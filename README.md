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

