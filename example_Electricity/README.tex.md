
# Optimal Production Investment Problem in Electricity Market

## 1, Introduction

> As the proportion of wind and solar generation capacity increases, their intermittency and stochasticity increase the need for resources able to compensate rapidly for substantial changes in the load/generation balance. Ensuring that enough generation capacity is available to meet reliably the peak demand is no longer sufficient. Generators and other resources (such as demand response and storage) must be sufficiently flexible to respond to these changes. Flexible generating units have large ramp-up and ramp- down rates, low minimum stable generation as well as short minimum up- and down­ times. Storage typically has a fast response time but must have a large enough energy capacity to sustain this response. Demand-side resources must demonstrate their dependability. [1]

## 2, Scenario and Profile

> Taking the need for flexibility into account when assessing whether a portfolio of generation and other resources will meet future needs for electricity cannot be done on the basis of a projected load-duration curve because such curves do not reflect the time-domain variations of the load. To ensure that a set of resources will be able to meet a system’s operating constraints, their operation must be simulated on a set of demand profiles that reflect a sufficiently wide range of anticipated system conditions. For a more detailed discussion of this issue, see Ma et al. (2013) or Ulbig and Andersson (2015). [1]

> Note that a discrete stochastic process can be represented by a finite set of actual vectors, referred to as scenarios, resulting from the combinations of all the discrete values that its component random variables can adopt. In mathematical terms, if $\lambda$ is a discrete stochastic process, it can be expressed as $\lambda  = {\lambda(\omega), \omega = 1, 2, ..., N_{\Omega}}$, where $\omega$ is the scenario index and $N_{\Omega}$ is the number of possible scenarios. In order for the discrete stochastic process to be perfectly determined, a probability of occurrence π(ω) needs to be associated with each realization $\lambda(\omega)$ such that $\sum_{\omega = 1}^{N_{\Omega}} \pi(\omega) = 1$. [2]

### Stochastic Process and Scenario

> A weakly stationary process is characterized by the fact that both the mean value and the variance are constant, while the auto-covariance function depends only on the time difference, i.e., by $(t_1 − t_2)$. [3]

> A stationary process is said to be ergodic if its ensemble averages equal appropriate time averages. By this definition we mean that any statistic of $X(t)$ can be determined from a single realization $x(t)$. This is a general requirement. In most applications we consider only specific statistics, as, e.g., the mean value. [3]

### Scenario Generation and Reduction

> To adequately describe a stochastic process, it is critical to generate a sufficient number of scenarios so that these scenarios cover the most plausible realizations of the considered stochastic process. To achieve this, it is generally required to generate a very large number of scenarios, which may render the associated stochastic programming problem computationally intractable. [2]

> It is thus required to develop procedures to reduce the number of scenarios initially generated. These procedures should retain most of the relevant information on the stochastic process contained in the original scenario set while reducing significantly its cardinality. [2]

## 3, Risk Management

### Distribution of Worse Case Scenario instead of Worst Case Scenario

## 4, Inter-Dependence of Multiple Stochastic Processes

> Decision-making problems related to electricity markets may be affected by stochastic processes that are statistically dependent. For instance, It is well-known that electricity prices and demand are strongly interrelated in such a way that periods of high/low prices often coincide with periods of high/low demand. [2]

## 5, Discrete instead of Continuous

> Solving optimization problems where uncertainty on input data is modeled by continuous stochastic processes is very difficult, or even impossible in many cases. In contrast, discrete stochastic processes can be easily embedded into an optimization problem using the deterministic equivalent problem. For this reason, prior to finding the solution of a stochastic programming problem, every continuous stochastic process is to be replaced by an approximate discrete one. [2]

## 6, References

1. Kirschen, D.S. and Strbac, G., 2018. Fundamentals of power system economics. John Wiley & Sons.
2. Conejo, A.J., Carrión, M. and Morales, J.M., 2010. Decision making under uncertainty in electricity markets (Vol. 1). New York: Springer.
3. Madsen, H., 2007. Time series analysis. Chapman and Hall/CRC.