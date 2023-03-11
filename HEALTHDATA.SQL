CREATE DATABASE HRMDBHEALTH;
GO


USE HRMDB;
GO


-- CREATING TABLES, WITH APPLICABLE CONSTRAINTS, 

CREATE TABLE Patient
(
	mrn CHAR(5) NOT NULL,
	pFName VARCHAR(30) NOT NULL,
	pLName VARCHAR(30) NOT NULL,
	PDoB DATE NOT NULL,
	insuranceId CHAR(7) NULL, 
	gender CHAR(1) NOT NULL,
	SSN CHAR(11) NULL,
	stAddress VARCHAR(25) NOT NULL,
	city VARCHAR(25) NOT NULL,
	[state] CHAR(2) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	registeredDate DATE NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Patient_mrn PRIMARY KEY (mrn),
	CONSTRAINT CK_Patient_mrn_Format CHECK(mrn LIKE '[A-Z][A-Z][0-9][0-9][0-9]'),
	CONSTRAINT UQ_Patient_insuranceId UNIQUE (insuranceId),
	CONSTRAINT CK_Patient_gender_Format CHECK(gender IN ('F', 'M', 'U')),
	CONSTRAINT CK_Patient_SSN_Format CHECK ((SSN LIKE '[0-9][0-9][0-9][-][0-9][0-9][-][0-9][0-9][0-9][0-9]') AND (SSN NOT LIKE '000-00-0000')),
	CONSTRAINT UQ_Patient_SSN UNIQUE (SSN),
	CONSTRAINT CK_Patient_state_Format CHECK([state] LIKE '[A-Z][A-Z]'),
	CONSTRAINT CK_Pateint_zipCode_Fomrat CHECK((zipCode LIKE '[0-9][0-9][0-9][0-9][0-9]') AND (zipCode NOT LIKE '00000'))
);
GO


CREATE TABLE Employee
(
	empId CHAR(5) NOT NULL,
	empFName VARCHAR(25) NOT NULL,
	empLName VARCHAR(25) NOT NULL,
	SSN CHAR(11) NOT NULL,
	DoB DATE NOT NULL,
	gender CHAR(1) NOT NULL,
	salary DECIMAL(8,2) NULL,
	employedDate DATE NOT NULL,
	strAddress VARCHAR (30) NOT NULL,
	apt VARCHAR(5) NULL,
	city VARCHAR(25) NOT NULL,
	[state] CHAR(2) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	phoneNo CHAR(14) NOT NULL,
	email VARCHAR(50) NULL,
	empType VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Employee_empId PRIMARY KEY (empId)
);
GO

CREATE TABLE Disease
(
	dId INT NOT NULL,	
	dName VARCHAR(100) NOT NULL,
	dCategoryId CHAR(2) NULL,
	dCategory VARCHAR(50) NOT NULL,
	dType VARCHAR(40) NOT NULL,
	CONSTRAINT PK_Disease_dId PRIMARY KEY (dId),
	CONSTRAINT CHK_Disease_dCategoryId CHECK (dCategoryId LIKE '[A-Z][0-9]')
);
GO



CREATE TABLE Doctor
(
	empId CHAR(5) NOT NULL, 
	docId CHAR(4) NOT NULL,
	lisenceNo CHAR(11) UNIQUE NOT NULL,
	lisenceDate DATE NOT NULL,
	[rank] VARCHAR(25) NOT NULL,
	specialization VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Doctor_docId PRIMARY KEY (docId),
	CONSTRAINT FK_Doctor_Employee_empId FOREIGN KEY (empId) REFERENCES Employee (empId) ON DELETE CASCADE ON UPDATE CASCADE
);
GO


