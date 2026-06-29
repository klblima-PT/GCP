
CREATE TABLE public.orders (
	id serial4 NOT NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	uuid varchar(36) NULL,
	total_order int8 NULL,
	external_id varchar(255) NOT NULL,
	"status" public."status" NOT NULL,
	wallet_payment int8 NULL,
	authorization_id varchar(255) NULL,
	cancellation_id varchar(255) NULL,
	refund_id varchar(255) NULL,
	wallet_order_id varchar(255) NULL,
	buyer_id int4 NULL,
	wallet_id int4 NULL,
	store_pos_id int4 NULL,
	meta_data json NULL,
	callback_url varchar(255) NULL,
	wallet_payment_id varchar(255) NULL,
	expiration_date timestamp NULL,
	payment_date timestamp NULL,
	order_generated_by_wallet_id int4 NULL,
	"type" varchar(30) NULL,
	wallet_setting_id int4 NULL,
	balance int8 NULL,
	installments int4 NULL,
	payer_id int4 NULL,
	CONSTRAINT orders_pkey PRIMARY KEY (id),
	CONSTRAINT order_generated_by_system_wallet_id_fkey FOREIGN KEY (order_generated_by_wallet_id) REFERENCES public.system_wallets(id),
	CONSTRAINT orders_buyer_id_fkey FOREIGN KEY (buyer_id) REFERENCES public.buyers(id),
	CONSTRAINT orders_payer_id_fkey FOREIGN KEY (payer_id) REFERENCES public.payer(id),
	CONSTRAINT orders_store_pos_id_fkey FOREIGN KEY (store_pos_id) REFERENCES public.store_pos(id),
	CONSTRAINT orders_system_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.system_wallets(id),
	CONSTRAINT orders_wallet_setting_id_fkey FOREIGN KEY (wallet_setting_id) REFERENCES public.wallet_settings(id)
);

CREATE UNIQUE INDEX idx_orders ON public.orders USING btree (uuid);
CREATE INDEX idx_orders_created_at ON public.orders USING btree (created_at);
CREATE INDEX idx_orders_external_id ON public.orders USING btree (external_id);
CREATE INDEX idx_orders_status ON public.orders USING btree (status);
CREATE INDEX idx_orders_uuid_gin ON public.orders USING gin (uuid gin_trgm_ops);
CREATE INDEX idx_orders_wallet_order_id ON public.orders USING btree (wallet_order_id);
CREATE INDEX ix_orders_buyer_id ON public.orders USING btree (buyer_id);
CREATE INDEX ix_orders_order_generated_by_wallet_id ON public.orders USING btree (order_generated_by_wallet_id);
CREATE INDEX ix_orders_store_pos_id ON public.orders USING btree (store_pos_id);
CREATE INDEX ix_orders_updated_at ON public.orders USING btree (updated_at);
CREATE INDEX ix_orders_wallet_id ON public.orders USING btree (wallet_id);
CREATE INDEX ix_orders_wallet_setting_id ON public.orders USING btree (wallet_setting_id);
