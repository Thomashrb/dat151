use pendantdelete;

drop table if exists pendantdelete.onetable;
create table if not exists pendantdelete.onetable
(
    M_ID int NOT NULL AUTO_INCREMENT,
    NM varchar(8),
    primary key(M_ID)
);

drop table if exists pendantdelete.manytable;
create table if not exists pendantdelete.manytable
(
    ID int NOT NULL AUTO_INCREMENT,
    O_ID int NOT NULL,
    NM varchar(8),
    primary key(ID),
    constraint ID_fk foreign key (O_ID) references pendantdelete.onetable (M_ID)
);

DROP TRIGGER IF EXISTS pdel;
-- make trigger
DELIMITER $$
CREATE TRIGGER pdel
AFTER DELETE
   ON pendantdelete.manytable FOR EACH ROW
BEGIN
   IF NOT EXISTS (SELECT 1 FROM pendantdelete.manytable where O_ID  = OLD.O_ID)
   THEN
     DELETE FROM pendantdelete.onetable where M_ID = OLD.O_ID;
   END IF;
END$$
DELIMITER ;

--inserts
insert into onetable(NM) values("Zeta");
insert into onetable(NM) values("Zeeke");
insert into onetable(NM) values("Zoork");

insert into manytable(O_ID,NM) values(1,"Alice");
insert into manytable(O_ID,NM) values(1,"Bob");
insert into manytable(O_ID,NM) values(2,"Charlie");
insert into manytable(O_ID,NM) values(2,"Dale");
insert into manytable(O_ID,NM) values(3,"Eeroy");
