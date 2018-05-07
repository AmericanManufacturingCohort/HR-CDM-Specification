require(dplyr)
require(lubridate)

# Load the raw data
#
load('/mnt/alcoa/Shared/omop/RawData/rawHR.rdata')
raw_data<-as.data.frame(pvor_combined_clean)
raw_data$id<-seq.int(from=1, to=nrow(raw_data))

# Load the retirement eligibility table (copied from Amal's shared directory)
#
retire_eligibility<-read.csv(file="/mnt/alcoa/Shared/omop/RawData/eligibility.csv")
retire_eligibility<-retire_eligibility %>%
   filter(Elig==1) %>%
   select(eessno, Elig) %>%
   distinct %>%
   arrange(eessno)

# Merge both (ignore the warning message)
#
raw_data<-raw_data %>% left_join(retire_eligibility, by='eessno')
raw_data$action[is.na(raw_data$action)]<-""
raw_data$actioncd[is.na(raw_data$actioncd)]<-""
raw_data$actionde[is.na(raw_data$actionde)]<-""
raw_data$actionrs[is.na(raw_data$actionrs)]<-""
raw_data$reasoncd[is.na(raw_data$reasoncd)]<-""
raw_data$reasonde[is.na(raw_data$reasonde)]<-""
raw_data$empstats[is.na(raw_data$empstats)]<-""
raw_data$Elig<-ifelse(is.na(raw_data$Elig),0,raw_data$Elig)  # Assume NA == 0

# (Checkpoint: raw_data has 1,519,506 rows and 49 variables)

# Clean up: remove unused table
#
rm(oracle08_13, pv9607_share, pvor_combined_clean, retire_eligibility)

###############
# 1: PERSON
###############

# Initialize the table by filling it out with base data
# Checkpoint: 
#    (71,224 rows in 18 variables)
person<-raw_data %>%
  group_by(eessno) %>%
  summarize(birth_datetime=first(birth_dt),
            person_source_value=first(eessno), 
            gender_source_value=first(sex), 
            ethnicity_source_value=first(ethnicity)) %>%
  mutate(gender_concept_id="",
         year_of_birth=year(birth_datetime), 
         month_of_birth=month(birth_datetime), 
         day_of_birth=day(birth_datetime), 
         race_concept_id="", 
         ethnicity_concept_id="", 
         location_id="", 
         provider_id="", 
         care_site_id="", 
         gender_source_concept_id="", 
         race_source_value="", 
         race_source_concept_id="", 
         ethnicity_source_concept_id="") %>%
  arrange(eessno)

# Fill out the gender concept id based on the OMOP Gender Vocabulary (M = 8507, F = 8532, (Other) = 0)
#
person$gender_concept_id<-ifelse(person$gender_source_value=='M',8507,ifelse(person$gender_source_value=="F",8532,0))

# Fill out the ethnicity concept id based on the OMOP Ethnicity Vocabulary (Hispanic = 38003563, Not Hispanic = 38003564)
#
person$ethnicity_concept_id<-ifelse(grepl("ambiguous|unknown",tolower(person$ethnicity_source_value)),0,ifelse(grepl("hispanic|latino",tolower(person$ethnicity_source_value)),38003563,38003564))

# Assign the unique person_id (starts from 10000001)
#
person$person_id<-10000000+seq.int(from=1, to=nrow(person))

# Rearrange the columns
#
person<-person[,
  c("person_id",
    "gender_concept_id",
    "year_of_birth",
    "month_of_birth",
    "day_of_birth",
    "birth_datetime",
    "race_concept_id",
    "ethnicity_concept_id",
    "location_id",
    "provider_id",
    "care_site_id",
    "person_source_value",
    "gender_source_value",
    "gender_source_concept_id",
    "race_source_value",
    "race_source_concept_id",
    "ethnicity_source_value",
    "ethnicity_source_concept_id")]

# Final touch: reorganize the column types
#
person$person_source_value<-as.character(person$person_source_value)
person$gender_source_value<-as.character(person$gender_source_value)
person$ethnicity_source_value<-as.character(person$ethnicity_source_value)


###############
# 2: EMPLOYEE
###############

# Initialize the table by filling it out with base data
#
employee<-raw_data %>% 
  group_by(eessno) %>% 
  summarize(employee_id=first(eessno)) %>%
  select(employee_id) %>%
  arrange(employee_id)

