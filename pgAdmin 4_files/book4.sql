-- From project with team
--create paymentmethod table
CREATE TABLE paymentmethods (
	payment_method_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY ,
	payment_method_name VARCHAR
);
DROP TABLE paymentmethods;

BEGIN;

-- insert a new row into the paymentmethod  table
INSERT INTO paymentmethods (payment_method_name)
VALUES ('American Express'), ('Visa'), ('Mastercard'), ('JCB'), ('Laser'),
	   ('China-Unionpay'), ('Instapayment'), ('Solo'), ('Diners-Club-Enroute'), ('Bankcard'),
	   ('Diners-Club-International'), ('Diners-Club-US-CA'), ('Switch'), ('Visa-Electron'), ('Diners-Club-Carte-Blanche'), ('Maestro');

-- update payment_method column in sales with correct payment_method
UPDATE sales SET payment_method = '1' WHERE payment_method = 'americanexpress';
UPDATE sales SET payment_method = '2' WHERE payment_method = 'visa';
UPDATE sales SET payment_method = '3' WHERE payment_method = 'mastercard';
UPDATE sales SET payment_method = '4' WHERE payment_method = 'jcb';
UPDATE sales SET payment_method = '5' WHERE payment_method = 'laser';
UPDATE sales SET payment_method = '6' WHERE payment_method = 'china-unionpay';
UPDATE sales SET payment_method = '7' WHERE payment_method = 'instapayment';
UPDATE sales SET payment_method = '8' WHERE payment_method = 'solo';
UPDATE sales SET payment_method = '9' WHERE payment_method = 'diners-club-enroute';
UPDATE sales SET payment_method = '10' WHERE payment_method = 'bankcard';
UPDATE sales SET payment_method = '11' WHERE payment_method = 'diners-club-international';
UPDATE sales SET payment_method = '12' WHERE payment_method = 'diners-club-us-ca';
UPDATE sales SET payment_method = '13' WHERE payment_method = 'switch';
UPDATE sales SET payment_method = '14' WHERE payment_method = 'visa-electron';
UPDATE sales SET payment_method = '15' WHERE payment_method = 'diners-club-carte-blanche';
UPDATE sales SET payment_method = '16' WHERE payment_method = 'maestro';

-- change type for column payment_method from character varying to integer
ALTER TABLE sales
ALTER COLUMN payment_method TYPE INT
USING payment_method::integer;

-- change name of column payment_method to payment_method_id
ALTER TABLE sales
RENAME COLUMN payment_method TO payment_method_id;

-- change payment_method_id to FK on sales
ALTER TABLE sales
ADD CONSTRAINT FK_payment_method_id
FOREIGN KEY (payment_method_id) REFERENCES paymentmethods(payment_method_id);

-- add column dealership_id on to vehicles table to establish relationship between vehicles and dealerships
ALTER TABLE vehicles
ADD COLUMN dealership_id INT;

-- change dealership_id column on vehicles table to foreign key referenceing dealerships table
ALTER TABLE vehicles
ADD CONSTRAINT FK_dealership_id
FOREIGN KEY (dealership_id) REFERENCES dealerships(dealership_id);

-- populate dealership_id on vehicles table
UPDATE vehicles
SET dealership_id = vehicle_id;

ROLLBACK;
-- commit the change
COMMIT;

SELECT dealership_id FROM vehicles
ORDER BY dealership_id DESC;

-- Which dealerships are currently selling the least number of vehicle models?
-- This will let dealerships market vehicle models more effectively per region.
EXPLAIN ANALYZE SELECT
	d.business_name,
	vm.name,
	COUNT(vm.name)
FROM dealerships d
JOIN sales s ON s.dealership_id = d.dealership_id
JOIN vehicles v ON s.vehicle_id = v.vehicle_id
JOIN vehicletypes vt ON v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclemodels vm ON vm.vehicle_model_id = vt.model_id
GROUP BY d.business_name, vm.name
ORDER BY COUNT(vm.name);

CREATE MATERIALIZED VIEW vehicle_make_model AS
SELECT
	v.vehicle_id,
	mo.name AS model
FROM vehicles v
JOIN vehicletypes vt ON vt.vehicle_type_id = v.vehicle_type_id
JOIN vehiclemodels mo ON mo.vehicle_model_id = vt.model_id

CREATE INDEX vehicle_type_index ON vehicle_make_model(vehicle_id);

EXPLAIN ANALYZE SELECT
	d.business_name,
	vm.model,
	COUNT(vm.model)
FROM dealerships d
JOIN sales s ON s.dealership_id = d.dealership_id
JOIN vehicle_make_model vm ON s.vehicle_id = vm.vehicle_id
GROUP BY d.business_name, vm.model
ORDER BY COUNT(vm.model);

SELECT * FROM vehiclemodels;




