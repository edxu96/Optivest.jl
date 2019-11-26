
library(tidyverse)
library(magrittr)
library(ggplot)
library(tidyr)

rm(list = ls())
setwd("~/GitHub/Optivest.jl/Power-System/PIED")

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
      title = "Dispatch of Newly Installed Gas Turbine",
      x = "Time Index", y = "Power (MW)"
      )
# Notice that the demand is satisfied entirely by gas turbine.

ti_l_ev <-
  read_csv("../results/mat_l_result.csv", col_names = as.character(seq(1, 20))) %>%
  mutate(index = row_number())

ti_l_ev %>%
  ggplot() + 
    geom_line(mapping = aes(x = index, y = `1`)) +
    geom_abline(aes(intercept = 0.07, slope = 0), color = "red") +
    geom_abline(aes(intercept = 0.0028, slope = 0), color = "red") 
