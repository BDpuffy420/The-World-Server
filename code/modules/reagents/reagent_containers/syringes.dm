////////////////////////////////////////////////////////////////////////////////
/// Syringes.
////////////////////////////////////////////////////////////////////////////////
#define SYRINGE_DRAW 0
#define SYRINGE_INJECT 1
#define SYRINGE_BROKEN 2

/obj/item/weapon/reagent_containers/syringe
	name = "syringe"
	desc = "A syringe."
	icon = 'icons/obj/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = null //list(5,10,15)
	volume = 15
	sharp = 1
	var/mode = SYRINGE_DRAW
	var/busy = 0	// needed for delayed drawing of blood
	materials = list(MAT_METAL=10, MAT_GLASS=20)
	unacidable = 1

/obj/item/weapon/reagent_containers/syringe/New()
	..()
	if(list_reagents) //syringe starts in inject mode if its already got something inside
		mode = SYRINGE_INJECT
		update_icon()

/obj/item/weapon/reagent_containers/syringe/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_self(mob/user as mob)
	if(mode == SYRINGE_BROKEN)
		return
	mode = !mode
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/syringe/attackby(obj/item/I, mob/user, params)
	return

/obj/item/weapon/reagent_containers/syringe/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return
	if(!target.reagents) return

	if(mode == SYRINGE_BROKEN)
		user << "<span class='warning'>This syringe is broken!</span>"
		return

	if (user.a_intent == "hurt" && ismob(target))
		if((CLUMSY in user.mutations) && prob(50))
			target = user
		syringestab(target, user)
		return


	switch(mode)
		if(SYRINGE_DRAW)

			if(reagents.total_volume >= reagents.maximum_volume)
				user << "<span class='notice'>The syringe is full.</span>"
				return

			if(ismob(target))//Blood!
				if(istype(target, /mob/living/carbon/slime))
					user << "<span class='warning'>You are unable to locate any blood!</span>"
					return
				if(reagents.has_reagent("blood"))
					user << "<span class='warning'>There is already a blood sample in this syringe!</span>"
					return
				if(istype(target, /mob/living/carbon))//maybe just add a blood reagent to all mobs. Then you can suck them dry...With hundreds of syringes. Jolly good idea.
					var/amount = src.reagents.maximum_volume - src.reagents.total_volume
					var/mob/living/carbon/T = target
					if(!T.dna)
						user << "<span class='warning'>You are unable to locate any blood!</span>"
						return
					if(NOCLONE in T.mutations) //target done been eaten, no more blood in him
						user << "<span class='warning'>You are unable to locate any blood!</span>"
						return

					if(target != user)
						target.visible_message("<span class='danger'>[user] is trying to take a blood sample from [target]!</span>", \
										"<span class='userdanger'>[user] is trying to take a blood sample from [target]!</span>")
						busy = 1
						if(!do_mob(user, target))
							busy = 0
							return
					busy = 0
					var/datum/reagent/B
					B = T.take_blood(src,amount)

					if(!B && ishuman(target))
						var/mob/living/carbon/human/H = target
						if(H.species && H.species.flags & NO_BLOOD)
							target.reagents.trans_to(src, amount)
						else
							user << "<span class='warning'>You are unable to locate any blood!</span>"
							return
					if (B)
						src.reagents.reagent_list += B
						src.reagents.update_total()
						src.on_reagent_change()
						src.reagents.handle_reactions()

					user.visible_message("[user] takes a blood sample from [target].")

			else //if not mob
				if(!target.reagents.total_volume)
					user << "\red [target] is empty."
					return

				if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers) && !istype(target,/obj/item/slime_extract))
					user << "\red You cannot directly remove reagents from this object."
					return

				var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

				user << "\blue You fill the syringe with [trans] units of the solution."
			if (reagents.total_volume >= reagents.maximum_volume)
				mode=!mode
				update_icon()

		if(SYRINGE_INJECT)
			if(!reagents.total_volume)
				user << "<span class='notice'>[src] is empty.</span>"
				return
			if(istype(target, /obj/item/weapon/implantcase/chem))
				return

			if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/slime_extract) && !istype(target, /obj/item/clothing/mask/cigarette) && !istype(target, /obj/item/weapon/storage/fancy/cigarettes))
				user << "<span class='warning'>You cannot directly fill [target]!</span>"
				return
			if(target.reagents.total_volume >= target.reagents.maximum_volume)
				user << "<span class='notice'>[target] is full.</span>"
				return

			if(ismob(target) && target != user)
				var/time = 30 //Injecting through a hardsuit takes longer due to needing to find a port.
				if(istype(target,/mob/living/carbon/human))
					var/mob/living/carbon/human/H = target
					if(H.wear_suit)
						if(istype(H.wear_suit,/obj/item/clothing/suit/space))
							time = 60
						else if(!H.can_inject(user, 1))
							return
				else if(isliving(target))
					var/mob/living/M = target
					if(!M.can_inject(user, 1))
						return

				if(time == 30)
					target.visible_message("<span class='danger'>[user] is trying to inject [target]!</span>", \
											"<span class='userdanger'>[user] is trying to inject [target]!</span>")
				else
					target.visible_message("<span class='danger'>[user] begins hunting for an injection port on [target]'s suit!</span>", \
											"<span class='userdanger'>[user] begins hunting for an injection port on [target]'s suit!</span>")

				if(!do_mob(user, target, time))
					return

				//Sanity checks after sleep
				if(!reagents.total_volume)
					return
				if(target.reagents.total_volume >= target.reagents.maximum_volume)
					return

				target.visible_message("<span class='danger'>[user] injects [target] with the syringe!", \
								"<span class='userdanger'>[user] injects [target] with the syringe!")
				//Attack log entries are produced here due to failure to produce elsewhere. Remove them here if you have doubles from normal syringes.
				var/list/rinject = list()
				for(var/datum/reagent/R in src.reagents.reagent_list)
					rinject += R.name
				var/contained = english_list(rinject)
				var/mob/M = target
				add_logs(user, M, "injected", src, addition="which had [contained]")
				var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
				reagents.reaction(target, INGEST, fraction)

			if(ismob(target) && target == user)
				//Attack log entries are produced here due to failure to produce elsewhere. Remove them here if you have doubles from normal syringes.
				var/list/rinject = list()
				for(var/datum/reagent/R in src.reagents.reagent_list)
					rinject += R.name
				var/contained = english_list(rinject)
				var/mob/M = target
				log_attack("<font color='red'>[user.name] ([user.ckey]) injected [M.name] ([M.ckey]) with [src.name], which had [contained] (INTENT: [uppertext(user.a_intent)])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Injected themselves ([contained]) with [src.name].</font>")
				var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
				reagents.reaction(target, INGEST, fraction)
			spawn(5)
				var/datum/reagent/blood/B
				for(var/datum/reagent/blood/d in src.reagents.reagent_list)
					B = d
					break
				if(B && istype(target,/mob/living/carbon))
					var/mob/living/carbon/C = target
					C.inject_blood(src,5)
				else
					src.reagents.trans_to(target, amount_per_transfer_from_this)
				user << "<span class='notice'>You inject [amount_per_transfer_from_this] units of the solution. The syringe now contains [src.reagents.total_volume] units.</span>"
				if (reagents.total_volume <= 0 && mode==SYRINGE_INJECT)
					mode = SYRINGE_DRAW
					update_icon()

