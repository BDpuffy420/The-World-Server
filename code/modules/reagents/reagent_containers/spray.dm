/obj/item/weapon/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	flags = OPENCONTAINER | NOBLUDGEON
	slot_flags = SLOT_BELT
	throwforce = 0
	w_class = 2
	throw_speed = 3
	throw_range = 7
	var/spray_maxrange = 3 //what the sprayer will set spray_currentrange to in the attack_self.
	var/spray_currentrange = 3 //the range of tiles the sprayer will reach when in fixed mode.
	amount_per_transfer_from_this = 5
	volume = 250
	possible_transfer_amounts = null


/obj/item/weapon/reagent_containers/spray/afterattack(atom/A as mob|obj, mob/user as mob)
	if(istype(A, /obj/item/weapon/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/closet) \
	|| istype(A, /obj/item/weapon/reagent_containers) || istype(A, /obj/structure/sink) || istype(A, /obj/structure/janitorialcart))
		return

	if(istype(A, /obj/effect/proc_holder/spell))
		return

	if(istype(A, /obj/structure/reagent_dispensers) && get_dist(src,A) <= 1) //this block copypasted from reagent_containers/glass, for lack of a better solution
		if(!A.reagents.total_volume && A.reagents)
			user << "<span class='notice'>\The [A] is empty.</span>"
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			user << "<span class='notice'>\The [src] is full.</span>"
			return

		var/trans = A.reagents.trans_to(src, A:amount_per_transfer_from_this)
		user << "<span class='notice'>You fill \the [src] with [trans] units of the contents of \the [A].</span>"
		user.changeNext_move(CLICK_CD_FILL)
		return

	if(reagents.total_volume < amount_per_transfer_from_this)
		user << "<span class='notice'>\The [src] is empty!</span>"
		return

	spray(A)

	playsound(src.loc, 'sound/effects/spray2.ogg', 50, 1, -6)
	user.changeNext_move(CLICK_CD_RANGE*2)
	user.newtonian_move(get_dir(A, user))
	var/turf/T = get_turf(src)
	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from \a [src] at [get_area(src)] ([T.x], [T.y], [T.z]).")
		log_game("[key_name(user)] fired sulphuric acid from \a [src] at [get_area(src)] ([T.x], [T.y], [T.z]).")
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from \a [src] at [get_area(src)] ([T.x], [T.y], [T.z]).")
		log_game("[key_name(user)] fired Polyacid from \a [src] at [get_area(src)] ([T.x], [T.y], [T.z]).")
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from \a [src] at [get_area(src)] ([T.x], [T.y], [T.z]).")
		log_game("[key_name(user)] fired Space lube from \a [src] at [get_area(src)] ([T.x], [T.y], [T.z]).")
	return

/obj/item/weapon/reagent_containers/spray/proc/spray(atom/A)
	var/range = max(min(spray_currentrange, get_dist(src, A)), 1)
	var/obj/effect/decal/chempuff/D = new /obj/effect/decal/chempuff(get_turf(src))
	D.create_reagents(amount_per_transfer_from_this)
	reagents.trans_to(D, amount_per_transfer_from_this, 1/range)
	D.icon += mix_color_from_reagents(D.reagents.reagent_list)
	var/puff_reagent_left = range //how many turf, mob or dense objet we can react with before we consider the chem puff consumed
	var/wait_step = max(round(2+3/range), 2)

	var/turf/A_turf = get_turf(A)//BS12

	spawn(0)
		for(var/i=0, i<range, i++)
			step_towards(D,A)
			sleep(wait_step)

			for(var/atom/T in get_turf(D))
				if(T == D || T.invisibility) //we ignore the puff itself and stuff below the floor
					continue
				if(puff_reagent_left <= 0)
					break
				D.reagents.reaction(T, VAPOR)
				if(ismob(T)) //mobs are obstacles that consume part of the puff, shortening its range.
					puff_reagent_left -= 1

				// When spraying against the wall, also react with the wall, but
				// not its contents. BS12
				if(get_dist(D, A_turf) == 1 && A_turf.density)
					D.reagents.reaction(A_turf)
					puff_reagent_left -= 1

			if(puff_reagent_left > 0)
				D.reagents.reaction(get_turf(D), VAPOR)
				puff_reagent_left -= 1

			if(puff_reagent_left <= 0) // we used all the puff so we delete it.
				qdel(D)
				return
		qdel(D)


