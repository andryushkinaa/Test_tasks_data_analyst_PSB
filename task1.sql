CREATE DATABASE IF NOT EXISTS test;
USE test;


-- Задача 1
CREATE TABLE purchases (
    client_id INT,
    amount INT,
    date DATE
);

INSERT INTO purchases (client_id, amount, date) VALUES
(1, 200, '2023-01-01'),
(1, 50, '2023-01-09'),
(2, 20, '2023-01-01'),
(3, 40, '2023-01-01'),
(3, 60, '2023-02-01'),
(1, 600, '2023-02-01'),
(6, 550, '2023-01-15'),
(4, 810, '2023-02-18'),
(5, 620, '2023-01-10'),
(5, 1500, '2023-02-05');

-- 1. количество клиентов магазина
SELECT COUNT(DISTINCT client_id) AS count_of_clients FROM purchases;

-- 2. за январь 2023 года для каждого клиента сумму всех его покупок, среднюю сумму покупки, максимальный размер покупки (самую дорогую)
SELECT client_id, SUM(amount) AS amount_of_purchases, AVG(amount) AS avg_amount, MAX(amount) AS max_amount
FROM purchases
WHERE date BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY client_id
ORDER BY client_id;

-- 3. клиентов, которые совершили больше 2 покупок и количество совершенных покупок. 
-- Результат необходимо отразить по убыванию количества совершенных покупок
SELECT client_id, COUNT(*) AS count_of_purchases
FROM purchases
GROUP BY client_id
HAVING COUNT(*) >= 2
ORDER BY count_of_purchases DESC;

