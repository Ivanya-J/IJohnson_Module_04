## WORKSHOP 1: Reproducible Research & Version Control ####

## Getting Gib Set Up ####

# gitcreds::gitcreds_set()
# install.packages("tidyverse")
library(tidyverse)

## Setting up packages and Debugging ####

# install.packages("devtools")
# devtools::install_github("r-lib/conflicted")

library(conflicted)
library(dplyr)
conflicts_prefer(dplyr::filter)
conflicts_prefer(dplyr::lag)

## Palmer Penguins Data ####
library(palmerpenguins)
library(ggthemes)

## First ggplot ####

library(ggplot2)
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy))
# displ is the engine size and hwy is the fuel efficiency
# geom_point adds a layer of points to the plot
# ggplot pulls the data you set, but you must add layers or the plot will be empty
# Mapping argument always with "aes"

## Graphing Template ####

ggplot(data = mpg) + geom_line(mapping = aes(x = displ, y = hwy))

## Aesthetic Mappings ####

# You can add a third variable to plots, such as class

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, size = class))
# Warning: using size for a discrete variable is not advised

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, shape = class))
# Must specify shapes manually because the shape function can only handle a max of 6 values

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
# using alpha for a discrete variable is not advised

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), color = "purple")

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
# Makes it a logical function (True or False) and changes color to reflect that

## Facet and Panel Plots ####

# Use facet_wrap to create a subset of your data; only use for discrete variables
ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_wrap(~ class, nrow = 2)
# Use facet_grid to do this with more than one variable

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(drv ~ cyl)

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + facet_grid(. ~ cyl)
# Use a . if you don't want to facet in the rows or column dimension

## Exercise 1 ####

?facet_wrap
# nrows is the number of rows, ncol is the number of columns
# shrink is used with scales. If it's true that the scale needs to be fixed, it will shrink the output of statistics.

## Fitting Simple Lines ####

ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy))
# A geom is an object that your plot uses to represent data. You can change the geom function to whatever plot you wish to use

ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y = hwy, color = drv, linetype = drv))
# To set the lines to different colors, you must input the variable you want the colors to be based on

## Complex Plots in ggplot ####

ggplot(data = mpg) + geom_smooth(mapping = aes(x = displ, y =hwy, color = drv, group = drv), show.legend = FALSE)

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy)) + geom_smooth(mapping = aes(x = displ, y = hwy))
# With the above code, the top and second rows are duplicates so if you wanted to change the x variable you'd have to do it in multiple locations

# Instead, you can make global mappings so you'd only have too change it in one location
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(color = class)) + geom_smooth()

# By doing this, you can change certain features of one set without impacting the other

# Specifying different data for each layer using a filter called "subcompact" to select a subset of the data and plot ONLY that subset
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point(mapping = aes(color = class)) + geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

## Exercise 2 ####

# 1. use geom_line for a line chart, geom_boxplot for a box plot, geom_histogram for a histogram, and geom_area for an area plot.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_point() + geom_smooth()

ggplot() + geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) + geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# 2. The top code will give us the same plot from earlier (right above Exercise 2). One chart using both point data and a smooth line (kinda like a line of best fit). The bottom code will give us two different plots in panels because of the + before the geom_point function

# 3.In reality, the above code give the same result because, as we saw earlier, you can duplicate the data or make it global. In the bottom code, we have simply duplicated the data in the top code.

## Transformations and Stats ####

# Now we will use the diamond data set

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + stat_count(mapping = aes(x = cut))

## Overriding Defaults in ggplot2 ####

demo <- tribble(
  ~cut,         ~freq,
  "Fair",       1610,
  "Good",       4906,
  "Very Good",  12082,
  "Premium",    13791,
  "Ideal",      21551
)

ggplot(data = demo) + geom_bar(mapping = aes(x = cut, y = freq), stat = "identity")

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, y = stat(prop), group = 1))

