-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2022-09-09 05:24:49.033

-- tables
-- Table: appointment
CREATE TABLE appointment (
    id int  NOT NULL,
    patient_case_id int  NOT NULL,
    in_department_id int  NOT NULL,
    time_created timestamp  NOT NULL,
    appointment_start_time timestamp  NOT NULL,
    appointment_end_time timestamp  NULL,
    appointment_status_id int  NOT NULL,
    CONSTRAINT appointment_ak_1 UNIQUE (patient_case_id, appointment_start_time) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT appointment_ak_2 UNIQUE (appointment_start_time) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT appointment_pk PRIMARY KEY (id)
);

-- Table: appointment_status
CREATE TABLE appointment_status (
    id int  NOT NULL,
    status_name varchar(64)  NOT NULL,
    CONSTRAINT appointment_status_ak_1 UNIQUE (status_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT appointment_status_pk PRIMARY KEY (id)
);

-- Table: clinic
CREATE TABLE clinic (
    id int  NOT NULL,
    clinic_name varchar(255)  NOT NULL,
    address varchar(255)  NOT NULL,
    details text  NULL,
    CONSTRAINT clinic_ak_1 UNIQUE (clinic_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT clinic_pk PRIMARY KEY (id)
);

-- Table: department
CREATE TABLE department (
    id int  NOT NULL,
    department_name varchar(255)  NOT NULL,
    clinic_id int  NOT NULL,
    CONSTRAINT department_ak_1 UNIQUE (department_name, clinic_id) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT department_pk PRIMARY KEY (id)
);

-- Table: document
CREATE TABLE document (
    id int  NOT NULL,
    document_internal_id varchar(64)  NOT NULL,
    document_name varchar(255)  NOT NULL,
    document_type_id int  NOT NULL,
    time_created timestamp  NOT NULL,
    document_url text  NOT NULL,
    details text  NULL,
    patient_id int  NULL,
    patient_case_id int  NULL,
    appointment_id int  NULL,
    in_department_Id int  NULL,
    CONSTRAINT document_ak_1 UNIQUE (document_internal_id) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT document_pk PRIMARY KEY (id)
);

-- Table: document_type
CREATE TABLE document_type (
    id int  NOT NULL,
    type_name varchar(64)  NOT NULL,
    CONSTRAINT document_type_ak_1 UNIQUE (type_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT document_type_pk PRIMARY KEY (id)
);

-- Table: employee
CREATE TABLE employee (
    id int  NOT NULL,
    first_name varchar(64)  NOT NULL,
    last_name varchar(64)  NOT NULL,
    user_name varchar(64)  NOT NULL,
    password varchar(64)  NOT NULL,
    email varchar(255)  NULL,
    mobile varchar(255)  NULL,
    phone varchar(255)  NULL,
    is_active bool  NOT NULL,
    CONSTRAINT employee_ak_1 UNIQUE (user_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT employee_pk PRIMARY KEY (id)
);

-- Table: has_role
CREATE TABLE has_role (
    id int  NOT NULL,
    employee_id int  NOT NULL,
    role_id int  NOT NULL,
    time_from timestamp  NOT NULL,
    time_to timestamp  NULL,
    is_active bool  NOT NULL,
    CONSTRAINT has_role_ak_1 UNIQUE (employee_id, role_id, time_from) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT has_role_pk PRIMARY KEY (id)
);

-- Table: in_department
CREATE TABLE in_department (
    id int  NOT NULL,
    employee_id int  NOT NULL,
    department_id int  NOT NULL,
    time_from timestamp  NOT NULL,
    time_to timestamp  NULL,
    is_active bool  NOT NULL,
    CONSTRAINT in_department_ak_1 UNIQUE (employee_id, department_id, time_from) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT in_department_pk PRIMARY KEY (id)
);

-- Table: patient
CREATE TABLE patient (
    id int  NOT NULL,
    first_name varchar(64)  NOT NULL,
    last_name varchar(64)  NOT NULL,
    CONSTRAINT patient_pk PRIMARY KEY (id)
);

-- Table: patient_case
CREATE TABLE patient_case (
    id int  NOT NULL,
    patient_id int  NOT NULL,
    start_time timestamp  NOT NULL,
    end_time timestamp  NULL,
    in_progress bool  NOT NULL,
    total_cost decimal(10,2)  NULL,
    amount_paid decimal(10,2)  NULL,
    CONSTRAINT patient_case_pk PRIMARY KEY (id)
);

-- Table: role
CREATE TABLE role (
    id int  NOT NULL,
    role_name varchar(64)  NOT NULL,
    CONSTRAINT role_ak_1 UNIQUE (role_name) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT role_pk PRIMARY KEY (id)
);

-- Table: schedule
CREATE TABLE schedule (
    id int  NOT NULL,
    in_department_id int  NOT NULL,
    date date  NOT NULL,
    time_start timestamp  NOT NULL,
    time_end timestamp  NOT NULL,
    CONSTRAINT schedule_ak_1 UNIQUE (in_department_id, date, time_start) NOT DEFERRABLE  INITIALLY IMMEDIATE,
    CONSTRAINT schedule_pk PRIMARY KEY (id)
);

-- Table: status_history
CREATE TABLE status_history (
    id int  NOT NULL,
    appointment_id int  NOT NULL,
    appointment_status_id int  NOT NULL,
    status_time timestamp  NOT NULL,
    details text  NOT NULL,
    CONSTRAINT status_history_pk PRIMARY KEY (id)
);

-- foreign keys
-- Reference: appointment_appointment_status (table: appointment)
ALTER TABLE appointment ADD CONSTRAINT appointment_appointment_status
    FOREIGN KEY (appointment_status_id)
    REFERENCES appointment_status (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: appointment_in_department (table: appointment)
ALTER TABLE appointment ADD CONSTRAINT appointment_in_department
    FOREIGN KEY (in_department_id)
    REFERENCES in_department (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: appointment_patient_case (table: appointment)
ALTER TABLE appointment ADD CONSTRAINT appointment_patient_case
    FOREIGN KEY (patient_case_id)
    REFERENCES patient_case (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: department_hospital (table: department)
ALTER TABLE department ADD CONSTRAINT department_hospital
    FOREIGN KEY (clinic_id)
    REFERENCES clinic (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: document_appointment (table: document)
ALTER TABLE document ADD CONSTRAINT document_appointment
    FOREIGN KEY (appointment_id)
    REFERENCES appointment (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: document_document_type (table: document)
ALTER TABLE document ADD CONSTRAINT document_document_type
    FOREIGN KEY (document_type_id)
    REFERENCES document_type (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: document_in_department (table: document)
ALTER TABLE document ADD CONSTRAINT document_in_department
    FOREIGN KEY (in_department_Id)
    REFERENCES in_department (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: document_patient (table: document)
ALTER TABLE document ADD CONSTRAINT document_patient
    FOREIGN KEY (patient_id)
    REFERENCES patient (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: document_patient_case (table: document)
ALTER TABLE document ADD CONSTRAINT document_patient_case
    FOREIGN KEY (patient_case_id)
    REFERENCES patient_case (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: has_role_employee (table: has_role)
ALTER TABLE has_role ADD CONSTRAINT has_role_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: has_role_role (table: has_role)
ALTER TABLE has_role ADD CONSTRAINT has_role_role
    FOREIGN KEY (role_id)
    REFERENCES role (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: in_department_department (table: in_department)
ALTER TABLE in_department ADD CONSTRAINT in_department_department
    FOREIGN KEY (department_id)
    REFERENCES department (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: in_department_employee (table: in_department)
ALTER TABLE in_department ADD CONSTRAINT in_department_employee
    FOREIGN KEY (employee_id)
    REFERENCES employee (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: patient_case_patient (table: patient_case)
ALTER TABLE patient_case ADD CONSTRAINT patient_case_patient
    FOREIGN KEY (patient_id)
    REFERENCES patient (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: schedule_in_department (table: schedule)
ALTER TABLE schedule ADD CONSTRAINT schedule_in_department
    FOREIGN KEY (in_department_id)
    REFERENCES in_department (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: status_history_appointment (table: status_history)
ALTER TABLE status_history ADD CONSTRAINT status_history_appointment
    FOREIGN KEY (appointment_id)
    REFERENCES appointment (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: status_history_appointment_status (table: status_history)
ALTER TABLE status_history ADD CONSTRAINT status_history_appointment_status
    FOREIGN KEY (appointment_status_id)
    REFERENCES appointment_status (id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

