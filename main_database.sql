-- ============================================================
-- PharmaTrack: Prescription & Inventory Management System
-- File: 01_create_schema.sql
-- Purpose: Create all tables, primary keys, foreign keys,
--          and constraints for the PharmaTrack database.
-- Order matters: parent tables must be created before children.
-- ============================================================

DROP DATABASE IF EXISTS pharmatrack;
CREATE DATABASE pharmatrack;
USE pharmatrack;

-- ============================================================
-- TABLE 1: DOCTOR
-- Stores prescribing doctors and their contact/clinic info.
-- ============================================================
CREATE TABLE DOCTOR (
    DOCTOR_ID       INT             AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME      VARCHAR(50)     NOT NULL,
    LAST_NAME       VARCHAR(50)     NOT NULL,
    LICENSE_NUMBER  VARCHAR(20)     NOT NULL UNIQUE,
    PHONE           VARCHAR(15)     NOT NULL,
    EMAIL           VARCHAR(100),
    CLINIC_NAME     VARCHAR(100)
);

-- ============================================================
-- TABLE 2: PATIENT
-- Stores patient demographics, contact info, and allergies.
-- ============================================================
CREATE TABLE PATIENT (
    PATIENT_ID      INT             AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME      VARCHAR(50)     NOT NULL,
    LAST_NAME       VARCHAR(50)     NOT NULL,
    DATE_OF_BIRTH   DATE            NOT NULL,
    PHONE           VARCHAR(15)     NOT NULL,
    EMAIL           VARCHAR(100),
    STREET          VARCHAR(100),
    CITY            VARCHAR(50),
    STATE           CHAR(2),
    ZIP_CODE        VARCHAR(10),
    ALLERGIES       TEXT            -- NULL means no known allergies
);

-- ============================================================
-- TABLE 3: PHARMACIST
-- Stores licensed pharmacists who process prescription fills.
-- ============================================================
CREATE TABLE PHARMACIST (
    PHARMACIST_ID   INT             AUTO_INCREMENT PRIMARY KEY,
    FIRST_NAME      VARCHAR(50)     NOT NULL,
    LAST_NAME       VARCHAR(50)     NOT NULL,
    LICENSE_NUMBER  VARCHAR(20)     NOT NULL UNIQUE,
    PHONE           VARCHAR(15)     NOT NULL,
    EMAIL           VARCHAR(100)
);

-- ============================================================
-- TABLE 4: INVENTORY
-- Master catalog of medications tracked by the pharmacy.
-- NDC_CODE (National Drug Code) is unique per medication type.
-- ============================================================
CREATE TABLE INVENTORY (
    INVENTORY_ID    INT             AUTO_INCREMENT PRIMARY KEY,
    MEDICATION_NAME VARCHAR(100)    NOT NULL,
    NDC_CODE        VARCHAR(20)     NOT NULL UNIQUE,
    GENERIC_NAME    VARCHAR(100),
    DOSAGE_FORM     VARCHAR(50),    -- e.g., Tablet, Capsule, Liquid
    STRENGTH        VARCHAR(50)     -- e.g., 500mg, 10mg/5mL
);

-- ============================================================
-- TABLE 5: MEDICATION
-- Represents specific physical stock of a medication.
-- Each row is a unique lot tied to an INVENTORY entry.
-- ============================================================
CREATE TABLE MEDICATION (
    MEDICATION_ID       INT             AUTO_INCREMENT PRIMARY KEY,
    INVENTORY_ID        INT             NOT NULL,
    LOT_NUMBER          VARCHAR(50)     NOT NULL,
    EXPIRATION_DATE     DATE            NOT NULL,
    QUANTITY_IN_STOCK   INT             NOT NULL DEFAULT 0,
    UNIT_PRICE          DECIMAL(10,2)   NOT NULL,
    MANUFACTURER        VARCHAR(100),

    CONSTRAINT fk_medication_inventory
        FOREIGN KEY (INVENTORY_ID) REFERENCES INVENTORY(INVENTORY_ID)
);

-- ============================================================
-- TABLE 6: PRESCRIPTION
-- Represents a prescription issued by a doctor for a patient.
-- STATUS values: 'Active', 'Filled', 'Expired', 'Cancelled'
-- ============================================================
CREATE TABLE PRESCRIPTION (
    PRESCRIPTION_ID     INT             AUTO_INCREMENT PRIMARY KEY,
    DOCTOR_ID           INT             NOT NULL,
    PATIENT_ID          INT             NOT NULL,
    DATE_ISSUED         DATE            NOT NULL,
    REFILLS_REMAINING   INT             NOT NULL DEFAULT 0,
    STATUS              VARCHAR(20)     NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_prescription_doctor
        FOREIGN KEY (DOCTOR_ID) REFERENCES DOCTOR(DOCTOR_ID),
    CONSTRAINT fk_prescription_patient
        FOREIGN KEY (PATIENT_ID) REFERENCES PATIENT(PATIENT_ID)
);

-- ============================================================
-- TABLE 7: PRESCRIPTION_LINE (Junction Table)
-- Resolves the M:N relationship between PRESCRIPTION and MEDICATION.
-- Each row = one medication on a given prescription.
-- Composite PK: (PRESCRIPTION_ID, MEDICATION_ID)
-- ============================================================
CREATE TABLE PRESCRIPTION_LINE (
    PRESCRIPTION_ID     INT             NOT NULL,
    MEDICATION_ID       INT             NOT NULL,
    QUANTITY_PRESCRIBED INT             NOT NULL,
    DOSAGE_INSTRUCTIONS VARCHAR(255),

    PRIMARY KEY (PRESCRIPTION_ID, MEDICATION_ID),

    CONSTRAINT fk_pl_prescription
        FOREIGN KEY (PRESCRIPTION_ID) REFERENCES PRESCRIPTION(PRESCRIPTION_ID),
    CONSTRAINT fk_pl_medication
        FOREIGN KEY (MEDICATION_ID) REFERENCES MEDICATION(MEDICATION_ID)
);

-- ============================================================
-- TABLE 8: FILLS (Associative Entity)
-- Resolves the M:N relationship between PRESCRIPTION and PHARMACIST.
-- Tracks each individual fill event (original + refills).
-- ============================================================
CREATE TABLE FILLS (
    FILLS_ID            INT             AUTO_INCREMENT PRIMARY KEY,
    PRESCRIPTION_ID     INT             NOT NULL,
    PHARMACIST_ID       INT             NOT NULL,
    FILLS_DATE          DATE            NOT NULL,
    FILL_NUMBER         INT             NOT NULL DEFAULT 1,
    NOTES               TEXT,

    CONSTRAINT fk_fills_prescription
        FOREIGN KEY (PRESCRIPTION_ID) REFERENCES PRESCRIPTION(PRESCRIPTION_ID),
    CONSTRAINT fk_fills_pharmacist
        FOREIGN KEY (PHARMACIST_ID) REFERENCES PHARMACIST(PHARMACIST_ID)
);

