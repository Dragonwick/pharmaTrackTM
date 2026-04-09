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
