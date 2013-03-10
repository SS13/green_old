
var/jsonpath = "/srv/byond/green"
var/dmepath = "/srv/byond/green/baystation12.dme"
var/makejson = 0 //temp
/proc/switchmap(newmap,newpath)
	var/oldmap
	var/obj/mapinfo/M = locate()

	if(M)
		oldmap = M.mapname

	else
		message_admins("Did not locate mapinfo object. Go bug the mapper to add a /obj/mapinfo to their map!\n For now, you can probably spawn one manually. If you do, be sure to set it's mapname var correctly, or else you'll just get an error again.")
		return

	message_admins("Current map: [oldmap]")
	var/text = file2text(dmepath)
	var/path = "#include \"maps/[oldmap].dmm\""
	var/xpath = "#include \"maps/[newpath].dmm\""
	var/loc = findtext(text,path,1,0)
	if(!loc)
		path = "#include \"maps\\[oldmap].dmm\""
		xpath = "#include \"maps\\[newpath].dmm\""
		loc = findtext(text,path,1,0)
		if(!loc)
			message_admins("Could not find '#include \"maps\\[oldmap].dmm\"' or '\"maps/[oldmap].dmm\"' in the bs12.dme. The mapinfo probably has an incorrect mapname var. Alternatively, could not find the .dme itself, at [dmepath].")
			return

	var/rest = copytext(text, loc + length(path))
	text = copytext(text,1,loc)
	text += "\n[xpath]"
	text += rest
/*	for(var/A in lines)
		if(findtext(A,path,1,0))
			lineloc = lines.Find(A,1,0)
			lines[lineloc] = xpath
			world << "FOUND"*/
	fdel(dmepath)
	var/file = file(dmepath)
	file << text
	message_admins("Compiling...")
	shell("./recompile")
	message_admins("Done")
	world.Reboot("Switching to [newmap]")

obj/mapinfo
	invisibility = 101
	var/mapname = "thismap"
	var/decks = 4
proc/GetMapInfo()
//	var/obj/mapinfo/M = locate()
//	Just removing these to try and fix the occasional JSON -> WORLD issue.
//	world << M.name
//	world << M.mapname
client/proc/ChangeMap(var/X as text)
	set name = "Change Map"
	set category  = "Admin"
	switchmap(X,X)
