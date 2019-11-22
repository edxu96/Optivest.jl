## Julia Script for 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Nov 15th, 2019

# using ExcelReaders
using JuMP
using GLPK
using CSV

cd("/Users/edxu96/GitHub/Optivest.jl/Power-System/PIED")


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


function optim_mod(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var, vec_max
        )
    model = Model(with_optimizer(GLPK.Optimizer))

    @variable(model, mat_x[1:2, 1:168] >= 0)
    @variable(model, vec_cap[1:2] >= 0)
    @variable(model, 0 <= cap_wind <= 1)

    @objective(model, Min,
        sum(mat_x[i, t] * vec_c_var[i] for i = 1:2, t = 1:168) +
        sum(vec_cap[i] * vec_c_fix[i] for i = 1:2) +
        c_fix_wind * cap_wind
        )
    @constraint(model, mat_cons_1[j = 1:2, t = 1:167],
        - vec_max[j] * vec_cap[j] <= mat_x[j, t+1] - mat_x[j, t]
        )
    @constraint(model, mat_cons_4[j = 1:2, t = 1:167],
        mat_x[j, t+1] - mat_x[j, t] <= vec_max[j] * vec_cap[j]
        )
    @constraint(model, vec_cons_2[t = 1:168],
        mat_x[1, t] + mat_x[2, t] >= vec_demand[t] - cap_wind * vec_wind[t]
        )
    @constraint(model, vec_cons_3[i = 1:2, t = 1:168],
        mat_x[i, t] <= vec_cap[i]
        )

    optimize!(model)
    # vec_result_u = dual_vec([vec_cons_1, vec_cons_2, vec_cons_3, vec_cons_4])
    obj = objective_value(model)
    mat_x_result = [value(mat_x[j, i]) for j = 1:2, i = 1:168]
    vec_cap_result = value_vec(vec_cap)
    cap_wind_result = value(cap_wind)

    return obj, mat_x_result, vec_cap_result, cap_wind_result
end


function get_data()
    vec_demand = CSV.read("../data/demand.csv")[!, 2]
    vec_wind = CSV.read("../data/wind.csv")[!, 2]
    vec_c_fix = [441, 2541]
    vec_c_var = [0.4, 0.433]
    c_fix_wind = 5000
    vec_max = [1, 0.6]
    return vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var, vec_max
end


function main()
    vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var, vec_max = get_data()
    obj, mat_x_result, vec_cap_result, cap_wind_result = optim_mod(
        vec_demand, vec_wind, vec_c_fix, c_fix_wind, vec_c_var, vec_max
        )
    return obj, mat_x_result, vec_cap_result, cap_wind_result
end


obj, mat_x_result, vec_cap_result, cap_wind_result = main()
