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