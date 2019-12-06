## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


"Get the optimized value of decision vector."
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


"Print the first stage decision variables and performace metric"
function print_result(obj_result, vec_y_result, z_result, wind_curtail)
    mat_result = [
        vec_y_result[1] vec_y_result[2] z_result obj_result wind_curtail
        ]
    pretty_table(
        mat_result, ["y_gt" "y_bio" "z" "obj" "curtail"]; formatter=ft_round(4)
        )
    return mat_result
end
