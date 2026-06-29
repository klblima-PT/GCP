CREATE TABLE public.wallet_settings (
	id serial4 NOT NULL,
	uuid varchar(36) NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	active bool NULL,
	wallet_id int4 NULL,
	"default" bool NOT NULL DEFAULT false,
	"name" varchar(100) NULL,
	customer_id int4 NULL,
	psp_provider_id int4 NULL,
	pix_dict_key varchar(255) NULL,
	"transaction_type" varchar(100) default 'cashin',
	bank_slip_settings_id int4 NULL,
	withdraw_bank_id int4 NULL,
	CONSTRAINT wallet_settings_pkey PRIMARY KEY (id),
	CONSTRAINT wallet_settings_bank_slip_settings_id_fkey FOREIGN KEY (bank_slip_settings_id) REFERENCES public.bank_slip_settings(id),
	CONSTRAINT wallet_settings_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customers(id),
	CONSTRAINT wallet_settings_psp_provider_id_fkey FOREIGN KEY (psp_provider_id) REFERENCES public.system_wallets(id),
	CONSTRAINT wallet_settings_system_wallet_id_fkey FOREIGN KEY (wallet_id) REFERENCES public.system_wallets(id),
	CONSTRAINT wallet_settings_withdraw_bank_id_fkey FOREIGN KEY (withdraw_bank_id) REFERENCES public.banks(id)
);
CREATE UNIQUE INDEX idx_wallet_settings ON public.wallet_settings USING btree (uuid);