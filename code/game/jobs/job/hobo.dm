//Tunnel Rat//
/datum/job/hobo
	title = "Hobo"
	flag = HOBO
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 0
	spawn_positions = 3
	supervisors = "beer and smoke"
	idtype = /obj/item/weapon/card/id/old
	selection_color = "#dddddd"

	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_if_possible(new /obj/item/clothing/under/fluff/jumpsuitdirty(H), H.slot_w_uniform)
		H.equip_if_possible(new /obj/item/weapon/reagent_containers/food/drinks/beer(H), H.slot_l_hand)
		H.disabilities |= 16
		H.mutations.Add(mHallucination)
		return 1