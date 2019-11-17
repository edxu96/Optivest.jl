## Forecast Bi-Annual Electricity Price in Malta
## Edward J. Xu (edxu96@outlook.com)
## Oct. 6, 2019

library(tidyverse)
library(readxl)
library(ggplot2)
library(lubridate)
library(forecast)
library(writexl)
library(tseries)
library(magrittr)

#### Data ####
## Bi-Annual Electricity Price in Malta (Euro / Kilowatt-hour) with All taxes and levies included
## <https://ec.europa.eu/eurostat/data/database>
ti <-
  readxl::read_excel("~/GitHub/EnergyStorage/e-price-forecast/e-price.xlsx") %>%
  as.matrix() %>%
  t() %>%
  {tibble(bi_annual = as.numeric(rownames(.)), price = .[,1])} %>%
  mutate(observation = rep(TRUE, length(.$bi_annual)))

## <https://www.statista.com/statistics/418104/electricity-prices-for-households-in-malta/>
ti[15:23, 2] <- c(16.47, 16.53, 16.51, 16.66, 16.73, 16.78, 16.64, 16.89, 14.74) / 100

ti %>%
  ggplot() +
  geom_line(mapping = aes(x = bi_annual, y = price))

## Forecast using Linear Regression
lm <- lm(price ~ bi_annual, ti)

acf(lm$residuals)
pacf(lm$residuals)

mod_resi_lm <- auto.arima(lm$residuals)

pred_resi_lm <- predict(mod_resi_lm, n.ahead = 21 * 2)
pred_lm <- predict(lm, newdata = data.frame(bi_annual = seq(2019.5, 2019.5 + 20.5, by = 0.5)))

ti %<>%
  bind_rows(
    tibble(
      bi_annual = seq(2019.5, 2019.5 + 20.5, by = 0.5),
      price = pred_resi_lm$pred + pred_lm,
      observation = rep(FALSE, length(pred_lm))
      )
    )

ti %>%
  ggplot() +
    geom_line(mapping = aes(x = bi_annual, y = price, color = observation)) +
    labs(
      title = "Observation and Forecast of Electricity Price in Malta",
      y = "Electricity Price (Euro / Kilo-Watt-Hour)",
      x = "Bi-Annual"
      )

# plot(c(ti$bi_annual, seq(2019.5, 2019.5 + 20.5, by = 0.5)), c(ti$price, c_new))

ti_annual <-
  tibble(
    year = round(seq(2019 - 0.01, 2019 - 0.01 + 20.5, by = 0.5)),
    price = c(0.1305, (pred_resi_lm$pred + pred_lm)[1:41]), bi = rep(1:2, 21)
    ) %>%
  spread(key = "bi", value = "price") %>%
  mutate(price_ave = (.$`1` + .$`2`) / 2) %>%
  select(year, price_ave)

writexl::write_xlsx(
  ti_annual,
  path = "~/GitHub/EnergyStorage/e-price-forecast/e-price-pred.xlsx"
)

## Forecast using Decomposition
ts <-
  ts(ti$price, frequency = 2) %>%
  tseries::na.remove()

li_decomp <- ts %>%
  decompose(type = c("multiplicative"), filter = NULL)

plot(li_decomp$seasonal)

mod <-
  li_decomp$trend %>%
  forecast::auto.arima()

acf(mod$residuals)
pacf(mod$residuals)

pred_2 <- predict(mod, n.ahead = 20 * 2)

plot(c(li_decomp$trend, pred_2$pred))

## Electricity Price in Malta (euro cents per kilowatt-hour)
## <https://www.statista.com/statistics/418104/electricity-prices-for-households-in-malta/>
# ti <- tibble(
#   time = c(2010, 2010.5, 2011, 2011.5, 2012, 2012.5, 2013, 2013.5, 2014,
#            2014.5, 2015, 2015.5, 2016, 2016.5, 2017),
#   price = c(16.47, 16.53, 16.51, 16.66, 16.73, 16.78, 16.64, 16.89, 14.74,
#             12.48, 12.57, 12.69, 12.57, 12.74, 12.78)
#   )
#
# ti %>%
#   ggplot() +
#     geom_line(mapping = aes(x = time, y = price))
