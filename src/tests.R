# Check datatypes in dataframe
str(crashes)

# Check if Fatalities == Fatalities.Crew + Fatalities.Passengers
Fatalities_Check = crashes$Fatalities == crashes$Fatalities.Passangers + crashes$Fatalities.Crew
crashes$Fatalities = ifelse(Fatalities_Check, crashes$Fatalities, crashes$Fatalities.Passangers + crashes$Fatalities.Crew)

sum(crashes$Fatalities_Check)

incorrect_fatalities <- crashes |>
  filter((!Fatalities_Check))

correct_fatalities <- crashes |>
  filter((Fatalities_Check))

View(incorrect_fatalities)
View(correct_fatalities)