CREATE TABLE Diagnosis
(
	diagnosisNo INT NOT NULL,
	mrn CHAR(5) NOT NULL,
	docId CHAR(4) NULL,
	dId INT NOT NULL,
	diagDate DATE DEFAULT GETDATE() NOT NULL,
	diagResult VARCHAR(1000) NOT NULL,
	CONSTRAINT PK_Diagnosis_diagnosisNo PRIMARY KEY (diagnosisNo),
	CONSTRAINT FK_Diagnosis_Patient_mrn FOREIGN KEY (mrn) REFERENCES Patient(mrn),
	CONSTRAINT FK_Diagnosis_Doctor_docId FOREIGN KEY (docId) REFERENCES Doctor(docId) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT FK_Diagnosis_Disease_dId FOREIGN KEY (dId) REFERENCES Disease(dId)
);
GO



CREATE TABLE PharmacyPersonel
(
	empId CHAR(5) NOT NULL,
	pharmacistLisenceNo CHAR (11) NOT NULL,
	lisenceDate DATE NOT NULL,
	PCATTestResult INT NULL,
	[level] VARCHAR (40) NOT NULL,
	CONSTRAINT FK_PharmacyPersonel_empId FOREIGN KEY (empId) REFERENCES Employee (empId),
	CONSTRAINT UQ_PharmacyPersonel_pharmacistLisenceNo UNIQUE (pharmacistLisenceNo)
);
GO


CREATE TABLE Medicine
(
	mId SMALLINT NOT NULL,
	brandName VARCHAR(40) NOT NULL,
	genericName VARCHAR(50) NOT NULL,
	qtyInStock INT NOT NULL,
	[use] VARCHAR(50) NOT NULL,
	expDate DATE NOT NULL,
	unitPrice DECIMAL(6,2) NOT NULL,
	CONSTRAINT PK_Medicine_mId PRIMARY KEY (mId)
);
GO



CREATE TABLE Prescription
(
	prescriptionId INT NOT NULL,
	diagnosisNo INT NOT NULL,
	prescriptionDate DATE NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Prescription_prescriptionId PRIMARY KEY (prescriptionId),
	CONSTRAINT FK_Prescription_Diagnosis_diagnosisNo FOREIGN KEY (diagnosisNo) REFERENCES Diagnosis(diagnosisNo) 
);
GO



CREATE TABLE MedicinePrescribed
(
	prescriptionId INT NOT NULL,
	mId SMALLINT NOT NULL,
	dosage VARCHAR(50) NOT NULL,
	numberOfAllowedRefills TINYINT NOT NULL,
	CONSTRAINT PK_MedicinePrescribed_prescriptionId_mId PRIMARY KEY(prescriptionId, mId),
	CONSTRAINT FK_MedicinePrescribed_prescriptionId FOREIGN KEY (prescriptionId) REFERENCES Prescription(prescriptionId),
	CONSTRAINT FK_MedicinePrescribed_mId FOREIGN KEY (mId) REFERENCES Medicine(mId)
);
GO



-- Inserting data into tables of HRMS database, 


INSERT INTO Disease 
	VALUES (1, 'Anthrax', 'D1','Bacterial infections', 'Contageous'), 
		   (2, 'Acquired hemophilia','D2','Blood Diseases','Type2'), 
		   (3, 'Accessory pancreas ','D3','Digestive Diseases','xyz'),
		   (4, 'Cholera ','D1', 'Bacterial infections', 'Contageous'),
		   (5, 'Acatalasemia ', 'D2','Blood Diseases', 'Chronic'),
		   (6, 'Acute fatty liver of pregnancy ','D3','Digestive Diseases','Non Contageous');
GO



INSERT INTO Medicine 
	VALUES (1, 'Xaleto','Rivaroxi...', 200, 'Anticoagulant', '2022-12-31', 67.99), 
		   (2, 'Eliquis', 'Apiza...',500, 'ACE inhitor', '2021-06-06', 23.49),
		   (3, 'Tran..Acid', 'Inhibitor', 600, 'Something','2020-12-31', 9.99),
		   (4, 'Fosamax', 'alendronate tablet', 200, 'treat certain types of bone loss in adults','2022-12-31',58),
		   (5, 'Hexalen capsules','altretamine',150,'Ovarian cancer','2020-12-31',26),
		   (6, 'Prozac','Fluoxetine...', 125, 'Anti-depressent', '2019-12-31', 43.99),
		   (7, 'Glucofage','Metformine...', 223, 'Anti-Diabetic', '2019-10-13', 22.99),
		   (8, 'Advil', 'Ibuprofine', 500, 'Pain killer', '2023-01-01', 0.10),
		   (9, 'Amoxy','Amoxilcillin', 2000, 'Antibiotics', '2021-12-31', 0.20 );
