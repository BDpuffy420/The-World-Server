//Procedures in this file: Eye mending surgery
//////////////////////////////////////////////////////////////////
//						EYE SURGERY							//
//////////////////////////////////////////////////////////////////

/datum/surgery_step/eye
	priority = 2
	can_infect = 1
	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		if (!hasorgans(target))
			return 0
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		if (!affected)
			return 0

		var/obj/item/organ/eyes = target.internal_organs_by_name["eyes"]

		return target_zone == "eyes" && eyes

/datum/surgery_step/eye/cut_open
	allowed_tools = list(
	/obj/item/weapon/scalpel = 100,		\
	/obj/item/weapon/kitchenknife = 75,	\
	/obj/item/weapon/shard = 50, 		\
	)

	min_duration = 90
	max_duration = 110

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts to separate the corneas on [target]'s eyes with \the [tool].", \
		"You start to separate the corneas on [target]'s eyes with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has separated the corneas on [target]'s eyes with \the [tool].</span>" , \
		"<span class='notice'>You have separated the corneas on [target]'s eyes with \the [tool].</span>",)
		target.op_stage.eyes = 1
		target.blinded += 1.5

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/eyes/eyes = target.internal_organs_by_name["eyes"]
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user]'s hand slips, slicing [target]'s eyes wth \the [tool]!</span>" , \
		"<span class='danger'>Your hand slips, slicing [target]'s eyes wth \the [tool]!</span>" )
		affected.createwound(CUT, 10)
		eyes.take_damage(5, 0)

/datum/surgery_step/eye/lift_eyes
	allowed_tools = list(
	/obj/item/weapon/retractor = 100,	\
	/obj/item/weapon/kitchen/utensil/fork = 50
	)

	min_duration = 30
	max_duration = 40

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.eyes == 1

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts lifting corneas from [target]'s eyes with \the [tool].", \
		"You start lifting corneas from [target]'s eyes with \the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] has lifted the corneas from [target]'s eyes from with \the [tool].</span>" , \
		"<span class='notice'>You has lifted the corneas from [target]'s eyes from with \the [tool].</span>" )
		target.op_stage.eyes = 2

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/eyes/eyes = target.internal_organs_by_name["eyes"]
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user]'s hand slips, damaging [target]'s eyes with \the [tool]!</span>", \
		"<span class='danger'>Your hand slips, damaging [target]'s eyes with \the [tool]!</span>")
		target.apply_damage(10, BRUTE, affected)
		eyes.take_damage(5, 0)

/datum/surgery_step/eye/mend_eyes
	allowed_tools = list(
	/obj/item/weapon/hemostat = 100, 	\
	/obj/item/stack/cable_coil = 75, 	\
	/obj/item/device/assembly/mousetrap = 10	//I don't know. Don't ask me. But I'm leaving it because hilarity.
	)

	min_duration = 80
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..() && target.op_stage.eyes == 2

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] starts mending the nerves and lenses in [target]'s eyes with \the [tool].", \
		"You start mending the nerves and lenses in [target]'s eyes with the [tool].")
		..()

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("<span class='notice'>[user] mends the nerves and lenses in [target]'s with \the [tool].</span>" ,	\
		"<span class='notice'>You mend the nerves and lenses in [target]'s with \the [tool].</span>")
		target.op_stage.eyes = 3

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/eyes/eyes = target.internal_organs_by_name["eyes"]
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user]'s hand slips, stabbing \the [tool] into [target]'s eye!</span>", \
		"<span class='danger'>Your hand slips, stabbing \the [tool] into [target]'s eye!</span>")
		target.apply_damage(10, BRUTE, affected, sharp=1)
		eyes.take_damage(5, 0)

/datum/surgery_step/eye/cauterize
	allowed_tools = list(
	/obj/item/weapon/cautery = 100,			\
	/obj/item/clothing/mask/cigarette = 75,	\
	/obj/item/weapon/lighter = 50,			\
	/obj/item/weapon/weldingtool = 25
	)

	min_duration = 70
	max_duration = 100

	can_use(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		return ..()

	begin_step(mob/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		user.visible_message("[user] is beginning to cauterize the incision around [target]'s eyes with \the [tool]." , \
		"You are beginning to cauterize the incision around [target]'s eyes with \the [tool].")

	end_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/eyes/eyes = target.internal_organs_by_name["eyes"]
		user.visible_message("<span class='notice'>[user] cauterizes the incision around [target]'s eyes with \the [tool].</span>", \
		"<span class='notice'>You cauterize the incision around [target]'s eyes with \the [tool].</span>")
		if (target.op_stage.eyes == 3)
			target.disabilities &= ~NEARSIGHTED
			target.sdisabilities &= ~BLIND
			eyes.damage = 0
		target.op_stage.eyes = 0

	fail_step(mob/living/user, mob/living/carbon/human/target, target_zone, obj/item/tool)
		var/obj/item/organ/eyes/eyes = target.internal_organs_by_name["eyes"]
		var/obj/item/organ/external/affected = target.get_organ(target_zone)
		user.visible_message("<span class='danger'>[user]'s hand slips,  searing [target]'s eyes with \the [tool]!</span>", \
		"<span class='danger'>Your hand slips, searing [target]'s eyes with \the [tool]!</span>")
		target.apply_damage(5, BURN, affected)
		eyes.take_damage(5, 0)