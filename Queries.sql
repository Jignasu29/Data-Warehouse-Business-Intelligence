use DWProject

-- Staging DDL
create table StagingElectric (
	FacilityID varchar(50),
	FacilityName varchar(100),
	OperatorID varchar(50),
	OperatorName varchar(100),
	[State] varchar(2),
	NaicsCode varchar(10),
	ElecFuelConsumptionMmbtus varchar(30),
	NetGenerationMegawatthours varchar(30),
	[Year] varchar(4)
);


create table StagingPollution (
	[State] varchar(30),
	[Date] varchar(25),
	NO2Mean varchar(20),
	NO2AQI varchar(20),
	O3Mean varchar(20),
	O3AQI varchar(20),
	SO2Mean varchar(20),
	SO2AQI varchar(20),
	COMean varchar(20),
	COAQI varchar(20)
);


create table StagingPopulation (
	[State] varchar(30),
	PopulationEstimate2010 varchar(15),
	PopulationEstimate2011 varchar(15),
	PopulationEstimate2012 varchar(15),
	PopulationEstimate2013 varchar(15),
	PopulationEstimate2014 varchar(15),
	PopulationEstimate2015 varchar(15),
	PopulationEstimate2016 varchar(15),
	PopulationEstimate2017 varchar(15),
	NumericPopulationChange2010 varchar(15),
	NumericPopulationChange2011 varchar(15),
	NumericPopulationChange2012 varchar(15),
	NumericPopulationChange2013 varchar(15),
	NumericPopulationChange2014 varchar(15),
	NumericPopulationChange2015 varchar(15),
	NumericPopulationChange2016 varchar(15),
	NumericPopulationChange2017 varchar(15),
	Births2010 varchar(15),
	Births2011 varchar(15),
	Births2012 varchar(15),
	Births2013 varchar(15),
	Births2014 varchar(15),
	Births2015 varchar(15),
	Births2016 varchar(15),
	Births2017 varchar(15),
	Deaths2010 varchar(15),
	Deaths2011 varchar(15),
	Deaths2012 varchar(15),
	Deaths2013 varchar(15),
	Deaths2014 varchar(15),
	Deaths2015 varchar(15),
	Deaths2016 varchar(15),
	Deaths2017 varchar(15),
	NetMigration2010 varchar(15),
	NetMigration2011 varchar(15),
	NetMigration2012 varchar(15),
	NetMigration2013 varchar(15),
	NetMigration2014 varchar(15),
	NetMigration2015 varchar(15),
	NetMigration2016 varchar(15),
	NetMigration2017 varchar(15)
);

 

create table StagingWeather (
	Station varchar(50),
	StationName varchar(80),
	[State] varchar(30),
	[Date] varchar(25),
	AvgTemp varchar(10),
	MaxTemp varchar(10),
	MinTemp varchar(10),
);


-- DW DDL
create table DimPollution (
	DimPollutionID int not null identity primary key,
	[Year] varchar(4),
	[State] varchar(2),
	NO2Mean float,
	NO2AQI float,
	O3Mean float,
	O3AQI float,
	SO2Mean float,
	SO2AQI float,
	COMean float,
	COAQI float
);

create table DimPopulation (
	DimPopulationID int not null identity primary key,
	[Year] varchar(4),
	[State] varchar(2),
	PopulationEstimate bigint,
	NumericPopulationChange bigint,
	Births bigint,
	Deaths bigint,
	NetMigration bigint
);

create table DimWeather (
	DimWeatherID int not null identity primary key,
	[Year] varchar(4),
	[State] varchar(2),
	AvgTemp float,
	MaxTemp float,
	MinTemp float
);

create table DimFacility (
	DimFacilityID int not null identity primary key,
	[State] varchar(2),
	FacilityID int,
	FacilityName varchar(100),
	OperatorID varchar(50),
	OperatorName varchar(100),
	NaicsCode varchar(10),
	FacilityNameChangedDate date default Null,
	PreviousOperatorName  varchar(100) default Null,
	PreviousNaicsCode varchar(10) default Null,
);


