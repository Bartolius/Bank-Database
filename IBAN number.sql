CREATE OR REPLACE FUNCTION card_number()
--wartoœæ zwracana przez funkcjê
RETURNS varchar(9)

--cia³o funkcji
AS $$

--zadeklarowanie zmiennych
DECLARE
	letter_var varchar(9);
	check_value int;
BEGIN
	--utworzenie chwilowych tableli 
	CREATE TEMP TABLE lettertable(letter varchar(1),value int PRIMARY key);
	INSERT INTO lettertable(letter,value) VALUES ('0',0),('1',1),('2',2),('3',3),('4',4),('5',5),
		('6',6),('7',7),('8',8),('9',9),('A',10),('B',11),('C',12),('D',13),('E',14),('F',15),
		('G',16),('H',17),('I',18),('J',19),('K',20),('L',21),('M',22),('N',23),('O',24),('P',25),
		('Q',26),('R',27),('S',28),('T',29),('U',30),('V',31),('W',32),('X',33),('Y',34),('Z',35);
	
	CREATE TEMP TABLE card_letter(id int PRIMARY KEY,value int);
	ALTER TABLE card_letter ADD CONSTRAINT card_fkey FOREIGN KEY (value) REFERENCES lettertable(value);

	--wpisanie losowych liter w pola 1-3 i losowych cyfr w pola 5-9
	for i IN 1..9
	LOOP
		CASE i 
		WHEN 1,2,3 THEN
			INSERT INTO card_letter(id,value) VALUES (i,(floor(random()*26)+10)::NUMERIC::integer);
		WHEN 5,6,7,8,9 then
			INSERT INTO card_letter(id,value) VALUES (i,floor(random()*10)::NUMERIC::integer);
		ELSE
		PERFORM '';
		END CASE;
	END LOOP;

	--obliczenie wartoœci sprawdzaj¹cej
	check_value = 
	(
		7*(SELECT value FROM card_letter WHERE id=1)+
		3*(SELECT value FROM card_letter WHERE id=2)+
		1*(SELECT value FROM card_letter WHERE id=3)+
		7*(SELECT value FROM card_letter WHERE id=5)+
		3*(SELECT value FROM card_letter WHERE id=6)+
		1*(SELECT value FROM card_letter WHERE id=7)+
		7*(SELECT value FROM card_letter WHERE id=8)+
		3*(SELECT value FROM card_letter WHERE id=9)
	)%10;
	--wstawienie wartoœci sprawdzaj¹cej w pole 4
	INSERT INTO card_letter(id,value) VALUES (4,check_value);

	--przesuniêcie rekordów 5-9 na miejsca po rekordzie z wartoœci¹ sprawdzaj¹c¹
	for i IN 5..9
	LOOP
		UPDATE card_letter SET id=i WHERE id=i;
	END LOOP;

	--wstawienie do zmiennej letter_var 'sklejonej' wartoœci czêœci peselu
	SELECT string_agg(l.letter,'') INTO letter_var FROM lettertable AS l RIGHT JOIN card_letter AS p ON l.value=p.value;

	--usuniêcie chwilowych tabel
	DROP TABLE card_letter;
	DROP TABLE lettertable;
	
	--zwrócenie wartoœci
    RETURN letter_var;
END;
--jêzyk funkcji
$$ LANGUAGE plpgsql;





CREATE OR REPLACE FUNCTION IBAN_number(country varchar(2),bank_ID varchar(8))
--wartoœæ zwracana przez funkcjê
RETURNS varchar(28)

--cia³o funkcji
AS $$

--zadeklarowanie zmiennych
DECLARE
	letter_var varchar(28);
	check_value int;
	number_val int DEFAULT 0;
	rest_val int DEFAULT 0;