# Checkpoint: (71,224 rows in 1 variables)

# Final touch: reorganize the column type
#
employee$employee_id<-as.character(employee$employee_id)


#######################
# 3: HR_EVENT
#######################

# Initialize the table by filling it out with base data
#
hr_event<-raw_data %>% 
  mutate(employee_id=eessno, 
         year_of_event=year(effdtdt), 
         month_of_event=month(effdtdt), 
         day_of_event=day(effdtdt), 
         event_date=effdtdt, 
         hr_event_concept_id="",
         hr_event_source_value=action, 
         hr_event_source_concept_id=actioncd) %>% 
  arrange(employee_id,year_of_event,month_of_event,day_of_event)

# Checkpoint: (hr_event has 1,519,906 rows in 57 variables)

# Assign the unique hr_event_id (starts from 10000001)
#
hr_event$hr_event_id<-10000000+seq.int(from=1, to=nrow(hr_event))

# Rearrange the columns
#
hr_event<-hr_event[,
  c("hr_event_id",
    "employee_id",
    "year_of_event",
    "month_of_event",
    "day_of_event",
    "event_date",
    "hr_event_concept_id",
    "hr_event_source_value",
    "hr_event_source_concept_id")]

# Checkpoint: (hr_event has 1,519,906 rows in 9 variables)

# Final touch: reorganize the column types
#
hr_event$employee_id<-as.character(hr_event$employee_id)
hr_event$hr_event_source_value<-as.character(hr_event$hr_event_source_value)


############################
# 4: WORK_SITE
############################

# Load the work site raw data from a CSV file
#
work_site<-read.csv('/mnt/alcoa/Shared/omop/CDM/Code/Alcoa_Plants.csv')

# Checkpoint: (work_site has 437 rows in 3 variables)

############################
# 5: LOCATION
############################

# Load the location raw data from a CSV file
#
location<-read.csv('/mnt/alcoa/Shared/omop/CDM/Code/Alcoa_Plant_Locations.csv')

# Checkpoint: (location has 437 rows in 8 variables)


############################
# 6: LOGBOOK
############################

# Load the work site raw data from a CSV file
#
logbook<-read.csv('/mnt/alcoa/Shared/omop/CDM/Code/Alcoa_Plant_History.csv')

# Checkpoint: (logbook has 756 rows in 13 variables)


############################
# 7: TRACK_RECORD
############################

# Recreate HR_EVENT table (mini version) to build a reference table
#
hr_event_ref<-raw_data %>% 
  mutate(employee_id=eessno, 
         year_of_event=year(effdtdt), 
         month_of_event=month(effdtdt), 
         day_of_event=day(effdtdt)) %>% 
  arrange(employee_id,year_of_event,month_of_event,day_of_event) %>%
  select(id,employee_id,year_of_event,month_of_event,day_of_event,action)

# Assign the unique hr_event_id (starts from 10000001). IMPORTANT: Make sure the ID generation
# for hr_event_ref has the same parameter with the original HR_EVENT table
#
hr_event_ref$hr_event_id<-10000000+seq.int(from=1, to=nrow(hr_event_ref))

# Checkpoint: (hr_event_ref has 1,519,906 rows in 7 variables)

# Load the action-to-workstate table, which is the translation from Amal's algorithm
# 
workstate_mapping<-read.csv('/mnt/alcoa/Shared/omop/CDM/Code/Action_to_WorkState_Mapping.csv')

# Assign each (action, actioncd, reasoncd, empstats and Elig) combination to a particular
# work state (ignore the warning messages)
#
track_record<-raw_data %>%
  left_join(workstate_mapping, by=c("action","actioncd","reasoncd","empstats","Elig")) %>%
  left_join(work_site, by=c("locatcd"="work_site_source_value")) %>%
  left_join(hr_event_ref, by=c("id", "eessno"="employee_id")) %>%
  select(hr_event_id, eessno, effdtdt, jobtitle, jobcode, work_state, emptype, work_site_id, bundesc, deptname, annual) %>%
  mutate(employee_id=eessno,
         hr_event_id=hr_event_id,
         year_of_record=year(effdtdt), 
         month_of_record=month(effdtdt), 
         day_of_record=day(effdtdt), 
         record_date=effdtdt,
         work_site_id=work_site_id,
         job_concept_id="", 
         employment_status_concept_id="", 
         employment_type_concept_id="",
         job_source_value=jobtitle, 
         job_source_concept_id=jobcode, 
         employment_status_source_value=work_state,
         employment_status_source_concept_id="",
         employment_type_source_value=emptype,
         employment_type_source_concept_id="",
         business_unit_source_value=bundesc,
         business_unit_source_concept_id="",
	 department_source_value=deptname,
         department_source_concept_id="",
         annual_salary=annual) %>%
  arrange(employee_id,year_of_record,month_of_record,day_of_record)

