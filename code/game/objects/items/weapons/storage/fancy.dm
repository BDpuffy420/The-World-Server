/*
 * The 'fancy' path is for objects like donut boxes that show how many items are in the storage item on the sprite itself
 * .. Sorry for the shitty path name, I couldnt think of a better one.
 *
 * WARNING: var/icon_type is used for both examine text and sprite name. Please look at the procs below and adjust your sprite names accordingly
 *		TODO: Cigarette boxes should be ported to this standard
 *
 * Contains:
 *		Donut Box
 *		Egg Box
 *		Candle Box
 *		Crayon Box
 *		Cigarette Box
 */

/obj/item/weapon/storage/fancy/
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox6"
	name = "donut box"
	burn_state = 0 //Burnable
	var/icon_type = "donut"
	var/spawn_type = null

/obj/item/weapon/storage/fancy/New()
	..()
	for(var/i = 1 to storage_slots)
		new spawn_type(src)

/obj/item/weapon/storage/fancy/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "[src.icon_type]box[total_contents]"
	return

/obj/item/weapon/storage/fancy/examine(mob/user)
	..()
	if(contents.len == 1)
		user << "There is one [src.icon_type] left."
	else
		user << "There are [contents.len <= 0 ? "no" : "[src.contents.len]"] [src.icon_type]s left."


/*
 * Donut Box
 */

/obj/item/weapon/storage/fancy/donut_box
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "donutbox6"
	icon_type = "donut"
	name = "donut box"
	storage_slots = 6
	can_hold = list(/obj/item/weapon/reagent_containers/food/snacks/donut)
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/donut

/*
 * Egg Box
 */

/obj/item/weapon/storage/fancy/egg_box
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "eggbox"
	icon_type = "egg"
	name = "egg box"
	storage_slots = 12
	max_combined_w_class = 24
	can_hold = list("/obj/item/weapon/reagent_containers/food/snacks/egg")
	spawn_type = /obj/item/weapon/reagent_containers/food/snacks/egg

/*
 * Candle Box
 */

/obj/item/weapon/storage/fancy/candle_box
	name = "candle pack"
	desc = "A pack of red candles."
	icon = 'icons/obj/candle.dmi'
	icon_state = "candlebox5"
	icon_type = "candle"
	item_state = "candlebox5"
	storage_slots = 5
	throwforce = 2
	slot_flags = SLOT_BELT
	spawn_type = /obj/item/weapon/flame/candle


////////////
//CIG PACK//
////////////
/obj/item/weapon/storage/fancy/cigarettes
	name = "cigarette packet"
	desc = "The most popular brand of Space Cigarettes, sponsors of the Space Olympics."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cig"
	item_state = "cigpacket"
	w_class = 1
	throwforce = 0
	slot_flags = SLOT_BELT
	storage_slots = 6
	can_hold = list(/obj/item/clothing/mask/cigarette, /obj/item/weapon/lighter)
	icon_type = "cigarette"
	spawn_type = /obj/item/clothing/mask/cigarette


/obj/item/weapon/storage/fancy/cigarettes/New()
	..()
	flags |= NOREACT
	create_reagents(15 * storage_slots)//so people can inject cigarettes without opening a packet, now with being able to inject the whole one

/obj/item/weapon/storage/fancy/cigarettes/Destroy()
	qdel(reagents)
	..()

/obj/item/weapon/storage/fancy/cigarettes/update_icon()
	overlays.Cut()
	icon_state = initial(icon_state)
	if(!contents.len)
		icon_state += "_empty"
	else
		overlays += "[icon_state]_open"
		for(var/c = contents.len, c >= 1, c--)
			overlays += image(icon = src.icon, icon_state = "cigarette", pixel_x = 1 * (c -1))
	return

/obj/item/weapon/storage/fancy/cigarettes/remove_from_storage(obj/item/W, atom/new_location)
	if(istype(W,/obj/item/clothing/mask/cigarette))
		if(reagents)
			reagents.trans_to(W,(reagents.total_volume/contents.len))
	..()

/obj/item/weapon/storage/fancy/cigarettes/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	if(!istype(M, /mob))
		return
	var/obj/item/clothing/mask/cigarette/cig = locate(/obj/item/clothing/mask/cigarette) in contents
	if(cig)
		if(M == user && contents.len > 0 && !user.wear_mask)
			var/obj/item/clothing/mask/cigarette/W = cig
			remove_from_storage(W, M)
			M.equip_to_slot_if_possible(W, slot_wear_mask)
			contents -= W
			user << "<span class='notice'>You take a [icon_type] out of the pack.</span>"
		else
			..()
	else
		user << "<span class='notice'>There are no [icon_type]s left in the pack.</span>"