/obj/item/weapon/reagent_containers/syringe/update_icon()
	overlays.Cut()
	if(mode == SYRINGE_BROKEN)
		icon_state = "broken"
		return
	var/rounded_vol = min(max(round(reagents.total_volume,5),5),15)
	if(ismob(loc))
		var/injoverlay
		switch(mode)
			if (SYRINGE_DRAW)
				injoverlay = "draw"
			if (SYRINGE_INJECT)
				injoverlay = "inject"
		overlays += injoverlay
	icon_state = "[rounded_vol]"
	item_state = "syringe_[rounded_vol]"

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "syringe10")
		filling.icon_state = "syringe[rounded_vol]"
		filling.color  = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

/obj/item/weapon/reagent_containers/syringe/proc/syringestab(mob/living/carbon/target as mob, mob/living/carbon/user as mob)

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [target.name] ([target.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	target.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	if(istype(target, /mob/living/carbon/human))

		var/target_zone = ran_zone(check_zone(user.zone_sel.selecting, target))
		var/obj/item/organ/external/affecting = target:get_organ(target_zone)

		if (!affecting)
			return
		if(affecting.status & ORGAN_DESTROYED)
			user << "What [affecting.name]?"
			return
		var/hit_area = affecting.name

		var/mob/living/carbon/human/H = target
		if((user != target) && H.check_shields(7, "the [src.name]"))
			return

		if (target != user && target.getarmor(target_zone, "melee") > 5 && prob(50))
			for(var/mob/O in viewers(world.view, user))
				O.show_message(text("\red <B>[user] tries to stab [target] in \the [hit_area] with [src.name], but the attack is deflected by armor!</B>"), 1)
			user.unEquip(src)
			qdel(src)
			return

		for(var/mob/O in viewers(world.view, user))
			O.show_message(text("\red <B>[user] stabs [target] in \the [hit_area] with [src.name]!</B>"), 1)

		if(affecting.take_damage(3))
			target:UpdateDamageIcon()

	else
		for(var/mob/O in viewers(world.view, user))
			O.show_message(text("\red <B>[user] stabs [target] with [src.name]!</B>"), 1)
		target.take_organ_damage(3)// 7 is the same as crowbar punch

	src.reagents.reaction(target, INGEST)
	var/syringestab_amount_transferred = rand(0, (reagents.total_volume - 5)) //nerfed by popular demand
	src.reagents.trans_to(target, syringestab_amount_transferred)
	src.desc += " It is broken."
	src.mode = SYRINGE_BROKEN
	src.add_blood(target)
	src.add_fingerprint(usr)
	src.update_icon()

/obj/item/weapon/reagent_containers/ld50_syringe
	name = "lethal injection syringe"
	desc = "A syringe used for lethal injections."
	icon = 'icons/obj/syringe.dmi'
	item_state = "syringe_0"
	icon_state = "0"
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = null //list(5,10,15)
	volume = 50
	var/mode = SYRINGE_DRAW

	on_reagent_change()
		update_icon()

	pickup(mob/user)
		..()
		update_icon()

	dropped(mob/user)
		..()
		update_icon()

	attack_self(mob/user as mob)
		mode = !mode
		update_icon()

	attack_hand()
		..()
		update_icon()

	attackby(obj/item/I as obj, mob/user as mob)

		return

	afterattack(obj/target, mob/user , flag)
		if(!target.reagents) return

		switch(mode)
			if(SYRINGE_DRAW)

				if(reagents.total_volume >= reagents.maximum_volume)
					user << "<span class='warning'>The syringe is full.</span>"
					return

				if(ismob(target))
					if(istype(target, /mob/living/carbon))//I Do not want it to suck 50 units out of people
						usr << "<span class='warning'>This needle isn't designed for drawing blood.</span>"
						return
				else //if not mob
					if(!target.reagents.total_volume)
						user << "<span class='warning'>red [target] is empty.</span>"
						return

					if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
						user << "<span class='warning'>red You cannot directly remove reagents from this object.</span>"
						return

					var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this) // transfer from, transfer to - who cares?

					user << "<span class='notice'>You fill the syringe with [trans] units of the solution.</span>"
				if (reagents.total_volume >= reagents.maximum_volume)
					mode=!mode
					update_icon()

			if(SYRINGE_INJECT)
				if(!reagents.total_volume)
					user << "<span class='warning'>The Syringe is empty.</span>"
					return
				if(istype(target, /obj/item/weapon/implantcase/chem))
					return
				if(!target.is_open_container() && !ismob(target) && !istype(target, /obj/item/weapon/reagent_containers/food))
					user << "<span class='warning'>You cannot directly fill this object.</span>"
					return
				if(target.reagents.total_volume >= target.reagents.maximum_volume)
					user << "<span class='warning'>[target] is full.</span>"
					return

				if(ismob(target) && target != user)
					for(var/mob/O in viewers(world.view, user))
						O.show_message(text("<span class='danger'>[] is trying to inject [] with a giant syringe!</span>", user, target), 1)
					if(!do_mob(user, target, 300)) return
					for(var/mob/O in viewers(world.view, user))
						O.show_message(text("<span class='danger'>[] injects [] with a giant syringe!</span>", user, target), 1)
					src.reagents.reaction(target, INGEST)
				if(ismob(target) && target == user)
					src.reagents.reaction(target, INGEST)
				spawn(5)
					var/trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
					user << "<span class='notice'>You inject [trans] units of the solution. The syringe now contains [src.reagents.total_volume] units.</span>"
					if (reagents.total_volume >= reagents.maximum_volume && mode==SYRINGE_INJECT)
						mode = SYRINGE_DRAW
						update_icon()
		return


	update_icon()
		var/rounded_vol = round(reagents.total_volume,50)
		if(ismob(loc))
			var/mode_t
			switch(mode)
				if (SYRINGE_DRAW)
					mode_t = "d"
				if (SYRINGE_INJECT)
					mode_t = "i"
			icon_state = "[mode_t][rounded_vol]"
		else
			icon_state = "[rounded_vol]"
		item_state = "syringe_[rounded_vol]"


////////////////////////////////////////////////////////////////////////////////
/// Syringes. END
////////////////////////////////////////////////////////////////////////////////



/obj/item/weapon/reagent_containers/syringe/inaprovaline
	name = "Syringe (inaprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	list_reagents = list("inaprovaline" = 15)

/obj/item/weapon/reagent_containers/syringe/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	list_reagents = list("antitoxin" = 15)

/obj/item/weapon/reagent_containers/syringe/antiviral
	name = "Syringe (spaceacillin)"
	desc = "Contains antiviral agents."
	list_reagents = list("spaceacillin" = 15)

/obj/item/weapon/reagent_containers/syringe/drugs
	name = "Syringe (drugs)"
	desc = "Contains aggressive drugs meant for torture."
	list_reagents = list("space_drugs" = 5, "mindbreaker" = 5, "cryptobiolin" = 5)

/obj/item/weapon/reagent_containers/ld50_syringe/choral
	list_reagents = list("chloralhydrate" = 50)
	New()
		..()
		mode = SYRINGE_INJECT
		update_icon()

//Robot syringes
//Not special in any way, code wise. They don't have added variables or procs.
/obj/item/weapon/reagent_containers/syringe/robot/antitoxin
	name = "Syringe (anti-toxin)"
	desc = "Contains anti-toxins."
	list_reagents = list("antitoxin" = 15)

/obj/item/weapon/reagent_containers/syringe/robot/inoprovaline
	name = "Syringe (inoprovaline)"
	desc = "Contains inaprovaline - used to stabilize patients."
	list_reagents = list("inaprovaline" = 15)

/obj/item/weapon/reagent_containers/syringe/robot/mixed
	name = "Syringe (mixed)"
	desc = "Contains inaprovaline & anti-toxins."
	list_reagents = list("inaprovaline" = 7, "antitoxin" = 8)