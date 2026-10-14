-- Procedimiento 1
-- Crear un procedimiento que liste todos los pacientes.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_list_patients $$
CREATE PROCEDURE sp_list_patients()
BEGIN
 SELECT * FROM patients;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_list_patients();

-- Procedimiento 2
-- Crear un procedimiento que reciba el ID de un paciente y muestre sus datos.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patients_id $$
CREATE PROCEDURE sp_patients_id(IN p_id BIGINT)
BEGIN
 SELECT * FROM patients WHERE id=p_id;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patients_id(1);

-- Procedimiento 3
-- Crear un procedimiento que busque un paciente por número de documento.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patients_documents $$
CREATE PROCEDURE sp_patients_documents(IN p_document VARCHAR(30))
BEGIN
 SELECT * FROM patients WHERE document_number=p_document;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patients_documents('1001001001');

-- Procedimiento 4
-- Crear un procedimiento que liste todas las consultas de un paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patients_consults $$
CREATE PROCEDURE sp_patients_consults(IN p_id BIGINT)
BEGIN
 SELECT mv.* FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_id ORDER BY mv.visit_date;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patients_consults(1);

-- Procedimiento 5
-- Crear un procedimiento que muestre todos los profesionales.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_healthcare_professionals $$
CREATE PROCEDURE sp_healthcare_professionals()
BEGIN
 SELECT * FROM healthcare_professionals;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_healthcare_professionals();

-- Procedimiento 6
-- Crear un procedimiento que reciba una especialidad y muestre sus profesionales.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_specialties $$
CREATE PROCEDURE sp_specialties(IN p_specialty VARCHAR(100))
BEGIN
 SELECT hp.* FROM healthcare_professionals hp JOIN specialties s ON s.id=hp.specialty_id WHERE s.name=p_specialty;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_specialties('Glaucoma');

-- Procedimiento 7
-- Crear un procedimiento que liste diagnósticos.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_list_diagnoses $$
CREATE PROCEDURE sp_list_diagnoses()
BEGIN
 SELECT * FROM diagnoses;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_list_diagnoses();

-- Procedimiento 8
-- Crear un procedimiento que muestre medicamentos activos.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_list_medications $$
CREATE PROCEDURE sp_list_medications()
BEGIN
 SELECT * FROM medications WHERE active=TRUE;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_list_medications();

-- Procedimiento 9
-- Crear un procedimiento que liste procedimientos clínicos realizados a un paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_list_procedures $$
CREATE PROCEDURE sp_list_procedures(IN p_patient_id BIGINT)
BEGIN
 SELECT * FROM clinical_procedures WHERE patient_id=p_patient_id ORDER BY procedure_date;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_list_procedures(1);

-- Procedimiento 10
-- Crear un procedimiento para consultar todos los controles de glaucoma de un paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_glaucoma_records $$
CREATE PROCEDURE sp_glaucoma_records(IN p_patient_id BIGINT)
BEGIN
 SELECT gc.* FROM glaucoma_controls gc JOIN glaucoma_records gr ON gr.id=gc.glaucoma_record_id WHERE gr.patient_id=p_patient_id ORDER BY gc.control_date;
END $$

DELIMITER ;


CALL sp_glaucoma_records(1);

-- Procedimiento 11
-- Crear un procedimiento para registrar un nuevo paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_patient $$
CREATE PROCEDURE sp_create_patient(IN p_doc_type BIGINT, IN p_city BIGINT, IN p_document VARCHAR(30), IN p_first VARCHAR(100), IN p_last VARCHAR(100), IN p_birth DATE, IN p_sex VARCHAR(1), IN p_phone VARCHAR(30), IN p_email VARCHAR(150))
BEGIN
 INSERT INTO patients(document_type_id,city_id,document_number,first_name,last_name,birth_date,sex,phone,email) VALUES(p_doc_type,p_city,p_document,p_first,p_last,p_birth,p_sex,p_phone,p_email);