ggplot(data = diamonds) + stat_summary(mapping = aes(x = cut, y = depth), fun.min = min, fun.max = max, fun = median)

## Aesthetic Adjustment ####

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, color = cut)) # Has grey bars with a highlighted color around each bar

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = cut)) # Changes the color for each bar

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity)) # Stacks the bars and has a different color for each clarity

# To alter transparency (alpha)
ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + geom_bar(alpha = 1/5, position = "identity")

# To color the bar outlines with no fill color
ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) + geom_bar(fill = NA, position = "identity")

# position = "fill" works like stacking, but makes each set of stacked bars the same height

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# position = "dodge" places overlapping objects directly beside on another

ggplot(data = diamonds) + geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

# position = "jitter" adds a small amount of random noise to each point so it doesn't overplot when points overlap

ggplot(data = mpg) + geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

## Workshop 2: Using ggplot2 for Communication ####

## Labels ####

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel efficiency generally decreases with engine size")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel efficiency generally decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov"
  )

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )

## Annotations ####

best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_text(aes(label = model), data = best_in_class)

## Scales ####

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous() +
  scale_y_continuous() +
  scale_colour_discrete()

## Axis Ticks ####

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
# Sets the y-axis range (min: 15, max: 40) and goes in increments of 5

ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)

## Legends and Color Schemes ####

base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class))

base + theme(legend.position = "left")
base + theme(legend.position = "top")
base + theme(legend.position = "bottom")
base + theme(legend.position = "right") # the default
base + theme(legend.position = "none")

## Replacing a Scale ####

ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() + 
  scale_x_log10() + 
  scale_y_log10()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_color_brewer(palette = "Set1")

presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, color = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_color_manual(values = c(Republican = "red", Democratic = "blue"))

## Popular Color Package ####

# install.packages("viridis")
# install.packages("hexbin")
library(viridis)
library(hexbin)

df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000)
) # Making a fake data set to plot using this function

ggplot(df, aes(x, y)) +
  geom_hex() + # New geom!
  coord_fixed()

ggplot(df, aes(x, y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()

## Themes ####

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_bw()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_light()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_classic()

ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = class)) +
  geom_smooth(se = FALSE) +
  theme_dark()

# Theme that Ben wrote himself so his plots are the same style. We can do this to format our own as well

theme (panel.border = element_blank(),
       panel.grid.minor.x = element_blank(),
       panel.grid.minor.y = element_blank(),
       legend.position = "bottom",
       legend.title = element_blank(),
       legend.text = element_text(size=8),
       panel.grid.major = element_blank(),
       legend.key = element_blank(),
       legend.background = element_blank(),
       axis.text.y = element_text(colour="black"),
       axis.text.x = element_text(colour="black"),
       text = element_text(family="Arial")) 

## Saving/Exporting Plots ####

ggplot(mpg, aes(displ, hwy)) + geom_point()

ggsave("Mod4-Workshop2-plot.pdf")

# Use width width and height arguments to play with dimensions of your plot

## Workshop 3 - Data Wrangling ####

## Tidy Data ####

library(tidyverse)

# Compute rate per 10,000
table1 %>% 
  mutate(rate = cases / population * 10000)
#> # A tibble: 6 × 5
#>   country      year  cases population  rate
#>   <chr>       <dbl>  <dbl>      <dbl> <dbl>
#> 1 Afghanistan  1999    745   19987071 0.373
#> 2 Afghanistan  2000   2666   20595360 1.29 
#> 3 Brazil       1999  37737  172006362 2.19 
#> 4 Brazil       2000  80488  174504898 4.61 
#> 5 China        1999 212258 1272915272 1.67 
#> 6 China        2000 213766 1280428583 1.67

# Compute cases per year
table1 %>% 
  count(year, wt = cases)
#> # A tibble: 2 × 2
#>    year      n
#>   <dbl>  <dbl>
#> 1  1999 250740
#> 2  2000 296920

