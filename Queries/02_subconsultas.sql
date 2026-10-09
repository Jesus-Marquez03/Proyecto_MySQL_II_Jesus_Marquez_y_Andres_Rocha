-- Subconsulta 1
-- Mostrar los pacientes cuya edad sea superior a la edad promedio de todos los pacientes.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, TIMESTAMPDIFF(YEAR, p.birth_date, CURRENT_DATE) AS age
FROM patients p
WHERE TIMESTAMPDIFF(YEAR, p.birth_date, CURRENT_DATE) > (
    SELECT AVG(TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE))
    FROM patients
);

-- Subconsulta 2
-- Mostrar los pacientes cuya edad sea inferior a la edad promedio.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, TIMESTAMPDIFF(YEAR, p.birth_date, CURRENT_DATE) AS age
FROM patients p
WHERE TIMESTAMPDIFF(YEAR, p.birth_date, CURRENT_DATE) < (
    SELECT AVG(TIMESTAMPDIFF(YEAR, birth_date, CURRENT_DATE))
    FROM patients
);

-- Subconsulta 3
-- Consultar la medición de presión intraocular más alta registrada.

SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MAX(pressure)
    FROM intraocular_pressures
);

-- Subconsulta 4
-- Mostrar todas las mediciones que tengan el mismo valor que la presión máxima registrada.

SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MAX(pressure)
    FROM intraocular_pressures
);

-- Subconsulta 5
-- Mostrar la presión intraocular mínima registrada.

SELECT *
FROM intraocular_pressures
WHERE pressure = (
    SELECT MIN(pressure)
    FROM intraocular_pressures
);

-- Subconsulta 6
-- Mostrar los estudios OCT cuyo RNFL sea inferior al promedio general.

SELECT *
FROM oct_exams
WHERE rnfl_average < (
    SELECT AVG(rnfl_average)
    FROM oct_exams
);

-- Subconsulta 7
-- Mostrar los estudios OCT cuyo RNFL sea superior al promedio general.

SELECT *
FROM oct_exams
WHERE rnfl_average > (
    SELECT AVG(rnfl_average)
    FROM oct_exams
);

-- Subconsulta 8
-- Consultar pacientes cuya cantidad de consultas sea mayor que el promedio de consultas por paciente.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(mv.id) AS visit_count
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(mv.id) > (
    SELECT AVG(x.visit_count)
    FROM (
        SELECT COUNT(mv2.id) AS visit_count
        FROM patients p2
        LEFT JOIN clinical_histories ch2 ON ch2.patient_id = p2.id
        LEFT JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
        GROUP BY p2.id
    ) x
);

-- Subconsulta 9
-- Mostrar profesionales cuya cantidad de consultas sea superior al promedio por profesional.

SELECT hp.id, CONCAT(hp.first_name, ' ', hp.last_name) AS professional_name, COUNT(mv.id) AS visit_count
FROM healthcare_professionals hp
INNER JOIN medical_visits mv ON mv.professional_id = hp.id
GROUP BY hp.id, hp.first_name, hp.last_name
HAVING COUNT(mv.id) > (
    SELECT AVG(x.visit_count)
    FROM (
        SELECT COUNT(mv2.id) AS visit_count
        FROM healthcare_professionals hp2
        LEFT JOIN medical_visits mv2 ON mv2.professional_id = hp2.id
        GROUP BY hp2.id
    ) x
);

-- Subconsulta 10
-- Consultar pacientes cuya última presión intraocular sea superior al promedio general.

SELECT DISTINCT
    p.id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    iop.pressure AS last_iop
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN intraocular_pressures iop ON iop.visit_id = mv.id
WHERE iop.measured_at = (
    SELECT MAX(iop2.measured_at)
    FROM clinical_histories ch2
    INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    INNER JOIN intraocular_pressures iop2 ON iop2.visit_id = mv2.id
    WHERE ch2.patient_id = p.id
)
AND iop.pressure > (
    SELECT AVG(pressure)
    FROM intraocular_pressures
);

-- Subconsulta 11
-- Mostrar pacientes que tengan al menos una consulta registrada.

SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
);

-- Subconsulta 12
-- Mostrar pacientes que tengan diagnóstico de glaucoma.

SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
    INNER JOIN diagnoses d ON d.id = vd.diagnosis_id
    WHERE d.diagnosis_type = 'GLAUCOMA'
);

