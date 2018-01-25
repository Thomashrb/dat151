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
