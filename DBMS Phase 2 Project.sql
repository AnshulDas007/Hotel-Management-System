create database hotel;
use hotel;


-- Guest Table
CREATE TABLE Guest (
    guestID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contactNo VARCHAR(15) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address TEXT NOT NULL,
    dob DATE NOT NULL,
    nationality VARCHAR(50) NOT NULL
);


-- Room Table
CREATE TABLE Room (
    roomID INT PRIMARY KEY,
    roomNum INT NOT NULL,
    type VARCHAR(50) NOT NULL, -- Single, Double, Suite
    pricePerNight DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL, -- Available, Occupied, Under Maintenance
    floor INT NOT NULL,
    view VARCHAR(50) -- Sea, Garden, City
);

-- Reservation Table
CREATE TABLE Reservation (
    reservationID INT PRIMARY KEY,
    guestID INT,
    checkInDate DATE,
    checkOutDate DATE,
    numberOfGuests INT,
    specialRequests TEXT,
    FOREIGN KEY (guestID) REFERENCES Guest(guestID) ON DELETE CASCADE
);

-- Junction Table for Reservation and Room (Many-to-Many relationship)
CREATE TABLE ReservationRoom (
    reservationID INT,
    roomID INT,
    PRIMARY KEY (reservationID, roomID),
    FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID) ON DELETE CASCADE,
    FOREIGN KEY (roomID) REFERENCES Room(roomID) ON DELETE CASCADE
);

--  Staff Table
CREATE TABLE Staff (
    staffID INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL, -- Manager, Housekeeping, Receptionist, Chef, etc.
    contactNum VARCHAR(15) NOT NULL unique,
    email VARCHAR(100) NOT NULL unique,
    hireDate DATE
);

-- Service Table
CREATE TABLE Service (
    serviceID INT PRIMARY KEY,
    serviceType VARCHAR(50) NOT NULL, -- Room Service, Laundry, Spa, etc.
    description TEXT NOT NULL,
    price DECIMAL(10, 2) NOT NULL
);

-- Junction Table for Guest and Service (Many-to-Many relationship)
CREATE TABLE GuestService (
    guestID INT,
    serviceID INT,
    PRIMARY KEY (guestID, serviceID),
    FOREIGN KEY (guestID) REFERENCES Guest(guestID) ON DELETE CASCADE,
    FOREIGN KEY (serviceID) REFERENCES Service(serviceID) ON DELETE CASCADE
);

-- Junction Table for Staff and Service (Many-to-Many relationship)
CREATE TABLE StaffService (
    staffID INT,
    serviceID INT,
    PRIMARY KEY (staffID, serviceID),
    FOREIGN KEY (staffID) REFERENCES Staff(staffID) ON DELETE CASCADE,
    FOREIGN KEY (serviceID) REFERENCES Service(serviceID) ON DELETE CASCADE
);

-- Payment Table
CREATE TABLE Payment (
    paymentID INT PRIMARY KEY,
    reservationID INT,
    guestID INT,
    paymentDate DATE,
    amt DECIMAL(10, 2) NOT NULL,
    paymentMethod VARCHAR(50) NOT NULL, -- Credit Card, Cash, Bank Transfer, UPI
    status VARCHAR(20) NOT NULL, -- Completed, Pending, Failed
    FOREIGN KEY (reservationID) REFERENCES Reservation(reservationID) ON DELETE CASCADE,
    FOREIGN KEY (guestID) REFERENCES Guest(guestID) ON DELETE CASCADE
);

-- Room Service Table
CREATE TABLE RoomService (
    roomServiceID INT PRIMARY KEY,
    roomID INT,
    serviceID INT,
    staffID INT,
    serviceDate DATE NOT NULL,
    serviceDetails TEXT NOT NULL,
    FOREIGN KEY (roomID) REFERENCES Room(roomID) ON DELETE CASCADE,
    FOREIGN KEY (serviceID) REFERENCES Service(serviceID) ON DELETE CASCADE,
    FOREIGN KEY (staffID) REFERENCES Staff(staffID) ON DELETE CASCADE
);

