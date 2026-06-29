
-- ** tbl_dbcorpapirisco_escalarisco  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.tbl_dbcorpapirisco_escalarisco` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
sk_dbcorpapirisco_escalarisco ,
  escalariscoid ,
  valor ,
  usuarioinclusaoid ,
  usuarioalteracaoid ,
  datahorainclusao ,
  datahoraalteracao ,
  status ,
  descricao ,
  datainiciovigenciactrl ,
  datafimvigenciactrl ,
  ativoctrl ,

      ROW_NUMBER() OVER(PARTITION BY EscalaRiscoId ORDER BY DataHoraAlteracao  DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.TBL_Dbcorpapirisco_EscalaRisco`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.EscalaRiscoId = raw.EscalaRiscoId  

WHEN MATCHED THEN UPDATE SET
  bronze.sk_dbcorpapirisco_escalarisco 	=	   raw.sk_dbcorpapirisco_escalarisco ,		
  bronze.escalariscoid                  =    raw.escalariscoid ,
  bronze.valor                          =    raw.valor ,
  bronze.usuarioinclusaoid              =    raw.usuarioinclusaoid ,
  bronze.usuarioalteracaoid             =    raw.usuarioalteracaoid ,
  bronze.datahorainclusao               =    raw.datahorainclusao ,
  bronze.datahoraalteracao              =    raw.datahoraalteracao ,
  bronze.status                         =    raw.status ,
  bronze.descricao                      =    raw.descricao ,
  bronze.datainiciovigenciactrl         =    raw.datainiciovigenciactrl ,
  bronze.datafimvigenciactrl            =    raw.datafimvigenciactrl ,
  bronze.ativoctrl                      =    raw.ativoctrl 

WHEN NOT MATCHED THEN INSERT (
sk_dbcorpapirisco_escalarisco ,
  escalariscoid ,
  valor ,
  usuarioinclusaoid ,
  usuarioalteracaoid ,
  datahorainclusao ,
  datahoraalteracao ,
  status ,
  descricao ,
  datainiciovigenciactrl ,
  datafimvigenciactrl ,
  ativoctrl ,
  dt_carga_bronze
)
VALUES (
raw.sk_dbcorpapirisco_escalarisco ,
  raw.escalariscoid ,
  raw.valor ,
  raw.usuarioinclusaoid ,
  raw.usuarioalteracaoid ,
  raw.datahorainclusao ,
  raw.datahoraalteracao ,
  raw.status ,
  raw.descricao ,
  raw.datainiciovigenciactrl ,
  raw.datafimvigenciactrl ,
  raw.ativoctrl ,
CURRENT_DATETIME('-03:00')
);
