library(tidyverse)

## Workflow: Basics

#1. my_variable, not my_var?able

#2.

ggplot(data = mpg) +
      geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

#3. Keyboard shortcuts! Tools > Keyboard Shortcuts Help by menu.