# productivity libs
import pendulum
from datetime import datetime, timedelta
import yaml
import os

# airflow libs
from airflow.models.dag import DAG
from airflow.operators.dummy import DummyOperator
from airflow.operators.python_operator import PythonOperator

# from airflow.operators.trigger_dagrun import TriggerDagRunOperator

from airflow.contrib.operators.dataflow_operator \
    import DataflowTemplateOperator

from airflow.utils.task_group import TaskGroup
from airflow.providers.google.cloud.operators.bigquery \
    import BigQueryInsertJobOperator

# modules libs
from modules.LastDateModified import get_last_sequential as last_sequential
from modules.ReadProcessGCSFileOperator import ReadProcessGCSFileOperator
from modules.SecretManager import get_secret

# common libs
from common.config.owners import Owners


# Load YAML file
def load_configurations():
    # Read YAML file
    file_path = os.path.join(
        os.path.dirname(os.path.abspath(__file__)),
        "config.yaml"
    )

    with open(file_path, "r") as f:
        dag_configs = yaml.safe_load(f)
        return dag_configs


# functions
def prepare_request_data(id, **dag_config):

    task_group_prefix = 'extract'

    tg_last_date_list = []

    DATASET = id

    layer = dag_config.get('layer')

    executions = dag_config.get('executions')

    environment_variables = dag_config.get('environment_variables')

    for execution in executions:

        table_size = execution.get('table_size')
        schema = execution.get('schema')
        type = execution.get('type')
        data_type_exists = execution.get('data_type_exists')
        tables = execution.get('tables')

        for table in tables:
            tg_group = create_taskgroup_last_date(
                task_group_prefix,
                DATASET,
                layer,
                table_size,
                schema,
                type,
                data_type_exists,
                table,
                environment_variables
            )

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


# Dataflow job to run small tables - Low computacional power
def generate_dataflow_low_job(
        task_group_prefix,
        DATASET,
        table,
        query,
        environment_variables
):

    PROJECT = environment_variables.get('project_id')
    DRIVER_BUCKET = environment_variables.get('oracle_driver')
    TEMP_DIR = environment_variables.get('temp_dir')
    BIGQUERY_TEMP_DIR = environment_variables.get('bigquery_temp_dir')
    SUBNETWORK = environment_variables.get('subnetwork')

    CREDENTIALS = get_secret(PROJECT, DATASET, 1)
    USER_NAME = CREDENTIALS.get("user_name")
    USER_PASS = CREDENTIALS.get("password")
    USER_URL = CREDENTIALS.get("url")

    OUTPUT_TABLE = f'{PROJECT}:{DATASET}.{table}'
    extract = DataflowTemplateOperator(
        task_id=f'{task_group_prefix}',
        job_name=f'{DATASET}-{task_group_prefix}-{table}',  # Dataflow Job Name
        execution_timeout=timedelta(hours=1),
        location='southamerica-east1',  # same region from subnet
        template='gs://dataflow-templates-southamerica-east1' +
        '/latest/Jdbc_to_BigQuery',

        parameters={
            'driverJars': DRIVER_BUCKET,
            # 'KMSEncryptionKey':KMS_KEY,
            'driverClassName': 'oracle.jdbc.driver.OracleDriver',
            'connectionProperties': 'oracle.jdbc.timezoneAsRegion=false',
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
            'machineType': 'n1-standard-4',
            'tempLocation': TEMP_DIR
            }
        )

    return extract


