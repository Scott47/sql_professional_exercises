
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

-- Get a list of sales with the VIN of the vehicle, the first name and last name of the customer,
-- first name and last name of the employee who made the sale and the name, city and state of the dealership.
SELECT v.vin, bt.name as bodytype, ma.name as make, mo.name as model
FROM vehicles v
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id;

-- Get a list of all the dealerships and the employees, if any, working at each one.
SELECT d.business_name, CONCAT(e.first_name, ' ', e.last_name) as employee_name
FROM dealershipEmployees de
RIGHT JOIN dealerships d ON d.dealership_id = de.dealership_id
LEFT JOIN employees e ON e.employee_id = de.employee_id;
-- Get a list of vehicles with the names of the body type, make, model and color.

-- Book 2 Ch. 4
-- Practice: Sales Type by Dealership
-- Produce a report that lists every dealership, the number of purchases done by each, and the number of leases done by each.
SELECT d.dealership_id, d.business_name, COUNT(st.name) AS purchase
FROM dealerships d
JOIN sales s ON d.dealership_id = s.dealership_id
JOIN salestypes st ON s.sales_type_id = st.sales_type_id
WHERE st.sales_type_id = 2
GROUP BY d.dealership_id;

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


-- Which employee type sold the most of that make?


-- Book 2 Ch. 8
-- Purchase Income by Dealership
-- Write a query that shows the total purchase sales income per dealership.
-- Write a query that shows the purchase sales income per dealership for the current month.
-- Write a query that shows the purchase sales income per dealership for the current year.


-- Lease Income by Dealership
-- Write a query that shows the total lease income per dealership.
-- Write a query that shows the lease income per dealership for the current month.
-- Write a query that shows the lease income per dealership for the current year.


-- Total Income by Employee
-- Write a query that shows the total income (purchase and lease) per employee.