CREATE DATABASE IF NOT EXISTS test;
USE test;


-- Задача 3
CREATE TABLE employee (
	id INT,
	hire_date DATE,
	chief_id INT NULL,
	salary DECIMAL(10, 2)
);

INSERT INTO employee (id, hire_date, chief_id, salary) VALUES
(1, '2020-01-15', NULL, 350000.00),
(2, '2020-02-10', 1, 40000.00),
(3, '2020-03-05', 2, 130000.00),
(4, '2020-04-12', 2, 280000.00),
(5, '2020-05-20', 3, 150000.00),
(6, '2021-01-10', 1, 200000.00),
(7, '2021-02-15', 6, 62000.00),
(8, '2021-03-20', NULL, 300000.00),
(9, '2021-04-25', 8, 100000.00),
(10, '2021-05-30', 9, 270000.00),
(2, '2020-02-10', 1, 40000.00),
(6, '2021-01-10', 1, 200000.00); 

-- 1. посчитать количество сотрудников, которые работают в компании дольше, чем их непосредственные начальники
SELECT COUNT(*) AS count_of_employees
FROM employee e1
INNER JOIN employee e2 ON e1.chief_id = e2.id
WHERE e1.hire_date < e2.hire_date;

-- 2. проверить, есть ли дублирующиеся строки по сотруднику (id) в таблице employee – вывести пример такого сотрудника
SELECT id AS id_duplicate
FROM employee
GROUP BY id
HAVING COUNT(*) > 1;