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

-- UPDATE TRIGGER: does not allow patients to update their address to somewhere outside of texas
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


