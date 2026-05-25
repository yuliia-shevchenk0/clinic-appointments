# Clinic Appointments Analytics Project

## Objective
In this project,  I designed and implemented an end-to-end healthcare data pipeline that consists of several stages:
1.	Extracted messy data from Kaggle website.
2.	Cleaned and transformed the data using Python on VS Code.
3.	Developed a dashboard on Power BI.
The goal of this project was to transform raw appointment data into actionable business insights that management teams can use to improve operational efficiency, patient retention, and resource planning.
The sections below will explain additional details on the technologies and files utilized.

## Table of Content
* [Dataset Used](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#dataset-used)
* [Technologies](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#technologies)
* [Data Pipeline](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#data-pipeline)
* [Step 1: Cleaning and Transformation](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#step-1-cleaning-and-transformation)
* [Step 2: Analytics](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#)
* [Step 2: Dashboard](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#step-3-dashboard)
* [Key Business Insights](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#key-business-insights)
* [Business Recommendations](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#business-recommendations)
* [Conclusion](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#conclusion)
* [What I've Learned](https://github.com/yuliia-shevchenk0/clinic-appointments/edit/main/README.md#what-ive-learned)

## Dataset Used
A realistic messy dataset for practicing data cleaning and preprocessing to practice proper cleaning, which includes:
* Inconsistent date formats (multiple styles in the same column)
* Mixed gender representations (e.g., "M", "Male", "1")
* Billing values with different currency symbols
* Duplicate patient IDs
* Missing values in different formats ("N/A", empty, null)
* Noisy categorical fields

More info about dataset can be found in the following links:
* Website: https://www.kaggle.com/datasets/nudratabbas/messy-clinic-appointments-dataset 
* Raw Data (CSV): https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments.csv 

## Technologies
The following technologies are used to build this project:
* Language: Python, SQL
* Extraction and transformation: VS Code, MySQL
* Dashboard: Power BI

## Data Pipeline 
Files in the following stages:
* Step 1: [Cleaning and transformation – Python Code](https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments.ipynb)
* Step 2: [Analytics - SQL script](https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments-analysis.sql)
* Step 3: [Dashboard](https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments-viz.pdf)

## Step 1: Cleaning and Transformation
### Main issues with the dataset and their resolution while cleaning
|	column	|	issue	|	resolution
|	---	|	---	|	---
|	patient_id	|	some patients have the same IDs	|	changed the patient IDs and assigned them corresponding numbers
|	patient_name	|	patients names aren't in alphabetical order	|	arranged names in alphabetical order
|	gender	|	inconsistent naming of genders	|	changed "F", "female", "Female", "0" - to "F", changed " " to "X", changed "M", "male", "Male", "1" - to "M"
|	appointment_date	|	inconsistent date types	|	changed dates to "YYYY-MM-DD" format
|	booking_date	|	inconsistent date types	|	changed dates to "YYYY-MM-DD" format
|	billing_amount	|	inconsistent currencies	|	converted different currencies to $ depending on currency
|	billing_amount	|	missing values	|	filled missing values with the mean of the department
|	follow_up_required	|	inconsistent answers	|	changed "N", "No", "0" - to "0", changed "Y", "Yes", "1" - to "1"
					
### New columns
|	column	|	description	|	
|	---	|	---	|	
|	age_group	|	age groups of patients	|	
|	waiting_days	|	how many days the patient was waiting between booking and the appointment	|	
|	billing_usd	|	different currencies converted to $	|	
					
## Step 2: Analytics
Link to the script https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments-analysis.sql

This project includes:
* Aggregate functions 
 ```sql
-- Average Waitig Days by Department
select 
	department, 
    round(avg(waiting_days),2) as avg_waiting_days
from clinic_appointments
group by department
order by avg_waiting_days desc
```
* Window functions & Common Table Expressions (CTEs) 
```sql
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
```
* Percentage calculations 
```sql
-- Follow-Up Requirement Rate by Age Groups
select
	age_group,
    concat(round(sum(follow_up_required) / count(follow_up_required) * 100, 2), "%") as follow_up_rate
from clinic_appointments
group by age_group
order by follow_up_rate desc;
```
* Trend analysis queries 
```sql
-- Monthly Revenue Trend
select 
    monthname(appointment_date) as month_name,
    round(sum(billing_usd),2) as revenue
from clinic_appointments
group by month_name, month(appointment_date)
order by month(appointment_date);
```

## Step 3: Dashboard
### Links to the dashboard:
* https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments-viz.pdf
* https://github.com/yuliia-shevchenk0/clinic-appointments/blob/main/clinic-appointments-viz.pbix

## Key Business Insights
### Executive Overview
* Total Revenue - $235,113
* Average Bill - $235.11
* Follow-Up Rate - 51.4%
* Average Waiting Time - 274.56 days
* October 2025 and February 2026 had the highest revenue, likely because of seasonal demand for more expensive treatments and check-ups.
* The follow-up rate is good overall (51.4%), but both appointments and follow-ups dropped sharply in March 2026.
* The busiest days reached 7 appointments, especially during late autumn and early January.

### Department Performance
* Neurology is the strongest department, with the highest number of appointments (273) and the highest revenue ($66K). Additionally, this department has managed to keep its average waiting time to 271 days, which is lower than both the General and Orthopedics departments. 
* The General department has one of the longest waiting times (280 days) despite handling fewer patients than Neurology.
Orthopedics is the only department where fewer than half of the patients (49.2%) receive a recommendation to return.

### Patient Gender Analysis
* Billing is consistent across all genders, with very small differences in average appointment cost ($221–$237), which shows pricing and treatment processes are well standardized.
* Since follow-up rates are similar for men and women (~51%), the same automated reminders and outreach systems can be used for both groups.
* Hovewer, the “Unknown” group experience longest waiting times and highest follow-up requirements.

### Patient Age Groups Analysis
* Middle-aged and senior patients have the longest waiting times (around 280 days), require more follow-up care and generate higher appointment costs.
* Many Young Adults already need follow-up care (52.8%) and can become long-term patients.

## Business Recommendations
### Operations & Scheduling
* Increase staffing or extend clinic hours to reduce wait times. 
* Prepare staffing levels before peak periods (September and January) and limit leave during busy months. 
* Introduce automated cancellation/waitlist systems to fill empty appointment slots. 
* Offer discounts on slower days to balance patient demand.
  
### Department Improvements
* Increase capacity in General and Orthopedics departments to reduce delays. 
* Audit workflows in General medicine to identify bottlenecks and improve follow-up scheduling. 
* Review Orthopedics follow-up practices to ensure patients receive necessary recovery check-ups. 
* Support Neurology staff with adequate resources to maintain performance and avoid burnout.
  
### Demographic & Equity Focus
* Make demographic information (age, gender) mandatory during registration for better analysis of clinic demographics and service improvement.
* Monitor wait times by gender and age groups to identify service inequalities early. 
* Introduce priority scheduling for Seniors and Middle-Aged patients with time-sensitive conditions. 
* Add specialist staff or dedicated clinic hours for high-need age groups.
  
### Patient Engagement & Follow-Ups
* Use phone calls or caregiver notifications for Seniors. 
* Use SMS/app reminders for Young Adults to improve follow-up attendance. 
* Create dedicated appointment slots for follow-up patients to reduce long return wait times. 
* Improve follow-up record collection for “Unknown” gender patients to prevent missed care.
  
### Revenue & Retention
* Increase marketing before peak months to attract more patients. 
* Focus on retaining Young Adults as long-term patients through effective follow-up care. 
* Combine multiple check-ups for Seniors into one visit to improve efficiency and reduce repeated appointments.

## Conclusion
This project demonstrates how data analytics can help healthcare organizations:
* Improve operational efficiency 
* Reduce waiting times 
* Increase patient retention 
* Optimize staffing and scheduling 
* Make data-driven business decisions

## What I've Learned
This project improved my understanding of:
* Healthcare analytics 
* KPI storytelling 
* Business-oriented dashboard design 
* Translating SQL analysis into management decisions 
* Identifying operational bottlenecks through data
