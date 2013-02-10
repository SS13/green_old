//Saturn
/mob/living/simple_animal/saturn
	name = "saturn"
	real_name = "Saturn"
	desc = "It's a Saturn."
	icon = 'mob.dmi'
	icon_state = "saturn"
	icon_living = "saturn"
	icon_dead = "saturn_dead"
	speak = list("YAP", "Woof!", "Bark!", "AUUUUUU")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/sliceable/meat/corgi
	meat_amount = 4
	response_help  = "pets the"
	response_disarm = "gently pushes aside the"
	response_harm   = "kicks the"
	see_in_dark = 5