INSERT INTO INVENTORY (INVENTORY_ID, MEDICATION_NAME, NDC_CODE, GENERIC_NAME, DOSAGE_FORM, STRENGTH) VALUES
(1, 'TYLENOL', '50580-488-01', 'ACETAMINOPHEN', 'TABLET', '500MG'),
(2, 'ADVIL', '0573-0164-30', 'IBUPROFEN', 'TABLET', '200MG'),
(3, 'AMOXIL', '00093-2260-01', 'AMOXICILLIN', 'CAPSULE', '500MG'),
(4, 'PRINIVIL', '00006-0273-82', 'LISINOPRIL', 'TABLET', '10MG'),
(5, 'GLUCOPHAGE', '00093-1045-01', 'METFORMIN', 'TABLET', '500MG'),
(6, 'LIPITOR', '00071-0155-23', 'ATORVASTATIN', 'TABLET', '20MG'),
(7, 'NORVASC', '00071-0156-23', 'AMLODIPINE', 'TABLET', '5MG'),
(8, 'LOSARTAN', '00093-7146-01', 'LOSARTAN', 'TABLET', '50MG'),
(9, 'SYNTHROID', '00006-0070-61', 'LEVOTHYROXINE', 'TABLET', '50MCG'),
(10, 'ZESTRIL', '00006-0273-83', 'LISINOPRIL', 'TABLET', '20MG'),
(11, 'PLAVIX', '00093-7424-01', 'CLOPIDOGREL', 'TABLET', '75MG'),
(12, 'COUMADIN', '00093-0128-01', 'WARFARIN', 'TABLET', '5MG'),
(13, 'PRILOSEC', '00093-7425-01', 'OMEPRAZOLE', 'CAPSULE', '20MG'),
(14, 'PROZAC', '00093-7426-01', 'FLUOXETINE', 'CAPSULE', '20MG'),
(15, 'ZOLOFT', '00093-7427-01', 'SERTRALINE', 'TABLET', '50MG'),
(16, 'LEXAPRO', '00093-7428-01', 'ESCITALOPRAM', 'TABLET', '10MG'),
(17, 'CELEXA', '00093-7429-01', 'CITALOPRAM', 'TABLET', '20MG'),
(18, 'ABILIFY', '00093-7430-01', 'ARIPIPRAZOLE', 'TABLET', '5MG'),
(19, 'SEROQUEL', '00093-7431-01', 'QUETIAPINE', 'TABLET', '25MG'),
(20, 'XANAX', '00093-7432-01', 'ALPRAZOLAM', 'TABLET', '0.5MG'),
(21, 'VALIUM', '00093-7433-01', 'DIAZEPAM', 'TABLET', '5MG'),
(22, 'ATIVAN', '00093-7434-01', 'LORAZEPAM', 'TABLET', '1MG'),
(23, 'TRAMADOL', '00093-7435-01', 'TRAMADOL', 'TABLET', '50MG'),
(24, 'VICODIN', '00093-7436-01', 'HYDROCODONE', 'TABLET', '5MG'),
(25, 'PERCOCET', '00093-7437-01', 'OXYCODONE', 'TABLET', '5MG'),
(26, 'NEURONTIN', '00093-7438-01', 'GABAPENTIN', 'CAPSULE', '300MG'),
(27, 'LYRICA', '00093-7439-01', 'PREGABALIN', 'CAPSULE', '75MG'),
(28, 'CYMBALTA', '00093-7440-01', 'DULOXETINE', 'CAPSULE', '60MG'),
(29, 'EFFEXOR', '00093-7441-01', 'VENLAFAXINE', 'TABLET', '75MG'),
(30, 'WELLBUTRIN', '00093-7442-01', 'BUPROPION', 'TABLET', '150MG'),
(31, 'INSULIN', '00093-7443-01', 'INSULIN GLARGINE', 'INJECTION', '100U/ML'),
(32, 'HUMALOG', '00093-7444-01', 'INSULIN LISPRO', 'INJECTION', '100U/ML'),
(33, 'NOVOLOG', '00093-7445-01', 'INSULIN ASPART', 'INJECTION', '100U/ML'),
(34, 'LASIX', '00093-7446-01', 'FUROSEMIDE', 'TABLET', '40MG'),
(35, 'HYDRODIURIL', '00093-7447-01', 'HYDROCHLOROTHIAZIDE', 'TABLET', '25MG'),
(36, 'ALDACTONE', '00093-7448-01', 'SPIRONOLACTONE', 'TABLET', '25MG'),
(37, 'COREG', '00093-7449-01', 'CARVEDILOL', 'TABLET', '12.5MG'),
(38, 'TOPROL', '00093-7450-01', 'METOPROLOL', 'TABLET', '50MG'),
(39, 'PROPRANOLOL', '00093-7451-01', 'PROPRANOLOL', 'TABLET', '40MG'),
(40, 'DIGOXIN', '00093-7452-01', 'DIGOXIN', 'TABLET', '0.25MG'),
(41, 'PREDNISONE', '00093-7453-01', 'PREDNISONE', 'TABLET', '10MG'),
(42, 'METHYLPREDNISOLONE', '00093-7454-01', 'METHYLPREDNISOLONE', 'TABLET', '4MG'),
(43, 'AZITHROMYCIN', '00093-7455-01', 'AZITHROMYCIN', 'TABLET', '250MG'),
(44, 'CIPRO', '00093-7456-01', 'CIPROFLOXACIN', 'TABLET', '500MG'),
(45, 'LEVAQUIN', '00093-7457-01', 'LEVOFLOXACIN', 'TABLET', '500MG'),
(46, 'DOXYCYCLINE', '00093-7458-01', 'DOXYCYCLINE', 'CAPSULE', '100MG'),
(47, 'CLINDAMYCIN', '00093-7459-01', 'CLINDAMYCIN', 'CAPSULE', '300MG'),
(48, 'PENICILLIN', '00093-7460-01', 'PENICILLIN V', 'TABLET', '500MG'),
(49, 'ALBUTEROL', '00093-7461-01', 'ALBUTEROL', 'INHALER', '90MCG'),
(50, 'VENTOLIN', '00093-7462-01', 'ALBUTEROL', 'INHALER', '90MCG');

INSERT INTO MEDICATION (MEDICATION_ID, LOT_NUMBER, EXPIRATION_DATE, QUANTITY_IN_STOCK, UNIT_PRICE, MANUFACTURER, INVENTORY_ID) VALUES
(1, '001', '2027-05-12', 150, 8.99, 'Pfizer', 1),
(2, '002', '2026-11-03', 200, 5.49, 'Johnson & Johnson', 2),
(3, '003', '2028-01-20', 120, 12.75, 'Merck', 3),
(4, '004', '2027-08-15', 300, 3.99, 'Bayer', 4),
(5, '005', '2026-06-10', 180, 6.25, 'Novartis', 5),
(6, '006', '2027-12-01', 220, 9.99, 'Roche', 6),
(7, '007', '2028-03-18', 140, 15.50, 'Sanofi', 7),
(8, '008', '2026-09-25', 260, 4.75, 'AbbVie', 8),
(9, '009', '2027-04-30', 175, 7.20, 'GSK', 9),
(10, '010', '2028-07-11', 130, 11.80, 'Amgen', 10),
(11, '011', '2027-02-14', 210, 10.25, 'Pfizer', 11),
(12, '012', '2026-10-08', 190, 5.99, 'Merck', 12),
(13, '013', '2028-05-22', 160, 14.40, 'Bayer', 13),
(14, '014', '2027-09-13', 240, 6.75, 'Novartis', 14),
(15, '015', '2026-12-29', 170, 8.10, 'Sanofi', 15),
(16, '016', '2028-02-17', 150, 13.60, 'Roche', 16),
(17, '017', '2027-06-05', 300, 4.20, 'AbbVie', 17),
(18, '018', '2026-08-19', 280, 3.50, 'GSK', 18),
(19, '019', '2027-11-27', 200, 9.40, 'Pfizer', 19),
(20, '020', '2028-04-06', 145, 16.75, 'Amgen', 20),
(21, '021', '2027-01-09', 230, 7.90, 'Johnson & Johnson', 21),
(22, '022', '2026-07-23', 260, 5.60, 'Bayer', 22),
(23, '023', '2028-06-14', 180, 18.30, 'Merck', 23),
(24, '024', '2027-03-02', 210, 9.10, 'Novartis', 24),
(25, '025', '2026-11-30', 195, 6.45, 'Sanofi', 25),
(26, '026', '2028-08-21', 155, 20.00, 'Roche', 26),
(27, '027', '2027-05-17', 175, 11.25, 'AbbVie', 27),
(28, '028', '2026-09-09', 240, 4.95, 'GSK', 28),
(29, '029', '2027-12-12', 220, 10.60, 'Pfizer', 29),
(30, '030', '2028-02-28', 165, 17.80, 'Amgen', 30),
(31, '031', '2027-04-03', 200, 8.35, 'Johnson & Johnson', 31),
(32, '032', '2026-10-19', 210, 5.75, 'Bayer', 32),
(33, '033', '2028-07-07', 150, 19.90, 'Merck', 33),
(34, '034', '2027-01-25', 260, 7.80, 'Novartis', 34),
(35, '035', '2026-06-18', 180, 6.95, 'Sanofi', 35),
(36, '036', '2028-03-30', 140, 22.10, 'Roche', 36),
(37, '037', '2027-08-08', 170, 12.40, 'AbbVie', 37),
(38, '038', '2026-12-05', 230, 4.10, 'GSK', 38),
(39, '039', '2027-09-21', 210, 9.85, 'Pfizer', 39),
(40, '040', '2028-05-01', 160, 18.60, 'Amgen', 40),
(41, '041', '2027-02-11', 190, 7.55, 'Johnson & Johnson', 41),
(42, '042', '2026-08-27', 250, 5.20, 'Bayer', 42),
(43, '043', '2028-06-03', 130, 21.75, 'Merck', 43),
(44, '044', '2027-03-15', 200, 8.60, 'Novartis', 44),
(45, '045', '2026-11-11', 220, 6.10, 'Sanofi', 45),
(46, '046', '2028-01-29', 155, 23.50, 'Roche', 46),
(47, '047', '2027-06-22', 180, 13.75, 'AbbVie', 47),
(48, '048', '2026-09-14', 240, 4.65, 'GSK', 48),
(49, '049', '2027-12-03', 210, 10.95, 'Pfizer', 49),
(50, '050', '2028-04-18', 170, 19.25, 'Amgen', 50);