create table FactElectric (
	FactElectricID int not null identity primary key,
	FacilityID int,
	DimPopulationID int,
	DimPollutionID int,
	DimWeatherID int,
	[State] varchar(2),
	[Year] varchar(4),
	ElecFuelConsumptionMmbtus float,
	NetGenerationMegawatthours float,
);


-- State Lookup
CREATE TABLE StateLookup (
   StateID       INT IDENTITY (1, 1),
   StateName     VARCHAR (32),
	StateAbbrev   CHAR (2)
);


INSERT INTO StateLookup
VALUES ('Alabama', 'AL'),
       ('Alaska', 'AK'),
       ('Arizona', 'AZ'),
       ('Arkansas', 'AR'),
       ('California', 'CA'),
       ('Colorado', 'CO'),
       ('Connecticut', 'CT'),
       ('Delaware', 'DE'),
       ('District of Columbia', 'DC'),
       ('Florida', 'FL'),
       ('Georgia', 'GA'),
       ('Hawaii', 'HI'),
       ('Idaho', 'ID'),
       ('Illinois', 'IL'),
       ('Indiana', 'IN'),
       ('Iowa', 'IA'),
       ('Kansas', 'KS'),
       ('Kentucky', 'KY'),
       ('Louisiana', 'LA'),
       ('Maine', 'ME'),
       ('Maryland', 'MD'),
       ('Massachusetts', 'MA'),
       ('Michigan', 'MI'),
       ('Minnesota', 'MN'),
       ('Mississippi', 'MS'),
       ('Missouri', 'MO'),
       ('Montana', 'MT'),
       ('Nebraska', 'NE'),
       ('Nevada', 'NV'),
       ('New Hampshire', 'NH'),
       ('New Jersey', 'NJ'),
       ('New Mexico', 'NM'),
       ('New York', 'NY'),
       ('North Carolina', 'NC'),
       ('North Dakota', 'ND'),
       ('Ohio', 'OH'),
       ('Oklahoma', 'OK'),
       ('Oregon', 'OR'),
       ('Pennsylvania', 'PA'),
       ('Rhode Island', 'RI'),
       ('South Carolina', 'SC'),
       ('South Dakota', 'SD'),
       ('Tennessee', 'TN'),
       ('Texas', 'TX'),
       ('Utah', 'UT'),
       ('Vermont', 'VT'),
       ('Virginia', 'VA'),
       ('Washington', 'WA'),
       ('West Virginia', 'WV'),
       ('Wisconsin', 'WI'),
       ('Wyoming', 'WY');

---- Code Run ----

-- Transformation Source Pollution
select
	Year(a.Date) as [Year]
	, s.StateAbbrev as [State]
	, NO2Mean
	, NO2AQI
	, O3Mean
	, O3AQI
	, SO2Mean
	, SO2AQI
	, COMean
	, COAQI
from StagingPollution a
join StateLookup s
	on a.State = s.StateName
where Year(a.[Date]) not in (select distinct [Year] from DimPollution)
	--and s.StateAbbrev not in (select distinct [State] from DimPollution);


-- Transformation Source Population
with temp1 as (
	SELECT [State], [DescYear], [Count]
	FROM (
		select * from StagingPopulation
	) p
	UNPIVOT
	([Count] FOR [DescYear] IN (PopulationEstimate2010, PopulationEstimate2011, PopulationEstimate2012, PopulationEstimate2013, PopulationEstimate2014, PopulationEstimate2015, PopulationEstimate2016, PopulationEstimate2017, 
									NumericPopulationChange2010, NumericPopulationChange2011, NumericPopulationChange2012, NumericPopulationChange2013, NumericPopulationChange2014, NumericPopulationChange2015, NumericPopulationChange2016, NumericPopulationChange2017, 
									Births2010, Births2011, Births2012, Births2013, Births2014, Births2015, Births2016, Births2017, 
									Deaths2010, Deaths2011, Deaths2012, Deaths2013, Deaths2014, Deaths2015, Deaths2016, Deaths2017, 
									NetMigration2010, NetMigration2011, NetMigration2012, NetMigration2013, NetMigration2014, NetMigration2015, NetMigration2016, NetMigration2017)) as unpvt
),
temp2 as (
	select
		right(DescYear, 4) as [Year]
		, s.StateAbbrev as [State]
		, substring(DescYear, 0, len(DescYear)-3) as [Description]
		, [Count]
	from temp1 a
	join StateLookup s
		on a.State = s.StateName
	where Year(right(DescYear, 4)) not in (select distinct [Year] from DimPopulation)
	and s.StateAbbrev not in (select distinct [State] from DimPopulation)
)
select
	[Year]
	, [State]
	, [PopulationEstimate]
	, [NumericPopulationChange]
	, [Births]
	, [Deaths]
	, [NetMigration]
