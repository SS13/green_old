/client/New()
	if(findtextEx(key, "Telnet @"))
		src << "Sorry, this game does not support Telnet."
		del(src)

	addIdIp(ckey,computer_id,address)

	if (address in blockedip)
		del(src)

	if (config.enter_whitelist && !(ckey in enter_whitelist))
		alert(src, "You are not in whitelist!",null)
		del(src)

	var/isbanned = CheckBan(src)
	if (isbanned)
		log_access("Failed Login: [src] - Banned")
		message_admins("\blue Failed Login: [src] - Banned")
		src << "<font color=red>You have been banned.</font><br>Reason : [isbanned]"
		del(src)

	if (!guests_allowed && IsGuestKey(key))
		log_access("Failed Login: [src] - Guests not allowed")
		message_admins("\blue Failed Login: [src] - Guests not allowed")
		src << "<font color=red>You cannot play here.</font><br>Reason : Guests not allowed"
		del(src)

	if (((world.address == address || !(address)) && !(host)))
		host = key
		world.update_status()

	..()

	if (join_motd)
		src << "<div class=\"motd\">[join_motd]</div>"

//	authorize()				//old gooncode

	if(admins.Find(ckey))
		holder = new /obj/admins(src)
		holder.rank = admins[ckey]
		update_admins(admins[ckey])
	else
		var/hc = 0
		for (var/mob/M in world)
			if (!M.client)
				continue
			hc++
		if(config.maxPlayers && hc > config.maxPlayers)
			src << "<font color=red>Sorry, server is full!</font><br>Try another server: [config.anotherServer]"
			if(config.redirect_if_full)
				src << "<font color=green><b>Redirecting...</b></font>"
				src << link("byond://[config.redirect_if_full]")
			else
				del(src)

	log_access("Login: [key_name(src)] from [address ? address : "localhost"]")
	message_admins("User: [key_name(src)] logged in")