-- usage:
-- mysql -u dbuser -p task5 < task5.sql
-- echo "select * from arrangement" | mysql -u dbuser task5
--drop database if exists task5;
--create database task5;

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

insert into task5.arrangement (arrID,arrName,arrTime,arrSpaces) values
(1,'Ulriken down','2017-07-01 10:00:00',15000),
(2,'The 7-mountain hike','2017-05-23 09:00:00',32000),
(3,'Pink Floyd at Koengen','2017-06-16 08:00:00',25000),
(4,'AHA at Koengen','2017-08-05 07:00:00',23000),
(5,'Stolzekleiven opp','2017-09-12 10:00:00',50000),
(6,'Stolzekleiven opp','2017-09-12 10:00:00',50000),
(7,'Led Zeppelin at Koengen','2017-07-12 07:30:00',25000),
(8,'Bergen City Maraton','2017-05-12 08:00:00',78000),
(9,'Knarvikmila','2017-06-23 08:30:00',53000),
(10,'Lyderhorn opp','2017-08-12 09:00:00',34000),
(11,'Stones at Koengen','2017-06-13 09:00:00',24000),
(12,'Kygo at Brann Stadion','2017-07-15 10:20:00',21000);

-- tickets insert
INSERT INTO task5.tickets
SELECT pID, arrID, 'N'
FROM task5.allrow;

-- make procedure takeSeat
