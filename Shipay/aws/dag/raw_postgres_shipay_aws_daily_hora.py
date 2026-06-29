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


##Variaveis

environment_variables = models.Variable.get('environment_variables', deserialize_json=True)

PROJECT = environment_variables["project_id"]
SUBNETWORK = environment_variables["subnetwork"]
DRIVER_BUCKET = environment_variables["postgres_driver"]
STAGING_LOCATION = environment_variables["staging_location"]
BIGQUERY_TEMP_DIR = environment_variables["bigquery_temp_dir"]
TEMP_DIR = environment_variables["temp_dir"]
#KMS_KEY = environment_variables["KMSkey"]

USER_NAME = get_secret(PROJECT, 'eng-data-postgres-aws_user_name', 1)
USER_PASS = get_secret(PROJECT, 'eng-data-postgres-aws_password', 1)
##USER_URL = get_secret(PROJECT, 'eng-data-postgres-aws_url', 1)

#USER_NAME = 'shipay_bigquery'
#USER_PASS = 'alMLkhA4gApgjr643wEu'
USER_URL = 'jdbc:postgresql://172.16.145.211/shipay'

DATASET = 'raw_shipay_aws'
str_tables_list = models.Variable.get("postgres_tables_raw_shipay_daily")
tables_list = ast.literal_eval(str_tables_list)



def prepare_request_data():
    tg_last_date_list = []


    for table_info in tables_list:
        tg_group = create_taskgroup_last_date("extract", table_info)
        tg_last_date_list.append(tg_group)

    return tg_last_date_list

def _create_table(table, sql_name):
    
    return BigQueryInsertJobOperator(
        task_id=f"create_query_{table}_job",
        configuration={
            "query": {
                "query": f"{sql_name}",
                "useLegacySql": False,
            }
        },
        location="southamerica-east1",
)
    
