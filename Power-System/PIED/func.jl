## Julia Script for Optimization Model in 42002 Group Project
## Edward J. Xu (edxu96@outlook.com)
## Dec 6th, 2019


function export_result(name_para, para)
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
