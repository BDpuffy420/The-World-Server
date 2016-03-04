//Food items that are eaten normally and don't leave anything behind.
/obj/item/weapon/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food/food.dmi'
	icon_state = null
	var/bitesize = 2
	var/bitecount = 0
	var/trash = null
	var/slice_path		 // for sliceable food. path of the item resulting from the slicing
	var/slices_num
	var/eatverb
	var/wrapped = 0
	var/dried_type = null
	var/potency = null
	var/dry = 0
	var/cooktype[0]
	var/junkiness = 0 //for junk food. used to lower human satiety.
	var/cooked_type = null  //for microwave cooking. path of the resulting item after microwaving
	var/filling_color = "#FFFFFF" //color to use when added to custom food.
	var/custom_food_type = null  //for food customizing. path of the custom food to create
	var/list/bonus_reagents = list() //the amount of reagents (usually nutriment and vitamin) added to crafted/cooked snacks, on top of the ingredients reagents.
	var/customfoodfilling = 1 // whether it can be used as filling in custom food

	center_of_mass = list("x"=15, "y"=15)

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/weapon/reagent_containers/food/snacks/proc/On_Consume(var/mob/M)
	if(!usr)	return
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
		usr.unEquip(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item/weapon/grown))
				var/obj/item/TrashItem = new trash(usr,src.potency)
				usr.put_in_hands(TrashItem)
			else if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/weapon/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/snacks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(!eatverb)
		eatverb = pick("bite","chew","nibble","gnaw","gobble","chomp")
	if(!reagents.total_volume)						//Shouldn't be needed but it checks to see if it has anything left in it.
		user << "<span class='notice'>None of [src] left, oh no!</span>"
		M.unEquip(src)	//so icons update :[
		qdel(src)
		return 0

	if(iscarbon(M))
		if(!canconsume(M, user))
			return 0

	var/fullness = M.nutrition + 10
	for(var/datum/reagent/consumable/C in M.reagents.reagent_list) //we add the nutrition value of what we're currently digesting
		fullness += C.nutriment_factor * C.volume / C.metabolization_rate

	if(M == user)								//If you're eating it yourself
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				H << "<span class='notice'>You have a monitor for a head, where do you think you're going to put that?</span>"
				return
		if(junkiness && M.satiety < -150 && M.nutrition > NUTRITION_LEVEL_STARVING + 50 )
			M << "<span class='notice'>You don't feel like eating any more junk food at the moment.</span>"
			return 0
		if(wrapped)
			M << "<span class='warning'>You can't eat wrapped food!</span>"
			return 0
		else if(fullness <= 50)
			M << "<span class='notice'>You hungrily [eatverb] some of \the [src] and gobble it down!</span>"
		else if(fullness > 50 && fullness < 150)
			M << "<span class='notice'>You hungrily begin to [eatverb] \the [src].</span>"
		else if(fullness > 150 && fullness < 500)
			M << "<span class='notice'>You [eatverb] \the [src].</span>"
		else if(fullness > 500 && fullness < 600)
			M << "<span class='notice'>You unwillingly [eatverb] a bit of \the [src].</span>"
		else if(fullness > (600 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
			M << "<span class='warning'>You cannot force any more of \the [src] to go down your throat!</span>"
			return 0
	else
		if(istype(M,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(H.species.flags & IS_SYNTHETIC)
				H << "\red They have a monitor for a head, where do you think you're going to put that?"
				return

		if(!istype(M, /mob/living/carbon/slime))		//If you're feeding it to someone else.

			if(wrapped)
				return 0
			if(fullness <= (600 * (1 + M.overeatduration / 1000)))
				M.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>", \
									"<span class='userdanger'>[user] attempts to feed [M] [src].</span>")
			else
				M.visible_message("<span class='warning'>[user] cannot force anymore of [src] down [M]'s throat!</span>", \
									"<span class='warning'>[user] cannot force anymore of [src] down [M]'s throat!</span>")
				return 0

			if(!do_mob(user, M))
				return
			add_logs(user, M, "fed", object="[reagentlist(src)]")
			M.visible_message("<span class='danger'>[user] forces [M] to eat [src].</span>", \
								"<span class='userdanger'>[user] feeds [M] to eat [src].</span>")

		else
			user << "<span class='warning'>[M] doesn't seem to have a mouth!</span>"
			return

	if(reagents)								//Handle ingestion of the reagent.
		if(M.satiety > -200)
			M.satiety -= junkiness
		playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
		if(reagents.total_volume)
			if(reagents.total_volume > bitesize)
				/*
				 * I totally cannot understand what this code supposed to do.
				 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
				var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
				reagents.trans_to(M, temp_bitesize)
				*/
				reagents.trans_to_ingest(M, bitesize)
			else
				reagents.trans_to_ingest(M, reagents.total_volume)
			bitecount++
			On_Consume(M)
		return 1

	return 0

/obj/item/weapon/reagent_containers/food/snacks/afterattack(obj/target, mob/user, proximity)
	return ..()

/obj/item/weapon/reagent_containers/food/snacks/examine(mob/user)
	if(!..(user, 1))
		return
	if (bitecount==0)
		return
	else if (bitecount==1)
		user << "\blue \The [src] was bitten by someone!"
	else if (bitecount<=3)
		user << "\blue \The [src] was bitten [bitecount] times!"
	else
		user << "\blue \The [src] was bitten multiple times!"

/obj/item/weapon/reagent_containers/food/snacks/attackby(obj/item/weapon/W, mob/user, params)
	if(istype(W,/obj/item/weapon/storage))
		..() // -> item/attackby()
		return 0

	// Eating with forks
	if(istype(W,/obj/item/weapon/kitchen/utensil))
		var/obj/item/weapon/kitchen/utensil/U = W

		if(!U.reagents)
			U.create_reagents(5)

		if (U.reagents.total_volume > 0)
			user << "\red You already have something on your [U]."
			return

		user.visible_message( \
			"[user] scoops up some [src] with \the [U]!", \
			"\blue You scoop up some [src] with \the [U]!" \
		)

		src.bitecount++
		U.overlays.Cut()
		U.loaded = "[src]"
		var/image/I = new(U.icon, "loadedfood")
		I.color = src.filling_color
		U.overlays += I

		reagents.trans_to(U,min(reagents.total_volume,5))

		if (reagents.total_volume <= 0)
			qdel(src)
		return

	//Custom food
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/S = W
		if(custom_food_type && ispath(custom_food_type))
			if(S.w_class > 2)
				user << "<span class='warning'>[S] is too big for [src]!</span>"
				return 0
			if(!S.customfoodfilling)
				user << "<span class='warning'>[src] can't be filled with [S]!</span>"
				return 0
			if(contents.len >= 20)
				user << "<span class='warning'>You can't add more ingredients to [src]!</span>"
				return 0
			var/obj/item/weapon/reagent_containers/food/snacks/customizable/C = new custom_food_type(get_turf(src))
			C.initialize_custom_food(src, S, user)
			return 0

	var/sharpness = W.is_sharp()
	if(sharpness)
		if(slice(sharpness, W, user))
			return 1

//Called when you finish tablecrafting a snack.
/obj/item/weapon/reagent_containers/food/snacks/CheckParts()
	if(bonus_reagents.len)
		for(var/r_id in bonus_reagents)
			var/amount = bonus_reagents[r_id]
			reagents.add_reagent(r_id, amount)

/obj/item/weapon/reagent_containers/food/snacks/proc/slice(accuracy, obj/item/weapon/W, mob/user)
	if((slices_num <= 0 || !slices_num) || !slice_path) //is the food sliceable?
		return 0

	if ( \
			!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/machinery/optable) in src.loc) && \
			!(locate(/obj/item/weapon/storage/bag/tray) in src.loc) \
		)
		user << "<span class='warning'>You cannot slice [src] here! You need a table or at least a tray.</span>"
		return 1

	var/slices_lost = 0
	if (accuracy >= IS_SHARP_ACCURATE)
		user.visible_message( \
			"[user] slices [src].", \
			"<span class='notice'>You slice [src].</span>" \
		)
	else
		user.visible_message( \
			"[user] crudely slices [src] with [W]!", \
			"<span class='notice'>You crudely slice [src] with your [W]!</span>" \
		)
		slices_lost = rand(1,min(1,round(slices_num/2)))

	var/reagents_per_slice = reagents.total_volume/slices_num
	for(var/i=1 to (slices_num-slices_lost))
		var/obj/item/weapon/reagent_containers/food/snacks/slice = new slice_path (loc)
		initialize_slice(slice, reagents_per_slice)
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/proc/initialize_slice(obj/item/weapon/reagent_containers/food/snacks/slice, reagents_per_slice)
	slice.create_reagents(slice.volume)
	reagents.trans_to(slice,reagents_per_slice)
	return

/obj/item/weapon/reagent_containers/food/snacks/proc/update_overlays(obj/item/weapon/reagent_containers/food/snacks/S)
	overlays.Cut()
	var/image/I = new(src.icon, "[initial(icon_state)]_filling")
	if(S.filling_color == "#FFFFFF")
		I.color = pick("#FF0000","#0000FF","#008000","#FFFF00")
	else
		I.color = S.filling_color

	overlays += I

// initialize_cooked_food() is called when microwaving the food
/obj/item/weapon/reagent_containers/food/snacks/proc/initialize_cooked_food(obj/item/weapon/reagent_containers/food/snacks/S, cooking_efficiency = 1)
	S.create_reagents(S.volume)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)
	if(S.bonus_reagents.len)
		for(var/r_id in S.bonus_reagents)
			var/amount = S.bonus_reagents[r_id] * cooking_efficiency
			S.reagents.add_reagent(r_id, amount)

/obj/item/weapon/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.loc = get_turf(src)
	return ..()


////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/snacks/attack_generic(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message("<b>[user]</b> nibbles away at the [src].","You nibble away at the [src].")
	bitecount++
	if(reagents && user.reagents)
		reagents.trans_to_ingest(user, bitesize)
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	On_Consume(user)

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.


/////////////////////////////////////////////////Store////////////////////////////////////////
// All the food items that can store an item inside itself, like bread or cake.


/obj/item/weapon/reagent_containers/food/snacks/store
	w_class = 3
	var/stored_item = 0

/obj/item/weapon/reagent_containers/food/snacks/store/attackby(obj/item/weapon/W, mob/user, params)
	..()
	if(W.w_class <= 2 & !istype(W, /obj/item/weapon/reagent_containers/food/snacks)) //can't slip snacks inside, they're used for custom foods.
		if(W.is_sharp())
			return 0
		if(stored_item)
			return 0
		if(!iscarbon(user))
			return 0
		if(contents.len >= 20)
			user << "<span class='warning'>[src] is full.</span>"
			return 0
		user << "<span class='notice'>You slip [W] inside [src].</span>"
		user.unEquip(W)
		add_fingerprint(user)
		contents += W
		stored_item = 1
		return 1 // no afterattack here

/obj/item/weapon/reagent_containers/food/snacks/flour
	name = "flour"
	desc = "A small bag filled with some flour."
	icon = 'icons/obj/food/containers.dmi'
	icon_state = "flour"
	New()
		..()
		reagents.add_reagent("nutriment", 1)

/obj/item/weapon/reagent_containers/food/snacks/organ

	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"

	New()
		..()
		reagents.add_reagent("nutriment", rand(3,5))
		reagents.add_reagent("toxin", rand(1,3))
		src.bitesize = 3

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/weapon/reagent_containers/food/sliceable/store
	w_class = 3 //Whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.


///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////

// Flour + egg = dough
/obj/item/weapon/reagent_containers/food/snacks/flour/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/egg))
		new /obj/item/weapon/reagent_containers/food/snacks/dough(src)
		user << "You make some dough."
		qdel(W)
		qdel(src)

