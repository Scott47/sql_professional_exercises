
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

-- Book 2 Ch. 4Practice: Leased Types
-- Produce a report that determines the most popular vehicle model that is leased.
SELECT mo.name, COUNT(s.sale_id) AS lease_count
FROM sales s,
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclesbodytypes bt ON vt_vehicle_body_type_id = bt.vehicle_body_type_id
JOIN vehiclemodels mo ON vt_vehicle_model_id = mo.vt_vehicle_model_id
WHERE sales_type_id = 2
GROUP BY mo.vt_vehicle_model_id
ORDER BY COUNT(s.sale_id) DESC;