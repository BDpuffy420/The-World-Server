


///////////////////////////////////////////////////////////////////////////////////////
						//ALCOHOLS
/////////////////////////////////////////////////////////////////////////////////////

/*boozepwr chart
55 = non-toxic alchohol
45 = medium-toxic
35 = the hard stuff
25 = potent mixes
<15 = deadly toxic
*/

/datum/reagent/consumable/ethanol
	name = "Ethanol"
	id = "ethanol"
	description = "A well-known alcohol with a variety of applications."
	color = "#CAEAF4" // rgb: 202, 234, 244
	nutriment_factor = 0
	var/boozepwr = 10 //lower numbers mean the booze will have an effect faster.
	var/total_cycles = 0 //keep track of how many total ethanol cycles to handle the mixing of boozes.
	var/boozes //keep track of how many boozes are being mixed
	var/boozepwr_avg //average of all the booze powers. lower numbers mean the booze will have an effect faster.

/datum/reagent/consumable/ethanol/on_mob_life(mob/living/M, alien)

	if(alien) return ..() // Aliens without livers don't get drunk.
	M.jitteriness = max(M.jitteriness-5,0)

	if(alien && alien == IS_SKRELL) //Skrell get very drunk very quickly.
		current_cycle *= 1.2

	//make all the beverages work together
	total_cycles = current_cycle
	boozes = 1
	boozepwr_avg = boozepwr
	for(var/datum/reagent/consumable/ethanol/A in holder.reagent_list)
		if(A != src && isnum(A.current_cycle))
			boozes++
			boozepwr_avg += A:boozepwr
			total_cycles += A.current_cycle

	if(boozes > 1)
		boozepwr_avg = (boozepwr_avg)/boozes	//Calculate the average booze strength between all mixed beverages

	if(prob(100/boozes))	//This is here so that, on average, the status effects will only be applied by one of the booze reagents instead of by all of them.
		//Go through the various stages of drunkedness based on how long alchohol been in the mob's system, and how strong the alchohol is
		if(total_cycles >= boozepwr_avg*1.8)
			if (!M:slurring) M:slurring = 1
			M:slurring += 3
			M.make_dizzy(5)
		if(total_cycles >= boozepwr_avg*2.5 && prob(33))
			if (!M.confused) M.confused = 1
			M.confused += 2
		if(total_cycles >= boozepwr_avg*6 && prob(33))
			M.eye_blurry = max(M.eye_blurry, 10)
			M:drowsyness  = max(M:drowsyness, 0)
		if(total_cycles >= boozepwr_avg*10 && prob(33))
			M:paralysis = max(M:paralysis, 20)
			M:drowsyness  = max(M:drowsyness, 30)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/liver/L = H.internal_organs_by_name["liver"]
				if (!L)
					H.adjustToxLoss(5)
				else if(istype(L))
					L.take_damage(0.1, 1)
				H.adjustToxLoss(0.1)
	..()
	return

/datum/reagent/consumable/ethanol/reaction_obj(obj/O, reac_volume)
	if(istype(O,/obj/item/weapon/paper))
		var/obj/item/weapon/paper/paperaffected = O
		paperaffected.clearpaper()
		usr << "The solution melts away the ink on the paper."
	if(istype(O,/obj/item/weapon/book))
		if(istype(O,/obj/item/weapon/book/tome))
			usr << "The solution does nothing. Whatever this is, it isn't normal ink."
			return
		if(reac_volume >= 5)
			var/obj/item/weapon/book/affectedbook = O
			affectedbook.dat = null
			usr << "The solution melts away the ink on the book."
		else
			usr << "It wasn't enough..."
	return

/datum/reagent/consumable/ethanol/reaction_mob(mob/living/M, method=TOUCH, reac_volume)//Splashing people with ethanol isn't quite as good as fuel.
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH || method == VAPOR)
		M.adjust_fire_stacks(reac_volume / 15)
	..()

