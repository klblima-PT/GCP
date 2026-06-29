CREATE TABLE public.stores (
	id serial4 NOT NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	"name" varchar(100) NULL,
	uuid varchar(36) NULL,
	active bool NULL,
	zip_code varchar(8) NULL,
	street_name varchar(100) NULL,
	street_number varchar(10) NULL,
	city_name varchar(50) NULL,
	state_name varchar(2) NULL,
	latitude float8 NULL,
	longitude float8 NULL,
	reference text NULL,
	meta_data json NULL,
	customer_id int4 NULL,
	cnpj_cpf varchar(14) NOT NULL,
	headquarter bool NULL,
	"degree" public.ltree NULL,
	person_type varchar(2) NULL,
	neighborhood varchar(100) NULL,
	zendesk_deal_id int4 NULL,
	CONSTRAINT stores_pkey PRIMARY KEY (id),
	CONSTRAINT stores_un UNIQUE (cnpj_cpf, degree),
	CONSTRAINT stores_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id)
);
CREATE INDEX ix_stores_customer_id ON public.stores USING btree (customer_id);
CREATE INDEX ix_stores_degree ON public.stores USING gist (degree);
CREATE INDEX ix_stores_name ON public.stores USING btree (name);