END $$

DELIMITER ;

CALL sp_create_patient(1, 1, '9900000021', 'Juan', 'Prueba', '2000-04-01', 'M', '3009990021', 'juan.prueba21@example.com');

-- Procedimiento 12
-- Crear un procedimiento para crear una historia clínica.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_history $$
CREATE PROCEDURE sp_create_history(IN p_patient BIGINT, IN p_number VARCHAR(30), IN p_date DATE)
BEGIN
 INSERT INTO clinical_histories(patient_id,history_number,opening_date) VALUES(p_patient,p_number,p_date);
END $$

DELIMITER ;

CALL sp_create_history(21, 'HC-0021', '2026-10-08');

-- Procedimiento 13
-- Crear un procedimiento para registrar una consulta médica.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_visit $$
CREATE PROCEDURE sp_create_visit(IN p_history BIGINT, IN p_prof BIGINT, IN p_date DATETIME, IN p_reason TEXT)
BEGIN
 INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(p_history,p_prof,p_date,p_reason);
END $$

DELIMITER ;

CALL sp_create_visit(21, 1, '2026-10-08 09:00:00', 'Revision general de prueba');

-- Procedimiento 14
-- Crear un procedimiento para registrar un diagnóstico asociado a una consulta.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_visit_diagnosis $$
CREATE PROCEDURE sp_create_visit_diagnosis(IN p_visit BIGINT, IN p_diagnosis BIGINT)
BEGIN
 INSERT INTO visit_diagnoses(visit_id,diagnosis_id,is_primary) VALUES(p_visit,p_diagnosis,TRUE);
END $$

DELIMITER ;

CALL sp_create_visit_diagnosis(34, 1);

-- Procedimiento 15
-- Crear un procedimiento para registrar una medición de PIO.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_iop $$
CREATE PROCEDURE sp_create_iop(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_pressure DECIMAL(5,2), IN p_date DATETIME)
BEGIN
 CALL sp_register_iop(p_visit,p_eye,p_pressure,p_date);
END $$

DELIMITER ;

CALL sp_create_iop(34, 'OD', 18.00, '2026-10-08 09:15:00');

-- Procedimiento 16
-- Crear un procedimiento para registrar un control de glaucoma.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_glaucoma_control $$
CREATE PROCEDURE sp_create_glaucoma_control(IN p_record BIGINT, IN p_visit BIGINT, IN p_date DATE, IN p_next DATE)
BEGIN
 INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,next_control_date) VALUES(p_record,p_visit,p_date,p_next);
END $$

DELIMITER ;

CALL sp_create_glaucoma_control(1, 1, '2026-10-08', '2027-01-08');

-- Procedimiento 17
-- Crear un procedimiento para registrar un examen OCT.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_oct $$
CREATE PROCEDURE sp_create_oct(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_date DATE, IN p_rnfl DECIMAL(6,2))
BEGIN
 INSERT INTO oct_exams(visit_id,eye,exam_date,rnfl_average) VALUES(p_visit,p_eye,p_date,p_rnfl);
END $$

DELIMITER ;

CALL sp_create_oct(34, 'OD', '2026-10-08', 90.00);

-- Procedimiento 18
-- Crear un procedimiento para registrar un campo visual.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_visual_field $$
CREATE PROCEDURE sp_create_visual_field(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_date DATE, IN p_md DECIMAL(6,2), IN p_psd DECIMAL(6,2), IN p_vfi DECIMAL(5,2))
BEGIN
 INSERT INTO visual_field_exams(visit_id,eye,exam_date,md,psd,vfi) VALUES(p_visit,p_eye,p_date,p_md,p_psd,p_vfi);
END $$

DELIMITER ;

CALL sp_create_visual_field(34, 'OD', '2026-10-08', -2.00, 2.00, 95.00);

