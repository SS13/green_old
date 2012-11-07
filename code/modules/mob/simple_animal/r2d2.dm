//r2d2
/mob/living/simple_animal/r2d2
	name = "r2d2"
	real_name = "R2D2"
	desc = "Astro droid."
	icon = 'mob.dmi'
	icon_state = "r2d2"
	icon_living = "r2d2"
	icon_dead = "r2d2_dead"
	speak = list("breep-tiop!","peeep!","trip-poop!","pip-poop!")
	speak_emote = list("whizz", "beeps")
	emote_hear = list("whizz")
	emote_see = list("blink", "observing")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/weapon/cable_coil/yellow
	meat_amount = 3
	response_help  = "knock the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	see_in_dark = 6

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0		//so they don't freeze in space
	maxbodytemp = 295	//if it's just 25 degrees, they start to burn up

//r2d3
/mob/living/simple_animal/r2d3
	name = "r2d3"
	real_name = "R2D3"
	desc = "Engineering droid."
	icon = 'mob.dmi'
	icon_state = "r2d3"
	icon_living = "r2d3"
	icon_dead = "r2d3_dead"
	speak = list("breep-tiop!","peeep!","trip-poop!","pip-poop!")
	speak_emote = list("whizz", "beeps")
	emote_hear = list("whizz")
	emote_see = list("blink", "observing")
	speak_chance = 1
	turns_per_move = 5
	meat_type = /obj/item/weapon/cable_coil/yellow
	meat_amount = 3
	response_help  = "knock the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	see_in_dark = 6
