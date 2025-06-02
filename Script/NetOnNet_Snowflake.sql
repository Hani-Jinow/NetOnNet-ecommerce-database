USE master 
GO 

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'NetOnNet_Snowflake')  

	BEGIN  
		ALTER DATABASE NetOnNet_Snowflake SET SINGLE_USER WITH ROLLBACK  IMMEDIATE  

		DROP DATABASE NetOnNet_Snowflake  
	END  


CREATE DATABASE NetonNet_Snowflake
GO

Use NetonNet_Snowflake
GO

	CREATE TABLE DimCustomer (
		CustomerID INT PRIMARY KEY,
		FirstName NVARCHAR(30),
		LastName NVARCHAR(30),
		Email VARCHAR(70),
		Street NVARCHAR(50),
		City NVARCHAR(30),
		PostalCode VARCHAR(10),
		Country NVARCHAR(30),
		)

	INSERT INTO DimCustomer (
		CustomerID, 
		FirstName, 
		LastName,
		Email, 
		Street, 
		City, 
		PostalCode,
		Country
		)
	SELECT 
		sl.CustomerID, 
		sl.FirstName, 
		sl.LastName, 
		sl.Email, 
		sa.Street, 
		sa.PostalCode,
		sa.City, 
		sa.Country
	FROM NetOnNet.Sales.Customer sl
	INNER JOIN NetOnNet.Sales.Address sa ON sl.CustomerID = sa.CustomerID

	CREATE TABLE DimSubCategory(
		SubCategoryID INT PRIMARY KEY,
		SubCategoryName NVARCHAR(20)
		)

	INSERT INTO DimSubCategory(
		SubCategoryID,
		SubCategoryName
		)
	SELECT
		SubCategoryID,
		SubCategoryName
	FROM NetOnNet.Product.SubCategory

	CREATE TABLE DimProduct(
		ProductID INT PRIMARY KEY,
		SubCategoryID INT,
		ProductName NVARCHAR(50),
		EAN VARCHAR(50),
		SerieNumber VARCHAR(55),
		FOREIGN KEY (SubCategoryID) REFERENCES DimSubCategory(SubCategoryID)
		)

	INSERT INTO DimProduct(
		ProductID,
		SubCategoryID,
		ProductName,
		EAN,
		SerieNumber
		)
	SELECT
		pp.ProductID,
		pp.SubCategoryID,
		pp.ProductName,
		pp.EAN,
		ps.SerialNumber
	FROM NetOnNet.Product.Product pp
	INNER JOIN NetOnNet.Product.SerialNumber ps ON pp.ProductID = ps.ProductID

	CREATE TABLE DimService (
	ServiceID INT PRIMARY KEY,
	Decription NVARCHAR(100),
	PriceIncVAT DECIMAL(10,2),
	VAT DECIMAL(6,2)
	)

	INSERT INTO DimService 
		(ServiceID, 
		Decription, 
		PriceIncVAT, 
		VAT)
	SELECT 
		ServiceID, 
		Description, 
		PriceIncVat,
		VAT
	FROM NetOnNet.Sales.Service


	CREATE TABLE DimShipper(
		ShippingID INT PRIMARY KEY,
		CompanyName NVARCHAR(70),
		Address NVARCHAR(255),
		PhoneNumber NVARCHAR(55),
		Email NVARCHAR(255),
		ContactName NVARCHAR(50),
		ContactEmail NVARCHAR(100)
		)

	INSERT INTO DimShipper(
		ShippingID,
		CompanyName,
		Address,
		PhoneNumber,
		Email,
		ContactName,
		ContactEmail
		)
	SELECT
	ShipperID,
	CompanyName,
	Address,
	PhoneNumber,
	Email,
	ContactName,
	ContactEmail
	FROM NetOnNet.Shipment.Shipper
	
	CREATE TABLE DimOrder(
	OrderID INT PRIMARY KEY,
	OrderDate DATETIME,
	ShippingDate DATETIME
	)

	INSERT INTO DimOrder(
	OrderID,
	OrderDate,
	ShippingDate
	)

	SELECT 
		so.OrderID, 
		so.OrderDate, 
		ss.ShipDate
	FROM NetOnNet.[Sales].[Order] so
	INNER JOIN NetOnNet.Shipment.Shipment ss ON so.OrderID = ss.OrderID 


	CREATE TABLE DimOrderDetail(
	OrderLineID INT PRIMARY KEY,
	OrderID INT,
	ProductID INT,
	UnitPrice DECIMAL(10,2),
	Quantity INT
	FOREIGN KEY (OrderID) REFERENCES DimOrder(OrderID),
	FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID)
	)

	INSERT INTO DimOrderDetail(
	OrderLineID,
	OrderID,
	ProductID,
	UnitPrice,
	Quantity
	)

	SELECT OrderDetailID, OrderID, ProductID, UnitPrice, Quantity
	FROM NetOnNet.Sales.OrderDetail

	CREATE TABLE DimDate(
	DateID INT PRIMARY KEY,
    [Date] DATE,
    Week INT,
    Month NVARCHAR(20),
    Quarter INT,
    Year INT
	)

	INSERT INTO DimDate(
	DateID,
	Date,
	Week,
	Month,
	Quarter,
	Year
	)

	SELECT DISTINCT 
	OrderID,
    OrderDate,
    DATEPART(WEEK, OrderDate),
    MONTH(OrderDate),
    DATEPART(QUARTER, OrderDate),
    YEAR(OrderDate)
	FROM NetOnNet.[Sales].[Order]

	CREATE TABLE FactSales(
	FactSalesID INT PRIMARY KEY IDENTITY(1,1),
	ProductID INT FOREIGN KEY REFERENCES DimProduct(ProductID),
	ServiceID INT FOREIGN KEY REFERENCES DimService(ServiceID),
	CustomerID INT FOREIGN KEY REFERENCES DimCustomer(CustomerID),
	OrderID INT  FOREIGN KEY REFERENCES DimOrder(OrderID),
	DateID INT FOREIGN KEY REFERENCES DimDate(DateID),
	ShippingID INT FOREIGN KEY REFERENCES DimShipper(ShippingID),
	Quantity INT,
	TotalSales DECIMAL(18,2),
	Date DATETIME
	)

	INSERT INTO FactSales(
	ProductID,
	ServiceID,
	CustomerID,
	OrderID,
	DateID,
	ShippingID,
	Quantity,
	TotalSales,
	Date
	)

	SELECT 
    od.ProductID,
	od.ServiceID,
    o.CustomerID,
    o.OrderID,
    d.DateID,
    s.ShipperID,
    od.Quantity,
    (od.UnitPrice * od.Quantity) AS TotalSales,
    o.OrderDate
FROM NetOnNet.Sales.OrderDetail od
LEFT JOIN NetOnNet.Sales.[Order] o ON od.OrderID = o.OrderID
INNER JOIN NetOnNet.Shipment.Shipment sh ON o.OrderID = sh.OrderID
INNER JOIN NetOnNet.Shipment.Method sm ON sh.ShippingMethodID = sm.ShippingMethodID
INNER JOIN NetOnNet.Shipment.Shipper s ON sm.ShipperID = s.ShipperID
INNER JOIN DimDate d ON d.[Date] = CAST(o.OrderDate AS DATE)
LEFT JOIN NetOnNet.Sales.Service sv ON od.ServiceID = sv.ServiceID

