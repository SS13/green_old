

var/list/areamem = new/list() // where hell else define this shit

/area/proc/move_contents_dir(var/direct)
	//Takes: Area. Optional: turf type to leave behind.
	//Returns: Nothing.
	//Notes: Attempts to move the contents of one area to another area.
	//       Movement based on lower left corner. Tiles that do not fit
	//		 into the new area will not be moved.
//	world << "move prepearing"

	if(!src) return 0
	var/list/turfs_src = new/list()
	if(!areamem.len)
		turfs_src = get_area_turfs(src.type)
	else
		turfs_src = areamem

	//var/list/turfs_trg
	var/list/turfs_trg = new/list()
	var/delta_x = 0
	var/delta_y = 0
	switch(direct)
		if(1)
			delta_y = 1
		if(2)
			delta_y = -1
		if(4)
			delta_x = 1
		if(8)
			delta_x = -1

	for(var/turf/T in turfs_src)

		turfs_trg += locate(T.x+delta_x, T.y+delta_y, T.z)


/*	var/list/turfs_trg = new/list()
	for(var/area/N in world)
		if(istype(N, areatype))
			for(var/turf/T in N)
				T.x++
				turfs_trg += T*/




	var/blanked_turfs = list()
	var/src_min_x = 0
	var/src_min_y = 0
	var/src_max_x = 255
	var/src_max_y = 255
	for (var/turf/T in turfs_src)
		if(src.ul_Lighting)
			blanked_turfs |= T.ul_BlankLocal()
		if(T.x < src_min_x || !src_min_x) src_min_x	= T.x
		if(T.y < src_min_y || !src_min_y) src_min_y	= T.y
		if(T.x > src_max_x || src_max_x == 255) src_max_x	= T.x
		if(T.y > src_max_y || src_max_y == 255) src_max_y	= T.y
	var/trg_min_x = 0
	var/trg_min_y = 0
	var/trg_max_x = 255
	var/trg_max_y = 255
	for (var/turf/T in turfs_trg)
//		if(A.ul_Lighting)
//			blanked_turfs |= T.ul_BlankLocal()
		if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
		if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y
		if(T.x > trg_max_x || trg_max_x == 255) trg_max_x	= T.x
		if(T.y > trg_max_y || trg_max_y == 255) trg_max_y	= T.y

	var/list/turfs_dmg = new/list
	turfs_dmg = turfs_trg - turfs_src
//	switch(direct)
	for(var/turf/W in turfs_dmg)
		if(!istype(W,/turf/simulated/shuttle/floor/spaceship) && !istype(W,/turf/simulated/shuttle/wall/spaceship) && !istype(W,/turf/space))
			//explosion(W, 2, 4, 5, 6)
			return 0

	for(var/turf/W in turfs_dmg)
		for(var/obj/D in W)
			del(D)







	if(trg_max_x > 250 || trg_min_x < 5 || trg_max_y > 250 || trg_min_y < 5)
	//	world << "reached a worldside"
		var/zlev = pick(1,3,4,5)
	//	world << "[zlev]"
		var/list/turfs_trg_nextz = new/list()
		if(trg_max_x > 250 || trg_min_x < 5)
		//	world << "x side"

//			for (var/srcarea in turfs_src)
//				new /area/shuttle/spaceship/init(srcarea)
			if(trg_min_x < 5)
				for(var/turf/T in turfs_src)
//					new /area/shuttle/spaceship/target(locate(T.x+(245-(src_max_x-src_min_x),T.y,zlev))
					turfs_trg_nextz += locate(T.x+(245-(src_max_x-src_min_x))-1,T.y,zlev)
			else
		//		world << "max x side"
				for(var/turf/T in turfs_src)
//					new /area/shuttle/spaceship/target(locate(T.x-(245-(src_max_x-src_min_x),T.y,zlev))
					turfs_trg_nextz += locate(T.x-(245-(src_max_x-src_min_x))+1,T.y,zlev)
		if(trg_max_y > 250 || trg_min_y < 5)

