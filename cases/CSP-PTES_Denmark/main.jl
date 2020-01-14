## Calculate the heat loss coefficient of the top cover of PTES
## Edward J. Xu <edxu96@outlook.com>
## Nov 30th, 2019


function get_data()
	## Initial guess of temperature of the cover
	t_cover_0 = 0 + 273.15

	## Parameters
	t_ambient = 5 + 273.15
	t_ptes = 80 + 273.15
	h_convec = 5.8  # [W / m2 K] When the wind speed is 1 m/s
	# h_convec = 8.8  # [W / m2 K] When the wind speed is 2 m/s

	## Parameters for radiation
	t_sky = - 10 + 273.15  # Temperature of the sky
	epsilon_cover = 0.3  # Emissivity of the cover
	sigma = 1  # ???

	## Parameters for conduction
	d_cover = 0.25  # [m] Thickness of PE insulation layer
	k_insu = 0.045  # [W / m / K] Thermal conductivity of PE insulation

	return t_cover_0, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu,
		d_cover, t_ptes
end


# function cal_t_cover(
# 		t_cover, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu,
# 		d_cover, t_ptes
# 		)
# 	h_radia = (
# 		epsilon_cover * sigma * (t_cover + t_sky) * (t_cover^2 + t_sky^2) *
# 		(t_cover - t_sky)
# 		) / (t_cover - t_ambient)
#
# 	t_cover = ((k_insu / d_cover * t_ptes) + (h_convec + h_radia) * t_ambient) /
# 		(k_insu / d_cover + h_convec + h_radia)
#
# 	return t_cover
# end


"""
Calculate the new t_cover using the assumed t_cover.
"""
function cal_t_cover(
		t_cover, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu,
		d_cover, t_ptes
		)
	##
	q_radia = epsilon_cover * sigma * (t_cover^2 - t_sky^2) *
		(t_cover^2 + t_sky^2)

	t_cover_new = (k_insu / d_cover * t_ptes + h_convec * t_ambient - q_radia) /
		(k_insu / d_cover + h_convec)

	return t_cover_new
end


function main()
	t_cover_0, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu,
		d_cover, t_ptes = get_data()

	## Start the iteration to find t_cover
	t_cover = t_cover_0
	whe_continue = true
	num_ite = 1
	while whe_continue
		t_cover_new = cal_t_cover(
			t_cover, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu,
			d_cover, t_ptes
			)

		if abs(t_cover - t_cover_new) <= 1E-4
			println("t_cover = $(t_cover_new - 273.15) (Celsius) ;")
			println("num_ite = $(num_ite) ;")
			whe_continue = false
		elseif num_ite >= 100
			println("t_cover cannot be calculated ;")
			println(
				"t_cover_new = $(t_cover_new - 273.15) (Celsius) ;"
				)
			whe_continue = false
		else
			t_cover = t_cover_new
			num_ite += 1
		end
	end
end


main()
