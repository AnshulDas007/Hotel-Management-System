# 🏨 Hotel Management System

A comprehensive **relational database system** for managing hotel operations including guest management, room reservations, staff assignments, service tracking, and payment processing.

## 📋 Overview

This project implements a fully normalized database schema that models the core operations of a hotel. It includes:

- **9 interconnected tables** with proper foreign key relationships
- **PL/SQL components** — triggers, functions, and stored procedures for business logic automation
- **Analytical queries** for reporting on guest spending, staff workloads, and reservation trends
- **Sample data** with 10 records per table for testing and demonstration

## 🗂️ Project Structure

```
Hotel Management System - DBMS/
│
├── DBMS Phase 2 Project.sql    # Complete MySQL schema + sample data
├── SQL tables.txt              # Oracle/PL*SQL table definitions
├── SQL Queries.txt             # 7 analytical queries (Oracle dialect)
├── PLSQL for project.txt       # Triggers, functions & procedures
├── ER Diagram.jpg              # Entity-Relationship diagram
├── DBMS Phase 2 Project.pdf    # Project report document
│
├── README.md                   # This file
├── Project_Requirements.md     # Project Requirements Document (PRD)
└── Project_Architecture.md     # Project Architecture Document
```

## 🗄️ Database Schema

| Table | Description |
|---|---|
| **Guest** | Guest personal details (name, contact, nationality, etc.) |
| **Room** | Room inventory (number, type, price, floor, view, status) |
| **Reservation** | Booking records linking guests to check-in/out dates |
| **ReservationRoom** | Junction table for many-to-many reservation ↔ room mapping |
| **Staff** | Hotel employee records (name, position, contact, hire date) |
| **Service** | Available hotel services (spa, laundry, room service, etc.) |
| **GuestService** | Junction table tracking which guests use which services |
| **StaffService** | Junction table mapping staff to the services they provide |
| **Payment** | Payment records (amount, method, status) linked to reservations |
| **RoomService** | Operational log of services delivered to specific rooms by staff |

## ⚙️ PL/SQL Components

| Component | Type | Description |
|---|---|---|
| `trg_update_room_status` | Trigger | Auto-updates room status (Occupied/Available) on reservation changes |
| `calculate_total_cost` | Function | Computes total reservation cost from nights × price per night |
| `assign_staff_to_service` | Procedure | Assigns a staff member to deliver a service to a room |
| `trg_assign_staff_to_service` | Trigger | Auto-assigns available staff when a guest requests a service |

## 🚀 Setup Instructions

### MySQL

```sql
-- Run the complete setup script
source DBMS\ Phase\ 2\ Project.sql;
```

This will create the `hotel` database, all 9 tables, and insert 10 sample records into each table.

### Oracle / PL*SQL

1. Run `SQL tables.txt` to create all tables
2. Run `PLSQL for project.txt` to create triggers, functions, and procedures
3. Use queries from `SQL Queries.txt` for analytics and reporting

## 📊 ER Diagram

The entity-relationship diagram (`ER Diagram.jpg`) visualizes all table relationships and cardinalities in the system.

## 📄 Documentation

- **[Project Requirements](Project_Requirements.md)** — Functional and non-functional requirements
- **[Project Architecture](Project_Architecture.md)** — Database schema design and system architecture
