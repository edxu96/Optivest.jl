
library(tidyverse)
library(readxl)
library(purrr)

#' Calculate the Levelized Cost of Hydrogen (LCOH)
#' @param c_elec the cost of electricity per [$ / kWh]
#' @param capacity the capacity of the electrolyzer power plants [kg / h]
#' @param rate_elec_consume the rate to consume electricity [kWh / Nm^3]
#' @return levelized cost of hydrogen [$ / kg]
cal_lcoh <- function(
    c_bop, c_stack, t_bop, t_stack, c_elec, rate_elec_consume
    ){

  ## Default Parameters
  t_sys <- 20
  capacity <- 25E3

  ## Unit Cost from Capital Investment
  rho <- 0.09
  rate_elec_consume_all <- rate_elec_consume * capacity / rho
  c_op <- c_elec * (rate_elec_consume_all * t_sys * 24)

  ## Unit Cost from Operation
  c_invest <- c_stack * t_sys / t_stack + c_bop * t_sys / t_bop
  c_cap <- c_invest / (rate_elec_consume_all * t_sys * 24)




  lcoh <- c_op + c_cap

  return(lcoh)
}


#### Data ####

ti <-
  tibble(
    # whi = c("AEC", "PEMEC", "SOEC"),
    c_elec = c(0.04, 0.04, 0.04),
    rate_elec_consume = c(4.5, 5, 4),
    c_stack = c(200, 400, 200),
    c_bop = c(350, 350, 350),
    t_stack = c(10, 10, 5),
    t_bop = c(20, 20, 20)
    # per_om = c(0.02, 0.02, 0.02)
  )

pmap(ti, cal_lcoh)