# Checkpoint: (track_record has 1,519,906 rows in 30 variables)

# Remove unused tables
#
rm(workstate_mapping, hr_event_ref)

# Rearrange the columns
#
track_record<-track_record[
  c("employee_id",
    "hr_event_id",
    "year_of_record",
    "month_of_record",
    "day_of_record",
    "record_date",
    "work_site_id",
    "job_concept_id",
    "employment_status_concept_id",
    "employment_type_concept_id",
    "job_source_value",
    "job_source_concept_id",
    "employment_status_source_value",
    "employment_status_source_concept_id",
    "employment_type_source_value",
    "employment_type_source_concept_id",
    "business_unit_source_value",
    "business_unit_source_concept_id",
    "department_source_value",
    "department_source_concept_id",
    "annual_salary")]

# Checkpoint: (track_record 1,519,906 rows in 21 variables)

# Final touch: reorganize the column types
#
track_record$employee_id<-as.character(track_record$employee_id)
track_record$employment_status_source_value<-as.character(track_record$employment_status_source_value)
track_record$employment_type_source_value<-as.character(track_record$employment_type_source_value)

# -----------------------------------------------------------------------------------
# Adding checkpoints to make the timeline data have a monthly uniform information
# -----------------------------------------------------------------------------------

# STEP 1: Create checkpoints from January 1, 1996 to the last action date for each employee
# STEP 2: (see below)
# STEP 3: If the checkpoints happened to be between January 1, 1996 to the first hiring date,
#         then the work status is "Unhired"
#
track_record <- track_record %>% 
  group_by(employee_id) %>% 
  summarize(start=min(record_date),end=max(record_date)) %>% 
  filter(end > as.Date('1996-01-01')) %>% 
  rowwise() %>% 
  do(data.frame(employee_id=.$employee_id,hired_date=.$start,record_date=seq(as.Date('1996-01-01'),.$end-1,by="month"))) %>% 
  mutate(track_record_id=NA,
         employee_id=employee_id,
         hr_event_id=NA,
         year_of_record=year(record_date),
         month_of_record=month(record_date),
         day_of_record=day(record_date),
         record_date=record_date,
         work_site_id=NA,
         job_concept_id="",
         employment_status_concept_id="",
         employment_type_concept_id="",
         job_source_value="",
         job_source_concept_id="",
         employment_status_source_value=ifelse(record_date<hired_date,"Unhired",""),
         employment_status_source_concept_id="",
         employment_type_source_value="",
         employment_type_source_concept_id="",
         business_unit_source_value="",
         business_unit_source_concept_id="",
         department_source_value="",
         department_source_concept_id="",
         annual_salary=NA) %>% 
  select(-one_of('hired_date')) %>%
  rbind(track_record,.) %>% 
  arrange(employee_id,record_date)

# STEP 2: Fill out the other empty checkpoints by copying the previous non-empty or non-NA 
#         value to each one of them
#
require(zoo)
require(data.table)

is.na(track_record$job_source_value)<-track_record$job_source_value==''
is.na(track_record$job_source_concept_id)<-track_record$job_source_concept_id==''
is.na(track_record$employment_status_source_value)<-track_record$employment_status_source_value==''
is.na(track_record$employment_type_source_value)<-track_record$employment_type_source_value==''
is.na(track_record$business_unit_source_value)<-track_record$business_unit_source_value==''
is.na(track_record$department_source_value)<-track_record$department_source_value==''

