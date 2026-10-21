
-- Safety: the destructive DROP DATABASE command is intentionally disabled.
-- If you need a clean reset, back up your data before dropping the database.
CREATE DATABASE IF NOT EXISTS VehicleServiceTracker;
USE VehicleServiceTracker;

-- ================================
-- TABLES (core entities)
-- ================================

CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address VARCHAR(255)
);

CREATE TABLE Vehicle (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT NOT NULL,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Year INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID) ON DELETE CASCADE
);

CREATE TABLE ServiceType (
    ServiceTypeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL
);

CREATE TABLE Mechanic (
    MechanicID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Specialization VARCHAR(100)
);

CREATE TABLE ServiceBooking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    VehicleID INT NOT NULL,
    ServiceTypeID INT NOT NULL,
    MechanicID INT NULL,  -- Changed to allow NULL for ON DELETE SET NULL
    BookingDate DATE NOT NULL,
    Status ENUM('Pending','In Progress','Completed','Cancelled') DEFAULT 'Pending',
    PaymentAmount DECIMAL(10,2),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID) ON DELETE CASCADE,
    FOREIGN KEY (ServiceTypeID) REFERENCES ServiceType(ServiceTypeID) ON DELETE RESTRICT,
    FOREIGN KEY (MechanicID) REFERENCES Mechanic(MechanicID) ON DELETE SET NULL
);




CREATE TABLE Supplier (
    SupplierID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Address VARCHAR(255)
);

CREATE TABLE Part (
    PartID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID) ON DELETE RESTRICT
);

-- Junction table for many-to-many between Booking and Part
CREATE TABLE BookingPart (
    BookingID INT NOT NULL,
    PartID INT NOT NULL,
    Quantity INT NOT NULL CHECK (Quantity > 0),
    PRIMARY KEY (BookingID, PartID),
    FOREIGN KEY (BookingID) REFERENCES ServiceBooking(BookingID) ON DELETE CASCADE,
    FOREIGN KEY (PartID) REFERENCES Part(PartID) ON DELETE RESTRICT
);

CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    BookingID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10,2) NOT NULL CHECK (Amount >= 0),
    Method ENUM('Cash','Card','Mobile Banking') NOT NULL,
    TransactionRef VARCHAR(100),
    FOREIGN KEY (BookingID) REFERENCES ServiceBooking(BookingID) ON DELETE CASCADE
);



-- CUSTOMER (20 records)
INSERT INTO Customer (Name, Phone, Email, Address) VALUES
('Alice Johnson', '01710000001', 'alice.johnson@example.com', '123 Maple St'),
('Bob Smith', '01710000002', 'bob.smith@example.com', '456 Oak Ave'),
('Charlie Lee', '01710000003', 'charlie.lee@example.com', '789 Pine Rd'),
('Diana Prince', '01710000004', 'diana.prince@example.com', '321 Cedar Blvd'),
('Ethan Hunt', '01710000005', 'ethan.hunt@example.com', '654 Spruce Ln'),
('Fiona Gallagher', '01710000006', 'fiona.g@example.com', '987 Birch Ct'),
('George Lucas', '01710000007', 'george.lucas@example.com', '159 Elm St'),
('Hannah Baker', '01710000008', 'hannah.baker@example.com', '753 Willow Dr'),
('Ian Fleming', '01710000009', 'ian.fleming@example.com', '852 Aspen Way'),
('Jane Doe', '01710000010', 'jane.doe@example.com', '951 Redwood Pl'),
('Kevin Hart', '01710000011', 'kevin.hart@example.com', '147 Cypress Rd'),
('Lara Croft', '01710000012', 'lara.croft@example.com', '258 Fir St'),
('Mike Ross', '01710000013', 'mike.ross@example.com', '369 Palm Ave'),
('Nina Simone', '01710000014', 'nina.simone@example.com', '741 Cherry Ln'),
('Oscar Wilde', '01710000015', 'oscar.wilde@example.com', '852 Magnolia Blvd'),
('Pam Beesly', '01710000016', 'pam.beesly@example.com', '963 Poplar Ct'),
('Quinn Fabray', '01710000017', 'quinn.fabray@example.com', '174 Dogwood Dr'),
('Ryan Gosling', '01710000018', 'ryan.gosling@example.com', '285 Maplewood St'),
('Sophie Turner', '01710000019', 'sophie.turner@example.com', '396 Chestnut Rd'),
('Tom Holland', '01710000020', 'tom.holland@example.com', '507 Hickory Ln');

