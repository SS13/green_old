//Walle
/mob/living/simple_animal/walle
	name = "walle"
	desc = "Waste Allocation Load Lifter Earth-Class."
	icon = 'mob.dmi'
	icon_state = "walle"
	icon_living = "walle"
	icon_dead = "walle_dead"
	speak = list("Walle!","Bzzt!","Bep!","Beep!")
	speak_emote = list("state", "bep-bop")
	emote_hear = list("beep")
	emote_see = list("sweeping debris", "observing")
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/cable_coil/yellow
	response_help  = "knock the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"

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
