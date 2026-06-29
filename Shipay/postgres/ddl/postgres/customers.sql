CREATE TABLE public.customers (
	id serial4 NOT NULL,
	uuid varchar(36) NULL,
	"name" varchar(100) NOT NULL,
	email varchar(100) NOT NULL,
	access_key varchar(30) NOT NULL,
	secret_key varchar(100) NOT NULL,
	"degree" public.ltree NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	access_key_reference int4 NULL,
	secret_key_reference int4 NULL,
	external_crm_id varchar(80) NULL,
	CONSTRAINT customers_pkey PRIMARY KEY (id)
);
CREATE UNIQUE INDEX ix_customers_access_key_reference ON public.customers USING btree (access_key_reference);
CREATE INDEX ix_customers_degree ON public.customers USING gist (degree);
CREATE UNIQUE INDEX ix_customers_secret_key_reference ON public.customers USING btree (secret_key_reference);