setDT(track_record)[,work_site_id := na.locf(work_site_id, na.rm=F), by=employee_id]
setDT(track_record)[,job_source_value := na.locf(job_source_value, na.rm=F), by=employee_id]
setDT(track_record)[,job_source_concept_id := na.locf(job_source_concept_id, na.rm=F), by=employee_id]
setDT(track_record)[,employment_status_source_value := na.locf(employment_status_source_value, na.rm=F), by=employee_id]
setDT(track_record)[,employment_type_source_value := na.locf(employment_type_source_value, na.rm=F), by=employee_id]
setDT(track_record)[,business_unit_source_value := na.locf(business_unit_source_value, na.rm=F), by=employee_id]
setDT(track_record)[,department_source_value := na.locf(department_source_value, na.rm=F), by=employee_id]
setDT(track_record)[,annual_salary := na.locf(annual_salary, na.rm=F), by=employee_id]

# Assign the unique track_record_id (starts from 1)
#
track_record$track_record_id<-seq.int(from=1, to=nrow(track_record))

# Checkpoint: (track_record has 10,167,601 rows in 22 variables)

# ---------------------------------------------------------------------------------------------------
# Revisiting the EMPLOYEE table to fill out the hired_date, termination_date, and retired_date
# ---------------------------------------------------------------------------------------------------

# Fill out the hired_date
#
hired_tbl<-track_record %>% 
  filter(employment_status_source_value=="Work") %>% 
  select(employee_id,record_date) %>% 
  arrange(employee_id,record_date) %>% 
  group_by(employee_id) %>% 
  summarize(hired_date=first(record_date))

employee<-employee %>% left_join(hired_tbl, by="employee_id") %>% mutate(employee_id=employee_id, hired_date=hired_date)

# Checkpoint: (employee has 71,224 rows in 2 variables)

# Fill out the termination_date
#
termination_tbl<-track_record %>% 
  filter(employment_status_source_value=="Terminate") %>% 
  select(employee_id,record_date) %>% 
  arrange(employee_id,record_date) %>% 
  group_by(employee_id) %>% 
  summarize(termination_date=last(record_date))

employee<-employee %>% left_join(termination_tbl, by="employee_id") %>% mutate(employee_id=employee_id, termination_date=termination_date)

# Checkpoint: (employee has 71,224 rows in 3 variables)

# Fill out the retire_date
#
retired_tbl<-track_record %>% 
  filter(employment_status_source_value=="Retire") %>% 
  select(employee_id,record_date) %>% 
  arrange(employee_id,record_date) %>% 
  group_by(employee_id) %>% 
  summarize(retired_date=last(record_date))

employee<-employee %>% left_join(retired_tbl, by="employee_id") %>% mutate(employee_id=employee_id, retired_date=retired_date)

# Checkpoint: (employee has 71,224 rows in 4 variables)

# Clean helper tables
#
rm(hired_tbl, termination_tbl, retired_tbl)


##############################
# Saving to CSV files
##############################

write.table(person, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/PERSON.csv', na="", row.names=F, col.names=T, append=F, sep=",")
write.table(employee, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/EMPLOYEE.csv', na="", row.names=F, col.names=T, append=F, sep=",")
write.table(hr_event, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/HR_EVENT.csv', na="", row.names=F, col.names=T, append=F, sep=",")
write.table(track_record, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/TRACK_RECORD.csv', na="", row.names=F, col.names=T, append=F, sep=",")
write.table(work_site, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/WORK_SITE.csv', na="", row.names=F, col.names=T, append=F, sep=",")
write.table(location, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/LOCATION.csv', na="", row.names=F, col.names=T, append=F, sep=",")
write.table(logbook, '/mnt/alcoa/Shared/omop/CDM/Release/0.2/LOGBOOK.csv', na="", row.names=F, col.names=T, append=F, sep=",")


###########################################################################
# Loading from CSV files.
# This technique can be useful to convert empty cells to NA values in R
###########################################################################

person<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/PERSON.csv', header=T, na.strings=c(""," ","NA"))
employee<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/EMPLOYEE.csv', header=T, na.strings=c(""," ","NA"))
hr_event<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/HR_EVENT.csv', header=T, na.strings=c(""," ","NA"))
track_record<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/TRACK_RECORD.csv', header=T, na.strings=c(""," ","NA"))
work_site<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/WORK_SITE.csv', header=T, na.strings=c(""," ","NA"))
location<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/LOCATION.csv', header=T, na.strings=c(""," ","NA"))
logbook<-read.csv('/mnt/alcoa/Shared/omop/CDM/Release/0.2/LOGBOOK.csv', header=T, na.strings=c(""," ","NA"))


