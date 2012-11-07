//statistics
/proc/addJobsStartStatistics(var/key,var/job,var/fromstart=1)
	var/DBConnection/dbcon = new()
	dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
	if(!dbcon.IsConnected())
		return 0

	var/DBQuery/query = dbcon.NewQuery("SELECT id, byondkey, job, [fromstart ? "fromstart" : "afterstart"] FROM jobs")
	query.Execute()

	while(query.NextRow())
		if(key != query.item[2])
			continue
		if(job != query.item[3])
			continue
		var/id = text2num(query.item[1])
		var/count = text2num(query.item[4])
		count++

		query = dbcon.NewQuery("UPDATE jobs SET [fromstart ? "fromstart" : "afterstart"]=\"[count]\" WHERE id=[id]")
		/*if(!query.Execute())
			world << "\green SQL Error: [query.ErrorMsg()]"*/
		query.Execute()
		dbcon.Disconnect()
		return 1

	query = dbcon.NewQuery("INSERT INTO jobs (byondkey, job, fromstart, afterstart) VALUES ('[key]', '[job]', '[fromstart ? 1 : 0]', '[fromstart ? 0 : 1]')")
	/*if(!query.Execute())
		world << "\red SQL Error: <b>[query.ErrorMsg()]</b>"*/
	query.Execute()
	dbcon.Disconnect()
	return 1


/proc/addIdIp(var/key,var/userid,var/userip)
	//debug
	if(!userid) userid = "default"
	if(!userip) userip = "default"

	var/DBConnection/dbcon = new()
	dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
	if(!dbcon.IsConnected())
		return 0

	var/DBQuery/query = dbcon.NewQuery("SELECT id, byondkey, computerid, ip FROM spy")
	query.Execute()

	//find byondkey in base
	while(query.NextRow())
		if(key != query.item[2])
			continue
		var/id = query.item[1]
		var/all_compid = query.item[3]
		var/all_ip = query.item[4]
		var/changed = 0 //sort of bitflags

		if(!(userid in dd_text2list(all_compid, ";")))
			all_compid += ";[userid]"
			changed |= 1
		if(!(userip in dd_text2list(all_ip, ";")))
			all_ip += ";[userip]"
			changed |= 2
		if(!changed)
			return 1
		var/qr = "UPDATE spy SET "
		if(changed & 1)
			qr += "computerid=\"[all_compid]\""
		if((changed & 1) && (changed & 2))
			qr += ", "
		if(changed & 2)
			qr += "ip=\"[all_ip]\""
		qr += " WHERE id=[id]"
		//query = dbcon.NewQuery("UPDATE spy SET [changed & 1 ? "computerid=\"[all_compid]\"" : ""][changed==3 ? ", " : ""][changed & 2 ? "ip=\"[all_ip]\"" : ""] WHERE id=[id]")
		query = dbcon.NewQuery(qr)
		query.Execute()
		dbcon.Disconnect()
		return 1

	query = dbcon.NewQuery("INSERT INTO spy (byondkey, computerid, ip) VALUES ('[key]', '[userid]', '[userip]')")
	query.Execute()
	dbcon.Disconnect()
	return 1