from google.cloud import bigquery


def get_last_date_modified(**kwargs):
    project = kwargs['project']
    sql = kwargs['sql']

    client = bigquery.Client(project=project)

    df = client.query(sql).to_dataframe()

    return df.iloc[0,0]

def get_last_sequential(**kwargs):
    project = kwargs['project']
    sql = kwargs['sql']
    ti = kwargs['ti']
    table = kwargs['table']

    client = bigquery.Client(project=project)

    df = client.query(sql).to_dataframe()

    result = int(df.iloc[0,0])

    ti.xcom_push(key=f'get_last_sequential_{table}', value=result)

    return result
