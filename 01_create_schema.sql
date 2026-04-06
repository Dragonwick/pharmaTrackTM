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
