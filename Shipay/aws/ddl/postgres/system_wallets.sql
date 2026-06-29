CREATE TABLE public.system_wallets (
	id serial4 NOT NULL,
	wallet_name varchar(20) NOT NULL,
	active bool NULL,
	payment_fee float8 NULL,
	minimum_payment float8 NULL,
	require_settings bool NULL,
	"wallet_type" public."wallet_type" NOT NULL,
	single_credentials bool NULL,
	wallet_friendly_name varchar(20) NULL,
	wallet_logo text NULL,
	icon text NULL,
	uuid varchar(36) NOT NULL,
	cashout_active bool NULL DEFAULT false,
	CONSTRAINT system_wallets_pkey PRIMARY KEY (id)
);