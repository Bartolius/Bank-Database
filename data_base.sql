CREATE TABLE personal_data(
	personal_data_id serial,
	phone_number varchar(13),
		CHECK(length(phone_number) > 4),
	Email varchar(50)
		CHECK(length(Email) > 5) UNIQUE,
	
	PRIMARY KEY(personal_data_id)
);

CREATE TABLE ID_card(
	card_id varchar(9)
		NOT NULL UNIQUE,
	first_name varchar(50)
		NOT NULL CHECK(length(first_name)>3),
	last_name varchar(50)
		NOT NULL CHECK(length(first_name)>3),
	birth_date date
		NOT NULL CHECK(birth_date<now()-interval '6 year'),
	pesel varchar(11)
		UNIQUE,
	personal_data_id int
		NOT NULL CHECK(personal_data_id > 0) UNIQUE,
	
	PRIMARY KEY (card_id),
	FOREIGN KEY (personal_data_id)
    	REFERENCES personal_data(personal_data_id)
);

CREATE TYPE address_type_enum AS ENUM('birth place','address','correspondence address');
CREATE TABLE address(
	address_id serial,
	card_id varchar(9)
		NOT NULL CHECK(length(card_id)=9),
	type_of_address address_type_enum
		NOT NULL,
	province varchar(25)
		CHECK(length(province)>4),
	town varchar(35)
		NOT NULL CHECK(length(town)>4),
	post_code varchar(6)
		CHECK(length(post_code)=6),
	street varchar(50)
		NOT NULL CHECK(length(street)>3),
	home_number varchar(50)
		NOT NULL,
	
	PRIMARY KEY(address_id),
	FOREIGN KEY(card_id)
    	REFERENCES ID_card(card_id)
);

CREATE TABLE accound_type(
	accound_type_id serial,
	type_name varchar(30)
		NOT NULL CHECK(length(type_name)>5),
	
	PRIMARY KEY(accound_type_id)
);

CREATE TABLE bank_accound(
	iban_number_id varchar(28)
		NOT NULL CHECK(length(iban_number_id)=28) UNIQUE,
	accound_type int
		NOT NULL CHECK(accound_type>0),
	balance money
		NOT NULL DEFAULT 0.00::float8::NUMERIC::money,
	accound_pass varchar(35)
		NOT NULL CHECK(accound_pass <> ''),
	
	PRIMARY KEY(iban_number_id),
	FOREIGN KEY(accound_type)
    	REFERENCES accound_type(accound_type_id)
    
);
CREATE TABLE bank_accound_to_personal_data(
	id serial,
	accound_id varchar(28)
		NOT NULL CHECK(length(accound_id)=28),
	personal_data_id int
		NOT NULL CHECK(personal_data_id>0),

	PRIMARY KEY(id),
	FOREIGN KEY(accound_id)
    	REFERENCES bank_accound(iban_number_id),
	FOREIGN KEY(personal_data_id)
    	REFERENCES personal_data(personal_data_id)
);

CREATE TYPE transaction_history_type AS enum('user','accound','credit_card','loan','transfer','others');
CREATE TABLE transaction_history(
	transaction_id serial,
	accound_id varchar(28),
	description TEXT,
	transaction_date timestamp,
	transaction_type transaction_history_type,
	
	PRIMARY KEY(transaction_id),
	FOREIGN KEY(accound_id)
    	REFERENCES bank_accound(iban_number_id)
);
ALTER TABLE transaction_history ALTER COLUMN transaction_date SET DEFAULT now();
ALTER TABLE transaction_history ADD CONSTRAINT accound_id_check CHECK(length(accound_id)=28);
ALTER TABLE transaction_history ALTER COLUMN transaction_type SET NOT NULL;

CREATE TYPE card_type_enum AS ENUM('credit card','debit card','charge card');
CREATE TABLE card_type(
	card_type_id serial,
	card_type card_type_enum,
	interest numeric(5,2),
	
	PRIMARY KEY (card_type_id)
);
ALTER TABLE card_type ALTER COLUMN card_type SET NOT NULL;
ALTER TABLE card_type ADD CONSTRAINT interest_check CHECK(interest>=0.0);
ALTER TABLE card_type ALTER COLUMN interest SET NOT NULL;