-- Procedimiento 19
-- Crear un procedimiento para registrar una paquimetría.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_pachymetry $$
CREATE PROCEDURE sp_create_pachymetry(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_date DATE, IN p_thickness DECIMAL(6,2))
BEGIN
 INSERT INTO pachymetry_exams(visit_id,eye,exam_date,corneal_thickness) VALUES(p_visit,p_eye,p_date,p_thickness);
END $$

DELIMITER ;

CALL sp_create_pachymetry(34, 'OD', '2026-10-08', 540.00);

-- Procedimiento 20
-- Crear un procedimiento para registrar un tratamiento.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_create_treatment $$
CREATE PROCEDURE sp_create_treatment(IN p_patient BIGINT, IN p_visit BIGINT, IN p_med BIGINT, IN p_start DATE, IN p_dose VARCHAR(120), IN p_frequency VARCHAR(120))
BEGIN
 INSERT INTO treatments(patient_id,visit_id,medication_id,start_date,dosage,frequency) VALUES(p_patient,p_visit,p_med,p_start,p_dose,p_frequency);
END $$

DELIMITER ;

CALL sp_create_treatment(21, 34, 1, '2026-10-08', 'Una gota', 'Cada noche');

-- Procedimiento 21
-- Crear un procedimiento para actualizar teléfono y correo de un paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_patient_contact $$
CREATE PROCEDURE sp_update_patient_contact(IN p_id BIGINT, IN p_phone VARCHAR(30), IN p_email VARCHAR(150))
BEGIN
 UPDATE patients SET phone=p_phone, email=p_email WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_update_patient_contact(21, '3009990033', 'juan.actualizado21@example.com');

-- Procedimiento 22
-- Crear un procedimiento para modificar el estado de una historia clínica.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_history_status $$
CREATE PROCEDURE sp_update_history_status(IN p_id BIGINT, IN p_status VARCHAR(15))
BEGIN
 UPDATE clinical_histories SET status=p_status WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_update_history_status(21, 'OPEN');

-- Procedimiento 23
-- Crear un procedimiento para actualizar observaciones de una consulta.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_visit_notes $$
CREATE PROCEDURE sp_update_visit_notes(IN p_id BIGINT, IN p_notes TEXT)
BEGIN
 UPDATE medical_visits SET assessment=p_notes WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_update_visit_notes(34, 'Paciente estable durante la revision');

-- Procedimiento 24
-- Crear un procedimiento para modificar la presión objetivo de un paciente con glaucoma.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_target_pressure $$
CREATE PROCEDURE sp_update_target_pressure(IN p_patient BIGINT, IN p_od DECIMAL(5,2), IN p_oi DECIMAL(5,2))
BEGIN
 UPDATE glaucoma_records SET target_pressure_od=p_od,target_pressure_oi=p_oi WHERE patient_id=p_patient;
END $$

DELIMITER ;

CALL sp_update_target_pressure(1, 17.00, 17.00);

-- Procedimiento 25
-- Crear un procedimiento para finalizar un tratamiento.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_finish_treatment $$
CREATE PROCEDURE sp_finish_treatment(IN p_id BIGINT, IN p_end DATE)
BEGIN
 UPDATE treatments SET status='FINISHED',end_date=p_end WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_finish_treatment(1, '2026-10-08');

-- Procedimiento 26
-- Crear un procedimiento para cambiar el medicamento de un tratamiento.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_change_treatment_med $$
CREATE PROCEDURE sp_change_treatment_med(IN p_id BIGINT, IN p_med BIGINT)
BEGIN
 UPDATE treatments SET medication_id=p_med WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_change_treatment_med(1, 2);

-- Procedimiento 27
-- Crear un procedimiento para actualizar el estado clínico del glaucoma.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_glaucoma_status $$
CREATE PROCEDURE sp_update_glaucoma_status(IN p_patient BIGINT, IN p_status VARCHAR(20))
BEGIN
 UPDATE glaucoma_records SET clinical_status=p_status WHERE patient_id=p_patient;
END $$

DELIMITER ;

CALL sp_update_glaucoma_status(1, 'STABLE');

