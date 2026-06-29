import pendulum
import ast
from datetime import date, datetime, timedelta

from airflow import models
from airflow import DAG
from airflow.models import Variable

# operators
from airflow.operators.dummy import DummyOperator
from airflow.providers.google.cloud.operators.bigquery import BigQueryInsertJobOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.trigger_dagrun import TriggerDagRunOperator
from modules.LastDateModified import get_last_sequential as last_sequential
from airflow.utils.task_group import TaskGroup
from airflow.sensors.external_task_sensor import ExternalTaskSensor
from airflow.models import DagRun
from airflow.utils.trigger_rule import TriggerRule


##Variaveis
environment_variables = models.Variable.get('environment_variables', deserialize_json=True)
str_tables_list = models.Variable.get("postgres_tables_trusted_shipay_daily")
tables_list = ast.literal_eval(str_tables_list)
PROJECT = environment_variables["project_id"]
STAGING_LOCATION = environment_variables["staging_location"]
BIGQUERY_TEMP_DIR = environment_variables["bigquery_temp_dir"]
DATASET = 'trusted_shipay'


##FUNCOES

def prepare_request_data():
    tg_last_date_list = []


    for table_info in tables_list:
        tg_group = create_taskgroup("query_group", table_info)
        tg_last_date_list.append(tg_group)

    return tg_last_date_list
    
    
def _create_table(table, sql_name):
    
    return BigQueryInsertJobOperator(
        task_id=f"create_table_{table}_job",
        configuration={
            "query": {
                "query": f"{sql_name}",
                "useLegacySql": False,
            }
        },
        location="us",
    )


def _populate_table(table, sql_name):

    return BigQueryInsertJobOperator(
        task_id=f"populate_query_{table}_job",
        configuration={
            "query": {
                "query": f"{sql_name}",
                "useLegacySql": False,
            }
        },
        location="us",
    )

def create_taskgroup(task_group_prefix, table_info):
    table = table_info['table']
     
    with TaskGroup(group_id=f"{task_group_prefix}_{table}") as tg1:

        create_table = _create_table(
            table, f"queries/trusted/ddl/ddl_trusted_shipay_{table}.sql"
        )
        populate_table = _populate_table(
            table, f"queries/trusted/dml/dml_trusted_shipay_{table}.sql"
        )

        create_table >> populate_table
        return tg1
        
        

default_args = {
    'owner':'Airflow - HVAR',
    'start_date': pendulum.datetime(2024, 4, 1, tz='America/Sao_Paulo'),
    #'schedule_interval':None,              
    'email_on_failure':False,
    'email_on_retry':False,
    'retries':0,
    'retry_delay': timedelta(minutes=5)
}

with models.DAG(
    'bronze_bi_rendimento',
    default_args=default_args,
    schedule_interval='0 6 * * 0-5',
    template_searchpath="/home/airflow/gcs/plugins/",
    catchup=False,
    max_active_runs=3, concurrency=4 
    ) as dag:

    start = DummyOperator(task_id="start", dag=dag)

    tg_group = prepare_request_data()

    end = DummyOperator(task_id="end", dag=dag)

    ##trigger_silver = TriggerDagRunOperator (task_id='trigger_silver',trigger_dag_id = 'silver_default_step_1', dag=dag)
    
    start >> tg_group >> end 
    ##trigger_silver.set_upstream(end)