INSERT INTO PHARMACIST (PHARMACIST_ID, FIRST_NAME, LAST_NAME, LICENSE_NUMBER, PHONE, EMAIL) VALUES
(1, 'Pamela', 'House', 'TX-RPH-5501', '9565551001', 'phouse@pharmatrack.com'),
(2, 'Belinda', 'Peters', 'TX-RPH-5502', '9565551002', 'bpeters@pharmatrack.com'),
(3, 'Brenda', 'Johnson', 'TX-RPH-5503', '9565551003', 'bjohnson@pharmatrack.com'),
(4, 'Benjamin', 'Thomas', 'TX-RPH-5504', '9565551004', 'bthomas@pharmatrack.com'),
(5, 'John', 'Williams', 'TX-RPH-5505', '9565551005', 'jwilliams@pharmatrack.com'),
(6, 'Michelle', 'Mills', 'TX-RPH-5506', '9565551006', 'mmills@pharmatrack.com'),
(7, 'Samantha', 'Perez', 'TX-RPH-5507', '9565551007', 'sperez@pharmatrack.com'),
(8, 'Douglas', 'Simpson', 'TX-RPH-5508', '9565551008', 'dsimpson@pharmatrack.com'),
(9, 'Stacy', 'Myers', 'TX-RPH-5509', '9565551009', 'smyers@pharmatrack.com'),
(10, 'Matthew', 'Peters', 'TX-RPH-5510', '9565551010', 'mpeters@pharmatrack.com'),
(11, 'Audrey', 'Watson', 'TX-RPH-5511', '9565551011', 'awatson@pharmatrack.com'),
(12, 'Nicole', 'Crawford', 'TX-RPH-5512', '9565551012', 'ncrawford@pharmatrack.com'),
(13, 'Timothy', 'Sullivan', 'TX-RPH-5513', '9565551013', 'tsullivan@pharmatrack.com'),
(14, 'Charles', 'Barrett', 'TX-RPH-5514', '9565551014', 'cbarrett@pharmatrack.com'),
(15, 'Kristina', 'Huff', 'TX-RPH-5515', '9565551015', 'khuff@pharmatrack.com'),
(16, 'Melanie', 'Brown', 'TX-RPH-5516', '9565551016', 'mbrown@pharmatrack.com'),
(17, 'Troy', 'Carter', 'TX-RPH-5517', '9565551017', 'tcarter@pharmatrack.com'),
(18, 'Taylor', 'Miller', 'TX-RPH-5518', '9565551018', 'tmiller@pharmatrack.com'),
(19, 'Michelle', 'King', 'TX-RPH-5519', '9565551019', 'mking@pharmatrack.com'),
(20, 'Robert', 'Smith', 'TX-RPH-5520', '9565551020', 'rsmith@pharmatrack.com');

INSERT INTO DOCTOR (DOCTOR_ID, FIRST_NAME, LAST_NAME, LICENSE_NUMBER, PHONE, EMAIL, CLINIC_NAME) VALUES
(1, 'John', 'Craig', 'TX-MD-10021', '2105554821', 'jcraig@alamoheightsclinic.com', 'Alamo Heights Family Clinic'),
(2, 'Eric', 'Fisher', 'TX-MD-10022', '5125559034', 'efisher@lonestarmedical.org', 'Lone Star Medical Center'),
(3, 'Ryan', 'Adams', 'TX-MD-10023', '2815557762', 'radams@sanmarcoshealth.org', 'San Marcos Community Health'),
(4, 'Kimberly', 'Garcia', 'TX-MD-10024', '2145551198', 'kgarcia@hillcountrywellness.com', 'Hill Country Wellness Clinic'),
(5, 'Larry', 'Perry', 'TX-MD-10025', '7135556405', 'lperry@riograndevalleycare.org', 'Rio Grande Valley Care Center'),
(6, 'Christopher', 'Sanders', 'TX-MD-10026', '4695557320', 'csanders@bluebonnetfamilypractice.com', 'Bluebonnet Family Practice'),
(7, 'Rose', 'Chapman', 'TX-MD-10027', '8305554471', 'rchapman@cypresscreekmedgroup.com', 'Cypress Creek Medical Group'),
(8, 'Carolyn', 'Nicholson', 'TX-MD-10028', '9035552284', 'cnicholson@missiontrailprimary.com', 'Mission Trail Primary Care'),
(9, 'Denise', 'Church', 'TX-MD-10029', '3255559910', 'dchurch@westlakehillshealth.com', 'Westlake Hills Health Clinic'),
(10, 'Glenn', 'Hobbs', 'TX-MD-10030', '4095555632', 'ghobbs@southtexasregional.org', 'South Texas Regional Clinic'),
(11, 'Brandy', 'Shaw', 'TX-MD-10031', '9565558740', 'bshaw@pecangrovemedical.com', 'Pecan Grove Medical Associates'),
(12, 'Anthony', 'Taylor', 'TX-MD-10032', '9405553159', 'ataylor@northaustinfamilyhealth.com', 'North Austin Family Health'),
(13, 'Isaiah', 'Fisher', 'TX-MD-10033', '6825557044', 'ifisher@trinityrivermedical.org', 'Trinity River Medical Clinic'),
(14, 'Sandra', 'Brown', 'TX-MD-10034', '7375551289', 'sbrown@cedarparkprimarycare.com', 'Cedar Park Primary Care'),
(15, 'Brittney', 'Foster', 'TX-MD-10035', '8065559023', 'bfoster@brazosvalleyhealth.org', 'Brazos Valley Health Center'),
(16, 'Sean', 'Woodard', 'TX-MD-10036', '3615554478', 'swoodard@pineridgefamilymed.com', 'Pine Ridge Family Medicine'),
(17, 'Crystal', 'Smith', 'TX-MD-10037', '4325556601', 'csmith@friocountyclinic.org', 'Frio County Community Clinic'),
(18, 'Bobby', 'Paul', 'TX-MD-10038', '9795552846', 'bpaul@guadaluperivermedical.com', 'Guadalupe River Medical Center'),
(19, 'Cheryl', 'Ford', 'TX-MD-10039', '2545559932', 'cford@mesquitespringshealth.com', 'Mesquite Springs Health Clinic'),
(20, 'Andrew', 'Patrick', 'TX-MD-10040', '9155557714', 'apatrick@windcrestfamilycare.org', 'Windcrest Family Care');

