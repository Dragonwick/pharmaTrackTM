-- INSERT TRIGGER: prevents inserting a prescription_line that references an already expired medication
DELIMITER //
CREATE TRIGGER tr_prescription_line_ins
BEFORE INSERT
ON prescription_line
FOR EACH ROW
BEGIN
    -- If the medication referenced is expired, block the insert
    IF EXISTS (
        SELECT 1
        FROM medication
        WHERE medication_id = NEW.medication_id
          AND expiration_date < CURDATE()
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to insert prescription_line. Medication is expired.';
    END IF;
END //
DELIMITER ;

-- INSERT TRIGGER EXAMPLE STATEMENTS
INSERT INTO medication (inventory_id, lot_number, expiration_date, quantity_in_stock, unit_price, manufacturer)
VALUES (5, 'TEST-LOT-001', '2028-12-31', 100, 4.50, 'Acme Pharma');
SET @med_id = LAST_INSERT_ID();

INSERT INTO prescription (doctor_id, patient_id, date_issued, refills_remaining)
VALUES (1, 1, CURDATE(), 2);
SET @presc_id = LAST_INSERT_ID();

INSERT INTO prescription_line (prescription_id, medication_id, quantity_prescribed, dosage_instructions)
VALUES (@presc_id, @med_id, 30, 'Take one tablet daily');

-- UPDATE TRIGGER: does not allow patients to update their address to somewhere outside of Texas
DELIMITER //
CREATE TRIGGER tr_texas_only
BEFORE UPDATE ON patient
FOR EACH ROW
BEGIN
    IF NEW.state <> 'TX' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Patients must reside in the state of Texas (TX)';
    END IF;
END //
DELIMITER ;

-- UPDATE TRIGGER EXAMPLE STATEMENT
UPDATE patient
SET state = 'CA'
WHERE patient_id = 1;

-- DELETE TRIGGER: checks for a patients active prescriptions before deletion
DELIMITER //
CREATE TRIGGER tr_patient_pres
BEFORE DELETE
ON patient
FOR EACH ROW
BEGIN
	-- check if patient has any active prescriptions before deleting
    IF EXISTS(
		SELECT 1
         FROM prescription 
         WHERE patient_id = OLD.patient_id AND status = 'Active'
    ) THEN
		-- block delete
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Failed to delete patient. Patient has at least one active prescription.';
    END IF;
END //
DELIMITER ;

-- DELETE TRIGGER EXAMPLE STATEMENT
DELETE FROM patient
WHERE patient_id = 51;
