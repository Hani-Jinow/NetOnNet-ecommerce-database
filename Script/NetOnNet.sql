USE master 
GO 

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'NetOnNet')  

	BEGIN  
		ALTER DATABASE NetOnNet SET SINGLE_USER WITH ROLLBACK  IMMEDIATE  

		DROP DATABASE NetOnNet  
	END  

CREATE DATABASE NetOnNet 
GO  

USE NetOnNet 
GO  

CREATE SCHEMA Product 
GO 

CREATE SCHEMA Sales
GO

CREATE SCHEMA HR
GO

CREATE SCHEMA Warehouse
GO

CREATE SCHEMA Shipment
GO

CREATE SCHEMA Purchasing
GO

CREATE SCHEMA System
GO

CREATE TABLE Product.Color(
ColorID INT IDENTITY(1,1) PRIMARY KEY,
ColorName NVARCHAR(10)
)

CREATE TABLE Product.Brand ( 
BrandID INT IDENTITY(1,1) PRIMARY KEY, 
BrandName NVARCHAR(50) 
) 

CREATE TABLE Product.Supplier ( 
SupplierID INT IDENTITY(1,1) PRIMARY KEY, 
CompanyName NVARCHAR(255), 
Address NVARCHAR(255), 
PhoneNumber NVARCHAR(55), 
Email NVARCHAR(255), 
ContactName NVARCHAR(55), 
ContactEmail NVARCHAR(55), 
CreditLimit DECIMAL(10,2), 
CurrentCredit DECIMAL(10,2) 
) 

CREATE TABLE Product.Category ( 
CategoryID INT IDENTITY (1,1) PRIMARY KEY, 
CategoryName NVARCHAR(50), 
Description NTEXT,
)  

CREATE TABLE Product.SubCategory ( 
SubCategoryID INT IDENTITY(1,1) PRIMARY KEY, 
SubCategoryName Nvarchar(20), 
CategoryID INT,
FOREIGN KEY (CategoryID) REFERENCES Product.Category(CategoryID)
)

CREATE TABLE Product.Product ( 
ProductID INT IDENTITY(1,1) PRIMARY KEY , 
ProductName NVARCHAR(50), 
SupplierID INT, 
BrandID INT, 
SubCategoryID INT,
ColorID INT,
UnitPrice DECIMAL(18,2), 
TaxRate DECIMAL(6,3), 
EAN NVARCHAR(50), 
Description NVARCHAR(100), 
ImageURL VARBINARY(MAX), 
Height DECIMAL(10,2), 
Length DECIMAL(10,2), 
Width DECIMAL(10,2), 
Discontinued BIT, 
CreatedAt DATETIME, 
UploadedAt DATETIME,
FOREIGN KEY (SupplierID) REFERENCES Product.Supplier(SupplierID),
FOREIGN KEY (BrandID) REFERENCES Product.Brand(BrandID),
FOREIGN KEY (SubcategoryID) REFERENCES Product.SubCategory(SubCategoryID),
FOREIGN KEY (ColorID) REFERENCES Product.Color(ColorID)
) 

CREATE TABLE Product.SerialNumber ( 
SerialID INT IDENTITY(1,1) PRIMARY KEY, 
ProductID INT, 
SerialNumber NVARCHAR(55), 
InStock BIT, 
OrderDetailID INT,
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID)
) 

CREATE TABLE System.UserType ( 
UserTypeID INT IDENTITY(1,1) PRIMARY KEY, 
TypeName NVARCHAR(8) 
) 

CREATE TABLE [System].[User] ( 
UserID INT IDENTITY(1,1) PRIMARY KEY, 
UserTypeID INT, 
UserName NVARCHAR(50), 
PasswordHash VARBINARY(128), 
Salt NVARCHAR(50), 
IsVerified BIT, 
LastEditedBy INT,
FOREIGN KEY (UserTypeID) REFERENCES System.UserType(UserTypeID)
) 

CREATE TABLE System.Log ( 
LogID INT IDENTITY(1,1) PRIMARY KEY, 
UserID INT, 
IpAddress NVARCHAR(14), 
Email NVARCHAR(14), 
AttemptTime DATETIME, 
Success BIT,
FOREIGN KEY (UserID) REFERENCES [System].[User](UserID)
) 

CREATE TABLE HR.Department ( 
DepartmentID INT IDENTITY(1,1) PRIMARY KEY, 
DepartmentName NVARCHAR(50), 
CreatedAt DATETIME, 
ModifiedAt DATETIME, 
LastEditedBy INT 
) 

CREATE TABLE HR.Employee ( 
EmployeeID INT IDENTITY(1,1) PRIMARY KEY, 
FirstName NVARCHAR(50), 
LastName NVARCHAR(50), 
UserID INT, 
DepartmentID INT, 
Email NVARCHAR(255) UNIQUE, 
HiredDate DATETIME, 
DateOfBirth DATETIME, 
EndDate DATETIME, 
IsActive BIT, 
CreatedAt DATETIME, 
ModifiedAt DATETIME, 
LastEditedBy INT REFERENCES HR.Employee(EmployeeID),
FOREIGN KEY (UserID) REFERENCES [System].[User](UserID),
FOREIGN KEY (DepartmentID) REFERENCES HR.Department(DepartmentID)
) 

CREATE TABLE HR.EmployeeSalaryType ( 
SalaryTypeID INT IDENTITY(1,1) PRIMARY KEY, 
SalaryTypeName NVARCHAR(30) 
) 

CREATE TABLE HR.EmployeeSalary ( 
SalaryID INT IDENTITY(1,1) PRIMARY KEY, 
EmployeeID INT, 
SalaryAmount INT, 
SalaryTypeID INT, 
Date DATETIME,
FOREIGN KEY (SalaryTypeID) REFERENCES HR.EmployeeSalaryType(SalaryTypeID),
FOREIGN KEY (EmployeeID) REFERENCES HR.Employee(EmployeeID)
)  

CREATE TABLE HR.Role ( 
RoleID INT IDENTITY(1,1) PRIMARY KEY, 
RoleName NVARCHAR(50), 
Description NVARCHAR(100), 
CreatedAt DATETIME, 
ModifiedAt DATETIME, 
LastEditedBy INT,
FOREIGN KEY (LastEditedBy) REFERENCES HR.Employee(EmployeeID)
) 

CREATE TABLE HR.EmployeeRole ( 
EmployeeRoleID INT IDENTITY(1,1) PRIMARY KEY, 
EmployeeID INT, 
RoleID INT,
FOREIGN KEY (EmployeeID) REFERENCES HR.Employee(EmployeeID),
FOREIGN KEY (RoleID) REFERENCES HR.Role(RoleID)
) 

CREATE TABLE Sales.Customer( 
CustomerID INT PRIMARY KEY IDENTITY (1,1), 
UserID INT, 
FirstName NVARCHAR(25), 
LastName NVARCHAR(25), 
BirthDate DATE, 
Email VARCHAR(75), 
CreatedDate DATETIME DEFAULT GETDATE(), 
IsActive BIT, 
FOREIGN KEY (UserID) REFERENCES [System].[User](UserID) 
) 

CREATE TABLE Product.ProductReview( 
ProductReviewID INT IDENTITY(1,1) PRIMARY KEY, 
ProductID INT, 
CustomerID INT, 
Rating TINYINT, 
ReviewTitle NVARCHAR(100), 
ReviewText NTEXT, 
ReviewDate DATETIME, 
IsVerifiedPurchase BIT, 
HelpfulVotes INT, 
IsEdited BIT, 
EditDate DATETIME,
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID),
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID)
) 

CREATE TABLE Sales.PhoneType( 
PhoneTypeID INT PRIMARY KEY IDENTITY (1,1), 
PhoneType NVARCHAR(20) 
) 

CREATE TABLE Sales.Phone( 
PhoneID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
PhoneTypeID INT, 
PhoneNumber VARCHAR(20),
CreatedDate DATETIME, 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (PhoneTypeID) REFERENCES Sales.PhoneType(PhoneTypeID) 
)  

CREATE TABLE Sales.AddressType( 
AddressTypeID INT PRIMARY KEY IDENTITY (1,1), 
AddressType NVARCHAR(20) 
) 

CREATE TABLE Sales.Address( 
AddressID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
AddressTypeID INT, 
Street NVARCHAR(50), 
PostalCode VARCHAR(10), 
City NVARCHAR(20), 
Country NVARCHAR(20), 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (AddressTypeID) REFERENCES Sales.AddressType(AddressTypeID) 
) 

CREATE TABLE Sales.LoyaltyProgram( 
LoyaltyID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
CreatedDate DATETIME DEFAULT GETDATE(),
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID)
) 

CREATE TABLE Sales.CustomerSupport( 
CustomerSupportID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
CloseByEmployee INT, 
Subject NVARCHAR(50), 
Description NVARCHAR(MAX), 
CreatedDate DATETIME DEFAULT GETDATE(), 
SolvedDate DATETIME, 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (CloseByEmployee) REFERENCES HR.Employee(EmployeeID) 
) 

