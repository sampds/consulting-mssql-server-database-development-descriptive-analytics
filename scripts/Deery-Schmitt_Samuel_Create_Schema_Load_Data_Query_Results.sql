DROP PROCEDURE IF EXISTS ParentDashboard
DROP PROCEDURE IF EXISTS sp_insert_parent_records_into_demographic_tables
DROP PROCEDURE IF EXISTS sp_insert_student_records_into_demographic_tables
DROP PROCEDURE IF EXISTS sp_insert_record_into_parent_student_list
DROP PROCEDURE IF EXISTS reset_institution_table
DROP PROCEDURE IF EXISTS sp_insert_record_into_parent_education
DROP PROCEDURE IF EXISTS sp_insert_record_into_college_application

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parent_education')
BEGIN
	DROP TABLE parent_education
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'college_application')
BEGIN
	DROP TABLE college_application
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'institution')
BEGIN
	DROP TABLE institution
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'student_citizenship_list')
BEGIN
	DROP TABLE student_citizenship_list
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'student_nationality_list')
BEGIN
	DROP TABLE student_nationality_list
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parent_student_list')
BEGIN
	DROP TABLE parent_student_list
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'student')
BEGIN
	DROP TABLE student
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parent_citizenship_list')
BEGIN
	DROP TABLE parent_citizenship_list
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parent_nationality_list')
BEGIN
	DROP TABLE parent_nationality_list
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'parent')
BEGIN
	DROP TABLE parent
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'degree_type')
BEGIN
	DROP TABLE degree_type
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'highest_education_level')
BEGIN
	DROP TABLE highest_education_level
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'country')
BEGIN
	DROP TABLE country
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'us_state')
BEGIN
	DROP TABLE us_state
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'citizenship')
BEGIN
	DROP TABLE citizenship
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'nationality')
BEGIN
	DROP TABLE nationality
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'relationship')
BEGIN
	DROP TABLE relationship
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'attendance_decision')
BEGIN
	DROP TABLE attendance_decision
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'admissions_decision')
BEGIN
	DROP TABLE admissions_decision
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'application_status')
BEGIN
	DROP TABLE application_status
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'application_type')
BEGIN
	DROP TABLE application_type
END
GO

CREATE TABLE application_type (
	application_type_id int identity primary key
	, application_type varchar(30) not null
	, CONSTRAINT uq_a_t UNIQUE (application_type)
)
GO

CREATE TABLE application_status (
	application_status_id int identity primary key
	, application_status varchar(30) not null
	, CONSTRAINT uq_a_s UNIQUE (application_status)
)
GO

CREATE TABLE admissions_decision (
	admissions_decision_id int identity primary key
	, admissions_decision varchar(30) not null
	, CONSTRAINT uq_a_d UNIQUE (admissions_decision)
)
GO

CREATE TABLE attendance_decision (
	attendance_decision_id int identity primary key
	, attendance_decision varchar(50) not null
	, CONSTRAINT uq_at_de UNIQUE (attendance_decision)
)
GO

CREATE TABLE relationship (
	relationship_id int identity primary key
	, relationship varchar(30) not null
	CONSTRAINT uq_r UNIQUE (relationship)
)
GO

CREATE TABLE citizenship (
	citizenship_id int identity primary key
	, citizenship varchar(100) not null
	, CONSTRAINT uq_cit UNIQUE (citizenship)
)
GO

CREATE TABLE nationality (
	nationality_id int identity primary key
	, nationality varchar(100) not null
	, CONSTRAINT uq_nat UNIQUE (nationality)
)
GO

CREATE TABLE us_state (
	us_state_id int identity primary key
	, state_name varchar(100) not null
	, CONSTRAINT uq_us_s UNIQUE (state_name)
	, state_abbreviation char(2) not null
	, CONSTRAINT uq_s_a UNIQUE (state_abbreviation)
)
GO

CREATE TABLE country (
	country_id int identity primary key
	, country_name nvarchar(100) not null
	, CONSTRAINT uq_cou_nam UNIQUE (country_name)
	, abbreviation char(3) not null
	, CONSTRAINT uq_abb UNIQUE (abbreviation)
)
GO

CREATE TABLE degree_type (
	degree_type_id int identity primary key
	, degree_type varchar(50) not null
	, CONSTRAINT uq_d_t UNIQUE (degree_type)
)
GO

CREATE TABLE highest_education_level (
	highest_education_level_id int identity primary key
	, highest_education_level varchar(100) not null
	, CONSTRAINT uq_h_e_l UNIQUE (highest_education_level)
)
GO

CREATE TABLE parent (
	parent_id int identity primary key
	, english_forename varchar(100) not null
	, english_middle_initial varchar(1)
	, english_surname varchar(100) not null
	, international_forename nvarchar(100)
	, international_middle_name nvarchar(100)
	, international_surname nvarchar(100)
	, preferred_forename nvarchar(100)
	, preferred_surname nvarchar(100)
	, address_line_1 varchar(100) not null
	, address_line_2 varchar(100)
	, city varchar(100) not null
	, us_state_id int FOREIGN KEY REFERENCES us_state(us_state_id)
	, international_state_province varchar(50)
	, postal_code varchar(11) not null
	, country_id int FOREIGN KEY REFERENCES country(country_id)
	, phone_country_code varchar(10) not null
	, phone_number varchar(10) not null
	, email nvarchar(100) not null
	, birth_country_id int FOREIGN KEY REFERENCES country(country_id)
)
GO

CREATE TABLE parent_citizenship_list (
	parent_citizenship_list_id int identity primary key
	, citizenship_id int FOREIGN KEY REFERENCES citizenship(citizenship_id) not null
	, parent_id int FOREIGN KEY REFERENCES parent(parent_id) not null
)
GO

CREATE TABLE parent_nationality_list (
	parent_nationality_list_id int identity primary key
	, nationality_id int FOREIGN KEY REFERENCES nationality(nationality_id) not null
	, parent_id int FOREIGN KEY REFERENCES parent(parent_id) not null
)
GO

