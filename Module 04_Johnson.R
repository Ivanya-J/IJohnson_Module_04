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

##  Exercise 3 ####

## Pivoting Data ####

## Lengthening Data sets ####

## Pivoting Longer ####

## Widening Data sets ####

## Pivoting Wider ####

## Exercise 4 ####

## Separating/Uniting Data Tables ####

## Handling Missing Values ####

## Explicit missing values ####

## Fixed Values ####

## NaN ####

# NaN = Not a Number

## Implicit Missing Values ####

## Import Data into R ####

## CSV Files ####

## Practical Advice ####

## Exercise 5 ####

## Relational Data ####

## Joining Data Sets ####

## Mutating Joins ####

## Pipes for Readable Workflows ####

## Workshop 4 - Spatial Data in R ####