// Egg + flour = dough
/obj/item/weapon/reagent_containers/food/snacks/egg/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/flour))
		new /obj/item/weapon/reagent_containers/food/snacks/dough(src)
		user << "You make some dough."
		qdel(W)
		qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/weapon/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/meatball))
		new /obj/item/weapon/reagent_containers/food/snacks/monkeyburger(src)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/cutlet))
		new /obj/item/weapon/reagent_containers/food/snacks/monkeyburger(src)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/sausage))
		new /obj/item/weapon/reagent_containers/food/snacks/hotdog(src)
		user << "You make a hotdog."
		qdel(W)
		qdel(src)

// Burger + cheese wedge = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/monkeyburger/attackby(obj/item/weapon/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/weapon/reagent_containers/food/snacks/cheesewedge))
		new /obj/item/weapon/reagent_containers/food/snacks/burger/cheese(src)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/human/burger/attackby(obj/item/weapon/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/weapon/reagent_containers/food/snacks/burger/cheese(src)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	New()
		..()
		reagents.add_reagent("nutriment", 1)

/obj/item/weapon/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

// potato + knife = raw sticks
/obj/item/weapon/reagent_containers/food/snacks/grown/potato/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		new /obj/item/weapon/reagent_containers/food/snacks/rawsticks(src)
		user << "You cut the potato."
		qdel(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/deepfryholder
	name = "Deep Fried Foods Holder Obj"
	desc = "If you can see this description the code for the deep fryer fucked up."
	icon = 'icons/obj/food/food.dmi'
	icon_state = "deepfried_holder_icon"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/MouseDrop(atom/over)
	var/turf/T = get_turf(src)
	var/obj/structure/table/TB = locate(/obj/structure/table) in T
	if(TB)
		TB.MouseDrop(over)
	else
		..()