

--1. BEFORE INSERT  Names to UPPERCASE**

CREATE TRIGGER trg_students_upper
BEFORE INSERT ON STUDENTS
FOR EACH ROW
BEGIN
    SET NEW.student_name = UPPER(NEW.student_name);
END$$



--2. Prevent delete on weekends**




CREATE TRIGGER trg_emp_no_weekend_delete
BEFORE DELETE ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF DAYOFWEEK(NOW()) = 1 OR DAYOFWEEK(NOW()) = 7 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete on weekends';
    END IF;
END




*(1 = Sunday, 7 = Saturday)*

---

--3. Log UPDATEs of salary into LOG_SALARY_AUDIT**


-- audit table must exist
-- LOG_SALARY_AUDIT(id, emp_id, old_salary, new_salary, changed_at)



CREATE TRIGGER trg_salary_update_log
AFTER UPDATE ON EMPLOYEES
FOR EACH ROW
BEGIN
    IF OLD.salary <> NEW.salary THEN
        INSERT INTO LOG_SALARY_AUDIT(emp_id, old_salary, new_salary, changed_at)
        VALUES (OLD.emp_id, OLD.salary, NEW.salary, NOW());
    END IF;
END$$




--4. Prevent negative PRICE in PRODUCTS**



CREATE TRIGGER trg_product_price_check
BEFORE UPDATE ON PRODUCTS
FOR EACH ROW
BEGIN
    IF NEW.price < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Price cannot be negative';
    END IF;
END


---

--5. Insert username + timestamp on COURSES insert**


-- assuming: COURSES(username, inserted_at, ...)


CREATE TRIGGER trg_courses_insert_user
BEFORE INSERT ON COURSES
FOR EACH ROW
BEGIN
    SET NEW.username = USER();
    SET NEW.inserted_at = NOW();
END

---

--6. Default department_id if NULL in EMP**


CREATE TRIGGER trg_emp_default_dept
BEFORE INSERT ON EMP
FOR EACH ROW
BEGIN
    IF NEW.department_id IS NULL THEN
        SET NEW.department_id = 100;   -- your default dept
    END IF;
END

---

--7. Compound trigger for SALES (MySQL does NOT support Oracle compound triggers)**


Assume table:
`SALES(id, price, qty, total)`
`total = price * qty`

### BEFORE INSERT → compute total


CREATE TRIGGER trg_sales_before
BEFORE INSERT ON SALES
FOR EACH ROW
BEGIN
    SET NEW.total = NEW.price * NEW.qty;
END

### AFTER INSERT → store total into audit table 


CREATE TABLE SALES_AUDIT (
    sale_id INT,
    total DECIMAL(10,2),
    logged_at DATETIME
);


CREATE TRIGGER trg_sales_after
AFTER INSERT ON SALES
FOR EACH ROW
BEGIN
    INSERT INTO SALES_AUDIT(sale_id, total, logged_at)
    VALUES (NEW.id, NEW.total, NOW());
END
--8. DDL Trigger (MySQL does NOT support schema-level DDL triggers)

l
CREATE TABLE SCHEMA_DDL_LOG (
    event_time TIMESTAMP,
    username   VARCHAR2(50),
    operation  VARCHAR2(50),
    obj_name   VARCHAR2(100)
);

CREATE OR REPLACE TRIGGER trg_schema_ddl_log
AFTER CREATE OR DROP ON SCHEMA
BEGIN
    INSERT INTO SCHEMA_DDL_LOG
    VALUES (SYSTIMESTAMP, USER, ORA_SYSEVENT, ORA_DICT_OBJ_NAME);
END;
/

---

--9. Prevent UPDATE if order_status = 'SHIPPED'**


CREATE TRIGGER trg_no_update_shipped
BEFORE UPDATE ON ORDERS
FOR EACH ROW
BEGIN
    IF OLD.order_status = 'SHIPPED' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot update shipped orders';
    END IF;
END



CREATE TABLE LOGIN_AUDIT (
    username VARCHAR2(30),
    login_time TIMESTAMP
);

CREATE OR REPLACE TRIGGER trg_logon_audit
AFTER LOGON ON DATABASE
BEGIN
    INSERT INTO LOGIN_AUDIT
    VALUES (USER, SYSTIMESTAMP);
END;
/


