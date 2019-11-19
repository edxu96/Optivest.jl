# CIED: Capacity Invest and Economic Dispatch

## 1, Economic Dispatch

For now, you may leave out unit commitment considerations. The model should include investments in both conventional power plants and wind power. To focus on the interactions between various technologies, in particular wind power and other technologies, the model should have an hourly time resolution. In principle, the time horizon of the model could be a year or a number of years. However, to facilitate computations, consider only a small number of representative weeks in a year, for example an average week during each season. Justify any other model assumptions you make.

Construct a data set for the technologies included in the model. Note that if the time horizon is a year, investment costs can be annualized, and operations costs can be multiplied by the number of weeks in a year, a representative week covers (for an average week during each season, approximately 13). Wind power production and electricity demand can be found at www.energinet.dk, and technology data, fuel and emission prices at www.ens.dk.

Solve the model to find the optimal power system configurations with varing parameters on fuel and emission prices to do sensitivity analysis. You may for instance, solve the model with fuel and emission prices increased and decreased by 10%.

## 2, Prototypical Project

$$
\begin{array}{c c c}
	\hline
	\text{Symbol} & \text{Definition} & \text{Example} \\
	\hline
	T & \text{Time Units} & (12:15, 12:45), (12:45, 13:15) \\
	J & \text{Controllable generation technologies} & \{\text{Gas Turbine}, \text{Biomass Power Generation}\} \\
	\hline
\end{array}
$$

_Table 1, summary of sets_

$$
\begin{array}{c l c c}
	\hline
	\text{Symbol} & \text{Definition} & \text{Unit} & \text{Set} \\
	\hline
	y_{j} & \text{Capacity of different generation technologies} & \text{MW} & J \\
	x_{j, t} & \text{Average power output during time interval} & \text{MW} & J, T \\
	z & \text{Percent of new wind turbine compared with installed} & \text{MW} & {\text{wind}} \\
	\hline
\end{array}
$$

_Table 2, summary of decision variables_

$$
\begin{array}{c l c c}
	\hline
	\text{Symbol} & \text{Definition} & \text{Unit} & \text{Set} \\
	\hline
	w_{t} & \text{Historical wind power output of installed turbines} & \text{MW} & T \\
	d_{t} & \text{Historical electricity demand} & \text{MW} & T \\
	a & \text{Length of the time interval} & \text{hour} & - \\
	c^{fix}_{j} & \text{Fixed cost per capacity of different generation technologies} & \text{DKK / MW} & J \\
	c^{fix, wind} & \text{Fixed cost per percent capacity of wind turbines} & \text{DKK / %} &{\text{wind}} \\
	c^{var}_{j, t} & \text{Production cost per unit output of different generation technologies} & \text{DKK / MW} & J, T \\
	s^{max}_{j} & \text{Max percent of controllable increment power output} & \text{%} & J \\
	\beta_{j} & \text{Minimum percent of load percent of full load} & \text{%} & J \\ \hline
\end{array}
$$

_Table 3, summary of constants_

$$
\begin{align}
\text{min} \quad & \sum_j c^{fix}_{i} y_{j} + c^{fix, wind} z + a \sum_j \sum_t c^{var}_{j, t} x_{j, t} \quad \text{(DKK)} \\
\text{s.t.} \quad & x_{j, t} \leq a y_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
& \sum_j x_{j, t} \geq d_{t} - w_{t} * z \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
& - s^{max}_{j} y_{j} \leq x_{j, t+1} - x_{j, t} \leq s^{max}_{j} y_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
& x_{j, t} \geq \beta_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)}
\end{align}
$$

## Data

$$
\begin{array}{c c c}
	\hline
	\text{Symbol} & \text{Unit} & \text{Value} \\
	\hline
	a &  \text{hour} & 0.5 \\
	c^{fix}_{1} &  \text{DKK / MW} &  \\
	c^{fix}_{2} &  \text{DKK / MW} &  \\
	c^{fix, wind} & \text{DKK / %} &{\text{wind}} \\
	c^{var}_{j, t} & \text{DKK / MW} & J, T \\
	s^{max}_{j} & \text{%} & J \\
	\beta_{j} & \text{%} & J \\ \hline
\end{array}
$$

_Table 3, summary of important constants_


## Integration of Electric Vehicles

The purpose of this extension is to include the modelling of electric cars and wind power in the model, and furthermore, to use this as a basis for analyzing the effects of demand flexibility from electric vehicles on integration of variable renewables.

- Formulate the additional constraints necessary for including electric vehicles, and implement it in your investment model in GAMS. You may consider battery electric vehicles (driving on electricity only) only, or both these and hybrid electric vehicles (driving on fuel or electricity). You may want to revisit your time horizon from the base model. Justify any other model assumptions you make.
- Construct a data set for electric vehicles. Data for electric vehicles can be found in the references below, however, consider using updated data on battery sizes. Driving demands can be found on Inside. If you consider future years, remember to make assumptions on future demands from electric vehicles.
- Solve the model to obtain the optimal investments in the power system with and without the inclusion of electric cars.
- Present and discuss your results. The discussion should include the effects of demand flexibility from electric vehicles on integration of variable renewables. How are total costs affected? How does the consumption from electric vehicles and the variable renewables power generation complement each other? What is the impact on the operation of the conventional power generating units? How are electricity prices affected? Remember to make a sensitivity analysis on important parameters.

## Integration of Heating

The purpose of this extension is therefore to add a district heating demand, combined heat-and-power units, electric heat boilers, and heat storages to the base model. This model can then be used for analyzing effects of demand flexibility from electric heat production on integration of variable renewables.

- Formulate the additional constraints mathematically and in GAMS, including electric heat production. The model should include district heating demand, combined heat- and-power units, electric heat boilers, and heat storages. You may need to reconsider the time horizon from your base model. Justify any other model assumptions you make.
- Construct a data set for the heat production. Time series for hourly heat demand time series can be found on Inside.
- Solve the model to find the investments in the heat and power system with and without the inclusion of electric heat production.
- Present and discuss the results. The discussion should include the effects of demand flexibility from electric heat boilers and heat storages on integration of variable renewables. How are total costs affected? How does the consumption from electric heat production and the generation from variable renewables complement each other? What is the impact on the operation of the conventional power generating units? How are electricity prices affected? Remember to make a sensitivity analysis on important parameters.

## Integration of Power2Hydrogen

Hydrogen is frequently argued to be a promising new energy carrier that facilitates large-scale integration of uncontrollable electricity production such as wind and solar power. By including electrolysis plants and hydrogen storage in an energy system, and using the resulting hydrogen production in fuel cell power plants or gas turbines, considerable flexibility is added to power systems, although on the expense of large losses in hydrogen production.
The purpose of this extension is therefore to include electrolysis plants and hydrogen storage in the investment model, and use this a basis for analysing the effects of using hydrogen as an energy carrier.

- Formulate the necessary extra constraint mathematically and in GAMS. The model should include electrolysis plants and hydrogen storages. You may need to revise your time horizon from the base model. Justify any other model assumptions you make.
- Construct a data set that covers the hydrogen technologies included. Technology data can be found at www.ens.dk.
- Solve the model to find the optimal investments in the system with and without the inclusion of hydrogen production.
- Present and discuss the results. The discussion should include the effects of demand flexibility from electrolysis and hydrogen storage on wind power integration. How are total costs affected? How does the electricity consumption from hydrogen production and generation from variable renewables complement each other? What is the impact on the operation of the conventional power generating units? How are electricity prices affected? Remember to make a sensitivity analysis on important parameters.
