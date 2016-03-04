/obj/item/weapon/handcuffs
	name = "handcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	w_class = 2.0
	throw_speed = 2
	throw_range = 5
	materials = list(MAT_METAL=500)
	origin_tech = "materials=1"
	var/dispenser = 0
	var/breakouttime = 600 //Deciseconds = 60s = 1 minute
	var/cuff_sound = 'sound/weapons/handcuffs.ogg'
	var/trashtype = null //for disposable cuffs

/obj/item/weapon/handcuffs/attack(mob/living/carbon/C as mob, mob/user as mob)
	if (!istype(user, /mob/living/carbon/human))
		user << "\red You don't have the dexterity to do this!"
		return
	//makes sure the mob actually has hands
	if (ishuman(C))
		var/mob/living/carbon/human/H = C
		if (!H.has_organ_for_slot(slot_handcuffed))
			user << "\red \The [H] needs at least two wrists before you can cuff them together!"
			return
		//can't cuff someone who's in a deployed hardsuit.
		if(istype(H.gloves,/obj/item/clothing/gloves/rig))
			user << "<span class='danger'>The cuffs won't fit around \the [H.gloves]!</span>"
			return

	if ((CLUMSY in usr.mutations) && prob(50))
		user << "\red Uh ... how do those things work?!"
		apply_cuffs(user, user)
		return

	if(!C.handcuffed)
		if (C == user)
			var/confirm = alert("Are you sure you want to handcuff yourself?", "Confirm", "Yes", "No")
			switch(confirm)
				if("Yes") apply_cuffs(user, user)
				if("No") return
			return

		//check for an aggressive grab
		for (var/obj/item/weapon/grab/G in C.grabbed_by)
			if (G.loc == user && G.state >= GRAB_AGGRESSIVE)
				apply_cuffs(C, user)
				if(istype(src, /obj/item/weapon/handcuffs/cable))
					feedback_add_details("handcuffs","C")
				else
					feedback_add_details("handcuffs","H")

				add_logs(user, C, "handcuffed")
				return
		user << "\red You need to have a firm grip on [C] before you can put \the [src] on!"

/obj/item/weapon/handcuffs/proc/apply_cuffs(var/mob/living/carbon/target, var/mob/user)
	playsound(src.loc, cuff_sound, 30, 1, -2)

	if(!target.handcuffed)
		if(!user.drop_item())
			return
		if(target == user)
			target.visible_message("<span class='danger'>[user] binds their own wrists together with [src.name]!</span>")
		else
			target.visible_message("<span class='danger'>[user] binds [target]'s wrists together with [src.name]!</span>", \
													"<span class='userdanger'>[user] binds [target]'s wrists together with [src.name]!</span>")

		msg_admin_attack("[key_name(user)] handcuffed [key_name(target)]")

		if(trashtype)
			target.handcuffed = new trashtype(target)
			qdel(src)
		else
			loc = target
			target.handcuffed = src
		target.update_inv_handcuffed()
		return

	if (ismonkey(target)) //#TOREMOVE
		var/mob/living/carbon/monkey/M = target
		var/obj/effect/equip_e/monkey/O = new /obj/effect/equip_e/monkey(  )
		O.source = user
		O.target = M
		O.item = user.get_active_hand()
		O.s_loc = user.loc
		O.t_loc = M.loc
		O.place = "handcuff"
		M.requests += O
		spawn( 0 )
			O.process()
		return

var/last_chew = 0
/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	if (A != src) return ..()
	if (last_chew + 26 > world.time) return

	var/mob/living/carbon/human/H = A
	if (!H.handcuffed) return
	if (H.a_intent != "hurt") return
	if (H.zone_sel.selecting != "mouth") return
	if (H.wear_mask) return
	if (istype(H.wear_suit, /obj/item/clothing/suit/straight_jacket)) return

	var/obj/item/organ/external/O = H.organs_by_name[H.hand?"l_hand":"r_hand"]
	if (!O) return

	var/s = "\red [H.name] chews on \his [O.name]!"
	H.visible_message(s, "\red You chew on your [O.name]!")
	H.attack_log += text("\[[time_stamp()]\] <font color='red'>[s] ([H.ckey])</font>")
	log_attack("[s] ([H.ckey])")

	if(O.take_damage(3,0,1,1,"teeth marks"))
		H:UpdateDamageIcon()

	last_chew = world.time

/obj/item/weapon/handcuffs/cable
	name = "cable restraints"
	desc = "Looks like some cables tied together. Could be used to tie something up."
	icon_state = "cuff_white"
	breakouttime = 300 //Deciseconds = 30s
	cuff_sound = 'sound/weapons/cablecuff.ogg'

/obj/item/weapon/handcuffs/cable/red
	color = "#DD0000"

/obj/item/weapon/handcuffs/cable/yellow
	color = "#DDDD00"

/obj/item/weapon/handcuffs/cable/blue
	color = "#0000DD"

/obj/item/weapon/handcuffs/cable/green
	color = "#00DD00"

/obj/item/weapon/handcuffs/cable/pink
	color = "#DD00DD"

/obj/item/weapon/handcuffs/cable/orange
	color = "#DD8800"

/obj/item/weapon/handcuffs/cable/cyan
	color = "#00DDDD"

/obj/item/weapon/handcuffs/cable/white
	color = "#FFFFFF"

