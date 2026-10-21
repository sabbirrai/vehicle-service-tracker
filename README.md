# Vehicle Service Tracker

A MySQL database project for managing vehicle servicing operations, including customers, vehicles, service types, mechanics, bookings, suppliers, spare parts, and payments.

## Features

- Relational schema with primary keys and foreign-key constraints
- Customer and vehicle records
- Service types, mechanics, and service bookings
- Supplier and spare-parts management
- Booking-to-parts relationship through a junction table
- Payment records and payment methods
- Sample data for practicing SQL
- `SELECT`, filtering, `GROUP BY`, `HAVING`, and joins
- Subqueries and nested queries
- Views for completed bookings
- Triggers for automatic service-price assignment and payment validation
- Stored procedures and transaction examples
- Example role and privilege statements

## Database Tables

- `Customer`
- `Vehicle`
- `ServiceType`
- `Mechanic`
- `ServiceBooking`
- `Supplier`
- `Part`
- `BookingPart`
- `Payment`

## Requirements

- MySQL 8.0 or a compatible MySQL server
- MySQL Workbench or another MySQL client

## How to Run

1. Download `vehicle_service_tracker.sql`.
2. Open it in MySQL Workbench.
3. Connect to your local MySQL server.
4. Review the script, then execute it.
5. Refresh the Schemas panel and select `VehicleServiceTracker`.

> **Important:** The script creates the `VehicleServiceTracker` database and inserts sample records. Review the SQL before running it on any database containing important data. The destructive `DROP DATABASE` command is disabled in this version.

## Notes

- The script contains example stored procedures, triggers, and role/privilege statements. Some statements may require suitable MySQL privileges.
- The negative-payment test is commented out so it does not intentionally interrupt a full script run. Uncomment it separately if you want to test the validation trigger.
- This is an academic/demo project using fictional sample data.

## Author

Sabbir Raihan

## License

For educational use. Add a specific open-source license if you want to grant formal reuse permissions.
