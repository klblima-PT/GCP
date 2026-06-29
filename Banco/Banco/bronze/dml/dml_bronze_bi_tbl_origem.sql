
-- ** tbl_origem  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.tbl_origem` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
  tbl_bigquery ,
  tbl_dm ,
  tbl_origem ,
  servidor_origem,	
      
      ROW_NUMBER() OVER(PARTITION BY tbl_bigquery ORDER BY tbl_origem DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.TBL_Origem`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.tbl_origem = raw.tbl_origem  

WHEN MATCHED THEN UPDATE SET
  bronze.tbl_bigquery     = raw.tbl_bigquery ,
  bronze.tbl_dm           = raw.tbl_dm ,
  bronze.tbl_origem       = raw.tbl_origem  ,
  bronze.servidor_origem  = raw.servidor_origem 			

WHEN NOT MATCHED THEN INSERT (
tbl_bigquery ,
  tbl_dm ,
  tbl_origem ,
  servidor_origem,	
  dt_carga_bronze
)
VALUES (
  raw.tbl_bigquery ,
  raw.tbl_dm ,
  raw.tbl_origem ,
  raw.servidor_origem,	
  CURRENT_DATETIME('-03:00')
);
