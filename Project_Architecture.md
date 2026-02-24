# Project Architecture Document — Hotel Management System

## 1. System Overview

The Hotel Management System is a **relational database project** that models hotel operations through a normalized schema of 9 interconnected tables, supported by PL/SQL triggers, functions, and stored procedures for business logic automation.

```
+---------------------------------------------+
|           Hotel Management System            |
+---------------------------------------------+
|                                              |
|  +----------+   +------+   +-----------+    |
|  |  Guests  |-->| Res. |<--| Rooms     |    |
|  +----------+   +------+   +-----------+    |
|       |              |                       |
|       v              v                       |
|  +---------+   +----------+   +---------+   |
|  | Services|   | Payments |   |  Staff  |   |
|  +---------+   +----------+   +---------+   |
|       |                            |         |
|       +------- RoomService --------+         |
|                                              |
+---------------------------------------------+
|  PL/SQL: Triggers | Functions | Procedures   |
+---------------------------------------------+
```

---

## 2. Database Schema Design

### 2.1 Core Entity Tables

#### Guest
| Column | Type | Constraints |
|---|---|---|
| guestID | INT / NUMBER | PRIMARY KEY |
| name | VARCHAR(100) | NOT NULL |
| contactNo | VARCHAR(15) | NOT NULL |
| email | VARCHAR(100) | NOT NULL, UNIQUE |
| address | TEXT / VARCHAR2(100) | NOT NULL |
| dob | DATE | NOT NULL |
| nationality | VARCHAR(50) | NOT NULL |

#### Room
| Column | Type | Constraints |
|---|---|---|
| roomID | INT / NUMBER | PRIMARY KEY |
| roomNum | INT / NUMBER | NOT NULL |
| type | VARCHAR(50) | NOT NULL — Single, Double, Suite |
| pricePerNight | DECIMAL(10,2) / NUMBER(10,2) | NOT NULL |
| status | VARCHAR(20) | NOT NULL — Available, Occupied, Under Maintenance |
| floor | INT / NUMBER | NOT NULL |
| view | VARCHAR(50) | NULLABLE — Sea, Garden, City |

#### Staff
| Column | Type | Constraints |
|---|---|---|
| staffID | INT / NUMBER | PRIMARY KEY |
| name | VARCHAR(100) | NOT NULL |
| position | VARCHAR(50) | NOT NULL |
| contactNum | VARCHAR(15) | NOT NULL, UNIQUE |
| email | VARCHAR(100) | NOT NULL, UNIQUE |
| hireDate | DATE | NULLABLE |

#### Service
| Column | Type | Constraints |
|---|---|---|
| serviceID | INT / NUMBER | PRIMARY KEY |
| serviceType | VARCHAR(50) | NOT NULL |
| description | TEXT / CLOB | NOT NULL |
| price | DECIMAL(10,2) / NUMBER(10,2) | NOT NULL |

### 2.2 Transaction Tables

#### Reservation
| Column | Type | Constraints |
|---|---|---|
| reservationID / resID | INT / NUMBER | PRIMARY KEY |
| guestID | INT / NUMBER | FK → Guest |
| roomID | INT / NUMBER | FK → Room *(Oracle version)* |
| checkInDate | DATE | — |
| checkOutDate | DATE | — |
| numberOfGuests | INT | *(MySQL version)* |
| specialRequests | TEXT | *(MySQL version)* |
| status | VARCHAR(20) | NOT NULL *(Oracle version)* |
| totalAmount | NUMBER(10,2) | NOT NULL *(Oracle version)* |

> **Note:** The MySQL and Oracle schemas have minor structural differences in the Reservation table. The MySQL version stores `numberOfGuests` and `specialRequests`, while the Oracle version stores `status` and `totalAmount` directly.

#### Payment
| Column | Type | Constraints |
|---|---|---|
| paymentID | INT / NUMBER | PRIMARY KEY |
| reservationID | INT / NUMBER | FK → Reservation |
| guestID | INT / NUMBER | FK → Guest |
| paymentDate | DATE | — |
| amt | DECIMAL(10,2) / NUMBER(10,2) | NOT NULL |
| paymentMethod | VARCHAR(50) | NOT NULL — Credit Card, Cash, Bank Transfer, UPI |
| status | VARCHAR(20) | NOT NULL — Completed, Pending, Failed |

### 2.3 Junction Tables

