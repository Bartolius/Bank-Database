INSERT INTO accound_type (type_name) VALUES 
('individual'),
('business');

INSERT INTO card_type (card_type ,interest) VALUES
('credit card',0.06),
('debit card',0.05),
('charge card',0.06);

INSERT INTO loan_type (loan_type_name,interest,monthly_loan_increase,max_loan) VALUES 
('credit card loan',0.07,0.02,25000.00::float8::NUMERIC::money),
('debit card loan',0.10,0.02,5000.00::float8::NUMERIC::money),
('consumptive loan',0.07,0.03,100000.00::float8::NUMERIC::money),
('mortgage loan',0.08,0.02,1000000.00::float8::NUMERIC::money),
('investment loan',0.06,0.04,250000000.00::float8::NUMERIC::money);

INSERT INTO personal_data (phone_number,email) VALUES
('907474933', 'MartaZieli�ska@gmail.com'),
('994457262', 'Kaja�uczak@gmail.com'),
('560137001', 'PaulinaSzewczyk@gmail.com'),
('519146568', 'JacekWi�niewski@gmail.com'),
('846156068', 'MarcelAndrzejewski@gmail.com'),
('573971320', 'MateuszSzyma�ski@gmail.com'),
('809953977', 'AlicjaSobolewska@gmail.com'),
('260275809', 'PatrycjaJasi�ska@gmail.com'),
('525733827', 'ZofiaMa�ecka@gmail.com'),
('842738468', 'MarcelGrzybowski@gmail.com'),
('391958170', 'FranciszekPaj�k@gmail.com'),
('810344592', 'AlicjaD�browska@gmail.com'),
('703222513', 'CecyliaKrawczyk@gmail.com'),
('464960883', 'ZofiaWr�blewska@gmail.com'),
('406439122', 'Micha�Stefaniak@gmail.com'),
('545686057', 'DominikMatusiak@gmail.com'),
('372858662', 'Milena�ak@gmail.com'),
('100857310', 'AdamLipi�ski@gmail.com'),
('787898185', 'JakubCzajka@gmail.com'),
('624837397', 'Miko�ajNowak@gmail.com'),
('439126372', 'BrunoDomaga�a@gmail.com'),
('404232397', 'NataliaZych@gmail.com'),
('511415227', 'KarolinaWo�niak@gmail.com'),
('853096099', 'BrunoStasiak@gmail.com'),
('354268708', 'FranciszekOlejniczak@gmail.com'),
('921320117', 'Ma�gorzataSzyma�ska@gmail.com'),
('746710468', 'ArturMilewski@gmail.com'),
('358159692', 'PiotrKowalik@gmail.com'),
('114999463', 'Oliwier�ak@gmail.com'),
('122069050', 'Stanis�awZieli�ski@gmail.com');


INSERT INTO id_card (card_id,first_name,last_name,birth_date,pesel,personal_data_id) VALUES
('XYM528255', 'Marta','Zieli�ska','04.06.1998',null,1),
('PBZ277656', 'Kaja','�uczak','09.04.1996',null,2),
('ZMH884244', 'Paulina','Szewczyk','21.10.1998',null,3),
('DCN475608', 'Jacek','Wi�niewski','07.08.1992',null,4),
('CCQ667272', 'Marcel','Andrzejewski','17.05.2002',null,5),
('YSB196386', 'Mateusz','Szyma�ski','01.03.1981',null,6),
('NPI078872', 'Alicja','Sobolewska','09.03.1981',null,7),
('LMS070675', 'Patrycja','Jasi�ska','21.10.1990',null,8),
('WBA037904', 'Zofia','Ma�ecka','09.08.1994',null,9),
('XWO711367', 'Marcel','Grzybowski','18.05.1991',null,10),
('LFV883860', 'Franciszek','Paj�k','12.01.2003',null,11),
('PAQ215508', 'Alicja','D�browska','04.09.2000',null,12),
('BTD051175', 'Cecylia','Krawczyk','08.05.1984',null,13),
('BBZ513721', 'Zofia','Wr�blewska','26.02.1996',null,14),
('KHB466657', 'Micha�','Stefaniak','31.03.2002',null,15),
('INL403117', 'Dominik','Matusiak','27.01.1987',null,16),
('TMG329674', 'Milena','�ak','26.11.1991',null,17),
('FUG270738', 'Adam','Lipi�ski','22.04.1997',null,18),
('CTA971714', 'Jakub','Czajka','18.05.1995',null,19),
('DCW046511', 'Miko�aj','Nowak','09.03.1986',null,20),
('QPO052095', 'Bruno','Domaga�a','02.06.1993',null,21),
('SWR344455', 'Natalia','Zych','07.07.1993',null,22),
('UKJ029022', 'Karolina','Wo�niak','21.10.1984',null,23),
('KBI064119', 'Bruno','Stasiak','27.06.1997',null,24),
('YBQ925942', 'Franciszek','Olejniczak','06.05.2010',null,25),
('VEA998023', 'Ma�gorzata','Szyma�ska','22.07.1993',null,26),
('GEJ901872', 'Artur','Milewski','05.06.1989',null,27),
('RNU699408', 'Piotr','Kowalik','11.11.1981',null,28),
('MLU799712', 'Oliwier','�ak','07.11.1985',null,29),
('YWT881356', 'Stanis�aw','Zieli�ski','05.03.2008',null,30);

--INSERT INTO address (card_id,type_of_address,province,town,post_code,street,home_number) VALUES ();