# Visualise changes over time
library(ggplot2)
ggplot(table1, aes(year, cases)) + 
  geom_line(aes(group = country), colour = "grey50") + 
  geom_point(aes(colour = country))

##  Exercise 3 ####

# 1. For each of the sample tables, describe what each observation and each column represents.

# Each of the three sample tables show the same data: cases of TB per country per year. In table 1, the columns are country, year, cases, and population. Table 2 columns are country, year, type, and count. Table 3 columns are country, year, and rate. Table 1 is tidy because it ha split the total population from the cases count. Table 2 has a column labeled type because the corresponding count is either for a population or cases. Lastly, table 3's column labeled rate shows the number of cases/population for each country in a given year.

# 2. Sketch out the processes you'd use to calculate the 'rate' for table2 and table3. You will need to perform four operations.
    # a.Extract the number of TB cases per country per year
# For table 2 I would use pivot_wider to split the column type into two separate columns (cases and population).For table 3, use the separate function to separate the rate column into cases and population.
    # b. Extract the matching population per country per year
# Once we have separate columns, I would then need to pivot longer by year to match the cases and population with each country by year.
    # c. Divide cases by population, and multiply by 1,000
# Using the mutate function, set the new column title to rate and the equation would be cases / population * 1000 to get the rate of TB per country per year.
    # d. Store back in the appropriate place
# Call the table and check the data to make sure it has performed the calculation and given the correct values for the new column. We need to use the unite function to tell R to read the values as numeric, not characters. 

## Pivoting Data ####

## Lengthening Data sets ####

# Pivoting data set longer is the most common tidying issue. pivot_longer() makes data sets "longer" by increasing the # of rows and decreasing the number of columns. pivot_longer() splits the data set by column, and re-formats it into the tidy format of observations as rows, columns as variables, and values as cell entries.

billboard

billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank"
  )

billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) # This is used to drop any NA values

## Pivoting Longer ####

df <- tribble(
  ~id, ~bp1, ~bp2,
  "A", 100, 120,
  "B", 140, 115,
  "C", 120, 125
) # Created a data set called 'df' with three variables and their associated values
# New tidy data set with three variables:
# 1. id (already exists)
# 2. measurment (column names)
# 3. value (cell values)

df |>
  pivot_longer(
    cols = bp1:bp2,
    names_to = "measurement",
    values_to = "value"
  )

## Widening Data sets ####

# Widening a data set is the opposite of lengthening and we do so using the pivot_wider() function. pivot_wider() allows us to handle an observation if it's scattered across *multiple rows*.

cms_patient_experience

cms_patient_experience |>
  distinct(measure_cd, measure_title)
# Instead of choosing new column names, we need to provide the existing columns that define the values and the column name.

cms_patient_experience |>
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  ) # Tibble doesn't look right because we need to also tell the pivot_wider() which column or columns have values that uniquely identify each row.

cms_patient_experience |>
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )

## Pivoting Wider ####

df <- tribble(
  ~id, ~measurement, ~value,
  "A", "bp1", 100,
  "B", "bp1", 140,
  "B", "bp2", 115,
  "A", "bp2", 120,
  "A", "bp3", 105
)

df |>
  pivot_wider(
    names_from = measurement,
    values_from = value
  )

df |>
  distinct(measurement) |>
  pull() # pulls the values associated with measurement that aren't going into the new names or values.

df |>
  select(-measurement, -value) |>
  distinct() # Selects the columns to remove and just gives us the 'id' column

df |>
  select(-measurement, -value) |>
  distinct() |>
  mutate(x = NA, y = NA, z = NA) # This fills all of the missing values using the data in the input. 

## Exercise 4 ####

# 1. Why are pivot_longer() and pivot_wider() not perfectly symmetrical? Carefully consider the following example.
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)

stocks %>% 
  pivot_wider(names_from = year, values_from = return) %>% 
  pivot_longer(`2015`:`2016`, names_to = "year", values_to = "return")

