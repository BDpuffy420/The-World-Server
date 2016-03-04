/obj/item/clothing/shoes/proc/step_action() //this was made to rewrite clown shoes squeaking

/obj/item/clothing/shoes/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is bashing their own head in with [src]! Ain't that a kick in the head?</span>")
	for(var/i = 0, i < 3, i++)
		sleep(3)
		playsound(user, 'sound/weapons/genhit2.ogg', 50, 1)
	return(BRUTELOSS)

/obj/item/clothing/shoes/syndigaloshes
	desc = "A pair of brown shoes. They seem to have extra grip."
	name = "brown shoes"
	icon_state = "brown"
	item_state = "br_shoes"
	permeability_coefficient = 0.05
	flags = NOSLIP
	origin_tech = "syndicate=3"
	var/list/clothing_choices = list()
	siemens_coefficient = 0.8
	species_restricted = null
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/mime
	name = "mime shoes"
	icon_state = "mime"
	item_state = "w_shoes"

/obj/item/clothing/shoes/swat
	name = "\improper SWAT shoes"
	desc = "When you want to turn up the heat."
	icon_state = "swat"
	item_state = "jackboots"
	force = 3
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags = NOSLIP
	siemens_coefficient = 0.6
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/combat //Basically SWAT shoes combined with galoshes.
	name = "combat boots"
	desc = "When you REALLY want to turn up the heat"
	icon_state = "swat"
	item_state = "jackboots"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 50,energy = 25, bomb = 50, bio = 10, rad = 0)
	flags = NOSLIP
	siemens_coefficient = 0.6
	burn_state = -1 //Won't burn in fires

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/tourist
	desc = "A pair of plain black sandals with socks. Shooebie!"
	name = "black sandals"
	icon_state = "tourist"
	item_state = "tourist"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/sandal
	desc = "A pair of rather plain, wooden sandals."
	name = "sandals"
	icon_state = "wizard"
	item_state = "wizshoe"
	species_restricted = null
	body_parts_covered = 0

/obj/item/clothing/shoes/sandal/marisa
	desc = "A pair of magic, black shoes."
	name = "magic shoes"
	icon_state = "black"
	item_state = "bl_shoes"
	body_parts_covered = FEET

/obj/item/clothing/shoes/galoshes
	desc = "A pair of yellow rubber boots, designed to prevent slipping on wet surfaces."
	name = "galoshes"
	icon_state = "galoshes"
	item_state = "galoshes"
	permeability_coefficient = 0.05
	flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	species_restricted = null
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/galoshes/dry
	name = "absorbent galoshes"
	desc = "A pair of orange rubber boots, designed to prevent slipping on wet surfaces while also drying them."
	icon_state = "galoshes_dry"
	item_state = "galoshes_dry"

/obj/item/clothing/shoes/galoshes/dry/step_action()
	var/turf/simulated/t_loc = get_turf(src)
	if(istype(t_loc) && t_loc.wet)
		t_loc.MakeDry(TURF_WET_WATER)

/obj/item/clothing/shoes/clown_shoes
	desc = "The prankster's standard-issue clowning shoes. Damn they're huge!"
	name = "clown shoes"
	icon_state = "clown"
	item_state = "clown_shoes"
	slowdown = SHOES_SLOWDOWN+1
	force = 0
	var/footstep = 1	//used for squeeks whilst walking
	species_restricted = null

/obj/item/clothing/shoes/clown_shoes/step_action()
	if(ismob(loc))
		var/mob/living/carbon/human/H = loc
		if(H.m_intent == "run")
			if(footstep > 1)
				playsound(src, "clownstep", 50, 1)
				footstep = 0
			else
				footstep++
		else
			playsound(src, "clownstep", 20, 1)

/obj/item/clothing/shoes/w_police
	name = "armored boots"
	desc = "Stylish, and functional!"
	icon_state = "w_policeboots"
	item_state = "w_policeboots"
	force = 3
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0) //Same values as a standard helmet
	siemens_coefficient = 0.6
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/jackboots
	name = "jackboots"
	desc = "Nanotrasen-issue Security combat boots for combat scenarios or combat situations. All combat, all the time."
	icon_state = "jackboots"
	item_state = "jackboots"
	force = 3
	siemens_coefficient = 0.7
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/winterboots
	name = "winter boots"
	desc = "Boots lined with 'synthetic' animal fur."
	icon_state = "winterboots"
//	item_state = "winterboots" #TOREMOVE - inhands sprite does not exist
	cold_protection = FEET|LEGS
	min_cold_protection_temperature = SHOES_MIN_TEMP_PROTECT
	heat_protection = FEET|LEGS
	max_heat_protection_temperature = SHOES_MAX_TEMP_PROTECT

/obj/item/clothing/shoes/workboots
	name = "work boots"
	desc = "Nanotrasen-issue Engineering lace-up work boots for the especially blue-collar."
	icon_state = "workboots"
	item_state = "jackboots"

/obj/item/clothing/shoes/cult
	name = "boots"
	desc = "A pair of boots worn by the followers of Nar-Sie."
	icon_state = "cult"
	//item_state = "cult" #TOREMOVE - inhands sprite does not exist
	force = 2
	siemens_coefficient = 0.7

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = null

/obj/item/clothing/shoes/cyborg
	name = "cyborg boots"
	desc = "Shoes for a cyborg costume"
	icon_state = "boots"

/obj/item/clothing/shoes/slippers
	name = "bunny slippers"
	desc = "Fluffy!"
	icon_state = "slippers"
	item_state = "w_shoes"
	force = 0
	species_restricted = null
	w_class = 2

/obj/item/clothing/shoes/slippers_worn
	name = "worn bunny slippers"
	desc = "Fluffy..."
	icon_state = "slippers_worn"
	item_state = "w_shoes"
	force = 0
	w_class = 2

/obj/item/clothing/shoes/laceup
	name = "laceup shoes"
	desc = "The height of fashion, and they're pre-polished!"
	icon_state = "laceups"
	item_state = "bl_shoesold"

/obj/item/clothing/shoes/leather
	name = "leather shoes"
	desc = "A sturdy pair of leather shoes."
	icon_state = "leather"
	item_state = "br_shoesold"

/obj/item/clothing/shoes/roman
	name = "roman sandals"
	desc = "Sandals with buckled leather straps on it."
	icon_state = "roman"
//	item_state = "roman" //#TOREMOVE - inhands sprite does not exist

/obj/item/clothing/shoes/swimmingfins
	desc = "Help you swim good."
	name = "swimming fins"
	icon_state = "flippers"
	flags = NOSLIP
	slowdown = SHOES_SLOWDOWN+1
	species_restricted = null
	burn_state = -1 //Won't burn in fires

/obj/item/clothing/shoes/iceskate
	name = "iceskating boots"
	icon_state = "iceskate"
	desc = "A pair of black shoes."

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE