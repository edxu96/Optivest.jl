## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


"Get the optimized results from model 1."
function get_result_optim_mod_1(vec_wind, vec_demand, num_unit, model, vec_y,
        z, mat_x)
    obj_result = objective_value(model)
    vec_y_result = value_vec(vec_y)
    z_result = value(z)

    mat_x_result = [value(mat_x[j, i]) for j = 1:2, i = 1:num_unit]
    vec_wind_net = vec_demand - mat_x_result'[:, 1] - mat_x_result'[:, 2]

    ## Calculate the average wind_curtail over the year
    wind_curtail = sum(vec_wind - vec_wind_net) / num_unit * 365 * 24

    return obj_result, vec_y_result, z_result, wind_curtail, mat_x_result
end


"Export the results from model 1 to CSV files."
function export_result_mod_1(name_para, para, mat_x_result_1, vec_result_1)
    CSV.write(
        "./results/" * name_para * "-" *  string(para) * "/mat_x_result_1.csv",
        DataFrame(mat_x_result_1'), writeheader = false
        )
    CSV.write(
        "./results/" * name_para * "-" * string(para) * "/vec_result_1.csv",
        DataFrame(vec_result_1), writeheader = false
        )
end


"Optimal Investment and Economic Dispatch without Storage Devices"
function optim_mod_1(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, num_unit
        )
    model = Model(with_optimizer(CPLEX.Optimizer, CPX_PARAM_SCRIND = 0))

    @variable(model, mat_x[1:2, 1:num_unit] >= 0)
    @variable(model, vec_y[1:2] >= 0)
    @variable(model, 0 <= z <= 1)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:num_unit) /
        num_unit * 365 * 24 + sum(vec_y[i] * vec_c_fix[i] for i = 1:2) +
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
    obj_result, vec_y_result, z_result, wind_curtail, mat_x_result =
        get_result_optim_mod_1(vec_wind, vec_demand, num_unit, model, vec_y,
        z, mat_x)

    vec_result = get_vec_result(obj_result, vec_y_result, z_result, wind_curtail)
    # pretty_table(vec_result, ["y_gt" "y_bio" "z" "obj" "curtail"];
        # formatter = ft_round(4))
    # export_result_mod_1("c_fix_wind", 1000000, mat_x_result, vec_result)

    return vec_result
end
