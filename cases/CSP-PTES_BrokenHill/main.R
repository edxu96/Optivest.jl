
setwd("/Users/edxu96/GitHub/Optivest.jl/CSP-PTES_BrokenHill")

library(tidyverse)
library(magrittr)
library(ggplot2)
library(tidyr)
library(kableExtra)
library(knitr)
library(lubridate)

# Renewables.ninja Weather (Point API) - -31.966, 141.453 - Version: 1.0 - License: https://science.nasa.gov/earth-science/earth-science-data/data-information-policy - Reference: https://www.renewables.ninja/
# Units: time in UTC, local_time in Australia/Broken_Hill, radiation_surface in W/m²
# {"units": {"time": "UTC", "local_time": "Australia/Broken_Hill", "radiation_surface": "W/m\u00b2"}, "params": {"local_time": true, "header": true, "lat": "-31.966326731999086", "lon": "141.45301222626478", "date_from": "2014-01-01", "date_to": "2014-12-31", "dataset": "merra2", "var_t2m": false, "var_prectotland": false, "var_precsnoland": false, "var_snomas": false, "var_rhoa": false, "var_swgdn": true, "var_swtdn": false, "var_cldtot": false}}

ti <- 
  read_csv("./solar-radiation_2014.csv") %>%
  mutate(time_local = local_time) %>%
  select(time_local, radiation_surface)

vec_filter <- month(ti$time_local) == 2

ti[vec_filter, ] %>%
  ggplot() + 
    geom_line(mapping = aes(x = time_local, y = radiation_surface)) +
    labs(
      title = "Surface Solar Radiation in February 2014",
      x = "Hour", y = "Power / Area (W / m2)"
     )

vec_filter <- year(ti$time_local) == 2014

sum(ti[vec_filter, ]$radiation_surface * 1) / 1000
