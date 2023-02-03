CREATE OR REPLACE FUNCTION insert_user(
phone varchar(13),email_ varchar(50),
firstname varchar(50),lastname varchar(50),birth_date date,pesel_ varchar(11),
province_1 varchar(25),city_1 varchar(35),postcode_1 varchar(6),street_1 varchar(50),homenumber_1 varchar(50),
province_2 varchar(25),city_2 varchar(35),postcode_2 varchar(6),street_2 varchar(50),homenumber_2 varchar(50)
)
RETURNS varchar(50)
AS $$
DECLARE
	card_id_number varchar(9) DEFAULT card_number();
BEGIN
	
	WHILE (SELECT count(*) FROM id_card WHERE card_id=card_id_number)>0
	LOOP 
		card_id_number = card_number();
	END LOOP;

	IF length(phone)<=4 THEN 
		RETURN 'Phone number is incorrect!';
	ELSIF length(email_) <= 5 OR (SELECT count(*) FROM personal_data WHERE email = email_)>0 THEN 
		RETURN 'Email is incorrect!';
	ELSIF firstname IS NULL OR length(firstname)<=3 THEN
		RETURN 'First name is incorrect!';
	ELSIF lastname IS NULL OR length(lastname)<=3 THEN
		RETURN 'Last name is incorrect!';
	ELSIF birth_date IS NULL OR birth_date>(now()-interval '6 year')::date THEN
		RETURN 'Birth date is incorrect!';
	ELSIF pesel_ IS NULL OR (SELECT count(*) FROM id_card WHERE pesel = pesel_)>0 OR length(pesel_)<>11 THEN
		RETURN 'Pesel is incorrect!';
	ELSIF length(province_1)<=4 THEN
		RETURN 'Province of birth is incorrect!';
	ELSIF city_1 is NULL OR length(city_1)<=4 THEN
		RETURN 'City of birth is incorrect!';
	ELSIF length(postcode_1)<>6 THEN
		RETURN 'Postcode of city birth is incorrect!';
	ELSIF street_1 IS NULL OR length(street_1)<=3 THEN
		RETURN 'Street where you birth is incorrect!';
	ELSIF homenumber_1 IS NULL THEN
		RETURN 'Number of place where you birth is incorrect!';
	ELSIF length(province_2)<=4 THEN
		RETURN 'Province where you life is incorrect!';
	ELSIF city_2 IS NULL OR length(city_2)<=4 THEN
		RETURN 'City where you life is incorrect!';
	ELSIF length(postcode_2)<>6 THEN
		RETURN 'Postcode where you life birth is incorrect!';
	ELSIF street_2 IS NULL OR length(street_2)<=3 THEN
		RETURN 'Street where you life is incorrect!';
	ELSIF homenumber_2 IS NULL THEN
		RETURN 'Number of place where you life is incorrect!';
	ELSE
		INSERT INTO personal_data (phone_number,email) VALUES (phone,email_);
		INSERT INTO id_card (card_id,first_name,last_name,birth_date,pesel,personal_data_id) VALUES
			(card_id_number,firstname,lastname,birth_date,pesel_,(SELECT personal_data_id FROM personal_data WHERE email=email_));
		INSERT INTO address (card_id,type_of_address,province,town,post_code,street,home_number) VALUES
			(card_id_number,'birth place',province_1,city_1,postcode_1,street_1,homenumber_1),
			(card_id_number,'address',province_2,city_2,postcode_2,street_2,homenumber_2);
		INSERT INTO transaction_history (accound_id,description,transaction_date,transaction_type) VALUES
			(NULL,concat('User: ',card_id_number,' has been added to database.'),now(),'user');
	END IF;
	
	RETURN concat('User: ',card_id_number,' was created and added to database. His/Her id: ',(SELECT personal_data_id FROM personal_data WHERE email=email_));
END;
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION insert_accound(
	personal_data_input int,
	accound varchar(30),pass varchar(25)
)
RETURNS varchar(100)
AS $$
DECLARE
	iban_number varchar(28) DEFAULT IBAN_number('PL','39168566');
