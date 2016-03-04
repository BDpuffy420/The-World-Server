//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/crates.dmi'
	var/icon_crate = "crate"
	icon_state = "crate"
	climbable = 1
	var/rigged = 0
	var/sound_effect_open = 'sound/machines/click.ogg'
	var/sound_effect_close = 'sound/machines/click.ogg'
	var/obj/item/weapon/paper/manifest/manifest

/obj/structure/closet/crate/New()
	..()
	update_icon()

/obj/structure/closet/crate/update_icon()
	overlays.Cut()
	if(opened)
		icon_state = "[icon_crate]open"
	else
		icon_state = icon_crate
	if(manifest)
		overlays += "manifest"

/obj/structure/closet/crate/internals
	desc = "A internals crate."
	name = "internals crate"
	icon_crate = "o2crate"
	icon_state = "o2crate"

/obj/structure/closet/crate/trashcart
	desc = "A heavy, metal trashcart with wheels."
	name = "trash cart"
	icon_crate = "trashcart"
	icon_state = "trashcart"

/obj/structure/closet/crate/medical
	desc = "A medical crate."
	name = "medical crate"
	icon_crate = "medicalcrate"
	icon_state = "medicalcrate"

/obj/structure/closet/crate/rcd
	desc = "A crate for the storage of the RCD."
	name = "\improper RCD crate"

/obj/structure/closet/crate/rcd/New()
	..()
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd(src)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

/obj/structure/closet/crate/solar/New()
	..()
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/weapon/circuitboard/solar_control(src)
	new /obj/item/weapon/tracker_electronics(src)
	new /obj/item/weapon/paper/solar(src)

/obj/structure/closet/crate/freezer
	desc = "A freezer."
	name = "freezer"
	icon_crate = "freezer"
	icon_state = "freezer"
	var/target_temp = T0C - 40
	var/cooling_power = 40

	return_air()
		var/datum/gas_mixture/gas = (..())
		if(!gas)	return null
		var/datum/gas_mixture/newgas = new/datum/gas_mixture()
		newgas.copy_from(gas)
		if(newgas.temperature <= target_temp)	return

		if((newgas.temperature - cooling_power) > target_temp)
			newgas.temperature -= cooling_power
		else
			newgas.temperature = target_temp
		return newgas

/obj/structure/closet/crate/freezer/rations //For use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."

/obj/structure/closet/crate/freezer/rations/New()
	..()
	new /obj/item/weapon/storage/box/donkpockets(src)
	new /obj/item/weapon/storage/box/donkpockets(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle(src)
	new /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle(src)
	new /obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle(src)

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_crate = "largemetal"

/obj/structure/closet/crate/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	icon_state = "largemetal"
	icon_crate = "largemetal"
	redlight = "largemetalr"
	greenlight = "largemetalg"

/obj/structure/closet/crate/secure/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plasticcrate"
	icon_crate = "plasticcrate"

/obj/structure/closet/crate/radiation
	desc = "A crate with a radiation sign on it."
	name = "radioactive gear crate"
	icon_crate = "radiation"
	icon_state = "radiation"

/obj/structure/closet/crate/radiation/New()
	..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_crate = "hydrocrate"
	icon_state = "hydrocrate"

/obj/structure/closet/crate/hydroponics/prespawned

/obj/structure/closet/crate/hydroponics/prespawned/New()
	..()
	new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
	new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
	new /obj/item/weapon/minihoe(src)

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "secure crate"
	icon_crate = "securecrate"
	icon_state = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"
	locked = 1
	health = 1000

/obj/structure/closet/crate/secure/weapon
	desc = "A secure weapons crate."
	name = "weapons crate"
	icon_crate = "weaponcrate"
	icon_state = "weaponcrate"

/obj/structure/closet/crate/secure/plasma
	desc = "A secure plasma crate."
	name = "plasma crate"
	icon_crate = "plasmacrate"
	icon_state = "plasmacrate"

/obj/structure/closet/crate/secure/gear
	desc = "A secure gear crate."
	name = "gear crate"
	icon_crate = "secgearcrate"
	icon_state = "secgearcrate"

/obj/structure/closet/crate/secure/hydrosec
	desc = "A crate with a lock on it, painted in the scheme of the station's botanists."
	name = "secure hydroponics crate"
	icon_crate = "hydrosecurecrate"
	icon_state = "hydrosecurecrate"

/obj/structure/closet/crate/secure/update_icon()
	..()
	if(locked)
		overlays += redlight
	else if(broken)
		overlays += emag
	else
		overlays += greenlight

/obj/structure/closet/crate/open()
	playsound(src.loc, sound_effect_open, 15, 1, -3)
	dump_contents()
	src.opened = 1
	update_icon()
	return 1

/obj/structure/closet/crate/close()
	playsound(src.loc, sound_effect_close, 15, 1, -3)
	take_contents()
	src.opened = 0
	update_icon()
	return 1

/obj/structure/closet/crate/insert(var/atom/movable/AM, var/include_mobs = 0)

	if(contents.len >= storage_capacity)
		return -1
	if(include_mobs && isliving(AM))
		var/mob/living/L = AM
		if(L.buckled)
			return 0
	else if(isobj(AM))
		if(AM.density || AM.anchored || istype(AM,/obj/structure/closet))
			return 0
	else
		return 0

	if(istype(AM, /obj/structure/stool/bed)) //This is only necessary because of rollerbeds and swivel chairs.
		var/obj/structure/stool/bed/B = AM
		if(B.buckled_mob)
			return 0

	AM.forceMove(src)
	return 1

/obj/structure/closet/crate/proc/tear_manifest(mob/user as mob)
	user << "<span class='notice'>You tear the manifest off of the crate.</span>"
	playsound(src.loc, 'sound/items/poster_ripped.ogg', 75, 1)
	manifest.forceMove(loc)
	if(ishuman(user))
		user.put_in_hands(manifest)
	manifest = null
	overlays-="manifest"

/obj/structure/closet/crate/attack_hand(mob/user as mob)
	if(manifest)
		tear_manifest(user)
		return
	if(opened)
		close()
	else
		if(rigged && locate(/obj/item/device/radio/electropack) in src)
			if(isliving(user))
				var/mob/living/L = user
				if(L.electrocute_act(17, src))
					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, src)
					s.start()
					return
		open()
	return

