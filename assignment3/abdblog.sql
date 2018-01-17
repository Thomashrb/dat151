use abdblog;

create table if not exists abdblog.A
(
    SSN int not null,
    POINTS int not null,
    primary key(SSN)
);

create table if not exists abdblog.B
(
    L_SSN int not null,
    L_POINTS int not null,
    primary key(L_SSN)
);

insert A(SSN,POINTS) values(1234,0);

-- make trigger
DELIMITER $$
CREATE TRIGGER LOG
BEFORE INSERT
   ON abdblog.A FOR EACH ROW
BEGIN
   INSERT INTO abdblog.B (L_SSN,L_POINTS)
   VALUES (NEW.SSN,NEW.POINTS);
END;
$$
DELIMITER ;

-- add values
--insert A(SSN,POINTS) values(4321,0);
