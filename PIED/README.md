
# Production Investment and Economic Dispatch (PIED) for Sustainable Energy System

The holder hosts Julia code I wrote for course 42002 at Technical
University of Denmark.

- The model is formulated in [models.pdf](./models.pdf)
- Plots for results and sensitivity analysis can be found in
  https://rpubs.com/edxu96/PIED-Renewable

The model is mostly based on the second section of
[trine2011optimal](#reference). [bouffard2008stochastic](#reference) and
[ortega2010assessing](#reference) are relevant as well.

Remember to specify units of variables and constants.

> As the proportion of wind and solar generation capacity increases, their
> intermittency and stochasticity increase the need for resources able to
> compensate rapidly for substantial changes in the load/generation balance.
> Ensuring that enough generation capacity is available to meet reliably the
> peak demand is no longer sufficient. Generators and other resources (such as
> demand response and storage) must be sufficiently flexible to respond to
> these changes. Flexible generating units have large ramp-up and ramp-down
> rates, low minimum stable generation as well as short minimum up- and down-­
> times. Storage typically has a fast response time but must have a large
> enough energy capacity to sustain this response. Demand-side resources must
> demonstrate their dependability. [kirschen2018fundamentals](#reference)

## Discrete instead of Continuous

> Solving optimization problems where uncertainty on input data is modeled by
> continuous stochastic processes is very difficult, or even impossible in many
> cases. In contrast, discrete stochastic processes can be easily embedded into
> an optimization problem using the deterministic equivalent problem. For this
> reason, prior to finding the solution of a stochastic programming problem,
> every continuous stochastic process is to be replaced by an approximate
> discrete one. [conejo2010decision](#reference)

## Inter-Dependence of Multiple Stochastic Processes

> Decision-making problems related to electricity markets may be affected by
> stochastic processes that are statistically dependent. For instance, It is
> well-known that electricity prices and demand are strongly interrelated in
> such a way that periods of high/low prices often coincide with periods of
> high/low demand. [conejo2010decision](#reference)

## Reference

- [kirschen2018fundamentals] Kirschen, D. S., & Strbac, G. (2018). Fundamentals
  of power system economics. John Wiley & Sons.
- [conejo2010decision] Conejo, A. J., Carrión, M., & Morales, J. M. (2010).
  Decision making under uncertainty in electricity markets (Vol. 1). New York:
  Springer.
- [trine2011optimal] Kristoffersen, T. K., Capion, K., & Meibom, P. (2011).
  Optimal charging of electric drive vehicles in a market environment. Applied
  Energy, 88(5), 1940-1948.
- [bouffard2008stochastic] Bouffard, F., & Galiana, F. D. (2008, July).
  Stochastic security for operations planning with significant wind power
  generation. In 2008 IEEE Power and Energy Society General Meeting-Conversion
  and Delivery of Electrical Energy in the 21st Century (pp. 1-11). IEEE.
- [ortega2010assessing] Ortega-Vazquez, M. A., & Kirschen, D. S. (2010).
  Assessing the impact of wind power generation on operating costs. IEEE
  Transactions on Smart Grid, 1(3), 295-301.
