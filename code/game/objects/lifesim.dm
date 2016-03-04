// This can be a human, skrell, unathi, or tajara child. Don't do any freaky interspecies shit with this. I'm watching you.
/obj/item/weapon/baby
	name = "baby"
	desc = "A very, very young child. How cute."
	icon = 'icons/obj/lifesim.dmi'
	icon_state = "baby-blackeyed"

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/bottle
	name = "baby bottle"
	desc = "A simple baby bottle.."
	icon_state = "bottle_empty"

//Mobile Phones

/obj/item/weapon/mobile
	name = "Subspace Mobile"
	desc = "It appears to be a mobile phone."
	icon = 'icons/obj/lifesim.dmi'
	icon_state = "subspacemobile"


	attack_hand(mob/user)
		switch(alert("This is a mobile phone, what do you want to do?",,"Ring","Talk","Text Message","None"))
			if("Ring")

				return
			if("Shopping")
				var/turf/T = locate(106,170,7)
				if(T)
					user.loc = T
				return
			if("Text")
				var/turf/T = locate(13,136,9)
				if(T)
					user.loc = T
				return
			if("None")
				return

/obj/item/weapon/mobile/fluff/elizabeth
	name = "Subspace Mobile"
	desc = "It appears to be a mobile phone."
	icon = 'icons/obj/lifesim.dmi'
	icon_state = "subspacemobile"
