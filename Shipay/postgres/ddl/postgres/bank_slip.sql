CREATE TABLE public.bank_slip (
	id serial4 NOT NULL,
	uuid varchar(36) NOT NULL,
	external_id varchar(36) NULL,
	created_at timestamp NOT NULL DEFAULT now(),
	updated_at timestamp NULL DEFAULT CURRENT_TIMESTAMP,
	expire_date timestamp NOT NULL,
	payment_code public.enumpaymentcode NOT NULL,
	total_amount int8 NOT NULL,
	rebate_amount int8 NULL,
	days_until_expiration int4 NULL,
	days_until_negation int4 NULL,
	order_id int4 NULL,
	covenant_code varchar(10) NULL,
	days_valid_after_due int4 NULL,
	payment_method public.paymentmethod NULL,
	CONSTRAINT bank_slip_pkey PRIMARY KEY (id),
	CONSTRAINT bank_slip_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.orders(id)
);
CREATE INDEX ix_bank_slip_order_id ON public.bank_slip USING btree (order_id);