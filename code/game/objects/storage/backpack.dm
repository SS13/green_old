/obj/item/weapon/storage/backpack/MouseDrop(obj/over_object as obj)
	if (ishuman(usr) || ismonkey(usr)) //so monkeys can take off their backpacks -- Urist
		var/mob/M = usr
		if (!( istype(over_object, /obj/screen) ))
			return ..()
		playsound(src.loc, "rustle", 50, 1, -5)
		if ((!( M.restrained() ) && !( M.stat ) && M.back == src))
			if (over_object.name == "r_hand")
				if (!( M.r_hand ))
					M.u_equip(src)
					M.r_hand = src
			else
				if (over_object.name == "l_hand")
					if (!( M.l_hand ))
						M.u_equip(src)
						M.l_hand = src
			M.update_clothing()
			src.add_fingerprint(usr)
			return
		if(over_object == usr && in_range(src, usr) || usr.contents.Find(src))
			if (usr.s_active)
				usr.s_active.close(usr)
			src.show_to(usr)
			return
	return

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()


/obj/item/weapon/storage/backpack/holding
	name = "Bag of Holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "bluespace=4"
	icon_state = "holdingpack"
	max_w_class = 4
	max_combined_w_class = 28

	New()
		..()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(crit_fail)
			user << "\red The Bluespace generator isn't working."
			return
		if(istype(W, /obj/item/weapon/storage/backpack/holding) && !W.crit_fail)
			investigate_log("has become a singularity. Caused by [user.key]","singulo")
			user << "\red The Bluespace interfaces of the two devices catastrophically malfunction!"
			del(W)
			var/obj/machinery/singularity/singulo = new /obj/machinery/singularity (get_turf(src))
			singulo.energy = 300 //should make it a bit bigger~
			message_admins("[key_name_admin(user)] detonated a bag of holding")
			log_game("[key_name(user)] detonated a bag of holding")
			del(src)
			return

		..()

	proc/failcheck(mob/user as mob)
		if (prob(src.reliability)) return 1 //No failure
		if (prob(src.reliability))
			user << "\red The Bluespace portal resists your attempt to add another item." //light failure
		else
			user << "\red The Bluespace generator malfunctions!"
			for (var/obj/O in src.contents) //it broke, delete what was in it
				del(O)
			crit_fail = 1
			icon_state = "brokenpack"

/obj/item/weapon/storage/backpack/holding/inspector/New()
	..()
	new /obj/item/weapon/melee/classic_baton(src)
	new /obj/item/weapon/flashbang/clusterbang(src)
	new /obj/item/weapon/reagent_containers/food/drinks/ambrosia(src)
	new /obj/item/weapon/gun/projectile/mateba(src)
	new /obj/item/weapon/melee/energy/axe(src)
	new /obj/item/weapon/cloaking_device(src)
	new /obj/item/weapon/storage/firstaid/death(src)

/obj/item/weapon/storage/backpack/holding/agent1/New()
	..()
	new /obj/item/weapon/rcd(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/chem_grenade/metalfoam(src)
	new /obj/item/weapon/syndie/c4explosive/heavy(src)
	new /obj/item/weapon/syndie/c4detonator(src)

/obj/item/weapon/storage/backpack/holding/agent2/New()
	..()
	new /obj/item/weapon/reagent_containers/food/drinks/ambrosia(src)
	new /obj/item/weapon/storage/firstaid/fire(src)
	new /obj/item/weapon/storage/firstaid/toxin(src)
	new /obj/item/weapon/storage/firstaid/adv(src)
	new /obj/item/weapon/storage/emp_kit(src)
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/storage/handcuff_kit(src)

/obj/item/weapon/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4.0
	storage_slots = 20
	max_w_class = 3
	max_combined_w_class = 400 // can store a ton of shit!

	New()
		..()
		return

