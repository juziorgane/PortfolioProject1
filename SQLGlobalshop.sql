Select count(*)
From PortfolioProject..[Orders]

--make the data order from 1 to n 
Select *
From PortfolioProject..[Orders]
Order by 1

--check if order id is the primary key. It's not. 
select [Order ID],count(*)
from PortfolioProject..[Orders]
group by [Order ID]
having count(*) >1

--show detail information of order Id = 'AE-2014-3830' in which we see order Id is not the primary key
select *
from PortfolioProject..[Orders]
where [Order ID] = 'AE-2014-3830'
--how many different ship mode are there? 4
select distinct [Ship Mode]
from PortfolioProject..[Orders]

--check many days from order date to ship date when the oder is in second class
select DATEDIFF(Day,[Order Date],[Ship Date]) as NumOfDays,*
from PortfolioProject..[Orders]
where [Ship Mode]='Second Class'
--find min and max of NumOfDays they had when the order is a second class 
select min(a.NumOfDays), max(a.NumOfDays)
from(
select DATEDIFF(Day,[Order Date],[Ship Date]) as NumOfDays,*
from PortfolioProject..[Orders]
where [Ship Mode]='Second Class') AS a
--find min and max of NumOfDays they had when the order is a same day class
select min(a.NumOfDays), max(a.NumOfDays)
from(
select DATEDIFF(Day,[Order Date],[Ship Date]) as NumOfDays,*
from PortfolioProject..[Orders]
where [Ship Mode]='Same Day') AS a

--check each customer has how many orders, and count how many items in each order 
select [Customer ID],[Order ID],count(*)
from PortfolioProject..[Orders]
group by [Customer ID],[Order ID]
order by [Customer ID]
--check what the customer had ordered 
select *
from PortfolioProject..[Orders]
where [Order ID]= 'CA-2011-128055'

