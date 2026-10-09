-- Consulta 1
-- Mostrar todos los pacientes registrados en la base de datos.

SELECT * 
FROM patients;

-- Consulta 2
-- Mostrar únicamente el número de documento, nombres y apellidos de todos los pacientes.

SELECT document_number, first_name, last_name
FROM patients;

-- Consulta 3
-- Listar todos los profesionales de salud registrados.

SELECT * 
FROM healthcare_professionals;

-- Consulta 4
-- Mostrar todos los diagnósticos disponibles en el catálogo.

SELECT * 
FROM diagnoses;

-- Consulta 5
-- Consultar todas las historias clínicas registradas.

SELECT * 
FROM clinical_histories;

-- Consulta 6
-- Mostrar todos los pacientes ordenados alfabéticamente por apellido.

SELECT p.last_name
FROM patients p
ORDER BY p.last_name ASC;

-- Consulta 7
-- Mostrar los pacientes ordenados por fecha de nacimiento desde el más joven hasta el de mayor edad.

SELECT p.birth_date
FROM patients p
ORDER BY p.birth_date ASC;

-- Consulta 8
-- Consultar los pacientes cuyo apellido sea Gómez.

SELECT p.last_name
FROM patients p
WHERE p.last_name LIKE '%Gomez%';

-- Consulta 9
-- Mostrar los pacientes cuyo número de documento comience por 10.

SELECT p.document_number
FROM patients p
WHERE p.document_number LIKE '10%';

-- Consulta 10
-- Consultar los pacientes cuyo correo electrónico pertenezca al dominio gmail.com.

SELECT p.email
FROM patients p
WHERE p.email LIKE '%gmail.com%';

-- Consulta 11
-- Mostrar los pacientes que no tengan correo electrónico registrado.

SELECT p.email
FROM patients p
WHERE p.email IS NULL;

-- Consulta 12
-- Mostrar los profesionales cuya especialidad sea Oftalmología.

SELECT hp.first_name, hp.last_name
FROM healthcare_professionals hp
INNER JOIN specialties s ON hp.id = hp.specialty_id
WHERE s.name LIKE '%Oftalmologia%';

-- Consulta 13
-- Consultar todas las consultas médicas realizadas durante el año 2026.

SELECT mv.visit_date
FROM medical_visits mv
WHERE mv.visit_date BETWEEN '2026-01-01' AND '2026-12-31';

-- Consulta 14
-- Mostrar las consultas realizadas durante un mes determinado.

SELECT mv.visit_date
FROM medical_visits mv
WHERE MONTH(mv.visit_date) = 3 AND YEAR(mv.visit_date) = 2026;

-- Consulta 15
-- Consultar las mediciones de presión intraocular superiores a 20 mmHg.

SELECT ip.pressure
FROM intraocular_pressures ip
WHERE ip.pressure > 20;

-- Consulta 16
-- Mostrar las mediciones de presión intraocular correspondientes únicamente al ojo derecho.

SELECT ip.pressure, ip.eye
FROM intraocular_pressures ip
WHERE ip.eye = 'OD';

-- Consulta 17
-- Mostrar las mediciones correspondientes únicamente al ojo izquierdo.

SELECT ip.pressure, ip.eye
FROM intraocular_pressures ip
WHERE ip.eye = 'OI';

-- Consulta 18
-- Consultar todos los tratamientos que se encuentren activos.

SELECT t.id ,t.status
FROM treatments t
WHERE t.status = 'ACTIVE';

-- Consulta 19
-- Mostrar todos los tratamientos que hayan finalizado.

SELECT t.id ,t.status
FROM treatments t
WHERE t.status = 'FINISHED';

-- Consulta 20
-- Consultar los procedimientos realizados después de una fecha determinada.

SELECT cp.procedure_date
FROM clinical_procedures cp
WHERE cp.procedure_date > '2026-02-14';

-- Consulta 21
-- Mostrar cada paciente junto con el número de su historia clínica.

SELECT p.id, p.first_name, p.last_name, ch.id, ch.history_number
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id;

-- Consulta 22
-- Mostrar cada consulta indicando el nombre completo del paciente.

SELECT ch.id, p.id, p.first_name, p.last_name
FROM clinical_histories ch
INNER JOIN patients p ON p.id = ch.patient_id;

-- Consulta 23
-- Mostrar cada consulta junto con el nombre del profesional que la realizó.

SELECT mv.id, hp.id, hp.first_name, hp.last_name
FROM medical_visits mv
INNER JOIN healthcare_professionals hp ON hp.id = mv.professional_id;

-- Consulta 24
-- Listar todos los pacientes junto con la fecha de sus consultas.