CREATE TABLE Sales.ServiceType( 
ServiceTypeID INT PRIMARY KEY IDENTITY (1,1), 
Description NVARCHAR(20), 
) 

CREATE TABLE Sales.ServiceSupplier( 
ServiceSupplierID INT PRIMARY KEY IDENTITY (1,1), 
CompanyName NVARCHAR(25), 
ContactName NVARCHAR(50), 
Email VARCHAR(75), 
Phone VARCHAR(20),  
OrganisationNumber CHAR(11) 
) 

CREATE TABLE Sales.Service( 
ServiceID INT PRIMARY KEY IDENTITY (1,1), 
ServiceTypeID INT, 
ServiceSupplierID INT, 
Description NVARCHAR(40), 
PriceIncVat DECIMAL(7,2), 
PriceExcVat DECIMAL(7,2), 
VAT DECIMAL(6,2), 
CreatedDate DATETIME, 
IsActive BIT, 
FOREIGN KEY (ServiceTypeID) REFERENCES Sales.ServiceType(ServiceTypeID), 
FOREIGN KEY (ServiceSupplierID) REFERENCES Sales.ServiceSupplier(ServiceSupplierID) 
) 

CREATE TABLE Sales.Campaign( 
CampaignID INT PRIMARY KEY IDENTITY (1,1), 
CreatedBy INT, 
CampaignName NVARCHAR(30), 
CampaignDescription NVARCHAR(100), 
ValidFrom DATETIME, 
ValidTo DATETIME, 
FOREIGN KEY (CreatedBy) REFERENCES HR.Employee(EmployeeID) 
) 

CREATE TABLE Sales.CampaignRule( 
CampaignRuleID INT PRIMARY KEY IDENTITY (1,1), 
CampaignID INT, 
RuleDescription NVARCHAR(100), 
MinTotalQty INT, 
FOREIGN KEY (CampaignID) REFERENCES Sales.Campaign(CampaignID) 
) 

CREATE TABLE Sales.DiscountValueType( 
DiscountValueTypeID INT PRIMARY KEY IDENTITY (1,1), 
DiscountValueType NVARCHAR(10) 
) 

CREATE TABLE Sales.CampaignRuleDetail( 
RuleDetailID INT PRIMARY KEY IDENTITY (1,1), 
CampaignRuleID INT, 
ProductID INT, 
SubCategoryID INT, 
ServiceID INT, 
DiscountValueTypeID INT, 
DiscountValue DECIMAL(9,3), 
Quantity INT, 
MinQty INT, 
MaxQty INT, 
FOREIGN KEY (CampaignRuleID) REFERENCES Sales.CampaignRule(CampaignRuleID), 
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID), 
FOREIGN KEY (SubCategoryID) REFERENCES Product.SubCategory(SubCategoryID), 
FOREIGN KEY (DiscountValueTypeID) REFERENCES Sales.DiscountValueType(DiscountValueTypeID) 
) 

CREATE TABLE Sales.Discount( 
DiscountID INT PRIMARY KEY IDENTITY (1,1), 
ProductID INT, 
ServiceID INT, 
CreatedBy INT, 
DiscountValueTypeID INT, 
DiscountValue DECIMAL(9,3), 
ValidFrom DATETIME, 
ValidTo DATETIME, 
OnlyForMembers BIT, 
IsActive BIT,  
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID), 
FOREIGN KEY (ServiceID) REFERENCES Sales.Service(ServiceID), 
FOREIGN KEY (CreatedBy) REFERENCES HR.Employee(EmployeeID), 
FOREIGN KEY (DiscountValueTypeID) REFERENCES Sales.DiscountValueType(DiscountValueTypeID) 
) 

CREATE TABLE Sales.WishList( 
WishListID INT PRIMARY KEY IDENTITY (1,1) NOT NULL, 
CustomerID  INT, 
CreatedDate DATETIME, 
LastModifiedDate DATETIME, 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID) 
) 

CREATE TABLE Sales.WishListdetail( 
WishListDetailID INT PRIMARY KEY IDENTITY (1,1), 
WishListID INT, 
ProductID INT, 
DiscountID INT, 
Quantity INT, 
UnitPrice DECIMAL(10,2), 
FOREIGN KEY (WishListID) REFERENCES Sales.WishList(WishListID), 
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID), 
FOREIGN KEY (DiscountID) REFERENCES Sales.Discount(DiscountID) 
) 

CREATE TABLE Sales.ShoppingCart( 
ShoppingCartID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
WishListID INT, 
CreatedDate DATETIME, 
LastUpdated DATETIME, 
CartStatus NVARCHAR(20), 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (WishListID) REFERENCES Sales.WishList(WishListID) 
) 

CREATE TABLE Sales.ShoppingCartDetail( 
ShoppingCartDetailID INT PRIMARY KEY IDENTITY (1,1), 
ShoppingCartID INT, 
ProductID INT, 
DiscountID INT, 
ServiceID INT, 
Quantity INT, 
UnitPrice DECIMAL(10,2), 
FOREIGN KEY (ShoppingCartID) REFERENCES Sales.ShoppingCart(ShoppingCartID), 
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID), 
FOREIGN KEY (DiscountID) REFERENCES Sales.Discount(DiscountID), 
FOREIGN KEY (ServiceID) REFERENCES Sales.Service(ServiceID) 
) 

  

CREATE TABLE [Sales].[Order]( 
OrderID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
ShoppingCartID INT, 
OrderDate datetime, 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (ShoppingCartID) REFERENCES Sales.ShoppingCart(ShoppingCartID) 
) 

CREATE TABLE Sales.OrderDetail( 
OrderDetailID INT PRIMARY KEY IDENTITY (1,1), 
OrderID INT, 
DiscountID INT, 
CampaignRuleDetailsID INT,
ProductID INT, 
ServiceID INT,
Quantity INT, 
UnitPrice DECIMAL(10,2), 
VATAmount DECIMAL (10,3), 
FOREIGN KEY (OrderID) REFERENCES [Sales].[Order](OrderID), 
FOREIGN KEY (DiscountID) REFERENCES Sales.Discount(DiscountID), 
FOREIGN KEY (CampaignRuleDetailsID) REFERENCES Sales.CampaignRuleDetail(RuleDetailID), 
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID),
FOREIGN KEY (ServiceID) REFERENCES Sales.Service(ServiceID)
) 

CREATE TABLE Sales.PaymentPartner( 
PaymentPartnerID INT PRIMARY KEY IDENTITY (1,1), 
PaymentPartnerName nvarchar(30) 
) 

CREATE TABLE Sales.PaymentMethod( 
PaymentMethodID INT PRIMARY KEY IDENTITY (1,1), 
PaymentPartnerID INT, 
PaymentMethodName NVARCHAR(15), 
FOREIGN KEY (PaymentPartnerID) REFERENCES Sales.PaymentPartner(PaymentPartnerID) 
) 

CREATE TABLE Sales.Invoice( 
InvoiceID INT PRIMARY KEY IDENTITY (1,1), 
OrderID INT, 
CustomerID INT, 
AddressID INT, 
InvoiceDate DATETIME, 
DueDate DATETIME, 
AmountExclVAT DECIMAL(10,2), 
VATAmount DECIMAL(9,2), 
OutstandingBalance DECIMAL(10,2), 
FinalizedDate DATETIME, 
LastEditedDate DATETIME, 
LastEditedBy INT, 
FOREIGN KEY (OrderID) REFERENCES [Sales].[Order](OrderID), 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (AddressID) REFERENCES Sales.Address(AddressID), 
FOREIGN KEY (LastEditedBy) REFERENCES HR.Employee(EmployeeID) 
) 

CREATE TABLE [Sales].[Return]( 
ReturnID INT PRIMARY KEY IDENTITY (1,1), 
CustomerID INT, 
OrderID INT, 
HandledBy INT, 
CreatedDate DATETIME, 
OpenedDate DATETIME, 
ClosedDate DATETIME, 
FOREIGN KEY (CustomerID) REFERENCES Sales.Customer(CustomerID), 
FOREIGN KEY (OrderID) REFERENCES [Sales].[Order](OrderID), 
FOREIGN KEY (HandledBy) REFERENCES HR.Employee(EmployeeID) 
) 

CREATE TABLE Sales.ReturnReason( 
ReturnReasonID INT PRIMARY KEY IDENTITY (1,1), 
Description NVARCHAR(20) 
) 

CREATE TABLE Sales.ReturnDetail( 
ReturnDetailID INT PRIMARY KEY IDENTITY (1,1), 
ReturnID INT, 
ProductID INT, 
ReturnReasonID INT, 
Quantity INT, 
IsApproved BIT, 
FOREIGN KEY (ReturnID) REFERENCES [Sales].[Return](ReturnID), 
FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID), 
FOREIGN KEY (ReturnReasonID) REFERENCES Sales.ReturnReason(ReturnReasonID) 
) 

