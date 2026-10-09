# Modelos y mapas del proyecto corregidos

Este archivo contiene los modelos principales del proyecto. Se mantienen sencillos para que sean faciles de explicar y sustentar.

## 1. Mapa general del sistema

```mermaid
flowchart TD
    P[Paciente] --> H[Historia clinica]
    H --> C[Consulta medica]
    C --> D[Diagnosticos]
    C --> EO[Examen oftalmologico]
    C --> PIO[Presion intraocular]
    C --> OCT[OCT]
    C --> CV[Campo visual]
    C --> PAQ[Paquimetria]
    C --> GON[Gonioscopia]
    P --> ANT[Antecedentes]
    P --> AL[Alergias]
    P --> GR[Registro glaucoma]
    GR --> GC[Controles glaucoma]
    P --> T[Tratamientos]
    T --> M[Medicamentos]
    P --> PR[Procedimientos]
    P --> DOC[Documentos clinicos]
```

## 2. Modelo conceptual

El modelo conceptual muestra las entidades principales y sus relaciones sin entrar todavia en tipos de datos o detalles propios de MySQL.

```mermaid
flowchart LR
    PACIENTE -->|tiene una| HISTORIA_CLINICA
    HISTORIA_CLINICA -->|registra muchas| CONSULTA
    PROFESIONAL -->|atiende muchas| CONSULTA
    ESPECIALIDAD -->|clasifica| PROFESIONAL

    CONSULTA <-->|muchos a muchos| DIAGNOSTICO

    CONSULTA -->|registra| EXAMEN_OFTALMOLOGICO
    CONSULTA -->|registra| PIO
    CONSULTA -->|registra| OCT
    CONSULTA -->|registra| CAMPO_VISUAL
    CONSULTA -->|registra| PAQUIMETRIA
    CONSULTA -->|registra| GONIOSCOPIA

    PACIENTE -->|tiene| ANTECEDENTE
    PACIENTE -->|puede tener| ALERGIA
    PACIENTE -->|puede tener| GLAUCOMA
    GLAUCOMA -->|tiene muchos| CONTROL_GLAUCOMA
    PACIENTE -->|recibe| TRATAMIENTO
    MEDICAMENTO -->|se usa en| TRATAMIENTO
    PACIENTE -->|recibe| PROCEDIMIENTO
    PACIENTE -->|tiene| DOCUMENTO_CLINICO
```

## 3. Modelo logico visual

El modelo logico muestra las tablas principales, sus claves primarias (PK), claves foraneas (FK) y la forma en que se conectan.

**Importante:** este modelo se divide en tres diagramas solamente para que pueda leerse bien en Typora y en la sustentacion. Los tres diagramas juntos forman un solo modelo logico.

### 3.1. Nucleo clinico

```mermaid
flowchart TB
    DT["DOCUMENT_TYPES<br/>PK id<br/>code UNIQUE<br/>name UNIQUE"]
    CI["CITIES<br/>PK id<br/>name<br/>department<br/>country"]
    PA["PATIENTS<br/>PK id<br/>FK document_type_id<br/>FK city_id<br/>document_number<br/>first_name<br/>last_name"]
    CH["CLINICAL_HISTORIES<br/>PK id<br/>FK patient_id UNIQUE<br/>history_number UNIQUE<br/>opening_date<br/>status"]
    SP["SPECIALTIES<br/>PK id<br/>name UNIQUE"]
    HP["HEALTHCARE_PROFESSIONALS<br/>PK id<br/>FK specialty_id<br/>license_number UNIQUE<br/>first_name<br/>last_name"]
    MV["MEDICAL_VISITS<br/>PK id<br/>FK clinical_history_id<br/>FK professional_id<br/>visit_date<br/>reason<br/>status"]
    DG["DIAGNOSES<br/>PK id<br/>code UNIQUE<br/>name<br/>diagnosis_type"]
    VD["VISIT_DIAGNOSES<br/>PK/FK visit_id<br/>PK/FK diagnosis_id<br/>is_primary"]

    DT -->|1 a N| PA
    CI -->|1 a N| PA
    PA -->|1 a 1| CH
    CH -->|1 a N| MV
    SP -->|1 a N| HP
    HP -->|1 a N| MV
    MV -->|1 a N| VD
    DG -->|1 a N| VD
```

