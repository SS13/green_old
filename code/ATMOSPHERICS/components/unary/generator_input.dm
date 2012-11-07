/obj/machinery/atmospherics/unary/generator_input
	icon = 'heat_exchanger.dmi'
	icon_state = "intact"
	density = 1

	name = "Generator Input"
	desc = "Placeholder"

	var/update_cycle

	New()
		..()
		air_contents.volume = 1000



	update_icon()
		if(node)
			icon_state = "intact"
		else
			icon_state = "exposed"

		return

	proc
		return_exchange_air()
			return air_contents