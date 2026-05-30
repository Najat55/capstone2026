
---- TABLES CREATION 

--- 1  patients table
CREATE TABLE Patients (
    patient_nbr INT PRIMARY KEY,
    race VARCHAR(50),
    gender VARCHAR(20),
    age VARCHAR(20)
);

---- 2 encounter table
CREATE TABLE Encounters (
    encounter_id INT PRIMARY KEY,
    patient_nbr INT,
    admission_type VARCHAR(100),
    discharge_disposition VARCHAR(100),
    admission_source VARCHAR(100),
    time_in_hospital INT,
    payer_code VARCHAR(50),
    medical_specialty VARCHAR(100),
    readmitted VARCHAR(20),
    FOREIGN KEY (patient_nbr) REFERENCES Patients(patient_nbr)
);
 
---- 3 Metric table
CREATE TABLE Metrics (
    encounter_id INT PRIMARY KEY,
    num_lab_procedures INT,
    num_procedures INT,
    num_medications INT,
    number_outpatient INT,
    number_emergency INT,
    number_inpatient INT,
    number_diagnoses INT,
    diag_1 VARCHAR(50),
    diag_2 VARCHAR(50),
    diag_3 VARCHAR(50),
    max_glu_serum VARCHAR(50),
    A1Cresult VARCHAR(50),
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id)
);

--- Medication table
CREATE TABLE Medications (
    encounter_id INT PRIMARY KEY,
    metformin VARCHAR(20),
    repaglinide VARCHAR(20),
    nateglinide VARCHAR(20),
    chlorpropamide VARCHAR(20),
    glimepiride VARCHAR(20),
    acetohexamide VARCHAR(20),
    glipizide VARCHAR(20),
    glyburide VARCHAR(20),
    tolbutamide VARCHAR(20),
    pioglitazone VARCHAR(20),
    rosiglitazone VARCHAR(20),
    acarbose VARCHAR(20),
    miglitol VARCHAR(20),
    troglitazone VARCHAR(20),
    tolazamide VARCHAR(20),
    examide VARCHAR(20),
    citoglipton VARCHAR(20),
    insulin VARCHAR(20),
    glyburide_metformin VARCHAR(20),
    glipizide_metformin VARCHAR(20),
    glimepiride_pioglitazone VARCHAR(20),
    metformin_rosiglitazone VARCHAR(20),
    metformin_pioglitazone VARCHAR(20),
    change VARCHAR(20),
    diabetesMed VARCHAR(20),
    FOREIGN KEY (encounter_id) REFERENCES Encounters(encounter_id)
);


----Capstone SQL Tasks: 

--- Calculate the total number of patient encounters in the healthcare dataset


select 
count(encounter_id) as total_encounters
from Encounters e  ;

---Identify the top 10 most frequent diagnoses in the dataset
--- (diag_1) is the primary Diagnosis and it is the main reason the patient was admitted

SELECT 
diag_1 AS diagnosis_code, 
COUNT(encounter_id) AS total_occurrences
FROM Metrics
GROUP BY diag_1
ORDER BY total_occurrences DESC
LIMIT 10;

--- Calculate the average length of hospital stay for each admission type 

select 
admission_type, 
avg (time_in_hospital) as avg_stay 
from Encounters e  
group by admission_type
order by avg_stay DESC 
;

--- Determine the number of readmitted patients and the percentage of total encounters that they represent

SELECT 
readmitted as readmission_type, 
COUNT(*) AS count,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage_of_total
FROM Encounters
GROUP BY readmitted
order by percentage_of_total desc;


--- Identify the age distribution of patients
select 
age as patient_age,
count(age) as total_patients
from Patients p 
group by age
order by total_patients desc ;

--- Identify the most common procedures performed during patient encounters

select 
num_procedures ,
count(num_procedures) as frequency
from Metrics m 
group by num_procedures
order by frequency desc;


SELECT 
    num_procedures, 
    COUNT(*) AS total_encounters
FROM Metrics
GROUP BY num_procedures
ORDER BY total_encounters DESC;


--- Calculate the average number of medications prescribed for patients in each age group

select 
p.age as age_groupe,
m.num_medications as medication,
avg(m.num_medications) as average_medication
from patients p 
inner join Encounters e on p.patient_nbr  = e.patient_nbr 
inner join Metrics m on e.encounter_id = m.encounter_id 
group by 
p.age
order by average_medication desc ;

--- Identify the distribution of readmission rates across different payer codes

SELECT 
payer_code,
readmitted,
COUNT(*) AS total,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY payer_code),2) AS percentage
FROM Encounters
GROUP BY payer_code, readmitted
ORDER BY payer_code, readmitted DESC;