# The variables for half and year are numeric while return is an integer. However, R reads the tibble as half and return are integers while year is numeric. Column type information tends to get lost when converted from wide to long. Pivot longer stacks multiple columns into a single column while pivot wider creates column names from values in the column. 

# 2. Why does this code fail?
table4a %>%
  pivot_longer(c(1999, 2000), names_to = "year", values_to = "cases")
# Error: Can't select columns past the end. Locations 1999 and 2000 don't exist. There are only 3 columns. To select the columns 1999 and 200, you need (``) or provide the information as a string. 

# 3. Consider the sample tibble below. Do you need to make it wider or longer? What are the variables?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)

# Use pivot_longer to create variables sex (male, female), pregnant (yes, no), and count.

## Separating/Uniting Data Tables ####

# In this section, the example table (table 3) has a column (rate) that contains two variables (cases and population). To address this issue, we can use the separate() function, which separates one column into multiple columns.

table3

table3 %>%
  separate(rate, into = c("cases", "population"))
# By default, separate() will split values wherever it sees a non-alphanumeric character (i.e. a character that isn't a number or letter). If you wish to use a specific character to separate a column, you can pass the character to the sep argument of separate().

table3 %>%
  separate(rate, into = c("cases", "population"), sep = "/")

# As a default, separate() labeled 'cases' and 'population' as character types. But the values are numeric. We  want to ask separate() to convert them to better types using convert = TRUE.

table3 %>%
  separate(rate, into = c("cases", "population"), convert = TRUE)

table3 %>%
  separate(year, into = c("century", "year"), sep = 2)

# Using unite

table5

table5 %>%
  unite(new, century, year, sep = "")

## Handling Missing Values ####

# An NA (explicit absence) indicates the presence of absent data, and a blank cell just indicates the absence of data (implicit absence).

## Explicit missing values ####

treatment <- tribble(
  ~person, ~treatment, ~response,
  "Derrick Whitmore", 1, 7,
  NA, 2, 10,
  NA, 3, NA,
  "Katherine Burke", 1, 4
)

treatment |>
  fill(everything())
# Using this function, you fill the missing values. This treatment is sometimes called "last observation carried forward" (locf).

## Fixed Values ####

x <- c(1, 4, 5, 7, NA)
coalesce(x, 0)
# Use coalesce() when missing values represent some fixed and known value, most commonly 0 to replace the NA.

x <- c(1, 4, 5, 7, -99)
na_if(x, -99)
# This is for the opposite problem above. Some other concrete value actually represents a missing value. This happens when data is generated from an older software that can't properly represent missing values so it uses something like 99 or -999 in place of the missing value.

## NaN ####

# NaN = Not a Number and behaves the same as NA, but in some cases you may need to distinguish it using is.nan(x)

x <- c(NA, NaN)
x * 10
x == 1
is.na(x)

#NaN is most common when performing a mathematical operation that has an indeterminate result.

## Implicit Missing Values ####

stocks <- tibble(
  year  = c(2020, 2020, 2020, 2020, 2021, 2021, 2021),
  qtr   = c(1, 2, 3, 4, 2, 3, 4),
  price = c(1.88, 0.59, 0.35, NA, 0.92, 0.17, 2.66)
)

# Two missing observations: Price in the 4th quarter of 2020 is explicitly missing, because its value is NA. Price for the 1st quarter of 2021 is implicitly missing, because it does not appear in the data set.

stocks |>
  pivot_wider(
    names_from = qtr,
    values_from = price
  )
# Advanced Note: See link in doc on how to use tidyr::complete() to generate missing values in special cases

## Import Data into R ####

# Exploring how to read plain-text rectangular files into R. These include .csv files. Focusing only on the simplest forms of data files in this section, many of the data import principles are applicable to other data types.

## CSV Files ####

# .csv = Comma-separated values (data values are separated by commas)

# Things to note:

# The first row or "header row" gives the column names

# The following six rows provide the data

