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
include("data.jl")


"Get the optimized value of decision vector."
function value_vec(vec_x::Union{Array{VariableRef,1}, VariableRef})
    if isa(vec_x, VariableRef)
        vec_value = value(vec_x)
    else
        vec_value = [value(vec_x[i]) for i = 1:length(vec_x)]
    end

    return vec_value
end


function optim(vec_demand, vec_wind, dict_input, vec_num, mat_demand_ev,
        num_unit, whe_print_result)

    vec_c_fix, c_fix_wind, vec_c_var, vec_ramp_rate_max, vec_min_rate,
        vec_eta_plus, vec_eta_minus, vec_u_plus_max, vec_u_minus_max,
        vec_l_min, vec_l_max, scale_fleet = get_data_for_model(dict_input)

    vec_result_1 = optim_mod_1(vec_demand, vec_wind, vec_c_fix, c_fix_wind,
        vec_c_var, vec_ramp_rate_max, vec_min_rate, num_unit,
        whe_print_result)

    vec_result_2 = optim_mod_2(vec_demand, vec_wind, vec_c_fix, c_fix_wind,
        vec_c_var, vec_ramp_rate_max, vec_min_rate, vec_eta_plus,
        vec_eta_minus, vec_u_plus_max, vec_u_minus_max, vec_l_min,
        vec_l_max, vec_num, mat_demand_ev, num_unit, whe_print_result,
        scale_fleet)

    return vec_result_1, vec_result_2
end

"Do sensitivity analysis."
function analyze_sensitivity(vec_sensible, whi_sensible, whe_subsidy,
        dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit,
        whe_print_result)

    df_result = DataFrame(name = String[], value = Float64[],
        sensitivity = Float64[], whe_sub = Bool[], whe_ev = Bool[])

    for i in vec_sensible
        dict_input[whi_sensible] = i

        ## Optimize model 1
        vec_result_1, vec_result_2 = optim(vec_demand, vec_wind, dict_input,
            vec_num, mat_demand_ev, num_unit, whe_print_result)

        push!(df_result, ["y_gt", vec_result_1[1], i, whe_subsidy, false])
        push!(df_result, ["y_bio", vec_result_1[2], i, whe_subsidy, false])
        push!(df_result, ["z", vec_result_1[3], i, whe_subsidy, false])
        push!(df_result, ["obj", vec_result_1[4], i, whe_subsidy, false])
        push!(df_result, ["curtail", vec_result_1[5], i, whe_subsidy, false])

        push!(df_result, ["y_gt", vec_result_2[1], i, whe_subsidy, true])
        push!(df_result, ["y_bio", vec_result_2[2], i, whe_subsidy, true])
        push!(df_result, ["z", vec_result_2[3], i, whe_subsidy, true])
        push!(df_result, ["obj", vec_result_2[4], i, whe_subsidy, true])
        push!(df_result, ["curtail", vec_result_2[5], i, whe_subsidy, true])
    end

    ## Print the result
    pretty_table(df_result)

    ## Export the result
    CSV.write("./results/df_result_sensitivity_" * whi_sensible * ".csv",
        df_result, writeheader = false)

    return df_result
end


function main()
    println("#### Start ####")

    ## Get the default data
    num_unit = 7 * 24  # 168 360 * 24
    whe_subsidy = true

    ## Get the data
    dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev =
        get_data(whe_subsidy, num_unit)

    ## No Sensitity Analysis
    whe_print_result = true
    optim(vec_demand, vec_wind, dict_input, vec_num, mat_demand_ev,
        num_unit, whe_print_result)

    ## Sensitity Analysis
    # whe_print_result = false

    # vec_sensible = collect(0.995:0.001:1.005) .* 52000000 ./ 20
    # whi_sensible = "c_fix_wind"

    # vec_sensible = collect(0.995:0.001:1.005) * 441 ./ 20
    # whi_sensible = "c_fix_gt"

    # vec_sensible = collect(0.995:0.001:1.005) * 800 ./ 20
    # whi_sensible = "c_fix_bio"

    # vec_sensible = collect(0.995:0.001:1.005) * 0.5
    # whi_sensible = "c_var_gt"

    # vec_sensible = collect(0.995:0.001:1.005) * 0.433
    # whi_sensible = "c_var_bio"

    # vec_sensible = collect(0:0.5:3) * 1
    # whi_sensible = "scale_fleet"
    #
    # analyze_sensitivity(vec_sensible, whi_sensible, whe_subsidy, dict_input,
    #     vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit,
    #     whe_print_result)

    println("#### Done ####")
end


main()
