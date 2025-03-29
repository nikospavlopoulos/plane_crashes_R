# Group fatalities per decade and visualize it in a bar chart

fatalities_decade <- crashes |>
  group_by(Decade) |>
  summarize(Fatalities = sum(Fatalities))

ggplot(fatalities_decade,
       aes(x = Decade, y = Fatalities)) +
  geom_col(aes(fill = Decade))


# Plot diagram with the total fatalities per crash
ggplot(
  crashes,
  aes(x = Year, y = Total_Fatalities)
) + 
  geom_jitter(shape = "bullet", size = 0.5, color="red") +
  theme_linedraw() +
  labs(
    title = "Total Fatalities Per Year"
  )
# Observing an Outlier event of the 9/11 due to the thousands of ground deaths
# TODO repeat analysis and Regression model without the ground deaths of 9/11

