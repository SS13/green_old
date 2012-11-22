/obj/admins/proc/view_ban_log()
	set category = "Admin"
	set name = "Show Ban Log"
	set desc = "Shows servers ban log."

	var/path = "data/ban_log.txt"
	if( fexists(path) )
		src << run( file(path) )
	else
		src << "<font color='red'>Error:File not found/Invalid path([path]).</font>"
		return
//	feedback_add_details("admin_verb","VTL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return