CREATE TABLE [Sales].[Transaction]( 
TransactionID INT PRIMARY KEY IDENTITY (1,1), 
OrderID INT, 
ReturnID INT, 
PaymentMethodID INT, 
InvoiceID INT, 
TransactionAmount DECIMAL(10,2), 
TransactionDate DATETIME,
FOREIGN KEY (OrderID) REFERENCES [Sales].[Order](OrderID),
FOREIGN KEY (ReturnID) REFERENCES [Sales].[Return](ReturnID)
) 

CREATE TABLE Sales.FAQ( 
FAQ INT PRIMARY KEY IDENTITY (1,1), 
Subject NVARCHAR(30), 
Decspription NVARCHAR(255) 
) 

CREATE TABLE Warehouse.StockItem (
	StockItemID INT IDENTITY(1,1) PRIMARY KEY,
	ProductID INT,
	WarehouseLocation INT,
	QuantityOnHand INT,
	ReorderLevel INT,
	RequireSerialNumber BIT,
	IsActive BIT,
	FOREIGN KEY (ProductID) REFERENCES Product.Product(ProductID),
	CHECK (RequireSerialNumber IN (0, 1)),
	CHECK (IsActive IN (0, 1))
)

CREATE TABLE Warehouse.TransactionType (
	TransactionTypeID INT IDENTITY(1,1) PRIMARY KEY,
	TransactionName NVARCHAR(55),
	Description TEXT
)

CREATE TABLE Warehouse.PurchaseOrder (
	PurchaseOrderID INT IDENTITY(1,1) PRIMARY KEY,
	SupplierID INT,
	CreatedByEmpID INT NOT NULL,
	OrderDate DATETIME,
	Status NVARCHAR(55),
	FOREIGN KEY (SupplierID) REFERENCES Product.Supplier(SupplierID),
	FOREIGN KEY (CreatedByEmpID) REFERENCES HR.Employee(EmployeeID)
)

CREATE TABLE Warehouse.PurchaseOrderDetail (
	PurchaseOrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
	PurchaseOrderID INT,
	StockItemID INT,
	Quantity INT,
	UnitPrice DECIMAL(10, 2),
	SerialNumber NVARCHAR(255),
	FOREIGN KEY (PurchaseOrderID) REFERENCES Warehouse.PurchaseOrder(PurchaseOrderID),
	FOREIGN KEY (StockItemID) REFERENCES Warehouse.StockItem(StockItemID)
)

CREATE TABLE Warehouse.SupplierReturn (
	ReturnID INT IDENTITY(1,1) PRIMARY KEY,
	PurchaseOrderID INT,
	ReturnDate DATETIME,
	CreatedByEmployee INT,
	Reason TEXT,
	Status NVARCHAR(50),
	FOREIGN KEY (CreatedByEmployee) REFERENCES HR.Employee(EmployeeID),
	FOREIGN KEY (PurchaseOrderID) REFERENCES Warehouse.PurchaseOrder(PurchaseOrderID),
	CHECK (Status IN ('Pending', 'Processed', 'Cancelled'))
)

CREATE TABLE Warehouse.SupplierReturnDetail (
	ReturnDetailID INT IDENTITY(1,1) PRIMARY KEY,
	ReturnID INT,
	StockItemID INT,
	Quantity INT,
	Reason TEXT,
	FOREIGN KEY (ReturnID) REFERENCES Warehouse.SupplierReturn(ReturnID),
	FOREIGN KEY (StockItemID) REFERENCES Warehouse.StockItem(StockItemID),
	CHECK (Quantity > 0)
)

CREATE TABLE Shipment.Shipper (
	ShipperID INT IDENTITY(1,1) PRIMARY KEY,
	CompanyName NVARCHAR(255) NOT NULL,
	Address NVARCHAR(255),
	PhoneNumber NVARCHAR(55),
	Email NVARCHAR(255) NOT NULL,
	ContactName NVARCHAR(55),
	ContactEmail NVARCHAR(55),
	CHECK (Email LIKE '%@%')
)

CREATE TABLE Shipment.Method (
	ShippingMethodID INT IDENTITY(1,1) PRIMARY KEY,
	ShipperID INT NOT NULL,
	Name NVARCHAR(55) UNIQUE,
	Description TEXT,
	FOREIGN KEY (ShipperID) REFERENCES Shipment.Shipper(ShipperID)
)

CREATE TABLE Shipment.Rates (
	ShippingRateID INT IDENTITY(1,1) PRIMARY KEY,
	ShippingMethodID INT NOT NULL,
	RateName NVARCHAR(55) UNIQUE,
	MinWeight DECIMAL(10, 2),
	MaxWeight DECIMAL(10, 2) CHECK (MaxWeight>= 0),
	MinVolume DECIMAL(10, 2),
	MaxVolume DECIMAL(10, 2) CHECK (MaxVolume>= 0),
	Cost DECIMAL(10, 2) NOT NULL,
	EstDeliveryDays INT,
	FOREIGN KEY (ShippingMethodID) REFERENCES Shipment.Method(ShippingMethodID)
)

CREATE TABLE Shipment.Shipment (
	ShipmentID INT IDENTITY(1,1) PRIMARY KEY,
	OrderID INT,
	ShippingMethodID INT,
	ShippingRateID INT,
	ProcessedByEmpID INT NOT NULL,
	TotalWeight DECIMAL(10, 2),
	TotalVolume DECIMAL(10, 2),
	ShipDate DATETIME NOT NULL,
	TrackingNumber NVARCHAR(255),
	FOREIGN KEY (OrderID) REFERENCES [Sales].[Order](OrderID),
	FOREIGN KEY (ShippingMethodID) REFERENCES Shipment.Method(ShippingMethodID),
	FOREIGN KEY (ShippingRateID) REFERENCES Shipment.Rates(ShippingRateID),
	FOREIGN KEY (ProcessedByEmpID) REFERENCES HR.Employee(EmployeeID),
	CHECK (TotalWeight >= 0),
	CHECK (TotalVolume >= 0)
)

CREATE TABLE Shipment.ShipmentItem (
	ShipmentItemID INT IDENTITY(1,1) PRIMARY KEY,
	ShipmentID INT NOT NULL,
	OrderDetailsID INT NOT NULL,
	Quantity INT,
	FOREIGN KEY (ShipmentID) REFERENCES Shipment.Shipment(ShipmentID),
	FOREIGN KEY (OrderDetailsID) REFERENCES Sales.OrderDetail(OrderDetailID),
	CHECK (Quantity > 0)
)

CREATE TABLE Purchasing.Invoice (
	InvoiceID INT IDENTITY(1,1) PRIMARY KEY,
	SupplierID INT NOT NULL,
	PurchaseOrderID INT,
	CreatedByEmpID INT NOT NULL,
	InvoiceDate DATETIME NOT NULL,
	DueDate DATETIME,
	InvoiceAmount DECIMAL(10, 2),
	PaidAmount DECIMAL(10, 2),
	Status NVARCHAR(20),
	FOREIGN KEY (SupplierID) REFERENCES Product.Supplier(SupplierID),
	FOREIGN KEY (PurchaseOrderID) REFERENCES Warehouse.PurchaseOrder(PurchaseOrderID),
	FOREIGN KEY (CreatedByEmpID) REFERENCES HR.Employee(EmployeeID),
	CHECK (Status IN ('Open', 'Paid', 'Partially Paid', 'Cancelled'))
)

CREATE TABLE Purchasing.InvoiceTransaction (
	TransactionID INT IDENTITY(1,1) PRIMARY KEY,
	InvoiceID INT NOT NULL,
	ProcessedByEmpID INT NOT NULL,
	TransactionTime DATETIME NOT NULL,
	Amount DECIMAL(10, 2),
	FOREIGN KEY (InvoiceID) REFERENCES Purchasing.Invoice(InvoiceID),
	FOREIGN KEY (ProcessedByEmpID) REFERENCES HR.Employee(EmployeeID)
)

