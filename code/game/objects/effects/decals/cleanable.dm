/obj/effect/decal/cleanable
	var/list/random_icon_states = list()
	var/targeted_by = null			// Used so cleanbots can't claim a mess.

/obj/effect/decal/cleanable/New()
	if (random_icon_states && length(src.random_icon_states) > 0)
		src.icon_state = pick(src.random_icon_states)
	..()

/obj/effect/decal/cleanable/ex_act()
	//if(reagents)
	//	for(var/datum/reagent/R in reagents.reagent_list)
	//		R.on_ex_act()
	..()

/obj/effect/decal/cleanable/fire_act()
//	if(reagents)
	//	reagents.chem_temp += 30
	//	reagents.handle_reactions() #TOREMOVE - implement floor fuel decal ignition
	..()
