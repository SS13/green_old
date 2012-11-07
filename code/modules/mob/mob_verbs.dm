//Admin Verbs
/mob/proc/Cell()
	set category = "Admin"
	set hidden = 1

	if(!loc) return 0

	var/datum/gas_mixture/environment = loc.return_air()

	var/t = "\blue Coordinates: [x],[y] \n"
	t+= "\red Temperature: [environment.temperature] \n"
	t+= "\blue Nitrogen: [environment.nitrogen] \n"
	t+= "\blue Oxygen: [environment.oxygen] \n"
	t+= "\blue Plasma : [environment.toxins] \n"
	t+= "\blue Carbon Dioxide: [environment.carbon_dioxide] \n"
	for(var/datum/gas/trace_gas in environment.trace_gases)
		usr << "\blue [trace_gas.type]: [trace_gas.moles] \n"

	usr.show_message(t, 1)

//IC Verbs

/mob/verb/mode()
	set name = "Activate Held Object"
	set category = "IC"

	set src = usr

	var/obj/item/W = equipped()
	if (W)
		W.attack_self(src)
	return

/atom/verb/examine()
	set name = "Examine"
	set category = "IC"
	set src in oview(12)	//make it work from farther away

	if (!( usr ))
		return
	usr << "That's \a [src]." //changed to "That's" from "This is" because "This is some metal sheets" sounds dumb compared to "That's some metal sheets" ~Carn
	usr << desc
	// *****RM
	//usr << "[name]: Dn:[density] dir:[dir] cont:[contents] icon:[icon] is:[icon_state] loc:[loc]"
	return

//OOC Verbs

/mob/verb/memory()
	set name = "Notes"
	set category = "OOC"
	if(mind)
		mind.show_memory(src)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/verb/add_memory(msg as message)
	set name = "Add Note"
	set category = "OOC"

	msg = copytext(msg, 1, MAX_MESSAGE_LEN)
	msg = sanitize(msg)

	if(mind)
		mind.store_memory(msg)
	else
		src << "The game appears to have misplaced your mind datum, so we can't show you your notes."

/mob/proc/store_memory(msg as message, popup, sane = 1)
	msg = copytext(msg, 1, MAX_MESSAGE_LEN)

	if (sane)
		msg = sanitize(msg)

	if (length(memory) == 0)
		memory += msg
	else
		memory += "<BR>[msg]"

	if (popup)
		memory()

/mob/verb/abandon_mob()
	set name = "Respawn"
	set category = "OOC"

	if (!( abandon_allowed ))
		usr << "\blue Respawn is disabled."
		return
	if ((stat != 2 || !( ticker )))
		usr << "\blue <B>You must be dead to use this!</B>"
		return
	if (ticker.mode.name == "meteor" || ticker.mode.name == "epidemic")
		usr << "\blue Respawn is disabled."
		return

	log_game("[usr.name]/[usr.key] used abandon mob.")

	usr << "\blue <B>Make sure to play a different character, and please roleplay correctly!</B>"

	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return
	for(var/obj/screen/t in usr.client.screen)
		if (t.loc == null)
			//t = null
			del(t)
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		return

	var/mob/new_player/M = new /mob/new_player()
	if(!client)
		log_game("[usr.key] AM failed due to disconnect.")
		del(M)
		return

	if(client && client.holder && (client.holder.state == 2))
		client.admin_play()
		return

	M.key = client.key
	M.respawndelaystart = world.time
	M.Login()
	return

/mob/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	if (client)
		src.getFiles('postcardsmall.jpg',
							 'somerights20.png',
							 '88x31.png',
							 'bug-minus.png',
							 'cross-circle.png',
							 'hard-hat-exclamation.png',
							 'image-minus.png',
							 'image-plus.png',
							 'music-minus.png',
							 'music-plus.png',
							 'tick-circle.png',
							 'wrench-screwdriver.png',
							 'spell-check.png',
							 'burn-exclamation.png',
							 'chevron.png',
							 'chevron-expand.png',
							 'changelog.css',
							 'changelog.js'
							 )
		src << browse('changelog.html', "window=changes;size=675x650")
		client.changes = 1


/mob/verb/observe()
	set name = "Observe"
	set category = "OOC"
	var/is_admin = 0

	if (client.holder && client.holder.level >= 1 && ( client.holder.state == 2 || client.holder.level > 3 ))
		is_admin = 1
	else if (istype(src, /mob/new_player) || stat != 2)
		usr << "\blue You must be observing to use this!"
		return

	if (is_admin && stat == 2)
		is_admin = 0

	var/list/names = list()
	var/list/namecounts = list()
	var/list/creatures = list()

	for (var/obj/item/weapon/disk/nuclear/D in world)
		var/name = "Nuclear Disk"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = D

	for (var/obj/machinery/singularity/S in world)
		var/name = "Singularity"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = S

	for (var/obj/machinery/bot/B in world)
		var/name = "BOT: [B.name]"
		if (name in names)
			namecounts[name]++
			name = "[name] ([namecounts[name]])"
		else
			names.Add(name)
			namecounts[name] = 1
		creatures[name] = B