BEGIN
	
	--utworzenie chwilowych tableli 
	CREATE TEMP TABLE lettertable(letter varchar(1),value int PRIMARY key);
	INSERT INTO lettertable(letter,value) VALUES ('0',0),('1',1),('2',2),('3',3),('4',4),('5',5),
		('6',6),('7',7),('8',8),('9',9),('A',10),('B',11),('C',12),('D',13),('E',14),('F',15),
		('G',16),('H',17),('I',18),('J',19),('K',20),('L',21),('M',22),('N',23),('O',24),('P',25),
		('Q',26),('R',27),('S',28),('T',29),('U',30),('V',31),('W',32),('X',33),('Y',34),('Z',35);
	
	CREATE TEMP TABLE pesel_letter(id int PRIMARY KEY,value int);
	ALTER TABLE pesel_letter ADD CONSTRAINT pesel_fkey FOREIGN KEY (value) REFERENCES lettertable(value);

	--wstawienie wartoœci znaków pola kraj do tabeli
	INSERT INTO pesel_letter(id,value) SELECT 1,value FROM lettertable WHERE letter=substr(country, 1, 1);
	INSERT INTO pesel_letter(id,value) SELECT 2,value FROM lettertable WHERE letter=substr(country, 2, 1);

	--wstawienie w pola 5-12 podzielonego numeru identyfikacyjnego banku
	FOR i IN 5..12
	LOOP
		INSERT INTO pesel_letter(id,value) SELECT i,value FROM lettertable WHERE letter=substr(bank_ID, i-4, 1);
	END LOOP;
	
	--wstawienie 16 losowych cyfr
	FOR i IN 13..28
	LOOP
		INSERT INTO pesel_letter(id,value) VALUES (i,floor(random()*10)::NUMERIC::integer);
	END LOOP;

	--wyliczenie modulo z ca³ej liczby(numer identyfikacyjny|losowe cyfry|kraj przerobiony na cyfry|00)
	FOR i IN 1..28
	LOOP
		IF i<25
		THEN
			rest_val=(rest_val*10+(SELECT value FROM pesel_letter WHERE id=i+4))%97;
		ELSIF i=25 OR i=26 THEN
			rest_val=(rest_val*100+(SELECT value FROM pesel_letter WHERE id=i-24))%97;
		ELSIF i>26 THEN
			rest_val=(rest_val*10)%97;
		END IF;
	END LOOP;
	
	--wyliczenie liczby sprawdzaj¹cej
	number_val=97-rest_val+1;
	
	--wpisanie liczby do tabeli na miejsce 3 i 4
	IF number_val<10
	THEN
		INSERT INTO pesel_letter(id,value) values(3,0);
		INSERT INTO pesel_letter(id,value) values(4,number_val);
	ELSE
		INSERT INTO pesel_letter(id,value) values(3,(number_val-number_val%10)/10);
		INSERT INTO pesel_letter(id,value) values(4,number_val%10);
	END IF;

	--przesuniêcie wszystkich rekordów od 5 do 28 poni¿ej numeru sprawdzaj¹cego
	for i IN 5..28
	LOOP
		UPDATE pesel_letter SET id=i WHERE id=i;
	END LOOP;

	--wstawenie po³¹czonego wyniku do letter_var
	SELECT string_agg(l.letter,'') INTO letter_var FROM lettertable AS l RIGHT JOIN pesel_letter AS p ON l.value=p.value;
	
	--usuniêcie chwilowych tabel
	DROP TABLE pesel_letter;
	DROP TABLE lettertable;

	--zwrócenie wartoœci
	RETURN letter_var;
END;
--jêzyk funkcji
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION c_credit_card_number()
--wartoœæ zwracana przez funkcjê
RETURNS varchar(16)

--cia³o funkcji
AS $$

--zadeklarowanie zmiennych
DECLARE
	c_number varchar(16) DEFAULT '';
BEGIN
	
	--pêtla 'do while'
	LOOP
		c_number='';
		FOR i IN 1..16
		LOOP 
			c_number=concat(c_number,(floor(random()*10))::varchar);
		END LOOP;
	
		--warunek koñcz¹cy pêtle
		EXIT WHEN (SELECT count(*) FROM credit_card WHERE credit_card_number=c_number)<1;
	END LOOP;
	

	--zwrócenie wartoœci
	RETURN c_number;
END;
--jêzyk funkcji
$$ LANGUAGE plpgsql;


















SELECT IBAN_number('PL','39168566');





















--SELECT c_credit_card_number();
--
--SELECT card_number();
--