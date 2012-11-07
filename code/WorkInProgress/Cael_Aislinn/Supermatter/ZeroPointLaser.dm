//new supermatter lasers

/obj/machinery/emitter/zero_point_laser
	name = "Zero-point laser"
	desc = "A super-powerful laser"
	icon = 'engine.dmi'
	icon_state = "laser"
	mega_energy = 0.0001

	var/freq = 50000
	var/id

	Topic(href, href_list)
		..()
		if( href_list["input"] )
			var/i = text2num(href_list["input"])
			var/d = i
			var/new_power = mega_energy + d
			new_power = max(new_power,0.0001)	//lowest possible value
			new_power = min(new_power,0.1)		//highest possible value
			mega_energy = new_power
			//
			for(var/obj/machinery/computer/lasercon/comp in world)
				if(comp.id == src.id)
					comp.updateDialog()
		else if( href_list["online"] )
			active = !active
			//
			for(var/obj/machinery/computer/lasercon/comp in world)
				if(comp.id == src.id)
					comp.updateDialog()
		else if( href_list["freq"] )
			var/amt = text2num(href_list["freq"])
			var/new_freq = frequency + amt
			new_freq = max(new_freq,1)		//lowest possible value
			new_freq = min(new_freq,50000)	//highest possible value
			frequency = new_freq
			//
			for(var/obj/machinery/computer/lasercon/comp in world)
				if(comp.id == src.id)
					comp.updateDialog()

	update_icon()
		if (active && !(stat & (NOPOWER|BROKEN)))
			icon_state = "laser"//"emitter_+a"
		else
			icon_state = "laser"//"emitter"

	process()
		var/curstate = active

		if(stat & (NOPOWER|BROKEN))
			return
		if(src.state != 2)
			src.active = 0
			return
		if(((src.last_shot + src.fire_delay) <= world.time) && (src.active == 1))
			src.last_shot = world.time
			if(src.shot_number < 3)
				src.fire_delay = 2
				src.shot_number ++
			else
				src.fire_delay = rand(20,100)
				src.shot_number = 0
			use_power(mega_energy*10000)
			var/obj/item/projectile/beam/emitter/A = new /obj/item/projectile/beam/emitter( src.loc )
			A.damage = mega_energy
			playsound(src.loc, 'emitter.ogg', 25, 1)
			if(prob(35))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(5, 1, src)
				s.start()
			A.dir = src.dir
			if(src.dir == 1)//Up
				A.yo = 20
				A.xo = 0
			else if(src.dir == 2)//Down
				A.yo = -20
				A.xo = 0
			else if(src.dir == 4)//Right
				A.yo = 0
				A.xo = 20
			else if(src.dir == 8)//Left
				A.yo = 0
				A.xo = -20
			else // Any other
				A.yo = -20
				A.xo = 0
			A.fired()


		if(active != curstate)
			for(var/obj/machinery/computer/lasercon/comp in world)
				if(comp.id == src.id)
					comp.updateDialog()
