/obj/item/weapon/cell/handmade_cell
	name = "handmade power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'power.dmi'
	icon_state = "cell_handmade"
	item_state = "cell_handmade"
	m_amt = 500
	g_amt = 100
	maxcharge = 500

/obj/item/weapon/cell/handmade_cell/New()
	charge = 500

/obj/item/weapon/frame/power_cell
	var/stage = 0
	var/items = 0
	icon = 'power.dmi'
	icon_state = "cell_frame1"
	attackby(var/obj/item/weapon/W as obj, var/mob/living/carbon/C as mob)
		switch(stage)
			if(0)
				if(istype(W, /obj/item/weapon/clot))
					if(src.items >= 5)
						usr << "You can't find place for this."
					else
						items += 1
						usr << "You add a clot into frame."
						del W
				if(istype(W, /obj/item/weapon/cable_coil) && W:amount>=2 && src.items >= 1)
					W:amount -= 2
					src.stage = 1
					icon_state = "cell_frame2"
					if(!W:amount)
						del(W)
			if(1)
				if(istype(W, /obj/item/stack/sheet/glass))
					W:amount -= 1
					usr << "You insert glass lens into frame."
					icon_state = "cell_frame3"
					src.stage = 2
					if(!W:amount)
						del (W)
			if(2)
				if(istype(W, /obj/item/weapon/screwdriver))
					playsound(src.loc, 'Screwdriver.ogg', 50, 1)
					usr << "You finish your battery."
					var/D = new /obj/item/weapon/cell (src.loc)
					D:maxcharge = src.items * 500
					D:charge = src.items*250
					del src

/obj/item/weapon/clot
	name = "clot"
	desc = "clot of substance"
	icon = 'power.dmi'
	icon_state = "clot"
	item_state = "clot"
