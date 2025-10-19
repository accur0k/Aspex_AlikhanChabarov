-- Выполнение тестового задания | Алихан Чабаров


--- Задание 1
-- Первый пункт
create table [Bicycle]
(
 [Id] int IDENTITY(1,1) not null,
 [Brand] varchar(50) not null,
 [RentPrice] int not null, -- цена аренды
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
 [Name] varchar(10) not null, -- имя сотрудника
 [Passport] varchar(50) not null,
 [Date] date not null, -- дата начала работы
 primary key(Id)
)
create table [Detail] -- запчасти велосипеда
(
 [Id] int IDENTITY(1,1) not null,
 [Brand] varchar(50) not null,
 [Type] varchar(50) not null, -- тип детали (цепь, звезда, etc.)
 [Name] varchar(50) not null, -- название детали
 [Price] int not null,
 primary key(Id)
)
create table [DetailForBicycle] -- список деталей подходящих к велосипедам
(
 [BicycleId] int not null,
 [DetailId] int not null,
 FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
 FOREIGN KEY ([DetailId]) REFERENCES [Detail] ([Id])
)
create table [ServiceBook] -- сервисное обслуживание велосипедов
(
 [BicycleId] int not null,
 [DetailId] int not null,
 [Date] date not null,
 [Price] int not null, -- цена работы
 [StaffId] int not null,
 FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
 FOREIGN KEY ([StaffId]) REFERENCES [Staff] ([Id]),
 FOREIGN KEY ([DetailId]) REFERENCES [Detail] ([Id])
)
create table [RentBook] -- аренда велосипеда клиентом
(
 [Id] int IDENTITY(1,1) not null,
 [Date] date not null, -- дата аренды
 [Time] int not null, -- время аренды в часах
 [Paid] bit not null, -- 1 оплатил; 0 не оплатил
 [BicycleId] int not null,
 [ClientId] int not null,
 [StaffId] int not null,
 FOREIGN KEY ([BicycleId]) REFERENCES [Bicycle] ([Id]),
 FOREIGN KEY ([StaffId]) REFERENCES [Staff] ([Id]),
 FOREIGN KEY ([ClientId]) REFERENCES [Client] ([Id])
) 

-- Второй пункт
/* RentPrice и Price имеют тип int, для записи финансовых данных используется тип данных DECIMAL
он хранит числа с фиксированной точкой без округления
*/ 
ALTER TABLE Bicycle ALTER COLUMN RentPrice DECIMAL(10, 2) NOT NULL;
ALTER TABLE Detail ALTER COLUMN Price DECIMAL(10, 2) NOT NULL;
ALTER TABLE ServiceBook ALTER COLUMN Price DECIMAL(10, 2) NOT NULL;

/* Удалил Name из таблиц Client и Staff, и добавил новые столбцы FirstName и LastName. 
Разделение полного имени на имя, фамилию дает возможность легкого поиска и фильтрации, 
также увеличил длину строки до 50
*/ 
ALTER TABLE Client DROP COLUMN Name;
ALTER TABLE Client ADD FirstName VARCHAR(50) NULL;
ALTER TABLE Client ADD LastName VARCHAR(50) NULL;

ALTER TABLE Staff DROP COLUMN Name;
ALTER TABLE Staff ADD FirstName VARCHAR(50) NULL;
ALTER TABLE Staff ADD LastName VARCHAR(50) NULL;

/*
Переименовал столбец Phone number, так как он имеет пробел в названии, это затрудняет обращение к столбцу
и также, старт начало работы у работника, для большей ясности
*/
EXEC sp_rename 'Client.[Phone number]', 'PhoneNumber', 'COLUMN';
EXEC sp_rename 'Staff.Date', 'Start_Date', 'COLUMN';

/* 
Паспортные данные и номера телефонов у клиента и сотрудника должны быть уникальными, 
так как у нескольких человек не может быть одинаковых номеров телефона или паспортных данных 
*/
ALTER TABLE Client ADD CONSTRAINT UQ_Client_Passport UNIQUE (Passport);
ALTER TABLE Client ADD CONSTRAINT UQ_Client_PhoneNumber UNIQUE (PhoneNumber);
ALTER TABLE Staff ADD CONSTRAINT UQ_Staff_Passport UNIQUE (Passport);

/* DetailForBicycle является связующей (many-to-many). 
Добавил составной первичный ключ, для уникальной идентификации строки из двух полей
*/
ALTER TABLE DetailForBicycle ADD PRIMARY KEY (BicycleId, DetailId);

-- Третий пункт

-- Вставка данных в таблицу Bicycle
INSERT INTO Bicycle (Brand, RentPrice) VALUES
('Giant', 1500.00),
('Scott', 1400.00),
('Aspect', 1650.00),
('Stinger', 1300.00),
('Stels', 1250.00);

-- Вставка данных в таблицу Client
INSERT INTO Client (Passport, PhoneNumber, Country, FirstName, LastName) VALUES
('4510 123456', '+77011234567', 'Казахстан', 'Alikhan', 'Chabarov'),
('US 987654321', '+12025550181', 'США', 'Mark', 'Magdat'),
('4511 654321', '+77057654321', 'Казахстан', 'Aya', 'Shalkar'),
('CN 112233445', '+861012345678', 'Китай', 'Jackie','Chan'),
('ES A1B2C3D4', '+34911234567', 'Испания', 'Lamine', 'Yamal');

