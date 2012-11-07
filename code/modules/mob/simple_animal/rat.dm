//Rat
/mob/living/simple_animal/rat
	name = "rat"
	desc = "space parasite"
	icon = 'mob.dmi'
	icon_state = "rat"
	icon_living = "rat"
	icon_dead = "rat_dead"
	speak = list("Squeak!","Grrr!","Pew-pew!","HSSSSS")
	maxHealth = 50
	health = 50
	speak_emote = list("squeak", "squeak")
	emote_hear = list("squeak","squeak")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meat
	response_help  = "touch the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	harm_intent_damage = 0
	melee_damage_lower = 2
	melee_damage_upper = 7
	attacktext = "bites"
	min_oxy = 0
	max_co2 = 0
	max_tox = 0
	speed = -5
	nopush = 1
	a_intent = "harm"
	canstun = 0
	canweaken = 0
	heat_damage_per_tick = 2	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	cold_damage_per_tick = 1	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	pass_flags = PASSTABLE



/obj/structure/cable/attackby(obj/item/W, mob/user)

	var/turf/T = src.loc
	if(T.intact)
		return

	if(istype(W, /obj/item/weapon/wirecutters))

		if(power_switch)
			user << "\red This piece of cable is tied to a power switch. Flip the switch to remove it."
			return

		if (shock(user, 50))
			return

		if(src.d1)	// 0-X cables are 1 unit, X-X cables are 2 units long
			new/obj/item/weapon/cable_coil(T, 2, color)
		else
			new/obj/item/weapon/cable_coil(T, 1, color)

		for(var/mob/O in viewers(src, null))
			O.show_message("\red [user] cuts the cable.", 1)

		if(defer_powernet_rebuild)
			if(netnum && powernets && powernets.len >= netnum)
				var/datum/powernet/PN = powernets[netnum]
				PN.cut_cable(src)
		del(src)

		return	// not needed, but for clarity