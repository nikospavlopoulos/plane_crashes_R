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
