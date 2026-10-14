USE ophthalmology_glaucoma_db;

INSERT INTO document_types(code, name) VALUES
('CC', 'Cedula de ciudadania'),
('TI', 'Tarjeta de identidad'),
('CE', 'Cedula de extranjeria'),
('PA', 'Pasaporte');

INSERT INTO cities(name, department, country) VALUES
('Bogota', 'Cundinamarca', 'Colombia'),
('Medellin', 'Antioquia', 'Colombia'),
('Cali', 'Valle del Cauca', 'Colombia'),
('Barranquilla', 'Atlantico', 'Colombia'),
('Bucaramanga', 'Santander', 'Colombia');

INSERT INTO specialties(name) VALUES
('Oftalmologia general'),
('Glaucoma'),
('Retina'),
('Optometria'),
('Cirugia ocular');

INSERT INTO healthcare_professionals(specialty_id, license_number, first_name, last_name, phone, email) VALUES
(1, 'RM-1001', 'Laura', 'Martinez', '3001111111', 'laura.martinez@clinica.edu'),
(2, 'RM-1002', 'Andres', 'Gomez', '3002222222', 'andres.gomez@clinica.edu'),
(3, 'RM-1003', 'Camila', 'Rojas', '3003333333', 'camila.rojas@clinica.edu'),
(4, 'RM-1004', 'Santiago', 'Perez', '3004444444', 'santiago.perez@clinica.edu'),
(5, 'RM-1005', 'Diana', 'Torres', '3005555555', 'diana.torres@clinica.edu');

INSERT INTO diagnoses(code, name, diagnosis_type) VALUES
('H40.1', 'Glaucoma primario de angulo abierto', 'GLAUCOMA'),
('H40.2', 'Glaucoma de angulo cerrado', 'GLAUCOMA'),
('H40.0', 'Sospecha de glaucoma', 'GLAUCOMA'),
('H25.9', 'Catarata senil', 'CATARACT'),
('H52.1', 'Miopia', 'GENERAL'),
('H52.0', 'Hipermetropia', 'GENERAL'),
('H10.9', 'Conjuntivitis', 'GENERAL'),
('E11.3', 'Retinopatia diabetica', 'RETINA'),
('H35.3', 'Degeneracion macular', 'RETINA'),
('Z01.0', 'Examen oftalmologico general', 'GENERAL');

INSERT INTO antecedent_types(name) VALUES
('Personal'), ('Familiar'), ('Quirurgico'), ('Farmacologico');

INSERT INTO allergies(name) VALUES
('Penicilina'), ('Sulfas'), ('Latanoprost'), ('Ninguna conocida');

INSERT INTO medications(name, concentration, pharmaceutical_form) VALUES
('Latanoprost', '0.005%', 'Gotas oftalmicas'),
('Timolol', '0.5%', 'Gotas oftalmicas'),
('Dorzolamida', '2%', 'Gotas oftalmicas'),
('Brimonidina', '0.2%', 'Gotas oftalmicas'),
('Acetazolamida', '250 mg', 'Tableta'),
('Lagrimas artificiales', NULL, 'Gotas oftalmicas');

