-- Función 1
-- Crear una función que calcule la edad de un paciente a partir de su fecha de nacimiento.

DELIMITER $$

CREATE FUNCTION ej_fn_age(p_birth DATE) RETURNS INT
NOT DETERMINISTIC
BEGIN
 RETURN TIMESTAMPDIFF(YEAR,p_birth,CURDATE());
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_age('1990-01-01') AS resultado;

-- Función 2
-- Crear una función que reciba nombres y apellidos y retorne el nombre completo.

DELIMITER $$

CREATE FUNCTION ej_fn_fullname(p_first VARCHAR(100),p_last VARCHAR(100)) RETURNS VARCHAR(210)
DETERMINISTIC
BEGIN
 RETURN CONCAT(p_first,' ',p_last);
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_fullname('Ejemplo', 'Ejemplo') AS resultado;

-- Función 3
-- Crear una función que reciba un ID de paciente y retorne su número de documento.

DELIMITER $$

CREATE FUNCTION ej_fn_document(p_patient BIGINT) RETURNS VARCHAR(30)
READS SQL DATA
BEGIN
 DECLARE v VARCHAR(30); SELECT MAX(document_number) INTO v FROM patients WHERE id=p_patient; RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_document(1) AS resultado;

-- Función 4
-- Crear una función que reciba un ID de paciente y retorne su edad.

DELIMITER $$

