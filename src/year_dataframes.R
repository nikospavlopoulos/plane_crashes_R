# Summarize total fatalities per year
sum_fatalities_per_year <- crashes |>
  select(Year, Total_Fatalities) |>
  # filter(Decade != 1900 & Decade != 2020) |> # Omitting the first and last incomplete decades (~2 or 3 years of data)
  group_by(Year) |>
  summarise(Total_Fatalities = sum(Total_Fatalities))

# Summarize total passenger per year
sum_passengers_per_year <- passengers |>
  select(Year, Passengers_Traveled) |>
  # filter(Decade != 2020) |> # Omitting the last as incomplete (only 2 years of data), & An Outlier even COVID-19 that halted the industry
  group_by(Year) |>
  summarise(Passengers_Traveled = sum(Passengers_Traveled))

# Left Join Tables - Grouped by year
sum_passengers_fatalities_year <- sum_fatalities_per_year |>
  left_join(sum_passengers_per_year, by = "Year") |>
  mutate(Fatalities_Per_100_million_Passengers = floor((Total_Fatalities/Passengers_Traveled)*100000000))
