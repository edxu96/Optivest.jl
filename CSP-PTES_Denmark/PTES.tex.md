
## 1, Energy Content of PTES

$$
Q = c_{p} m \Delta T
$$

$c$ is the specific heat of water with unit being J / (kg C).

## 2, Energy Balance of PTES

$$
\begin{align}
	c_{p} m \frac{\mathrm{d} T}{\mathrm{d} t} &= - U_{air} A_{air} (T - T_{air}) - U_{soil} A_{soil} (T - T_{soil})
\end{align}
$$

The time $t$ needed to cool the water down from $T_0$ to $T_1$ can be integrated from the above equation.

$$
t = - \frac{c_{p} m}{U_{air} A_{air} + U_{soil} A_{soil}} \ln\left(\frac{T_t - T_a^{*}}{T_{0} - T_a^{*}} \right)
$$

## 3, Energy Loss through Heat Transfer

The Fourier's Law can be expressed by:

$$
\Phi = - \lambda A \frac{\mathrm{d} T}{\mathrm{d} x}
$$

The heat conduction over a plate can be expressed by:

$$
\begin{align}
	\Phi_{A} &= \frac{\Delta T}{R_A} \\
	R_A &= \frac{\sigma}{\lambda A}
\end{align}
$$

where $R_{A}$ is the thermal resistance.

## 4, Thermal Stratification

Calculate discharge/charge efficiency of PTES from $t_0$ to $t_1$.

### Charging Efficiency

$$
\begin{align}
	Q_1 &= \int_{t_0}^{t_1} c_{p} m (T_{\text{in}} - T_{\text{out}}) \mathrm{d} t \\
	Q_2 &= c_{p} m (T_{\text{average-in}} - T_{0}) \\
	\eta_{\text{charge}} &= Q_1 / Q_2
\end{align}
$$

### Discharging Efficiency

$$
\begin{align}
	Q_1 &= \int_{t_0}^{t_1} c_{p} m (T_{\text{out}} - T_{\text{in}}) \mathrm{d} t \\
	Q_2 &= c_{p} m (T_{0}, T_{\text{average-in}}) \\
	\eta_{\text{discharge}} &= Q_1 / Q_2
\end{align}
$$

where $T_{\text{average-in}}$ is the average inlet temperature during the experiment.

## 5, Mix Number

$$
M_{final} = \frac{M_{\text{str}} - M_{\text{exp}}}{M_{\text{str}}-M_{\text{mix}}}
$$

$$
M = \sum_{i=1}^{N} y_{i} c_{i} \rho_{i} V_{i} T_{i}
$$

$$
C = 4209.1 - 1.328 T + 0.01432 T^{2} \quad \text{J/kgK}
$$

## 6, Thermal Energy Storage in the Tank

The heat storage capacity of the hot water tanks consists of two parts, that of water and that of steel.

- At a typical tank temperature of 70 C, the specific heat of water is 4190 J / kg K and the density of water is 978 kg / m3.
- The specific heat of steel is 460 J / kg K and the density of steel is 7850 kg / m3.

## 7, Potential Energy of Water

$$
\begin{align}
	E_{\text{potential}} &= \rho g h \\
	\rho &= 1000.6 - 0.0128 T^{1.76} \quad \text{kg / m3} \\
	g &= 9.82 \quad \text{N / kg}
\end{align}
$$
