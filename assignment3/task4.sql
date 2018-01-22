use pendantdelete;

create table if not exists pendantdelete.T1
(
    ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(ID)
);

create table if not exists pendantdelete.T2
(
    ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(ID)
);

create table if not exists pendantdelete.T3
(
    ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(ID)
);


-- make trigger
DELIMITER $$
CREATE TRIGGER tr12
BEFORE INSERT
   ON pendantdelete.T1 FOR EACH ROW
BEGIN
     insert into T2(NM) values("fromT1");
END$$
DELIMITER ;