from temp2
pivot(
	max([Count]) for [Description] in ([PopulationEstimate], [NumericPopulationChange], [Births], [Deaths], [NetMigration])
) as PivotTable;



-- Transformation Source Weather
select
	Year(a.Date) as [Year]
	, s.StateAbbrev as [State]
	, AvgTemp
	, MaxTemp
	, MinTemp
from StagingWeather a
join StateLookup s
	on a.State = s.StateName
where Year(a.[Date]) not in (select distinct [Year] from DimWeather)
	--and s.StateAbbrev not in (select distinct [State] from DimWeather);



-- Transformation Source for DimFacility
select
	distinct a.FacilityID
	, a.FacilityName
	, a.OperatorID
	, a.OperatorName
	, a.NaicsCode
	, a.[State]
	, df.FacilityName as [FacilityName_currentSource]
	, df.FacilityNameChangedDate as [FacilityNameChangedDate_currentSource]
from StagingElectric a
join DimFacility df
	on a.FacilityID = df.FacilityID
where a.[Year] = (select max(Year(b.[Year])) from StagingElectric b)
	and df.FacilityNameChangedDate is Null
	and (a.FacilityName != df.FacilityName
		or a.OperatorID != df.OperatorID
		or a.OperatorName != df.OperatorName
		or a.NaicsCode != df.NaicsCode
	)
union
select
	distinct c.FacilityID
	, c.FacilityName
	, c.OperatorID
	, c.OperatorName
	, c.NaicsCode
	, c.[State]
	, Null as [FacilityName_currentSource]
	, Null as [FacilityNameChangedDate_currentSource]
from StagingElectric c
where c.FacilityID not in (select distinct d.FacilityID from DimFacility d);



-- StagingFacility update
update dbo.StagingElectric
set FacilityName = ?,
	OperatorID = ?,
	OperatorName = ?,
	NaicsCode = ?
where [Year] = ?
	and [State] = ?
	and FacilityID = ?;


-- SCD for FacilityName
declare @FacilityID as int = ?;
declare @FacilityName as varchar(100) = ?;

update dbo.DimFacility
set FacilityNameChangedDate = CONVERT(date, GETDATE())
where FacilityID = @FacilityID 
	and FacilityNameChangedDate is null;

insert into DimFacility(State, FacilityID, FacilityName, OperatorID, OperatorName, NaicsCode)
values (?, @FacilityID, @FacilityName, ?, ?, ?);


-- SCD for OperatorName & NaicsCode
update dbo.DimFacility
set OperatorID = ?,
	OperatorName = ?,
	NaicsCode = ?,
	PreviousOperatorName = ?,
	PreviousNaicsCode = ?
where FacilityID = ?;


-- SCD for OperatorName
update dbo.DimFacility
set OperatorID = ?,
	OperatorName = ?,
	PreviousOperatorName = ?
where FacilityID = ?;


-- SCD for NaicsCode
update dbo.DimFacility
set OperatorID = ?,
	NaicsCode = ?,
	PreviousNaicsCode = ?
where FacilityID = ?;


-- SCD for OperatorID
update dbo.DimFacility
set OperatorID = ?
where FacilityID = ?;



