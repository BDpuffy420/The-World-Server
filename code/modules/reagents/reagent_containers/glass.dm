
////////////////////////////////////////////////////////////////////////////////
/// (Mixing)Glass.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/glass
	name = "glass"
	desc = " "
	var/base_name = " "
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10, 15, 25, 30, 50)
	volume = 60
	flags = OPENCONTAINER
	spillable = 1
	unacidable = 1
	var/label_text = ""

	can_be_placed_into = list(
		/obj/machinery/chem_master/,
		/obj/machinery/chem_dispenser/,
//		/obj/machinery/chem_heater/,
		/obj/machinery/reagentgrinder,
		/obj/machinery/atmospherics/unary/cryo_cell,
		/obj/machinery/dna_scannernew,
		/obj/machinery/bot/medbot,
		/obj/machinery/computer/pandemic,
		/obj/machinery/iv_drip,
		/obj/machinery/disease2/incubator,
		/obj/machinery/disposal,
		/obj/machinery/apiary,
		/obj/machinery/computer/centrifuge,
		/obj/machinery/sleeper,
		/obj/machinery/smartfridge/,
		/obj/machinery/biogenerator,
		/obj/machinery/constructable_frame,
		/obj/structure/table,
		/obj/structure/closet,
		/obj/structure/sink,
		/obj/item/weapon/storage,
		/obj/item/weapon/grenade/chem_grenade,
		/obj/item/weapon/storage/secure/safe,
		/mob/living/simple_animal/cow,
		/mob/living/simple_animal/hostile/retaliate/goat,
		)


/obj/item/weapon/reagent_containers/glass/New()
	..()
	base_name = name

/obj/item/weapon/reagent_containers/glass/examine(mob/user)
	if(!..(user, 2))
		return
	if(reagents && reagents.reagent_list.len)
		user << "<span class='notice'>It contains [src.reagents.total_volume] units of liquid.</span>"
	else
		user << "<span class='notice'>It is empty.</span>"
	if (!is_open_container())
		user << "<span class='notice'>Airtight lid seals it completely.</span>"

