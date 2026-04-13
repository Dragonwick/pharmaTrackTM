-- stored procedure: get_patient_summary
-- given a patient ID, returns all prescriptions for
-- 	that patient along with the medications prescribed
--  and the current status of each prescription.
-- inpu:  p_patient_id (INT) - the ID of the patient to look up
-- usage:  CALL get_patient_summary(1);

USE pharmatrack;

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
