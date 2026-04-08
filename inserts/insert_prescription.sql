-- ============================================================
-- PharmaTrack: Prescription Data Insert
-- File: insert_prescription.sql
-- Tables: PRESCRIPTION, PRESCRIPTION_LINE, FILLS
-- Notes:
--   - DOCTOR_ID range:      1–20
--   - PATIENT_ID range:     1–200
--   - MEDICATION_ID range:  1–50
--   - PHARMACIST_ID range:  1–20
--   - Allergy conflicts avoided (Ibuprofen→MED 2, Acetaminophen→MED 1,
--     Penicillin→MED 48 & MED 3)
--   - STATUS values: 'Active', 'Filled', 'Expired', 'Cancelled'
-- ============================================================

USE pharmatrack;

-- ============================================================
-- PRESCRIPTION (50 records)
-- ============================================================
INSERT INTO PRESCRIPTION (PRESCRIPTION_ID, DOCTOR_ID, PATIENT_ID, DATE_ISSUED, REFILLS_REMAINING, STATUS) VALUES
(1,   1,  1,  '2025-01-15', 2, 'Active'),
(2,   2,  2,  '2025-02-20', 0, 'Filled'),
(3,   3,  3,  '2025-03-10', 1, 'Active'),
(4,   4,  4,  '2024-11-05', 0, 'Expired'),
(5,   5,  5,  '2025-04-01', 3, 'Active'),
(6,   6,  6,  '2025-05-12', 0, 'Filled'),
(7,   7,  7,  '2024-12-20', 0, 'Cancelled'),
(8,   8,  8,  '2025-06-18', 2, 'Active'),
(9,   9,  9,  '2025-07-07', 0, 'Filled'),
(10,  10, 10, '2025-08-14', 1, 'Active'),
(11,  11, 11, '2025-09-22', 0, 'Filled'),
(12,  12, 12, '2024-10-30', 0, 'Expired'),
(13,  13, 13, '2025-10-05', 2, 'Active'),
(14,  14, 14, '2025-11-11', 0, 'Filled'),
(15,  15, 15, '2025-12-01', 5, 'Active'),
(16,  16, 16, '2025-01-08', 0, 'Filled'),
(17,  17, 17, '2025-02-14', 1, 'Active'),
(18,  18, 18, '2025-03-25', 0, 'Filled'),
(19,  19, 19, '2025-04-30', 0, 'Cancelled'),
(20,  20, 20, '2025-05-17', 3, 'Active'),
(21,   1, 21, '2025-06-05', 0, 'Filled'),
(22,   2, 22, '2025-07-20', 2, 'Active'),
(23,   3, 23, '2025-08-09', 0, 'Filled'),
(24,   4, 24, '2025-09-15', 0, 'Expired'),
(25,   5, 25, '2025-10-22', 1, 'Active'),
(26,   6, 26, '2025-11-03', 0, 'Filled'),
(27,   7, 27, '2025-12-18', 4, 'Active'),
(28,   8, 28, '2026-01-07', 0, 'Filled'),
(29,   9, 29, '2026-01-25', 2, 'Active'),
(30,  10, 30, '2026-02-10', 0, 'Filled'),
(31,  11, 31, '2026-02-28', 0, 'Cancelled'),
(32,  12, 32, '2026-03-05', 1, 'Active'),
(33,  13, 33, '2026-03-15', 0, 'Filled'),
(34,  14, 34, '2026-03-20', 3, 'Active'),
(35,  15, 35, '2026-03-25', 0, 'Filled'),
(36,  16, 36, '2026-03-28', 0, 'Active'),
(37,  17, 37, '2026-04-01', 2, 'Active'),
(38,  18, 38, '2026-04-03', 0, 'Filled'),
(39,  19, 39, '2026-04-05', 0, 'Active'),
(40,  20, 40, '2026-04-07', 1, 'Active'),
(41,   1, 41, '2025-01-20', 0, 'Filled'),
(42,   2, 42, '2025-02-28', 0, 'Expired'),
(43,   3, 43, '2025-03-12', 2, 'Active'),
(44,   4, 44, '2025-04-18', 0, 'Filled'),
(45,   5, 45, '2025-05-22', 1, 'Active'),
(46,   6, 46, '2025-06-30', 0, 'Filled'),
(47,   7, 47, '2025-07-14', 0, 'Cancelled'),
(48,   8, 48, '2025-08-20', 3, 'Active'),
(49,   9, 49, '2025-09-05', 0, 'Filled'),
(50,  10, 50, '2025-10-10', 2, 'Active');

