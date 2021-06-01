```CustomerID
CustomerFullName
	,CustomerFirstName
	,CustomerLastName
	,CustomerGender
```

USE DestinationSystem
SELECT dbo.StageCustomer.CustomerID AS CustomerID,
	dbo.StageCustomer.FirstName + ' ' + dbo.StageCustomer.LastName AS CustomerFullName,
	dbo.StageCustomer.FirstName AS CustomerFirstName,
	dbo.StageCustomer.LastName AS CustomerLastName,
	dbo.StageCustomer.Gender AS CustomerGender
	FROM StageCustomer


	USE DestinationSystem
SELECT dbo.StageCustomer.CustomerID AS CustomerID,
	dbo.StageCustomer.FirstName + ' ' + dbo.StageCustomer.LastName AS CustomerFullName,
	dbo.StageCustomer.FirstName AS CustomerFirstName,
	dbo.StageCustomer.LastName AS CustomerLastName,
	dbo.StageCustomer.Gender AS CustomerGender
	FROM StageCustomer


-- create CTE with all dates needed for load
;WITH LocationCTE AS
(
SELECT Address,City,PostalCode,StateProvince,Country
From dbo.StageCustomer
UNION 
SELECT Address,City,PostalCode,StateProvince,Country
From dbo.StageReseller
UNION 
SELECT Address,City,PostalCode,StateProvince,Country
From dbo.StageStore
)

USE DestinationSystem
WITH LocationCTE AS
(
SELECT Address,City,PostalCode,StateProvince,Country
From dbo.StageCustomer
UNION 
SELECT Address,City,PostalCode,StateProvince,Country
From dbo.StageReseller
UNION 
SELECT Address,City,PostalCode,StateProvince,Country
From dbo.StageStore
)

SELECT CustomerID
from dbo.StageCustomer

IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	ALTER TABLE dbo.dimCustomer
	DROP CONSTRAINT PK_dimCustomer;
	Drop Table dbo.dimCustomer;
END
GO


IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	CREATE TABLE dbo.dimCustomer
	(
	dimCustomerKey INT IDENTITY(1,1) CONSTRAINT PK_dimCustomer PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	dimLocationKey INT,
	FOREIGN KEY (dimLocationKey) REFERENCES dimLocation(dimLocationKey),
	CustomerID UNIQUEIDENTIFIER NOT NUll, --Natural Key
	CustomerFullName VARCHAR(255) NOT NULL,
	CustomerFirstName VARCHAR(255) NOT NULL,
	CustomerLastName VARCHAR(255) NOT NULL,
	CustomerGender VARCHAR(1) NOT NULL
	);
END
GO


select * from dimCustomer
--dimCustomer
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimCustomer')
BEGIN
	-- ====================================
	-- Load dimCustomer table
	-- ====================================

	INSERT INTO dbo.dimCustomer
	(
	CustomerID
	,CustomerFullName
	,CustomerFirstName
	,CustomerLastName
	,CustomerGender
	)
	SELECT 
	dbo.StageCustomer.CustomerID AS CustomerID
	,dbo.StageCustomer.FirstName + ' ' + dbo.StageCustomer.LastName AS CustomerFullName
	,dbo.StageCustomer.FirstName AS CustomerFirstName
	,dbo.StageCustomer.LastName AS CustomerLastName
	,dbo.StageCustomer.Gender AS CustomerGender
	
	FROM StageCustomer
END
GO 

SET IDENTITY_INSERT dbo.dimCustomer ON;

