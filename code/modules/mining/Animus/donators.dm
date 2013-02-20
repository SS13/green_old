/var/list/donators = list()
/var/list/donators_special = list()


/proc/load_donators()
	var/text = file2text("config/donators.txt")


	if (!text)
		diary << "No donators.txt file found"
		return
	diary << "Reading donators.txt"


	var/list/CL = dd_text2list(text, "\n")


	for (var/t in CL)
		if (!t)
			continue
		if (length(t) == 0)
			continue
		if (copytext(t, 1, 2) == "#")
			continue


		var/special = 0
		if (copytext(t, 1, 2) == "$")
			t = copytext(t, 2)
			special = 1


		var/pos = findtext(t, " ")
		var/byondkey = null
		var/value = null


		if (pos)
			byondkey = lowertext(copytext(t, 1, pos))
			value = copytext(t, pos + 1)
			if(!special)
				donators[byondkey] = text2num(value)
			else
				donators_special[byondkey] = value


/client/var/datum/donators/donator = null


/client/verb/cmd_donator_panel()
	set name = "Donator panel"
	set category = "OOC"


	if(!ticker || ticker.current_state < 3)
		alert("Please wait until game setting up!")
		return


	if(!donator)
		var/exists = 0
		for(var/datum/donators/D)
			if(D.ownerkey == ckey)
				exists = 1
				donator = D
				break
		if(!exists)
			donator = new /datum/donators()
			donator.owner = src
			donator.ownerkey = ckey
			if(donators[ckey])
				donator.maxmoney = donators[ckey]
				donator.money = donator.maxmoney


	donator.donatorpanel()




/var/list/donators_datums = list() //need for protect from garbage collector


/datum/donators
	var/client/owner = null
	var/ownerkey
	var/money = 0
	var/maxmoney = 0
	var/allowed_num_items = 10
	var/special_used = 0


	New()
		..()
		donators_datums += src


