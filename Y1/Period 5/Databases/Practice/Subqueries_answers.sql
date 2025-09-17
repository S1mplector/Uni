-- a. Model numbers and products made by maker b 

SELECT model, maker
FROM Products
WHERE maker = 'b';

-- b. List the model numbers of all products not made by maker B.

SELECT model, maker
FROM Products
WHERE model NOT IN (SELECT model FROM Products WHERE maker = 'b');

-- c. List the model numbers of all PCs with speed >= 3.00.

SELECT model AS model_number, speed
FROM pcs
WHERE speed >= 3.00;

-- d. List the model numbers of all color laser printers.

SELECT model AS model_number
FROM printers
WHERE color = 'TRUE';

-- e. List the customer IDs of all customers who paid for a product with a visa card (debit or credit).

SELECT customer_id AS visa_payers,  type_of_payment
FROM sales
WHERE type_of_payment LIKE '%visa%'

-- f. List the first names, the last names, the city and the street address of all customers who have the letter ‘e’ either in their first name or in their last name.

SELECT firstname, lastname, city, address AS street_address
FROM customers
WHERE firstname LIKE '%e%' OR lastname LIKE '%e%';

-- g. List all attributes of the transactions (from table sales) made between the 18th and the 20th of December 2013 (including the 18th and the 20th).

SELECT *
FROM sales
WHERE day BETWEEN '2013-12-18' AND '2013-12-20'

--  List all attributes of the transactions (from table sales) made either before the 18th or after the 20th of December 2013

SELECT *
FROM sales
WHERE day < '2013-12-18' OR day > '2013-12-20'

-- i. Assume all prices in table Laptops are in Euro. List the model numbers of all laptops with ram at least 1024. For each model, list also its price in USD. Assume that 1 USD = 0.85 EURO.

SELECT model, price as price_eur, price * 0.85 as price_usd
FROM laptops

-- Subqueries Section

-- a. List all PC models that have been sold at least once.

SELECT p.model, COUNT(s.quantity) AS amount_sold
FROM pcs AS p 
JOIN sales AS s
USING (model)
GROUP BY p.model   

-- b. List the makers of laptops with speed of at least 2.00.

SELECT l.model, p.maker, l.speed
FROM laptops AS l
JOIN products AS p 
ON l.model = p.model
WHERE l.speed >= 2.00;

-- c. List all pairs of PC models that have both the same speed and ram. A pair should be listed only once; e.g., list (i, j) but not (j, i).

FROM pcs p1
JOIN pcs p2 
ON p1.speed = p2.speed
AND p1.ram = p2.ram
WHERE p1.model < p2.model;

-- d. List the makers that make at least two diﬀerent models of PC.

SELECT p.maker
FROM pcs AS pc
JOIN products as p
ON pc.model = p.model
GROUP BY p.maker
HAVING COUNT(DISTINCT pc.model) >= 2

-- e. List the maker(s) of the laptop(s) with the highest available speed.

SELECT l.model, l.speed, p.maker, p.type
FROM laptops AS l
JOIN products AS p
ON l.model = p.model
ORDER BY l.speed DESC LIMIT 1;

-- f. List the cities with customers who bought a printer.

SELECT c.customer_id AS buyer_customer, 
s.model AS model_bought
FROM sales AS s
JOIN customers AS c
ON c.customer_id = s.customer_id
WHERE s.model IN (SELECT model FROM products WHERE type = 'printer');

-- g. List the makers of PCs that don’t make any laptop (but may make printers)

SELECT DISTINCT p.maker
FROM pcs AS pc
JOIN products AS p
ON pc.model = p.model
WHERE p.maker NOT IN 
(SELECT p2.maker 
FROM Products AS p2
JOIN laptops AS l
ON p2.model = l.model)

-- Alternative way? 

SELECT DISTINCT p.maker
FROM pcs AS pc
JOIN products AS p
ON pc.model = p.model
WHERE p.maker NOT IN 
(SELECT maker FROM products WHERE type = 'laptop');

-- h. List the makers of PCs that don’t make any laptop or printer

SELECT DISTINCT p.maker 
FROM pcs AS pc
JOIN products AS p
ON pc.model = p.model
WHERE p.maker NOT IN 
(SELECT maker FROM products WHERE type = 'laptop' OR type = 'printer');

-- i. List the model numbers and prices of laptops which are cheaper than at least one PC
 
 SELECT l.model, l.price
 FROM laptops AS l
 WHERE l.price < ANY (SELECT price FROM pcs)
 
 -- j. List all makers, all model numbers they make, and the corresponding product types (i.e. the entire maker, model and type columns from table Products). For the PC models only list their speed and price as well in two additional columns. These two extra columns should contain NULL markers for laptop and printer models.
 
 SELECT p.maker, p.model, p.type, pc.speed AS pc_speed, pc.price AS pc_price
FROM products AS p
LEFT JOIN pcs AS pc
USING(model);

-- k. List all laptop model numbers and only for those made by makers A and B list also their price. The prices of laptops not made by either A or B should be NULL.

SELECT 
  l.model,
  ab_laptops.price,
  p.maker
FROM Laptops AS l
JOIN Products AS p ON l.model = p.model
LEFT JOIN Laptops AS ab_laptops 
  ON l.model = ab_laptops.model
WHERE p.maker IN ('A', 'B')
   OR ab_laptops.model IS NULL;



