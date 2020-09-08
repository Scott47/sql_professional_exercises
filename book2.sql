
-- Query Review
-- Write a query that returns the business name, city, state, and website for each dealership. Use an alias for the Dealerships table.

SELECT
	d.business_name,
	d.city,
	d.state,
	d.website
	FROM Dealerships d;

-- Write a query that returns the first name, last name, and email address of every customer. Use an alias for the Customers table.

SELECT
	cu.first_name,
	cu.last_name,
	cu.email
	FROM Customers cu;


-- Get a list of sales records where the sale was a lease.
SELECT
	*
FROM
	sales sa
WHERE
	sa.sales_type_id = 2;

SELECT
	sales_type_id
    AS Lease,
    *
FROM
	sales sa
WHERE
	sa.sales_type_id = 2;

-- Get a list of sales where the purchase date is within the last two years.
SELECT
	*
FROM
	sales sa
WHERE
	sa.purchase_date >= CURRENT_DATE - '2 years'::interval;


SELECT
    *, purchase_date AS "last_two_years"
FROM
	sales
WHERE
	purchase_date < '8-31-2018'
ORDER BY purchase_date ASC;

-- Get a list of sales where the deposit was above 5000 or the customer payed with American Express.
SELECT *, s.deposit AS dep_above_5000
FROM Sales s
WHERE deposit > 5000 OR payment_method = 'American Express';

-- Get a list of employees whose first names start with "M" or ends with "E".
SELECT e.first_name
FROM employees e
WHERE e.first_name LIKE 'M%' OR first_name LIKE '%E';

-- Get a list of employees whose phone numbers have the 600 area code.
SELECT e.first_name, e.last_name
FROM employees e
WHERE e.phone_number  LIKE '600%';

-- Book 2 Ch. 3
-- Practice: Carnival
-- Get a list of the sales that was made for each sales type.
SELECT s.*
FROM sales s
JOIN salestypes st ON st.sales_type_id = s.sales_type_id

-- Get a list of sales with the VIN of the vehicle, the first name and last name of the customer,
-- first name and last name of the employee who made the sale and the name, city and state of the dealership.
SELECT
	v.vin,
	bt.name as bodytype,
	ma.name as make,
	mo.name as model
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id;

-- Get a list of all the dealerships and the employees, if any, working at each one.
SELECT
	d.business_name,
	CONCAT(e.first_name, ' ', e.last_name) as employee_name
FROM dealershipEmployees de
LEFT JOIN dealerships d ON d.dealership_id = de.dealership_id
LEFT JOIN employees e ON e.employee_id = de.employee_id;

-- Get a list of vehicles with the names of the body type, make, model and color.
SELECT
	v.vin,
	bt.name,
	ma.name,
	mo.name
FROM vehicles v
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id

-- Book 2 Ch. 4
-- Practice: Sales Type by Dealership
-- Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT d.dealership_id, d.business_name, COUNT(st.name) AS purchase
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_id = 1
GROUP BY d.dealership_id
ORDER BY d.dealershiop_id;


-- Practice: Leased Types
-- Produce a report that determines the most popular vehicle model that is leased.
SELECT mo.name, COUNT(s.sale_id) AS lease_count
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
WHERE sales_type_id = 2
GROUP BY mo.vehicle_model_id
ORDER BY COUNT(s.sale_id) DESC;

-- Practice: Who Sold What
-- What is the most popular vehicle make in terms of number of sales?
SELECT ma.name, COUNT(s.sale_id) AS sale_count
FROM sales s
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY ma.vehicle_make_id
ORDER BY COUNT(s.sale_id) DESC;

-- Which employee type sold the most of that make?



-- Book 2 Ch. 8
-- Purchase Income by Dealership
-- Write a query that shows the total purchase sales income per dealership.

SELECT
	d.business_name,
	COUNT(s.sale_id) AS num_sales,
	SUM(s.price) AS income
FROM sales s
JOIN dealerships d ON d.dealership_id = s.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_id = 1
GROUP BY s.sales_type_id, d.business_name
ORDER BY SUM(s.price) DESC;

-- Write a query that shows the purchase sales income per dealership for the current month.
SELECT
	d.dealership_id,
    SUM(s.price)
FROM sales s
    JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE EXTRACT(MONTH FROM s.purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM s.purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND s.sales_type_id = 1
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
  date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE) -- AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the purchase sales income per dealership for the current year.
SELECT
	d.dealership_id,
    SUM(s.price)
FROM sales s
    JOIN dealerships d ON d.dealership_id = s.dealership_id
	JOIN salestypes st ON st.sales_type_id = s.sales_type_id
	WHERE EXTRACT(YEAR FROM s.purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) AND s.sales_type_id = 1
	GROUP BY d.dealership_id
	ORDER BY d.dealership_id;

SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
WHERE
  date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Lease Income by Dealership
-- Write a query that shows the total lease income per dealership.
SELECT
	d.business_name,
	COUNT(s.sale_id) AS num_leases,
	SUM(s.price) AS income
