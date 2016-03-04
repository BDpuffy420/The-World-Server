/proc/random_blood_type()
	return pick(4;"O-", 36;"O+", 3;"A-", 28;"A+", 1;"B-", 20;"B+", 1;"AB-", 5;"AB+")


proc/random_hair_color(var/mob/living/carbon/human/M)
	//Hair colour
	var/r_hair = 0
	var/g_hair = 0
	var/b_hair = 0
	var/hair_color = list(0,0,0)

	var/red
	var/green
	var/blue

	var/col = pick ("blonde", "black", "chestnut", "copper", "brown", "wheat", "punk")
	if(M.age > 70)
		red = rand (100, 255)
		green = red
		blue = red
	else
		switch(col)
			if("blonde")
				red = 255
				green = 255
				blue = 0
			if("black")
				red = 0
				green = 0
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 51
			if("copper")
				red = 255
				green = 153
				blue = 0
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("wheat")
				red = 255
				green = 255
				blue = 153
			if("punk")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_hair = red
	g_hair = green
	b_hair = blue
	hair_color = list(
		r_hair ? r_hair : 0,
		g_hair ? g_hair : 0,
		b_hair ? b_hair : 0
		)

	return hair_color

proc/random_hair_style(gender, species = "Human")
	var/h_style = "Bald"

	var/list/valid_hairstyles = list()
	for(var/hairstyle in hair_styles_list)
		var/datum/sprite_accessory/S = hair_styles_list[hairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue
		valid_hairstyles[hairstyle] = hair_styles_list[hairstyle]

	if(valid_hairstyles.len)
		h_style = pick(valid_hairstyles)

	return h_style

proc/random_facial_hair_style(gender, species = "Human")
	var/f_style = "Shaved"

	var/list/valid_facialhairstyles = list()
	for(var/facialhairstyle in facial_hair_styles_list)
		var/datum/sprite_accessory/S = facial_hair_styles_list[facialhairstyle]
		if(gender == MALE && S.gender == FEMALE)
			continue
		if(gender == FEMALE && S.gender == MALE)
			continue
		if( !(species in S.species_allowed))
			continue

		valid_facialhairstyles[facialhairstyle] = facial_hair_styles_list[facialhairstyle]

	if(valid_facialhairstyles.len)
		f_style = pick(valid_facialhairstyles)

		return f_style

proc/random_name(gender, species = "Human")

	var/datum/species/current_species
	if(species)
		current_species = all_species[species]

	if(!current_species || current_species.name == "Human")
		if(gender==FEMALE)
			return capitalize(pick(first_names_female)) + " " + capitalize(pick(last_names))
		else
			return capitalize(pick(first_names_male)) + " " + capitalize(pick(last_names))
	else
		return current_species.get_random_name(gender)

proc/random_skin_tone()
	switch(pick(60;"caucasian", 15;"afroamerican", 10;"african", 10;"latino", 5;"albino"))
		if("caucasian")		. = -10
		if("afroamerican")	. = -115
		if("african")		. = -165
		if("latino")		. = -55
		if("albino")		. = 34
		else				. = rand(-185,34)
	return min(max( .+rand(-25, 25), -185),34)

proc/random_eye_color()
	var/red
	var/green
	var/blue
	var/eye_color = list(0,0,0)
	//Eye colour
	var/r_eyes = 0
	var/g_eyes = 0
	var/b_eyes = 0

	var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
	switch(col)
		if("black")
			red = 0
			green = 0
			blue = 0
		if("grey")
			red = rand (100, 200)
			green = red
			blue = red
		if("brown")
			red = 102
			green = 51
			blue = 0
		if("chestnut")
			red = 153
			green = 102
			blue = 0
		if("blue")
			red = 51
			green = 102
			blue = 204
		if("lightblue")
			red = 102
			green = 204
			blue = 255
		if("green")
			red = 0
			green = 102
			blue = 0
		if("albino")
			red = rand (200, 255)
			green = rand (0, 150)
			blue = rand (0, 150)

	red = max(min(red + rand (-25, 25), 255), 0)
	green = max(min(green + rand (-25, 25), 255), 0)
	blue = max(min(blue + rand (-25, 25), 255), 0)

	r_eyes = red
	g_eyes = green
	b_eyes = blue

	eye_color = list(
		r_eyes ? r_eyes : 0,
		g_eyes ? g_eyes : 0,
		b_eyes ? b_eyes : 0
		)

	return eye_color

proc/skintone2racedescription(tone)
	switch (tone)
		if(30 to INFINITY)		return "albino"
		if(20 to 30)			return "pale"
		if(5 to 15)				return "light skinned"
		if(-10 to 5)			return "white"
		if(-25 to -10)			return "tan"
		if(-45 to -25)			return "darker skinned"
		if(-65 to -45)			return "brown"
		if(-INFINITY to -65)	return "black"
		else					return "unknown"

proc/age2agedescription(age)
	switch(age)
		if(0 to 1)			return "infant"
		if(1 to 3)			return "toddler"
		if(3 to 13)			return "child"
		if(13 to 19)		return "teenager"
		if(19 to 30)		return "young adult"
		if(30 to 45)		return "adult"
		if(45 to 60)		return "middle-aged"
		if(60 to 70)		return "aging"
		if(70 to INFINITY)	return "elderly"
		else				return "unknown"

proc/RoundHealth(health)
	switch(health)
		if(100 to INFINITY)
			return "health100"
		if(70 to 100)
			return "health80"
		if(50 to 70)
			return "health60"
		if(30 to 50)
			return "health40"
		if(18 to 30)
			return "health25"
		if(5 to 18)
			return "health10"
		if(1 to 5)
			return "health1"
		if(-99 to 0)
			return "health0"
		else
			return "health-100"
	return "0"

proc/random_outfit(var/mob/living/carbon/human/M)

	var/outfit

	/var/random_dress = pick(/obj/item/clothing/under/dress/dress_yellow,
	/obj/item/clothing/under/dress/dress_hr, /obj/item/clothing/under/dress/dress_pink,
	/obj/item/clothing/under/dress/dress_saloon, /obj/item/clothing/under/dress/plaid_blue,
	/obj/item/clothing/under/dress/dress_fire,
	/obj/item/clothing/under/sundress_white,
	/obj/item/clothing/under/suit_jacket/female,
	/obj/item/clothing/under/cheongsam)

	if(M.gender == MALE)
		if(M.age < 90)
			outfit = pick (
				"hip_man",
				"middleaged_man",
				"wealthy_man",
				"hooligan_man")
		else
			outfit = pick (
				"old_man")
	if(M.gender == FEMALE)
		if(M.age < 90)
			outfit = pick (
				"hip_woman",
				"orange_woman",
				"floral_dress_woman",
				"hr",
				"pink",
				"harlot",
				"azn",
				"exec",
				"dorothy",
				"fire",
				"white")
		else
			outfit = pick (
				"old_woman")


	switch(outfit)
		if ("old_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/boaterhat(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)

			M.equip_to_slot_or_del(new /obj/item/weapon/cane(M), slot_r_hand)
		if ("hr")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_hr(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("pink")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_pink(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("harlot")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_saloon(M), slot_w_uniform)
			M.undershirt = undershirt_t.Find("None")
		if ("exec")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/female(M), slot_w_uniform)
		if ("dorothy")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/plaid_blue(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("fire")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/fluff/bruce_hachert(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_fire(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("white")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/sundress_white(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("azn")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/cheongsam(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")

		if ("old_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/blue(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_yellow(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/fluff/bruce_hachert(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/regular(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")

			M.equip_to_slot_or_del(new /obj/item/weapon/cane(M), slot_r_hand)
		if ("hip_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/fluff/tian_dress(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/bomber(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("orange_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/dress/dress_orange(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/hairflower(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/gloves/white(M), slot_gloves)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("hip_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/combat(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/burgundy(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/brown_jacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/big(M), slot_glasses)
		if ("middleaged_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/tan(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/toggle/brown_jacket(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)
		if ("wealthy_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/leather(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket/checkered(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/hoodie(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)
		if ("floral_dress_woman")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/purple(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/sundress_white(M), slot_w_uniform)
			M.equip_to_slot_or_del(new /obj/item/clothing/suit/hoodie(M), slot_wear_suit)
			M.equip_to_slot_or_del(new /obj/item/clothing/glasses/sunglasses/prescription(M), slot_glasses)
			M.undershirt = undershirt_t.Find("None")
		if ("hooligan_man")
			M.equip_to_slot_or_del(new /obj/item/clothing/shoes/laceup(M), slot_shoes)
			M.equip_to_slot_or_del(new /obj/item/clothing/head/det_hat/black(M), slot_head)
			M.equip_to_slot_or_del(new /obj/item/clothing/under/rank/vice(M), slot_w_uniform)

	return
/*
Proc for attack log creation, because really why not
1 argument is the actor
2 argument is the target of action
3 is the description of action(like punched, throwed, or any other verb)
4 should it make adminlog note or not
5 is the tool with which the action was made(usually item)					5 and 6 are very similar(5 have "by " before it, that it) and are separated just to keep things in a bit more in order
6 is additional information, anything that needs to be added
*/

/proc/add_logs(mob/user, mob/target, what_done, var/admin=1, var/object=null, var/addition=null)
	if(user && ismob(user))
		user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has [what_done] [target ? "[target.name][(ismob(target) && target.ckey) ? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(target && ismob(target))
		target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [what_done] by [user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
	if(admin)
		log_attack("<font color='red'>[user ? "[user.name][(ismob(user) && user.ckey) ? "([user.ckey])" : ""]" : "NON-EXISTANT SUBJECT"] [what_done] [target ? "[target.name][(ismob(target) && target.ckey)? "([target.ckey])" : ""]" : "NON-EXISTANT SUBJECT"][object ? " with [object]" : " "][addition]</font>")
