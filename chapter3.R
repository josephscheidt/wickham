library(nycflights13)
library(tidyverse)

#1.(a)

a <- filter(flights, arr_delay >= 120)

#(b)

b <- filter(flights, dest == "IAH" | dest == "HOU")

#(c)

c <- filter(flights, carrier %in% c("UA", "AA", "DL"))

#(d)

d <- filter(flights, month %in% c(7, 8, 9))

#(e)

e <- filter(flights, dep_delay <= 0 & arr_delay > 120)

#(f)

f <- filter(flights, dep_delay >= 60 & arr_delay + 30 <= dep_delay)

#(g)

g <- filter(flights, dep_time > 0 & dep_time < 600)

#2. between() takes a vector and two boundary values and returns a
# boolean vector indicating whether each element of the vector falls
# between the two values. It would have helped to do between(dep_time,
# 0, 600).

#3. arrival time, arrival and departure delays are also missing. These
#are likely scheduled flights that were canceled for whatever reason.
# 8255 flights are missing these values.

missing_dep <- filter(flights, is.na(dep_time))

#4. NA ^ 0 is 1, because regardless of what value it has, the result
# will be 1. NA | TRUE is NA or TRUE, so the first part can be ignored.
# FALSE & NA is FALSE regardless of what NA is. The general rule is,
#if the value is the expression is fixed for any value, it will return
#that value despite the presence of NA>