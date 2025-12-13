------------------------------------------------------------
-- TCL FULL MASTER SCRIPT
-- Covers: COMMIT, ROLLBACK, SAVEPOINT, AUTOCOMMIT, LOCKING
------------------------------------------------------------

SET SERVEROUTPUT ON;

------------------------------------------------------------
-- 1. CREATE TEST TABLE (DDL auto-commits)
------------------------------------------------------------
DROP TABLE books PURGE;
CREATE TABLE books (
    book_id NUMBER PRIMARY KEY,
    title   VARCHAR2(50)
);

-- DDL auto-commits here.
------------------------------------------------------------

------------------------------------------------------------
-- 2. BEGIN Transaction #1 (manual transaction)
------------------------------------------------------------

-- Insert one permanent row
INSERT INTO books VALUES (1, 'TOC');
COMMIT;   -- commit #1

dbms_output.put_line('After COMMIT #1: Inserted book_id 1');


------------------------------------------------------------
-- 3. WORKING WITH SAVEPOINTS
------------------------------------------------------------

SAVEPOINT sp_first;

INSERT INTO books VALUES (2, 'Algo');
INSERT INTO books VALUES (3, 'DAA');

SAVEPOINT sp_second;

INSERT INTO books VALUES (4, 'OS');
INSERT INTO books VALUES (5, 'Networks');


dbms_output.put_line('Inserted 2,3 under SP_FIRST and 4,5 under SP_SECOND');


------------------------------------------------------------
-- 4. ROLLBACK TO SAVEPOINT
------------------------------------------------------------

ROLLBACK TO sp_first;

dbms_output.put_line('Rollback to SP_FIRST -> Only book_id 1 remains committed');


------------------------------------------------------------
-- Check table data
------------------------------------------------------------
dbms_output.put_line('Current BOOKS data after rollback to SP_FIRST:');
FOR r IN (SELECT * FROM books ORDER BY book_id) LOOP
    dbms_output.put_line(r.book_id || '  ' || r.title);
END LOOP;




------------------------------------------------------------
-- 5. START Transaction #2 with SET TRANSACTION
------------------------------------------------------------

SET TRANSACTION NAME 'book_update_tx';

INSERT INTO books VALUES (2, 'SQL');
INSERT INTO books VALUES (3, 'PLSQL');

SAVEPOINT spA;

INSERT INTO books VALUES (4, 'AI');
INSERT INTO books VALUES (5, 'ML');

SAVEPOINT spB;

-- Undo ONLY the second set:
ROLLBACK TO spA;

dbms_output.put_line('After ROLLBACK TO spA -> rows 4,5 undone');


-- Now commit this transaction:
COMMIT;

dbms_output.put_line('Transaction book_update_tx committed.');




------------------------------------------------------------
-- 6. AUTOCOMMIT Demonstration
------------------------------------------------------------

SET AUTOCOMMIT ON;

INSERT INTO books VALUES (6, 'Autocommit Book');
-- Auto-committed immediately

SET AUTOCOMMIT OFF;
dbms_output.put_line('Inserted book 6 with AUTOCOMMIT ON (committed automatically).');




------------------------------------------------------------
-- 7. LOCKING DEMONSTRATION (Simulating two worksheets)
------------------------------------------------------------

-- Transaction that holds a lock:
UPDATE books SET title='Locked Row' WHERE book_id = 2;

dbms_output.put_line('Row 2 is now locked. Open another SQL worksheet and try:');
dbms_output.put_line('  UPDATE books SET title=''TryLock'' WHERE book_id = 2;');
dbms_output.put_line('It will HANG until COMMIT or ROLLBACK here.');

-- We RELEASE the lock:
COMMIT;

dbms_output.put_line('Lock on row 2 released.');




------------------------------------------------------------
-- 8. REAL-LIFE TRANSACTION (Customer places order)
------------------------------------------------------------

-- Setup tables
DROP TABLE customer PURGE;
DROP TABLE orders PURGE;

CREATE TABLE customer (
    customer_id NUMBER PRIMARY KEY,
    name        VARCHAR2(50),
    balance     NUMBER
);

CREATE TABLE orders (
    order_id    NUMBER PRIMARY KEY,
    customer_id NUMBER,
    amount      NUMBER,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- Start transaction
SET TRANSACTION NAME 'customer_order_tx';

INSERT INTO customer VALUES (10, 'Ali', 10000);
SAVEPOINT customer_added;

INSERT INTO orders VALUES (100, 10, 3000);
UPDATE customer SET balance = balance - 3000 WHERE customer_id = 10;

SAVEPOINT order_added;

-- Check for insufficient balance:
DECLARE
  bal NUMBER;
BEGIN
  SELECT balance INTO bal FROM customer WHERE customer_id = 10;

  IF bal < 0 THEN
    dbms_output.put_line('Insufficient balance! Rolling back order.');
    ROLLBACK TO customer_added;
  ELSE
    dbms_output.put_line('Order OK. Committing transaction...');
    COMMIT;
  END IF;
END;
/

------------------------------------------------------------
-- END OF TCL MASTER SCRIPT
------------------------------------------------------------
