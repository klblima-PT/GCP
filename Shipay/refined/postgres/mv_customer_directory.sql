CREATE MATERIALIZED VIEW mv_customer_directory AS

SELECT pv.id AS vendor_id
	,pv.name AS vendor_name
	,pv.cnpj AS vendor_cnpj
	,pv.email AS vendor_email
	,pv.uuid AS vendor_uuid
	,pv.active AS vendor_status
	,pv.created_at AS vendor_created
	,pp.id AS product_id
	,pp.name AS product_name
	,pp.email AS product_email
	,pp.active AS product_active
	,pp.created_at AS product_created
	,(
		SELECT rc.name
		FROM retail_chains rc
		WHERE (rc.degree @ > cus.degree) LIMIT 1
		) AS retail_name
	,cus.id AS customer_id
	,cus.name AS customer_name
	,cus.email AS customer_email
	,cus.created_at AS customer_created
	,cus.uuid AS customer_uuid
	,cus.external_crm_id AS customer_crm_id
	,st.id AS stores_id
	,st.name AS stores_name
	,st.created_at AS stores_created
	,st.city_name AS stores_city
	,st.state_name AS stores_state
	,st.person_type AS stores_type
	,st.cnpj_cpf AS stores_cnpj_cpf
	,st.active AS store_active
	,sp.id AS store_pos_id
	,sp.name AS s_pos_name
	,sp.created_at AS s_pos_created
	,sp.active AS s_pos_active
	,sp.category AS s_pos_category
	,current_timestamp AS last_refresh
FROM pos_vendors pv
LEFT JOIN pos_products pp ON pv.id = pp.pos_vendor_id
LEFT JOIN customers cus ON pp.degree @ > cus.degree
LEFT JOIN stores st ON cus.id = st.customer_id
LEFT JOIN store_pos sp ON st.id = sp.store_id
ORDER BY vendor_id
	,product_id
	,customer_id
	,stores_id
	,store_pos_id;
	
	
CREATE INDEX idx_mv_customer_directory_vendor  ON mv_customer_directory (vendor_id);
CREATE INDEX idx_mv_customer_directory_product ON mv_customer_directory (product_id);
CREATE INDEX idx_mv_customer_directory_customer ON mv_customer_directory (customer_id);
CREATE INDEX idx_mv_customer_directory_stores  ON mv_customer_directory (stores_id);
CREATE INDEX idx_mv_customer_directory_store_pos  ON mv_customer_directory (store_pos_id);