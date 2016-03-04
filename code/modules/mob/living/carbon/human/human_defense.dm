/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act
emp_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)

	var/obj/item/organ/external/organ = get_organ(check_zone(def_zone))

	//Shields
	if(check_shields(P.damage, "the [P.name]"))
		P.on_hit(src, 2, def_zone)
		return 2

	//Laserproof armour
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/armor/laserproof))
		if(istype(P, /obj/item/projectile/energy) || istype(P, /obj/item/projectile/beam))
			var/reflectchance = 40 - round(P.damage/3)
			if(!(def_zone in list("chest", "groin")))
				reflectchance /= 2
			if(prob(reflectchance))
				visible_message("\red <B>The [P.name] gets reflected by [src]'s [wear_suit.name]!</B>")

				// Find a turf near or on the original location to bounce to
				if(P.starting)
					var/new_x = P.starting.x + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/new_y = P.starting.y + pick(0, 0, 0, 0, 0, -1, 1, -2, 2)
					var/turf/curloc = get_turf(src)

					// redirect the projectile
					P.original = locate(new_x, new_y, P.z)
					P.starting = curloc
					P.current = curloc
					P.firer = src
					P.yo = new_y - curloc.y
					P.xo = new_x - curloc.x

				return -1 // complete projectile permutation

	//Shrapnel
	if (P.damage_type == BRUTE)
		var/armor = getarmor_organ(organ, "bullet")
		if((P.embed && prob(20 + max(P.damage - armor, -10))))
			var/obj/item/weapon/shard/shrapnel/SP = new()
			(SP.name) = "[P.name] shrapnel"
			(SP.desc) = "[SP.desc] It looks like it was fired from [P.shot_from]."
			(SP.loc) = organ
			organ.embed(SP)

	return (..(P , def_zone))

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/item/organ/external/affected = get_organ(check_zone(def_zone))
	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff

	switch (def_zone)
		if("head")
			agony_amount *= 1.50
		if("l_hand", "r_hand")
			var/c_hand
			if (def_zone == "l_hand")
				c_hand = l_hand
			else
				c_hand = r_hand

			if(c_hand && (stun_amount || agony_amount > 10))
				msg_admin_attack("[src.name] ([src.ckey]) was disarmed by a stun effect")

				unEquip(c_hand)
				if (affected.status & ORGAN_ROBOT)
					emote("me", 1, "drops what they were holding, their [affected.name] malfunctioning!")
				else
					var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
					emote("me", 1, "[(species && species.flags & NO_PAIN) ? "" : emote_scream ]drops what they were holding in their [affected.name]!")

	..(stun_amount, agony_amount, def_zone)

/mob/living/carbon/human/getarmor(var/def_zone, var/type)
	var/armorval = 0
	var/total = 0

	if(def_zone)
		if(isorgan(def_zone))
			return getarmor_organ(def_zone, type)
		var/obj/item/organ/external/affecting = get_organ(def_zone)
		return getarmor_organ(affecting, type)
		//If a specific bodypart is targetted, check how that bodypart is protected and return the value.

	//If you don't specify a bodypart, it checks ALL your bodyparts for protection, and averages out the values
	for(var/organ_name in organs_by_name)
		if (organ_name in organ_rel_size)
			var/obj/item/organ/external/organ = organs_by_name[organ_name]
			var/weight = organ_rel_size[organ_name]
			armorval += getarmor_organ(organ, type) * weight
			total += weight
	return (armorval/max(total, 1))

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = species.siemens_coefficient

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		if(istype(C) && (C.body_parts_covered & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	return siemens_coefficient

//this proc returns the armour value for a particular external organ.
/mob/living/carbon/human/proc/getarmor_organ(var/obj/item/organ/external/def_zone, var/type)
	if(!type)	return 0
	var/protection = 0
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/gear in protective_gear)
		if(gear && istype(gear ,/obj/item/clothing))
			var/obj/item/clothing/C = gear
			if(C.body_parts_covered & def_zone.body_part)
				protection += C.armor[type]
	return protection

/mob/living/carbon/human/proc/check_head_coverage()

	var/list/body_parts = list(head, wear_mask, wear_suit, w_uniform)
	for(var/bp in body_parts)
		if(!bp)	continue
		if(bp && istype(bp ,/obj/item/clothing))
			var/obj/item/clothing/C = bp
			if(C.body_parts_covered & HEAD)
				return 1
	return 0

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/attack_text = "the attack")
	if(l_hand && istype(l_hand, /obj/item/weapon))//Current base is the prob(50-d/3)
		var/obj/item/weapon/I = l_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("\red <B>[src] blocks [attack_text] with the [l_hand.name]!</B>")
			return 1
	if(r_hand && istype(r_hand, /obj/item/weapon))
		var/obj/item/weapon/I = r_hand
		if(I.IsShield() && (prob(50 - round(damage / 3))))
			visible_message("\red <B>[src] blocks [attack_text] with the [r_hand.name]!</B>")
			return 1
	if(wear_suit && istype(wear_suit, /obj/item/))
		var/obj/item/I = wear_suit
		if(I.IsShield() && (prob(35)))
			visible_message("\red <B>The reactive teleport system flings [src] clear of [attack_text]!</B>")
			var/list/turfs = new/list()
			for(var/turf/T in orange(6))
				if(istype(T,/turf/space)) continue
				if(T.density) continue
				if(T.x>world.maxx-6 || T.x<6)	continue
				if(T.y>world.maxy-6 || T.y<6)	continue
				turfs += T
			if(!turfs.len) turfs += pick(/turf in orange(6))
			var/turf/picked = pick(turfs)
			if(!isturf(picked)) return
			src.loc = picked
			return 1
	return 0