CREATE TABLE student (
	student_id int identity primary key
	, english_forename varchar(100) not null
	, english_middle_initial varchar(1)
	, english_surname varchar(100) not null
	, international_forename nvarchar(100)
	, international_middle_name nvarchar(100)
	, international_surname nvarchar(100)
	, preferred_forename nvarchar(100)
	, preferred_surname nvarchar(100)
	, current_school varchar(100) not null
	, graduation_year int not null
	, address_line_1 varchar(100) not null
	, address_line_2 varchar(100)
	, city varchar(100) not null
	, us_state_id int FOREIGN KEY REFERENCES us_state(us_state_id)
	, international_state_province varchar(50)
	, postal_code varchar(11) not null
	, country_id int FOREIGN KEY REFERENCES country(country_id)
	, phone_country_code varchar(10) not null
	, phone_number varchar(10) not null
	, email nvarchar(100) not null
	, birth_country_id int FOREIGN KEY REFERENCES country(country_id)
)
GO

CREATE TABLE parent_student_list (
	parent_student_list_id int identity primary key
	, parent_id int FOREIGN KEY REFERENCES parent(parent_id) not null
	, student_id int FOREIGN KEY REFERENCES student(student_id) not null
	, relationship_id int FOREIGN KEY REFERENCES relationship(relationship_id) not null
)
GO

CREATE TABLE student_citizenship_list (
	student_citizenship_list_id int identity primary key
	, citizenship_id int FOREIGN KEY REFERENCES citizenship(citizenship_id) not null
	, student_id int FOREIGN KEY REFERENCES student(student_id) not null
)
GO

CREATE TABLE student_nationality_list (
	student_citizenship_list_id int identity primary key
	, nationality_id int FOREIGN KEY REFERENCES nationality(nationality_id) not null
	, student_id int FOREIGN KEY REFERENCES student(student_id) not null
)
GO

CREATE TABLE institution (
	institution_id varchar(10) primary key
	, parent_institution_id char(10)
	, ope_id char(10)
	, institution_name varchar(200) not null
	, parent_institution_name varchar(200)
	, institution_type varchar(20)
	, city varchar(50)
	, inst_state char(2) not null
	, zipcode char(5) not null
	, complete_address varchar(200) not null
	, general_phone varchar(50)
	, admin_name varchar(50)
	, admin_phone varchar(50)
	, admin_email varchar(100)
	, last_updated_by_dept_of_edu varchar(50)
)
GO

CREATE TABLE college_application (
	college_application_id int identity primary key
	, student_id int FOREIGN KEY REFERENCES student(student_id) not null
	, application_type_id int FOREIGN KEY REFERENCES application_type(application_type_id) not null
	, institution_id varchar(10) FOREIGN KEY REFERENCES institution(institution_id) not null
	, institution_submission_deadline datetime
	, a1_submission_deadline datetime
	, application_status_id int FOREIGN KEY REFERENCES application_status(application_status_id) not null
	, admissions_decision_id int FOREIGN KEY REFERENCES admissions_decision(admissions_decision_id) not null
	, attendance_decision_id int FOREIGN KEY REFERENCES attendance_decision(attendance_decision_id) not null
)
GO

CREATE TABLE parent_education (
	parent_education_id int identity primary key
	, parent_id int FOREIGN KEY REFERENCES parent(parent_id) not null
	, highest_education_level_id int FOREIGN KEY REFERENCES highest_education_level(highest_education_level_id) not null
	, degree_type_id int FOREIGN KEY REFERENCES degree_type(degree_type_id) not null
)
GO

INSERT INTO highest_education_level
	(highest_education_level)
VALUES
	('No education')
	,('Some grade/primary school')
	,('Completed grade/primary school')
	,('Some high/secondary school')
	,('Graduated from high/secondary school (or equivalent)')
	,('Some trade school or community college')
	,('Graduated from trade school or community college')
	,('Some college/university')
	,('Graduated from college/university')
	,('Some graduate school')
	,('Graduate school')
GO

INSERT INTO degree_type
	(degree_type)
VALUES
	('No degree')
	,('GED or equivalent')
	,('Associate''s (AA, AS)')
	,('Bachelor''s (BA, BS)')
	,('Master''s (MA, MS)')
	,('Business (MBA, MAcc)')
	,('Law (JD, LLM)')
	,('Medicine (MD, DO, DVM, DDS)')
	,('Doctorate (PhD, EdD, etc.)')
	,('Other')
GO

INSERT INTO relationship
	(relationship)
VALUES
	('Mother (Biological)')
	,('Father (Biological)')
	,('Legal Guardian')
	,('Aunt')
	,('Uncle')
	,('Brother')
	,('Sister')
	,('Cousin')
	,('Stepbrother')
	,('Stepsister')
	,('Other')
GO

INSERT INTO application_type
	(application_type)
VALUES
	('Early Action')
	,('Early Decision')
	,('Regular Decision')
	,('Rolling Admission')
	,('Upward Bound')
	,('Other')
GO

INSERT INTO application_status
	(application_status)
VALUES
	('Unsubmitted')
	,('Submitted')
GO

INSERT INTO admissions_decision
	(admissions_decision)
VALUES
	('Accepted')
	,('Rejected')
	,('Waitlisted')
	,('Other')
GO

INSERT INTO attendance_decision
	(attendance_decision)
VALUES
	('NA: application not submitted')
	,('NA: no admissions decision received')
	,('NA: rejected by admissions')
	,('Declined to attend')
	,('Decided to attend')
GO

