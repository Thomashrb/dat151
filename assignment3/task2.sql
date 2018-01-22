use teacher;

create table if not exists teacher.nums
(
    id int NOT NULL AUTO_INCREMENT,
    SALARY int not null,
    BONUS int not null,
    TOTAL int,
    primary key(id)
);

-- make trigger
DELIMITER $$
CREATE TRIGGER CALCULATE
BEFORE INSERT
   ON teacher.nums FOR EACH ROW
BEGIN
   if NEW.SALARY < 1000 or NEW.SALARY > 10000
   THEN
       signal sqlstate '45000' set message_text = 'bad number';
   ELSE
       SET NEW.TOTAL = NEW.SALARY + NEW.BONUS;
   END IF;
END$$
DELIMITER ;

-- add values
insert nums(salary,bonus) values(1000,1);
insert nums(salary,bonus) values(2000,2);
insert nums(salary,bonus) values(3000,3);
insert nums(salary,bonus) values(4000,1);
