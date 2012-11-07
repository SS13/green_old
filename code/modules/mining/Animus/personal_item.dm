var/list/laureates = list()

//load laureates from config
/proc/load_laureates()
	var/text = file2text("config/laureates.txt")

	if (!text)
		diary << "No laureates.txt file found"
		return
	diary << "Reading laureates.txt"

	var/list/CL = dd_text2list(text, "\n")

	laureates = list()
	var/list/items = list()
	var/current_ckey
	var/current_text
	var/next = 0 //if 1, next string is object

	for (var/t in CL)
		if (!t)
			continue
		//t = trim(t)
		if (length(t) == 0)
			continue
		else if (copytext(t, 1, 2) == "#")
			continue

		if (!next)
			//ckey
			if (copytext(t, 1, 2) == "-")
				if(current_ckey && items.len) //add previous to laureates
					laureates[current_ckey] = items
					items = list()
				current_ckey = copytext(t, 2)
				if(current_ckey == "eof") //end of file
					break
				next = 0
			//text
			else
				current_text = t
				next = 1
		else
			//object
			items[current_text] = text2path(t)
			next = 0

//verb
/client/proc/spawn_personal_item()
	set name = "Spawn personal item"
	set category = "OOC"
	var/mob/living/carbon/human/H = usr
	if (!istype(H))
		usr << "\red Wrong mob! Must be a human!"
		return
	var/list/items = laureates[usr.ckey]
	if (!items)
		usr << "\red You do not have any awards or personal items!"
		return
	var/selected_path
	if (items.len>1)
		var/choise = input("Select item") as null|anything in items
		if (isnull(choise))
			return
		selected_path = items[choise]
		items -= choise
	else
		selected_path = items[items[1]]
		items.len = 0
		H.verbs -= /client/proc/spawn_personal_item
	var/obj/spawned = new selected_path(H)
	var/list/slots = list (
		"backpack" = H.slot_in_backpack,
		"left pocket" = H.slot_l_store,
		"right pocket" = H.slot_r_store,
		"left hand" = H.slot_l_hand,
		"right hand" = H.slot_r_hand,
	)
	var/where = H.equip_in_one_of_slots(spawned, slots, del_on_fail=0)
	if (!where)
		spawned.loc = H.loc
		usr << "\blue Your [spawned] has been spawned!"
	else
		usr << "\blue Your [spawned] has been spawned in your [where]!"

//special items
/obj/item/weapon/reagent_containers/food/snacks/fortunecookie/good_luck
	New()
		var/obj/item/weapon/paper/paper = new(src)
		paper.info = "Good luck!"
		..()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/threemileisland
	New()
		..()
		reagents.add_reagent("threemileisland", 50)
		on_reagent_change()