-- VEHICLE (20 records - 3 for Alice, 2 for Bob, 1 for others)
INSERT INTO Vehicle (CustomerID, LicensePlate, Model, Year) VALUES
(1, 'AB1234', 'Toyota Corolla', 2021),
(1, 'XY9876', 'Honda Accord', 2020),
(1, 'MN3456', 'Ford Escape', 2019),
(2, 'CD5678', 'Honda Civic', 2019),
(2, 'ZW5432', 'Ford F-150', 2021),
(3, 'EF9012', 'Ford Mustang', 2020),
(4, 'GH3456', 'Chevrolet Camaro', 2018),
(5, 'IJ7890', 'Tesla Model 3', 2022),
(6, 'KL2345', 'BMW X5', 2020),
(7, 'MN6789', 'Audi A4', 2017),
(8, 'OP0123', 'Mercedes C300', 2021),
(9, 'QR4567', 'Volkswagen Golf', 2019),
(10, 'ST8901', 'Subaru Outback', 2022),
(11, 'UV2345', 'Mazda CX-5', 2021),
(12, 'WX6789', 'Nissan Altima', 2020),
(13, 'YZ0123', 'Kia Sorento', 2018),
(14, 'AA4567', 'Hyundai Elantra', 2019),
(15, 'BB8901', 'Jeep Wrangler', 2021),
(16, 'CC2345', 'Dodge Charger', 2020),
(17, 'DD6789', 'Tesla Model X', 2022);

-- SERVICETYPE (20 records)
INSERT INTO ServiceType (Name, Description, Price) VALUES
('Oil Change', 'Replace engine oil and filter', 50.00),
('Brake Inspection', 'Inspect brake pads and rotors', 80.00),
('Tire Rotation', 'Rotate tires for even wear', 40.00),
('Engine Tune-Up', 'Tune engine for performance', 150.00),
('Battery Replacement', 'Replace car battery', 120.00),
('Transmission Service', 'Transmission fluid and filter change', 200.00),
('Air Conditioning Service', 'Inspect and recharge A/C system', 100.00),
('Wheel Alignment', 'Adjust wheel angles', 90.00),
('Coolant Flush', 'Flush and replace coolant', 70.00),
('Spark Plug Replacement', 'Replace spark plugs', 60.00),
('Suspension Check', 'Inspect suspension components', 85.00),
('Exhaust Repair', 'Fix exhaust leaks and damages', 130.00),
('Fuel System Cleaning', 'Clean fuel injectors and lines', 110.00),
('Timing Belt Replacement', 'Replace timing belt', 250.00),
('Clutch Repair', 'Repair or replace clutch system', 300.00),
('Headlight Replacement', 'Replace headlight bulbs', 45.00),
('Windshield Repair', 'Repair windshield chips or cracks', 90.00),
('Diagnostic Service', 'Run diagnostic tests', 75.00),
('Detailing Service', 'Full interior and exterior cleaning', 180.00),
('Roadside Assistance', 'Emergency roadside service', 60.00);

-- MECHANIC (20 records)
INSERT INTO Mechanic (Name, Phone, Specialization) VALUES
('John Doe', '01810000001', 'Engine Specialist'),
('Mary Jane', '01810000002', 'Brake Systems'),
('Paul Walker', '01810000003', 'Transmission Expert'),
('Emma Stone', '01810000004', 'Electrical Systems'),
('Chris Evans', '01810000005', 'Suspension and Alignment'),
('Natalie Portman', '01810000006', 'General Maintenance'),
('Mark Ruffalo', '01810000007', 'Air Conditioning'),
('Scarlett Johansson', '01810000008', 'Diagnostics'),
('Robert Downey', '01810000009', 'Exhaust Systems'),
('Jennifer Lawrence', '01810000010', 'Fuel Systems'),
('Tom Hiddleston', '01810000011', 'Battery Specialist'),
('Gal Gadot', '01810000012', 'Tire Services'),
('Benedict Cumberbatch', '01810000013', 'Detailing'),
('Zoe Saldana', '01810000014', 'Body Repair'),
('Chris Hemsworth', '01810000015', 'Clutch and Transmission'),
('Elizabeth Olsen', '01810000016', 'Engine Specialist'),
('Paul Rudd', '01810000017', 'Brake Systems'),
('Brie Larson', '01810000018', 'Electrical Systems'),
('Anthony Mackie', '01810000019', 'Suspension and Alignment'),
('Sebastian Stan', '01810000020', 'General Maintenance');