INSERT INTO patients(document_type_id, city_id, document_number, first_name, last_name, birth_date, sex, phone, email, address) VALUES
(1,1,'1001001001','Carlos','Gomez','1964-03-12','M','3101001001','carlos.gomez@gmail.com','Calle 10 # 5-20'),
(1,1,'1001001002','Maria','Rodriguez','1972-09-25','F','3101001002','maria.rodriguez@example.com','Carrera 8 # 12-30'),
(1,2,'1001001003','Jorge','Ramirez','1958-01-18','M','3101001003','jorge.ramirez@example.com','Av 80 # 40-11'),
(1,3,'1001001004','Ana','Lopez','1981-07-04','F','3101001004','ana.lopez@example.com','Calle 5 # 3-14'),
(1,4,'1001001005','Luis','Herrera','1969-11-30','M','3101001005','luis.herrera@example.com','Carrera 43 # 20-15'),
(1,5,'1001001006','Patricia','Moreno','1955-06-16','F','3101001006','patricia.moreno@example.com','Calle 45 # 18-21'),
(1,1,'1001001007','Fernando','Castro','1978-12-02','M','3101001007','fernando.castro@example.com','Av 19 # 90-11'),
(1,2,'1001001008','Claudia','Vargas','1988-04-09','F','3101001008','claudia.vargas@example.com','Calle 33 # 8-44'),
(1,3,'1001001009','Ricardo','Diaz','1949-10-21','M','3101001009','ricardo.diaz@example.com','Carrera 12 # 6-77'),
(1,4,'1001001010','Elena','Sanchez','1992-02-14','F','3101001010','elena.sanchez@example.com','Calle 70 # 54-10'),
(1,5,'1001001011','Miguel','Rincon','1961-08-08','M','3101001011','miguel.rincon@example.com','Carrera 27 # 36-55'),
(1,1,'1001001012','Sofia','Mendez','1975-05-27','F','3101001012','sofia.mendez@example.com','Calle 116 # 15-04'),
(1,2,'1001001013','Oscar','Pardo','1983-01-03','M','3101001013','oscar.pardo@example.com','Av Oriental # 22-19'),
(1,3,'1001001014','Natalia','Reyes','1967-07-19','F','3101001014','natalia.reyes@example.com','Calle 9 # 44-60'),
(1,4,'1001001015','Hector','Navarro','1952-03-29','M','3101001015','hector.navarro@example.com','Carrera 51 # 72-18'),
(1,5,'1001001016','Lucia','Acosta','1990-09-11','F','3101001016','lucia.acosta@example.com','Calle 35 # 21-02'),
(1,1,'1001001017','Raul','Mejia','1970-06-06','M','3101001017','raul.mejia@example.com','Av Suba # 120-10'),
(1,2,'1001001018','Isabel','Cortes','1959-12-24','F','3101001018','isabel.cortes@example.com','Calle 50 # 75-33'),
(1,3,'1001001019','Daniel','Fuentes','1986-10-10','M','3101001019','daniel.fuentes@example.com','Carrera 7 # 13-90'),
(1,4,'1001001020','Paula','Salazar','1979-04-17','F','3101001020',NULL,'Calle 84 # 52-01');

INSERT INTO clinical_histories(patient_id, history_number, opening_date) VALUES
(1,'HC-0001','2024-01-10'), (2,'HC-0002','2024-01-12'), (3,'HC-0003','2024-01-15'), (4,'HC-0004','2024-01-20'),
(5,'HC-0005','2024-02-01'), (6,'HC-0006','2024-02-04'), (7,'HC-0007','2024-02-09'), (8,'HC-0008','2024-02-15'),
(9,'HC-0009','2024-02-21'), (10,'HC-0010','2024-03-01'), (11,'HC-0011','2024-03-05'), (12,'HC-0012','2024-03-10'),
(13,'HC-0013','2024-03-13'), (14,'HC-0014','2024-03-18'), (15,'HC-0015','2024-04-01'), (16,'HC-0016','2024-04-08'),
(17,'HC-0017','2024-04-12'), (18,'HC-0018','2024-04-20'), (19,'HC-0019','2024-05-02'), (20,'HC-0020','2024-05-09');