-- Subconsulta 13
-- Mostrar pacientes que hayan recibido tratamiento farmacológico.

SELECT *
FROM patients
WHERE id IN (
    SELECT patient_id
    FROM treatments
);

-- Subconsulta 14
-- Mostrar pacientes que tengan estudios OCT registrados.

SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN oct_exams o ON o.visit_id = mv.id
);

-- Subconsulta 15
-- Mostrar pacientes que tengan campos visuales registrados.

SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN visual_field_exams vf ON vf.visit_id = mv.id
);

-- Subconsulta 16
-- Mostrar medicamentos que hayan sido utilizados en al menos un tratamiento.

SELECT *
FROM medications
WHERE id IN (
    SELECT medication_id
    FROM treatments
);

-- Subconsulta 17
-- Mostrar profesionales que hayan atendido pacientes con glaucoma.

SELECT *
FROM healthcare_professionals
WHERE id IN (
    SELECT mv.professional_id
    FROM medical_visits mv
    INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
    INNER JOIN diagnoses d ON d.id = vd.diagnosis_id
    WHERE d.diagnosis_type = 'GLAUCOMA'
);

-- Subconsulta 18
-- Mostrar diagnósticos utilizados en alguna consulta.

SELECT *
FROM diagnoses
WHERE id IN (
    SELECT diagnosis_id
    FROM visit_diagnoses
);

-- Subconsulta 19
-- Mostrar pacientes que hayan tenido algún procedimiento quirúrgico.

SELECT *
FROM patients
WHERE id IN (
    SELECT patient_id
    FROM clinical_procedures
    WHERE procedure_type LIKE '%laser%'
       OR procedure_type LIKE '%quirurg%'
       OR procedure_type LIKE '%cirug%'
);

-- Subconsulta 20
-- Mostrar pacientes que tengan registros de paquimetría.

SELECT *
FROM patients
WHERE id IN (
    SELECT ch.patient_id
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN pachymetry_exams pe ON pe.visit_id = mv.id
);

-- Subconsulta 21
-- Mostrar pacientes que nunca hayan tenido una consulta.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
);

-- Subconsulta 22
-- Mostrar pacientes que nunca hayan tenido un control de glaucoma.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM glaucoma_records gr
    INNER JOIN glaucoma_controls gc ON gc.glaucoma_record_id = gr.id
    WHERE gr.patient_id = p.id
);

-- Subconsulta 23
-- Mostrar pacientes que no tengan estudios OCT.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN oct_exams o ON o.visit_id = mv.id
    WHERE ch.patient_id = p.id
);

-- Subconsulta 24
-- Mostrar pacientes que no tengan campos visuales.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN visual_field_exams vf ON vf.visit_id = mv.id
    WHERE ch.patient_id = p.id
);

-- Subconsulta 25
-- Mostrar medicamentos que nunca hayan sido utilizados.

SELECT *
FROM medications m
WHERE NOT EXISTS (
    SELECT 1
    FROM treatments t
    WHERE t.medication_id = m.id
);

-- Subconsulta 26
-- Mostrar profesionales que todavía no hayan registrado consultas.

SELECT *
FROM healthcare_professionals hp
WHERE NOT EXISTS (
    SELECT 1
    FROM medical_visits mv
    WHERE mv.professional_id = hp.id
);

-- Subconsulta 27
-- Mostrar diagnósticos que nunca hayan sido asociados a una consulta.

SELECT *
FROM diagnoses d
WHERE NOT EXISTS (
    SELECT 1
    FROM visit_diagnoses vd
    WHERE vd.diagnosis_id = d.id
);

-- Subconsulta 28
-- Mostrar pacientes que no tengan tratamientos activos.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM treatments t
    WHERE t.patient_id = p.id
      AND t.status = 'ACTIVE'
);

-- Subconsulta 29
-- Mostrar pacientes que nunca hayan tenido procedimientos.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_procedures cp
    WHERE cp.patient_id = p.id
);

-- Subconsulta 30
-- Mostrar pacientes sin mediciones de presión intraocular.

SELECT *
FROM patients p
WHERE NOT EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN intraocular_pressures iop ON iop.visit_id = mv.id
    WHERE ch.patient_id = p.id
);

