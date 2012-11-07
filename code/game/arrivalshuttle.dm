var/arrival_shuttle_tickstomove = 15
var/arrival_shuttle_moving = 0
var/arrival_shuttle_location = 1 // 0 -spess, 1 - CK, 2 - NSS Exodus
var/start_arrival_shuttle_location = 0 // for coordinate, frome where flying shuttle
var/flying_time_from_station = 15  //15 sec
var/flying_time_to_station = 15  //15 sec

/obj/machinery/computer/arrival_shuttle
	name = "Arrival Shuttle Console"
	icon = 'computer.dmi'
	icon_state = "shuttle"
	req_access = list(ACCESS_SECURITY)
	var/hacked = 0
	var/allowedtocall = 0
	var/location = 0 // 0 -spess, 1 - CK, 2 - NSS Exodus


/obj/machinery/computer/arrival_shuttle/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat
	dat = text("<center>Arrival shuttle:<br> <b><A href='?src=\ref[src];move=[1]'>Send</A></b></center>")
	user << browse("[dat]", "window=miningshuttle;size=200x100")


/obj/machinery/computer/arrival_shuttle/Topic(href, href_list)
	if(..())
		return
	usr.machine = src
	src.add_fingerprint(usr)
	if(href_list["move"])
		if (!arrival_shuttle_moving)
			usr << "\blue Shuttle recieved message and will be sent."
			move_arrival_shuttle()
		else
			usr << "\blue Shuttle is already moving."


proc/move_arrival_shuttle()
	if (arrival_shuttle_moving)
		return
	arrival_shuttle_moving = 1
	var/area/fromArea
	var/area/toArea
	var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
	if (arrival_shuttle_location == 1)
		fromArea = locate(/area/shuttle/arrival/pre_game)
		a.autosay("\"Arrival shuttle will leave the CentComm's anabiosis center [(flying_time_from_station == 0) ? "now" : "in [flying_time_from_station] seconds."]\"", "Shuttle Autopilot")
	else
		fromArea = locate(/area/shuttle/arrival/station)
		a.autosay("\"Arrival shuttle will leave the [station_name()] [(flying_time_from_station == 0) ? "now" : "in [flying_time_from_station] seconds."]\"", "Shuttle Autopilot")
	toArea = locate(/area/shuttle/arrival/spess)
	start_arrival_shuttle_location = arrival_shuttle_location
	sleep(arrival_shuttle_tickstomove*flying_time_from_station)
//	if(arrival_shuttle_location == 2)
//		if(check_people())
//			a.autosay("Please, leave arrival shuttle before it can return to CentComm.", "Shuttle Autopilot")
//			del(a)
//			return
	fromArea.move_contents_to(toArea)
	for(var/mob/M in toArea)
		if(M.client)
			spawn()
				if(M.buckled)
					shake_camera(M, 2, 1)
				else
					shake_camera(M, 4, 2)
					M.Weaken (10)
	for(var/obj/machinery/door/unpowered/D in world)
		if( get_area(D) == toArea )
			spawn(0)
				D.close()
	arrival_shuttle_location = 0
	if (start_arrival_shuttle_location == 1)
		toArea = locate(/area/shuttle/arrival/station)
		a.autosay("\"Arrival shuttle left the CentComm's anabiosis center. [(flying_time_to_station != 0) ? "ETA: [flying_time_to_station] sec." : ""]\"", "Shuttle Autopilot")
	else
		toArea = locate(/area/shuttle/arrival/pre_game)
		a.autosay("\"Arrival shuttle left the [station_name()]. [(flying_time_to_station != 0) ? "ETA: [flying_time_to_station] sec." : ""]\"", "Shuttle Autopilot")
	fromArea = locate(/area/shuttle/arrival/spess)
	arrival_shuttle_location = 0
	sleep(arrival_shuttle_tickstomove*flying_time_to_station)
	fromArea.move_contents_to(toArea)
	for(var/mob/M in toArea)
		if(M.client)
			spawn()
				if(M.buckled)
					shake_camera(M, 4, 1)
				else
					shake_camera(M, 10, 2)
					M.Weaken (10)
	for(var/obj/machinery/door/unpowered/D in world)
		if( get_area(D) == toArea )
			spawn(0)
				D.close()
	if(start_arrival_shuttle_location == 1)
		arrival_shuttle_location = 2
		a.autosay("\"Arrival shuttle docked with the [station_name()].\"", "Shuttle Autopilot")
	else
		arrival_shuttle_location = 1
		a.autosay("\"Arrival shuttle docked with the the CentComm's anabiosis center.\"", "Shuttle Autopilot")
	arrival_shuttle_moving = 0
	del(a)
//	move_back_arrival_shuttle(1)
	return
/*
proc/move_back_arrival_shuttle(var/auto = 0)
	if(arrival_shuttle_location == 1)
		return
	var/obj/item/device/radio/intercom/a = new /obj/item/device/radio/intercom(null)
	while(src)
		if(check_people())
			sleep(100)
			a.autosay("Please, leave Arrival shuttle before it can return to CentComm.", "Shuttle Autopilot")
			sleep(200)
			continue
		else
			var/b = flying_time_from_station
			flying_time_from_station = 0
			move_arrival_shuttle()
			flying_time_from_station = b
			del(a)
			return

proc/check_people()
	world << "Locating."
	switch(arrival_shuttle_location)
		if(0)
			for(var/mob/living/carbon/C in world)
				if(get_turf(C) == locate(/area/shuttle/arrival/spess))
					world << "Find."
					return 1
			world << "Not find."
			return 0
		if(1)
			for(var/mob/living/carbon/C in world)
				if(get_turf(C) == locate(/area/shuttle/arrival/pre_game))
					world << "Find."
					return 1
			world << "Not find."
			return 0
		if(2)
			for(var/mob/living/carbon/C in world)
				if(get_turf(C) == locate(/area/shuttle/arrival/station))
					world << "Find."
					return 1
			world << "Not find."
			return 0

*/