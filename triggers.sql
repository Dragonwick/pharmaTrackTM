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

-- UPDATE TRIGGER: updates a patient's address
DELIMITER //
CREATE TRIGGER update_address
BEFORE UPDATE ON patient
FOR EACH ROW
BEGIN 
	SET NEW.street = NEW.street;
    SET NEW.city = NEW.city;
    SET NEW.zip_code = NEW.zip_code;                
END //
DELIMITER ;
