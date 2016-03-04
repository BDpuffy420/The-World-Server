/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = 1
	var/icon_door = null
	var/icon_door_override = 0 //override to have open overlay use icon different to its base's
	var/secure = 0 //secure locker or not, also used if overriding a non-secure locker with a secure door overlay to add fancy lights
	var/opened = 0
	var/welded = 0
	var/locked = 0
	var/broken = 0
	var/large = 1
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/health = 100
	var/lastbang
	var/max_mob_size = MOB_SIZE_HUMAN //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 3 // how many human sized mob/living can fit together inside a closet.
	var/storage_capacity = 40 //This is so that someone can't pack hundreds of items in a locker/crate
							  //then open it in a populated area to crash clients.
	var/open_sound = 'sound/machines/click.ogg'
	var/close_sound = 'sound/machines/click.ogg'

	var/store_misc = 1
	var/store_items = 1
	var/store_mobs = 1

	var/const/default_mob_size = 15

	var/icon_opened
	var/icon_closed

/obj/structure/closet/New()
	..()
	update_icon()

/obj/structure/closet/Destroy()
	dump_contents()
	return ..()

/obj/structure/closet/initialize()
	..()
	if(!opened)		// if closed, any item at the crate's loc is put in the contents
		take_contents()

/obj/structure/closet/update_icon()
	overlays.Cut()
	if(!opened)
		if(icon_door)
			overlays += "[icon_door]_door"
		else
			overlays += "[icon_state]_door"
		if(welded)
			overlays += "welded"
		if(secure)
			if(!broken)
				if(locked)
					overlays += "locked"
				else
					overlays += "unlocked"
			else
				overlays += "off"
	else
		if(icon_door_override)
			overlays += "[icon_door]_open"
		else
			overlays += "[icon_state]_open"

/obj/structure/closet/examine(mob/user)
	..()
	if(secure)
		if(broken || opened || !ishuman(user))
			return //Monkeys don't get a message, nor does anyone if it's open or emagged
		else
			user << "<span class='notice'>Alt-click the locker to [locked ? "unlock" : "lock"] it.</span>"

/obj/structure/closet/alter_health()
	return get_turf(src)

/obj/structure/closet/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0 || wall_mounted)) return 1
	return (!density)

/obj/structure/closet/proc/can_open()
	if(welded || locked)
		return 0
	return 1

/obj/structure/closet/proc/can_close()
	for(var/obj/structure/closet/closet in get_turf(src))
		if(closet != src)
			return 0
	return 1

/obj/structure/closet/proc/dump_contents()
	//Cham Projector Exception
	for(var/obj/effect/dummy/chameleon/AD in src)
		AD.forceMove(loc)

	for(var/obj/I in src)
		I.forceMove(loc)

	for(var/mob/M in src)
		M.forceMove(loc)
		if(M.client)
			M.client.eye = M.client.mob
			M.client.perspective = MOB_PERSPECTIVE

/obj/structure/closet/proc/take_contents()

	for(var/atom/movable/AM in loc)
		if(insert(AM) == -1) // limit reached
			break

/obj/structure/closet/proc/open()
	if(src.opened)
		return 0
	if(!src.can_open())
		return 0
	dump_contents()

	opened = 1
	playsound(src.loc, open_sound, 15, 1, -3)
	density = 0
	update_icon()
	return 1

/obj/structure/closet/proc/insert(var/atom/movable/AM)

	if(contents.len >= storage_capacity)
		return -1

	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		if(L.buckled || L.mob_size > max_mob_size) //buckled mobs and mobs too big for the container don't get inside closets.
			return 0
		if(L.mob_size > MOB_SIZE_TINY) //decently sized mobs take more space than objects.
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				mobs_stored++
				if(mobs_stored >= mob_storage_capacity)
					return 0
		if(L.client)
			L.client.perspective = EYE_PERSPECTIVE
			L.client.eye = src
	else if(!istype(AM, /obj/item) && !istype(AM, /obj/effect/dummy/chameleon))
		return 0
	else if(AM.density || AM.anchored)
		return 0
	else if(AM.flags & NODROP)
		return 0
	AM.forceMove(src)
	return 1

/obj/structure/closet/proc/close()
	if(!opened)
		return 0
	if(!can_close())
		return 0
	take_contents()

	opened = 0
	playsound(src.loc, close_sound, 15, 1, -3)
	density = 1
	update_icon()
	return 1

/obj/structure/closet/proc/store_mobs(var/stored_units)
	var/added_units = 0
	for(var/mob/living/M in src.loc)
		if(M.buckled || M.pinned.len)
			continue
		var/current_mob_size = (M.mob_size ? M.mob_size : default_mob_size)
		if(stored_units + added_units + current_mob_size > storage_capacity)
			break
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		added_units += current_mob_size
	return added_units

/obj/structure/closet/proc/toggle()
	if(opened)
		return close()
	return open()

