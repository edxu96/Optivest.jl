
# Production Investment and Economic Dispatch (PIED) for Sustainable Energy System

The holder hosts Julia code I wrote for course 42002 at Technical
University of Denmark.

- The model is formulated in [models.pdf](./models.pdf)
- Plots for results and sensitivity analysis can be found in
  https://rpubs.com/edxu96/PIED-Renewable

> As the proportion of wind and solar generation capacity increases,
> their intermittency and stochasticity increase the need for resources
> able to compensate rapidly for substantial changes in the
> load/generation balance. Ensuring that enough generation capacity is
> available to meet reliably the peak demand is no longer sufficient.
> Generators and other resources (such as demand response and storage)
> must be sufficiently flexible to respond to these changes. Flexible
> generating units have large ramp-up and ramp-down rates, low minimum
> stable generation as well as short minimum up- and down-­ times.
> Storage typically has a fast response time but must have a large
> enough energy capacity to sustain this response. Demand-side resources
> must demonstrate their dependability. [kirschen2018fundamentals]

## Discrete instead of Continuous

> Solving optimization problems where uncertainty on input data is
> modeled by continuous stochastic processes is very difficult, or even
> impossible in many cases. In contrast, discrete stochastic processes
> can be easily embedded into an optimization problem using the
> deterministic equivalent problem. For this reason, prior to finding
> the solution of a stochastic programming problem, every continuous
> stochastic process is to be replaced by an approximate discrete one.
> [conejo2010decision]

## Inter-Dependence of Multiple Stochastic Processes

> Decision-making problems related to electricity markets may be
> affected by stochastic processes that are statistically dependent. For
> instance, It is well-known that electricity prices and demand are
> strongly interrelated in such a way that periods of high/low prices
> often coincide with periods of high/low demand. [conejo2010decision]

## Reference

- Kirschen, D. S., & Strbac, G. (2018). Fundamentals of power system
  economics. John Wiley & Sons.
- Conejo, A. J., Carrión, M., & Morales, J. M. (2010). Decision making
  under uncertainty in electricity markets (Vol. 1). New York: Springer.
