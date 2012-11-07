/var/list/enter_whitelist = list()

/proc/load_enter_whitelist()
	var/text = file2text("data/enter_whitelist.txt")
	if (!text)
		diary << "Failed to load enter_whitelist.txt\n"
	else
		enter_whitelist = dd_text2list(text, "\n")