/datum/job/civilian
	title = "Civilian"
	flag = CIVILIAN
	department_flag = SUPPORT
	faction = "Station"
	total_positions = -1
	spawn_positions = -1
	supervisors = "the mayor and government"
	selection_color = "#dddddd"
	access = list()			//See /datum/job/civilian/get_access()
	minimal_access = list()	//See /datum/job/civilian/get_access()


/datum/job/civilian/equip(var/mob/living/carbon/human/H)
	if(!H)	return 0
	H.equip_to_slot_or_del(new /obj/item/clothing/under/civilian(H), slot_w_uniform)
	H.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(H), slot_shoes)
	if(H.backbag == 1)
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H), slot_r_hand)
	else
		H.equip_to_slot_or_del(new /obj/item/weapon/storage/box/survival(H.back), slot_in_backpack)
	return 1

/datum/job/civilian/get_access()
	if(config.civilian_maint)
		return list(access_maint_tunnels)
	else
		return list()