### 3.2. Antecedentes, alergias y examenes

```mermaid
flowchart TB
    PA["PATIENTS<br/>PK id"]
    MV["MEDICAL_VISITS<br/>PK id"]

    AT["ANTECEDENT_TYPES<br/>PK id<br/>name UNIQUE"]
    PANT["PATIENT_ANTECEDENTS<br/>PK id<br/>FK patient_id<br/>FK antecedent_type_id<br/>description<br/>registered_at"]
    AL["ALLERGIES<br/>PK id<br/>name UNIQUE"]
    PAL["PATIENT_ALLERGIES<br/>PK/FK patient_id<br/>PK/FK allergy_id<br/>reaction"]

    OE["OPHTHALMOLOGIC_EXAMS<br/>PK id<br/>FK visit_id<br/>visual_acuity_od<br/>visual_acuity_oi"]
    IOP["INTRAOCULAR_PRESSURES<br/>PK id<br/>FK visit_id<br/>eye<br/>pressure<br/>measured_at"]
    PACH["PACHYMETRY_EXAMS<br/>PK id<br/>FK visit_id<br/>eye<br/>corneal_thickness<br/>exam_date"]
    GON["GONIOSCOPY_EXAMS<br/>PK id<br/>FK visit_id<br/>eye<br/>angle_grade<br/>exam_date"]
    OCT["OCT_EXAMS<br/>PK id<br/>FK visit_id<br/>eye<br/>exam_date<br/>rnfl_average"]
    VF["VISUAL_FIELD_EXAMS<br/>PK id<br/>FK visit_id<br/>eye<br/>exam_date<br/>md / psd / vfi"]

    PA -->|1 a N| PANT
    AT -->|1 a N| PANT
    PA -->|1 a N| PAL
    AL -->|1 a N| PAL

    MV -->|1 a N| OE
    MV -->|1 a N| IOP
    MV -->|1 a N| PACH
    MV -->|1 a N| GON
    MV -->|1 a N| OCT
    MV -->|1 a N| VF
```

### 3.3. Glaucoma, tratamientos y soporte

```mermaid
flowchart TB
    PA["PATIENTS<br/>PK id"]
    MV["MEDICAL_VISITS<br/>PK id"]

    GR["GLAUCOMA_RECORDS<br/>PK id<br/>FK patient_id UNIQUE<br/>diagnosis_date<br/>glaucoma_type<br/>clinical_status"]
    GC["GLAUCOMA_CONTROLS<br/>PK id<br/>FK glaucoma_record_id<br/>FK visit_id<br/>control_date<br/>progression"]

    ME["MEDICATIONS<br/>PK id<br/>name UNIQUE<br/>concentration<br/>pharmaceutical_form"]
    TR["TREATMENTS<br/>PK id<br/>FK patient_id<br/>FK visit_id opcional<br/>FK medication_id<br/>start_date<br/>end_date<br/>status"]

    PR["CLINICAL_PROCEDURES<br/>PK id<br/>FK patient_id<br/>FK visit_id opcional<br/>procedure_type<br/>procedure_date"]
    CD["CLINICAL_DOCUMENTS<br/>PK id<br/>FK patient_id<br/>FK visit_id opcional<br/>document_type<br/>file_name"]
    IN["INTERNAL_NOTIFICATIONS<br/>PK id<br/>FK patient_id opcional<br/>FK visit_id opcional<br/>message<br/>severity"]
    AU["AUDIT_LOGS<br/>PK id<br/>table_name<br/>record_id<br/>action<br/>changed_at"]

    PA -->|1 a 0..1| GR
    GR -->|1 a N| GC
    MV -->|1 a N| GC

    PA -->|1 a N| TR
    ME -->|1 a N| TR
    MV -.->|puede originar| TR

    PA -->|1 a N| PR
    MV -.->|puede registrar| PR
    PA -->|1 a N| CD
    MV -.->|puede asociar| CD
    PA -.->|puede recibir| IN
    MV -.->|puede generar| IN

    AU["AUDIT_LOGS<br/>PK id<br/>tabla y registro auditado<br/>sin FK directa"]
```

