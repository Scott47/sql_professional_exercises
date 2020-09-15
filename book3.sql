BOOK 3 CH. 1 SQL_UPDATE

-- Practice: Employees
-- Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location. She is currently at dealership 751.
-- She would like to work at dealership 20. Update her record to reflect her transfer.

UPDATE  public.dealershipemployees
SET dealership_id = 20
WHERE dealership_employee_id = 10

-- test
SELECT * FROM dealershipemployees
WHERE employee_id = 680;

-- Practice: Sales
-- A Sales associate needs to update a sales record because her customer want so pay wish Mastercard instead of American Express.
-- Update Customer, Layla Igglesden Sales record which has an invoice number of 2781047589.

UPDATE  public.sales
SET payment_method = 'mastercard'
WHERE customer_id = 13;

-- test
SELECT * FROM sales s
WHERE s.customer_id = 13;

-- Practice - Employees
-- A sales employee at carnival creates a new sales record for a sale they are trying to close. The customer,
-- last minute decided not to purchase the vehicle. Help delete the Sales record with an invoice number of '7628231837'.
DELETE FROM sales s
WHERE s.invoice_number = '7628231837';

-- test
SELECT * FROM sales s
WHERE s.invoice_number = '7628231837';


-- An employee was recently fired so we must delete them from our database. Delete the employee with employee_id of 35.
-- What problems might you run into when deleting? How would you recommend fixing it?



-- Inventory Management
-- Selling a Vehicle
-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs.
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table.
-- When set to True this flag will indicate that the vehicle is no longer available in the inventory.
-- Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.

-- Returning a Vehicle
-- Carnival would also like to handle the case for when a car gets returned by a customer.
-- When this occurs they must add the car back to the inventory and mark the original sales record as returned = True.
-- Selling a vehicle
CREATE PROCEDURE remove_vehicle_from_inventory(vehicleId int)
LANGUAGE plpgsql
    AS $$
    BEGIN

    UPDATE vehicles v.
    SET is_sold = True
    WHERE v.vehicle_id = vehicleId

END
    $$;

CALL remove_vehicle_from_inventory(2)

ALTER TABLE
  vehicles
ADD
  COLUMN is_sold bool NOT NULL
SET
  DEFAULT false;


-- Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor.
-- In our stored procedure, we must also log the oil change within the OilChangeLog table.

CREATE TABLE OilChangeLog (
    oil_change_id PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    date_oil_changed TIMESTAMP WITH TIME ZONE,
    FOREIGN KEY vehicle_id REFERENCES Vehicles (vehicle_id)
)

-- Goals
-- Use the story above and extract the requirements.
-- Build two stored procedures for Selling a car and Returning a car.
-- Be ready to share with your class or instructor your result.

-- BOOK 3 CH 5 Intro to Triggers
-- Practice: Carnival
-- Create a trigger for when a new Sales record is added, set the purchase date to 3 days from the current date.
CREATE FUNCTION set_pickup_date()
  RETURNS TRIGGER
  LANGUAGE PlPGSQL
AS $$
BEGIN
  -- trigger function logic
  UPDATE sales
  SET pickup_date = NEW.purchase_date + integer '7'
  WHERE sales.sale_id = NEW.sale_id;

  RETURN NULL;
END;
$$

CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  EXECUTE PROCEDURE set_pickup_date();


-- Create a trigger for updates to the Sales table. If the pickup date is on or before the purchase date,
-- set the pickup date to 7 days after the purchase date. If the pickup date is after the purchase date
-- but less than 7 days out from the purchase date, add 4 additional days to the pickup date.


CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  WHEN NEW.pickup_date <= NEW.purchase_date
  EXECUTE PROCEDURE set_pickup_date();

CREATE TRIGGER new_sale_made
  AFTER INSERT
  ON sales
  FOR EACH ROW
  WHEN NEW.pickup_date > NEW.purchase_date AND NEW.pickup_date < NEW.purchase_date + 7
  EXECUTE PROCEDURE set_pickup_date();


-- Book 3 Ch 6
-- Because Carnival is a single company,
-- we want to ensure that there is consistency in the data provided to the user.
-- Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember.
-- Therefore, any time a new dealership is added or an existing dealership is updated,
-- we want to ensure that the website URL has the following format:
-- http://www.carnivalcars.com/{name of the dealership with underscores separating words}.

CREATE OR REPLACE FUNCTION format_dealership_webiste()
  RETURNS TRIGGER
  LANGUAGE PlPGSQL
AS $$
BEGIN
	NEW.website := CONCAT('http://www.carnivalcars.com/', REPLACE(LOWER(NEW.business_name), ' ', '_'));

	RETURN NEW;
END;
$$

CREATE TRIGGER dealership_website
BEFORE INSERT OR UPDATE
ON dealerships
FOR EACH ROW EXECUTE PROCEDURE format_dealership_webiste();

INSERT INTO dealerships(business_name, phone, city, state, website, tax_id)
VALUES ('New Dealership in Music City', '615-200-2000', 'Nashville', 'Tennessee', 'www.test.com', 'ab-200-2000');

SELECT * FROM dealerships ORDER BY dealership_id DESC;

-- If a phone number is not provided for a new dealership,
-- set the phone number to the default customer care number 777-111-0305.

CREATE OR replace FUNCTION default_phone_num()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
BEGIN

	UPDATE dealerships
	SET phone = '777-111-0305'
	WHERE phone IS NULL;

	RETURN NULL;

END;
$$

CREATE trigger add_phone
	AFTER INSERT
	ON dealerships
	for each row
  EXECUTE PROCEDURE default_phone_num();

-- Test

INSERT INTO dealerships(business_name)
VALUES('New dealership 3!');

SELECT * FROM dealerships
ORDER BY dealership_id DESC;

SELECT * FROM dealerships;

-- For accounting purposes, the name of the state needs to be part of the dealership's tax id.
-- For example, if the tax id provided is bv-832-2h-se8w for a dealership in Virginia,
-- then it needs to be put into the database as bv-832-2h-se8w--virginia.

SELECT count(*) FROM dealerships
WHERE tax_id NOT LIKE '%-%-%-%--%';

CREATE OR replace FUNCTION update_tax_id()
	RETURNS trigger
	LANGUAGE plpgsql
AS $$
BEGIN

	UPDATE dealerships
	SET tax_id = concat(tax_id, '--', lower(state))
	WHERE tax_id NOT LIKE '%-%-%-%--%';

	RETURN null;

END;
$$

CREATE trigger tax_id
	AFTER INSERT OR UPDATE
	ON dealerships
	FOR EACH ROW
	EXECUTE PROCEDURE update_tax_id();

-- Test
INSERT INTO dealerships(business_name)
VALUES('new Dealership');

UPDATE dealerships
SET tax_id = concat(tax_id, '--', lower(state))
WHERE dealership_id = 2;

SELECT * FROM dealerships
WHERE tax_id LIKE '%-%-%-%--%';