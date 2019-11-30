## Calculate the heat loss coefficient of the top cover of PTES
## Edward J. Xu <edxu96@outlook.com>
## Nov 30th, 2019


function get_data()
	## Initial guess of temperature of the cover
	t_cover_0 = 2

	## Other important parameters
	t_ambient = 5 + 273.15
	t_sky = - 10 + 273.15
	h_convec = 5.8  # [W / m2 K] When the wind speed is 1 m/s
	# h_convec = 8.8  # [W / m2 K] When the wind speed is 2 m/s

	epsilon_cover = 
	k_insu = 0.045  # [W / m / K] Thermal conductivity of PE insulation
	sigma = 0.3
	d_cover = 0.25  # [m] Thickness of PE insulation layer

	return t_cover_0, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu
end


function cal_t_cover(
		t_cover, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu
		)
	h_radia = (
		epsilon_cover * sigma * (t_cover + t_sky) * (t_cover^2 + t_sky^2) *
		(t_cover - t_sky)
		) / (t_cover - t_ambient)

	t_cover = ((k_insu / d_cover * t_ptes) + (h_convec + h_radia) * t_ambient) /
		(k_insu / d_cover + h_convec + h_radia)

	return t_cover
end


function main()
	t_cover_0, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu =
		get_data()

	t_cover = cal_t_cover(
		t_cover_0, t_ambient, t_sky, h_convec, epsilon_cover, sigma, k_insu
		)

	println("t_cover = $(t_cover).")
end


main()
