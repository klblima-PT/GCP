
-- ** tb_cnae_risco  **
-- DEVELOPED BY HVAR CONSULTING | DataOps team

truncate table `corporativo-poc-hvar.silver_bi.tb_cnae_risco`;

INSERT INTO `corporativo-poc-hvar.silver_bi.tb_cnae_risco` 
(        
Documento ,	
CodCnae ,	
EscalaRiscoId ,	
Escala_Risco ,	
Subclasse ,	
Cnae_Desc ,	
Descricao ,	
Desc_Escala 
)
With ClienteCnae as (
  select distinct Documento, CodCnae,Cnae_Desc from corporativo-poc-hvar.bronze_bi.mat_clientecnae
)
 ,Dbcorpapirisco_Cnae_Remove_duplicados as(
    select 
  Subclasse, max(DataHoraAlteracao) DataHoraAlteracao
  from corporativo-poc-hvar.bronze_bi.tbl_dbcorpapirisco_cnae
  where trim(Subclasse) <>''
  group by Subclasse
 )
  
, Dbcorpapirisco_Cnae as 
(
  select distinct
   max(case when c.EscalaRiscoId is null then 1 else c.EscalaRiscoId end) as EscalaRiscoId ,
   replace(replace(c.Subclasse,'/',''),'-','')   as Subclasse  
  ,c.Descricao
  from corporativo-poc-hvar.bronze_bi.tbl_dbcorpapirisco_cnae as c
  where c.subclasse <>''
  and ativoctrl= true  
  group by 
     replace(replace(c.Subclasse,'/',''),'-','')   
  ,c.Descricao
)
--select * from Dbcorpapirisco_Cnae
, Dbcorpapirisco_EscalaRisco as(
   select EscalaRiscoId,Descricao from corporativo-poc-hvar.bronze_bi.tbl_dbcorpapirisco_escalarisco
   where ativoctrl = true
)

select 
distinct 
Documento
, CodCnae
, b.EscalaRiscoId
,case when b.escalaRiscoId in (5,6) then "Maior Risco" else "Baixo Risco" end as Escala_Risco
, b.Subclasse
,max(a.Cnae_Desc) Cnae_Desc
,max(b.Descricao) Descricao
,max(c.Descricao) as Desc_Escala
  from ClienteCnae as a
  left join Dbcorpapirisco_Cnae as b
  on a.CodCnae = b.Subclasse 
  left join Dbcorpapirisco_EscalaRisco as c
  on c.EscalaRiscoId = b.EscalaRiscoId
  where b.EscalaRiscoId is not null
  group by 1,2,3,4,5