FROM sales s
JOIN dealerships d ON d.dealership_id = s.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_id = 2
GROUP BY s.sales_type_id, d.business_name
ORDER BY SUM(s.price) DESC;


SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
GROUP BY
  d.dealership_id;

-- Write a query that shows the lease income per dealership for the current month.
SELECT
	d.dealership_id,
    SUM(s.price)
FROM sales s
    JOIN dealerships d ON d.dealership_id = s.dealership_id
WHERE EXTRACT(MONTH FROM s.purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND EXTRACT(YEAR FROM s.purchase_date) = EXTRACT(MONTH FROM CURRENT_DATE) AND s.sales_type_id = 2
GROUP BY d.dealership_id
ORDER BY d.dealership_id;

SELECT
  d.business_name,
  SUM(s.price)
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
  AND date_part('month', s.purchase_date) = date_part('month', CURRENT_DATE) -- AND date_part('year', s.purchase_date) = date_part('year', CURRENT_DATE)
GROUP BY
  d.dealership_id;

-- Write a query that shows the lease income per dealership for the current year.
SELECT
	d.dealership_id,
    SUM(s.price)
FROM sales s
    JOIN dealerships d ON d.dealership_id = s.dealership_id
	JOIN salestypes st ON st.sales_type_id = s.sales_type_id
	WHERE EXTRACT(YEAR FROM s.purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE) AND s.sales_type_id = 2
	GROUP BY d.dealership_id
	ORDER BY d.dealership_id;

-- Total Income by Employee
-- Write a query that shows the total income (purchase and lease) per employee.
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
	COUNT(s.sale_id) AS num_sales,
	SUM(s.price) AS income
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY employee_name
ORDER BY SUM(s.price) DESC;

-- Book 2 Ch. 10 Employee Recognition
-- How many emloyees are there for each role?
SELECT
  et.name,
  COUNT(e.employee_id)
FROM
  employeetypes et
  JOIN employees e ON et.employee_type_id = e.employee_type_id
GROUP BY
  et.employee_type_id

  -- How many finance managers work at each dealership?
SELECT
  d.business_name,
  COUNT(e.employee_id)
FROM
  employeetypes et
  JOIN employees e ON et.employee_type_id = e.employee_type_id
  JOIN dealershipemployees de ON de.employee_id = e.employee_id
  JOIN dealerships d ON de.dealership_id = d.dealership_id
WHERE
  LOWER(et.name) LIKE '%finance%'
GROUP BY
  d.dealership_id;

-- Get the names of the top 3 employees who work shifts at the most dealerships?
SELECT
  e.first_name,
  e.last_name,
  COUNT(d.dealership_id)
FROM
  employees e
  JOIN dealershipemployees de ON de.employee_id = e.employee_id
  JOIN dealerships d ON de.dealership_id = d.dealership_id
GROUP BY
  e.employee_id
ORDER BY
  COUNT(d.dealership_id) DESC
LIMIT
  3;

-- Get a report on the top two employees who has made the most sales through leasing vehicles.
SELECT
  e.first_name,
  e.last_name,
  COUNT(s.sale_id)
FROM
  employees e
  JOIN sales s ON s.employee_id = e.employee_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) LIKE '%lease%'
GROUP BY
  e.employee_id
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  2;

-- Get a report on the the two employees who has made the least number of non-lease sales.
SELECT
  e.first_name,
  e.last_name,
  COUNT(s.sale_id)
FROM
  employees e
  JOIN sales s ON s.employee_id = e.employee_id
  JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE
  LOWER(st.name) NOT LIKE '%lease%'
GROUP BY
  e.employee_id
ORDER BY
  COUNT(s.sale_id) ASC
LIMIT
  2;

-- Book 2 Ch. 11
-- What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
  c.state,
  COUNT(s.sale_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  c.state
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  5;

  -- What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
SELECT
  c.zipcode,
  COUNT(s.sale_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  c.zipcode
ORDER BY
  COUNT(s.sale_id) DESC
LIMIT
  5;

-- What are the top 5 dealerships with the most customers?
SELECT
  d.business_name,
  COUNT(c.customer_id)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  d.dealership_id
ORDER BY
  COUNT(c.customer_id) DESC
LIMIT
  5;

-- Book 2 Ch. 12
-- Practice: Carnival
-- Create a view that lists all vehicle body types, makes and models.
CREATE VIEW automobiles AS
	SELECT
		bt.name AS body,
		ma.name AS make,
		mo.name AS model
	FROM vehicletypes vt
	JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
	JOIN vehiclemakes ma ON vt.make_id = bt.vehicle_body_type_id
	JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id;


-- Create a view that shows the total number of employees for each employee type.
-- Create a view that lists all customers without exposing their emails, phone numbers and street address.
-- Create a view named sales2018 that shows the total number of sales for each sales type for the year 2018.
-- Create a view that shows the employee at each dealership with the most number of sales.

