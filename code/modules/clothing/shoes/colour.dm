/obj/item/clothing/shoes/
	item_state = "bl_shoes"

/obj/item/clothing/shoes/black
	name = "black shoes"
	icon_state = "black"
	item_color = "black"
	desc = "A pair of black shoes."

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	desc = "A pair of brown shoes."
	icon_state = "brown"
	item_color = "brown"
	item_state = "br_shoes"

/obj/item/clothing/shoes/blue
	name = "blue shoes"
	icon_state = "blue"
	item_color = "blue"
	item_state = "blu_shoes"

/obj/item/clothing/shoes/green
	name = "green shoes"
	icon_state = "green"
	item_color = "green"
	item_state = "g_shoes"

/obj/item/clothing/shoes/yellow
	name = "yellow shoes"
	icon_state = "yellow"
	item_color = "yellow"
	item_state = "y_shoes"

/obj/item/clothing/shoes/purple
	name = "purple shoes"
	icon_state = "purple"
	item_color = "purple"
	item_state = "p_shoes"

/obj/item/clothing/shoes/brown
	name = "brown shoes"
	icon_state = "brown"
	item_color = "brown"
	item_state = "br_shoes"

/obj/item/clothing/shoes/red
	name = "red shoes"
	desc = "Stylish red shoes."
	icon_state = "red"
	item_color = "red"
	item_state = "r_shoes"

/obj/item/clothing/shoes/white
	name = "white shoes"
	icon_state = "white"
	permeability_coefficient = 0.01
	item_color = "white"
	item_state = "w_shoes"

/obj/item/clothing/shoes/rainbow
	name = "rainbow shoes"
	desc = "Very gay shoes."
	icon_state = "rain_bow"
	item_color = "rainbow"
	item_state = "rbow_shoes"

/obj/item/clothing/shoes/orange
	name = "orange shoes"
	icon_state = "orange"
	item_color = "orange"
	item_state = "o_shoes"
	var/obj/item/weapon/handcuffs/chained = null

/obj/item/clothing/shoes/orange/proc/attach_cuffs(var/obj/item/weapon/handcuffs/cuffs, mob/user as mob)
	if (src.chained) return

	user.drop_item()
	cuffs.loc = src
	src.chained = cuffs
	src.slowdown = 15
	src.icon_state = "orange1"
	item_state = "o_shoes1"

/obj/item/clothing/shoes/orange/proc/remove_cuffs(mob/user as mob)
	if (!src.chained) return

	user.put_in_hands(src.chained)
	src.chained.add_fingerprint(user)

	src.slowdown = initial(slowdown)
	src.icon_state = "orange"
	item_state = "o_shoes"
	src.chained = null

/obj/item/clothing/shoes/orange/attack_self(mob/user as mob)
	..()
	remove_cuffs(user)

/obj/item/clothing/shoes/orange/attackby(H as obj, mob/user as mob)
	..()
	if (istype(H, /obj/item/weapon/handcuffs))
		attach_cuffs(H, user)


