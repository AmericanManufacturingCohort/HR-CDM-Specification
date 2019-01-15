The WORK_SITE table contains a list of uniquely identified institutional (physical or organizational) units where an occupation or labor is practiced.

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|work_site_id|Yes|Number, nominal|A unique identifier for each work site.|
|location_id|No|Number, nominal|A foreign key to the geographic location in the LOCATION table, where the detailed address information is stored.|
|work_site_source_value|No|String|The identifier for the work site in the source data, stored as a data reference.|