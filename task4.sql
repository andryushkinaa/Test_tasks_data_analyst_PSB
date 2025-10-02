CREATE DATABASE IF NOT EXISTS test;
USE test;


-- Задача 4
CREATE TABLE transactions (
    id INT PRIMARY KEY,
    transaction_date DATE,
    client_id INT,
    currency VARCHAR(10),
    amount DECIMAL(15, 2)
);

INSERT INTO transactions (id, transaction_date, client_id, currency, amount) VALUES
(1, '2022-05-23', 33, 'EURO', 259.00),
(2, '2022-05-24', 34, 'USD', 300.00),
(3, '2022-05-24', 34, 'RUB', 5000.00),
(4, '2022-05-25', 35, 'USD', 150.00),
(5, '2022-05-25', 33, 'EURO', 100.00),
(6, '2022-05-26', 36, 'RUB', 3000.00), 
(7, '2022-05-26', 37, 'USD', 200.00), 
(8, '2022-05-27', 34, 'EURO', 50.00);  

CREATE TABLE currency (
    id INT PRIMARY KEY,
    currency_date DATE,
    currency VARCHAR(10),
    value DECIMAL(10, 4)
);

INSERT INTO currency (id, currency_date, currency, value) VALUES
(1, '2022-05-23', 'EURO', 69.0000),
(2, '2022-05-23', 'USD', 60.0000),
(3, '2022-05-24', 'EURO', 70.0000),
(4, '2022-05-24', 'USD', 59.5000),
(5, '2022-05-24', 'EURO', 70.0000),
(6, '2022-05-24', 'USD', 59.5000),
(9, '2022-05-27', 'EURO', 72.0000),
(10, '2022-05-27', 'USD', 62.0000);

-- 1. вычислить стоимость всех покупок для каждого клиента, результат посчитать в рублях
-- (клиент 1, сумма всех покупок),
-- (клиент 2, сумма всех покупок)
SELECT t.client_id,
    SUM(
        CASE 
            WHEN t.currency = 'RUB' THEN t.amount
            ELSE t.amount * c.value
        END
    ) AS total_rub
FROM transactions t
LEFT JOIN currency c ON t.transaction_date = c.currency_date AND t.currency = c.currency
GROUP BY t.client_id
ORDER BY t.client_id;

-- 2. вычислить стоимость всех покупок в рублях для каждого клиента в ситуации, когда курс ЦБ есть не на все даты 
-- (в таблице валют отсутствует строка с датой). 
-- На праздники и выходные устанавливается курс ЦБ в крайний рабочий день перед ними.
-- (клиент 1, сумма всех покупок),
-- (клиент 2, сумма всех покупок)
SELECT client_id,
    SUM(
        CASE 
            WHEN currency = 'RUB' THEN amount
            ELSE amount * (
                SELECT value 
                FROM currency c 
                WHERE c.currency = t.currency AND c.currency_date <= t.transaction_date 
                ORDER BY c.currency_date DESC 
                LIMIT 1
            )
        END
    ) as total_rub
FROM transactions t
GROUP BY client_id
ORDER BY client_id; 

