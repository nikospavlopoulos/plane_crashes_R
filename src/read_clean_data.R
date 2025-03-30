setwd("~/Dropbox/DataAnalyst/6_CAPSTONE_R/plane_crashes_R/src")

#Load Libraries
library(tidyverse)

# Read the dataset csv and save it in a dataframe "crashes"
# Columns [Time, Flight, Registration, cn.ln] are largely incomplete, 
# or they include data that are not useful for my insights 
# These data are going to be ignored from the dataframe.
# Converting columns Date and Fatalities to the appropriate 
# data types Date and Integer
# Extract Date and Month in Separate Columns
# Missing (NA) values in the Fatalities are going to be replaced with 0 (zero)
# Remove rows where all columns 6:12 contain only 0
# Correct rows where Fatalities total do not match the sum of Fatalities.Passangers and Fatalities.Crew
# Create Total_Fatalities Column that includes the Fatalities that took place on the Ground
# Extract an Integer representing Decade from the year

crashes <- read.csv("crashes.csv") |>
  select(!c(Time, Flight.., Registration, cn.ln)) |>
  mutate(Date = as.Date(Date, format = "%m/%d/%Y")) |>
  mutate(
    Year = as.integer(format(Date, "%Y")),
    Month = as.integer(format(Date, "%m"))
  ) |>
  relocate(Year, Month, .after = Date) |>
  mutate(suppressWarnings(across(8:14, as.integer))) |>
  mutate(across(8:14, ~ replace(., is.na(.), 0))) |>
  filter(!if_all(8:14, ~ . == 0)) |>
  mutate(
    Fatalities = if_else(Fatalities == (Fatalities.Passangers + Fatalities.Crew), Fatalities, Fatalities.Passangers + Fatalities.Crew)
  ) |>
  mutate(
    Total_Fatalities = Fatalities + Ground
  ) |>
  relocate(Total_Fatalities, .after = Ground) |>
  mutate(
    Decade = floor(Year/10) * 10
  ) |>
  relocate(Decade, .after = Year)


# Read Passengeris Carried total, set column names, filter only data about World
# Pivot the row/column creating a column with the year
# Convert String - character data to numeric
# Create Column decades
passengers <- read.csv("Passengers_Carried_1970_2021.csv", header = FALSE) |> 
  (\(x) `colnames<-`(x, x[5,]))() |> 
  slice(-c(1:5)) |> 
  rename(Country_Name = `Country Name`) |>
  filter(Country_Name == "World") |>
  select(c(1:4,15:66)) |>
  pivot_longer(
    cols = 5:56,
    names_to = "Year",
    values_to = "Passengers_Traveled"
  ) |>
  mutate(across(Year, as.numeric)) |>
  mutate(Passengers_Traveled = as.numeric(gsub(",", "", Passengers_Traveled))) |>
  mutate(
    Decade = floor(Year/10) * 10
  ) |>
  relocate(Decade, .after = Year)
