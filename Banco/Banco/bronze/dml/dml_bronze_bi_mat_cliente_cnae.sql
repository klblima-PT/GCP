
-- ** mat_clientecnae  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.mat_clientecnae` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
 documento ,
 sessao ,
 sessao_desc ,
 codcnae , 
 cnae_desc ,
 tipocod ,

      
      ROW_NUMBER() OVER(PARTITION BY Documento ORDER BY CodCnae  DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.MAT_ClienteCnae`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.Documento = raw.Documento  

WHEN MATCHED THEN UPDATE SET
bronze.documento          = raw.documento ,
bronze.sessao	            = raw.sessao,
bronze.sessao_desc		    = raw.sessao_desc,
bronze.codcnae   	        = raw.codcnae,
bronze.cnae_desc	        = raw.cnae_desc,
bronze.tipocod            = raw.tipocod 


WHEN NOT MATCHED THEN INSERT (
documento ,
 sessao ,
 sessao_desc ,
 codcnae , 
 cnae_desc ,
 tipocod ,
dt_carga_bronze
)
VALUES (
 raw.documento ,
 raw.sessao ,
 raw.sessao_desc ,
 raw.codcnae , 
 raw.cnae_desc ,
 raw.tipocod ,
CURRENT_DATETIME('-03:00')
);
