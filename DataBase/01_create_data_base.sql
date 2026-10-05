DROP DATABASE IF EXISTS ophthalmology_glaucoma_db;
CREATE DATABASE ophthalmology_glaucoma_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ophthalmology_glaucoma_db;

CREATE TABLE document_types (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE cities (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'Colombia',
    CONSTRAINT uq_city UNIQUE (name, department, country)
);

CREATE TABLE patients (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    document_type_id BIGINT NOT NULL,
    city_id BIGINT NULL,
    document_number VARCHAR(30) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    sex ENUM('F','M','O') NOT NULL,
    phone VARCHAR(30) NULL,
    email VARCHAR(150) NULL,
    address VARCHAR(200) NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT uq_patient_document UNIQUE (document_type_id, document_number),
    CONSTRAINT uq_patient_email UNIQUE (email),
    CONSTRAINT fk_patient_document_type FOREIGN KEY (document_type_id) REFERENCES document_types(id),
    CONSTRAINT fk_patient_city FOREIGN KEY (city_id) REFERENCES cities(id)
);

CREATE TABLE clinical_histories (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    history_number VARCHAR(30) NOT NULL UNIQUE,
    opening_date DATE NOT NULL,
    status ENUM('OPEN','CLOSED','INACTIVE') NOT NULL DEFAULT 'OPEN',
    notes TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT uq_history_patient UNIQUE (patient_id),
    CONSTRAINT fk_history_patient FOREIGN KEY (patient_id) REFERENCES patients(id)
);

CREATE TABLE specialties (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE healthcare_professionals (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    specialty_id BIGINT NOT NULL,
    license_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(30) NULL,
    email VARCHAR(150) NULL UNIQUE,
    active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT fk_professional_specialty FOREIGN KEY (specialty_id) REFERENCES specialties(id)
);

CREATE TABLE medical_visits (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    clinical_history_id BIGINT NOT NULL,
    professional_id BIGINT NOT NULL,
    visit_date DATETIME NOT NULL,
    reason TEXT NOT NULL,
    assessment TEXT NULL,
    plan TEXT NULL,
    status ENUM('OPEN','CLOSED','CANCELLED') NOT NULL DEFAULT 'OPEN',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT fk_visit_history FOREIGN KEY (clinical_history_id) REFERENCES clinical_histories(id),
    CONSTRAINT fk_visit_professional FOREIGN KEY (professional_id) REFERENCES healthcare_professionals(id)
);

CREATE TABLE diagnoses (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    diagnosis_type ENUM('GENERAL','GLAUCOMA','CATARACT','RETINA','OTHER') NOT NULL DEFAULT 'GENERAL',
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE visit_diagnoses (
    visit_id BIGINT NOT NULL,
    diagnosis_id BIGINT NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    notes TEXT NULL,
    PRIMARY KEY (visit_id, diagnosis_id),
    CONSTRAINT fk_visit_diagnosis_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT fk_visit_diagnosis_diagnosis FOREIGN KEY (diagnosis_id) REFERENCES diagnoses(id)
);

CREATE TABLE antecedent_types (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE patient_antecedents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    antecedent_type_id BIGINT NOT NULL,
    description TEXT NOT NULL,
    registered_at DATE NOT NULL,
    CONSTRAINT fk_antecedent_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_antecedent_type FOREIGN KEY (antecedent_type_id) REFERENCES antecedent_types(id)
);

CREATE TABLE allergies (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE
);

CREATE TABLE patient_allergies (
    patient_id BIGINT NOT NULL,
    allergy_id BIGINT NOT NULL,
    reaction TEXT NULL,
    PRIMARY KEY (patient_id, allergy_id),
    CONSTRAINT fk_patient_allergy_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_patient_allergy_allergy FOREIGN KEY (allergy_id) REFERENCES allergies(id)
);

CREATE TABLE ophthalmologic_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    visual_acuity_od VARCHAR(20) NULL,
    visual_acuity_oi VARCHAR(20) NULL,
    slit_lamp_findings TEXT NULL,
    fundus_findings TEXT NULL,
    observations TEXT NULL,
    CONSTRAINT fk_oph_exam_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE intraocular_pressures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD','OI') NOT NULL,
    pressure DECIMAL(5,2) NOT NULL,
    measured_at DATETIME NOT NULL,
    method VARCHAR(80) NOT NULL DEFAULT 'Goldmann',
    CONSTRAINT fk_iop_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT chk_iop_positive CHECK (pressure > 0),
    CONSTRAINT chk_iop_plausible CHECK (pressure <= 80)
);

CREATE TABLE pachymetry_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD','OI') NOT NULL,
    corneal_thickness DECIMAL(6,2) NOT NULL,
    exam_date DATE NOT NULL,
    interpretation TEXT NULL,
    CONSTRAINT fk_pachy_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT chk_pachy_positive CHECK (corneal_thickness > 0)
);

CREATE TABLE gonioscopy_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD','OI') NOT NULL,
    angle_grade VARCHAR(30) NOT NULL,
    pigmentation VARCHAR(80) NULL,
    exam_date DATE NOT NULL,
    interpretation TEXT NULL,
    CONSTRAINT fk_gonio_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE oct_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD','OI') NOT NULL,
    exam_date DATE NOT NULL,
    rnfl_average DECIMAL(6,2) NOT NULL,
    cup_disc_ratio DECIMAL(4,2) NULL,
    interpretation TEXT NULL,
    validated BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT fk_oct_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT chk_oct_rnfl_positive CHECK (rnfl_average > 0)
);