-- ============================================================
-- PRESCRIPTION_LINE (~90 records)
-- Allergy notes per patient referenced below:
--   Pt  2 (Grass),  Pt  4 (Aspirin), Pt  5 (Ibuprofen→avoid MED 2),
--   Pt 11 (Ibuprofen→avoid MED 2), Pt 12 (Penicillin→avoid MED 3,48),
--   Pt 13 (Acetaminophen→avoid MED 1), Pt 18 (Aspirin),
--   Pt 19 (Penicillin→avoid MED 3,48), Pt 20 (Ibuprofen→avoid MED 2),
--   Pt 22 (Aspirin), Pt 28 (Penicillin→avoid MED 3,48),
--   Pt 33 (Penicillin→avoid MED 3,48), Pt 34 (Aspirin),
--   Pt 39 (Acetaminophen→avoid MED 1), Pt 49 (Ibuprofen→avoid MED 2),
--   Pt 50 (Acetaminophen→avoid MED 1)
-- ============================================================
INSERT INTO PRESCRIPTION_LINE (PRESCRIPTION_ID, MEDICATION_ID, QUANTITY_PRESCRIBED, DOSAGE_INSTRUCTIONS) VALUES
-- Rx 1 – Pt 1 (Shellfish): Lisinopril + Atorvastatin
(1,  4,  30, 'Take 1 tablet daily for blood pressure'),
(1,  6,  30, 'Take 1 tablet daily in the evening for cholesterol'),

-- Rx 2 – Pt 2 (Grass): Metformin for diabetes
(2,  5,  60, 'Take 1 tablet twice daily with meals'),

-- Rx 3 – Pt 3 (None): Omeprazole + Metoprolol
(3,  13, 30, 'Take 1 capsule daily before breakfast'),
(3,  38, 30, 'Take 1 tablet daily for heart rate'),

-- Rx 4 – Pt 4 (Aspirin): Lisinopril only (no aspirin-class meds)
(4,  4,  30, 'Take 1 tablet daily'),

-- Rx 5 – Pt 5 (Ibuprofen – avoid MED 2): Atorvastatin + Metformin + Lisinopril
(5,  6,  30, 'Take 1 tablet daily for cholesterol'),
(5,  5,  60, 'Take 1 tablet twice daily with meals'),
(5,  4,  30, 'Take 1 tablet daily for blood pressure'),

-- Rx 6 – Pt 6 (Grass): Sertraline for depression
(6,  15, 30, 'Take 1 tablet daily in the morning'),

-- Rx 7 – Pt 7 (Peanuts): Gabapentin (cancelled, included for record completeness)
(7,  26, 60, 'Take 1 capsule three times daily for nerve pain'),

-- Rx 8 – Pt 8 (Latex): Omeprazole + Levothyroxine
(8,  13, 30, 'Take 1 capsule daily before breakfast'),
(8,  9,  30, 'Take 1 tablet daily on an empty stomach'),

-- Rx 9 – Pt 9 (Latex): Albuterol inhaler
(9,  49,  1, 'Use 2 puffs every 4–6 hours as needed for shortness of breath'),

-- Rx 10 – Pt 10 (Grass): Metformin + Insulin Glargine
(10, 5,  60, 'Take 1 tablet twice daily with meals'),
(10, 31, 10, 'Inject 10 units subcutaneously at bedtime'),

-- Rx 11 – Pt 11 (Ibuprofen – avoid MED 2): Fluoxetine
(11, 14, 30, 'Take 1 capsule daily in the morning'),

-- Rx 12 – Pt 12 (Penicillin – avoid MED 3,48): Azithromycin + Prednisone
(12, 43, 6,  'Take 1 tablet daily for 5 days (Z-pack)'),
(12, 41, 21, 'Take as directed; taper dose over 3 weeks'),

