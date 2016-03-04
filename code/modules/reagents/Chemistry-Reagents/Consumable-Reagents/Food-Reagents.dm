///////////////////////////////////////////////////////////////////
					//Food Reagents
//////////////////////////////////////////////////////////////////


// Part of the food code. Also is where all the food
// 	condiments, additives, and such go.


/datum/reagent/consumable
	name = "Consumable"
	id = "consumable"
	var/nutriment_factor = 1 * REAGENTS_METABOLISM

/datum/reagent/consumable/on_mob_life(mob/living/M)
	current_cycle++
	M.nutrition += nutriment_factor
	holder.remove_reagent(src.id, metabolization_rate)

/datum/reagent/consumable/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48

/datum/reagent/consumable/nutriment/on_mob_life(mob/living/M)
	if(prob(50))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/protein // Meat-based protein, digestable by carnivores and omnivores, worthless to herbivores
	name = "Protein"
	id = "protein"
	description = "Various essential proteins and fats commonly found in animal flesh and blood."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48

/datum/reagent/consumable/nutriment/on_mob_life(mob/living/M)
	if(prob(50))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/plant_matter 	// Plant-based biomatter, digestable by herbivores and omnivores, worthless to carnivores
	name = "Plant-matter"
	id = "plantmatter"
	description = "Vitamin-rich fibers and natural sugars commonly found in fresh produce."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48

/datum/reagent/consumable/plant_matter/on_mob_life(mob/living/M)
	if(prob(50))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/vitamin
	name = "Vitamin"
	id = "vitamin"
	description = "All the best vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	color = "#664330" // rgb: 102, 67, 48

/datum/reagent/consumable/vitamin/on_mob_life(mob/living/M)
	if(prob(50))
		M.heal_organ_damage(1,1)
	if(M.satiety < 600)
		M.satiety += 30
	..()
	return

/datum/reagent/consumable/sugar
	name = "Sugar"
	id = "sugar"
	description = "The organic compound commonly known as table sugar and sometimes called saccharose. This white, odorless, crystalline powder has a pleasing, sweet taste."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255, 255, 255
	nutriment_factor = 10 * REAGENTS_METABOLISM
	metabolization_rate = 2 * REAGENTS_METABOLISM
	overdose_threshold = 200 // Hyperglycaemic shock

/datum/reagent/consumable/sugar/overdose_start(mob/living/M)
	M << "<span class='userdanger'>You go into hyperglycaemic shock! Lay off the twinkies!</span>"
	M.sleeping += 30
	return

/datum/reagent/consumable/sugar/overdose_process(mob/living/M)
	M.sleeping += 3
	..()
	return

/datum/reagent/consumable/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water and milk. Virus cells can use this mixture to reproduce."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19

/datum/reagent/consumable/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0

/datum/reagent/consumable/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8


/datum/reagent/consumable/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."
	color = "#B31008" // rgb: 179, 16, 8

/datum/reagent/consumable/capsaicin/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 15)
			M.bodytemperature += 5 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				M.bodytemperature += rand(5,20)
		if(15 to 25)
			M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				M.bodytemperature += rand(10,20)
		if(25 to 35)
			M.bodytemperature += 15 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.species && !(H.species.flags & (NO_PAIN | IS_SYNTHETIC)) )
					H.apply_effect(2,AGONY,0)
					if(prob(5))
						H.visible_message("<span class='warning'>[H] [pick("dry heaves!","coughs!","splutters!")]</span>")
						H << "<span class='warning'>You feel like your insides are burning !</span>"
			if(isslime(M))
				M.bodytemperature += rand(15,20)
		if(35 to INFINITY)
			M.bodytemperature += 20 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				if(H.species && !(H.species.flags & (NO_PAIN | IS_SYNTHETIC)) )
					H.apply_effect(2,AGONY,0)
					if(prob(5))
						H.visible_message("<span class='warning'>[H] [pick("dry heaves!","coughs!","splutters!")]</span>")
						H << "<span class='warning'>You feel like your insides are burning !</span>"
			if(isslime(M))
				M.bodytemperature += rand(20,25)
	if(holder.has_reagent("cryostylane"))
		holder.remove_reagent("cryostylane", 5)
	if(holder.has_reagent("frostoil"))
		holder.remove_reagent("frostoil", 5)
	..()
	return

