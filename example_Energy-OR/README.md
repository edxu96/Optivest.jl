
# OR-Energy, DTU42002

## Description

For now, you may leave out unit commitment considerations. The model should include investments in both conventional power plants and wind power. To focus on the interactions between various technologies, in particular wind power and other technologies, the model should have an hourly time resolution. In principle, the time horizon of the model could be a year or a number of years. However, to facilitate computations, consider only a small number of representative weeks in a year, for example an average week during each season. Justify any other model assumptions you make.

Construct a data set for the technologies included in the model. Note that if the time horizon is a year, investment costs can be annualized, and operations costs can be multiplied by the number of weeks in a year, a representative week covers (for an average week during each season, approximately 13). Wind power production and electricity demand can be found at www.energinet.dk, and technology data, fuel and emission prices at www.ens.dk.

Solve the model to find the optimal power system configurations with varying parameters on fuel and emission prices to do sensitivity analysis. You may for instance, solve the model with fuel and emission prices increased and decreased by 10%.

## Model

<p align="center"><img src="/example_Wind/tex/033610b6d74f2df5bf349adf313ebb1d.svg?invert_in_darkmode&sanitize=true" align=middle width=346.75866555pt height=61.150654949999996pt/></p>

_Table 1, summary of sets_

<p align="center"><img src="/example_Wind/tex/6a77557d708cecddec59c4fbf3ed9c2c.svg?invert_in_darkmode&sanitize=true" align=middle width=489.87525344999995pt height=61.150654949999996pt/></p>

_Table 2, summary of decision variables_

<p align="center"><img src="/example_Wind/tex/d32ec45d8bdd4b198fb0f14c5d0a3822.svg?invert_in_darkmode&sanitize=true" align=middle width=618.1574652pt height=100.60270935pt/></p>

_Table 3, summary of constants_

<p align="center"><img src="/example_Wind/tex/22ac6a6f64d7e474ee269332d34936d5.svg?invert_in_darkmode&sanitize=true" align=middle width=343.11439305pt height=140.63485095pt/></p>
