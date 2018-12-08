create database studentLeaveSystem
on(
name='studentLeaveSystem',
filename='D:\MyDB\studentLeaveSystem.mdf',
size=5mb
)
go
use studentLeaveSystem
go
create table Roles--��ɫ��
(
RoleId int primary key identity(1,1),
RoleName nvarchar(50) not null,--��ɫ��
)
go
insert into Roles values('ѧ������')
insert into Roles values('������')
insert into Roles values('����Ա')
go
--select *from Roles
go
create table Admins--����Ա��
(
 Aid int primary key identity(1,1),
 AdminName nvarchar(50) not null,--����Ա����
 AdminPwd nvarchar(50) not null,--����Ա���� 
 RoleId int foreign key references Roles(RoleId)
)
go
update Admins set AdminPwd='12345' where AdminName='5'
go
insert into Admins values('������','123456',3)
insert into Admins values('����','123456',1)
--select * from Admins
go
create table Gnb--���ܱ�
(
  GnId int  primary key identity(1,1),
  GnName nvarchar(50) not null,--��������
)
go
insert into Gnb values('Left')
insert into Gnb values('Left1')
go
create table Qxb--Ȩ�ޱ�
(
  Qid int primary key identity(1,1),
  RoleId int foreign key references Roles(RoleId),
  GnId int foreign key references Gnb(GnId)
)
go
insert into Qxb values(1,2)
insert into Qxb values(2,2)
insert into Qxb values(3,1)

--select * from Admins,Roles,Qxb,Gnb where 
Admins.RoleId=Roles.RoleId and Qxb.GnId=Gnb.GnId and Roles.RoleId=Qxb.RoleId  
go
create table Grade--�꼶�����
(
Gid int primary key identity(1,1),
GNum nvarchar(20),--������
)

go
--select * from Grade
go
create table Class --�༶��
(
Cid int primary key identity(1,1),
CName nvarchar(50),--�꼶��
Gid int foreign key references Grade(Gid)--����
)
--GO
--select GNum,CName from Grade,Class where Grade.Gid=Class.Gid and Class.Gid=1 and Cid=1
go
create table Student--ѧ����
(
  StuId int primary key identity(1,1),
  StuNum nvarchar(50) not null,--ѧ��
  StuName nvarchar(50) not null,--����
  Phone nvarchar(30) not null,--�ֻ���
  Gid int foreign key references  Grade(Gid),--����
  Cid int foreign key references  Class(Cid),--�༶
)

--select * from Student,Grade,Class where Student.Cid=Class.Cid  and Grade.Gid=Class.Cid
go
create table LeaveInfo--�����Ϣ��
(
Lid int primary key identity(1,1),
StuNum nvarchar(50) not null,--ѧ��,
StuName nvarchar(50) not null,--����
Phone nvarchar(30) not null,--�ֻ���
GNum nvarchar(20) not null,--����
CName nvarchar(20) not null,--�༶
BeginDate date not null,--��ʼʱ��
EndDate date not null,--����ʱ��
Addresss nvarchar(50) not null,--�ص�
Reason nvarchar(200) not null,--ԭ��
Principal nvarchar(10) not null,--������
Statu int ,--״̬
)

--select top 0 * from LeaveInfo where Lid not in
--(select top 0  Lid from LeaveInfo)
--update LeaveInfo set Statu=1 where StuNum='41916078'

--select top 5 Lid, StuNum,StuName,Phone,GNum,CName,Date(date,BeginDate,23) BeginDate,
--CONVERT(varchar(100),EndDate,23) EndDate,Addresss,Reason,Principal,Statu
--from LeaveInfo where Lid not in(select top ((0*5)) Lid from LeaveInfo)

--select top 5 StuNum,StuName,Phone,GNum,CName
-- from Student,Grade,Class  where StuId not in(select top (1*5) Student.StuId from Student) and
-- Student.Gid=Grade.Gid and Grade.Gid=Class.Cid

select count(*) total from LeaveInfo where DateDiff(dd,BeginDate,getdate())=0

select *
from LeaveInfo where DateDiff(dd,BeginDate,getdate())=0 