-- Вставка данных в таблицу Staff
INSERT INTO Staff (Passport, Start_Date, FirstName, LastName) VALUES
('112654321', '2022-05-10', 'Darren', 'Watkins'),
('030460708', '2023-01-15', 'Pavel', 'Durov');

-- Вставка данных в таблицу Detail
INSERT INTO Detail (Brand, Type, Name, Price) VALUES
('Shimano', 'Chain', 'CN-HG71', 12000.00),
('Shimano', 'Brake', 'BR-M315', 35000.50),
('Maxxis', 'Tire', 'Ikon 29"', 25000.00),
('SRAM', 'Cassette', 'PG-1230', 55000.75),
('RockShox', 'Fork', 'Judy Silver', 150000.00);

-- Вставка данных в таблицу DetailForBicycle
INSERT INTO DetailForBicycle (BicycleId, DetailId) VALUES
(1, 1), (1, 2), (1, 3),
(2, 1), (2, 2),
(3, 3), (3, 4), (3, 5),
(4, 1), (4, 4), 
(5, 2), (5, 3); 

-- Вставка данных в таблицу ServiceBook
INSERT INTO ServiceBook (BicycleId, DetailId, Date, Price, StaffId) VALUES
(1, 1, '2025-06-15', 5000.00, 1),
(3, 5, '2025-07-01', 15000.00, 2),
(1, 2, '2025-09-01', 7500.00, 1),  
(4, 4, '2025-10-19', 6000.00, 2);  

-- Вставка данных в таблицу RentBook
INSERT INTO RentBook (Date, Time, Paid, BicycleId, ClientId, StaffId) VALUES
('2025-09-01', 3, 1, 1, 1, 1),
('2025-09-10', 5, 1, 2, 2, 2),
('2025-09-12', 2, 1, 3, 3, 1),
('2025-09-15', 8, 1, 1, 4, 2),
('2025-09-19', 4, 0, 5, 5, 1),
('2025-10-05', 6, 1, 1, 2, 1),
('2025-10-10', 3, 1, 4, 3, 2);

-- Четвертый пункт

-- Общая выручка по каждому велосипеду
SELECT BicycleId, SUM(Time * b.RentPrice) AS TotalRentRevenue FROM RentBook rb
	INNER JOIN Bicycle b 
	ON rb.BicycleId = b.Id
WHERE rb.Paid = 1 
GROUP BY BicycleId, b.RentPrice

-- Общая выручка по каждому сотруднику
SELECT FirstName, LastName, SUM(Time * b.RentPrice) as TotalStaffRevenue FROM Staff st
	INNER JOIN RentBook rb
	ON rb.StaffId = st.Id
	INNER JOIN Bicycle b 
	ON rb.BicycleId = b.Id
WHERE rb.Paid = 1
GROUP BY st.FirstName, st.LastName

-- Общая трата каждого клиента
SELECT FirstName, LastName, SUM(rb.Time * b.RentPrice) as TotalClientSpent FROM Client cl
	INNER JOIN Rentbook rb 
	ON rb.ClientId = cl.Id
	INNER JOIN Bicycle b
	ON rb.BicycleId = b.Id
WHERE rb.Paid = 1
GROUP BY FirstName, LastName
ORDER BY TotalClientSpent DESC

-- Общее количество и затрата на запчасти
SELECT dt.Type, COUNT(sb.BicycleId) as NumOfRepair, SUM(sb.Price + dt.Price) as TotalCost from ServiceBook sb
	INNER JOIN Detail dt
	ON dt.Id = sb.DetailId
GROUP BY dt.Type
ORDER BY TotalCost DESC

-- Популярность велосипедов по времени аренды
SELECT b.Brand, SUM(rb.Time) as TotalHoursRented FROM RentBook rb
	INNER JOIN Bicycle b
	ON b.Id = rb.BicycleId
GROUP BY b.Brand
ORDER BY TotalHoursRented DESC


--- Задание 2
/* Я понял логику задания второго задания, написал ключевые запросы, которые можно использовать в конечном запросе. 
Основная сложность для меня возникла на объединения этих запросов в единую хранимую процедуру 
из-за нехватки недавней практики в написании процедур.
*/

-- Витрина таблиц
CREATE TABLE StaffBonus
(
    BonusYear INT NOT NULL,
    BonusMonth INT NOT NULL,
    StaffName VARCHAR(100) NOT NULL, 
    BonusAmount DECIMAL(18, 2) NOT NULL 
);

-- Данные по аренде и базовая премия
SELECT st.FirstName, st.LastName, SUM(rb.Time * b.RentPrice) * 0.3 as RentBonus FROM Staff st
	INNER JOIN RentBook rb
	ON rb.StaffId = st.Id 
	INNER JOIN Bicycle b 
	ON b.Id = rb.BicycleId
WHERE rb.Paid = 1
GROUP BY st.FirstName, st.LastName

-- Данные по ремонту и базовая премия
SELECT StaffId, SUM(Price) * 0.80 AS BaseBonusValue FROM ServiceBook
GROUP BY StaffId

/* Для автоматизации процесса ежедневной загрузки витрины данных 
можно использовать SQL Server Agent (планировщик задач в MS SQL Server)
в котором создается задание и по расписанию запускает T-SQL команду
*/
