CREATE TABLE public.retail_chains (
	id serial4 NOT NULL,
	"name" varchar(100) NULL,
	uuid varchar(36) NULL,
	email varchar(100) NULL,
	"degree" public.ltree NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	external_crm_id varchar(80) NULL,
	CONSTRAINT retail_chains_pkey PRIMARY KEY (id)
);

