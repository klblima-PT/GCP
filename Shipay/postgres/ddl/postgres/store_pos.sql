CREATE TABLE public.store_pos (
	id serial4 NOT NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	"name" varchar(100) NULL,
	active bool NULL,
	uuid varchar(36) NOT NULL,
	fixed_amount bool NULL,
	meta_data json NULL,
	store_id int4 NULL,
	category public."enumcategory" NULL DEFAULT 'general'::enumcategory,
	client_token_reference int4 NULL,
	CONSTRAINT store_pos_pkey PRIMARY KEY (id),
	CONSTRAINT store_pos_store_id_fkey FOREIGN KEY (store_id) REFERENCES public.stores(id)
);
CREATE UNIQUE INDEX ix_store_pos_client_token_reference ON public.store_pos USING btree (client_token_reference);
CREATE INDEX ix_store_pos_name ON public.store_pos USING btree (name);
CREATE INDEX ix_store_pos_store_id ON public.store_pos USING btree (store_id);