CREATE OR REPLACE FUNCTION GetMemberByName(
    firstName VARCHAR(50),
    lastName VARCHAR(50)
)
RETURNS INT
AS $$
DECLARE 
    memberID INT;
BEGIN
    SELECT UserID INTO memberID
    FROM Members
    WHERE FName = firstName AND LName = lastName
    LIMIT 1;
    
    RETURN memberID;
END;
$$
LANGUAGE plpgsql;

CREATE FUNCTION UserRegistration(
    FName VARCHAR(50),
    LName VARCHAR(50),
    Email VARCHAR(255),
    DateOfBirth DATE,
    Gender CHAR(1),
    HeightCM DECIMAL(5, 2),
    WeightKG DECIMAL(5, 2)
)
RETURNS BOOLEAN
AS $$
DECLARE 
    Completed BOOLEAN;
BEGIN
    INSERT INTO Members (FName, LName, Email, DateOfBirth, Gender, HeightCM, WeightKG, ActiveStatus)
	VALUES
	(FName, LName, Email, DateOfBirth, Gender, HeightCM, WeightKG, true);
    
    RETURN Completed;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION OpenDashboard(UserID INT) RETURNS VOID AS $$
DECLARE
    v_HeightCM DECIMAL(5, 2);
    v_WeightKG DECIMAL(5, 2);
BEGIN
    -- Retrieve height and weight 
    SELECT Members.HeightCM, Members.WeightKG
    INTO v_HeightCM, v_WeightKG
    FROM Members
    WHERE Members.UserID = OpenDashboard.UserID;
    
 
    RAISE NOTICE 'Height: % cm', v_HeightCM;
    RAISE NOTICE 'Weight: % kg', v_WeightKG;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION SetTrainer1(vTrainerID INT, StartTIME TIME, EndTIME TIME) RETURNS VOID AS $$
BEGIN
    UPDATE Trainers
    SET AvailabilityStart = StartTIME,
        AvailabilityEnd = EndTIME
    WHERE TrainerID = vTrainerID;
  
    RAISE NOTICE 'Trainer availability time updated for TrainerID: %', vTrainerID;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CancelBooking(User_ID INT, Booking_ID INT) RETURNS VOID AS $$
DECLARE
    ReceiptID INT;
BEGIN
    SELECT TransactionID INTO ReceiptID 
    FROM Receipt 
    WHERE UserID = User_ID AND Status = 'Paid' AND Number = '1' || Booking_ID;

    -- Refund the Receipt
    UPDATE Receipt 
    SET Status = 'Refunded' 
    WHERE TransactionID = Booking_ID;

    RAISE NOTICE 'Booking cancelled successfully!';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION RoomBooking(User_ID INT, Room_ID INT) RETURNS VOID AS $$
DECLARE
    BookingID INT;
BEGIN
    -- Check if the class is active and capacity
    IF EXISTS (SELECT 1 FROM Classes WHERE RoomID = Room_ID AND Active = TRUE AND Capacity > 0) THEN
        -- Decrement the capacity of the class
        UPDATE Classes
        SET Capacity = Capacity - 1
        WHERE RoomID = Room_ID;
        
        -- Insert a receipt 
        INSERT INTO Receipt (Date, UserID, Number, Status)
        VALUES (CURRENT_DATE, User_ID, 'B' || Room_ID || '-' || CURRENT_TIMESTAMP, 'Paid');
        
        
        SELECT INTO BookingID currval(pg_get_serial_sequence('receipt', 'transactionid'));
        
       
        RAISE NOTICE 'Booking successful! Capacity decremented for RoomID: %', Room_ID;
        RAISE NOTICE 'Receipt generated! BookingID: %', BookingID;
    ELSE
        RAISE EXCEPTION 'Class is not active or has no available capacity.';
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION MarkEquipmentChecked(Equipment_ID INT) RETURNS VOID AS $$
BEGIN
    -- Update the status of the equipment to 'Checked'
    UPDATE Equipment
    SET LastChecked = CURRENT_TIMESTAMP
    WHERE EquipmentID = Equipment_ID;
    
    -- Confirmation message
    RAISE NOTICE 'Equipment marked as checked successfully!';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION updateStats(
    p_userId INT,
    p_new_weight NUMERIC,
    p_new_height NUMERIC
)
RETURNS VOID
AS $$
BEGIN
    UPDATE members
    SET weightkg = p_new_weight,
        heightcm = p_new_height
    WHERE userId = p_userId;
END;
$$
LANGUAGE plpgsql;