-- Import 8 CSV files to create the following tables:
/*
1 citizenship_import
	chose nvcarh(MAX) for citizenship column in order to add longest values
2 country_import 
	chose nvchar(MAX) for country column in order to add longest values
3 institution_import
 here is the data type for each column roughly calculcated based on max length of element in each column
	institution_id varchar(10) primary key
	, parent_institution_id char(10)
	, ope_id char(10)
	, institution_name varchar(200) not null
	, parent_institution_name varchar(200)
	, institution_type varchar(20)
	, city varchar(50)
	, inst_state char(2) not null
	, zipcode char(5) not null
	, complete_address varchar(200) not null
	, general_phone varchar(50)
	, admin_name varchar(50)
	, admin_phone varchar(50)
	, admin_email varchar(100)
	, last_updated_by_dept_of_edu varchar(50)
4 parent_import
	parent_id as int
	, english_forename and english_surname as varchar(50)
	, international_forename and surname as nvarchar(50)
	, city as varchar(50)
	, address_line_1 as varchar(MAX)
	, postal_code, phone_country_code, and phone_number as varchar(50),
	, email as nvarchar(50)
5 nationality_import
	was able to "click through" for defaults
6 student_import
	student_id as int
	, english_forename and english_surname as varchar(50)
	, international_forename and surname as nvarchar(50)
	, current_school as varchar(50
	, graduation_year as int
	----- THIS NEEDS TO BE CONVERTED PROPERLY BEFORE GOING LIVE
	, city as varchar(50)
	, address_line_1 as varchar(MAX)
	, postal_code, phone_country_code, and phone_number as varchar(50),
	, email as nvarchar(50)
7 us_state_import
	was able to "click through" for defaults
8 i also inserted the table
	institution_with_rankings_import
	same settings as the other one, just an extra column
	going to use this as an "experimental" table to add rankings for colleges in the future
	beyond just the us news and world report
	for instance, would like to completion of associate's at community colleges as well as successful transfer to 4-year college to come up
	with a "quality" index for certain programs at different community colleges
	same for degrees at 4-year institutions
	by having two tables, and a stored procedur i can use to revert to the safe one,
	I can safely insert new metrics in without messing up my "good" table

	I'm not going to make it live yet, but I may run views on it
*/

-- Insert the intermediate table values into the corresponding live tables

-- 1 citizenship
--double-check intermediate column names
SELECT * FROM citizenship_import
-- do the insert
INSERT INTO citizenship (citizenship)
	SELECT citizenship FROM citizenship_import
-- make sure it worked 
SELECT * FROM citizenship
GO

-- 2 country
--double-check intermediate column names
SELECT * FROM country_import
-- do the insert
INSERT INTO country (country_name, abbreviation)
	SELECT country_name, abbreviation FROM country_import
-- make sure it worked 
SELECT * FROM country
GO

-- 3 institution
--double-check intermediate column names
SELECT * FROM institution_import
-- do the insert
INSERT INTO institution (institution_id, parent_institution_id, ope_id, institution_name, parent_institution_name, institution_type, city, inst_state, zipcode, complete_address, general_phone, admin_name, admin_phone, admin_email, last_updated_by_dept_of_edu)
	SELECT * FROM institution_import
-- make sure it worked 
SELECT * FROM institution
GO

-- 4 nationality
--double-check intermediate column names
SELECT * FROM nationality_import
-- do the insert
INSERT INTO nationality (nationality)
	SELECT nationality FROM nationality_import
-- make sure it worked 
SELECT * FROM nationality
GO

-- 5 us_state
--double-check intermediate column names
SELECT * FROM us_state_import
-- do the insert
INSERT INTO us_state (state_name, state_abbreviation)
	SELECT state_name, state_abbreviation FROM us_state_import
-- make sure it worked 
SELECT * FROM us_state
GO

--6 parent
--double-check intermediate column names
SELECT * FROM parent_import
-- do the insert
INSERT INTO parent (english_forename, english_surname, international_forename, international_surname
, city, address_line_1, postal_code, phone_country_code, phone_number, email)
	SELECT english_forename, english_surname, international_forename, international_surname
, city, address_line_1, postal_code, phone_country_code, phone_number, email FROM parent_import
-- make sure it worked 
SELECT * FROM parent
GO

-- 7 student
SELECT * FROM student_import
-- do the insert
INSERT INTO student (english_forename, english_surname, international_forename, international_surname, current_school, graduation_year
, city, address_line_1, postal_code, phone_country_code, phone_number, email)
	SELECT english_forename, english_surname, international_forename, international_surname, current_school, graduation_year
, address_line_1, city,  postal_code, phone_country_code, phone_number, email FROM student_import
-- make sure it worked 
SELECT * FROM student
GO
-- create a stored procedure to update the institution table, effectively "resetting" it based on the current instition_import table in memory
-- this will allow me to run my R script on the table, then load it into here, run this procedure, and update it

CREATE OR ALTER PROCEDURE reset_institution_table (
@areYouSure varchar(10))
AS
BEGIN
	IF @areYouSure = 'Yes'
		BEGIN
			DELETE FROM institution
			INSERT INTO institution (institution_id, parent_institution_id, ope_id, institution_name, parent_institution_name, institution_type, city, inst_state, zipcode, complete_address, general_phone, admin_name, admin_phone, admin_email, last_updated_by_dept_of_edu)
				SELECT * FROM institution_import
			Print ('institution records were reset to match institution_import records.')
		END
	ELSE
		BEGIN
			Print ('Ok, will not reset the table.')
		END
END
GO

-- make a procedure that adds records to parent_education table
-- this can be used as a template to add records at ANY bridge table

CREATE OR ALTER PROCEDURE sp_insert_record_into_parent_education (
@parent_email nvarchar(100)
, @highest_education_level varchar(100)
, @degree_type varchar(50))
AS
BEGIN
     DECLARE @parent_id int
	 DECLARE @highest_education_level_id int
     DECLARE @degree_type_id int

     SELECT @parent_id = parent_id FROM parent WHERE email = @parent_email
     SELECT @highest_education_level_id = highest_education_level_id FROM highest_education_level WHERE highest_education_level = @highest_education_level
	 SELECT @degree_type_id = degree_type_id FROM degree_type WHERE degree_type = @degree_type

     INSERT INTO parent_education VALUES (@parent_id, @highest_education_level_id, @degree_type_id)
END
GO

-- make a procedure that inserts records into ALL the demographic tables for which parent.parent_id is a foreign key

CREATE OR ALTER PROCEDURE sp_insert_parent_records_into_demographic_tables (
@parent_email nvarchar(100)
, @highest_education_level varchar(100)
, @degree_type varchar(50)
, @citizenship varchar(100)
, @nationality varchar(100))
AS
BEGIN
	-- parent_education
	DECLARE @parent_id int
	DECLARE @highest_education_level_id int
    DECLARE @degree_type_id int

    SELECT @parent_id = parent_id FROM parent WHERE email = @parent_email
    SELECT @highest_education_level_id = highest_education_level_id FROM highest_education_level WHERE highest_education_level = @highest_education_level
	SELECT @degree_type_id = degree_type_id FROM degree_type WHERE degree_type = @degree_type

    INSERT INTO parent_education VALUES (@parent_id, @highest_education_level_id, @degree_type_id)

	--parent_citizenship_list
	DECLARE @citizenship_id int
	
	SELECT @citizenship_id = citizenship_id FROM citizenship WHERE citizenship = @citizenship
	SELECT @parent_id = parent_id FROM parent WHERE email = @parent_email
	
	INSERT INTO parent_citizenship_list VALUES (@citizenship_id, @parent_id)
	
	--parent_nationality_list
	DECLARE @nationality_id int

	SELECT @nationality_id = nationality_id FROM nationality WHERE nationality = @nationality
	SELECT @parent_id = parent_id FROM parent WHERE email = @parent_email

	INSERT INTO parent_nationality_list VALUES (@nationality_id, @parent_id)