INSERT INTO medical_visits(clinical_history_id, professional_id, visit_date, reason, assessment, plan, status) VALUES
(1,2,'2024-01-10 08:00:00','Vision borrosa y control de PIO','Sospecha de glaucoma','Solicitar OCT y campo visual','CLOSED'),
(1,2,'2024-03-15 08:30:00','Control glaucoma','PIO elevada OD','Ajustar tratamiento','CLOSED'),
(1,2,'2024-06-20 09:00:00','Seguimiento','PIO en descenso','Continuar controles','CLOSED'),
(2,1,'2024-01-12 10:00:00','Revision general','Miopia','Correccion optica','CLOSED'),
(3,2,'2024-01-15 09:30:00','Dolor ocular','Glaucoma angulo cerrado','Tratamiento urgente','CLOSED'),
(3,2,'2024-04-15 09:30:00','Control','Mejoria parcial','Continuar medicamento','CLOSED'),
(4,1,'2024-01-20 11:00:00','Ojo rojo','Conjuntivitis','Tratamiento topico','CLOSED'),
(5,3,'2024-02-01 08:00:00','Control diabetico ocular','Retinopatia diabetica','Seguimiento retina','CLOSED'),
(6,2,'2024-02-04 08:30:00','Antecedente familiar glaucoma','Sospecha glaucoma','Control PIO','CLOSED'),
(6,2,'2024-05-04 08:30:00','Control PIO','Estable','Nuevo control','CLOSED'),
(7,1,'2024-02-09 10:20:00','Catarata','Catarata senil','Valoracion quirurgica','CLOSED'),
(8,4,'2024-02-15 09:00:00','Optometria','Hipermetropia','Formula optica','CLOSED'),
(9,2,'2024-02-21 08:00:00','Glaucoma conocido','Progresion probable','OCT y campo visual','CLOSED'),
(9,2,'2024-05-21 08:00:00','Control glaucoma','PIO alta','Adicionar medicamento','CLOSED'),
(9,2,'2024-08-21 08:00:00','Control glaucoma','Estable','Continuar','CLOSED'),
(10,1,'2024-03-01 14:00:00','Examen anual','Normal','Control anual','CLOSED'),
(11,2,'2024-03-05 08:40:00','Control glaucoma','Estable','Seguimiento','CLOSED'),
(11,2,'2024-07-05 08:40:00','Control glaucoma','Sin progresion','Continuar','CLOSED'),
(12,3,'2024-03-10 10:10:00','Vision central alterada','Degeneracion macular','Seguimiento retina','CLOSED'),
(13,1,'2024-03-13 11:00:00','Cefalea visual','Miopia','Correccion','CLOSED'),
(14,2,'2024-03-18 07:50:00','Sospecha glaucoma','Sospecha','Estudios complementarios','CLOSED'),
(14,2,'2024-06-18 07:50:00','Control','PIO limite','Seguimiento','CLOSED'),
(15,5,'2024-04-01 13:00:00','Catarata avanzada','Catarata','Programar procedimiento','CLOSED'),
(16,1,'2024-04-08 09:45:00','Irritacion ocular','Ojo seco','Lagrimas artificiales','CLOSED'),
(17,2,'2024-04-12 08:15:00','Glaucoma','Glaucoma abierto','Tratamiento','CLOSED'),
(17,2,'2024-09-12 08:15:00','Control','PIO controlada','Mantener tratamiento','CLOSED'),
(18,2,'2024-04-20 10:45:00','Control glaucoma','Glaucoma abierto','Control trimestral','CLOSED'),
(19,4,'2024-05-02 12:00:00','Optometria','Miopia leve','Formula','CLOSED'),
(20,1,'2024-05-09 15:00:00','Revision','Conjuntivitis','Tratamiento topico','CLOSED'),
(20,1,'2024-06-09 15:00:00','Control','Resuelto','Alta','CLOSED'),
(1,2,'2026-01-15 08:30:00','Control anual de glaucoma','Paciente estable','Continuar tratamiento','CLOSED'),
(9,2,'2026-02-20 09:00:00','Control de PIO','PIO en seguimiento','Solicitar nuevos estudios','CLOSED'),
(12,3,'2026-03-10 10:00:00','Control de retina','Sin cambios importantes','Continuar controles','CLOSED');

INSERT INTO visit_diagnoses(visit_id, diagnosis_id, is_primary) VALUES
(1,3,TRUE),(2,1,TRUE),(3,1,TRUE),(4,5,TRUE),(5,2,TRUE),(6,2,TRUE),(7,7,TRUE),(8,8,TRUE),(9,3,TRUE),(10,3,TRUE),
(11,4,TRUE),(12,6,TRUE),(13,1,TRUE),(14,1,TRUE),(15,1,TRUE),(16,10,TRUE),(17,1,TRUE),(18,1,TRUE),(19,9,TRUE),(20,5,TRUE),
(21,3,TRUE),(22,3,TRUE),(23,4,TRUE),(24,10,TRUE),(25,1,TRUE),(26,1,TRUE),(27,1,TRUE),(28,5,TRUE),(29,7,TRUE),(30,7,TRUE),
(31,1,TRUE),(32,1,TRUE),(33,9,TRUE);

INSERT INTO patient_antecedents(patient_id, antecedent_type_id, description, registered_at) VALUES
(1,2,'Padre con antecedente de glaucoma','2024-01-10'),
(3,1,'Hipertension arterial','2024-01-15'),
(6,2,'Madre con glaucoma','2024-02-04'),
(9,1,'Diabetes mellitus tipo 2','2024-02-21'),
(15,3,'Cirugia ocular previa','2024-04-01');

INSERT INTO patient_allergies(patient_id, allergy_id, reaction) VALUES
(1,4,NULL),
(3,1,'Erupcion en la piel'),
(6,4,NULL),
(9,2,'Irritacion'),
(17,4,NULL);

INSERT INTO ophthalmologic_exams(visit_id, visual_acuity_od, visual_acuity_oi, slit_lamp_findings, fundus_findings, observations) VALUES
(1,'20/40','20/30','Sin hallazgos importantes','Excavacion aumentada OD','Control inicial'),
(5,'20/80','20/60','Camara anterior estrecha','Nervio optico sospechoso','Requiere seguimiento'),
(13,'20/50','20/40','Sin alteraciones','Excavacion aumentada bilateral','Paciente con glaucoma'),
(21,'20/30','20/30','Normal','Sospecha de excavacion','Solicitar estudios'),
(25,'20/40','20/40','Normal','Cambios compatibles con glaucoma','Inicio de tratamiento');

INSERT INTO glaucoma_records(patient_id, diagnosis_date, glaucoma_type, target_pressure_od, target_pressure_oi, clinical_status) VALUES
(1,'2024-03-15','Primario de angulo abierto',16,16,'CONTROLLED'),
(3,'2024-01-15','Angulo cerrado',15,15,'STABLE'),
(6,'2024-02-04','Sospecha de glaucoma',18,18,'SUSPECT'),
(9,'2024-02-21','Primario de angulo abierto',14,14,'PROGRESSION'),
(11,'2024-03-05','Primario de angulo abierto',16,16,'STABLE'),
(14,'2024-03-18','Sospecha de glaucoma',18,18,'SUSPECT'),
(17,'2024-04-12','Primario de angulo abierto',15,15,'CONTROLLED'),
(18,'2024-04-20','Primario de angulo abierto',16,16,'STABLE');

INSERT INTO glaucoma_controls(glaucoma_record_id, visit_id, control_date, optic_nerve_status, progression, next_control_date, observations) VALUES
(1,1,'2024-01-10','Excavacion aumentada OD',FALSE,'2024-03-15','Control inicial'),
(1,2,'2024-03-15','Sin cambios relevantes',FALSE,'2024-06-20','Ajuste de tratamiento'),
(1,3,'2024-06-20','Estable',FALSE,'2024-09-20','Buen control'),
(2,5,'2024-01-15','Angulo estrecho',TRUE,'2024-04-15','Requiere vigilancia'),
(2,6,'2024-04-15','Mejoria parcial',FALSE,'2024-07-15','Continua manejo'),
(3,9,'2024-02-04','Sospecha por antecedente familiar',FALSE,'2024-05-04','Control PIO'),
(3,10,'2024-05-04','Estable',FALSE,'2024-08-04','Seguimiento'),
(4,13,'2024-02-21','Excavacion progresiva',TRUE,'2024-05-21','Alto riesgo'),
(4,14,'2024-05-21','PIO alta',TRUE,'2024-08-21','Adicionar medicamento'),
(4,15,'2024-08-21','Estable',FALSE,'2024-11-21','Continuar'),
(5,17,'2024-03-05','Estable',FALSE,'2024-07-05','Control'),
(5,18,'2024-07-05','Sin progresion',FALSE,'2024-11-05','Seguimiento'),
(6,21,'2024-03-18','Sospecha',FALSE,'2024-06-18','Estudios'),
(6,22,'2024-06-18','PIO limite',FALSE,'2024-09-18','Control'),
(7,25,'2024-04-12','Glaucoma abierto',FALSE,'2024-09-12','Inicio tratamiento'),
(7,26,'2024-09-12','Controlado',FALSE,'2025-01-12','Mantener'),
(8,27,'2024-04-20','Estable',FALSE,'2024-07-20','Seguimiento');

