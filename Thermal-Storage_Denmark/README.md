# Concentrated Solar Heat Generation, District Heating, and Water Pit Heat Storage

## 1, Introduction

1. Locate a district heating system, find out the annual heat demand, supply temperature, return temperature of the district heating plant. Calculate degree*hour for the heating system
2. Identify the size of a solar district heating system that can cover more than 50% of the annual heat demand of the district heating system obtained in the previous question. The configuration of the solar district heating system should be similar to the Marstal solar heating system. Determine average solar collector efficiency for the solar collector field. Determine the levelized cost of heat for the system.
3. Analyze the energy balance of the PTES and the tank heat storage calculated by the program SDHCal. Determine the average heat loss coefficients of the top cover, sides and the bottom surface of the PTES. Determine annual heat recovery rate of the heat storages
4. Carry out parametric investigations for different scenarios, for instance, different fuel price, different system size with an aim to decrease the levelized cost of heat.

## References

The reference solar district heating system in Marstal, Denmark. For the reference year used in the program, the sum of degree-hour per year is 81834\. The yearly solar radiation on a tilted surface of $35^{\circ}$ facing south is 1083 kWh/m2\. Info about the Marstal Solar heating plant is:

1. District heating net. The Marstal district heating net has an annual consumption of 32000 MWh. The supply temperature and the return temperature of the district heat net is $75^{\circ}$C and $35^{\circ}$C respectively.
2. There are three solar collector fields. The tilt of the collector in the three fields is $35^{\circ}$. The distance between collector rows is 4.5 m. Collector area and efficiency expressions are given as follows.

$$ \eta=\eta_{0} K_{\theta}-\frac{a_{1}\left(T_{m}-T_{a}\right)}{G}-\frac{a_{2}\left(T_{m}-T_{a}\right)^{2}}{G} $$

|   Row   | Collector Field Area | $\eta_{0}$ |  $a_{1}$  |  $a_{1}$  |  cost  |
|:-------:|:--------------------:|:----------:|:---------:|:---------:|:------:|
|  Unit   |       ($m^2$)        |     -      | (W/m^2/K) | (W/m^2/K) | DKK/m2 |
| Field 1 |         9043         |    0.76    |    3.5    |   0.002   |  1200  |
| Field 2 |         9124         |    0.81    |   2.57    |  0.0079   |  1400  |
| Field 3 |        15000         |    0.85    |   3.07    |   0.01    |  1500  |

1. The water pit heat storage used in the plant has a volume of 75000 m3\. The height to diameter ratio of the storage is 0.0705\. The storage was insulated with 0.24 m PE foam. Thermal conductivity of the PE foam is 0.05 W/m/K.
2. The steel buffer tank has a volume of $2100 m^3$ and a height to diameter ratio of 0.6612\. The heat loss coefficient of the tank is estimated to be 278 W/K.
3. The CO2 heat pump has power of 475 kW. The condensing wood-chip boiler plus ORC has a total power of 4493 kW. The maximum power of the backup bio-oil boiler is 10 MW.

### Financing of the solar heating plant

The water pit storage has a cost of 110 DKK/m3 while it is 700 DKK/m3 for the steel tank. The investment of the Marstal solar heating plant is financed by a 20 year loan with an annual interest rate of 5%. The annual payment for a 20 year loan is given in Appendix A for different interest rates. The heat produced by the CO2 heat pump is on average 100 DKK/MWh, while it costs 200 DKK/MWh to produce heat by woodchip boiler and 400 DKK/MWh to produce heat by bio-oil.

## Note

- Besides to supply more heat during winter, heat pump can be used to lower the temperature before spring, so more heat during summer can be absorbed.
- Over 50% of the heat loss happens in the top parts.
- <https://www.solar-district-heating.eu>
