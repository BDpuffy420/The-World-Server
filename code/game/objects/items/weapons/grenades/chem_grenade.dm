#define EMPTY 1
#define WIRED 2
#define READY 3

/obj/item/weapon/grenade/chem_grenade
	name = "grenade"
	icon_state = "chemg"
	item_state = "grenade"
	desc = "A hand made chemical grenade."
	w_class = 2.0
	force = 2.0
	var/stage = EMPTY
	var/list/beakers = list()
	var/list/allowed_containers = list(/obj/item/weapon/reagent_containers/glass/beaker, /obj/item/weapon/reagent_containers/glass/bottle)
	var/affected_area = 3
	var/obj/item/device/assembly_holder/nadeassembly = null
	var/assemblyattacher

/obj/item/weapon/grenade/chem_grenade/New()
	create_reagents(1000)
	stage_change() // If no argument is set, it will change the stage to the current stage, useful for stock grenades that start READY.


/obj/item/weapon/grenade/chem_grenade/examine(mob/user)
	display_timer = (stage == READY && !nadeassembly)	//show/hide the timer based on assembly state
	..()

/obj/item/weapon/grenade/chem_grenade/update_icon(is_active)
	if(is_active)
		icon_state = "chemg_active"
		item_state = "grenade_active"
	else
		icon_state = "chemg_locked"
		item_state = "grenade"
	if(ismob(loc))
		var/mob/living/carbon/C = loc
		C.update_inv_l_hand()
		C.update_inv_r_hand()