### 3.4. Esquema logico escrito

Este bloque se conserva como apoyo para revisar rapidamente las claves sin depender del grafico.

```text
DOCUMENT_TYPES(id PK, code UNIQUE, name UNIQUE)
CITIES(id PK, name, department, country)
PATIENTS(id PK, document_type_id FK, city_id FK, document_number UNIQUE con document_type_id, first_name, last_name, birth_date, sex, phone, email UNIQUE)
CLINICAL_HISTORIES(id PK, patient_id FK UNIQUE, history_number UNIQUE, opening_date, status)
SPECIALTIES(id PK, name UNIQUE)
HEALTHCARE_PROFESSIONALS(id PK, specialty_id FK, license_number UNIQUE, first_name, last_name, phone, email, active)
MEDICAL_VISITS(id PK, clinical_history_id FK, professional_id FK, visit_date, reason, assessment, plan, status)
DIAGNOSES(id PK, code UNIQUE, name, diagnosis_type, active)
VISIT_DIAGNOSES(visit_id PK/FK, diagnosis_id PK/FK, is_primary, notes)
ANTECEDENT_TYPES(id PK, name UNIQUE)
PATIENT_ANTECEDENTS(id PK, patient_id FK, antecedent_type_id FK, description, registered_at)
ALLERGIES(id PK, name UNIQUE)
PATIENT_ALLERGIES(patient_id PK/FK, allergy_id PK/FK, reaction)
OPHTHALMOLOGIC_EXAMS(id PK, visit_id FK, visual_acuity_od, visual_acuity_oi, slit_lamp_findings, fundus_findings, observations)
INTRAOCULAR_PRESSURES(id PK, visit_id FK, eye, pressure, measured_at, method)
PACHYMETRY_EXAMS(id PK, visit_id FK, eye, corneal_thickness, exam_date, interpretation)
GONIOSCOPY_EXAMS(id PK, visit_id FK, eye, angle_grade, pigmentation, exam_date, interpretation)
OCT_EXAMS(id PK, visit_id FK, eye, exam_date, rnfl_average, cup_disc_ratio, interpretation, validated)
VISUAL_FIELD_EXAMS(id PK, visit_id FK, eye, exam_date, md, psd, vfi, interpretation)
GLAUCOMA_RECORDS(id PK, patient_id FK UNIQUE, diagnosis_date, glaucoma_type, target_pressure_od, target_pressure_oi, clinical_status)
GLAUCOMA_CONTROLS(id PK, glaucoma_record_id FK, visit_id FK, control_date, optic_nerve_status, progression, next_control_date)
MEDICATIONS(id PK, name UNIQUE, concentration, pharmaceutical_form, active)
TREATMENTS(id PK, patient_id FK, visit_id FK opcional, medication_id FK, start_date, end_date, dosage, frequency, status)
CLINICAL_PROCEDURES(id PK, patient_id FK, visit_id FK opcional, procedure_type, procedure_date, eye, description)
CLINICAL_DOCUMENTS(id PK, patient_id FK, visit_id FK opcional, document_type, file_name, file_path, uploaded_at)
AUDIT_LOGS(id PK, table_name, record_id, action, old_value, new_value, changed_at, changed_by)
INTERNAL_NOTIFICATIONS(id PK, patient_id FK opcional, visit_id FK opcional, message, severity, created_at, read_at)
```