/mob/living/carbon/human/emp_act(severity)
	for(var/obj/O in src)
		if(!O)	continue
		O.emp_act(severity)
	for(var/obj/item/organ/external/O  in organs)
		if(O.status & ORGAN_DESTROYED)	continue
		O.emp_act(severity)
		for(var/obj/item/organ/I  in O.internal_organs)
			if(I.robotic == 0)	continue
			I.emp_act(severity)
	..()


//Returns 1 if the attack hit, 0 if it missed.
/mob/living/carbon/human/proc/attacked_by(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I || !user)	return 0

	if((istype(I, /obj/item/weapon/butch) || istype(I, /obj/item/weapon/twohanded/chainsaw)) && src.stat == DEAD && user.a_intent == "hurt" && src.meatleft)
		var/obj/item/weapon/reagent_containers/food/snacks/meat/slab/human/newmeat = new /obj/item/weapon/reagent_containers/food/snacks/meat/slab/human(get_turf(src.loc))
		newmeat.name = src.real_name + newmeat.name
		newmeat.subjectname = src.real_name
		newmeat.subjectjob = src.job
		newmeat.reagents.add_reagent ("nutriment", (src.nutrition / 15) / 3)
		src.reagents.trans_to (newmeat, round ((src.reagents.total_volume) / 3, 1))
		src.loc.add_blood(src)
		--src.meatleft
		user << "\red You hack off a chunk of meat from [src.name]"

	var/target_zone = ran_zone(user.zone_sel.selecting)

	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_sel.selecting

	var/obj/item/organ/external/affecting = get_organ(target_zone)
	if (!affecting)
		return 0
	if((affecting.status & ORGAN_DESTROYED))
		user << "<span class='danger'>They are missing that limb!</span>"
		return 0
	var/hit_area = affecting.name

	if((user != src) && check_shields(I.force, "the [I.name]"))
		return 0

	if(istype(I,/obj/item/weapon/card/emag))
		if(!(affecting.status & ORGAN_ROBOT))
			user << "\red That limb isn't robotic."
			return
		if(affecting.sabotaged)
			user << "\red [src]'s [affecting.name] is already sabotaged!"
		else
			user << "\red You sneakily slide [I] into the dataport on [src]'s [affecting.name] and short out the safeties."
			var/obj/item/weapon/card/emag/emag = I
			emag.uses--
			affecting.sabotaged = 1
		return 1

	if(I.attack_verb && I.attack_verb.len)
		visible_message("\red <B>[src] has been [pick(I.attack_verb)] in the [hit_area] with [I.name] by [user]!</B>")
	else
		visible_message("\red <B>[src] has been attacked in the [hit_area] with [I.name] by [user]!</B>")

	var/armor = run_armor_check(affecting, "melee", "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].")
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	if ((weapon_sharp || weapon_edge) && prob(getarmor(target_zone, "melee")))
		weapon_sharp = 0
		weapon_edge = 0

	if(armor >= 2)	return 0
	if(!I.force)	return 0
	var/Iforce = I.force //to avoid runtimes on the forcesay checks at the bottom. Some items might delete themselves if you drop them. (stunning yourself, ninja swords)

	apply_damage(I.force, I.damtype, affecting, armor, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	var/bloody = 0
	if(((I.damtype == BRUTE) || (I.damtype == HALLOSS)) && prob(25 + (I.force * 2)))
		I.add_blood(src)	//Make the weapon bloody, not the person.
//		if(user.hand)	user.update_inv_l_hand()	//updates the attacker's overlay for the (now bloodied) weapon
//		else			user.update_inv_r_hand()	//removed because weapons don't have on-mob blood overlays
		if(prob(33))
			bloody = 1
			var/turf/location = loc
			if(istype(location, /turf/simulated))
				location.add_blood(src)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
					H.bloody_body(src)
					H.bloody_hands(src)

		switch(hit_area)
			if("head")//Harder to score a stun but if you do it lasts a bit longer
				if(prob(I.force))
					apply_effect(20, PARALYZE, armor)
					visible_message("\red <B>[src] has been knocked unconscious!</B>")
					if(src != user && I.damtype == BRUTE)
						ticker.mode.remove_revolutionary(mind)

				if(bloody)//Apply blood
					if(wear_mask)
						wear_mask.add_blood(src)
						update_inv_wear_mask(0)
					if(head)
						head.add_blood(src)
						update_inv_head(0)
					if(glasses && prob(33))
						glasses.add_blood(src)
						update_inv_glasses(0)

			if("chest")//Easier to score a stun but lasts less time
				if(prob((I.force + 10)))
					apply_effect(6, WEAKEN, armor)
					visible_message("\red <B>[src] has been knocked down!</B>")

				if(bloody)
					bloody_body(src)

	if(Iforce > 10 || Iforce >= 5 && prob(33))
		forcesay(hit_appends)	//forcesay checks stat already

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !I.is_robot_module())
		var/damage = I.force
		if (armor)
			damage /= armor+1

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if(((weapon_sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance))) && (I.no_embed == 0))
			affecting.embed(I)
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj,var/speed = 5)
	if(istype(AM,/obj/))
		var/obj/O = AM

		if(in_throw_mode && !get_active_hand() && speed <= 5)	//empty active hand and we're in throw mode
			if(canmove && !restrained())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message("<span class='warning'>[src] catches [O]!</span>")
					throw_mode_off()
					return

		var/dtype = BRUTE
		if(istype(O,/obj/item/weapon))
			var/obj/item/weapon/W = O
			dtype = W.damtype
		var/throw_damage = O.throwforce*(speed/5)

		var/zone
		if (istype(O.thrower, /mob/living))
			var/mob/living/L = O.thrower
			zone = check_zone(L.zone_sel.selecting)
		else
			zone = ran_zone("chest",75)	//Hits a random part of the body, geared towards the chest

		//check if we hit
		if (O.throw_source)
			var/distance = get_dist(O.throw_source, loc)
			zone = get_zone_with_miss_chance(zone, src, min(15*(distance-2), 0))
		else
			zone = get_zone_with_miss_chance(zone, src, 15)

		if(!zone)
			visible_message("\blue \The [O] misses [src] narrowly!")
			return

		O.throwing = 0		//it hit, so stop moving

		if ((O.thrower != src) && check_shields(throw_damage, "[O]"))
			return

		var/obj/item/organ/external/affecting = get_organ(zone)
		var/hit_area = affecting.name

		src.visible_message("\red [src] has been hit in the [hit_area] by [O].")
		var/armor = run_armor_check(affecting, "melee", "Your armor has protected your [hit_area].", "Your armor has softened hit to your [hit_area].") //I guess "melee" is the best fit here

		if(armor < 2)
			apply_damage(throw_damage, dtype, zone, armor, is_sharp(O), has_edge(O), O)

		if(ismob(O.thrower))
			var/mob/M = O.thrower
			var/client/assailant = M.client
			if(assailant)
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been hit with a [O], thrown by [M.name] ([assailant.ckey])</font>")
				M.attack_log += text("\[[time_stamp()]\] <font color='red'>Hit [src.name] ([src.ckey]) with a thrown [O]</font>")
				if(!istype(src,/mob/living/simple_animal/mouse))
					msg_admin_attack("[src.name] ([src.ckey]) was hit by a [O], thrown by [M.name] ([assailant.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

		//thrown weapon embedded object code.
		if(dtype == BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!I.is_robot_module())
				var/sharp = is_sharp(I)
				var/damage = throw_damage
				if (armor)
					damage /= armor+1

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I)

		// Begin BS12 momentum-transfer code.
		if(O.throw_source && speed >= 15)
			var/obj/item/weapon/W = O
			var/momentum = speed/2
			var/dir = get_dir(O.throw_source, src)

			visible_message("\red [src] staggers under the impact!","\red You stagger under the impact!")
			src.throw_at(get_edge_target_turf(src,dir),1,momentum)

			if(!W || !src) return

			if(W.loc == src && W.sharp) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.loc = T
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = 1
					src.pinned += O