//			for (var/srcarea in turfs_src)
//				new /area/shuttle/spaceship/init(srcarea)
			if(trg_min_y < 5)
				for(var/turf/T in turfs_src)
//					new /area/shuttle/spaceship/target(locate(T.x,T.y+(245-(src_max_x-src_min_x),zlev))
					turfs_trg_nextz += locate(T.x,T.y+(245-(src_max_y-src_min_y))-1,zlev)
			else
				for(var/turf/T in turfs_src)
//					new /area/shuttle/spaceship/target(locate(T.x,T.y-(245-(src_max_x-src_min_x),zlev))
					turfs_trg_nextz += locate(T.x,T.y-(245-(src_max_y-src_min_y))+1,zlev)
		turfs_trg = turfs_trg_nextz
		trg_min_x = 0
		trg_max_x = 255
		trg_min_y = 0
		trg_max_y = 255
		for (var/turf/T in turfs_trg)
//		if(A.ul_Lighting)
//			blanked_turfs |= T.ul_BlankLocal()


			if(T.x < trg_min_x || !trg_min_x) trg_min_x	= T.x
			if(T.y < trg_min_y || !trg_min_y) trg_min_y	= T.y
			if(T.x > trg_max_x || trg_max_x == 255) trg_max_x	= T.x
			if(T.y > trg_max_y || trg_max_y == 255) trg_max_y	= T.y





/*	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = -1*((T.x - src_min_x)-(src_max_x-src_min_x))
		C.y_pos = -1*((T.y - src_min_y)-(src_max_y-src_min_y))

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = -1*((T.x - trg_min_x)-(trg_max_x-trg_min_x))
		C.y_pos = -1*((T.y - trg_min_y)-(trg_max_y-trg_min_y))*/
	areamem = turfs_trg

	if (direct == 1 || direct == 4)
		var/list/turfs_trg_inv = new/list()
		for(var/i=turfs_trg.len,i>=1,i--)
			turfs_trg_inv += turfs_trg[i]
		var/list/turfs_src_inv = new/list()
		for(var/i=turfs_src.len,i>=1,i--)
			turfs_src_inv += turfs_src[i]
		turfs_trg = turfs_trg_inv
		turfs_src = turfs_src_inv


	var/list/refined_src = new/list()
	for(var/turf/T in turfs_src)
		refined_src += T
		refined_src[T] = new/datum/coords
		var/datum/coords/C = refined_src[T]
		C.x_pos = (T.x - src_min_x)
		C.y_pos = (T.y - src_min_y)

	var/list/refined_trg = new/list()
	for(var/turf/T in turfs_trg)
		refined_trg += T
		refined_trg[T] = new/datum/coords
		var/datum/coords/C = refined_trg[T]
		C.x_pos = (T.x - trg_min_x)
		C.y_pos = (T.y - trg_min_y)

