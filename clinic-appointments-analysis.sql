-- Executive Overview

-- Total Appointments
select
	count(patient_id) as total_appointments
from clinic_appointments;
    
-- Total Revenue
select
	round(sum(billing_usd),0) as total_revenue
from clinic_appointments;
    
-- Average Bill
select
	concat("$",round(avg(billing_usd),2)) as avg_bill
from clinic_appointments;
    
-- Follow-Up Rate
select
	concat(round((sum(follow_up_required) / sum(count(follow_up_required)) over ()) * 100, 1), '%') as follow_up_rate
from clinic_appointments;

-- Average Waiting Time
select
	round(avg(waiting_days),2) as avg_waiting_days
from clinic_appointments;

-- Monthly Revenue Trend
select 
    monthname(appointment_date) as month_name,
    round(sum(billing_usd),2) as revenue
from clinic_appointments
group by month_name, month(appointment_date)
order by month(appointment_date);

-- Monthly Follow-Up Trend
select 
    monthname(booking_date) as month_name,
    count(follow_up_required) as follow_up_requirement
from clinic_appointments
group by month_name, month(booking_date)
order by month(booking_date);

-- Monthly Appointment Trend
select 
    monthname(booking_date) as month_name,
    count(patient_id) as num_of_appointments
from clinic_appointments
group by month_name, month(booking_date)
order by month(booking_date);

-- Top busiest days
select 
    date(appointment_date),
    count(patient_id) as num_of_appointments
from clinic_appointments
group by date(appointment_date)
order by num_of_appointments desc
limit 10;

-- --------------------------------------------------------------------------------------

-- Department Performance Analysis

-- Appointments by Department
select 
	department, 
    count(department) as number_of_patients
from clinic_appointments
group by department
order by number_of_patients desc;

-- Total Revenue by Department
select 
	department, 
    round(sum(billing_usd),0) as revenue
from clinic_appointments
group by department
order by revenue desc;

-- Follow-Up Requirement Rate by Department
select
	department, 
    concat(round(sum(follow_up_required) / count(follow_up_required) * 100, 2), "%") as follow_up_rate
from clinic_appointments
group by department
order by follow_up_rate desc;

-- Average Waitig Days by Department
select 
	department, 
    round(avg(waiting_days),2) as avg_waiting_days
from clinic_appointments
group by department
order by avg_waiting_days desc;

-- --------------------------------------------------------------------------------------

-- Patient Gender Analysis

-- Patients by Gender
select 
	gender, 
    count(gender) as number_of_patients,
    concat(round((count(gender) / sum(count(gender)) over ()) * 100, 2), '%') as patients_rate
from clinic_appointments
group by gender
order by number_of_patients desc;

-- Gender Distribution Across Departments
with ranked_gender_group as (
    select 
        department, 
        gender,
        count(gender) as patient_count,
        row_number() over (partition by department order by count(gender) desc) as ranking
    from clinic_appointments
    group by department, gender
)
select 
    department,
    gender as dominant_gender,
    patient_count as dominant_gender_count
from ranked_gender_group
where ranking = 1
order by department;

-- Average Appointment Cost by Gender
select 
	gender, 
    round(avg(billing_usd),2) as avg_appointment_cost
from clinic_appointments
group by gender
order by avg_appointment_cost desc;

-- Follow-Up Requirement Rate by Gender
select
	gender,
    concat(round(sum(follow_up_required) / count(follow_up_required) * 100, 2), "%") as follow_up_rate
from clinic_appointments
group by gender
order by follow_up_rate desc;

-- Average Waiting Days by Gender
select 
	gender, 
    round(avg(waiting_days),2) as avg_waiting_days
from clinic_appointments
group by gender
order by avg_waiting_days desc;

-- --------------------------------------------------------------------------------------

-- Patient Age Group Analysis

-- Patients by Age Groups
select 
	age_group, 
    count(age_group) as number_of_patients,
    concat(round((count(age_group) / sum(count(age_group)) over ()) * 100, 2), '%') as rate
from clinic_appointments
group by age_group
order by number_of_patients desc;

-- Age Groups Distribution Across Departments
with ranked_age_group as (
    select 
        department, 
        age_group,
        count(age_group) as patient_count,
        row_number() over (partition by department order by count(age_group) desc) as ranking
    from clinic_appointments
    group by department, age_group
)
select 
    department,
    age_group as dominant_age_group,
    patient_count as dominant_group_count
from ranked_age_group
where ranking = 1
order by department;

-- Average Appointment Cost by Age Groups
select 
	age_group, 
    round(avg(billing_usd),2) as avg_appointment_cost
from clinic_appointments
group by age_group
order by avg_appointment_cost desc;

-- Follow-Up Requirement Rate by Age Groups
select
	age_group,
    concat(round(sum(follow_up_required) / count(follow_up_required) * 100, 2), "%") as follow_up_rate
from clinic_appointments
group by age_group
order by follow_up_rate desc;

-- Average Waiting Days by Age Groups
select 
	age_group, 
    round(avg(waiting_days),2) as avg_waiting_days
from clinic_appointments
group by age_group
order by avg_waiting_days desc;