/datum/reagent/consumable/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extraced from Icepeppers."
	color = "#8BA6E9" // rgb: 139, 166, 233

/datum/reagent/consumable/frostoil/on_mob_life(mob/living/M)
	switch(current_cycle)
		if(1 to 15)
			M.bodytemperature -= 10 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				M.bodytemperature -= rand(5,20)
		if(15 to 25)
			M.bodytemperature -= 20 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(isslime(M))
				M.bodytemperature -= rand(10,20)
		if(25 to 35)
			M.bodytemperature -= 30 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(prob(1))
				M.emote("shiver")
			if(isslime(M))
				M.bodytemperature -= rand(15,20)
		if(35 to INFINITY)
			M.bodytemperature -= 40 * TEMPERATURE_DAMAGE_COEFFICIENT
			if(prob(5))
				M.emote("shiver")
			if(isslime(M))
				M.bodytemperature -= rand(20,25)
	if(holder.has_reagent("capsaicin"))
		holder.remove_reagent("capsaicin", 5)
	if(holder.has_reagent("condensedcapsaicin"))
		holder.remove_reagent("condensedcapsaicin", 5)
	..()
	return

/datum/reagent/consumable/frostoil/reaction_turf(turf/simulated/T, reac_volume)
	if(reac_volume >= 5)
		for(var/mob/living/simple_animal/slime/M in T)
			M.adjustToxLoss(rand(15,30))
		//if(istype(T))
		//	T.atmos_spawn_air(SPAWN_COLD)

/datum/reagent/consumable/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	color = "#B31008" // rgb: 179, 16, 8

/datum/reagent/consumable/condensedcapsaicin/reaction_mob(mob/living/M, method=TOUCH, reac_volume)
	if(!istype(M, /mob/living/carbon/human) && !istype(M, /mob/living/carbon/monkey))
		return

	if(method == TOUCH || method == VAPOR)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = M
			var/mouth_covered = 0
			var/eyes_covered = 0
			var/obj/item/safe_thing = null
			if( victim.wear_mask )
				if ( victim.wear_mask.flags & MASKCOVERSEYES )
					eyes_covered = 1
					safe_thing = victim.wear_mask
				if ( victim.wear_mask.flags & MASKCOVERSMOUTH )
					mouth_covered = 1
					safe_thing = victim.wear_mask
			if( victim.head )
				if ( victim.head.flags & MASKCOVERSEYES )
					eyes_covered = 1
					safe_thing = victim.head
				if ( victim.head.flags & MASKCOVERSMOUTH )
					mouth_covered = 1
					safe_thing = victim.head
			if(victim.glasses)
				eyes_covered = 1
				if ( !safe_thing )
					safe_thing = victim.glasses
			if ( eyes_covered && mouth_covered )
				victim << "<span class='warning'>Your [safe_thing] protects you from the pepperspray!</span>"
				return
			else if ( eyes_covered )	// Reduced effects if partially protected
				victim << "<span class='warning'>Your [safe_thing] protect you from most of the pepperspray!</span>"
				victim.eye_blurry = max(M.eye_blurry, 15)
				victim.eye_blind = max(M.eye_blind, 5)
				victim.Stun(5)
				victim.Weaken(5)
				//victim.Paralyse(10)
				//victim.drop_item()
				return
			else if ( mouth_covered ) // Mouth cover is better than eye cover
				victim << "<span class='warning'>Your [safe_thing] protects your face from the pepperspray!</span>"
				if (!(victim.species && (victim.species.flags & NO_PAIN)))
					victim.emote("scream")
				victim.eye_blurry = max(M.eye_blurry, 5)
				return
			else // Oh dear :D
				if (!(victim.species && (victim.species.flags & NO_PAIN)))
					victim.emote("scream")
				victim << "<span class='warning'>You're sprayed directly in the eyes with pepperspray!</span>"
				victim.eye_blurry = max(M.eye_blurry, 25)
				victim.eye_blind = max(M.eye_blind, 10)
				victim.Stun(5)
				victim.Weaken(5)

