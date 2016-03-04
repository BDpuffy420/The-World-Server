/mob/living/carbon/Life()
	..()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

/mob/living/carbon/Destroy()
	//qdel(ingested)
	//qdel(touching)  #TOREMOVE -- not yet implemented
	// We don't qdel(bloodstr) because it's the same as qdel(reagents)
	for(var/guts in internal_organs)
		qdel(guts)
	for(var/food in stomach_contents)
		qdel(food)
	return ..()

/mob/living/carbon/Move(NewLoc, direct)
	. = ..()
	if(.)
		if(src.nutrition && src.stat != 2)
			src.nutrition -= HUNGER_FACTOR/10
			if(src.m_intent == "run")
				src.nutrition -= HUNGER_FACTOR/10
		if((FAT in src.mutations) && src.m_intent == "run" && src.bodytemperature <= 360)
			src.bodytemperature += 2

		// Moving around increases germ_level faster
		if(germ_level < GERM_LEVEL_MOVE_CAP && prob(8))
			germ_level++

/mob/living/carbon/relaymove(var/mob/user, direction)
	if(user in src.stomach_contents)
		if(prob(40))
			for(var/mob/M in hearers(4, src))
				if(M.client)
					M.show_message(text("\red You hear something rumbling inside [src]'s stomach..."), 2)
			var/obj/item/I = user.get_active_hand()
			if(I && I.force)
				var/d = rand(round(I.force / 4), I.force)
				if(istype(src, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = src
					var/organ = H.get_organ("chest")
					if (istype(organ, /obj/item/organ/external))
						var/obj/item/organ/external/temp = organ
						if(temp.take_damage(d, 0))
							H.UpdateDamageIcon()
					H.updatehealth()
				else
					src.take_organ_damage(d)
				for(var/mob/M in viewers(user, null))
					if(M.client)
						M.show_message(text("\red <B>[user] attacks [src]'s stomach wall with the [I.name]!"), 2)
				playsound(user.loc, 'sound/effects/attackblob.ogg', 50, 1)

				if(prob(src.getBruteLoss() - 50))
					for(var/atom/movable/A in stomach_contents)
						A.loc = loc
						stomach_contents.Remove(A)
					src.gib()

/mob/living/carbon/gib()
	for(var/mob/M in src)
		if(M in src.stomach_contents)
			src.stomach_contents.Remove(M)
		M.loc = src.loc
		for(var/mob/N in viewers(src, null))
			if(N.client)
				N.show_message(text("\red <B>[M] bursts out of [src]!</B>"), 2)
	..()

/mob/living/carbon/attack_hand(mob/M as mob)
	if(!istype(M, /mob/living/carbon)) return
	if (hasorgans(M))
		var/obj/item/organ/external/temp = M:organs_by_name["r_hand"]
		if (M.hand)
			temp = M:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			M << "\red You can't use your [temp.name]"
			return

	for(var/datum/disease/D in viruses)

		if(D.spread_by_touch())

			M.contract_disease(D, 0, 1, CONTACT_HANDS)

	for(var/datum/disease/D in M.viruses)

		if(D.spread_by_touch())

			contract_disease(D, 0, 1, CONTACT_HANDS)

	return

/mob/living/carbon/electrocute_act(var/shock_damage, var/obj/source, var/siemens_coeff = 1.0, var/def_zone = null)
	if(status_flags & GODMODE)	return 0	//godmode
	shock_damage *= siemens_coeff
	if (shock_damage<1)
		return 0

	src.apply_damage(shock_damage, BURN, def_zone, used_weapon="Electrocution")
	playsound(loc, "sparks", 50, 1, -1)
	if (shock_damage > 15)
		src.visible_message(
			"\red [src] was shocked by the [source]!", \
			"\red <B>You feel a powerful shock course through your body!</B>", \
			"\red You hear a heavy electrical crack." \
		)
		Stun(10)//This should work for now, more is really silly and makes you lay there forever
		Weaken(10)
	else
		src.visible_message(
			"\red [src] was mildly shocked by the [source].", \
			"\red You feel a mild shock course through your body.", \
			"\red You hear a light zapping." \
		)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(5, 1, loc)
	s.start()

	return shock_damage


/mob/living/carbon/proc/swap_hand()
	var/obj/item/item_in_hand = src.get_active_hand()
	if(item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(istype(item_in_hand,/obj/item/weapon/twohanded))
			if(item_in_hand:wielded == 1)
				usr << "<span class='warning'>Your other hand is too busy holding the [item_in_hand.name]</span>"
				return
	src.hand = !( src.hand )
	if(hud_used.l_hand_hud_object && hud_used.r_hand_hud_object)
		if(hand)	//This being 1 means the left hand is in use
			hud_used.l_hand_hud_object.icon_state = "hand_active"
			hud_used.r_hand_hud_object.icon_state = "hand_inactive"
		else
			hud_used.l_hand_hud_object.icon_state = "hand_inactive"
			hud_used.r_hand_hud_object.icon_state = "hand_active"
	/*if (!( src.hand ))
		src.hands.set_dir(NORTH)
	else
		src.hands.set_dir(SOUTH)*/
	return

/mob/living/carbon/proc/activate_hand(var/selhand) //0 or "r" or "right" for right hand; 1 or "l" or "left" for left hand.

	if(istext(selhand))
		selhand = lowertext(selhand)

		if(selhand == "right" || selhand == "r")
			selhand = 0
		if(selhand == "left" || selhand == "l")
			selhand = 1

	if(selhand != src.hand)
		swap_hand()

/mob/living/carbon/proc/help_shake_act(mob/living/carbon/M)
	if (src.health >= config.health_threshold_crit)
		if(src == M && istype(src, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = src
			src.visible_message( \
				text("\blue [src] examines [].",src.gender==MALE?"himself":"herself"), \
				"\blue You check yourself for injuries." \
				)

			for(var/obj/item/organ/external/org in H.organs)
				var/status = ""
				var/brutedamage = org.brute_dam
				var/burndamage = org.burn_dam
				if(halloss > 0)
					if(prob(30))
						brutedamage += halloss
					if(prob(30))
						burndamage += halloss

				if(brutedamage > 0)
					status = "bruised"
				if(brutedamage > 20)
					status = "bleeding"
				if(brutedamage > 40)
					status = "mangled"
				if(brutedamage > 0 && burndamage > 0)
					status += " and "
				if(burndamage > 40)
					status += "peeling away"

				else if(burndamage > 10)
					status += "blistered"
				else if(burndamage > 0)
					status += "numb"
				if(org.status & ORGAN_DESTROYED)
					status = "MISSING!"
				if(org.status & ORGAN_MUTATED)
					status = "weirdly shapen."
				if(status == "")
					status = "OK"
				src.show_message(text("\t []My [] is [].",status=="OK"?"\blue ":"\red ",org.name,status),1)
			if((SKELETON in H.mutations) && (!H.w_uniform) && (!H.wear_suit))
				H.play_xylophone()
		else
			var/t_him = "it"
			if (src.gender == MALE)
				t_him = "him"
			else if (src.gender == FEMALE)
				t_him = "her"
			if (istype(src,/mob/living/carbon/human) && src:w_uniform)
				var/mob/living/carbon/human/H = src
				H.w_uniform.add_fingerprint(M)

			var/show_ssd
			var/mob/living/carbon/human/H = src
			if(istype(H)) show_ssd = H.species.show_ssd
			if(show_ssd && !client && !aghosted)
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [t_him] up!</span>", \
				"<span class='notice'>You shake [src], but they do not respond... Maybe they have S.S.D?</span>")
			else if(lying || src.sleeping)
				src.sleeping = max(0,src.sleeping-5)
				if(src.sleeping == 0)
					src.resting = 0
				M.visible_message("<span class='notice'>[M] shakes [src] trying to wake [t_him] up!</span>", \
									"<span class='notice'>You shake [src] trying to wake [t_him] up!</span>")
			else
				var/mob/living/carbon/human/hugger = M
				if(istype(hugger))
					hugger.species.hug(hugger,src)
				else
					M.visible_message("<span class='notice'>[M] hugs [src] to make [t_him] feel better!</span>", \
								"<span class='notice'>You hug [src] to make [t_him] feel better!</span>")
				if(M.fire_stacks >= (src.fire_stacks + 3))
					src.fire_stacks += 1
					M.fire_stacks -= 1
				if(M.on_fire)
					src.IgniteMob()
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)

			playsound(src.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)

/mob/living/carbon/proc/eyecheck()
	return 0

// ++++ROCKDTBEN++++ MOB PROCS -- Ask me before touching.
// Stop! ... Hammertime! ~Carn

/mob/living/carbon/proc/getDNA()
	return dna

/mob/living/carbon/proc/setDNA(var/datum/dna/newDNA)
	dna = newDNA

// ++++ROCKDTBEN++++ MOB PROCS //END

/mob/living/carbon/clean_blood()
	. = ..()
	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.gloves)
			if(H.gloves.clean_blood())
				H.update_inv_gloves(0)
			H.gloves.germ_level = 0
		else
			if(H.bloody_hands)
				H.bloody_hands = 0
				H.update_inv_gloves(0)
			H.germ_level = 0
	update_icons()	//apply the now updated overlays to the mob

/mob/living/carbon/flash_eyes(intensity = 1, override_blindness_check = 0, affect_silicon = 0)
	var/damage = intensity - check_eye_prot()
	if(..()) // we've been flashed
		if(weakeyes)
			Stun(2)
		switch(damage)
			if(1)
				src << "<span class='warning'>Your eyes sting a little.</span>"
				if(prob(40))
					eye_stat += 1

			if(2)
				src << "<span class='warning'>Your eyes burn.</span>"
				eye_stat += rand(2, 4)

			else
				src << "<span class='warning'>Your eyes itch and burn severely!</span>"
				eye_stat += rand(12, 16)

		if(eye_stat > 10)
			eye_blind += damage
			eye_blurry += damage * rand(3, 6)

			if(eye_stat > 20)
				if (prob(eye_stat - 20))
					src << "<span class='warning'>Your eyes start to burn badly!</span>"
					disabilities |= NEARSIGHT
				else if(prob(eye_stat - 25))
					src << "<span class='warning'>You can't see anything!</span>"
					disabilities |= BLIND
			else
				src << "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>"
		return 1

	else if(damage == 0) // just enough protection
		if(prob(20))
			src << "<span class='notice'>Something bright flashes in the corner of your vision!</span>"

/mob/living/carbon/proc/tintcheck()
	return 0

//Throwing stuff

/mob/living/carbon/proc/toggle_throw_mode()
	if (src.in_throw_mode)
		throw_mode_off()
	else
		throw_mode_on()

/mob/living/carbon/proc/throw_mode_off()
	src.in_throw_mode = 0
	if(src.throw_icon) //in case we don't have the HUD and we use the hotkey
		src.throw_icon.icon_state = "act_throw_off"

/mob/living/carbon/proc/throw_mode_on()
	src.in_throw_mode = 1
	if(src.throw_icon)
		src.throw_icon.icon_state = "act_throw_on"

/mob/proc/throw_item(atom/target)
	return

/mob/living/carbon/throw_item(atom/target)
	var/spin = 1
	throw_mode_off()
	if(usr.stat || !target)
		return
	if(target.type == /obj/screen)
		return

	var/atom/movable/item = src.get_active_hand()

	if(!item || (item.flags & NODROP))
		return

	if (istype(item, /obj/item/weapon/grab))
		spin = 0
		var/obj/item/weapon/grab/G = item
		item = G.throw_held() //throw the person instead of the grab
		qdel(G)
		if(ismob(item))
			var/turf/start_T = get_turf(loc) //Get the start and target tile for the descriptors
			var/turf/end_T = get_turf(target)
			if(start_T && end_T)
				var/mob/M = item
				var/start_T_descriptor = "<font color='#6b5d00'>tile at [start_T.x], [start_T.y], [start_T.z] in area [get_area(start_T)]</font>"
				var/end_T_descriptor = "<font color='#6b4400'>tile at [end_T.x], [end_T.y], [end_T.z] in area [get_area(end_T)]</font>"

				add_logs(src, M, "thrown", addition="from [start_T_descriptor] with the target [end_T_descriptor]")
				msg_admin_attack("[key_name_admin(usr)] has thrown [key_name_admin(M)] from [start_T_descriptor] with the target [end_T_descriptor]")

				if(!iscarbon(usr))
					M.LAssailant = null
				else
					M.LAssailant = usr

	if(!item) return //Grab processing has a chance of returning null
	if(!ismob(item)) //Honk mobs don't have a dropped() proc honk
		unEquip(item)

	update_icons()

	if(src.client)
		src.client.screen -= item

	//actually throw it!
	if (item)
		item.layer = initial(item.layer)
		src.visible_message("<span class='danger'>[src] has thrown [item].</danger>")

		if(!src.lastarea)
			src.lastarea = get_area(src.loc)
		if((istype(src.loc, /turf/space)) || (src.lastarea.has_gravity == 0))
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)


/*
		if(istype(src.loc, /turf/space) || (src.flags & NOGRAV)) //they're in space, move em one space in the opposite direction
			src.inertia_dir = get_dir(target, src)
			step(src, inertia_dir)
*/


		item.throw_at(target, item.throw_range, item.throw_speed, src, spin)

/mob/living/carbon/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	..()
	bodytemperature = max(bodytemperature, BODYTEMP_HEAT_DAMAGE_LIMIT+10)

/mob/living/carbon/can_use_hands()
	if(handcuffed)
		return 0
	if(buckled && ! istype(buckled, /obj/structure/stool/bed/chair)) // buckling does not restrict hands
		return 0
	return 1

/mob/living/carbon/restrained()
	if (handcuffed)
		return 1
	return

/mob/living/carbon/show_inv(mob/living/carbon/user as mob)
	user.set_machine(src)
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR>
	<BR><B>Head(Mask):</B> <A href='?src=\ref[src];item=mask'>[(wear_mask ? wear_mask : "Nothing")]</A>
	<BR><B>Left Hand:</B> <A href='?src=\ref[src];item=l_hand'>[(l_hand ? l_hand  : "Nothing")]</A>
	<BR><B>Right Hand:</B> <A href='?src=\ref[src];item=r_hand'>[(r_hand ? r_hand : "Nothing")]</A>
	<BR><B>Back:</B> <A href='?src=\ref[src];item=back'>[(back ? back : "Nothing")]</A> [((istype(wear_mask, /obj/item/clothing/mask) && istype(back, /obj/item/weapon/tank) && !( internal )) ? text(" <A href='?src=\ref[];item=internal'>Set Internal</A>", src) : "")]
	<BR>[(handcuffed ? text("<A href='?src=\ref[src];item=handcuff'>Handcuffed</A>") : text("<A href='?src=\ref[src];item=handcuff'>Not Handcuffed</A>"))]
	<BR>[(internal ? text("<A href='?src=\ref[src];item=internal'>Remove Internal</A>") : "")]
	<BR><A href='?src=\ref[src];item=pockets'>Empty Pockets</A>
	<BR><A href='?src=\ref[user];refresh=1'>Refresh</A>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[];size=325x500", name))
	onclose(user, "mob[name]")
	return

//generates realistic-ish pulse output based on preset levels
/mob/living/carbon/proc/get_pulse(var/method)	//method 0 is for hands, 1 is for machines, more accurate
	var/temp = 0								//see setup.dm:694
	switch(src.pulse)
		if(PULSE_NONE)
			return "0"
		if(PULSE_SLOW)
			temp = rand(40, 60)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_NORM)
			temp = rand(60, 90)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_FAST)
			temp = rand(90, 120)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_2FAST)
			temp = rand(120, 160)
			return num2text(method ? temp : temp + rand(-10, 10))
		if(PULSE_THREADY)
			return method ? ">250" : "extremely weak and fast, patient's artery feels like a thread"
