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