END
GO

-- make a similar stored procedure for students
-- make a procedure that inserts records into ALL demographic tables for which student.student.id is a foreign key
-- at this point, it's just citizenship and nationality

CREATE OR ALTER PROCEDURE sp_insert_student_records_into_demographic_tables (
@student_email nvarchar(100) 
,@citizenship varchar(100)
,@nationality varchar(100)) 
AS
BEGIN
	--student_citizenship_list
	DECLARE @student_id int
	DECLARE @citizenship_id int
	
	SELECT @citizenship_id = citizenship_id FROM citizenship WHERE citizenship = @citizenship
	SELECT @student_id = student_id FROM student WHERE email = @student_email
	
	INSERT INTO student_citizenship_list VALUES (@citizenship_id, @student_id)
	
	--parent_nationality_list
	DECLARE @nationality_id int

	SELECT @nationality_id = nationality_id FROM nationality WHERE nationality = @nationality
	SELECT @student_id = student_id FROM student WHERE email = @student_email

	INSERT INTO student_nationality_list VALUES (@nationality_id, @student_id)
END
GO

CREATE OR ALTER PROCEDURE sp_insert_record_into_parent_student_list (
@parent_email nvarchar(100)
, @student_email nvarchar(100)
, @relationship varchar(30))
AS
BEGIN
	 --parent_student_list
	DECLARE @parent_id int
	DECLARE @student_id int
	DECLARE @relationship_id int

	SELECT @parent_id = parent_id FROM parent WHERE email = @parent_email
	SELECT @student_id = student_id FROM student WHERE email = @student_email
	SELECT @relationship_id = relationship_id FROM relationship WHERE relationship = @relationship

	INSERT INTO parent_student_list VALUES (@parent_id, @student_id, @relationship_id)
END
GO

-- make a procedure to insert records into college_application

CREATE OR ALTER PROCEDURE sp_insert_record_into_college_application (
@student_email nvarchar(100) 
, @application_type varchar(30)
, @institution_name varchar(200)
, @application_status varchar(30)
, @admissions_decision varchar(30)
, @attendance_decision varchar(50))
AS
BEGIN
	DECLARE @student_id int
	DECLARE @application_type_id int
	DECLARE @institution_id varchar(50)
	DECLARE @application_status_id int
	DECLARE @admissions_decision_id int
	DECLARE @attendance_decision_id int

	SELECT @student_id = student_id FROM student WHERE email = @student_email
	SELECT @application_type_id = application_type_id FROM application_type WHERE application_type = @application_type
	SELECT @institution_id = institution_id FROM institution WHERE institution_name = @institution_name
	SELECT @application_status_id = application_status_id FROM application_status WHERE application_status = @application_status
	SELECT @admissions_decision_id = admissions_decision_id FROM admissions_decision WHERE admissions_decision = @admissions_decision
	SELECT @attendance_decision_id = attendance_decision_id FROM attendance_decision WHERE attendance_decision = @attendance_decision

	INSERT INTO college_application VALUES (@student_id, @application_type_id, @institution_id, null, null, @application_status_id, @admissions_decision_id, @attendance_decision_id)
END
GO

-- Make a person-readable VIEW of parent_education

CREATE OR ALTER VIEW ParentEducation
AS
	SELECT
		parent.english_forename + ' ' + parent.english_surname AS Parent
		, highest_education_level.highest_education_level AS HighestEducationLevel
		, degree_type.degree_type AS DegreeType
	FROM parent_education
	JOIN parent ON parent.parent_id = parent_education.parent_id
	RIGHT JOIN highest_education_level ON highest_education_level.highest_education_level_id = parent_education.highest_education_level_id
	RIGHT JOIN degree_type ON degree_type.degree_type_id = parent_education.degree_type_id
GO

CREATE OR ALTER VIEW ParentNationality
AS
	SELECT
		parent.english_forename + ' ' + parent.english_surname AS Parent
		, nationality.nationality AS Nationality
	FROM parent_nationality_list
	JOIN parent ON parent.parent_id = parent_nationality_list.parent_id
	JOIN nationality ON nationality.nationality_id = parent_nationality_list.nationality_id
GO

-- Make a person-readable VIEW of parent_citizenship

CREATE OR ALTER VIEW ParentCitizenship
AS
	SELECT
		parent.english_forename + ' ' + parent.english_surname AS Parent
		, citizenship.citizenship AS Citizenship
	FROM parent_citizenship_list
	JOIN parent ON parent.parent_id = parent_citizenship_list.parent_id
	JOIN citizenship ON citizenship.citizenship_id = parent_citizenship_list.citizenship_id
GO

--Make a person-readable VIEW of parent_student

CREATE OR ALTER VIEW ParentStudent
AS
	SELECT
		parent.english_forename + ' ' + parent.english_surname AS Parent
		, student.english_forename + ' ' + student.english_surname AS Student
		, relationship.relationship AS RelationshipToStudent
	FROM parent_student_list
	JOIN parent ON parent.parent_id = parent_student_list.parent_id
	JOIN student ON student.student_id = parent_student_list.student_id
	JOIN relationship ON relationship.relationship_id = parent_student_list.relationship_id
GO

-- make a view of international and preferred names, if any exist

CREATE OR ALTER VIEW ParentNames
AS
	SELECT
	 	 parent.english_forename + ' ' + parent.english_surname AS EnglishName
		, parent.international_forename + ' ' + parent.international_surname AS InternationalName
		, parent.preferred_forename + ' ' + parent.preferred_surname AS PreferredName
	FROM parent_student_list
	JOIN parent ON parent.parent_id = parent_student_list.parent_id
