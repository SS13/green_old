/client/proc/set_max_players(C as num)
	set name = "Set slots count"
	set desc = "Count of players who can enter game"
	set category = "Debug"

	config.maxPlayers = C
	message_admins("\blue [key_name_admin(usr)] set slots count to [C ? C : "infinity"]", 1)
	return


/client/proc/toggle_singulo_possession()
	set name = "Toggle singulo possession"
	set category = "Server"
	set desc = "Toggle possession of gravitational singularities"

	message_admins("\blue [key_name(usr)] toggled singulo possession to [config.forbid_singulo_possession].")
	config.forbid_singulo_possession = !(config.forbid_singulo_possession)


/client/proc/warn_key()
	set name = "Warn Key"
	set desc = "Warn easy!"
	set category = "Special Verbs"

	var/list/players = new/list()
	for(var/client/C)
		if(!C.mob)
			continue
		players[C.key + " ([C.mob.name])"] = C.mob
	var/mob/M = players[input("Select player to warn","Warn Key")as null|anything in players]
	if(isnull(M))
		return

	warn(M)

/client/proc/controlpanel()
	set name = "Control panel"
	set category = "Debug"
	set desc = "You are admin of admins!"

	if (!istype(src,/obj/admins))
		src = usr.client.holder
	if (!istype(src,/obj/admins))
		usr << "Error: you are not an admin!"
		return

	var/dat = "<html><head><title>Control Panel</title></head>"
	dat += "<b>Control panel</b><br><br>"
	dat += "Files:<br>"
	dat += "<A HREF='?src=\ref[src];controlpanel=readfile'>Read textfile</A><br>"
//	dat += "<A HREF='?src=\ref[src];controlpanel=editfile'>Edit textfile</A><br>"
//	dat += "<A HREF='?src=\ref[src];controlpanel=editfile'>Edit textfile</A><br>"
	dat += "<br>"
	dat += "SQL:<br>"
	dat += "Jobs: <A HREF='?src=\ref[src];controlpanel=sql_jobsplayer'>show selected player jobs</A><br>"
	dat += "Jobs: <A HREF='?src=\ref[src];controlpanel=sql_playersjob'>show selected job players</A><br>"
	dat += "Karma: <A HREF='?src=\ref[src];controlpanel=sql_karmaspender'>show changes by player</A><br>"
	dat += "Karma: <A HREF='?src=\ref[src];controlpanel=sql_karmareceiver'>show player karma changes</A><br>"
	dat += "Library: <A HREF='?src=\ref[src];controlpanel=sql_lib_showbyid'>show book by id</A><br>"
	dat += "Spy: <A HREF='?src=\ref[src];controlpanel=sql_spyjustshow'>show selected ckey info</A><br>"
	dat += "Spy: <A HREF='?src=\ref[src];controlpanel=sql_findip'>find ip</A><br>"
	dat += "Spy: <A HREF='?src=\ref[src];controlpanel=sql_findcompid'>find compid</A><br>"
	dat += "Population: <A HREF='?src=\ref[src];controlpanel=sql_population'>create data file</A><br>"
	dat += "Log: <A HREF='?src=\ref[src];controlpanel=sql_banslog'>bans log</A><br>"
	dat += "Log: <A HREF='?src=\ref[src];controlpanel=sql_banslogspecial'>show bans log for ckey</A><br>"
	dat += "<br>"
	dat += "Other:<br>"
	dat += "<A HREF='?src=\ref[src];controlpanel=checkdonators'>Check donators list</A><br>"
	dat += "<A HREF='?src=\ref[src];controlpanel=reloadipblocks'>Reload IP blocks</A><br>"
//	dat += "<A HREF='?src=\ref[src];controlpanel=reloadipblocks'>Reload IP blocks</A><br>"
//at += "<A HREF='?src=\ref[src];controlpanel=spybackup'>Spy database backup</A><br>"

	dat += "<br><br><A HREF='?src=\ref[src];controlpanel=oldbanstodb'>Move bans to DB</A> - use only once!<br>"

	usr << browse(dat, "window=controlpanel")

