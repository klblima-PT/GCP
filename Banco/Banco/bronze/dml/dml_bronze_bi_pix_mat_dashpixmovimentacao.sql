
-- ** bi_pix_mat_dashpixmovimentacao  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

MERGE INTO `corporativo-poc-hvar.bronze_bi.bi_pix_mat_dashpixmovimentacao` AS bronze
USING (
  SELECT
    * EXCEPT (rnk)
  FROM (
    SELECT DISTINCT
anomes				,
data				,
tipopessoa			,
enviadosrecebidos	,
statusmensagem		,
diretoindireto		,
mesmatitularidade	,
tipochave			,
participanteorigem	,
participantedestino	,
participante		,
faixahorario		,
faixahorariofiltro	,
possuichave			,
transfinterna		,
devolucao			,
dtfaixahorario		,
sistema				,
codgerente			,
clienteespecifico	,
relatoriocomerro	,
tipomes				,
situacaobackoffice	,
iddocumento			,
nometop				,
qtde				,
valor				,
qtdetop				,
valortop			,
      
      ROW_NUMBER() OVER(PARTITION BY faixahorario ORDER BY data DESC) AS rnk 
     
	 FROM
        `corporativo-poc-hvar.BI_RENDIMENTO.BI_PIX_MAT_DashPixMovimentacao`
     --WHERE
        --DATE(_PARTITIONDATE) >= DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
    ) 
  WHERE
    rnk = 1
) AS raw

ON bronze.data = raw.data
and bronze.faixahorario = raw.faixahorario

WHEN MATCHED THEN UPDATE SET
bronze.anomes				= raw.anomes				,
bronze.data				= raw.data				,
bronze.tipopessoa			= raw.tipopessoa			,
bronze.enviadosrecebidos	= raw.enviadosrecebidos	,
bronze.statusmensagem		= raw.statusmensagem		,
bronze.diretoindireto		= raw.diretoindireto		,
bronze.mesmatitularidade	= raw.mesmatitularidade	,
bronze.tipochave			= raw.tipochave			,
bronze.participanteorigem	= raw.participanteorigem	,
bronze.participantedestino	= raw.participantedestino	,
bronze.participante		= raw.participante		,
bronze.faixahorario		= raw.faixahorario		,
bronze.faixahorariofiltro	= raw.faixahorariofiltro	,
bronze.possuichave			= raw.possuichave			,
bronze.transfinterna		= raw.transfinterna		,
bronze.devolucao			= raw.devolucao			,
bronze.dtfaixahorario		= raw.dtfaixahorario		,
bronze.sistema				= raw.sistema				,
bronze.codgerente			= raw.codgerente			,
bronze.clienteespecifico	= raw.clienteespecifico	,
bronze.relatoriocomerro	= raw.relatoriocomerro	,
bronze.tipomes				= raw.tipomes				,
bronze.situacaobackoffice	= raw.situacaobackoffice	,
bronze.iddocumento			= raw.iddocumento			,
bronze.nometop				= raw.nometop				,
bronze.qtde				= raw.qtde				,
bronze.valor				= raw.valor				,
bronze.qtdetop				= raw.qtdetop				,
bronze.valortop			= raw.valortop			
			

WHEN NOT MATCHED THEN INSERT (
anomes				
,data					
,tipopessoa			
,enviadosrecebidos	
,statusmensagem		
,diretoindireto		
,mesmatitularidade	
,tipochave			
,participanteorigem	
,participantedestino	
,participante			
,faixahorario			
,faixahorariofiltro	
,possuichave			
,transfinterna		
,devolucao			
,dtfaixahorario		
,sistema				
,codgerente			
,clienteespecifico	
,relatoriocomerro		
,tipomes				
,situacaobackoffice	
,iddocumento			
,nometop				
,qtde					
,valor				
,qtdetop				
,valortop				
,dt_carga_bronze 
)
VALUES (
raw.anomes				,
raw.data				,
raw.tipopessoa			,
raw.enviadosrecebidos	,
raw.statusmensagem		,
raw.diretoindireto		,
raw.mesmatitularidade	,
raw.tipochave			,
raw.participanteorigem	,
raw.participantedestino	,
raw.participante		,
raw.faixahorario		,
raw.faixahorariofiltro	,
raw.possuichave			,
raw.transfinterna		,
raw.devolucao			,
raw.dtfaixahorario		,
raw.sistema				,
raw.codgerente			,
raw.clienteespecifico	,
raw.relatoriocomerro	,
raw.tipomes				,
raw.situacaobackoffice	,
raw.iddocumento			,
raw.nometop				,
raw.qtde				,
raw.valor				,
raw.qtdetop				,
raw.valortop			,
CURRENT_DATETIME('-03:00')
);