BEGIN 
	WHILE (SELECT count(*) FROM bank_accound WHERE iban_number_id=iban_number)>0
	LOOP
		iban_number=IBAN_number('PL','39168566');
	END LOOP;
	if personal_data_input IS NULL OR personal_data_input<=0 THEN 
		RETURN 'Personal id is incorrect!';
	ELSIF (SELECT count(*) FROM personal_data WHERE personal_data_id=personal_data_input)<1 THEN 
		RETURN 'This User doesn''t exists!';
	ELSIF accound IS NULL OR length(accound)<=0 THEN 
		RETURN 'Accound type is incorrect!';
	ELSIF (SELECT count(*) FROM accound_type WHERE type_name=accound)<>1 THEN 
		RETURN 'This accound doesn''t exists or it does multiplied!';
	ELSIF pass IS NULL OR length(pass)<6 THEN 
		RETURN 'Password is incorrect!';
	ELSE
		INSERT INTO bank_accound (iban_number_id,accound_type,balance,accound_pass) VALUES
			(iban_number,(SELECT accound_type_id FROM accound_type WHERE type_name=accound LIMIT 1),0.00::float8::NUMERIC::money,md5(pass));
		INSERT INTO bank_accound_to_personal_data (accound_id,personal_data_id) VALUES
			(iban_number,personal_data_input);
		INSERT INTO transaction_history (accound_id,description,transaction_date,transaction_type) VALUES
			(NULL,concat('Accound: ',iban_number,' was created and added to User:',personal_data_input),now(),'accound');
	END IF;
	RETURN concat('Accound: ',iban_number,' was created and added to User:',personal_data_input,' with password: ',pass);
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION add_card(
	iban_number varchar(28),pass varchar(35),
	is_primary boolean,"type" int
)
RETURNS varchar(100)
AS $$
DECLARE
	card_number varchar(16) DEFAULT c_credit_card_number();
	card_password varchar(4) DEFAULT concat(floor(random()*10),floor(random()*10),floor(random()*10),floor(random()*10));
