/mob/living/carbon/alien

	name = "alien"
	desc = "What IS that?"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alien"
	pass_flags = PASSTABLE
	health = 100
	maxHealth = 100
	mob_size = 4

	var/adult_form
	var/dead_icon
	var/amount_grown = 0
	var/max_grown = 200
	var/time_of_birth
	var/language

/mob/living/carbon/alien/New()

	time_of_birth = world.time

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src

	name = "[initial(name)] ([rand(1, 1000)])"
	real_name = name
	regenerate_icons()

	if(language)
		add_language(language)

	gender = NEUTER

	..()

/mob/living/carbon/alien/Stat()
	..()
	stat(null, "Progress: [amount_grown]/[max_grown]")

/mob/living/carbon/alien/restrained()
	return 0

/mob/living/carbon/alien/show_inv(mob/user as mob)
	return //Consider adding cuffs and hats to this, for the sake of fun.

/mob/living/carbon/alien/can_use_vents()
	return

//Paradise Ported footstep code

/mob/living/carbon/alien/handle_footstep(turf/T)
	if(..())
		if(T.footstep_sounds["xeno"])
			var/S = pick(T.footstep_sounds["xeno"])
			if(S)
				if(m_intent == "run")
					if(!(step_count % 2)) //every other turf makes a sound
						return 0
				var/range = -(world.view - 2)
				range -= 0.666 //-(7 - 2) = (-5) = -5 | -5 - (0.666) = -5.666 | (7 + -5.666) = 1.334 | 1.334 * 3 = 4.002 | range(4.002) = range(4)
				var/volume = 5
				if(m_intent == "walk")
					return 0 //silent when walking
				if(buckled || lying || throwing)
					return 0 //people flying, lying down or sitting do not step
				if(!has_gravity(src))
					if(step_count % 3) //this basically says, every three moves make a noise
						return 0       //1st - none, 1%3==1, 2nd - none, 2%3==2, 3rd - noise, 3%3==0
				playsound(T, S, volume, 1, range)
				return 1
	return 0

//End Paradise ported footstep code