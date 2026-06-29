from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.google.cloud.transfers.bigquery_to_gcs import BigQueryToGCSOperator
from airflow.operators.python_operator import PythonOperator
from airflow.models import Variable
from datetime import date
import os
from googleapiclient.discovery import build
from google.oauth2.service_account import Credentials

# Default arguments for the DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
}

# Load the list of tables and their corresponding folders from Airflow variables
tables_list = Variable.get("bigquery_tables_list", deserialize_json=True)
SPREADSHEET_FOLDER_ID = '1XFLtiXXPxEIcuBqOqMpwKW_cR4rMUVh6'  # Google Drive folder ID
SERVICE_ACCOUNT_FILE = '/path/to/your/service-account-key.json'

# Function to upload the file to Google Drive
def move_file_to_drive(bucket_name, folder, table_name):
    from airflow.providers.google.cloud.hooks.gcs import GCSHook
    gcs_hook = GCSHook(gcp_conn_id='google_cloud_default')

    # Authenticate with Google Drive API
    SCOPES = ['https://www.googleapis.com/auth/drive']
    creds = Credentials.from_service_account_file(SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    drive_service = build('drive', 'v3', credentials=creds)

    # Define file paths
    local_file_path = f'/tmp/{table_name}.csv'
    gcs_file_path = f'relatorios-bi/{folder}/{table_name}.csv'

    # Download the file from GCS
    gcs_hook.download(bucket_name, gcs_file_path, local_file_path)

    # Upload the file to Google Drive
    file_metadata = {
        'name': f'{table_name}.csv',  # File name in Google Drive
        'parents': [SPREADSHEET_FOLDER_ID],  # ID of the destination folder
    }
    media = MediaFileUpload(local_file_path, mimetype='text/csv')
    drive_service.files().create(body=file_metadata, media_body=media, fields='id').execute()

    # Clean up local file
    os.remove(local_file_path)

# Define the DAG
with DAG(
    dag_id='bigquery_to_gcs_and_google_drive',
    default_args=default_args,
    schedule_interval="10 9,17,18 * * *",
    catchup=False,
) as dag:

    for item in tables_list:
        table = item['table']
        folder = item['folder']
        table_name = table.split('.')[-1]  # Extract table name for use in file naming
        bucket_name = 'bucket-dados'

        # Task to extract CSV from BigQuery to GCS
        extract_task = BigQueryToGCSOperator(
            task_id=f'extract_{table_name}',
            source_project_dataset_table=table,
            destination_cloud_storage_uris=[f'gs://{bucket_name}/relatorios-bi/{folder}/{table_name}.csv'],
            export_format='csv',
            field_delimiter=';',
            print_header=True,
            gcp_conn_id='google_cloud_default',
        )
       
        # Task to move the file to Google Drive
        move_task = PythonOperator(
            task_id=f'move_{table_name}_to_drive',
            python_callable=move_file_to_drive,
            op_kwargs={
                'bucket_name': bucket_name,
                'folder': folder,
                'table_name': table_name,
            },
        )
       
        # Set task dependencies
        extract_task >> move_task