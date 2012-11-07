
/obj/item/weapon/melee/gibstick
	name = "Centcomm Manipulation Device"
	desc = "Product of weird technology from deepest CentComm labs."
	icon = 'library.dmi'
	icon_state = "scanner"
	var/mode
	New()
		message_admins("ADMIN: Manipulation Device has been spawned")
	attack_self (mob/user)
		mode ++
		if(mode == 5)
			mode = 0
		switch(mode)
			if(0)
				usr << "You turn off manipulation device"
			if(1)
				usr << "You turn gib mode"
			if(2)
				usr << "You turn stun mode"
			if(3)
				usr << "You turn heal mode"
			if(4)
				usr << "You turn cuff mode"

	attack(var/mob/living/M as mob, mob/living/user as mob)
		switch(mode)
			if(0)
				..()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[user] has turned off CentComm Manipulation Device!</B>", 1, "\red You hear something clicked", 2)
			if(1)
				M.gib()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been destroyed with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone gibs", 2)
			if(2)
				M.Stun(25)
				M.Weaken(25)
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been stunned with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone fall", 2)
			if(3)
				M.revive()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been healed with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone heals", 2)
			if(4)
				M.handcuffed = new /obj/item/weapon/handcuffs(M)
				M.update_clothing()
				for(var/mob/O in viewers(M))
					if (O.client)	O.show_message("\red <B>[M] has been handcuffed with the CentComm Manipulation Device by [user]!</B>", 1, "\red You hear someone screams", 2)
		return