-- SERVICEBOOKING (20 records - focused on first 3 mechanics and first 5 customers)
INSERT INTO ServiceBooking (VehicleID, ServiceTypeID, MechanicID, BookingDate, Status, PaymentAmount) VALUES
-- Mechanic 1 (John Doe) - 5 bookings
(1, 1, 1, '2025-07-01', 'Completed', 50.00),
(2, 2, 1, '2025-07-03', 'In Progress', 80.00),
(3, 3, 1, '2025-07-05', 'Pending', 40.00),
(1, 4, 1, '2025-08-01', 'Completed', 150.00),
(2, 5, 1, '2025-08-03', 'Completed', 120.00),

-- Mechanic 2 (Mary Jane) - 4 bookings
(4, 6, 2, '2025-07-07', 'Cancelled', 200.00),
(5, 7, 2, '2025-07-09', 'Completed', 100.00),
(4, 8, 2, '2025-08-05', 'In Progress', 90.00),
(5, 9, 2, '2025-08-07', 'Completed', 70.00),

-- Mechanic 3 (Paul Walker) - 3 bookings
(6, 10, 3, '2025-07-11', 'Completed', 60.00),
(7, 11, 3, '2025-07-13', 'In Progress', 85.00),
(6, 12, 3, '2025-08-09', 'Pending', 130.00),

-- Other mechanics with 1 booking each
(8, 13, 4, '2025-07-15', 'Completed', 110.00),
(9, 14, 5, '2025-07-17', 'Completed', 250.00),
(10, 15, 6, '2025-07-19', 'In Progress', 300.00),
(11, 16, 7, '2025-07-21', 'Completed', 45.00),
(12, 17, 8, '2025-07-23', 'Cancelled', 90.00),
(13, 18, 9, '2025-07-25', 'Completed', 75.00),
(14, 19, 10, '2025-07-27', 'Completed', 180.00),
(15, 20, 11, '2025-07-29', 'Completed', 60.00);

-- SUPPLIER (20 records)
INSERT INTO Supplier (Name, Phone, Address) VALUES
('AutoParts Co.', '01910000001', '10 Industrial Rd'),
('Speedy Supplies', '01910000002', '22 Commerce St'),
('Quality Auto', '01910000003', '35 Motorway Blvd'),
('Parts4You', '01910000004', '50 Auto Park'),
('GearHub', '01910000005', '18 Warehouse Ln'),
('DriveLine', '01910000006', '5 Transport St'),
('MotorMax', '01910000007', '77 Service Ave'),
('Prime Parts', '01910000008', '13 Retail Rd'),
('AutoZone', '01910000009', '99 Distribution Dr'),
('Supreme Supplies', '01910000010', '6 Manufacturing Pl'),
('FastFix', '01910000011', '28 Industrial Rd'),
('CarCare Supplies', '01910000012', '44 Commerce St'),
('PartsExpress', '01910000013', '21 Motorway Blvd'),
('AutoFix', '01910000014', '32 Auto Park'),
('DriveTech', '01910000015', '11 Warehouse Ln'),
('MotorPro', '01910000016', '9 Transport St'),
('GearWorks', '01910000017', '54 Service Ave'),
('PartsDirect', '01910000018', '15 Retail Rd'),
('FixIt Fast', '01910000019', '88 Distribution Dr'),
('CarParts Plus', '01910000020', '7 Manufacturing Pl');