CREATE TABLE [Warehouse].[Transaction](
	TransactionID INT IDENTITY(1,1) PRIMARY KEY,
	TransactionTypeID INT,
	StockItemID INT,
	OrderDetailID INT,
	ShipmentID INT,
	ReturnDetailID INT,
	PurchaseOrderID INT,
	SupplierReturnDetailID INT,
	Quantity INT,
	TransactionDate DATETIME,
	FOREIGN KEY (TransactionTypeID) REFERENCES Warehouse.TransactionType(TransactionTypeID),
	FOREIGN KEY (StockItemID) REFERENCES Warehouse.StockItem(StockItemID),
	FOREIGN KEY (OrderDetailID) REFERENCES Sales.OrderDetail(OrderDetailID),
	FOREIGN KEY (ShipmentID) REFERENCES Shipment.Shipment(ShipmentID),
	FOREIGN KEY (ReturnDetailID) REFERENCES Sales.ReturnDetail(ReturnDetailID),
	FOREIGN KEY (PurchaseOrderID) REFERENCES Warehouse.PurchaseOrder(PurchaseOrderID),
	FOREIGN KEY (SupplierReturnDetailID) REFERENCES Warehouse.SupplierReturnDetail(ReturnDetailID),
	CHECK (Quantity <> 0)
)



 INSERT INTO Sales.PhoneType
 (PhoneType)
 VALUES
 ('Mobile'),
 ('Home'),
 ('Office'),
 ('Fax')

 INSERT INTO Sales.AddressType
 (AddressType)
 VALUES
 ('Home'),
 ('Office'),
 ('Delivery'),
 ('Invoice')


 INSERT INTO Sales.ServiceType
 (Description)
 VALUES
 ('Delivery'),
 ('Insurance'),
 ('Installation')
 

 INSERT INTO Sales.ServiceSupplier
 (CompanyName, ContactName, Email, Phone, OrganisationNumber)
 VALUES
 ('Post Nord AB', 'Anna Nilsson', 'anna.nilsson@postnord.se', '070-8632604', '556711-5695'),
 ('Instabox AB', 'Petter Persson', 'petter.persson@instabox.se', '070-6244771', '556831-5393'),
 ('Solid Försäkringar AB', 'Stefan Franzén', 'stefan.franzen@solidforsakring.se', '077-6499750', '516401-8482'),
 ('Elektronikproffsen AB', 'Gunnar Andersson', 'gunnar.andersson@elektronikproffsen.se', '079-6858575', '556942-9668')

 INSERT INTO Sales.Service
 (ServiceTypeID, ServiceSupplierID, Description, PriceIncVat, PriceExcVat, VAT, CreatedDate, IsActive)
 VALUES
 (1, 1, 'Home Delivery belove 25kg', 49, 36.75, 12.25, '2025-04-21', 1),
 (1, 1, 'Home Delivery 25-50kg', 99, 74.25, 24.75, '2025-04-21', 1),
 (1, 1, 'Home Delivery above 50kg', 199, 149.25, 49.75, '2025-04-21', 1),
 (1, 1, 'Delivery to Postoffice belove 25kg', 29, 21.75, 7.25, '2025-04-21', 1),
 (1, 1, 'Delivery to Postoffice 25-50kg', 49, 36.75, 12.25, '2025-04-21', 1),
 (1, 2, 'Box delivery 0-12kg', 29, 21.75, 7.25, '2025-04-21', 1),
 (1, 2, 'Box delivery 13-25kg', 39, 29.25, 9.75, '2025-04-21', 1),
 (2, 3, 'Insurance cat.1 12 month', 99, 74.25, 24.75, '2025-04-21', 1),
 (2, 3, 'Insurance cat.2 12 month', 149, 111.75, 37.25, '2025-04-21', 1),
 (2, 3, 'Insurance cat.3 12 month', 199, 149.25, 49.75, '2025-04-21', 1),
 (2, 3, 'Insurance cat.4 12 month', 249, 186.75, 62.25, '2025-04-21', 1),
 (2, 3, 'Insurance cat.5 12 month', 299, 224.25, 74.75, '2025-04-21', 1),
 (2, 3, 'Insurance cat.6 12 month', 399, 299.25, 99.75, '2025-04-21', 1),
 (2, 3, 'Insurance cat.7 12 month', 499, 374.25, 124.75, '2025-04-21', 1),
 (3, 4, 'Installation cat.1', 499, 374.25, 124.75, '2025-04-21', 1),
 (3, 4, 'Installation cat.2', 999, 749.25, 249.75, '2025-04-21', 1)

 
 INSERT INTO Sales.PaymentPartner
 (PaymentPartnerName)
 VALUES
 ('Klarna Bank AB'),
 ('Swish AB')

 INSERT INTO Sales.PaymentMethod
 (PaymentMethodName, PaymentPartnerID)
 VALUES
 ('Credit Card', NULL),
 ('Swish', 2),
 ('Installment', 1),
 ('Invoice', NULL),
 ('Gift Card', NULL)

 INSERT INTO Sales.Customer
 (FirstName, LastName, BirthDate, Email, CreatedDate, IsActive)
 VALUES
 ('Hans', 'Svensson', '1974-06-21', 'hans.svensson@gmail.com', '2025-04-21', 1),
 ('Lotta', 'Johansson', '1999-04-01', 'lotta.johansson@gmail.com', '2025-04-21', 1),
 ('Amir', 'Ahmed', '2003-01-23', 'amir.ahmed_03@hotmail.com', '2025-04-21', 1),
 ('George', 'Yanos', '1957-11-15', 'george.yanos@hotmail.com', '2025-04-21', 1),
 ('Emilie', 'Gillén', '1985-12-12', 'emilie.gillen@gmail.com', '2025-04-21', 1),
 ('Lena', 'Philipsson', '1972-09-30', 'lena.philipsson@hotmail.com', '2025-04-21', 1),
 ('Mikael', 'Persbrandt', '1965-02-08', 'mikael.persbrandt@gmail.com', '2025-04-21', 1),
 ('Simon', 'Simonsson', '2005-03-27', 'simon.simonsson@gmail.com', '2025-04-21', 1),
 ('Ylva', 'Andersson', '1989-05-03', 'ylva.andersson@hotmail.com', '2025-04-21', 1),
 ('Jasmine', 'Chang', '1995-07-10', 'jasmine.chang@hotmail.com', '2025-04-21', 1)


INSERT INTO Sales.Address (CustomerID, AddressTypeID, Street, PostalCode, City, Country)
VALUES
(1, 1, 'Main Street 123', '11122', 'Stockholm', 'Sverige'),
(2, 2, 'Baker Street 221B', '11345', 'Stockholm', 'Sverige'),
(3, 3, 'Kungsgatan 45', '41111', 'Göteborg', 'Sverige'),
(4, 4, 'Skeppsbron 10', '11630', 'Stockholm', 'Sverige'),
(5, 1, 'Storgatan 9', '90326', 'Umeå', 'Sverige'),
(6, 2, 'Lilla Nygatan 4', '21134', 'Malmö', 'Sverige'),
(7, 3, 'Drottninggatan 16', '70210', 'Örebro', 'Sverige'),
(8, 4, 'Östra Hamngatan 12', '41109', 'Gothenburg', 'Sverige'),
(9, 1, 'Vasagatan 1', '72211', 'Västerås', 'Sverige'),
(10, 2, 'Norrlandsgatan 7', '11143', 'Stockholm', 'Sverige')

INSERT INTO Sales.Phone (CustomerID, PhoneTypeID, PhoneNumber, CreatedDate)
VALUES
(1, 1, '0701234567', GETDATE()),
(2, 2, '081234567', GETDATE()),
(3, 1, '0707654321', GETDATE()),
(4, 4, '084567890', GETDATE()),
(5, 1, '0731122334', GETDATE()),
(6, 2, '031556677', GETDATE()),
(7, 1, '0769988776', GETDATE()),
(8, 4, '090778899', GETDATE()),
(9, 3, '0723344556', GETDATE()),
(10, 3, '040112244', GETDATE());

INSERT INTO Sales.LoyaltyProgram (CustomerID)
VALUES
(1),
(2),
(3),
(4),
(5)


INSERT INTO System.UserType 
(TypeName)
VALUES ('Employee'), ('Customer')


DECLARE @SALT nvarchar(50)
select @SALT=CONVERT(NVARCHAR(50),NEWID())

INSERT INTO [System].[User] 
(UserTypeID, UserName, PasswordHash, Salt, IsVerified, LastEditedBy)
VALUES
(1, 'HansS', HASHBYTES('SHA2_512','HansSvensson' + @SALT), @SALT, 1, 1),
(1, 'LottaL', HASHBYTES('SHA2_512','LottaJohansson' + @SALT), @SALT, 1, 1),
(1, 'AmirA', HASHBYTES('SHA2_512', 'AmirAhmed' + @SALT), @SALT, 1, 1),
(1, 'GeorgeY', HASHBYTES('SHA2_512', 'GeorgeYanos' + @SALT), @SALT, 1, 1),
(1, 'EmelieG', HASHBYTES('SHA2_512', 'EmilieGillén' + @SALT), @SALT, 1, 1),
(1, 'FredrikE', HASHBYTES('SHA2_512', 'FredrikEriksson' + @SALT), @SALT, 1, 1),
(1, 'SaraL', HASHBYTES('SHA2_512', 'SaraLarsson'    + @SALT), @SALT, 1, 1),
(1, 'PeterB', HASHBYTES('SHA2_512', 'PeterBergström' + @SALT), @SALT, 1, 1),
(1, 'AnnaS', HASHBYTES('SHA2_512', 'AnnaSvensson'   + @SALT), @SALT, 1, 1),
(1, 'JohanK', HASHBYTES('SHA2_512', 'JohanKarlsson'  + @SALT), @SALT, 1, 1),
(2, 'LenaP', HASHBYTES('SHA2_512', 'LenaPhilipsson' + @SALT), @SALT, 1, 1),
(2, 'MikaelP', HASHBYTES('SHA2_512', 'MikaelPersbrandt' + @SALT), @SALT, 1, 1),
(2, 'SimonS', HASHBYTES('SHA2_512', 'SimonSimonsson' + @SALT), @SALT, 1, 1),
(2, 'YlvaA', HASHBYTES('SHA2_512', 'YlvaAndersson' + @SALT), @SALT, 1, 1),
(2, 'JasmineC', HASHBYTES('SHA2_512', 'JasmineChange' + @SALT), @SALT, 1, 1)



