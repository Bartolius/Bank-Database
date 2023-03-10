CREATE SCHEMA IF NOT EXISTS Bank;

CREATE USER Manager WITH LOGIN SUPERUSER PASSWORD 'db_manager';

CREATE ROLE Programer WITH LOGIN PASSWORD 'db_programer';
GRANT ALL ON ALL TABLES IN SCHEMA Bank TO Programer;
REVOKE UPDATE ,Delete ON TABLE transaction_history FROM Programer;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA Bank TO Programer;

CREATE ROLE Db_user WITH LOGIN PASSWORD 'db_user';
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA Bank TO Db_user;
REVOKE UPDATE ,Delete  ON TABLE transaction_history FROM Db_user;

DROP SCHEMA Bank CASCADE;