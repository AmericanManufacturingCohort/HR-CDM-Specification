The SITE_EVENT table stores the events that happened to work sites over time.

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|site_event_id|Yes|Number, nominal|A unique identifier for each business event.|
|work_site_id|Yes|Number, nominal|A foreign key to the base information about the work site in the WORK_SITE table.|
|year_of_event|Yes|Number, ordinal|The year of the site event, extracted from the event date.|
|month_of_event|No|Number, ordinal|The month of the site event, extracted from the event date.|
|day_of_event|No|Number, ordinal|The day of the site event, extracted from the event date.|
|event_date|No|Date|The date of site event.|
|site_event_concept_id|No|Number, ordinal|The source code about the name of the work site.|
|site_event_source_value|No|String|The source code about the operational business unit.|
|site_event_source_concept_id|No|Number, ordinal|The source code about the status of the site.|