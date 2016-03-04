/obj/item/clothing/shoes/magboots
	desc = "Magnetic boots, often used during extravehicular activity to ensure the user remains safely attached to the vehicle."
	name = "magboots"
	icon_state = "magboots0"
	item_state = "magboots"
	var/magpulse = 0
	var/slowdown_active = 2
	action_button_name = "Toggle magboots"
	icon_action_button = "action_blank"
	species_restricted = null
	force = 3
	burn_state = -1 //Won't burn in fires
	origin_tech = "magnets=2"

/obj/item/clothing/shoes/magboots/verb/toggle()
	set name = "Toggle Magboots"
	set category = "Object"
	set src in usr
	if(!can_use(usr))
		return
	attack_self(usr)

/obj/item/clothing/shoes/magboots/attack_self(mob/user)
	if(magpulse)
		flags &= ~NOSLIP
		slowdown = SHOES_SLOWDOWN
		force = 3
	else
		flags |= NOSLIP
		slowdown = slowdown_active
		force = 5
	magpulse = !magpulse
	if(!istype(src, /obj/item/clothing/shoes/magboots/rig)) icon_state = "[item_state][magpulse]"
	user << "<span class='notice'>You [magpulse ? "enable" : "disable"] the mag-pulse traction system.</span>"
	user.update_inv_shoes()	//so our mob-overlays update

/obj/item/clothing/shoes/magboots/examine(mob/user)
	..()
	user << "Its mag-pulse traction system appears to be [magpulse ? "enabled" : "disabled"]."

/obj/item/clothing/shoes/magboots/advance
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer."
	name = "advanced magboots"
	icon_state = "advmag0"
	item_state = "advmag"
	slowdown_active = SHOES_SLOWDOWN

/obj/item/clothing/shoes/magboots/syndie
	desc = "Reverse-engineered magnetic boots that have a heavy magnetic pull. Property of Gorlex Marauders."
	name = "blood-red magboots"
	icon_state = "syndiemag0"
	item_state = "syndiemag"
	origin_tech = "magnets=2,syndicate=3"