SELECT p.id, CONCAT(p.first_name, ' ', p.last_name), mv.visit_date 
FROM patients p
INNER JOIN clinical_histories ch ON p.id = ch.patient_id
INNER JOIN medical_visits mv ON ch.id = mv.clinical_history_id;

-- Consulta 25
-- Mostrar los diagnósticos asociados a cada consulta.

SELECTmv.id AS visit_id,mv.visit_date,d.code,d.name AS diagnosis
FROM medical_visits mv
INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
INNER JOIN diagnoses d ON d.id = vd.diagnosis_id
ORDER BY mv.id;

-- Consulta 26
-- Mostrar nombre del paciente, fecha de consulta y diagnóstico correspondiente.

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name,mv.visit_date,d.name AS diagnosis
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
INNER JOIN diagnoses d ON d.id = vd.diagnosis_id
ORDER BY p.last_name, mv.visit_date;

-- Consulta 27
-- Consultar todos los pacientes que tengan diagnóstico de glaucoma.

SELECT DISTINCT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
INNER JOIN visit_diagnoses vd ON vd.visit_id = mv.id
INNER JOIN diagnoses d ON d.id = vd.diagnosis_id
WHERE d.diagnosis_type = 'GLAUCOMA';

-- Consulta 28
-- Mostrar todos los controles de glaucoma indicando el paciente correspondiente.

SELECT gc.id AS control_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, gc.control_date, gc.progression, gc.next_control_date
FROM glaucoma_controls gc
INNER JOIN glaucoma_records gr ON gr.id = gc.glaucoma_record_id
INNER JOIN patients p ON p.id = gr.patient_id
ORDER BY p.last_name, gc.control_date;

-- Consulta 29
-- Mostrar cada medición de presión intraocular junto con nombre del paciente, fecha y ojo.

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name, iop.measured_at, iop.eye, iop.pressure
FROM intraocular_pressures iop
INNER JOIN medical_visits mv ON mv.id = iop.visit_id
INNER JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
INNER JOIN patients p ON p.id = ch.patient_id
ORDER BY patient_name, iop.measured_at;

-- Consulta 30
-- Mostrar los estudios OCT realizados indicando paciente, ojo y fecha.

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name, iop.measured_at, iop.eye, iop.pressure
FROM intraocular_pressures iop
INNER JOIN medical_visits mv ON mv.id = iop.visit_id
INNER JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
INNER JOIN patients p ON p.id = ch.patient_id
ORDER BY patient_name, iop.measured_at;

-- Consulta 31
-- Mostrar los campos visuales registrados indicando paciente, ojo, MD, PSD y VFI.

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name, vf.eye, vf.exam_date, vf.md, vf.psd, vf.vfi
FROM visual_field_exams vf
INNER JOIN medical_visits mv ON mv.id = vf.visit_id
INNER JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
INNER JOIN patients p ON p.id = ch.patient_id
ORDER BY patient_name, vf.exam_date;

-- Consulta 32
-- Mostrar las paquimetrías realizadas junto con el paciente y el espesor corneal registrado.

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name, pe.eye, pe.exam_date, pe.corneal_thickness
FROM pachymetry_exams pe
INNER JOIN medical_visits mv ON mv.id = pe.visit_id
INNER JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
INNER JOIN patients p ON p.id = ch.patient_id
ORDER BY patient_name, pe.exam_date;

-- Consulta 33
-- Mostrar los tratamientos activos incluyendo nombre del paciente y medicamento.

SELECT CONCAT(p.first_name, ' ', p.last_name) AS patient_name, m.name AS medication, t.dosage, t.frequency, t.start_date
FROM treatments t
INNER JOIN patients p ON p.id = t.patient_id
INNER JOIN medications m ON m.id = t.medication_id
WHERE t.status = 'ACTIVE'
ORDER BY patient_name, t.start_date

-- Consulta 34
-- Mostrar cada medicamento y la cantidad de tratamientos en los que ha sido utilizado.

SELECT m.name AS medication, COUNT(t.id) AS treatment_count
FROM medications m
LEFT JOIN treatments t ON t.medication_id = m.id
GROUP BY m.id, m.name
ORDER BY treatment_count DESC, m.name;

-- Consulta 35
-- Mostrar la cantidad total de pacientes registrados.

SELECT COUNT(*) AS total_patients
FROM patients;

-- Consulta 36
-- Mostrar la cantidad de consultas realizadas.

SELECT *
FROM medical_visits mv;

-- Consulta 37
-- Mostrar la cantidad de pacientes por sexo.

SELECT sex, COUNT(*) AS total_patients
FROM patients
GROUP BY sex;

-- Consulta 38
-- Mostrar la cantidad de pacientes atendidos por cada profesional.

SELECT mv.id, mv.professional_id COUNT(*), ch.patient_id
FROM medical_visits mv
INNER JOIN clinical_histories ch ON ch.id = mv.clinical_history_id
GROUP BY mv.professional_id;