/obj/item/weapon/grenade/chem_grenade/attack_self(mob/user)
	if(stage == READY &&  !active)
		if(nadeassembly)
			nadeassembly.attack_self(user)
		else if(clown_check(user))
			var/turf/bombturf = get_turf(src)
			var/area/A = get_area(bombturf)
			message_admins("[key_name_admin(usr)]<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[usr]'>FLW</A>) has primed a [name] for detonation at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
			log_game("[key_name(usr)] has primed a [name] for detonation at [A.name] ([bombturf.x],[bombturf.y],[bombturf.z]).")
			user << "<span class='warning'>You prime the [name]! [det_time / 10] second\s!</span>"
			playsound(user.loc, 'sound/weapons/armbomb.ogg', 60, 1)
			active = 1
			update_icon(active)
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
			//if(istype(user,/mob/living/carbon/human))
			//	var/mob/living/carbon/human/H = user
			//	H.update_inv_l_hand()
			//	H.update_inv_r_hand()

			spawn(det_time)
				prime()


/obj/item/weapon/grenade/chem_grenade/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/weapon/screwdriver))
		if(stage == WIRED)
			if(beakers.len)
				stage_change(READY)
				user << "<span class='notice'>You lock the [initial(name)] assembly.</span>"
				playsound(loc, 'sound/items/Screwdriver.ogg', 25, -3)
			else
				user << "<span class='warning'>You need to add at least one beaker before locking the [initial(name)] assembly!</span>"
		else if(stage == READY && !nadeassembly)
			det_time = det_time == 50 ? 30 : 50	//toggle between 30 and 50
			user << "<span class='notice'>You modify the time delay. It's set for [det_time / 10] second\s.</span>"
		else if(stage == EMPTY)
			user << "<span class='warning'>You need to add an activation mechanism!</span>"

	else if(stage == WIRED && is_type_in_list(I, allowed_containers))
		if(beakers.len == 2)
			user << "<span class='warning'>[src] can not hold more containers!</span>"
			return
		else
			if(I.reagents.total_volume)
				user << "<span class='notice'>You add [I] to the [initial(name)] assembly.</span>"
				user.drop_item()
				I.loc = src
				beakers += I
			else
				user << "<span class='warning'>[I] is empty!</span>"

	else if(stage == EMPTY && istype(I, /obj/item/device/assembly_holder))
		var/obj/item/device/assembly_holder/A = I
		if(isigniter(A.a_left) == isigniter(A.a_right))	//Check if either part of the assembly has an igniter, but if both parts are igniters, then fuck it
			return

		user.drop_item()
		nadeassembly = A
		A.master = src
		A.loc = src
		assemblyattacher = user.ckey

		stage_change(WIRED)
		user << "<span class='notice'>You add [A] to the [initial(name)] assembly.</span>"

	else if(stage == EMPTY && istype(I, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = I
		if (C.use(1))
			det_time = 50 // In case the cable_coil was removed and readded.
			stage_change(WIRED)
			user << "<span class='notice'>You rig the [initial(name)] assembly.</span>"
		else
			user << "<span class='warning'>You need one length of coil to wire the assembly!</span>"
			return

	else if(stage == READY && istype(I, /obj/item/weapon/wirecutters))
		stage_change(WIRED)
		user << "<span class='notice'>You unlock the [initial(name)] assembly.</span>"

	else if(stage == WIRED && istype(I, /obj/item/weapon/wrench))
		if(beakers.len)
			for(var/obj/O in beakers)
				O.loc = get_turf(src)
			beakers = list()
			user << "<span class='notice'>You open the [initial(name)] assembly and remove the payload.</span>"
			return // First use of the wrench remove beakers, then use the wrench to remove the activation mechanism.
		if(nadeassembly)
			nadeassembly.loc = get_turf(src)
			nadeassembly.master = null
			nadeassembly = null
		else // If "nadeassembly = null && stage == WIRED", then it most have been cable_coil that was used.
			new /obj/item/stack/cable_coil(get_turf(src),1)
		stage_change(EMPTY)
		user << "<span class='notice'>You remove the activation mechanism from the [initial(name)] assembly.</span>"


/obj/item/weapon/grenade/chem_grenade/proc/stage_change(var/N)
	if(N)
		stage = N
	if(stage == EMPTY)
		name = "[initial(name)] casing"
		desc = "A do it yourself [initial(name)] casing!"
		icon_state = initial(icon_state)
	else if(stage == WIRED)
		name = "unsecured [initial(name)]"
		desc = "An unsecured [initial(name)] assembly."
		icon_state = "[initial(icon_state)]_ass"
	else if(stage == READY)
		name = initial(name)
		desc = initial(desc)
		icon_state = "[initial(icon_state)]_locked"


//assembly stuff
/obj/item/weapon/grenade/chem_grenade/receive_signal()
	active = 1
	prime()

/obj/item/weapon/grenade/chem_grenade/HasProximity(atom/movable/AM)
	if(nadeassembly)
		nadeassembly.HasProximity(AM)

/obj/item/weapon/grenade/chem_grenade/Crossed(atom/movable/AM)
	if(nadeassembly)
		nadeassembly.Crossed(AM)

/obj/item/weapon/grenade/chem_grenade/on_found(mob/finder)
	if(nadeassembly)
		nadeassembly.on_found(finder)

/obj/item/weapon/grenade/chem_grenade/prime()
	if(stage != READY)
		return

	var/has_reagents
	for(var/obj/item/I in beakers)
		if(I.reagents.total_volume)
			has_reagents = 1

	if(!has_reagents)
		playsound(loc, 'sound/items/Screwdriver2.ogg', 50, 1)
		return

	if(nadeassembly)
		var/mob/M = get_mob_by_ckey(assemblyattacher)
		var/mob/last = get_mob_by_ckey(nadeassembly.fingerprintslast)
		var/turf/T = get_turf(src)
		var/area/A = get_area(T)
		message_admins("grenade primed by an assembly, attached by [key_name_admin(M)]<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>(?)</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[M]'>FLW</A>) and last touched by [key_name_admin(last)]<A HREF='?_src_=holder;adminmoreinfo=\ref[last]'>(?)</A> (<A HREF='?_src_=holder;adminplayerobservefollow=\ref[last]'>FLW</A>) ([nadeassembly.a_left.name] and [nadeassembly.a_right.name]) at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[T.x];Y=[T.y];Z=[T.z]'>[A.name] (JMP)</a>.")
		log_game("grenade primed by an assembly, attached by [key_name(M)] and last touched by [key_name(last)] ([nadeassembly.a_left.name] and [nadeassembly.a_right.name]) at [A.name] ([T.x], [T.y], [T.z])")

	playsound(loc, 'sound/effects/bamf.ogg', 50, 1)

	update_mob()

	mix_reagents()

	if(reagents.total_volume)	//The possible reactions didnt use up all reagents, so we spread it around.
		var/datum/effect/effect/system/steam_spread/steam = new /datum/effect/effect/system/steam_spread()
		steam.set_up(10, 0, get_turf(src))
		steam.attach(src)
		steam.start()

		var/list/viewable = view(affected_area, loc)
		var/list/accessible = can_flood_from(loc, affected_area)
		var/list/reactable = accessible
		var/mycontents = GetAllContents()
		for(var/turf/T in accessible)
			for(var/atom/A in T.GetAllContents())
				if(A in mycontents) continue
				if(!(A in viewable)) continue
				reactable |= A
		if(!reactable.len) //Nothing to react with. Probably means we're in nullspace.
			qdel(src)
			return
		var/fraction = 1/reactable.len
		for(var/atom/A in reactable)
			reagents.reaction(A, TOUCH, fraction)

	invisibility = INVISIBILITY_MAXIMUM //Why am i doing this?
	spawn(50)		   //To make sure all reagents can work
		qdel(src)	   //correctly before deleting the grenade.


/obj/item/weapon/grenade/chem_grenade/proc/mix_reagents()
	//var/total_temp #TOREMOVE
	for(var/obj/item/weapon/reagent_containers/glass/G in beakers)
		G.reagents.trans_to(src, G.reagents.total_volume)
		//total_temp += G.reagents.chem_temp
	//reagents.chem_temp = total_temp

/obj/item/weapon/grenade/chem_grenade/proc/can_flood_from(myloc, maxrange)
	var/turf/myturf = get_turf(myloc)
	var/list/reachable = list(myloc)
	for(var/i=1; i<=maxrange; i++)
		var/list/turflist = list()
		for(var/turf/T in (orange(i, myloc) - orange(i-1, myloc)))
			turflist |= T
		for(var/turf/T in turflist)
			if( !(get_dir(T,myloc) in cardinal) && (abs(T.x - myturf.x) == abs(T.y - myturf.y) ))
				turflist.Remove(T)
				turflist.Add(T) // we move the purely diagonal turfs to the end of the list.
		for(var/turf/T in turflist)
			if(T in reachable) continue
			for(var/turf/NT in orange(1, T))
				if(!(NT in reachable)) continue
				if(!(get_dir(T,NT) in cardinal)) continue
				//if(!NT.CanAtmosPass(T)) continue
				reachable |= T
				break
	return reachable

/obj/item/weapon/grenade/chem_grenade/large
	name = "large chem grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "large_grenade"
	allowed_containers = list(/obj/item/weapon/reagent_containers/glass)
	origin_tech = "combat=3;materials=3"
	affected_area = 4

/obj/item/weapon/grenade/chem_grenade/metalfoam
	name = "metal-foam grenade"
	desc = "Used for emergency sealing of air breaches."
	stage = READY

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 30)
		B2.reagents.add_reagent("foaming_agent", 10)
		B2.reagents.add_reagent("pacid", 10)


		beakers += B1
		beakers += B2

/obj/item/weapon/grenade/chem_grenade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	stage = READY

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("aluminum", 15)
		B1.reagents.add_reagent("welding_fuel",20)
		B2.reagents.add_reagent("plasma", 15)
		B2.reagents.add_reagent("sacid", 15)
		B1.reagents.add_reagent("welding_fuel",20)


		beakers += B1
		beakers += B2

/obj/item/weapon/grenade/chem_grenade/antiweed
	name = "weedkiller grenade"
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."
	stage = READY

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("plantbgone", 25)
		B1.reagents.add_reagent("potassium", 25)
		B2.reagents.add_reagent("phosphorus", 25)
		B2.reagents.add_reagent("sugar", 25)


		beakers += B1
		beakers += B2
		icon_state = "grenade"

/obj/item/weapon/grenade/chem_grenade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."
	stage = READY

	New()
		..()
		var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
		var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

		B1.reagents.add_reagent("fluorosurfactant", 40)
		B2.reagents.add_reagent("water", 40)
		B2.reagents.add_reagent("cleaner", 10)


		beakers += B1
		beakers += B2

/obj/item/weapon/grenade/chem_grenade/teargas
	name = "teargas grenade"
	desc = "Used for nonlethal riot control. Contents under pressure. Do not directly inhale contents."
	stage = READY

/obj/item/weapon/grenade/chem_grenade/teargas/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("condensedcapsaicin", 70)
	B1.reagents.add_reagent("potassium", 30)
	B2.reagents.add_reagent("phosphorus", 30)
	B2.reagents.add_reagent("sugar", 30)
	B1.reagents.add_reagent("condensedcapsaicin", 40)

	beakers += B1
	beakers += B2


/obj/item/weapon/grenade/chem_grenade/facid
	name = "acid grenade"
	desc = "Used for melting armoured opponents."
	stage = READY

/obj/item/weapon/grenade/chem_grenade/facid/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent("facid", 290)
	B1.reagents.add_reagent("potassium", 10)
	B2.reagents.add_reagent("phosphorus", 10)
	B2.reagents.add_reagent("sugar", 10)
	B2.reagents.add_reagent("facid", 280)

	beakers += B1
	beakers += B2


/obj/item/weapon/grenade/chem_grenade/colorful
	name = "colorful grenade"
	desc = "Used for wide scale painting projects."
	stage = READY

/obj/item/weapon/grenade/chem_grenade/colorful/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("colorful_reagent", 25)
	B1.reagents.add_reagent("potassium", 25)
	B2.reagents.add_reagent("phosphorus", 25)
	B2.reagents.add_reagent("sugar", 25)

	beakers += B1
	beakers += B2


/obj/item/weapon/grenade/chem_grenade/clf3
	name = "clf3 grenade"
	desc = "BURN!-brand foaming clf3. In a special applicator for rapid purging of wide areas."
	stage = READY

/obj/item/weapon/grenade/chem_grenade/clf3/New()
	..()
	var/obj/item/weapon/reagent_containers/glass/beaker/bluespace/B1 = new(src)
	var/obj/item/weapon/reagent_containers/glass/beaker/bluespace/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 250)
	B1.reagents.add_reagent("clf3", 50)
	B2.reagents.add_reagent("water", 250)
	B2.reagents.add_reagent("clf3", 50)

	beakers += B1
	beakers += B2



#undef EMPTY
#undef WIRED
#undef READY