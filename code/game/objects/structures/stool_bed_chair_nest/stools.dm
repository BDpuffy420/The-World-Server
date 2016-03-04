/obj/structure/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	anchored = 1.0
	pressure_resistance = 15
	burn_state = 0 //Burnable

/obj/structure/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
	return

/obj/structure/stool/blob_act()
	if(prob(75))
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)

/obj/structure/stool/burn()
	..()
	new /obj/item/stack/rods(src.loc)

/obj/structure/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/metal(src.loc)
		qdel(src)
	return

/obj/structure/stool/MouseDrop(atom/over_object)
	if (istype(over_object, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = over_object
		if (H==usr && !H.restrained() && !H.stat && in_range(src, over_object))
			var/obj/item/weapon/stool/S = new/obj/item/weapon/stool()
			S.origin = src
			src.loc = S
			H.put_in_hands(S)
			H.visible_message("<span class='danger'>[H] grabs [src] from the floor!</span>",
								"<span class='userdanger'> You grab [src] from the floor!</span>")

/obj/structure/stool/bar
	name = "bar stool"
	icon_state = "barstool"
	can_buckle = 1
	mouse_opacity = 2

/obj/structure/stool/bar/post_buckle_mob(mob/living/M)
	if(M == buckled_mob)
		M.pixel_y = 5
		M.old_y = 5
		density = 1
		if(M.dir == 1) M.layer = OBJ_LAYER - 0.1
	else
		M.pixel_y = 0
		M.old_y = 0
		density = 0
		if(M.dir == 1) M.layer = initial(M.layer)

/obj/item/weapon/stool
	name = "stool"
	desc = "Uh-hoh, bar is heating up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 10
	throwforce = 10
	w_class = 5.0
	var/obj/structure/stool/origin = null

/obj/item/weapon/stool/dropped()
	..()
	origin.loc = get_turf(src)
	origin.dir = usr.dir
	qdel(src)

/obj/item/weapon/stool/throw_impact(atom/hit_atom)
	..()
	origin.loc = get_turf(src)
	origin.dir = usr.dir
	qdel(src)

/obj/item/weapon/stool/attack_self(mob/user as mob)
	..()
	origin.loc = get_turf(src)
	origin.dir = user.dir
	user.unEquip(src)
	user.visible_message("<span class='notice'>[user] puts [src] down.", "\blue You put [src] down.</span>")
	qdel(src)

/obj/item/weapon/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("<span class='danger'>[user] breaks [src] over [M]'s back!.</span>")
		user.unEquip(src)
		var/obj/item/stack/sheet/metal/m = new/obj/item/stack/sheet/metal
		m.loc = get_turf(src)
		qdel(src)
		var/mob/living/T = M
		T.Weaken(5)
		return
	..()