/datum/donators/proc/donatorpanel()
	var/dat = "<title>Donator panel</title>"
	dat += "Your money: [money]/[maxmoney]<br>"
	dat += "Allowed number of items: [allowed_num_items]/10<br><br>"
	dat += "<b>Select items:</b> <br>"

	//here items list
	dat += "<b>Collectable Hats:</b> <br>"
	dat += "Tough Guy's Toque: <A href='?src=\ref[src];item=/obj/item/clothing/head/fluff/enos_adlai_1;cost=600'>600</A><br>"
	dat += "SWAT Cap: <A href='?src=\ref[src];item=/obj/item/clothing/head/secsoft/fluff/swatcap;cost=650'>650</A><br>"
	dat += "Bloody Welding Helmet: <A href='?src=\ref[src];item=/obj/item/clothing/head/helmet/welding/fluff/yuki_matsuda_1;cost=600'>600</A><br>"
	dat += "Welding Helmet with Flowers: <A href='?src=\ref[src];item=/obj/item/clothing/head/helmet/welding/fluff/alice_maccrea_1;cost=600'>600</A><br>"
	dat += "Flagmask: <A href='?src=\ref[src];item=/obj/item/clothing/mask/fluff/flagmask;cost=600'>600</A><br>"
	dat += "Collectable Pete Hat: <A href='?src=\ref[src];item=/obj/item/clothing/head/collectable/petehat;cost=2400'>2400</A><br>"
	dat += "Collectable Metroid Hat: <A href='?src=\ref[src];item=/obj/item/clothing/head/collectable/metroid;cost=1500'>1500</A><br>"
	dat += "Collectable Xenom Hat: <A href='?src=\ref[src];item=/obj/item/clothing/head/collectable/xenom;cost=1100'>1100</A><br>"
	dat += "Collectable Slime Hat: <A href='?src=\ref[src];item=/obj/item/clothing/head/collectable/slime;cost=1500'>1500</A><br>"
	dat += "Collectable Top Hat: <A href='?src=\ref[src];item=/obj/item/clothing/head/collectable/tophat;cost=900'>900</A><br>"
	dat += "Kitty Ears: <A href='?src=\ref[src];item=/obj/item/clothing/head/kitty;cost=600'>600</A><br>"
	dat += "Ushanka: <A href='?src=\ref[src];item=/obj/item/clothing/head/ushanka;cost=300'>300</A><br>"
	dat += "<b>Personal Stuff:</b> <br>"
	dat += "Eye patch: <A href='?src=\ref[src];item=/obj/item/clothing/glasses/eyepatch;cost=200'>200</A><br>"
	dat += "Premium Havanian Cigar: <A href='?src=\ref[src];item=/obj/item/clothing/mask/cigarette/cigar/havana;cost=200'>200</A><br>"
	dat += "Walking stick: <A href='?src=\ref[src];item=/obj/item/weapon/staff/stick;cost=200'>200</A><br>"
	dat += "Zippo: <A href='?src=\ref[src];item=/obj/item/weapon/lighter/zippo;cost=200'>200</A><br>"
	dat += "Cigarette packet: <A href='?src=\ref[src];item=/obj/item/weapon/cigpacket;cost=50'>50</A><br>"
	dat += "pAI card: <A href='?src=\ref[src];item=/obj/item/device/paicard;cost=300'>300</A><br>"
	dat += "Beer bottle: <A href='?src=\ref[src];item=/obj/item/weapon/reagent_containers/food/drinks/beer;cost=80'>80</A><br>"
	dat += "Captain flask: <A href='?src=\ref[src];item=/obj/item/weapon/reagent_containers/food/drinks/flask;cost=300'>300</A><br>"
	dat += "\"Three Mile Island\" Ice Tea: <A href='?src=\ref[src];item=/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/threemileisland;cost=100'>100</A><br>"
	dat += "Sunglasses: <A href='?src=\ref[src];item=/obj/item/clothing/glasses/sunglasses;cost=600'>600</A><br>"
	dat += "<b>Clothing Sets:</b> <br>"
	dat += "Prig Costume: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/prig;cost=750'>750</A><br>"
	dat += "Plague Doctor Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/plaguedoctor;cost=3750'>3750</A><br>"
	dat += "Waiter Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/waiter;cost=750'>750</A><br>"
	dat += "Commie Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/commie;cost=1100'>1100</A><br>"
	dat += "Girly-girl Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/nyangirl;cost=750'>750</A><br>"
	dat += "Rosh Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/rosh;cost=1200'>1200</A><br>"
	dat += "Butler Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/butler;cost=750'>750</A><br>"
	dat += "Highlander Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/highlander;cost=1100'>1100</A><br>"
	dat += "Scratch Set: <A href='?src=\ref[src];item=/obj/effect/landmark/costume/scratch;cost=750'>750</A><br>"
	dat += "Moonluck armour: <A href='?src=\ref[src];item=/obj/item/clothing/suit/armor/moonluck_suit;cost=2500'>2500</A><br>"
	dat += "<b>Shoes:</b> <br>"
	dat += "Clown Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/clown_shoes;cost=200'>200</A><br>"
	dat += "Red Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/red;cost=200'>200</A><br>"
	dat += "Rainbow Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/rainbow;cost=200'>200</A><br>"
	dat += "Cyborg Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/cyborg;cost=200'>200</A><br>"
	dat += "Laceups Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/laceups;cost=200'>200</A><br>"
	dat += "Yellow Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/yellow;cost=200'>200</A><br>"
	dat += "Purple Shoes: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/purple;cost=200'>200</A><br>"
	dat += "Purple Boots: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/purpleboots;cost=200'>200</A><br>"
	dat += "Yellow Boots: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/yellowboots;cost=200'>200</A><br>"
	dat += "White Boots: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/whiteboots;cost=200'>200</A><br>"
	dat += "Brown Boots: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/fullbrown;cost=200'>3200</A><br>"
	dat += "BDSM Boots: <A href='?src=\ref[src];item=/obj/item/clothing/shoes/fluff/leatherboots;cost=400'>400</A><br>"
	dat += "<b>Pajamas:</b> <br>"
	dat += "Vice Policeman: <A href='?src=\ref[src];item=/obj/item/clothing/under/rank/vice;cost=900'>900</A><br>"
	dat += "Johny~~ Suit: <A href='?src=\ref[src];item=/obj/item/clothing/suit/johnny_coat;cost=920'>920</A><br>"
	dat += "Rainbow Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/rainbow;cost=200'>200</A><br>"
	dat += "Cloud Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/cloud;cost=900'>900</A><br>"
	dat += "Lightblue Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/lightblue;cost=200'>200</A><br>"
	dat += "Aqua Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/aqua;cost=900'>900</A><br>"
	dat += "Purpe Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/purple;cost=200'>200</A><br>"
	dat += "Lightpurpe Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/lightpurple;cost=200'>200</A><br>"
	dat += "Lightbrown Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/lightbrown;cost=200'>200</A><br>"
	dat += "Brown Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/brown;cost=200'>200</A><br>"
	dat += "Darkblue suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/darkblue;cost=200'>200</A><br>"
	dat += "Lightred Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/lightred;cost=200'>200</A><br>"
	dat += "Darkred Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/darkred;cost=200'>200</A><br>"
	dat += "Grim Jacket: <A href='?src=\ref[src];item=/obj/item/clothing/under/suit_jacket;cost=200'>200</A><br>"
	dat += "Black Jacket: <A href='?src=\ref[src];item=/obj/item/clothing/under/color/blackf;cost=200'>200</A><br>"
	dat += "Sexy Police Uniform: <A href='?src=\ref[src];item=/obj/item/clothing/under/det/fluff/retpoluniform;cost=700'>700</A><br>"
	dat += "Scratched Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/scratch;cost=200'>200</A><br>"
	dat += "Purple Cheerleader Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/cheerleader/purple;cost=200'>200</A><br>"
	dat += "Yellow Cheerleader Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/cheerleader/yellow;cost=200'>200</A><br>"
	dat += "White Cheerleader Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/cheerleader/white;cost=200'>200</A><br>"
	dat += "Cheerleader Suit: <A href='?src=\ref[src];item=/obj/item/clothing/under/cheerleader;cost=200'>200</A><br>"
	dat += "Downy Jumpsuit: <A href='?src=\ref[src];item=/obj/item/clothing/under/fluff/jumpsuitdown;cost=200'>200</A><br>"
	dat += "<b>Gloves:</b> <br>"
	dat += "White: <A href='?src=\ref[src];item=/obj/item/clothing/gloves/white;cost=300'>300</A><br>"
	dat += "Rainbow: <A href='?src=\ref[src];item=/obj/item/clothing/gloves/rainbow;cost=300'>300</A><br>"
	dat += "Fingerless: <A href='?src=\ref[src];item=/obj/item/clothing/gloves/fingerless/black;cost=250'>250</A><br>"
	dat += "Black: <A href='?src=\ref[src];item=item=/obj/item/clothing/gloves/black;cost=400'>400</A><br>"
	dat += "Black gloves: <A href='?src=\ref[src];item=/obj/item/clothing/gloves/black;cost=600'>600</A><br>"
	dat += "<b>Coats:</b> <br>"
	dat += "France Jacker: <A href='?src=\ref[src];item=/obj/item/clothing/suit/storage/labcoat/fr_jacket;cost=500'>500</A><br>"
	dat += "Pink Labcoat: <A href='?src=\ref[src];item=/obj/item/clothing/suit/storage/labcoat/fluff/pink;cost=500'>500</A><br>"
	dat += "Girly Labcoat: <A href='?src=\ref[src];item=/obj/item/clothing/suit/storage/labcoat/fluff/red;cost=500'>500</A><br>"
	dat += "Brown Coat: <A href='?src=\ref[src];item=/obj/item/clothing/suit/browncoat;cost=500'>500</A><br>"
	dat += "BDSM Coat: <A href='?src=\ref[src];item=/obj/item/clothing/suit/leathercoat;cost=600'>600</A><br>"
	dat += "Neo Coat: <A href='?src=\ref[src];item=/obj/item/clothing/suit/neocoat;cost=900'>900</A><br>"
	dat += "Wedding Dress: <A href='?src=\ref[src];item=/obj/item/clothing/suit/weddingdress;cost=500'>500</A><br>"
	dat += "<b>Beedsheets:</b> <br>"
	dat += "Clown Bedsheet: <A href='?src=\ref[src];item=/obj/item/weapon/bedsheet/clown;cost=300'>300</A><br>"
	dat += "Mime Bedsheet: <A href='?src=\ref[src];item=/obj/item/weapon/bedsheet/mime;cost=300'>300</A><br>"
	dat += "Rainbow Bedsheet: <A href='?src=\ref[src];item=/obj/item/weapon/bedsheet/rainbow;cost=300'>300</A><br>"
	dat += "Captain Bedsheet: <A href='?src=\ref[src];item=/obj/item/weapon/bedsheet/captain;cost=600'>600</A><br>"
	dat += "<b>Toys:</b> <br>"
	dat += "Rubber Duck: <A href='?src=\ref[src];item=/obj/weapon/bikehorn/rubberducky;cost=500'>500</A><br>"
	dat += "The Holy Cross: <A href='?src=\ref[src];item=/obj/item/fluff/val_mcneil_1;cost=600'>600</A><br>"
	dat += "Champion Belt: <A href='?src=\ref[src];item=/obj/item/weapon/storage/belt/champion;cost=400'>400</A><br>"
	dat += "Rohtin Exclusive Zippo: <A href='?src=\ref[src];item=/obj/item/weapon/lighter/zippo/fluff/riley_rohtin_1;cost=400'>400</A><br>"
	dat += "Matsuda Exclusive Zippo: <A href='?src=\ref[src];item=/obj/item/weapon/lighter/zippo/fluff/li_matsuda_1;cost=400'>400</A><br>"
	dat += "Santabag: <A href='?src=\ref[src];item=/obj/item/weapon/storage/backpack/santabag;cost=400'>400</A><br>"
	dat += "Keppel: <A href='?src=\ref[src];item=/obj/item/weapon/fluff/cado_keppel_1;cost=400'>400</A><br>"
	dat += "<b>Special Stuff:</b> <br>"
	dat += "Satchel: <A href='?src=\ref[src];item=/obj/item/weapon/storage/backpack/satchel;cost=400'>400</A><br>"
	dat += "Tacticool Turtleneck: <A href='?src=\ref[src];item=/obj/item/clothing/under/syndicate/tacticool;cost=200'>200</A><br>"