| Table | Keys | Purpose |
|---|---|---|
| **ReservationRoom** | PK(`reservationID`, `roomID`) | Many-to-many: Reservation ↔ Room |
| **GuestService** | PK(`guestID`, `serviceID`) | Many-to-many: Guest ↔ Service |
| **StaffService** | PK(`staffID`, `serviceID`) | Many-to-many: Staff ↔ Service |

### 2.4 Operational Log Table

#### RoomService
| Column | Type | Constraints |
|---|---|---|
| roomServiceID | INT / NUMBER | PRIMARY KEY |
| roomID | INT / NUMBER | FK → Room |
| serviceID | INT / NUMBER | FK → Service |
| staffID | INT / NUMBER | FK → Staff |
| serviceDate | DATE | NOT NULL |
| serviceDetails | TEXT / CLOB | NOT NULL |

---

## 3. Entity Relationships

```
Guest (1) ──────< (M) Reservation (M) >────── (1) Room
  │                        │                      │
  │                        │                      │
  │ (M)                    │ (1)                   │ (M)
  v                        v                      v
GuestService (M)       Payment (M)          RoomService (M)
  │                                               │
  │ (1)                                            │ (1)
  v                                               v
Service (1) ─────────────────────────────── StaffService (M)
                                                  │
                                                  │ (1)
                                                  v
                                              Staff (1)
```

### Cardinality Summary

| Relationship | Type |
|---|---|
| Guest → Reservation | One-to-Many |
| Reservation ↔ Room (via ReservationRoom) | Many-to-Many |
| Guest ↔ Service (via GuestService) | Many-to-Many |
| Staff ↔ Service (via StaffService) | Many-to-Many |
| Reservation → Payment | One-to-Many |
| Guest → Payment | One-to-Many |
| Room + Service + Staff → RoomService | Many-to-One (convergent) |

---

## 4. PL/SQL Components

### 4.1 Triggers

#### `trg_update_room_status`
- **Fires:** AFTER INSERT OR UPDATE OF `status` ON `Reservation`
- **Logic:** Sets room status to `Occupied` when reservation is `Confirmed`; sets to `Available` when `Checked Out` or `Cancelled`
- **Purpose:** Eliminates manual room status updates

#### `trg_assign_staff_to_service`
- **Fires:** AFTER INSERT ON `GuestService`
- **Logic:** Finds the first available staff member for the requested service, locates the guest's confirmed room, then calls `assign_staff_to_service` procedure
- **Error handling:** Catches `NO_DATA_FOUND` (no staff available) and generic exceptions

### 4.2 Function

#### `calculate_total_cost(p_reservation_id)`
- **Returns:** NUMBER (total cost)
- **Logic:** Joins Reservation and Room tables, computes `(checkOutDate - checkInDate) × pricePerNight`
- **Output:** Prints calculation breakdown via `DBMS_OUTPUT`

### 4.3 Procedure

#### `assign_staff_to_service(p_staff_id, p_service_id, p_room_id, p_service_date, p_service_details)`
- **Action:** Inserts a new record into `RoomService` using `RoomService_seq.NEXTVAL` for the primary key
- **Note:** Does not issue a COMMIT (designed to be called from triggers)

---

## 5. Data Flow

### Reservation Flow
```
Guest registers → Makes Reservation → Reservation linked to Room(s) via ReservationRoom
     │                    │
     │                    └──> trg_update_room_status fires → Room.status updated
     │
     └──> Payment recorded against Reservation
```

### Service Delivery Flow
```
Guest requests Service → GuestService record created
     │
     └──> trg_assign_staff_to_service fires
               │
               ├──> Finds available Staff from StaffService
               ├──> Finds Guest's confirmed Room from Reservation
               └──> Calls assign_staff_to_service procedure
                          │
                          └──> RoomService record created (operational log)
```

---

## 6. Analytical Queries

The system includes 7 pre-built analytical queries:

| # | Query | Key Tables |
|---|---|---|
| 1 | Total reservation cost for confirmed bookings | Reservation, Guest, Room |
| 2 | Room status update simulation (trigger test) | Reservation |
| 3 | Staff-to-service assignment (procedure test) | RoomService |
| 4 | High-spending guest details (> $1000) | Guest, Reservation, Payment, Service |
| 5 | Service history and cost per reservation | Reservation, ReservationRoom, RoomService, Staff |
| 6 | Longest cumulative stay across reservations | Guest, Reservation |
| 7 | Staff member handling the most services | Staff, RoomService, Service |

---

## 7. ER Diagram

The complete Entity-Relationship diagram is available in `ER Diagram.jpg` at the project root.
