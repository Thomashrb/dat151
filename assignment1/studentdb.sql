use uni;

create table if not exists uni.course_schedule
(
    CCODE varchar(8) not null,
    CYEAR varchar(8) not null,
    TEACHER varchar(8),
    primary key(CCODE,CYEAR)
);

create table if not exists uni.grades
(
    CCODE varchar(8) not null,
    SNR int not null,
    grade varchar(1),
    primary key(CCODE)
);

create table if not exists uni.faculty
(
    FCODE varchar(8) not null,
    FNAME varchar(8) not null,
    TLF int,
    ADDR int,
    primary key(FCODE)
);

create table if not exists uni.course_enrollment
(
    BIRTH_NUMBER int  not null,
    CCODE varchar(8),
    CYEAR int,
    primary key(BIRTH_NUMBER),
    constraint CCODE_fk foreign key (CCODE)
    references course_schedule(CCODE)
);

create table if not exists uni.student
(
    SNR int not null,
    SNAME varchar(8),
    BIRTH_NUMBER int not null,
    ADDR varchar(8),
    ADDR2 varchar(8),
    TLF int,
    SEX varchar(1),
    SYEAR int,
    primary key(SNR),
    constraint BIRTH_NUMBER_fk foreign key (BIRTH_NUMBER)
    references course_enrollment(BIRTH_NUMBER)
);

create table if not exists uni.study_program
(
    SP_ID varchar(8) not null,
    SP_NAME varchar(8),
    STUDY_LEVEL float,
    FCODE varchar(8) not null,
    primary key (SP_ID),
    constraint FCODE_fk foreign key (FCODE)
    references faculty(FCODE)
);

create table if not exists uni.course
(
    CCODE varchar(8) not null,
    CNAME varchar(8),
    HOURS float,
    SP_ID varchar(8) not null,
    primary key(CCODE),
    constraint SP_ID_fk foreign key (SP_ID)
    references study_program(SP_ID)
);
