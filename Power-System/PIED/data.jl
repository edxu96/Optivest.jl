## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


"Get the default data in the optimization"
function get_data(num_unit)
    ## Data for wind output and demand
    df_dk1 = CSV.read("./data/Electricity-Dispatch_DK1.csv")[1:(num_unit+1), 1:9]
    vec_demand = df_dk1[1:num_unit, :TotalLoad]
    vec_wind = df_dk1[1:num_unit, 5] + df_dk1[1:num_unit, 6]
    for i in 2:(num_unit - 1)
        if isequal(vec_demand[i], missing)
            vec_demand[i] = (vec_demand[i+1] + vec_demand[i-1]) / 2
        end
        if isequal(vec_wind[i], missing)
            vec_wind[i] = (vec_wind[i+1] + vec_wind[i-1]) / 2
        end
    end

    ## Investment cost of different generation technologies
    vec_c_fix = [441, 800] ./ 20 # [441, 2541] ./ 20
    c_fix_wind = 1000000 / 20 # !!! Cost of percent 8000000 * 50

    ##
    vec_c_var = [0.4, 0.2] # [0.4, 0.433]
    vec_ramp_rate_max = [1, 0.6]
    vec_min_rate = [0.23, 0.5]  # [0.5, 0.3]
    ## emission cost 25

    ## Data for EVs
    vec_eta_plus = repeat([0.94], 20)
    vec_eta_minus = repeat([0.886], 20)  # 0.086
    vec_u_plus_max = repeat([0.035], 20)  # 0.05
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


# "Get the default data in the optimization"
# function get_data(num_unit)
#     ## Data for wind output and demand
#     df_dk1 = CSV.read("./data/Electricity-Dispatch_DK1.csv")[1:(num_unit+1), 1:9]
#     vec_demand = df_dk1[1:num_unit, :TotalLoad]
#     vec_wind = df_dk1[1:num_unit, 5] + df_dk1[1:num_unit, 6]
#     for i in 2:(num_unit - 1)
#         if isequal(vec_demand[i], missing)
#             vec_demand[i] = (vec_demand[i+1] + vec_demand[i-1]) / 2
#         end
#         if isequal(vec_wind[i], missing)
#             vec_wind[i] = (vec_wind[i+1] + vec_wind[i-1]) / 2
#         end
#     end
#
#     ## Investment cost of different generation technologies
#     vec_c_fix = [441, 2541] ./ 20
#     c_fix_wind = 1000000 / 20 # !!! Cost of percent 8000000 * 50
#
#     ##
#     vec_c_var = [0.4, 0.433]
#     vec_ramp_rate_max = [1, 0.6]
#     vec_min_rate = [0.23, 0.5]  # [0.5, 0.3]
#     ## emission cost 25
#
#     ## Data for EVs
#     vec_eta_plus = repeat([0.94], 20)
#     vec_eta_minus = repeat([0.886], 20)  # 0.086
#     vec_u_plus_max = repeat([0.035], 20)  # 0.05
#     vec_u_minus_max = repeat([0.14], 20)
#     vec_l_min = repeat([0.0028], 20)
#     vec_l_max = repeat([0.07], 20)
#     vec_num = [28, 66, 68, 143, 160, 174, 188, 213, 227, 242, 244, 256, 303,
#         360, 368, 428, 471, 472, 526, 1102]
#
#     ## Data for driving patterns
#     mat_demand_weekend =
#         CSV.read("./data/demand-EV_weekend.csv")[1:20, 1:24] .* 0.0001666
#     mat_demand_weekday =
#         CSV.read("./data/demand-EV_weekday.csv")[1:20, 1:24] .* 0.0001666
#     mat_demand_ev = hcat(mat_demand_weekday, mat_demand_weekday,
#         mat_demand_weekday, mat_demand_weekday, mat_demand_weekday,
#         mat_demand_weekend, mat_demand_weekend, makeunique = true)
#
#     return vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
#         vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
#         vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
#         mat_demand_ev
# end