INSERT INTO bank_accound (iban_number_id,accound_type,balance,accound_pass) VALUES
('PL22391685668807517857858541',1,100000::money,md5('abcdef1234')),
('PL61391685661139670870659991',1,100000::money,md5('abcdef1234')),
('PL86391685665017113727070273',1,100000::money,md5('abcdef1234')),
('PL84391685660777665945133107',1,100000::money,md5('abcdef1234')),
('PL37391685660542045644365127',1,100000::money,md5('abcdef1234')),
('PL12391685667418164585804345',1,100000::money,md5('abcdef1234')),
('PL27391685667583925692289725',1,100000::money,md5('abcdef1234')),
('PL58391685669335921705477511',1,100000::money,md5('abcdef1234')),
('PL69391685669699718923533752',1,100000::money,md5('abcdef1234')),
('PL06391685665727049060366798',1,100000::money,md5('abcdef1234')),
('PL37391685669909107583627114',1,100000::money,md5('abcdef1234')),
('PL63391685662052097935961347',1,100000::money,md5('abcdef1234')),
('PL25391685664536367682637893',1,100000::money,md5('abcdef1234')),
('PL18391685666898449468492548',1,100000::money,md5('abcdef1234')),
('PL65391685660692647653267930',1,100000::money,md5('abcdef1234')),
('PL16391685665639325480177052',1,100000::money,md5('abcdef1234')),
('PL46391685661208112204100222',1,100000::money,md5('abcdef1234')),
('PL85391685664155912328181000',1,100000::money,md5('abcdef1234')),
('PL66391685666697876624938516',1,100000::money,md5('abcdef1234')),
('PL67391685668130358135535077',1,100000::money,md5('abcdef1234')),
('PL51391685663315375840670560',1,100000::money,md5('abcdef1234')),
('PL52391685668073802419177776',1,100000::money,md5('abcdef1234')),
('PL20391685662730261430762068',1,100000::money,md5('abcdef1234')),
('PL91391685665481967066449014',1,100000::money,md5('abcdef1234')),
('PL32391685662355288076521134',1,100000::money,md5('abcdef1234')),
('PL70391685667978712745138436',1,100000::money,md5('abcdef1234')),
('PL30391685665663547445796393',1,100000::money,md5('abcdef1234')),
('PL36391685665887604060403408',1,100000::money,md5('abcdef1234')),
('PL63391685660442300588461053',1,100000::money,md5('abcdef1234')),
('PL56391685669682635706297331',1,100000::money,md5('abcdef1234'));

INSERT INTO bank_accound_to_personal_data (accound_id,personal_data_id) VALUES
('PL22391685668807517857858541',1),
('PL61391685661139670870659991',2),
('PL86391685665017113727070273',3),
('PL84391685660777665945133107',4),
('PL37391685660542045644365127',5),
('PL12391685667418164585804345',6),
('PL27391685667583925692289725',7),
('PL58391685669335921705477511',8),
('PL69391685669699718923533752',9),
('PL06391685665727049060366798',10),
('PL37391685669909107583627114',11),
('PL63391685662052097935961347',12),
('PL25391685664536367682637893',13),
('PL18391685666898449468492548',14),
('PL65391685660692647653267930',15),
('PL16391685665639325480177052',16),
('PL46391685661208112204100222',17),
('PL85391685664155912328181000',18),
('PL66391685666697876624938516',19),
('PL67391685668130358135535077',20),
('PL51391685663315375840670560',21),
('PL52391685668073802419177776',22),
('PL20391685662730261430762068',23),
('PL91391685665481967066449014',24),
('PL32391685662355288076521134',25),
('PL70391685667978712745138436',26),
('PL30391685665663547445796393',27),
('PL36391685665887604060403408',28),
('PL63391685660442300588461053',29),
('PL56391685669682635706297331',30);

INSERT INTO credit_card (credit_card_number,accound_id,primary_card,card_pass,card_type) VALUES
('1307430725666209','PL22391685668807517857858541',TRUE,md5('1234'),2),
('7321578984909336','PL61391685661139670870659991',TRUE,md5('1234'),2),
('4742737106086490','PL86391685665017113727070273',TRUE,md5('1234'),2),
('1804624270503440','PL84391685660777665945133107',TRUE,md5('1234'),2),
('2025113243440705','PL37391685660542045644365127',TRUE,md5('1234'),2),
('8921475567455259','PL12391685667418164585804345',TRUE,md5('1234'),2),
('1993723924765053','PL27391685667583925692289725',TRUE,md5('1234'),2),
('9223327822563008','PL58391685669335921705477511',TRUE,md5('1234'),2),
('1064874058654447','PL69391685669699718923533752',TRUE,md5('1234'),2),
('3002933298683215','PL06391685665727049060366798',TRUE,md5('1234'),2),
('7620055842989781','PL37391685669909107583627114',TRUE,md5('1234'),2),
('5454292495550178','PL63391685662052097935961347',TRUE,md5('1234'),2),
('7393825289184798','PL25391685664536367682637893',TRUE,md5('1234'),2),
('8274218765002986','PL18391685666898449468492548',TRUE,md5('1234'),2),
('4924222170317780','PL65391685660692647653267930',TRUE,md5('1234'),2),
('3482520316566645','PL16391685665639325480177052',TRUE,md5('1234'),2),
('9079594849991013','PL46391685661208112204100222',TRUE,md5('1234'),2),
('5554211279274998','PL85391685664155912328181000',TRUE,md5('1234'),2),
('7305543228083938','PL66391685666697876624938516',TRUE,md5('1234'),2),
('5521410931559029','PL67391685668130358135535077',TRUE,md5('1234'),2);