# Project Requirements Document — Hotel Management System

## 1. Project Objective

Design and implement a relational database system that models and supports the core operations of a hotel, including guest management, room inventory, reservations, service delivery, staff assignments, and payment processing.

## 2. Scope

This project covers the **database layer** of a hotel management system. It provides the schema, data integrity constraints, stored procedures, triggers, and analytical queries needed to power a hotel's day-to-day operations. It does **not** include a frontend application or API layer.

---

## 3. Functional Requirements

### 3.1 Guest Management
| ID | Requirement |
|---|---|
| FR-01 | Store guest details: name, contact number, email, address, date of birth, nationality |
| FR-02 | Enforce unique email addresses across all guests |
| FR-03 | Support cascading deletes — removing a guest removes their reservations, payments, and service records |

### 3.2 Room Management
| ID | Requirement |
|---|---|
| FR-04 | Track room inventory with room number, type (Single/Double/Suite), price per night, floor, and view (Sea/Garden/City) |
| FR-05 | Maintain room status: Available, Occupied, Under Maintenance |
| FR-06 | Automatically update room status when reservation status changes (via trigger) |

### 3.3 Reservation Management
| ID | Requirement |
|---|---|
| FR-07 | Create reservations linking a guest to check-in/out dates with special requests |
| FR-08 | Support many-to-many mapping between reservations and rooms (a reservation can span multiple rooms) |
| FR-09 | Calculate total reservation cost based on number of nights × price per night (via function) |

### 3.4 Service Management
| ID | Requirement |
|---|---|
| FR-10 | Maintain a catalog of hotel services (Room Service, Laundry, Spa, Gym, Parking, etc.) with descriptions and prices |
| FR-11 | Track which guests have used which services (many-to-many) |
| FR-12 | Log room service deliveries with date, staff assigned, and service details |

### 3.5 Staff Management
| ID | Requirement |
|---|---|
| FR-13 | Store staff records: name, position, contact number, email, hire date |
| FR-14 | Enforce unique contact numbers and emails for staff |
| FR-15 | Map staff members to the services they are qualified to provide (many-to-many) |
| FR-16 | Auto-assign available staff to services requested by guests (via trigger + procedure) |

### 3.6 Payment Management
| ID | Requirement |
|---|---|
| FR-17 | Record payments linked to both a reservation and a guest |
| FR-18 | Support multiple payment methods: Credit Card, Cash, Bank Transfer, UPI |
| FR-19 | Track payment status: Completed, Pending, Failed |

---

## 4. Non-Functional Requirements

| ID | Requirement |
|---|---|
| NFR-01 | **Referential Integrity** — All foreign keys enforce ON DELETE CASCADE to maintain consistency |
| NFR-02 | **Data Validation** — NOT NULL constraints on critical fields; UNIQUE constraints on emails and contact numbers |
| NFR-03 | **Normalization** — Schema is in 3NF with junction tables resolving many-to-many relationships |
| NFR-04 | **Portability** — Schema provided in both MySQL and Oracle/PL*SQL dialects |
| NFR-05 | **Automation** — Business logic handled by triggers and stored procedures to reduce manual intervention |

---

## 5. Database Entities

| Entity | Primary Key | Key Relationships |
|---|---|---|
| Guest | `guestID` | → Reservation, Payment, GuestService |
| Room | `roomID` | → ReservationRoom, RoomService |
| Reservation | `reservationID` / `resID` | → Guest (FK), ReservationRoom, Payment |
| ReservationRoom | (`reservationID`, `roomID`) | → Reservation (FK), Room (FK) |
| Staff | `staffID` | → StaffService, RoomService |
| Service | `serviceID` | → GuestService, StaffService, RoomService |
| GuestService | (`guestID`, `serviceID`) | → Guest (FK), Service (FK) |
| StaffService | (`staffID`, `serviceID`) | → Staff (FK), Service (FK) |
| Payment | `paymentID` | → Reservation (FK), Guest (FK) |
| RoomService | `roomServiceID` | → Room (FK), Service (FK), Staff (FK) |

---

## 6. Key Use Cases

1. **Book a Room** — A guest makes a reservation for one or more rooms with check-in/out dates and special requests.
2. **Check In / Check Out** — Updating reservation status auto-triggers room status changes (Occupied ↔ Available).
3. **Request a Service** — A guest requests a service; the system auto-assigns an available staff member.
4. **Process Payment** — A payment is recorded against a reservation with method and status tracking.
5. **Generate Reports** — Analytical queries identify high-spending guests, longest-staying guests, and busiest staff members.
