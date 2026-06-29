CREATE TABLE public.pos_vendors (
	id serial4 NOT NULL,
	uuid varchar(36) NULL,
	"name" varchar(255) NOT NULL,
	cnpj varchar(14) NOT NULL,
	email varchar(100) NOT NULL,
	active bool NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	"degree" public.ltree NOT NULL,
	external_crm_id varchar(80) NULL,
	CONSTRAINT pos_vendors_pkey PRIMARY KEY (id)
);
CREATE INDEX ix_pos_vendors_degree ON public.pos_vendors USING gist (degree);
