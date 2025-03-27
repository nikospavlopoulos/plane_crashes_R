set.seed(111)

# Select & scale numerical data Decades and Total_Fatalities
total_fatalities_decade <- crashes |>
  select(Decade, Total_Fatalities) |>
  scale()

# Create empty vector
totwinss=c()
# Loop different values 
for (k in 2:10) {
  kmeans_totfatal <- kmeans(total_fatalities_decade, k, nstart = 25)
  totwinss[k] <-kmeans_totfatal$tot.withinss
}

# Plot the result
plot(1:10, totwinss, xlab = "Number of Clusters", ylab = "Total within sum of squares")
lines(1:10, totwinss)

# Execute kmeans with k = 3
kmeans_totfatal <- kmeans(total_fatalities_decade, 3)
table(kmeans_totfatal$cluster)

# Plot the clusters
OG_total_fatalities_decade <- crashes[, c("Decade", "Total_Fatalities")]

plot(OG_total_fatalities_decade, col = kmeans_totfatal$cluster)
