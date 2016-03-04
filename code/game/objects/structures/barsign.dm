/obj/structure/sign/double/barsign
	icon = 'icons/obj/barsigns.dmi'
	icon_state = "empty"
	light_color = "#742a20"
	light_power = 2
	anchored = 1
	var/on
	New()
		ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum", "meadbay", "thedamnwall", "thecavern", "cindikate", "theorchard", "thesaucyclown", "theclownshead", "whiskeyimplant", "carpecarp", "robustroadhouse", "greytide", "theredshirt"))
		on = 1
		blink()
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		return

/obj/structure/sign/double/barsign/Destroy()
	set_light(0)
	..()

/obj/structure/sign/double/barsign/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/card = I
		if(access_bar in card.GetAccess())
			var/sign_type = input(user, "What would you like to change the barsign to?") as null|anything in list("Off", "Pink Flamingo", "Magma Sea", "Limbo", "Rusty Axe", "Armok Bar", "Broken Drum", "Mead Bay", "The Damn Wall", "The Cavern", "Cindi Kate", "The Orchard", "The Saucy Clown", "The Clowns Head", "Whiskey Implant", "Carpe Carp", "Robust Roadhouse", "Greytide", "The Redshirt")
			if(sign_type == null)
				return
			else
				sign_type = replacetext(lowertext(sign_type), " ", "") // lowercase, strip spaces - along with choices for user options, avoids huge if-else-else
				src.ChangeSign(sign_type)
				user << "You change the barsign."

/obj/structure/sign/double/barsign/proc/blink()
	if(on)
		switch(light_range)
			if(5)
				set_light(0)
			if(0)
				set_light(5)
	else
		set_light(0)