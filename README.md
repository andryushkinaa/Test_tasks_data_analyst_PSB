# Тестовые задания на вакансию Стажера Аналитика данных в ПСБ

Задание выполнено Андрюшкиной Дарьей

Запросы выполнены для СУБД MYSQL

Далее приведены условия задач и их решение с объяснениями 

Тестовое задание
Примечание:

1. Можно использовать любой диалект SQL с его указанием при решении;
2. Краткость и форматирование кода приветствуются.

## Задача 1

Есть таблица Table с покупками клиентов, где 
CLIENT_ID –  это идентификатор клиента,
AMOUNT – сумма совершенной покупки,
DATE – дата совершенной транзакции.

<img width="336" height="219" alt="image" src="https://github.com/user-attachments/assets/cfd85ad9-3ced-402e-be44-5c6cb91ea0c8" />

Необходимо написать запросы, которые покажут:
1.	количество клиентов магазина,
2.	за январь 2023 года для каждого клиента сумму всех его покупок, среднюю сумму покупки, максимальный размер покупки (самую дорогую),
3.	клиентов, которые совершили больше 2 покупок и количество совершенных покупок. Результат необходимо отразить по убыванию количества совершенных покупок.

## Решение задачи 1
Предварительно в базе данных test была создана таблица purchases с несколькими записями:

<img width="416" height="261" alt="image" src="https://github.com/user-attachments/assets/36cd0c50-fd7c-45eb-a98b-7b0b0e399f13" />

```cpp
CREATE DATABASE IF NOT EXISTS test;
USE test;

CREATE TABLE purchases (
    client_id INT,
    amount INT,
    date DATE
);
```

-- 1. количество клиентов магазина
```sql
SELECT COUNT(DISTINCT client_id) AS count_of_clients FROM purchases;
```
<img width="260" height="65" alt="image" src="https://github.com/user-attachments/assets/c39624cb-b62e-4ced-a077-4eb6f7c49566" />

-- 2. за январь 2023 года для каждого клиента сумму всех его покупок, среднюю сумму покупки, максимальный размер покупки (самую дорогую)
```sql
SELECT client_id, SUM(amount) AS amount_of_purchases, AVG(amount) AS avg_amount, MAX(amount) AS max_amount
FROM purchases
WHERE date BETWEEN '2023-01-01' AND '2023-01-31'
GROUP BY client_id
ORDER BY client_id;
```
<img width="765" height="163" alt="image" src="https://github.com/user-attachments/assets/519cb0cb-6cf6-42e1-9b8e-9c6f098e12d2" />

-- 3. клиентов, которые совершили больше 2 покупок и количество совершенных покупок. 
-- Результат необходимо отразить по убыванию количества совершенных покупок
```sql
SELECT client_id, COUNT(*) AS count_of_purchases
FROM purchases
GROUP BY client_id
HAVING COUNT(*) >= 2
ORDER BY count_of_purchases DESC;
```
<img width="453" height="125" alt="image" src="https://github.com/user-attachments/assets/9f93cce4-9425-4c45-95e9-0c5d0d0fbc45" />


## Задача 2

Есть две таблицы:
•	credit (credit_id, issued_date) – таблица со всеми выданными кредитами,
•	credit_calculations (credit_id, calculation_date, status) – таблица с описанием каждого дня жизни кредита. Поле status может принимать значения: ACTIVE (займ активен), EXPIRED (займ в просрочке), COMPLETED (займ закрылся, после этого записи в таблице credit_calculations по данному кредиту прекращаются).
Необходимо:
1.	для каждого кредита, выданного в этом году, вывести количество дней, когда он находился в просрочке (если кредит не имел просрочки, то по таким кредитам выводить значение 0),
2.	для каждого кредита вывести актуальный статус (с максимальной датой calculation_date). Здесь хотелось бы увидеть 2 варианта решения – с использованием оконной функции и без неё,
3.	разработчик случайно сделал update таблицы credit_calculations таким образом, что поля credit_id и calculation_date остались корректными, а поле status стало частично пустым (null). Требуется написать запрос, показывающий количество кредитов, по которым стали пустыми все статусы - вывести количество таких кредитов.

## Решение задачи 2
Таблица credit (credit_id, issued_date):

<img width="465" height="203" alt="image" src="https://github.com/user-attachments/assets/b55e43ec-e0ca-4566-b88c-2aa704c3b48a" />

```sql
CREATE DATABASE IF NOT EXISTS test;
USE test;

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
```
Таблица credit_calculations (credit_id, calculation_date, status):

<img width="538" height="503" alt="image" src="https://github.com/user-attachments/assets/defc5478-14a1-46b1-8435-b698f667877f" />

```sql
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
```

-- 1. для каждого кредита, выданного в этом году, вывести количество дней, когда он находился в просрочке 
-- (если кредит не имел просрочки, то по таким кредитам выводить значение 0)
```sql
SELECT c.credit_id,  SUM(IF(cc.status = 'EXPIRED', 1, 0)) AS days_in_expired
FROM credit c 
LEFT JOIN credit_calculations cc ON c.credit_id = cc.credit_id
WHERE YEAR(c.issued_date) = 2025
GROUP BY c.credit_id;
```
<img width="494" height="148" alt="image" src="https://github.com/user-attachments/assets/12b984bc-ac78-44d6-a64a-62fbc0903ff5" />

