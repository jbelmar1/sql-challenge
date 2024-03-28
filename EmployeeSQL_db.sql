-- DATA ENGINEERING

-- Departments Table
create table departments (
	dept_no VARCHAR(10) primary key NOT NULL,
	dept_name VARCHAR(50) NOT NULL
);

-- Titles Table
create table titles (
	title_id VARCHAR(10) PRIMARY KEY NOT NULL,
	title VARCHAR(50) NOT NULL
);

-- Employee Table
CREATE TABLE employees (
	emp_no INT PRIMARY KEY NOT NULL,
	emp_title_id VARCHAR(10) NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(40) NOT NULL,
	sex VARCHAR(5) NOT NULL,
	hire_date DATE NOT NULL,
	foreign key (emp_title_id) references titles (title_id)
);

-- Department Employee Table
create table dept_emp (
	emp_no INT NOT NULL,
	dept_no VARCHAR(8) NOT NULL,
    foreign key (emp_no) references employees (emp_no),
    foreign key (dept_no) references departments (dept_no)
);

-- Department Manager Table
create table dept_manager (
	dept_no VARCHAR(10) NOT NULL,
	emp_no INT PRIMARY KEY NOT NULL,
	foreign key (dept_no) references departments (dept_no),
    foreign key (emp_no) references employees (emp_no)
);

-- Salary Table
create table salaries (
	emp_no INT PRIMARY KEY NOT NULL,
	salary INT NOT NULL,
    foreign key (emp_no) references employees (emp_no)
);


-- DATA ANALYSIS

select * from departments;
select * from dept_emp;
select * from dept_manager;
select * from employees;
select * from salaries;
select * from titles;

-- 1. List the employee number, last name, first name, sex, and salary of each employee.
CREATE VIEW employee_info as
SELECT s.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees AS e
INNER JOIN salaries AS s
ON s.emp_no = e.emp_no;

SELECT *
FROM employee_info
limit 10


-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
CREATE VIEW employees_in_1986 as
SELECT emp_no, first_name, last_name, hire_date 
FROM employees 
WHERE hire_date BETWEEN '1/1/1986' AND '12/31/1986';

SELECT *
FROM employees_in_1986
limit 10


-- 3. List the manager of each department along with their department number, 
-- department name, employee number, last name, and first name.
CREATE VIEW manager_info as
SELECT m.dept_no, d.dept_name, m.emp_no, e.last_name, e.first_name
FROM dept_manager AS m
INNER JOIN departments AS d
ON m.dept_no= d.dept_no
INNER JOIN employees AS e
ON m.emp_no = e.emp_no;

SELECT *
FROM manager_info


-- 4. List the department number for each employee along with that employee’s employee number, 
-- last name, first name, and department name.
CREATE VIEW department_info as
SELECT e.emp_no, e.last_name, e.first_name,d.dept_name
FROM employees AS e
LEFT JOIN dept_emp AS d_e
ON e.emp_no = d_e.emp_no
INNER JOIN departments AS d
ON d_e.dept_no = d.dept_no;

SELECT *
FROM department_info
limit 10

-- 5. List first name, last name, and sex of each employee whose first name is Hercules 
-- and whose last name begins with the letter B.
CREATE VIEW Hercules_B as
SELECT e.last_name, e.first_name, e.sex
FROM employees AS e
WHERE (e.first_name = 'Hercules') 
AND (LOWER(e.last_name) LIKE 'b%');

SELECT *
FROM Hercules_B


-- 6. List each employee in the Sales department, including their employee number, 
-- last name, and first name.
CREATE VIEW sales_department as
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS d_e
ON e.emp_no = d_e.emp_no
INNER JOIN departments AS d
ON d_e.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

SELECT *
FROM sales_department
limit 10


-- 7. List each employee in the Sales and Development departments, including their employee
-- number, last name, first name, and department name.
CREATE VIEW sales_and_development as
SELECT e.emp_no, e.last_name, e.first_name, d.dept_name
FROM employees AS e
INNER JOIN dept_emp AS d_e
ON e.emp_no = d_e.emp_no
INNER JOIN departments AS d
ON d_e.dept_no = d.dept_no
WHERE d.dept_name = 'Sales'
OR d.dept_name = 'Development';

SELECT *
FROM sales_and_development
limit 10


-- 8. List the frequency counts, in descending order, of all the employee last names 
-- (that is, how many employees share each last name).
CREATE VIEW frequency_counts as
SELECT last_name,COUNT(last_name) AS Frequency 
FROM employees 
GROUP BY last_name
ORDER BY frequency DESC;

SELECT *
FROM frequency_counts
limit 10
    
