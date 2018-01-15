use uni;

create table if not exists uni.student
(
    sname varchar(8) not null,
    snr int,
    ssn int,
    brn int,
    addr varchar(8),
    addr2 varchar(8),
    tlf int,
    fcode varchar(8),
    s_program varchar(8),
    level varchar(8),
    primary key(sname)
);

create table if not exists uni.faculty
(
    fname varchar(8) not null,
    fcode varchar(8) not null,
    tfl int,
    addr int,
    primary key(fname,fin)
    constraint fname_fkey
	       foreign key(fname) references course_schedule(fname)
	       on delete cascade
	       on update no action
);

create table if not exists uni.course_schedule
(
    cname varchar(8) not null,
    ccode varchar(8),
    hours float,
    fname varchar(8),
    professor varchar(8),
    snr int,
    grade varchar(1),
    cyear int,
    primary key(cname)
);
