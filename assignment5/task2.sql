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
    sname INT,
    cost_per_passing INT,
    primary key(id)
);

DROP TABLE IF EXISTS tolldb.passing;
CREATE TABLE if NOT EXISTS tolldb.passing
(
    regno CHAR(7) NOT NULL,
    time_stamp TIMESTAMP NOT NULL,
    tollstationID INT,
    PRIMARY KEY(regno,time_stamp),
    FOREIGN KEY (tollstationID) REFERENCES tolldb.tollstation (id),
    FOREIGN KEY (regno) REFERENCES tolldb.car (regno)
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
