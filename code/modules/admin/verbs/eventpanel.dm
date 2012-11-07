/client/proc/animuspanel()
	set name = "Events panel"
	set category = "Fun"

	if (!istype(src,/obj/admins))
		src = usr.client.holder
	if (!istype(src,/obj/admins))
		usr << "Error: you are not an admin!"
		return

	var/dat = "<html><head><title>Animus Events Panel</title></head>"

	dat += "<b>Events panel</b><br><br>"
	dat += "<A HREF='?src=\ref[src];animuspanel=statistics'>Statistics</A><br>"
//	if(usr.ckey == "morfei") //test stuff - now it's my own
	dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent'>Zombie Event</A><br>"
	dat += "<A HREF='?src=\ref[src];animuspanel=easybuttons'>Buttons</A><br>"

	usr << browse(dat, "window=animuspanel")


/obj/admins/Topic(href, href_list)
	..()
	if(href_list["animuspanel"])
		var/dat = "<html><head><title>Animus Events Panel</title></head>"
		dat += "<b>Events panel</b> (<A HREF='?src=\ref[src];animuspanel=returntomenu'>return</A>)<br><br>"
		switch(href_list["animuspanel"])
			if("returntomenu")
				return
			if("statistics")
				var/lcount = 0 //humans (live) count
				var/dcount = 0 //humans (dead) count
				dat += "<b>Statistics:</b> (<A HREF='?src=\ref[src];animuspanel=statistics'>refresh</A>)<br>"

				for(var/mob/living/carbon/human/M in world)
					if(M.stat == 2)	dcount++; else lcount++
				dat += "Humans: [lcount] living || [dcount] dead<br>"
				lcount = 0; dcount = 0
				/*for(var/mob/living/carbon/zombie/Z in world)
					if(Z.stat == 2)
						lcount++
					else
						dcount++
				dat += "Zombie: [lcount] living || [dcount] dead<br>"
				lcount = 0; dcount = 0*/
				for(var/mob/living/carbon/alien/A in world)
					if(A.stat == 2)
						dcount++
					else
						lcount++
				dat += "Aliens: [lcount] living || [dcount] dead<br>"
				lcount = 0; dcount = 0
				for(var/mob/living/silicon/robot/B in world)
					if(B.stat == 2)
						dcount++
					else
						lcount++
				dat += "Borgs:  [lcount] living || [dcount] dead<br>"
				lcount = 0; dcount = 0
				for(var/mob/dead/observer/O in world)
					if(O.key)
						if(O.client)
							lcount++
						else
							dcount++
				dat += "Observers: [lcount] online || [dcount] offline<br>"

				usr << browse(dat, "window=animuspanel")
				return


			//=================
			//=====ZOMBIES=====
			//=================
			/*if("zombieevent")
				dat += "<b>Zombie Event</b><br>"
				dat += "Commands:<br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent_start'>Start Zombie Event!</A> (infect random humans)<br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent_alert'>Create Biohazard alert</A> (centcom message)<br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent_pmtozombie'>Send message to all zombies</A><br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent_infect'>Infect a human</A><br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent_createzombie'>Create zombie</A><br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent_createzombierand'>Create zombie (random key)</A><br>"

				usr << browse(dat, "window=animuspanel")
				return
			if("zombieevent_start")
				dat += "<b>Zombie Event</b><br>"
				var/I = 0
				var/zombiecount = input("Input count:","Infect") as num
				for(var/mob/living/carbon/human/M in world)
					if(I >= zombiecount)
						break
					if(M.mind && M.mind.special_role)
						continue //butthurt protection --balagi
					I++
					M.contract_disease(new /datum/disease/zombie_transformation(0),1)
				dat += "Zombie Event started! [I] humans infected.<br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=zombieevent'>back</A>"
				//if(I)
					//message_admins("\blue [key_name_admin(usr)] starts Zombie Event ([I] infected).", 1)
					//log_admin("[key_name(usr)] starts Zombie Event [I]")

				usr << browse(dat, "window=animuspanel")
				return
			if("zombieevent_pmtozombie")
				var/message = sanitize(input("Your message","Message to all zombies"))
				if(!message)
					return
				for(var/mob/living/carbon/zombie/Z in world)
					if(Z.stat != 2)
						Z << "\blue <b>Admin-PM (all zombies):</b> [message]"
				message_admins("\blue [key_name_admin(usr)] send message to all zombies: [message]", 1)
				log_admin("[key_name(usr)] send to zombies: [message]")
				return
			if("zombieevent_alert")
				command_alert("Confirmed outbreak of level 7 viral biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
				world << sound('outbreak7.ogg')
				//message_admins("\blue [key_name_admin(usr)] create a biohazard alert.", 1)
				return
			if("zombieevent_infect")
				var/mob/living/carbon/human/HL[] = list()
				for(var/mob/living/carbon/human/M in world)
					if(M.stat != 2) //dead
						HL += M
				if(!HL.len)
					usr << "\red There are no humans at the station."
					return
				var/mob/living/carbon/human/H = input("Select mob to infect","") as null|anything in HL
				if(!isnull(H))
					H.contract_disease(new /datum/disease/zombie_transformation(0),1)
					//message_admins("\blue [key_name_admin(usr)] infect [key_name_admin(H)] with a zombie virus.", 1)
					//log_admin("[key_name(usr)] infect [key_name(H)] with a zombie virus")
				return
			if("zombieevent_createzombie")
				var/tname = input("Input name:","Name")
				var/tkey = input("Input key:","Key")
				var/mob/living/carbon/zombie/H = new/mob/living/carbon/zombie(usr.loc)
				H.real_name = tname
				H.name = tname
				H.morph_stage = 2
				if(alert("Spawn jumpsuit",,"Yes","No")=="Yes")
					H.w_uniform = new/obj/item/clothing/under/color/grey(H)
					H.shoes = new/obj/item/clothing/shoes/black(H)
				spawn(5)
					H.key = tkey
				return
			if("zombieevent_createzombierand")
				//random observer
				var/list/olist = list()
				for(var/mob/dead/observer/O in world)
					if(O.client)
						olist += O
				if(!olist.len)
					usr << "\red No dead players"
					return
				var/mob/M = pick(olist)
				var/tname = input("Input name:","Name")
				var/mob/living/carbon/zombie/H = new/mob/living/carbon/zombie(usr.loc)
				H.real_name = tname
				H.name = tname
				H.morph_stage = 2
				if(alert("Spawn jumpsuit",,"Yes","No")=="Yes")
					H.w_uniform = new/obj/item/clothing/under/color/grey(H)
					H.shoes = new/obj/item/clothing/shoes/black(H)
				//message_admins("\blue [key_name_admin(usr)] spawn [key_name_admin(H)] like a zombie.", 1)
				spawn(5)
					H.key = M.key
				return*/
			//=============
			//===BUTTONS===
			//=============
			if("easybuttons")
				dat += "<b>Buttons</b><br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=easybuttons_createhuman'>Create human</A><br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=easybuttons_createhumanrand'>Create human (random key)</A><br>"
				dat += "<A HREF='?src=\ref[src];animuspanel=easybuttons_delghosts'>Delete all ghosts without key</A><br>"

				usr << browse(dat, "window=animuspanel")
				return
			if("easybuttons_createhuman")
				var/tname = input("Input name:","Name")
				var/tkey = input("Input key:","Key")
				var/mob/living/carbon/human/H = new/mob/living/carbon/human(usr.loc)
				H.real_name = tname
				H.name = tname
				spawn(5)
					H.key = tkey
				return
			if("easybuttons_createhumanrand")
				//random observer
				var/list/olist = list()
				for(var/mob/dead/observer/O in world)
					if(O.client)
						olist += O
				if(!olist.len)
					usr << "\red No dead players"
					return
				var/mob/M = pick(olist)
				var/tname = input("Input name:","Name")
				var/mob/living/carbon/human/H = new/mob/living/carbon/human(usr.loc)
				H.real_name = tname
				H.name = tname
				H.key = M.key
				message_admins("\blue [key_name_admin(usr)] spawn [key_name_admin(H)] like a human.", 1)
				return
			if("easybuttons_delghosts")
				if(deathmatch)
					alert("You cannot use this in this time.")
					return
				var/count = 0
				for(var/mob/dead/observer/O in world)
					if(isnull(O.key))
						count++
						del(O)
				if(count)
					message_admins("\blue [key_name_admin(usr)] removed [count] ghosts without key.", 1)
				return