//			output for machines^	^^^^^^^output for people^^^^^^^^^

/mob/living/carbon/verb/mob_sleep()
	set name = "Sleep"
	set category = "IC"

	if(usr.sleeping)
		usr << "\red You are already sleeping"
		return
	if(alert(src,"You sure you want to sleep for a while?","Sleep","Yes","No") == "Yes")
		usr.sleeping = 20 //Short nap

/mob/living/carbon/Bump(var/atom/movable/AM, yes)
	if(now_pushing || !yes)
		return
	..()
	if(istype(AM, /mob/living/carbon) && prob(10))
		src.spread_disease_to(AM, "Contact")

/mob/living/carbon/resist_buckle()
	if(restrained())
		changeNext_move(CLICK_CD_BREAKOUT)
		last_special = world.time + CLICK_CD_BREAKOUT
		visible_message("<span class='warning'>[src] attempts to unbuckle themself!</span>", \
					"<span class='notice'>You attempt to unbuckle yourself... (This will take around one minute and you need to stay still.)</span>")
		if(do_after(src, 600, needhand = 0, target = src))
			if(!buckled)
				return
			if(istype(buckled, /obj/vehicle))
				var/obj/vehicle/V
				V.unload(src)
			else
				buckled.user_unbuckle_mob(src,src)
		else
			if(src && buckled)
				src << "<span class='warning'>You fail to unbuckle yourself!</span>"
	else
		if(istype(buckled, /obj/vehicle))
			var/obj/vehicle/car/V
			V.unload(src)
		else
			buckled.user_unbuckle_mob(src,src)

