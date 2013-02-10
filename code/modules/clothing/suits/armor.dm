/obj/item/clothing/suit/armor
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/pepperspray,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/taperoll/police)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS
	flags_inv = HIDEJUMPSUIT


/obj/item/clothing/suit/armor/vest
	name = "armor"
	desc = "An armored vest that protects against some damage."
	icon_state = "armor"
	item_state = "armor"
	flags = FPRINT | TABLEPASS
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/vest/warden
	name = "warden's jacket"
	desc = "An armoured jacket with silver rank pips and livery."
	icon_state = "warden_jacket"
	item_state = "armor"

/obj/item/clothing/suit/armor/riot
	name = "riot suit"
	desc = "A suit of armor with heavy padding to protect against melee attacks. Looks like it might impair movement."
	icon_state = "riot"
	item_state = "swat_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	armor = list(melee = 80, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	origin_tech = "combat=3,materials=4"


/obj/item/clothing/suit/armor/bulletproof
	name = "bulletproof vest"
	desc = "A vest that excels in protecting the wearer against high-velocity solid projectiles."
	icon_state = "bulletproof"
	item_state = "armor"
	armor = list(melee = 10, bullet = 80, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	origin_tech = "combat=3,materials=4"


/obj/item/clothing/suit/armor/laserproof
	name = "ablative armour vest"
	desc = "A vest that excels in protecting the wearer against energy projectiles."
	icon_state = "armor_reflec"
	item_state = "armor_reflec"
	armor = list(melee = 10, bullet = 10, laser = 80, energy = 50, bomb = 0, bio = 0, rad = 0)
	origin_tech = "combat=3,materials=4,powerstorage=3,magnets=2"

/obj/item/clothing/suit/armor/internalsecurity
	name = "Commissar coat"
	desc = "A coat, which is worn only by honorfull IS members."
	icon_state = "retpolcoat"
	item_state = "retpolcoat"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/commissarcoat
	name = "Commissar coat"
	desc = "A coat, which is worn only by honorfull IS members."
	icon_state = "commissarcoat"
	item_state = "commissarcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEJUMPSUIT

/obj/item/clothing/suit/storage/gearharness
	name = "gear harness"
	desc = "A simple security harness, used for storing small objects."
	icon_state = "gearharness"
	item_state = "gearharness"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/pepperspray,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/taperoll/police)
	flags_inv = 0

/obj/item/clothing/suit/armor/reactive
	name = "reactive teleport armour"
	desc = "Someone separated our Research Director from their own head!"
	var/active = 0.0
	icon_state = "reactiveoff"
	item_state = "reactiveoff"
	slowdown = 1
	flags = FPRINT | TABLEPASS
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/suit/storage/armourrigvest
	name = "armoured rig vest"
	desc = "An important looking armoured vest, outfitted with pockets."
	icon_state = "armourrigvest"
	item_state = "armourrigvest"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	flags = FPRINT | TABLEPASS
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/weapon/pepperspray,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/taperoll/police)
	armor = list(melee = 50, bullet = 15, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/reactive/IsShield()
	if(active)
		return 1
	return 0


/obj/item/clothing/suit/armor/reactive/attack_self(mob/user as mob)
	src.active = !( src.active )
	if (src.active)
		user << "\blue The reactive armor is now active."
		src.icon_state = "reactive"
		src.item_state = "reactive"
	else
		user << "\blue The reactive armor is now inactive."
		src.icon_state = "reactiveoff"
		src.item_state = "reactiveoff"
		src.add_fingerprint(user)
	return

/obj/item/clothing/suit/armor/reactive/emp_act(severity)
	active = 0
	src.icon_state = "reactiveoff"
	src.item_state = "reactiveoff"
	..()

/obj/item/clothing/suit/armor/stormtrooper
	name = "stormtrooper armor"
	desc = "A long time ago in a galaxy far, far away."
	icon_state = "stormtrooper"
	item_state = "stormtrooper"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	armor = list(melee = 10, bullet = 10, laser = 10, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT

/obj/item/clothing/suit/armor/knight_suit
	name = "Knight armour"
	desc = "For brave heart man."
	icon_state = "knight_suit"
	item_state = "knight_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	armor = list(melee = 70, bullet = 10, laser = 40, energy = 10, bomb = 0, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	origin_tech = "combat=3,materials=4"

/obj/item/clothing/suit/armor/moonluck_suit
	name = "Moonluck suit"
	desc = "Armor named after the great knight of a bygone empire."
	icon_state = "moonluck_suit"
	item_state = "moonluck_suit"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	slowdown = 1
	armor = list(melee = 5, bullet = 2, laser = 1, energy = 1, bomb = 1, bio = 0, rad = 0)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