CREATE TABLE credit_card(
	credit_card_number varchar(16),
	accound_id varchar(28),
	primary_card boolean,
	card_pass varchar(35),
	card_type int,
	
	PRIMARY KEY(credit_card_number),
	FOREIGN KEY(accound_id)
    	REFERENCES bank_accound(iban_number_id),
    FOREIGN KEY(card_type)
    	REFERENCES card_type(card_type_id)
);
ALTER TABLE credit_card ALTER COLUMN credit_card_number SET NOT NULL;
ALTER TABLE credit_card ADD CONSTRAINT credit_card_number_check CHECK(length(credit_card_number)=16);
ALTER TABLE credit_card ALTER COLUMN accound_id SET NOT NULL;
ALTER TABLE credit_card ADD CONSTRAINT accound_id_check CHECK(length(accound_id)=28);
ALTER TABLE credit_card ALTER COLUMN primary_card SET NOT NULL;
ALTER TABLE credit_card ALTER COLUMN primary_card SET DEFAULT FALSE;
ALTER TABLE credit_card ALTER COLUMN card_pass SET NOT NULL;
ALTER TABLE credit_card ADD CONSTRAINT card_pass_check CHECK(card_pass <> '');
ALTER TABLE credit_card ALTER COLUMN card_type SET NOT NULL;
ALTER TABLE credit_card ADD CONSTRAINT card_type_check CHECK(card_type>0);

CREATE TABLE loan_type(
	loan_type_id serial,
	loan_type_name varchar(50),
	interest numeric(5,2),
	monthly_loan_increase numeric(5,2),
	max_loan money,
	
	PRIMARY KEY(loan_type_id)
);
ALTER TABLE loan_type ALTER COLUMN loan_type_name SET NOT NULL;
ALTER TABLE loan_type ALTER COLUMN interest SET NOT NULL;
ALTER TABLE loan_type ADD CONSTRAINT interest_check CHECK(interest>=0.0);
ALTER TABLE loan_type ALTER COLUMN monthly_loan_increase SET NOT NULL;
ALTER TABLE loan_type ADD CONSTRAINT monthly_loan_increase_check CHECK(monthly_loan_increase>=0.0);
ALTER TABLE loan_type ALTER COLUMN max_loan SET NOT NULL;
ALTER TABLE loan_type ADD CONSTRAINT max_loan_check CHECK(max_loan>0.0::float8::NUMERIC::money);

CREATE TABLE loans(
	loan_id serial,
	card_id varchar(16),
	loan_amount money,
	loan_to_pay money,
	start_of_loan timestamp,
	end_of_loan timestamp,
	loan_type int,
	
	PRIMARY KEY(loan_id),
	FOREIGN KEY(card_id)
    	REFERENCES credit_card(credit_card_number),
    FOREIGN KEY(loan_type)
    	REFERENCES loan_type(loan_type_id)
);
ALTER TABLE loans ALTER COLUMN card_id SET NOT NULL;
ALTER TABLE loans ADD CONSTRAINT card_id_check CHECK(length(card_id)=16);
ALTER TABLE loans ALTER COLUMN loan_amount SET NOT NULL;
ALTER TABLE loans ALTER COLUMN loan_amount SET DEFAULT 0.00::float8::NUMERIC::money;
ALTER TABLE loans ADD CONSTRAINT loan_amount_check CHECK(loan_amount>=0.0::float8::NUMERIC::money);
ALTER TABLE loans ALTER COLUMN loan_to_pay SET NOT NULL;
ALTER TABLE loans ALTER COLUMN loan_to_pay SET DEFAULT 0.00::float8::NUMERIC::money;
ALTER TABLE loans ADD CONSTRAINT loan_to_pay CHECK(loan_to_pay>=0.0::float8::NUMERIC::money);
ALTER TABLE loans ALTER COLUMN start_of_loan SET DEFAULT now();
ALTER TABLE loans ALTER COLUMN start_of_loan SET NOT NULL;
ALTER TABLE loans ALTER COLUMN end_of_loan SET NOT NULL;
ALTER TABLE loans ALTER COLUMN loan_type SET NOT NULL;
ALTER TABLE loans ADD CONSTRAINT loan_type_check CHECK(loan_type>0);





















--DROP TABLE IF EXISTS loans cascade;
--DROP TABLE IF EXISTS loan_type cascade;
--DROP TABLE IF EXISTS credit_card cascade;
--DROP TABLE IF EXISTS card_type cascade;
--DROP TABLE IF EXISTS transaction_history cascade;
--DROP TABLE IF EXISTS bank_accound_to_personal_data cascade;
--DROP TABLE IF EXISTS bank_accound cascade;
--DROP TABLE IF EXISTS accound_type cascade;
--DROP TABLE IF EXISTS address cascade;
--DROP TABLE IF EXISTS ID_card cascade;
--DROP TABLE IF EXISTS personal_data cascade;
--
--DROP TYPE IF EXISTS card_type_enum;
--DROP TYPE IF EXISTS transaction_history_type;
--DROP TYPE IF EXISTS address_type_enum;