/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	if (gloves)
		gloves.add_blood(source)
		gloves:transfer_blood = amount
		gloves:bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if(damtype != BURN && damtype != BRUTE) return

	// The rig might soak this hit, if we're wearing one.
	if(back && istype(back,/obj/item/weapon/rig))
		var/obj/item/weapon/rig/rig = back
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	var/obj/item/clothing/suit/space/SS = wear_suit
	var/penetrated_dam = max(0,(damage - SS.breach_threshold))
	if(penetrated_dam) SS.create_breaches(damtype, penetrated_dam)


/mob/living/carbon/human/acid_act(acidpwr, toxpwr, acid_volume)
	var/list/damaged = list()
	var/list/inventory_items_to_kill = list()
	var/acidity = min(acidpwr*acid_volume/200, toxpwr)
	var/acid_volume_left = acid_volume
	var/acid_decay = 100/acidpwr // how much volume we lose per item we try to melt. 5 for fluoro, 10 for sulphuric

	//HEAD//
	var/obj/item/clothing/head_clothes = null
	if(glasses)
		head_clothes = glasses
	if(wear_mask)
		head_clothes = wear_mask
	if(head)
		head_clothes = head
	if(head_clothes)
		if(!head_clothes.unacidable)
			head_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0) //We remove some of the acid volume.
			update_inv_glasses()
			update_inv_wear_mask()
			update_inv_head()
		else
			src << "<span class='notice'>Your [head_clothes.name] protects your head and face from the acid!</span>"
	else
		. = get_organ("head")
		if(.)
			damaged += .
		if(r_ear)
			inventory_items_to_kill += r_ear
		if(l_ear)
			inventory_items_to_kill += l_ear

	//CHEST//
	var/obj/item/clothing/chest_clothes = null
	if(w_uniform)
		chest_clothes = w_uniform
	if(wear_suit)
		chest_clothes = wear_suit
	if(chest_clothes)
		if(!chest_clothes.unacidable)
			chest_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [chest_clothes.name] protects your body from the acid!</span>"
	else
		. = get_organ("chest")
		if(.)
			damaged += .
		if(wear_id)
			inventory_items_to_kill += wear_id
		if(r_store)
			inventory_items_to_kill += r_store
		if(l_store)
			inventory_items_to_kill += l_store
		if(s_store)
			inventory_items_to_kill += s_store


	//ARMS & HANDS//
	var/obj/item/clothing/arm_clothes = null
	if(gloves)
		arm_clothes = gloves
	if(w_uniform && (w_uniform.body_parts_covered & HANDS) || w_uniform && (w_uniform.body_parts_covered & ARMS))
		arm_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & HANDS) || wear_suit && (wear_suit.body_parts_covered & ARMS))
		arm_clothes = wear_suit
	if(arm_clothes)
		if(!arm_clothes.unacidable)
			arm_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_gloves()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [arm_clothes.name] protects your arms and hands from the acid!</span>"
	else
		. = get_organ("r_arm")
		if(.)
			damaged += .
		. = get_organ("l_arm")
		if(.)
			damaged += .


	//LEGS & FEET//
	var/obj/item/clothing/leg_clothes = null
	if(shoes)
		leg_clothes = shoes
	if(w_uniform && (w_uniform.body_parts_covered & FEET) || w_uniform && (w_uniform.body_parts_covered & LEGS))
		leg_clothes = w_uniform
	if(wear_suit && (wear_suit.body_parts_covered & FEET) || wear_suit && (wear_suit.body_parts_covered & LEGS))
		leg_clothes = wear_suit
	if(leg_clothes)
		if(!leg_clothes.unacidable)
			leg_clothes.acid_act(acidpwr, acid_volume_left)
			acid_volume_left = max(acid_volume_left - acid_decay, 0)
			update_inv_shoes()
			update_inv_w_uniform()
			update_inv_wear_suit()
		else
			src << "<span class='notice'>Your [leg_clothes.name] protects your legs and feet from the acid!</span>"
	else
		. = get_organ("r_leg")
		if(.)
			damaged += .
		. = get_organ("l_leg")
		if(.)
			damaged += .


	//DAMAGE//
	for(var/obj/item/organ/external/affecting in damaged)
		affecting.take_damage(acidity, 2*acidity)

		if(affecting.name == "head")
			if(prob(min(acidpwr*acid_volume/10, 90))) //Applies disfigurement
				affecting.take_damage(acidity, 2*acidity)
				emote("scream")
				f_style = "Shaved"
				h_style = "Bald"
				update_hair()
				affecting.disfigure("burn")
				status_flags |= DISFIGURED

		UpdateDamageIcon()

	//MELTING INVENTORY ITEMS//
	//these items are all outside of armour visually, so melt regardless.
	if(back)
		inventory_items_to_kill += back
	if(belt)
		inventory_items_to_kill += belt
	if(r_hand)
		inventory_items_to_kill += r_hand
	if(l_hand)
		inventory_items_to_kill += l_hand

	for(var/obj/item/I in inventory_items_to_kill)
		I.acid_act(acidpwr, acid_volume_left)
		acid_volume_left = max(acid_volume_left - acid_decay, 0)