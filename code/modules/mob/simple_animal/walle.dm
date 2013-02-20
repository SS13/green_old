//Walle
/mob/living/simple_animal/walle
	name = "droid"
	desc = "Waste Allocation Load Lifter Earth-Class."
	icon = 'mob.dmi'
	icon_state = "walle"
	icon_living = "walle"
	icon_dead = "walle_dead"
	speak = list("Bzzt!","Bep!","Beep!")
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

/mob/living/simple_animal/walle/say(var/message)

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
				playsound(loc, "beep", 25, 1, 1)//So aliens can hiss while they hiss yo/N
			return ..(message)
