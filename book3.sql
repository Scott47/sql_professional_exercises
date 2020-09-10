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