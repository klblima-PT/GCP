
-- ** dbo_clientes  **
-- DEVELOPED BY Kleber CONSULTING | DataOps team

CREATE TABLE IF NOT EXISTS `bronze_sqlserver_ab_infobanc.dbo_clientes` (
    codcliente STRING,
    cgc_cpf STRING,
    sequencia STRING,
    nome STRING,
    tipopessoa STRING,
    codcategoria STRING,
    tipotributacao STRING,
    codatividade STRING,
    codgerente STRING,
    status STRING,
    datacadastro DATETIME,
    dataatualizacao DATETIME,
    ind_factoring STRING,
    clientehomebank STRING,
    ind_tributacpmf STRING,
    datavencimento DATETIME,
    nomeusuario STRING,
    numdocumento STRING,
    tipodocumento STRING,
    orgaoexpedidor STRING,
    uf_orgaoexpedidor STRING,
    datadocumento DATETIME,
    regimetributacao STRING,
    datarenovacao DATETIME,
    origemcadastro STRING,
    indinvestinstit STRING,
    indisentoiof STRING,
    codgerenteant STRING,
    codfirma STRING,
    codglobal STRING,
    indautbank STRING,
    codcoligada STRING,
    codagencia STRING,
    codccusto STRING,
    codclassif_gerencial STRING,
    mesclientedesde STRING,
    anoclientedesde STRING,
    obsclientedesde STRING,
    datadesativacao DATETIME,
    codarea STRING,
    codsetor_atividade STRING,
    cp_acc STRING,
    cp_sec STRING,
    intragrupo STRING,
    dataatualizacaogerente DATETIME,
    motivoalteracaogerente STRING,
    codclassif_administrativa STRING,
    clienteproblematico STRING,
    codmotivoproblematico STRING,
    codbasileia STRING,
    id_ponto_atendimento NUMERIC,

    -- TABLE CREATED TO BIGQUERY TREATMENT
    dt_carga_raw TIMESTAMP,
    dt_carga_bronze TIMESTAMP,

PRIMARY KEY
    (codcliente) NOT ENFORCED--,
--
--FOREIGN KEY
--  (cgc_cpf, sequencia, codcategoria, codatividade, codgerente, cp_acc, cp_sec) REFERENCES ... NOT ENFORCED
)

PARTITION BY
    TIMESTAMP_TRUNC(dt_carga_bronze, DAY)

CLUSTER BY
    dataatualizacao

OPTIONS (
DESCRIPTION = 'Table DBO_CLIENTES clustered by dataatualizacao.'
); 
