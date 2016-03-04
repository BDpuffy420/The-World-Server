
/obj/item/weapon/reagent_containers/robodropper
	name = "industrial dropper"
	desc = "A larger dropper. Transfers 10 units."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "dropper0"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(1,2,3,4,5,6,7,8,9,10)
	volume = 10
	unacidable = 1

/obj/item/weapon/reagent_containers/robodropper/afterattack(obj/target, mob/user , proximity)
	if(!proximity) return
	if(!target.reagents) return


	if(reagents.total_volume > 0)
		if(target.reagents.total_volume >= target.reagents.maximum_volume)
			user << "<span class='notice'>[target] is full.</span>"
			return

		if(!target.is_open_container() && !ismob(target) && !istype(target,/obj/item/weapon/reagent_containers/food) && !istype(target, /obj/item/clothing/mask/cigarette)) //You can inject humans and food but you cant remove the shit.
			user << "<span class='warning'>You cannot directly fill [target]!</span>"
			return

		var/trans = 0
		var/fraction = min(amount_per_transfer_from_this/reagents.total_volume, 1)

		if(ismob(target))

			if(target == user)
				if(istype(target, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = target
					if(H.species.flags & IS_SYNTHETIC)
						user << "<span class='warning'>You have a monitor for a head, where do you think you're going to put that?</span>"
						return 0

				target << ("<span class='notice'>You squirt the solution into your eyes.</span>")

			else
				if(istype(target, /mob/living/carbon/human))
					var/mob/living/carbon/human/H = target
					if(H.species.flags & IS_SYNTHETIC)
						user << "<span class='warning'>They have a monitor for a head, where do you think you're going to put that?</span>"
						return 0

				var/time = 20 //2/3rds the time of a syringe
				target.visible_message("<span class='danger'>[user] is trying to squirt something into [target]'s eyes!</span>", \
										"<span class='userdanger'>[user] is trying to squirt something into [target]'s eyes!</span>")

				if(!do_mob(user, target, time)) return

				if(istype(target , /mob/living/carbon/human))
					var/mob/living/carbon/human/victim = target

					var/obj/item/safe_thing = null
					if(victim.wear_mask)
						if(victim.wear_mask.flags & MASKCOVERSEYES)
							safe_thing = victim.wear_mask
					if(victim.head)
						if(victim.head.flags & MASKCOVERSEYES)
							safe_thing = victim.head
					if(victim.glasses)
						if(!safe_thing)
							safe_thing = victim.glasses

					if(safe_thing)
						if(!safe_thing.reagents)
							safe_thing.create_reagents(100)

						reagents.reaction(safe_thing, TOUCH, fraction)
						trans = reagents.trans_to(safe_thing, amount_per_transfer_from_this)

						target.visible_message("<span class='danger'>[user] tries to squirt something into [target]'s eyes, but fails!</span>", \
												"<span class='userdanger'>[user] tries to squirt something into [target]'s eyes, but fails!</span>")

						user << "<span class='notice'>You transfer [trans] unit\s of the solution.</span>"
						update_icon()
						return

				target.visible_message("<span class='danger'>[user] squirts something into [target]'s eyes!</span>", \
										"<span class='userdanger'>[user] squirts something into [target]'s eyes!</span>")

				var/mob/M = target
				var/R
				if(reagents)
					for(var/datum/reagent/A in src.reagents.reagent_list)
						R += A.id + " ("
						R += num2text(A.volume) + "),"
				add_logs(user, M, "squirted", R)
				msg_admin_attack("[user.name] ([user.ckey]) squirted [M.name] ([M.key]) with [src.name]. Reagents: [R] (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		reagents.reaction(target, TOUCH, fraction)
		trans = src.reagents.trans_to(target, amount_per_transfer_from_this)
		user << "<span class='notice'>You transfer [trans] unit\s of the solution.</span>"
		update_icon()

	else

		if(!target.is_open_container() && !istype(target,/obj/structure/reagent_dispensers))
			user << "<span class='notice'>You cannot directly remove reagents from [target].</span>"
			return

		if(!target.reagents.total_volume)
			user << "<span class='warning'>[target] is empty!</span>"
			return

		var/trans = target.reagents.trans_to(src, amount_per_transfer_from_this)

		user << "<span class='notice'>You fill [src] with [trans] unit\s of the solution.</span>"

		update_icon()


/obj/item/weapon/reagent_containers/robodropper/update_icon()
	overlays.Cut()
	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "dropper")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		overlays += filling