use AdventureWorksDW2019

 select FactCallCenterID, WageType,Shift,IssuesRaised,Date
 into tempscd
 from FactCallCenter

 select top 7 * into scd from tempscd

CREATE TABLE [dbo].[DimScd](

       [FactCallCenterID] [int] null,

       [WageType] [nvarchar](15) null,

	   [Shift] [nvarchar](20) Null,

       [IssuesRaised] [smallint] NULL,

       [Date] [datetime] NULL,

	   [EndDate][datetime] NULL,

	   [PriorShift][nvarchar](20) NULL
) 
GO

select * from scd
select * from DimScd


update scd set WageType='everyday' where FactCallCenterID=1
update scd set IssuesRaised=4 where FactCallCenterID=1


update scd set IssuesRaised=7 where FactCallCenterID=1
update scd set WageType='weekends' where FactCallCenterID=1


update scd set Shift='midnight' where FactCallCenterID=7

delete from scd where FactCallCenterID=1

INSERT INTO scd (WageType, Shift, IssuesRaised)
VALUES ('everyday', 'PM2', 1);

