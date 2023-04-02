use AdventureWorks2019

select count(*) from sales.customer

select top (10) * from sales.customer

select count(*) from sales.customer
select count(distinct PersonID) from sales.Customer

select count(personID)  from sales.customer
where PersonID is not null
group by personID 
having count(*) > 1

select count(isnull(personID,'99999'))  from sales.customer
group by personID 
having count(*) > 1

select count(isnull(personID,'99999'))  from sales.customer
group by personID 
having count(*) > 1

select top (10) * from sales.customer where personID is not null

select * from sales.customer where AccountNumber = 'AW00011000'

select * from person.Person where person.BusinessEntityID = '13531'
select * from person.EmailAddress where BusinessEntityID = '13531'


use AdventureWorksDW2019

select count(*) from dimcustomer
select * from DimCustomer

use AdventureWorks2019

select * from HumanResources.EmployeePayHistory

select * from sales.Customer where AccountNumber = 'AW00011000'

select top (10) * from sales.customer sc
join AdventureWorksDW2019..DimCustomer dc
    on dc.CustomerKey=sc.CustomerID


use AdventureWorks2019
SELECT      c.name  AS 'ColumnName'
            ,t.name AS 'TableName'FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%Gender%'ORDER BY    TableName
            ,ColumnName;

select * from Person.AddressType

select soh.CustomerID, soh.OrderDate
from Sales.SalesOrderHeader soh
group by soh.CustomerID

select * from HumanResources.Employee
