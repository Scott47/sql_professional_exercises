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