CREATE TABLE visual_field_exams (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    visit_id BIGINT NOT NULL,
    eye ENUM('OD','OI') NOT NULL,
    exam_date DATE NOT NULL,
    md DECIMAL(6,2) NOT NULL,
    psd DECIMAL(6,2) NOT NULL,
    vfi DECIMAL(5,2) NOT NULL,
    interpretation TEXT NULL,
    CONSTRAINT fk_vf_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT chk_vf_vfi CHECK (vfi BETWEEN 0 AND 100)
);

CREATE TABLE glaucoma_records (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    diagnosis_date DATE NOT NULL,
    glaucoma_type VARCHAR(100) NOT NULL,
    target_pressure_od DECIMAL(5,2) NULL,
    target_pressure_oi DECIMAL(5,2) NULL,
    clinical_status ENUM('STABLE','PROGRESSION','SUSPECT','CONTROLLED') NOT NULL DEFAULT 'SUSPECT',
    notes TEXT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NULL,
    CONSTRAINT uq_glaucoma_patient UNIQUE (patient_id),
    CONSTRAINT fk_glaucoma_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT chk_target_od_positive CHECK (target_pressure_od IS NULL OR target_pressure_od > 0),
    CONSTRAINT chk_target_oi_positive CHECK (target_pressure_oi IS NULL OR target_pressure_oi > 0)
);