-- PART (20 records)
INSERT INTO Part (SupplierID, Name, Price) VALUES
(1, 'Oil Filter', 15.00),
(2, 'Brake Pad Set', 75.00),
(3, 'Air Filter', 20.00),
(4, 'Spark Plug', 10.00),
(5, 'Battery', 120.00),
(6, 'Tire', 100.00),
(7, 'Windshield Wiper', 25.00),
(8, 'Headlight Bulb', 30.00),
(9, 'Fuel Pump', 150.00),
(10, 'Radiator', 200.00),
(11, 'Clutch Kit', 300.00),
(12, 'Timing Belt', 180.00),
(13, 'Exhaust Pipe', 130.00),
(14, 'Brake Rotor', 90.00),
(15, 'Shock Absorber', 110.00),
(16, 'Alternator', 250.00),
(17, 'Starter Motor', 175.00),
(18, 'Air Conditioning Compressor', 400.00),
(19, 'Fuel Injector', 80.00),
(20, 'Engine Oil (5L)', 45.00);

-- BOOKINGPART (20 records - 1 per booking)
INSERT INTO BookingPart (BookingID, PartID, Quantity) VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 1), (4, 4, 4), (5, 5, 1),
(6, 6, 1), (7, 7, 2), (8, 8, 1), (9, 9, 1), (10, 10, 1),
(11, 11, 1), (12, 12, 1), (13, 13, 1), (14, 14, 1), (15, 15, 1),
(16, 16, 1), (17, 17, 1), (18, 18, 1), (19, 19, 1), (20, 20, 1);

-- PAYMENT (20 records - 1 per booking)
INSERT INTO Payment (BookingID, PaymentDate, Amount, Method, TransactionRef) VALUES
(1, '2025-07-01', 50.00, 'Cash', 'TXN001'),
(2, '2025-07-03', 80.00, 'Card', 'TXN002'),
(3, '2025-07-05', 40.00, 'Mobile Banking', 'TXN003'),
(4, '2025-08-01', 150.00, 'Cash', 'TXN004'),
(5, '2025-08-03', 120.00, 'Card', 'TXN005'),
(6, '2025-07-07', 200.00, 'Mobile Banking', 'TXN006'),
(7, '2025-07-09', 100.00, 'Cash', 'TXN007'),
(8, '2025-08-05', 90.00, 'Card', 'TXN008'),
(9, '2025-08-07', 70.00, 'Mobile Banking', 'TXN009'),
(10, '2025-07-11', 60.00, 'Cash', 'TXN010'),
(11, '2025-07-13', 85.00, 'Card', 'TXN011'),
(12, '2025-08-09', 130.00, 'Mobile Banking', 'TXN012'),
(13, '2025-07-15', 110.00, 'Cash', 'TXN013'),
(14, '2025-07-17', 250.00, 'Card', 'TXN014'),
(15, '2025-07-19', 300.00, 'Mobile Banking', 'TXN015'),
(16, '2025-07-21', 45.00, 'Cash', 'TXN016'),
(17, '2025-07-23', 90.00, 'Card', 'TXN017'),
(18, '2025-07-25', 75.00, 'Mobile Banking', 'TXN018'),
(19, '2025-07-27', 180.00, 'Cash', 'TXN019'),
(20, '2025-07-29', 60.00, 'Card', 'TXN020');






-- ==========================================================
-- VEHICLE SERVICE TRACKER - PRACTICE QUERIES
-- Covers: SELECT, GROUP BY, HAVING, JOINS, SUBQUERIES, 
-- VIEWS, TRIGGERS, TRANSACTIONS (with ACID), 
-- STORED PROCEDURES, Roles & Privileges
-- ==========================================================

USE VehicleServiceTracker;

-- ==========================================================
-- 1. BASIC SELECT with WHERE
-- Purpose: Retrieve vehicles from year 2020 or newer
-- ==========================================================
SELECT VehicleID, LicensePlate, Model, Year
FROM Vehicle
WHERE Year >= 2020;


-- ==========================================================
-- 2. SELECT with GROUP BY and HAVING
-- Purpose: Find mechanics with more than 2 bookings
-- ==========================================================
SELECT MechanicID, COUNT(*) AS TotalBookings
FROM ServiceBooking
GROUP BY MechanicID
HAVING COUNT(*) > 2;


