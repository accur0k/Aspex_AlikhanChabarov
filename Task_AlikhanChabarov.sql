-- ���������� ��������� ������� | ������ �������


--- ������� 1
-- ������ �����
create table [Bicycle]
(
 [Id] int IDENTITY(1,1) not null,
 [Brand] varchar(50) not null,
 [RentPrice] int not null, -- ���� ������
 primary key(Id)
)
create table [Client]
(
 [Id] int IDENTITY(1,1) not null,
 [Name] varchar(10) not null,
 [Passport] varchar(50) not null,
 [Phone number] varchar(50) not null,
 [Country] varchar(50) not null,
 primary key(Id)
)
create table [Staff]
(
 [Id] int IDENTITY(1,1) not null,
 [Name] varchar(10) not null, -- ��� ����������
 [Passport] varchar(50) not null,
 [Date] date not null, -- ���� ������ ������
 primary key(Id)
)
create table [Detail] -- �������� ����������
(
 [Id] int IDENTITY(1,1) not null,
 [Brand] varchar(50) not null,
 [Type] varchar(50) not null, -- ��� ������ (����, ������, etc.)
 [Name] varchar(50) not null, -- �������� ������
 [Price] int not null,
 primary key(Id)
)
create table [DetailForBicycle] -- ������ ������� ���������� � �����������
(
 [BicycleId] int not null,
 [DetailId] int not null,
 FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
 FOREIGN KEY ([DetailId]) REFERENCES [Detail] ([Id])
)
create table [ServiceBook] -- ��������� ������������ �����������
(
 [BicycleId] int not null,
 [DetailId] int not null,
 [Date] date not null,
 [Price] int not null, -- ���� ������
 [StaffId] int not null,
 FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
 FOREIGN KEY ([StaffId]) REFERENCES [Staff] ([Id]),
 FOREIGN KEY ([DetailId]) REFERENCES [Detail] ([Id])
)
create table [RentBook] -- ������ ���������� ��������
(
 [Id] int IDENTITY(1,1) not null,
 [Date] date not null, -- ���� ������
 [Time] int not null, -- ����� ������ � �����
 [Paid] bit not null, -- 1 �������; 0 �� �������
 [BicycleId] int not null,
 [ClientId] int not null,
 [StaffId] int not null,
 FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
 FOREIGN KEY ([StaffId]) REFERENCES [Staff] ([Id]),
 FOREIGN KEY ([ClientId]) REFERENCES [Client] ([Id])
) 

-- ������ �����
/* RentPrice � Price ����� ��� int, ��� ������ ���������� ������ ������������ ��� ������ DECIMAL
�� ������ ����� � ������������� ������ ��� ����������
*/ 
ALTER TABLE Bicycle ALTER COLUMN RentPrice DECIMAL(10, 2) NOT NULL;
ALTER TABLE Detail ALTER COLUMN Price DECIMAL(10, 2) NOT NULL;
ALTER TABLE ServiceBook ALTER COLUMN Price DECIMAL(10, 2) NOT NULL;

/* ������ Name �� ������ Client � Staff, � ������� ����� ������� FirstName � LastName. 
���������� ������� ����� �� ���, ������� ���� ����������� ������� ������ � ����������, 
����� �������� ����� ������ �� 50
*/ 
ALTER TABLE Client DROP COLUMN Name;
ALTER TABLE Client ADD FirstName VARCHAR(50) NULL;
ALTER TABLE Client ADD LastName VARCHAR(50) NULL;

ALTER TABLE Staff DROP COLUMN Name;
ALTER TABLE Staff ADD FirstName VARCHAR(50) NULL;
ALTER TABLE Staff ADD LastName VARCHAR(50) NULL;

/*
������������ ������� Phone number, ��� ��� �� ����� ������ � ��������, ��� ���������� ��������� � �������
� �����, ����� ������ ������ � ���������, ��� ������� �������
*/
EXEC sp_rename 'Client.[Phone number]', 'PhoneNumber', 'COLUMN';
EXEC sp_rename 'Staff.Date', 'Start_Date', 'COLUMN';

/* 
���������� ������ � ������ ��������� � ������� � ���������� ������ ���� �����������, 
��� ��� � ���������� ������� �� ����� ���� ���������� ������� �������� ��� ���������� ������ 
*/
ALTER TABLE Client ADD CONSTRAINT UQ_Client_Passport UNIQUE (Passport);
ALTER TABLE Client ADD CONSTRAINT UQ_Client_PhoneNumber UNIQUE (PhoneNumber);
ALTER TABLE Staff ADD CONSTRAINT UQ_Staff_Passport UNIQUE (Passport);

/* DetailForBicycle �������� ��������� (many-to-many). 
������� ��������� ��������� ����, ��� ���������� ������������� ������ �� ���� �����
*/
ALTER TABLE DetailForBicycle ADD PRIMARY KEY (BicycleId, DetailId);

-- ������ �����

-- ������� ������ � ������� Bicycle
INSERT INTO Bicycle (Brand, RentPrice) VALUES
('Giant', 1500.00),
('Scott', 1400.00),
('Aspect', 1650.00),
('Stinger', 1300.00),
('Stels', 1250.00);

-- ������� ������ � ������� Client
INSERT INTO Client (Passport, PhoneNumber, Country, FirstName, LastName) VALUES
('4510 123456', '+77011234567', '���������', 'Alikhan', 'Chabarov'),
('US 987654321', '+12025550181', '���', 'Mark', 'Magdat'),
('4511 654321', '+77057654321', '���������', 'Aya', 'Shalkar'),
('CN 112233445', '+861012345678', '�����', 'Jackie','Chan'),
('ES A1B2C3D4', '+34911234567', '�������', 'Lamine', 'Yamal');