-- Procedimiento 28
-- Crear un procedimiento para actualizar información de un profesional.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_professional $$
CREATE PROCEDURE sp_update_professional(IN p_id BIGINT, IN p_phone VARCHAR(30), IN p_email VARCHAR(150))
BEGIN
 UPDATE healthcare_professionals SET phone=p_phone,email=p_email WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_update_professional(1, '3008887777', 'laura.actualizada@clinica.edu');

-- Procedimiento 29
-- Crear un procedimiento para modificar la interpretación de un OCT.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_oct_interpretation $$
CREATE PROCEDURE sp_update_oct_interpretation(IN p_id BIGINT, IN p_text TEXT)
BEGIN
 UPDATE oct_exams SET interpretation=p_text WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_update_oct_interpretation(1, 'Control OCT revisado');

-- Procedimiento 30
-- Crear un procedimiento para actualizar la interpretación de un campo visual.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_update_visual_interpretation $$
CREATE PROCEDURE sp_update_visual_interpretation(IN p_id BIGINT, IN p_text TEXT)
BEGIN
 UPDATE visual_field_exams SET interpretation=p_text WHERE id=p_id;
END $$

DELIMITER ;

CALL sp_update_visual_interpretation(1, 'Campo visual revisado');

-- Procedimiento 31
-- Crear un procedimiento que registre una PIO únicamente si el paciente existe.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_iop_if_patient_exists $$
CREATE PROCEDURE sp_iop_if_patient_exists(IN p_patient BIGINT, IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_value DECIMAL(5,2))
BEGIN
 IF NOT EXISTS(SELECT 1 FROM patients WHERE id=p_patient) OR NOT EXISTS(SELECT 1 FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE mv.id=p_visit AND ch.patient_id=p_patient) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente o consulta no corresponde'; END IF;
 CALL sp_register_iop(p_visit,p_eye,p_value,NOW());
END $$

DELIMITER ;

CALL sp_iop_if_patient_exists(21, 34, 'OI', 16.00);

-- Procedimiento 32
-- Crear un procedimiento que registre una consulta solo si existe la historia clínica.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_visit_if_history_exists $$
CREATE PROCEDURE sp_visit_if_history_exists(IN p_history BIGINT, IN p_prof BIGINT, IN p_date DATETIME, IN p_reason TEXT)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM clinical_histories WHERE id=p_history) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Historia inexistente'; END IF;
 CALL sp_create_visit(p_history,p_prof,p_date,p_reason);
END $$

DELIMITER ;

CALL sp_visit_if_history_exists(21, 1, '2026-10-09 09:00:00', 'Seguimiento de prueba');

-- Procedimiento 33
-- Crear un procedimiento que impida registrar un tratamiento con fecha final anterior a la inicial.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_treatment_check_dates $$
CREATE PROCEDURE sp_treatment_check_dates(IN p_patient BIGINT, IN p_med BIGINT, IN p_start DATE, IN p_end DATE)
BEGIN
 IF p_end<p_start THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Fecha final incorrecta'; END IF;
 INSERT INTO treatments(patient_id,medication_id,start_date,end_date,dosage,frequency) VALUES(p_patient,p_med,p_start,p_end,'Segun indicacion','Diaria');
END $$

DELIMITER ;

CALL sp_treatment_check_dates(21, 1, '2026-10-08', '2026-12-08');

-- Procedimiento 34
-- Crear un procedimiento que impida registrar valores negativos de PIO.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_iop_positive $$
CREATE PROCEDURE sp_iop_positive(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_value DECIMAL(5,2))
BEGIN
 IF p_value IS NULL OR p_value<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='PIO debe ser positiva'; END IF;
 CALL sp_register_iop(p_visit,p_eye,p_value,NOW());
END $$

DELIMITER ;

CALL sp_iop_positive(34, 'OD', 17.00);

