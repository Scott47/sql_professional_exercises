-- Best Sellers
-- Who are the top 5 employees for generating sales income?
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
	COUNT(s.sale_id) AS num_sales,
	SUM(s.price) AS income
FROM sales s
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY employee_name
ORDER BY SUM(s.price) DESC
LIMIT 5;
-- Who are the top 5 dealership for generating sales income?
SELECT
  d.business_name AS dealership,
  SUM(s.price) AS income
FROM
  sales s
  JOIN dealerships d ON s.dealership_id = d.dealership_id
GROUP BY
  d.dealership_id
LIMIT 5;
-- Which vehicle model generated the most sales income?
SELECT 
	mo.name, 
	SUM(s.price)
FROM sales s
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY mo.vehicle_model_id
ORDER BY COUNT(s.sale_id) DESC
LIMIT 1;
-- Top Performance
-- Which employees generate the most income per dealership?
SELECT
	CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
	d.business_name,
	SUM(s.price) AS income
FROM sales s
JOIN dealerships d ON s.dealership_id = d.dealership_id
JOIN dealershipemployees de ON s.employee_id = de.employee_id
JOIN employees e ON s.employee_id = e.employee_id
GROUP BY d.business_name, employee_name
ORDER BY SUM(s.price) DESC;
-- Vehicle Reports
-- Inventory
-- In our Vehicle inventory, show the count of each Model that is in stock.
SELECT
	mo.name AS model,
  COUNT(v.vehicle_id) AS inventory
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemodels mo ON vt.model_id = mo.vehicle_model_id
GROUP BY
  mo.name
ORDER BY
  COUNT(v.vehicle_id) DESC;
-- In our Vehicle inventory, show the count of each Make that is in stock.
SELECT
	ma.name AS make,
  COUNT(v.vehicle_id) AS inventory
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclemakes ma ON vt.make_id = ma.vehicle_make_id
GROUP BY
  ma.name
ORDER BY
  COUNT(v.vehicle_id) DESC;
-- In our Vehicle inventory, show the count of each BodyType that is in stock.
SELECT
	bt.name AS bodytype,
  COUNT(v.vehicle_id) AS inventory
FROM
  vehicles v
  JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
  JOIN vehiclebodytypes bt ON vt.body_type_id = bt.vehicle_body_type_id
GROUP BY
  bt.name
ORDER BY
  COUNT(v.vehicle_id) DESC;
-- Purchasing Power
-- Which US state's customers have the highest average purchase price for a vehicle?
CREATE VIEW us_customer_highest_average AS
SELECT
  c.state,
  AVG(s.price)::numeric(10,2)
FROM
  customers c
  JOIN sales s ON s.customer_id = c.customer_id
GROUP BY
  c.state
ORDER BY AVG(s.price) DESC;

-- Now using the data determined above, 
-- which 5 states have the customers with the highest average purchase price for a vehicle?
SELECT *
FROM us_customer_highest_average
LIMIT 5