/obj/item/weapon/reagent_containers/glass/attack(mob/M, mob/user, obj/target)
	if(!canconsume(M, user))
		return

	if(!spillable)
		return

	if(!reagents || !reagents.total_volume)
		user << "<span class='warning'>[src] is empty!</span>"
		return

	if(istype(M))
		if(user.a_intent == "hurt")
			var/R
			M.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [M]!</span>", \
							"<span class='userdanger'>[user] splashes the contents of [src] onto [M]!</span>")
			if(reagents)
				for(var/datum/reagent/A in reagents.reagent_list)
					R += A.id + " ("
					R += num2text(A.volume) + "),"
			reagents.reaction(M, TOUCH)
			add_logs(user, M, "splashed with reagents([reagentlist(src)])")
			msg_admin_attack("[user.name] ([user.ckey]) splashed [M.name] ([M.key]) with [src.name]. Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

			reagents.clear_reagents()
		else
			if(M != user)

				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(H.species.flags & IS_SYNTHETIC)
						user << "<span class='warning'>They have a monitor for a head, where do you think you're going to put that?</span>"
						return

				M.visible_message("<span class='danger'>[user] attempts to feed something to [M].</span>", \
							"<span class='userdanger'>[user] attempts to feed something to you.</span>")
				if(!do_mob(user, M))
					return
				if(!reagents || !reagents.total_volume)
					return // The drink might be empty after the delay, such as by spam-feeding
				M.visible_message("<span class='danger'>[user] feeds something to [M].</span>", "<span class='userdanger'>[user] feeds something to you.</span>")
				add_logs(user, M, "fed", reagentlist(src))
			else
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = M
					if(H.species.flags & IS_SYNTHETIC)
						H << "<span class='warning'>You have a monitor for a head, where do you think you're going to put that?</span>"
						return

				user << "<span class='notice'>You swallow a gulp of [src].</span>"
			var/fraction = min(5/reagents.total_volume, 1)
			reagents.reaction(M, INGEST, fraction)
			spawn(5)
				reagents.trans_to(M, 5)
			playsound(M.loc,'sound/items/drink.ogg', rand(10,50), 1)

/obj/item/weapon/reagent_containers/glass/attack_self()
	..()
	if (is_open_container())
		usr << "<span class='notice'>You put the lid on \the [src].</span>"
		flags ^= OPENCONTAINER
	else
		usr << "<span class='notice'>You take the lid off \the [src].</span>"
		flags |= OPENCONTAINER
	update_icon()

/obj/item/weapon/reagent_containers/glass/afterattack(obj/target, mob/user, flag, proximity)

	if (!is_open_container() || !flag)	return

	if((!proximity) || !check_allowed_items(target,target_self=1)) return

	else if(istype(target, /obj/structure/reagent_dispensers)) //A dispenser. Transfer FROM it TO us.
		target.add_fingerprint(user)
		if(target.reagents && !target.reagents.total_volume)
			user << "<span class='warning'>[target] is empty and can't be refilled!</span>"
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			user << "<span class='notice'>[src] is full.</span>"
			return

		var/trans = target.reagents.trans_to(src, target:amount_per_transfer_from_this)
		user << "<span class='notice'>You fill [src] with [trans] unit\s of the contents of [target].</span>"
		user.changeNext_move(CLICK_CD_FILL) //to make filling up a container quicker.

	else if(target.is_open_container() && target.reagents) //Something like a glass. Player probably wants to transfer TO it.
		if(!reagents.total_volume)
			user << "<span class='warning'>[src] is empty!</span>"
			return

		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			user << "<span class='notice'>[target] is full.</span>"
			return


		var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
		user << "<span class='notice'>You transfer [trans] unit\s of the solution to [target].</span>"
		user.changeNext_move(CLICK_CD_FILL)

	else if(istype(target, /obj/machinery/bunsen_burner))
		return

	else if(istype(target, /obj/machinery/smartfridge))
		return

	else if(istype(target, /obj/machinery/radiocarbon_spectrometer))
		return

	else if(istype(target, /obj/machinery/fishtank)) //stop splashing it on stuff and gimme some of that delicious fishwater
		return

	else if(istype(target, /obj/effect/decal/cleanable)) //stops splashing while scooping up fluids
		return

	else if(reagents.total_volume)
		if(user.a_intent == "hurt")
			user.visible_message("<span class='danger'>[user] splashes the contents of [src] onto [target]!</span>", \
								"<span class='notice'>You splash the contents of [src] onto [target].</span>")
			reagents.reaction(target, TOUCH)
			reagents.clear_reagents()

/obj/item/weapon/reagent_containers/glass/attackby(obj/item/I, mob/user, params)
	//| Labeling
	if(istype(I, /obj/item/weapon/pen) || istype(I, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitize(copytext(input(user, "Enter a label for [src.name]","Label",src.label_text), 1, MAX_NAME_LEN))
		if(length(tmp_label) > 10)
			user << "<span class='warning'>The label can be at most 10 characters long.</span>"
		else
			user << "<span class='notice'>You set the label to \"[tmp_label]\".</span>"
			src.label_text = tmp_label
			src.update_name_label()

	if(istype(I, /obj/item/clothing/mask/cigarette)) //ciggies are weird
		return
	var/hotness = is_hot(I)
	if(hotness)
		var/added_heat = (hotness / 100) //ishot returns a temperature
		if(reagents)
			if(reagents.chem_temp < hotness) //can't be heated to be hotter than the source
				reagents.chem_temp += added_heat
				user << "<span class='notice'>You heat [src] with [I].</span>"
				reagents.handle_reactions()
			else
				user << "<span class='warning'>[src] is already hotter than [I]!</span>"

	if(istype(I,/obj/item/weapon/reagent_containers/food/snacks/egg)) //breaking eggs
		var/obj/item/weapon/reagent_containers/food/snacks/egg/E = I
		if(reagents)
			if(reagents.total_volume >= reagents.maximum_volume)
				user << "<span class='notice'>[src] is full.</span>"
			else
				user << "<span class='notice'>You break [E] in [src].</span>"
				reagents.add_reagent("eggyolk", 5)
				qdel(E)
			return
	..()

/obj/item/weapon/reagent_containers/glass/proc/update_name_label()
	if(src.label_text == "")
		src.name = src.base_name
	else
		src.name = "[src.base_name] ([src.label_text])"

/obj/item/weapon/reagent_containers/glass/beaker
	name = "beaker"
	desc = "A beaker."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "beaker"
	item_state = "beaker"
	materials = list(MAT_GLASS=500)

/obj/item/weapon/reagent_containers/glass/beaker/New()
	..()
	desc += " Can hold up to [volume] units."
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/update_icon()
	overlays.Cut()

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]10")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent)
			if(0 to 9)		filling.icon_state = "[icon_state]-10"
			if(10 to 24) 	filling.icon_state = "[icon_state]10"
			if(25 to 49)	filling.icon_state = "[icon_state]25"
			if(50 to 74)	filling.icon_state = "[icon_state]50"
			if(75 to 79)	filling.icon_state = "[icon_state]75"
			if(80 to 90)	filling.icon_state = "[icon_state]80"
			if(91 to INFINITY)	filling.icon_state = "[icon_state]100"

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/weapon/reagent_containers/glass/beaker/large
	name = "large beaker"
	desc = "A large beaker."
	icon_state = "beakerlarge"
	materials = list(MAT_GLASS=2500)
	volume = 100
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,50,100)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/noreact
	name = "cryostasis beaker"
	desc = "A cryostasis beaker that allows for chemical storage without reactions."
	icon_state = "beakernoreact"
	materials = list(MAT_GLASS=500)
	volume = 50
	amount_per_transfer_from_this = 10
	flags = OPENCONTAINER | NOREACT

/obj/item/weapon/reagent_containers/glass/beaker/bluespace
	name = "bluespace beaker"
	desc = "A bluespace beaker, powered by experimental bluespace technology."
	icon_state = "beakerbluespace"
	materials = list(MAT_GLASS=5000)
	volume = 300
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30,60,120,300)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/vial
	name = "vial"
	desc = "A small glass vial."
	icon_state = "vial"
	materials = list(MAT_GLASS=250)
	volume = 30
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25)
	flags = OPENCONTAINER