-- Subconsulta 31
-- Mostrar las mediciones de PIO superiores al promedio del mismo paciente.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, iop.eye, iop.measured_at, iop.pressure
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN intraocular_pressures iop ON iop.visit_id = mv.id
WHERE iop.pressure > (
    SELECT AVG(iop2.pressure)
    FROM clinical_histories ch2
    INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    INNER JOIN intraocular_pressures iop2 ON iop2.visit_id = mv2.id
    WHERE ch2.patient_id = p.id
);

-- Subconsulta 32
-- Mostrar los estudios OCT cuyo RNFL sea inferior al promedio del mismo paciente.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, o.eye, o.exam_date, o.rnfl_average
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN oct_exams o ON o.visit_id = mv.id
WHERE o.rnfl_average < (
    SELECT AVG(o2.rnfl_average)
    FROM clinical_histories ch2
    INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    INNER JOIN oct_exams o2 ON o2.visit_id = mv2.id
    WHERE ch2.patient_id = p.id
);

-- Subconsulta 33
-- Mostrar las consultas posteriores a la primera consulta de cada paciente.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, mv.id AS visit_id, mv.visit_date
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
WHERE mv.visit_date > (
    SELECT MIN(mv2.visit_date)
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = ch.id
);

-- Subconsulta 34
-- Mostrar la última consulta de cada paciente utilizando una subconsulta correlacionada.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, mv.id AS visit_id, mv.visit_date
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
WHERE mv.visit_date = (
    SELECT MAX(mv2.visit_date)
    FROM medical_visits mv2
    WHERE mv2.clinical_history_id = ch.id
);

-- Subconsulta 35
-- Mostrar la primera medición de PIO de cada paciente.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, iop.eye, iop.measured_at, iop.pressure
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN intraocular_pressures iop ON iop.visit_id = mv.id
WHERE iop.measured_at = (
    SELECT MIN(iop2.measured_at)
    FROM clinical_histories ch2
    INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    INNER JOIN intraocular_pressures iop2 ON iop2.visit_id = mv2.id
    WHERE ch2.patient_id = p.id
);

-- Subconsulta 36
-- Mostrar la última medición de presión intraocular de cada paciente y ojo.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, iop.eye, iop.measured_at, iop.pressure
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN intraocular_pressures iop ON iop.visit_id = mv.id
WHERE iop.measured_at = (
    SELECT MAX(iop2.measured_at)
    FROM clinical_histories ch2
    INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    INNER JOIN intraocular_pressures iop2 ON iop2.visit_id = mv2.id
    WHERE ch2.patient_id = p.id
      AND iop2.eye = iop.eye
);

-- Subconsulta 37
-- Mostrar los tratamientos cuya fecha de inicio sea posterior a la primera consulta del paciente.

SELECT t.*
FROM treatments t
WHERE t.start_date > (
    SELECT DATE(MIN(mv.visit_date))
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = t.patient_id
);

-- Subconsulta 38
-- Mostrar pacientes cuyo número de consultas sea mayor que el de todos los demás pacientes de su misma ciudad.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, p.city_id,
    (
        SELECT COUNT(*)
        FROM clinical_histories ch
        INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
        WHERE ch.patient_id = p.id
    ) AS visit_count
FROM patients p
WHERE (
    SELECT COUNT(*)
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    WHERE ch.patient_id = p.id
) >= ALL (
    SELECT COUNT(mv2.id)
    FROM patients p2
    LEFT JOIN clinical_histories ch2 ON ch2.patient_id = p2.id
    LEFT JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    WHERE p2.city_id = p.city_id
      AND p2.id <> p.id
    GROUP BY p2.id
);

-- Subconsulta 39
-- Mostrar profesionales cuya cantidad de consultas sea superior al promedio de los profesionales de su especialidad.

SELECT hp.id, CONCAT(hp.first_name, ' ', hp.last_name) AS professional_name, COUNT(mv.id) AS visit_count
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv ON mv.professional_id = hp.id
GROUP BY hp.id, hp.first_name, hp.last_name, hp.specialty_id
HAVING COUNT(mv.id) > (
    SELECT AVG(x.visit_count)
    FROM (
        SELECT hp2.id, hp2.specialty_id, COUNT(mv2.id) AS visit_count
        FROM healthcare_professionals hp2
        LEFT JOIN medical_visits mv2 ON mv2.professional_id = hp2.id
        GROUP BY hp2.id, hp2.specialty_id
    ) x
    WHERE x.specialty_id = hp.specialty_id
);

