# Group fatalities per decade and visualize it in a bar chart

# fatalities_decade <- crashes |>
#   group_by(Decade) |>
#   summarize(Fatalities = sum(Fatalities))

ggplot(sum_fatalities_per_decade,
       aes(x = Decade, y = Total_Fatalities)) +
  scale_x_continuous(breaks = seq(1900,2020, by = 10)) +
  geom_col(aes(fill = Decade)) + 
  labs ( title = "Fatalities Per Decade Bar Chart")

ggplot(sum_passengers_per_decade,
       aes(x = Decade, y = Passengers_Traveled,)) +
  scale_x_continuous(breaks = seq(1900,2020, by = 10)) +
  geom_col(aes(fill = Decade)) + 
  labs ( title = "Passengers Per Decade Bar Chart")

ggplot(sum_passengers_fatalities_decade,
       aes(x = Decade, y = Fatalities_Per_100.000.000_Passengers)) +
  scale_x_continuous(breaks = seq(1970,2020, by = 10)) +
  geom_col(aes(fill = Decade)) + 
  labs ( title = "Fatalities Per 100.000.000 Passengers - Bar Chart")

# Plot diagram with the total fatalities per crash
ggplot(
  crashes,
  aes(x = Year, y = Total_Fatalities)
) + 
  geom_jitter(shape = "bullet", size = 0.5, color="red") +
  theme_linedraw() +
  labs(
    title = "Total Fatalities Per Year Scatterplot (9_11 outlier Event)"
  )
# Observing an Outlier event of the 9/11 due to the thousands of ground deaths
# TODO repeat analysis and Regression model without the ground deaths of 9/11