?read_csv

students <- read_csv("https://pos.it/r4ds-students-csv")

students

students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))

students

students |>
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

## Practical Advice ####

# Once you read data in, the first step should include assessing whether it is tidy. That means understanding the nature of your variables, and asking the questions:

# Are observations in rows?
# Are variables in columns?
# Are there any odd variables? Things that seems strange, like spelling errors or some other issue that R will have with it?

# By default, read_csv() only recognizes empty strings ("") in the students data set as NAs, we want it to also recognize the character string "N/A"

# In the student data set, tne Student ID and Full Name columns are surrounded by backticks. That’s because they contain spaces, breaking R’s usual rules for variable names; they’re non-syntactic names (think back to our intro to programming workshop!). To refer to these variables, you need to surround them with backticks, `:

## Exercise 5 ####

# 1. Identify what is wrong with each of the following inline CSV files. What happens when you run the code?

read_csv("a,b\n1,2,3\n4,5,6") # Needs a 3rd column header.
read_csv("a,b,c\n1,2\n1,2,3,4") # Missing one value on the 2nd line so it shows as NA.
read_csv("a,b\n\"1") # 2nd value is missing and the 2nd quotation mark is missing.
read_csv("a,b\n1,2\na,b") # There are character and numeric types; you need to specify the columns better.
read_csv("a;b\n1;3") # R reads it as ; delimited because it's separated by semicolons. Need to use read_csv2

## Relational Data ####

# Relational data is a collection of multiple data tables in a given data set or in a project that are related in some ways. They're called relational data because the relations *between* these tables matter, not just the individual tables, and will be a key source of the insights you can deliver.

# Relations are always defined between a pair of tables. All other relations are built up from this idea: the relations of three or more tables are always a property of the relations between each pair.

# Sometimes both elements of a pair can be the same table! This is needed if, for example, you have a table of people, and each person has a reference to their parents.

# To work with relational data you need verbs that work with pairs of tables. In the same way that ggplot2 is a package for implementing the grammar of graphics, dplyr is a package focused on the grammar of data manipulation. It’s a package specialised for doing data analysis. 

# dplyr provides the following verbs to make common data analysis operations easier. The three families of verbs designed to work with relational data are:

# 1. Mutating joins - add new variables to one dataframe from matching observations in another

# 2. Filtering joins - filter observations from one data frame based on whether or not they match an observation in the other table

# 3. Set operations - treat observations as if they are set elements

# install.packages("nycflights13")
library(nycflights13)

airlines # Full carrier name from its abbreviated code

airports # Information about each airport

planes # Information about each olane, id'd by its tailnum

weather # Gives weather at each NYC airport for each hour

# flights connects to planes via a single variable, tailnum.

# flights connects to airlines through the carrier variable.

# flights connects to airports in two ways: via origin and dest variables.

# flights connects to weather via origin (the location), and year, month, day and hour (the time).

## Joining Data Sets ####

# Identify the keys to join the data sets

# Primary key uniquely ids an observation in its own table.
# Foreign key uniquely ids an observation in another table

planes %>%
  count(tailnum) %>%
  filter(n > 1)

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)

flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

flights %>%
  count(year, month, day, tailnum) %>%
  filter(n > 1)

## Mutating Joins ####

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")

flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)

# Select is for getting columns, filter is for getting rows.

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)

x %>%
  inner_join(y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)

left_join(x, y, by = "key")

x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)

y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)

left_join(x, y, by = "key")

flights2 %>%
  left_join(weather)

flights2 %>%
  left_join(planes, by = "tailnum")

flights2 %>%
  left_join(airports, c("dest" = "faa"))

flights2 %>%
  left_join(airports, c("origin" = "faa"))

## Pipes for Readable Workflows ####

# This is just used as an example. None of the code will actually run. The goal is to show how we can write a kids story in R using the piping function, rather than other methods

# install.packages("magrittr")
library(magrittr)

# Little Bunny Foo Foo
# Went Hopping Through The Forest
# Scooping Up The Field Mice
# And Bopping Them On The Head

# Create the story and set it
 # foo_foo <- little_bunny()

# Saving each step as a new object 
 # foo_foo_1 <- hop(foo_foo, through = forest)
 # foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
 # foo_foo_3 <- bop(foo_foo_2, on = head)

# Overwrite the original object instead of creating intermediate objects at each step
 # foo_foo <- hop(foo_foo, through = forest)
 # foo_foo <- scoop(foo_foo, up = field_mice)
 # foo_foo <- bop(foo_foo, on = head)

# String the functions and calls together
 # bop(
  # scoop(
    # hop(foo_foo, through = forest),
    # up = field_mice
#  ), 
 # on = head
# )

# USE A PIPE
# foo_foo %>%
  # hop(through = forest) %>%
  # scoop(up = field_mice) %>%
  # bop(on = head)

## Workshop 4 - Spatial Data in R ####

# Installing/Loading the spatial R packages

# install.packages("sf")
# install.packages("terra")
# install.packages("tmap")

library(tidyverse)
library(sf) # simple features
library(terra) # raster
library(tmap) # Thematic maps are geographical maps in which spatial data distributions are visualized
library(readr)

dat <- read_csv("data-for-course/copepods_raw.csv")
dat

## Data Exploration ####

# Check coordinates

library(ggplot2)

ggplot(dat) +
  aes(x = longitude, y = latitude, color = richness_raw) +
  geom_point()

ggplot(dat, aes(x = latitude, y = richness_raw)) +
  stat_smooth() +
  geom_point()

# Get Going With Maps

sdat <- st_as_sf(dat, coords = c("longitude", "latitude"),
                 crs = 4326)
?st_as_sf
# st_as_sf converts different data types to simple features
# coords gives the names of the columns that relate to the spatial coordinates (in order of X coordinate followed by Y coordinate)
# crs stands for 'coordinate reference system'

# Coordinate Reference Systems

# CRS are required for 2D mapping to compensate for the lumpy, spherical (3D) nature of the earth

crs4326 <- st_crs(4326)
crs4326 # Look at the whole crs
crs4326$Name
crs4326$wkt

# Feature Collection (points)

sdat

# Cartography

plot(sdat["richness_raw"])
plot(sdat)

# Thematic Maps for Communication

# Using tmap

tm_shape(sdat) +
  tm_dots(col = "richness_raw")

# tm_dots to plot dots of the coordinates. Other options are tm_polygons and tm_symbols
# Use tmap_save to save the map to your working directory

tmap_save(filename = "Richness-map.png",
          width = 600, height = 600)
# Above code doesn't work right now. Talia already asked Ben about it and he's going to check it

## Mapping Spatial polygons as Layers ####

# Loading shapefiles
# Shapefiles are not ideal as they're inefficient at storing data and to save 1 shapefile you create multiple files. This means, a bit of the file might be lost if you transfer the data somewhere else.

aus <- st_read("data-for-course/spatial-data/Aussie/Aussie.shp")
shelf <- st_read("data-for-course/spatial-data/aus_shelf/aus_shelf.shp")

aus
shelf

# Mapping Polygons

tm_shape(shelf) +
  tm_polygons()

tm_shape(shelf, bbox = sdat) +
  tm_polygons() +
  tm_shape(aus) +
  tm_polygons() +
  tm_shape(sdat) +
  tm_dots()

# Exploring tmap ####

vignette('tmap-getstarted')

# Follow the instructions in the Help Window

data("World")

tm_shape(World) +
  tm_polygons("HPI")

# Interactive Maps

tmap_mode("view")

tm_shape(World) +
  tm_polygons("HPI")

# Multiple shapes and layers

data(World, metro, rivers, land)

tmap_mode("plot")