//	dat += "Soul stone shard: <A href='?src=\ref[src];item=/obj/item/device/soulstone;cost=1500'>1500</A><br>"
	dat += "Plastic balisong knife: <A href='?src=\ref[src];item=/obj/item/weapon/kitchenknife/b_knife;cost=800'>800</A><br>"

	if(donators_special[ownerkey] && !special_used)
		dat += "<br>Special for [ownerkey]:<br>"
		switch(donators_special[ownerkey])
			if("catman")
				dat += "Make youself cat: <A href='?src=\ref[src];special=catman'>click</A><br>"
			if("black catman")
				dat += "Make youself cat: <A href='?src=\ref[src];special=black catman'>click</A><br>"


	usr << browse(dat, "window=donatorpanel;size=250x400")




/datum/donators/Topic(href, href_list)
	if(href_list["item"])
		attemptSpawnItem(href_list["item"],text2num(href_list["cost"]))
		return
	if(href_list["special"])
		switch(href_list["special"])
			if("catman")
				var/mob/living/carbon/human/H = owner.mob
				if(!istype(H))
					owner << "\red You must be a human to do this"
					return
				H.mutantrace = "cat"
				special_used = 1
			if("black catman")
				var/mob/living/carbon/human/H = owner.mob
				if(!istype(H))
					owner << "\red You must be a human to do this"
					return
				H.mutantrace = "catb"
				special_used = 1


/datum/donators/proc/attemptSpawnItem(var/item,var/cost)
	if(cost > money)
		usr << "\red You don't have enough funds."
		return 0


	if(!allowed_num_items)
		usr << "\red You already spawned max count of items."
		return


	var/mob/living/carbon/human/H = owner.mob
	if(!istype(H))
		usr << "\red You must be a human to use this."
		return 0


	if(H.stat)
		return 0


	money -= cost
	allowed_num_items--


	var/obj/spawned = new item(H)


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


	owner.cmd_donator_panel()






//SPECIAL ITEMS
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/threemileisland
	New()
		..()
		reagents.add_reagent("threemileisland", 50)
		on_reagent_change()