-- ==========================================================
-- 3. INNER JOIN
-- Purpose: Booking details with customer, vehicle, and service type
-- ==========================================================
SELECT sb.BookingID, c.Name AS CustomerName, v.Model, st.Name AS ServiceName, sb.Status
FROM ServiceBooking sb
INNER JOIN Vehicle v ON sb.VehicleID = v.VehicleID
INNER JOIN Customer c ON v.CustomerID = c.CustomerID
INNER JOIN ServiceType st ON sb.ServiceTypeID = st.ServiceTypeID;


-- ==========================================================
-- 4. LEFT JOIN
-- Purpose: Show all mechanics and any bookings they have
-- ==========================================================
SELECT m.MechanicID, m.Name, sb.BookingID
FROM Mechanic m
LEFT JOIN ServiceBooking sb ON m.MechanicID = sb.MechanicID;


-- ==========================================================
-- 5. RIGHT JOIN
-- Purpose: Show all service types and the bookings (if any exist)
-- ==========================================================
SELECT st.Name AS ServiceType, sb.BookingID
FROM ServiceType st
RIGHT JOIN ServiceBooking sb ON st.ServiceTypeID = sb.ServiceTypeID;


-- ==========================================================
-- 6. SUBQUERY in WHERE
-- Purpose: Find customers who have booked more than 3 services
-- ==========================================================
SELECT Name, Phone
FROM Customer
WHERE CustomerID IN (
    SELECT v.CustomerID
    FROM Vehicle v
    JOIN ServiceBooking sb ON v.VehicleID = sb.VehicleID
    GROUP BY v.CustomerID
    HAVING COUNT(sb.BookingID) > 3
);


-- ==========================================================
-- 7. NESTED QUERY in SELECT
-- Purpose: Calculate total parts cost for each booking
-- ==========================================================
SELECT b.BookingID,
       (SELECT SUM(bp.Quantity * p.Price)
        FROM BookingPart bp
        JOIN Part p ON bp.PartID = p.PartID
        WHERE bp.BookingID = b.BookingID) AS PartsCost
FROM ServiceBooking b;


-- ==========================================================
-- 8. CREATE VIEW
-- Purpose: Store completed bookings with customer & mechanic info
-- ==========================================================
CREATE VIEW CompletedBookings AS
SELECT sb.BookingID, c.Name AS CustomerName, m.Name AS MechanicName, sb.PaymentAmount
FROM ServiceBooking sb
JOIN Vehicle v ON sb.VehicleID = v.VehicleID
JOIN Customer c ON v.CustomerID = c.CustomerID
JOIN Mechanic m ON sb.MechanicID = m.MechanicID
WHERE sb.Status = 'Completed';

SELECT * FROM CompletedBookings;

-- ==========================================================
-- 9. TRIGGER: Automatic Payment Calculation
-- Purpose: Set PaymentAmount from service type price before insert
-- ==========================================================
DELIMITER //
CREATE TRIGGER CalculatePaymentBeforeInsert
BEFORE INSERT ON ServiceBooking
FOR EACH ROW
BEGIN
    DECLARE service_price DECIMAL(10,2);
    SELECT Price INTO service_price
    FROM ServiceType
    WHERE ServiceTypeID = NEW.ServiceTypeID;
    SET NEW.PaymentAmount = service_price;
END;
//
DELIMITER ;

INSERT INTO ServiceBooking (VehicleID, ServiceTypeID, MechanicID, BookingDate, Status)
VALUES (1, 1, 1, CURDATE(), 'Pending');

-- Then check the inserted record's PaymentAmount
SELECT BookingID, PaymentAmount FROM ServiceBooking
WHERE BookingID = LAST_INSERT_ID();

-- ==========================================================
-- 10. TRANSACTION with ACID properties
-- Purpose: Create a booking and payment atomically, rollback on error
-- ==========================================================
DELIMITER //
CREATE PROCEDURE CreateBookingWithPayment()
BEGIN
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        -- Rollback in case of any error
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO ServiceBooking (VehicleID, ServiceTypeID, MechanicID, BookingDate, Status)
    VALUES (1, 2, 1, CURDATE(), 'Pending');

    INSERT INTO Payment (BookingID, PaymentDate, Amount, Method)
    VALUES (LAST_INSERT_ID(), CURDATE(), 150.00, 'Cash');

    COMMIT;