-- Rx 13 – Pt 13 (Acetaminophen – avoid MED 1): Lisinopril + Losartan
(13, 4,  30, 'Take 1 tablet daily for blood pressure'),
(13, 8,  30, 'Take 1 tablet daily for blood pressure'),

-- Rx 14 – Pt 14 (Latex): Sertraline + Omeprazole
(14, 15, 30, 'Take 1 tablet daily'),
(14, 13, 30, 'Take 1 capsule daily before breakfast'),

-- Rx 15 – Pt 15 (Bees): Lisinopril + Metoprolol + Warfarin
(15, 4,  30, 'Take 1 tablet daily for blood pressure'),
(15, 38, 30, 'Take 1 tablet daily for heart rate'),
(15, 12, 30, 'Take 1 tablet daily; monitor INR regularly'),

-- Rx 16 – Pt 16 (None): Atorvastatin
(16, 6,  30, 'Take 1 tablet daily in the evening'),

-- Rx 17 – Pt 17 (Shellfish): Metformin + Amlodipine
(17, 5,  60, 'Take 1 tablet twice daily with meals'),
(17, 7,  30, 'Take 1 tablet daily for blood pressure'),

-- Rx 18 – Pt 18 (Aspirin): Omeprazole
(18, 13, 30, 'Take 1 capsule daily before breakfast'),

-- Rx 19 – Pt 19 (Penicillin – avoid MED 3,48): Furosemide (cancelled)
(19, 34, 30, 'Take 1 tablet daily in the morning'),

-- Rx 20 – Pt 20 (Ibuprofen – avoid MED 2): Lisinopril + Metformin + Levothyroxine
(20, 4,  30, 'Take 1 tablet daily'),
(20, 5,  60, 'Take 1 tablet twice daily with meals'),
(20, 9,  30, 'Take 1 tablet daily on an empty stomach'),

-- Rx 21 – Pt 21 (Bees): Fluoxetine
(21, 14, 30, 'Take 1 capsule daily in the morning'),

-- Rx 22 – Pt 22 (Aspirin): Atorvastatin + Metoprolol
(22, 6,  30, 'Take 1 tablet daily in the evening'),
(22, 38, 30, 'Take 1 tablet daily'),

-- Rx 23 – Pt 23 (Bees): Doxycycline
(23, 46, 14, 'Take 1 capsule twice daily for 7 days'),

-- Rx 24 – Pt 24 (Pollen): Escitalopram (expired)
(24, 16, 30, 'Take 1 tablet daily in the morning'),

-- Rx 25 – Pt 25 (Ants): Gabapentin + Tramadol
(25, 26, 90, 'Take 1 capsule three times daily for nerve pain'),
(25, 23, 30, 'Take 1 tablet every 6 hours as needed for pain'),

-- Rx 26 – Pt 26 (Ants): Ciprofloxacin
(26, 44, 14, 'Take 1 tablet twice daily for 7 days'),

-- Rx 27 – Pt 27 (None): Metformin + Lisinopril + Atorvastatin
(27, 5,  60, 'Take 1 tablet twice daily with meals'),
(27, 4,  30, 'Take 1 tablet daily'),
(27, 6,  30, 'Take 1 tablet daily in the evening'),

-- Rx 28 – Pt 28 (Penicillin – avoid MED 3,48): Warfarin
(28, 12, 30, 'Take 1 tablet daily; monitor INR weekly'),

-- Rx 29 – Pt 29 (Grass): Amlodipine + Hydrochlorothiazide
(29, 7,  30, 'Take 1 tablet daily for blood pressure'),
(29, 35, 30, 'Take 1 tablet daily in the morning'),

-- Rx 30 – Pt 30 (Peanuts): Furosemide + Digoxin
(30, 34, 30, 'Take 1 tablet daily in the morning'),
(30, 40, 30, 'Take 1 tablet daily; monitor heart rate'),

-- Rx 31 – Pt 31 (Pollen): Sertraline (cancelled)
(31, 15, 30, 'Take 1 tablet daily in the morning'),

