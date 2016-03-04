/* Beds... get your mind out of the gutter, they're for sleeping!
 * Contains:
 * 		Beds
 *		Roller beds
 */

/*
 * Beds
 */
/obj/structure/stool/bed
	name = "bed"
	desc = "This is used to lie in, sleep in or strap on."
	icon_state = "bed"
	can_buckle = 1
	buckle_lying = 1
	burn_state = 0 //Burnable
	burntime = 30

/obj/structure/stool/bed/alien
	name = "resting contraption"
	desc = "This looks similar to contraptions from earth. Could aliens be stealing our technology?"
	icon_state = "abed"

/obj/structure/stool/bed/Move(atom/newloc, direct) //Some bed children move
	. = ..()
	if(buckled_mob)
		buckled_mob.buckled = null
		if(!buckled_mob.Move(loc, direct))
			loc = buckled_mob.loc //we gotta go back
			last_move = buckled_mob.last_move
			inertia_dir = last_move
			buckled_mob.inertia_dir = last_move
			. = 0
		buckled_mob.buckled = src
/*
/obj/structure/stool/bed/Process_Spacemove(movement_dir = 0)
	if(buckled_mob)
		return buckled_mob.Process_Spacemove(movement_dir)
	return ..() #TOREMOVE */

/obj/structure/stool/bed/CanPass(atom/movable/mover, turf/target, height=1.5)
	if(mover == buckled_mob)
		return 1
	return ..()

/obj/structure/stool/bed/psych
	name = "psychiatrist's couch"
	desc = "For prime comfort during psychiatric evaluations."
	icon_state = "psychbed"

/*
 * Roller beds
 */
/obj/structure/stool/bed/roller
	name = "roller bed"
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "down"
	anchored = 0
	burn_state = -1 //Not Burnable

/obj/structure/stool/bed/roller/post_buckle_mob(mob/living/M as mob)
	if(M == buckled_mob)
		M.pixel_y = 6
		M.old_y = 6
		density = 1
		icon_state = "up"
	else
		M.pixel_y = 0
		M.old_y = 0
		density = 0
		icon_state = "down"

	return ..()


/obj/item/roller
	name = "roller bed"
	desc = "A collapsed roller bed that can be carried around."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	w_class = 4.0 // Can't be put in backpacks.


/obj/item/roller/attack_self(mob/user)
	var/obj/structure/stool/bed/roller/R = new /obj/structure/stool/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(src)


/obj/item/roller/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W,/obj/item/roller_holder))
		var/obj/item/roller_holder/RH = W
		if(!RH.held)
			user << "\blue You collect the roller bed."
			src.loc = RH
			RH.held = src
			return

	..()

/obj/structure/stool/bed/roller/MouseDrop(over_object, src_location, over_location)
	..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		if(buckled_mob)
			return 0
		usr.visible_message("[usr] collapses \the [src.name].", "<span class='notice'>You collapse \the [src.name].</span>")
		new/obj/item/roller(get_turf(src))
		qdel(src)
		return

/obj/item/roller_holder
	name = "roller bed rack"
	desc = "A rack for carrying a collapsed roller bed."
	icon = 'icons/obj/rollerbed.dmi'
	icon_state = "folded"
	var/obj/item/roller/held

/obj/item/roller_holder/New()
	..()
	held = new /obj/item/roller(src)

/obj/item/roller_holder/attack_self(mob/user as mob)

	if(!held)
		user << "\blue The rack is empty."
		return

	user << "\blue You deploy the roller bed."
	var/obj/structure/stool/bed/roller/R = new /obj/structure/stool/bed/roller(user.loc)
	R.add_fingerprint(user)
	qdel(held)
	held = null

/obj/structure/stool/bed/dogbed
	name = "dog bed"
	icon_state = "dogbed"
	desc = "A comfy-looking dog bed. You can even strap your pet in, in case the gravity turns off."
	anchored = 0

/obj/structure/stool/bed/dogbed/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/wood(loc, 10)
		qdel(src)

/obj/structure/stool/bed/dogbed/post_buckle_mob(mob/living/M)
	if(M == buckled_mob)
		M.pixel_y = 5
		M.old_y = 5
		M.dir = pick(4,8)
		density = 1
	else
		M.pixel_y = 0
		M.old_y = 0
		density = 0