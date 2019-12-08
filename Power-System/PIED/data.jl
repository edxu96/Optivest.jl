## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


"""
Import and tidy the data about electricity demand and historical wind power
    output
"""
function get_data_demand_wind(num_unit)
    ## Data for wind output and demand
    df_dk1 = CSV.read("./data/Electricity-Dispatch_DK1.csv")[1:(num_unit+1),
        1:9]
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

    return vec_demand, vec_wind
end


"Import and tidy the data about the demand of electric vehicle driving"
function get_data_ev(num_unit)
    ## Data for EVs
    vec_num = [28, 66, 68, 143, 160, 174, 188, 213, 227, 242, 244, 256, 303,
        360, 368, 428, 471, 472, 526, 1102]

    ## Data for driving patterns
    mat_demand_weekend =
        CSV.read("./data/demand-EV_weekend.csv")[1:20, 1:24] .* 0.0001666
    mat_demand_weekday =
        CSV.read("./data/demand-EV_weekday.csv")[1:20, 1:24] .* 0.0001666

    mat_demand_ev = hcat(mat_demand_weekday, mat_demand_weekday,
        mat_demand_weekend, mat_demand_weekend, mat_demand_weekday,
        mat_demand_weekday, mat_demand_weekday,
        makeunique = true)
    mat_demand_ev = convert(Matrix, mat_demand_ev)

    ##
    mat_demand_ev = repeat(mat_demand_ev, 1, convert(Int64,
        floor(num_unit / 168) + 1))
    mat_demand_ev = mat_demand_ev[:, 1:num_unit]
    scale_fleet = 1  # To enlarge or shrink the number of BEVs

    return vec_num, mat_demand_ev, scale_fleet
end


"Get the dataset with subsidies in the optimization"
function get_data_subsidy(num_unit)
    vec_demand, vec_wind = get_data_demand_wind(num_unit)

    ## Investment cost of different generation technologies
    vec_c_fix = [441, 800] ./ 20 # [441, 2541] ./ 20
    c_fix_wind = 52000000 / 20 # !!! Cost of percent 8000000 * 50

    ## Variable cost
    vec_c_var = [0.5, 0.433] # [0.4, 0.433]
    vec_ramp_rate_max = [1, 0.6]
    vec_min_rate = [0.23, 0.5]  # [0.5, 0.3]

    ## Data for EVs
    vec_eta_plus = repeat([0.94], 20)
    vec_eta_minus = repeat([0.886], 20)  # 0.086
    vec_u_plus_max = repeat([0.035], 20)  # 0.05
    vec_u_minus_max = repeat([0.14], 20)
    vec_l_min = repeat([0.0028], 20)
    vec_l_max = repeat([0.07], 20)

    ## Get the data for electric vehicles
    vec_num, mat_demand_ev, scale_fleet = get_data_ev(num_unit)

    return vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, scale_fleet
end


"Get the default data in the optimization"
function get_data_default(num_unit)
    vec_demand, vec_wind = get_data_demand_wind(num_unit)

    ## Investment cost of different generation technologies
    vec_c_fix = [441, 2541] ./ 20
    c_fix_wind = 1000000 / 20 # !!! Cost of percent 8000000 * 50
    # c_fix_wind =  7600000000 / 20

    ##
    vec_c_var = [0.4, 0.433]
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

    vec_num, mat_demand_ev, scale_fleet = get_data_ev(num_unit)

    return vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
        vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
        vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
        mat_demand_ev, scale_fleet
end


"Get the data and transfer to dictionary."
function get_data(whe_subsidy, num_unit)
    if whe_subsidy
        println("Data with subsidy is the input.")
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
            vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
            vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
            mat_demand_ev, scale_fleet = get_data_subsidy(num_unit)
    else
        println("Data without subsidy is the input.")
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var,
            vec_ramp_rate_max, vec_min_rate, vec_eta_plus, vec_eta_minus,
            vec_u_plus_max, vec_u_minus_max, vec_l_min, vec_l_max, vec_num,
            mat_demand_ev, scale_fleet = get_data_default(num_unit)
    end

    ##
    dict_input = Dict(
        "c_fix_wind" => c_fix_wind,
        "c_fix_gt" => vec_c_fix[1],
        "c_fix_bio" => vec_c_fix[2],
        "c_var_gt" => vec_c_var[1],
        "c_var_bio" => vec_c_var[2],
        "ramp_rate_max_gt" => vec_ramp_rate_max[1],
        "ramp_rate_max_bio" => vec_ramp_rate_max[2],
        "min_rate_gt" => vec_min_rate[1],
        "min_rate_bio" => vec_min_rate[2],
        "eta_plus" => vec_eta_plus[1],
        "eta_minus" => vec_eta_minus[1],
        "u_plus_max" => vec_u_plus_max[1],
        "u_minus_max" => vec_u_minus_max[1],
        "l_min" => vec_l_min[1],
        "l_max" => vec_l_max[1],
        "num_unit" => num_unit,
        "scale_fleet" => scale_fleet
        )
    pretty_table(DataFrame(Name = [i for i in keys(dict_input)],
        Value = [i for i in values(dict_input)]))

    return dict_input, vec_demand, vec_wind, vec_num, mat_demand_ev
end


"Transfer the data back from changing in sensitivity analysis."
function get_data_for_model(dict_input)

    c_fix_wind = dict_input["c_fix_wind"]
    vec_c_fix = [dict_input["c_fix_gt"], dict_input["c_fix_bio"]]
    vec_c_var = [dict_input["c_var_gt"], dict_input["c_var_bio"]]
    vec_ramp_rate_max = [dict_input["ramp_rate_max_gt"],
        dict_input["ramp_rate_max_bio"]]
    vec_min_rate = [dict_input["min_rate_gt"], dict_input["min_rate_bio"]]
    scale_fleet = dict_input["scale_fleet"]

    vec_eta_plus = repeat([dict_input["eta_plus"]], 20)
    vec_eta_minus = repeat([dict_input["eta_minus"]], 20)  # 0.086
    vec_u_plus_max = repeat([dict_input["u_plus_max"]], 20)  # 0.05
    vec_u_minus_max = repeat([dict_input["u_minus_max"]], 20)
    vec_l_min = repeat([dict_input["l_min"]], 20)
    vec_l_max = repeat([dict_input["l_max"]], 20)

    return vec_c_fix, c_fix_wind, vec_c_var, vec_ramp_rate_max, vec_min_rate,
        vec_eta_plus, vec_eta_minus, vec_u_plus_max, vec_u_minus_max,
        vec_l_min, vec_l_max, scale_fleet
end