/datum/reagent/consumable/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#E2E67b" // rgb: 226, 230, 123
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 55

/datum/reagent/consumable/ethanol/beer/greenbeer
	name = "Green Beer"
	id = "greenbeer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. Dyed a festive green."
	color = "#92CA7A" // rgb: 146, 202, 122

/datum/reagent/consumable/ethanol/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#1D1111" // rgb: 29, 17, 17
	boozepwr = 45

/datum/reagent/consumable/ethanol/kahlua/on_mob_life(mob/living/M)
	M.dizziness = max(0,M.dizziness-5)
	M.drowsyness = max(0,M.drowsyness-3)
	M.sleeping = max(0,M.sleeping-2)
	M.Jitter(5)
	..()
	return

/datum/reagent/consumable/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#AE5107" // rgb: 174, 81, 7
	boozepwr = 35

/datum/reagent/consumable/ethanol/specialwhiskey
	name = "Special Blend Whiskey"
	id = "specialwhiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	color = "#AE5107" // rgb: 174, 81, 7
	boozepwr = 35

/datum/reagent/consumable/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "A potent mixture of caffeine and alcohol."
	color = "#FFAE06" // rgb: 255, 174, 6
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 35

/datum/reagent/consumable/ethanol/thirteenloko/on_mob_life(mob/living/M)
	M.drowsyness = max(0,M.drowsyness-7)
	M.sleeping = max(0,M.sleeping-2)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.Jitter(5)
	..()
	return

/datum/reagent/consumable/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#CAEAF4" // rgb: 202, 234, 244
	boozepwr = 35

/datum/reagent/consumable/ethanol/vodka/on_mob_life(mob/living/M)
	M.radiation = max(M.radiation-1,0)
	..()
	return

/datum/reagent/consumable/ethanol/bilk
	name = "Bilk"
	id = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C" // rgb: 137, 92, 76
	nutriment_factor = 2 * REAGENTS_METABOLISM
	boozepwr = 55

/datum/reagent/consumable/ethanol/bilk/on_mob_life(mob/living/M)
	if(M.getBruteLoss() && prob(10))
		M.heal_organ_damage(1,0)
	..()
	return

/datum/reagent/consumable/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Made for a woman, strong enough for a man."
	color = "#FF6633" // rgb: 255, 102, 51
	boozepwr = 15

/datum/reagent/consumable/ethanol/threemileisland/on_mob_life(mob/living/M)
	M.druggy = max(M.druggy, 50)
	..()
	return

/datum/reagent/consumable/ethanol/gin
	name = "Gin"
	id = "gin"
	description = "It's gin. In space. I say, good sir."
	color = "#CAEAF4" // rgb: 202, 234, 244
	boozepwr = 55

/datum/reagent/consumable/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Yohoho and all that."
	color = "#C1B97E" // rgb: 193, 185, 126
	boozepwr = 45

/datum/reagent/consumable/ethanol/sake
	name = "Sake"
	id = "sake"
	description = "Anime's favorite drink."
	color = "#CAEAF4" // rgb: 202, 234, 244
	boozepwr = 35

	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/consumable/ethanol/tequila
	name = "Tequila"
	id = "tequila"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty, hombre?"
	color = "#D7D9B3" // rgb: 215, 217, 179
	boozepwr = 35

/datum/reagent/consumable/ethanol/vermouth
	name = "Vermouth"
	id = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#CEC797" // rgb: 206, 199, 151
	boozepwr = 45

/datum/reagent/consumable/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	color = "#C66570" // rgb: 198, 101, 112
	boozepwr = 45

/datum/reagent/consumable/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#DFA866" // rgb: 223, 168, 102
	boozepwr = 45

/datum/reagent/consumable/ethanol/hooch
	name = "Hooch"
	id = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35

/datum/reagent/consumable/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#751810" // rgb: 117, 24, 16
	boozepwr = 55

