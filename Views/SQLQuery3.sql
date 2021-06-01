USE DestinationSystem

--store 8

select SaleAmount,SaleQuantity,SalesUnitPrice,SalesExtendedCost,SalesTotalProfit,d.* 
from factSalesActual A,dimDate D
where dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) 
and A.dimSaleDateKey = D.dimDateKey

USE [DestinationSystem]
GO

--actual sales store 8
IF EXISTS (select * from sys.views WHERE name ='storeperformanceperstate')
BEGIN
 DROP VIEW [dbo].[storeperformanceperstate]
END
GO

--[StoreActualSales_View]
CREATE VIEW [dbo].[StoreActualSales_View]
AS
select s.storeName AS StoreName, SaleAmount AS ActualSaleAmount,SaleQuantity,SalesUnitPrice,SalesExtendedCost,SalesTotalProfit,d.CalendarYear,d.CalendarSemester,D.CalendarQuarter,d.MonthName 
from factSalesActual A,dimDate D,dimStore s
where (a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
and A.dimSaleDateKey = D.dimDateKey
and s.dimStoreKey = A.dimStoreKey
GO

--[StoreTargetSales_View]
CREATE VIEW [dbo].[StoreTargetSales_View]
AS
select T.dimStoreKey,s.storeName AS StoreName,c.ChannelName,SalesTargetAmount,d.CalendarYear,d.CalendarSemester,D.CalendarQuarter,d.MonthName 
from factSRCSalesTarget T, dimDate D,dimStore s,dimChannel c
where (t.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		t.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
and T.dimTargetDateKey = D.dimDateKey
and s.dimStoreKey = T.dimStoreKey
and c.dimChannelKey = t.dimChannelKey
GO
--1a.ActualTargetSales
CREATE VIEW [dbo].[StoreActualTargetSales_View]
AS
with tbl1 as
(select A.dimStoreKey, sum(SaleAmount) AS ActualSaleAmount,sum(SaleQuantity) as ActualSaleQuantity,sum(SalesTotalProfit) as ActualSaleTotalProfit,d.CalendarYear as ActualSaleYear,d.MonthName as ActualSaleMonth
from factSalesActual A,dimDate D,dimStore s
where (a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
and A.dimSaleDateKey = D.dimDateKey
and s.dimStoreKey = A.dimStoreKey
group by A.dimStoreKey,d.CalendarYear,d.MonthName)
select distinct s.storeName AS StoreName,cast(cast(SalesTargetAmount AS NUMERIC) AS INT)/12 as TargetSaleAmount,d.CalendarYear as SaleYear,d.MonthName as SaleMonth,d.MonthNumberOfYear
,tbl1.ActualSaleAmount,tbl1.ActualSaleQuantity, tbl1.ActualSaleTotalProfit
from factSRCSalesTarget T, dimDate D,dimStore s,tbl1
where (t.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
	t.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
	and T.dimTargetDateKey = D.dimDateKey
and s.dimStoreKey = T.dimStoreKey
and tbl1.dimStoreKey = T.dimStoreKey
and tbl1.ActualSaleYear = d.CalendarYear
and tbl1.ActualSaleMonth = d.MonthName
GO

--1b.ActualTargetProductSales
select *
from factProductSalesTarget pst,dimProduct p
where p.dimProductKey = pst.dimProductKey 


select * from factSalesActual a
where p.dimProductKey = pst.dimProductKey and a.dimProductKey = pst.dimProductKey
and (a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5))  
go

use DestinationSystem

CREATE VIEW [dbo].[58ActualTargetSales_View]
AS
with table1 as 
(select A.dimStoreKey as dimStoreKey, sum(SaleAmount) AS ActualSaleAmount,sum(SaleQuantity) as ActualSaleQuantity,sum(SalesTotalProfit) as ActualSaleTotalProfit,d.CalendarYear as ActualSaleYear
from factSalesActual A,dimDate D,dimStore s
where (a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
and A.dimSaleDateKey = D.dimDateKey
and s.dimStoreKey = A.dimStoreKey
group by A.dimStoreKey,d.CalendarYear
)
select distinct t.dimStoreKey, s.storeName AS StoreName,cast(SalesTargetAmount as numeric) as SalesTargetAmount,d.CalendarYear,table1.ActualSaleAmount
from factSRCSalesTarget t,dimDate d,table1,dimStore s
where (t.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
	t.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
	and d.dimDateKey = t.dimTargetDateKey
	and table1.dimStoreKey = t.dimStoreKey
	and table1.ActualSaleYear = d.CalendarYear
	and s.dimStoreKey = t.dimStoreKey
GO


select D.CalendarYear,PST.ProductTargetSalesQuantity, ProductName,ProductType,ProductCategory,
	ProductRetailProfit,ProductWholesaleUnitProfit,ProductProfitMarginUnitPercent
from factProductSalesTarget PST,dimProduct P,dimDate D
where PST.dimProductKey = P.dimProductKey
	and D.dimDateKey = PST.dimTargetDateKey
select * from factSalesActual
select * from dimProduct;
GO

-- 2.totalsalequantity
create view [ProductTypesSale]
as
select d.CalendarYear,s.StoreName, a.dimProductKey,p.ProductType,sum(a.saleQuantity) as totalsalequantity,sum(a.SalesTotalProfit) as SalesTotalProfit
from factSalesActual a, dimProduct p,dimDate d,dimStore s
where p.dimProductKey = a.dimProductKey and d.dimDateKey = a.dimSaleDateKey and s.dimStoreKey = a.dimStoreKey and s.dimStoreKey !=-1
	and (p.ProductType = 'Mens Casual' or p.ProductType = 'Womens Casual')
	and (a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
group by d.CalendarYear,s.StoreName,a.dimProductKey,p.ProductType
go



use DestinationSystem
go
--3. Sale Trend 
create view [saletrendperweek]
as
select d.CalendarYear,d.WeekNumberOfYear ,s.StoreName, sum(SaleQuantity) as SalesQuantityPerWeek
from factSalesActual a,dimStore s, dimProduct p,dimDate d
where (a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 8) or 
		a.dimStoreKey = (select dimStoreKey from dimStore where StoreNumber = 5)) 
		and s.dimStoreKey = a.dimStoreKey
		and p.dimProductKey = a.dimProductKey
		and d.dimDateKey = a.dimSaleDateKey
	group by s.StoreName,d.CalendarYear,d.WeekNumberOfYear
GO

--4. Store Peroformance in differenct state
with per as(
select d.CalendarYear, L.State_Province,count(*) as DistinctStoresPerState
from  dimStore s, dimLocation L,dimDate d
where s.dimLocationKey = L.dimLocationKey and L.dimLocationKey != -1
group by L.State_Province)
go

create view [storeperformanceperstate]
as
select d.CalendarYear,s.StoreName,l.State_Province,a.dimStoreKey,sum(a.saleAmount) as TotalSaleAmount,sum(a.saleQuantity) as TotalSaleQuantity,
	sum(a.SalesTotalProfit) as SalesTotalProfit
from factSalesActual a,dimStore s, dimLocation l,dimdate d
where a.dimStoreKey = s.dimStoreKey
	and l.dimLocationKey = a.dimLocationKey
	and a.dimStoreKey != -1 and L.dimLocationKey != -1
	and a.dimSaleDateKey = d.dimDateKey
group by a.dimStoreKey,s.StoreName,l.State_Province,d.CalendarYear
go