-- Subconsulta 40
-- Mostrar el estudio OCT más reciente de cada paciente.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, o.eye, o.exam_date, o.rnfl_average
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN oct_exams o ON o.visit_id = mv.id
WHERE o.exam_date = (
    SELECT MAX(o2.exam_date)
    FROM clinical_histories ch2
    INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
    INNER JOIN oct_exams o2 ON o2.visit_id = mv2.id
    WHERE ch2.patient_id = p.id
);

-- Subconsulta 41
-- Mostrar pacientes cuya presión intraocular máxima sea mayor que la presión máxima promedio de todos los pacientes.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, MAX(iop.pressure) AS patient_max_iop
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN intraocular_pressures iop ON iop.visit_id = mv.id
GROUP BY p.id, p.first_name, p.last_name
HAVING MAX(iop.pressure) > (
    SELECT AVG(x.max_iop)
    FROM (
        SELECT MAX(iop2.pressure) AS max_iop
        FROM clinical_histories ch2
        INNER JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
        INNER JOIN intraocular_pressures iop2 ON iop2.visit_id = mv2.id
        GROUP BY ch2.patient_id
    ) x
);

-- Subconsulta 42
-- Mostrar pacientes cuya cantidad de diagnósticos diferentes sea superior al promedio.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(DISTINCT vd.diagnosis_id) AS different_diagnoses
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(DISTINCT vd.diagnosis_id) > (
    SELECT AVG(x.diagnosis_count)
    FROM (
        SELECT COUNT(DISTINCT vd2.diagnosis_id) AS diagnosis_count
        FROM patients p2
        LEFT JOIN clinical_histories ch2 ON ch2.patient_id = p2.id
        LEFT JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
        LEFT JOIN visit_diagnoses vd2 ON vd2.visit_id = mv2.id
        GROUP BY p2.id
    ) x
);SELECT
    p.id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name,
    COUNT(DISTINCT vd.diagnosis_id) AS different_diagnoses
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(DISTINCT vd.diagnosis_id) > (
    SELECT AVG(x.diagnosis_count)
    FROM (
        SELECT COUNT(DISTINCT vd2.diagnosis_id) AS diagnosis_count
        FROM patients p2
        LEFT JOIN clinical_histories ch2 ON ch2.patient_id = p2.id
        LEFT JOIN medical_visits mv2 ON mv2.clinical_history_id = ch2.id
        LEFT JOIN visit_diagnoses vd2 ON vd2.visit_id = mv2.id
        GROUP BY p2.id
    ) x
);

-- Subconsulta 43
-- Mostrar los pacientes que tengan más tratamientos activos que el promedio de tratamientos activos por paciente.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(t.id) AS active_treatments
FROM patients p
INNER JOIN treatments t ON t.patient_id = p.id AND t.status = 'ACTIVE'
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(t.id) > (
    SELECT AVG(x.active_treatments)
    FROM (
        SELECT COUNT(t2.id) AS active_treatments
        FROM patients p2
        LEFT JOIN treatments t2 ON t2.patient_id = p2.id AND t2.status = 'ACTIVE'
        GROUP BY p2.id
    ) x
);

-- Subconsulta 44
-- Mostrar el medicamento más utilizado en tratamientos.

SELECT m.id, m.name, COUNT(t.id) AS use_count
FROM medications m
INNER JOIN treatments t ON t.medication_id = m.id
GROUP BY m.id, m.name
HAVING COUNT(t.id) = (
    SELECT MAX(x.use_count)
    FROM (
        SELECT COUNT(*) AS use_count
        FROM treatments
        GROUP BY medication_id
    ) x
);

-- Subconsulta 45
-- Mostrar el diagnóstico más frecuente utilizando subconsultas.

SELECT d.id, d.name, COUNT(vd.diagnosis_id) AS frequency
FROM diagnoses d
INNER JOIN visit_diagnoses vd ON vd.diagnosis_id = d.id
GROUP BY d.id, d.name
HAVING COUNT(vd.diagnosis_id) = (
    SELECT MAX(x.frequency)
    FROM (
        SELECT COUNT(*) AS frequency
        FROM visit_diagnoses
        GROUP BY diagnosis_id
    ) x
);

