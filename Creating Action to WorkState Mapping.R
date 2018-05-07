require(dplyr)
require(lubridate)

load('CDM_EventToWorkState.RData')

# There is a couple of steps to produce the mapping table by observing the
# raw HR event table. The columns are selected based on the Amal's algorithm
# for identifying disability state.
#
# Note that since our 'event_label' already includes the information about
# the 'actioncd', 'reasoncd', 'empstats' and 'Elig', creating the mapping can
# be done immediately by reading the values in the 'event_label' column. We
# added the 'actioncd' column in the dataset below to make the curation easier
# to do. You can use the `amc_vocabulary` dataset to produce the same result.
#
worksheet<-hr_event_raw %>%
   select(id, event_label, actioncd) %>% 
   distinct %>% 
   arrange(actioncd)

write.csv(worksheet, file='/mnt/alcoa/Shared/omop/Action_to_WorkState_Mapping.csv', row.names=F)

# [!] Manual curation by translating Amal's algorithm for identifying disability
# state into a mapping table.

# Reload the manual curation output back to R
#
worksheet<-read.csv('/mnt/alcoa/Shared/omop/Action_to_WorkState_Mapping.csv')

# We need to remove duplicates from the worksheet by focusing only to the 'id',
# 'event_label' and 'work_state' columns.
#
worksheet<-worksheet %>% 
   select(id,event_label,work_state) %>% 
   distinct

# (Checkpoint: worksheet has 357 rows)

write.csv(worksheet, file='/mnt/alcoa/Shared/omop/Action_to_WorkState_Mapping.csv', row.names=F)
