## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


"Get the optimized results from model 2."
function get_result_optim_mod_2(vec_wind, vec_demand, num_unit, vec_num, model,
        vec_y, z, mat_x, mat_u_plus, mat_u_minus, mat_l)
    obj_result = objective_value(model)
    vec_y_result = value_vec(vec_y)
    z_result = value(z)

    mat_x_result = [value(mat_x[j, t]) for j = 1:2, t = 1:num_unit]
    mat_u_plus_result = [value(mat_u_plus[g, t]) for g = 1:20, t = 1:num_unit]
    mat_u_minus_result = [value(mat_u_minus[g, t]) for g = 1:20,
        t = 1:num_unit]
    mat_l_result = [value(mat_l[g, t]) for g = 1:20, t = 1:num_unit]

    ## Combine the results of charging and discharging together
    mat_u_result = mat_u_plus_result' - mat_u_minus_result'

    ## Aggregate the charging and discharing
    vec_u_result = vec_demand
    for t = 1:num_unit
        vec_u_result[t] = sum(mat_u_result[t, i] * vec_num[i] for i = 1:20)
    end

    ## Calculate the average wind_curtail over the year
    vec_wind_net = vec_demand + vec_u_result - mat_x_result'[:, 1] -
        mat_x_result'[:, 2]
    wind_curtail = sum(vec_wind - vec_wind_net) / num_unit * 365 * 24

    return obj_result, vec_y_result, z_result, wind_curtail, mat_x_result,
        vec_wind_net, vec_u_result, mat_l_result
end


"Export the results from model 2 to CSV files."
function export_result_mod_2(name_para, para, mat_x_result, vec_u_result,
        mat_l_result, vec_result, vec_wind_net)
    CSV.write(
        "./results/" * name_para * "-" * string(para) * "/mat_x_result_2.csv",
        DataFrame(mat_x_result'), writeheader = false
        )
    CSV.write(
        "./results/" * name_para * "-" * string(para) * "/mat_l_result.csv",
        DataFrame(mat_l_result'), writeheader = false
        )
    CSV.write(
        "./results/" * name_para * "-" * string(para) * "/vec_result_2.csv",
        DataFrame(vec_result), writeheader = false
        )
    CSV.write(
        "./results/" * name_para * "-" * string(para) * "/mat_wind_u.csv",
        DataFrame(wind_net = vec_wind_net, charging = vec_u_result),
        writeheader = false
        )
end


"Optimal Investment and Economic Dispatch with BEVs"
function optim_mod_2(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit, whe_print_result
        )

    model = Model(with_optimizer(CPLEX.Optimizer, CPX_PARAM_SCRIND = 0))
    @variable(model, mat_x[1:2, 1:num_unit] >= 0)
    @variable(model, vec_y[1:2] >= 0)
    @variable(model, 0 <= z <= 1)
    @variable(model, mat_u_plus[1:20, 1:num_unit] >= 0)
    @variable(model, mat_u_minus[1:20, 1:num_unit] >= 0)
    @variable(model, mat_l[1:20, 1:num_unit] >= 0)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:num_unit) /
        num_unit * 365 * 24 + sum(vec_y[i] * vec_c_fix[i] for i = 1:2) +
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
        1 * mat_u_minus[g, t] - 1 * mat_demand_ev[g, t])
        # Update the energy level
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
    obj_result, vec_y_result, z_result, wind_curtail, mat_x_result,
        vec_wind_net, vec_u_result, mat_l_result = get_result_optim_mod_2(
        vec_wind, vec_demand, num_unit, vec_num, model, vec_y, z, mat_x,
        mat_u_plus, mat_u_minus, mat_l)

    vec_result = get_vec_result(obj_result, vec_y_result, z_result, wind_curtail)

    if whe_print_result
        pretty_table(vec_result, ["y_gt" "y_bio" "z" "obj" "curtail"];
            formatter = ft_round(4))
        export_result_mod_2("c_fix_wind", 1000000, mat_x_result, vec_u_result,
            mat_l_result, vec_result, vec_wind_net)
    end

    return vec_result
end
