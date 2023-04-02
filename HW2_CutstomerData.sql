use AdventureWorks2019

select 
	sl.CustomerID as 'cust_key',
	sl.AccountNumber as 'Customer_account_no',
	null as 'Title',
	per.Suffix as 'Suffix',
	per.FirstName as 'First Name',
	per.MiddleName as 'Middle Name',
	per.LastName as 'Last Name',
	per.NameStyle as 'Name Style',
	hm.Gender as 'Gender',
	hm.BirthDate as 'Birth Date',
	hm.MaritalStatus as 'Marital Status',
	pe.EmailAddress as 'Email Address',
	null as 'Goegraphic location',
	ad.AddressLine1 as 'Address Line1',
	ad.AddressLine2 as 'Address Line2',
	cont.PhoneNumber as 'Contact Number',
	fod.[First Order Date] as 'First Order Date',
	null as 'Annual Salary',
	null as 'Children',
	null as 'English Occupation',
	null as 'Spanish Occupation',
	null as 'French Occupation',
	null as 'House Owner Flag',
	null as 'Own car',
	null as 'Commute distance'
from Sales.Customer sl

join Person.Person per
on per.BusinessEntityID=sl.CustomerID

LEFT join HumanResources.Employee hm
on hm.BusinessEntityID=per.BusinessEntityID

LEFT join Person.EmailAddress pe
on per.BusinessEntityID=pe.BusinessEntityID

left join Person.Address ad
on ad.AddressID=sl.CustomerID

left join Person.PersonPhone cont
on cont.BusinessEntityID=sl.CustomerID

left join  ( select soh.CustomerID, Min(soh.OrderDate) as 'First Order Date'
from Sales.SalesOrderHeader soh 
group by soh.CustomerID
) fod on fod.CustomerID=sl.CustomerID


select distinct dimc.CustomerKey as 'DimCustomer.CustomerKey' from AdventureWorksDW2019..DimCustomer dimc
where dimc.CustomerKey NOT IN ( select CustomerID from Sales.Customer c
where c.CustomerID=dimc.CustomerKey)

select distinct c.CustomerID as 'Sales.CustomerID' from sales.Customer c
where c.CustomerID NOT IN ( select dimc.CustomerKey from AdventureWorksDW2019..DimCustomer dimc
where c.CustomerID=dimc.CustomerKey)

/* As sales.customer contains data which change slowly over the time for instance storeID, modifiedDate 
whereas Dimcustomer contain data which are retrived from multiple table for OLAP purpose in Data warehouse. 
Therefore, Some customer details in sales.cutomer table do not exist in dimCustomer table.
*/

/* why all primary keys, count */