GO

-- Make a procedure that pulls up person-readable VIEWS for parent information that may show up on the common app

CREATE OR ALTER PROCEDURE ParentDashboard
AS
BEGIN
	SELECT * FROM ParentStudent
	SELECT * FROM ParentNames
	SELECT * FROM ParentEducation
	SELECT * FROM ParentNationality
	SELECT * FROM ParentCitizenship
END
GO

-- Make a person-readable VIEW of student_nationality

CREATE OR ALTER VIEW StudentNationality
AS
	SELECT
		student.english_forename + ' ' + student.english_surname AS Student
		, nationality.nationality AS Nationality
	FROM student_nationality_list
	JOIN student ON student.student_id = student_nationality_list.student_id
	JOIN nationality ON nationality.nationality_id = student_nationality_list.nationality_id
GO

-- Make a person-readable VIEW of student_citizenship

CREATE OR ALTER VIEW StudentCitizenship
AS
	SELECT
		student.english_forename + ' ' + student.english_surname AS Student
		, citizenship.citizenship AS Citizenship
	FROM student_citizenship_list
	JOIN student ON student.student_id = student_citizenship_list.student_id
	JOIN citizenship ON citizenship.citizenship_id = student_citizenship_list.citizenship_id
GO

-- make a view of international and preferred names, if any exist

CREATE OR ALTER VIEW StudentNames
AS
	SELECT 
		  student.english_forename + ' ' + student.english_surname AS EnglishName
		, student.international_forename + ' ' + student.international_surname AS InternationalName
		, student.preferred_forename + ' ' + student.preferred_surname AS PreferredName
	FROM Student
GO

-- Make a procedure that pulls up person-readable VIEWS for student information that may show up on the common app


CREATE OR ALTER PROCEDURE StudentDemographicDashboard
AS
BEGIN
	SELECT * FROM ParentStudent
	SELECT * FROM StudentNames
	SELECT * FROM StudentCitizenship
	SELECT * FROM StudentNationality
END
GO

CREATE OR ALTER VIEW CollegeAppDashboard
AS
	SELECT
		student.english_forename + ' ' + student.english_surname AS Student
		, student.graduation_year AS HSGradYear
		, institution.institution_name AS School 
		, dbo.institution_with_rankings_import.ranking AS Ranking
		, application_status AS SubmissionStatus
		, admissions_decision AS Decision
		, attendance_decision AS Attendance
	FROM college_application
	JOIN student ON student.student_id = college_application.student_id
	JOIN institution ON institution.institution_id = college_application.institution_id
	JOIN dbo.institution_with_rankings_import ON dbo.institution_with_rankings_import.institution_id = college_application.institution_id 
	JOIN application_status ON application_status.application_status_id = college_application.application_status_id
	JOIN admissions_decision ON admissions_decision.admissions_decision_id = college_application.admissions_decision_id
	JOIN attendance_decision ON attendance_decision.attendance_decision_id = college_application.attendance_decision_id
GO

-- execute stored procecures programmatically created in R
-- there was an issue with the odbc orm and the virtual machine, so i just made some functions to generate these statements

