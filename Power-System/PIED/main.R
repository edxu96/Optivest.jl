
rm(list = ls())
setwd("~/GitHub/Optivest.jl/Power-System/PIED")

library(tidyverse)
library(magrittr)
library(ggplot2)
library(tidyr)

ti_dk1 <- 
  read_csv2("./data/Electricity-Dispatch_DK1.csv") %>%
  mutate(OffshoreWindPower = as.numeric(OffshoreWindPower)) %>%
  mutate(TotalLoad = TotalLoad / 100) %>%
  mutate(OnshoreWindPower = OnshoreWindPower / 100)

ti <- 
  read_csv(
    "./results/c_fix_wind-1000000/mat_x_result_1.csv", 
    col_names = c("gt", "bio")
  ) %>%
  mutate(index = row_number()) %>%
  bind_cols(ti_dk1[1:168, 4]) %>%
  bind_cols(ti_dk1[1:168, 5:6]) %>%
  mutate(wind_total = (OnshoreWindPower + OffshoreWindPower) * 0.7991) %>%
  mutate(demand = TotalLoad) %>%
  mutate(wind_net = demand - gt - bio) %>%
  select(index, demand, wind_total, wind_net, gt, bio)

ti %>%
  gather(-index, key = "whi", value = "power") %>%
  ggplot() + 
    geom_line(mapping = aes(x = index, y = power, color = whi)) +
    geom_hline(yintercept = 568.61, color = "black") +
    geom_hline(yintercept = 568.61 * 0.23, color = "black") +
    geom_hline(yintercept = 2229.65, color = "black") +
    geom_hline(yintercept = 2229.65 * 0.5, color = "black") +
    labs(
      title = "Demand, Wind Power Output, Dispatch of GT and Bio",
      x = "Time Index", y = "Power (MW)"
      )

ti %>%
  select(index, bio, gt, wind_net) %>%
  gather(-index, key = "whi", value = "power") %>%
  ggplot() +
    geom_area(mapping = aes(x = index, y = power, fill = whi))


#### Model 2

ti <- 
  read_csv(
    "./results/c_fix_wind-1000000/mat_x_result_2.csv", 
    col_names = c("gt", "bio")
  ) %>%
  mutate(index = row_number()) %>%
  bind_cols(ti_dk1[4]) %>%
  bind_cols(ti_dk1[5] + ti_dk1[6]) %>%
  select(index, demand, wind, gt)

ti %>%
  gather(-index, key = "whi", value = "power") %>%
  ggplot() + 
  geom_line(mapping = aes(x = index, y = power, color = whi)) +
  geom_abline(aes(intercept = 3208, slope = 0), color = "black") +
  geom_abline(aes(intercept = 3208 * 0.23, slope = 0), color = "black") +
  labs(
    title = "Demand, Wind Power Output, Dispatch of GT and Bio",
    x = "Time Index", y = "Power (MW)"
  )

ti_l_ev <-
  read_csv(
    "./results/2/mat_l_result.csv", col_names = as.character(seq(1, 20))
  ) %>%
  mutate(index = row_number()) %>%
  gather(-index, key = "group", value = "level")

ti_u_ev <-
  read_csv(
    "./results/2/mat_u_result.csv", col_names = as.character(seq(1, 20))
  ) %>%
  mutate(index = row_number()) %>%
  gather(-index, key = "group", value = "diff")

ti_ev <- 
  right_join(ti_l_ev, ti_u_ev, by = c("index", "group")) %>%
  mutate(g = as.numeric(group)) %>%
  select(index, g, level, diff)

ti_ev %>%
  filter(g == 5 | g == 10 | g == 15) %>%  #
  ggplot() + 
  facet_grid(rows = vars(g)) +
  geom_line(mapping = aes(x = index, y = level)) +
  # geom_line(mapping = aes(x = index, y = diff)) +
  geom_abline(aes(intercept = 0.07, slope = 0), color = "red") +
  geom_abline(aes(intercept = 0.0028, slope = 0), color = "red") +
  labs(
    title = "Battery Energy Levels of Different EV Groups",
    x = "Time Index", y = "Energy (MWh)"
  )

# To plot the line and bar graphs separately in two facets, use a dummy facet. See <https://sebastianrothbucher.github.io/datascience/r/visualization/ggplot/2018/03/24/two-scales-ggplot-r.html>.