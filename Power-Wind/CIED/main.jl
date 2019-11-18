## Julia Script for 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Nov 15th, 2019

using JuMP
using GLPK


function value_vec(vec_x::Union{Array{VariableRef,1}, VariableRef})
    if isa(vec_x, VariableRef)
        vec_value = value(vec_x)
    else
        vec_value = [value(vec_x[i]) for i = 1:length(vec_x)]
    end

    return vec_value
end


function dual_vec(vec_cons)
    return [dual(vec_cons[i]) for i = 1:length(vec_cons)]
end


function optim_mod_1()
    model = Model(with_optimizer(GLPK.Optimizer))
    @variable(model, vec_x[1:3] >= 0)
    @objective(model, Max, 4 * 24 * vec_x[1] - vec_x[3] * 2100 + 2 * 24 * vec_x[2])
    vec_cons_1 = @constraint(model, vec_x[1] + 3 * vec_x[3] >= 47)
    vec_cons_2 = @constraint(model, -3 * 24 * vec_x[1] + 2100 * vec_x[3] >= 21)
    vec_cons_3 = @constraint(model, 5 * vec_x[1] + vec_x[2] + 3 * vec_x[3] <= 500)
    vec_cons_4 = @constraint(model, vec_x[2] + vec_x[1] <= 100)

    optimize!(model)
    vec_result_u = dual_vec([vec_cons_1, vec_cons_2, vec_cons_3, vec_cons_4])
    obj = objective_value(model)
    vec_result_x = value_vec(vec_x)
    
    return obj, vec_result_x, vec_result_u
end


function main()

end

main()