/obj/item/weapon/reagent_containers/glass/beaker/cryoxadone
	list_reagents = list("cryoxadone" = 30)

/obj/item/weapon/reagent_containers/glass/beaker/sulphuric
	list_reagents = list("sacid" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/slime
	list_reagents = list("slimejelly" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/large/styptic
	name = "styptic reserve tank"
	list_reagents = list("styptic_powder" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/large/silver_sulfadiazine
	name = "silver sulfadiazine reserve tank"
	list_reagents = list("silver_sulfadiazine" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/large/charcoal
	name = "antitoxin reserve tank"
	list_reagents = list("charcoal" = 50)

/obj/item/weapon/reagent_containers/glass/beaker/large/epinephrine
	name = "epinephrine reserve tank"
	list_reagents = list("epinephrine" = 50)

/obj/item/weapon/reagent_containers/glass/bucket
	name = "bucket"
	desc = "It's a bucket."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "bucket"
	item_state = "bucket"
	materials = list(MAT_METAL=200)
	w_class = 3
	amount_per_transfer_from_this = 20
	possible_transfer_amounts = list(10,20,30,50,100)
	volume = 100
	flags = OPENCONTAINER
	unacidable = 0

/obj/item/weapon/reagent_containers/glass/bucket/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/weapon/mop))
		if(reagents.total_volume < 1)
			user << "<span class='warning'>[src] is out of water!</span>"
		else
			reagents.trans_to(O, 5)
			user << "<span class='notice'>You wet [O] in [src].</span>"
			playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
	else if(isprox(O))
		user << "<span class='notice'>You add [O] to [src].</span>"
		qdel(O)
		user.unEquip(src)
		qdel(src)
		user.put_in_hands(new /obj/item/weapon/bucket_sensor)
	else
		..()

/obj/item/weapon/reagent_containers/glass/bucket/update_icon()
	overlays.Cut()

	if (!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid