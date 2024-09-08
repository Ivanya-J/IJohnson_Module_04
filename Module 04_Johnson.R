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

# 2. The top code will give us the same plot from earlier. One chart using both point data and a smooth line (kinda like a line of best fit). The bottom code will give us two different plots in panels because of the + before the geom_point function

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

## Annotations ####

## Scales ####

## Axis Ticks ####

## Legends and Color Schemes ####

## Replacing a Scale ####

## Themes ####

## Saving/Exporting Plots ####

## Workshop 3 - Data Wrangling ####