INSERT INTO dbo.dimCustomer
(
dimCustomerKey
,dimLocationKey
,CustomerID
,CustomerFullName
,CustomerFirstName
,CustomerLastName
,CustomerGender
)
VALUES
( 
-1
,-1
,newid()
,'Unknown'
,'Unknown'
,'Unknown'
,'Unknown'
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimCustomer OFF;
GO


SELECT 
	L.dimLocationKey As dimLocationKey
	,dbo.StageCustomer.CustomerID AS CustomerID
	,dbo.StageCustomer.FirstName + ' ' + dbo.StageCustomer.LastName AS CustomerFullName
	,dbo.StageCustomer.FirstName AS CustomerFirstName
	,dbo.StageCustomer.LastName AS CustomerLastName
	,dbo.StageCustomer.Gender AS CustomerGender
	
	FROM StageCustomer, dimLocation L
	WHERE L.Address = dbo.StageCustomer.Address 
	AND L.City = dbo.StageCustomer.City 
	AND L.PostalCode = dbo.StageCustomer.PostalCode
	AND L.State_Province = dbo.StageCustomer.StateProvince
	AND L.Country = dbo.StageCustomer.Country


SELECT 
	L.dimLocationKey As dimLocationKey
	,dbo.StageReseller.ResellerID AS CustomerID
	,dbo.StageReseller.Contact AS ContactName
	,dbo.StageReseller.PhoneNumber AS PhoneNumber
	,dbo.StageReseller.EmailAddress AS Email
	
	FROM StageReseller, dimLocation L
	WHERE L.Address = dbo.StageReseller.Address 
	AND L.City = dbo.StageReseller.City 
	AND L.PostalCode = dbo.StageReseller.PostalCode
	AND L.State_Province = dbo.StageReseller.StateProvince
	AND L.Country = dbo.StageReseller.Country



SELECT 
L.dimLocationKey As dimLocationKey
,dbo.StageStore.StoreID AS StoreID
,dbo.StageStore.StoreNumber AS StoreNumber
,dbo.StageStore.StoreManager AS StoreManager
	
FROM StageStore, dimLocation L
WHERE L.Address = dbo.StageStore.Address 
AND L.City = dbo.StageStore.City 
AND L.PostalCode = dbo.StageStore.PostalCode
AND L.State_Province = dbo.StageStore.StateProvince
AND L.Country = dbo.StageStore.Country

dimStoreKey
	,dimResellerKey
	,dimChannelKey
	,dimTargetDateKey
	,SalesTargetAmount

USE DestinationSystem


SELECT 
L.dimLocationKey As dimLocationKey
,dbo.StageStore.StoreID AS StoreID
,CONCAT('Store Number ', dbo.StageStore.StoreNumber) AS StoreName
,dbo.StageStore.StoreNumber AS StoreNumber
,dbo.StageStore.StoreManager AS StoreManager
	
FROM StageStore, dimLocation L
WHERE L.Address = dbo.StageStore.Address 
AND L.City = dbo.StageStore.City 
AND L.PostalCode = dbo.StageStore.PostalCode
AND L.State_Province = dbo.StageStore.StateProvince
AND L.Country = dbo.StageStore.Country


dimStoreKey
,dimResellerKey
,dimChannelKey
,dimTargetDateKey
,SalesTargetAmount

SELECT 
S.dimStoreKey AS dimStoreKey 
,R.dimResellerKey AS dimResellerKey
,C.dimChannelKey AS dimChannelKey
, D.dimDateKey AS dimTargetDateKey
, RSC.[ TargetSalesAmount ] AS SalesTargetAmount 
FROM  StageTargetChannelResellerStore RSC
RIGHT JOIN dimStore S ON RSC.TargetName = S.StoreName 



dimStore S, dimReseller R, dimChannel C, DimDate D,

USE DestinationSystem



USE DestinationSystem

SELECT 
P.ProductID As ProductID
,PT.ProductTypeID As ProductTypeID
,PC.ProductCategoryID As ProductCategoryID
,P.Product AS ProductName
,PT.ProductType AS ProductType
,PC.ProductCategory AS ProductCategory
,P.Price AS ProductRetailPrice
,P.WholesalePrice AS ProductWholesalePrice
,P.Cost AS ProductCost
,CASE WHEN (SD.SalesAmount/SD.SalesQuantity = P.Price) THEN (SELECT SD.SalesAmount -(SD.SalesAmount/SD.SalesQuantity*P.Cost)) ELSE 0 END AS ProductRetailProfit 
,CASE WHEN (SD.SalesAmount/SD.SalesQuantity = P.WholesalePrice) THEN (SELECT SD.SalesAmount -(SD.SalesAmount/SD.SalesQuantity*P.Cost)/SD.SalesQuantity) ELSE 0 END AS ProductWholeSaleUnitProfit
,(P.Price - P.Cost)/P.Price AS ProductProfitMarginUnitPercent
FROM StageProduct P,StageProductType PT,StageProductCategory PC,StageSalesDetail SD
WHERE P.ProductTypeID = PT.ProductTypeID AND PC.ProductCategoryID = PT.ProductCategoryID AND SD.ProductID = P.ProductID

USE DestinationSystem
--dimProduct
-- =============================
-- Begin load of unknown member
-- =============================
SET IDENTITY_INSERT dbo.dimProduct ON;

-- dimProduct
IF NOT EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	CREATE TABLE dbo.dimProduct
	(
	dimProductKey INT IDENTITY(1,1) CONSTRAINT PK_dimProduct PRIMARY KEY CLUSTERED NOT NULL, -- SurrogateKey
	ProductID INT NOT NUll, --Natural Key
	ProductTypeID INT NOT NUll, --Natural Key
	ProductCategroyID INT NOT NUll, --Natural Key
	ProductName VARCHAR(50) NOT NULL,
	ProductType VARCHAR(50) NOT NULL,
	ProductCategroy VARCHAR(50) NOT NULL,
	ProductRetailPrice NUMERIC(18,2) NOT NULL,
	ProductWholesalePrice NUMERIC(18,2) NOT NULL,
	ProductCost NUMERIC(18,2) NOT NULL,
	ProductRetailProfit NUMERIC(18,2) NOT NULL,
	ProductWholesaleUnitProfit NUMERIC(18,2) NOT NULL,
	ProductProfitMarginUnitPercent NUMERIC(18,2) NOT NULL,
	);
END
GO

--dimProduct
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	-- ====================================
	-- Load dimProduct table
	-- ====================================

	INSERT INTO dbo.dimProduct
	(
	ProductID
	,ProductTypeID
	,ProductCategroyID 
	,ProductName 
	,ProductType 
	,ProductCategroy 
	,ProductRetailPrice 
	,ProductWholesalePrice 
	,ProductCost 
	,ProductRetailProfit
	,ProductWholesaleUnitProfit
	,ProductProfitMarginUnitPercent
	)
	SELECT 
	P.ProductID As ProductID
	,PT.ProductTypeID As ProductTypeID
	,PC.ProductCategoryID As ProductCategoryID
	,P.Product AS ProductName
	,PT.ProductType AS ProductType
	,PC.ProductCategory AS ProductCategory
	,P.Price AS ProductRetailPrice
	,P.WholesalePrice AS ProductWholesalePrice
	,P.Cost AS ProductCost
	,CASE WHEN (SD.SalesAmount/SD.SalesQuantity = P.Price) THEN (SELECT SD.SalesAmount -(SD.SalesAmount/SD.SalesQuantity*P.Cost)) ELSE 0 END AS ProductRetailProfit 
	,CASE WHEN (SD.SalesAmount/SD.SalesQuantity = P.WholesalePrice) THEN (SELECT SD.SalesAmount -(SD.SalesAmount/SD.SalesQuantity*P.Cost)/SD.SalesQuantity) ELSE 0 END AS ProductWholeSaleUnitProfit
	,(P.Price - P.Cost)/P.Price AS ProductProfitMarginUnitPercent
	FROM StageProduct P,StageProductType PT,StageProductCategory PC,StageSalesDetail SD
	WHERE P.ProductTypeID = PT.ProductTypeID AND PC.ProductCategoryID = PT.ProductCategoryID AND SD.ProductID = P.ProductID
END
GO 

-- dimProduct
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	Drop Table dbo.dimProduct;
END
GO

select * from dimProduct

SET IDENTITY_INSERT dbo.dimProduct ON;

INSERT INTO dbo.dimProduct
(
dimProductKey
,ProductID
,ProductTypeID
,ProductCategroyID 
,ProductName 
,ProductType 
,ProductCategroy 
,ProductRetailPrice 
,ProductWholesalePrice 
,ProductCost 
,ProductRetailProfit
,ProductWholesaleUnitProfit
,ProductProfitMarginUnitPercent
)
VALUES
( 
-1
,-1
,-1
,-1
,newid()
,CAST (newid() as nvarchar(50)
,CAST (newid() as nvarchar(50)
,-1
,-1
,-1
,-1
,-1
,-1
);
-- Turn the identity insert to OFF so new rows auto assign identities
SET IDENTITY_INSERT dbo.dimProduct OFF;
GO

USE DestinationSystem

SELECT
P.dimProductKey AS dimProductKey
, S.dimStoreKey AS dimStoreKey
, R.dimResellerKey AS dimResellerKey
, C.dimCustomerKey AS dimCustomerKey
,CN.dimChannelKey AS dimChannelKey
,D.dimDateKey AS dimSaleDateKey
, L.dimLocationKey AS dimLocationKey
, SH.SalesHeaderID AS SalesHeaderID
, SD.SalesDetailID AS SalesDetailID
,SD.SalesAmount AS SaleAmount
,SD.SalesQuantity AS SaleQuantity
,SD.SalesAmount/SD.SalesQuantity AS SalesUnitPrice
,P.ProductCost*SD.SalesQuantity AS SalesExtendedCost 
,SD.SalesAmount-(P.ProductCost*SD.SalesQuantity)  AS SalesTotalProfit

FROM StageSalesDetail SD
LEFT JOIN StageSalesHeader SH ON  SH.SalesHeaderID = SD.SalesHeaderID
LEFT JOIN dimProduct P ON P.ProductID = SD.ProductID 
LEFT JOIN dimStore S ON S.StoreID = SH.StoreID
LEFT JOIN dimReseller R ON R.ResellerID = SH.ResellerID 
LEFT JOIN dimCustomer C ON C.CustomerID = SH.CustomerID 
LEFT JOIN dimChannel CN ON CN.ChannelID = SH.ChannelID 
LEFT JOIN dimDate D ON D.FullDate = CAST(SD.CreatedDate AS DATE)
LEFT JOIN dimLocation L ON C.dimLocationKey = L.dimLocationKey OR  S.dimLocationKey = L.dimLocationKey OR R.dimLocationKey = L.dimLocationKey


TRUNCATE TABLE dbo.StageSalesHeader


SELECT SD.SalesDetailID,SD.SalesHeaderID,SD.ProductID,SD.SalesAmount,SD.SalesQuantity,D.dimDateKey
FROM StageSalesDetail SD
LEFT JOIN StageSalesHeader SH ON  SH.SalesHeaderID = SD.SalesHeaderID
LEFT JOIN dimDate D ON D.FullDate = CAST(SD.CreatedDate AS DATE)

SELECT 
P.dimProductKey
, S.dimStoreKey AS dimStoreKey
, R.dimResellerKey AS dimResellerKey
, C.dimCustomerKey AS dimCustomerKey
,CN.dimChannelKey AS dimChannelKey
,D.dimDateKey AS dimSaleDateKey
,L.dimLocationKey AS dimLocationKey
,SD.SalesDetailID
,SD.SalesHeaderID
,SD.ProductID
,SD.SalesAmount
,SD.SalesQuantity
,SD.SalesAmount/SD.SalesQuantity AS SalesUnitPrice
,P.ProductCost*SD.SalesQuantity AS SalesExtendedCost 
,SD.SalesAmount-(P.ProductCost*SD.SalesQuantity)  AS SalesTotalProfit
FROM StageSalesDetail SD
LEFT JOIN StageSalesHeader SH ON  SH.SalesHeaderID = SD.SalesHeaderID
LEFT JOIN dimDate D ON D.FullDate = CAST(SD.CreatedDate AS DATE)
LEFT JOIN dimProduct P ON P.ProductID = SD.ProductID 
LEFT JOIN dimStore S ON S.StoreID = SH.StoreID
LEFT JOIN dimReseller R ON R.ResellerID = SH.ResellerID 
LEFT JOIN dimCustomer C ON C.CustomerID = SH.CustomerID 
LEFT JOIN dimChannel CN ON CN.ChannelID = SH.ChannelID 
LEFT JOIN dimLocation L ON L.dimLocationKey = S.dimLocationKey OR L.dimLocationKey = R.dimLocationKey OR L.dimLocationKey = C.dimLocationKey

USE DestinationSystem
------------------------
WITH tb1 AS(
	SELECT
	sub1.ProductID
	,sum(case when sub1.saleprice = sub1.ProductRetailPrice then sub1.SalesQuantity else 0 end) as retailquantity
	,sum(case when sub1.saleprice = sub1.ProductRetailPrice then sub1.SalesAmount else 0 end) as retailAmount
	,sum(case when  sub1.saleprice = sub1.ProductWholesalePrice then sub1.SalesQuantity else 0 end) as wholesalequantity
	,sum(case when  sub1.saleprice = sub1.ProductWholesalePrice then sub1.SalesAmount else 0 end) as wholesaleAmount
	FROM(
		SELECT 
		P.ProductID As ProductID
		,P.Price AS ProductRetailPrice
		,P.WholesalePrice AS ProductWholesalePrice
		,SD.SalesQuantity
		,SD.SalesAmount
		,SD.SalesAmount/SD.SalesQuantity AS saleprice
		FROM StageProduct P
		LEFT JOIN StageProductType PT ON P.ProductTypeID = PT.ProductTypeID
		LEFT JOIN StageProductCategory PC ON  PC.ProductCategoryID = PT.ProductCategoryID  
		LEFT JOIN StageSalesDetail SD ON SD.ProductID = P.ProductID
	) sub1
	GROUP BY sub1.ProductID
	)
SELECT 
P.ProductID As ProductID
,PT.ProductTypeID As ProductTypeID
,PC.ProductCategoryID As ProductCategoryID
,P.Product AS ProductName
,PT.ProductType AS ProductType
,PC.ProductCategory AS ProductCategory
,P.Price AS ProductRetailPrice
,P.WholesalePrice AS ProductWholesalePrice
,P.Cost AS ProductCost
,(tb1.retailAmount - tb1.retailquantity*P.Cost) AS ProductRetailProfit 
,(tb1.wholesaleAmount-tb1.wholesalequantity*P.Cost)/tb1.wholesalequantity AS ProductWholeSaleUnitProfit
,(P.Price - P.Cost)/P.Price*100 AS ProductProfitMarginUnitPercent
FROM StageProduct P,StageProductType PT,StageProductCategory PC,tb1
WHERE P.ProductTypeID = PT.ProductTypeID AND PC.ProductCategoryID = PT.ProductCategoryID AND tb1.ProductID = P.ProductID
ORDER BY P.ProductID


--dimProduct
IF EXISTS (SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'dimProduct')
BEGIN
	-- ====================================
	-- Load dimProduct table
	-- ====================================
	WITH tb1 AS(
		SELECT
		sub1.ProductID
		,sum(case when sub1.saleprice = sub1.ProductRetailPrice then sub1.SalesQuantity else 0 end) as retailquantity
		,sum(case when sub1.saleprice = sub1.ProductRetailPrice then sub1.SalesAmount else 0 end) as retailAmount
		,sum(case when  sub1.saleprice = sub1.ProductWholesalePrice then sub1.SalesQuantity else 0 end) as wholesalequantity
		,sum(case when  sub1.saleprice = sub1.ProductWholesalePrice then sub1.SalesAmount else 0 end) as wholesaleAmount
		FROM(
		SELECT 
		P.ProductID As ProductID
		,P.Price AS ProductRetailPrice
		,P.WholesalePrice AS ProductWholesalePrice
		,SD.SalesQuantity
		,SD.SalesAmount
		,SD.SalesAmount/SD.SalesQuantity AS saleprice
		FROM StageProduct P
		LEFT JOIN StageProductType PT ON P.ProductTypeID = PT.ProductTypeID
		LEFT JOIN StageProductCategory PC ON  PC.ProductCategoryID = PT.ProductCategoryID  
		LEFT JOIN StageSalesDetail SD ON SD.ProductID = P.ProductID
		) sub1
		GROUP BY sub1.ProductID
	)
	INSERT INTO dbo.dimProduct
	(
	ProductID
	,ProductTypeID
	,ProductCategroyID 
	,ProductName 
	,ProductType 
	,ProductCategroy 
	,ProductRetailPrice 
	,ProductWholesalePrice 
	,ProductCost 
	,ProductRetailProfit
	,ProductWholesaleUnitProfit
	,ProductProfitMarginUnitPercent
	)
	SELECT 
	P.ProductID As ProductID
	,PT.ProductTypeID As ProductTypeID
	,PC.ProductCategoryID As ProductCategoryID
	,P.Product AS ProductName
	,PT.ProductType AS ProductType
	,PC.ProductCategory AS ProductCategory
	,P.Price AS ProductRetailPrice
	,P.WholesalePrice AS ProductWholesalePrice
	,P.Cost AS ProductCost
	,(tb1.retailAmount - tb1.retailquantity*P.Cost) AS ProductRetailProfit 
	,(tb1.wholesaleAmount-tb1.wholesalequantity*P.Cost)/tb1.wholesalequantity AS ProductWholeSaleUnitProfit
	,(P.Price - P.Cost)/P.Price*100 AS ProductProfitMarginUnitPercent
	FROM StageProduct P,StageProductType PT,StageProductCategory PC,tb1
	WHERE P.ProductTypeID = PT.ProductTypeID AND PC.ProductCategoryID = PT.ProductCategoryID AND tb1.ProductID = P.ProductID
	ORDER BY P.ProductID
END
GO 



SELECT 
	P.dimProductKey As dimProductKey
	,D.dimDateKey As dimTargetDateKey
	,STP.[ SalesQuantityTarget ] AS ProductTargetSalesQuantity

	FROM StageTargetProduct STP
	LEFT JOIN dimProduct P ON P.ProductID = STP.ProductID
	LEFT JOIN dimDate D ON D.CalendarYear = STP.[Year]

select * from factProductSalesTarget



SELECT 
P.dimProductKey As dimProductKey
,D.dimDateKey As dimTargetDateKey
,STP.[ SalesQuantityTarget ]/365 AS ProductTargetSalesQuantity
FROM StageTargetProduct STP
LEFT JOIN dimProduct P ON P.ProductID = STP.ProductID
LEFT JOIN dimDate D ON D.CalendarYear = STP.[Year]


SELECT 
P.dimProductKey
, CASE WHEN S.dimStoreKey IS NULL THEN -1 ELSE S.dimStoreKey END As dimStoreKey
, CASE WHEN  R.dimResellerKey IS NULL THEN -1 ELSE R.dimResellerKey END As dimResellerKey
, CASE WHEN C.dimCustomerKey IS NULL THEN -1 ELSE C.dimCustomerKey END As dimCustomerKey
,CN.dimChannelKey AS dimChannelKey
,D.dimDateKey AS dimSaleDateKey
,L.dimLocationKey AS dimLocationKey
,SD.SalesHeaderID
,SD.SalesDetailID
,SD.SalesAmount
,SD.SalesQuantity
,SD.SalesAmount/SD.SalesQuantity AS SalesUnitPrice
,P.ProductCost*SD.SalesQuantity AS SalesExtendedCost 
,SD.SalesAmount-(P.ProductCost*SD.SalesQuantity)  AS SalesTotalProfit
FROM StageSalesDetail SD
LEFT JOIN StageSalesHeader SH ON  SH.SalesHeaderID = SD.SalesHeaderID
LEFT JOIN dimDate D ON D.FullDate = CAST(SD.CreatedDate AS DATE)
LEFT JOIN dimProduct P ON P.ProductID = SD.ProductID 
LEFT JOIN dimStore S ON S.StoreID = SH.StoreID
LEFT JOIN dimReseller R ON R.ResellerID = SH.ResellerID 
LEFT JOIN dimCustomer C ON C.CustomerID = SH.CustomerID 
LEFT JOIN dimChannel CN ON CN.ChannelID = SH.ChannelID 
LEFT JOIN dimLocation L ON L.dimLocationKey = S.dimLocationKey OR L.dimLocationKey = R.dimLocationKey OR L.dimLocationKey = C.dimLocationKey



USE DestinationSystem
--dimChannelView
IF EXISTS (select * from sys.views WHERE name ='dimChannelView')
BEGIN
	DROP VIEW dimChannelView
END
GO

CREATE VIEW dimChannelView
AS
SELECT dimChannelKey,ChannelID,ChannelCategoryID,ChannelName,ChannelCategory
FROM dimChannel;

--dimCustomerView
IF EXISTS (select * from sys.views WHERE name ='dimCustomerView')
BEGIN
	DROP VIEW dimCustomerView
END
GO

CREATE VIEW dimCustomerView
AS
SELECT dimCustomerKey,dimLocationKey,CustomerID,CustomerFullName,CustomerFirstName,CustomerLastName,CustomerGender
FROM dimCustomer


--dimDateView
IF EXISTS (select * from sys.views WHERE name ='dimDateView')
BEGIN
	DROP VIEW dimDateView
END
GO

CREATE VIEW dimDateView
AS
SELECT dimDateKey,FullDate,DayNumberOfWeek,DayNameOfWeek,DayNumberOfMonth,DayNumberOfYear,
	WeekdayFlag,WeekNumberOfYear,MonthName,MonthNumberOfYear,CalendarQuarter,CalendarYear,
	CalendarSemester,CreatedDate,CreatedBy,ModifiedDate,ModifiedBy
FROM dimDate

--dimLocationView
IF EXISTS (select * from sys.views WHERE name ='dimLocationView')
BEGIN
	DROP VIEW dimLocationView
END
GO

CREATE VIEW dimLocationView
AS
SELECT dimLocationKey,Address,City,PostalCode,State_Province,Country
FROM dimLocation

use DestinationSystem
--dimProductView
IF EXISTS (select * from sys.views WHERE name ='dimProductView')
BEGIN
	DROP VIEW dimProductView
END
GO

CREATE VIEW dimProductView
AS
SELECT dimProductKey,ProductID,ProductTypeID,ProductCategoryID,ProductName,ProductType,ProductCategory,
	ProductRetailPrice,ProductWholesalePrice,ProductCost,ProductRetailProfit,ProductWholesaleUnitProfit,
	ProductProfitMarginUnitPercent
FROM dimProduct


--dimResellerView
IF EXISTS (select * from sys.views WHERE name ='dimResellerView')
BEGIN
	DROP VIEW dimResellerView
END
GO

CREATE VIEW dimResellerView
AS
SELECT dimResellerKey,dimLocationKey,ResellerID,ResellerName,ContactName,PhoneNumber,Email
FROM dimReseller

--dimStoreView
IF EXISTS (select * from sys.views WHERE name ='dimStoreView')
BEGIN
	DROP VIEW dimStoreView
END
GO

CREATE VIEW dimStoreView
AS
SELECT dimStoreKey,dimLocationKey,StoreId, StoreName,StoreNumber,StoreManager
FROM dimStore

--factProductSalesTargetView
IF EXISTS (select * from sys.views WHERE name ='factProductSalesTargetView')
BEGIN
	DROP VIEW factProductSalesTargetView
END
GO

CREATE VIEW factProductSalesTargetView
AS
SELECT factSaleTargetKey,dimProductKey,dimTargetDateKey,ProductTargetSalesQuantity
FROM factProductSalesTarget



--factSalesActualView
IF EXISTS (select * from sys.views WHERE name ='factSalesActualView')
BEGIN
	DROP VIEW factSalesActualView
END
GO

CREATE VIEW factSalesActualView
AS
SELECT factSalesActualKey
	,dimProductKey
	,dimStoreKey
	,dimResellerKey
	,dimCustomerKey
	,dimChannelKey
	,dimSaleDateKey
	,dimLocationKey
	,SalesHeaderID 
	,SalesDetailID
	,SaleAmount 
	,SaleQuantity
	,SalesUnitPrice 
	,SalesExtendedCost 
	,SalesTotalProfit 
FROM factSalesActual

--factSRCSalesTargetView
IF EXISTS (select * from sys.views WHERE name ='factSRCSalesTargetView')
BEGIN
	DROP VIEW factSRCSalesTargetView
END
GO

CREATE VIEW factSRCSalesTargetView
AS
SELECT factSalesTarget
	,dimStoreKey
	,dimResellerKey
	,dimChannelKey
	,dimTargetDateKey
	,SalesTargetAmount
FROM factSRCSalesTarget


select * from dbo.View_dimChannel

IF EXISTS (select * from Views WHERE name ='View_dimDate')
BEGIN
 DROP VIEW [dbo].[View_dimDate]
END
GO

Drop view  if exists dbo.View_dimDate

select * from dbo.View_dimDate