/datum/reagent/consumable/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#8CC356" // rgb: 140, 195, 86
	boozepwr = 25

	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/consumable/ethanol/pwine
	name = "Poison Wine"
	id = "pwine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000" // rgb: 0, 0, 0 SHOCKER
	boozepwr = 55

	glass_center_of_mass = list("x"=16, "y"=5)

	on_mob_life(var/mob/living/M as mob)
		if(!M) M = holder.my_atom
		M.druggy = max(M.druggy, 50)
		switch(current_cycle)
			if(1 to 25)
				if (!M.stuttering) M.stuttering = 1
				M.make_dizzy(1)
				M.hallucination = max(M.hallucination, 3)
				if(prob(1)) M.emote(pick("twitch","giggle"))
			if(25 to 75)
				if (!M.stuttering) M.stuttering = 1
				M.hallucination = max(M.hallucination, 10)
				M.Jitter(2)
				M.make_dizzy(2)
				M.druggy = max(M.druggy, 45)
				if(prob(5)) M.emote(pick("twitch","giggle"))
			if (75 to 150)
				if (!M.stuttering) M.stuttering = 1
				M.hallucination = max(M.hallucination, 60)
				M.Jitter(4)
				M.make_dizzy(4)
				M.druggy = max(M.druggy, 60)
				if(prob(10)) M.emote(pick("twitch","giggle"))
				if(prob(30)) M.adjustToxLoss(2)
			if (150 to 300)
				if (!M.stuttering) M.stuttering = 1
				M.hallucination = max(M.hallucination, 60)
				M.Jitter(4)
				M.make_dizzy(4)
				M.druggy = max(M.druggy, 60)
				if(prob(10)) M.emote(pick("twitch","giggle"))
				if(prob(30)) M.adjustToxLoss(2)
				if(prob(5)) if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/obj/item/organ/heart/L = H.internal_organs_by_name["heart"]
					if (L && istype(L))
						L.take_damage(5, 0)
			if (300 to INFINITY)
				if(ishuman(M))
					var/mob/living/carbon/human/H = M
					var/obj/item/organ/heart/L = H.internal_organs_by_name["heart"]
					if (L && istype(L))
						L.take_damage(100, 0)
		..()
		return

/////////////////////////////////////////////////////////////////cocktail entities//////////////////////////////////////////////

/datum/reagent/consumable/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#D9D9D9" // rgb: 217, 217, 217
	boozepwr = 25

/datum/reagent/consumable/ethanol/patron
	name = "Patron"
	id = "patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#D3D4AF" // rgb: 211, 212, 175
	boozepwr = 45

/datum/reagent/consumable/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "An all time classic, mild cocktail."
	color = "#CAEAF4" // rgb: 202, 234, 244
	boozepwr = 55

/datum/reagent/consumable/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Rum, mixed with cola. Viva la revolution."
	color = "#896167" // rgb: 137, 97, 103
	boozepwr = 45

/datum/reagent/consumable/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 35

/datum/reagent/consumable/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#CDDCAD" // rgb: 205, 220, 173
	boozepwr = 35

/datum/reagent/consumable/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#CDDCAD" // rgb: 205, 220, 173
	boozepwr = 25

/datum/reagent/consumable/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "That's just, like, your opinion, man..."
	color = "#DBDCCC" // rgb: 219, 220, 204
	boozepwr = 35

/datum/reagent/consumable/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#D9B58E" // rgb: 217, 181, 142
	boozepwr = 35

/datum/reagent/consumable/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Ewww..."
	color = "#12F812" // rgb: 18, 248, 18
	boozepwr = 45

/datum/reagent/consumable/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#C17985" // rgb: 193, 121, 133
	boozepwr = 35

/datum/reagent/consumable/ethanol/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "It's just as effective as Dutch-Courage!."
	color = "#A8A099" // rgb: 168, 160, 153
	boozepwr = 35