-- Rx 32 – Pt 32 (Ants): Levothyroxine
(32, 9,  30, 'Take 1 tablet daily on an empty stomach'),

-- Rx 33 – Pt 33 (Penicillin – avoid MED 3,48): Azithromycin
(33, 43, 6,  'Take 1 tablet daily for 5 days'),

-- Rx 34 – Pt 34 (Aspirin): Metformin + Losartan
(34, 5,  60, 'Take 1 tablet twice daily with meals'),
(34, 8,  30, 'Take 1 tablet daily'),

-- Rx 35 – Pt 35 (Bees): Omeprazole + Clopidogrel
(35, 13, 30, 'Take 1 capsule daily before breakfast'),
(35, 11, 30, 'Take 1 tablet daily to prevent blood clots'),

-- Rx 36 – Pt 36 (None): Escitalopram + Bupropion
(36, 16, 30, 'Take 1 tablet daily in the morning'),
(36, 30, 30, 'Take 1 tablet daily; avoid alcohol'),

-- Rx 37 – Pt 37 (Peanuts): Metoprolol + Lisinopril
(37, 38, 30, 'Take 1 tablet daily'),
(37, 4,  30, 'Take 1 tablet daily for blood pressure'),

-- Rx 38 – Pt 38 (Latex): Sertraline
(38, 15, 30, 'Take 1 tablet daily in the morning'),

-- Rx 39 – Pt 39 (Acetaminophen – avoid MED 1): Prednisone
(39, 41, 10, 'Take as directed; do not stop abruptly'),

-- Rx 40 – Pt 40 (Ants): Albuterol + Ventolin (backup inhaler)
(40, 49,  1, 'Use 2 puffs every 4–6 hours as needed'),
(40, 50,  1, 'Use as directed by physician'),

-- Rx 41 – Pt 41 (Latex): Escitalopram
(41, 16, 30, 'Take 1 tablet daily in the morning'),

-- Rx 42 – Pt 42 (Peanuts): Metformin (expired)
(42, 5,  60, 'Take 1 tablet twice daily with meals'),

-- Rx 43 – Pt 43 (Bees): Amoxicillin (no penicillin allergy)
(43, 3,  21, 'Take 1 capsule three times daily for 7 days'),

-- Rx 44 – Pt 44 (Latex): Prednisone + Azithromycin
(44, 41, 6,  'Take as directed; short-course burst'),
(44, 43, 6,  'Take 1 tablet daily for 5 days'),

-- Rx 45 – Pt 45 (Peanuts): Albuterol
(45, 49,  1, 'Use 2 puffs every 4–6 hours as needed for wheezing'),

-- Rx 46 – Pt 46 (None): Lisinopril + Atorvastatin
(46, 4,  30, 'Take 1 tablet daily for blood pressure'),
(46, 6,  30, 'Take 1 tablet daily in the evening'),

-- Rx 47 – Pt 47 (Ants): Omeprazole (cancelled)
(47, 13, 30, 'Take 1 capsule daily before breakfast'),

-- Rx 48 – Pt 48 (Grass): Sertraline + Alprazolam
(48, 15, 30, 'Take 1 tablet daily'),
(48, 20, 30, 'Take 0.5 mg as needed for anxiety; max 3x daily'),

-- Rx 49 – Pt 49 (Ibuprofen – avoid MED 2): Levothyroxine
(49, 9,  30, 'Take 1 tablet daily on an empty stomach'),

-- Rx 50 – Pt 50 (Acetaminophen – avoid MED 1): Metformin + Metoprolol
(50, 5,  60, 'Take 1 tablet twice daily with meals'),
(50, 38, 30, 'Take 1 tablet daily for heart rate');

