-- mysql -u <dbuser> -p tolldb < task2.sql
DROP database if EXISTS tolldb;
CREATE database tolldb;
use tolldb;

DROP TABLE IF EXISTS tolldb.tollstation;
CREATE TABLE IF NOT EXISTS tolldb.tollstation
(
    id INT NOT NULL,
    tname VARCHAR(20),
    PRIMARY KEY(id)
);

DROP TABLE IF EXISTS tolldb.car;
CREATE TABLE IF NOT EXISTS tolldb.car
(
    regno CHAR(7) NOT NULL,
    oname VARCHAR(20),
    PRIMARY KEY(regno)
);

drop table if exists tolldb.subscriptionType;
create table if not exists tolldb.subscriptionType
(
    id INT NOT NULL,
    sname VARCHAR(20),
    cost_per_passing INT,
    primary key(id)
);

DROP TABLE IF EXISTS tolldb.passing;
CREATE TABLE if NOT EXISTS tolldb.passing
(
    regno CHAR(7) NOT NULL,
    time_stamp TIMESTAMP(6) DEFAULT CURRENT_TIMESTAMP,
    tollstationID INT,
    PRIMARY KEY(regno,time_stamp),
    FOREIGN KEY (regno) REFERENCES tolldb.car (regno),
    FOREIGN KEY (tollstationID) REFERENCES tolldb.tollstation (id)
);

DROP TABLE IF EXISTS tolldb.subscription;
CREATE TABLE IF NOT EXISTS tolldb.subscription
(
    regno CHAR(7) NOT NULL,
    typeid INT NOT NULL,
    PRIMARY KEY(regno),
    FOREIGN KEY (regno) REFERENCES tolldb.car (regno),
    FOREIGN KEY (typeid) REFERENCES tolldb.subscriptionType (id)
);

insert into tollstation (id,tname) values
(0,'Arna'),
(1,'Bergen'),
(2,'Chile'),
(3,'Dale'),
(4,'Evanger'),
(5,'Fjosanger'),
(6,'Geiranger'),
(7,'Hylkjo'),
(8,'Igesund'),
(9,'Jamtland');

insert into subscriptionType (id,sname,cost_per_passing) values
(0,'Freeloader Rich Guy',10),
(1,'Expert',20),
(2,'Intermediate',30),
(3,'Amateur',40),
(4,'Novice',50),
(5,'Beginner',60);

DELIMITER $$
CREATE PROCEDURE prepare_carandsubscription()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE reg CHAR(7) DEFAULT 'KH00000';
  WHILE i < 3001 DO
    INSERT INTO  tolldb.car (regno,oname) VALUES (reg,'Olsen');
    INSERT INTO  tolldb.subscription (regno,typeid) VALUES (reg, FLOOR( RAND() * 5));
    SET reg = CONCAT('KH' ,LPAD(i,5,'0'));
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE prepare_passing()
BEGIN
  DECLARE i INT DEFAULT 1;
  DECLARE limited INT DEFAULT 2;
  DECLARE reg CHAR(7) DEFAULT 'KH00000';
  WHILE i < 100001 DO
    INSERT INTO  tolldb.passing (regno, tollstationID) VALUES (reg, FLOOR( RAND() * 9));
    SET reg = CONCAT('KH' ,LPAD(limited,5,'0'));
    SET limited = MOD(i,3000);
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

-- Takes too long to run automaticly
-- CALL prepare_carandsubscription();
-- CALL prepare_passing();

-- SELECT routine_definition
-- FROM information_schema.routines
-- WHERE
-- routine_name = 'prepare_carandsubscription' AND routine_schema = 'tolldb';

--set profiling = 1;
--run query
--show profiles;
--explain
