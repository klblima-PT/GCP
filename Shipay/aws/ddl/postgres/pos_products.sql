CREATE TABLE public.pos_products (
	id serial4 NOT NULL,
	uuid varchar(36) NULL,
	"name" varchar(255) NOT NULL,
	email varchar(100) NOT NULL,
	pos_vendor_id int4 NULL,
	active bool NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	"degree" public.ltree NOT NULL,
	fake_register bool NULL DEFAULT false,
	"notify" bool NULL,
	logo text NULL,
	external_crm_id varchar(80) NULL,
	CONSTRAINT pos_products_pkey PRIMARY KEY (id),
	CONSTRAINT pos_products_pos_vendor_id_fkey FOREIGN KEY (pos_vendor_id) REFERENCES public.pos_vendors(id)
);
CREATE INDEX ix_pos_products_degree ON public.pos_products USING gist (degree);
CREATE INDEX ix_pos_products_pos_vendor_id ON public.pos_products USING btree (pos_vendor_id);