def generate_dataflow_low_job(table, query, type_table):
    OUTPUT_TABLE = f'{PROJECT}:{DATASET}.{table}'
    extract = DataflowTemplateOperator(
        task_id='extract',
        job_name=f'postgres-public-raw-extract-{table}',  # Dataflow Job Name
        ##pool = "raw_postgres_public",
        execution_timeout=timedelta(hours=2),
        location='southamerica-east1',  # Deve ser o mesmo que a sub rede
        template='gs://dataflow-templates-southamerica-east1/latest/Jdbc_to_BigQuery',
        parameters={
            'driverJars':DRIVER_BUCKET,
            'driverClassName':'org.postgresql.Driver',
            'bigQueryLoadingTemporaryDirectory':BIGQUERY_TEMP_DIR,
            'username':USER_NAME,
            'connectionURL':USER_URL,
            'query':query,
            'outputTable':OUTPUT_TABLE,
            'password':USER_PASS
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
        job_name=f'postgres-public-raw-extract-{table}',  # Dataflow Job Name
        ##pool = "raw_postgres_public",        
        execution_timeout=timedelta(hours=5),
        location='southamerica-east1',  # Deve ser o mesmo que a sub rede
        template='gs://dataflow-templates-southamerica-east1/latest/Jdbc_to_BigQuery',
        parameters={
            'driverJars':DRIVER_BUCKET,
            'driverClassName':'org.postgresql.Driver',
            'bigQueryLoadingTemporaryDirectory':BIGQUERY_TEMP_DIR,
            'username':USER_NAME,
            'connectionURL':USER_URL,
            'query':query,
            'outputTable':OUTPUT_TABLE,
            'password':USER_PASS      
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


def prepare_request_columns(table, data_type_exists):

    read_process_gcs_file = ReadProcessGCSFileOperator(
            task_id='read_process_gcs_file_table',
            gcs_file_path=f'southamerica-east1-cps-ship-eb7d71bd-bucket/dags/queries/aws/raw/columns/{table}_columns.txt',
            table_name=table,
            data_type_exists=data_type_exists,
            dag=dag
            )
    
    return read_process_gcs_file


def create_taskgroup_last_date(task_group_prefix, table_info):
    table = table_info['table']
    schema = table_info['schema']
    type_table = table_info['type']
    data_type_exists = table_info['data_type_exists']
    table_size = table_info['table_size']    

    with TaskGroup(group_id=f"{task_group_prefix}_{table}") as tg1:
        BQ_TABLE = f'{PROJECT}.{DATASET}.{table}'

        create_table = _create_table(
            table,
            f"queries/aws/raw/ddl/ddl_raw_shipay_aws_{table}.sql",
        )

        prepare_request_columns_operator = prepare_request_columns(table, data_type_exists)

        #delta = D-1, NÃƒÆ’O contempla os dados do dia da carga
        if type_table == "delta":
            column_primary = table_info['column_primary']
            column_secondary = table_info['column_secondary']            

            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""

            query_1 = f"SELECT {colunas_xcom} FROM {schema}.{table} WHERE {column_primary} >= TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD')"
            query_2 = f"SELECT {colunas_xcom} FROM {schema}.{table} WHERE {column_primary} = TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD') OR {column_secondary} = TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD')"
            

            if table_size == "small" and column_primary and not column_secondary:
                extract = generate_dataflow_low_job(table, query_1, type_table)
            elif table_size == "small" and column_primary and column_secondary:
                extract = generate_dataflow_low_job(table, query_2, type_table)
            elif table_size == "large" and column_primary and not column_secondary:
                extract = generate_dataflow_high_job(table, query_1, type_table) 
            elif table_size == "large" and column_primary and column_secondary:
                extract = generate_dataflow_high_job(table, query_2, type_table)  

            create_table  >> prepare_request_columns_operator >> extract
        
        
        #delta_today >= D-1, contempla os dados do dia da carga
        elif type_table == "delta_today":
            column_primary = table_info['column_primary']

            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""

            query = f"SELECT {colunas_xcom} FROM {schema}.{table} WHERE TRUNC({column_primary}) >= TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD') AND TRUNC({column_primary}) <= TO_DATE('{{{{data_interval_end | ds}}}}', 'YYYY-MM-DD')"

            if table_size == "small":
                extract = generate_dataflow_low_job(table, query, type_table)
            elif table_size == "large":
                extract = generate_dataflow_high_job(table, query, type_table)

            create_table  >> prepare_request_columns_operator >> extract


        # Full >= Carga full com APPEND    
        elif type_table == "full":
            
            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""
            
            query = f"SELECT {colunas_xcom} FROM {schema}.{table}"

            if table_size == "small":
                extract = generate_dataflow_low_job(table, query, type_table)
            elif table_size == "large":
                extract = generate_dataflow_high_job(table, query, type_table)

            create_table  >> prepare_request_columns_operator >> extract
             # Caso tipo "delta_hora" - dados do dia atual e da última hora
        elif type_table == "delta_hora":
            column_primary = table_info['column_primary']

            xcom_key = f'{table}_gcs_file_rows'
            colunas_xcom = f"""{{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}"""

            query = f"""
                    SELECT {colunas_xcom} 
                    FROM {schema}.{table} 
                    WHERE TRUNC({column_primary}) = TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD') 
                    AND {column_primary} >= TO_TIMESTAMP('{{{{data_interval_end | ds}}}}', 'YYYY-MM-DD HH24:MI') - INTERVAL '1 HOUR'
                    """

    # Escolha do job baseado no tamanho da tabela
        if table_size == "small":
            extract = generate_dataflow_low_job(table, query, type_table)
        elif table_size == "large":
            extract = generate_dataflow_high_job(table, query, type_table)
            
        return tg1


default_args = {
    'owner':'Airflow',
    'start_date': pendulum.datetime(2024, 3, 11, tz='America/Sao_Paulo'),
    'email_on_failure':False,
    'email_on_retry':False,
    ##'retries':2,
    ##'retry_delay': timedelta(minutes=5),
    'dataflow_default_options':{
        'projetct':PROJECT,
        'zone':'southamerica-east1-a',
        'stagingLocation':STAGING_LOCATION
    }
}

with models.DAG(
    'raw_postgres_shipay_aws_daily_hora',
    default_args=default_args,
    schedule_interval='0 7 * * *',
    template_searchpath="/home/airflow/gcs/plugins/",
    catchup=False
    ) as dag:

    start = DummyOperator(task_id='start')
    end = DummyOperator(task_id='end')

    tg_group = prepare_request_data()
    
    trigger_trusted_aws = TriggerDagRunOperator (task_id='trigger_trusted_aws',trigger_dag_id = 'trusted_postgres_shipay_aws_daily', dag=dag)

start >> tg_group  >> end
trigger_trusted_aws.set_upstream(end)