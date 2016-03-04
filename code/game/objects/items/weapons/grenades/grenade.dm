/obj/item/weapon/grenade
	name = "grenade"
	desc = "A hand held grenade, with an adjustable timer."
	w_class = 2.0
	icon = 'icons/obj/grenade.dmi'
	icon_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT
	burn_state = 0 //Burnable
	burntime = 5
	var/active = 0
	var/det_time = 50
	var/display_timer = 1

/obj/item/weapon/grenade/burn()
	prime()
	..()

/obj/item/weapon/grenade/proc/clown_check(var/mob/living/carbon/human/user)
	if(user.disabilities & CLUMSY && prob(50))
		user << "<span class='warning'>Huh? How does this thing work?</span>"
		active = 1
		icon_state = initial(icon_state) + "_active"
		playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
		spawn(5)
			if(user)
				user.drop_item()
			prime()
		return 0
	return 1

/obj/item/weapon/grenade/examine(mob/user)
	..()
	if(display_timer)
		if(det_time > 1)
			user << "The timer is set to [det_time/10] seconds."
		else
			user << "\The [src] is set for instant detonation."

/obj/item/weapon/grenade/attack_self(mob/user as mob)
	if(!active)
		if(clown_check(user))
			user << "<span class='warning'>You prime the [name]! [det_time/10] seconds!</span>"
			playsound(user.loc, 'sound/weapons/armbomb.ogg', 60, 1)
			active = 1
			icon_state = initial(icon_state) + "_active"
			add_fingerprint(user)
			var/turf/bombturf = get_turf(src)
			var/area/A = get_area(bombturf)
			message_admins("[key_name(usr)]<A HREF='?_src_=holder;adminmoreinfo=\ref[usr]'>?</A> has primed a [name] for detonation at <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[bombturf.x];Y=[bombturf.y];Z=[bombturf.z]'>[A.name] (JMP)</a>.")
			log_game("[key_name(usr)] has primed a [name] for detonation at [A.name] ([bombturf.x],[bombturf.y],[bombturf.z]).")
			update_icon()
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.throw_mode_on()
			spawn(det_time)
				prime()
/*
/obj/item/weapon/grenade/proc/activate(mob/user as mob)
	if(active)
		return

	if(user)
		msg_admin_attack("[user.name] ([user.ckey]) primed \a [src] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")
	active = 1
	update_icon(active)
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)

	spawn(det_time)
		prime()*/


/obj/item/weapon/grenade/proc/prime()

/obj/item/weapon/grenade/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(isscrewdriver(W))
		switch(det_time)
			if ("1")
				det_time = 10
				user << "<span class='notice'>You set the [name] for 1 second detonation time.</span>"
			if ("10")
				det_time = 30
				user << "<span class='notice'>You set the [name] for 3 second detonation time.</span>"
			if ("30")
				det_time = 50
				user << "<span class='notice'>You set the [name] for 5 second detonation time.</span>"
			if ("50")
				det_time = 1
				user << "<span class='notice'>You set the [name] for instant detonation.</span>"
		add_fingerprint(user)
	..()


/obj/item/weapon/grenade/attack_hand()
	walk(src, null, null)
	..()

/obj/item/weapon/grenade/proc/update_mob()
	if(ismob(loc))
		var/mob/M = loc
		M.unEquip(src)

/obj/item/weapon/grenade/update_icon()
	if(active)
		icon_state = initial(icon_state) + "_active"
		item_state = initial(item_state) + "_active"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	if(ismob(loc))
		var/mob/living/carbon/C = loc
		C.update_inv_l_hand()
		C.update_inv_r_hand()