BEGIN 
	--RAISE NOTICE SELECT count(*) FROM bank_accound WHERE iban_number_id=iban_number;
	IF (SELECT count(*) FROM bank_accound WHERE iban_number_id=iban_number)=0 THEN
		RETURN 'This accound doesn''t exists!';
	ELSIF (SELECT count(*) FROM bank_accound WHERE iban_number_id=iban_number AND accound_pass=md5(pass))>0 THEN
		IF is_primary IS NULL THEN
			RETURN 'Primary card is incorrect!';
		ELSIF (SELECT count(*) FROM card_type WHERE card_type_id="type")<>1 THEN
			RETURN 'Type of card not exists!';
		ELSIF (SELECT count(*) FROM credit_card WHERE accound_id=iban_number AND primary_card=TRUE)>0 AND is_primary = TRUE THEN
			RETURN 'You cannot bring more than 1 primary card!';
		ELSE
			INSERT INTO credit_card (credit_card_number,accound_id,primary_card,card_pass,card_type) VALUES
				(card_number,iban_number,is_primary,md5(card_password),"type");
			INSERT INTO transaction_history (accound_id,description,transaction_date,transaction_type) VALUES
				(iban_number,concat('Add new card: ',card_number,' to accound: ',iban_number),now(),'credit_card');
			END IF;
	ELSE
		RETURN 'This password is incorrect';
	END IF;
	RETURN concat('Add new card: ',card_number,' to accound: ',iban_number,' with password: ',card_password);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION take_loan(
	iban_number varchar(28),pass varchar(35),
	card_number varchar(16),pass2 varchar(35),
	type_of_loan int, ammount money,length_of_loan INTERVAL
)
RETURNS varchar(50)
AS $$
	DECLARE 
		loan_id_trans int DEFAULT 0;
	BEGIN 
		IF (SELECT count(*) FROM credit_card WHERE credit_card_number=card_number)<>1 THEN
			RETURN 'Card number is incorrect!';
		
			
		ELSIF ammount IS NULL OR ammount <= 0.0::float8::NUMERIC::money THEN
			RETURN 'Ammount of money is incorrect';
		ELSIF length_of_loan IS NULL OR length_of_loan<('1 month')::interval THEN
			RETURN 'Time of loan is to small';
		ELSIF (SELECT count(*) FROM credit_card WHERE credit_card_number=card_number AND card_pass=md5(pass2))=1 AND type_of_loan>2 THEN
			IF (SELECT count(*) FROM bank_accound WHERE iban_number_id=iban_number)<>1 THEN 
				RETURN 'Accound number is incorrect!';
			ELSIF (SELECT count(*) FROM bank_accound WHERE iban_number_id=iban_number AND accound_pass=md5(pass))=1 THEN 
				IF ammount>(SELECT max_loan FROM loan_type WHERE loan_type_id=type_of_loan) THEN
					RETURN concat('You couldn''t take loan of ammount higher than: ',(SELECT max_loan FROM loan_type WHERE loan_type_id=type_of_loan));
				ELSIF (extract(year from length_of_loan) * 12+extract(month from length_of_loan)+ floor(EXTRACT(DAY FROM length_of_loan)/30))<10 THEN
					RETURN 'Time of loan is to low!';
				ELSE
					INSERT INTO loans(card_id,loan_amount,loan_to_pay,start_of_loan,end_of_loan,loan_type) VALUES
						(card_number,ammount,((ammount::money::NUMERIC::float8)*(1.00+(SELECT interest FROM loan_type WHERE loan_type_id=type_of_loan)))::float8::NUMERIC::money,now(),now()+length_of_loan,type_of_loan)RETURNING loan_id INTO loan_id_trans;
					INSERT INTO transaction_history (accound_id,description,transaction_date,transaction_type) VALUES
						(iban_number,concat('Card: ',card_number,' take a',(SELECT loan_type_name FROM loan_type WHERE loan_type_id=type_of_loan),', amount of: ',ammount,'. To repaid: ',(SELECT loan_to_pay FROM loans WHERE loan_id=loan_id_trans)),now(),'loan');
					UPDATE bank_accound SET balance=((SELECT balance FROM bank_accound WHERE iban_number_id=iban_number)::money::NUMERIC::float8+ammount::money::NUMERIC::float8)::float8::NUMERIC::money WHERE iban_number_id=iban_number;
					RETURN concat('You take a loan: ',ammount,', to repaid: ',(SELECT loan_to_pay FROM loans WHERE loan_id=loan_id_trans));
				END IF;
			ELSE
				RETURN 'Password is incorrect!';
			END IF;
		ELSIF (extract(year from length_of_loan) * 12+extract(month from length_of_loan)+ floor(EXTRACT(DAY FROM length_of_loan)/30))<2 THEN
			RETURN 'Time of loan is to low!';
		ELSIF (SELECT count(*) FROM credit_card WHERE credit_card_number=card_number AND card_pass=md5(pass2))=1 THEN 
			IF (SELECT count(*) FROM loans WHERE card_id=card_number)>0 THEN
				RETURN concat('You arleady have 1 ',(SELECT loan_type_name FROM loan_type WHERE loan_type_id=type_of_loan));
			ELSE 
				INSERT INTO loans(card_id,loan_amount,loan_to_pay,start_of_loan,end_of_loan,loan_type) VALUES
					(card_number,ammount,((ammount::money::NUMERIC::float8)*(1.00+(SELECT interest FROM loan_type WHERE loan_type_id=type_of_loan)))::float8::NUMERIC::money,now(),now()+length_of_loan,type_of_loan)RETURNING loan_id INTO loan_id_trans;
				INSERT INTO transaction_history (accound_id,description,transaction_date,transaction_type) VALUES
					(iban_number,concat('Card: ',card_number,' take a',(SELECT loan_type_name FROM loan_type WHERE loan_type_id=type_of_loan),', amount of: ',ammount,'. To repaid: ',(SELECT loan_to_pay FROM loans WHERE loan_id=loan_id_trans)),now(),'loan');
				UPDATE bank_accound SET balance=((SELECT balance FROM bank_accound WHERE iban_number_id=iban_number)::money::NUMERIC::float8+ammount::money::NUMERIC::float8)::float8::NUMERIC::money WHERE iban_number_id=iban_number;
				RETURN concat('You take a loan: ',ammount,', to repaid: ',(SELECT loan_to_pay FROM loans WHERE loan_id=loan_id_trans));
			END IF;
		ELSE
			RETURN 'Password is incorrect!';
		END IF;
	END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION transfer(
from_accound varchar(28),accound_password varchar(35),
to_accound varchar(28),
ammount money,
from_card varchar(16), pass varchar(35))
RETURNS varchar(100)
AS $$
	BEGIN
		IF length(from_accound)<>28 OR from_accound IS NULL OR (SELECT count(*) FROM bank_accound WHERE iban_number_id=from_accound)=0 THEN 
			RETURN 'Your accound is incorrect!';
		ELSIF length(to_accound)<>28 OR to_accound IS NULL OR (SELECT count(*) FROM bank_accound WHERE iban_number_id=to_accound)=0 THEN 
			RETURN 'Other accound is incorrect!';
		ELSIF ammount::money::NUMERIC::float8 >2500 then
			IF accound_password IS NULL OR (SELECT count(*) FROM bank_accound WHERE iban_number_id=from_accound AND accound_pass=md5(accound_password))=0 THEN 
				RETURN 'Your password is incorrect!';
			ELSIF ammount::money::NUMERIC::float8<=0 OR ammount IS NULL OR (SELECT balance FROM bank_accound WHERE iban_number_id=from_accound)::money::NUMERIC::float8 < ammount::money::NUMERIC::float8 THEN 
				RETURN concat('You dont have ',ammount,' on your accound or billance is too small');
			ELSE
				UPDATE bank_accound SET balance=((SELECT balance FROM bank_accound WHERE iban_number_id=from_accound)::money::NUMERIC::float8-ammount::money::NUMERIC::float8)::float8::NUMERIC::money WHERE iban_number_id=from_accound;
				UPDATE bank_accound SET balance=((SELECT balance FROM bank_accound WHERE iban_number_id=to_accound)::money::NUMERIC::float8+ammount::money::NUMERIC::float8)::float8::NUMERIC::money WHERE iban_number_id=to_accound;
				INSERT INTO transaction_history(accound_id,description,transaction_date,transaction_type) VALUES (from_accound,concat('User: ',from_accound,' paid: ',ammount,' to: ',to_accound),now(),'transfer');
				RETURN concat('You paid: ',ammount,' to ',to_accound);
			END IF;
		ELSE 
			IF pass IS NULL OR (SELECT count(*) FROM credit_card WHERE credit_card_number=from_card AND card_pass=md5(pass))=0 THEN 
				RETURN 'Your password is incorrect!';
			ELSIF ammount::money::NUMERIC::float8<=0 OR ammount IS NULL OR (SELECT balance FROM bank_accound WHERE iban_number_id=(SELECT accound_id FROM credit_card WHERE credit_card_number=from_card))::money::NUMERIC::float8 < ammount::money::NUMERIC::float8 THEN 
				RETURN concat('You dont have ',ammount,' on your accound or billance is too small');
			ELSE
				UPDATE bank_accound SET balance=((SELECT balance FROM bank_accound WHERE iban_number_id=(SELECT accound_id FROM credit_card WHERE credit_card_number=from_card))::money::NUMERIC::float8-ammount::money::NUMERIC::float8)::float8::NUMERIC::money WHERE iban_number_id=(SELECT accound_id FROM credit_card WHERE credit_card_number=from_card);
				UPDATE bank_accound SET balance=((SELECT balance FROM bank_accound WHERE iban_number_id=to_accound)::money::NUMERIC::float8+ammount::money::NUMERIC::float8)::float8::NUMERIC::money WHERE iban_number_id=to_accound;
				INSERT INTO transaction_history(accound_id,description,transaction_date,transaction_type) VALUES (from_accound,concat('User: ',from_accound,' paid: ',ammount,' to: ',to_accound),now(),'transfer');
				RETURN concat('You paid: ',ammount,' to ',to_accound);
			END IF;
		END IF;
	END;
