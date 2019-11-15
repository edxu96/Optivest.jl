
# OR-Energy, DTU42002

## 1, Simple Economic Dispatch Model

For now, you may leave out unit commitment considerations. The model should include investments in both conventional power plants and wind power. To focus on the interactions between various technologies, in particular wind power and other technologies, the model should have an hourly time resolution. In principle, the time horizon of the model could be a year or a number of years. However, to facilitate computations, consider only a small number of representative weeks in a year, for example an average week during each season. Justify any other model assumptions you make.

Construct a data set for the technologies included in the model. Note that if the time horizon is a year, investment costs can be annualized, and operations costs can be multiplied by the number of weeks in a year, a representative week covers (for an average week during each season, approximately 13). Wind power production and electricity demand can be found at www.energinet.dk, and technology data, fuel and emission prices at www.ens.dk.

Solve the model to find the optimal power system configurations with varying parameters on fuel and emission prices to do sensitivity analysis. You may for instance, solve the model with fuel and emission prices increased and decreased by 10%.

## Model

$$
\begin{array}{c c}
    \hline
    \text{Symbol} & \text{Definition} \\
    \hline
    T & \text{Time Units} \\
    J & \text{Controllable generation technologies} \\
    \hline
\end{array}
$$

_Table 1, summary of sets_

$$
\begin{array}{c c c}
    \hline
    \text{Symbol} & \text{Definition} & \text{Set} \\
    \hline
    y & \text{Capacity of different generation technologies} & J, \{\text{wind}\} \\
    x & \text{Power output} & J, T \\
    \hline
\end{array}
$$

_Table 2, summary of decision variables_

$$
\begin{array}{c c c}
    \hline
    \text{Symbol} & \text{Definition} & \text{Set} \\
    \hline
    w & \text{Wind power output} & T \\
    d & \text{Demand} & T \\
    c^{vary} & \text{Production cost per unit output of different generation technologies} & J, T \\
    s^{max} & \text{Max controllable increment power output} & J \\
    \hline
\end{array}
$$

_Table 3, summary of constants_

$$
\begin{align}
    \text{min} \quad & \sum_j c^{fix}_{i} y_{j} + \sum_j \sum_t c^{vary}_{j, t} x_{j, t} \\
    \text{s.t.} \quad & x_{j, t} \leq y_{j} * 1 \quad \text{for } j \in J, t \in T \\
    & \sum_j x_{j, t} \geq d_{t} - w_{t} \quad \text{for } j \in J, t \in T \\
    & - s^{max}_{j} \leq x_{j, t+1} - x_{j, t} \leq s^{max}_{j} \quad \text{for } j \in J
\end{align}
$$
