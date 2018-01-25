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
