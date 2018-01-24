-- usage:
-- mysql -u dbuser -p task5 < task5.sql
-- echo "select * from arrangement" | mysql -u dbuser task5

drop database if exists task5;
create database task5;
use task5;

drop table if exists task5.participant;
create table if not exists task5.participant
(
    pID int NOT NULL,
    pFname varchar(15),
    pLname varchar(15),
    primary key(pID)
);

drop table if exists task5.arrangement;
create table if not exists task5.arrangement
(
    arrID int NOT NULL,
    arrName varchar(25),
    arrTime date,
    arrSpaces int,
    primary key(arrID)
);

drop table if exists task5.tickets;
create table if not exists task5.tickets
(
    pID int NOT NULL,
    arrID int NOT NULL,
    ticketType char(1),
    primary key(pID,arrID),
    foreign key (pID) references task5.participant (pID),
    foreign key (arrID) references task5.arrangement (arrID)
);


-- make procedure takeSeat