INSERT INTO PATIENT (PATIENT_ID, FIRST_NAME, LAST_NAME, DATE_OF_BIRTH, PHONE, EMAIL, STREET, CITY, STATE, ZIP_CODE, ALLERGIES) VALUES
(1, 'Kevin', 'Browning', '2016-01-28', '8063300190', 'kevin.browning@gmail.com', '715 David Stream Apt. 032', 'Amarillo', 'TX', '79101', 'Shellfish'),
(2, 'Jennifer', 'Sloan', '1937-10-22', '3618088296', 'jennifer.sloan@hotmail.com', '05393 Hurst Isle Suite 214', 'Corpus Christi', 'TX', '78401', 'Grass'),
(3, 'Robert', 'Green', '1937-09-28', '7137291248', 'robert.green@gmail.com', '61042 Brandon Way Suite 342', 'Houston', 'TX', '77001', 'None'),
(4, 'Tommy', 'Johnson', '1939-10-10', '6829194522', 'tommy.johnson@gmail.com', '3494 Cathy Mountain', 'Arlington', 'TX', '76010', 'Aspirin'),
(5, 'Christian', 'Porter', '2016-09-28', '8176496145', 'christian.porter@yahoo.com', '94732 Nelson Knolls', 'Fort Worth', 'TX', '76102', 'Ibuprofen'),
(6, 'Sarah', 'Gibson', '2010-06-03', '8069374812', 'sarah.gibson@yahoo.com', '5727 Compton Trail', 'Amarillo', 'TX', '79101', 'Grass'),
(7, 'Daniel', 'Clark', '1942-11-03', '9158553252', 'daniel.clark@yahoo.com', '47400 Michelle Manors Apt. 460', 'El Paso', 'TX', '79901', 'Peanuts'),
(8, 'Evan', 'Mclaughlin', '1959-02-03', '8060734043', 'evan.mclaughlin@yahoo.com', '6830 Jones Stream', 'Amarillo', 'TX', '79101', 'Latex'),
(9, 'Christian', 'Vasquez', '2006-12-26', '5129205384', 'christian.vasquez@gmail.com', '85388 Angel Rest Suite 986', 'Austin', 'TX', '73301', 'Latex'),
(10, 'William', 'Fox', '2017-05-22', '8067371888', 'william.fox@gmail.com', '33139 Arnold Pass', 'Amarillo', 'TX', '79101', 'Grass'),
(11, 'Michelle', 'Gonzalez', '1974-03-08', '9158280791', 'michelle.gonzalez@gmail.com', '083 Jennifer Highway', 'El Paso', 'TX', '79901', 'Ibuprofen'),
(12, 'Debra', 'Cummings', '2017-05-12', '6824866632', 'debra.cummings@hotmail.com', '4604 Ward Squares Suite 076', 'Arlington', 'TX', '76010', 'Penicillin'),
(13, 'John', 'Miles', '1988-04-20', '2141086324', 'john.miles@yahoo.com', '97375 Anna Run Apt. 937', 'Dallas', 'TX', '75201', 'Acetaminophen'),
(14, 'Doris', 'Ramsey', '2019-08-09', '5127878703', 'doris.ramsey@yahoo.com', '0246 Mathews Oval', 'Austin', 'TX', '73301', 'Latex'),
(15, 'Tyler', 'Cherry', '1939-12-10', '5126583082', 'tyler.cherry@hotmail.com', '7095 Jeffrey Mills Suite 946', 'Austin', 'TX', '73301', 'Bees'),
(16, 'Kevin', 'Mason', '2020-10-01', '2148647565', 'kevin.mason@hotmail.com', '28720 Larson Divide', 'Dallas', 'TX', '75201', 'None'),
(17, 'Jose', 'Mcintosh', '1986-02-01', '8068149957', 'jose.mcintosh@yahoo.com', '24027 Weiss Underpass Apt. 257', 'Amarillo', 'TX', '79101', 'Shellfish'),
(18, 'Heather', 'Curtis', '1945-07-04', '2146853766', 'heather.curtis@yahoo.com', '516 Anthony Pines', 'Dallas', 'TX', '75201', 'Aspirin'),
(19, 'Michael', 'Lewis', '1953-03-07', '8060567673', 'michael.lewis@gmail.com', '2824 Amber Lake', 'Lubbock', 'TX', '79401', 'Penicillin'),
(20, 'Jay', 'James', '1941-08-11', '3613033895', 'jay.james@gmail.com', '05856 Greene Unions Apt. 718', 'Corpus Christi', 'TX', '78401', 'Ibuprofen'),
(21, 'Benjamin', 'Smith', '1995-06-10', '6822810178', 'benjamin.smith@yahoo.com', '4733 Vang Inlet Apt. 441', 'Arlington', 'TX', '76010', 'Bees'),
(22, 'Richard', 'Mcdonald', '1959-05-12', '8170063032', 'richard.mcdonald@gmail.com', '36207 Hamilton Key Suite 333', 'Fort Worth', 'TX', '76102', 'Aspirin'),
(23, 'Amanda', 'Walker', '2008-06-01', '9156161483', 'amanda.walker@gmail.com', '35309 Davis Mount Suite 854', 'El Paso', 'TX', '79901', 'Bees'),
(24, 'Cindy', 'Taylor', '2003-11-18', '2103404432', 'cindy.taylor@yahoo.com', '40635 Kathryn Views', 'San Antonio', 'TX', '78205', 'Pollen'),
(25, 'Jerome', 'Stanley', '1986-04-23', '8068796764', 'jerome.stanley@hotmail.com', '165 Anthony Corners', 'Amarillo', 'TX', '79101', 'Ants'),
(26, 'Jason', 'Williams', '2002-11-07', '9150940329', 'jason.williams@gmail.com', '95697 Anthony Landing', 'El Paso', 'TX', '79901', 'Ants'),
(27, 'Michael', 'Mendez', '1952-09-12', '3615453780', 'michael.mendez@hotmail.com', '886 Alyssa Village Apt. 354', 'Corpus Christi', 'TX', '78401', 'None'),
(28, 'Gerald', 'Esparza', '1939-12-06', '8179562404', 'gerald.esparza@gmail.com', '751 Jones Wells', 'Fort Worth', 'TX', '76102', 'Penicillin'),
(29, 'Randall', 'Allen', '1987-10-01', '6826181731', 'randall.allen@hotmail.com', '779 Shields Mill', 'Arlington', 'TX', '76010', 'Grass'),
(30, 'Joseph', 'Hardin', '1935-05-29', '7136151137', 'joseph.hardin@hotmail.com', '471 Mark Highway Suite 851', 'Houston', 'TX', '77001', 'Peanuts'),
(31, 'Valerie', 'Davis', '2015-11-16', '5120509543', 'valerie.davis@gmail.com', '3953 Ford Plains Suite 770', 'Austin', 'TX', '73301', 'Pollen'),
(32, 'Elizabeth', 'Kelly', '1997-03-02', '8065849850', 'elizabeth.kelly@gmail.com', '15994 Padilla Keys Suite 868', 'Amarillo', 'TX', '79101', 'Ants'),
(33, 'Carol', 'Herrera', '2023-01-07', '2107103870', 'carol.herrera@gmail.com', '36190 Tiffany Canyon', 'San Antonio', 'TX', '78205', 'Penicillin'),
(34, 'Gregory', 'Mayer', '2018-11-27', '9157624834', 'gregory.mayer@hotmail.com', '639 Rivera Rapids Apt. 238', 'El Paso', 'TX', '79901', 'Aspirin'),
(35, 'Cassandra', 'Neal', '1937-08-14', '8065294943', 'cassandra.neal@yahoo.com', '108 Thompson Ports Apt. 090', 'Lubbock', 'TX', '79401', 'Bees'),
(36, 'Ian', 'Kline', '1997-11-15', '7132864158', 'ian.kline@hotmail.com', '9712 Maxwell Garden Suite 336', 'Houston', 'TX', '77001', 'None'),
(37, 'Brandon', 'Martinez', '1969-03-14', '8065976849', 'brandon.martinez@yahoo.com', '452 Michael Tunnel Suite 215', 'Amarillo', 'TX', '79101', 'Peanuts'),
(38, 'Karen', 'Bailey', '1949-10-13', '8069840635', 'karen.bailey@gmail.com', '77545 Caitlin Gardens Suite 007', 'Amarillo', 'TX', '79101', 'Latex'),
(39, 'Diane', 'Burgess', '2006-05-13', '2147776672', 'diane.burgess@hotmail.com', '23199 Melissa Crest', 'Dallas', 'TX', '75201', 'Acetaminophen'),
(40, 'Jeffrey', 'Hamilton', '2008-02-12', '8173811125', 'jeffrey.hamilton@gmail.com', '759 Troy Canyon Apt. 144', 'Fort Worth', 'TX', '76102', 'Ants'),
(41, 'Leah', 'Suarez', '1943-12-11', '5122853460', 'leah.suarez@hotmail.com', '2922 Bright Overpass Apt. 640', 'Austin', 'TX', '73301', 'Latex'),
(42, 'Susan', 'Anderson', '1945-05-19', '6820302884', 'susan.anderson@yahoo.com', '029 Kimberly Skyway Suite 077', 'Arlington', 'TX', '76010', 'Peanuts'),
(43, 'Paul', 'Bailey', '2018-07-19', '5120901953', 'paul.bailey@hotmail.com', '4808 Cindy View', 'Austin', 'TX', '73301', 'Bees'),
(44, 'Sylvia', 'Green', '2019-08-07', '2108863983', 'sylvia.green@gmail.com', '70463 Greg Track Apt. 779', 'San Antonio', 'TX', '78205', 'Latex'),
(45, 'Christina', 'Young', '2008-04-21', '2101891429', 'christina.young@hotmail.com', '27973 Aaron Passage Apt. 591', 'San Antonio', 'TX', '78205', 'Peanuts'),
(46, 'Elizabeth', 'Lee', '1990-07-14', '2102826893', 'elizabeth.lee@gmail.com', '47654 Clayton Burg Suite 023', 'San Antonio', 'TX', '78205', 'None'),
(47, 'Krystal', 'Ferguson', '1942-02-16', '2101567253', 'krystal.ferguson@hotmail.com', '8554 Julie Vista', 'San Antonio', 'TX', '78205', 'Ants'),
(48, 'Jessica', 'Mendez', '1993-07-24', '9156149556', 'jessica.mendez@gmail.com', '8555 Ronnie Tunnel Suite 353', 'El Paso', 'TX', '79901', 'Grass'),
(49, 'Alicia', 'Pham', '2005-06-01', '2144661619', 'alicia.pham@gmail.com', '1982 Rojas Mill Suite 209', 'Dallas', 'TX', '75201', 'Ibuprofen'),
(50, 'Susan', 'Burnett', '1981-03-01', '8061997984', 'susan.burnett@gmail.com', '4601 Vega Trail Apt. 778', 'Lubbock', 'TX', '79401', 'Acetaminophen'),
(51, 'Brady', 'House', '2011-01-20', '8066760782', 'brady.house@yahoo.com', '7762 Todd Road Apt. 105', 'Lubbock', 'TX', '79401', 'Shellfish'),
(52, 'Theresa', 'Gamble', '2010-07-28', '3615009057', 'theresa.gamble@yahoo.com', '448 Judith Trace Suite 107', 'Corpus Christi', 'TX', '78401', 'Bees'),
(53, 'Candice', 'Hernandez', '1959-07-29', '2108933720', 'candice.hernandez@hotmail.com', '2664 Alvarez Isle Suite 022', 'San Antonio', 'TX', '78205', 'Shellfish'),
(54, 'Patrick', 'Floyd', '1969-03-19', '2108175774', 'patrick.floyd@gmail.com', '32434 Bernard Circles', 'San Antonio', 'TX', '78205', 'Dairy'),
(55, 'Leslie', 'Good', '2019-01-13', '8064093246', 'leslie.good@hotmail.com', '13246 Alexander Village Apt. 566', 'Amarillo', 'TX', '79101', 'Peanuts'),
(56, 'Crystal', 'Pitts', '1940-08-03', '2141531433', 'crystal.pitts@hotmail.com', '6417 Antonio Center Suite 079', 'Dallas', 'TX', '75201', 'Latex'),
(57, 'Brandy', 'Jones', '2006-05-17', '8060484364', 'brandy.jones@gmail.com', '3060 Morgan Mountains', 'Amarillo', 'TX', '79101', 'Penicillin'),
(58, 'Michael', 'Campbell', '2013-10-19', '2142189215', 'michael.campbell@hotmail.com', '5144 Samantha Union', 'Dallas', 'TX', '75201', 'Dairy'),
(59, 'Luis', 'Reed', '1953-03-30', '2144801083', 'luis.reed@hotmail.com', '00890 Austin Skyway Suite 920', 'Dallas', 'TX', '75201', 'Dairy'),
(60, 'Christopher', 'Whitaker', '1940-09-10', '8060686174', 'christopher.whitaker@yahoo.com', '0634 Michael Inlet', 'Lubbock', 'TX', '79401', 'Ibuprofen'),
(61, 'Ashlee', 'Brown', '1954-06-10', '5125793799', 'ashlee.brown@gmail.com', '6529 Jacobson Circles', 'Austin', 'TX', '73301', 'Shellfish'),
(62, 'Amanda', 'Luna', '1940-03-20', '8065077970', 'amanda.luna@gmail.com', '2235 Pratt Ramp Suite 528', 'Lubbock', 'TX', '79401', 'Peanuts'),
(63, 'Derek', 'Warren', '2008-05-30', '8064389826', 'derek.warren@hotmail.com', '580 Gabrielle Mountain', 'Amarillo', 'TX', '79101', 'Grass'),
(64, 'Jesse', 'Anderson', '1957-12-07', '2104047021', 'jesse.anderson@hotmail.com', '0059 Ramirez Springs', 'San Antonio', 'TX', '78205', 'Ibuprofen'),
(65, 'John', 'Shaw', '1953-11-06', '3614334642', 'john.shaw@yahoo.com', '50658 Chris Locks Suite 878', 'Corpus Christi', 'TX', '78401', 'Pollen'),
(66, 'Gary', 'Johnson', '1969-12-20', '2144012929', 'gary.johnson@hotmail.com', '3329 Roberts Curve', 'Dallas', 'TX', '75201', 'Aspirin'),
(67, 'Brittany', 'Chavez', '2008-08-16', '7135699297', 'brittany.chavez@yahoo.com', '43435 Fisher Road', 'Houston', 'TX', '77001', 'Peanuts'),
(68, 'Jimmy', 'George', '1955-02-25', '2107407700', 'jimmy.george@hotmail.com', '817 Tammy Lights Apt. 879', 'San Antonio', 'TX', '78205', 'Peanuts'),
(69, 'Deanna', 'Bass', '1949-05-01', '8064099944', 'deanna.bass@hotmail.com', '92443 Larsen Parks', 'Amarillo', 'TX', '79101', 'None'),
(70, 'Rachel', 'Mendoza', '2009-04-18', '5121140427', 'rachel.mendoza@hotmail.com', '0446 Michelle Isle', 'Austin', 'TX', '73301', 'Aspirin'),
(71, 'Brandon', 'Chavez', '1957-03-08', '9156435859', 'brandon.chavez@hotmail.com', '6655 Smith Greens Suite 922', 'El Paso', 'TX', '79901', 'None'),
(72, 'James', 'Miles', '2020-01-25', '2147094734', 'james.miles@hotmail.com', '746 Sheila Loop Suite 897', 'Dallas', 'TX', '75201', 'Ants'),
(73, 'John', 'Vincent', '1996-09-25', '2148980670', 'john.vincent@hotmail.com', '63466 Derek Bridge Suite 383', 'Dallas', 'TX', '75201', 'Latex'),
(74, 'Daniel', 'Martin', '1984-08-17', '3618014512', 'daniel.martin@hotmail.com', '681 Rodriguez Corner Apt. 948', 'Corpus Christi', 'TX', '78401', 'Ibuprofen'),
(75, 'Catherine', 'Hinton', '1968-05-14', '6824391648', 'catherine.hinton@gmail.com', '90206 Mullen River', 'Arlington', 'TX', '76010', 'Acetaminophen'),
(76, 'David', 'Schroeder', '2020-04-22', '7132362562', 'david.schroeder@gmail.com', '49177 Kristina Causeway Suite 899', 'Houston', 'TX', '77001', 'Dairy'),
(77, 'Michael', 'Hall', '2006-12-06', '2149303437', 'michael.hall@yahoo.com', '8482 Munoz Club', 'Dallas', 'TX', '75201', 'Pollen'),
(78, 'Jennifer', 'Graham', '1999-06-18', '2108454647', 'jennifer.graham@hotmail.com', '281 Mccoy Route Apt. 559', 'San Antonio', 'TX', '78205', 'Peanuts'),
(79, 'Zachary', 'Torres', '1993-12-03', '8061880944', 'zachary.torres@hotmail.com', '3688 Sanchez Mall Apt. 465', 'Lubbock', 'TX', '79401', 'Penicillin'),
(80, 'Jay', 'Baker', '2003-06-24', '8063791490', 'jay.baker@gmail.com', '136 Chris Club Apt. 103', 'Amarillo', 'TX', '79101', 'Acetaminophen'),
(81, 'Jeffery', 'Roach', '2014-04-13', '8068503900', 'jeffery.roach@yahoo.com', '9566 Ramirez Trail Apt. 204', 'Lubbock', 'TX', '79401', 'Bees'),
(82, 'Tyler', 'Morgan', '1978-06-06', '8065706396', 'tyler.morgan@yahoo.com', '479 Richard Lodge', 'Lubbock', 'TX', '79401', 'Penicillin'),
(83, 'Melissa', 'Smith', '1996-03-15', '2147582396', 'melissa.smith@yahoo.com', '916 Christy Meadows Apt. 773', 'Dallas', 'TX', '75201', 'Grass'),
(84, 'James', 'Blanchard', '2007-01-25', '9154051772', 'james.blanchard@yahoo.com', '252 Stephanie Track Suite 898', 'El Paso', 'TX', '79901', 'Aspirin'),
(85, 'Marcus', 'Moss', '1953-08-28', '2145475809', 'marcus.moss@hotmail.com', '6916 Rachael Knolls Suite 930', 'Dallas', 'TX', '75201', 'Peanuts'),
(86, 'Samantha', 'Hoover', '1973-05-24', '8064103446', 'samantha.hoover@yahoo.com', '47797 Robert Fort', 'Amarillo', 'TX', '79101', 'Penicillin'),
(87, 'Jacob', 'Dixon', '1972-03-12', '8068724941', 'jacob.dixon@hotmail.com', '267 Owen Shore Suite 732', 'Lubbock', 'TX', '79401', 'Acetaminophen'),
(88, 'David', 'Aguilar', '2011-10-16', '6827558442', 'david.aguilar@hotmail.com', '79174 Johnson Road Apt. 113', 'Arlington', 'TX', '76010', 'Pollen'),
(89, 'Andrea', 'Roach', '2022-04-05', '8069163666', 'andrea.roach@yahoo.com', '88815 Wright Creek Suite 070', 'Amarillo', 'TX', '79101', 'Aspirin'),
(90, 'Kelli', 'Lam', '1988-11-16', '5124106793', 'kelli.lam@yahoo.com', '374 Jason Plain Apt. 354', 'Austin', 'TX', '73301', 'None'),
(91, 'Jason', 'Barnett', '1948-06-23', '7135268152', 'jason.barnett@hotmail.com', '1025 Bradley Park Suite 105', 'Houston', 'TX', '77001', 'Penicillin'),
(92, 'Matthew', 'Robbins', '2021-10-09', '5125059793', 'matthew.robbins@yahoo.com', '190 Catherine Curve', 'Austin', 'TX', '73301', 'Pollen'),
(93, 'Deborah', 'Rosario', '1962-01-04', '8060118515', 'deborah.rosario@gmail.com', '338 Michael Ports', 'Amarillo', 'TX', '79101', 'Peanuts'),
(94, 'Mary', 'Small', '1989-12-21', '5123551860', 'mary.small@gmail.com', '318 Patricia Fort', 'Austin', 'TX', '73301', 'Acetaminophen'),
(95, 'Brandon', 'Salazar', '1999-11-05', '9150817914', 'brandon.salazar@gmail.com', '118 Fred Streets Suite 887', 'El Paso', 'TX', '79901', 'Pollen'),
(96, 'Jessica', 'Flores', '2003-02-26', '2107306972', 'jessica.flores@yahoo.com', '5878 Michael Club', 'San Antonio', 'TX', '78205', 'Aspirin'),
(97, 'Nicole', 'Wilkins', '2012-05-26', '8063325442', 'nicole.wilkins@gmail.com', '461 Martinez Dam Apt. 026', 'Lubbock', 'TX', '79401', 'Ants'),
(98, 'Kathleen', 'Stein', '1963-06-05', '2107563580', 'kathleen.stein@gmail.com', '1625 Denise Turnpike Suite 529', 'San Antonio', 'TX', '78205', 'Ants'),
(99, 'James', 'Davis', '2012-09-30', '2107766996', 'james.davis@gmail.com', '067 Lewis Center', 'San Antonio', 'TX', '78205', 'Penicillin'),
(100, 'Catherine', 'Stein', '1968-06-13', '3614919275', 'catherine.stein@hotmail.com', '136 Bennett Groves Apt. 807', 'Corpus Christi', 'TX', '78401', 'Shellfish'),
(101, 'Keith', 'Love', '1958-09-03', '5128725654', 'keith.love@gmail.com', '259 Mary Lodge Apt. 077', 'Austin', 'TX', '73301', 'Peanuts'),
(102, 'Kelsey', 'Gaines', '1975-03-21', '5129929046', 'kelsey.gaines@yahoo.com', '187 Tamara Inlet', 'Austin', 'TX', '73301', 'Aspirin'),
(103, 'Sheila', 'Clark', '2002-09-16', '5122544966', 'sheila.clark@yahoo.com', '655 Danielle Union', 'Austin', 'TX', '73301', 'Ants'),
(104, 'Michael', 'Thompson', '2009-07-15', '6828539612', 'michael.thompson@gmail.com', '337 Gerald Coves Suite 689', 'Arlington', 'TX', '76010', 'Ants'),
(105, 'Alicia', 'Warren', '1957-03-08', '8170106846', 'alicia.warren@gmail.com', '0754 Bond Gardens', 'Fort Worth', 'TX', '76102', 'Ibuprofen'),
(106, 'Andrea', 'Thompson', '1936-11-27', '8064303779', 'andrea.thompson@hotmail.com', '26463 Johnson Prairie Suite 486', 'Amarillo', 'TX', '79101', 'Shellfish'),
(107, 'Ashley', 'Lane', '1965-12-29', '8065110998', 'ashley.lane@hotmail.com', '8734 Santiago Extensions Suite 894', 'Amarillo', 'TX', '79101', 'Bees'),
(108, 'Amy', 'Carpenter', '2003-06-13', '5122463608', 'amy.carpenter@gmail.com', '991 Karen Mountains Apt. 565', 'Austin', 'TX', '73301', 'Latex'),
(109, 'Shelly', 'Harris', '1996-11-19', '3618402559', 'shelly.harris@hotmail.com', '2179 Holmes Street Apt. 134', 'Corpus Christi', 'TX', '78401', 'Peanuts'),
(110, 'Devin', 'Gonzales', '1988-01-12', '8060939310', 'devin.gonzales@gmail.com', '054 Mary Isle', 'Lubbock', 'TX', '79401', 'Ants'),
(111, 'Robert', 'Stanton', '1977-03-16', '5121687393', 'robert.stanton@hotmail.com', '71255 Smith Points Apt. 387', 'Austin', 'TX', '73301', 'Acetaminophen'),
(112, 'Raymond', 'Cooper', '1942-07-23', '9153585413', 'raymond.cooper@yahoo.com', '176 Walters Crest', 'El Paso', 'TX', '79901', 'Pollen'),
(113, 'Martin', 'Cross', '1943-08-17', '6820754537', 'martin.cross@yahoo.com', '24166 Anthony Plaza', 'Arlington', 'TX', '76010', 'Peanuts'),
(114, 'Lisa', 'Clark', '1980-06-13', '8069909020', 'lisa.clark@gmail.com', '33749 Moore Club', 'Amarillo', 'TX', '79101', 'Ibuprofen'),
(115, 'Levi', 'Nguyen', '1969-03-29', '6828317502', 'levi.nguyen@gmail.com', '503 Smith Lakes Suite 118', 'Arlington', 'TX', '76010', 'Ants'),
(116, 'Erica', 'Garza', '2008-04-11', '8064403670', 'erica.garza@yahoo.com', '97632 Douglas Underpass Apt. 053', 'Amarillo', 'TX', '79101', 'Peanuts'),
(117, 'Brittany', 'Wood', '1980-08-02', '5129133076', 'brittany.wood@gmail.com', '123 Sean Rest', 'Austin', 'TX', '73301', 'Shellfish'),
(118, 'Priscilla', 'Phillips', '1937-06-23', '6824869435', 'priscilla.phillips@hotmail.com', '70435 Rachel Locks', 'Arlington', 'TX', '76010', 'Bees'),
(119, 'Karen', 'Sweeney', '1986-03-02', '3613734539', 'karen.sweeney@gmail.com', '08850 Dale Port Apt. 190', 'Corpus Christi', 'TX', '78401', 'None'),
(120, 'Jennifer', 'Rogers', '2002-06-17', '3616770593', 'jennifer.rogers@hotmail.com', '2674 Michael Ranch Suite 752', 'Corpus Christi', 'TX', '78401', 'Ants'),
(121, 'Stephen', 'Rodriguez', '1959-05-20', '5120850578', 'stephen.rodriguez@yahoo.com', '848 Gonzalez Street Suite 884', 'Austin', 'TX', '73301', 'Latex'),
(122, 'Taylor', 'Jimenez', '1939-01-15', '3611552677', 'taylor.jimenez@hotmail.com', '315 Alisha Landing Apt. 182', 'Corpus Christi', 'TX', '78401', 'Acetaminophen'),
(123, 'Lisa', 'Lopez', '1953-06-21', '5125266678', 'lisa.lopez@gmail.com', '62553 Diaz Fords', 'Austin', 'TX', '73301', 'Aspirin'),
(124, 'Shane', 'Rivas', '1952-10-31', '8061430510', 'shane.rivas@hotmail.com', '1018 William Mill', 'Lubbock', 'TX', '79401', 'Ibuprofen'),
(125, 'Kathryn', 'Dominguez', '1975-01-10', '8060304467', 'kathryn.dominguez@yahoo.com', '56499 Laura Fall', 'Lubbock', 'TX', '79401', 'Dairy'),
(126, 'Ashley', 'Hughes', '1946-12-13', '2100181669', 'ashley.hughes@yahoo.com', '11306 Benjamin Cliffs Apt. 748', 'San Antonio', 'TX', '78205', 'Penicillin'),
(127, 'Wendy', 'Armstrong', '1949-07-01', '5124979301', 'wendy.armstrong@yahoo.com', '6211 Allison Union', 'Austin', 'TX', '73301', 'Shellfish'),
(128, 'Patricia', 'Moore', '2009-07-23', '8060316561', 'patricia.moore@hotmail.com', '9218 Taylor Extensions Suite 871', 'Lubbock', 'TX', '79401', 'Ants'),
(129, 'David', 'Boone', '1969-01-02', '5127310293', 'david.boone@gmail.com', '931 Eugene Canyon', 'Austin', 'TX', '73301', 'Bees'),
(130, 'Bruce', 'Ramirez', '1978-07-08', '8064777759', 'bruce.ramirez@gmail.com', '0478 Miller Cliffs', 'Lubbock', 'TX', '79401', 'Latex'),
(131, 'Gregory', 'Smith', '2000-01-29', '8068689691', 'gregory.smith@gmail.com', '6980 Ashley Port Apt. 963', 'Amarillo', 'TX', '79101', 'Bees'),
(132, 'Belinda', 'Atkinson', '2013-07-17', '8174139170', 'belinda.atkinson@yahoo.com', '766 Smith Lake Suite 462', 'Fort Worth', 'TX', '76102', 'None'),
(133, 'Michael', 'Rogers', '1956-06-06', '7137292980', 'michael.rogers@yahoo.com', '5577 Jones Meadows Suite 923', 'Houston', 'TX', '77001', 'Aspirin'),
(134, 'Emily', 'Fowler', '2002-07-28', '5120636704', 'emily.fowler@hotmail.com', '4849 Audrey Shores', 'Austin', 'TX', '73301', 'Ibuprofen'),
(135, 'Kimberly', 'Grimes', '2013-01-11', '8067195771', 'kimberly.grimes@gmail.com', '35755 Santiago Place Suite 961', 'Amarillo', 'TX', '79101', 'Grass'),
(136, 'Joseph', 'Brown', '1998-07-21', '2149186293', 'joseph.brown@yahoo.com', '07517 Hoffman Inlet', 'Dallas', 'TX', '75201', 'Pollen'),
(137, 'Steven', 'Jacobs', '2010-07-03', '3612214991', 'steven.jacobs@hotmail.com', '7553 Carpenter Estates Apt. 989', 'Corpus Christi', 'TX', '78401', 'Dairy'),
(138, 'Melanie', 'Matthews', '1995-06-19', '5123218188', 'melanie.matthews@gmail.com', '3683 Amy Terrace', 'Austin', 'TX', '73301', 'Pollen'),
(139, 'Randy', 'Sullivan', '1985-12-11', '3619431886', 'randy.sullivan@hotmail.com', '3056 Christina Cliff Suite 954', 'Corpus Christi', 'TX', '78401', 'Bees'),
(140, 'Michele', 'Cunningham', '1979-09-20', '3611942156', 'michele.cunningham@yahoo.com', '61797 William Field', 'Corpus Christi', 'TX', '78401', 'Aspirin'),
(141, 'Crystal', 'Moore', '2005-04-03', '5122757298', 'crystal.moore@gmail.com', '71799 Timothy Avenue', 'Austin', 'TX', '73301', 'Dairy'),
(142, 'Anthony', 'Fuller', '2000-03-25', '9158680236', 'anthony.fuller@yahoo.com', '44364 Jennifer Ferry Apt. 991', 'El Paso', 'TX', '79901', 'Ibuprofen'),
(143, 'Jared', 'Barnes', '2006-02-24', '6822868483', 'jared.barnes@gmail.com', '20627 Hansen Coves Suite 955', 'Arlington', 'TX', '76010', 'Pollen'),
(144, 'Lisa', 'Petty', '1998-08-25', '6821439203', 'lisa.petty@hotmail.com', '57051 Lopez Cape', 'Arlington', 'TX', '76010', 'Aspirin'),
(145, 'Matthew', 'Cantrell', '1942-02-17', '8068463063', 'matthew.cantrell@gmail.com', '21196 Bradley Valleys Suite 481', 'Lubbock', 'TX', '79401', 'Dairy'),
(146, 'Thomas', 'Palmer', '2021-08-12', '2108416607', 'thomas.palmer@yahoo.com', '940 Patrick Islands Apt. 819', 'San Antonio', 'TX', '78205', 'Aspirin'),
(147, 'Barbara', 'Hoover', '1980-08-08', '8060543753', 'barbara.hoover@yahoo.com', '17485 Chung Manors', 'Lubbock', 'TX', '79401', 'Ants'),
(148, 'Vanessa', 'Jackson', '1988-05-15', '6823724401', 'vanessa.jackson@yahoo.com', '949 Hanson Unions', 'Arlington', 'TX', '76010', 'Ants'),
(149, 'Jane', 'Lopez', '2001-06-26', '5123414552', 'jane.lopez@gmail.com', '4172 Daniel Ridges', 'Austin', 'TX', '73301', 'Bees'),
(150, 'Christopher', 'Escobar', '2021-04-12', '8065045210', 'christopher.escobar@gmail.com', '32738 Lara Course', 'Amarillo', 'TX', '79101', 'Shellfish'),
(151, 'Charles', 'Ruiz', '1971-10-21', '2100957534', 'charles.ruiz@gmail.com', '372 Sandra Views Suite 966', 'San Antonio', 'TX', '78205', 'Grass'),
(152, 'Molly', 'Reilly', '1956-04-12', '8068966929', 'molly.reilly@gmail.com', '29378 Hughes Ford Suite 072', 'Lubbock', 'TX', '79401', 'Pollen'),
(153, 'Jessica', 'Johnson', '2001-06-11', '8064453140', 'jessica.johnson@gmail.com', '13870 Whitney Spring', 'Amarillo', 'TX', '79101', 'Dairy'),
(154, 'Jessica', 'Dixon', '2003-05-13', '7139392981', 'jessica.dixon@yahoo.com', '662 Sharon Mission Apt. 412', 'Houston', 'TX', '77001', 'Peanuts'),
(155, 'Kaitlyn', 'White', '2010-09-27', '8176412963', 'kaitlyn.white@hotmail.com', '7469 Andrea Stream', 'Fort Worth', 'TX', '76102', 'Dairy'),
(156, 'Lisa', 'Miller', '1966-03-10', '5128515777', 'lisa.miller@gmail.com', '449 Maynard Heights Suite 348', 'Austin', 'TX', '73301', 'Dairy'),
(157, 'Stephen', 'Blevins', '2003-04-01', '7134021773', 'stephen.blevins@gmail.com', '79643 Lisa Keys', 'Houston', 'TX', '77001', 'Peanuts'),
(158, 'Alyssa', 'Jones', '2010-03-16', '2108218555', 'alyssa.jones@yahoo.com', '35482 Richard Knoll Suite 943', 'San Antonio', 'TX', '78205', 'Dairy'),
(159, 'John', 'Mathews', '1992-01-08', '8061054613', 'john.mathews@gmail.com', '035 Hernandez Falls', 'Amarillo', 'TX', '79101', 'Ants'),
(160, 'Donald', 'Poole', '2004-01-30', '2148503504', 'donald.poole@gmail.com', '1847 Bradley Vista Apt. 195', 'Dallas', 'TX', '75201', 'Ants'),
(161, 'Rhonda', 'Green', '1982-09-18', '6829584681', 'rhonda.green@yahoo.com', '90605 Jennifer Port Suite 395', 'Arlington', 'TX', '76010', 'None'),
(162, 'Jennifer', 'Anderson', '1967-07-23', '9157745154', 'jennifer.anderson@yahoo.com', '00642 Martin Extensions Apt. 726', 'El Paso', 'TX', '79901', 'Grass'),
(163, 'Ann', 'Smith', '2004-09-15', '3618737102', 'ann.smith@gmail.com', '23125 Kyle Way', 'Corpus Christi', 'TX', '78401', 'Ants'),
(164, 'Robert', 'Cowan', '1994-02-02', '6828431708', 'robert.cowan@gmail.com', '1172 Sandra Plaza Suite 337', 'Arlington', 'TX', '76010', 'Bees'),
(165, 'Robert', 'Wright', '1953-08-29', '7132580049', 'robert.wright@hotmail.com', '3181 Ruiz Square Apt. 278', 'Houston', 'TX', '77001', 'None'),
(166, 'Michele', 'Myers', '1998-07-19', '2142923047', 'michele.myers@hotmail.com', '62520 Carter Manor Suite 285', 'Dallas', 'TX', '75201', 'Latex'),
(167, 'Darrell', 'Mitchell', '1989-05-10', '8174828533', 'darrell.mitchell@hotmail.com', '015 Williams Rapid Apt. 640', 'Fort Worth', 'TX', '76102', 'Grass'),
(168, 'Kristy', 'Mcpherson', '1978-06-26', '5125533190', 'kristy.mcpherson@yahoo.com', '7409 Joseph Estates', 'Austin', 'TX', '73301', 'Peanuts'),
(169, 'Michael', 'Dodson', '1982-07-01', '2140309376', 'michael.dodson@hotmail.com', '26145 Taylor Plains Suite 806', 'Dallas', 'TX', '75201', 'Latex'),
(170, 'Kristi', 'Larsen', '1950-06-19', '2140341895', 'kristi.larsen@gmail.com', '19340 Sanders Village Suite 639', 'Dallas', 'TX', '75201', 'Ibuprofen'),
(171, 'Lori', 'Ayers', '1977-06-22', '7132395573', 'lori.ayers@hotmail.com', '5066 Green Lane', 'Houston', 'TX', '77001', 'Aspirin'),
(172, 'Jackson', 'Mccarthy', '2010-04-02', '9153356521', 'jackson.mccarthy@gmail.com', '229 John Neck', 'El Paso', 'TX', '79901', 'Ibuprofen'),
(173, 'Emily', 'Garcia', '1975-01-30', '2108594707', 'emily.garcia@gmail.com', '379 Bailey Stravenue', 'San Antonio', 'TX', '78205', 'Aspirin'),
(174, 'Laura', 'Jones', '1989-09-10', '8172606457', 'laura.jones@hotmail.com', '6196 Veronica Hills Apt. 674', 'Fort Worth', 'TX', '76102', 'Ibuprofen'),
(175, 'Rachel', 'Hunter', '1955-01-15', '2108527231', 'rachel.hunter@yahoo.com', '3756 Richard Course', 'San Antonio', 'TX', '78205', 'Ibuprofen'),
(176, 'Erica', 'Valencia', '1945-07-02', '7132794894', 'erica.valencia@yahoo.com', '55541 Michael Corner', 'Houston', 'TX', '77001', 'Peanuts'),
(177, 'Brenda', 'Rodriguez', '1952-05-18', '9155114905', 'brenda.rodriguez@hotmail.com', '32789 Larry Pines', 'El Paso', 'TX', '79901', 'Ants'),
(178, 'Victor', 'Martin', '1993-09-23', '9152036721', 'victor.martin@hotmail.com', '0851 Sherri Terrace', 'El Paso', 'TX', '79901', 'Ants'),
(179, 'Barbara', 'Clayton', '2021-04-28', '7133611484', 'barbara.clayton@hotmail.com', '0868 Felicia Falls', 'Houston', 'TX', '77001', 'Pollen'),
(180, 'Jessica', 'Garcia', '1953-03-05', '2143283404', 'jessica.garcia@hotmail.com', '8547 Williams Station Suite 336', 'Dallas', 'TX', '75201', 'Dairy'),
(181, 'Karen', 'Johnson', '2017-02-01', '8068635890', 'karen.johnson@hotmail.com', '176 Carson Motorway Apt. 029', 'Lubbock', 'TX', '79401', 'Peanuts'),
(182, 'Jorge', 'Walton', '2008-08-28', '2105362366', 'jorge.walton@gmail.com', '412 Becky Flats Suite 609', 'San Antonio', 'TX', '78205', 'Ibuprofen'),
(183, 'Brian', 'Lin', '1989-02-21', '3617666729', 'brian.lin@hotmail.com', '841 Julie Squares', 'Corpus Christi', 'TX', '78401', 'Acetaminophen'),
(184, 'Kari', 'Vega', '1953-03-24', '2102947992', 'kari.vega@gmail.com', '875 Page Brooks Suite 395', 'San Antonio', 'TX', '78205', 'Penicillin'),
(185, 'Tiffany', 'Hart', '1968-01-28', '8067823821', 'tiffany.hart@gmail.com', '951 Gallagher Streets Suite 930', 'Amarillo', 'TX', '79101', 'Peanuts'),
(186, 'Briana', 'Willis', '1989-07-05', '2146597806', 'briana.willis@gmail.com', '837 Matthew Inlet Suite 884', 'Dallas', 'TX', '75201', 'Grass'),
(187, 'Matthew', 'Jackson', '1937-03-28', '6820796059', 'matthew.jackson@hotmail.com', '957 Miller Burgs Apt. 599', 'Arlington', 'TX', '76010', 'Dairy'),
(188, 'Craig', 'Hamilton', '2002-06-29', '2140729328', 'craig.hamilton@hotmail.com', '8067 Allen Curve', 'Dallas', 'TX', '75201', 'None'),
(189, 'Karla', 'Massey', '2023-11-02', '6827085559', 'karla.massey@yahoo.com', '48633 Emma Road', 'Arlington', 'TX', '76010', 'Pollen'),
(190, 'Lisa', 'Bender', '1985-11-27', '8065991774', 'lisa.bender@yahoo.com', '3708 Carlos Tunnel Suite 680', 'Lubbock', 'TX', '79401', 'Ibuprofen'),
(191, 'Megan', 'Dennis', '1968-12-10', '2102060454', 'megan.dennis@yahoo.com', '124 George Union Apt. 386', 'San Antonio', 'TX', '78205', 'Dairy'),
(192, 'Peter', 'Gordon', '2019-03-03', '8069808381', 'peter.gordon@hotmail.com', '925 Cynthia Square Apt. 473', 'Amarillo', 'TX', '79101', 'Dairy'),
(193, 'Margaret', 'Wells', '1964-04-30', '7136855994', 'margaret.wells@hotmail.com', '5248 Barry Ville', 'Houston', 'TX', '77001', 'Aspirin'),
(194, 'Mark', 'Scott', '1980-06-06', '2148850897', 'mark.scott@hotmail.com', '8632 Acevedo Turnpike Suite 668', 'Dallas', 'TX', '75201', 'Latex'),
(195, 'Christopher', 'Smith', '1956-10-13', '6828068792', 'christopher.smith@hotmail.com', '44955 Justin Divide Suite 546', 'Arlington', 'TX', '76010', 'Penicillin'),
(196, 'Catherine', 'Donaldson', '1976-03-15', '2107776098', 'catherine.donaldson@hotmail.com', '7483 Travis Creek', 'San Antonio', 'TX', '78205', 'Ibuprofen'),
(197, 'Shannon', 'Watson', '1977-12-21', '8064190852', 'shannon.watson@yahoo.com', '1168 Henderson Fields Apt. 804', 'Lubbock', 'TX', '79401', 'Peanuts'),
(198, 'Melissa', 'Hart', '1952-10-21', '2146054605', 'melissa.hart@gmail.com', '0214 Jessica Burgs', 'Dallas', 'TX', '75201', 'Peanuts'),
(199, 'Jonathan', 'Bernard', '1980-01-27', '3616445939', 'jonathan.bernard@hotmail.com', '21780 Rodriguez Forks', 'Corpus Christi', 'TX', '78401', 'Ibuprofen'),
(200, 'Stephen', 'Schultz', '1956-10-10', '8062450621', 'stephen.schultz@yahoo.com', '3395 Erin Points', 'Lubbock', 'TX', '79401', 'Ants');

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
