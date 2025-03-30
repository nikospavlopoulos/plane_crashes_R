set.seed(111) # Set seed for reproducability

# Developing a Linear Regression Model
# Independent variable = Decades, Dependent = Fatalities
plot(crashes$Decade, crashes$Total_Fatalities)
fatalities_decade_model <- lm(crashes$Total_Fatalities ~ crashes$Decade, data = crashes)
summary(fatalities_decade_model)

### Check alternative data frame
sum_fatalities_per_decade_model <- lm(Total_Fatalities ~ Decade, data = sum_fatalities_per_decade)
summary(sum_fatalities_per_decade_model)
anova(sum_fatalities_per_decade_model)

plot(sum_fatalities_per_decade_model)

# Plot diagram with the total fatalities per decade
ggplot(
  sum_fatalities_per_decade,
  aes(x = Decade, y = Total_Fatalities)
) + 
geom_point(shape = "bullet", size = 4, color="red") +
 scale_x_continuous(breaks = seq(1910,2020, by = 10)) +
  # geom_line() +
  geom_smooth(se = TRUE, level = 0.75) + # Default Method = loess ?loess
  geom_smooth(method = "lm", se = TRUE, level = 0.75, color = "green") +
  theme_linedraw() + 
  labs(
    title = "Total Fatalities Per Decade (Linear vs LOESS Locally Weighted Scatterplot)"
  )
# Big deviation between the two lines demonstrates that relationship is not linear. 
# TODO, try to implement an alternative model, (Polynomial)


# Correlation between Year and Fatalities (Pearson default)
cor(crashes$Year, crashes$Fatalities)
plot(crashes$Year, crashes$Fatalities)

# Linear Regression Model (Month~Fatalities)
lm(crashes$Year~crashes$Fatalities, data = crashes)
summary(lm(crashes$Year~crashes$Fatalities, data = crashes))
anova(lm(crashes$Year~crashes$Fatalities, data = crashes))

# Correlation between Month and Fatalities (Pearson default)
cor(crashes$Month, crashes$Fatalities)
plot(crashes$Month, crashes$Fatalities)

# Linear Regression Model (Month~Fatalities)
lm(crashes$Month~crashes$Fatalities, data = crashes)
summary(lm(crashes$Month~crashes$Fatalities, data = crashes))
anova(lm(crashes$Month~crashes$Fatalities, data = crashes))

# Linear Regression Model (Fatalities ~ Year + Month)
lm(crashes$Fatalities ~ crashes$Year+crashes$Month, data = crashes)
summary(lm(crashes$Fatalities ~ crashes$Year+crashes$Month, data = crashes))
anova(lm(crashes$Fatalities ~ crashes$Year+crashes$Month, data = crashes))

# Correlation between Fatalities and Decade
cor(crashes$Fatalities, crashes$Decade)
plot(crashes$Fatalities, crashes$Decade)
