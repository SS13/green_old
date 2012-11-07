/obj/item/weapon/slipknot
	name = "slipknot"
	desc = "Can be used to strangle someone."
	throwforce = 10.0
	throw_speed = 2
	throw_range = 5
	w_class = 1.0
	flags = TABLEPASS | USEDELAY | FPRINT | CONDUCT
	slot_flags = SLOT_BELT
	var/state = 0 //Straingling states: 0 - idle, 1..3 - victim being strangled (different states)
	var/mob/living/carbon/human/victim = null
	var/mob/agressor = null

/obj/item/weapon/slipknot/cable
	name = "cable slipknot"
	desc = "A slipknot made of cable wire. Can be used to grab and strangle someone."
	icon = 'items.dmi'
	icon_state = "cable_slipknot_red"

/obj/item/weapon/slipknot/attack(mob/M as mob, mob/user as mob)
	agressor = user
	if (ishuman(M) && (user.a_intent == "grab" || user.a_intent == "hurt"))
		if (state == 0) //If we at idle
			var/mob/living/carbon/human/victim = M
			if (user.dir == M.dir) //Cheking that we are in right direction
				if (prob(66))
					victim.visible_message("<span class='danger'>[M] is being strangled with the [src] by [user]!</span>")
					user << "\red You begin to strangle [M] with your [src]!"
					state = 1
				else
					victim.visible_message("<span class='danger'>[user] is attempting to strangle [M] with the [src]!</span>")
					user << "\red You failed to strangle [M] with your [src]!"
			else
				user << "\red You should be behind of [M] to strangle him!"

		if (state == 1) //Trying to tighten grip
			if (prob(50))
				user << "\red You tighten your grip on [M]'s neck!"
				state = 2

		if (state == 2) //Trying to tighten grip
			if (prob(33))
				user << "\red You tighten more your grip on [M]'s neck!"
				state = 3
	return

/obj/item/weapon/slipknot/attack_self(mob/user as mob)
	if (ishuman(user) && (user.a_intent == "grab" || user.a_intent == "hurt"))
		if (state == 0) //If we at idle
			if (prob(20))
				victim = user
				user << "\red You begin to strangle yourself. There's no way out..."
				state = 2
			else
				user << "\red You tried to strangle yourself, but with no success."
	return


/obj/item/weapon/slipknot/proc/strangle_victim(var/force)
	if (victim)
		victim.being_strangled = 1
		var/datum/organ/external/head = victim.organs["head"]
		head.add_wound("Strangulation", force)
	return

/obj/item/weapon/slipknot/process()
	if (state == 0) //A little optimisation
		return
	if (victim)
		if (state == 0)
			return
		if (state == 1)
			strangle_victim(0.3)
		if (state == 2)
			strangle_victim(0.5)
		if (state == 3)
			strangle_victim(1.0)
		if (state != 0 && get_dist(agressor, victim) > 1)
			state = 0
			agressor << "\red You moved too far away from [victim] and [src] slipped off the neck!"
	else
		state = 0
	return