UPDATE Sales.Customer
SET UserID = CASE
    WHEN CustomerID = 1 THEN 1
    WHEN CustomerID = 2 THEN 2
	WHEN CustomerID = 3 THEN 3
	WHEN CustomerID = 4 THEN 4
	WHEN CustomerID = 5 THEN 5
	WHEN CustomerID = 6 THEN 11
	WHEN CustomerID = 7 THEN 12
	WHEN CustomerID = 8 THEN 13
	WHEN CustomerID = 9 THEN 14
	WHEN CustomerID = 10 THEN 15
    ELSE UserID 
END


INSERT INTO Product.Brand 
(BrandName)
VALUES 
('Acer'), ('Apple'), ('Samsung'), ('Dell'), ('Google'), ('HP'), ('Lenovo'),
('Asos'), ('Meta'), ('Microsoft'), ('Nintendo'), ('Philips'), ('PS4'), ('Siemens')

INSERT INTO Product.Color
(ColorName)

VALUES
('Black'), ('White'), ('Blue'), ('Orange'), ('Pink'), ('Red'), ('Green'), ('Yellow'), ('Brown'),
('Beige'), ('Purple'), ('Gray') 

INSERT INTO Product.Category (CategoryName, Description)
VALUES
('Computers & Tablets','Everything related to computers, laptops, tablets, and accessories.'),
('TV','Televisions, including LED, OLED, and QLED models with smart features.'),
('Audio','Headphones, speakers, soundbars, and hi‑fi systems.')

INSERT INTO Product.SubCategory (SubCategoryName, CategoryID)
VALUES
('Laptop', 1),
('Monitor', 1),
('Tablet', 1),
('OLED TV', 2),
('LED TV', 2),
('Headphones', 3),
('Speakers', 3)

INSERT INTO Product.Supplier
(CompanyName, Address, PhoneNumber, Email, ContactName, ContactEmail, CreditLimit, CurrentCredit)
VALUES
('ABC Electronics', 'Sveavägen 10, 111 57 Stockholm, Sweden','+46 8 123 456 78','sales@abcelectronics.com', 'John Andersson',
'john.andersson@abcelectronics.com', 50000.00, 15000.00),

('Nordic Supplies AB', 'Storgatan 5, 903 26 Umeå, Sweden', '+46 90 987 6543', 'info@nordicsupplies.se', 'Lisa Berg',
'lisa.berg@nordicsupplies.se', 75000.00, 32000.50),

('Gadget World', 'Mölndalsvägen 45, 412 63 Göteborg, Sweden', '+46 31 765 4321','contact@gadgetworld.com','Erik Svensson',
'erik.svensson@gadgetworld.com', 60000.00, 12000.00),
   
('Prime Tech Solutions', 'Östra Hamngatan 12, 411 09 Göteborg, Sweden', '+46 31 123 9876', 'support@primetech.se','Anna Karlsson', 
'anna.karlsson@primetech.se', 100000.00, 45000.75)

INSERT INTO Product.Product
(ProductName, SupplierID, BrandID, SubCategoryID, ColorID, UnitPrice, TaxRate, EAN, Description, ImageURL, Height, Length,
 Width, Discontinued, CreatedAt, UploadedAt)
VALUES
('MacBook Pro 14"', 1,  2, 1, 12, 19999.00, 0.250, '0194252567890', '14‑inch MacBook Pro with M2 chip', NULL,  1.55,  31.26, 22.12, 0, '2025‑04‑10 08:30:00', '2025‑04‑10 09:00:00'),
('Dell XPS 13', 2,  4, 1,  2, 15999.00, 0.250, '5397181234567', '13‑inch Dell XPS ultrabook with InfinityEdge display', NULL,  1.48,  30.20, 19.90, 0, '2025‑04‑11 10:00:00', '2025‑04‑11 10:30:00'),
('Lenovo ThinkPad X1 Carbon', 2,  7, 1,  1, 17999.00, 0.250, '0194252501234', 'Lightweight business laptop from Lenovo', NULL,  1.49,  32.00, 21.90, 0, '2025‑04‑12 11:15:00', '2025‑04‑12 12:00:00'),
('Google Pixel Tablet', 4,  5, 3,  2,  7999.00, 0.250, '0812345678901', '11‑inch Android tablet by Google', NULL,  0.70,  24.00, 16.50, 0, '2025‑04‑13 09:45:00', '2025‑04‑13 10:00:00'),
('Samsung Galaxy Tab S8', 3,  3, 3,  1,  8999.00, 0.250, '8806090945643', 'Samsung premium Android tablet with S Pen', NULL,  0.70,  25.00, 16.00, 0, '2025‑04‑14 14:00:00', '2025‑04‑14 14:30:00'),
('Philips 27" Monitor', 3, 12, 2,  1,  2999.00, 0.250, '8712587530265', '27‑inch full HD monitor from Philips', NULL, 40.00,  61.00, 24.00, 0, '2025‑04‑15 15:20:00', '2025‑04‑15 15:45:00'),
('Samsung OLED 65" TV', 3,  3, 4,  1, 15999.00, 0.250, '8806090790151', '65‑inch Samsung OLED smart TV', NULL, 80.00, 145.00,  5.00, 0, '2025‑04‑16 16:00:00', '2025‑04‑16 16:30:00'),
('Beats Solo3 Headphones', 1,  6, 6,  2,  2499.00, 0.250, '0194253001118', 'Wireless on‑ear headphones by Beats', NULL, 18.00,  17.00,  7.00, 0, '2025‑04‑17 17:10:00', '2025‑04‑17 17:40:00'),
('Philips Hue Soundbar', 1, 12, 7,  1,  3499.00, 0.250, '8718696123450', 'Soundbar with integrated LED lighting', NULL,  6.00,  90.00, 10.00, 0, '2025‑04‑18 18:25:00', '2025‑04‑18 18:50:00'),
('iPad Air', 1,  2, 3,  2,  7499.00, 0.250, '0194252567897', '10.9‑inch Apple tablet with A14 Bionic chip', NULL,  6.10, 247.60,178.50, 0, '2025‑04‑19 19:00:00', '2025‑04‑19 19:30:00')


INSERT INTO Product.SerialNumber
(ProductID, SerialNumber, InStock, OrderDetailID)
VALUES
(1,  'SN0000001', 1, 1001),
(2,  'SN0000002', 1, 1002),
(3,  'SN0000003', 1, 1003),
(4,  'SN0000004', 1, 1004),
(5,  'SN0000005', 1, 1005),
(6,  'SN0000006', 1, 1006),
(7,  'SN0000007', 1, 1007),
(8,  'SN0000008', 1, 1008),
(9,  'SN0000009', 1, 1009),
(10, 'SN0000010', 1, 1010)

INSERT INTO HR.Department
(DepartmentName, CreatedAt, ModifiedAt, LastEditedBy)
VALUES
('Executive', '2025-01-10 08:30:00', '2025-04-15 14:20:00', 1),
('Human Resources', '2025-01-12 09:00:00', '2025-04-16 10:45:00', 1),
('Finance',  '2025-01-15 10:15:00', '2025-04-14 16:10:00', 1),
('Inventory', '2025-02-01 11:00:00', '2025-04-18 09:30:00', 1),
('Customer Service', '2025-02-05 13:45:00', '2025-04-17 15:00:00', 1),
('Shipping and Receiving','2025-02-10 14:20:00', '2025-04-19 11:25:00', 1),
('IT', '2025-02-09 14:20:00', '2025-04-18 11:25:00', 1)

INSERT INTO HR.EmployeeSalaryType
(SalaryTypeName)
VALUES
('Monthly'),
('Bonus'),
('Overtime')


INSERT INTO HR.Employee (FirstName, LastName, UserID, DepartmentID, Email, HiredDate, DateOfBirth, EndDate, IsActive, CreatedAt, ModifiedAt, LastEditedBy)
VALUES
('Hans','Svensson',1,7,'hans.svensson@netonnet.se','2020-03-01','1985-06-15',NULL,1,'2020-03-01 09:00:00','2025-04-21 10:00:00',1),
('Lotta','Johansson',2,2,'lotta.johansson@netonnet.se','2019-07-15','1990-02-20',NULL,1,'2019-07-15 08:30:00','2025-04-21 10:00:00',1),
('Amir','Ahmed',3,3,'amir.ahmed@netonnet.se','2021-01-10','1988-11-05',NULL,1,'2021-01-10 10:00:00','2025-04-21 10:00:00',1),
('George','Yanos',4,4,'george.yanos@netonnet.se','2020-06-20','1987-09-12',NULL,1,'2020-06-20 09:15:00','2025-04-21 10:00:00',1),
('Emelie','Gillén',5,5,'emelie.gillen@netonnet.se','2018-11-01','1992-04-18',NULL,1,'2018-11-01 08:45:00','2025-04-21 10:00:00',1),
('Fredrik','Eriksson',6,4,'fredrik.eriksson@netonnet.se','2019-03-05','1989-12-30',NULL,1,'2019-03-05 09:00:00','2025-04-21 10:00:00',1),
('Sara','Larsson',7,5,'sara.larsson@netonnet.se','2021-05-12','1991-07-22',NULL,1,'2021-05-12 10:30:00','2025-04-21 10:00:00',1),
('Peter','Bergström',8,6,'peter.bergstrom@netonnet.se','2020-10-07','1986-01-28',NULL,1,'2020-10-07 11:00:00','2025-04-21 10:00:00',1),
('Anna','Svensson',9,3,'anna.svensson@netonnet.se','2019-12-02','1993-05-09',NULL,1,'2019-12-02 09:45:00','2025-04-21 10:00:00',1),
('Johan','Karlsson',10,7,'johan.karlsson@netonnet.se','2021-02-18','1990-08-14',NULL,1,'2021-02-18 08:50:00','2025-04-21 10:00:00',1)


