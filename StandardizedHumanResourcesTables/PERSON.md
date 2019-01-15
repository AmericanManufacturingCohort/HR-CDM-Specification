The PERSON table contains records that uniquely identify each patient in the source data who is time at-risk to have clinical observations recorded within the source systems. This table is a direct copy of the [OMOP CDM Person data table](https://github.com/OHDSI/CommonDataModel/wiki/PERSON).

Field|Required|Type|Description
:---------------------------|:--------:|:------------:|:-----------------------------------------------
|person_id|Yes|Number, nominal|A unique identifier for each person.|
|gender_concept_id|Yes|Number, nominal|A foreign key that refers to a unique gender concept in the Clinical Data Standardized Vocabulary.|
|year_of_birth|Yes|Number, ordinal|The year of birth of the person, extracted from the date of birth.|
|month_of_birth|No|Number, ordinal|The month of birth of the person, extracted from the date of birth.|
|day_of_birth|No|Number, ordinal|The year of birth of the person, extracted from the date of birth.|
|birth_datetime|No|Datetime|The date (and time) of birth of the person.|
|race_concept_id|Yes|Number, nominal|A foreign key that refers to a unique race concept in the Clinical Data Standardized Vocabulary.|
|ethnicity_concept_id|Yes|Number, nominal|A foreign key that refers to a unique ethnicity concept in the Clinical Data Standardized Vocabulary.|
|location_id|No|Number, nominal|A foreign key to the place of residency for the person in the LOCATION table.|
|provider_id|No|Number, nominal|A foreign key to the primary care provider the person is seeing in the PROVIDER table.|
|care_site_id|No|Number, nominal|A foreign key to the site of primary care in the CARE_SITE table.|
|person_source_value|No|String, nominal|A key derived from the person identifier in the source data.|
|gender_source_value|No|String, nominal|The source code for the gender of the person as it appears in the source data.|
|gender_source_concept_id|No|Number, nominal|A foreign key to the gender concept used in the source data.|
|race_source_value|No|String, nominal|The source code for the race of the person as it appears in the source data.|
|race_source_concept_id|No|Number, nominal|A foreign key to the race concept used in the source data.|
|ethnicity_source_value|No|String, nominal|The foreign key to the ethnicity of the person as it appears in the source data.|
|ethnicity_source_concept_id|No|Number, nominal|A foreign key to the ethnicity concept used in the source data.|