/obj/item/weapon/storage/fancy/cigarettes/dromedaryco
	name = "\improper DromedaryCo packet"
	desc = "A packet of six imported DromedaryCo cancer sticks. A label on the packaging reads, \"Wouldn't a slow death make a change?\""
	icon_state = "dromedary"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_uplift
	name = "\improper Uplift Smooth packet"
	desc = "Your favorite brand, now menthol flavored."
	icon_state = "uplift"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robust
	name = "\improper Robust packet"
	desc = "Smoked by the robust."
	icon_state = "robust"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robustgold
	name = "\improper Robust Gold packet"
	desc = "Smoked by the truly robust."
	icon_state = "robustg"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_robustgold/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("gold",1)

/obj/item/weapon/storage/fancy/cigarettes/cigpack_carp
	name = "\improper Carp Classic packet"
	desc = "Since 2313."
	icon_state = "carp"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate
	name = "cigarette packet"
	desc = "An obscure brand of cigarettes."
	icon_state = "syndie"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_syndicate/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("omnizine",15)


/obj/item/weapon/storage/fancy/cigarettes/cigpack_midori
	name = "\improper Midori Tabako packet"
	desc = "You can't understand the runes, but the packet smells funny."
	icon_state = "midori"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims
	name ="\improper Shady Jim's Super Slims"
	desc = "Is your weight slowing you down? Having trouble running away from gravitational singularities? Can't stop stuffing your mouth? Smoke Shady Jim's Super Slims and watch all that fat burn away. Guaranteed results!"
	icon_state = "shadyjim"

/obj/item/weapon/storage/fancy/cigarettes/cigpack_shadyjims/New()
	..()
	for(var/i = 1 to storage_slots)
		reagents.add_reagent("lipolicide",4)
		reagents.add_reagent("ammonia",2)
		reagents.add_reagent("plantbgone",1)
		reagents.add_reagent("toxin",1.5)

/obj/item/weapon/storage/fancy/rollingpapers
	name = "rolling paper pack"
	desc = "A pack of NanoTrasen brand rolling papers."
	w_class = 1
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "rolling_paper_pack"
	storage_slots = 10
	icon_type = "rolling paper"
	can_hold = list(/obj/item/weapon/rollingpaper)
	spawn_type = /obj/item/weapon/rollingpaper

/obj/item/weapon/storage/fancy/rollingpapers/update_icon()
	overlays.Cut()
	if(!contents.len)
		overlays += "[icon_state]_empty"
	return

/////////////
//CIGAR BOX//
/////////////

/obj/item/weapon/storage/fancy/cigarettes/cigars
	name = "\improper premium cigar case"
	desc = "A case of premium cigars. Very expensive."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarcase"
	w_class = 3
	storage_slots = 7
	can_hold = list(/obj/item/clothing/mask/cigarette/cigar)
	icon_type = "premium cigar"
	spawn_type = /obj/item/clothing/mask/cigarette/cigar

/obj/item/weapon/storage/fancy/cigarettes/cigars/update_icon()
	overlays.Cut()
	overlays += "[icon_state]_open"
	for(var/c = contents.len, c >= 1, c--)
		if(c <= 5) overlays += image(icon = src.icon, icon_state = icon_type, pixel_x = 4 * (c -1))
	return

/obj/item/weapon/storage/fancy/cigarettes/cigars/cohiba
	name = "\improper cohiba robusto cigar case"
	desc = "A case of imported Cohiba cigars, renowned for their strong flavor."
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/cohiba

/obj/item/weapon/storage/fancy/cigarettes/cigars/havana
	name = "\improper premium havanian cigar case"
	desc = "A case of classy Havanian cigars."
	spawn_type = /obj/item/clothing/mask/cigarette/cigar/havana

/*
 * Vial Box
 */

/obj/item/weapon/storage/fancy/vials
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox6"
	icon_type = "vial"
	name = "vial storage box"
	storage_slots = 6
	can_hold = list("/obj/item/weapon/reagent_containers/glass/beaker/vial")


/obj/item/weapon/storage/fancy/vials/New()
	..()
	for(var/i=1; i <= storage_slots; i++)
		new /obj/item/weapon/reagent_containers/glass/beaker/vial(src)
	return

/obj/item/weapon/storage/lockbox/vials
	name = "secure vial storage box"
	desc = "A locked box for keeping things away from children."
	icon = 'icons/obj/vialbox.dmi'
	icon_state = "vialbox0"
	item_state = "syringe_kit"
	max_w_class = 3
	can_hold = list("/obj/item/weapon/reagent_containers/glass/beaker/vial")
	max_combined_w_class = 14 //The sum of the w_classes of all the items in this storage item.
	storage_slots = 6
	req_access = list(access_virology)

/obj/item/weapon/storage/lockbox/vials/New()
	..()
	update_icon()

/obj/item/weapon/storage/lockbox/vials/update_icon(var/itemremoved = 0)
	var/total_contents = src.contents.len - itemremoved
	src.icon_state = "vialbox[total_contents]"
	src.overlays.Cut()
	if (!broken)
		overlays += image(icon, src, "led[locked]")
		if(locked)
			overlays += image(icon, src, "cover")
	else
		overlays += image(icon, src, "ledb")
	return

/obj/item/weapon/storage/lockbox/vials/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	update_icon()
