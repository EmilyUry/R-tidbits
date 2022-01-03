## TimeTracking.R

### this script was ripped straight from Sam Zipper
### https://github.com/samzipper/SelfAnalysis/blob/master/WorkTimeAnalysis_CollectData.R
### https://www.samzipper.com/post/2022-01-02-work-tracking-update/


# Tutorial on googlesheets package here: https://datascienceplus.com/how-to-use-googlesheets-to-connect-r-to-google-sheets/

library(tidyverse)
library(googlesheets4)

# deauthorize - no need to write or read private sheets
gs4_deauth()

## first: do 2022
sheet_url <- "https://docs.google.com/spreadsheets/d/1M1rWK6CDB0FobOBGA-yjuiIrCSyj1k6VZVwtSFnNhv4/edit?usp=sharing"
sheet_info <- gs4_get(sheet_url)
tabs_all <- 
  sheet_info$sheets %>% 
  subset(name != "template")

for (w in 1:length(tabs_all$name)){
  # figure out when this week starts
  week_start_date <- lubridate::mdy(tabs_all$name[w])
  
  # read google sheet
  data <- read_sheet(sheet_url, sheet = tabs_all$name[w], range = "A3:H40", col_types = "cccccccc")
  daytype <- read_sheet(sheet_url, sheet = tabs_all$name[w], range = "B2:H2", 
                        col_names = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))
  
  # transform to long-form and combine
  daytype_long <- 
    tibble::tibble(Day = colnames(daytype), 
                   Daytype = c(as.character(daytype[1,])))
  data_long <- 
    reshape2::melt(data, id = "Time", value.name = "Activity", variable.name = "Day")
  
  week_summary <- 
    dplyr::left_join(data_long, daytype_long, by = "Day") %>% 
    replace_na(list("Activity" = "Not Work")) %>% 
    dplyr::mutate(week_start_date = week_start_date)
  
  if (w == 1){
    all_weeks <- week_summary
  } else {
    all_weeks <-
      dplyr::bind_rows(week_summary, all_weeks)
  }
  
  # pause to avoid rate limit
  Sys.sleep(8)
  
}

# save 2020 output
setwd("C:/Users/Emily Ury/OneDrive - University of Waterloo/Wetlands_local/Data_files")
write_csv(all_weeks, "WorkTimeAnalysis_Hours_2022.csv")
