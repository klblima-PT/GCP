# Importação das bibliotecas necessárias
import pendulum
import ast
from airflow import models
from airflow.contrib.operators.dataflow_operator import DataflowTemplateOperator
from airflow.operators.dummy import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from datetime import date, datetime, timedelta
from modules.LastDateModified import get_last_sequential as last_sequential
from modules.ReadProcessGCSFileOperator import ReadProcessGCSFileOperator
from modules.SecretManager import get_secret
from airflow.utils.task_group import TaskGroup
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.utils.trigger_rule import TriggerRule

# Definição de variáveis do ambiente a partir de um modelo do Airflow
environment_variables = models.Variable.get('environment_variables', deserialize_json=True)

# Variáveis extraídas do arquivo de variáveis de ambiente
PROJECT = environment_variables["project_id"]
SUBNETWORK = environment_variables["subnetwork"]
DRIVER_BUCKET = environment_variables["postgres_driver"]
STAGING_LOCATION = environment_variables["staging_location"]
BIGQUERY_TEMP_DIR = environment_variables["bigquery_temp_dir"]
TEMP_DIR = environment_variables["temp_dir"]

# Credenciais de acesso ao banco de dados, obtidas via o Secret Manager
USER_NAME = get_secret(PROJECT, 'eng-data-postgres_user_name', 1)
USER_PASS = get_secret(PROJECT, 'eng-data-postgres_password', 1)
USER_URL = 'jdbc:postgresql://10.23.0.8:5432/shipay'  # URL fixa para conexão

# Definição do dataset e extração das tabelas a serem processadas
DATASET = 'raw_shipay'
str_tables_list = models.Variable.get("postgres_tables_raw_shipay_daily")
tables_list = ast.literal_eval(str_tables_list)

# Função para preparar os dados e gerar grupos de tarefas para extração das últimas datas de modificação
def prepare_request_data():
    tg_last_date_list = []

    # Para cada tabela, cria um grupo de tarefas (TaskGroup)
    for table_info in tables_list:
        tg_group = create_taskgroup_last_date("extract", table_info)
        tg_last_date_list.append(tg_group)

    return tg_last_date_list

# Função que cria uma tarefa para executar uma consulta SQL no BigQuery
def _create_table(table, sql_name):
    return BigQueryInsertJobOperator(
        task_id=f"create_query_{table}_job",
        configuration={
            "query": {
                "query": f"{sql_name}",
                "useLegacySql": False,
            }
        },
        location="southamerica-east1",  # Região específica
)

# Funções que geram tarefas de extração de dados via Dataflow (carga para BigQuery)
def generate_dataflow_low_job(table, query, type_table):
    OUTPUT_TABLE = f'{PROJECT}:{DATASET}.{table}'
    extract = DataflowTemplateOperator(
        task_id='extract',
        job_name=f'postgres-public-raw-extract-{table}',  # Nome do job no Dataflow
        execution_timeout=timedelta(hours=2),
        location='southamerica-east1',  # Mesma região da sub-rede
        template='gs://dataflow-templates-southamerica-east1/latest/Jdbc_to_BigQuery',
        parameters={
            'driverJars': DRIVER_BUCKET,
            'driverClassName': 'org.postgresql.Driver',
            'bigQueryLoadingTemporaryDirectory': BIGQUERY_TEMP_DIR,
            'username': USER_NAME,
            'connectionURL': USER_URL,
            'query': query,
            'outputTable': OUTPUT_TABLE,
            'password': USER_PASS
        },
        environment={
            'numWorkers': 2,
            'subnetwork': SUBNETWORK,
            'maxWorkers': 4,
            'machineType': 'n1-standard-2',
            'tempLocation': TEMP_DIR
        }
    )
    return extract

def generate_dataflow_high_job(table, query, type_table):
    OUTPUT_TABLE = f'{PROJECT}:{DATASET}.{table}'
    extract = DataflowTemplateOperator(
        task_id='extract',
        job_name=f'postgres-public-raw-extract-{table}',  # Nome do job no Dataflow
        execution_timeout=timedelta(hours=5),
        location='southamerica-east1',  # Mesma região da sub-rede
        template='gs://dataflow-templates-southamerica-east1/latest/Jdbc_to_BigQuery',
        parameters={
            'driverJars': DRIVER_BUCKET,
            'driverClassName': 'org.postgresql.Driver',
            'bigQueryLoadingTemporaryDirectory': BIGQUERY_TEMP_DIR,
            'username': USER_NAME,
            'connectionURL': USER_URL,
            'query': query,
            'outputTable': OUTPUT_TABLE,
            'password': USER_PASS      
        },
        environment={
            'numWorkers': 2,
            'subnetwork': SUBNETWORK,
            'maxWorkers': 8,
            'machineType': 'n1-standard-2',
            'tempLocation': TEMP_DIR
        }
    )
    return extract

