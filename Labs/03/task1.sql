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


--Post Lab Tasks

--Q11
ALTER TABLE employees
ADD CONSTRAINT unique_bonus UNIQUE (bonus);
-- Test with two records 
INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus)
VALUES (201, 'Muhammad Sabeeh', 50000, 1, 1500);
--This one will fail because of constraint
INSERT INTO employees (emp_id, full_name, salary, dept_id, bonus)
VALUES (202, 'Aeeba Hasnain', 45000, 2, 1500); -- (same bonus)

--Q12
ALTER TABLE employees DROP CONSTRAINT check_age;
ALTER TABLE employees ADD dob DATE;

--Q13
INSERT INTO employees (emp_id, full_name, monthly_salary, dept_id, dob, bonus)
VALUES (205, 'Young Employee', 30000, 1, ADD_MONTHS(SYSDATE, -12*17), 1000);

--Q14
-- Find the foreign key constraint name
SELECT constraint_name FROM user_constraints 
WHERE table_name = 'EMPLOYEES' AND constraint_type = 'R';
ALTER TABLE employees DROP CONSTRAINT FK_EMP_DEPT;-- Drop the foreign key constraint
-- Insert employee with non-existing department
INSERT INTO employees (emp_id, full_name, monthly_salary, dept_id, bonus)
VALUES (206, 'Invalid Dept Employee', 40000, 999, 1200);
ALTER TABLE employees
ADD CONSTRAINT fk_emp_dept FOREIGN KEY (dept_id) REFERENCES departments(dept_id);

--Q15
ALTER TABLE employees DROP COLUMN age;
ALTER TABLE employees DROP COLUMN city;

--Q16
SELECT d.dept_id, d.dept_name, 
       e.emp_id, e.full_name, e.monthly_salary, e.bonus
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
ORDER BY d.dept_id, e.emp_id;

--Q17
ALTER TABLE employees RENAME COLUMN salary TO monthly_salary;

-- Verify the column was renamed
DESCRIBE employees;
--Q18
SELECT d.dept_id, d.dept_name
FROM departments d
WHERE NOT EXISTS (
    SELECT 1 FROM employees e WHERE e.dept_id = d.dept_id
);
--Q19
TRUNCATE TABLE employees;

--Q20
SELECT * FROM (
    SELECT d.dept_id, d.dept_name, COUNT(e.emp_id) as employee_count
    FROM departments d
    LEFT JOIN employees e ON d.dept_id = e.dept_id
    GROUP BY d.dept_id, d.dept_name
    ORDER BY employee_count DESC
) WHERE ROWNUM = 1;
