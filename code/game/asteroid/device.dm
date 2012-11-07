
/obj/item/weapon/storage/explorers_box
	name = "SpaceFriend(tm)"
	icon_state = "box"
	desc = "Everything a dashing space explorer would want to have near in the grim darkness of... whatever."

/obj/item/weapon/storage/explorers_box/New()
	..()
	new /obj/item/device/radio/beacon(src)
	new /obj/item/device/flashlight(src)
	new /obj/item/weapon/reagent_containers/food/drinks/beer(src)
	new /obj/item/weapon/reagent_containers/food/snacks/chips(src)
	new /obj/item/weapon/cigpacket(src)
	var/obj/item/weapon/reagent_containers/pill/P = new/obj/item/weapon/reagent_containers/pill(src)
	P.reagents.add_reagent("nutriment", 500)
	P.name = "Cyanide pill"
	return

/obj/effect/ship_landing_beacon
	icon = 'craft.dmi'
	icon_state = "beacon"
	name = "Beacon"
	var/active = 0

	proc
		deploy()
			if(active)
				return
			src.active = 1
			src.anchored = 1
		deactivate()
			if(!active)
				return
			src.active = 0
			src.anchored = 0