-- ������� ������ � ������� Staff
INSERT INTO Staff (Passport, Start_Date, FirstName, LastName) VALUES
('112654321', '2022-05-10', 'Darren', 'Watkins'),
('030460708', '2023-01-15', 'Pavel', 'Durov');

-- ������� ������ � ������� Detail
INSERT INTO Detail (Brand, Type, Name, Price) VALUES
('Shimano', 'Chain', 'CN-HG71', 12000.00),
('Shimano', 'Brake', 'BR-M315', 35000.50),
('Maxxis', 'Tire', 'Ikon 29"', 25000.00),
('SRAM', 'Cassette', 'PG-1230', 55000.75),
('RockShox', 'Fork', 'Judy Silver', 150000.00);

-- ������� ������ � ������� DetailForBicycle
INSERT INTO DetailForBicycle (BicycleId, DetailId) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2),
(3, 3), (3, 4), (3, 5),
(4, 1), (4, 4), 
(5, 2), (5, 3); 

-- ������� ������ � ������� ServiceBook
INSERT INTO ServiceBook (BicycleId, DetailId, Date, Price, StaffId) VALUES
(1, 1, '2025-06-15', 5000.00, 1),
(3, 5, '2025-07-01', 15000.00, 2),
(1, 2, '2025-09-01', 7500.00, 1),  
(4, 4, '2025-10-19', 6000.00, 2);  

-- ������� ������ � ������� RentBook
INSERT INTO RentBook (Date, Time, Paid, BicycleId, ClientId, StaffId) VALUES
('2025-09-01', 3, 1, 1, 1, 1),
('2025-09-10', 5, 1, 2, 2, 2),
('2025-09-12', 2, 1, 3, 3, 1),
('2025-09-15', 8, 1, 1, 4, 2),
('2025-09-19', 4, 0, 5, 5, 1),
('2025-10-05', 6, 1, 1, 2, 1),
('2025-10-10', 3, 1, 4, 3, 2);

-- ��������� �����

-- ����� ������� �� ������� ����������
SELECT BicycleId, SUM(Time * b.RentPrice) AS TotalRentRevenue FROM RentBook rb
	INNER JOIN Bicycle b 
	ON rb.BicycleId = b.Id
WHERE rb.Paid = 1 
GROUP BY BicycleId, b.RentPrice

-- ����� ������� �� ������� ����������
SELECT FirstName, LastName, SUM(Time * b.RentPrice) as TotalStaffRevenue FROM Staff st
	INNER JOIN RentBook rb
	ON rb.StaffId = st.Id
	INNER JOIN Bicycle b 
	ON rb.BicycleId = b.Id
WHERE rb.Paid = 1
GROUP BY st.FirstName, st.LastName

-- ����� ����� ������� �������
SELECT FirstName, LastName, SUM(rb.Time * b.RentPrice) as TotalClientSpent FROM Client cl
	INNER JOIN Rentbook rb 
	ON rb.ClientId = cl.Id
	INNER JOIN Bicycle b
	ON rb.BicycleId = b.Id
WHERE rb.Paid = 1
GROUP BY FirstName, LastName
ORDER BY TotalClientSpent DESC

-- ����� ���������� � ������� �� ��������
SELECT dt.Type, COUNT(sb.BicycleId) as NumOfRepair, SUM(sb.Price + dt.Price) as TotalCost from ServiceBook sb
	INNER JOIN Detail dt
	ON dt.Id = sb.DetailId
GROUP BY dt.Type
ORDER BY TotalCost DESC

-- ������������ ����������� �� ������� ������
SELECT b.Brand, SUM(rb.Time) as TotalHoursRented FROM RentBook rb
	INNER JOIN Bicycle b
	ON b.Id = rb.BicycleId
GROUP BY b.Brand
ORDER BY TotalHoursRented DESC


--- ������� 2
/* � ����� ������ ������� ������� �������, ������� �������� �������, ������� ����� ������������ � �������� �������. 
�������� ��������� ��� ���� �������� �� ����������� ���� �������� � ������ �������� ��������� 
��-�� �������� �������� �������� � ��������� ��������.
*/

-- ������� ������
CREATE TABLE StaffBonus
(
    BonusYear INT NOT NULL,
    BonusMonth INT NOT NULL,
    StaffName VARCHAR(100) NOT NULL, 
    BonusAmount DECIMAL(18, 2) NOT NULL 
);

-- ������ �� ������ � ������� ������
SELECT st.FirstName, st.LastName, SUM(rb.Time * b.RentPrice) * 0.3 as RentBonus FROM Staff st
	INNER JOIN RentBook rb
	ON rb.StaffId = st.Id 
	INNER JOIN Bicycle b 
	ON b.Id = rb.BicycleId
WHERE rb.Paid = 1
GROUP BY st.FirstName, st.LastName

-- ������ �� ������� � ������� ������
SELECT StaffId, SUM(Price) * 0.80 AS BaseBonusValue FROM ServiceBook
GROUP BY StaffId

/* ��� ������������� �������� ���������� �������� ������� ������ 
����� ������������ SQL Server Agent (����������� ����� � MS SQL Server)
� ������� ��������� ������� � �� ���������� ��������� T-SQL �������
*/