/obj/item/weapon/handcuffs/cable/attackby(var/obj/item/I, mob/user as mob)
	..()
	if(istype(I, /obj/item/stack/rods))
		var/obj/item/stack/rods/R = I
		if (R.use(1))
			var/obj/item/weapon/wirerod/W = new /obj/item/weapon/wirerod

			user.put_in_hands(W)
			user << "<span class='notice'>You wrap the cable restraint around the top of the rod.</span>"
			qdel(src)
			update_icon(user)


/obj/item/weapon/handcuffs/cyborg
	dispenser = 1

/obj/item/weapon/handcuffs/cyborg/attack(mob/living/carbon/C as mob, mob/user as mob)
	if(isrobot(user))
		if(!C.handcuffed)

			if (ishuman(C))
				var/mob/living/carbon/human/H = C
				if (!H.has_organ_for_slot(slot_handcuffed))
					user << "\red \The [H] needs at least two wrists before you can cuff them together!"
					return

			playsound(loc, 'sound/weapons/cablecuff.ogg', 30, 1, -2)
			C.visible_message("<span class='danger'>[user] is trying to put zipties on [C]!</span>", \
								"<span class='userdanger'>[user] is trying to put zipties on [C]!</span>")

			if(do_mob(user, C, 30))
				if(!C.handcuffed)
					C.handcuffed = new /obj/item/weapon/handcuffs(C)
					C.update_inv_handcuffed(0)
					user << "<span class='notice'>You handcuff [C].</span>"
					add_logs(user, C, "handcuffed")
			else
				user << "<span class='warning'>You fail to handcuff [C]!</span>"


/obj/item/weapon/handcuffs/cable/zipties
	name = "zipties"
	desc = "Plastic, disposable zipties that can be used to restrain temporarily but are destroyed after use."
	icon_state = "cuff_white"
	breakouttime = 450 //Deciseconds = 45s
	trashtype = /obj/item/weapon/handcuffs/cable/zipties/used

/obj/item/weapon/handcuffs/cable/zipties/used
	desc = "A pair of broken zipties."
	icon_state = "cuff_white_used"

/obj/item/weapon/handcuffs/cable/zipties/used/attack()
	return

/obj/item/weapon/legcuffs
	name = "legcuffs"
	desc = "Use this to keep prisoners in line."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "handcuff"
	flags = CONDUCT
	throwforce = 0
	w_class = 3.0
	origin_tech = "materials=1"
	var/breakouttime = 300	//Deciseconds = 30s = 0.5 minute

/obj/item/weapon/legcuffs/beartrap
	name = "bear trap"
	throw_speed = 2
	throw_range = 1
	icon_state = "beartrap0"
	desc = "A trap used to catch bears and other legged creatures."
	breakouttime = 300 //Deciseconds = 30s
	var/obj/item/organ/external/affecting
	var/armed = 0
	var/trap_damage = 10


/obj/item/weapon/legcuffs/beartrap/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] is sticking \his head in the [src.name]! It looks like \he's trying to commit suicide.</span>")
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return (BRUTELOSS)

/obj/item/weapon/legcuffs/beartrap/attack_self(mob/user as mob)
	..()
	if(ishuman(user) && !user.stat && !user.restrained())
		armed = !armed
		icon_state = "beartrap[armed]"
		user << "<span class='notice'>[src] is now [armed ? "armed" : "disarmed"]</span>"

/obj/item/weapon/legcuffs/beartrap/Crossed(AM as mob|obj)
	if(armed && isturf(src.loc))
		if(isliving(AM))
			var/mob/living/L = AM
			var/snap = 0
			var/def_zone = "chest"

			if(iscarbon(AM))
				var/mob/living/carbon/C = L
				snap = 1
				if(!C.lying)
					def_zone = pick("l_leg", "r_leg")
					if(!C.legcuffed) //beartrap can't cuff your leg if there's already a beartrap or legcuffs.
						C.legcuffed = src
						src.loc = C
						C.update_inv_legcuffed()
						feedback_add_details("handcuffs","B") //Yes, I know they're legcuffs. Don't change this, no need for an extra variable. The "B" is used to tell them apart.

			else if(isanimal(AM))
				var/mob/living/simple_animal/SA = L
				if(!SA.flying && SA.mob_size > MOB_SIZE_TINY)
					snap = 1

			if(snap)
				armed = 0
				icon_state = "beartrap[armed]"
				playsound(src.loc, 'sound/effects/snap.ogg', 50, 1)
				L.visible_message("<span class='danger'>[L] triggers \the [src].</span>", \
						"<span class='userdanger'>You trigger \the [src]!</span>")

				if(ishuman(L))
					var/mob/living/carbon/human/H = L
					var/obj/item/organ/external/affecting = H.get_organ(pick("l_foot", "r_foot"))
					if(affecting.status & ORGAN_ROBOT)
						return
					if(affecting.take_damage(trap_damage, 0))
						H.UpdateDamageIcon()
					H.updatehealth()
					if(!(H.species && (H.species.flags & NO_PAIN)))
						H.Weaken(3)
				else
					L.apply_damage(trap_damage,BRUTE, def_zone)
	..()

/obj/item/weapon/legcuffs/beartrap/energy
	name = "energy snare"
	armed = 0
	icon_state = "e_snare0"
	trap_damage = 0

/obj/item/weapon/legcuffs/beartrap/energy/New()
	..()
	spawn(100)
		if(!istype(loc, /mob))
			var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread
			sparks.set_up(1, 1, src)
			sparks.start()
			qdel(src)

/obj/item/weapon/legcuffs/beartrap/energy/dropped()
	..()
	qdel(src)

/obj/item/weapon/legcuffs/beartrap/energy/attack_hand(mob/user)
	Crossed(user) //honk