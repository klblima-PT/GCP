
-- ** tbl_dbcorpapirisco_cnae  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.tbl_dbcorpapirisco_cnae` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
  sk_dbcorpapirisco_cnae ,
  cnaeid ,
  usuarioinclusaoid ,
  usuarioalteracaoid ,
  escalariscoid ,
  datahorainclusao ,
  datahoraalteracao ,
  status ,
  secao ,
  divisao ,
  grupo ,
  classe ,
  subclasse ,
  descricao ,
  datainiciovigenciactrl ,
  datafimvigenciactrl ,
  ativoctrl ,

      
      ROW_NUMBER() OVER(PARTITION BY CnaeId ORDER BY EscalaRiscoId  DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.TBL_Dbcorpapirisco_Cnae`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.CnaeId = raw.CnaeId  

WHEN MATCHED THEN UPDATE SET
  bronze.sk_dbcorpapirisco_cnae = raw.sk_dbcorpapirisco_cnae ,
  bronze.cnaeid = raw.cnaeid ,
  bronze.usuarioinclusaoid = raw.usuarioinclusaoid ,
  bronze.usuarioalteracaoid = raw.usuarioalteracaoid ,
  bronze.escalariscoid = raw.escalariscoid ,
  bronze.datahorainclusao = raw.datahorainclusao ,
  bronze.datahoraalteracao = raw.datahoraalteracao ,
  bronze.status = raw.status ,
  bronze.secao = raw.secao ,
  bronze.divisao = raw.divisao ,
  bronze.grupo = raw.grupo ,
  bronze.classe = raw.classe ,
  bronze.subclasse = raw.subclasse ,
  bronze.descricao = raw.descricao ,
  bronze.datainiciovigenciactrl = raw.datainiciovigenciactrl ,
  bronze.datafimvigenciactrl = raw.datafimvigenciactrl ,
  bronze.ativoctrl = raw.ativoctrl 

WHEN NOT MATCHED THEN INSERT (
sk_dbcorpapirisco_cnae ,
  cnaeid ,
  usuarioinclusaoid ,
  usuarioalteracaoid ,
  escalariscoid ,
  datahorainclusao ,
  datahoraalteracao ,
  status ,
  secao ,
  divisao ,
  grupo ,
  classe ,
  subclasse ,
  descricao ,
  datainiciovigenciactrl ,
  datafimvigenciactrl ,
  ativoctrl ,
  dt_carga_bronze
)
VALUES (
 raw.sk_dbcorpapirisco_cnae ,
  raw.cnaeid ,
  raw.usuarioinclusaoid ,
  raw.usuarioalteracaoid ,
  raw.escalariscoid ,
  raw.datahorainclusao ,
  raw.datahoraalteracao ,
  raw.status ,
  raw.secao ,
  raw.divisao ,
  raw.grupo ,
  raw.classe ,
  raw.subclasse ,
  raw.descricao ,
  raw.datainiciovigenciactrl ,
  raw.datafimvigenciactrl ,
  raw.ativoctrl ,
CURRENT_DATETIME('-03:00')
);
