/obj/structure/stool/bed/chair	//YES, chairs are a type of bed, which are a type of stool. This works, believe me.	-Pete
	name = "chair"
	desc = "You sit in this. Either by will or force."
	icon_state = "chair"
	buckle_lying = 0 //you sit in a chair, not lay
	burn_state = -1 //Not Burnable
	var/propelled = 0 // Check for fire-extinguisher-driven chairs

/obj/structure/stool/bed/chair/New()
	..()
	spawn(3)	//sorry. i don't think there's a better way to do this.
		handle_layer()
	return

/obj/structure/stool/bed/chair/Move(atom/newloc, direct)
	..()
	handle_rotation()

/obj/structure/stool/bed/chair/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(istype(W, /obj/item/assembly/shock_kit))
		if(!user.drop_item())
			return
		var/obj/item/assembly/shock_kit/SK = W
		var/obj/structure/stool/bed/chair/e_chair/E = new /obj/structure/stool/bed/chair/e_chair(src.loc)
		playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
		E.dir = dir
		E.part = SK
		SK.loc = E
		SK.master = E
		qdel(src)
/obj/structure/stool/bed/chair/attack_tk(mob/user)
	if(buckled_mob)
		..()
	else
		rotate()
	return

/obj/structure/stool/bed/chair/proc/handle_rotation(direction)
	if(buckled_mob)
		buckled_mob.buckled = null //Temporary, so Move() succeeds.
		if(!direction || !buckled_mob.Move(get_step(src, direction), direction))
			buckled_mob.buckled = src
			dir = buckled_mob.dir
			return 0
		buckled_mob.buckled = src //Restoring
	handle_layer()
	return 1

/obj/structure/stool/bed/chair/proc/handle_layer()
	if(dir == NORTH)
		src.layer = FLY_LAYER
	else
		src.layer = OBJ_LAYER

/obj/structure/stool/bed/chair/proc/spin()
	src.dir = turn(src.dir, 90)
	handle_layer()
	if(buckled_mob)
		buckled_mob.dir = dir

/obj/structure/stool/bed/chair/verb/rotate()
	set name = "Rotate Chair"
	set category = "Object"
	set src in oview(1)

	if(config.ghost_interaction)
		spin()
	else
		if(!usr || !isturf(usr.loc))
			return
		if(usr.stat || usr.restrained())
			return
		spin()

// Chair types
/obj/structure/stool/bed/chair/wood
	burn_state = 0 //Burnable
	burntime = 20

/obj/structure/stool/bed/chair/wood/normal
	icon_state = "wooden_chair"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/wings
	icon_state = "wooden_chair_wings"
	name = "wooden chair"
	desc = "Old is never too old to not be in fashion."

/obj/structure/stool/bed/chair/wood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		new /obj/item/stack/sheet/wood(src.loc)
		qdel(src)
	else
		..()

/obj/structure/stool/bed/chair/comfy
	name = "comfy chair"
	desc = "It looks comfy."
	icon_state = "comfychair"
	color = rgb(255,255,255)
	burn_state = 0 //Burnable
	burntime = 30
	var/image/armrest = null

/obj/structure/stool/bed/chair/comfy/New()
	armrest = image("icons/obj/objects.dmi", "comfychair_armrest")
	armrest.layer = MOB_LAYER + 0.1

	return ..()

/obj/structure/stool/bed/chair/comfy/post_buckle_mob()
	if(buckled_mob)
		overlays += armrest
	else
		overlays -= armrest

/obj/structure/stool/bed/chair/comfy/brown
	color = rgb(255,113,0)

/obj/structure/stool/bed/chair/comfy/beige
	color = rgb(255,253,195)

/obj/structure/stool/bed/chair/comfy/teal
	color = rgb(0,255,255)

/obj/structure/stool/bed/chair/office
	anchored = 0
	buckle_movable = 1

/obj/structure/stool/bed/chair/comfy/black
	color = rgb(167,164,153)

/obj/structure/stool/bed/chair/comfy/lime
	color = rgb(255,251,0)

/obj/structure/stool/bed/chair/comfy/red
	color = rgb(247,77,94)

/obj/structure/stool/bed/chair/office/Bump(atom/A)
	..()
	if(!buckled_mob)	return

	if(propelled)
		var/mob/living/occupant = unbuckle_mob()

		var/def_zone = ran_zone()
		var/blocked = occupant.run_armor_check(def_zone, "melee")
		occupant.throw_at(A, 3, propelled)
		occupant.apply_effect(6, STUN, blocked)
		occupant.apply_effect(6, WEAKEN, blocked)
		occupant.apply_effect(6, STUTTER, blocked)
		occupant.apply_damage(10, BRUTE, def_zone, blocked)
		playsound(src.loc, 'sound/weapons/punch1.ogg', 50, 1, -1)
		if(istype(A, /mob/living))
			var/mob/living/victim = A
			def_zone = ran_zone()
			blocked = victim.run_armor_check(def_zone, "melee")
			victim.apply_effect(6, STUN, blocked)
			victim.apply_effect(6, WEAKEN, blocked)
			victim.apply_effect(6, STUTTER, blocked)
			victim.apply_damage(10, BRUTE, def_zone, blocked)
		occupant.visible_message("<span class='danger'>[occupant] crashed into \the [A]!</span>")

/obj/structure/stool/bed/chair/office/light
	icon_state = "officechair_white"

/obj/structure/stool/bed/chair/office/dark
	icon_state = "officechair_dark"

/obj/structure/stool/bed/chair/barber
	icon_state = "barber_chair"

/obj/structure/stool/bed/chair/sofa
	name = "old ratty sofa"
	icon_state = "sofamiddle"
	anchored = 1
	burn_state = 0 //Burnable
	burntime = 30

/obj/structure/stool/bed/chair/sofa/left
	icon_state = "sofaend_left"
/obj/structure/stool/bed/chair/sofa/right
	icon_state = "sofaend_right"
/obj/structure/stool/bed/chair/sofa/corner
	icon_state = "sofacorner"