## 4. DER completo con cardinalidades

Para que las cardinalidades puedan leerse sin hacer zoom excesivo, el DER completo se presenta en tres partes. **No son tres modelos diferentes:** son tres vistas del mismo DER.

### 4.1. DER - nucleo clinico

```mermaid
erDiagram
    DOCUMENT_TYPES ||--o{ PATIENTS : clasifica
    CITIES ||--o{ PATIENTS : reside_en
    PATIENTS ||--|| CLINICAL_HISTORIES : tiene
    CLINICAL_HISTORIES ||--o{ MEDICAL_VISITS : registra
    SPECIALTIES ||--o{ HEALTHCARE_PROFESSIONALS : agrupa
    HEALTHCARE_PROFESSIONALS ||--o{ MEDICAL_VISITS : atiende
    MEDICAL_VISITS ||--o{ VISIT_DIAGNOSES : tiene
    DIAGNOSES ||--o{ VISIT_DIAGNOSES : aparece_en
```

### 4.2. DER - antecedentes, alergias y examenes

```mermaid
erDiagram
    PATIENTS ||--o{ PATIENT_ANTECEDENTS : tiene
    ANTECEDENT_TYPES ||--o{ PATIENT_ANTECEDENTS : clasifica
    PATIENTS ||--o{ PATIENT_ALLERGIES : presenta
    ALLERGIES ||--o{ PATIENT_ALLERGIES : corresponde

    MEDICAL_VISITS ||--o{ OPHTHALMOLOGIC_EXAMS : registra
    MEDICAL_VISITS ||--o{ INTRAOCULAR_PRESSURES : registra
    MEDICAL_VISITS ||--o{ PACHYMETRY_EXAMS : registra
    MEDICAL_VISITS ||--o{ GONIOSCOPY_EXAMS : registra
    MEDICAL_VISITS ||--o{ OCT_EXAMS : registra
    MEDICAL_VISITS ||--o{ VISUAL_FIELD_EXAMS : registra
```

### 4.3. DER - glaucoma, tratamientos y soporte

```mermaid
erDiagram
    PATIENTS ||--o| GLAUCOMA_RECORDS : puede_tener
    GLAUCOMA_RECORDS ||--o{ GLAUCOMA_CONTROLS : tiene
    MEDICAL_VISITS ||--o{ GLAUCOMA_CONTROLS : soporta

    PATIENTS ||--o{ TREATMENTS : recibe
    MEDICATIONS ||--o{ TREATMENTS : se_formula
    MEDICAL_VISITS o|--o{ TREATMENTS : puede_originar

    PATIENTS ||--o{ CLINICAL_PROCEDURES : recibe
    MEDICAL_VISITS o|--o{ CLINICAL_PROCEDURES : puede_registrar
    PATIENTS ||--o{ CLINICAL_DOCUMENTS : tiene
    MEDICAL_VISITS o|--o{ CLINICAL_DOCUMENTS : puede_asociar
    PATIENTS o|--o{ INTERNAL_NOTIFICATIONS : puede_recibir
    MEDICAL_VISITS o|--o{ INTERNAL_NOTIFICATIONS : puede_generar
```

> `AUDIT_LOGS` se deja fuera de las lineas del DER porque guarda auditoria generica de varias tablas y no posee una clave foranea directa hacia una sola entidad.

## 5. DER completo con atributos principales

Este DER tambien se divide en partes para que los atributos puedan leerse claramente en Typora. Los campos secundarios siguen disponibles en el modelo logico escrito y en `01_ddl_corregido.sql`.

### 5.1. Atributos - pacientes, historias y consultas

