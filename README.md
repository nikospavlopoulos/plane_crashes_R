# Analysis of Airplane Crashes and Air Transport Data
###### GitHub Repository: [https://github.com/nikospavlopoulos/plane\_crashes\_R](https://github.com/nikospavlopoulos/plane_crashes_R)

## 1\. Introduction
Air travel has not only revolutionized the way we connect globally but also transformed the dynamics of transportation safety and risk management. With more than a century of aviation history, air travel, is regarded as the safest mode of transportation.
Although the probability of an accident is extremely low, its consequences can be catastrophic, which is why the fear of aviation accidents remains strong among many passengers.

The goal of this project is to analyze historical aviation accident data and to identify key patterns for better understanding and visualization.

## 2\. Datasets and Licenses

The project leverages two primary datasets:

### 2.1 Airplane Crashes and Fatalities upto 2023

- **Source:** [Kaggle – Airplane Crashes and Fatalities up to 2023](https://www.kaggle.com/datasets/nayansubedi1/airplane-crashes-and-fatalities-upto-2023)
- **License:** [Database Contents License (DbCL) v1.0](https://opendatacommons.org/licenses/dbcl/1-0/)

This dataset provides a historical record of airplane crashes from 1908 to 2023, detailing incident dates, locations, aircraft types, causes, and fatality numbers.  Its comprehensive coverage from the early days of aviation to the modern era makes it an invaluable resource for safety analysis.

### 2.2 Air Transport, Passengers Carried

- **Source:** [World Bank – Air Transport, Passengers Carried](https://data.worldbank.org/indicator/IS.AIR.PSGR)
- **License:** [Creative Commons Attribution 4.0 (CC-BY 4.0)](https://datacatalog.worldbank.org/public-licenses#cc-by)

This dataset records the annual number of passengers transported by air, starting from the year 1970 up to 2021, reflecting the growth and scale of the aviation industry over recent decades. It is critical in understanding the context in which crashes occur—linking operational volume with safety performance.

Through analysis of the above two datasets, an effort is made to answer questions such as:

- **Historical Trends:**  
  How have airplane crashes and passenger volume evolved over the decades? <br/>
  How does the frequency of accidents relate to different time periods?
- **Regression Analysis:**  
How does the volume of air passengers correlate with crash statistics? <br/> 
Can regression models explain the variation in safety records? <br/>
Does increased air travel lead to a proportional increase in incidents, or are safety improvements offsetting higher traffic levels?

## 3\. Methodology \& Analysis

Our analysis is divided into several stages. [R programming language](https://www.r-project.org/) is used and the development environment is [RStudio](https://posit.co/products/open-source/rstudio/). 
Each phase is implemented using R scripts, organized within the repository’s **[`src`](https://github.com/nikospavlopoulos/plane_crashes_R/tree/main/src)** directory. <br/>
The methodology section describes data preparation, exploratory analysis, and statistical approaches.

Libraries used: - [Tidyverse](https://www.tidyverse.org/packages/) - [Scales](https://scales.r-lib.org/)

### 3.1 Data Preparation and Cleaning 

The initial step involves loading the raw data from the two datasets. (Airplane Crashes / Fatalities & Passengers Carried. <br/>
Preparation and Cleaning steps include: Omitting non useful for our analysis columns (ex Time, Flight, Registration, cn.ln), Ensuring Values to be analysed are formatted as numbers, ensuring that 'NA' values are not polluting our data and tidying up columns and grouping by Decade.

Code Snippet: [```read_clean_data.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/read_clean_data.R) 
```
# Import - Prepare - Clean - Airplane Crashes data
crashes <- read.csv("crashes.csv") |>
  select(!c(Time, Flight.., Registration, cn.ln)) |>
  mutate(Date = as.Date(Date, format = "%m/%d/%Y")) |>
  mutate(
    Year = as.integer(format(Date, "%Y")), 
    Month = as.integer(format(Date, "%m"))
  ) |>
  relocate(Year, Month, .after = Date) |>
  mutate(suppressWarnings(across(8:14, as.integer))) |>
  mutate(across(8:14, ~ replace(., is.na(.), 0))) |>
  filter(!if_all(8:14, ~ . == 0)) |>
  mutate(
    Fatalities = if_else(Fatalities == (Fatalities.Passangers + Fatalities.Crew),
 Fatalities, Fatalities.Passangers + Fatalities.Crew)
  ) |>
  mutate(
    Total_Fatalities = Fatalities + Ground
  ) |>
  relocate(Total_Fatalities, .after = Ground) |>
  mutate(
    Decade = floor(Year/10) * 10
  ) |>
  relocate(Decade, .after = Year)

# Import - Prepare - Clean - Passengers Traveled data
passengers <- read.csv("Passengers_Carried_1970_2021.csv", header = FALSE) |> 
  (\(x) `colnames<-`(x, x[5,]))() |> 
  slice(-c(1:5)) |> 
  rename(Country_Name = `Country Name`) |>
  filter(Country_Name == "World") |>
  select(c(1:4,15:66)) |>
  pivot_longer(
    cols = 5:56,
    names_to = "Year",
    values_to = "Passengers_Traveled"
  ) |>
  mutate(across(Year, as.numeric)) |>
  mutate(Passengers_Traveled = as.numeric(gsub(",", "", Passengers_Traveled))) |>
  mutate(
    Decade = floor(Year/10) * 10
  ) |>
  relocate(Decade, .after = Year)
```

 ### 3.2 Creating Grouped By Year & Decade - Dataframes

To facilitate data merging during analysis and visualization, the data have been grouped by year and by decade into separate dataframes. 


Code Snippets: [```year_dataframes.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/year_dataframes.R) & [```decade_dataframes.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/decade_dataframes.R)

```
# Summarize total fatalities per year
sum_fatalities_per_year <- crashes |>
  select(Year, Total_Fatalities) |>
  group_by(Year) |>
  summarise(Total_Fatalities = sum(Total_Fatalities))

# Summarize total passenger per year
sum_passengers_per_year <- passengers |>
  select(Year, Passengers_Traveled) |>
  group_by(Year) |>
  summarise(Passengers_Traveled = sum(Passengers_Traveled))

# Left Join Tables - Grouped by year
sum_passengers_fatalities_year <- sum_fatalities_per_year |>
  left_join(sum_passengers_per_year, by = "Year") |>
  mutate(Fatalities_Per_100_million_Passengers 
         = floor((Total_Fatalities/Passengers_Traveled)*100000000))
```
```
# Summarize total fatalities per decade
sum_fatalities_per_decade <- crashes |>
  select(Decade, Total_Fatalities) |>
# Omitting the first and last incomplete decades (~2 or 3 years of data)
  filter(Decade != 1900 & Decade != 2020) |> 
  group_by(Decade) |>
  summarise(Total_Fatalities = sum(Total_Fatalities))

# Summarize total passenger per decade
sum_passengers_per_decade <- passengers |>
  select(Decade, Passengers_Traveled) |>
# Omitting the last as incomplete (only 2 years of data)
  filter(Decade != 2020) |> 
  group_by(Decade) |>
  summarise(Passengers_Traveled = sum(Passengers_Traveled))

# Left Join Tables - Grouped by decade
sum_passengers_fatalities_decade <- sum_fatalities_per_decade |>
  left_join(sum_passengers_per_decade, by = "Decade") |>
  mutate(Fatalities_Per_100_million_Passengers 
         = floor((Total_Fatalities/Passengers_Traveled)*100000000))
```

 ### 3.3 Historical Trends & Visualizations

 #### 3.3.1 Preliminary Observations

Based on this preliminary analysis, after grouping the data there are several noteworthy observations regarding historical trends. 

- **Pre - World War II Era:** <br/>
These are the early years of aviation. Data indicate several sporadic incidents gradually increasing in fatalities as air travel is being more adopted and humanity is experimenting with more air travel methods.
- **Post - World War II Era:** <br/>
World War II, being the first war that aviation played a significant role, demonstrates an increase in air crash incidents. This is followed by the post World War II era where commercial aviation expanded rapidly. This expansion is also visible in an uptick in recorded incidents especially until the 70s.
- **Modern Era - Digital Age (70s - present):** <br/>
During these years there are also available data recorded and collected in World Banks's dataset about the total passenger volume. During this era the aviation world shifts its focus from cutting edge technology and experimentation, to fuel saving / fuel efficiency priorities, as well as a culture emphasizing the overall aviation safety.
- **Outliers:** <br/>
We observe two events that can be considered outliers in our dataset. <br/>
The first one is a spike in overall deaths on year 2000, caused by the ground casualties of the 9/11 terrorist attacks. <br/>
The second one is the immediate drop of passenger volume during 2020 COVID-19 lockdowns.

*References:*
- [History of Aviation - Wikipedia](https://en.wikipedia.org/wiki/History_of_aviation#History)
- [Aviation in World War II - Wikipedia](https://en.wikipedia.org/wiki/Aviation_in_World_War_II)
- [Post-war aviation - Wikipedia](https://en.wikipedia.org/wiki/Post-war_aviation)
- [Aviation in the Digital Age - Wikipedia](https://en.wikipedia.org/wiki/Aviation_in_the_Digital_Age)


 #### 3.3.2 Visualizations per Year (Fatalities & Passengers Traveled)

Code Snippets: [```year_plots.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/year_plots.R)
<br/>
```
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
  scale_y_continuous(labels = label_number(scale = 1e-9, suffix = " billion"),
					 breaks = seq(0,40e+10, by = 5e+8)) +
  geom_col(aes(fill = Year)) + 
  labs ( title = "Passengers Per Year Bar Chart")
```
<br/>

| ![Fatalities_Per_Year_Bar_Chart](./plots/Fatalities_Per_Year_Bar_Chart.png) |
| ------------- |
| ![Passenger_Per_Year_Bar_Chart](./plots/Passengers_Per_Year_Bar_Chart.png) |
<br/>

 #### 3.3.3 Visualizations per Decade (Fatalities & Passengers Traveled)

Code Snippets: [```decade_plots.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/decade_plots.R)
<br/>
```
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
```
<br/>

| ![Fatalities_Per_Decade_Chart](./plots/Fatalities_Per_Decade_Bar_Chart.png) |
| ------------- |
| ![Passenger_Per_Decade_Bar_Chart](./plots/Passengers_Per_Decade_Bar_Chart.png) |
<br/>

 ### 3.4 Regression Analysis

From our preliminary observations, while visually evaluating the trends, it is becoming apparent that in the modern era (70s - present), the amount of passengers traveled have been increasing every year. 
At the same time the fatalities have been decreasing for the same period.
This provides us an initial hypothesis that there is a negative correlation between these two variables.

In order to statistically evaluate this hypothesis in this section we are building a Regression model. 

The subject we are evaluating is "Aviation Safety".

The Goal is to determine if there is:

- A **Positive Correlation**: More passengers lead to more fatalities.
    
- A **Negative Correlation**: More passengers are associated with fewer fatalities (suggesting improved aviation safety).
    
- **No Correlation**: Passenger volume does not have a clear relationship with fatalities.

 #### 3.4.1 Model Building

We first filter the data to remove rows with missing passenger values (for years before 1970 and after 2021), then build a linear regression model.

For this model we are going to use:
- **As the Dependent Variable:**  
    `Total_Fatalities` – the number of fatalities we want to explain. 
- **As the Independent Variable:**  
    `Passengers_Traveled` – the number of passengers, which we believe might influence fatalities.

Code Snippet: [```lm_fatalities_passengers.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/lm_fatalities_passengers.R)

```
# Filtering Out Rows that have NA data. Before 1970 and after 2021.
fatalities_passengers_filtered <- sum_passengers_fatalities_year |>
  filter(!is.na(Passengers_Traveled))

# Building the Linear Regression Model
lm_fatalities_passengers <- lm(Total_Fatalities ~ Passengers_Traveled, 
                               data = fatalities_passengers_filtered)
summary(lm_fatalities_passengers)
```

 #### 3.4.2 Summary of Regression Output

The summary of our regression model is:
```
Call:
lm(formula = Total_Fatalities ~ Passengers_Traveled, data = fatalities_passengers_filtered)

Residuals:
    Min      1Q  Median      3Q     Max 
-1038.6  -286.2   -89.7    87.7  5520.5 

Coefficients:
                      Estimate Std. Error t value Pr(>|t|)    
(Intercept)          2.137e+03  2.187e+02   9.767 3.53e-13 ***
Passengers_Traveled -4.193e-07  1.126e-07  -3.725 0.000497 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 892.5 on 50 degrees of freedom
Multiple R-squared:  0.2172,	Adjusted R-squared:  0.2016 
F-statistic: 13.87 on 1 and 50 DF,  p-value: 0.0004974
```

**Understanding & Interpreting the Results**

- **Residuals**: Residuals demonstrate the difference between the actual value of our dependent variable `Total_Fatalities` and the predicted variable by our model.<br/><br/>
Residuals close to zero means that our model made a good prediction. In our results we see that the median is -89.7 which means that the model is accurately predicting the fatalities with a very slight overestimation. <br/><br/>
This slight overestimation can be explained by the observation of the Max residual which is 5520.5. This means that our model in this case largely underestimated the fatalities. Demonstrating that in this year there is an outlier. <br/><br/>
Indeed, as we can also confirm visually in the scatterplot below the outlier event is the 9/11 terrorist attacks which caused a large spike in fatalities.

![Scatterplot_Outlier](./plots/Total_Fatalities_Per_Year_Scatterplot_9_11_outlier_Event.png)
<br/>
Chart Code Snippet: [```time_series.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/time_series.R)

- **Coefficients**: We observe that in the column `Estimate - Passengers_Traveled` the result is -4.193e-07 (Decimal Notation: -0.0000004193). Multiplying this with 100 000 000 (100 million) we get -41.93. <br/>
The negative sign demonstrates that there is a negative correlation. In practical terms, there has been a decrease of approximately **~42** deaths for every 100 million additional Passengers Traveled . <br/><br/>
The p-value in the column `Pr(>|t|)` tells us whether the coefficient is statistically significant. If p-value is less than 0.05 it is considered statistically significant. <br/>
In our model with the p-value being `0.000497` we can safely say that the relationship between `Passengers_Traveled` and `Total_Fatalities` is statistically significant. <br/>
This is also demonstrated with the significance code `***` Very significant (p < 0.001)

- **R-squared - Model Performance**: In the final section of our model summary we observe that the R-squared value is `0.2172`. R squared allows us to evaluate the linear model's performance in predicting the variation of the dependent variable. <br/><br/>
In our example the R-squared is relatively low, which can be interpreted that only `21.72%` of variation in `Total_Fatalities` can be explained linearly with the dependent variable `Passengers_Traveled`. <br/><br/>
In practical terms that means that the majority `78.28%` is due to other factors not presently and included and analyzed in our model (for example, factors like safety improvements, regulations etc) Passengers_Traveled alone does not fully explain fatalities.

 #### 3.4.3 Visualizing Regression Output

The chart below demonstrates the relationship between `Total_Fatalities` and `Passengers_Traveled`. The green line demonstrates the results from the linear regression model implemented above. 

Chart Code Snippet: [```lm_fatalities_passengers.R```](https://github.com/nikospavlopoulos/plane_crashes_R/blob/main/src/lm_fatalities_passengers.R)

```
# Plot diagram - Linear Regression Model
ggplot(
  fatalities_passengers_filtered,
  aes(x = Passengers_Traveled, y = Total_Fatalities)
) + 
  geom_point(shape = "bullet", size = 2, color="red") +
  scale_x_continuous(breaks = seq(1970,2021, by = 5)) +
  scale_y_continuous(breaks = seq(0,8000, by = 1000)) +
  geom_smooth(method = "lm", formula = y ~ x, se = FALSE, color = "green") +
  theme_linedraw() + 
  labs(
    title = "Relationship Between Total Fatalities and Passengers Traveled",
    x = "Passengers Traveled Per Year",
    y = "Total Fatalities Per Year"
  )
```

![lm_Relationship_Between_Total_Fatalities_and_Passengers_Traveled](./plots/lm_Relationship_Between_Total_Fatalities_and_Passengers_Traveled.png)
<br/>

## 4\. Conclusion, Insights & Limitations
In this project, the historical trends in airplane crashes & fatalities and air transport data were analyzed. Two distinct datasets were combined, one on airplane crashes spanning over a century, and another one with air passenger volume for the past five decades. 

**Key Conclusions & Insights**
- **Historical Trends:**  The analysis confirmed that while the number of fatalities in the early decades of air travel was high, the overall fatalities have shown a downward trend in the modern era despite the big increase in passengers traveling globally.
- **Visual Evidence:**  The visualizations have provided clear, graphical representation of these trends. Outliers, such as the drop of passenger volume during COVID-19 lockdowns, as well as the spike in fatalities during the year 2000, largely influenced by the 9/11 terrorist attacks, were identifiable and emphasize the importance of analyzing the statistical information within the context of real-world events. 
- **Regression Analysis:** The linear regression analysis between `Total_Fatalities` and `Passengers_Traveled` revealed a statistically significant negative correlation. Specifically, the model suggests that since the 1970s, for every additional 100 million passengers traveling each year, the fatalities decrease by approximately 42. 

**Limitations of the Analysis**
- **Model Predictive Performance:** The R-squared value of the linear regression model was relatively low. (0.2172) indicating that while passenger volume can explain some of the variability of the fatalities (~21.72%) the majority (~78.28%) is attributable to other factors. <br/>
This indicates the model in this analysis is too simple, and may be missing important predictors that can explain the variability in the dependent variable (`Total_Fatalities`) <br/><br/>
In practical terms this means that, even though the p-value shows statistical significance, if we predict `Total_Fatalities` using only `Passengers_Traveled`, we ignore important variables like `Safety Improvements, Aircraft Design, New Regulations` etc.

- **Future Work:**
By identifying the gaps in the current model, suggestions for further research include expanding the model to include additional predictors, or to explore using non-linear modeling techniques.

## 5\. Appendix
The appendix provides aggregated the materials and source code that were used in this analysis. 

### Appendix A: Data Sources and Licenses

- #### Airplane Crashes and Fatalities up to 2023:
	- **Source:** [Kaggle – Airplane Crashes and Fatalities up to 2023](https://www.kaggle.com/datasets/nayansubedi1/airplane-crashes-and-fatalities-upto-2023)
	- **License:** [Database Contents License (DbCL) v1.0](https://opendatacommons.org/licenses/dbcl/1-0/)

- #### Air Transport, Passengers Carried:
	- **Source:** [World Bank – Air Transport, Passengers Carried](https://data.worldbank.org/indicator/IS.AIR.PSGR)
	- **License:** [Creative Commons Attribution 4.0 (CC-BY 4.0)](https://datacatalog.worldbank.org/public-licenses#cc-by)

### Appendix B: Source Code [`Github Folder: 'src'`](https://github.com/nikospavlopoulos/plane_crashes_R/tree/main/src)
Contains all the R scripts used in this analysis as well as the datasets csv files.

### Appendix C: Visualizations [`Github Folder: 'plots'`](https://github.com/nikospavlopoulos/plane_crashes_R/tree/main/plots)
Contains all the visualizations (plots & bar charts) used in this analysis saved in png format.
