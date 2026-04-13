-- list medications with their inventory details
SELECT m.medication_id, i.medication_name, m.quantity_in_stock, m.unit_price
FROM medication m
JOIN inventory i
ON m.inventory_id = i.inventory_id
ORDER BY i.medication_name;

-- list patients with prescriptions and their counts
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS "Patient Name", COUNT(pr.prescription_id) AS "Number of Prescriptions"
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
GROUP BY p.patient_id, p.first_name, p.last_name
ORDER BY "Number of Prescriptions" DESC, "Patient Name";

-- find patients with active prescription
SELECT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS "Patient Name", pr.prescription_id, pr.date_issued, pr.status
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
WHERE pr.status = "Active"
ORDER BY p.patient_id, pr.date_issued DESC;

-- find the medications with the highest and lowest quantity in stock
SELECT i.medication_name, m.quantity_in_stock
FROM medication m
JOIN inventory i
ON m.inventory_id = i.inventory_id
WHERE m.quantity_in_stock = (
    SELECT MAX(quantity_in_stock)
    FROM medication
)
OR m.quantity_in_stock = (
    SELECT MIN(quantity_in_stock)
    FROM medication
)
ORDER BY m.quantity_in_stock DESC, i.medication_name;

-- lists how many prescriptions each doctor has issued
SELECT d.doctor_id, CONCAT(d.first_name, ' ', d.last_name) AS "Doctor Name", COUNT(p.prescription_id) AS "Total Prescriptions"
FROM doctor d
LEFT JOIN prescription p
    ON d.doctor_id = p.doctor_id
GROUP BY d.doctor_id, "Doctor Name"
ORDER BY "Total Prescriptions" DESC;

-- lists the average quantity prescribed per medication
SELECT i.medication_name, AVG(pl.quantity_prescribed) AS "Average Quantity"
FROM prescription_line pl
JOIN medication m
    ON pl.medication_id = m.medication_id
JOIN inventory i
    ON m.inventory_id = i.inventory_id
GROUP BY i.medication_name
ORDER BY "Average Quantity" DESC;

-- lists the distinct allergy types across all patients
SELECT DISTINCT allergies
FROM patient
WHERE allergies IS NOT NULL AND allergies  != 'None'
ORDER BY allergies;

-- make a subquerey where we list patients who have never had a prescription filled
SELECT CONCAT(p.first_name, ' ', p.last_name) AS "Patient Name",
pr.prescription_id, pr.status
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
WHERE pr.prescription_id NOT IN (
	SELECT DISTINCT prescription_id FROM fills
)
ORDER BY "Patient Name";

-- find all patients who have been presrcibed a certain medication 
SELECT DISTINCT p.patient_id, CONCAT(p.first_name, ' ', p.last_name) AS "Patient Name"
FROM patient p
JOIN prescription pr ON p.patient_id = pr.patient_id
JOIN prescription_line pl ON pr.prescription_id = pl.prescription_id
JOIN medication m ON pl.medication_id = m.medication_id
JOIN inventory i ON m.inventory_id = i.inventory_id
WHERE i.medication_name = 'PRINIVIL';