/obj/admins/Topic(href, href_list)
	..()
	if(href_list["controlpanel"])
		var/dat = "<html><head><title>Control Panel</title></head>"
		dat += "<b>Control panel</b> (<A HREF='?src=\ref[src];controlpanel=returntomenu'>return</A>)<br><br>"
		switch(href_list["controlpanel"])
			if("returntomenu")
				return
			if("readfile")
				var/fname = input("Filename","Filename","config/config.txt")
				var/text = file2text(fname)
				if(!text)
					return
				dat += "<b>[fname]:</b><br><br><pre>[text]</pre>"
				usr << browse(dat, "window=controlpanel")
				return
			if("editfile")
				dat += "<font color=red>Attention: Don't be a dick.</font><br>"
				usr << browse(dat, "window=controlpanel")
				var/fname = input("Filename","Filename","config/laureates.txt") as text|null
				if(!fname)
					dat += "Cancelled.<br>"
					usr << browse(dat, "window=controlpanel")
					return
				var/text = file2text(fname)

				var/newtext = input("Edit file:", "Edit file", text) as message|null
				if(!newtext)
					dat += "Cancelled.<br>"
					usr << browse(dat, "window=controlpanel")
					return
				if(fexists(fname))
					fdel(fname)
				if(text2file(newtext,fname))
					dat += "Success!<br>"
				else
					dat += "Error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("reloadipblocks")
				UpdateIpBlocks()
				alert("Ok.",null)
			if("sql_jobsplayer")
				var/player = input("Input player key:","Select player") as text|null
				if(!player)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT job, fromstart, afterstart FROM jobs WHERE byondkey = '[player]'")
					if(query.Execute())
						dat += "Jobs player [player]:<br>"
						dat += "<table border=1 cellspacing=0><tr><td>Job</td><td>S</td><td>J</td></tr>"
						while(query.NextRow())
							dat += "<tr><td>[query.item[1]]</td><td>[query.item[2]]</td><td>[query.item[3]]</td></tr>"
						dat += "</table>"
					else
						dat += "query.Execute() error: [query.ErrorMsg()]<br>"
				else
					dat += "SQL connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_playersjob")
				var/job = input("Input job:","Select job") as text|null
				if(!job)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT byondkey, fromstart, afterstart FROM jobs WHERE job = '[job]'")
					if(query.Execute())
						dat += "Players job [job]:<br>"
						dat += "<table border=1 cellspacing=0><tr><td>Player</td><td>S</td><td>J</td></tr>"
						while(query.NextRow())
							dat += "<tr><td>[query.item[1]]</td><td>[query.item[2]]</td><td>[query.item[3]]</td></tr>"
						dat += "</table>"
					else
						dat += "query.Execute() error: [query.ErrorMsg()]<br>"
				else
					dat += "SQL connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_karmaspender")
				var/spender = input("Input spender key:","Show karma changes") as text|null
				if(!spender)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT spendername, receiverkey, receivername, receiverrole, receiverspecial, isnegative, time FROM karma WHERE spenderkey = '[spender]'")
					if(query.Execute())
						dat += "Karma spends by [spender]:<br>"
						dat += "<table border=1 cellspacing=0><tr><td>SName</td><td>RKey</td><td>RName</td><td>RRole</td><td><RSpecial></td><td></td><td>Time</td></tr>"
						while(query.NextRow())
							dat += "<tr><td>[query.item[1]]</td><td>[query.item[2]]</td><td>[query.item[3]]</td><td>[query.item[4]]</td><td>[query.item[5]]</td><td>[text2num(query.item[6]) ? "-" : "+"]</td><td>[query.item[7]]</td></tr>"
						dat += "</table>R: Receiver, S: Spender<br>"
					else
						dat += "query.Execute() error: [query.ErrorMsg()]<br>"
					dbcon.Disconnect()
				else
					dat += "SQL connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_karmareceiver")
				var/receiver = input("Input receiver key:","Show karma changes") as text|null
				if(!receiver)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT spendername, spenderkey, receivername, receiverrole, receiverspecial, isnegative, time FROM karma WHERE receiverkey = '[receiver]'")
					if(query.Execute())
						dat += "[receiver] karma changes:<br>"
						dat += "<table border=1 cellspacing=0><tr><td>SName</td><td>SKey</td><td>RName</td><td>RRole</td><td><RSpecial></td><td></td><td>Time</td></tr>"
						while(query.NextRow())
							dat += "<tr><td>[query.item[1]]</td><td>[query.item[2]]</td><td>[query.item[3]]</td><td>[query.item[4]]</td><td>[query.item[5]]</td><td>[text2num(query.item[6]) ? "-" : "+"]</td><td>[query.item[7]]</td></tr>"
						dat += "</table>R: Receiver, S: Spender<br>"
					else
						dat += "query.Execute() error: [query.ErrorMsg()]<br>"
					dbcon.Disconnect()
				else
					dat += "SQL connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_lib_showbyid")
				var/bookid = input("Input ID of book","Show by ID") as num|null
				if(!bookid)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query_set
					query_set= dbcon.NewQuery("SET NAMES 'cp1251';")
					query_set.Execute()
					query_set= dbcon.NewQuery("SET CHARACTER SET 'cp1251';")
					query_set.Execute()
					query_set= dbcon.NewQuery("SET SESSION collation_connection = 'cp1251_general_ci';")
					query_set.Execute()
					var/DBQuery/query = dbcon.NewQuery("SELECT author, title, category, content FROM library WHERE id = '[bookid]'")
					if(query.Execute())
						dat += "Book [bookid]:<br>"
						while(query.NextRow())
							dat += "Author: [query.item[1]] <A HREF='?src=\ref[src];controlpanel=sql_lib_changebook;action=setauthor;bookid=[bookid]'>(change)</A><br>"
							dat += "Title: [query.item[2]] <A HREF='?src=\ref[src];controlpanel=sql_lib_changebook;action=settitle;bookid=[bookid]'>(change)</A><br>"
							dat += "Category: [query.item[3]] <A HREF='?src=\ref[src];controlpanel=sql_lib_changebook;action=setcategory;bookid=[bookid]'>(change)</A><br>"
							dat += "Delete book from database: <A HREF='?src=\ref[src];controlpanel=sql_lib_changebook;action=delete;bookid=[bookid]'>click</A><br><br>"
							dat += query.item[4]
							break
						dbcon.Disconnect()
					else
						dat += "query.Execute() error: [query.ErrorMsg()]<br>"
				else
					dat += "SQL connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_lib_changebook")
				var/sqlquery
				var/newtext
				switch(href_list["action"])
					if("setauthor")
						newtext = input("Input new author","Set author") as text|null
						sqlquery = "UPDATE library SET author=\"[newtext]\" WHERE id=[href_list["bookid"]]"
					if("settitle")
						newtext = input("Input new title","Set title") as text|null
						sqlquery = "UPDATE library SET title=\"[newtext]\" WHERE id=[href_list["bookid"]]"
					if("setcategory")
						newtext = input("Input new category","Set category") as text|null
						sqlquery = "UPDATE library SET category=\"[newtext]\" WHERE id=[href_list["bookid"]]"
					if("delete")
						sqlquery = "DELETE FROM library WHERE id=[href_list["bookid"]]"
						if(alert("Are you sure to delete book [href_list["bookid"]]?","DELETE BOOK","Yes","No")=="Yes")
							newtext = 1
				if(!newtext)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery(sqlquery)
					if(query.Execute())
						alert("Okay.jpg",null,"Ok")
					else alert("Fail",null,"=(")
					dbcon.Disconnect()
				return
			if("sql_spyjustshow")
				var/byondkey = input("Input ckey","SPY") as text|null
				if(!byondkey)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT computerid, ip FROM spy WHERE byondkey='[byondkey]'")
					if(query.Execute())
						while(query.NextRow())
							dat += "Known <i>[byondkey]</i> compid:<br>"
							for(var/t in dd_text2list(query.item[1], ";"))
								dat += "[t]<br>"
							dat += "Known <i>[byondkey]</i> ip:<br>"
							for(var/t in dd_text2list(query.item[2], ";"))
								dat += "[t]<br>"
						dbcon.Disconnect()
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_findip")
				var/ip = input("Input IP","Find IP") as text|null
				if(!ip)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT byondkey FROM spy WHERE ip LIKE '%[ip]%'")
					if(query.Execute())
						dat += "Find IP [ip]:<br>"
						while(query.NextRow())
							dat += "[query.item[1]]<br>"
						dbcon.Disconnect()
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
			if("sql_findcompid")
				var/compid = input("Input computer ID","Find by compid") as text|null
				if(!compid)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT byondkey FROM spy WHERE computerid LIKE '%[compid]%'")
					if(query.Execute())
						dat += "Find compid [compid]:<br>"
						while(query.NextRow())
							dat += "[query.item[1]]<br>"
						dbcon.Disconnect()
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel")
				return
		/*	if("sql_population")
				var/tfile = input("Write to:","Filename","data/population.txt") as text|null
				dat += "Target filename: [tfile]<br>"
				var/separator = input("Input separator:","Separator") as text|null
				dat += "Separator: [separator]<br>"
				if(!tfile)
					return
				var/filedata = ""
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT id, playercount, admincount, time FROM population")
					if(query.Execute())
						while(query.NextRow())
							filedata += "[query.item[1]][separator][query.item[2]][separator][query.item[3]][separator][query.item[4]]\n"
						dbcon.Disconnect()
						if(text2file(filedata,tfile))
							dat += "Writing success.<br>"
						else
							dat += "Writing failed.<br>"
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel") */
			if("sql_banslog")
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())

					var/DBQuery/query_set
					query_set= dbcon.NewQuery("SET NAMES 'cp1251';")
					query_set.Execute()
					query_set= dbcon.NewQuery("SET CHARACTER SET 'cp1251';")
					query_set.Execute()
					query_set= dbcon.NewQuery("SET SESSION collation_connection = 'cp1251_general_ci';")
					query_set.Execute()

					var/DBQuery/query = dbcon.NewQuery("SELECT targetkey, adminkey, action, time, notes FROM banslog WHERE bantype='ban' ORDER BY time DESC")
					if(query.Execute())
						dat += "<table border=1 rules=all frame=void cellspacing=0 cellpadding=3>"
						while(query.NextRow())
							var/actchar
							var/bgcolor
							switch(query.item[3])
								if("add")
									actchar = "A"
									bgcolor = "#ccffcc"
								if("edit")
									actchar = "E"
									bgcolor = "#ffffcc"
								if("remove")
									actchar = "R"
									bgcolor = "#ffcccc"
							dat += "<tr bgcolor=\"[bgcolor]\"><td>[actchar]</td><td>[query.item[1]]</td><td>[query.item[2]]</td><td>[query.item[4]]</td><td>[query.item[5]]</td></tr>"
						dbcon.Disconnect()
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel")
			if("sql_banslogspecial")
				var/ckey = input("Input target ckey",null) as null|text
				if(!ckey)
					return
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())

					var/DBQuery/query_set
					query_set= dbcon.NewQuery("SET NAMES 'cp1251';")
					query_set.Execute()
					query_set= dbcon.NewQuery("SET CHARACTER SET 'cp1251';")
					query_set.Execute()
					query_set= dbcon.NewQuery("SET SESSION collation_connection = 'cp1251_general_ci';")
					query_set.Execute()

					var/DBQuery/query = dbcon.NewQuery("SELECT targetkey, adminkey, action, time, notes FROM banslog WHERE bantype='ban' AND targetkey='[ckey]' OR adminkey='[ckey]' OR notes LIKE '%[ckey]%' ORDER BY time DESC")
					if(query.Execute())
						dat += "<table border=1 rules=all frame=void cellspacing=0 cellpadding=3>"
						while(query.NextRow())
							var/actchar
							var/bgcolor
							switch(query.item[3])
								if("add")
									actchar = "A"
									bgcolor = "#ccffcc"
								if("edit")
									actchar = "E"
									bgcolor = "#ffffcc"
								if("remove")
									actchar = "R"
									bgcolor = "#ffcccc"
							dat += "<tr bgcolor=\"[bgcolor]\"><td>[actchar]</td><td>[query.item[1]]</td><td>[query.item[2]]</td><td>[query.item[4]]</td><td>[query.item[5]]</td></tr>"
						dbcon.Disconnect()
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel")
			if("checkdonators")
				dat += "Donators list:<br>"
				for(var/t in donators)
					dat += "[t]:[donators[t]]<br>"
				dat += "<br>Special:<br>"
				for(var/t in donators_special)
					dat += "[t]:[donators_special[t]]"
				usr << browse(dat, "window=controlpanel")
			if("oldbanstodb")
				if(alert("Are you sure?","Move bans","Yes","No") == "No")
					return
				var/CMinutes = world.realtime / 600
				//load
				dat += "LoadBans()<br>"
				var/savefile/Banlist = new("data/banlist.bdb")
				if (!length(Banlist.dir)) dat += "Banlist is empty.<br>"
				if (!Banlist.dir.Find("base"))
					dat += "Banlist missing base dir.<br>"
					Banlist.dir.Add("base")
					Banlist.cd = "/base"
				else
					Banlist.cd = "/base"
				usr << browse(dat, "window=controlpanel")

				dat += "=============<br>"
				Banlist.cd = "/base"
				for (var/A in Banlist.dir)
					Banlist.cd = "/base/[A]"
					if (!Banlist["key"] || !Banlist["id"])
						Banlist.dir.Remove(A)
						dat += "Invalid Ban: [A].<br>"
						continue

					if (!Banlist["temp"])
						AddBan(Banlist["key"], Banlist["id"], Banlist["reason"], Banlist["bannedby"], 0, 0, 1)
						dat += "Permaban moved: [A]<br>"
						continue
					if (CMinutes >= Banlist["minutes"])
						Banlist.dir.Remove(A)
						dat += "Expired ban removed: [A]<br>"
					else
						AddBan(Banlist["key"], Banlist["id"], Banlist["reason"], Banlist["bannedby"], 1, Banlist["minutes"], 1)
						dat += "Ban moved: [A]<br>"
				usr << browse(dat, "window=controlpanel")
			if("spybackup")
				var/tfile = input("Write to:","Filename","data/spydump.txt") as text|null
				dat += "Target filename: [tfile]<br>"
				var/separator = input("Input separator:","Separator") as text|null
				dat += "Separator: [separator]<br>"
				if(!tfile)
					return
				var/filedata = ""
				var/DBConnection/dbcon = new()
				dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
				if(dbcon.IsConnected())
					var/DBQuery/query = dbcon.NewQuery("SELECT id, byondkey, computerid, ip FROM spy")
					if(query.Execute())
						while(query.NextRow())
							filedata += "[query.item[1]][separator][query.item[2]][separator][query.item[3]][separator][query.item[4]]\n"
						dbcon.Disconnect()
						if(text2file(filedata,tfile))
							dat += "Writing success.<br>"
						else
							dat += "Writing failed.<br>"
					else
						dat += "Query error.<br>"
				else
					dat += "Connection error.<br>"
				usr << browse(dat, "window=controlpanel")


//ip blocks
var/blockedip[0]

/proc/UpdateIpBlocks()
	var/text = file2text("data/bannedip.txt")
	if(!text)
		return
	blockedip = dd_text2list(text, "\n")