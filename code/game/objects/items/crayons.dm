/***************************************************************
**						Crayons     						  **
**                 Includes spraycans                         **
***************************************************************/

/obj/item/toy/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = 1.0
	attack_verb = list("attacked", "coloured")
	var/colour = "#FF0000" //RGB
	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/list/validSurfaces = list(/turf/simulated/floor)
	var/edible = 1 //so you can't eat a spraycan

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is jamming the [src.name] up \his nose and into \his brain. It looks like \he's trying to commit suicide.</b>"
		return (BRUTELOSS|OXYLOSS)

/obj/item/toy/crayon/afterattack(atom/target, mob/user as mob, proximity)
	if(!proximity) return
	if(is_type_in_list(target,validSurfaces))
		var/drawtype = input("Choose what you'd like to draw.", "Crayon scribbles") in list("graffiti","rune","letter")
		switch(drawtype)
			if("letter")
				drawtype = input("Choose the letter.", "Crayon scribbles") in list("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
				user << "You start drawing a letter on the [target.name]."
			if("graffiti")
				user << "You start drawing graffiti on the [target.name]."
			if("rune")
				user << "You start drawing a rune on the [target.name]."
		if(instant || do_after(user, 50))
			new /obj/effect/decal/cleanable/crayon(target,colour,shadeColour,drawtype)
			user << "You finish drawing."
			target.add_fingerprint(user)		// Adds their fingerprints to the floor the crayon is drawn on.
			if(uses)
				uses--
				if(!uses)
					user << "\red You used up your crayon!"
					qdel(src)
	return

/obj/item/toy/crayon/attack(mob/M as mob, mob/user as mob)
	if(edible && (M == user))
		user << "You take a bite of the crayon and swallow it."
		user.nutrition += 5
		if(uses)
			uses -= 5
			if(uses <= 0)
				user << "\red You ate your crayon!"
				qdel(src)
	else
		..()

/obj/item/toy/crayon/red
	icon_state = "crayonred"
	colour = "#DA0000"
	shadeColour = "#810C0C"
	colourName = "red"

/obj/item/toy/crayon/orange
	icon_state = "crayonorange"
	colour = "#FF9300"
	shadeColour = "#A55403"
	colourName = "orange"

/obj/item/toy/crayon/yellow
	icon_state = "crayonyellow"
	colour = "#FFF200"
	shadeColour = "#886422"
	colourName = "yellow"

/obj/item/toy/crayon/green
	icon_state = "crayongreen"
	colour = "#A8E61D"
	shadeColour = "#61840F"
	colourName = "green"

/obj/item/toy/crayon/blue
	icon_state = "crayonblue"
	colour = "#00B7EF"
	shadeColour = "#0082A8"
	colourName = "blue"

/obj/item/toy/crayon/purple
	icon_state = "crayonpurple"
	colour = "#DA00FF"
	shadeColour = "#810CFF"
	colourName = "purple"

/obj/item/toy/crayon/mime
	icon_state = "crayonmime"
	desc = "A very sad-looking crayon."
	colour = "#FFFFFF"
	shadeColour = "#000000"
	colourName = "mime"
	uses = 0

/obj/item/toy/crayon/mime/attack_self(mob/living/user as mob) //inversion
	if(colour != "#FFFFFF" && shadeColour != "#000000")
		colour = "#FFFFFF"
		shadeColour = "#000000"
		user << "You will now draw in white and black with this crayon."
	else
		colour = "#000000"
		shadeColour = "#FFFFFF"
		user << "You will now draw in black and white with this crayon."
	return

/obj/item/toy/crayon/rainbow
	icon_state = "crayonrainbow"
	colour = "#FFF000"
	shadeColour = "#000FFF"
	colourName = "rainbow"
	uses = 0

/obj/item/toy/crayon/rainbow/attack_self(mob/living/user as mob)
	colour = input(user, "Please select the main colour.", "Crayon colour") as color
	shadeColour = input(user, "Please select the shade colour.", "Crayon colour") as color
	return

/*
 * Crayon Box
 */
/obj/item/weapon/storage/crayons
	name = "box of crayons"
	desc = "A box of crayons for all your rune drawing needs."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonbox"
	w_class = 2
	storage_slots = 6
	can_hold = list(
		/obj/item/toy/crayon
	)
/obj/item/weapon/storage/crayons/New()
	..()
	new /obj/item/toy/crayon/red(src)
	new /obj/item/toy/crayon/orange(src)
	new /obj/item/toy/crayon/yellow(src)
	new /obj/item/toy/crayon/green(src)
	new /obj/item/toy/crayon/blue(src)
	new /obj/item/toy/crayon/purple(src)
	update_icon()
/obj/item/weapon/storage/crayons/update_icon()
	overlays.Cut()
	for(var/obj/item/toy/crayon/crayon in contents)
		overlays += image('icons/obj/crayons.dmi',crayon.colourName)
/obj/item/weapon/storage/crayons/attackby(obj/item/W, mob/user, params)
	if(istype(W,/obj/item/toy/crayon))
		switch(W:colourName)
			if("mime")
				usr << "This crayon is too sad to be contained in this box."
				return
			if("rainbow")
				usr << "This crayon is too powerful to be contained in this box."
				return
	..()

//|Spraycan stuff

/obj/item/toy/crayon/spraycan
	icon_state = "spraycan_cap"
	item_state = "spraycan"
	desc = "A metallic container containing tasty paint."
	var/capped = 1
	instant = 1
	edible = 0
	validSurfaces = list(/turf/simulated/floor,/turf/simulated/wall)

/obj/item/toy/crayon/spraycan/suicide_act(mob/user)
	var/mob/living/carbon/human/H = user
	if(capped)
		user.visible_message("<span class='suicide'>[user] shakes up the [src] with a rattle and lifts it to their mouth, but nothing happens! Maybe they should have uncapped it first! Nonetheless--</span>")
		user.say("MEDIOCRE!!")
	else
		user.visible_message("<span class='suicide'>[user] shakes up the [src] with a rattle and lifts it to their mouth, spraying silver paint across their teeth!</span>")
		user.say("WITNESS ME!!")
		playsound(loc, 'sound/effects/spray.ogg', 5, 1, 5)
		colour = "#C0C0C0"
		update_icon()
		H.lip_style = "spray_face"
		H.lip_color = colour
		H.update_body()
		uses = max(0, uses - 10)
	return (OXYLOSS)
/obj/item/toy/crayon/spraycan/New()
	..()
	name = "spray can"
	colour = pick("#DA0000","#FF9300","#FFF200","#A8E61D","#00B7EF","#DA00FF")
	update_icon()
/obj/item/toy/crayon/spraycan/examine(mob/user)
	..()
	if(uses)
		user << "It has [uses] uses left."
	else
		user << "It is empty."
/obj/item/toy/crayon/spraycan/attack_self(mob/living/user)
	var/choice = input(user,"Spraycan options") as null|anything in list("Toggle Cap","Change Drawing","Change Color")
	switch(choice)
		if("Toggle Cap")
			user << "<span class='notice'>You [capped ? "Remove" : "Replace"] the cap of the [src]</span>"
			capped = capped ? 0 : 1
			icon_state = "spraycan[capped ? "_cap" : ""]"
			update_icon()
		if("Change Drawing")
			..()
		if("Change Color")
			colour = input(user,"Choose Color") as color
			update_icon()
/obj/item/toy/crayon/spraycan/afterattack(atom/target, mob/user, proximity)
	if(!proximity)
		return
	if(capped)
		user << "<span class='warning'>Take the cap off first!</span>"
		return
	else
		if(iscarbon(target))
			if(uses)
				playsound(user.loc, 'sound/effects/spray.ogg', 5, 1, 5)
				var/mob/living/carbon/human/C = target
				user.visible_message("<span class='danger'>[user] sprays [src] into the face of [target]!</span>")
				target << "<span class='userdanger'>[user] sprays [src] into your face!</span>"
				if(C.client)
					C.eye_blurry = max(C.eye_blurry, 3)
					C.eye_blind = max(C.eye_blind, 1)
					if(C.check_eye_prot() <= 0) // no eye protection? ARGH IT BURNS.
						C.confused = max(C.confused, 3)
						C.Weaken(3)
				C.lip_style = "spray_face"
				C.lip_color = colour
				C.update_body()
				uses = max(0,uses-10)
		..()
/obj/item/toy/crayon/spraycan/update_icon()
	overlays.Cut()
	var/image/I = image('icons/obj/crayons.dmi',icon_state = "[capped ? "spraycan_cap_colors" : "spraycan_colors"]")
	I.color = colour
	overlays += I