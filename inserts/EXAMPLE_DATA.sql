-- ============================================================
-- PharmaTrack: Prescription & Inventory Management System
-- File: 02_insert_data.sql
-- Purpose: Populate all tables with realistic sample data.
-- Run AFTER 01_create_schema.sql
-- Insert order: parent tables first, then children.
-- ============================================================

USE pharmatrack;

-- ============================================================
-- DOCTORS (8 rows)
-- ============================================================
INSERT INTO DOCTOR (FIRST_NAME, LAST_NAME, LICENSE_NUMBER, PHONE, EMAIL, CLINIC_NAME) VALUES
('James',   'Nguyen',    'TX-MD-10021', '9561234567', 'jnguyen@valleyclinic.com',    'Valley Family Clinic'),
('Maria',   'Torres',    'TX-MD-10022', '9562345678', 'mtorres@rgvhealth.com',       'RGV Health Center'),
('David',   'Patel',     'TX-MD-10023', '9563456789', 'dpatel@sunrisemed.com',       'Sunrise Medical Group'),
('Sandra',  'Williams',  'TX-MD-10024', '9564567890', 'swilliams@borderprimary.com', 'Border Primary Care'),
('Carlos',  'Reyes',     'TX-MD-10025', '9565678901', 'creyes@missionhealth.com',    'Mission Health Clinic'),
('Linda',   'Chen',      'TX-MD-10026', '9566789012', 'lchen@edinburgmed.com',       'Edinburg Medical Center'),
('Robert',  'Gomez',     'TX-MD-10027', '9567890123', 'rgomez@pahospital.com',       'PA Regional Hospital'),
('Angela',  'Flores',    'TX-MD-10028', '9568901234', 'aflores@harlingencare.com',   'Harlingen Care Associates');

-- ============================================================
-- PATIENTS (10 rows)
-- ============================================================
INSERT INTO PATIENT (FIRST_NAME, LAST_NAME, DATE_OF_BIRTH, PHONE, EMAIL, STREET, CITY, STATE, ZIP_CODE, ALLERGIES) VALUES
('Luis',    'Garza',     '1985-03-12', '9561112222', 'lgarza@email.com',    '101 Palm Ave',      'McAllen',    'TX', '78501', 'Penicillin'),
('Rosa',    'Martinez',  '1990-07-22', '9562223333', 'rmartinez@email.com', '202 Cactus Blvd',   'Edinburg',   'TX', '78539', NULL),
('Miguel',  'Lopez',     '1978-11-05', '9563334444', 'mlopez@email.com',    '303 Mesquite St',   'Mission',    'TX', '78572', 'Sulfa'),
('Diana',   'Salinas',   '2000-01-30', '9564445555', 'dsalinas@email.com',  '404 River Rd',      'Pharr',      'TX', '78577', NULL),
('Carlos',  'Vega',      '1965-09-18', '9565556666', 'cvega@email.com',     '505 Citrus Ln',     'McAllen',    'TX', '78504', 'Aspirin, NSAIDs'),
('Elena',   'Ramirez',   '1995-04-14', '9566667777', 'eramirez@email.com',  '606 Oak Dr',        'Weslaco',    'TX', '78596', NULL),
('Jorge',   'Hernandez', '1950-12-01', '9567778888', 'jhernandez@email.com','707 Pecan Blvd',    'Harlingen',  'TX', '78550', 'Codeine'),
('Patricia','Morales',   '1982-06-25', '9568889999', 'pmorales@email.com',  '808 Sunflower Ave', 'Brownsville','TX', '78520', NULL),
('Antonio', 'Cruz',      '1973-08-09', '9569990000', 'acruz@email.com',     '909 Magnolia St',   'McAllen',    'TX', '78503', 'Latex'),
('Sofia',   'Delgado',   '2005-02-17', '9560001111', 'sdelgado@email.com',  '1010 Cypress Rd',   'Edinburg',   'TX', '78542', NULL);

-- ============================================================
-- PHARMACISTS (5 rows)
-- ============================================================
INSERT INTO PHARMACIST (FIRST_NAME, LAST_NAME, LICENSE_NUMBER, PHONE, EMAIL) VALUES
('Rachel',  'Kim',       'TX-RPH-5501', '9561231111', 'rkim@pharmatrack.com'),
('Marco',   'Ruiz',      'TX-RPH-5502', '9562342222', 'mruiz@pharmatrack.com'),
('Tina',    'Nguyen',    'TX-RPH-5503', '9563453333', 'tnguyen@pharmatrack.com'),
('James',   'Okafor',    'TX-RPH-5504', '9564564444', 'jokafor@pharmatrack.com'),
('Sara',    'Castillo',  'TX-RPH-5505', '9565675555', 'scastillo@pharmatrack.com');

-- ============================================================
-- INVENTORY (10 rows)
-- Master list of drug types tracked by the pharmacy.
-- ============================================================
INSERT INTO INVENTORY (MEDICATION_NAME, NDC_CODE, GENERIC_NAME, DOSAGE_FORM, STRENGTH) VALUES
('Lisinopril',      '0093-1040-01', 'Lisinopril',           'Tablet',  '10mg'),
('Metformin',       '0093-1050-01', 'Metformin HCl',        'Tablet',  '500mg'),
('Atorvastatin',    '0071-0155-23', 'Atorvastatin Calcium', 'Tablet',  '20mg'),
('Amoxicillin',     '0093-2264-01', 'Amoxicillin',          'Capsule', '500mg'),
('Albuterol',       '0487-0901-01', 'Albuterol Sulfate',    'Inhaler', '90mcg'),
('Omeprazole',      '0093-7242-56', 'Omeprazole',           'Capsule', '20mg'),
('Amlodipine',      '0069-1520-66', 'Amlodipine Besylate',  'Tablet',  '5mg'),
('Sertraline',      '0049-4900-66', 'Sertraline HCl',       'Tablet',  '50mg'),
('Metoprolol',      '0378-0266-01', 'Metoprolol Tartrate',  'Tablet',  '25mg'),
('Gabapentin',      '0093-0238-01', 'Gabapentin',           'Capsule', '300mg');