INSERT INTO Sales.CustomerSupport (CustomerID, CloseByEmployee, Subject, Description, SolvedDate)
VALUES
(1, 5, 'Försenad leverans', 'Produkten kom senare än förväntat.', '2025-04-10'),
(2, 5, 'Skadad vara', 'Varan var skadad vid leverans.', '2025-04-12'),
(3, 5, 'Felaktig faktura', 'Jag fick en faktura för något jag inte har beställt.', '2025-04-15'),
(4, 5, 'Problem med inloggning', 'Jag kan inte logga in på mitt konto.', NULL),
(5, 5, 'Betalning misslyckades', 'Min betalning nekades men pengar drogs ändå.', '2025-04-14'),
(7, 5, 'Ingen återbetalning', 'Jag blev lovad en återbetalning men har inte fått den ännu.', NULL),
(8, 5, 'Ta bort konto', 'Jag vill ta bort mitt konto permanent.', '2025-04-17')


INSERT INTO HR.EmployeeSalary (EmployeeID, SalaryAmount, SalaryTypeID, Date)
VALUES
(1, 30000, 1, '2025-04-01'),
(1, 1500, 3, '2025-04-01'),
(2, 30000, 1, '2025-04-01'),
(2, 1500, 3, '2025-04-01'),
(3, 30000, 1, '2025-04-01'),
(3, 1500, 3, '2025-04-01'),
(4, 30000, 1, '2025-04-01'),
(4, 1500, 3, '2025-04-01'),
(5, 30000, 1, '2025-04-01'),
(5, 1500, 3, '2025-04-01'),
(6, 30000, 1, '2025-04-01'),
(6, 1500, 3, '2025-04-01'),
(7, 30000, 1, '2025-04-01'),
(7, 1500, 3, '2025-04-01'),
(8, 30000, 1, '2025-04-01'),
(8, 1500, 3, '2025-04-01'),
(9, 30000, 1, '2025-04-01'),
(9, 1500, 3, '2025-04-01'),
(10, 30000, 1, '2025-04-01'),
(10, 1500, 3, '2025-04-01')

INSERT INTO HR.Role
(RoleName, Description, CreatedAt, ModifiedAt, LastEditedBy)
VALUES
('CEO', 'Chief Executive Officer, overall leadership', '2025-04-21 10:00:00', '2025-04-21 10:00:00', 1),
('HR Manager', 'Manages recruitment, training and employee relations', '2025-04-21 10:01:00', '2025-04-21 10:01:00', 1),
('System Administrator', 'Maintains IT infrastructure, security and user support', '2025-04-21 10:02:00', '2025-04-21 10:02:00', 1),
('Inventory Clerk', 'Handles stock counting, bin replenishment and inventory record-keeping', '2025-04-21 10:03:00', '2025-04-21 10:03:00', 1),
('Warehouse Supervisor', 'Oversees warehouse operations, team coordination and safety compliance', '2025-04-21 10:04:00', '2025-04-21 10:04:00', 1),
('Customer Service Representative', 'Responds to customer inquiries, complaints and support tickets', '2025-04-21 10:05:00', '2025-04-21 10:05:00', 1),
('Shipping Coordinator', 'Coordinates outbound shipments, carrier scheduling and shipment tracking', '2025-04-21 10:06:00', '2025-04-21 10:06:00', 1),
('Accountant', 'Prepares financial statements and oversees bookkeeping', '2025-04-21 10:07:00', '2025-04-21 10:07:00', 1)

INSERT INTO HR.EmployeeRole (EmployeeID, RoleID)
VALUES
(1,3),
(2,2),
(3,1),
(4,4),
(5,5),
(6,6),
(7,7),
(8,8),
(9,4),
(10,6)

INSERT INTO Product.ProductReview (ProductID, CustomerID, Rating, ReviewTitle, ReviewText, ReviewDate, IsVerifiedPurchase, HelpfulVotes, IsEdited, EditDate)
VALUES
(1, 1, 5, 'Excellent laptop', 'The performance and battery life are outstanding.', '2025-03-15 10:20:00', 1, 12, 1, '2025-03-20 08:00:00'),
(2, 2, 4, 'Great monitor', 'Crisp image and easy setup, but a bit pricey.', '2025-02-10 14:30:00', 1, 5, 0, NULL),
(3, 3, 3, 'Decent tablet', 'Good for media, but lags with heavy apps.', '2025-04-01 09:00:00', 0, 3, 1, '2025-04-05 12:00:00'),
(4, 4, 5, 'Amazing soundbar', 'Improves TV audio drastically, highly recommend.', '2025-01-25 18:45:00', 1, 8, 0, NULL),
(5, 5, 2, 'Not as expected', 'The keyboard keys felt mushy and unresponsive.', '2025-03-05 12:15:00', 0, 1, 1, '2025-03-06 07:30:00')

INSERT INTO System.Log (UserID, IpAddress, Email, AttemptTime, Success)
VALUES
(1, '192.168.1.10', 'hans@nn.se',        '2025-04-21 09:15:00', 1),
(2, '10.0.0.5',     'lotta@nn.se',       '2025-04-21 09:20:00', 1),
(3, '172.16.0.2',   'amir@nn.se',        '2025-04-21 09:25:00', 1),
(4, '203.0.113.8',  'george@nn.se',      '2025-04-21 09:30:00', 1),
(5, '198.51.100.23','emelie@nn.se',      '2025-04-21 09:35:00', 1)

INSERT INTO Warehouse.StockItem (ProductID, WarehouseLocation, QuantityOnHand, ReorderLevel, RequireSerialNumber, IsActive)
VALUES
(1, 12, 1243, 500, 0, 1),
(2, 3, 13, 5, 1, 1),
(3, 6, 42, 40, 0, 1),
(4, 152, 89, 50, 0, 1),
(5, 154, 16, 10, 1, 1),
(6, 55, 12, 10, 1, 1),
(7, 5, 19, 20, 1, 1),
(8, 102, 129, 100, 0, 1),
(9, 17, 72, 70, 0, 1),
(10, 19, 110, 100, 0, 1)


INSERT INTO Warehouse.TransactionType (TransactionName, Description)
VALUES 
('Supplier Delivery', 'Items received from supplier.'),
('Customer Shipment', 'Items shipped to customer.'),
('Customer Return', 'Returned items from customer.'),
('Return to Supplier', 'Items sent back to supplier.'),
('Stock Adjustment', 'Manual inventory')

INSERT INTO Warehouse.PurchaseOrder (SupplierID,CreatedByEmpID,OrderDate,Status)
VALUES
(1,5,'2025-04-01 10:00:00', 'Pending'),
(2,5,'2025-04-05 14:30:00', 'Approved'),
(3,5,'2025-04-10 09:15:00', 'Received'),
(4,5,'2025-04-15 13:45:00', 'Cancelled')

INSERT INTO Warehouse.PurchaseOrderDetail (PurchaseOrderID,StockItemID,Quantity,UnitPrice,SerialNumber)
VALUES
(1,2,1,15999.00,'SN0000002'),
(2,5,1,8999.00,'SN0000005'),
(3,6,1,2999.00,'SN0000006'),
(4,7,1,15999.00,'SN0000007')

INSERT INTO Warehouse.SupplierReturn(PurchaseOrderID,ReturnDate,CreatedByEmployee,Reason,Status)
VALUES
(1, '2025-04-21 09:00:00', 4, 'Incorrect product delivered', 'Pending'),
(2, '2025-04-22 10:30:00', 4, 'Damaged upon delivery', 'Processed'),
(3, '2025-04-23 11:15:00', 4, 'Redundant order', 'Cancelled')

INSERT INTO Purchasing.Invoice(SupplierID,PurchaseOrderID,CreatedByEmpID,InvoiceDate,DueDate,InvoiceAmount,PaidAmount,Status)
VALUES
(1, 1, 5, '2025-04-01 09:00:00', '2025-05-01 00:00:00', 15999.00, 0.00, 'Open'),
(2, 2, 5, '2025-04-05 10:30:00', '2025-05-05 00:00:00', 8999.00, 8999.00, 'Paid'),
(3, 4, 5, '2025-04-10 11:15:00', '2025-05-10 00:00:00', 15999.00, 999.00, 'Partially Paid'),
(4, 3, 5, '2025-04-15 14:45:00', '2025-05-15 00:00:00', 2999.00, 0.00, 'Cancelled')

