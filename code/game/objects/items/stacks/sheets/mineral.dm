/*
Mineral Sheets
	Contains:
		- Sandstone
		- Diamond
		- Uranium
		- Plasma
		- Gold
		- Silver
		- Enriched Uranium
		- Platinum
		- Metallic Hydrogen
		- Tritium
		- Osmium
*/

var/global/list/datum/stack_recipe/sandstone_recipes = list ( \
	new/datum/stack_recipe("pile of dirt", /obj/machinery/portable_atmospherics/hydroponics/soil, 3, time = 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("sandstone door", /obj/structure/mineral_door/sandstone, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/silver_recipes = list ( \
	new/datum/stack_recipe("silver door", /obj/structure/mineral_door/silver, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/diamond_recipes = list ( \
	new/datum/stack_recipe("diamond door", /obj/structure/mineral_door/transparent/diamond, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/uranium_recipes = list ( \
	new/datum/stack_recipe("uranium door", /obj/structure/mineral_door/uranium, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/gold_recipes = list ( \
	new/datum/stack_recipe("golden door", /obj/structure/mineral_door/gold, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/plasma_recipes = list ( \
	new/datum/stack_recipe("plasma door", /obj/structure/mineral_door/transparent/plasma, 10, one_per_turf = 1, on_floor = 1), \
	)

var/global/list/datum/stack_recipe/plastic_recipes = list ( \
	new/datum/stack_recipe("plastic crate", /obj/structure/closet/crate/plastic, 10, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("plastic ashtray", /obj/item/ashtray/plastic, 2, one_per_turf = 1, on_floor = 1), \
	new/datum/stack_recipe("plastic fork", /obj/item/weapon/kitchen/utensil/pfork, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic spoon", /obj/item/weapon/kitchen/utensil/pspoon, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic knife", /obj/item/weapon/kitchen/utensil/pknife, 1, on_floor = 1), \
	new/datum/stack_recipe("plastic bag", /obj/item/weapon/storage/bag/plasticbag, 3, on_floor = 1), \
	new/datum/stack_recipe("blood pack", /obj/item/weapon/reagent_containers/blood/empty, 4, on_floor = 0), \
	)

var/global/list/datum/stack_recipe/iron_recipes = list ( \
	new/datum/stack_recipe("iron door", /obj/structure/mineral_door/iron, 20, one_per_turf = 1, on_floor = 1), \
	null, \
)

/obj/item/stack/sheet/mineral
	icon = 'icons/obj/mining.dmi'
	force = 5.0
	throwforce = 5
	w_class = 3.0
	throw_speed = 3
	throw_range = 3

/obj/item/stack/sheet/mineral/New()
	..()
	pixel_x = rand(0,4)-4
	pixel_y = rand(0,4)-4

obj/item/stack/sheet/mineral/iron
	name = "iron"
	icon_state = "sheet-silver"
	origin_tech = "materials=1"
	sheettype = "iron"
	color = "#333333"
	perunit = 3750

obj/item/stack/sheet/mineral/iron/New()
	..()
	recipes = iron_recipes

/obj/item/stack/sheet/mineral/sandstone
	name = "sandstone brick"
	desc = "This appears to be a combination of both sand and stone."
	singular_name = "sandstone brick"
	icon_state = "sheet-sandstone"
	throw_speed = 4
	throw_range = 5
	origin_tech = "materials=1"
	materials = list(MAT_GLASS=MINERAL_MATERIAL_AMOUNT)
	sheettype = "sandstone"

/obj/item/stack/sheet/mineral/sandstone/New()
	..()
	recipes = sandstone_recipes

/obj/item/stack/sheet/mineral/diamond
	name = "diamond"
	icon_state = "sheet-diamond"
	origin_tech = "materials=6"
	materials = list(MAT_DIAMOND=MINERAL_MATERIAL_AMOUNT)
	sheettype = "diamond"


/obj/item/stack/sheet/mineral/diamond/New()
	..()
	recipes = diamond_recipes

/obj/item/stack/sheet/mineral/uranium
	name = "uranium"
	icon_state = "sheet-uranium"
	origin_tech = "materials=5"
	materials = list(MAT_URANIUM=MINERAL_MATERIAL_AMOUNT)
	sheettype = "uranium"

/obj/item/stack/sheet/mineral/uranium/New()
	..()
	recipes = uranium_recipes

/obj/item/stack/sheet/mineral/plasma
	name = "solid plasma"
	icon_state = "sheet-plasma"
	origin_tech = "plasmatech=2;materials=2"
	materials = list(MAT_PLASMA=MINERAL_MATERIAL_AMOUNT)
	sheettype = "plasma"

/obj/item/stack/sheet/mineral/plasma/New()
	..()
	recipes = plasma_recipes

/obj/item/stack/sheet/mineral/plasma/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(is_hot(W) > 300)//If the temperature of the object is over 300, then ignite
		message_admins("Plasma sheets ignited by [key_name_admin(user)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[user]'>FLW</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
		log_game("Plasma sheets ignited by [key_name(user)] in ([x],[y],[z])")
		fire_act()
	else
		..()

/obj/item/stack/sheet/mineral/plasma/fire_act()
	//atmos_spawn_air(SPAWN_HEAT | SPAWN_TOXINS, amount*10) #TOREMOVE once linda is in place
	qdel(src)

/obj/item/stack/sheet/mineral/plastic
	name = "Plastic"
	icon_state = "sheet-plastic"
	origin_tech = "materials=3"

/obj/item/stack/sheet/mineral/plastic/New()
	..()
	recipes = plastic_recipes

/obj/item/stack/sheet/mineral/plastic/cyborg
	name = "plastic sheets"
	icon_state = "sheet-plastic"
	stacktype = /obj/item/stack/sheet/mineral/plastic

/obj/item/stack/sheet/mineral/gold
	name = "gold"
	icon_state = "sheet-gold"
	origin_tech = "materials=4"
	materials = list(MAT_GOLD=MINERAL_MATERIAL_AMOUNT)
	sheettype = "gold"

/obj/item/stack/sheet/mineral/gold/New()
	..()
	recipes = gold_recipes

/obj/item/stack/sheet/mineral/silver
	name = "silver"
	icon_state = "sheet-silver"
	origin_tech = "materials=3"
	materials = list(MAT_SILVER=MINERAL_MATERIAL_AMOUNT)
	sheettype = "silver"

/obj/item/stack/sheet/mineral/silver/New()
	..()
	recipes = silver_recipes

/obj/item/stack/sheet/mineral/bananium
	name = "bananium"
	icon_state = "sheet-clown"
	origin_tech = "materials=4"
	sheettype = "clown"
	materials = list(MAT_BANANIUM=MINERAL_MATERIAL_AMOUNT)

/obj/item/stack/sheet/mineral/enruranium
	name = "enriched uranium"
	icon_state = "sheet-enruranium"
	origin_tech = "materials=5"
	materials = list(MAT_URANIUM=3000)

//Valuable resource, cargo can sell it.
/obj/item/stack/sheet/mineral/platinum
	name = "platinum"
	icon_state = "sheet-adamantine"
	origin_tech = "materials=2"
	sheettype = "platinum"

//Extremely valuable to Research.
/obj/item/stack/sheet/mineral/mhydrogen
	name = "metallic hydrogen"
	icon_state = "sheet-mythril"
	origin_tech = "materials=6;powerstorage=5;magnets=5"
	sheettype = "mhydrogen"

//Fuel for MRSPACMAN generator.
/obj/item/stack/sheet/mineral/tritium
	name = "tritium"
	icon_state = "sheet-silver"
	sheettype = "tritium"
	origin_tech = "materials=5"
	color = "#777777"

/obj/item/stack/sheet/mineral/osmium
	name = "osmium"
	icon_state = "sheet-silver"
	sheettype = "osmium"
	origin_tech = "materials=5"
	color = "#9999FF"