INSERT INTO intraocular_pressures(visit_id, eye, pressure, measured_at) VALUES
(1,'OD',24,'2024-01-10 08:15:00'),
(1,'OI',21,'2024-01-10 08:16:00'),
(2,'OD',22,'2024-03-15 08:40:00'),
(2,'OI',19,'2024-03-15 08:41:00'),
(3,'OD',17,'2024-06-20 09:10:00'),
(3,'OI',16,'2024-06-20 09:11:00'),
(5,'OD',32,'2024-01-15 09:40:00'),
(5,'OI',28,'2024-01-15 09:41:00'),
(6,'OD',20,'2024-04-15 09:40:00'),
(6,'OI',19,'2024-04-15 09:41:00'),
(9,'OD',21,'2024-02-04 08:40:00'),
(9,'OI',20,'2024-02-04 08:41:00'),
(10,'OD',18,'2024-05-04 08:40:00'),
(10,'OI',18,'2024-05-04 08:41:00'),
(13,'OD',27,'2024-02-21 08:10:00'),
(13,'OI',25,'2024-02-21 08:11:00'),
(14,'OD',24,'2024-05-21 08:10:00'),
(14,'OI',23,'2024-05-21 08:11:00'),
(15,'OD',17,'2024-08-21 08:10:00'),
(15,'OI',16,'2024-08-21 08:11:00'),
(17,'OD',18,'2024-03-05 08:45:00'),
(17,'OI',17,'2024-03-05 08:46:00'),
(18,'OD',16,'2024-07-05 08:45:00'),
(18,'OI',16,'2024-07-05 08:46:00'),
(21,'OD',22,'2024-03-18 08:00:00'),
(21,'OI',21,'2024-03-18 08:01:00'),
(22,'OD',20,'2024-06-18 08:00:00'),
(22,'OI',19,'2024-06-18 08:01:00'),
(25,'OD',25,'2024-04-12 08:25:00'),
(25,'OI',23,'2024-04-12 08:26:00'),
(26,'OD',16,'2024-09-12 08:25:00'),
(26,'OI',15,'2024-09-12 08:26:00'),
(27,'OD',19,'2024-04-20 10:55:00'),
(27,'OI',18,'2024-04-20 10:56:00');

INSERT INTO oct_exams(visit_id, eye, exam_date, rnfl_average, cup_disc_ratio, interpretation, validated) VALUES
(1,'OD','2024-01-10',72,0.70,'Adelgazamiento RNFL superior',TRUE),
(1,'OI','2024-01-10',84,0.50,'Dentro de limites',TRUE),
(5,'OD','2024-01-15',65,0.80,'Dano glaucomatoso',TRUE),
(13,'OD','2024-02-21',60,0.85,'Progresion probable',TRUE),
(13,'OI','2024-02-21',68,0.75,'Adelgazamiento RNFL',TRUE),
(17,'OD','2024-03-05',78,0.65,'Estable',TRUE),
(21,'OD','2024-03-18',82,0.55,'Sospecha',FALSE),
(25,'OD','2024-04-12',70,0.72,'Compatible con glaucoma',TRUE),
(27,'OI','2024-04-20',76,0.62,'Estable',TRUE);

