CREATE TABLE Equipment (
    EquipmentID SERIAL PRIMARY KEY,
    EquipmentName VARCHAR(100) NOT NULL,
    Description TEXT,
    Location VARCHAR(100),
    PurchaseDate DATE,
    LastChecked TIMESTAMP
);

CREATE TABLE Bookings (
    BookingID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Members(UserID),
    RoomID INT REFERENCES Classes(RoomID),
    BookingDate DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Trainers (
    TrainerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(255),
    Phone VARCHAR(20),
    AvailabilityStart TIME,
    AvailabilityEnd TIME
);

CREATE TABLE Classes (
	RoomID INT PRIMARY KEY,
	Capacity INT,
	Trainer VARCHAR(255),
	Active BOOLEAN
)

CREATE TABLE Members (
    UserID INT PRIMARY KEY,
    FName VARCHAR(50) NOT NULL,
    LName VARCHAR(50) NOT NULL,
    Email VARCHAR(255),
    DateOfBirth DATE,
    Gender CHAR(1),
    HeightCM DECIMAL(5, 2),
    WeightKG DECIMAL(5, 2),
    ActiveStatus BOOLEAN
);

CREATE TABLE Receipt (
    TransactionID SERIAL PRIMARY KEY,
    Date DATE,
    UserID INT REFERENCES Members(UserID),
    Number VARCHAR(100),
    Status VARCHAR(50)
);
