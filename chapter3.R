##Data Transformations with dplyr

##ply on, plyette. No diggity, no doubt.

library(nycflights13)
library(tidyverse)

#Filter rows with filter
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

#Arrange rows with arrange()
#1. 
arrange(flights, !(is.na(dep_time)))

#2.
#Most delayed
arrange(flights, desc(dep_delay))
#left earliest
arrange(flights, dep_delay)

#3.
arrange(flights, air_time)

#4. 
#longest
arrange(flights, desc(distance))
#shortest
arrange(flights, distance)

#Select columns with select()
#1.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, ends_with("_time"), ends_with("_delay")) %>%
      select(starts_with("dep_"), starts_with("arr_"))
flights[,c(4,6:7,9)]
select(flights, starts_with("dep_"), starts_with("arr_")) %>%
      select(contains("_time"), contains("_delay"))

#2. It ignores the second mention.
select(flights, month, month)

#3. one_of makes a character vector of column names usable in the select
# function, whereas usually it is not.

?one_of
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, vars) #error
select(flights, one_of(vars))

#4. It did, actually. The select helpers ignore case by default. You can change
#that by passing the argument ignore.case = FALSE to the function.
select(flights, contains("TIME"))
select(flights, contains("TIME", ignore.case = FALSE))

#Add new variables with mutate()
#1.
mutate(flights, dep_minutes = (dep_time %/% 100) * 60 + dep_time %% 100,
       sched_dep_minutes = (sched_dep_time %/% 100) * 60 + 
             sched_dep_time %% 100) %>%
      select(dep_time, dep_minutes, sched_dep_time, sched_dep_minutes)

#2. arr_time - dep_time is incorrect because the times are coded as integers,
# so each hour is counted as 100 minutes, not 60. Need to apply the correction
# from question 1.
mutate(flights, incorrect = arr_time - dep_time) %>%
      select(air_time, incorrect)

#3. Once dep_time and sched_dep_time have been corrected as in question 1,
#the difference between them should equal dep_delay
delays <- mutate(flights, dep_minutes = (dep_time %/% 100) * 60 + dep_time %% 100,
                 sched_dep_minutes = (sched_dep_time %/% 100) * 60 + 
                       sched_dep_time %% 100,
                 calc_delay = dep_minutes - sched_dep_minutes) %>%
      select(calc_delay, dep_delay)
identical(delays$calc_delay, delays$dep_delay) #false, incorrect when delays
#cross midnight (large negative number)

#4.
mutate(flights, delay_rank = min_rank(desc(arr_delay))) %>%
      arrange(delay_rank, distance) %>%
      filter(between(row_number(), 1, 10))

#5. A vector of 10 integers and a warning. 1:3 is repeated over the length of
#1:10, and the warning is because the length 10 is not a multiple of length 3.

1:3 + 1:10

#6. cos(), sin(), and tan(); acos(), asin(), atan(), and atan2() (for arc-); 
# and cospi(), sinpi(), and tanpi().

#Grouped Summaries with summarize()

not_cancelled <- flights %>%
      filter(!is.na(dep_delay), !is.na(arr_delay))

#1. Arrival delay is more important. Leaving the airport late doesn't really
# matter if you still arrive at the destination on time. Different ways to 
# measure: percent of flights on time, average delay, average variation from
# scheduled arrival, average delay when delayed, average variation overall.

#2.

not_cancelled %>% group_by(dest) %>%
      summarize(flights = n())
not_cancelled %>% count(dest)

not_cancelled %>% count(tailnum, wt = distance)
not_cancelled %>% group_by(tailnum) %>%
      summarize(miles = sum(distance))

#3. There may not be any data without a recorded departure delay that 
#have an observed arrival delay.
 # Let's check!

#1175 observations with an na arrival delay and an observed departure delay -
# these are flights that left but did not arrive at their destination.
na_arr_delay <- flights %>%
      filter(is.na(arr_delay), !is.na(dep_delay))

#no observations with an na departure delay and an observed arrival delay
na_dep_delay <- flights %>%
      filter(!is.na(arr_delay), is.na(dep_delay))

#4. There seem to be more concelled flights on Wednesday and Thursday and
# fewer cancelled flights on Saturday and Sunday.
na_arr_delay %>% count(weekdays(time_hour))

not_cancelled %>% count(weekdays(time_hour), wt = arr_delay)

#There definitely seems to be less total delay on Saturdays and Sundays, and
# Thursday has the highest total delay, but Wednesday has a lower total than
# Friday or Monday. So while there is correlation here, it doesn't completely
# explain the relationship.

#5.

not_cancelled %>% group_by(carrier) %>%
      summarize(avg_delay = mean(arr_delay)) %>%
      arrange(desc(avg_delay))

filter(airlines, carrier == "F9" | carrier == "FL")
#Frontier have the worst delays, followed by AirTran.

#to control for destination airports, what you could do is calculate the
#average delay for each airport, and compare it to the average delay for
#each airline going to that airport. You could then add up the difference from
#the mean for each airport for a quick and dirty ranking, or calculate the
#standard deviations from the mean for each airport for each airline, and add
#those together for perhaps a more meaningful ranking.

#6.
not_cancelled %>% mutate(hour_delay = arr_delay > 60) %>%
      group_by(tailnum) %>%
      filter(!cumany(hour_delay)) %>%
      count(tailnum, sort = TRUE)

#7. The sort arguments sorts the count from largest to smallest. Usually you
# are interested in the groups with the highest or lowest counts, so this is
# very convenient.

#Grouped Mutates and Filters
#1. This must be a publishing mistake? I see no table. However, functions will
# calculate within each group instead of over the entire tibble.

#2. Several planes have never been on time. Setting the bar at 10 flights for
# more interesting data.

not_cancelled %>% group_by(tailnum) %>%
      filter(n() > 10) %>%
      mutate(ontime_pct = mean(arr_delay <= 0)) %>%
      select(tailnum, ontime_pct) %>%
      arrange(ontime_pct) %>%
      unique()

#N168AT is the worst here.

#3.

not_cancelled %>% group_by(hour) %>%
      summarize(avg_delay = mean(arr_delay)) %>%
      arrange(avg_delay)

#Early morning flights are best. Between 5 and 10 am flights arrive early on
#average. Flights leaving between 7 and 10 pm have the longest delays.

#4.

not_cancelled %>% filter(arr_delay > 0) %>%
      group_by(dest) %>%
      mutate(prop_delay = arr_delay / sum(arr_delay))

#5. This is not a question! However,

not_cancelled %>% group_by(day) %>%
      mutate(lag_delay = lag(dep_delay)) %>%
      filter(!is.na(lag_delay)) %>%
      ggplot(aes(x = dep_delay, y = lag_delay)) +
                   geom_point(color = "blue", alpha = 0.1) +
                   geom_smooth(method = "lm", color = "red")

#Lots of noise here. Not sure it's a great relationship.

#6.
not_cancelled %>% group_by(dest) %>%
      mutate(prop_air_time = air_time / mean(air_time)) %>%
      arrange(prop_air_time) %>%
      select(dest, air_time, prop_air_time, distance)

#Some of these long distance flights seem like they might be too fast: shaving
#an hour of a two and a half hour flight to MSP, for example.

#7.
not_cancelled %>% group_by(dest) %>%
      filter(n_distinct(carrier) > 2) %>%
      group_by(carrier) %>%
      summarize(num_dest = n_distinct(dest)) %>%
      arrange(-num_dest)
      
filter(airlines, carrier == "DL")

#Delta Air Lines has the most destinations with multiple airlines covering.