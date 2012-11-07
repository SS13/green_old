/mob/proc/unlock_medal(title, announce)
	spawn()
		if(ismob(src) && src.key)
			if(world.SetMedal(title, src, config.medal_hub, config.medal_password) == 1)
				if(announce)
					world << "<font color=olive><b>[src.key] earned the &quot;[title]&quot; medal.</b></font>"
				if(!announce)
					src << "<font color=olive><b>You earned the &quot;[title]&quot; medal! Only 4 your eyes.</b></font>"
					message_admins("[src.key] earned the &quot;[title]&quot; medal.")

/client/proc/unlock_medal_client(title, announce)
	spawn()
		if(!ismob(src) && src.key)
			if(world.SetMedal(title, src, config.medal_hub, config.medal_password) == 1)
				if(announce)
					world << "<font color=olive><b>[src.key] earned the &quot;[title]&quot; medal.</b></font>"
				if(!announce)
					src << "<font color=olive><b>You earned the &quot;[title]&quot; medal! Only 4 your eyes.</b></font>"
					message_admins("[src.key] earned the &quot;[title]&quot; medal.")

/client/verb/cmd_medals()
	set category = "OOC"
	set name = "Medals"

	world.hub = config.medal_hub // they say it can be null, but then isnt working
	world.hub_password = config.medal_password

	src << "Stealing your medal information..."

	var/medal // kinda defining as null
	var/pMedals = world.GetMedal(medal, usr, config.medal_hub) // medal, who, hub
	var/lMedals = params2list(pMedals) // making them a list

	var/medal_got // For output
	var/medal_count = 0 // For counting
	src << "<b>Medals:</b>" // First line
	for (medal_got in lMedals)
		src << "<li>            [medal_got]</li>" // leaving alot of        space
		medal_count++ // showing the medal name and counting it

	src << "<b>You have [medal_count] medals.</b>" // and showing amount of medals