INSERT INTO Purchasing.InvoiceTransaction (InvoiceID, ProcessedByEmpID, TransactionTime, Amount)
VALUES
(2, 5, '2025-04-05 15:30:00', 8999.00),
(3, 5, '2025-04-06 09:45:00', 999.00)

INSERT INTO Warehouse.SupplierReturnDetail(ReturnID,StockItemID,Quantity,Reason)
VALUES
(2, 5, 1, 'Defective upon delivery'),
(3, 6, 1, 'Redundant order'),
(1, 2, 1, 'Incorrect product sent')


INSERT INTO Shipment.Shipper 
(CompanyName, Address, PhoneNumber, Email, ContactName, ContactEmail)
VALUES
('PostNord Sverige AB', 'Terminalvägen 24, 171 73 Solna', '0771-33 33 10', 'info@postnord.se', 'Erik Eriksson', 'erik.eriksson@postnord.se'),
('Instabox AB', 'Malmvägen 12, 115 34 Stockholm', '08-555 123 45', 'kontakt@instabox.se', 'Petter Persson', 'petter.persson@instabox.se')


INSERT INTO Shipment.Method (ShipperID, Name, Description)
VALUES
(1, 'PostNord Home Delivery', 'Leveranstid 3–5 arbetsdagar.'),
(1, 'PostNord Postoffice', 'Leveranstid 1–2 dagar.'),
(2, 'InstaBox', 'Box Delivery 1-3 dagar')


INSERT INTO Shipment.Rates 
(ShippingMethodID, RateName, MinWeight, MaxWeight, MinVolume, MaxVolume, Cost, EstDeliveryDays)
VALUES
(1, 'Home Delivery Light', 0.00, 24.99, 0.00, 10.00, 99.00, 5),
(1, 'Home Delivery Heavy', 25.00, 100.00, 10.01, 50.00, 199.00, 5),
(2, 'PostOffice Light', 0.00, 24.99, 0.00, 5.00, 49.00, 2),
(2, 'PostOffice Heavy', 25.00, 50.00, 5.01, 20.00, 149.00, 2),
(3, 'Box Delivery Light', 0.00, 12.00, 0.00, 15.00, 29.00, 3),
(3, 'Box Delivery Heavy', 12.01, 25.00, 15.01, 40.00, 59.00, 3)


INSERT INTO Sales.WishList
(CustomerID, CreatedDate, LastModifiedDate)
VALUES
(1, '2025-04-01', '2025-04-01'),
(4, '2025-02-28', '2025-02-28')

INSERT INTO Sales.WishListdetail
(WishListID, ProductID, Quantity, UnitPrice)
VALUES
(1, 7, 1, 15999),
(1, 9, 1, 3499),
(2, 10, 1, 7499)

INSERT INTO Sales.ShoppingCart
(CustomerID, WishListID, CreatedDate, LastUpdated, CartStatus)
VALUES
(5, NULL, '2025-01-25', '2025-01-25', 'Purchased'),
(2, NULL, '2025-02-10', '2025-02-10', 'Purchased'),
(3, NULL, '2025-02-28', '2025-02-28', 'Purchased'),
(6, 2, '2025-03-08', '2025-03-08', 'Purchased'),
(4, NULL, '2025-03-19', '2025-03-19', 'Purchased'),
(7, NULL, '2025-04-02', '2025-04-02', 'Purchased'),
(8, 1, '2025-04-13', '2025-04-13', 'Purchased'),
(1, NULL, '2025-04-15', '2025-04-15', 'Purchased'),
(9, NULL, '2025-04-18', '2025-04-18', 'Purchased'),
(10, NULL, '2025-04-22', '2025-04-22', 'Purchased')

INSERT INTO Sales.ShoppingCartDetail
(ShoppingCartID, ProductID, ServiceID, Quantity, UnitPrice)
VALUES
(1, 2, NULL, 1, 15999),
(1, NULL, 1, 1, 49),
(2, 8, NULL, 1, 2499),
(2, NULL, 4, 1, 29),
(3, 10, NULL, 1, 7499),
(3, 8, NULL, 1, 2499),
(3, NULL, 6, 1, 29),
(3, NULL, 10, 1, 199),
(4, 10, NULL, 1, 7499),
(4, NULL, 1, 1, 49),
(5, 6, NULL, 1, 2999),
(5, NULL, 4, 1, 29),
(6, 5, NULL, 1, 8999),
(6, 8, NULL, 1, 2499),
(6, NULL, 6, 1, 29),
(6, NULL, 10, 1, 199),
(7, 7, NULL, 1, 15999),
(7, 9, NULL, 1, 3499),
(7, NULL, 2, 1, 99),
(8, 1, NULL, 1, 19999),
(8, NULL, 4, 1, 29),
(9, 3, NULL, 1, 17999),
(9, NULL, 1, 1, 49),
(10, 8, NULL, 1, 2499),
(10, NULL, 6, 1, 29)

INSERT INTO [Sales].[Order]
(CustomerID, ShoppingCartID, OrderDate)
VALUES
(5, 1, '2025-01-25'),
(2, 2, '2025-02-10'),
(3, 3, '2025-02-28'),
(6, 4, '2025-03-08'),
(4, 5, '2025-03-19'),
(7, 6, '2025-04-02'),
(8, 7, '2025-04-13'),
(1, 8, '2025-04-15'),
(9, 9, '2025-04-18'),
(10, 10, '2025-04-22')

INSERT INTO Sales.OrderDetail
(OrderID, ProductID, ServiceID, Quantity, UnitPrice, VATAmount)
VALUES
(1, 2, NULL, 1, 15999, (15999*0.25)),
(1, NULL, 1, 1, 49, (49*0.25)),
(2, 8, NULL, 1, 2499, (2499*0.25)),
(2, NULL, 4, 1, 29, (29*0.25)),
(3, 10, NULL, 1, 7499, (7499*0.25)),
(3, 8, NULL, 1, 2499, (2499*0.25)),
(3, NULL, 6, 1, 29, (29*0.25)),
(3, NULL, 10, 1, 199, (199*0.25)),
(4, 10, NULL, 1, 7499, (7499*0.25)),
(4, NULL, 1, 1, 49, (49*0.25)),
(5, 6, NULL, 1, 2999, (2999*0.25)),
(5, NULL, 4, 1, 29, (29*0.25)),
(6, 5, NULL, 1, 8999, (8999*0.25)),
(6, 8, NULL, 1, 2499, (2499*0.25)),
(6, NULL, 7, 1, 39, (39*0.25)),
(6, NULL, 10, 1, 199, (199*0.25)),
(7, 7, NULL, 1, 15999, (15999*0.25)),
(7, 9, NULL, 1, 3499, (3499*0.25)),
(7, NULL, 2, 1, 99, (99*0.25)),
(8, 1, NULL, 1, 19999, (19999*0.25)),
(8, NULL, 4, 1, 29, (29*0.25)),
(9, 3, NULL, 1, 17999, (17999*0.25)),
(9, NULL, 1, 1, 49, (49*0.25)),
(10, 8, NULL, 1, 2499, (2499*0.25)),
(10, NULL, 6, 1, 29, (29*0.25))

INSERT INTO Sales.DiscountValueType (DiscountValueType)
VALUES
('Amount'), ('Percentage')

INSERT INTO Sales.Campaign (CreatedBy, CampaignName, CampaignDescription, ValidFrom, ValidTo)
VALUES
(2, 'Spring Sale', '10% off on all laptops and tablets',  '2025-04-22 00:00:00', '2025-05-05 23:59:59'),
(4, 'Back to School', 'Special student pricing on monitors',  '2025-08-15 00:00:00', '2025-09-01 23:59:59'),
(5, 'Black Friday','Doorbuster deals on TVs and accessories',  '2025-11-27 00:00:00', '2025-11-27 23:59:59')


INSERT INTO Sales.CampaignRule
(CampaignID, RuleDescription)
VALUES
(1, '10% off on all Laptops and Tablets'),
(2, '30% off on monitors when buying a laptop'),
(3, '25% off on TVs and accessories')



INSERT INTO Sales.CampaignRuleDetail
(CampaignRuleID, ProductID, SubCategoryID, DiscountValueTypeID, DiscountValue, Quantity, MinQty, MaxQty)
VALUES
(1, NULL, 1, 2, 0.10, NULL, NULL, NULL),
(1, NULL, 3, 2, 0.10, NULL, NULL, NULL),
(2, NULL, 2, 2, 0.30, 1, NULL, NULL),
(2, NULL, 1, 2, 0, 1, NULL, NULL),
(3, NULL, 4, 2, 0.25, NULL, NULL, NULL),
(3, NULL, 5, 2, 0.25, NULL, NULL, NULL),
(3, NULL, 6, 2, 0.25, NULL, NULL, NULL),
(3, NULL, 7, 2, 0.25, NULL, NULL, NULL)