CREATE TABLE glaucoma_controls (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    glaucoma_record_id BIGINT NOT NULL,
    visit_id BIGINT NOT NULL,
    control_date DATE NOT NULL,
    optic_nerve_status TEXT NULL,
    progression BOOLEAN NOT NULL DEFAULT FALSE,
    next_control_date DATE NULL,
    observations TEXT NULL,
    CONSTRAINT fk_control_glaucoma_record FOREIGN KEY (glaucoma_record_id) REFERENCES glaucoma_records(id),
    CONSTRAINT fk_control_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE medications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    concentration VARCHAR(60) NULL,
    pharmaceutical_form VARCHAR(80) NULL,
    active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE treatments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    visit_id BIGINT NULL,
    medication_id BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    dosage VARCHAR(120) NOT NULL,
    frequency VARCHAR(120) NOT NULL,
    status ENUM('ACTIVE','FINISHED','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
    notes TEXT NULL,
    CONSTRAINT fk_treatment_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_treatment_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id),
    CONSTRAINT fk_treatment_medication FOREIGN KEY (medication_id) REFERENCES medications(id),
    CONSTRAINT chk_treatment_dates CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE clinical_procedures (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    visit_id BIGINT NULL,
    procedure_type VARCHAR(120) NOT NULL,
    procedure_date DATE NOT NULL,
    eye ENUM('OD','OI') NULL,
    description TEXT NULL,
    CONSTRAINT fk_procedure_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_procedure_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE clinical_documents (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NOT NULL,
    visit_id BIGINT NULL,
    document_type VARCHAR(80) NOT NULL,
    file_name VARCHAR(200) NOT NULL,
    file_path VARCHAR(300) NOT NULL,
    uploaded_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at DATETIME NULL,
    CONSTRAINT fk_document_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_document_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE TABLE audit_logs (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id BIGINT NOT NULL,
    action VARCHAR(20) NOT NULL,
    old_value TEXT NULL,
    new_value TEXT NULL,
    changed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_by VARCHAR(100) NULL
);

CREATE TABLE internal_notifications (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    patient_id BIGINT NULL,
    visit_id BIGINT NULL,
    message VARCHAR(300) NOT NULL,
    severity ENUM('INFO','WARNING','CRITICAL') NOT NULL DEFAULT 'INFO',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME NULL,
    CONSTRAINT fk_notification_patient FOREIGN KEY (patient_id) REFERENCES patients(id),
    CONSTRAINT fk_notification_visit FOREIGN KEY (visit_id) REFERENCES medical_visits(id)
);

CREATE INDEX idx_patient_name ON patients(last_name, first_name);
CREATE INDEX idx_visit_date ON medical_visits(visit_date);
CREATE INDEX idx_iop_visit_eye_date ON intraocular_pressures(visit_id, eye, measured_at);
CREATE INDEX idx_oct_visit_date ON oct_exams(visit_id, exam_date);
CREATE INDEX idx_vf_visit_date ON visual_field_exams(visit_id, exam_date);
CREATE INDEX idx_treatment_patient_status ON treatments(patient_id, status);

DELIMITER $$

CREATE TRIGGER trg_patients_before_insert
BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
    SET NEW.first_name = TRIM(NEW.first_name);
    SET NEW.last_name = TRIM(NEW.last_name);
    SET NEW.document_number = UPPER(TRIM(NEW.document_number));
    IF NEW.email IS NOT NULL THEN
        SET NEW.email = LOWER(TRIM(NEW.email));
    END IF;
    IF NEW.birth_date > CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La fecha de nacimiento no puede ser futura';
    END IF;
END $$

CREATE TRIGGER trg_patients_before_update
BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
    SET NEW.updated_at = CURRENT_TIMESTAMP;
    SET NEW.first_name = TRIM(NEW.first_name);
    SET NEW.last_name = TRIM(NEW.last_name);
    IF NEW.email IS NOT NULL THEN
        SET NEW.email = LOWER(TRIM(NEW.email));
    END IF;
END $$

CREATE TRIGGER trg_patients_after_insert
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs(table_name, record_id, action, new_value)
    VALUES('patients', NEW.id, 'INSERT', CONCAT(NEW.first_name, ' ', NEW.last_name));
END $$

CREATE TRIGGER trg_patients_after_update
AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs(table_name, record_id, action, old_value, new_value)
    VALUES(
        'patients',
        NEW.id,
        'UPDATE',
        CONCAT(OLD.first_name, ' ', OLD.last_name, ' - ', COALESCE(OLD.email, 'sin correo')),
        CONCAT(NEW.first_name, ' ', NEW.last_name, ' - ', COALESCE(NEW.email, 'sin correo'))
    );
END $$

CREATE TRIGGER trg_iop_after_insert
AFTER INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
    DECLARE v_patient_id BIGINT;

    SELECT ch.patient_id INTO v_patient_id
    FROM medical_visits mv
    INNER JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
    WHERE mv.id = NEW.visit_id;

    INSERT INTO audit_logs(table_name, record_id, action, new_value)
    VALUES('intraocular_pressures', NEW.id, 'INSERT', CONCAT('PIO ', NEW.eye, ': ', NEW.pressure));

    IF NEW.pressure > 21 THEN
        INSERT INTO internal_notifications(patient_id, visit_id, message, severity)
        VALUES(
            v_patient_id,
            NEW.visit_id,
            CONCAT('Presion intraocular elevada en ', NEW.eye, ': ', NEW.pressure, ' mmHg'),
            'WARNING'
        );
    END IF;
END $$

CREATE FUNCTION fn_patient_age(p_birth_date DATE)
RETURNS INT
NOT DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, p_birth_date, CURRENT_DATE);
END $$

CREATE FUNCTION fn_eye_name(p_eye VARCHAR(2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    RETURN CASE p_eye
        WHEN 'OD' THEN 'Ojo derecho'
        WHEN 'OI' THEN 'Ojo izquierdo'
        ELSE 'No definido'
    END;
END $$

CREATE PROCEDURE sp_get_patient_visits(IN p_patient_id BIGINT)
BEGIN
    SELECT
        mv.id,
        mv.visit_date,
        mv.reason,
        mv.assessment,
        mv.plan
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p_patient_id
    ORDER BY mv.visit_date DESC;
END $$

CREATE PROCEDURE sp_register_iop(
    IN p_visit_id BIGINT,
    IN p_eye VARCHAR(2),
    IN p_pressure DECIMAL(5,2),
    IN p_measured_at DATETIME
)
BEGIN
    IF p_eye NOT IN ('OD', 'OI') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El ojo debe ser OD u OI';
    END IF;

    IF p_pressure <= 0 OR p_pressure > 80 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La PIO debe estar entre 1 y 80 mmHg';
    END IF;

    INSERT INTO intraocular_pressures(visit_id, eye, pressure, measured_at)
    VALUES(p_visit_id, p_eye, p_pressure, p_measured_at);
END $$

CREATE FUNCTION fn_iop_status(p_pressure DECIMAL(5,2))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    IF p_pressure > 21 THEN
        RETURN 'Elevada';
    ELSE
        RETURN 'Normal';
    END IF;
END $$

CREATE PROCEDURE sp_get_active_treatments(IN p_patient_id BIGINT)
BEGIN
    SELECT
        t.id,
        m.name AS medication,
        t.dosage,
        t.frequency,
        t.start_date
    FROM treatments t
    INNER JOIN medications m ON m.id = t.medication_id
    WHERE t.patient_id = p_patient_id
      AND t.status = 'ACTIVE'
    ORDER BY t.start_date DESC;
END $$

CREATE EVENT ev_daily_audit_summary
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
    INSERT INTO audit_logs(table_name, record_id, action, new_value)
    VALUES('system', 0, 'EVENT', 'Resumen diario ejecutado');
END $$

DELIMITER ;

CREATE VIEW vw_patient_last_visit AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    MAX(mv.visit_date) AS last_visit
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
GROUP BY p.id, p.first_name, p.last_name;

CREATE VIEW vw_iop_average_by_eye AS
SELECT
    eye,
    AVG(pressure) AS average_pressure,
    MIN(pressure) AS minimum_pressure,
    MAX(pressure) AS maximum_pressure
FROM intraocular_pressures
GROUP BY eye;

CREATE VIEW vw_glaucoma_patients AS
SELECT
    p.id AS patient_id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    gr.glaucoma_type,
    gr.clinical_status,
    gr.diagnosis_date
FROM patients p
INNER JOIN glaucoma_records gr ON gr.patient_id = p.id;
