SELECT * FROM inventory
JOIN medication ON inventory.inventory_id = medication.inventory_id;

-- list patients with prescriptions and their counts
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(pr.prescription_id) AS number_of_prescriptions
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY number_of_prescriptions DESC, patient_name;

-- find patients who currently have prescriptions using a subquery
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, pr.prescription_id, pr.date_issued, pr.status
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
WHERE pr.status = "Active"
ORDER BY p.patient_id, pr.date_issued DESC;

-- lists how many prescriptions each doctor has issued
SELECT d.doctor_id, CONCAT(d.first_name, ' ', d.last_name) AS doctor_name, COUNT(p.prescription_id) AS total_prescriptions
FROM doctor d
LEFT JOIN prescription p
    ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, doctor_name
ORDER BY total_prescriptions DESC;

-- lists the average quantity prescribed per medication
SELECT i.medication_name, AVG(pl.quantity_prescribed) AS avg_quantity
FROM prescription_line pl
JOIN medication m
    ON pl.medication_id = m.medication_id
JOIN inventory i
    ON m.inventory_id = i.inventory_id
GROUP BY i.medication_name
ORDER BY avg_quantity DESC;

-- aaron's queries
-- lists the distinct allergy types across all patients
SELECT DISTINCT allergies
FROM patient
WHERE allergies IS NOT NULL AND allergies  != 'None'
ORDER BY allergies;

-- make a subquerey where we list patients who have never had a prescription filled

-- find all patients who have been presrcibed a certain medication 
SELECT DISTINCT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS "Patient Name"
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
JOIN prescription_line pl ON pr.prescription_id = pl.prescription_id
JOIN medication m ON pl.medication_id = m.medication_id
JOIN inventory i ON m.inventory_id = i.inventory_id
WHERE i.medication_name = 'PRINIVIL';
