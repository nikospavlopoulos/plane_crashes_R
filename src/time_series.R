library(tidyverse)
library(scales)


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