# Função para preparar as colunas da requisição e ler arquivos do GCS
def prepare_request_columns(table, data_type_exists):
    read_process_gcs_file = ReadProcessGCSFileOperator(
        task_id='read_process_gcs_file_table',
        gcs_file_path=f'southamerica-east1-cps-ship-eb7d71bd-bucket/dags/queries/postgres/raw/columns/{table}_columns.txt',
        table_name=table,
        data_type_exists=data_type_exists,
        dag=dag
    )
    return read_process_gcs_file

# Função que cria um grupo de tarefas (TaskGroup) para o processamento de uma tabela
def create_taskgroup_last_date(task_group_prefix, table_info):
    table = table_info['table']
    schema = table_info['schema']
    type_table = table_info['type']
    data_type_exists = table_info['data_type_exists']
    table_size = table_info['table_size']    

    with TaskGroup(group_id=f"{task_group_prefix}_{table}") as tg1:
        BQ_TABLE = f'{PROJECT}.{DATASET}.{table}'

        # Criação da tabela no BigQuery
        create_table = _create_table(
            table,
            f"queries/postgres/raw/ddl/ddl_raw_shipay_{table}.sql",
        )

        # Preparação dos dados das colunas
        prepare_request_columns_operator = prepare_request_columns(table, data_type_exists)

        # Caso tipo "delta" - dados anteriores a D-1
        if type_table == "delta":
            column_primary = table_info['column_primary']
            column_secondary = table_info['column_secondary']            

            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""

            query_1 = f"SELECT {colunas_xcom} FROM {schema}.{table} WHERE {column_primary} >= TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD')"
            query_2 = f"SELECT {colunas_xcom} FROM {schema}.{table} WHERE {column_primary} = TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD') OR {column_secondary} = TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD')"
            
            # Escolha do job baseado no tamanho da tabela
            if table_size == "small" and column_primary and not column_secondary:
                extract = generate_dataflow_low_job(table, query_1, type_table)
            elif table_size == "small" and column_primary and column_secondary:
                extract = generate_dataflow_low_job(table, query_2, type_table)
            elif table_size == "large" and column_primary and not column_secondary:
                extract = generate_dataflow_high_job(table, query_1, type_table)
            elif table_size == "large" and column_primary and column_secondary:
                extract = generate_dataflow_high_job(table, query_2, type_table)  

            create_table >> prepare_request_columns_operator >> extract
        
        # Caso tipo "delta_today" - dados até D-0
        elif type_table == "delta_today":
            column_primary = table_info['column_primary']

            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""

            query = f"SELECT {colunas_xcom} FROM {schema}.{table} WHERE TRUNC({column_primary}) >= TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD') AND TRUNC({column_primary}) <= TO_DATE('{{{{data_interval_end | ds}}}}', 'YYYY-MM-DD')"

            # Escolha do job baseado no tamanho da tabela
            if table_size == "small":
                extract = generate_dataflow_low_job(table, query, type_table)
            elif table_size == "large":
                extract = generate_dataflow_high_job(table, query, type_table)

            create_table >> prepare_request_columns_operator >> extract

        # Caso tipo "full" - carga completa com APPEND
        elif type_table == "full":
            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""
            
            query = f"SELECT {colunas_xcom} FROM {schema}.{table}"

            # Escolha do job baseado no tamanho da tabela
            if table_size == "small":
                extract = generate_dataflow_low_job(table, query, type_table)
            elif table_size == "large":
                extract = generate_dataflow_high_job(table, query, type_table)

            create_table >> prepare_request_columns_operator >> extract
            
        return tg1

# Definição de argumentos padrão do DAG
default_args = {
    'owner': 'Airflow',
    'start_date': pendulum.datetime(2024, 3, 11, tz='America/Sao_Paulo'),
    'email_on_failure': False,
    'email_on_retry': False,
    'dataflow_default_options': {
        'projetct': PROJECT,
        'zone': 'southamerica-east1-a',
        'stagingLocation': STAGING_LOCATION
    }
}

# Definição do DAG com as tarefas
with models.DAG(
    'raw_postgres_shipay_daily',
    default_args=default_args,
    schedule_interval='0 7 * * *',  # Agendamento diário às 07h00
    template_searchpath="/home/airflow/gcs/plugins/",
    catchup=False
) as dag:

    # Operadores Dummy para marcação de início e fim
    start = DummyOperator(task_id='start')
    end = DummyOperator(task_id='end')

    # Grupo de tarefas gerado pela função prepare_request_data
    tg_group = prepare_request_data()
    
    # Operador que dispara outro DAG ao final do processo
    trigger_trusted = TriggerDagRunOperator(task_id='trigger_trusted', trigger_dag_id='trusted_postgres_shipay_daily', dag=dag)

# Definindo dependências entre as tarefas
start >> tg_group >> end
trigger_trusted.set_upstream(end)
