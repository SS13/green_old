//proto
/mob/living/simple_animal/proto
	name = "proto"
	real_name = "Proto"
	desc = "CentCom protocol cyborg."
	icon = 'mob.dmi'
	icon_state = "proto"
	icon_living = "proto"
	icon_dead = "proto_dead"
	speak = list("Beep. Remember: good work - long life!","Beep. Dont forget buckled on chair when shuttle arriwed!","Beep. NanoTrasen love you. If you work.","Beep!")
	speak_emote = list("whizz", "beeps")
	emote_hear = list("state")
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

	anchored = 1