-- Procedimiento 35
-- Crear un procedimiento que valide que el ojo recibido sea OD u OI.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_validate_eye $$
CREATE PROCEDURE sp_validate_eye(IN p_eye VARCHAR(2))
BEGIN
 IF p_eye IS NULL OR p_eye NOT IN ('OD','OI') THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Ojo invalido'; END IF;
 SELECT 'Ojo valido' AS resultado;
END $$

DELIMITER ;

CALL sp_validate_eye('OD');

-- Procedimiento 36
-- Crear un procedimiento que impida crear dos historias clínicas para el mismo paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_history_without_duplicate $$
CREATE PROCEDURE sp_history_without_duplicate(IN p_patient BIGINT, IN p_number VARCHAR(30))
BEGIN
 IF EXISTS(SELECT 1 FROM clinical_histories WHERE patient_id=p_patient) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paciente ya tiene historia'; END IF;
 CALL sp_create_history(p_patient,p_number,CURDATE());
END $$

DELIMITER ;

CALL sp_history_without_duplicate(21, 'HC-0021');

-- Procedimiento 37
-- Crear un procedimiento que registre un diagnóstico solo si existe en el catálogo.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_diagnosis_if_exists $$
CREATE PROCEDURE sp_diagnosis_if_exists(IN p_visit BIGINT, IN p_diagnosis BIGINT)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM diagnoses WHERE id=p_diagnosis) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Diagnostico inexistente'; END IF;
 CALL sp_create_visit_diagnosis(p_visit,p_diagnosis);
END $$

DELIMITER ;

CALL sp_diagnosis_if_exists(34, 2);

-- Procedimiento 38
-- Crear un procedimiento que valide que el profesional se encuentre activo antes de registrar una consulta.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_visit_if_prof_active $$
CREATE PROCEDURE sp_visit_if_prof_active(IN p_history BIGINT, IN p_prof BIGINT, IN p_date DATETIME, IN p_reason TEXT)
BEGIN
 IF NOT EXISTS(SELECT 1 FROM healthcare_professionals WHERE id=p_prof AND active=TRUE) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Profesional inactivo o inexistente'; END IF;
 CALL sp_create_visit(p_history,p_prof,p_date,p_reason);
END $$

DELIMITER ;

CALL sp_visit_if_prof_active(21, 1, '2026-10-10 09:00:00', 'Visita con profesional activo');

-- Procedimiento 39
-- Crear un procedimiento que registre un campo visual validando que VFI esté entre 0 y 100.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_visual_check_vfi $$
CREATE PROCEDURE sp_visual_check_vfi(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_date DATE, IN p_md DECIMAL(6,2), IN p_psd DECIMAL(6,2), IN p_vfi DECIMAL(5,2))
BEGIN
 IF p_vfi IS NULL OR p_vfi NOT BETWEEN 0 AND 100 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='VFI fuera de rango'; END IF;
 CALL sp_create_visual_field(p_visit,p_eye,p_date,p_md,p_psd,p_vfi);
END $$

DELIMITER ;

CALL sp_visual_check_vfi(34, 'OI', '2026-10-08', -2.00, 2.00, 95.00);

-- Procedimiento 40
-- Crear un procedimiento que registre una paquimetría validando que el valor sea positivo.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_pachymetry_positive $$
CREATE PROCEDURE sp_pachymetry_positive(IN p_visit BIGINT, IN p_eye VARCHAR(2), IN p_date DATE, IN p_value DECIMAL(6,2))
BEGIN
 IF p_value IS NULL OR p_value<=0 THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Paquimetria debe ser positiva'; END IF;
 CALL sp_create_pachymetry(p_visit,p_eye,p_date,p_value);
END $$

DELIMITER ;

CALL sp_pachymetry_positive(34, 'OI', '2026-10-08', 535.00);