-- ============================================================
-- FILLS
-- Fill records exist for all non-Cancelled prescriptions.
-- Cancelled RxIDs (no fills): 7, 19, 31, 47
-- Expired RxIDs may have had fills before expiration: 4, 12, 24, 42
-- Active RxIDs with prior fills (fill_number = 1 shows first fill):
--   1, 3, 5, 8, 10, 13, 15, 17, 20, 22, 25, 27, 29, 32, 34, 36,
--   37, 39, 40, 43, 45, 48, 50
-- ============================================================
INSERT INTO FILLS (PRESCRIPTION_ID, PHARMACIST_ID, FILLS_DATE, FILL_NUMBER, NOTES) VALUES
-- Filled prescriptions (STATUS = 'Filled')
(2,   3,  '2025-02-21', 1, 'Original fill dispensed'),
(6,   7,  '2025-05-13', 1, 'Original fill dispensed'),
(9,   1,  '2025-07-08', 1, 'Patient counseled on inhaler technique'),
(11,  5,  '2025-09-23', 1, 'Original fill dispensed'),
(14,  9,  '2025-11-12', 1, 'Patient counseled on sertraline side effects'),
(16,  2,  '2025-01-09', 1, 'Original fill dispensed'),
(18,  11, '2025-03-26', 1, 'Original fill dispensed'),
(21,  6,  '2025-06-06', 1, 'Original fill dispensed'),
(23,  14, '2025-08-10', 1, 'Short-course antibiotic; patient counseled'),
(26,  4,  '2025-11-04', 1, 'Original fill dispensed; patient counseled on side effects'),
(28,  8,  '2026-01-08', 1, 'INR baseline documented; patient counseled on warfarin diet'),
(30,  15, '2026-02-11', 1, 'Original fill dispensed'),
(33,  3,  '2026-03-16', 1, 'Short-course antibiotic dispensed'),
(35,  10, '2026-03-26', 1, 'Original fill dispensed'),
(38,  17, '2026-04-04', 1, 'Original fill dispensed'),
(41,  12, '2025-01-21', 1, 'Original fill dispensed'),
(44,  20, '2025-04-19', 1, 'Steroid burst + antibiotic combo dispensed'),
(46,  6,  '2025-07-01', 1, 'Original fill dispensed'),
(49,  2,  '2025-09-06', 1, 'Original fill dispensed'),

-- Expired prescriptions (had fills before expiration)
(4,   16, '2024-11-06', 1, 'Original fill dispensed before expiration'),
(12,  7,  '2024-10-31', 1, 'Original fill dispensed; prescription subsequently expired'),
(24,  9,  '2025-09-16', 1, 'Original fill dispensed; prescription subsequently expired'),
(42,  13, '2025-03-01', 1, 'Original fill dispensed before expiration'),

-- Active prescriptions – first fill already dispensed
(1,   18, '2025-01-16', 1, 'Original fill dispensed'),
(3,   4,  '2025-03-11', 1, 'Original fill dispensed'),
(5,   1,  '2025-04-02', 1, 'Original fill dispensed; patient counseled on metformin GI effects'),
(8,   19, '2025-06-19', 1, 'Original fill dispensed'),
(10,  5,  '2025-08-15', 1, 'Original fill dispensed; insulin injection technique reviewed'),
(13,  16, '2025-10-06', 1, 'Original fill dispensed'),
(15,  3,  '2025-12-02', 1, 'Original fill dispensed; INR monitoring schedule set'),
(17,  11, '2025-02-15', 1, 'Original fill dispensed'),
(20,  8,  '2025-05-18', 1, 'Original fill dispensed'),
(22,  20, '2025-07-21', 1, 'Original fill dispensed'),
(25,  14, '2025-10-23', 1, 'Tramadol – Schedule IV; photo ID verified'),
(27,  7,  '2025-12-19', 1, 'Original fill dispensed'),
(29,  2,  '2026-01-26', 1, 'Original fill dispensed'),
(32,  15, '2026-03-06', 1, 'Original fill dispensed'),
(34,  9,  '2026-03-21', 1, 'Original fill dispensed'),
(36,  6,  '2026-03-29', 1, 'Original fill dispensed; patient counseled on bupropion'),
(37,  4,  '2026-04-02', 1, 'Original fill dispensed'),
(43,  18, '2025-03-13', 1, 'Amoxicillin dispensed; patient counseled to finish course'),
(45,  1,  '2025-05-23', 1, 'Patient counseled on rescue inhaler use'),
(48,  12, '2025-08-21', 1, 'Alprazolam – Schedule IV; photo ID verified'),
(50,  17, '2025-10-11', 1, 'Original fill dispensed');