-- Insert expanded dummy data into Guest table
INSERT INTO Guest (guestID, name, contactNo, email, address, dob, nationality)
VALUES 
(101, 'John Doe', '1234567890', 'johndoe@example.com', '123 Elm Street, Springfield', '1985-06-15', 'American'),
(102, 'Jane Smith', '0987654321', 'janesmith@example.com', '456 Oak Avenue, Metropolis', '1990-04-22', 'British'),
(103, 'Carlos Rivera', '5551234567', 'carlosr@example.com', '789 Maple Road, Gotham', '1978-12-10', 'Spanish'),
(104, 'Emily Davis', '3334445555', 'emilyd@example.com', '101 Pine Street, Smallville', '1995-02-14', 'Canadian'),
(105, 'Michael Brown', '1112223333', 'michaelb@example.com', '202 Birch Avenue, Star City', '1982-09-18', 'Australian'),
(106, 'Sophia Green', '9876543210', 'sophiag@example.com', '404 Cedar Lane, Central City', '1987-11-30', 'German'),
(107, 'David Wilson', '5554443333', 'davidw@example.com', '505 Fir Street, Coast City', '1993-07-08', 'Brazilian'),
(108, 'Ava Martinez', '2223334444', 'avam@example.com', '606 Spruce Road, Keystone City', '1989-03-25', 'Mexican'),
(109, 'Daniel Lee', '4445556666', 'daniell@example.com', '707 Redwood Blvd, National City', '1975-05-20', 'Korean'),
(110, 'Olivia Harris', '7778889999', 'oliviah@example.com', '808 Palm Avenue, Hill Valley', '1992-01-01', 'Indian');

-- Insert expanded dummy data into Room table
INSERT INTO Room (roomID, roomNum, type, pricePerNight, status, floor, view)
VALUES 
(101, 101, 'Single', 150.00, 'Available', 1, 'Sea'),
(102, 102, 'Double', 200.00, 'Occupied', 1, 'Garden'),
(103, 201, 'Suite', 350.00, 'Under Maintenance', 2, 'City'),
(104, 202, 'Single', 150.00, 'Available', 2, 'Sea'),
(105, 203, 'Double', 220.00, 'Occupied', 2, 'City'),
(106, 301, 'Suite', 400.00, 'Available', 3, 'Garden'),
(107, 302, 'Double', 210.00, 'Under Maintenance', 3, 'Sea'),
(108, 303, 'Single', 170.00, 'Available', 3, 'Garden'),
(109, 401, 'Suite', 450.00, 'Available', 4, 'City'),
(110, 402, 'Double', 230.00, 'Occupied', 4, 'Sea');

-- Insert expanded dummy data into Reservation table
INSERT INTO Reservation (reservationID, guestID, checkInDate, checkOutDate, numberOfGuests, specialRequests)
VALUES 
(101, 101, '2024-10-01', '2024-10-05', 1, 'No smoking room'),
(102, 102, '2024-10-10', '2024-10-15', 2, 'Extra pillows'),
(103, 103, '2024-09-20', '2024-09-25', 1, 'Late check-in'),
(104, 104, '2024-08-05', '2024-08-10', 3, 'Baby cot required'),
(105, 105, '2024-07-15', '2024-07-20', 2, 'High floor requested'),
(106, 106, '2024-06-12', '2024-06-18', 1, 'Vegetarian meals'),
(107, 107, '2024-05-01', '2024-05-07', 4, 'Connecting rooms'),
(108, 108, '2024-04-18', '2024-04-23', 2, 'Early check-in requested'),
(109, 109, '2024-03-10', '2024-03-15', 3, 'Quiet room'),
(110, 110, '2024-02-25', '2024-03-01', 1, 'Airport transfer');

-- Insert expanded dummy data into ReservationRoom table
INSERT INTO ReservationRoom (reservationID, roomID)
VALUES 
(101, 101),
(102, 102),
(103, 103),
(104, 104),
(105, 105),
(106, 106),
(107, 107),
(108, 108),
(109, 109),
(110, 110);

