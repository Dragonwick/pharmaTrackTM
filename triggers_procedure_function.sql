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

-- UPDATE TRIGGER: prevents from updating patient addresses to out of state
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

-- stored procedure: get_patient_summary
-- given a patient ID, returns all prescriptions for that patient along with the medications prescribed and the current status of each prescription.
-- input:  p_patient_id (INT) - the ID of the patient to look up
-- usage:  CALL get_patient_summary(1);

DROP PROCEDURE IF EXISTS get_patient_summary;

DELIMITER //

CREATE PROCEDURE get_patient_summary(IN p_patient_id INT)
BEGIN
    SELECT
        CONCAT(p.first_name, ' ', p.last_name) AS "Patient Name",
        pr.prescription_id,
        pr.date_issued,
        pr.status,
        pr.refills_remaining,
        i.medication_name,
        pl.dosage_instructions
    FROM patient p
    JOIN prescription pr ON p.patient_id = pr.patient_id
    JOIN prescription_line pl ON pr.prescription_id = pl.prescription_id
    JOIN medication m ON pl.medication_id = m.medication_id
    JOIN inventory i ON m.inventory_id = i.inventory_id
    WHERE p.patient_id = p_patient_id
    ORDER BY pr.date_issued DESC;
END //

DELIMITER ;

-- this is an example to retrieve full prescription summary for patient ID 1 (Kevin Browning)
CALL get_patient_summary(1);

-- funtion: get_prescription_total
-- 	given a prescription id, calculate the total cost of all medicaitons on that prescription by multiplying quantity prescribed by unit price for each medicaiton.
-- 	input : p_prescription_id (INT) - the prescription to calculate
-- 	output: DECIMAL (10, 2) - this is the total cost of the prescription
-- 	usage: SELECT get_prescription_total(1)

DROP FUNCTION IF EXISTS get_prescription_total;

DELIMITER //

CREATE FUNCTION get_prescription_total(p_prescription_id INT)
RETURNS DECIMAL (10, 2)
DETERMINISTIC
BEGIN
	DECLARE total DECIMAL (10,2);
    
	SELECT SUM(pl.quantity_prescribed * m.unit_price)
    INTO total
    FROM prescription_line pl
    JOIN medication m ON pl.medication_id = m.medication_id
    WHERE pl.prescription_id = p_prescription_id;
    
    RETURN total;
END //
DELIMITER ;

-- example to calculate the total cost of prescription ID 1
SELECT get_prescription_total(1) AS "Prescription Total";