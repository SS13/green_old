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

	maxHealth = 60
	health = 60

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

/mob/living/simple_animal/walle/proc/call_sound_emote(var/E)
	switch(E)
		if("Bep!", "Beep!")
			for(var/mob/M in viewers(usr, null))
				M << sound(pick('Beep001.ogg'))
