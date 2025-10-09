-- LAB 5

-- Q1. All possible pairs of employees and departments
SELECT e.emp_name, d.dept_name
FROM employees e CROSS JOIN departments d;

-- Q2. All departments and employees (even if no employees)
SELECT e.emp_name, d.dept_name
FROM employees e
RIGHT OUTER JOIN departments d ON e.dept_id = d.dept_id;

-- Q3. Employee names with their manager names
SELECT e.emp_name AS employee, m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Q4. Employees not assigned any project
SELECT e.emp_name
FROM employees e
LEFT JOIN projects p ON e.emp_id = p.emp_id
WHERE p.emp_id IS NULL;

-- Q5. Student names with their enrolled course names
SELECT s.name AS student, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- Q6. All customers with their orders (even if none placed)
SELECT c.customer_name, o.order_id
FROM customers c
LEFT OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- Q7. All departments and employees (even if no employee)
SELECT d.dept_name, e.emp_name
FROM departments d
LEFT OUTER JOIN employees e ON d.dept_id = e.dept_id;

-- Q8. All pairs of teachers and subjects (taught or not)
SELECT t.teacher_name, s.subject_name
FROM teachers t
CROSS JOIN subjects s;

-- Q9. Departments with total employees
SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM departments d
LEFT JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name;

-- Q10. Each student, their course, and their teacher
SELECT s.name AS student, c.course_name, t.teacher_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id;

-- POST-LAB TASKS

-- Q11. Students and teachers where student city = teacher city
SELECT s.name AS student, t.teacher_name, s.city
FROM students s
JOIN teachers t ON s.city = t.city;

-- Q12. Employees and their manager names (include employees without managers)
SELECT e.emp_name AS employee, m.emp_name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id;

-- Q13. Employees who don’t belong to any department
SELECT e.emp_name
FROM employees e
LEFT JOIN departments d ON e.dept_id = d.dept_id
WHERE d.dept_id IS NULL;

-- Q14. Average salary per department where avg > 50,000
SELECT d.dept_name, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING AVG(e.salary) > 50000;

-- Q15. Employees earning more than avg salary in their department
SELECT e.emp_name, e.salary, e.dept_id
FROM employees e
WHERE e.salary > (
  SELECT AVG(salary)
  FROM employees
  WHERE dept_id = e.dept_id
);

-- Q16. Departments where no employee earns less than 30,000
SELECT d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING MIN(e.salary) >= 30000;

-- Q17. Students and their courses where city = 'Lahore'
SELECT s.name AS student, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE s.city = 'Lahore';

-- Q18. Employees with manager + department (hire date between 2020–2023)
SELECT e.emp_name, m.emp_name AS manager, d.dept_name, e.hire_date
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.emp_id
JOIN departments d ON e.dept_id = d.dept_id
WHERE e.hire_date BETWEEN DATE '2020-01-01' AND DATE '2023-01-01';

-- Q19. Students enrolled in courses taught by ‘Sir Ali’
SELECT s.name AS student, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN teachers t ON c.teacher_id = t.teacher_id
WHERE t.teacher_name = 'Sir Ali';

-- Q20. Employees whose manager is from the same department
SELECT e.emp_name, m.emp_name AS manager
FROM employees e
JOIN employees m ON e.manager_id = m.emp_id
WHERE e.dept_id = m.dept_id;

