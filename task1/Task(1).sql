Create Database Task1


use Task1


create Table Employee(
  ID int primary key ,
  BDate Date,
  Gender char(1) check(Gender='m'or Gender= 'f'),
  FName nvarchar(150) Not null,
  LName nvarchar(150) Not null,
  DNum int,
  Super_SSN int,
  foreign key (Super_SSN) references Employee(ID)
  ON DELETE NO ACTION  
  ON UPDATE NO ACTION
)

create table Department(
  DNum int primary key identity(100,10),
  DName varchar(150) Not null,
  ESSN int ,
  foreign key (ESSN) references Employee(ID)
  on delete set null
  on update cascade
)

create table Hiring_Date(
  ESSN int,
  foreign key (ESSN) references Employee(ID) on delete cascade on update cascade,
  DNum int ,
  foreign key (DNum) references Department(DNum) on delete no action on update no action,
  primary key (ESSN, DNum),
  HireDate DateTime default GetDate()
)

create table DLocations(
  Dlocation nvarchar(50) ,
  DNum int ,
  foreign key (DNum) references Department(DNum) on delete no action on update no action,
  primary key (Dlocation,DNum)
)

create table Dependant(
  DName nvarchar(150) not null,
  Gender char(1) check(Gender='m' or Gender='f'),
  BDate Date not null,
  ESSN int,
  foreign key (ESSN) references Employee(ID) on delete cascade on update cascade,
  primary key (DName,ESSN)
)

create table project(
  PNum int primary key not null,
  PName varchar(150) not null,
  PLocation_City nvarchar(150),
  DNum int,
  foreign key (DNum) references Department(DNum) on delete no action on update no action,
)

create table Emp_Project(
  ESSN int,
  foreign key (ESSN) references Employee(ID) on delete no action on update no action,
  PNum int ,
  foreign key (PNum) references project(PNum) on delete no action on update no action,
  primary key (ESSN, PNum),
  Work_hour int 
)

Alter table employee
add foreign key(DNum) references Department(DNum) 


insert into Department (DName)
values('IT'),
      ('security'),
      ('sales'),
      ('SW'),
      ('HR'),
      ('Finance'),
      ('Marketing'),
      ('Operations')



insert into Employee(ID,BDate,Gender,FName,LName,DNum,Super_SSN)
values(384658,'04-28-1990','M','Ahmad','Ebrahem',110,null),
      (847649,'02-14-2000','F','Nada','Mohamed',100,null),
      (847574,null,'M','adel','kamal',110,384658),
      (487589,'01-10-1999','M','amr','mohamed',120,null),
      (498586,'09-05-2001',null,'mohamed','ramzy',120,487589),
      (234678,'06-29-2003','f','mona','ahmad',100,847649),
      (847394, '1990-01-01', 'M', 'Ahmed', 'Ali', 100, 847649),
      (048603, '1988-05-12', 'F', 'Sara', 'Hassan', 110, 384658),
      (784343, '1992-07-30', 'M', 'Mohamed', 'Ibrahim', 120, 487589),
      (549045, '1995-03-21', 'F', 'Nour', 'Khaled', 130, null),
      (549046, '1991-11-11', 'M', 'Omar', 'Sami', 140, null),
      (549047, '1996-06-06', 'F', 'Laila', 'Adel', 100, 847649),
      (549048, '1993-09-15', 'M', 'Kareem', 'Youssef', 110, 384658),
      (549049, '1994-10-20', 'F', 'Dina', 'Mahmoud', 120, 487589),
      (549050, '1997-02-18', 'M', 'Hassan', 'Saad', 130, 549045),
      (549051, '1998-12-12', 'F', 'Mona', 'Nabil', 140, 549046);


update Department
set ESSN = 847649
where DNum = 100

update Department
set ESSN = 384658
where DNum = 110

update Department
set ESSN = 487589
where DNum = 120

update Department
set ESSN = 549045
where DNum = 130

update Department
set ESSN = 549046
where DNum = 140

insert into Hiring_Date (ESSN, DNum, HireDate)
values 
(847394, 100, '2015-01-01'),
(847649, 100, '2018-02-03'),
(384658, 110, '2014-03-21'),
(549048, 110, '2017-06-11'),
(784343, 120, '2016-07-19'),
(549049, 120, '2019-01-25'),
(549045, 130, '2015-04-10'),
(549050, 130, '2020-08-15'),
(549051, 140, '2013-09-09'),
(549046, 140, '2021-10-10');

insert into DLocations (Dlocation, DNum)
values 
('Cairo HQ', 100),
('Alex Branch', 100),
('Giza', 110),
('Tanta', 120),
('Mansoura', 130),
('Aswan', 140);

INSERT INTO Project (PNum, PName,PLocation_City, DNum)
VALUES
(1,'Website Redesign', 'Cairo', 100),
(2,'Recruitment Drive', 'Alexandria', 110),
(3,'Budget Planning', 'Cairo', 120),
(4,'Marketing Campaign', 'Giza', 130),
(5,'Logistics Setup', 'Aswan', 140);

insert into Emp_Project (ESSN, PNum, Work_hour)
values
(847649, 1, 30),
(234678, 1, 20),
(847394, 1, 50),
(549047, 1, 35),
(384658, 2, 40),
(847574, 2, 15),
(048603, 2, 25),
(549048, 2, 15),
(487589, 3, 25),
(498586, 3, 10),
(784343, 3, 30),
(549049, 3, 10),
(549045, 4, 35),
(549050, 4, 20),
(549046, 5, 50),
(549051, 5, 15);

Delete from Dependant
where ESSN =847649

select *
from Employee E inner join Department D
on D.DNum=E.DNum

select E.*,P.PName,P.PLocation_City,EP.Work_hour
from Employee E inner join Emp_Project EP
on E.ID=EP.ESSN
inner join project P
on EP.PNum=P.PNum