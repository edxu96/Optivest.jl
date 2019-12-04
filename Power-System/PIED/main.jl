## Main Julia Script for 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 4th, 2019

# using ExcelReaders
using JuMP
using GLPK
using CSV
using CPLEX
using PrettyTables
using DataFrames

# cd("/Users/edxu96/GitHub/Optivest.jl/Power-System/PIED")


"Get the default data in the optimization"
function get_data()
    ## Data for wind output and demand
    df_dk1 = CSV.read("./data/Electricity-Dispatch_DK1.csv")[1:8725, 1:9]
    vec_demand = df_dk1[1:169, :TotalLoad]
    vec_wind = df_dk1[1:169, 5] + df_dk1[1:169, 6]
    for i in 1:169
        if isequal(vec_demand[i], 1)
            vec_demand[i] = (vec_demand[i+1] + vec_demand[i-1]) / 2
        end
        if isequal(vec_wind[i], 1)
            vec_wind[i] = (vec_wind[i+1] + vec_wind[i-1]) / 2
        end
    end

    ## Default Parameters
    vec_c_fix = [441, 2541]
    vec_c_var = [0.4, 0.433]
    c_fix_wind = 50000 # !!! Cost of percent 8000000 * 50
    vec_ramp_rate_max = [1, 0.6]
    vec_min_rate = [0.23, 0.5]

    ## Data for EVs
    vec_eta_plus = repeat([0.94], 20)
    vec_eta_minus = repeat([0.886], 20)
    vec_u_plus_max = repeat([0.035], 20)
    vec_u_minus_max = repeat([0.14], 20)
    vec_l_min = repeat([0.0028], 20)
    vec_l_max = repeat([0.07], 20)
    vec_num = [28, 66, 68, 143, 160, 174, 188, 213, 227, 242, 244, 256, 303,
        360, 368, 428, 471, 472, 526, 1102]

    ## Data for driving patterns
    mat_demand_weekend =
        CSV.read("./data/demand-EV_weekend.csv")[1:20, 1:24] .* 0.0001666
    mat_demand_weekday =
        CSV.read("./data/demand-EV_weekday.csv")[1:20, 1:24] .* 0.0001666
    mat_demand_ev = hcat(mat_demand_weekday, mat_demand_weekday,
        mat_demand_weekday, mat_demand_weekday, mat_demand_weekday,
        mat_demand_weekend, mat_demand_weekend, makeunique = true)

    return vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev
end


"Optimize model 1 and model 2, export the results"
function optim(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev,
        )
    ## Optimize model 1
    mat_x_result_1, mat_result_1 = optim_mod_1(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate
        )

    ## Optimize model 2
    mat_x_result_2, mat_u_plus_result, mat_u_minus_result, mat_l_result,
        mat_result_2 = optim_mod_2(
            vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
            vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
            vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
            mat_demand_ev
            )

    return mat_x_result_1, mat_result_1, mat_x_result_2, mat_u_plus_result,
        mat_u_minus_result, mat_l_result, mat_result_2
end


function export(name_para, para)
    CSV.write(
        "./results/" * name_para * "/" *  string(para) * "/mat_x_result_1.csv",
        DataFrame(mat_x_result_1'), writeheader = false
        )
    CSV.write(
        "./results/" * string(para) * "/mat_result_1.csv", DataFrame(mat_result_1),
        writeheader = false
        )

    ## Store
    CSV.write(
        "./results/" * string(para) * "/mat_x_result_2.csv", DataFrame(mat_x_result_2'),
         writeheader = false
        )
    CSV.write(
        "./results/" * string(para) * "/mat_u_result.csv",
        DataFrame(mat_u_plus_result' - mat_u_minus_result'),
        writeheader = false
        )
    CSV.write(
        "./results/" * string(para) * "/mat_l_result.csv", DataFrame(mat_l_result'),
        writeheader = false
        )
    CSV.write(
        "./results/" * string(para) * "/mat_result_2.csv", DataFrame(mat_result_2),
        writeheader = false
        )
end


"Sensitivity analysis"
function analyze_sense()
    ## Sensitity Analysis of `c_fix_wind`
    c_fix_wind = missing
    vec_c_fix_wind = [5000, 50000, 500000]

    for i = 1:3
        c_fix_wind = vec_c_fix_wind[i]
        optim(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
            vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
            vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
            mat_demand_ev, vec_c_fix_wind[i]
            )
    end
end


function main()
    ## Include models in `optim.jl`
    include("optim.jl")

    ## Get the default data
    vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var, vec_ramp_rate_max,
        vec_min_rate, vec_eta_plus, vec_eta_minus, vec_u_plus_max,
        vec_u_minus_max, vec_l_min, vec_l_max, vec_num, mat_demand_ev =
        get_data()

    ## Optimize using default data
    optim(vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, c_fix_wind
        )

    ## Do sensitity analysis
    # analyze_sense()
end


main()