-- Subconsulta 46
-- Mostrar los pacientes cuya última PIO sea inferior a su primera PIO.

SELECT DISTINCT
    p.id,
    CONCAT(p.first_name, ' ', p.last_name) AS patient_name
FROM patients p
WHERE (
    SELECT iop_last.pressure
    FROM clinical_histories ch_last
    INNER JOIN medical_visits mv_last ON mv_last.clinical_history_id = ch_last.id
    INNER JOIN intraocular_pressures iop_last ON iop_last.visit_id = mv_last.id
    WHERE ch_last.patient_id = p.id
    ORDER BY iop_last.measured_at DESC
    LIMIT 1
) < (
    SELECT iop_first.pressure
    FROM clinical_histories ch_first
    INNER JOIN medical_visits mv_first ON mv_first.clinical_history_id = ch_first.id
    INNER JOIN intraocular_pressures iop_first ON iop_first.visit_id = mv_first.id
    WHERE ch_first.patient_id = p.id
    ORDER BY iop_first.measured_at ASC
    LIMIT 1
);

-- Subconsulta 47
-- Mostrar pacientes cuya presión promedio del ojo derecho sea mayor que la del ojo izquierdo.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name
FROM patients p
WHERE (
    SELECT AVG(iop_od.pressure)
    FROM clinical_histories ch_od
    INNER JOIN medical_visits mv_od ON mv_od.clinical_history_id = ch_od.id
    INNER JOIN intraocular_pressures iop_od ON iop_od.visit_id = mv_od.id
    WHERE ch_od.patient_id = p.id
      AND iop_od.eye = 'OD'
) > (
    SELECT AVG(iop_oi.pressure)
    FROM clinical_histories ch_oi
    INNER JOIN medical_visits mv_oi ON mv_oi.clinical_history_id = ch_oi.id
    INNER JOIN intraocular_pressures iop_oi ON iop_oi.visit_id = mv_oi.id
    WHERE ch_oi.patient_id = p.id
      AND iop_oi.eye = 'OI'
);

-- Subconsulta 48
-- Mostrar los pacientes con mayor cantidad de controles de glaucoma que el promedio general.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(gc.id) AS control_count
FROM patients p
INNER JOIN glaucoma_records gr ON gr.patient_id = p.id
INNER JOIN glaucoma_controls gc ON gc.glaucoma_record_id = gr.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(gc.id) > (
    SELECT AVG(x.control_count)
    FROM (
        SELECT COUNT(gc2.id) AS control_count
        FROM patients p2
        LEFT JOIN glaucoma_records gr2 ON gr2.patient_id = p2.id
        LEFT JOIN glaucoma_controls gc2 ON gc2.glaucoma_record_id = gr2.id

-- Subconsulta 49
-- Mostrar las consultas que tengan más diagnósticos asociados que el promedio de diagnósticos por consulta.

SELECT mv.id AS visit_id, mv.visit_date, COUNT(vd.diagnosis_id) AS diagnosis_count
FROM medical_visits mv
INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
GROUP BY mv.id, mv.visit_date
HAVING COUNT(vd.diagnosis_id) > (
    SELECT AVG(x.diagnosis_count)
    FROM (
        SELECT COUNT(vd2.diagnosis_id) AS diagnosis_count
        FROM medical_visits mv2
        LEFT JOIN visit_diagnoses vd2 ON vd2.visit_id = mv2.id
        GROUP BY mv2.id
    ) x
);

-- Subconsulta 50
-- Mostrar los pacientes que tengan simultáneamente OCT, campo visual, paquimetría y control de glaucoma registrados.

SELECT *
FROM patients p
WHERE EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN oct_exams o ON o.visit_id = mv.id
    WHERE ch.patient_id = p.id
)
AND EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN visual_field_exams vf ON vf.visit_id = mv.id
    WHERE ch.patient_id = p.id
)
AND EXISTS (
    SELECT 1
    FROM clinical_histories ch
    INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
    INNER JOIN pachymetry_exams pe ON pe.visit_id = mv.id
    WHERE ch.patient_id = p.id
)
AND EXISTS (
    SELECT 1
    FROM glaucoma_records gr
    INNER JOIN glaucoma_controls gc ON gc.glaucoma_record_id = gr.id
    WHERE gr.patient_id = p.id
);
