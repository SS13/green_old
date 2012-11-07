//global var
/var/datum/deathmatch/deathmatch = null


/datum/deathmatch
	//team attached lists
	var/list/teamname
	var/list/lastnames //of created humans
	var/list/turf/spawn_point
	//clothing
	var/list/jumpsuit
	var/list/radiofreq

	var/players[0] ///assotiative list, "ckey"=number of team
	var/cmobs[0] //ckey = current (spawned) mob
	var/ghosts[0] //assotiative list, "ckey"=ref on origin mob

	//statistics
	var/deathcount = 0
	var/DMlog = ""

/datum/deathmatch/proc/logmessage(var/message)
	DMlog += message + "<br>"

/datum/deathmatch
	proc/addplayer(var/mob/M,var/sel_team)
		if(!M)
			return
		if(!istype(M,/mob/dead/observer))
			alert("Wrong mob! Must be a dead!",null)
			return
		if(!M.client && !M.key)
			alert("[M.name] have no player.",null)
			return
		var/pkey = M.key
		logmessage("Player: [pkey] ([M.name]) added to [sel_team] team.")
		ghosts[pkey] = M
		players[pkey] = sel_team
		cmobs[pkey] = M
		return

	proc/removeplayer(var/player)
		if(!players[player])
			return
		logmessage("Player: [player] removed from deathmatch.")
		var/mob/G = ghosts[player]
		G.key = player
		ghosts -= player
		players -= player
		cmobs -= player
		return

	proc/respawnplayer(var/player)
		var/cteam = players[player]
		var/mob/living/carbon/human/H = cmobs[player]
		if(!istype(H) || H.stat == 2) //observer or dead
			H = new/mob/living/carbon/human(spawn_point[cteam])
			H.real_name = pick(first_names_male) + " " + lastnames[cteam]
			H.name = H.real_name
			H.key = player
			cmobs[player] = H
		else //living human, heal and teleport he to spawn
			H.toxloss = 0
			H.oxyloss = 0
			H.paralysis = 0
			H.stunned = 0
			H.weakened = 0
			H.radiation = 0
			H.nutrition = 400
			H.heal_overall_damage(1000, 1000)
			H.buckled = initial(H.buckled)
			H.handcuffed = initial(H.handcuffed)
			if (H.stat)
				H.stat=0
			H.loc = spawn_point[cteam]
		//equip
		var/jsuit = jumpsuit[cteam]
		H.equip_if_possible(new jsuit(H), H.slot_w_uniform)
		H.equip_if_possible(new/obj/item/clothing/shoes/black(H), H.slot_shoes)
		var/obj/item/device/radio/headset/headset = new/obj/item/device/radio/headset(H)
		headset.freerange = 1
		headset.set_frequency(radiofreq[cteam])
		H.equip_if_possible(headset,H.slot_ears)


		return

