INSERT INTO Members (UserID, FName, LName, Email, DateOfBirth, Gender, HeightCM, WeightKG, ActiveStatus)
VALUES
(1, 'John', 'Doe', 'johndoe@example.com', '1990-05-15', 'M', 175.5, 75.2, true);

INSERT INTO Trainers (TrainerID, Name, Email, Phone, AvailabilityStart, AvailabilityEnd)
VALUES
(1, 'Alice Smith', 'alice.smith@example.com', '123-456-7890', '09:00:00', '17:00:00');

INSERT INTO Classes (RoomID, Capacity, Trainer, Active)
VALUES
(1, 20, 'Alice Smith', true),
(2, 15, 'Bob Johnson', true),
(3, 30, 'Eve Anderson', false);

INSERT INTO Equipment (EquipmentName, Description, Location, PurchaseDate, LastChecked)
VALUES
    ('Treadmill', 'Cardio machine for running or walking', 'Gym Floor', '2023-01-01', CURRENT_TIMESTAMP),
    ('Barbell', 'Weightlifting equipment', 'Weightlifting Area', '2023-03-01', NULL),
    ('Dumbbell Set', 'Set of dumbbells of different weights', 'Weightlifting Area', '2022-02-15', NULL),