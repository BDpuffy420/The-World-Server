/obj/item/weapon/deskbell
	name = "desk bell"
	desc = "An annoying bell. Ring for service."
	icon = 'icons/obj/objects.dmi'
	icon_state = "deskbell"
	force = 2
	throwforce = 2
	w_class = 2.0
	attack_verb = list("annoyed")

/obj/item/weapon/deskbell/MouseDrop(atom/over_object)
	var/mob/M = usr
	if(M.restrained() || M.stat || !Adjacent(M))
		return

	if(over_object == M)
		M.put_in_hands(src)

	else if(istype(over_object, /obj/screen))
		switch(over_object.name)
			if("r_hand")
				if(!remove_item_from_storage(M))
					M.unEquip(src)
				M.put_in_r_hand(src)
			if("l_hand")
				if(!remove_item_from_storage(M))
					M.unEquip(src)
				M.put_in_l_hand(src)

	add_fingerprint(M)

/obj/item/weapon/deskbell/attack(mob/target as mob, mob/living/user as mob)
	playsound(loc, 'sound/effects/deskbell.ogg', 100, 1, -1)
	..()

/obj/item/weapon/deskbell/attack_hand(mob/user as mob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			H << "<span class='notice'>You try to move your [temp.name], but cannot!"
			return

	if(user.a_intent == "hurt")
		playsound(user.loc, 'sound/effects/deskbell_rude.ogg', 50, 1)
	else
		playsound(user.loc, 'sound/effects/deskbell.ogg', 50, 1)

	add_fingerprint(user)
	return


/obj/item/weapon/deskbell/attackby(obj/item/i as obj, mob/user as mob, params)
	if(!istype(i))
		return
	playsound(user.loc, 'sound/effects/deskbell.ogg', 50, 1)