END;
//
DELIMITER ;

-- Example call:
CALL CreateBookingWithPayment();

-- Then verify the booking and payment created
SELECT * FROM ServiceBooking ORDER BY BookingID DESC LIMIT 1;
SELECT * FROM Payment ORDER BY PaymentID DESC LIMIT 1;



-- ==========================================================
-- 11. STORED PROCEDURE: Get bookings for a customer
-- Purpose: Retrieve booking list by customer ID
-- ==========================================================
DELIMITER //
CREATE PROCEDURE GetCustomerBookings(IN cust_id INT)
BEGIN
    SELECT sb.BookingID, st.Name AS ServiceName, sb.Status, sb.BookingDate
    FROM ServiceBooking sb
    JOIN Vehicle v ON sb.VehicleID = v.VehicleID
    JOIN ServiceType st ON sb.ServiceTypeID = st.ServiceTypeID
    WHERE v.CustomerID = cust_id;
END;
//
DELIMITER ;

-- Example call:

CALL GetCustomerBookings(1);

-- ==========================================================
-- 12. STORED PROCEDURE: Create booking with parts
-- Purpose: Insert booking and associated parts atomically
-- ==========================================================
DELIMITER //
CREATE PROCEDURE CreateBookingWithParts(
    IN veh_id INT,
    IN service_type INT,
    IN mech_id INT,
    IN booking_date DATE,
    IN part_id INT,
    IN qty INT
)
BEGIN
    DECLARE new_booking_id INT;
    DECLARE exit handler for SQLEXCEPTION
    BEGIN
        -- Rollback in case of any error
        ROLLBACK;
    END;
    
    START TRANSACTION;
    
    INSERT INTO ServiceBooking (VehicleID, ServiceTypeID, MechanicID, BookingDate)
    VALUES (veh_id, service_type, mech_id, booking_date);
    
    SET new_booking_id = LAST_INSERT_ID();
    
    INSERT INTO BookingPart (BookingID, PartID, Quantity)
    VALUES (new_booking_id, part_id, qty);
    
    COMMIT;
END;
//
DELIMITER ;

CALL CreateBookingWithParts(
    1,       -- VehicleID
    1,       -- ServiceTypeID
    1,       -- MechanicID
    CURDATE(), -- BookingDate
    1,       -- PartID
    2        -- Quantity
);

-- Check the newly inserted booking and booking parts
SELECT * FROM ServiceBooking ORDER BY BookingID DESC LIMIT 1;
SELECT * FROM BookingPart ORDER BY BookingID DESC LIMIT 1;

-- ==========================================================
-- 13. TRIGGER: Data Integrity
-- Purpose: Prevent negative payment amounts
-- ==========================================================
DELIMITER //
CREATE TRIGGER PreventNegativePayment
BEFORE INSERT ON Payment
FOR EACH ROW
BEGIN
    IF NEW.Amount < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Payment amount cannot be negative';
    END IF;
END;
//
DELIMITER ;

-- Intentional negative-payment test (uncomment to verify the trigger rejects it):
-- INSERT INTO Payment (BookingID, PaymentDate, Amount, Method)
-- VALUES (1, CURDATE(), -100.00, 'Cash');

-- ==========================================================
-- 14. ROLE and PRIVILEGE Example
-- Purpose: Grant basic booking permissions to service desk staff
-- ==========================================================
CREATE ROLE 'service_staff';
GRANT SELECT, INSERT, UPDATE ON VehicleServiceTracker.ServiceBooking TO 'service_staff';

-- Show grants for the role
SHOW GRANTS FOR 'service_staff';


-- ==========================================================
-- 15. COMPLEX QUERY with Multiple Joins + Grouping
-- Purpose: Show total revenue per mechanic from completed bookings
-- ==========================================================
SELECT m.MechanicID, m.Name,
       SUM(sb.PaymentAmount) AS TotalRevenue
FROM ServiceBooking sb
JOIN Mechanic m ON sb.MechanicID = m.MechanicID
WHERE sb.Status = 'Completed'
GROUP BY m.MechanicID, m.Name
ORDER BY TotalRevenue DESC;



