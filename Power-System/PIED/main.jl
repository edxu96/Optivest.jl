## Main Julia Script for 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019

# using ExcelReaders
using JuMP
using GLPK
using CSV
using CPLEX
using PrettyTables
using DataFrames

# cd("/Users/edxu96/GitHub/Optivest.jl/Power-System/PIED")
include("optim_1.jl")
include("optim_2.jl")
include("func.jl")
include("data.jl")


# "Sensitivity analysis"
# function analyze_sense()
#     ## Sensitity Analysis of `c_fix_wind`
#     c_fix_wind = missing
#     vec_c_fix_wind = [5000, 50000, 500000]
#
#     for i = 1:3
#         c_fix_wind = vec_c_fix_wind[i]
#         optim(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
#             vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
#             vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
#             mat_demand_ev, vec_c_fix_wind[i]
#             )
#     end
# end


"Optimize model 1 and model 2, export the results"
function optim(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit)
    optim_mod_1(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, num_unit)

    optim_mod_2(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit)
end


function main()
    println("#### Start ####")

    ## Get the default data
    num_unit = 168  # 168
    vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev = get_data(num_unit)

    ## Optimize using default data
    wind_curtail_1, wind_curtail_2 = optim(vec_demand,
        vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit
        )

    ## Do sensitity analysis
    # analyze_sense()

    println("#### Done ####")
end


main()