-- Consulta 39
-- Calcular el promedio general de presión intraocular.

SELECT AVG(pressure) AS average_iop
FROM intraocular_pressures;

-- Consulta 40
-- Calcular la presión intraocular mínima y máxima registrada.

SELECT MIN(pressure) AS minimum_iop, MAX(pressure) AS maximum_iop
FROM intraocular_pressures;

-- Consulta 41
-- Calcular la presión intraocular promedio para OD y OI por separado.

SELECT eye,AVG(pressure) AS average_iop
FROM intraocular_pressures
GROUP BY eye;

-- Consulta 42
-- Mostrar la cantidad de consultas realizadas por cada paciente.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(mv.id) AS visit_count
FROM patients p
LEFT JOIN clinical_histories ch ON ch.patient_id = p.id
LEFT JOIN medical_visits mv ON mv.clinical_history_id = ch.id
GROUP BY p.id, p.first_name, p.last_name
ORDER BY visit_count DESC;

-- Consulta 43
-- Mostrar únicamente los pacientes que tengan tres o más consultas.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(mv.id) AS visit_count
FROM patients p
INNER JOIN clinical_histories ch ON ch.patient_id = p.id
INNER JOIN medical_visits mv ON mv.clinical_history_id = ch.id
GROUP BY p.id, p.first_name, p.last_name
HAVING COUNT(mv.id) >= 3;

-- Consulta 44
-- Mostrar cada profesional junto con la cantidad de consultas realizadas.

SELECT CONCAT(hp.first_name, ' ', hp.last_name) AS professional_name, COUNT(mv.id) AS visit_count
FROM healthcare_professionals hp
LEFT JOIN medical_visits mv ON mv.professional_id = hp.id
GROUP BY hp.id, hp.first_name, hp.last_name
ORDER BY visit_count DESC;

-- Consulta 45
-- Mostrar los profesionales que hayan realizado más de 20 consultas.

SELECT CONCAT(hp.first_name, ' ', hp.last_name) AS professional_name, COUNT(mv.id) AS visit_count
FROM healthcare_professionals hp
INNER JOIN medical_visits mv ON mv.professional_id = hp.id
GROUP BY hp.id, hp.first_name, hp.last_name
HAVING COUNT(mv.id) > 20;

-- Consulta 46
-- Calcular la cantidad de diagnósticos registrados por tipo de diagnóstico.

SELECT d.diagnosis_type, COUNT(vd.diagnosis_id) AS total_registered
FROM diagnoses d
LEFT JOIN visit_diagnoses vd ON vd.diagnosis_id = d.id
GROUP BY d.diagnosis_type;

-- Consulta 47
-- Mostrar los cinco diagnósticos más frecuentes.

SELECT d.name AS diagnosis, COUNT(vd.diagnosis_id) AS frequency
FROM diagnoses d
INNER JOIN visit_diagnoses vd ON vd.diagnosis_id = d.id
GROUP BY d.id, d.name
ORDER BY frequency DESC
LIMIT 5;

-- Consulta 48
-- Mostrar la cantidad de estudios OCT realizados por mes.

SELECT DATE_FORMAT(exam_date, '%Y-%m') AS exam_month, COUNT(*) AS total_oct
FROM oct_exams
GROUP BY DATE_FORMAT(exam_date, '%Y-%m')
ORDER BY exam_month;

-- Consulta 49
-- Mostrar la cantidad de campos visuales realizados por año.

SELECT YEAR(exam_date) AS exam_year, COUNT(*) AS total_visual_fields
FROM visual_field_exams
GROUP BY YEAR(exam_date)
ORDER BY exam_year;

-- Consulta 50
-- Generar un reporte que muestre por paciente: nombre completo, número de consultas, cantidad de controles de glaucoma, promedio de PIO y fecha de última consulta.

SELECT p.id AS patient_id, CONCAT(p.first_name, ' ', p.last_name) AS patient_name, COUNT(DISTINCT mv.id) AS visit_count, COUNT(DISTINCT gc.id) AS glaucoma_control_count, AVG(iop.pressure) AS average_iop, MAX(mv.visit_date) AS last_visit
FROM patients p
LEFT JOIN clinical_histories ch ON ch.patient_id = p.id
LEFT JOIN medical_visits mv ON mv.clinical_history_id = ch.id
LEFT JOIN glaucoma_records gr ON gr.patient_id = p.id
LEFT JOIN glaucoma_controls gc ON gc.glaucoma_record_id = gr.id
LEFT JOIN intraocular_pressures iop ON iop.visit_id = mv.id
GROUP BY p.id, p.first_name, p.last_name
ORDER BY p.last_name, p.first_name;
