from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.transfers.bigquery_to_gcs import BigQueryToGCSOperator
from airflow.providers.google.suite.transfers.gcs_to_sheets import GCSToGoogleSheetsOperator
from airflow.models import Variable
from datetime import date

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

# Load the list of tables and their corresponding folders from Airflow variables
tables_list = Variable.get("bigquery_tables_list", deserialize_json=True)
spreadsheet_id = Variable.get("spreadsheet_id")  # Load SPREADSHEET_ID from Airflow variables
today = date.today()

# Define the DAG
with DAG(
    dag_id='bigquery_extract_with_variable_tables_and_folders_dag1',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
) as dag:

    for item in tables_list:
        table = item['table']
        folder = item['folder']
        table_name = table.split('.')[-1]  # Extract table name for use in file naming

        # Task to export BigQuery table to GCS
        extract_task = BigQueryToGCSOperator(
            task_id=f'extract_{table_name}',
            source_project_dataset_table=table,
            destination_cloud_storage_uris=[f'gs://bucket-dados/relatorios-bi/{folder}/{table_name}.csv'],
            export_format='csv',
            field_delimiter=';',
            print_header=True,
            gcp_conn_id='google_cloud_default',
        )

        # Task to load CSV from GCS to Google Sheets
        update_sheets_task = GCSToGoogleSheetsOperator(
            task_id=f'update_sheets_{table_name}',
            spreadsheet_id=spreadsheet_id,
            gcs_bucket='bucket-dados',
            gcs_object=f'relatorios-bi/{folder}/{table_name}.csv',
            gcp_conn_id='google_cloud_default',
        )

        # Ensure the Google Sheets update happens after the CSV is exported
        extract_task >> update_sheets_task
