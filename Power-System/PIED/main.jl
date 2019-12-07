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


function optim(dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev,
        num_unit, whe_print_result)
    ## Convert the data for model
    vec_c_fix, c_fix_wind, vec_c_var, vec_ramp_rate_max, vec_min_rate,
        vec_eta_plus, vec_eta_minus, vec_u_plus_max, vec_u_minus_max,
        vec_l_min, vec_l_max = get_data_for_model(dict_input)

    let
    vec_result_1 = optim_mod_1(vec_demand, vec_wind, vec_c_fix, c_fix_wind,
        vec_c_var, vec_ramp_rate_max, vec_min_rate, num_unit, whe_print_result)
    end

    let
    vec_result_2 = optim_mod_2(vec_demand, vec_wind, vec_c_fix, c_fix_wind,
        vec_c_var, vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit, whe_print_result)
    end

    return vec_result_1, vec_result_2
end


function analyze_sensitivity(vec_sensible, whi_sensible, whe_subsidy,
        dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit,
        whe_print_result)

    df_result = DataFrame(name = String[], value = Float64[],
        sensitivity = Float64[], whe_sub = Bool[], whe_ev = Bool[])

    for i in vec_sensible
        dict_input[whi_sensible] = i
        println(dict_input[whi_sensible])

            vec_result_1 = [0 0 0 0 0]
            vec_result_2 = [0 0 0 0 0]
            vec_result_1, vec_result_2 = optim(dict_input, vec_demand, vec_wind,
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
    num_unit = 360 * 24  # 168 360 * 24
    whe_subsidy = true

    ## Get the data
    dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev =
        get_data(whe_subsidy, num_unit)

    ## No Sensitity Analysis
    whe_print_result = true
    optim(dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit,
        whe_print_result)

    ## Sensitity Analysis
    whe_print_result = false
    vec_sensible = [52000000] ./ 20
    # vec_sensible = collect(0.995:0.001:1.005) .* 52000000 ./ 20
    whi_sensible = "c_fix_wind"

    # vec_sensible = collect(0.7:0.05:1.1) * 441 ./ 20
    # whi_sensible = "c_fix_gt"

    analyze_sensitivity(vec_sensible, whi_sensible, whe_subsidy, dict_input,
        vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit,
        whe_print_result)

    println("#### Done ####")
end


main()