# Dataflow job to run large tables - High computacional power
def generate_dataflow_high_job(
        task_group_prefix,
        DATASET,
        table,
        query,
        environment_variables
):

    PROJECT = environment_variables.get('project_id')
    DRIVER_BUCKET = environment_variables.get('oracle_driver')
    TEMP_DIR = environment_variables.get('temp_dir')
    BIGQUERY_TEMP_DIR = environment_variables.get('bigquery_temp_dir')
    SUBNETWORK = environment_variables.get('subnetwork')

    CREDENTIALS = get_secret(PROJECT, DATASET, 1)
    USER_NAME = CREDENTIALS.get("user_name")
    USER_PASS = CREDENTIALS.get("password")
    USER_URL = CREDENTIALS.get("url")

    OUTPUT_TABLE = f'{PROJECT}:{DATASET}.{table}'
    extract = DataflowTemplateOperator(
        task_id=f'{task_group_prefix}',
        job_name=f'{DATASET}-{task_group_prefix}-{table}',  # Dataflow Job Name
        execution_timeout=timedelta(hours=1),
        location='southamerica-east1',  # same region from subnet
        template='gs://dataflow-templates-southamerica-east1' +
        '/latest/Jdbc_to_BigQuery',

        parameters={
            'driverJars': DRIVER_BUCKET,
            # 'KMSEncryptionKey':KMS_KEY,
            'driverClassName': 'oracle.jdbc.driver.OracleDriver',
            'connectionProperties': 'oracle.jdbc.timezoneAsRegion=false',
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
            'machineType': 'n1-standard-8',
            'tempLocation': TEMP_DIR
            }
        )

    return extract


def dataflow_machine_type(
        task_group_prefix,
        DATASET,
        table,
        query,
        environment_variables,
        table_size: str
):

    if table_size == "small":
        extract = generate_dataflow_low_job(
            task_group_prefix,
            DATASET,
            table,
            query,
            environment_variables
        )

    elif table_size == "large":
        extract = generate_dataflow_high_job(
            task_group_prefix,
            DATASET,
            table,
            query,
            environment_variables
        )

    else:
        extract = generate_dataflow_high_job(
            task_group_prefix,
            DATASET,
            table,
            query,
            environment_variables
        )

    print(f"""
Executing Dataflow table {table} -- Recommended to {table_size} table size.
""")

    return extract


def prepare_request_columns(DATASET, table, data_type_exists):

    read_process_gcs_file = ReadProcessGCSFileOperator(
            task_id='read_process_gcs_file_table',
            gcs_file_path='southamerica-east1-unimed-c-5e4fb72b-bucket' +
            f'/plugins/helpers/{DATASET}/{table}_columns.txt',

            table_name=table,
            data_type_exists=data_type_exists,
            dag=DAG
            )

    return read_process_gcs_file


def create_taskgroup_last_date(
        task_group_prefix,
        DATASET,
        layer,
        table_size,
        schema,
        type,
        data_type_exists,
        table,
        environment_variables
):

    PROJECT = environment_variables.get('project_id')

    with TaskGroup(group_id=f"{task_group_prefix}_{table}") as tg1:
        BQ_TABLE = f'{PROJECT}.{DATASET}.{table}'

        create_table = _create_table(
            table,
            f"queries/{DATASET}/ddl_{layer}_{table}.sql",
        )

        prepare_request_columns_operator = prepare_request_columns(
            DATASET,
            table,
            data_type_exists
        )

# Truncate table and recharge full load table
        if type == "truncate":

            truncate = BigQueryInsertJobOperator(
                task_id=f"truncate_{table}",
                configuration={
                    "query": {
                        "query": f"TRUNCATE TABLE {BQ_TABLE}",
                        "useLegacySql": False,
                        "priority": "BATCH",
                    }
                },
                location="southamerica-east1"
            )

            xcom_key = f'{table}_gcs_file_rows'

            columns_xcom = f"""
            {{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}
            """

            query = f"""
            SELECT
                {columns_xcom}
            FROM
                {schema}.{table}
            """

            extract = dataflow_machine_type(
                task_group_prefix,
                DATASET,
                table,
                query,
                environment_variables,
                table_size
            )

            # DAG flow
            (
                create_table
                >> truncate
                >> prepare_request_columns_operator
                >> extract
            )


# delta = D-1, do not include data load of the day
        elif type == "delta":

            column = table['column']

            xcom_key = f'{table}_gcs_file_rows'

            columns_xcom = f"""
            {{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}
            """

            query = f"""
            SELECT
                {columns_xcom}
            FROM
                {schema}.{table}
            WHERE
                TRUNC({column}) = TO_DATE('{{{{ds}}}}', 'YYYY-MM-DD')
            """

            extract = dataflow_machine_type(
                task_group_prefix,
                DATASET,
                table,
                query,
                environment_variables,
                table_size
            )

            # DAG flow
            (
                create_table
                >> prepare_request_columns_operator
                >> extract
            )