$$ LANGUAGE plpgsql;








--wykonanie funkcji

--SELECT take_loan('PL22391685668807517857858541','abcdef1234','1307430725666209','1234',3,25000::float8::NUMERIC::money,'5 year'::interval);
--
--SELECT transfer('PL22391685668807517857858541','abcdef1234','PL37391685669909107583627114',10000::float8::NUMERIC::money,'1307430725666209','1234');
--
--SELECT * FROM bank_accound WHERE iban_number_id IN ('PL22391685668807517857858541');
--SELECT * FROM loans;
--
--SELECT * FROM transaction_history;
--
--
--
--
--
--
--
--widoki
--
--CREATE VIEW widok1 AS (SELECT t.description, b.iban_number_id,b.balance FROM bank_accound AS b INNER JOIN transaction_history AS t ON b.iban_number_id=t.accound_id ORDER BY t.transaction_date DESC LIMIT 1);
--
--CREATE VIEW widok2 AS (SELECT b.balance,i.first_name,i.last_name FROM bank_accound AS b INNER JOIN bank_accound_to_personal_data AS bp ON b.iban_number_id=bp.accound_id INNER JOIN personal_data AS p
--ON bp.personal_data_id=p.personal_data_id INNER JOIN id_card AS i ON i.personal_data_id=p.personal_data_id);
--
--
--CREATE VIEW widok3 AS (SELECT b.iban_number_id,b.balance,sum(l.loan_amount) AS "Pobrano" ,sum(l.loan_to_pay) AS "Do zap³aty" FROM bank_accound AS b INNER JOIN credit_card AS c ON b.iban_number_id =c.accound_id 
--INNER JOIN loans AS l ON c.credit_card_number =l.card_id GROUP BY b.iban_number_id);
















--SELECT transfer('PL30391685669270719353165121','123456ab','PL49391685669205888083479003',50000::float8::NUMERIC::money,'1853354904290518','1727');


--SELECT take_loan('PL30391685669270719353165121','123456ab','8419399838472612','5278',2,50000::float8::NUMERIC::money,'5 year'::interval);

--SELECT insert_user('11111','aaaaaab','aaaa','aaaa',(now()-INTERVAL '7 year')::date,'aaaaaaaaabb',
--'aaaaa','aaaaa','aaaaaa','aaaa','aaa','aaaaa','aaaaa','aaaaaa','aaaa','aaa');

--SELECT insert_accound(2,'individual','123456ab');

--SELECT add_card('PL30391685669270719353165121','123456ab',false,2);