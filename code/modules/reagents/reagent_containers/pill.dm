////////////////////////////////////////////////////////////////////////////////
/// Pills.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/pill
	name = "pill"
	desc = "A tablet or capsule."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "pill"
	item_state = "pill"
	possible_transfer_amounts = null
	volume = 50
	var/apply_type = INGEST
	var/apply_method = "swallow"
	var/roundstart = 0

/obj/item/weapon/reagent_containers/pill/New()
	..()
	if(!icon_state)
		icon_state = "pill[rand(1,20)]"
	if(reagents.total_volume && roundstart)
		name += " ([reagents.total_volume]u)"

/obj/item/weapon/reagent_containers/pill/attack_self(mob/user)
	return


/obj/item/weapon/reagent_containers/pill/attack(mob/M, mob/user, def_zone)
	if(!canconsume(M, user))
		return 0

	if(M == user)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				H << "<span class='warning'>You have a monitor for a head, where do you think you're going to put that?</span>"
				return 0

		M << "<span class='notice'>You [apply_method] [src].</span>"

	else
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				H << "<span class='warning'>They have a monitor for a head, where do you think you're going to put that?</span>"
				return

		M.visible_message("<span class='danger'>[user] attempts to force [M] to [apply_method] [src].</span>", \
							"<span class='userdanger'>[user] attempts to force [M] to [apply_method] [src].</span>")

		if(!do_mob(user, M)) return 0

		M.visible_message("<span class='danger'>[user] forces [M] to [apply_method] [src].</span>", \
							"<span class='userdanger'>[user] forces [M] to [apply_method] [src].</span>")

	user.unEquip(src) //icon update
	add_logs(user, M, "fed", reagentlist(src))
	msg_admin_attack("[user.name] ([user.ckey]) fed [M.name] ([M.ckey]) with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	loc = M //Put the pill inside the mob. This fixes the issue where the pill appears to drop to the ground after someone eats it.

	if(reagents.total_volume)
		reagents.reaction(M, apply_type)
		reagents.trans_to_ingest(M, reagents.total_volume)
		qdel(src)
		return 1
	else
		qdel(src)
		return 1
	return 0

/obj/item/weapon/reagent_containers/pill/afterattack(obj/target, mob/user , proximity)
	if(!proximity) return
	if(target.is_open_container() != 0 && target.reagents)
		if(!target.reagents.total_volume)
			user << "<span class='warning'>[target] is empty! There's nothing to dissolve [src] in.</span>"
			return
		user << "<span class='notice'>You dissolve [src] in [target].</span>"
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Spiked \a [target] with a pill. Reagents: [reagentlist(src)]</font>")
		msg_admin_attack("[user.name] ([user.ckey]) spiked \a [target] with a pill. Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		for(var/mob/O in viewers(2, user))	//viewers is necessary here because of the small radius
			O << "<span class='warning'>[user] slips something into [target]!</span>"
		reagents.trans_to(target, reagents.total_volume)
		spawn(5)
			qdel(src)


////////////////////////////////////////////////////////////////////////////////
/// Pills. END
////////////////////////////////////////////////////////////////////////////////

//Pills
/obj/item/weapon/reagent_containers/pill/antitox
	name = "Anti-toxins pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	roundstart = 1
	list_reagents = list("antitoxin" = 25)
/obj/item/weapon/reagent_containers/pill/tox
	name = "Toxins pill"
	desc = "Highly toxic."
	icon_state = "pill5"
	roundstart = 1
	list_reagents = list("toxin" = 50)
/obj/item/weapon/reagent_containers/pill/cyanide
	name = "Cyanide pill"
	desc = "Don't swallow this."
	icon_state = "pill5"
	roundstart = 1
	list_reagents = list("cyanide" = 50)
/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "Adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	roundstart = 1
	list_reagents = list("adminordrazine" = 50)
/obj/item/weapon/reagent_containers/pill/stox
	name = "Sleeping pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	roundstart = 1
	list_reagents = list("stoxin" = 15)
/obj/item/weapon/reagent_containers/pill/kelotane
	name = "Kelotane pill"
	desc = "Used to treat burns."
	icon_state = "pill11"
	roundstart = 1
	list_reagents = list("kelotane" = 15)
/obj/item/weapon/reagent_containers/pill/paracetamol
	name = "Paracetamol pill"
	desc = "Tylenol! A painkiller for the ages. Chewables!"
	icon_state = "pill8"
	roundstart = 1
	list_reagents = list("paracetamol" = 15)
/obj/item/weapon/reagent_containers/pill/tramadol
	name = "Tramadol pill"
	desc = "A simple painkiller."
	icon_state = "pill8"
	roundstart = 1
	list_reagents = list("tramadol" = 15)
/obj/item/weapon/reagent_containers/pill/methylphenidate
	name = "Methylphenidate pill"
	desc = "Improves the ability to concentrate."
	icon_state = "pill8"
	roundstart = 1
	list_reagents = list("methylphenidate" = 15)
/obj/item/weapon/reagent_containers/pill/citalopram
	name = "Citalopram pill"
	desc = "Mild anti-depressant."
	icon_state = "pill8"
	roundstart = 1
	list_reagents = list("citalopram" = 15)
/obj/item/weapon/reagent_containers/pill/inaprovaline
	name = "Inaprovaline pill"
	desc = "Used to stabilize patients."
	icon_state = "pill20"
	roundstart = 1
	list_reagents = list("inaprovaline" = 30)
/obj/item/weapon/reagent_containers/pill/dexalin
	name = "Dexalin pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill16"
	roundstart = 1
	list_reagents = list("dexalin" = 15)
/obj/item/weapon/reagent_containers/pill/bicaridine
	name = "Bicaridine pill"
	desc = "Used to treat physical injuries."
	icon_state = "pill18"
	roundstart = 1
	list_reagents = list("bicaridine" = 20)
/obj/item/weapon/reagent_containers/pill/happy
	name = "Happy pill"
	desc = "Happy happy joy joy!"
	icon_state = "pill18"
	list_reagents = list("space_drugs" = 15, "sugar" = 15)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/zoom
	name = "Zoom pill"
	desc = "Zoooom!"
	icon_state = "pill18"
	list_reagents = list("hyperzine" = 5, "synaptizine" = 5, "impedrezene" = 10)
	roundstart = 1

//New Pills
/obj/item/weapon/reagent_containers/pill/adminordrazine
	name = "adminordrazine pill"
	desc = "It's magic. We don't have to explain it."
	icon_state = "pill16"
	list_reagents = list("adminordrazine" = 50)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/morphine
	name = "morphine pill"
	desc = "Commonly used to treat insomnia."
	icon_state = "pill8"
	list_reagents = list("morphine" = 30)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/stimulant
	name = "stimulant pill"
	desc = "Often taken by overworked employees, athletes, and the inebriated. You'll snap to attention immediately!"
	icon_state = "pill19"
	list_reagents = list("ephedrine" = 10, "antihol" = 10, "coffee" = 30)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/salbutamol
	name = "salbutamol pill"
	desc = "Used to treat oxygen deprivation."
	icon_state = "pill18"
	list_reagents = list("salbutamol" = 30)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/charcoal
	name = "antitoxin pill"
	desc = "Neutralizes many common toxins."
	icon_state = "pill17"
	list_reagents = list("charcoal" = 50)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/epinephrine
	name = "epinephrine pill"
	desc = "Used to stabilize patients."
	icon_state = "pill5"
	list_reagents = list("epinephrine" = 15)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/mannitol
	name = "mannitol pill"
	desc = "Used to treat brain damage."
	icon_state = "pill17"
	list_reagents = list("mannitol" = 50)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/mutadone
	name = "mutadone pill"
	desc = "Used to treat genetic damage."
	icon_state = "pill20"
	list_reagents = list("mutadone" = 50)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/salicyclic
	name = "salicylic acid pill"
	desc = "Used to dull pain."
	icon_state = "pill5"
	list_reagents = list("sal_acid" = 24)
	roundstart = 1
/obj/item/weapon/reagent_containers/pill/oxandrolone
	name = "oxandrolone pill"
	desc = "Used to stimulate burn healing."
	icon_state = "pill5"
	list_reagents = list("oxandrolone" = 24)
	roundstart = 1

/obj/item/weapon/reagent_containers/pill/insulin
	name = "insulin pill"
	desc = "Handles hyperglycaemic coma."
	icon_state = "pill5"
	list_reagents = list("insulin" = 50)
	roundstart = 1
