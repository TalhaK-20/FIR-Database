Create Database FIR_Management_System

CREATE TABLE Police_Officers (
    Officer_ID INT PRIMARY KEY,
    Officer_Name VARCHAR(100),
    Rank VARCHAR(50)
);

CREATE TABLE Crime_Categories (
    Category_ID INT PRIMARY KEY,
    Category_Name VARCHAR(100)
);

CREATE TABLE FIRs (
    FIR_ID INT PRIMARY KEY,
    FIR_Number VARCHAR(50),
    Incident_Date DATE,
    Incident_Time TIME,
    Location VARCHAR(100),
    Description VARCHAR(500),
    Category_ID INT,
    Officer_ID INT,
    FOREIGN KEY (Category_ID) REFERENCES Crime_Categories(Category_ID),
    FOREIGN KEY (Officer_ID) REFERENCES Police_Officers(Officer_ID)
);

CREATE TABLE FIR_Victims (
    Victim_ID INT PRIMARY KEY,
    FIR_ID INT,
    Victim_Name VARCHAR(100),
    Gender CHAR(1),
    Age INT,
    Contact_Number VARCHAR(20),
    FOREIGN KEY (FIR_ID) REFERENCES FIRs(FIR_ID)
);

CREATE TABLE Suspects (
    Suspect_ID INT PRIMARY KEY,
    FIR_ID INT,
    Suspect_Name VARCHAR(100),
    Gender CHAR(1),
    Age INT,
    Address VARCHAR(200),
    FOREIGN KEY (FIR_ID) REFERENCES FIRs(FIR_ID)
);

CREATE TABLE Witnesses (
    Witness_ID INT PRIMARY KEY,
    FIR_ID INT,
    Witness_Name VARCHAR(100),
    Gender CHAR(1),
    Age INT,
    Contact_Number VARCHAR(20),
    FOREIGN KEY (FIR_ID) REFERENCES FIRs(FIR_ID)
);

CREATE TABLE Evidences (
    Evidence_ID INT PRIMARY KEY,
    FIR_ID INT,
    Evidence_Description VARCHAR(200),
    FOREIGN KEY (FIR_ID) REFERENCES FIRs(FIR_ID)
);

INSERT INTO Police_Officers (Officer_ID, Officer_Name, Rank) VALUES
(1, 'John Smith', 'Inspector'),
(2, 'Emma Johnson', 'Sergeant');

INSERT INTO Crime_Categories (Category_ID, Category_Name) VALUES
(1, 'Robbery'),
(2, 'Assault');

INSERT INTO FIRs (FIR_ID, FIR_Number, Incident_Date, Incident_Time, Location, Description, Category_ID, Officer_ID) VALUES
(1, 'FIR001', '2023-08-03', '19:30', 'Main Street', 'Robbery occurred at a store', 1, 1),
(2, 'FIR002', '2023-08-03', '21:15', 'Park Avenue', 'Assault incident reported', 2, 2);

INSERT INTO FIR_Victims (Victim_ID, FIR_ID, Victim_Name, Gender, Age, Contact_Number) VALUES
(1, 1, 'Robert Johnson', 'M', 35, '123-456-7890'),
(2, 2, 'Emily Williams', 'F', 28, '987-654-3210');

INSERT INTO Suspects (Suspect_ID, FIR_ID, Suspect_Name, Gender, Age, Address) VALUES
(1, 1, 'Michael Brown', 'M', 27, '456 Oak Street'),
(2, 2, 'Sophia Clark', 'F', 30, '789 Maple Avenue');

INSERT INTO Witnesses (Witness_ID, FIR_ID, Witness_Name, Gender, Age, Contact_Number) VALUES
(1, 1, 'Daniel Lee', 'M', 22, '567-890-1234'),
(2, 2, 'Olivia Wilson', 'F', 25, '321-654-0987');

INSERT INTO Evidences (Evidence_ID, FIR_ID, Evidence_Description) VALUES
(1, 1, 'CCTV footage from the store'),
(2, 2, 'Blood-stained shirt found at the crime scene');

select * from Police_Officers;
select * from Crime_Categories;
select * from FIRs;
select * from FIR_Victims;
select * from Suspects;
select * from Witnesses;
select * from Evidences;

GO

CREATE VIEW FIR_Details AS
SELECT
    f.FIR_ID,
    f.FIR_Number,
    f.Incident_Date,
    f.Location,
    o.Officer_Name,
    c.Category_Name
FROM
    FIRs f
    INNER JOIN Police_Officers o ON f.Officer_ID = o.Officer_ID
    INNER JOIN Crime_Categories c ON f.Category_ID = c.Category_ID;

GO

select * from FIR_Details

GO

CREATE VIEW Victims_With_FIR AS
SELECT
    v.Victim_ID,
    v.Victim_Name,
    v.Gender,
    v.Age,
    v.Contact_Number,
    f.FIR_ID,
    f.FIR_Number,
    f.Incident_Date,
    f.Location
FROM
    FIR_Victims v
    LEFT JOIN FIRs f ON v.FIR_ID = f.FIR_ID;

GO

select * from Victims_With_FIR

GO

CREATE VIEW Suspects_With_FIR AS
SELECT
    s.Suspect_ID,
    s.Suspect_Name,
    s.Gender,
    s.Age,
    s.Address,
    f.FIR_ID,
    f.FIR_Number,
    f.Incident_Date,
    f.Location
FROM
    Suspects s
    RIGHT JOIN FIRs f ON s.FIR_ID = f.FIR_ID;

GO

select * from Suspects_With_FIR

GO

CREATE FUNCTION CalculateAge(@birthdate DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @birthdate, GETDATE()) - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @birthdate, GETDATE()), @birthdate) > GETDATE() THEN 1 ELSE 0 END;
END;

GO

CREATE FUNCTION GetOfficerRank(@officer_id INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @rank_val VARCHAR(50);
    SELECT @rank_val = Rank FROM Police_Officers WHERE Officer_ID = @officer_id;
    RETURN @rank_val;
END;

GO

CREATE FUNCTION GetFIRCountByCategory(@category_id INT)
RETURNS INT
AS
BEGIN
    DECLARE @count_val INT;
    SELECT @count_val = COUNT(*) FROM FIRs WHERE Category_ID = @category_id;
    RETURN @count_val;
END;

GO

SELECT Victim_Name, dbo.CalculateAge('1990-01-15') AS Victim_Age 
FROM FIR_Victims WHERE Victim_ID = 1;

SELECT Officer_Name, dbo.GetOfficerRank(1) AS Rank 
FROM Police_Officers WHERE Officer_ID = 1;

SELECT Category_Name, dbo.GetFIRCountByCategory(1) AS FIR_Count 
FROM Crime_Categories WHERE Category_ID = 1;
