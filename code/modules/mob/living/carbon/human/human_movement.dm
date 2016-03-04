/mob/living/carbon/human/movement_delay()

	var/tally = 0

	if(species.slowdown)
		tally = species.slowdown

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag)
		handle_embedded_objects() //Moving with objects stuck in you can cause bad times.

	if(reagents.has_reagent("hyperzine")) return -1

	if(reagents.has_reagent("nuka_cola")) return -1

	var/health_deficiency = (100 - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if (!(species && (species.flags & NO_PAIN)))
		if(halloss >= 10) tally += (halloss / 10) //halloss shouldn't slow you down if you can't even feel it

	var/hungry = (500 - nutrition)/5 // So overeat would be 100 and default level would be 80
	if (hungry >= 70) tally += hungry/50

	if(wear_suit)
		tally += wear_suit.slowdown

	if(istype(buckled, /obj/structure/stool/bed/chair/wheelchair))
		for(var/organ_name in list("l_hand","r_hand","l_arm","r_arm"))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || (E.status & ORGAN_DESTROYED))
				tally += 4
			if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		if(shoes)
			tally += shoes.slowdown

		for(var/organ_name in list("l_foot","r_foot","l_leg","r_leg"))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || (E.status & ORGAN_DESTROYED))
				tally += 4
			if(E.status & ORGAN_SPLINTED)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10) tally += 3

	if(FAT in src.mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	if(status_flags & GOTTAGOFAST)
		tally -= 1
	if(status_flags & GOTTAGOREALLYFAST)
		tally -= 2

	return (tally+config.human_delay)

/mob/living/carbon/human/Process_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/weapon/tank/jetpack))
			thrust = back
		else if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				thrust = module.jets
				break

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

	//If no working jetpack then use the other checks
	if(..())
		return 1
	return 0


/mob/living/carbon/human/Process_Spaceslipping(var/prob_slip = 5)
	//If knocked out we might just hit it and stop.  This makes it possible to get dead bodies and such.

	if(species.flags & NO_SLIP)
		return

	if(stat)
		prob_slip = 0 // Changing this to zero to make it line up with the comment, and also, make more sense.

	//Do we have magboots or such on if so no slip
	if(istype(shoes, /obj/item/clothing/shoes/magboots) && (shoes.flags & NOSLIP))
		prob_slip = 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= 2)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= 2)	prob_slip -= 1

	prob_slip = round(prob_slip)
	return(prob_slip)

//Paradise ported footstep code //

/mob/living/carbon/human/handle_footstep(turf/T)
	if(..())
		if(T.footstep_sounds["human"])
			var/S = pick(T.footstep_sounds["human"])
			if(S)
				if(m_intent == "run")
					if(!(step_count % 2)) //every other turf makes a sound
						return 0

				var/range = -(world.view - 2)
				if(m_intent == "walk")
					range -= 0.333
				if(!shoes)
					range -= 0.333

				//shoes + running
					//-(7 - 2) = -(5) = -5 | -5 - 0           = -5     | (7 + -5)     = 2     | 2     * 3 = 6     | range(6)     = range(6)
				//running OR shoes
					//-(7 - 2) = (-5) = -5 | -5 - 0.333       = -5.333 | (7 + -5.333) = 1.667 | 1.667 * 3 = 5.001 | range(5.001) = range(5)
				//walking AND no shoes
					//-(7 - 2) = (-5) = -5 | -5 - (0.333 * 2) = -5.666 | (7 + -5.666) = 1.334 | 1.334 * 3 = 4.002 | range(4.002) = range(4)

				var/volume = 13
				if(m_intent == "walk")
					volume -= 4
				if(!shoes)
					volume -= 4

				if(istype(shoes, /obj/item/clothing/shoes))
					var/obj/item/clothing/shoes/shooess = shoes
					if(shooess.silence_steps)
						return 0 //silent

				if(!has_organ("l_foot") && !has_organ("r_foot"))
					return 0 //no feet no footsteps

				if(buckled || lying || throwing)
					return 0 //people flying, lying down or sitting do not step

				if(!has_gravity(src))
					if(step_count % 3) //this basically says, every three moves make a noise
						return 0       //1st - none, 1%3==1, 2nd - none, 2%3==2, 3rd - noise, 3%3==0

				if(species.silent_steps)
					return 0 //species is silent

				playsound(T, S, volume, 1, range)
				return 1

	return 0
