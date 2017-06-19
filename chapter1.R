library(tidyverse)

##First steps

#1. Empty graph
ggplot(data = mpg)

#2. Rows = 234, Cols = 11
nrow(mpg); ncol(mpg)

#3. Front wheel drive, rear wheel drive, or four wheel drive, (f, r, 4)
?mpg

#4. highway mpg has a negative correlation with the number of cylinders.
ggplot(data = mpg, aes(x = cyl, y = hwy)) + 
      geom_point() + 
      geom_smooth(method = "lm")

#5. several car classes have multiple car types, two factor variables
#with no correlation or relationship
ggplot(data = mpg) + geom_point(mapping = aes(x = drv, y = class))

##Aesthetic mappings

#1. The color of the points is not blue because color = "blue" is inside
# the aes() function, telling ggplot to define color by the object listed,
# which is the character string "blue" rather than the color blue.

ggplot(data = mpg) +
      geom_point(
            mapping = aes(x = displ, y = hwy, color = "blue")
      )

#2. Manufacturer, model, year, cyl, trans, drv, fl, and class are categorical
#variables. Displ, cty, and hwy are continuous variables.
?mpg
str(mpg)

#3. Color:
ggplot(data = mpg) + 
      geom_point(mapping = aes(x = cyl, 
                               y = hwy, 
                               color = displ))

# Size:
ggplot(data = mpg) + 
      geom_point(mapping = aes(x = cyl, 
                               y = hwy, 
                               size = displ))

# Shape: (throws error: continuous vars cannot be mapped to shape)
ggplot(data = mpg) + 
      geom_point(mapping = aes(x = cyl, 
                               y = hwy, 
                               shape = displ))

#4. It just uses both aesthetics.
ggplot(data = mpg) + 
      geom_point(mapping = aes(x = cyl, 
                               y = hwy, 
                               color = hwy,
                               size = displ,
                               alpha = displ))

#5. Stroke modifies the width of the shape border, for shapes which
# have borders (1:14, 21:25)
ggplot(data = mpg) + 
      geom_point(mapping = aes(x = cyl, 
                               y = hwy),
                 shape = 21,
                 stroke = 0.5)

#6. The aesthetic will try to map to whatever object you pass to it.
# It is mapped to TRUE vs FALSE in this case, for each point.
ggplot(data = mpg) + 
      geom_point(mapping = aes(x = cyl, 
                               y = hwy, 
                               color = displ < 5))

##Facets
#1. You get loooooots of facets.
ggplot(data = mpg) +
      geom_point(mapping = aes(x = cty, y = hwy)) +
      facet_grid(drv ~ displ)

#2. It means there are no data for those combinations of drive type
# and number of cylinders. The second plot maps with points which 
#grids have data on the first.

ggplot(data = mpg) +
geom_point(mapping = aes(x = displ, y = hwy)) +
      facet_grid(drv ~ cyl)

ggplot(data = mpg) +
      geom_point(mapping = aes(x = drv, y = cyl))

#3. "." here just puts everything in one row or one column.
ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y = hwy)) +
      facet_grid(drv ~ .)

ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y = hwy)) +
      facet_grid(. ~ cyl)

#4. The advantage to using facets is that you separate out the data
# by factors. This leads to more useful visualizations when there are
# lots of data. When there are few data, using color or other aesthetics
# are better, as each facet may have too few observations to be useful.

ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y = hwy)) +
      facet_wrap(~ class, nrow = 2)

#5. In facet_wrap, nrow sets the number of rows, and ncol sets the number of
# columns. You can also change the scales from fixed to free, alter the labels,
# switch the label position, change the direction of the wrap (ver or hor),
# among other things. Facet_grid doesn't have ncol or nrow because those are
# set to whatever the number of unique values each of the facet variables have.

#6. You should put the variable with more unique levels in the columns because
# computer screens (and therefore usually viewing panes) are wider than they are
# tall, so the data will be easier to see that way.

# Geometric Objects
#1. geom_line() (or step or path), geom_boxplot(), geom_histogram(), 
# geom_area()

#2. Points colored by drive train type, with a loess smoothing line, no
# standard error bars. (In truth it is 3 smoothing lines, by drive train type)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
      geom_point() +
      geom_smooth(se = FALSE)

#3. It removes the legend of aesthetics from the plot. You removed it so it
# wouldn't be repeated three times in the same row of plots.

#4. removes the standard error bar.

#5. No, they will look the same. The first has global attributes set, the
#second sets the same attributes, but locally for each geom

#6.

ggplot(data = mpg, aes(x = displ, y = hwy)) +
      geom_point() +
      geom_smooth(color = "blue", se = FALSE)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
      geom_point() +
      geom_smooth(aes(group = drv), color = "blue", se = FALSE)

ggplot(data = mpg, aes(x = displ, y = hwy, color = drv)) +
      geom_point() +
      geom_smooth(se = FALSE)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
      geom_point(aes(color = drv)) +
      geom_smooth(color = "black", se = FALSE)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
      geom_point(aes(color = drv)) +
      geom_smooth(aes(linetype = drv), color = "black", se = FALSE)

ggplot(data = mpg, aes(x = displ, y = hwy)) +
      geom_point(aes(color = drv))

#Statistical Transformations
#1. Default geom is pointrange.

ggplot(data = diamonds) +
      geom_pointrange(mapping = aes(x = cut, y = depth),
                      stat = "summary", fun.ymin = min,
                      fun.ymax = max, fun.y = median)

#2. geom_bar takes the count of observations at each level of x variable.
#Geom_col represents values in the data instead.

#3. Where possible, the stat and geom function pairs share the same
#name.

#4. stat_smooth calculates a predicted value for y given x, along with
# t based standard error and a resulting confidence interval. It is
# controlled by data and the method argument.

#5. Without group aesthetic, each prop == 1. geom_bar separates into
# groups first, then calculates prop within each group.

ggplot(data = diamonds) +
      geom_bar(mapping = aes(x = cut, y = ..prop..))

ggplot(data = diamonds) +
      geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))

#Better
ggplot(data = diamonds) +
      geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

ggplot(data = diamonds) +
      geom_bar(mapping = aes(x = cut, fill = color, 
                             y = ..prop.., group = color))

#Position adjustments

#1. Overplotting. More than one observation at each point. Can
#improve with alpha or jitter.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
      geom_point(color = "blue", alpha = 0.3)

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
      geom_jitter()

#2. width and height control the jitter amount.

#3. geom_count uses point size to deal with overplotting.

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
      geom_count()

#4. Default position is dodge
ggplot(data = mpg, mapping = aes(x = drv, y = hwy, 
                                 fill = factor(year))) +
      geom_boxplot()

#Coordinate systems

#1.
ggplot(data = mpg, mapping = aes(x = 1, fill = class)) +
      geom_bar() +
      coord_polar(theta = "y")
             

#2. labs controls all labels for the plot, including axis, legend, 
# and title

#3. Coord_map tries to project whatever portion of the earth onto a 2d
# plane, which does not preserve straight lines and requires considerable
# computation. Coord_quickmap is a quick approximation that does preserve
# straight lines.

#4. Hwy is always higher than cty for cars in the data set. Coord_fixed
# sets the x axis and y axis to equal values and scales, and abline
# draws an x = y line on the graph.