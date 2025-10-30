
-- Create table
CREATE TABLE Students(
    student_id INT PRIMARY KEY,
    student_name VARCHAR2(20),
    h_pay INT,
    y_pay INT
);

-- Create student logs table for deleted records
CREATE TABLE student_logs(
    log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    student_id INT,
    student_name VARCHAR2(20),
    h_pay INT,
    y_pay INT,
    deleted_date DATE,
    deleted_by VARCHAR2(50)
);

-- View table
SELECT * FROM Students;

-- Insert data (FIXED: table name should be Students, not students)
INSERT INTO Students (student_id, student_name, h_pay) VALUES(3,'sana', NULL);

-- Enable server output
SET SERVEROUTPUT ON;

-- Fixed INSERT trigger
CREATE OR REPLACE TRIGGER insert_data
BEFORE INSERT ON Students 
FOR EACH ROW
BEGIN
    IF :NEW.h_pay IS NULL THEN 
        :NEW.h_pay := 250;
    END IF;
END;
/

-- UPDATE trigger (FIXED: table name should be Students)
CREATE OR REPLACE TRIGGER update_Salary
BEFORE UPDATE ON Students
FOR EACH ROW 
BEGIN
    :NEW.y_pay := :NEW.h_pay * 1920;
END;
/ 

-- Test the update (FIXED: table name should be Students)
UPDATE Students SET h_pay = 200 WHERE student_id = 3;

-- Verify the results
SELECT * FROM Students;

-- FIXED: Prevent delete trigger (removed semicolon and fixed syntax)
CREATE OR REPLACE TRIGGER prevent_admin
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
    IF :OLD.student_name = 'admin' THEN  -- REMOVED semicolon after 'admin'
        RAISE_APPLICATION_ERROR(-20000, 'you cannot delete admin record');
    END IF;
END;
/

-- Insert an admin record to test
INSERT INTO Students (student_id, student_name, h_pay) VALUES(1, 'admin', 100);

-- Test prevent delete (this should fail)
DELETE FROM Students WHERE student_name = 'admin';

-- Trigger to log deleted students into student_logs
CREATE OR REPLACE TRIGGER log_deleted_students
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
    -- Insert deleted record into student_logs table
    INSERT INTO student_logs (student_id, student_name, h_pay, y_pay, deleted_date, deleted_by)
    VALUES (:OLD.student_id, :OLD.student_name, :OLD.h_pay, :OLD.y_pay, SYSDATE, USER);
END;
/

-- Test the delete logging (insert a test record first)
INSERT INTO Students (student_id, student_name, h_pay) VALUES(2, 'test_user', 150);

-- Delete the test record (this will be logged in student_logs)
DELETE FROM Students WHERE student_id = 2;

-- Check what was logged
SELECT * FROM student_logs;

-- DDL triggers - Prevent table from being dropped
CREATE OR REPLACE TRIGGER prevent_tables
BEFORE DROP ON DATABASE
BEGIN 
    RAISE_APPLICATION_ERROR(-20001, 'Cannot drop object');
END;
/

-- FIXED: schema_audit table creation (removed incomplete line)
CREATE TABLE schema_audit (
    ddl_date DATE,
    ddl_user VARCHAR2(15),
    object_created VARCHAR2(15),
    object_name VARCHAR2(15),
    ddl_operation VARCHAR2(15)
);

SELECT * FROM schema_audit;

-- FIXED: DDL audit trigger (corrected syntax errors)
CREATE OR REPLACE TRIGGER hr_audit_tr
AFTER DDL ON SCHEMA
BEGIN
    INSERT INTO schema_audit VALUES (
        SYSDATE,
        SYS_CONTEXT('USERENV', 'CURRENT_USER'),  -- FIXED: sys_cotext to SYS_CONTEXT
        ORA_DICT_OBJ_TYPE,
        ORA_DICT_OBJ_NAME,
        ORA_SYSEVENT
    );
END;
/

-- Test DDL trigger
CREATE TABLE abc(
    id INT PRIMARY KEY,
    name VARCHAR2(20)
);

INSERT INTO abc VALUES (1, 'test');  -- You need to complete VALUES clause

-- Check DDL audit
SELECT * FROM schema_audit;

-- Prevent delete trigger
CREATE OR REPLACE TRIGGER prevent_admin
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
    IF :OLD.student_name = 'admin' THEN
        RAISE_APPLICATION_ERROR(-20000, 'you cannot delete admin record');
    END IF;
END;
/

-- Insert an admin record to test
INSERT INTO Students (student_id, student_name, h_pay) VALUES(1, 'admin', 100);

-- Test prevent delete (this should fail)
DELETE FROM Students WHERE student_name = 'admin';

-- Trigger to log deleted students into student_logs
CREATE OR REPLACE TRIGGER log_deleted_students
BEFORE DELETE ON Students
FOR EACH ROW
BEGIN
    -- Insert deleted record into student_logs table
    INSERT INTO student_logs (student_id, student_name, h_pay, y_pay, deleted_date, deleted_by)
    VALUES (:OLD.student_id, :OLD.student_name, :OLD.h_pay, :OLD.y_pay, SYSDATE, USER);
END;
/

-- Test the delete logging (insert a test record first)
INSERT INTO Students (student_id, student_name, h_pay) VALUES(2, 'test_user', 150);

-- Delete the test record (this will be logged in student_logs)
DELETE FROM Students WHERE student_id = 2;

-- Check what was logged
SELECT * FROM student_logs;

-- DDL triggers - Prevent ONLY Students table from being dropped
CREATE OR REPLACE TRIGGER prevent_students_drop
BEFORE DROP ON DATABASE
BEGIN 
    -- Only prevent dropping of STUDENTS table
    IF ORA_DICT_OBJ_NAME = 'STUDENTS' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot drop STUDENTS table! This table is protected.');
    END IF;
END;
/

-- FIXED: schema_audit table creation
CREATE TABLE schema_audit (
    ddl_date DATE,
    ddl_user VARCHAR2(15),
    object_created VARCHAR2(15),
    object_name VARCHAR2(15),
    ddl_operation VARCHAR2(15)
);

SELECT * FROM schema_audit;

-- DDL audit trigger
CREATE OR REPLACE TRIGGER hr_audit_tr
AFTER DDL ON SCHEMA
BEGIN
    INSERT INTO schema_audit VALUES (
        SYSDATE,
        SYS_CONTEXT('USERENV', 'CURRENT_USER'),
        ORA_DICT_OBJ_TYPE,
        ORA_DICT_OBJ_NAME,
        ORA_SYSEVENT
    );
END;
/

-- Test DDL trigger
CREATE TABLE abc(
    id INT PRIMARY KEY,
    name VARCHAR2(20)
);

INSERT INTO abc VALUES (1, 'test');

-- Check DDL audit
SELECT * FROM schema_audit;

-- TEST THE DROP PROTECTION:

-- Try to drop Students table (this should FAIL)
DROP TABLE Students;

-- Try to drop other tables (this should WORK since we only protect Students)
DROP TABLE abc;

-- Now disable the trigger to allow Students table to be dropped
ALTER TRIGGER prevent_students_drop DISABLE;

-- Now you can drop Students table (this will WORK after disabling trigger)
-- DROP TABLE Students;

-- To enable it again later:
-- ALTER TRIGGER prevent_students_drop ENABLE;
drop table Students cascade constraints;