/datum/reagent/consumable/ethanol/tequila_sunrise
	name = "Tequila Sunrise"
	id = "tequilasunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	color = "DBB771" // rgb: 219, 183, 113
	boozepwr = 35

/datum/reagent/consumable/ethanol/toxins_special
	name = "Toxins Special"
	id = "toxinsspecial"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	color = "#8780A9" // rgb: 135, 128, 169
	boozepwr = 15

/datum/reagent/consumable/ethanol/toxins_special/on_mob_life(var/mob/living/M as mob)
	if (M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (15 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
	description = "Deny drinking this and prepare for THE LAW."
	color = "#808000" // rgb: 128, 128, 0
	boozepwr = 25
	metabolization_rate = 0.8

/datum/reagent/consumable/ethanol/beepsky_smash/on_mob_life(mob/living/M)
	M.Stun(1)
	..()
	return

/datum/reagent/consumable/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	color = "#DAC29C" // rgb: 218, 194, 156
	boozepwr = 35

/datum/reagent/consumable/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	color = "#FF9603" // rgb: 255, 150, 3
	boozepwr = 45 //was 10, but really its only beer and ale, both weak alchoholic beverages

/datum/reagent/consumable/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	color = "#FF6633" // rgb: 255, 102, 51
	boozepwr = 25

/datum/reagent/consumable/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#CAEAF4" // rgb: 202, 234, 244
	boozepwr = 25

/datum/reagent/consumable/ethanol/b52
	name = "B-52"
	id = "b52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#B3732B" // rgb: 179, 115, 43
	boozepwr = 25

/datum/reagent/consumable/ethanol/irishcoffee
	name = "Irish Coffee"
	id = "irishcoffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 35

/datum/reagent/consumable/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#D9E2D0" // rgb: 217, 226, 208
	boozepwr = 35

/datum/reagent/consumable/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 35

/datum/reagent/consumable/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#FF6633" // rgb: 255, 102, 51
	boozepwr = 45

/datum/reagent/consumable/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#FF6633" // rgb: 255, 102, 51
	boozepwr = 15

/datum/reagent/consumable/ethanol/manhattan_proj/on_mob_life(mob/living/M)
	M.druggy = max(M.druggy, 30)
	..()
	return

/datum/reagent/consumable/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "For the more refined griffon."
	color = "#A48779" // rgb: 164, 135, 121
	boozepwr = 35

/datum/reagent/consumable/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ultimate refreshment."
	color = "#30EFFE" // rgb: 48, 239, 254
	boozepwr = 25

/datum/reagent/consumable/ethanol/antifreeze/on_mob_life(mob/living/M)
	if (M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Barefoot and pregnant"
	color = "#F268C4" // rgb: 242, 104, 196
	boozepwr = 45

/datum/reagent/consumable/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "A cold refreshment"
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 45

/datum/reagent/consumable/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	boozepwr = 1

	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/consumable/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD" // rgb: 0, 0, 205
	boozepwr = 1.5

	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/consumable/ethanol/suidream
	name = "Sui Dream"
	id = "suidream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	color = "#00A86B" // rgb: 0, 168, 107
	boozepwr = 0.5

	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/consumable/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "AHHHH!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 35

/datum/reagent/consumable/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "For when a gin and tonic isn't russian enough."
	color = "#CAEAF4" // rgb: 202, 234, 244
	boozepwr = 35

/datum/reagent/consumable/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Refreshingly lemony, deliciously dry."
	color = "#FFFFCC" // rgb: 255, 255, 204
	boozepwr = 45

/datum/reagent/consumable/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Tropical cocktail."
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 35

/datum/reagent/consumable/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "A blue-space beverage!"
	color = "#6D1007" // rgb: 109, 16, 7
	boozepwr = 15

/datum/reagent/consumable/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "A spicy Vodka! Might be a little hot for the little guys!"
	color = "#D3D5B0" // rgb: 211, 213, 176
	boozepwr = 35

/datum/reagent/consumable/ethanol/sbiten/on_mob_life(mob/living/M)
	if (M.bodytemperature < 360)
		M.bodytemperature = min(360, M.bodytemperature + (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "Creepy time!"
	color = "#F54F3D" // rgb: 245, 79, 61
	boozepwr = 35

/datum/reagent/consumable/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "The true Viking drink! Even though it has a strange red color."
	color = "#B24542" // rgb: 178, 69, 66
	boozepwr = 45

/datum/reagent/consumable/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "A Vikings drink, though a cheap one."
	color = "#E4C35E" // rgb: 228, 195, 94
	nutriment_factor = 1 * REAGENTS_METABOLISM
	boozepwr = 45

/datum/reagent/consumable/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "A beer which is so cold the air around it freezes."
	color = "#E2E67b" // rgb: 226, 230, 123
	boozepwr = 55

/datum/reagent/consumable/ethanol/iced_beer/on_mob_life(mob/living/M)
	if(M.bodytemperature > 270)
		M.bodytemperature = max(270, M.bodytemperature - (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/consumable/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Watered down rum, Nanotrasen approves!"
	color = "#E3E45E" // rgb: 227, 228, 94
	boozepwr = 90

/datum/reagent/consumable/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "So very, very, very good."
	color = "#FFFF00" // rgb: 255, 255, 0
	boozepwr = 35

/datum/reagent/consumable/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "A nice, strange named drink."
	color = "#C4F268" // rgb: 196, 242, 104
	boozepwr = 35

/datum/reagent/consumable/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	color = "#3AF2F2" // rgb: 58, 242, 242
	boozepwr = 35

/datum/reagent/consumable/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	color = "#8DE45E" // rgb: 141, 228, 94
	boozepwr = 45

/datum/reagent/consumable/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Official drink of the Nanotrasen Gun-Club!"
	color = "#E3E45E" // rgb: 227, 228, 94
	boozepwr = 35

/datum/reagent/consumable/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "You take a tiny sip and feel a burning sensation..."
	color = "#8DE45E" // rgb: 141, 228, 94
	boozepwr = 15

/datum/reagent/consumable/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Mmm, tastes like chocolate cake..."
	color = "#4E240B" // rgb: 78, 36, 11
	boozepwr = 25

/datum/reagent/consumable/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Tastes like terrorism!"
	color = "#E2E67b" // rgb: 226, 230, 123
	boozepwr = 15

/datum/reagent/consumable/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "The surprise is, it's green!"
	color = "#5CB242" // rgb: 92, 178, 66
	boozepwr = 35

/datum/reagent/consumable/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#B38F6C" // rgb: 179, 143, 108
	boozepwr = 25

/datum/reagent/consumable/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#DBDA73" // rgb: 219, 218, 115
	boozepwr = 25

/datum/reagent/consumable/ethanol/bananahonk/on_mob_life(mob/living/M)
	if( ( istype(M, /mob/living/carbon/human) && M.job in list("Clown") ) || istype(M, /mob/living/carbon/monkey) )
		M.heal_organ_damage(1,1)
	..()
	return

/datum/reagent/consumable/ethanol/silencer
	name = "Silencer"
	id = "silencer"
	description = "A drink from Mime Heaven."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#C0C0C0" // rgb: 192, 192, 192
	boozepwr = 15

/datum/reagent/consumable/ethanol/silencer/on_mob_life(mob/living/M)
	if(istype(M, /mob/living/carbon/human) && M.job in list("Mime"))
		M.heal_organ_damage(1,1)
	..()
	return

/datum/reagent/consumable/ethanol/drunkenblumpkin
	name = "Drunken Blumpkin"
	id = "drunkenblumpkin"
	description = "A weird mix of whiskey and blumpkin juice."
	color = "#3399CC" // rgb: 51, 153, 204
	boozepwr = 35