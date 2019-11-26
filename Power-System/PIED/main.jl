## Julia Script for 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Nov 15th, 2019

# using ExcelReaders
using JuMP
using GLPK
using CSV
using CPLEX

# cd("/Users/edxu96/GitHub/Optivest.jl/Power-System/PIED")


function value_vec(vec_x::Union{Array{VariableRef,1}, VariableRef})
    if isa(vec_x, VariableRef)
        vec_value = value(vec_x)
    else
        vec_value = [value(vec_x[i]) for i = 1:length(vec_x)]
    end

    return vec_value
end


# function dual_vec(vec_cons)
#     return [dual(vec_cons[i]) for i = 1:length(vec_cons)]
# end


function optim_mod_1(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate
        )
    model = Model(with_optimizer(GLPK.Optimizer))

    @variable(model, mat_x[1:2, 1:168] >= 0)
    @variable(model, vec_cap[1:2] >= 0)
    @variable(model, 0 <= frac_wind <= 1)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:168) +
        sum(vec_cap[i] * vec_c_fix[i] for i = 1:2) +
        c_fix_wind * frac_wind
        )
    @constraint(model, mat_cons_1[j = 1:2, t = 1:167],
        - vec_ramp_rate_max[j] * vec_cap[j] <= mat_x[j, t+1] - mat_x[j, t]
        )  # Ramping down ability
    @constraint(model, vec_cons_2[t = 1:168],
        mat_x[1, t] + mat_x[2, t] >= vec_demand[t] - frac_wind * vec_wind[t]
        )  # Satisfy the demand
    @constraint(model, vec_cons_3[i = 1:2, t = 1:168],
        mat_x[i, t] <= vec_cap[i]
        )
    @constraint(model, mat_cons_4[i = 1:2, t = 1:167],
        mat_x[i, t+1] - mat_x[i, t] <= vec_ramp_rate_max[i] * vec_cap[i]
        )  # Ramping up ability
    @constraint(model, vec_cons_5[i = 1:2, t = 1:168],
        mat_x[i, t] >= vec_min_rate[i] * vec_cap[i]
        )  # Min load

    optimize!(model)
    # vec_result_u = dual_vec([vec_cons_1, vec_cons_2, vec_cons_3, vec_cons_4])
    obj = objective_value(model)
    mat_x_result = [value(mat_x[j, i]) for j = 1:2, i = 1:168]
    vec_cap_result = value_vec(vec_cap)
    frac_wind_result = value(frac_wind)

    return obj, mat_x_result, vec_cap_result, frac_wind_result
end