```mermaid
erDiagram
    DOCUMENT_TYPES {
        BIGINT id PK
        VARCHAR code
        VARCHAR name
    }
    CITIES {
        BIGINT id PK
        VARCHAR name
        VARCHAR department
        VARCHAR country
    }
    PATIENTS {
        BIGINT id PK
        BIGINT document_type_id FK
        BIGINT city_id FK
        VARCHAR document_number
        VARCHAR first_name
        VARCHAR last_name
        DATE birth_date
        ENUM sex
    }
    CLINICAL_HISTORIES {
        BIGINT id PK
        BIGINT patient_id FK
        VARCHAR history_number
        DATE opening_date
        ENUM status
    }
    SPECIALTIES {
        BIGINT id PK
        VARCHAR name
    }
    HEALTHCARE_PROFESSIONALS {
        BIGINT id PK
        BIGINT specialty_id FK
        VARCHAR license_number
        VARCHAR first_name
        VARCHAR last_name
    }
    MEDICAL_VISITS {
        BIGINT id PK
        BIGINT clinical_history_id FK
        BIGINT professional_id FK
        DATETIME visit_date
        TEXT reason
        ENUM status
    }
    DIAGNOSES {
        BIGINT id PK
        VARCHAR code
        VARCHAR name
        ENUM diagnosis_type
    }
    VISIT_DIAGNOSES {
        BIGINT visit_id PK,FK
        BIGINT diagnosis_id PK,FK
        BOOLEAN is_primary
    }

    DOCUMENT_TYPES ||--o{ PATIENTS : clasifica
    CITIES ||--o{ PATIENTS : reside_en
    PATIENTS ||--|| CLINICAL_HISTORIES : tiene
    CLINICAL_HISTORIES ||--o{ MEDICAL_VISITS : registra
    SPECIALTIES ||--o{ HEALTHCARE_PROFESSIONALS : agrupa
    HEALTHCARE_PROFESSIONALS ||--o{ MEDICAL_VISITS : atiende
    MEDICAL_VISITS ||--o{ VISIT_DIAGNOSES : tiene
    DIAGNOSES ||--o{ VISIT_DIAGNOSES : aparece_en
```

### 5.2. Atributos - antecedentes y alergias

```mermaid
erDiagram
    PATIENTS {
        BIGINT id PK
        VARCHAR first_name
        VARCHAR last_name
    }
    ANTECEDENT_TYPES {
        BIGINT id PK
        VARCHAR name
    }
    PATIENT_ANTECEDENTS {
        BIGINT id PK
        BIGINT patient_id FK
        BIGINT antecedent_type_id FK
        TEXT description
        DATE registered_at
    }
    ALLERGIES {
        BIGINT id PK
        VARCHAR name
    }
    PATIENT_ALLERGIES {
        BIGINT patient_id PK,FK
        BIGINT allergy_id PK,FK
        TEXT reaction
    }

    PATIENTS ||--o{ PATIENT_ANTECEDENTS : tiene
    ANTECEDENT_TYPES ||--o{ PATIENT_ANTECEDENTS : clasifica
    PATIENTS ||--o{ PATIENT_ALLERGIES : presenta
    ALLERGIES ||--o{ PATIENT_ALLERGIES : corresponde
```

### 5.3. Atributos - examenes oftalmologicos

