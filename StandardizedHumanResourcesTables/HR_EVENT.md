The HR_EVENT table contains records of events produced or issued by the human resources department on an employee that cause a change in their employment status (e.g., work status, job title, salary amount, etc.)

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|hr_event_id|Yes|Number, nominal|A unique identifier for each HR event.|
|employee_id|Yes|Number, nominal|A foreign key to the base information about the employee in the EMPLOYEE table|
|year_of_event|Yes|Number, ordinal|The year of HR event that the employee received from the company, extracted from the event date.|
|month_of_event|Yes|Number, ordinal|The month of HR event that the employee received from the company, extracted from the event date.|
|day_of_event|Yes|Number, ordinal|The day of HR event that the employee received from the company, extracted from the event date|
|event_date|Yes|Date|The date of HR event that the employee received from the company.|
|hr_event_concept_id|Yes|Number, nominal|A foreign key that refers to a unique HR event concept in the HR Standardized Vocabulary.|
|hr_event_source_value|No|String|The source code for the HR event as it appears in the source data.|
|hr_event_source_concept_id|No|String, nominal|A foreign key to the HR event concept used in the source data.|
|hr_event_reason|No|String|Any specific reason for the HR event to happen mentioned in the source data, if any|
|hr_event_description|No|String|Detailed description about the HR event mentioned in the source data, if any|