INSERT INTO visual_field_exams(visit_id, eye, exam_date, md, psd, vfi, interpretation) VALUES
(1,'OD','2024-01-10',-5.20,4.10,88,'Defecto arcuato inicial'),
(1,'OI','2024-01-10',-2.10,2.00,96,'Leve disminucion'),
(5,'OD','2024-01-15',-12.50,8.40,65,'Dano moderado'),
(13,'OD','2024-02-21',-10.10,7.70,70,'Progresion'),
(17,'OD','2024-03-05',-4.00,3.00,90,'Estable'),
(21,'OD','2024-03-18',-3.20,2.80,92,'Sospecha'),
(25,'OD','2024-04-12',-6.80,4.50,84,'Defecto compatible'),
(27,'OI','2024-04-20',-3.80,3.10,91,'Estable');

INSERT INTO pachymetry_exams(visit_id, eye, corneal_thickness, exam_date, interpretation) VALUES
(1,'OD',520,'2024-01-10','Cornea promedio'),
(1,'OI',535,'2024-01-10','Cornea promedio'),
(5,'OD',498,'2024-01-15','Cornea delgada'),
(13,'OD',505,'2024-02-21','Cornea delgada'),
(21,'OD',540,'2024-03-18','Normal'),
(25,'OD',515,'2024-04-12','Normal');

INSERT INTO gonioscopy_exams(visit_id, eye, angle_grade, pigmentation, exam_date, interpretation) VALUES
(5,'OD','Shaffer I','Moderada','2024-01-15','Angulo estrecho'),
(5,'OI','Shaffer II','Moderada','2024-01-15','Angulo estrecho'),
(13,'OD','Shaffer III','Leve','2024-02-21','Angulo abierto'),
(25,'OD','Shaffer III','Leve','2024-04-12','Angulo abierto');

INSERT INTO treatments(patient_id, visit_id, medication_id, start_date, end_date, dosage, frequency, status) VALUES
(1,2,1,'2024-03-15',NULL,'1 gota','Cada noche','ACTIVE'),
(1,2,2,'2024-03-15',NULL,'1 gota','Cada 12 horas','ACTIVE'),
(3,5,5,'2024-01-15','2024-01-22','1 tableta','Cada 8 horas','FINISHED'),
(3,6,1,'2024-04-15',NULL,'1 gota','Cada noche','ACTIVE'),
(6,9,6,'2024-02-04',NULL,'1 gota','Cada 8 horas','ACTIVE'),
(9,14,1,'2024-05-21',NULL,'1 gota','Cada noche','ACTIVE'),
(9,14,3,'2024-05-21',NULL,'1 gota','Cada 12 horas','ACTIVE'),
(11,17,2,'2024-03-05',NULL,'1 gota','Cada 12 horas','ACTIVE'),
(17,25,1,'2024-04-12',NULL,'1 gota','Cada noche','ACTIVE'),
(18,27,4,'2024-04-20',NULL,'1 gota','Cada 12 horas','ACTIVE');

INSERT INTO clinical_procedures(patient_id, visit_id, procedure_type, procedure_date, eye, description) VALUES
(15,23,'Valoracion prequirurgica catarata','2024-04-01','OD','Preparacion para facoemulsificacion'),
(3,5,'Iridotomia laser','2024-01-16','OD','Manejo preventivo por angulo cerrado'),
(9,14,'Trabeculoplastia laser selectiva','2024-05-25','OD','Manejo complementario de PIO');



INSERT INTO clinical_documents(patient_id, visit_id, document_type, file_name, file_path) VALUES
(1,1,'OCT','oct_carlos_2024.pdf','/documentos/paciente_1/oct_carlos_2024.pdf'),
(3,5,'Campo visual','campo_visual_jorge_2024.pdf','/documentos/paciente_3/campo_visual_jorge_2024.pdf'),
(9,13,'OCT','oct_ricardo_2024.pdf','/documentos/paciente_9/oct_ricardo_2024.pdf');