-- Insert expanded dummy data into Staff table
INSERT INTO Staff (staffID, name, position, contactNum, email, hireDate)
VALUES 
(101, 'Alice Johnson', 'Manager', '3216549870', 'alicej@example.com', '2020-03-01'),
(102, 'Bob Lee', 'Housekeeping', '6549873210', 'boblee@example.com', '2019-07-15'),
(103, 'Chris King', 'Receptionist', '1237894560', 'chrisk@example.com', '2018-05-21'),
(104, 'Diana Prince', 'Chef', '3217896541', 'dianap@example.com', '2021-11-12'),
(105, 'Ethan White', 'Maintenance', '9876541230', 'ethanw@example.com', '2017-08-25'),
(106, 'Fiona Black', 'Spa Therapist', '4561237890', 'fionab@example.com', '2022-02-14'),
(107, 'George Taylor', 'Bartender', '7893216540', 'georget@example.com', '2020-12-10'),
(108, 'Hannah Scott', 'Security', '9632587410', 'hannahs@example.com', '2019-03-08'),
(109, 'Ian Brown', 'Housekeeping', '7418529630', 'ianb@example.com', '2016-10-18'),
(110, 'Jessica Adams', 'Concierge', '8529637410', 'jessicaa@example.com', '2021-04-04');

-- Insert expanded dummy data into Service table
INSERT INTO Service (serviceID, serviceType, description, price)
VALUES 
(101, 'Room Service', 'Food and beverage delivered to the room', 25.00),
(102, 'Laundry', 'Clothes washing and ironing', 15.00),
(103, 'Spa', 'Massage and relaxation services', 50.00),
(104, 'Gym', 'Access to fitness center', 10.00),
(105, 'Parking', 'Valet parking service', 20.00),
(106, 'Babysitting', 'Childcare services', 30.00),
(107, 'Tour', 'Guided city tour', 40.00),
(108, 'WiFi', 'High-speed internet access', 5.00),
(109, 'Mini Bar', 'Refreshments in room', 20.00),
(110, 'Dry Cleaning', 'Clothes dry cleaning service', 18.00);

-- Insert expanded dummy data into GuestService table
INSERT INTO GuestService (guestID, serviceID)
VALUES 
(101, 101),
(102, 102),
(103, 103),
(104, 104),
(105, 105),
(106, 106),
(107, 107),
(108, 108),
(109, 109),
(110, 110);

-- Insert expanded dummy data into StaffService table
INSERT INTO StaffService (staffID, serviceID)
VALUES 
(101, 101),
(102, 102),
(103, 103),
(104, 104),
(105, 105),
(106, 106),
(107, 107),
(108, 108),
(109, 109),
(110, 110);

-- Insert expanded dummy data into Payment table
INSERT INTO Payment (paymentID, reservationID, guestID, paymentDate, amt, paymentMethod, status)
VALUES 
(101, 101, 101, '2024-10-05', 600.00, 'UPI', 'Completed'),
(102, 102, 102, '2024-10-15', 1000.00, 'Cash', 'Pending'),
(103, 103, 103, '2024-09-25', 750.00, 'UPI', 'Completed'),
(104, 104, 104, '2024-08-10', 1200.00, 'Bank Transfer', 'Completed'),
(105, 105, 105, '2024-07-20', 950.00, 'Credit Card', 'Completed'),
(106, 106, 106, '2024-06-18', 400.00, 'Credit Card', 'Completed'),
(107, 107, 107, '2024-05-07', 1500.00, 'UPI', 'Pending'),
(108, 108, 108, '2024-04-23', 850.00, 'UPI', 'Completed'),
(109, 109, 109, '2024-03-15', 1100.00, 'Bank Transfer', 'Completed'),
(110, 110, 110, '2024-03-01', 700.00, 'Credit Card', 'Completed');

-- Insert expanded dummy data into RoomService table
INSERT INTO RoomService (roomServiceID, roomID, serviceID, staffID, serviceDate, serviceDetails)
VALUES 
(101, 101, 101, 101, '2024-10-03', 'Breakfast order'),
(102, 102, 102, 102, '2024-10-11', 'Laundry service for guest'),
(103, 103, 103, 103, '2024-09-22', 'Spa service'),
(104, 104, 104, 104, '2024-08-08', 'Gym session setup'),
(105, 105, 105, 105, '2024-07-17', 'Valet parking'),
(106, 106, 106, 106, '2024-06-15', 'Babysitting service'),
(107, 107, 107, 107, '2024-05-04', 'City tour arrangement'),
(108, 108, 108, 108, '2024-04-21', 'WiFi setup'),
(109, 109, 109, 109, '2024-03-13', 'Mini bar refill'),
(110, 110, 110, 110, '2024-02-28', 'Dry cleaning delivery');