/obj/item/weapon/reagent_containers/spray/attack_self(mob/user)

	amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
	spray_currentrange = (spray_currentrange == 1 ? spray_maxrange : 1)
	user << "<span class='notice'>You [amount_per_transfer_from_this == 10 ? "remove" : "fix"] the nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>"


/obj/item/weapon/reagent_containers/spray/examine(mob/user)
	if(..(user, 0) && user==src.loc)
		user << "[round(src.reagents.total_volume)] units left."
	return

/obj/item/weapon/reagent_containers/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr
	if(usr.stat || !usr.canmove || usr.restrained())
		return
	if (alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", "Yes", "No") != "Yes")
		return
	if(isturf(usr.loc) && src.loc == usr)
		usr << "<span class='notice'>You empty \the [src] onto the floor.</span>"
		reagents.reaction(usr.loc)
		src.reagents.clear_reagents()

//space cleaner
/obj/item/weapon/reagent_containers/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	list_reagents = list("cleaner" = 250)

/obj/item/weapon/reagent_containers/spray/cleaner/drone
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	volume = 50

//pepperspray
/obj/item/weapon/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	volume = 40
	spray_maxrange = 4
	amount_per_transfer_from_this = 5
	list_reagents = list("condensedcapsaicin" = 40)
	var/safety = 1

/obj/item/weapon/reagent_containers/spray/pepper/examine(mob/user)
	if(..(user, 1))
		user << "The safety is [safety ? "on" : "off"]."

/obj/item/weapon/reagent_containers/spray/pepper/attack_self(var/mob/user)
	safety = !safety
	usr << "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>"

/obj/item/weapon/reagent_containers/spray/pepper/spray(atom/A)
	if(safety)
		usr << "<span class = 'warning'>The safety is on!</span>"
		return
	..()

/obj/item/weapon/reagent_containers/spray/pepper/attack_self(var/mob/user)
	safety = !safety
	usr << "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>"

//water flower
/obj/item/weapon/reagent_containers/spray/waterflower
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/harvest.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	volume = 10
	list_reagents = list("water" = 10)

/obj/item/weapon/reagent_containers/spray/waterflower/attack_self(mob/user) //Don't allow changing how much the flower sprays
	return

//chemsprayer
/obj/item/weapon/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagents in a given area."
	icon = 'icons/obj/gun.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	throwforce = 0
	w_class = 3
	spray_maxrange = 7
	spray_currentrange = 7
	amount_per_transfer_from_this = 10
	volume = 600
	origin_tech = "combat=3;materials=3;engineering=3"

/obj/item/weapon/reagent_containers/spray/chemsprayer/spray(atom/A)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)
	for(var/i=1, i<=3, i++) // intialize sprays
		if(reagents.total_volume < 1)
			return
		..(the_targets[i])

/obj/item/weapon/reagent_containers/spray/chemsprayer/attack_self(mob/user)
	amount_per_transfer_from_this = (amount_per_transfer_from_this == 10 ? 5 : 10)
	user << "<span class='notice'>You adjust the output switch. You'll now use [amount_per_transfer_from_this] units per spray.</span>"
/obj/item/weapon/reagent_containers/spray/chemsprayer/bioterror
	list_reagents = list("sodium_thiopental" = 100, "coniine" = 100, "venom" = 100, "condensedcapsaicin" = 100, "initropidril" = 100, "polonium" = 100)
// Plant-B-Gone
/obj/item/weapon/reagent_containers/spray/plantbgone // -- Skie
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100
	list_reagents = list("plantbgone" = 100)

/obj/item/weapon/reagent_containers/spray/plantbgone/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(!proximity) return

	if (istype(A, /obj/effect/blob)) // blob damage in blob code
		return

	..()