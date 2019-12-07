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


function analyze_sensitivity(vec_sensible, whi_sensible, whe_subsidy,
        dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit)

    df_result = DataFrame(name = String[], value = Int64[],
        sensitivity = Int64[], whe_sub = Bool[], whe_ev = Bool[])

    for i in vec_sensible
        dict_input[whi_sensible] = i
        vec_result_1, vec_result_2 = optim(dict_input, vec_demand, vec_wind,
            vec_num, mat_demand_ev, num_unit)

        push!(["y_gt", vec_result_1[1], i, whe_subsidy, false])
        push!(["y_bio", vec_result_1[2], i, whe_subsidy, false])
        push!(["z", vec_result_1[3], i, whe_subsidy, false])
        push!(["obj", vec_result_1[4], i, whe_subsidy, false])
        push!(["curtail", vec_result_1[5], i, whe_subsidy, false])

        push!(["y_gt", vec_result_1[1], i, whe_subsidy, true])
        push!(["y_bio", vec_result_1[2], i, whe_subsidy, true])
        push!(["z", vec_result_1[3], i, whe_subsidy, true])
        push!(["obj", vec_result_1[4], i, whe_subsidy, true])
        push!(["curtail", vec_result_1[5], i, whe_subsidy, true])
    end

    return df_result
end


function optim(dict_input, vec_demand, vec_wind, vec_num,
        mat_demand_ev, num_unit)
    ## Convert the data for model
    vec_c_fix, c_fix_wind, vec_c_var, vec_ramp_rate_max, vec_min_rate,
        vec_eta_plus, vec_eta_minus, vec_u_plus_max, vec_u_minus_max,
        vec_l_min, vec_l_max = get_data_for_model(dict_input)

    vec_result_1 = optim_mod_1(vec_demand, vec_wind, vec_c_fix, c_fix_wind,
        vec_c_var, vec_ramp_rate_max, vec_min_rate, num_unit)
    vec_result_2 = optim_mod_2(vec_demand, vec_wind, vec_c_fix, c_fix_wind,
        vec_c_var, vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, num_unit)

    return vec_result_1, vec_result_2
end


function main()
    println("#### Start ####")

    ## Get the default data
    num_unit = 168  # 168
    whe_subsidy = true

    ## Get the data
    dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev =
        get_data(whe_subsidy)

    ##
    # optim(dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit)

    ## Sensitity Analysis
    vec_sensible = [52000000] ./ 20
    whi_sensible = "c_fix_wind"
    df_result = analyze_sensitivity(vec_sensible, whi_sensible, whe_subsidy,
        dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev, num_unit)

    pretty_table(df_result)

    println("#### Done ####")
end


main()
