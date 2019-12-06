## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


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

function print_result(model, vec_y, z)

    obj_result = objective_value(model)
    vec_y_result = value_vec(vec_y)
    z_result = value(z)

    mat_result = [obj_result vec_y_result[1] vec_y_result[2] z_result]
    pretty_table(mat_result, ["obj" "y_gt" "y_bio" "z"])

    return mat_result
end


"""
Optimal Investment and Economic Dispatch without Storage Devices
"""
function optim_mod_1(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, num_unit
        )
    model = Model(with_optimizer(GLPK.Optimizer))

    @variable(model, mat_x[1:2, 1:num_unit] >= 0)
    @variable(model, vec_y[1:2] >= 0)
    @variable(model, 0 <= z <= 1)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:num_unit) /
        num_unit * 365 + sum(vec_y[i] * vec_c_fix[i] for i = 1:2) +
        c_fix_wind * z
        )
    @constraint(model, mat_cons_1[j = 1:2, t = 1:(num_unit - 1)],
        - vec_ramp_rate_max[j] * vec_y[j] <= mat_x[j, t+1] - mat_x[j, t]
        )  # Ramping down ability
    @constraint(model, vec_cons_2[t = 1:num_unit],
        mat_x[1, t] + mat_x[2, t] >= vec_demand[t] - z * vec_wind[t]
        )  # Satisfy the demand
    @constraint(model, vec_cons_3[i = 1:2, t = 1:num_unit],
        mat_x[i, t] <= vec_y[i]
        )
    @constraint(model, mat_cons_4[i = 1:2, t = 1:(num_unit - 1)],
        mat_x[i, t+1] - mat_x[i, t] <= vec_ramp_rate_max[i] * vec_y[i]
        )  # Ramping up ability
    @constraint(model, vec_cons_5[i = 1:2, t = 1:num_unit],
        mat_x[i, t] >= vec_min_rate[i] * vec_y[i]
        )  # Min load

    optimize!(model)

    ## Get the optimization result
    mat_result = print_result(model, vec_y, z)
    # vec_result_u = dual_vec([vec_cons_1, vec_cons_2, vec_cons_3, vec_cons_4])
    mat_x_result = [value(mat_x[j, i]) for j = 1:2, i = 1:num_unit]

    return mat_x_result, mat_result
end


"""
Optimal Investment and Economic Dispatch with BEVs
"""
function optim_mod_2(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit
        )

    model = Model(with_optimizer(CPLEX.Optimizer))
    @variable(model, mat_x[1:2, 1:num_unit] >= 0)
    @variable(model, vec_y[1:2] >= 0)
    @variable(model, 0 <= z <= 1)
    @variable(model, mat_u_plus[1:20, 1:num_unit] >= 0)
    @variable(model, mat_u_minus[1:20, 1:num_unit] >= 0)
    @variable(model, mat_l[1:20, 1:num_unit] >= 0)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:num_unit) /
        num_unit * 365 + sum(vec_y[i] * vec_c_fix[i] for i = 1:2) +
        c_fix_wind * z
        )

    ## Basic constraints
    @constraint(model, mat_cons_1[j = 1:2, t = 1:(num_unit - 1)],
        - vec_ramp_rate_max[j] * vec_y[j] <= mat_x[j, t+1] - mat_x[j, t]
        )  # Ramping down ability
    @constraint(model, vec_cons_2[t = 1:num_unit],
        mat_x[1, t] + mat_x[2, t] +
            sum(mat_u_minus[g, t] * vec_eta_minus[g] * vec_num[g]
            for g = 1:20) >= vec_demand[t] - z * vec_wind[t] +
            sum(mat_u_plus[g, t] * vec_num[g] for g = 1:20)
        )  # Satisfy the demand
    @constraint(model, vec_cons_3[i = 1:2, t = 1:num_unit],
        mat_x[i, t] <= vec_y[i]
        )
    @constraint(model, mat_cons_4[i = 1:2, t = 1:(num_unit - 1)],
        mat_x[i, t+1] - mat_x[i, t] <= vec_ramp_rate_max[i] * vec_y[i]
        )  # Ramping up ability
    @constraint(model, vec_cons_5[i = 1:2, t = 1:num_unit],
        mat_x[i, t] >= vec_min_rate[i] * vec_y[i]
        )  # Min load

    ## Additional constraints for EVs
    @constraint(model, vec_cons_6[g = 1:20, t = 1:(num_unit - 1)],
        mat_l[g, t+1] == mat_l[g, t] + 1 * mat_u_plus[g, t] * vec_eta_plus[g] -
            1 * mat_u_minus[g, t] - 1 * mat_demand_ev[g, t]
        )  # Update the energy level
    @constraint(model, vec_cons_7[g = 1:20, t = 1:num_unit],
        vec_l_min[g] <= mat_l[g, t]
        )  # Lower limit of energy level
    @constraint(model, vec_cons_8[g = 1:20, t = 1:num_unit],
        vec_l_max[g] >= mat_l[g, t]
        )  # Upper limit of energy level
    @constraint(model, vec_cons_9[g = 1:20, t = 1:num_unit],
        mat_u_plus[g, t] <= vec_u_plus_max[g]
        )  # Upper limit of charging
    @constraint(model, vec_cons_10[g = 1:20, t = 1:num_unit],
        mat_u_minus[g, t] * vec_eta_minus[g] <= vec_u_minus_max[g]
        )  # Upper limit of discharging
    @constraint(model, vec_cons_11[g = 1:20, t = 1:num_unit],
        mat_u_plus[g, t] * mat_demand_ev[g, t] == 0
        )
    @constraint(model, vec_cons_12[g = 1:20, t = 1:num_unit],
        mat_u_minus[g, t] * mat_demand_ev[g, t] == 0
        )

    optimize!(model)

    ## Get the optimization result
    mat_result = print_result(model, vec_y, z)
    # vec_result_u = dual_vec([vec_cons_1, vec_cons_2, vec_cons_3, vec_cons_4])
    mat_x_result = [value(mat_x[j, t]) for j = 1:2, t = 1:num_unit]
    mat_u_plus_result = [value(mat_u_plus[g, t]) for g = 1:20, t = 1:num_unit]
    mat_u_minus_result = [value(mat_u_minus[g, t]) for g = 1:20, t = 1:num_unit]
    mat_l_result = [value(mat_l[g, t]) for g = 1:20, t = 1:num_unit]

    return mat_x_result, mat_u_plus_result, mat_u_minus_result, mat_l_result, mat_result
end


"Optimize model 1 and model 2, export the results"
function optim(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit
        )
    ## Optimize model 1
    mat_x_result_1, mat_result_1 = optim_mod_1(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, num_unit
        )

    ## Optimize model 2
    mat_x_result_2, mat_u_plus_result, mat_u_minus_result, mat_l_result,
        mat_result_2 = optim_mod_2(
            vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
            vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
            vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
            mat_demand_ev, num_unit
            )

    return mat_x_result_1, mat_result_1, mat_x_result_2, mat_u_plus_result,
        mat_u_minus_result, mat_l_result, mat_result_2
end
