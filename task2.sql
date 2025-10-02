CREATE DATABASE IF NOT EXISTS test;
USE test;


-- Задача 2
CREATE TABLE credit (
    credit_id INT PRIMARY KEY,
    issued_date DATE
);

INSERT INTO credit (credit_id, issued_date) VALUES
(1, '2024-12-12'),
(2, '2025-05-05'),
(3, '2025-03-10'),
(4, '2025-09-01'),
(5, '2024-01-20');

CREATE TABLE credit_calculations (
	credit_id INT,
    calculation_date DATE,
    status ENUM('ACTIVE', 'EXPIRED', 'COMPLETED'),
    PRIMARY KEY (credit_id, calculation_date),
    FOREIGN KEY (credit_id) REFERENCES credit(credit_id) ON DELETE CASCADE
);

INSERT INTO credit_calculations (credit_id, calculation_date, status) VALUES
(1, '2024-12-12', 'ACTIVE'),
(1, '2024-12-13', 'ACTIVE'),
(1, '2024-12-14', 'EXPIRED'),
(1, '2024-12-15', 'COMPLETED'),
(2, '2025-05-05', 'ACTIVE'),
(2, '2025-05-06', 'EXPIRED'),
(2, '2025-05-07', 'EXPIRED'),
(2, '2025-05-08', 'COMPLETED'),
(3, '2025-03-10', 'ACTIVE'),
(4, '2025-09-01', 'ACTIVE'),
(4, '2025-09-02', 'ACTIVE'),
(4, '2025-09-03', 'COMPLETED'),
(5, '2024-01-20', 'ACTIVE'),
(5, '2024-01-21', 'ACTIVE'),
(5, '2024-01-22', 'EXPIRED'),
(5, '2024-01-23', 'ACTIVE'),
(5, '2024-01-24', 'EXPIRED'),
(5, '2024-01-25', 'EXPIRED'),
(5, '2024-01-26', 'COMPLETED');

-- 1. для каждого кредита, выданного в этом году, вывести количество дней, когда он находился в просрочке 
-- (если кредит не имел просрочки, то по таким кредитам выводить значение 0)
SELECT c.credit_id,  SUM(IF(cc.status = 'EXPIRED', 1, 0)) AS days_in_expired
FROM credit c 
LEFT JOIN credit_calculations cc ON c.credit_id = cc.credit_id
WHERE YEAR(c.issued_date) = 2025
GROUP BY c.credit_id;

-- 2. для каждого кредита вывести актуальный статус (с максимальной датой calculation_date)

-- Вариант с оконной функцией
SELECT credit_id, calculation_date, status
FROM (
    SELECT credit_id, calculation_date, status,
    MAX(calculation_date) OVER (PARTITION BY credit_id) AS max_calculation_date
    FROM credit_calculations
) AS temp
WHERE calculation_date =  max_calculation_date;

-- Вариант без оконной функции
SELECT c.credit_id, cc.calculation_date AS max_calculation_date, cc.status
FROM credit c 
INNER JOIN credit_calculations cc ON c.credit_id = cc.credit_id
WHERE cc.calculation_date = (
    SELECT MAX(calculation_date)
    FROM credit_calculations cc2
    WHERE cc2.credit_id = c.credit_id
);

-- 3. разработчик случайно сделал update таблицы credit_calculations таким образом, 
-- что поля credit_id и calculation_date остались корректными, а поле status стало частично пустым (null). 
-- Требуется написать запрос, показывающий количество кредитов,
-- по которым стали пустыми все статусы - вывести количество таких кредитов.
SELECT COUNT(DISTINCT credit_id) AS count_null_credit
FROM (
    SELECT credit_id, SUM(IF(status IS NULL, 1, 0)) AS null_count,
    COUNT(*) AS total_count
    FROM credit_calculations
    GROUP BY credit_id
    HAVING null_count = total_count
) AS temp;