//	for(var/i=refined_src,i>=0,i--)
//		trg_max_y=1

	var/list/fromupdate = new/list()
	var/list/toupdate = new/list()
	//world << "moving started"
	moving:
		for (var/turf/T in refined_src)
			var/datum/coords/C_src = refined_src[T]
			for (var/turf/B in refined_trg)
				var/datum/coords/C_trg = refined_trg[B]
				if(C_src.x_pos == C_trg.x_pos && C_src.y_pos == C_trg.y_pos)
				//	world << "turf moved"

					var/old_dir1 = T.dir
					var/old_icon_state1 = T.icon_state
					var/old_icon1 = T.icon

					var/turf/X = new T.type(B)
					X.dir = old_dir1
					X.icon_state = old_icon_state1
					X.icon = old_icon1 //Shuttle floors are in shuttle.dmi while the defaults are floors.dmi

					/* Quick visual fix for some weird shuttle corner artefacts when on transit space tiles */
				/*	if(direction && findtext(X.icon_state, "swall_s"))

						// Spawn a new shuttle corner object
						var/obj/corner = new()
						corner.loc = X
						corner.density = 1
						corner.anchored = 1
						corner.icon = X.icon
						corner.icon_state = dd_replacetext(X.icon_state, "_s", "_f")
						corner.tag = "delete me"
						corner.name = "wall"

						// Find a new turf to take on the property of
						var/turf/nextturf = get_step(corner, direction)
						if(!nextturf || !istype(nextturf, /turf/space))
							nextturf = get_step(corner, turn(direction, 180))


						// Take on the icon of a neighboring scrolling space icon
						X.icon = nextturf.icon
						X.icon_state = nextturf.icon_state*/


					for(var/obj/O in T)

						// Reset the shuttle corners
						if(O.tag == "delete me")
							X.icon = 'shuttle.dmi'
							X.icon_state = dd_replacetext(O.icon_state, "_f", "_s") // revert the turf to the old icon_state
							X.name = "wall"
							del(O) // prevents multiple shuttle corners from stacking
							continue
						if(!istype(O,/obj)) continue
						O.loc = X
					for(var/mob/M in T)
						if(!istype(M,/mob)) continue
						M.loc = X

					var/area/AR = X.loc

					if(AR.ul_Lighting)
						X.opacity = !X.opacity
						X.ul_SetOpacity(!X.opacity)

					toupdate += X

					T.ReplaceWithSpace()

					refined_src -= T
					refined_trg -= B
					continue moving

	var/list/doors = new/list()

	if(toupdate.len)
		for(var/turf/simulated/T1 in toupdate)
			for(var/obj/machinery/door/D2 in T1)
				doors += D2
			air_master.tiles_to_update |= T1

	if(fromupdate.len)
		for(var/turf/simulated/T2 in fromupdate)
			for(var/obj/machinery/door/D2 in T2)
				doors += D2
			air_master.tiles_to_update |= T2

//	for(var/obj/O in doors)
//		O:update_nearby_tiles(1)
	//for(var/area/shuttle/spaceship/old in world)
	//	del(old)
//	for(var/newloc in turfs_trg)
//		new /area/shuttle/spaceship(newloc)

/obj/machinery/computer/spaceship
	name = "Spaceship control panel"
	icon = 'computer.dmi'
	icon_state = "shuttle"
	var/hacked = 0


/obj/machinery/computer/spaceship/attack_hand(user as mob)
	src.add_fingerprint(usr)
	var/dat
	dat = text("<center>Buckle in the chair and concentrate on the moving<br> </center>")
	user << browse("[dat]", "window=miningshuttle;size=200x100")




/obj/structure/stool/bed/chair/comfy/teal/pilot
	icon_state = "comfychair_teal"
	name = "Pilot's chair"


/obj/structure/stool/bed/chair/comfy/teal/pilot/relaymove(mob/user as mob, direction)
	if(ishuman(user))
		var/mob/living/carbon/human/J = user
		if(TK in J.mutations)
			var/area/fromArea = locate(/area/shuttle/spaceship)
			fromArea.move_contents_dir(direction)

		else
			user << "\red Ship engines require power of telekinetiks"


/turf/simulated/shuttle/wall/spaceship
	icon = 'space.dmi'
	name = "wall"
	icon_state = "placeholder"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/floor/spaceship
	icon = 'space.dmi'
	name = "floor"
	icon_state = "placeholder"

/obj/structure/shuttle/wall
	anchored = 1
	icon = 'shuttle.dmi'

/*/obj/structure/shuttle/wall/1
	icon_state = "swall_f6"

/obj/structure/shuttle/wall/2
	icon_state = "swall_f10"

/obj/structure/shuttle/wall/3
	icon_state = "swall_f5"

/obj/structure/shuttle/wall/4*/
	icon_state = "swall_f5"

/obj/structure/shuttle/floor
	anchored = 1
	icon = 'shuttle.dmi'
	icon_state = "floor"