--select top 5 *  from LeaveInfo where Lid not in
--(select top (1) Lid from LeaveInfo where  DateDiff(dd,BeginDate,getdate())=0 and GNum='2015' and CName='NET1') 
--and DateDiff(dd,BeginDate,getdate())=0 and GNum='2015' and CName='NET1'

--(select count(*) from LeaveInfo where DateDiff(dd,BeginDate,getdate())=1 ) zt,
--(select count(*) from LeaveInfo where DateDiff(dd,BeginDate,getdate())<=7 ) bz,
--(select count(*) from LeaveInfo where DateDiff(mm,BeginDate,getdate())=0 ) byue


select count(*)  from LeaveInfo where DateDiff(dd,BeginDate,getdate())=0 --����

select count(*) from LeaveInfo where DateDiff(dd,BeginDate,getdate())=1--����
select count(*) from LeaveInfo where DateDiff(dd,BeginDate,getdate())<=7--7���ڵ���������
select count(*) from LeaveInfo where DateDiff(dd,BeginDate,getdate())<=30--30���ڵ���������
select count(*) from LeaveInfo where DateDiff(mm,BeginDate,getdate())=0--����
select count(*) from LeaveInfo where DateDiff(yy,BeginDate,getdate())=0--����

--select  a.CName,a.GNum from (select *  from LeaveInfo where DateDiff(dd,BeginDate,getdate())=0 ) as a,
--(select *  from LeaveInfo where DateDiff(dd,BeginDate,getdate())=1 ) b,LeaveInfo 
--WHERE a.GNum=LeaveInfo.GNum  and b.GNum=a.GNum

SELECT A.CName AS �༶����, A.GNum AS �꼶,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum AND B.[Statu] = 1
        AND B.BeginDate >= DATEADD(DD,DATEDIFF(DD,0,GETDATE()),0) 
        AND B.EndDate < DATEADD(DD,DATEDIFF(DD,0,GETDATE()),1)) AS �������,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum AND B.[Statu] <= 1 
        AND B.BeginDate >= DATEADD(DD,DATEDIFF(DD,0,GETDATE()),-1) 
        AND B.EndDate < DATEADD(DD,DATEDIFF(DD,0,GETDATE()),0)) AS �������,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum AND B.[Statu] = 1 
        AND B.BeginDate >= DATEADD(WK,DATEDIFF(WK,0,GETDATE()),0) 
        AND B.EndDate < DATEADD(WK,DATEDIFF(WK,0,GETDATE()),7)) AS �������,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum AND B.[Statu] = 1 
        AND B.BeginDate >= DATEADD(MM,DATEDIFF(MM,0,GETDATE()),0) 
        AND B.EndDate < DATEADD(MM,DATEDIFF(MM,0,GETDATE()) + 1,0)) AS �������
FROM [dbo].[LeaveInfo] AS A 
GROUP BY A.CName, A.GNum

SELECT A.CName AS �༶����, A.GNum AS �꼶,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum 
        AND DateDiff(dd,BeginDate,getdate())=0) AS �������,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum 
         
        AND DateDiff(dd,BeginDate,getdate())=1) AS �������,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum 
        
        AND DateDiff(dd,BeginDate,getdate())<=7) AS �������,
    (SELECT COUNT(*) FROM [dbo].[LeaveInfo] AS B 
      WHERE B.CName = A.CName AND B.GNum = A.GNum 
        AND B.BeginDate >= DATEADD(MM,DATEDIFF(MM,0,GETDATE()),0) 
        AND B.EndDate < DATEADD(MM,DATEDIFF(MM,0,GETDATE()) + 1,0)) AS �������
FROM [dbo].[LeaveInfo] AS A 
GROUP BY A.CName, A.GNum
 
 select count(*) xjTotal from LeaveInfo where Statu=1

 
select count(*) xjTotal  from LeaveInfo where DateDiff(dd,EndDate,getdate())=1 and Statu=1
 --select CName,count(*) ����  from LeaveInfo where DateDiff(mm,BeginDate,getdate())=0 group by CName

