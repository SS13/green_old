/mob/verb/traitorstats()
	set category = "Special Verbs"
	set name = "Traitor statistics"
	set desc = "Thats your personal raiting in syndicate. Hiegher rating - harder missions"
	if(istype(usr,/mob))
		var/mob/M = usr
		var/savefile/info = new("data/player_saves/[copytext(M.ckey, 1, 2)]/[M.ckey]/traitor.sav")
		var/list/infos
		info >> infos
		if(istype(infos))
			var/total_attempts = infos["Total"]
			var/total_overall_success = infos["Success"]
			var/success_ratio = total_overall_success/total_attempts
			var/steal_success = infos["Steal"]
			var/kill_success = infos["Kill"]
			var/frame_success = infos["Frame"]
			var/protect_success = infos["Protect"]
			var/steal_need = infos["Steal_Total"]
			var/kill_need = infos["Kill_Total"]
			var/frame_need = infos["Frame_Total"]
			var/protect_need = infos["Protect_Total"]
			var/dat
			dat = "<center>Your personal statistics in syndicate</center><BR><BR>"
			dat+= text("Got [] missions.<BR>", total_attempts)
			dat+= text("Succeed in [] missions.<BR><BR>", total_overall_success)
			dat+= "<center>Overall Success Rate <BR>"
			var i = 0
			while(i < 40)
				if(i<success_ratio*40)
					dat+= "<span style='background-color: #C80000; color: #C80000;'>-</span>"
				else
					dat+= "<span style='background-color: #500000; color: #500000;'>-</span>"
				i++

			dat+= "</center><BR><BR>"
			dat+= text("Successfully stole [] valuable items of [] requested.<BR> ", round(steal_success*steal_need), steal_need)
			dat+= text("Assassinated [] targets of [] ordered .<BR>", round(kill_success*kill_need), kill_need)
			dat+= text("Framed [] syndicate enemies of [] needed.<BR>", round(frame_success*frame_need), frame_need)
			dat+= text("Protected [] important employees of [] pointed.<BR>", round(protect_success*protect_need), protect_need)

			var/ranked

			if(total_overall_success > 130)
				ranked = "SHEPARD"
			else if(total_overall_success > 110)
				ranked = "NANOTRASEN FEAR"
			else if(total_overall_success > 90)
				ranked = "SILENT ASSASSIN"
			else if(total_overall_success > 70)
				ranked = "PROFESSIONAL"
			else if(total_overall_success > 50)
				ranked = "BOND. SPACE BOND"
			else if(total_overall_success > 30)
				ranked = "EXPERIENCED AGENT"
			else if(total_overall_success > 12)
				ranked = "ASSISTANT"
			else if(total_overall_success > 7)
				ranked = "HANDCHANGE GURU"
			else if(total_overall_success > 3)
				ranked = "ROOKIE"
			else
				ranked = "NEWEBE"

			dat+= text("<BR><BR><center>According to the data your rank in our organisation - []</center>", ranked)


			M << browse(text("<HEAD><TITLE>Traitor statistics</TITLE></HEAD><BODY bgcolor='#100000' text='white'><TT><strong>[]</strong></TT></BODY>", dat), "window=trait_rec;size=500x320")
		else
			M << "\red No any statistics found"
		return