GO


INSERT INTO Patient
	VALUES	('PA001', 'Kirubel', 'Wassie', '09-12-1985', 'kki95', 'M','031-56-3472','2578 kk st', 'Alexandria', 'VA', '22132','2018-01-01'),
			('PA002', 'Harsha', 'Sagar', '11-19-1980', 'wes41', 'F','289-01-6994','3379 bb st', 'Miami', 'FL', '19376','2017-09-02'),
			('PA003', 'Fekadu', 'Gonfa', '05-20-1990', 'oi591', 'M','175-50-1235','1538 ff st',  'Seattle', 'WA', '35800','2018-01-01'),
			('PA004', 'Arsema', 'Negera', '01-25-1978', 'iuu53', 'F','531-31-3308','2928 aa st', 'Silver Spring', 'MD', '51763','2017-02-01'),
			('PA005', 'John', 'Craig', '12-31-1965', 'iu979', 'M','231-61-8422','1166 jj st', 'Alexandria', 'VA', '22132','2019-01-03'),
			('PA006', 'Maria', 'Michael', '08-12-1979', 'mk216', 'F', '786-32-0912','7866 mm st', 'Silver Spring', 'MD', '51763','2018-01-01'),
			('PA007', 'Derek', 'Nagaraju', '02-18-1975', 'sd025', 'M','120-21-6743','8889 ff st', 'Silver Spring', 'MD', '51763','2019-02-20'),
			('PA008', 'Birtukan', 'Wale', '01-27-1989', 'is489', 'F','013-32-6789','5464 bb st', 'Seattle', 'WA', '35800','2018-01-05'),
			('PA009', 'Yehualashet', 'Lemma', '05-15-1983', 'kl526', 'M', '745-21-0321','3338 yy st', 'Miami', 'FL', '19376','2018-01-01'),
			('PA010', 'Selam', 'Damtew', '09-22-1970', 's5561', 'F', '300-00-2211','4651 ss st', 'Huston', 'TX', '11156','2018-09-10'),
			('PA011', 'Simon', 'Kifle', '08-11-1968', 'dc256', 'M', '333-44-5555','2287 sk st', 'Springfield', 'VA', '22132','2018-01-01'),
			('PA012', 'Nany', 'Tekle', '08-25-1970', 'po724', 'F', '222-88-4444','1313 nt st', 'Springfield', 'VA', '22132','2019-03-01'),
			('PA013', 'Adane', 'Belay', '11-16-1984', 'sa366', 'M', '001-22-3216','4687 ab st', 'Seattle', 'WA', '35800','2017-02-02'),
			('PA014', 'Genet', 'Misikir', '05-28-1982', 'l8773', 'F', '999-44-2299','00468 gm st', 'Richmond', 'VA', '55982','2017-11-12'),
			('PA015', 'Mikiyas', 'Tesfaye', '01-15-1979', 'w6321', 'M', '221-90-8833','5090 mt st', 'Alexandria', 'VA', '22132','2017-11-12')
GO



