-- Trigger 1
-- Crear un trigger que elimine espacios externos de los nombres de pacientes antes de insertarlos.

DELIMITER $$

CREATE TRIGGER ex01_trim_patients BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
 SET NEW.first_name=TRIM(NEW.first_name); SET NEW.last_name=TRIM(NEW.last_name);
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex01_trim_patients';

-- Trigger 2
-- Convertir automáticamente el correo del paciente a minúsculas.

DELIMITER $$

CREATE TRIGGER ex02_lower_email BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
 IF NEW.email IS NOT NULL THEN SET NEW.email=LOWER(NEW.email); END IF;
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex02_lower_email';

-- Trigger 3
-- Convertir el número de documento a mayúsculas cuando contenga caracteres.

DELIMITER $$

CREATE TRIGGER ex03_upper_document BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
 SET NEW.document_number=UPPER(NEW.document_number);
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex03_upper_document';

-- Trigger 4
-- Impedir registrar una fecha de nacimiento futura.

DELIMITER $$

CREATE TRIGGER ex04_birth_date BEFORE INSERT ON patients
FOR EACH ROW
BEGIN
 IF NEW.birth_date>CURDATE() THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Nacimiento futuro'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex04_birth_date';

-- Trigger 5
-- Impedir registrar una presión intraocular negativa.

DELIMITER $$

CREATE TRIGGER ex05_positive_iop BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
 IF NEW.pressure IS NULL OR NEW.pressure<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PIO no puede ser negativa'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex05_positive_iop';

-- Trigger 6
-- Impedir registrar una PIO superior a un límite definido para datos plausibles.

DELIMITER $$

CREATE TRIGGER ex06_iop_limit BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
 IF NEW.pressure>80 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PIO mayor de 80'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex06_iop_limit';

-- Trigger 7
-- Validar que el campo eye solo admita OD u OI.

DELIMITER $$

CREATE TRIGGER ex07_eye_iop BEFORE INSERT ON intraocular_pressures
FOR EACH ROW
BEGIN
 IF NEW.eye IS NULL OR NEW.eye NOT IN('OD','OI') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo invalido'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex07_eye_iop';

-- Trigger 8
-- Impedir que un tratamiento tenga fecha final anterior a la inicial.

DELIMITER $$

CREATE TRIGGER ex08_treatment_dates BEFORE INSERT ON treatments
FOR EACH ROW
BEGIN
 IF NEW.end_date<NEW.start_date THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fechas incorrectas'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex08_treatment_dates';

-- Trigger 9
-- Validar que el VFI de un campo visual esté entre 0 y 100.

DELIMITER $$

CREATE TRIGGER ex09_visual_vfi BEFORE INSERT ON visual_field_exams
FOR EACH ROW
BEGIN
 IF NEW.vfi IS NULL OR NEW.vfi NOT BETWEEN 0 AND 100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='VFI invalido'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex09_visual_vfi';

-- Trigger 10
-- Validar que la paquimetría sea mayor que cero.

DELIMITER $$

CREATE TRIGGER ex10_pachy_positive BEFORE INSERT ON pachymetry_exams
FOR EACH ROW
BEGIN
 IF NEW.corneal_thickness IS NULL OR NEW.corneal_thickness<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paquimetria invalida'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex10_pachy_positive';

-- Trigger 11
-- Registrar en auditoría la creación de un nuevo paciente.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_patients_after_insert $$
CREATE TRIGGER trg_patients_after_insert
AFTER INSERT ON patients
FOR EACH ROW
BEGIN
    INSERT INTO audit_logs(table_name, record_id, action, new_value)
    VALUES('patients', NEW.id, 'INSERT', CONCAT(NEW.first_name, ' ', NEW.last_name));
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'trg_patients_after_insert';

-- Trigger 12
-- Registrar en auditoría la creación de una historia clínica.

DELIMITER $$

