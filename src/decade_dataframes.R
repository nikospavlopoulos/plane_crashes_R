library(tidyverse)
library(scales)

# Summarize total fatalities per decade
sum_fatalities_per_decade <- crashes |>
  select(Decade, Total_Fatalities) |>
  filter(Decade != 1900 & Decade != 2020) |> # Omitting the first and last incomplete decades (~2 or 3 years of data)
  group_by(Decade) |>
  summarise(Total_Fatalities = sum(Total_Fatalities))

# Summarize total passenger per decade
sum_passengers_per_decade <- passengers |>
  select(Decade, Passengers_Traveled) |>
  filter(Decade != 2020) |> # Omitting the last as incomplete (only 2 years of data), & An Outlier event COVID-19 that halted the industry
  group_by(Decade) |>
  summarise(Passengers_Traveled = sum(Passengers_Traveled))

# Left Join Tables - Grouped by decade
sum_passengers_fatalities_decade <- sum_fatalities_per_decade |>
  left_join(sum_passengers_per_decade, by = "Decade") |>
  mutate(Fatalities_Per_100_million_Passengers 
         = floor((Total_Fatalities/Passengers_Traveled)*100000000))