INSERT INTO Sales.Discount (ProductID,ServiceID,CreatedBy,DiscountValueTypeID,DiscountValue,ValidFrom,ValidTo,OnlyForMembers,IsActive)
VALUES
(1,NULL,1,2,0.100,'2025-04-22 00:00:00','2025-05-15 23:59:59',1,1),
(3,NULL,2,1,500.000,'2025-04-25 00:00:00','2025-05-05 23:59:59',1,1),
(4,NULL,3,2,0.150,'2025-06-01 00:00:00','2025-06-30 23:59:59',1,1),
(5,NULL,4,2,0.050,'2025-11-27 00:00:00','2025-11-27 23:59:59',1,1),
(6,NULL,5,1,200.000,'2025-12-15 00:00:00','2025-12-31 23:59:59',1,1)


INSERT INTO Shipment.Shipment (OrderID,ShippingMethodID,ShippingRateID,ProcessedByEmpID,TotalWeight,TotalVolume,ShipDate,TrackingNumber)
VALUES
(1,1,1,4,12.50,0.20,'2025-01-26 10:30:00','TRK0001001'),
(2,2,3,9,5.75,0.08,'2025-02-11 11:45:00','TRK0001002'),
(3,3,5,4,7.00,0.12,'2025-03-01 09:15:00','TRK0001003'),
(4,1,1,9,10.00,0.18,'2025-03-09 12:00:00','TRK0001004'),
(5,2,3,4,8.25,0.10,'2025-03-20 08:45:00','TRK0001005'),
(6,3,6,9,15.40,0.30,'2025-04-03 09:15:00','TRK0001006'),
(7,1,2,4,25.75,0.05,'2025-04-14 10:00:00','TRK0001007'),
(8,2,3,9,9.50,0.18,'2025-04-16 11:20:00','TRK0001008'),
(9,1,1,4,6.80,0.14,'2025-04-19 07:30:00','TRK0001009'),
(10,3,5,9,11.25,0.22,'2025-04-23 08:00:00','TRK0001010')


INSERT INTO Shipment.ShipmentItem (ShipmentID,OrderDetailsID,Quantity)
VALUES
(1, 1, 1),
(2, 3, 1),
(3, 5, 1),
(3, 6, 1),
(4, 9, 1),
(5, 11, 1),
(6, 13, 1),
(6, 14, 1),
(7, 17, 1),
(7, 18, 1),
(8, 20, 1),
(9, 22, 1),
(10, 24, 1)


INSERT INTO Sales.[Return] 
(CustomerID, OrderID, HandledBy, CreatedDate, OpenedDate, ClosedDate)
VALUES
(5, 1, 4, '2025-04-20 10:00:00', '2025-04-20 10:15:00', '2025-04-22 16:00:00'),
(2, 2, 9, '2025-04-21 11:30:00', '2025-04-21 12:00:00', '2025-04-24 17:30:00'),
(3, 3, 4, '2025-04-22 09:45:00', '2025-04-22 10:05:00', '2025-04-23 14:30:00')


INSERT INTO Sales.ReturnReason 
(Description)
VALUES
('Defective product'),
('Wrong item delivered'),
('Changed mind'),
('Missing parts'),
('Late delivery');


INSERT INTO Sales.ReturnDetail 
(ReturnID,ProductID,ReturnReasonID,Quantity,IsApproved)
VALUES
(1,2,3,1,1),
(2,8,4,1,1),
(3,10,1,1,1)

INSERT INTO Sales.Invoice
(OrderID, CustomerID, AddressID, InvoiceDate, DueDate, AmountExclVAT, VATAmount, OutstandingBalance, FinalizedDate, LastEditedDate, LastEditedBy)
VALUES
(7, 8, 8, '2025-04-13', '2025-04-28', (SELECT SUM(UnitPrice*Quantity) - SUM(VATAmount) FROM Sales.OrderDetail WHERE OrderID = 7), 
(SELECT SUM(VATAmount) FROM Sales.OrderDetail WHERE OrderID = 7), 0, '2025-04-28', '2025-04-28', 1),
(8, 1, 1, '2025-04-15', '2025-04-28', (SELECT SUM(UnitPrice*Quantity) - SUM(VATAmount) FROM Sales.OrderDetail WHERE OrderID = 8), 
(SELECT SUM(VATAmount) FROM Sales.OrderDetail WHERE OrderID = 8), 0, '2025-04-28', '2025-04-28', 1),
(9, 9, 9, '2025-04-18', '2025-04-28', (SELECT SUM(UnitPrice*Quantity) - SUM(VATAmount) FROM Sales.OrderDetail WHERE OrderID = 9), 
(SELECT SUM(VATAmount) FROM Sales.OrderDetail WHERE OrderID = 9), 0, '2025-04-28', '2025-04-28', 1)


INSERT INTO Sales.[Transaction]
(OrderID, ReturnID, PaymentMethodID, InvoiceID, TransactionAmount, TransactionDate)
VALUES
(1, NULL, 1, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 1), '2025-01-25'),
(2, NULL, 2, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 2), '2025-02-10'),
(3, NULL, 2, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 3), '2025-02-28'),
(4, NULL, 2, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 4), '2025-03-08'),
(5, NULL, 2, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 5), '2025-03-19'),
(6, NULL, 2, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 6), '2025-04-02'),
(1, 1, 1, NULL, (SELECT Quantity * ((SELECT UnitPrice FROM Sales.OrderDetail WHERE OrderID = 1 AND ProductID = 2) * -1) 
FROM Sales.ReturnDetail WHERE ReturnID = 1 AND ProductID = 2), '2025-04-22'),
(10, NULL, 1, NULL, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 10), '2025-04-22'),
(3, 3, 2, NULL, (SELECT Quantity * ((SELECT UnitPrice FROM Sales.OrderDetail WHERE OrderID = 3 AND ProductID = 10) * -1) 
FROM Sales.ReturnDetail WHERE ReturnID = 3 AND ProductID = 10), '2025-04-22'),
(2, 2, 2, NULL, (SELECT Quantity * ((SELECT UnitPrice FROM Sales.OrderDetail WHERE OrderID = 2 AND ProductID = 8) *-1) 
FROM Sales.ReturnDetail WHERE ReturnID = 2 AND ProductID = 8), '2025-04-24'),
(7, NULL, 4, 1, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 7), '2025-04-28'),
(8, NULL, 4, 2, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 8), '2025-04-28'),
(9, NULL, 4, 3, (SELECT SUM(UnitPrice*Quantity) FROM Sales.OrderDetail WHERE OrderID = 9), '2025-04-28')

INSERT INTO Warehouse.[Transaction] 
(TransactionTypeID, StockItemID, OrderDetailID, ShipmentID, ReturnDetailID,
PurchaseOrderID, SupplierReturnDetailID, Quantity, TransactionDate)
VALUES
(4, 2, NULL, NULL, NULL, 1, 1, -1, '2025-04-01 09:00:00'), 
(4, 5, NULL, NULL, NULL, 2, 2, -1, '2025-04-02 10:30:00'), 
(1, 7, NULL, NULL, NULL, 4, NULL, 1, '2025-04-03 11:15:00'), 
(4, 6, NULL, NULL, NULL, 3 ,3, -1, '2025-04-04 14:45:00'),
(2, 2, 1, 1, NULL, NULL, NULL, -1, '2025-01-25 22:16:00'),
(2, 8, 3, 2, NULL, NULL, NULL, -1, '2025-02-10 17:02:00'),
(2, 10, 5, 3, NULL, NULL, NULL, -1, '2025-02-28 09:24:00'),
(2, 8, 6, 3, NULL, NULL, NULL, -1,'2025-02-28 09:24:00'), 
(2, 10, 9, 4, NULL, NULL, NULL, -1, '2025-03-08 09:24:00'),
(2, 6, 11, 5, NULL, NULL, NULL, -1, '2025-03-19 09:24:00'),
(2, 5, 13, 6, NULL, NULL, NULL, -1,'2025-04-02 09:24:00'),
(2, 8, 14, 6, NULL, NULL, NULL, -1,'2025-04-02 09:24:00'),
(2, 7, 17, 7, NULL, NULL, NULL, -1,'2025-04-13 09:24:00'), 
(2, 9, 18, 7, NULL, NULL, NULL, -1,'2025-04-13 09:24:00'), 
(2, 1, 20, 8, NULL, NULL, NULL, -1,'2025-04-15 10:24:00'), 
(2, 3, 22, 9, NULL, NULL, NULL, -1,'2025-04-18 11:24:00'), 
(2, 8, 24, 10, NULL, NULL, NULL, -1,'2025-04-22 12:24:00'), 
(3, 2, 1, 1, 1, NULL, NULL, 1, '2025-04-22 16:00:00'), 
(3, 8, 3, 2, 2, NULL, NULL, 1, '2025-04-24 17:30:00'), 
(3, 10, 5, 3, 3, NULL, NULL, 1, '2025-04-23 14:30:00') 