tm_shape(land) + 
  tm_raster("elevation", palette = terrain.colors(10)) +
  tm_shape(World) +
  tm_borders("white", lwd = .5) +
  tm_text("iso_a3", size = "AREA") +
  tm_shape(metro) +
  tm_symbols(col = "red", size = "pop2020", scale = .5) +
  tm_legend(show = FALSE)

# Facets

tmap_mode("view")

tm_shape(World) +
  tm_polygons(c("HPI", "economy")) +
  tm_facets(sync = TRUE, ncol = 2)

tmap_mode("plot")

data(NLD_muni)

NLD_muni$perc_men <- NLD_muni$pop_men / NLD_muni$population * 100

tm_shape(NLD_muni) +
  tm_polygons("perc_men", palette = "RdYlBu") +
  tm_facets(by = "province")

tmap_mode("plot")

data(NLD_muni)

tm1 <- tm_shape(NLD_muni) + tm_polygons("population", convert2density = TRUE)

tm2 <- tm_shape(NLD_muni) + tm_bubbles(size = "population")

tmap_arrange(tm1, tm2)

# Basemaps and Overlay Tile Maps

tmap_mode("view")

tm_basemap("Stamen.Watercolor") +
  tm_shape(metro) + tm_bubbles(size = "pop2020", col = "red") +
  tm_tiles("Stamen.TonerLabels")

# Options and Styles

tmap_mode("plot")

tm_shape(World) +
  tm_polygons("HPI") +
  tm_layout(bg.color = "skyblue", inner.margins = c(0, .02, .02, .02))

tmap_options(bg.color = "black", legend.text.color = "white")

tm_shape(World) +
  tm_polygons("HPI", legend.title = "Happy Planet Index")

tmap_style("classic")

tm_shape(World) +
  tm_polygons("HPI", legend.title = "Happy Planet Index")

tmap_options_diff()

tmap_options_reset()

## Exporting Maps ####

?tmap_save

## Appendix A: Tibbles ####

iris
str(iris) # data.frame: 150 obs. of 5 variables

as_tibble(iris) # Tibble shows the first ten rows with what type is assigned to the column and the column name

tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y) # call new variables to produce new column values!

# To build the same as above with data.frame, it requires a few extra steps.

x <- c(1:5)
y <- c(1)
z <- x ^ 2 + y

data.frame(x = 1:5, y = 1, z = x ^ 2 + y) # This works!

data.frame(c(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)) # This does not work

tb <- tibble(
  `:)` = "smile",
  ` ` = "space",
  `2000` = "number"
)

as_tibble(iris)

tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

library(nycflights13)
nycflights13::flights %>%
  print(n = 10, width = Inf)

# You can set some things globally
options(tibble.width = Inf)

df <- tibble(
  x = runif(5),
  y = rnorm(5)
)

# Extract by name
df$x
df[["x"]]

# Do the same with pipes
df %>% .$x # . is a placeholder when using pipes to use these functions.
df %>% .[["x"]]

# Extract by row position
df[[1]]

# Extract by exact position
df[[2,2]]

# You can use the above to pull out a single value to plot on a graph, add a label to a plot, or print a key for your dataset.

# Tibbles won't do partial matching, meaning if the variable you call doesn't match exactly what's in the data frame, tibbles will generate a warning.

df <- tibble(
  xxx = runif(5),
  y = rnorm(5)
)

df$xx
# NULL

# If you run into a problem with tibble, us as.data.frame to turn a tibble back to a R dataframe. This may be necessary because tibbles don't always work with older functions in R.

df <- data.frame(abc = 1, xyz = "a")
df
df$x # call by name
df[,"xyz"] # call by exact position

# Tribble = Transposed tibble. Has one purpose: help you do data entry directly in your script. Column headings are defined by formulas (start with ~) and each data entry is put in a column, separated by commas.

# Add a comment to the line starting with # to clearly identify your header.
tribble(
  ~x, ~y, ~z,
  #--|--|----
  "a", 2, 3.6,
  "b", 1, 8.5
)
