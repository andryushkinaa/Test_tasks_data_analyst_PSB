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



