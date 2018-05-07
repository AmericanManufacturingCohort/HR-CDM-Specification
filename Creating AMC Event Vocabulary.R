require(dplyr)
require(lubridate)

# Load the raw data
#
load("rawHR.rdata")
raw_data<-as.data.frame(pvor_combined_clean)
raw_data$action[is.na(raw_data$action)]<-""
raw_data$actioncd[is.na(raw_data$actioncd)]<-""
raw_data$actionde[is.na(raw_data$actionde)]<-""
raw_data$actionrs[is.na(raw_data$actionrs)]<-""
raw_data$reasoncd[is.na(raw_data$reasoncd)]<-""
raw_data$reasonde[is.na(raw_data$reasonde)]<-""
raw_data$empstat[is.na(raw_data$empstat)]<-""

# Load the retirement eligibility table
#
retire_eligibility<-read.csv(file="/mnt/alcoa/Shared/harrati_disability/raw_files/Eligibility.csv")
retire_eligibility<-retire_eligibility %>%
   filter(Elig==1) %>%
   select(eessno, Elig) %>%
   distinct %>%
   arrange(eessno)

# Merge both
#
raw_data_elig<-raw_data %>% left_join(retire_eligibility, by='eessno')
raw_data_elig$Elig<-ifelse(is.na(raw_data_elig$Elig),0,raw_data_elig$Elig)  # Assume NA == 0

# Prepare the raw HR event data. This data represents all combinations used by the raw data
# across 5 columns: 'action', 'actioncd', 'reasoncd', 'emptstat', 'Elig'. The purpose
# of preparing this data is to assign a unique label and ID to each different value combination.
#
hr_event_raw<-unique(raw_data_elig[c('action','actioncd','reasoncd','empstat','Elig')])

# (Checkpoint: hr_event_raw has 840 rows)

# Create the label for each action data:
# 1. If the reasoncd is not empty, then the label would be "Action - ReasonCD"
# 2. If the reasoncd is empty but the actioncd is not, then the label would be "Action - ActionCD"
# 3. If both reasoncd and actioncd is empty then the label would be "Action"
# 4. Otherwise, the label would be just an empty string ""
hr_event_raw$event_label<-
   ifelse(hr_event_raw$action!="",
      ifelse(hr_event_raw$reasoncd!="",
         paste(hr_event_raw$action, hr_event_raw$reasoncd, sep=" - "),
         ifelse(hr_event_raw$actioncd!="",
            paste(hr_event_raw$action, hr_event_raw$actioncd, sep=" - "),
            as.character(hr_event_raw$action)),"")

write.csv(hr_event_raw, file='Event_Data_RAW.csv')

# The next step is a manual curation where we looked into each row and created a string
# for the empty labels. We devised the newly created label by looking at the other columns,
# such as the 'emptstat' and 'Elig'. For example, for 'empstat=3' we created a label named
# "Long Term Disability - Employment Status 3".
# 
# Once all the empty labels were filled, we then assigned a unique ID to each one of them.
# We used LibreOffice Calc as our editing tool. The resulting AMC_Vocabulary_RAW.csv
# is then reloaded to R for further processing.
#
hr_event_raw<-read.csv("Event_Data_RAW.csv")

# The output hr_event is the unique combination of 'id' and 'hr_event' columns
#
hr_event<-unique(raw_event_vocab[c('id','event_label')])
row.names(hr_event)<-NULL

# (Checkpoint: hr_event has 357 rows)

# Save as a AMC Vocabulary HR Event set
#
write.csv(amc_vocabulary, file='/mnt/alcoa/Shared/omop/AMC_Event_Vocabulary.csv', row.names=FALSE)

