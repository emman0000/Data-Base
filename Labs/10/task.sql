-- Q1
create table bank_accounts (
  account_no    number,
  holder_name   varchar(50),
  balance       number
);

insert into bank_accounts values (1, 'Account A', 30000);
insert into bank_accounts values (2, 'Account B', 15000);
insert into bank_accounts values (3, 'Account C', 20000);

commit;

update bank_accounts set balance = balance - 5000 where account_no = 1;
update bank_accounts set balance = balance + 5000 where account_no = 2;
update bank_accounts set balance = balance + 2000 where account_no = 3;

rollback;

select * from bank_accounts;

-- Q2
create table inventory (
  item_id    number,
  item_name  varchar(30),
  quantity   number
);

insert into inventory values (1, 'Keyboard', 80);
insert into inventory values (2, 'Monitor', 150);
insert into inventory values (3, 'Desk Lamp', 60);
insert into inventory values (4, 'Webcam', 200);

commit;

update inventory set quantity = quantity - 10 where item_id = 1;
savepoint sp1;
update inventory set quantity = quantity - 20 where item_id = 2;
savepoint sp2;
update inventory set quantity = quantity - 5 where item_id = 3;

rollback to sp1;

commit;

select * from inventory;

-- Q3
create table fees (
  student_id   number,
  name         varchar(30),
  amount_paid  number,
  total_fee    number
);

insert into fees values (1, 'Areeba', 2000, 6000);
insert into fees values (2, 'Emman', 2500, 6000);
insert into fees values (3, 'Amna', 1600, 6000);

commit;

update fees set amount_paid = amount_paid + 500 where student_id = 1;
savepoint halfway;
update fees set amount_paid = amount_paid + 1000 where student_id = 2;

rollback to halfway;

commit;

select * from fees;

-- Q4
create table products (
  product_id    number,
  product_name  varchar2(30),
  stock         number
);

create table orders (
  order_id     number,
  product_id   number,
  quantity     number
);

insert into products values (1, 'Airpods', 70);
insert into products values (2, 'Headphones', 50);
insert into products values (3, 'Charger', 90);

commit;

update products set stock = stock - 5
where product_id = 1;

insert into orders values (1001, 1, 5);

delete from products
where product_id = 2;

rollback;

update products set stock = stock - 5
where product_id = 1;

insert into orders values (1002, 1, 5);

commit;

select * from products;
select * from orders;


-- Q5
create table employees (
  emp_id    number,
  emp_name  varchar(30),
  salary    number
);

insert into employees values (1, 'Areeba', 80000);
insert into employees values (2, 'Emman', 85000);
insert into employees values (3, 'Hamza', 50000);
insert into employees values (4, 'Taha', 100000);
insert into employees values (5, 'Ibrahim', 150000);

commit;

update employees set salary = salary + 2000 where emp_id = 1;
savepoint A;
update employees set salary = salary + 3000 where emp_id = 2;
savepoint B;
update employees set salary = salary + 2500 where emp_id = 3;

rollback to A;

commit;

select * from employees;
