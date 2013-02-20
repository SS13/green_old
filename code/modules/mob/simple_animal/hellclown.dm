/mob/living/simple_animal/hellclown
	name = "hellclown"
	real_name = "Hell Clown"
	desc = "Honk from hell."
	icon = 'mob.dmi'
	icon_state = "hellclown"
	icon_living = "hellclown"
	icon_dead = "hellclown_dead"
	speak = list("HONK", "HAHAHA")
	speak_chance = 1
	response_help  = "honk the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	see_in_dark = 5

/mob/living/simple_animal/hellclown/say(var/message)

	if (length(message) >= 2)
		if (copytext(message, 1, 3) == ":a")
			message = copytext(message, 3)
			message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
			if (stat == 2)
				return say_dead(message)
			else
				alien_talk(message)
		else
			if (copytext(message, 1, 2) != "*" && !stat)
				playsound(loc, "laught", 25, 1, 1)//So aliens can hiss while they hiss yo/N
			return ..(message)

/mob/living/simple_animal/hellclown/verb/ventcrawl()
	set name = "Crawl through Vent"
	set desc = "Enter an air vent and crawl through the pipe system."
	set category = "Hellclown"

	if(stat == CONSCIOUS)
		if(!lying)
			var/obj/machinery/atmospherics/unary/vent_pump/vent_found
			for(var/obj/machinery/atmospherics/unary/vent_pump/v in range(1,src))
				if(!v.welded)
					vent_found = v
				else
					src << "\red That vent is welded."
			if(vent_found)
				if(vent_found.network&&vent_found.network.normal_members.len)
					var/list/vents = list()
					for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in vent_found.network.normal_members)
						if(temp_vent.loc == loc)
							continue
						vents.Add(temp_vent)
					var/list/choices = list()
					for(var/obj/machinery/atmospherics/unary/vent_pump/vent in vents)
						if(vent.loc.z != loc.z)
							continue
						var/atom/a = get_turf(vent)
						choices.Add(a.loc)
					var/turf/startloc = loc
					var/obj/selection = input("Select a destination.", "Duct System") in choices
					var/selection_position = choices.Find(selection)
					if(loc==startloc)
						if(contents.len)
							for(var/obj/item/carried_item in contents)//If the monkey got on objects.
								if(!istype(carried_item, /obj/item/weapon/implant))//If it's not an implant.
									src << "\red You can't be carrying items or have items equipped when vent crawling!"
									return
						var/obj/target_vent = vents[selection_position]
						if(target_vent)
							for(var/mob/O in oviewers(src, null))
								if ((O.client && !( O.blinded )))
									O.show_message(text("<B>[src] scrambles into the ventillation ducts!</B>"), 1)
							loc = target_vent.loc
					else
						src << "You need to remain still while entering a vent."
				else
					src << "This vent is not connected to anything."
			else
				src << "You must be standing on or beside an air vent to enter it."
		else
			src << "You can't vent crawl while you're stunned!"
	else
		src << "You must be conscious to do this!"
	return