```mermaid
erDiagram
    MEDICAL_VISITS {
        BIGINT id PK
        DATETIME visit_date
    }
    OPHTHALMOLOGIC_EXAMS {
        BIGINT id PK
        BIGINT visit_id FK
        VARCHAR visual_acuity_od
        VARCHAR visual_acuity_oi
    }
    INTRAOCULAR_PRESSURES {
        BIGINT id PK
        BIGINT visit_id FK
        ENUM eye
        DECIMAL pressure
        DATETIME measured_at
    }
    PACHYMETRY_EXAMS {
        BIGINT id PK
        BIGINT visit_id FK
        ENUM eye
        DECIMAL corneal_thickness
        DATE exam_date
    }
    GONIOSCOPY_EXAMS {
        BIGINT id PK
        BIGINT visit_id FK
        ENUM eye
        VARCHAR angle_grade
        DATE exam_date
    }
    OCT_EXAMS {
        BIGINT id PK
        BIGINT visit_id FK
        ENUM eye
        DATE exam_date
        DECIMAL rnfl_average
        DECIMAL cup_disc_ratio
    }
    VISUAL_FIELD_EXAMS {
        BIGINT id PK
        BIGINT visit_id FK
        ENUM eye
        DATE exam_date
        DECIMAL md
        DECIMAL psd
        DECIMAL vfi
    }

    MEDICAL_VISITS ||--o{ OPHTHALMOLOGIC_EXAMS : registra
    MEDICAL_VISITS ||--o{ INTRAOCULAR_PRESSURES : registra
    MEDICAL_VISITS ||--o{ PACHYMETRY_EXAMS : registra
    MEDICAL_VISITS ||--o{ GONIOSCOPY_EXAMS : registra
    MEDICAL_VISITS ||--o{ OCT_EXAMS : registra
    MEDICAL_VISITS ||--o{ VISUAL_FIELD_EXAMS : registra
```

### 5.4. Atributos - glaucoma y tratamientos

```mermaid
erDiagram
    PATIENTS {
        BIGINT id PK
        VARCHAR first_name
        VARCHAR last_name
    }
    MEDICAL_VISITS {
        BIGINT id PK
        DATETIME visit_date
    }
    GLAUCOMA_RECORDS {
        BIGINT id PK
        BIGINT patient_id FK
        DATE diagnosis_date
        VARCHAR glaucoma_type
        ENUM clinical_status
    }
    GLAUCOMA_CONTROLS {
        BIGINT id PK
        BIGINT glaucoma_record_id FK
        BIGINT visit_id FK
        DATE control_date
        BOOLEAN progression
    }
    MEDICATIONS {
        BIGINT id PK
        VARCHAR name
        VARCHAR concentration
        VARCHAR pharmaceutical_form
    }
    TREATMENTS {
        BIGINT id PK
        BIGINT patient_id FK
        BIGINT visit_id FK
        BIGINT medication_id FK
        DATE start_date
        DATE end_date
        ENUM status
    }

    PATIENTS ||--o| GLAUCOMA_RECORDS : puede_tener
    GLAUCOMA_RECORDS ||--o{ GLAUCOMA_CONTROLS : tiene
    MEDICAL_VISITS ||--o{ GLAUCOMA_CONTROLS : soporta
    PATIENTS ||--o{ TREATMENTS : recibe
    MEDICATIONS ||--o{ TREATMENTS : se_formula
    MEDICAL_VISITS o|--o{ TREATMENTS : puede_originar
```

### 5.5. Atributos - procedimientos, documentos y notificaciones

```mermaid
erDiagram
    PATIENTS {
        BIGINT id PK
        VARCHAR first_name
        VARCHAR last_name
    }
    MEDICAL_VISITS {
        BIGINT id PK
        DATETIME visit_date
    }
    CLINICAL_PROCEDURES {
        BIGINT id PK
        BIGINT patient_id FK
        BIGINT visit_id FK
        VARCHAR procedure_type
        DATE procedure_date
        ENUM eye
    }
    CLINICAL_DOCUMENTS {
        BIGINT id PK
        BIGINT patient_id FK
        BIGINT visit_id FK
        VARCHAR document_type
        VARCHAR file_name
    }
    INTERNAL_NOTIFICATIONS {
        BIGINT id PK
        BIGINT patient_id FK
        BIGINT visit_id FK
        VARCHAR message
        ENUM severity
    }
    AUDIT_LOGS {
        BIGINT id PK
        VARCHAR table_name
        BIGINT record_id
        VARCHAR action
        DATETIME changed_at
    }

    PATIENTS ||--o{ CLINICAL_PROCEDURES : recibe
    MEDICAL_VISITS o|--o{ CLINICAL_PROCEDURES : puede_registrar
    PATIENTS ||--o{ CLINICAL_DOCUMENTS : tiene
    MEDICAL_VISITS o|--o{ CLINICAL_DOCUMENTS : puede_asociar
    PATIENTS o|--o{ INTERNAL_NOTIFICATIONS : puede_recibir
    MEDICAL_VISITS o|--o{ INTERNAL_NOTIFICATIONS : puede_generar
```