BEGIN
  EXEC sp_insert_record_into_parent_student_list 'mwellard0@economist.com', 'tdessent0@biblegateway.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'abeadon1@example.com', 'idickons1@cloudflare.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'cmarkussen2@meetup.com', 'dharker2@studiopress.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'qprium3@hp.com', 'morange3@newyorker.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'dbleything4@yolasite.com', 'estoakes4@devhub.com', 'Aunt'
  EXEC sp_insert_record_into_parent_student_list 'jlandsman5@yahoo.com', 'jgiriardelli5@google.it', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'vdevita6@furl.net', 'lgheorghe6@slashdot.org', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'mmates7@bbb.org', 'tvanarsdall7@wufoo.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'rconers8@miitbeian.gov.cn', 'fespin8@mozilla.org', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'emusker9@discovery.com', 'nepton9@abc.net.au', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'jcattlowa@ask.com', 'sduchasteaua@zimbio.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'msmolanb@google.com.hk', 'fhalgarthb@rediff.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'cpalfreyc@loc.gov', 'ynettleshipc@blinklist.com', 'Aunt'
  EXEC sp_insert_record_into_parent_student_list 'alivingsd@chicagotribune.com', 'maloshikind@businesswire.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'lmoxhame@printfriendly.com', 'cduthiee@studiopress.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'blambrookf@freewebs.com', 'lboldeckef@statcounter.com', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'yluptong@cdbaby.com', 'amickleboroughg@ft.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'jmaddockh@imgur.com', 'emullinh@nbcnews.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'lpearli@columbia.edu', 'llucchii@tinyurl.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'hmussillij@cbsnews.com', 'krubiej@devhub.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'dmechick@vkontakte.ru', 'rtimblettk@a8.net', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'vleidll@springer.com', 'smyttonl@cocolog-nifty.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'dverdunm@cbc.ca', 'jminghellam@artisteer.com', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'kshiebern@technorati.com', 'sspeakmann@microsoft.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'rhottono@spiegel.de', 'tburgho@usda.gov', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'pskillingp@mapquest.com', 'ivolagep@globo.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'bstenetq@nytimes.com', 'cduckittq@de.vu', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'nhillingr@is.gd', 'pdictusr@wikispaces.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'vholliars@state.tx.us', 'rgevers@pagesperso-orange.fr', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'ejorist@va.gov', 'nlabant@gizmodo.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'cdroghanu@dion.ne.jp', 'aalanu@army.mil', 'Aunt'
  EXEC sp_insert_record_into_parent_student_list 'egeocklev@taobao.com', 'jlubeckv@sitemeter.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'khellicarw@sourceforge.net', 'naysikw@chronoengine.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'afishbournex@ucoz.ru', 'mfarrinx@si.edu', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'hwasbeyy@google.co.uk', 'lhansody@umn.edu', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'acoulthardz@surveymonkey.com', 'droakez@wisc.edu', 'Stepsister'
  EXEC sp_insert_record_into_parent_student_list 'rkleisel10@cafepress.com', 'fjosephs10@mysql.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'cpacher11@friendfeed.com', 'reuels11@51.la', 'Aunt'
  EXEC sp_insert_record_into_parent_student_list 'ebenham12@netscape.com', 'lmacdermid12@reference.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'bdurbyn13@tuttocitta.it', 'rattenborrow13@com.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'mhambers14@ucla.edu', 'tallchorne14@mediafire.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'hkempston15@ox.ac.uk', 'rspeachley15@upenn.edu', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'nfalkingham16@feedburner.com', 'rrolls16@house.gov', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'cmacilwrick17@ihg.com', 'mpressey17@intel.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'jrushford18@vistaprint.com', 'slinning18@harvard.edu', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'mgonning19@forbes.com', 'rphizaclea19@feedburner.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'ascapens1a@lycos.com', 'ctrematick1a@mayoclinic.com', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'dferrao1b@fema.gov', 'cstpierre1b@digg.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'ddebruijne1c@themeforest.net', 'dsheals1c@com.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'mmacillrick1d@privacy.gov.au', 'wlivick1d@wikimedia.org', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'mtolworth1e@mlb.com', 'rholliar1e@bigcartel.com', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'ldigwood1f@csmonitor.com', 'scouve1f@sina.com.cn', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'runthank1g@earthlink.net', 'cquig1g@twitter.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'hstefi1h@shinystat.com', 'hpedrozzi1h@github.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'tmuckle1i@adobe.com', 'mquernel1i@abc.net.au', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'rbaudrey1j@dell.com', 'lalu1j@theglobeandmail.com', 'Other'
  EXEC sp_insert_record_into_parent_student_list 'emckeag1k@berkeley.edu', 'crookes1k@irs.gov', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'rhearson1l@irs.gov', 'rsacase1l@ted.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'echazotte1m@alibaba.com', 'jbea1m@fda.gov', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'sbeasley1n@istockphoto.com', 'tweddell1n@cafepress.com', 'Other'
  EXEC sp_insert_record_into_parent_student_list 'esweetlove1o@nba.com', 'ahuff1o@slideshare.net', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'mcarmen1p@oakley.com', 'rhanfrey1p@trellian.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'pjeacop1q@soup.io', 'dlivesey1q@etsy.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'sarrigucci1r@latimes.com', 'eleathe1r@360.cn', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'groskelley1s@tmall.com', 'aheamus1s@soup.io', 'Aunt'
  EXEC sp_insert_record_into_parent_student_list 'slecordier1t@odnoklassniki.ru', 'bsheehy1t@parallels.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'cyonnie1u@dmoz.org', 'hingree1u@friendfeed.com', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'awebling1v@va.gov', 'kcrole1v@goo.gl', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'jwhistan1w@fc2.com', 'njaskiewicz1w@patch.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'sthornton1x@prlog.org', 'vbortolotti1x@techcrunch.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'squinby1y@nps.gov', 'amethuen1y@opensource.org', 'Uncle'
  EXEC sp_insert_record_into_parent_student_list 'rchsteney1z@simplemachines.org', 'mbeccera1z@prweb.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'akencott20@ebay.com', 'ahanse20@cbslocal.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'pcoey21@tamu.edu', 'bmcging21@people.com.cn', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'scake22@bandcamp.com', 'mhunstone22@state.gov', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'wmccray23@ted.com', 'ihairesnape23@dion.ne.jp', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'bstoffersen24@jalbum.net', 'omaccallester24@artisteer.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'akerford25@wisc.edu', 'cmcquirter25@cnet.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'rseefus26@gnu.org', 'fjehan26@fotki.com', 'Aunt'
  EXEC sp_insert_record_into_parent_student_list 'khengoed27@newyorker.com', 'rharlin27@bandcamp.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'tscully28@surveymonkey.com', 'okealy28@bluehost.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'nlonglands29@issuu.com', 'mwolstenholme29@wiley.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'dsybe2a@reverbnation.com', 'qfitzhenry2a@chronoengine.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'kmichin2b@theguardian.com', 'plukacs2b@mail.ru', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'bmacchaell2c@state.tx.us', 'rbrantl2c@ox.ac.uk', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'ecouves2d@tumblr.com', 'acreed2d@slashdot.org', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'lbryer2e@microsoft.com', 'sdutnell2e@accuweather.com', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'ploach2f@senate.gov', 'emoorhead2f@imageshack.us', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'gtosdevin2g@freewebs.com', 'pfeldberger2g@facebook.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'dmonckton2h@economist.com', 'eaartsen2h@archive.org', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'dfowler2i@comsenz.com', 'mparysiak2i@yellowbook.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'lallawy2j@theguardian.com', 'dnary2j@hao123.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'ealleyn2k@sohu.com', 'mmarfe2k@yahoo.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'jbuckles2l@latimes.com', 'tmcclenan2l@geocities.jp', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'sfasse2m@dell.com', 'cdemchen2m@symantec.com', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'mwollard2n@ucoz.ru', 'lscantlebury2n@dmoz.org', 'Father (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'ahorsley2o@yahoo.com', 'ahouldey2o@mit.edu', 'Legal Guardian'
  EXEC sp_insert_record_into_parent_student_list 'bnorrie2p@jugem.jp', 'hranger2p@ebay.co.uk', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'kkynvin2q@senate.gov', 'fpearle2q@amazon.com', 'Mother (Biological)'
  EXEC sp_insert_record_into_parent_student_list 'kchatwood2r@bing.com', 'agiacomi2r@nifty.com', 'Legal Guardian'
END
GO
  -- populate other records in which parent is a foreign key
