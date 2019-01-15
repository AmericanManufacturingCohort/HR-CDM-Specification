The SITE_HISTORY table stores the properties of work sites over time. This table has a one-to-one relationship with the SITE_EVENT table by passing a specific date and a site ID. 

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|site_history_id|Yes|Number, nominal|A unique identifier for each logbook record.|
|work_site_id|Yes|Number, nominal|A foreign key that refers to the work site in the WORK_SITE table, where the detailed information is stored.|
|site_event_id|Yes|Number, nominal|A foreign key that refers to the turnaround event in the SITE_EVENT table, where the detailed turnaround event information is stored.|
|year_of_record|Yes|Number, ordinal|The year of site’s record, extracted from the recording date.|
|month_of_record|No|Number, ordinal|The month of site’s record, extracted from the recording date.|
|day_of_record|No|Number, ordinal|The day of site’s record, extracted from the recording date.|
|record_date|No|Date|The recording date about the work site.|
|site_owner|No|String|The source code about the owner of the work site.|
|site_type|No|String|The source code about the type of the work site.|
|site_status|No|String|The source code about the status of the site.|