/datum/reagent/consumable/condensedcapsaicin/on_mob_life(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && !(H.species.flags & (NO_PAIN | IS_SYNTHETIC)))
			switch(current_cycle)
				if(1)
					H << "<span class='warning'>You feel like your insides are burning !</span>"
				if(2 to INFINITY)
					H.apply_effect(4,AGONY,0)
					if(prob(5))
						H.visible_message("<span class='warning'>[H] [pick("dry heaves!","coughs!","splutters!")]</span>")
						H << "<span class='warning'>You feel like your insides are burning !</span>"
	else if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15,30)
	if(holder.has_reagent("frostoil"))
		holder.remove_reagent("frostoil", 5)
	..()
	return

/datum/reagent/consumable/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255

/datum/reagent/consumable/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)

/datum/reagent/consumable/coco
	name = "Coco Powder"
	id = "cocoa"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	color = "#E700E7" // rgb: 231, 0, 231
	metabolization_rate = 0.2 * REAGENTS_METABOLISM

/datum/reagent/psilocybin/on_mob_life(mob/living/M)
	M.druggy = max(M.druggy, 30)
	switch(current_cycle)
		if(1 to 5)
			if (!M.stuttering) M.stuttering = 1
			M.make_dizzy(5)
			if(prob(10))
				M.emote(pick("twitch","giggle"))
		if(5 to 10)
			if (!M.stuttering) M.stuttering = 1
			M.Jitter(10)
			M.make_dizzy(10)
			M.druggy = max(M.druggy, 35)
			if(prob(20))
				M.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			if (!M.stuttering) M.stuttering = 1
			M.Jitter(20)
			M.make_dizzy(20)
			M.druggy = max(M.druggy, 40)
			if(prob(30))
				M.emote(pick("twitch","giggle"))
	..()
	return

/datum/reagent/consumable/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	color = "#FF00FF" // rgb: 255, 0, 255

/datum/reagent/consumable/sprinkles/on_mob_life(mob/living/M)
	if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden"))
		M.heal_organ_damage(1,1)
		..()
		return
	..()

/datum/reagent/consumable/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/consumable/cornoil/reaction_turf(turf/simulated/T, reac_volume)
	if (!istype(T))
		return
	if(reac_volume >= 3)
		T.MakeSlippery()
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot)
		var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles )
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
/* #TOREMOVE - Port LINDA to uncomment
	var/obj/effect/hotspot/hotspot = (locate(/obj/effect/hotspot) in T)
	if(hotspot)
		var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles() )
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)
*/
/datum/reagent/consumable/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	color = "#365E30" // rgb: 54, 94, 48

/datum/reagent/consumable/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/consumable/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/consumable/hot_ramen/on_mob_life(mob/living/M)
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (10 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/consumable/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/consumable/hell_ramen/on_mob_life(mob/living/M)
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
	..()
	return

/datum/reagent/consumable/flour
	name = "Flour"
	id = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 0, 0, 0

/datum/reagent/consumable/flour/reaction_turf(turf/T, reac_volume)
	if(!istype(T, /turf/space))
		var/obj/effect/decal/cleanable/reagentdecal = new/obj/effect/decal/cleanable/flour(T)
		reagentdecal.reagents.add_reagent("flour", reac_volume)

/datum/reagent/consumable/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	color = "#801E28" // rgb: 128, 30, 40

/datum/reagent/consumable/bluecherryjelly
	name = "Blue Cherry Jelly"
	id = "bluecherryjelly"
	description = "Blue and tastier kind of cherry jelly."
	color = "#00F0FF"

/datum/reagent/consumable/rice
	name = "Rice"
	id = "rice"
	description = "tiny nutritious grains"
	reagent_state = SOLID
	nutriment_factor = 3 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0

/datum/reagent/consumable/vanilla
	name = "Vanilla Powder"
	id = "vanilla"
	description = "A fatty, bitter paste made from vanilla pods."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#FFFACD"

/datum/reagent/consumable/eggyolk
	name = "Egg Yolk"
	id = "eggyolk"
	description = "It's full of protein."
	color = "#FFB500"

/datum/reagent/consumable/corn_starch
	name = "Corn Starch"
	id = "corn_starch"
	description = "A slippery solution."
	color = "#C8A5DC"

/datum/reagent/consumable/corn_syrup
	name = "Corn Syrup"
	id = "corn_syrup"
	description = "Decays into sugar."
	color = "#C8A5DC"

/datum/reagent/consumable/corn_syrup/on_mob_life(mob/living/M)
	M.reagents.add_reagent("sugar", 3)
	M.reagents.remove_reagent("corn_syrup", 1)
	..()