-- Procedimiento 41
-- Crear un procedimiento que devuelva un resumen completo de la historia clínica de un paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patient_history_summary $$
CREATE PROCEDURE sp_patient_history_summary(IN p_patient BIGINT)
BEGIN
 SELECT p.*,ch.history_number,ch.status AS history_status FROM patients p LEFT JOIN clinical_histories ch ON ch.patient_id=p.id WHERE p.id=p_patient;
 SELECT mv.* FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ORDER BY mv.visit_date;
 SELECT d.name,mv.visit_date FROM visit_diagnoses vd JOIN diagnoses d ON d.id=vd.diagnosis_id JOIN medical_visits mv ON mv.id=vd.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient;
 SELECT * FROM treatments WHERE patient_id=p_patient;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patient_history_summary(1);

-- Procedimiento 42
-- Crear un procedimiento que muestre la evolución de PIO de un paciente entre dos fechas.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patient_iop_range $$
CREATE PROCEDURE sp_patient_iop_range(IN p_patient BIGINT, IN p_start DATE, IN p_end DATE)
BEGIN
 SELECT i.* FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND DATE(i.measured_at) BETWEEN p_start AND p_end ORDER BY i.measured_at;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patient_iop_range(1, '2026-04-01', '2026-04-01');

-- Procedimiento 43
-- Crear un procedimiento que reciba paciente y ojo y muestre todas sus mediciones cronológicamente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patient_iop_eye $$
CREATE PROCEDURE sp_patient_iop_eye(IN p_patient BIGINT, IN p_eye VARCHAR(2))
BEGIN
 SELECT i.* FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND i.eye=p_eye ORDER BY i.measured_at;
END $$

DELIMITER ;


CALL sp_patient_iop_eye(1, 'OD');

-- Procedimiento 44
-- Crear un procedimiento que genere estadísticas mensuales de consultas.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_monthly_visits $$
CREATE PROCEDURE sp_monthly_visits()
BEGIN
 SELECT DATE_FORMAT(visit_date,'%Y-%m') AS mes,COUNT(*) AS total FROM medical_visits GROUP BY DATE_FORMAT(visit_date,'%Y-%m') ORDER BY mes;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_monthly_visits();

-- Procedimiento 45
-- Crear un procedimiento que calcule la cantidad de pacientes atendidos por cada especialista.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patients_per_professional $$
CREATE PROCEDURE sp_patients_per_professional()
BEGIN
 SELECT hp.id,CONCAT(hp.first_name,' ',hp.last_name) AS profesional,COUNT(DISTINCT ch.patient_id) AS pacientes FROM healthcare_professionals hp LEFT JOIN medical_visits mv ON mv.professional_id=hp.id LEFT JOIN clinical_histories ch ON ch.id=mv.clinical_history_id GROUP BY hp.id,hp.first_name,hp.last_name;
END $$

DELIMITER ;


CALL sp_patients_per_professional();

-- Procedimiento 46
-- Crear un procedimiento que determine pacientes sin consulta durante un número de meses recibido como parámetro.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patients_without_recent_visit $$
CREATE PROCEDURE sp_patients_without_recent_visit(IN p_months INT)
BEGIN
 SELECT p.id,p.first_name,p.last_name,MAX(mv.visit_date) AS ultima_consulta FROM patients p LEFT JOIN clinical_histories ch ON ch.patient_id=p.id LEFT JOIN medical_visits mv ON mv.clinical_history_id=ch.id GROUP BY p.id,p.first_name,p.last_name HAVING MAX(mv.visit_date) IS NULL OR MAX(mv.visit_date)<DATE_SUB(CURDATE(),INTERVAL p_months MONTH);
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patients_without_recent_visit(1);

-- Procedimiento 47
-- Crear un procedimiento que genere un resumen de diagnósticos por paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_diagnoses_by_patient $$
CREATE PROCEDURE sp_diagnoses_by_patient(IN p_patient BIGINT)
BEGIN
 SELECT d.name,COUNT(*) AS total FROM diagnoses d JOIN visit_diagnoses vd ON vd.diagnosis_id=d.id JOIN medical_visits mv ON mv.id=vd.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient GROUP BY d.id,d.name;
