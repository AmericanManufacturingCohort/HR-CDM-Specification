The LOCATION table represents a generic way to capture physical location or address information of a work site. This table is a direct copy of the [OMOP CDM Location data table](https://github.com/OHDSI/CommonDataModel/wiki/LOCATION).

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|location_id|Yes|Number, nominal|A unique identifier for each geographic location.|
|address_1|No|String|The address field 1, typically used for the street address, as it appears in the source data.|
|address_2|No|String|The address field 2, typically used for additional detail such as buildings, suites, floors, as it appears in the source data.|
|city|No|String, nominal|The city name as it appears in the source data|
|state|No|String, nominal|The state name as it appears in the source data.|
|zip|No|Number, nominal|The zip or postal code as it appears in the source data.|
|county|No|String, nominal|The county name as it appears in the source data.|
|location_source_value|No|String|The verbatim information that is used to uniquely identify the location as it appears in the source data.|