-- 2. для каждого кредита вывести актуальный статус (с максимальной датой calculation_date)
```sql
-- Вариант с оконной функцией
SELECT credit_id, calculation_date, status
FROM (
    SELECT credit_id, calculation_date, status,
    MAX(calculation_date) OVER (PARTITION BY credit_id) AS max_calculation_date
    FROM credit_calculations
) AS temp
WHERE calculation_date =  max_calculation_date;
```
```sql
-- Вариант без оконной функции
SELECT c.credit_id, cc.calculation_date AS max_calculation_date, cc.status
FROM credit c 
INNER JOIN credit_calculations cc ON c.credit_id = cc.credit_id
WHERE cc.calculation_date = (
    SELECT MAX(calculation_date)
    FROM credit_calculations cc2
    WHERE cc2.credit_id = c.credit_id
);
```
<img width="673" height="192" alt="image" src="https://github.com/user-attachments/assets/29e19d28-46e5-4601-8eca-214936383210" />

-- 3. разработчик случайно сделал update таблицы credit_calculations таким образом, 
-- что поля credit_id и calculation_date остались корректными, а поле status стало частично пустым (null). 
-- Требуется написать запрос, показывающий количество кредитов,
-- по которым стали пустыми все статусы - вывести количество таких кредитов.
```sql
SELECT COUNT(DISTINCT credit_id) AS count_null_credit
FROM (
    SELECT credit_id, SUM(IF(status IS NULL, 1, 0)) AS null_count,
    COUNT(*) AS total_count
    FROM credit_calculations
    GROUP BY credit_id
    HAVING null_count = total_count
) AS temp;
```
<img width="321" height="81" alt="image" src="https://github.com/user-attachments/assets/b9a2a8ea-ff02-4acc-a05b-080481581db2" />

## Задача 3

Есть таблица employee (id, hire_date, chief_id, salary) со списком id сотрудников, их датой приёма на работу, id начальника (такой же сотрудник в таблице) и зарплатой.
Необходимо:
1.	посчитать количество сотрудников, которые работают в компании дольше, чем их непосредственные начальники,
2.	проверить, есть ли дублирующиеся строки по сотруднику (id) в таблице employee – вывести пример такого сотрудника.

## Решение задачи 3
Таблица employee (id, hire_date, chief_id, salary):

<img width="728" height="429" alt="image" src="https://github.com/user-attachments/assets/2e27dace-5532-498a-9c91-806038729f83" />


```sql
CREATE DATABASE IF NOT EXISTS test;
USE test;


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
```
-- 1. посчитать количество сотрудников, которые работают в компании дольше, чем их непосредственные начальники
```sql
SELECT COUNT(*) AS count_of_employees
FROM employee e1
INNER JOIN employee e2 ON e1.chief_id = e2.id
WHERE e1.hire_date < e2.hire_date;
```
<img width="351" height="81" alt="image" src="https://github.com/user-attachments/assets/1b565d20-73ea-46bd-8bb6-c037dedd3f0e" />

-- 2. проверить, есть ли дублирующиеся строки по сотруднику (id) в таблице employee – вывести пример такого сотрудника
```sql
SELECT id AS id_duplicate
FROM employee
GROUP BY id
HAVING COUNT(*) > 1;
```
<img width="296" height="110" alt="image" src="https://github.com/user-attachments/assets/7ef5598d-419c-43f0-b0bf-30038923af46" />

## Задача 4

В банке есть 2 таблицы:
•	транзакции клиентов (могут быть как в рублях, так и в евро и долларах):  
transactions (id, transaction_date, client_id, currency, amount), пример: 
(1, '2022-05-23', 33, 'EURO', 259), 
(2, '2022-05-24', 34, 'USD', 300),
(3, '2022-05-24', 34, 'RUB', 5000),
•	ежедневный курс ЦБ евро и доллара к рублю: currency (id, currency_date, currency, value), пример: 
(1, '2022-05-23', 'EURO', 69.0),
(2, '2022-05-23', 'USD', 60),
(3, '2022-05-24', ' EURO ', 70),
(4, '2022-05-24', 'USD', 59.5).
Необходимо:
1.	вычислить стоимость всех покупок для каждого клиента, результат посчитать в рублях
(клиент 1, сумма всех покупок),
(клиент 2, сумма всех покупок)
2.	вычислить стоимость всех покупок в рублях для каждого клиента в ситуации, когда курс ЦБ есть не на все даты (в таблице валют отсутствует строка с датой). На праздники и выходные устанавливается курс ЦБ в крайний рабочий день перед ними.
(клиент 1, сумма всех покупок),
(клиент 2, сумма всех покупок)

## Решение задачи 4
Таблица transactions (id, transaction_date, client_id, currency, amount):

<img width="974" height="297" alt="image" src="https://github.com/user-attachments/assets/2fe364a7-7896-413e-a7cd-8998c8cf49ff" />

```sql
CREATE DATABASE IF NOT EXISTS test;
USE test;


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
```
Таблица currency (id, currency_date, currency, value):

<img width="771" height="310" alt="image" src="https://github.com/user-attachments/assets/b674a749-aeb1-4472-84c4-37849dfa3f27" />

```sql
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
```

-- 1. вычислить стоимость всех покупок для каждого клиента, результат посчитать в рублях
-- (клиент 1, сумма всех покупок),
-- (клиент 2, сумма всех покупок)
```sql
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
```
<img width="444" height="208" alt="image" src="https://github.com/user-attachments/assets/24d547b7-78ca-416f-a27a-2a0f2a7176ad" />

-- 2. вычислить стоимость всех покупок в рублях для каждого клиента в ситуации, когда курс ЦБ есть не на все даты 
-- (в таблице валют отсутствует строка с датой). 
-- На праздники и выходные устанавливается курс ЦБ в крайний рабочий день перед ними.
-- (клиент 1, сумма всех покупок),
-- (клиент 2, сумма всех покупок)
```sql
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
```
<img width="433" height="200" alt="image" src="https://github.com/user-attachments/assets/1e5611c0-d421-4ae7-a928-c68f840f8f5b" />

