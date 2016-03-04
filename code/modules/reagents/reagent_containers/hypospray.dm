////////////////////////////////////////////////////////////////////////////////
/// HYPOSPRAY
////////////////////////////////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/hypospray
	name = "hypospray"
	desc = "The DeForest Medical Corporation hypospray is a sterile, air-needle autoinjector for rapid administration of drugs to patients."
	icon = 'icons/obj/syringe.dmi'
	item_state = "hypo"
	icon_state = "hypo"
	amount_per_transfer_from_this = 5
	volume = 30
	possible_transfer_amounts = null
	flags = OPENCONTAINER
	slot_flags = SLOT_BELT
	var/ignore_flags = 0
	list_reagents = list("tricordrazine" = 30)
	unacidable = 1

/obj/item/weapon/reagent_containers/hypospray/attack(mob/living/M, mob/user)
	if(!reagents.total_volume)
		user << "<span class='warning'>[src] is empty!</span>"
		return
	if(!istype(M))
		return

	if(reagents.total_volume && (ignore_flags || M.can_inject(user, 1))) // Ignore flag should be checked first or there will be an error message.
		M << "<span class='warning'>You feel a tiny prick!</span>"
		user << "<span class='notice'>You inject [M] with [src].</span>"

		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)
		reagents.reaction(M, INGEST, fraction)
		if(M.reagents)
			var/list/injected = list()
			for(var/datum/reagent/R in reagents.reagent_list)
				injected += R.name

			var/trans = reagents.trans_to(M, amount_per_transfer_from_this)
			user << "<span class='notice'>[trans] unit\s injected.  [reagents.total_volume] unit\s remaining in [src].</span>"

			var/contained = english_list(injected)

			add_logs(user, M, "injected", src, "([contained])")
			msg_admin_attack("[user.name] ([user.ckey]) injected [M.name] ([M.key]) with [src.name]. Reagents: [contained] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

/obj/item/weapon/reagent_containers/hypospray/autoinjector
	name = "autoinjector"
	desc = "A rapid and safe way to administer small amounts of drugs by untrained or trained personnel."
	icon_state = "autoinjector"
	item_state = "autoinjector"
	amount_per_transfer_from_this = 10
	volume = 10
	list_reagents = list("inaprovaline" = 10)
	ignore_flags = 1 //so you can autoinject through hardsuits

/obj/item/weapon/reagent_containers/hypospray/autoinjector/New()
	..()
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/attack(mob/M as mob, mob/user as mob)
	..()
	if(reagents.total_volume <= 0) //Prevents autoinjectors to be refilled.
		flags &= ~OPENCONTAINER
	update_icon()
	return

/obj/item/weapon/reagent_containers/hypospray/autoinjector/update_icon()
	if(reagents.total_volume > 0)
		icon_state = "[initial(icon_state)]1"
	else
		icon_state = "[initial(icon_state)]0"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/examine(mob/user)
	..()
	if(reagents && reagents.reagent_list.len)
		usr << "<span class='notice'>It is currently loaded.</span>"
	else
		usr << "<span class='notice'>It is spent.</span>"

/obj/item/weapon/reagent_containers/hypospray/autoinjector/stimpack //goliath kiting
	name = "stimpack medipen"
	desc = "A rapid way to stimulate your body's adrenaline, allowing for freer movement in restrictive armor."
	icon_state = "stimpen"
	volume = 20
	amount_per_transfer_from_this = 20
	list_reagents = list("ephedrine" = 10, "coffee" = 10)

/obj/item/weapon/reagent_containers/hypospray/autoinjector/morphine
	name = "morphine medipen"
	desc = "A rapid way to get you out of a tight situation and fast! You'll feel rather drowsy, though."
	list_reagents = list("morphine" = 10)