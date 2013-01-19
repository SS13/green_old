#define NODERANGE 3

/obj/effect/alien/weeds
	name = "weeds"
	desc = "Weird purple weeds."
	icon_state = "weeds"

	anchored = 1
	density = 0
	var/health = 15
	var/obj/effect/alien/weeds/node/linked_node = null

/obj/effect/alien/weeds/node
	icon_state = "weednode"
	name = "purple sac"
	desc = "Weird purple octopus-like thing."
	luminosity = NODERANGE
	var/node_range = NODERANGE

/obj/effect/alien/weeds/node/New()
	..(src.loc, src)


/obj/effect/alien/weeds/New(pos, node)
	..()
	linked_node = node
	if(istype(loc, /turf/space))
		del(src)
		return
	if(icon_state == "weeds")icon_state = pick("weeds", "weeds1", "weeds2")
	spawn(rand(150, 200))
		if(src)
			Life()
	return

/obj/effect/alien/weeds/proc/Life()
	set background = 1
	var/turf/U = get_turf(src)
/*
	if (locate(/obj/movable, U))
		U = locate(/obj/movable, U)
		if(U.density == 1)
			del(src)
			return

Alien plants should do something if theres a lot of poison
	if(U.poison> 200000)
		health -= round(U.poison/200000)
		update()
		return
*/
	if (istype(U, /turf/space))
		del(src)
		return

	direction_loop:
		for(var/dirn in cardinal)
			var/turf/T = get_step(src, dirn)

			if (!istype(T) || T.density || locate(/obj/effect/alien/weeds) in T || istype(T.loc, /area/arrival) || istype(T, /turf/space))
				continue

			if(!linked_node || get_dist(linked_node, src) > linked_node.node_range)
				return

	//		if (locate(/obj/movable, T)) // don't propogate into movables
	//			continue

			for(var/obj/O in T)
				if(O.density)
					continue direction_loop

			new /obj/effect/alien/weeds(T, linked_node)


/obj/effect/alien/weeds/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
		if(2.0)
			if (prob(50))
				del(src)
		if(3.0)
			if (prob(5))
				del(src)
	return

/obj/effect/alien/weeds/attackby(var/obj/item/weapon/W, var/mob/user)
	if(W.attack_verb.len)
		visible_message("\red <B>\The [src] have been [pick(W.attack_verb)] with \the [W][(user ? " by [user]." : ".")]")
	else
		visible_message("\red <B>\The [src] have been attacked with \the [W][(user ? " by [user]." : ".")]")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/weeds/proc/healthcheck()
	if(health <= 0)
		del(src)


/obj/effect/alien/weeds/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300)
		health -= 5
		healthcheck()

/*/obj/effect/alien/weeds/burn(fi_amount)
	if (fi_amount > 18000)
		spawn( 0 )
			del(src)
			return
		return 0
	return 1
*/

#undef NODERANGE