INSERT INTO Employee 
	VALUES ('EMP01', 'Neftalem', 'Medhanie', '050-23-1111', '1971-10-07','M',78000,'2017-03-02','1293 Duncan Avenue', '198','Rockville', 'MD','20871', '(707) 890-3212', 'nef@yahoo.com','P'),
		   ('EMP02', 'Mark', 'Lewis', '060-23-2222', '1972-09-12','M',67500,'2018-12-02','4080 Marshall Street', '800','Washington', 'DC','20021', '(202) 890-9032', 'mark@gmail.com','C'),
		   ('EMP03', 'Dennis', 'Price', '060-21-3333', '1973-10-09','F',89800,'2016-03-02','1331 Edsel Road', 'L21','Woodbridge', 'VA','20321', '(570) 000-2112', 'kathe@gmail.com','M'),
		   ('EMP04', 'Robert', 'Iversen', '070-23-4444', '1974-07-01','M',100000,'2017-09-01','786 Eagle Lane', '234','Columbia', 'MD','20990', '(301) 890-3200', 'rob@yahoo.com','P'),
		   ('EMP05', 'Rosie', 'Seiler', '080-23-5555', '1975-03-07','F',79300,'2016-03-02','123 Ky St', '698','Bethesda', 'MD','20871', '(332) 890-3212', 'rosie@yahoo.com','A'),
		   ('EMP06', 'Emmanuel', 'Kepa', '908-23-6666', '1985-09-15','M',89800,'2018-12-02','5 Poe Lane', '832','Washington', 'DC','20021', '(204) 890-9032', 'emma@gmail.com','A'),
		   ('EMP07', 'Andrew', 'Neftalem', '090-21-7777', '1986-11-03','M',100100,'2015-03-02','1378 Gateway Road', '823','Alexandia', 'VA','20321', '(703) 000-2112', 'dennisned@gmail.com','A'),
		   ('EMP08', 'Liang', 'Porter', '111-23-8888', '1987-01-01','M',78000,'2017-09-01','825 Victoria Street', '109','Columbia', 'MD','20990', '(249) 890-3200', 'lian@yahoo.com','P'),
		   ('EMP09', 'Sarah', 'Kathrin', '222-23-9999', '1988-03-18','F',90800,'2014-03-02','1389 Finwood Road', '007','Germantown', 'MD','20871', '(191) 890-3212', 'rosie@yahoo.fr','P'),
		   ('EMP10', 'Christopher', 'Rasmussen', '333-23-0000', '1989-03-23','M',62000,'2018-12-02','3520 Nash Street', '002','Washington', 'DC','20021', '(320) 890-9032', 'chris@gmail.com','C'),
		   ('EMP11', 'Ruth', 'Kumar', '444-21-1122', '1990-11-24','F',90200,'2019-03-02','4656 Byrd Lane', 'L21','Arlington', 'VA','20321', '(521) 000-2112', 'ruth@gmail.com','A'),
		   ('EMP12', 'Stefan', 'Xu', '444-23-2233', '1990-09-01','M',68000,'2013-09-01','3583 Stadium Drive', '100','Beltsville', 'MD','20990', '(260) 890-3200', 'stef@yahoo.com','M'),
		   ('EMP13', 'Jessamine', 'Seiler', '555-23-3344', '1982-11-28','F',90200,'2018-03-02','1337 Havanna Street', '498','Clarksburg', 'MD','20871', '(101) 890-3212', 'jes@yahoo.co.uk','M'),
		   ('EMP14', 'Enza', 'Kepa', '666-23-4455', '1990-09-30','F',85300,'2011-12-02','2780 Irish Lane', NULL,'Washington', 'DC','20021', '(511) 890-9032', 'enz@gmail.com','C'),
		   ('EMP15', 'Andrew', 'Kumar', '777-21-5566', '1983-10-25','M',120800,'2010-03-02','3048 James Avenue', 'L21','Fairfax', 'VA','20321', '(911) 000-2112', 'andkum@gmail.com','P'),
		   ('EMP16', 'Ermias', 'Henriksen', '888-23-6677', '1983-09-16','M',78000,'2017-09-01','714 Chicago Avenue', NULL,'Laurel', 'MD','20990', '(199) 890-3200', 'ermias@yahoo.com','P'),
		   ('EMP17', 'Petra', 'Seiler', '123-23-3456', '1980-09-07','F',45000,'2018-03-02','123 Ky St', '198','Clarksburg', 'MD','20871', '(101) 890-3212', 'ps@yahoo.com','P'),
		   ('EMP18', 'Peter', 'Kepa', '908-23-3432', '1990-09-07','M',72300,'2018-12-02','907 12 St', NULL,'Washington', 'DC','20021', '(201) 890-9032', 'pk@gmail.com','C'),
	       ('EMP19', 'Dennis', 'Kumar', '093-21-3456', '1983-10-03','M',120800,'2019-03-02','123 Ky St', 'L21','Manassas', 'VA','20321', '(571) 000-2112', 'dk@gmail.com','P'),
		   ('EMP20', 'Gang', 'Xu', '903-23-9056', '1983-09-01','M',79300,'2017-09-01','213 Coles rd', NULL,'Columbia', 'MD','20990', '(240) 890-3200', 'gxu@yahoo.com','P');
