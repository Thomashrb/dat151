use abdb;

create table if not exists abdb.A
(
    SSN int not null,
    POINTS int not null,
    primary key(SSN)
);

create table if not exists abdb.B
(
    UD_COUNT int
);

-- add values
insert  B(UD_COUNT) values(0);
insert A(SSN,POINTS) values(1234,0);
insert A(SSN,POINTS) values(4321,0);

-- make trigger
DELIMITER $$
CREATE TRIGGER INCREMENT
BEFORE UPDATE
   ON abdb.A FOR EACH ROW
BEGIN
   UPDATE abdb.B
   SET UD_COUNT = UD_COUNT + 1;
END;
$$
DELIMITER ;
