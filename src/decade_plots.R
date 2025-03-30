library(tidyverse)
library(scales)

# Group fatalities per decade and visualize it in a bar chart

ggplot(sum_fatalities_per_decade,
       aes(x = Decade, y = Total_Fatalities)) +
  scale_x_continuous(breaks = seq(1900,2020, by = 10)) +
  scale_y_continuous(breaks = seq(0,20000, by = 2000)) +
    geom_col(aes(fill = Decade)) + 
  labs ( title = "Fatalities Per Decade Bar Chart")

# Group passengers per decade and visualize it in a bar chart

ggplot(sum_passengers_per_decade,
       aes(x = Decade, y = Passengers_Traveled,)) +
  scale_x_continuous(breaks = seq(1900,2020, by = 10)) +
  scale_y_continuous(labels = label_number(scale = 1e-9, suffix = " billion"), 
                     breaks = seq(0,40e+10, by = 5e+9)) +
  geom_col(aes(fill = Decade)) + 
  labs ( title = "Passengers Per Decade Bar Chart")
