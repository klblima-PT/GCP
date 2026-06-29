from airflow.models import BaseOperator
from airflow.utils.decorators import apply_defaults
from google.cloud import storage

class ReadProcessGCSFileOperator(BaseOperator):
    template_fields = ('gcs_file_path',)

    @apply_defaults
    def __init__(
        self,
        gcs_file_path,
        table_name,
        data_type_exists,
        *args, **kwargs
    ):
        super().__init__(*args, **kwargs)
        self.gcs_file_path = gcs_file_path
        self.table_name = table_name
        self.data_type_exists = data_type_exists

    def execute(self, context):
        
        if self.data_type_exists == False:
 
            # Salvar os resultados em XCom com um nome dinâmico com base no nome da tabela
            xcom_key = f'{self.table_name}_gcs_file_rows'
            
            context['ti'].xcom_push(key=xcom_key, value="*")
            return "*"


        # Inicialize o cliente GCS
        storage_client = storage.Client()

        # Recupere o conteúdo do arquivo GCS
        bucket_name, blob_name = self.gcs_file_path.split('/', 1)
        bucket = storage_client.get_bucket(bucket_name)
        blob = bucket.blob(blob_name)
        file_content = blob.download_as_text()

        # Processar o conteúdo do arquivo
        # Neste exemplo, estamos dividindo o conteúdo por vírgulas
        # e criando um dicionário de colunas e valores
        rows = ""
        for line in file_content.split('\n'):
            
            rows += " \n"+ line

        # Salvar os resultados em XCom com um nome dinâmico com base no nome da tabela
        xcom_key = f'{self.table_name}_gcs_file_rows'
        
        context['ti'].xcom_push(key=xcom_key, value=rows.replace(" \n", " "))
