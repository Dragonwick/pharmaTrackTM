SELECT * FROM INVENTORY
JOIN MEDICATION ON INVENTORY.INVENTORY_ID = MEDICATION.INVENTORY_ID;

-- list patients with prescriptions and their counts
SELECT p.PATIENT_ID, CONCAT(p.FIRST_NAME, ' ', p.LAST_NAME) AS patient_name, COUNT(pr.PRESCRIPTION_ID) AS number_of_prescriptions
FROM patient p
JOIN prescription pr ON p.PATIENT_ID = pr.PATIENT_ID
GROUP BY p.PATIENT_ID, p.FIRST_NAME, p.LAST_NAME
ORDER BY number_of_prescriptions DESC, patient_name;

-- find patients who currently have prescriptions using a subquery
SELECT p.PATIENT_ID, CONCAT(p.FIRST_NAME, ' ', p.LAST_NAME) AS patient_name, pr.PRESCRIPTION_ID, pr.DATE_ISSUED, pr.STATUS
FROM patient p
JOIN prescription pr ON p.PATIENT_ID = pr.PATIENT_ID
WHERE pr.STATUS = "Active"
ORDER BY p.PATIENT_ID, pr.DATE_ISSUED DESC;

-- lists how many prescriptions each doctor has issued
SELECT d.DOCTOR_ID, CONCAT(d.FIRST_NAME, ' ', d.LAST_NAME) AS doctor_name, COUNT(p.PRESCRIPTION_ID) AS total_prescriptions
FROM DOCTOR d
LEFT JOIN PRESCRIPTION p
    ON d.DOCTOR_ID = p.DOCTOR_ID
GROUP BY d.DOCTOR_ID, doctor_name
ORDER BY total_prescriptions DESC;

-- lists the average quantity prescribed per medication
SELECT i.MEDICATION_NAME, AVG(pl.QUANTITY_PRESCRIBED) AS avg_quantity
FROM PRESCRIPTION_LINE pl
JOIN MEDICATION m
    ON pl.MEDICATION_ID = m.MEDICATION_ID
JOIN INVENTORY i
    ON m.INVENTORY_ID = i.INVENTORY_ID
GROUP BY i.MEDICATION_NAME
ORDER BY avg_quantity DESC;
