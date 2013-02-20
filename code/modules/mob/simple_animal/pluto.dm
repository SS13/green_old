//Pluto
/mob/living/simple_animal/pluto
	name = "pluto"
	real_name = "Pluto"
	desc = "It's a Pluto."
	icon = 'mob.dmi'
	icon_state = "pluto"
	icon_living = "pluto"
	icon_dead = "pluto_dead"
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meat/corgi
	meat_amount = 3
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	see_in_dark = 5

/mob/living/simple_animal/pluto/say(var/message)

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
				playsound(loc, "Woof!", 25, 1, 1)//So aliens can hiss while they hiss yo/N
			return ..(message)