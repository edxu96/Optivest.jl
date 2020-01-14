## Model and Predict the Monthly Load Demand of Electricity in Malta
## Edward J. Xu (edxu96@outlook.com)
## Sept. 25, 2019

library(tidyverse)
library(readxl)
library(ggplot2)
library(lubridate)
library(forecast)
library(writexl)

#### Data ####

ti <-
  readxl::read_excel("~/GitHub/EnergyStorage/demand-without-renewables.xlsx") %>%
  mutate(month = 1:12) %>%
  gather(-month, key = "year", value = "demand") %>%
  mutate(year = as.numeric(.$year)) %>%
  mutate(date = ymd(sprintf("%d-%02d-01", .$year, .$month))) %>%
  select(date, demand)

ti %>%
  mutate(month = month(.$date)) %>%
  mutate(year = as.character(year(.$date))) %>%
  ggplot() +
    geom_line(mapping = aes(x = month, y = demand, color = year))

ti %>%
  ggplot() +
  geom_line(mapping = aes(x = date, y = demand))

#### Decompose ####

ts <-
  ts(ti$demand, frequency = 12)

li_decomp <-
  ts %>%
  decompose(type = c("multiplicative"), filter = NULL)

plot(li_decomp$random)
plot(li_decomp$seasonal)
plot(1:length(ti$date), li_decomp$trend, pch = 1)

acf(li_decomp$random, na.action = na.pass)
pacf(li_decomp$random, na.action = na.pass)

#### Model of Trending Component using Linear Regression ####

df_trend <- data.frame(x = 1:length(li_decomp$trend), y = li_decomp$trend)
lm_trend <- lm(y ~ x, df_trend)

par(mfrow = c(2, 2))
plot(lm_trend)

par(mfrow = c(1, 1))
plot(
  predict(
    lm_trend, newdata = data.frame(x = c(1:(length(df_trend$x) + 12 * 10)))
    )
  )
lines(df_trend$x, df_trend$y)

#### Model of Trending Component using ARIMA ####

arima_trend <- auto.arima(li_decomp$trend)
acf(arima_trend$residuals, na.action = na.pass)
pacf(arima_trend$residuals, na.action = na.pass)

li_pred <- predict(arima_trend, n.ahead = 12 * 10)

plot(c(df_trend$y, li_pred$pred))

#### Prediction using Linear Regression Model ####

trend_new <- predict(
  lm_trend, newdata = data.frame(
    x = c((length(df_trend$x) + 1):(length(df_trend$x) + 12 * 20))
  )
)
seasonal_new <- rep(li_decomp$seasonal[1:12], 20)

ti_new <-
  tibble(
    index = 1:(12 * 20), demand = trend_new * seasonal_new  # multiplicative
  ) %>%
  mutate(date = rep(ti$date[60], length(.$index)))

for (i in 1:length(ti_new$index)) {
  month(ti_new$date[i]) = i + month(ti$date[60])
}

ti_new %<>%
  select(date, demand) %>%
  mutate(observation = rep(FALSE, length(.$date)))

ti %<>%
  bind_rows(ti_new)

ti %>%
  ggplot() +
  geom_line(mapping = aes(x = date, y = demand, color = observation)) +
  labs(title = "Forecast of Electricity Demand from Non-Renewables in Malta",
       y = "Electricity Demand from Non-Renewables (MWh)",
       x = "Index (Month)")

### Write the Result ####

new <- trend_new * seasonal_new
writexl::write_xlsx(
  as.data.frame(matrix(new, nrow = 12)),
  path = "~/GitHub/EnergyStorage/demand-without-renewables_pred.xlsx"
  )

