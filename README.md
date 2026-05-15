**Main issues with the dataset and their resolution while cleaning**
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
					
**New columns**
|	column	|	description	|	
|	---	|	---	|	
|	age_group	|	age groups of patients	|	
|	waiting_days	|	how many days the patient was waiting between booking and the appointment	|	
|	billing_usd	|	different currencies converted to $	|	
					
