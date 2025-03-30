setwd("~/Dropbox/DataAnalyst/6_CAPSTONE_R/plane_crashes_R/src")
set.seed(111) # Set seed for reproducability

#Load Libraries
library(tidyverse)
library(scales)

# Problem to evaluate - Aviation Safety
# How does total fatalities correlate with passenger volume
# Possible Outcomes: 
# - Positive (More Passengers - More Fatalities)
# - Negative (More Passengers - Less Fatalities ) = Aviation Safety Improved
# - No Correlation

# Filtering Out Rows that have NA data. Before 1970 and after 2021.

fatalities_passengers_filtered <- sum_passengers_fatalities_year |>
  filter(!is.na(Passengers_Traveled))

# Building the Linear Regression Model
# Passenger volume - Independent Variable
# Fatalities - Dependent Variable

lm_fatalities_passengers <- lm(Total_Fatalities ~ Passengers_Traveled, 
                               data = fatalities_passengers_filtered)
summary(lm_fatalities_passengers)

# Plot diagram - Linear Regression Model
ggplot(
  fatalities_passengers_filtered,
  aes(x = Passengers_Traveled, y = Total_Fatalities)
) + 
  geom_point(shape = "bullet", size = 2, color="red") +
  scale_x_continuous(breaks = seq(1970,2021, by = 5)) +
  scale_y_continuous(breaks = seq(0,8000, by = 1000)) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "green") +
  theme_linedraw() + 
  labs(
    title = "Relationship Between Total Fatalities and Passengers Traveled",
    x = "Passengers Traveled Per Year",
    y = "Total Fatalities Per Year"
  )