## Optimize the second model for BEVs
function optim_mod_2(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev
        )

    model = Model(with_optimizer(CPLEX.Optimizer))
    @variable(model, mat_x[1:2, 1:168] >= 0)
    @variable(model, vec_cap[1:2] >= 0)
    @variable(model, 0 <= frac_wind <= 1)
    @variable(model, mat_u_plus[1:20, 1:168] >= 0)
    @variable(model, mat_u_minus[1:20, 1:168] >= 0)
    @variable(model, mat_l[1:20, 1:168] >= 0)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:168) +
            sum(vec_cap[i] * vec_c_fix[i] for i = 1:2) +
            c_fix_wind * frac_wind
        )

    ## Basic constraints
    @constraint(model, mat_cons_1[j = 1:2, t = 1:167],
        - vec_ramp_rate_max[j] * vec_cap[j] <= mat_x[j, t+1] - mat_x[j, t]
        )  # Ramping down ability
    @constraint(model, vec_cons_2[t = 1:168],
        mat_x[1, t] + mat_x[2, t] +
            sum(mat_u_minus[g, t] * vec_eta_minus[g] * vec_num[g]
            for g = 1:20) >= vec_demand[t] - frac_wind * vec_wind[t] +
            sum(mat_u_plus[g, t] * vec_num[g] for g = 1:20)
        )  # Satisfy the demand
    @constraint(model, vec_cons_3[i = 1:2, t = 1:168],
        mat_x[i, t] <= vec_cap[i]
        )
    @constraint(model, mat_cons_4[i = 1:2, t = 1:167],
        mat_x[i, t+1] - mat_x[i, t] <= vec_ramp_rate_max[i] * vec_cap[i]
        )  # Ramping up ability
    @constraint(model, vec_cons_5[i = 1:2, t = 1:168],
        mat_x[i, t] >= vec_min_rate[i] * vec_cap[i]
        )  # Min load

    ## Additional constraints for EVs
    @constraint(model, vec_cons_6[g = 1:20, t = 1:167],
        mat_l[g, t+1] == mat_l[g, t] + 1 * mat_u_plus[g, t] * vec_eta_plus[g] -
            1 * mat_u_minus[g, t] - 1 * mat_demand_ev[g, t]
        )  # Update the energy level
    @constraint(model, vec_cons_7[g = 1:20, t = 1:168],
        vec_l_min[g] <= mat_l[g, t]
        )  # Lower limit of energy level
    @constraint(model, vec_cons_8[g = 1:20, t = 1:168],
        vec_l_max[g] >= mat_l[g, t]
        )  # Upper limit of energy level
    @constraint(model, vec_cons_9[g = 1:20, t = 1:168],
        mat_u_plus[g, t] <= vec_u_plus_max[g]
        )  # Upper limit of charging
    @constraint(model, vec_cons_10[g = 1:20, t = 1:168],
        mat_u_minus[g, t] * vec_eta_minus[g] <= vec_u_minus_max[g]
        )  # Upper limit of discharging
    @constraint(model, vec_cons_11[g = 1:20, t = 1:168],
        mat_u_plus[g, t] * mat_demand_ev[g, t] == 0
        )
    @constraint(model, vec_cons_12[g = 1:20, t = 1:168],
        mat_u_minus[g, t] * mat_demand_ev[g, t] == 0
        )

    optimize!(model)
    # vec_result_u = dual_vec([vec_cons_1, vec_cons_2, vec_cons_3, vec_cons_4])
    obj = objective_value(model)
    mat_x_result = [value(mat_x[j, i]) for j = 1:2, i = 1:168]
    vec_cap_result = value_vec(vec_cap)
    frac_wind_result = value(frac_wind)

    return obj, mat_x_result, vec_cap_result, frac_wind_result
end


function get_data()
    vec_demand = CSV.read("../data/demand.csv")[!, 2]
    vec_wind = CSV.read("../data/wind.csv")[!, 2]
    vec_c_fix = [441, 2541]
    vec_c_var = [0.4, 0.433]
    c_fix_wind = 8000000 * 50  # !!! Cost of percent
    vec_ramp_rate_max = [1, 0.6]
    vec_min_rate = [0.23, 0.5]
    vec_eta_plus = repeat([0.94], 20)
    vec_eta_minus = repeat([0.886], 20)
    vec_u_plus_max = repeat([0.14], 20)
    vec_u_minus_max = repeat([0.035], 20)
    vec_l_min = repeat([0.0028], 20)
    vec_l_max = repeat([0.07], 20)
    vec_num = [28, 66, 68, 143, 160, 174, 188, 213, 227, 242, 244, 256, 303,
        360, 368, 428, 471, 472, 526, 1102]

    mat_demand_weekend =
        CSV.read("../data/demand-EV_weekend.csv")[1:20, 1:24] .* 0.0001666
    mat_demand_weekday =
        CSV.read("../data/demand-EV_weekday.csv")[1:20, 1:24] .* 0.0001666
    mat_demand_ev = hcat(mat_demand_weekday, mat_demand_weekday,
        mat_demand_weekday, mat_demand_weekday, mat_demand_weekday,
        mat_demand_weekend, mat_demand_weekend, makeunique = true)

    return vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev
end


function main()
    vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var, vec_ramp_rate_max,
        vec_min_rate, vec_eta_plus, vec_eta_minus, vec_u_plus_max,
        vec_u_minus_max, vec_l_min, vec_l_max, vec_num, mat_demand_ev =
        get_data()
        
    obj, mat_x_result, vec_cap_result, frac_wind_result = optim_mod_1(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate
        )

    obj, mat_x_result, vec_cap_result, frac_wind_result = optim_mod_2(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev
        )
    return obj, mat_x_result, vec_cap_result, frac_wind_result
end


obj, mat_x_result, vec_cap_result, frac_wind_result = main()