//THIS IS HOW YOU ADD OBJECTS TO BE OBSERVED

	creatures += getmobs()
//THIS IS THE MOBS PART: LOOK IN HELPERS.DM

	client.perspective = EYE_PERSPECTIVE

	var/eye_name = null

	if (is_admin)
		eye_name = input("Please, select a player!", "Admin Observe", null, null) as null|anything in creatures
	else
		eye_name = input("Please, select a player!", "Observe", null, null) as null|anything in creatures

	if (!eye_name)
		return

	var/mob/eye = creatures[eye_name]
	if (is_admin)
		if (eye)
			reset_view(eye)
			client.adminobs = 1
			if(eye == client.mob)
				client.adminobs = 0
		else
			reset_view(null)
			client.adminobs = 0
	else
		if(ticker && ticker.mode)
//		 world << "there's a ticker"
			if(ticker.mode.name == "AI malfunction")
//				world << "ticker says its malf"
				var/datum/game_mode/malfunction/malf = ticker.mode
				for (var/datum/mind/B in malf.malf_ai)
//					world << "comparing [B.current] to [eye]"
					if (B.current == eye)
						for (var/mob/living/silicon/decoy/D in world)
							if (eye)
								eye = D
		if (client)
			if (eye)
				client.eye = eye
			else
				client.eye = client.mob

/mob/Topic(href, href_list)
	if(href_list["mach_close"])
		var/t1 = text("window=[href_list["mach_close"]]")
		machine = null
		src << browse(null, t1)

	if(href_list["teleto"])
		client.jumptoturf(locate(href_list["teleto"]))

	if(href_list["priv_msg"])
		var/mob/M = locate(href_list["priv_msg"])
		if(M)
			//if(src.client && client.muted_complete)
			//	src << "You are muted have a nice day"
			//	return
			if (!ismob(M))
				return

			var/recipient_name = M.key
			if(M.client && M.client.holder && M.client.stealth)
				recipient_name = "Administrator"

			//This should have a check to prevent the player to player chat but I am too tired atm to add it.
			var/t = input("Message:", text("Private message to [recipient_name]"))  as text|null
			if (!t || !usr || !usr.client)
				return
			if (usr.client && usr.client.holder)
				M << "\red Admin PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
				usr << "\blue Admin PM to-<b>[key_name(M, usr, 1)]</b>: [t]"
			else
				if (M)
					if (M.client && M.client.holder)
						M << "\blue Reply PM from-<b>[key_name(usr, M, 1)]</b>: [t]"
					else
						M << "\red Reply PM from-<b>[key_name(usr, M, 0)]</b>: [t]"
					usr << "\blue Reply PM to-<b>[key_name(M, usr, 0)]</b>: [t]"

			log_admin("PM: [key_name(usr)]->[key_name(M)] : [t]")

			//we don't use message_admins here because the sender/receiver might get it too
			for (var/mob/K in world)
				if(K && usr)
					if(K.client && K.client.holder && K.key != usr.key && K.key != M.key)
						K << "<b><font color='blue'>PM: [key_name(usr, K)]->[key_name(M, K)]:</b> \blue [t]</font>"
	if(href_list["flavor_more"])
		usr << browse(text("<HTML><HEAD><TITLE>[]</TITLE></HEAD><BODY><TT>[]</TT></BODY></HTML>", name, dd_replacetext(flavor_text, "\n", "<BR>")), text("window=[];size=500x200", name))
		onclose(usr, "[name]")
	if(href_list["flavor_change"])
		update_flavor_text()
//	..()
	return

/mob/verb/cancel_camera()
	set name = "Cancel Camera View"
	set category = "OOC"
	reset_view(null)
	machine = null
	if(istype(src, /mob/living))
		if(src:cameraFollow)
			src:cameraFollow = null

/client/var/ghost_ears = 1
/client/verb/toggle_ghost_ears()
	set name = "Ghost ears"
	set category = "OOC"
	set desc = "Hear talks from everywhere"
	ghost_ears = !ghost_ears
	if (ghost_ears)
		usr << "\blue Now you hear all speech in the world"
	else
		usr << "\blue Now you hear speech only from nearest creatures."

/client/var/ghost_sight = 1
/client/verb/toggle_ghost_sight()
	set name = "Ghost sight"
	set category = "OOC"
	set desc = "Hear emotes from everywhere"
	ghost_sight = !ghost_sight
	if (ghost_sight)
		usr << "\blue Now you hear all emotes in the world"
	else
		usr << "\blue Now you hear emotes only from nearest creatures."