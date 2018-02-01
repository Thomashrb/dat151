use threetabs;

create table if not exists threetabs.T1
(
    ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(ID)
);

create table if not exists threetabs.T2
(
    ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(ID)
);

create table if not exists threetabs.T3
(
    ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(ID)
);


-- make trigger
DELIMITER $$
CREATE TRIGGER tr12
BEFORE INSERT
   ON threetabs.T1 FOR EACH ROW
BEGIN
     insert into T2(NM) values("fromT1");
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tr23
AFTER INSERT
   ON threetabs.T2 FOR EACH ROW
BEGIN
     insert into T3(NM) values("fromT2");
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER tr13
AFTER INSERT
   ON threetabs.T1 FOR EACH ROW
BEGIN
     insert into T3(NM) values("fromT3");
END$$
DELIMITER ;

-- add values
insert T1(NM) values("Alice");
insert T1(NM) values("Bob");
insert T1(NM) values("Charlie");
insert T1(NM) values("Dale");
insert T1(NM) values("Eric");
insert T1(NM) values("Fred");
insert T1(NM) values("Garry");
insert T1(NM) values("Harry");
insert T1(NM) values("Ingolf");
insert T1(NM) values("John");
