var/prison_shuttle_tickstomove = 10
var/prison_shuttle_moving = 0
var/prison_shuttle_location = 0 // 0 = station 13, 1 = mining station

proc/move_prison_shuttle()
	if(prison_shuttle_moving)	return
	prison_shuttle_moving = 1
	spawn(prison_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (prison_shuttle_location == 1)
			fromArea = locate(/area/shuttle/prison/prison)
			toArea = locate(/area/shuttle/prison/station)
		else
			fromArea = locate(/area/shuttle/prison/station)
			toArea = locate(/area/shuttle/prison/prison)


		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		fromArea.move_contents_to(toArea)
		if (prison_shuttle_location)
			prison_shuttle_location = 0
		else
			prison_shuttle_location = 1
		prison_shuttle_moving = 0
	return

/obj/machinery/computer/prison_shuttle
	name = "Prison Shuttle Console"
	icon = 'computer.dmi'
	icon_state = "shuttle"
	req_access = list(ACCESS_SECURITY)
	var/hacked = 0
	var/allowedtocall = 0
	var/location = 0 //0 = station, 1 = mining base

/obj/machinery/computer/prison_shuttle/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat
	dat = text("<center>Prison shuttle:<br> <b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>")
	user << browse("[dat]", "window=miningshuttle;size=200x100")

/obj/machinery/computer/prison_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["move"])
		if(ticker.mode.name == "blob")
			if(ticker.mode:declared)
				usr << "Under directive 7-10, [station_name()] is quarantined until further notice."
				return

		if (!prison_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_prison_shuttle()
		else
			usr << "\blue Shuttle is already moving."

/obj/machinery/computer/prison_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"

var/deportation_shuttle_tickstomove = 10
var/deportation_shuttle_moving = 0
var/deportation_shuttle_location = 0 // 0 = station 13, 1 = mining station

proc/move_deportation_shuttle()
	if(deportation_shuttle_moving)	return
	deportation_shuttle_moving = 1
	spawn(deportation_shuttle_tickstomove*10)
		var/area/fromArea
		var/area/toArea
		if (deportation_shuttle_location == 1)
			fromArea = locate(/area/shuttle/deportationcosmoc)
			toArea = locate(/area/shuttle/deportationsputnik)
		else
			fromArea = locate(/area/shuttle/deportationsputnik)
			toArea = locate(/area/shuttle/deportationcosmoc)


		var/list/dstturfs = list()
		var/throwy = world.maxy

		for(var/turf/T in toArea)
			dstturfs += T
			if(T.y < throwy)
				throwy = T.y

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(T.x, throwy - 1, 1)
			//var/turf/E = get_step(D, SOUTH)
			for(var/atom/movable/AM as mob|obj in T)
				AM.Move(D)
				// NOTE: Commenting this out to avoid recreating mass driver glitch
				/*
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
				*/

			if(istype(T, /turf/simulated))
				del(T)

		for(var/mob/living/carbon/bug in toArea) // If someone somehow is still in the shuttle's docking area...
			bug.gib()

		fromArea.move_contents_to(toArea)
		if (deportation_shuttle_location)
			deportation_shuttle_location = 0
		else
			deportation_shuttle_location = 1
		deportation_shuttle_moving = 0
	return

/obj/machinery/computer/deportation_shuttle
	name = "Deportation Shuttle Console"
	icon = 'computer.dmi'
	icon_state = "shuttle"
	req_access = list(ACCESS_CAPTAIN)
	var/hacked = 0
	var/allowedtocall = 0
	var/location = 0 //0 = station, 1 = mining base

/obj/machinery/computer/deportation_shuttle/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat
	dat = text("<center>Prison shuttle:<br> <b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>")
	user << browse("[dat]", "window=miningshuttle;size=200x100")

/obj/machinery/computer/deportation_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["move"])
		if(ticker.mode.name == "blob")
			if(ticker.mode:declared)
				usr << "Under directive 7-10, [station_name()] is quarantined until further notice."
				return

		if (!deportation_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent shortly."
			move_deportation_shuttle()
		else
			usr << "\blue Shuttle is already moving."

/obj/machinery/computer/deportation_shuttle/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if (istype(W, /obj/item/weapon/card/emag))
		src.req_access = list()
		hacked = 1
		usr << "You fried the consoles ID checking system. It's now available to everyone!"
