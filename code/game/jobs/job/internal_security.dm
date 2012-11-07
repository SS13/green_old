
/datum/job/internalsecurity
	title = "Internal Security"
	flag = INTERNALSECURITY
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 2
	spawn_positions = 2


	equip(var/mob/living/carbon/human/H)
		if(!H)	return 0
		H.equip_if_possible(new /obj/item/weapon/storage/backpack/satchel (H), H.slot_back)
		H.equip_if_possible(new /obj/item/device/radio/headset/heads/captain(H), H.slot_ears)
		H.equip_if_possible(new /obj/item/clothing/under/internalsecurity(H), H.slot_w_uniform)
		H.equip_if_possible(new /obj/item/clothing/shoes/brown(H), H.slot_shoes)
		H.equip_if_possible(new /obj/item/device/pda/heads/hos(H), H.slot_belt)
		H.equip_if_possible(new /obj/item/clothing/suit/armor/commissarcoat(H), H.slot_wear_suit)
		H.equip_if_possible(new /obj/item/clothing/gloves/black(H), H.slot_gloves)
		H.equip_if_possible(new /obj/item/clothing/head/internalsecurity(H), H.slot_head)
		H.equip_if_possible(new /obj/item/clothing/glasses/sunglasses/sechud(H), H.slot_glasses)
		H.equip_if_possible(new /obj/item/weapon/handcuffs(H), H.slot_in_backpack)
		H.equip_if_possible(new /obj/item/weapon/chem_grenade/sleepsmoke(H), H.slot_in_backpack)
		H.equip_if_possible(new /obj/item/weapon/gun/energy/elitetaser(H), H.slot_s_store)
		H.equip_if_possible(new /obj/item/device/internalsecurityflash(H), H.slot_l_store)
		H.equip_if_possible(new /obj/item/weapon/pepperspray/elited(H.back), H.slot_in_backpack)
		var/obj/item/weapon/implant/loyalty/L = new/obj/item/weapon/implant/loyalty(H)
		L.imp_in = H
		L.implanted = 1
		return 1


//COMMISSAR WHITELIST
var/list/whitelist_internal_security

#define SECURITYFILE "data/whitelist_internal_security.txt"
/proc/load_whitelist_internal_security()
	var/text = file2text(SECURITYFILE)
	if (!text)
		diary << "Failed to [SECURITYFILE]\n"
	else
		whitelist_internal_security = dd_text2list(text, "\n")

/proc/check_whitelist_internal_security(mob/M)
	if(!whitelist_internal_security)
		return 0
	return ("[M.ckey]" in whitelist_internal_security)

#undef SECURITYFILE