# delta_today >= D-1, include data load of the day
        elif type == "delta_today":

            column = table['column']

            xcom_key = f'{table}_gcs_file_rows'

            columns_xcom = f"""
            {{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}
            """

            query = f"""
            SELECT
                {columns_xcom}
            FROM
                {schema}.{table}
            WHERE
                TRUNC({column}) >= TO_DATE(
                    '{{{{ds}}}}',
                    'YYYY-MM-DD'
                ) AND

                TRUNC({column}) <= TO_DATE(
                    '{{{{data_interval_end | ds}}}}',
                    'YYYY-MM-DD'
                )
            """

            extract = dataflow_machine_type(
                task_group_prefix,
                DATASET,
                table,
                query,
                environment_variables,
                table_size
            )

            # DAG flow
            (
                create_table
                >> prepare_request_columns_operator
                >> extract
            )

# based on countable field to bring registers (auto incremental data)
        elif type == "sequential":

            column = table['column']  # table_info

            DELTA_SQL = f"""
            SELECT
                MAX(CAST({column}  AS INT64))
            FROM
                `{BQ_TABLE}`
            """

            get_last_sequential_modified = PythonOperator(
                task_id='get_last_sequential_modified',
                python_callable=last_sequential,
                op_kwargs={
                    'project': PROJECT,
                    'sql': DELTA_SQL,
                    'table': table
                },
                provide_context=True
            )

            xcom_key = f'{table}_gcs_file_rows'

            columns_xcom = f"""
            {{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}
            """

            query = f"""
            SELECT
                {columns_xcom}
            FROM
                {schema}.{table}
            WHERE
                {column} >= {{{{
                    task_instance.xcom_pull(
                        key='get_last_sequential_{table}'
                    )
                }}}}
            """

            extract = dataflow_machine_type(
                task_group_prefix,
                DATASET,
                table,
                query,
                environment_variables,
                table_size
            )

            # DAG flow
            (
                create_table
                >> get_last_sequential_modified
                >> prepare_request_columns_operator
                >> extract
            )

# Charge Full load table from source (APPEND data)
        elif type == "full":

            xcom_key = f'{table}_gcs_file_rows'

            columns_xcom = f"""
            {{{{ task_instance.xcom_pull(key='{xcom_key}') }}}}
            """

            query = f"""
            SELECT
                {columns_xcom}
            FROM
                {schema}.{table}
            """

            extract = dataflow_machine_type(
                task_group_prefix,
                DATASET,
                table,
                query,
                environment_variables,
                table_size
            )

            # DAG flow
            (
                create_table
                >> prepare_request_columns_operator
                >> extract
            )

        return tg1


default_args = {
    'owner': Owners.DATA_ENGINEERING.value,
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 2,
    'retry_delay': timedelta(minutes=5)
}


# Dynamic generate DAGS
def create_dag(id, dag_config: dict):

    environment_variables = dag_config.get('environment_variables')
    start_date = datetime.fromisoformat(dag_config.get('start_date'))

    year = int(start_date.year)
    month = int(start_date.month)
    day = int(start_date.day)

    PROJECT = environment_variables.get('project_id')
    STAGING_LOCATION = environment_variables.get('staging_location')

    with DAG(
        dag_id=id,
        start_date=pendulum.datetime(year, month, day, tz='America/Sao_Paulo'),
        default_args=default_args,
        schedule_interval=None,
        template_searchpath="/home/airflow/gcs/plugins/",
        dataflow_default_options={
            'project': PROJECT,
            'zone': 'southamerica-east1-a',
            'stagingLocation': STAGING_LOCATION
        },
        catchup=False
    ) as dag:

        start = DummyOperator(task_id='start')

        tg_group = prepare_request_data(id, **dag_config)

        end = DummyOperator(task_id='end')

    (
        start
        >> tg_group
        >> end
    )

    return dag


# Generate DAGS for configurations
configurations = load_configurations()
for id, dag_config in configurations.items():
    globals()[id] = create_dag(id, dag_config)
