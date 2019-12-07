
rm(list = ls())
setwd("~/GitHub/Optivest.jl/Power-System/PIED")

library(tidyverse)
library(magrittr)
library(ggplot2)
library(tidyr)

ti <- 
  read_csv(
    "./results/df_result_sensitivity_c_fix_wind.csv", 
    col_names = c("name", "value", "sensitivity", "whe_sub", "whe_ev")
    )

# ti %>%
#   filter(whe_ev == F) %>%
#   filter(name == "obj") %>%
#   ggplot() + 
#     geom_line(mapping = aes(x = sensitivity, y = value)) +
#     labs(
#       x = "changed parameters", y = "value of results",
#       title = "Obejctive Value" #  with Respect to \"c_fix_wind\""
#       )
# 
# ti %>%
#   filter(whe_ev == F) %>%
#   filter(name == "y_gt") %>%
#   ggplot() + 
#   geom_line(mapping = aes(x = sensitivity, y = value)) +
#   labs(
#     x = "changed parameters", y = "value of results",
#     title = "Capacity of GT" # with Respect to \"c_fix_wind\""
#   )


ti %>%
  filter(whe_ev == T) %>%
  # filter(name == "obj") %>%
  ggplot() + 
    geom_line(mapping = aes(x = sensitivity, y = value)) +
    facet_grid(rows = vars(name), scales = "free")

####

ti_c_fix_gt <- 
  read_csv(
    "./results/df_result_sensitivity_c_fix_gt.csv", 
    col_names = c("name", "value", "sensitivity", "whe_sub", "whe_ev")
  )

ti_c_fix_gt %>%
  filter(whe_ev == F) %>%
  # filter(name == "obj") %>%
  ggplot() + 
  geom_line(mapping = aes(x = sensitivity, y = value)) +
  facet_grid(rows = vars(name), scales = "free")