END $$

DELIMITER ;


CALL sp_diagnoses_by_patient(1);

-- Procedimiento 48
-- Crear un procedimiento que devuelva el último OCT, último campo visual y última PIO de un paciente.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_patient_last_exams $$
CREATE PROCEDURE sp_patient_last_exams(IN p_patient BIGINT)
BEGIN
 SELECT * FROM oct_exams WHERE visit_id IN(SELECT mv.id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient) ORDER BY exam_date DESC,id DESC LIMIT 1;
 SELECT * FROM visual_field_exams WHERE visit_id IN(SELECT mv.id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient) ORDER BY exam_date DESC,id DESC LIMIT 1;
 SELECT * FROM intraocular_pressures WHERE visit_id IN(SELECT mv.id FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient) ORDER BY measured_at DESC,id DESC LIMIT 1;
END $$

DELIMITER ;

-- Probar el procedimiento
CALL sp_patient_last_exams(1);

-- Procedimiento 49
-- Crear un procedimiento que registre en una sola transacción una consulta, un diagnóstico y una medición de PIO.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_transaction_visit_diagnosis_iop $$
CREATE PROCEDURE sp_transaction_visit_diagnosis_iop(IN p_history BIGINT, IN p_prof BIGINT, IN p_date DATETIME, IN p_reason TEXT, IN p_diagnosis BIGINT, IN p_eye VARCHAR(2), IN p_pio DECIMAL(5,2))
BEGIN
 DECLARE v_visit BIGINT;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 START TRANSACTION;
 INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(p_history,p_prof,p_date,p_reason);
 SET v_visit=LAST_INSERT_ID();
 INSERT INTO visit_diagnoses(visit_id,diagnosis_id,is_primary) VALUES(v_visit,p_diagnosis,TRUE);
 CALL sp_register_iop(v_visit,p_eye,p_pio,p_date);
 COMMIT;
 SELECT v_visit AS nueva_consulta;
END $$

DELIMITER ;

CALL sp_transaction_visit_diagnosis_iop(21, 1, '2026-10-11 09:00:00', 'Consulta de control', 1, 'OD', 17.00);

-- Procedimiento 50
-- Crear un procedimiento transaccional que registre un control completo de glaucoma y ejecute ROLLBACK si alguna operación falla.

DELIMITER $$

DROP PROCEDURE IF EXISTS sp_transaction_glaucoma_control $$
CREATE PROCEDURE sp_transaction_glaucoma_control(IN p_record BIGINT, IN p_history BIGINT, IN p_prof BIGINT, IN p_date DATETIME, IN p_eye VARCHAR(2), IN p_pio DECIMAL(5,2), IN p_next DATE)
BEGIN
 DECLARE v_visit BIGINT;
 DECLARE v_patient BIGINT;
 DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; RESIGNAL; END;
 SELECT patient_id INTO v_patient FROM glaucoma_records WHERE id=p_record;
 IF v_patient IS NULL OR NOT EXISTS(SELECT 1 FROM clinical_histories WHERE id=p_history AND patient_id=v_patient) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='Historia y glaucoma no corresponden'; END IF;
 START TRANSACTION;
 INSERT INTO medical_visits(clinical_history_id,professional_id,visit_date,reason) VALUES(p_history,p_prof,p_date,'Control de glaucoma');
 SET v_visit=LAST_INSERT_ID();
 INSERT INTO glaucoma_controls(glaucoma_record_id,visit_id,control_date,next_control_date) VALUES(p_record,v_visit,DATE(p_date),p_next);
 CALL sp_register_iop(v_visit,p_eye,p_pio,p_date);
 COMMIT;
 SELECT v_visit AS nueva_consulta;
END $$

DELIMITER ;

CALL sp_transaction_glaucoma_control(1, 1, 2, '2026-10-12 09:00:00', 'OD', 17.00, '2027-01-12');
