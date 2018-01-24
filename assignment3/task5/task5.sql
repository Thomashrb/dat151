-- usage:
-- mysql -u dbuser -p pendantdelete < task5.sql
-- echo "select * from arrangement" | mysql -u dbuser task5

drop database if exists task5;
create database task5;
use task5;

--NORMALIZED
drop table if exists task5.participant;
create table if not exists task5.participant
(
    pID int NOT NULL,
    pFname varchar(22),
    pLname varchar(22),
    primary key(pID)
);

drop table if exists task5.arrangement;
create table if not exists task5.arrangement
(
    arrID int NOT NULL,
    arrName varchar(22),
    arrTime date,
    arrSpaces int,
    primary key(arrID)
);

drop table if exists task5.tickets;
create table if not exists task5.tickets
(
    pID int NOT NULL,
    arrID int NOT NULL,
    numTickets int,
    primary key(pID,arrID),
    foreign key (pID) references task5.participant (pID),
    foreign key (arrID) references task5.arrangement (arrID)
);


-- DENORMALIZED TO MAKE pId and arrID reside in same table
-- drop table if exists task5.participant;
-- create table if not exists task5.participant
-- (
--     pID int NOT NULL AUTO_INCREMENT,
--     pFname varchar(8),
--     pLname varchar(8),
--     primary key(pID)
-- );

-- drop table if exists task5.arrangement;
-- create table if not exists task5.arrangement
-- (
--     arrID int NOT NULL AUTO_INCREMENT,
--     arrName varchar(8),
--     arrTime date,
--     arrSpaces int,
--     pID int NOT NULL,
--     primary key(arrID),
--     constraint pID_fk foreign key (pID) references task5.participant (pID)
-- );

-- make procedure takeSeat
