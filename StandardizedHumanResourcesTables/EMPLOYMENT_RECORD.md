The EMPLOYEMENT_RECORD table stores records of employment history that occurred as a result of observing an HR event. This table has a one-to-one relationship with the HR_EVENT table by  passing a specific date and an employee ID.

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|employment_record_id|Yes|Number. nominal|A unique identifier for each employment record.|
|employee_id|Yes|Number, nominal|A foreign key to the base information about the employee in the EMPLOYEE table|
|hr_event_id|Yes|Number, ordinal|A foreign key to the HR event received by the employee in the HR_EVENT table|
|year_of_record|Yes|Number, ordinal|The year of the employee’s record, extracted from the recording date.|
|month_of_record|Yes|Number, ordinal|The month of the employee’s record, extracted from the recording date.|
|day_of_record|Yes|Number, ordinal|The day of the employee’s record, extracted from the recording date.|
|record_date|Yes|Date|The recording date about the employee|
|work_site_id|No|Number, nominal|A foreign key to the place of work of the employee in the WORK_SITE table.|
|job_concept_id|Yes|Number, nominal|A foreign key that refers to a unique job concept in the HR Standardized Vocabulary.|
|work_state|Yes|String, nominal|The state that an employee went into when a particular HR event occurred (see Section 3.2 for more details)|
|employment_type_concept_id|Yes|Number, nominal|A foreign key that refers to a unique employment type concept in the HR Standardized Vocabulary.|
|job_source_value|No|String|The source code for the job as it appears in the source data.|
|job_source_concept_id|No|Number, nominal|A foreign key to the job concept used in the source data.|
|employment_status_source_ value|No|String|The source code for the employment status as it appears in the source data. Employment status source codes are typically predefined and used as a flag raised by an action.|
|employment_status_source_ concept_id|No|Number, nominal|A foreign key to the employment status concept used in the source data.|
|employment_type_source_value|No|String|The source code for the employment type as it appears in the source data. Employment type source codes are such are 'Full-Time' or 'Part-Time'.|
|employment_type_source_concept_id|No|String, nominal|A foreign key to the employment type concept used in the source data.|
|business_unit_source_value|No|String|The source code for the business unit name as it appears in the source data.|
|business_unit_source_concept_id|No|Number, nominal|A foreign key to the business unit concept used in the source data.|
|department_source_value|No|String|The source code for the department name as it appears in the source data.|
|department_source_concept_id|No|Number, nominal|A foreign key to the department concept used in the source data.|
|annual_salary|No|Number, ratio|The amount of salary that an employee received every year.|