/mob/living/carbon/resist_fire()
	fire_stacks -= 5
	Weaken(3,1)
	spin(32,2)
	visible_message("<span class='danger'>[src] rolls on the floor, trying to put themselves out!</span>", \
		"<span class='notice'>You stop, drop, and roll!</span>")
	sleep(30)
	if(fire_stacks <= 0)
		visible_message("<span class='danger'>[src] has successfully extinguished themselves!</span>", \
			"<span class='notice'>You extinguish yourself.</span>")
		ExtinguishMob()
	return

/mob/living/carbon/resist_restraints()
	var/obj/item/I = null
	if(handcuffed)
		I = handcuffed
	else if(legcuffed)
		I = legcuffed
	if(I)
		changeNext_move(CLICK_CD_BREAKOUT)
		last_special = world.time + CLICK_CD_BREAKOUT
		cuff_resist(I)


/mob/living/carbon/proc/cuff_resist(obj/item/I, breakouttime = 600, cuff_break = 0)
	if(istype(I, /obj/item/weapon/handcuffs))
		var/obj/item/weapon/handcuffs/H = I
		breakouttime = H.breakouttime
	var/displaytime = breakouttime / 600
	if(!cuff_break)
		visible_message("<span class='warning'>[src] attempts to remove [I]!</span>")
		src << "<span class='notice'>You attempt to remove [I]... (This will take around [displaytime] minutes and you need to stand still.)</span>"
		if(do_after(src, breakouttime, 10, target = src))
			if(I.loc != src || buckled)
				return
			visible_message("<span class='danger'>[src] manages to remove [I]!</span>")
			src << "<span class='notice'>You successfully remove [I].</span>"

			if(handcuffed)
				handcuffed.loc = loc
				handcuffed.dropped(src)
				handcuffed = null
			//	if(buckled && buckled.buckle_requires_restraints) #TOREMOVE
				if(buckled)
					buckled.unbuckle_mob()
				update_inv_handcuffed()
				return
			if(legcuffed)
				legcuffed.loc = loc
				legcuffed.dropped()
				legcuffed = null
				update_inv_legcuffed()
		else
			src << "<span class='warning'>You fail to remove [I]!</span>"

	else
		breakouttime = 50
		visible_message("<span class='warning'>[src] is trying to break [I]!</span>")
		src << "<span class='notice'>You attempt to break [I]... (This will take around 5 seconds and you need to stand still.)</span>"
		if(do_after(src, breakouttime, 10, 0, target = src))
			if(!I.loc || buckled)
				return
			visible_message("<span class='danger'>[src] manages to break [I]!</span>")
			src << "<span class='notice'>You successfully break [I].</span>"
			qdel(I)

			if(handcuffed)
				handcuffed = null
				update_inv_handcuffed()
				return
			else
				legcuffed = null
				update_inv_legcuffed()
		else
			src << "<span class='warning'>You fail to break [I]!</span>"