CREATE TRIGGER ex12_audit_insert AFTER INSERT ON clinical_histories
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('clinical_histories',NEW.id,'INSERT',NULL,NEW.history_number,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex12_audit_insert';

-- Trigger 13
-- Registrar automáticamente en auditoría cada nueva consulta.

DELIMITER $$

CREATE TRIGGER ex13_audit_insert AFTER INSERT ON medical_visits
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('medical_visits',NEW.id,'INSERT',NULL,NEW.reason,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex13_audit_insert';

-- Trigger 14
-- Registrar cada nuevo diagnóstico asociado a una consulta.

DELIMITER $$

CREATE TRIGGER ex14_audit_insert AFTER INSERT ON visit_diagnoses
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('visit_diagnoses',NEW.visit_id,'INSERT',NULL,CAST(NEW.diagnosis_id AS CHAR),CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex14_audit_insert';

-- Trigger 15
-- Registrar cada nueva medición de presión intraocular.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_iop_after_insert $$
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

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'trg_iop_after_insert';

-- Trigger 16
-- Registrar cada nuevo tratamiento.

DELIMITER $$

CREATE TRIGGER ex16_audit_insert AFTER INSERT ON treatments
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('treatments',NEW.id,'INSERT',NULL,CAST(NEW.medication_id AS CHAR),CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex16_audit_insert';

-- Trigger 17
-- Registrar cada nuevo procedimiento.

DELIMITER $$

CREATE TRIGGER ex17_audit_insert AFTER INSERT ON clinical_procedures
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('clinical_procedures',NEW.id,'INSERT',NULL,NEW.procedure_type,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex17_audit_insert';

-- Trigger 18
-- Registrar en auditoría cada nuevo estudio OCT.

DELIMITER $$

CREATE TRIGGER ex18_audit_insert AFTER INSERT ON oct_exams
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('oct_exams',NEW.id,'INSERT',NULL,CAST(NEW.rnfl_average AS CHAR),CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex18_audit_insert';

-- Trigger 19
-- Registrar cada campo visual creado.

DELIMITER $$

CREATE TRIGGER ex19_audit_insert AFTER INSERT ON visual_field_exams
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('visual_field_exams',NEW.id,'INSERT',NULL,CAST(NEW.vfi AS CHAR),CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex19_audit_insert';

-- Trigger 20
-- Crear una notificación interna cuando se registre una PIO mayor que un valor determinado.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_iop_after_insert $$
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

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'trg_iop_after_insert';

-- Trigger 21
-- Actualizar automáticamente updated_at antes de modificar un paciente.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_patients_before_update $$
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

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'trg_patients_before_update';

-- Trigger 22
-- Actualizar updated_at antes de modificar una consulta.

DELIMITER $$

CREATE TRIGGER ex22_visit_updated_at BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
 SET NEW.updated_at=CURRENT_TIMESTAMP;
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex22_visit_updated_at';

-- Trigger 23
-- Impedir modificar el número de documento una vez creada la historia clínica.

DELIMITER $$

CREATE TRIGGER ex23_document_lock BEFORE UPDATE ON patients
FOR EACH ROW
BEGIN
 IF NOT(NEW.document_number <=> OLD.document_number) AND EXISTS(SELECT 1 FROM clinical_histories WHERE patient_id=OLD.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Documento protegido'; END IF;
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex23_document_lock';

-- Trigger 24
-- Impedir asignar una fecha de consulta futura no permitida.

DELIMITER $$

CREATE TRIGGER ex24_future_visit BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
 IF NEW.visit_date>NOW() THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consulta futura no permitida'; END IF;
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex24_future_visit';

-- Trigger 25
-- Validar que una nueva presión objetivo sea positiva.

DELIMITER $$

CREATE TRIGGER ex25_target_positive BEFORE UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
 IF NEW.target_pressure_od<=0 OR NEW.target_pressure_oi<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Presion objetivo invalida'; END IF;
END $$

DELIMITER ;


SHOW TRIGGERS WHERE `Trigger` = 'ex25_target_positive';

-- Trigger 26
-- Impedir establecer una fecha final de tratamiento anterior a su inicio.

DELIMITER $$

CREATE TRIGGER ex26_treatment_dates BEFORE UPDATE ON treatments
FOR EACH ROW
BEGIN
 IF NEW.end_date<NEW.start_date THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fecha final invalida'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex26_treatment_dates';

-- Trigger 27
-- Evitar modificar un examen OCT que haya sido marcado como validado.

DELIMITER $$

CREATE TRIGGER ex27_protect_validated_oct BEFORE UPDATE ON oct_exams
FOR EACH ROW
BEGIN
 IF OLD.validated=TRUE AND (NOT(NEW.interpretation <=> OLD.interpretation) OR NOT(NEW.rnfl_average <=> OLD.rnfl_average) OR NOT(NEW.exam_date <=> OLD.exam_date)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='OCT validado'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex27_protect_validated_oct';

-- Trigger 28
-- Evitar modificar una consulta marcada como cerrada.

DELIMITER $$

CREATE TRIGGER ex28_protect_closed_visit BEFORE UPDATE ON medical_visits
FOR EACH ROW
BEGIN
 IF OLD.status='CLOSED' AND (NOT(NEW.reason <=> OLD.reason) OR NOT(NEW.assessment <=> OLD.assessment) OR NOT(NEW.plan <=> OLD.plan)) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Consulta cerrada'; END IF;
END $$

DELIMITER ;

SHOW TRIGGERS WHERE `Trigger` = 'ex28_protect_closed_visit';

-- Trigger 29
-- Validar valores del campo visual antes de una actualización.

DELIMITER $$

CREATE TRIGGER ex29_visual_check_update BEFORE UPDATE ON visual_field_exams
FOR EACH ROW
BEGIN
 IF NEW.vfi IS NULL OR NEW.vfi NOT BETWEEN 0 AND 100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='VFI invalido'; END IF;
END $$

DELIMITER ;

SHOW TRIGGERS WHERE `Trigger` = 'ex29_visual_check_update';

-- Trigger 30
-- Normalizar observaciones eliminando espacios innecesarios antes de actualizar.

DELIMITER $$

CREATE TRIGGER ex30_trim_observations BEFORE UPDATE ON ophthalmologic_exams
FOR EACH ROW
BEGIN
 IF NEW.observations IS NOT NULL THEN SET NEW.observations=TRIM(NEW.observations); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex30_trim_observations';

-- Trigger 31
-- Registrar cambios de datos personales del paciente.

DELIMITER $$

DROP TRIGGER IF EXISTS trg_patients_after_update $$
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

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'trg_patients_after_update';

-- Trigger 32
-- Guardar valor anterior y nuevo del correo del paciente.

DELIMITER $$

CREATE TRIGGER ex32_audit_email AFTER UPDATE ON patients
FOR EACH ROW
BEGIN
 IF NOT(OLD.email <=> NEW.email) THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('patients',NEW.id,'EMAIL_CHANGE',OLD.email,NEW.email,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex32_audit_email';

-- Trigger 33
-- Registrar cambios en la presión objetivo.

DELIMITER $$

CREATE TRIGGER ex33_audit_update AFTER UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
 IF NOT(OLD.target_pressure_od <=> NEW.target_pressure_od) OR NOT(OLD.target_pressure_oi <=> NEW.target_pressure_oi) THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('glaucoma_records',NEW.id,'UPDATE',CONCAT_WS(',',OLD.target_pressure_od,OLD.target_pressure_oi),CONCAT_WS(',',NEW.target_pressure_od,NEW.target_pressure_oi),CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex33_audit_update';

-- Trigger 34
-- Auditar cambios en el estado del glaucoma.

DELIMITER $$

CREATE TRIGGER ex34_audit_update AFTER UPDATE ON glaucoma_records
FOR EACH ROW
BEGIN
 IF NOT(OLD.clinical_status <=> NEW.clinical_status) THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('glaucoma_records',NEW.id,'UPDATE',OLD.clinical_status,NEW.clinical_status,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex34_audit_update';

-- Trigger 35
-- Registrar cambios en tratamientos.

DELIMITER $$

CREATE TRIGGER ex35_audit_update AFTER UPDATE ON treatments
FOR EACH ROW
BEGIN
 IF TRUE THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('treatments',NEW.id,'UPDATE',OLD.status,NEW.status,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex35_audit_update';

-- Trigger 36
-- Registrar cambios en diagnósticos.

DELIMITER $$

CREATE TRIGGER ex36_audit_update AFTER UPDATE ON diagnoses
FOR EACH ROW
BEGIN
 IF TRUE THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('diagnoses',NEW.id,'UPDATE',OLD.name,NEW.name,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex36_audit_update';

-- Trigger 37
-- Registrar cambios de interpretación de OCT.

DELIMITER $$

CREATE TRIGGER ex37_audit_update AFTER UPDATE ON oct_exams
FOR EACH ROW
BEGIN
 IF NOT(OLD.interpretation <=> NEW.interpretation) THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('oct_exams',NEW.id,'UPDATE',OLD.interpretation,NEW.interpretation,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex37_audit_update';

-- Trigger 38
-- Registrar modificaciones de campos visuales.

DELIMITER $$

CREATE TRIGGER ex38_audit_update AFTER UPDATE ON visual_field_exams
FOR EACH ROW
BEGIN
 IF TRUE THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('visual_field_exams',NEW.id,'UPDATE',OLD.interpretation,NEW.interpretation,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex38_audit_update';

-- Trigger 39
-- Generar una alerta cuando una PIO sea actualizada a un valor superior al objetivo.

DELIMITER $$

CREATE TRIGGER ex39_iop_alert AFTER UPDATE ON intraocular_pressures
FOR EACH ROW
BEGIN
 DECLARE v_patient BIGINT; DECLARE v_target DECIMAL(5,2);
 SELECT ch.patient_id INTO v_patient FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=NEW.visit_id;
 SELECT CASE WHEN NEW.eye='OD' THEN target_pressure_od ELSE target_pressure_oi END INTO v_target FROM glaucoma_records WHERE patient_id=v_patient LIMIT 1;
 IF v_target IS NOT NULL AND NEW.pressure>v_target AND NEW.pressure>OLD.pressure THEN INSERT INTO internal_notifications(patient_id,visit_id,message,severity) VALUES(v_patient,NEW.visit_id,CONCAT('PIO actualizada sobre objetivo: ',NEW.pressure),'WARNING'); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex39_iop_alert';

-- Trigger 40
-- Registrar cuándo un tratamiento cambia de activo a finalizado.

DELIMITER $$

CREATE TRIGGER ex40_audit_update AFTER UPDATE ON treatments
FOR EACH ROW
BEGIN
 IF OLD.status='ACTIVE' AND NEW.status='FINISHED' THEN INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('treatments',NEW.id,'UPDATE',OLD.status,NEW.status,CURRENT_USER()); END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex40_audit_update';

-- Trigger 41
-- Guardar una copia de un paciente antes de eliminarlo.

CREATE TABLE IF NOT EXISTS backup_patients LIKE patients;

DELIMITER $$

CREATE TRIGGER ex41_backup_delete BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
 INSERT INTO backup_patients SELECT * FROM patients WHERE id=OLD.id ON DUPLICATE KEY UPDATE id=OLD.id;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex41_backup_delete';

-- Trigger 42
-- Guardar una copia de una consulta eliminada.

CREATE TABLE IF NOT EXISTS backup_medical_visits LIKE medical_visits;

DELIMITER $$

CREATE TRIGGER ex42_backup_delete BEFORE DELETE ON medical_visits
FOR EACH ROW
BEGIN
 INSERT INTO backup_medical_visits SELECT * FROM medical_visits WHERE id=OLD.id ON DUPLICATE KEY UPDATE id=OLD.id;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex42_backup_delete';

-- Trigger 43
-- Guardar un histórico de un tratamiento eliminado.

CREATE TABLE IF NOT EXISTS backup_treatments LIKE treatments;

DELIMITER $$

CREATE TRIGGER ex43_backup_delete BEFORE DELETE ON treatments
FOR EACH ROW
BEGIN
 INSERT INTO backup_treatments SELECT * FROM treatments WHERE id=OLD.id ON DUPLICATE KEY UPDATE id=OLD.id;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex43_backup_delete';

-- Trigger 44
-- Registrar en auditoría la eliminación de un diagnóstico.

DELIMITER $$

CREATE TRIGGER ex44_delete_diagnosis AFTER DELETE ON diagnoses
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('diagnoses',OLD.id,'DELETE',OLD.name,NULL,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex44_delete_diagnosis';

-- Trigger 45
-- Impedir eliminar pacientes que tengan historia clínica.

DELIMITER $$

CREATE TRIGGER ex45_protect_patient BEFORE DELETE ON patients
FOR EACH ROW
BEGIN
 IF EXISTS(SELECT 1 FROM clinical_histories WHERE patient_id=OLD.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente con historia'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex45_protect_patient';

-- Trigger 46
-- Impedir eliminar profesionales con consultas registradas.

DELIMITER $$

CREATE TRIGGER ex46_protect_professional BEFORE DELETE ON healthcare_professionals
FOR EACH ROW
BEGIN
 IF EXISTS(SELECT 1 FROM medical_visits WHERE professional_id=OLD.id) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Profesional tiene consultas'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex46_protect_professional';

-- Trigger 47
-- Impedir eliminar medicamentos actualmente utilizados en tratamientos activos.

DELIMITER $$

CREATE TRIGGER ex47_protect_medication BEFORE DELETE ON medications
FOR EACH ROW
BEGIN
 IF EXISTS(SELECT 1 FROM treatments WHERE medication_id=OLD.id AND status='ACTIVE') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Medicamento en tratamiento'; END IF;
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex47_protect_medication';

-- Trigger 48
-- Registrar automáticamente la eliminación de un examen OCT.

DELIMITER $$

CREATE TRIGGER ex48_delete_oct AFTER DELETE ON oct_exams
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('oct_exams',OLD.id,'DELETE',CONCAT('RNFL ',OLD.rnfl_average),NULL,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex48_delete_oct';

-- Trigger 49
-- Registrar quién eliminó un documento clínico.

DELIMITER $$

CREATE TRIGGER ex49_delete_document AFTER DELETE ON clinical_documents
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('clinical_documents',OLD.id,'DELETE',OLD.file_name,NULL,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex49_delete_document';

-- Trigger 50
-- Implementar un esquema completo de auditoría mediante triggers para INSERT, UPDATE y DELETE sobre la tabla patients.

DELIMITER $$

CREATE TRIGGER ex50_patient_delete AFTER DELETE ON patients
FOR EACH ROW
BEGIN
 INSERT INTO audit_logs(table_name,record_id,action,old_value,new_value,changed_by) VALUES('patients',OLD.id,'DELETE',CONCAT(OLD.first_name,' ',OLD.last_name),NULL,CURRENT_USER());
END $$

DELIMITER ;

-- Verificar que se creó
SHOW TRIGGERS WHERE `Trigger` = 'ex50_patient_delete';
