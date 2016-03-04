/obj/structure/closet/secure_closet/guncabinet
	name = "gun cabinet"
	req_access = list(access_armory)
	icon = 'icons/obj/guncabinet.dmi'
	icon_state = "base"
	var/icon_off ="base"
	var/icon_broken ="base"
	var/icon_locked ="base"
	icon_closed ="base"
	icon_opened = "base"

/obj/structure/closet/secure_closet/guncabinet/New()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/toggle()
	..()
	update_icon()

/obj/structure/closet/secure_closet/guncabinet/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(src.opened)
		if(istype(W, /obj/item/weapon/grab))
			var/obj/item/weapon/grab/G = W
			if(src.large)
				src.MouseDrop_T(G.affecting, user)	//act like they were dragged onto the closet
			else
				user << "<span class='notice'>The locker is too small to stuff [G.affecting] into!</span>"
		if(isrobot(user))
			return
		if(W.loc != user) // This should stop mounted modules ending up outside the module.
			return
		user.drop_item()
		if(W)
			W.loc = src.loc
	else if((istype(W, /obj/item/weapon/melee/energy/blade)) && !src.broken)
		broken = 1
		locked = 0
		desc = "It appears to be broken."
		icon_state = icon_off
		flick(icon_broken, src)
		if(istype(W, /obj/item/weapon/melee/energy/blade))
			var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, "sparks", 50, 1)
			for(var/mob/O in viewers(user, 3))
				O.show_message("<span class='warning'>The locker has been sliced open by [user] with an energy blade!</span>", 1, "You hear metal being sliced and sparks flying.", 2)
	else if(istype(W,/obj/item/weapon/packageWrap) || istype(W,/obj/item/weapon/weldingtool))
		return ..(W,user)
	else
		togglelock(user)

/obj/structure/closet/secure_closet/guncabinet/emag_act(mob/user as mob)
	if(!broken)
		broken = 1
		locked = 0
		desc += " It appears to be broken."
		update_icon()
		for(var/mob/O in viewers(user, 3))
			O.show_message("<span class='warning'>The locker has been broken by [user] with an electromagnetic card!</span>", 1, "You hear a faint electrical spark.", 2)
		overlays += "broken"
		spawn(4) //overlays don't support flick so we have to cheat
		update_icon()

/obj/structure/closet/secure_closet/guncabinet/update_icon()
	overlays.Cut()
	if(opened)
		overlays += icon(icon,"door_open")
	else
		var/lazors = 0
		var/shottas = 0
		for (var/obj/item/weapon/gun/G in contents)
			if (istype(G, /obj/item/weapon/gun/energy))
				lazors++
			if (istype(G, /obj/item/weapon/gun/projectile/))
				shottas++
		if (lazors || shottas)
			for (var/i = 0 to 2)
				var/image/gun = image(icon(src.icon))

				if (lazors > 0 && (shottas <= 0 || prob(50)))
					lazors--
					gun.icon_state = "laser"
				else if (shottas > 0)
					shottas--
					gun.icon_state = "projectile"

				gun.pixel_x = i*4
				overlays += gun

		overlays += icon(src.icon,"door")

		if(broken)
			overlays += icon(src.icon,"off")
		else if (locked)
			overlays += icon(src.icon,"locked")
		else
			overlays += icon(src.icon,"open")