/datum/deathmatch/Topic(href, href_list)
	if(href_list["command"])
		var/dat = "<html><head><title>Deathmatch</title></head>"
		dat += "<b>Deathmatch</b> (<A HREF='?src=\ref[src];command=returntomenu'>return</A>)<br><br>"
		switch(href_list["command"])
			if("returntomenu")
				if(usr.client.holder)
					usr.client.holder.animus_deathmatch()
			if("setup")
				dat += "<b>Setup teams</b> (<A HREF='?src=\ref[src];command=setup'>refresh</A>)<br>"
				var/teamscount = teamname.len
				if(teamscount)
					for(var/i = 1, i <= teamscount, i++)
						dat += "Team [i]: <A HREF='?src=\ref[src];command=setup_teamname;team=[i]'>[teamname[i]]</A><br>"
						dat += "Players lastname: <A HREF='?src=\ref[src];command=setup_lastnames;team=[i]'>[lastnames[i]]</A><br>"
						var/turf/T = spawn_point[i]
						dat += "Spawn point: X:[T.x] Y:[T.y] Z:[T.z]"
						dat += " || <A HREF='?src=\ref[src];command=setup_spawnjumpto;team=[i]'>jump</A>"
						dat += " || <A HREF='?src=\ref[src];command=setup_spawnsetloc;team=[i]'>set loc</A><br>"
						dat += "Jumpsuit: [jumpsuit[i]]<br>"
						dat += "Radio frequency:  <A HREF='?src=\ref[src];command=setup_freq;team=[i]'>[radiofreq[i]]</A><br>"
						dat += "============<br>"
				else
					dat += "Error: no teams!<br>"
				usr << browse(dat, "window=animus_dm")
			if("setup_teamname")
				var/newname = input("Input new team name:","Team name") as text|null
				if(newname)
					teamname[text2num(href_list["team"])] = newname
					logmessage("Setup: name of team [href_list["team"]] changed to [newname].")
			if("setup_lastnames")
				var/newname = input("Input new lastname:","Players lastname") as text|null
				if(newname)
					lastnames[text2num(href_list["team"])] = newname
					logmessage("Setup: lastname of team [href_list["team"]] changed to [newname].")
			if("setup_spawnjumpto")
				usr.loc = spawn_point[text2num(href_list["team"])]
			if("setup_spawnsetloc")
				if(alert("Are you sure?","Set spawn point","Yes","No")=="Yes")
					spawn_point[text2num(href_list["team"])] = get_turf(usr)
					logmessage("Setup: spawn point of team [href_list["team"]] changed.")
			if("setup_freq")
				var/newfreq = input("Input new frequency (in range 1200-1600)","Frequency") as num|null
				if(newfreq)
					radiofreq[text2num(href_list["team"])] = newfreq
					logmessage("Setup: frequency of team [href_list["team"]] changed to [newfreq].")
			if("players")
				dat += "<b>Players</b> (<A HREF='?src=\ref[src];command=players'>refresh</A>)<br>"
				dat += "X: delete, R: respawn<br>"
				dat += "=============<br>"
				if(teamname.len)
					for(var/i = 1, i <= teamname.len, i++)
						dat += "Team [i]: [teamname[i]]<br>"
						for(var/P in players)
							if(players[P] == i)
								var/mob/M = cmobs[P]
								if(istype(M,/mob/dead/observer))
									dat += "[P] had never started "
								else
									dat += "[P] - [M.real_name]: HP([M.health]) "
								dat += "|| <A HREF='?src=\ref[src];command=players_respawn;player=[P]'>R</A>"
								dat += "|| <A HREF='?src=\ref[src];command=players_remove;player=[P]'>X</A><br>"
						dat += "<A HREF='?src=\ref[src];command=players_add;rpage=players;team=[i]'>Add player</A><br>"
				else
					dat += "Error: no teams<br>"
				usr << browse(dat, "window=animus_dm")
			if("players_remove")
				if(alert("Are you sure to remove [href_list["player"]] from deathmatch?","Remove player","Yes","No")=="Yes")
					removeplayer(href_list["player"])
			if("players_respawn")
				if(alert("Are you sure to respawn [href_list["player"]]?","Respawn","Yes","No")=="Yes")
					respawnplayer(href_list["player"])
			if("players_add")
				var/list/allghosts = new/list()
				var/mob/dead/observer/O
				for(O in world)
					if(O.key && O.client)
						if(!(O.key in players))
							allghosts["[O.key] - [O.name]"] = O
				var/sgh = input("Select ghost:","Add player") as null|anything in allghosts
				if(sgh)
					addplayer(allghosts[sgh],text2num(href_list["team"]))
			if("control")
				dat += "<b>Control</b> (<A HREF='?src=\ref[src];command=control'>refresh</A>)<br>"
				dat += "<A HREF='?src=\ref[src];command=control_respawn'>Respawn all</A><br>"
				usr << browse(dat, "window=animus_dm")
			if("control_respawn")
				logmessage("Control: respawn all.")
				for(var/i in players)
					respawnplayer(i)
			if("log")
				dat += DMlog
				usr << browse(dat, "window=animus_dm")
			if("fullstop")
				if(alert("Are you sure to stop battle?","Stop deathmatch","Yes","No")=="Yes")
					logmessage("<b>Deathmatch fully stopped</b>, all players returned to thier ghosts.")
					for(var/P in players)
						removeplayer(P)
	if(href_list["rpage"])
		deathmatch.Topic("",list("command"=href_list["rpage"])) //refresh

//VERB
/obj/admins/proc/animus_deathmatch()
	set name = "Deathmatch"
	set desc = "DM control panel"
	set category = "Fun"

	if (!istype(src,/obj/admins))
		src = usr.client.holder
	if (!istype(src,/obj/admins))
		usr << "Error: you are not an admin!"
		return

	var/dat = "<html><head><title>Deathmatch</title></head>"

	dat += "<b>Deathmatch</b><br><br>"
	if(!deathmatch)
		if(alert("Create deathmatch?","Deathmatch","Yes","No") == "No")
			return
		deathmatch = new /datum/deathmatch
		//standart teams setting up
		deathmatch.teamname = new/list(2)
		deathmatch.teamname[1] = "Red team"
		deathmatch.lastnames = new/list(2)
		deathmatch.lastnames[1] = pick("Stall","Harrow","Sholl")
		deathmatch.spawn_point = new/list(2)
		deathmatch.spawn_point[1] = locate(117,75,2)
		deathmatch.jumpsuit = new/list(2)
		deathmatch.jumpsuit[1] = /obj/item/clothing/under/color/red
		deathmatch.radiofreq = new/list(2)
		deathmatch.radiofreq[1] = 1221
		deathmatch.teamname[2] = "Green team"
		deathmatch.lastnames[2] = pick("Baer","Kadel","Noton")
		deathmatch.spawn_point[2] = locate(139,75,2)
		deathmatch.jumpsuit[2] = /obj/item/clothing/under/color/green
		deathmatch.radiofreq[2] = 1241
		deathmatch.logmessage("Deathmatch created.")

	dat += "<A HREF='?src=\ref[deathmatch];command=players'>Players</A><br>"
	dat += "<A HREF='?src=\ref[deathmatch];command=control'>Control</A><br>"
	dat += "<A HREF='?src=\ref[deathmatch];command=setup'>Setup</A><br>"
	dat += "<A HREF='?src=\ref[deathmatch];command=log'>Show log</A><br>"

	dat += "<br><A HREF='?src=\ref[deathmatch];command=fullstop'>Stop deathmatch</A> (return all players to thier original ghosts)<br>"


	usr << browse(dat, "window=animus_dm")