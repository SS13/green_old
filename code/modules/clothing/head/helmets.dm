/obj/item/clothing/head/helmet
	name = "helmet"
	desc = "Standard Security gear. Protects the head from impacts."
	icon_state = "helmet"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS|HIDEEYES

/obj/item/clothing/head/helmet/warden
	name = "warden's hat"
	desc = "It's a special hat issued to the Warden of a securiy force. Protects the head from impacts."
	icon_state = "wardencap"
	flags_inv = 0

/obj/item/clothing/head/helmet/swat
	name = "\improper SWAT helmet"
	desc = "They're often used by highly trained SWAT officers."
	icon_state = "swat"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADSPACE | HEADCOVERSEYES
	item_state = "swat"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES

/obj/item/clothing/head/helmet/thunderdome
	name = "\improper Thunderdome helmet"
	desc = "<i>'Let the battle commence!'</i>"
	icon_state = "thunderdome"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADSPACE | HEADCOVERSEYES
	item_state = "thunderdome"
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 10, bomb = 25, bio = 10, rad = 0)

/obj/item/clothing/head/helmet/welding
	name = "welding helmet"
	desc = "A head-mounted face cover designed to protect the wearer completely from space-arc eye."
	icon_state = "welding"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES | HEADCOVERSMOUTH
	see_face = 0.0
	item_state = "welding"
	protective_temperature = 1300
	m_amt = 3000
	g_amt = 1000
	var/up = 0
	armor = list(melee = 10, bullet = 5, laser = 10,energy = 5, bomb = 10, bio = 5, rad = 10)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES

/obj/item/clothing/head/helmet/that
	name = "sturdy top hat"
	desc = "It's an amish looking armored top hat."
	icon_state = "tophat"
	item_state = "that"
	flags = FPRINT|TABLEPASS
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 0, rad = 0)
	flags_inv = 0

/obj/item/clothing/head/helmet/greenbandana
	name = "green bandana"
	desc = "It's a green bandana with some fine nanotech lining."
	icon_state = "greenbandana"
	item_state = "greenbandana"
	flags = FPRINT|TABLEPASS
	armor = list(melee = 5, bullet = 5, laser = 5,energy = 5, bomb = 15, bio = 15, rad = 15)
	flags_inv = 0

/obj/item/clothing/head/internalsecurity
	name = "white tophat"
	desc = "Standard Internal Security gear. Protects the head from impacts with style."
	icon_state = "secelitetop"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "secelitetop"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS

/obj/item/clothing/head/internalsecurity4
	name = "blue tophat"
	desc = "Standard Internal Security gear. Protects the head from impacts with style."
	icon_state = "beaver_hat"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "beaver_hat"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS

/obj/item/clothing/head/internalsecurity2
	name = "red velvet cap"
	desc = "Standard Internal Security gear. Protects the head from impacts with style."
	icon_state = "secelitecap"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "secelitecap"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS

/obj/item/clothing/head/internalsecurity3
	name = "white velvet cap"
	desc = "Standard Internal Security gear. Protects the head from impacts with style."
	icon_state = "secelitecap1"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "secelitecap1"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS

/obj/item/clothing/head/comcap
	name = "Commissar cap"
	desc = "Better you do not meet the person who wears it."
	icon_state = "comcap"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "comcap"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS

/obj/item/clothing/head/helmet/riot
	name = "riot helmet"
	desc = "It's a helmet specifically designed to protect against close range attacks."
	icon_state = "riot"
	item_state = "helmet"
	flags = FPRINT|TABLEPASS|SUITSPACE|HEADCOVERSEYES
	armor = list(melee = 82, bullet = 15, laser = 5,energy = 5, bomb = 5, bio = 2, rad = 0)
	flags_inv = HIDEEARS
	origin_tech = "combat=3,materials=4"

/obj/item/clothing/head/helmet/cap
	name = "captain's cap"
	desc = "You fear to wear it for the negligence it brings."
	icon_state = "capcap"
	flags = FPRINT|TABLEPASS|SUITSPACE
	armor = list(melee = 0, bullet = 0, laser = 2,energy = 2, bomb = 0, bio = 0, rad = 0)
	flags_inv = 0

/obj/item/clothing/head/stormtrooper_helmet
	name = "stormtrooper helmet"
	desc = "Helmet of the Old Empire Stormtrooper."
	icon_state = "stormtrooper_helmet"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "stormtrooper_helmet"
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 500
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS|HIDEEYES

/obj/item/clothing/head/knight_helmet
	name = "knight helmet"
	desc = "knight helmet."
	icon_state = "knight_helmet"
	flags = FPRINT | TABLEPASS | SUITSPACE | HEADCOVERSEYES
	item_state = "knight_helmet"
	armor = list(melee = 60, bullet = 15, laser = 30,energy = 10, bomb = 25, bio = 0, rad = 0)
	protective_temperature = 100
	heat_transfer_coefficient = 0.10
	flags_inv = HIDEEARS|HIDEEYES
	origin_tech = "combat=3,materials=4"