> `AUDIT_LOGS` aparece con sus atributos principales, pero sin una relacion grafica directa porque su diseño es de auditoria generica.

## 6. Modelo relacional resumido por relaciones

```text
DOCUMENT_TYPES 1 ----- N PATIENTS
CITIES 1 ------------- N PATIENTS
PATIENTS 1 ----------- 1 CLINICAL_HISTORIES
CLINICAL_HISTORIES 1 - N MEDICAL_VISITS
SPECIALTIES 1 -------- N HEALTHCARE_PROFESSIONALS
HEALTHCARE_PROFESSIONALS 1 - N MEDICAL_VISITS

MEDICAL_VISITS 1 ----- N VISIT_DIAGNOSES
DIAGNOSES 1 ---------- N VISIT_DIAGNOSES
Esto representa MEDICAL_VISITS N ----- N DIAGNOSES.

PATIENTS 1 ----------- N PATIENT_ANTECEDENTS
ANTECEDENT_TYPES 1 --- N PATIENT_ANTECEDENTS
PATIENTS 1 ----------- N PATIENT_ALLERGIES
ALLERGIES 1 ---------- N PATIENT_ALLERGIES

MEDICAL_VISITS 1 ----- N OPHTHALMOLOGIC_EXAMS
MEDICAL_VISITS 1 ----- N INTRAOCULAR_PRESSURES
MEDICAL_VISITS 1 ----- N PACHYMETRY_EXAMS
MEDICAL_VISITS 1 ----- N GONIOSCOPY_EXAMS
MEDICAL_VISITS 1 ----- N OCT_EXAMS
MEDICAL_VISITS 1 ----- N VISUAL_FIELD_EXAMS

PATIENTS 1 ----------- 0..1 GLAUCOMA_RECORDS
GLAUCOMA_RECORDS 1 --- N GLAUCOMA_CONTROLS
MEDICAL_VISITS 1 ----- N GLAUCOMA_CONTROLS

PATIENTS 1 ----------- N TREATMENTS
MEDICATIONS 1 -------- N TREATMENTS
PATIENTS 1 ----------- N CLINICAL_PROCEDURES
PATIENTS 1 ----------- N CLINICAL_DOCUMENTS
```

## 7. Mapa de normalizacion

```mermaid
flowchart TD
    A[Tabla no normalizada con diagnosticos, medicamentos, PIO, OCT y campos visuales repetidos] --> B[1FN: valores atomicos y sin listas]
    B --> C[2FN: separar datos que dependen de partes diferentes de una clave]
    C --> D[3FN: quitar datos que pueden obtenerse desde otra relacion, por ejemplo patient_id repetido en examenes]
    D --> E[BCNF: revisar claves candidatas y restricciones UNIQUE]
    E --> F[4FN: separar alergias, antecedentes, diagnosticos y tratamientos en relaciones independientes]
```

## 8. Idea principal para sustentar

La ruta principal del sistema es:

```text
PACIENTE -> HISTORIA CLINICA -> CONSULTA
```

Desde la consulta se registran los diagnosticos, examenes y mediciones. Por eso los estudios especializados solo necesitan `visit_id`: desde esa consulta se puede conocer la historia clinica y despues el paciente.

La relacion entre consultas y diagnosticos es muchos a muchos y se resuelve con la tabla intermedia `visit_diagnoses`.

Los antecedentes, alergias y tratamientos se mantienen separados porque un paciente puede tener varios valores de cada tipo y no deben almacenarse como listas dentro de `patients`.