GO


INSERT INTO Doctor 
	VALUES  ('EMP10','MD01', 'KNO-09-6667','2017-09-10', 'Senior','Infectious Disease'),
			('EMP12','MD02', 'BAV-00-9456','2016-08-10', 'senior','Family medicine'),
			('EMP04','MD03', 'LIC-22-0678', '2015-12-31','Senior','Intenal Medicine'),
			('EMP17','MD04', 'KAL-16-5420','2018-09-03','Junior','Cardiologist'),
		    ('EMP15','MD06', 'XYZ-66-7600','2017-02-5', 'Junior','Infectious Disease');
GO




INSERT INTO Diagnosis 
	VALUES (1, 'PA003', 'MD03', 1, '2017-11-06', 'Positive'),
		   (2, 'PA009', 'MD02', 5, '2018-02-06', 'Positive'),
		   (3, 'PA012', 'MD01', 2, '2015-09-04', 'Negative'),
		   (4, 'PA005', 'MD02', 3, '2019-11-06', 'Negative'),
		   (5, 'PA014', 'MD04', 4, '2014-10-04', 'Negative'),
		   (6, 'PA001', 'MD02', 5, '2017-10-04', 'Positive'),
		   (7, 'PA004', 'MD01', 6, '2016-11-04', 'Positive'),
		   (8, 'PA011', 'MD03', 2, '2016-11-04', 'Positive'),
		   (9, 'PA001', 'MD04', 2, GETDATE(),'Positive'),
		   (10,'PA002', 'MD03', 3, GETDATE(),'Not conclusive'),
		   (11,'PA003', 'MD02', 3, GETDATE(),'Negative'),
		   (12,'PA004', 'MD01', 3, GETDATE(),'Not conclusive'),
		   (13,'PA005', 'MD02', 2, GETDATE(),'Positive'),
		   (14,'PA006', 'MD03', 2, GETDATE(),'Not conclusive'),
		   (15,'PA007', 'MD04', 1, GETDATE(),'Positive'),
		   (16,'PA008', 'MD03', 3, GETDATE(),'Not conclusive');
GO



INSERT INTO Prescription 
	VALUES (10, 1, '2019-01-02'),
		   (11, 2, '2017-06-02'),
		   (12, 3, '2018-01-02'),
		   (13, 9, '2019-04-2'),
		   (14, 13, '2016-09-12'),
		   (15, 7, '2019-03-25'), 
		   (16, 14, '2019-03-26'), 
		   (17, 16, '2019-03-27'), 
		   (18, 8, '2019-03-26');
GO



INSERT INTO MedicinePrescribed 
	VALUES (10, 3,'As you wish', 10),
		   (14, 2,'As you wish', 12),
		   (12, 5,'As you wish', 6),
		   (11, 1,'As you wish', 9),
		   (13, 4,'As you wish', 7),
		   (18, 4, '3 times daily', 3),
		   (17, 3, '2 times daily', 2),
		   (10, 5, '2 times a day', 3), 
		   (12, 1, '3 times daly', 2);
GO



INSERT INTO PharmacyPersonel 
	VALUES ('EMP02', 'GP-003', '2012-02-06', 86, 'Senior'),
		   ('EMP06', 'CP-073', '2014-04-13', 93, 'Junior'),
		   ('EMP08', 'AB-099', '2017-02-16', 93, 'Junior');
GO