/obj/structure/closet/crate/secure/attack_hand(mob/user as mob)
	if(manifest)
		tear_manifest(user)
		return
	if(locked && !broken)
		if (allowed(user))
			user << "<span class='notice'>You unlock [src].</span>"
			src.locked = 0
			update_icon()
			add_fingerprint(user)
			return
		else
			user << "<span class='notice'>[src] is locked.</span>"
			return
	else
		..()

/obj/structure/closet/crate/secure/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(istype(W, /obj/item/weapon/card) && src.allowed(user) && !locked && !opened && !broken)
		user << "<span class='notice'>You lock \the [src].</span>"
		src.locked = 1
		update_icon()
		add_fingerprint(user)
		return

	return ..()

/obj/structure/closet/crate/secure/emag_act(mob/user as mob)
	if(locked && !broken)
		broken = 1
		locked = 0
		desc += " It appears to be broken."
		update_icon()
		for(var/mob/O in viewers(user, 3))
			O.show_message("<span class='warning'>The locker has been broken by [user] with an electromagnetic card!</span>", 1, "You hear a faint electrical spark.", 2)
		overlays += "securespark"
		playsound(src.loc, "sparks", 60, 1)
		spawn(6) //overlays don't support flick so we have to cheat
		update_icon()
		add_fingerprint(user)

/obj/structure/closet/crate/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(opened)
		if(isrobot(user))
			return
		if(!user.drop_item()) //couldn't drop the item
			user << "<span class='warning'>\The [W] is stuck to your hand, you cannot put it in \the [src]!</span>"
			return
		if(W)
			W.loc = src.loc
	else if(istype(W, /obj/item/weapon/packageWrap))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		if(rigged)
			user << "<span class='warning'>[src] is already rigged!</span>"
			return
		var/obj/item/stack/cable_coil/C = W
		if (C.use(5))
			user << "<span class='notice'>You rig [src].</span>"
			rigged = 1
		else
			user << "<span class='warning'>You need 5 lengths of cable to rig [src]!</span>"
		return
	else if(istype(W, /obj/item/device/radio/electropack))
		if(rigged)
			if(!user.drop_item())
				return
			user  << "<span class='notice'>You attach [W] to [src].</span>"
			W.forceMove(src)
			return
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(rigged)
			user  << "<span class='notice'>You cut away the wiring.</span>"
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else if(!place(user, W))
		return attack_hand(user)

/obj/structure/closet/crate/secure/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(!broken && !opened  && prob(50/severity))
		if(!locked)
			src.locked = 1
			update_icon()
		else
			src.locked = 0
			src.broken = 1
			update_icon()
			overlays += sparks
			spawn(6) overlays -= sparks //Tried lots of stuff but nothing works right. so i have to use this *sadface*
			playsound(src.loc, 'sound/effects/sparks4.ogg', 75, 1)
	if(!opened && prob(20/severity))
		if(!locked)
			open()
		else
			src.req_access = list()
			src.req_access += pick(get_all_accesses())
	..()

/obj/structure/closet/crate/ex_act(severity)
	switch(severity)
		if(1.0)
			for(var/obj/O in src.contents)
				qdel(O)
			qdel(src)
			return
		if(2.0)
			for(var/obj/O in src.contents)
				if(prob(50))
					qdel(O)
			qdel(src)
			return
		if(3.0)
			if (prob(50))
				qdel(src)
			return
		else
	return