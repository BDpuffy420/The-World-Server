/obj/structure/closet/secure_closet/personal
	name = "personal closet"
	desc = "It's a secure locker for personnel. The first card swiped gains control."
	req_access = list(access_all_personal_lockers)
	var/registered_name = null

/obj/structure/closet/secure_closet/personal/New()
	..()
	spawn(2)
		if(prob(50))
			new /obj/item/weapon/storage/backpack(src)
		else
			new /obj/item/weapon/storage/backpack/satchel_norm(src)
		new /obj/item/device/radio/headset( src )
	return


/obj/structure/closet/secure_closet/personal/patient
	name = "patient's closet"

/obj/structure/closet/secure_closet/personal/patient/New()
	..()
	spawn(4)
		// Not really the best way to do this, but it's better than "contents = list()"!
		for(var/atom/movable/AM in contents)
			qdel(AM)
		new /obj/item/clothing/under/color/white( src )
		new /obj/item/clothing/shoes/white( src )
	return

/obj/structure/closet/secure_closet/personal/cabinet
	icon_state = "cabinet"
	burn_state = 0 //Burnable
	burntime = 20

/obj/structure/closet/secure_closet/personal/cabinet/New()
	..()
	spawn(4)
		// Not really the best way to do this, but it's better than "contents = list()"!
		for(var/atom/movable/AM in contents)
			qdel(AM)
		new /obj/item/weapon/storage/backpack/satchel/withwallet( src )
		new /obj/item/device/radio/headset( src )
	return

/obj/structure/closet/secure_closet/personal/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W))
		var/obj/item/weapon/card/id/I = W.GetID()
		if(istype(I))
			if(src.broken)
				user << "<span class='danger'>It appears to be broken.</span>"
				return
			if(!I || !I.registered_name)	return
			if(src.allowed(user) || !src.registered_name || (istype(I) && (src.registered_name == I.registered_name)))
				//they can open all lockers, or nobody owns this, or they own this locker
				src.locked = !( src.locked )
				update_icon()

				if(!src.registered_name)
					src.registered_name = I.registered_name
					src.desc = "Owned by [I.registered_name]."
			else
				user << "<span class='danger'>Access Denied.</span>"
		else if( (istype(W, /obj/item/weapon/melee/energy/blade)) && !src.broken)
			broken = 1
			locked = 0
			desc = "It appears to be broken."
			//icon_state = src.icon_broken
			if(istype(W, /obj/item/weapon/melee/energy/blade))
				var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
				spark_system.set_up(5, 0, src.loc)
				spark_system.start()
				playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
				playsound(src.loc, "sparks", 50, 1)
				for(var/mob/O in viewers(user, 3))
					O.show_message("\blue The locker has been sliced open by [user] with an energy blade!", 1, "\red You hear metal being sliced and sparks flying.", 2)
		else
			..()
	else
		..()
	return

/obj/structure/closet/secure_closet/personal/verb/reset()
	set src in oview(1) // One square distance
	set category = "Object"
	set name = "Reset Lock"
	if(!usr.canmove || usr.stat || usr.restrained()) // Don't use it if you're not able to! Checks for stuns, ghost and restrain
		return
	if(ishuman(usr))
		add_fingerprint(usr)
		if (locked || !registered_name)
			usr << "\red You need to unlock it first."
		else if (broken)
			usr << "\red It appears to be broken."
		else
			if (opened)
				if(!close())
					return
			locked = 1
			update_icon()
			registered_name = null
			desc = "It's a secure locker for personnel. The first card swiped gains control."
	return