BEGIN
EXEC sp_insert_parent_records_into_demographic_tables 'mwellard0@economist.com', 'Some high/secondary school', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'abeadon1@example.com', 'Some high/secondary school', 'No degree', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'cmarkussen2@meetup.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'qprium3@hp.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dbleything4@yolasite.com', 'No education', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'jlandsman5@yahoo.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'vdevita6@furl.net', 'Some trade school or community college', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mmates7@bbb.org', 'Some high/secondary school', 'No degree', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'rconers8@miitbeian.gov.cn', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'emusker9@discovery.com', 'Graduate school', 'Master''s (MA, MS)', 'Korea, Republic of', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'jcattlowa@ask.com', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'msmolanb@google.com.hk', 'No education', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'cpalfreyc@loc.gov', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'alivingsd@chicagotribune.com', 'Some high/secondary school', 'No degree', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'lmoxhame@printfriendly.com', 'Completed grade/primary school', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'blambrookf@freewebs.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'yluptong@cdbaby.com', 'Some graduate school', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'jmaddockh@imgur.com', 'Some graduate school', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'lpearli@columbia.edu', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'hmussillij@cbsnews.com', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dmechick@vkontakte.ru', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'vleidll@springer.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dverdunm@cbc.ca', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'kshiebern@technorati.com', 'Graduated from high/secondary school (or equivalent)', 'GED or equivalent', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'rhottono@spiegel.de', 'Some college/university', 'No degree', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'pskillingp@mapquest.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'bstenetq@nytimes.com', 'Graduated from high/secondary school (or equivalent)', 'GED or equivalent', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'nhillingr@is.gd', 'Graduate school', 'Master''s (MA, MS)', 'Korea, Republic of', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'vholliars@state.tx.us', 'Graduated from high/secondary school (or equivalent)', 'GED or equivalent', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ejorist@va.gov', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'cdroghanu@dion.ne.jp', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'egeocklev@taobao.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'khellicarw@sourceforge.net', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'afishbournex@ucoz.ru', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'hwasbeyy@google.co.uk', 'Some high/secondary school', 'No degree', 'Korea, Republic of', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'acoulthardz@surveymonkey.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'rkleisel10@cafepress.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'cpacher11@friendfeed.com', 'Completed grade/primary school', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ebenham12@netscape.com', 'Some grade/primary school', 'No degree', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'bdurbyn13@tuttocitta.it', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mhambers14@ucla.edu', 'Some graduate school', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'hkempston15@ox.ac.uk', 'Graduated from high/secondary school (or equivalent)', 'GED or equivalent', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'nfalkingham16@feedburner.com', 'Some high/secondary school', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'cmacilwrick17@ihg.com', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'jrushford18@vistaprint.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mgonning19@forbes.com', 'Completed grade/primary school', 'No degree', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'ascapens1a@lycos.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dferrao1b@fema.gov', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ddebruijne1c@themeforest.net', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mmacillrick1d@privacy.gov.au', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mtolworth1e@mlb.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ldigwood1f@csmonitor.com', 'Graduated from high/secondary school (or equivalent)', 'GED or equivalent', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'runthank1g@earthlink.net', 'Some graduate school', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'hstefi1h@shinystat.com', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'tmuckle1i@adobe.com', 'Completed grade/primary school', 'No degree', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'rbaudrey1j@dell.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'emckeag1k@berkeley.edu', 'Some high/secondary school', 'No degree', 'Korea, Republic of', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'rhearson1l@irs.gov', 'Graduate school', 'Master''s (MA, MS)', 'Korea, Republic of', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'echazotte1m@alibaba.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'sbeasley1n@istockphoto.com', 'Some graduate school', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'esweetlove1o@nba.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mcarmen1p@oakley.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'pjeacop1q@soup.io', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'sarrigucci1r@latimes.com', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'groskelley1s@tmall.com', 'Some grade/primary school', 'No degree', 'Korea, Republic of', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'slecordier1t@odnoklassniki.ru', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'cyonnie1u@dmoz.org', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'awebling1v@va.gov', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'jwhistan1w@fc2.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'sthornton1x@prlog.org', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'squinby1y@nps.gov', 'Some graduate school', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'rchsteney1z@simplemachines.org', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'akencott20@ebay.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'pcoey21@tamu.edu', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'scake22@bandcamp.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'wmccray23@ted.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'bstoffersen24@jalbum.net', 'Some grade/primary school', 'No degree', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'akerford25@wisc.edu', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'rseefus26@gnu.org', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'khengoed27@newyorker.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'tscully28@surveymonkey.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'nlonglands29@issuu.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dsybe2a@reverbnation.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'kmichin2b@theguardian.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'bmacchaell2c@state.tx.us', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ecouves2d@tumblr.com', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'lbryer2e@microsoft.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ploach2f@senate.gov', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'gtosdevin2g@freewebs.com', 'Some high/secondary school', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dmonckton2h@economist.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'dfowler2i@comsenz.com', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'lallawy2j@theguardian.com', 'Graduated from trade school or community college', 'Associate''s (AA, AS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'ealleyn2k@sohu.com', 'Graduate school', 'Master''s (MA, MS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'jbuckles2l@latimes.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'American'
EXEC sp_insert_parent_records_into_demographic_tables 'sfasse2m@dell.com', 'Some high/secondary school', 'No degree', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'mwollard2n@ucoz.ru', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'ahorsley2o@yahoo.com', 'Graduated from college/university', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'bnorrie2p@jugem.jp', 'Graduate school', 'Master''s (MA, MS)', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'kkynvin2q@senate.gov', 'Some graduate school', 'Bachelor''s (BA, BS)', 'United States of America', 'South.Korean'
EXEC sp_insert_parent_records_into_demographic_tables 'kchatwood2r@bing.com', 'Completed grade/primary school', 'No degree', 'United States of America', 'South.Korean'
END
GO
--populate the two demographic tables student.id is a foreign key in
BEGIN
EXEC sp_insert_student_records_into_demographic_tables 'tdessent0@biblegateway.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'idickons1@cloudflare.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'dharker2@studiopress.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'morange3@newyorker.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'estoakes4@devhub.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'jgiriardelli5@google.it', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'lgheorghe6@slashdot.org', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'tvanarsdall7@wufoo.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'fespin8@mozilla.org', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'nepton9@abc.net.au', 'Korea, Republic of', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'sduchasteaua@zimbio.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'fhalgarthb@rediff.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'ynettleshipc@blinklist.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'maloshikind@businesswire.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'cduthiee@studiopress.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'lboldeckef@statcounter.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'amickleboroughg@ft.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'emullinh@nbcnews.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'llucchii@tinyurl.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'krubiej@devhub.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rtimblettk@a8.net', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'smyttonl@cocolog-nifty.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'jminghellam@artisteer.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'sspeakmann@microsoft.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'tburgho@usda.gov', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'ivolagep@globo.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'cduckittq@de.vu', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'pdictusr@wikispaces.com', 'Korea, Republic of', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'rgevers@pagesperso-orange.fr', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'nlabant@gizmodo.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'aalanu@army.mil', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'jlubeckv@sitemeter.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'naysikw@chronoengine.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mfarrinx@si.edu', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'lhansody@umn.edu', 'Korea, Republic of', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'droakez@wisc.edu', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'fjosephs10@mysql.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'reuels11@51.la', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'lmacdermid12@reference.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rattenborrow13@com.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'tallchorne14@mediafire.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rspeachley15@upenn.edu', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rrolls16@house.gov', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mpressey17@intel.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'slinning18@harvard.edu', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rphizaclea19@feedburner.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'ctrematick1a@mayoclinic.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'cstpierre1b@digg.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'dsheals1c@com.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'wlivick1d@wikimedia.org', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rholliar1e@bigcartel.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'scouve1f@sina.com.cn', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'cquig1g@twitter.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'hpedrozzi1h@github.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mquernel1i@abc.net.au', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'lalu1j@theglobeandmail.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'crookes1k@irs.gov', 'Korea, Republic of', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'rsacase1l@ted.com', 'Korea, Republic of', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'jbea1m@fda.gov', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'tweddell1n@cafepress.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'ahuff1o@slideshare.net', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rhanfrey1p@trellian.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'dlivesey1q@etsy.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'eleathe1r@360.cn', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'aheamus1s@soup.io', 'Korea, Republic of', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'bsheehy1t@parallels.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'hingree1u@friendfeed.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'kcrole1v@goo.gl', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'njaskiewicz1w@patch.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'vbortolotti1x@techcrunch.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'amethuen1y@opensource.org', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mbeccera1z@prweb.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'ahanse20@cbslocal.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'bmcging21@people.com.cn', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mhunstone22@state.gov', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'ihairesnape23@dion.ne.jp', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'omaccallester24@artisteer.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'cmcquirter25@cnet.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'fjehan26@fotki.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'rharlin27@bandcamp.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'okealy28@bluehost.com', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mwolstenholme29@wiley.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'qfitzhenry2a@chronoengine.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'plukacs2b@mail.ru', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'rbrantl2c@ox.ac.uk', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'acreed2d@slashdot.org', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'sdutnell2e@accuweather.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'emoorhead2f@imageshack.us', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'pfeldberger2g@facebook.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'eaartsen2h@archive.org', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'mparysiak2i@yellowbook.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'dnary2j@hao123.com', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'mmarfe2k@yahoo.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'tmcclenan2l@geocities.jp', 'United States of America', 'American'
EXEC sp_insert_student_records_into_demographic_tables 'cdemchen2m@symantec.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'lscantlebury2n@dmoz.org', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'ahouldey2o@mit.edu', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'hranger2p@ebay.co.uk', 'Korea, Republic of', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'fpearle2q@amazon.com', 'United States of America', 'South.Korean'
EXEC sp_insert_student_records_into_demographic_tables 'agiacomi2r@nifty.com', 'United States of America', 'South.Korean'
END
GO


 -- populate college_application_table for 5 students
 BEGIN
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Early Action', 'University of Notre Dame', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Regular Decision', 'University of California, Berkeley', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Regular Decision', 'Massachusetts Institute of Technology', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Early Decision', 'Georgetown University', 'Submitted', 'Accepted', 'Decided to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Regular Decision', 'University of Michigan - Ann Arbor', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Regular Decision', 'University of California - Los Angeles', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Early Action', 'University of Pennsylvania', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Regular Decision', 'Johns Hopkins University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Early Action', 'Vanderbilt University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'morange3@newyorker.com', 'Regular Decision', 'Stanford University', 'Submitted', 'Rejected', 'Declined to attend'
 
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Early Decision', 'Brown University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'Rice University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'Cornell University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'California Institute of Technology', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'University of Notre Dame', 'Submitted', 'Accepted', 'Decided to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Early Action', 'Johns Hopkins University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'Georgetown University', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Early Action', 'Harvard University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'Duke University', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'lboldeckef@statcounter.com', 'Regular Decision', 'Northwestern University', 'Submitted', 'Rejected', 'Declined to attend'
  
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'Georgetown University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'University of Michigan - Ann Arbor', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Early Decision', 'University of California - Los Angeles', 'Submitted', 'Accepted', 'Decided to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Early Action', 'Princeton University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'Harvard University', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'Rice University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'Emory University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'Washington University in St Louis', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Regular Decision', 'University of Notre Dame', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'tburgho@usda.gov', 'Early Action', 'California Institute of Technology', 'Submitted', 'Rejected', 'Declined to attend'

  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'Cornell University', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'Dartmouth College', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'Rice University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'Harvard University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'University of Michigan - Ann Arbor', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'California Institute of Technology', 'Submitted', 'Accepted', 'Decided to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'University of Chicago', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Early Action', 'Northwestern University', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Early Decision', 'Columbia University in the City of New York', 'Submitted', 'Accepted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'mfarrinx@si.edu', 'Regular Decision', 'Emory University', 'Submitted', 'Rejected', 'Declined to attend'
 
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Regular Decision', 'Duke University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Early Action', 'Cornell University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Regular Decision', 'Harvard University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Regular Decision', 'Yale University', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Regular Decision', 'University of Southern California', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Early Action', 'Johns Hopkins University', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Early Action', 'University of California - Los Angeles', 'Submitted', 'Waitlisted', 'Decided to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Early Action', 'California Institute of Technology', 'Submitted', 'Waitlisted', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Regular Decision', 'Columbia University in the City of New York', 'Submitted', 'Rejected', 'Declined to attend'
  EXEC sp_insert_record_into_college_application 'cstpierre1b@digg.com', 'Early Decision', 'Princeton University', 'Submitted', 'Rejected', 'Declined to attend'
END
GO

-- some examples of what this database can do
-- at a glance, display all admissions results, pending or not

SELECT * FROM CollegeAppDashboard
	ORDER BY Decision, School
GO
-- will need to change rankings into INT in the future so I can do math on them
-- pull up demographic information on students quickly check a large number of college applications for accuracy
EXEC StudentDemographicDashboard
GO
-- pull up demographic information on parents to quickly check a large number of college applications for mistakes
EXEC ParentDashboard
GO

-- access database in R to do some more analysis/create some visuals

