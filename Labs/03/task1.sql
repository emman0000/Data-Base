--Q1

CREATE TABLE departments(
    dept_id NUMBER PRIMARY KEY,
    dept_name VARCHAR2(40)
);
CREATE TABLE employees (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(20) NOT NULL,
    salary NUMBER(10,2) CHECK (salary > 20000),
    dept_id NUMBER
);

--Q2
ALTER TABLE employees
RENAME COLUMN emp_name TO full_name;
DESCRIBE employees; --Checking table to see if name is altered


--Q3
SELECT constraint_name, constraint_type, search_condition 
FROM user_constraints 
WHERE table_name = 'EMPLOYEES' AND constraint_type = 'C';
ALTER TABLE employees 
DROP CONSTRAINT SYS_C007029; -- name of the CHECK constraint
INSERT INTO departments (dept_id, dept_name) VALUES (1, 'IT');
INSERT INTO employees (emp_id, full_name, salary, dept_id)
VALUES (1001, 'Test Employee', 4000, 10);
-- Verify
SELECT * FROM departments;
SELECT * FROM employees;

--Q4
ALTER TABLE departments
ADD CONSTRAINT dept_name_unique UNIQUE (dept_name);
--3 new records
INSERT INTO departments(dept_id, dept_name) VALUES (2, 'HR');
INSERT INTO departments(dept_id, dept_name) VALUES (3, 'Finance');
INSERT INTO departments(dept_id, dept_name) VALUES (4, 'Marketing');
-- Verify the unqiue constraint works
SELECT * FROM departments;
-- UNIQUE constraint checked this line fails if run 
--INSERT INTO departments (dept_id, dept_name) VALUES (1, 'IT');

--Q5
-- Constraint conditon on table
ALTER TABLE employees
ADD constraint fk_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
-- Using this query to check if tables were created:
SELECT table_name FROM user_tables WHERE table_name IN ('DEPARTMENTS', 'EMPLOYEES');
DESCRIBE employees;

--Q6
ALTER TABLE employees ADD bonus NUMBER (6,2) DEFAULT 1000;

--Q7
ALTER TABLE employees ADD city VARCHAR(20) DEFAULT 'Karachi';
ALTER TABLE employees ADD age NUMBER CHECK (age > 18);

--Q8
DELETE FROM employees WHERE emp_id  IN (1,3);

--Q9
ALTER TABLE employees MODIFY full_name VARCHAR(20);
ALTER TABLE employees MODIFY city VARCHAR(20);

--Q10
ALTER TABLE employees ADD email VARCHAR(50) UNIQUE; 

--CHECK 
DESCRIBE employees;
