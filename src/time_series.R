# Group fatalities per decade and visualize it in a bar chart

fatalities_decade <- crashes |>
  group_by(Decade) |>
  summarize(Fatalities = sum(Fatalities))

ggplot(fatalities_decade,
       aes(x = Decade, y = Fatalities)) +
  geom_col(aes(fill = Decade))