/mob/living/carbon/proc/uncuff()
	if (handcuffed)
		var/obj/item/weapon/W = handcuffed
		handcuffed = null
		//if (buckled && buckled.buckle_requires_restraints) #TOREMOVE
		if (buckled)
			buckled.unbuckle_mob()
		update_inv_handcuffed()
		if (client)
			client.screen -= W
		if (W)
			W.loc = loc
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)
	if (legcuffed)
		var/obj/item/weapon/W = legcuffed
		legcuffed = null
		update_inv_legcuffed()
		if (client)
			client.screen -= W
		if (W)
			W.loc = loc
			W.dropped(src)
			if (W)
				W.layer = initial(W.layer)

/mob/living/carbon/can_use_vents()
	return

/mob/living/carbon/slip(var/slipped_on,stun_duration=8)
	if(buckled)
		return 0
	stop_pulling()
	src << "<span class='warning'>You slipped on [slipped_on]!</span>"
	playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
	Stun(stun_duration)
	Weaken(Floor(stun_duration/2))
	return 1

/mob/living/carbon/proc/is_mouth_covered(head_only = 0, mask_only = 0)
	if( (!mask_only && head && (head.flags & HEADCOVERSMOUTH)) || (!head_only && wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)) )
		return 1

/mob/living/carbon/check_eye_prot()
	var/number = ..()
	return number

/mob/living/carbon/check_ear_prot()
	if(head && (head.flags & HEADBANGPROTECT))
		return 1