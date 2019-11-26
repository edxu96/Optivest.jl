## Plots for PIED
## Edward J. Xu <edxu96@outlook.com>
## Nov 26th, 2019

library(tidyverse)
library(magrittr)
library(ggplot)
library(tidyr)
library(purrr)

rm(list = ls())
setwd("~/GitHub/Optivest.jl/Power-System/PIED")

#### Demand, Wind Power Output and Dispatch of Gas Turbine ####

ti <- 
  read_csv("../results/mat_x_result_1.csv", col_names = c("gt", "bio")) %>%
  mutate(index = row_number()) %>%
  bind_cols(read_csv("../data/demand.csv")[,2]) %>%
  bind_cols(read_csv("../data/wind.csv")[,2]) %>%
  select(index, demand, wind, gt)

ti %>%
  gather(-index, key = "whi", value = "power") %>%
  ggplot() + 
  geom_line(mapping = aes(x = index, y = power, color = whi)) +
  geom_abline(aes(intercept = 3208, slope = 0), color = "black") +
  geom_abline(aes(intercept = 3208 * 0.23, slope = 0), color = "black") +
  labs(
    title = "Demand, Wind Power Output and Dispatch of Gas Turbine",
    x = "Time Index", y = "Power (MW)"
  )
# Notice that the demand is satisfied entirely by gas turbine.

#### Battery Energy Levels of Different EV Groups ####

ti_l_ev <-
  read_csv(
    "../results/mat_l_result.csv", col_names = as.character(seq(1, 20))
    ) %>%
  mutate(index = row_number()) %>%
  gather(-index, key = "group", value = "level")

ti_u_ev <-
  read_csv(
    "../results/mat_u_result.csv", col_names = as.character(seq(1, 20))
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
