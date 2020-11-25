# Optimal Production Investment and Economic Dispatch, DTU-42002 Assignment 2

Edward J. Xu  
Jan 14, 2020

## 1, without Storage

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
	c^{fix}_{j} & \text{Fixed cost per capacity of conventional generation technologies} & \text{DKK / MW} & J \\
	c^{fix, wind} & \text{Fixed cost per percent capacity of wind turbines} & \text{DKK / %} &{\text{wind}} \\
	c^{var}_{j} & \text{Production cost per unit output of different generation technologies} & \text{DKK / MW} & J \\
	s^{max}_{j} & \text{Max percent of controllable increment power output} & \text{%} & J \\
	\beta^{min}_{j} & \text{Minimum percent of load percent of full load} & \text{%} & J \\
	\hline
\end{array}
$$

_Table 3, summary of constants_

$$
\begin{align}
	\text{min} \quad & \sum_j c^{fix}_{i} y_{j} + c^{fix, wind} z + a \sum_j \sum_t c^{var}_{j} x_{j, t} \quad \text{(DKK)} \\
	\text{s.t.} \quad & y_{j} \beta^{min}_{j} \leq x_{j, t} / a \leq y_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
	& \sum_j x_{j, t} \geq d_{t} - w_{t} * z \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
	& - s^{max}_{j} y_{j} \leq x_{j, t+1} - x_{j, t} \leq s^{max}_{j} y_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)}
\end{align}
$$

## 2, with Storage (Electric Vehicle)

$$
\begin{array}{c c c}
	\hline
	\text{Symbol} & \text{Definition} & \text{Example} \\
	\hline
	T & \text{Time units} & (12:15, 12:45), (12:45, 13:15) \\
	J & \text{Controllable generation technologies} & \{\text{Gas Turbine}, \text{Biomass Power Generation}\} \\
	G & \text{Groups of electric vehicles} & {EV1, EV2} \\
	\hline
\end{array}
$$

_Table 4, summary of sets_

$$
\begin{array}{c l c c}
	\hline
	\text{Symbol} & \text{Definition} & \text{Unit} & \text{Set} \\
	\hline
	y_{j} & \text{Capacity of different generation technologies} & \text{MW} & J \\
	x_{j, t} & \text{Average power output during time interval} & \text{MW} & J, T \\
	z & \text{Percent of new wind turbine compared with installed} & \text{MW} & {\text{wind}} \\
	u^{-}_{g, t} & \text{Discharge speed of every EV in group $g$ at $t$} & \text{MW} & T, G \\
	u^{+}_{g, t} & \text{Charging speed of every EV in group $g$ at $t$} & \text{MW} & T, G \\
	l_{g, t} & \text{State of every EV in group $g$ at $t$} & \text{MWh} & T, G \\
	\hline
\end{array}
$$

_Table 5, summary of decision variables_

$$
\begin{array}{c l c c}
	\hline
	\text{Symbol} & \text{Definition} & \text{Unit} & \text{Set} \\
	\hline
	w_{t} & \text{Historical wind power output of installed turbines} & \text{MW} & T \\
	d_{t} & \text{Historical electricity demand} & \text{MW} & T \\
	d^{EV}_{g, t} & \text{Historical driving demand} & \text{MW} & T, G \\
	a & \text{Length of the time interval} & \text{hour} & - \\
	b_{g} & \text{Number of EVs in group $g$} & - & G \\
	c^{fix}_{j} & \text{Fixed cost per capacity of conventional generation technologies} & \text{DKK / MW} & J \\
	c^{fix, wind} & \text{Fixed cost per percent capacity of wind turbines} & \text{DKK / \%} &{\text{wind}} \\
	c^{var}_{j} & \text{Production cost per unit output of different generation technologies} & \text{DKK / MW} & J \\
	s^{max}_{j} & \text{Max percent of controllable increment power output} &  \% & J \\
	\beta^{min}_{j} & \text{Minimum percent of load percent of full load} & \% & J \\
	u^{-, \text{max}}_{g} & \text{Max discharging speed of EVs in group g} & \text{MW} & G \\
	u^{+, \text{max}}_{g} & \text{Max charging speed of EVs in group g} & \text{MW} & G \\
	\eta^{-}_{g} & \text{Discharging efficiency of EVs in group g} & \% & G \\
	\eta^{+}_{g} & \text{Charging efficiency of EVs in group g} & \% & G \\
	\hline
\end{array}
$$

_Table 6, summary of constants_

$$
\begin{align}
	\text{min} \quad & \sum_j c^{fix}_{i} y_{j} + c^{fix, wind} z + a \sum_j \sum_t c^{var}_{j} x_{j, t} \quad \text{(DKK)} \\
	\text{s.t.} \quad & y_{j} \beta^{min}_{j} \leq x_{j, t} / a \leq y_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
	& \sum_j x_{j, t} + \sum_{g \in G} b_{g} \eta^{-}_{g} u^{-}_{g, t} \geq d_{t} - w_{t} * z + \sum_{g \in G} b_{g} u^{+}_{g, t} \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
	& - s^{max}_{j} y_{j} \leq x_{j, t+1} - x_{j, t} \leq s^{max}_{j} y_{j} \quad \text{for } j \in J, t \in T \quad \text{(MWh)} \\
	& l_{g, t+1} = l_{g, t} + a u^{+}_{g, t} \eta^{+}_{g} - a u^{-}_{g, t} - a d^{EV}_{g, t} \quad \text{for } g \in G, t \in T/t_{max} \quad \text{(MWh)} \\
	& l^{min}_{g, t} \leq l_{g, t} \leq l^{max}_{g, t} \quad \text{for } g \in G, t \in T \quad \text{(MWh)} \\
	& u^{+}_{g, t} \leq u^{+, \text{max}}_{g} \quad \text{for } g \in G, t \in T \quad \text{(MW)} \\
	& u^{-}_{g, t} \eta^{-}_{g} \leq u^{-, \text{max}}_{g} \quad \text{for } g \in G, t \in T \quad \text{(MW)} \\
	& u^{+}_{g, t} d^{EV}_{g, t} = 0 \quad \text{for } g \in G, t \in T \quad \text{(-)} \\
	& u^{-}_{g, t} d^{EV}_{g, t} = 0 \quad \text{for } g \in G, t \in T \quad \text{(-)} \\
\end{align}
$$