-- ============================================================
-- MEDICATION (10 rows)
-- Specific physical stock lots tied to inventory entries.
-- ============================================================
INSERT INTO MEDICATION (INVENTORY_ID, LOT_NUMBER, EXPIRATION_DATE, QUANTITY_IN_STOCK, UNIT_PRICE, MANUFACTURER) VALUES
(1,  'LOT-A001', '2026-06-30', 200, 0.15, 'Teva Pharmaceuticals'),
(2,  'LOT-A002', '2026-08-31', 350, 0.10, 'Amneal Pharmaceuticals'),
(3,  'LOT-A003', '2025-12-31', 180, 0.25, 'Pfizer Inc.'),
(4,  'LOT-A004', '2026-03-31', 150, 0.20, 'Sandoz'),
(5,  'LOT-A005', '2026-09-30', 75,  4.50, 'GlaxoSmithKline'),
(6,  'LOT-A006', '2026-07-31', 220, 0.18, 'Dr. Reddys Laboratories'),
(7,  'LOT-A007', '2026-05-31', 300, 0.12, 'Mylan Pharmaceuticals'),
(8,  'LOT-A008', '2026-10-31', 160, 0.30, 'Greenstone LLC'),
(9,  'LOT-A009', '2026-04-30', 240, 0.14, 'Caraco Pharmaceutical'),
(10, 'LOT-A010', '2026-11-30', 190, 0.35, 'Actavis Pharma');

-- ============================================================
-- PRESCRIPTION (12 rows)
-- Each prescription links a doctor to a patient.
-- STATUS: 'Active', 'Filled', 'Expired', 'Cancelled'
-- ============================================================
INSERT INTO PRESCRIPTION (DOCTOR_ID, PATIENT_ID, DATE_ISSUED, REFILLS_REMAINING, STATUS) VALUES
(1, 1,  '2025-01-10', 3, 'Active'),
(2, 2,  '2025-01-15', 0, 'Filled'),
(3, 3,  '2025-02-01', 2, 'Active'),
(4, 4,  '2025-02-20', 1, 'Active'),
(5, 5,  '2025-03-05', 0, 'Filled'),
(6, 6,  '2025-03-18', 5, 'Active'),
(7, 7,  '2025-04-02', 0, 'Expired'),
(8, 8,  '2025-04-10', 2, 'Active'),
(1, 9,  '2025-05-01', 1, 'Active'),
(2, 10, '2025-05-15', 0, 'Cancelled'),
(3, 1,  '2025-06-01', 3, 'Active'),
(4, 3,  '2025-06-20', 2, 'Filled');

-- ============================================================
-- PRESCRIPTION_LINE (14 rows)
-- Links prescriptions to specific medications.
-- ============================================================
INSERT INTO PRESCRIPTION_LINE (PRESCRIPTION_ID, MEDICATION_ID, QUANTITY_PRESCRIBED, DOSAGE_INSTRUCTIONS) VALUES
(1,  1,  30, 'Take 1 tablet daily for blood pressure'),
(1,  2,  60, 'Take 1 tablet twice daily with meals'),
(2,  3,  30, 'Take 1 tablet daily at bedtime'),
(3,  4,  21, 'Take 1 capsule three times daily for 7 days'),
(4,  5,  1,  'Inhale 2 puffs every 4-6 hours as needed'),
(5,  6,  30, 'Take 1 capsule before breakfast'),
(6,  7,  30, 'Take 1 tablet daily for blood pressure'),
(6,  8,  30, 'Take 1 tablet daily in the morning'),
(7,  9,  60, 'Take 1 tablet twice daily'),
(8,  10, 90, 'Take 1 capsule three times daily'),
(9,  1,  30, 'Take 1 tablet daily'),
(10, 2,  60, 'Take 1 tablet twice daily with food'),
(11, 3,  30, 'Take 1 tablet daily'),
(12, 4,  14, 'Take 1 capsule twice daily for 7 days');

-- ============================================================
-- FILLS (10 rows)
-- Each row is one fill event processed by a pharmacist.
-- FILL_NUMBER 1 = original fill, 2+ = refills.
-- ============================================================
INSERT INTO FILLS (PRESCRIPTION_ID, PHARMACIST_ID, FILLS_DATE, FILL_NUMBER, NOTES) VALUES
(1,  1, '2025-01-11', 1, 'Initial fill, counseled patient on side effects'),
(2,  2, '2025-01-16', 1, 'Filled, no issues'),
(3,  3, '2025-02-02', 1, 'Counseled patient on antibiotic course'),
(4,  4, '2025-02-21', 1, 'Patient instructed on inhaler technique'),
(5,  5, '2025-03-06', 1, 'Filled with generic brand, patient notified'),
(6,  1, '2025-03-19', 1, 'Initial fill'),
(7,  2, '2025-04-03', 1, 'Filled'),
(8,  3, '2025-04-11', 1, 'Noted patient allergy to codeine in profile'),
(1,  4, '2025-02-11', 2, 'First refill, no changes'),
(6,  5, '2025-04-19', 2, 'Second fill, patient reported dizziness, flagged for pharmacist review');
