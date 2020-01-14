
# Notes for CSP-PTES and Water Tank Thermal Storage

Edward J. Xu (<edxu96@outlook.com>)
Dec 1st, 2019

## 1, Energy Content of PTES

$$
Q = c_{p} m \Delta T
$$

$c$ is the specific heat of water with unit being J / (kg C).

## 2, Energy Balance of PTES

The energy balance during any infinite small time can be expressed by:

$$
\begin{align}
	c_{p} m \frac{\mathrm{d} T}{\mathrm{d} t} &= - U_{\text{air}} A_{\text{air}} (T - T_{\text{air}}) - U_{\text{soil}} A_{\text{soil}} (T - T_{\text{soil}})
\end{align}
$$

The time $t$ needed to cool the water down from $T_0$ to $T_1$ can be integrated from the above equation.

$$
t = - \frac{c_{p} m}{U_{\text{air}} A_{\text{air}} + U_{\text{soil}} A_{\text{soil}}} \ln\left(\frac{T_t - T_{\text{surround}}}{T_{0} - T_{\text{surround}}} \right)
$$

where modified surrounding temperature $T_{\text{surround}}$ can be expressed by:

$$
T_{\text{surround}} = \frac{U_{\text{air}} A_{\text{air}} T_{\text{ambient}} + U_{\text{soil}} A_{\text{soil}} T_{\text{soil}}}{U_{\text{air}} A_{\text{air}} + U_{\text{soil}} A_{\text{soil}}}
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

$$
\begin{align}
	\eta_{\text{charge}} = \frac{\int_{t_0}^{t_1} c_{p} m (T_{\text{in}} - T_{\text{out}}) \mathrm{d} t}{c_{p} m (T_{\text{average-in}} - T_{0})} \\
	\eta_{\text{discharge}} = \frac{\int_{t_0}^{t_1} c_{p} m (T_{\text{out}} - T_{\text{in}}) \mathrm{d} t}{c_{p} m (T_{0} - T_{\text{average-in}})}
\end{align}
$$

where the average inlet temperature $T_{\text{average-in}}$ during the experiment can be expressed by:

$$
T_{\text{average-in}} = \frac{\int_{t_0}^{t_1} T \mathrm{d} t}{t_1 - t_0}
$$

## 5, Mix Number $\beta_{\text{MIX}}$

The mix number $\beta_{\text{MIX}}$ indicates how well the stratification is. A pit with good stratification has low $\beta_{\text{MIX}}$. It can be expressed by:

$$
\beta_{\text{MIX}} = \frac{M_{\text{str}} - M_{\text{exp}}}{M_{\text{str}}-M_{\text{mix}}}
$$

where $M_{\text{str}}$ the total energy content under perfect stratification, $M_{\text{mix}}$ is that when fully mixed, and $M_{\text{exp}}$ is that measured during the experiment. They can be calculated using the following equation:

$$
M = \sum_{i=1}^{N} y_{i} c_{i} \rho_{i} V_{i} T_{i}
$$

where $y_{i}$ is the distance between the middle level and the bottom of the tank. and $c_{p}$ varies according to the following equation.

$$
c_{p} = 4209.1 - 1.328 T + 0.01432 T^{2} \quad \text{J/kgK}
$$

## 6, Thermal Energy Storage and Loss of Hot Water in the Tank

The heat storage capacity of the hot water tanks consists of two parts, that of water and that of steel.

- At a typical tank temperature of 70 C, the specific heat of water is 4190 J / kg K and the density of water is 978 kg / m3.
- The specific heat of steel is 460 J / kg K and the density of steel is 7850 kg / m3.

$$
\begin{align}
	c_{p} m \frac{\mathrm{d} T}{\mathrm{d} t} &= - U A (T - T_{\text{ambient}})
\end{align}
$$

The solution is:

$$
\begin{align}
	t_{1} - t_{0} &= - \ln \left( \frac{T_{\text{end}} -T_{\text{ambient}}}{T_{0} - T_{\text{ambient}}} \right) \frac{c_{p} m}{U A} \\
	T_{1} &= T_{\text{ambient}} + \left(T_{0} - T_{\text{ambient}}\right) \cdot e^{- \frac{U A}{c_{p} m} (t_{1} - t_{0})}
\end{align}
$$

## 7, Potential Energy of Water

$$
\begin{align}
	E_{\text{potential}} &= \rho g h \\
	\rho &= 1000.6 - 0.0128 T^{1.76} \quad \text{kg / m3} \\
	g &= 9.82 \quad \text{N / kg}
\end{align}
$$