// this should probably use dump_contents()
/obj/structure/closet/ex_act(severity)
	switch(severity)
		if(1)
			for(var/atom/movable/A as mob|obj in src)//pulls everything out of the locker and hits it with an explosion
				A.forceMove(loc)
				A.ex_act(severity++)
			qdel(src)
		if(2)
			if(prob(50))
				for (var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					A.ex_act(severity++)
				qdel(src)
		if(3)
			if(prob(5))
				for(var/atom/movable/A as mob|obj in src)
					A.forceMove(loc)
					A.ex_act(severity++)
				qdel(src)

/obj/structure/closet/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	if(health <= 0)
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(loc)
		qdel(src)

	return

// this should probably use dump_contents()
/obj/structure/closet/blob_act()
	if(prob(75))
		for(var/atom/movable/A as mob|obj in src)
			A.forceMove(loc)
		qdel(src)

/obj/structure/closet/meteorhit(obj/O as obj)
	if(O.icon_state == "flaming")
		for(var/mob/M in src)
			M.meteorhit(O)
		src.dump_contents()
		qdel(src)

/obj/structure/closet/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if(user.loc == src)
		return
	if(opened)
		if(istype(W, /obj/item/weapon/grab))
			if(large)
				var/obj/item/weapon/grab/G = W
				MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
				user.drop_item()
			else
				user << "<span class='notice'>The locker is too small to stuff [W] into!</span>"
			return
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin cutting \the [src] apart...</span>"
				playsound(loc, 'sound/items/Welder.ogg', 40, 1)
				if(do_after(user,40,5,1, target = src))
					if( !opened || !istype(src, /obj/structure/closet) || !user || !WT || !WT.isOn() || !user.loc )
						return
					playsound(loc, 'sound/items/Welder2.ogg', 50, 1)
					new /obj/item/stack/sheet/metal(loc)
					visible_message("[user] has cut \the [src] apart with \the [WT].", "<span class='italics'>You hear welding.</span>")
					qdel(src)
				return
		if(isrobot(user))
			return
		if(user.drop_item())
			W.forceMove(loc)
	else
		if(istype(W, /obj/item/weapon/packageWrap))
			return
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(WT.remove_fuel(0,user))
				user << "<span class='notice'>You begin [welded ? "unwelding":"welding"] \the [src]...</span>"
				playsound(loc, 'sound/items/Welder2.ogg', 40, 1)
				if(do_after(user,40,5,1, target = src))
					if(opened || !istype(src, /obj/structure/closet) || !user || !WT || !WT.isOn() || !user.loc )
						return
					playsound(loc, 'sound/items/welder.ogg', 50, 1)
					welded = !welded
					user << "<span class='notice'>You [welded ? "weld [src] shut":"unweld [src]"].</span>"
					update_icon()
					user.visible_message("[user.name] has [welded ? "welded [src] shut":"unwelded [src]"].", "<span class='warning'>You [welded ? "weld [src] shut":"unweld [src]"].</span>")
				return
		if(secure && broken)
			user << "<span class='notice'>The locker appears to be broken.</span>"
			return
		if(!place(user, W) && !isnull(W))
			attack_hand(user)
/*
/obj/structure/closet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			src.MouseDrop_T(G.affecting, user)      //act like they were dragged onto the closet
		if(istype(W,/obj/item/tk_grab))
			return 0
		if(istype(W, /obj/item/weapon/weldingtool))
			var/obj/item/weapon/weldingtool/WT = W
			if(!WT.remove_fuel(0,user))
				user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
				return
			new /obj/item/stack/sheet/metal(src.loc)
			for(var/mob/M in viewers(src))
				M.show_message("<span class='notice'>\The [src] has been cut apart by [user] with \the [WT].</span>", 3, "You hear welding.", 2)
			del(src)
			return
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		usr.drop_item()
		if(W)
			W.loc = src.loc
	else if(istype(W, /obj/item/weapon/packageWrap))
		return
	else if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(!WT.remove_fuel(0,user))
			user << "<span class='notice'>You need more welding fuel to complete this task.</span>"
			return
		src.welded = !src.welded
		src.update_icon()
		for(var/mob/M in viewers(src))
			M.show_message("<span class='warning'>[src] has been [welded?"welded shut":"unwelded"] by [user.name].</span>", 3, "You hear welding.", 2)
	else
		src.attack_hand(user)
	return */

/obj/structure/closet/proc/place(var/mob/user, var/obj/item/I)
	if(!opened && secure)
		togglelock(user)
		return 1
	return 0

/obj/structure/closet/MouseDrop_T(atom/movable/O as mob|obj, mob/user as mob, var/needs_opened = 1, var/show_message = 1, var/move_them = 1)
	if(istype(O, /obj/screen))	//fix for HUD elements making their way into the world	-Pete
		return
	if(!isturf(O.loc))
		return
	if(user.restrained() || user.stat || user.weakened || user.stunned || user.paralysis)
		return
	if((!( istype(O, /atom/movable) ) || O.anchored || get_dist(user, src) > 1 || get_dist(user, O) > 1 || user.contents.Find(src)))
		return
	if(user.loc==null) // just in case someone manages to get a closet into the blue light dimension, as unlikely as that seems
		return
	if(!istype(user.loc, /turf)) // are you in a container/closet/pod/etc?
		return
	if(needs_opened && !opened)
		return
	if(istype(O, /obj/structure/closet))
		return
	if(move_them)
		step_towards(O, src.loc)
	if(user != O)
		user.show_viewers("<span class='danger'>[user] stuffs [O] into [src]!</span>")
	add_fingerprint(user)
	return 1

/obj/structure/closet/relaymove(mob/user as mob)
	if(user.stat || !isturf(loc))
		return
	if(!open())
		user << "<span class='notice'>It won't budge!</span>"
		if(!lastbang)
			lastbang = 1
		if(world.time > lastbang+5)
			lastbang = world.time
			for(var/mob/M in get_mobs_in_view(src, null))
				M.show_message("<FONT size=[max(0, 5 - get_dist(src, M))]>BANG, bang!</FONT>", 2)

/obj/structure/closet/attack_hand(mob/user as mob)
	if(user.lying && get_dist(src, user) > 0)
		return

	if(!toggle())
		togglelock(user)
		add_fingerprint(user)
		return

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user as mob)
	return attack_hand(user)

