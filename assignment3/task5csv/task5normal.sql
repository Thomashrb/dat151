-- usage:
-- mysql -u dbuser -p task5 < task5.sql
-- echo "select * from arrangement" | mysql -u dbuser task5
--drop database if exists task5;
--create database task5;

drop database if exists task5;
create database task5;
use task5;

drop table if exists task5.allrow;
create table if not exists task5.allrow
(
    arrID varchar(25),
    arrName varchar(25),
    arrTime varchar(25),
    arrSpaces varchar(25),
    pID varchar(25),
    pFname varchar(25),
    pLname varchar(25)
);

LOAD DATA LOCAL INFILE '/home/user/Git/dat151/assignment3/task5csv/data.csv'
INTO TABLE allrow
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\n'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
 (arrID, arrName, arrTime, arrSpaces, pID, pFname, pLname);


drop table if exists task5.person;
create table if not exists task5.person
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

drop table if exists task5.participant;
create table if not exists task5.participant
(
    pID int NOT NULL,
    arrID int NOT NULL,
    primary key(pID,arrID),
    foreign key (pID) references task5.person (pID),
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

INSERT INTO task5.person
SELECT DISTINCT pID, pFname, pLname
FROM task5.allrow;

-- participant insert
INSERT INTO task5.participant
SELECT pID, arrID
FROM task5.allrow;

-- make procedure takeSeat
