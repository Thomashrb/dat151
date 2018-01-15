use uni;

create table if not exists uni.student
(
    sname varchar not null,
    snr int not null,
    ssn int,
    brn int,
    addr varchar,
    addr2 varchar,
    tlf int,
    fcode varchar,
    s_program varchar,
    level varchar,
    primary key(sname)
    constraint fcode_fkey
	foreign key(fname) references faculty(fname)
	on delete cascade
	on update no action
);

create table if not exists uni.faculty
(
    fname varchar not null,
    fin varchar not null,
    tfl int,
    addr int,
    primary key(fname,fin)
);

create table if not exists uni.course_schedule
(
    cname varchar not null,
    ccode varchar,
    hours float,
    fname varchar,
    professor varchar,
    snr int,
    grade varchar(1),
    cyear int,
    primary key(cname),
    constraint fcode_fkey
	foreign key(fname) references faculty(fname)
	on delete cascade
	on update no action,
    constraint snr_fkey
	foreign key(snr) references student(snr)
	on delete cascade
	on update no action
);
