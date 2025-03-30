library(tidyverse)
library(scales)

# Group fatalities per year and visualize it in a bar chart

ggplot(sum_fatalities_per_year,
       aes(x = Year, y = Total_Fatalities)) +
  scale_x_continuous(breaks = seq(1900,2020, by = 10)) +
  scale_y_continuous(breaks = seq(0,20000, by = 1000)) +
  geom_col(aes(fill = Year)) + 
  labs ( title = "Fatalities Per Year Bar Chart")

# Group passengers per year and visualize it in a bar chart

ggplot(sum_passengers_per_year,
       aes(x = Year, y = Passengers_Traveled,)) +
  scale_x_continuous(breaks = seq(1900,2020, by = 10)) +
  scale_y_continuous(labels = label_number(scale = 1e-9, suffix = " billion"), breaks = seq(0,40e+10, by = 5e+8)) +
  geom_col(aes(fill = Year)) + 
  labs ( title = "Passengers Per Year Bar Chart")

# Group fatalities per year and visualize it in a scatterplot

ggplot(
  sum_fatalities_per_year,
  aes(x = Year, y = Total_Fatalities)
) + 
  scale_y_continuous(breaks = seq(0,20000, by = 1000)) +
  scale_x_continuous(breaks = seq(1910,2020, by = 10)) +
  geom_jitter(shape = "bullet", size = 2, color="red") +
  theme_linedraw() +
  labs(
    title = "Total Fatalities Per Year Scatterplot (9_11 outlier Event)"
  ) +
  geom_smooth(se = TRUE) # Default Method = loess ?loess
  # geom_smooth(method = "lm", se = TRUE, color = "green")