/obj/structure/closet/verb/verb_toggleopen()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canmove || usr.stat || usr.restrained())
		return

	if(ishuman(usr))
		attack_hand(usr)
	else
		usr << "<span class='warning'>This mob type can't use this verb.</span>"

// Objects that try to exit a locker by stepping were doing so successfully,
// and due to an oversight in turf/Enter() were going through walls.  That
// should be independently resolved, but this is also an interesting twist.
/obj/structure/closet/Exit(atom/movable/AM)
	open()
	if(AM.loc == src) return 0
	return 1
/obj/structure/closet/container_resist()
	var/mob/living/user = usr
	var/breakout_time = 2 //2 minutes by default
	if(istype(user.loc, /obj/structure/closet/critter) && !welded)
		breakout_time = 0.75 //45 seconds if it's an unwelded critter crate

	if( opened || (!welded && !locked && !istype(loc, /obj/mecha)) )
		return  //Door's open, not locked or welded or inside a mech, no point in resisting.

	//okay, so the closet is either welded or locked... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user << "<span class='notice'>You lean on the back of [src] and start pushing the door open. (this will take about [breakout_time] minutes.)</span>"
	for(var/mob/O in viewers(src))
		O << "<span class='warning'>[src] begins to shake violently!</span>"
	if(do_after(user,(breakout_time*60*10), target = src)) //minutes * 60seconds * 10deciseconds
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || (!locked && !welded && !istype(loc, /obj/mecha)) )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting

		welded = 0 //applies to all lockers lockers
		locked = 0 //applies to critter crates and secure lockers only
		broken = 1 //applies to secure lockers only
		user.visible_message("<span class='danger'>[user] successfully broke out of [src]!</span>", "<span class='notice'>You successfully break out of [src]!</span>")
		if(istype( loc, /obj/structure/bigDelivery))
			var/obj/structure/bigDelivery/D = loc
			qdel(D)
		else if(istype( loc, /obj/mecha))
			loc = get_turf(loc)
		open()
	else
		user << "<span class='warning'>You fail to break out of [src]!</span>"

/obj/structure/closet/AltClick(var/mob/user)
	..()
	if(!user.canUseTopic(user) || broken)
		user << "<span class='warning'>You can't do that right now!</span>"
		return
	if(opened || !secure || !in_range(src, user))
		return
	else
		togglelock(user)

/obj/structure/closet/emp_act(severity)
	for(var/obj/O in src)
		O.emp_act(severity)
	if(secure && !broken)
		if(prob(50/severity))
			locked = !locked
			update_icon()
		if(prob(20/severity) && !opened)
			if(!locked)
				open()
			else
				req_access = list()
				req_access += pick(get_all_accesses())
	..()

/obj/structure/closet/proc/togglelock(mob/user as mob)
	if(secure)
		if(allowed(user))
			locked = !locked
			add_fingerprint(user)
			for(var/mob/O in viewers(user, 3))
				if((O.client && !( O.eye_blind )))
					O << "<span class='notice'>[user] has [locked ? null : "un"]locked the locker.</span>"
			update_icon()
		else
			user << "<span class='notice'>Access Denied</span>"
	else
		return

/obj/structure/closet/emag_act(mob/user as mob)
	if(secure && !broken)
		broken = 1
		locked = 0
		desc += " It appears to be broken."
		update_icon()
		for(var/mob/O in viewers(user, 3))
			O.show_message("<span class='warning'>The locker has been broken by [user] with an electromagnetic card!</span>", 1, "You hear a faint electrical spark.", 2)
		overlays += "sparking"
		playsound(src.loc, "sparks", 60, 1)
		spawn(6) //overlays don't support flick so we have to cheat
		update_icon()
		add_fingerprint(user)

/obj/structure/closet/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	for (var/atom/A in src)
		if(istype(A,/obj/))
			var/obj/O = A
			O.hear_talk(M, text, verb, speaking)

/obj/structure/closet/attack_generic(var/mob/user, var/damage, var/attack_message = "destroys", var/wallbreaker)
	if(!damage || !wallbreaker)
		return
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	dump_contents()
	spawn(1) qdel(src)
	return 1
