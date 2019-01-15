The EMPLOYEE table is a specialized table that has a tied association to the PERSON table and it solely contains information about a person’s employment.  The table gets updated or regenerated every time new data are loaded to the CDM to reflect the most recent event happened to the employees. In our specific application to the AMC population, this table is static because we are no longer receiving updates to the data. 

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|employee_id|Yes|Number, nominal|A unique identifier for each employee.|
|hired_date|Yes|Date|The date of hiring an employee.|
|termination_date|Yes|Date|The date of terminating an employee.|
|retired_date|Yes|Date|The date of retiring an employee.|
|retirement_eligibility_flag|No|Number, nominal|Whether the employee is eligible to receive retirement benefits from the company or not|