CREATE FUNCTION ej_fn_patient_age(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v DATE; SELECT MAX(birth_date) INTO v FROM patients WHERE id=p_patient; RETURN TIMESTAMPDIFF(YEAR,v,CURDATE());
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_patient_age(1) AS resultado;

-- Función 5
-- Crear una función que reciba el ID de una consulta y retorne su fecha.

DELIMITER $$

CREATE FUNCTION ej_fn_visit_date(p_visit BIGINT) RETURNS DATETIME
READS SQL DATA
BEGIN
 DECLARE v DATETIME; SELECT MAX(visit_date) INTO v FROM medical_visits WHERE id=p_visit; RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_visit_date(1) AS resultado;

-- Función 6
-- Crear una función que determine cuántos años han pasado desde una fecha.

DELIMITER $$

CREATE FUNCTION ej_fn_years_since(p_date DATE) RETURNS INT
NOT DETERMINISTIC
BEGIN
 RETURN TIMESTAMPDIFF(YEAR,p_date,CURDATE());
END $$

DELIMITER ;


SELECT ej_fn_years_since('1990-01-01') AS resultado;

-- Función 7
-- Crear una función que reciba un valor de PIO y retorne un texto descriptivo.

DELIMITER $$

CREATE FUNCTION ej_fn_iop_description(p_value DECIMAL(5,2)) RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
 IF p_value IS NULL THEN RETURN 'Sin dato'; ELSEIF p_value>21 THEN RETURN 'Elevada'; ELSE RETURN 'En rango academico'; END IF;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_iop_description(18.00) AS resultado;

-- Función 8
-- Crear una función que reciba OD u OI y devuelva Ojo derecho u Ojo izquierdo.

DELIMITER $$

CREATE FUNCTION ej_fn_eye(p_eye VARCHAR(2)) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
 RETURN CASE p_eye WHEN 'OD' THEN 'Ojo derecho' WHEN 'OI' THEN 'Ojo izquierdo' ELSE 'No definido' END;
END $$

DELIMITER ;

SELECT ej_fn_eye('OD') AS resultado;

-- Función 9
-- Crear una función que reciba un booleano y retorne Activo o Inactivo.

DELIMITER $$

CREATE FUNCTION ej_fn_active(p_active BOOLEAN) RETURNS VARCHAR(15)
DETERMINISTIC
BEGIN
 RETURN IF(p_active,'Activo','Inactivo');
END $$

DELIMITER ;


SELECT ej_fn_active(1) AS resultado;

-- Función 10
-- Crear una función que formatee un número de historia clínica.

DELIMITER $$

CREATE FUNCTION ej_fn_history_format(p_number BIGINT) RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
 RETURN CONCAT('HC-',LPAD(p_number,4,'0'));
END $$

DELIMITER ;


SELECT ej_fn_history_format(1) AS resultado;

-- Función 11
-- Crear una función que retorne la cantidad de consultas de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_visit_count(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT;
 SELECT COUNT(*) INTO v  FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_visit_count(1) AS resultado;

-- Función 12
-- Crear una función que retorne la cantidad de diagnósticos de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_diagnosis_count(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT;
 SELECT COUNT(*) INTO v FROM visit_diagnoses vd JOIN medical_visits mv ON mv.id=vd.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_diagnosis_count(1) AS resultado;

-- Función 13
-- Crear una función que retorne la cantidad de controles de glaucoma de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_glaucoma_controls(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT;
 SELECT COUNT(*) INTO v FROM glaucoma_controls gc JOIN glaucoma_records gr ON gr.id=gc.glaucoma_record_id WHERE gr.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_glaucoma_controls(1) AS resultado;

-- Función 14
-- Crear una función que retorne la última fecha de consulta.

DELIMITER $$

CREATE FUNCTION ej_fn_last_visit(p_patient BIGINT) RETURNS DATETIME
READS SQL DATA
BEGIN
 DECLARE v DATETIME;
 SELECT MAX(mv.visit_date) INTO v  FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_last_visit(1) AS resultado;

-- Función 15
-- Crear una función que retorne la primera fecha de consulta.

DELIMITER $$

CREATE FUNCTION ej_fn_first_visit(p_patient BIGINT) RETURNS DATETIME
READS SQL DATA
BEGIN
 DECLARE v DATETIME;
 SELECT MIN(mv.visit_date) INTO v  FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_first_visit(1) AS resultado;

-- Función 16
-- Crear una función que retorne la presión intraocular promedio de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_average_iop(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_average_iop(1) AS resultado;

-- Función 17
-- Crear una función que retorne la presión promedio de OD.

DELIMITER $$

CREATE FUNCTION ej_fn_average_od(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND i.eye='OD' ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_average_od(1) AS resultado;

-- Función 18
-- Crear una función que retorne la presión promedio de OI.

DELIMITER $$

CREATE FUNCTION ej_fn_average_oi(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND i.eye='OI' ;
 RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_average_oi(1) AS resultado;

-- Función 19
-- Crear una función que retorne la PIO máxima registrada para un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_max_iop(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT MAX(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_max_iop(1) AS resultado;

-- Función 20
-- Crear una función que retorne la PIO mínima registrada.

DELIMITER $$

CREATE FUNCTION ej_fn_min_iop(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT MIN(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_min_iop(1) AS resultado;

-- Función 21
-- Crear una función que clasifique una PIO según rangos definidos para fines académicos.

DELIMITER $$

CREATE FUNCTION ej_fn_iop_category(p_pressure DECIMAL(5,2)) RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
 IF p_pressure IS NULL THEN RETURN 'Sin dato'; ELSEIF p_pressure<10 THEN RETURN 'Baja'; ELSEIF p_pressure<=21 THEN RETURN 'Rango academico'; ELSE RETURN 'Elevada'; END IF;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_iop_category(18.00) AS resultado;

-- Función 22
-- Crear una función que indique si una PIO supera una presión objetivo recibida como parámetro.

DELIMITER $$

CREATE FUNCTION ej_fn_above_target(p_pressure DECIMAL(5,2),p_target DECIMAL(5,2)) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
 RETURN p_pressure>p_target;
END $$

DELIMITER ;


SELECT ej_fn_above_target(18.00, 18.00) AS resultado;

-- Función 23
-- Crear una función que determine si un paciente tiene diagnóstico de glaucoma.

DELIMITER $$

CREATE FUNCTION ej_fn_has_glaucoma(p_patient BIGINT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v BOOLEAN;
 SELECT COUNT(*)>0 INTO v FROM visit_diagnoses vd JOIN diagnoses d ON d.id=vd.diagnosis_id JOIN medical_visits mv ON mv.id=vd.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND d.diagnosis_type='GLAUCOMA' ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_has_glaucoma(1) AS resultado;

-- Función 24
-- Crear una función que determine si un paciente tiene tratamientos activos.

DELIMITER $$

CREATE FUNCTION ej_fn_has_active_treatment(p_patient BIGINT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v BOOLEAN;
 SELECT COUNT(*)>0 INTO v FROM treatments t WHERE t.patient_id=p_patient AND t.status='ACTIVE' ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_has_active_treatment(1) AS resultado;

-- Función 25
-- Crear una función que indique si el paciente tiene al menos un OCT registrado.

DELIMITER $$

CREATE FUNCTION ej_fn_has_oct(p_patient BIGINT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v BOOLEAN;
 SELECT COUNT(*)>0 INTO v FROM oct_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_has_oct(1) AS resultado;

-- Función 26
-- Crear una función que indique si tiene campo visual registrado.

DELIMITER $$

CREATE FUNCTION ej_fn_has_visual(p_patient BIGINT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v BOOLEAN;
 SELECT COUNT(*)>0 INTO v FROM visual_field_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_has_visual(1) AS resultado;

-- Función 27
-- Crear una función que determine si tiene paquimetría.

DELIMITER $$

CREATE FUNCTION ej_fn_has_pachy(p_patient BIGINT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v BOOLEAN;
 SELECT COUNT(*)>0 INTO v FROM pachymetry_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_has_pachy(1) AS resultado;

-- Función 28
-- Crear una función que determine si el paciente tiene controles pendientes según un número de meses.

DELIMITER $$

CREATE FUNCTION ej_fn_pending_control(p_patient BIGINT,p_months INT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v DATE; SELECT MAX(gc.control_date) INTO v FROM glaucoma_controls gc JOIN glaucoma_records gr ON gr.id=gc.glaucoma_record_id WHERE gr.patient_id=p_patient; RETURN v IS NULL OR v<DATE_SUB(CURDATE(),INTERVAL p_months MONTH);
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_pending_control(1, 1) AS resultado;

-- Función 29
-- Crear una función que clasifique un paciente según cantidad de consultas: nuevo, recurrente o frecuente.

DELIMITER $$

CREATE FUNCTION ej_fn_visit_category(p_patient BIGINT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
 DECLARE v INT; SET v=ej_fn_visit_count(p_patient); RETURN CASE WHEN v<=1 THEN 'Nuevo' WHEN v<=3 THEN 'Recurrente' ELSE 'Frecuente' END;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_visit_category(1) AS resultado;

-- Función 30
-- Crear una función que retorne Completo si el paciente tiene OCT, campo visual, PIO y paquimetría, o Incompleto en caso contrario.

DELIMITER $$

CREATE FUNCTION ej_fn_exam_complete(p_patient BIGINT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
 RETURN IF(ej_fn_has_oct(p_patient) AND ej_fn_has_visual(p_patient) AND ej_fn_has_pachy(p_patient) AND ej_fn_visit_count(p_patient)>0 AND ej_fn_average_iop(p_patient) IS NOT NULL,'Completo','Incompleto');
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_exam_complete(1) AS resultado;

-- Función 31
-- Crear una función que calcule el promedio de PIO entre dos fechas para un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_iop_date_average(p_patient BIGINT,p_start DATE,p_end DATE) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND DATE(i.measured_at) BETWEEN p_start AND p_end ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_iop_date_average(1, '1990-01-01', '1990-01-01') AS resultado;

-- Función 32
-- Crear una función que calcule la diferencia entre la primera y última PIO.

DELIMITER $$

CREATE FUNCTION ej_fn_iop_difference(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v_first DECIMAL(8,2); DECLARE v_last DECIMAL(8,2);
 SELECT i.pressure INTO v_first FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ORDER BY i.measured_at,i.id LIMIT 1;
 SELECT i.pressure INTO v_last FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ORDER BY i.measured_at DESC,i.id DESC LIMIT 1;
 RETURN v_last-v_first;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_iop_difference(1) AS resultado;

-- Función 33
-- Crear una función que retorne el número de días desde la última consulta.

DELIMITER $$

CREATE FUNCTION ej_fn_days_since_visit(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 RETURN DATEDIFF(CURDATE(),DATE(ej_fn_last_visit(p_patient)));
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_days_since_visit(1) AS resultado;

-- Función 34
-- Crear una función que retorne el número de meses desde el último OCT.

DELIMITER $$

CREATE FUNCTION ej_fn_months_since_oct(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v DATE; SELECT MAX(e.exam_date) INTO v FROM oct_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient; RETURN TIMESTAMPDIFF(MONTH,v,CURDATE());
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_months_since_oct(1) AS resultado;

-- Función 35
-- Crear una función que retorne el número de meses desde el último campo visual.

DELIMITER $$

CREATE FUNCTION ej_fn_months_since_visual(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v DATE; SELECT MAX(e.exam_date) INTO v FROM visual_field_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient; RETURN TIMESTAMPDIFF(MONTH,v,CURDATE());
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_months_since_visual(1) AS resultado;

-- Función 36
-- Crear una función que calcule el promedio de RNFL de los OCT de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_avg_rnfl(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(e.rnfl_average) INTO v FROM oct_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_avg_rnfl(1) AS resultado;

-- Función 37
-- Crear una función que retorne el valor más reciente de RNFL.

DELIMITER $$

CREATE FUNCTION ej_fn_latest_rnfl(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2); SELECT e.rnfl_average INTO v FROM oct_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ORDER BY e.exam_date DESC,e.id DESC LIMIT 1; RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_latest_rnfl(1) AS resultado;

-- Función 38
-- Crear una función que calcule el promedio de VFI de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_avg_vfi(p_patient BIGINT) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(e.vfi) INTO v FROM visual_field_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_avg_vfi(1) AS resultado;

-- Función 39
-- Crear una función que retorne la cantidad de tratamientos históricos.

DELIMITER $$

CREATE FUNCTION ej_fn_treatment_count(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT;
 SELECT COUNT(*) INTO v FROM treatments t WHERE t.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_treatment_count(1) AS resultado;

-- Función 40
-- Crear una función que retorne la cantidad de medicamentos diferentes utilizados por un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_med_count(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT;
 SELECT COUNT(DISTINCT t.medication_id) INTO v FROM treatments t WHERE t.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_med_count(1) AS resultado;

-- Función 41
-- Crear una función que reciba paciente y ojo y retorne la última PIO registrada.

DELIMITER $$

CREATE FUNCTION ej_fn_last_eye_iop(p_patient BIGINT,p_eye VARCHAR(2)) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2); SELECT i.pressure INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND i.eye=p_eye ORDER BY i.measured_at DESC,i.id DESC LIMIT 1; RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_last_eye_iop(1, 'OD') AS resultado;

-- Función 42
-- Crear una función que reciba paciente y ojo y retorne la PIO promedio.

DELIMITER $$

CREATE FUNCTION ej_fn_average_eye_iop(p_patient BIGINT,p_eye VARCHAR(2)) RETURNS DECIMAL(8,2)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2);
 SELECT AVG(i.pressure) INTO v FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND i.eye=p_eye ;
 RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_average_eye_iop(1, 'OD') AS resultado;

-- Función 43
-- Crear una función que determine si la última PIO es mayor o menor que la primera.

DELIMITER $$

CREATE FUNCTION ej_fn_iop_trend(p_patient BIGINT) RETURNS VARCHAR(20)
READS SQL DATA
BEGIN
 DECLARE v DECIMAL(8,2); SET v=ej_fn_iop_difference(p_patient); IF v IS NULL THEN RETURN 'Sin datos'; ELSEIF v>0 THEN RETURN 'Mayor'; ELSEIF v<0 THEN RETURN 'Menor'; ELSE RETURN 'Igual'; END IF;
END $$

DELIMITER ;


SELECT ej_fn_iop_trend(1) AS resultado;

-- Función 44
-- Crear una función que retorne la diferencia porcentual entre primera y última PIO.

DELIMITER $$

CREATE FUNCTION ej_fn_iop_change_pct(p_patient BIGINT) RETURNS DECIMAL(9,2)
READS SQL DATA
BEGIN
 DECLARE v_first DECIMAL(8,2); SELECT i.pressure INTO v_first FROM intraocular_pressures i JOIN medical_visits mv ON mv.id=i.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient ORDER BY i.measured_at,i.id LIMIT 1; IF v_first IS NULL OR v_first=0 THEN RETURN NULL; END IF; RETURN ej_fn_iop_difference(p_patient)*100/v_first;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_iop_change_pct(1) AS resultado;

-- Función 45
-- Crear una función que retorne el diagnóstico principal más reciente de un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_last_primary_diagnosis(p_patient BIGINT) RETURNS VARCHAR(150)
READS SQL DATA
BEGIN
 DECLARE v VARCHAR(150); SELECT d.name INTO v FROM diagnoses d JOIN visit_diagnoses vd ON vd.diagnosis_id=d.id JOIN medical_visits mv ON mv.id=vd.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND vd.is_primary=TRUE ORDER BY mv.visit_date DESC,mv.id DESC LIMIT 1; RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_last_primary_diagnosis(1) AS resultado;

-- Función 46
-- Crear una función que retorne el nombre del medicamento activo más reciente.

DELIMITER $$

CREATE FUNCTION ej_fn_recent_active_med(p_patient BIGINT) RETURNS VARCHAR(120)
READS SQL DATA
BEGIN
 DECLARE v VARCHAR(120); SELECT m.name INTO v FROM treatments t JOIN medications m ON m.id=t.medication_id WHERE t.patient_id=p_patient AND t.status='ACTIVE' ORDER BY t.start_date DESC,t.id DESC LIMIT 1; RETURN v;
END $$

DELIMITER ;

-- Probar la función
SELECT ej_fn_recent_active_med(1) AS resultado;

-- Función 47
-- Crear una función que retorne la cantidad de procedimientos realizados a un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_procedure_count(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT;
 SELECT COUNT(*) INTO v FROM clinical_procedures cp WHERE cp.patient_id=p_patient ;
 RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_procedure_count(1) AS resultado;

-- Función 48
-- Crear una función que determine si un profesional ha atendido alguna vez a un paciente específico.

DELIMITER $$

CREATE FUNCTION ej_fn_prof_seen_patient(p_patient BIGINT,p_prof BIGINT) RETURNS BOOLEAN
READS SQL DATA
BEGIN
 DECLARE v BOOLEAN;
 SELECT COUNT(*)>0 INTO v  FROM medical_visits mv JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient AND mv.professional_id=p_prof ;
 RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_prof_seen_patient(1, 1) AS resultado;

-- Función 49
-- Crear una función que calcule la cantidad total de exámenes especializados registrados para un paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_special_exam_total(p_patient BIGINT) RETURNS INT
READS SQL DATA
BEGIN
 DECLARE v INT; SELECT (SELECT COUNT(*) FROM oct_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient)+(SELECT COUNT(*) FROM visual_field_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient)+(SELECT COUNT(*) FROM pachymetry_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient)+(SELECT COUNT(*) FROM gonioscopy_exams e JOIN medical_visits mv ON mv.id=e.visit_id JOIN clinical_histories ch ON ch.id=mv.clinical_history_id WHERE ch.patient_id=p_patient) INTO v; RETURN v;
END $$

DELIMITER ;


SELECT ej_fn_special_exam_total(1) AS resultado;

-- Función 50
-- Crear una función que genere un resumen textual como:
-- Paciente: Carlos Gómez
-- Consultas: 8
-- Controles glaucoma: 4
-- Última PIO OD: 18
-- Última PIO OI: 17
-- Tratamientos activos: 2
-- a partir del ID del paciente.

DELIMITER $$

CREATE FUNCTION ej_fn_patient_text_summary(p_patient BIGINT) RETURNS TEXT
READS SQL DATA
BEGIN
 DECLARE v_name VARCHAR(210); DECLARE v_treatments INT; SELECT CONCAT(first_name,' ',last_name) INTO v_name FROM patients WHERE id=p_patient; IF v_name IS NULL THEN RETURN 'Paciente no encontrado'; END IF; SELECT COUNT(*) INTO v_treatments FROM treatments WHERE patient_id=p_patient AND status='ACTIVE'; RETURN CONCAT('Paciente: ',v_name,CHAR(10),'Consultas: ',ej_fn_visit_count(p_patient),CHAR(10),'Controles glaucoma: ',ej_fn_glaucoma_controls(p_patient),CHAR(10),'Ultima PIO OD: ',COALESCE(CAST(ej_fn_last_eye_iop(p_patient,'OD') AS CHAR),'Sin dato'),CHAR(10),'Ultima PIO OI: ',COALESCE(CAST(ej_fn_last_eye_iop(p_patient,'OI') AS CHAR),'Sin dato'),CHAR(10),'Tratamientos activos: ',v_treatments);
END $$

DELIMITER ;

SELECT ej_fn_patient_text_summary(1) AS resultado;
