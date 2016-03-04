/obj/item/weapon/reagent_containers/food/snacks/pie
	filling_color = "#FBFFB8"
	icon = 'icons/obj/food/pies&cakes.dmi'
	trash = /obj/item/trash/plate
	bitesize = 3
	w_class = 3
	volume = 80
	list_reagents = list("nutriment" = 10, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/plain
	name = "plain pie"
	desc = "A simple pie, still delicious."
	icon_state = "pie"
	custom_food_type = /obj/item/weapon/reagent_containers/food/snacks/customizable/pie
	bonus_reagents = list("nutriment" = 8, "vitamin" = 1)

/obj/item/weapon/reagent_containers/food/snacks/pie/cream
	name = "banana cream pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	bonus_reagents = list("nutriment" = 2, "vitamin" = 2)
	list_reagents = list("nutriment" = 6, "banana" = 5, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/cream/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	reagents.reaction(hit_atom, TOUCH)
	src.visible_message("\red [src.name] splats.","\red You hear a splat.")
	del(src) // Not qdel, because it'll hit other mobs then the floor for runtimes.

/obj/item/weapon/reagent_containers/food/snacks/pie/berryclafoutis
	name = "berry clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	bonus_reagents = list("nutriment" = 1, "vitamin" = 2)
	list_reagents = list("nutriment" = 10, "berryjuice" = 5, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/bearypie
	name = "beary pie"
	desc = "No brown bears, this is a good sign."
	icon_state = "bearypie"
	bonus_reagents = list("nutriment" = 2, "vitamin" = 3)
	list_reagents = list("nutriment" = 2, "vitamin" = 3)

/obj/item/weapon/reagent_containers/food/snacks/pie/meatpie
	filling_color = "#948051"
	name = "meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	bonus_reagents = list("nutriment" = 1, "vitamin" = 5)

/obj/item/weapon/reagent_containers/food/snacks/pie/tofupie
	filling_color = "#FFFEE0"
	name = "tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	bonus_reagents = list("nutriment" = 1, "vitamin" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/amanita_pie
	filling_color = "#FFCCCC"
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	bitesize = 4
	bonus_reagents = list("nutriment" = 1, "vitamin" = 4)
	list_reagents = list("nutriment" = 6, "amatoxin" = 3, "mushroomhallucinogen" = 1, "vitamin" = 4)


/obj/item/weapon/reagent_containers/food/snacks/pie/plump_pie
	filling_color = "#B8279B"
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	bonus_reagents = list("nutriment" = 1, "vitamin" = 4)

/obj/item/weapon/reagent_containers/food/snacks/pie/plump_pie/New()
	..()
	if(prob(10))
		name = "exceptional plump pie"
		desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
		reagents.add_reagent("omnizine", 5)
		bonus_reagents = list("nutriment" = 1, "tricordrazine" = 5, "vitamin" = 4)

/obj/item/weapon/reagent_containers/food/snacks/pie/xemeat
	filling_color = "#43DE18"
	name = "xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	bonus_reagents = list("nutriment" = 1, "vitamin" = 5)

/obj/item/weapon/reagent_containers/food/snacks/pie/apple
	filling_color = "#E0EDC5"
	name = "apple pie"
	desc = "A pie containing sweet sweet love...or apple."
	icon_state = "applepie"
	bonus_reagents = list("nutriment" = 1, "vitamin" = 3)

/obj/item/weapon/reagent_containers/food/snacks/pie/cherry
	filling_color = "#FF525A"
	name = "cherry pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	bonus_reagents = list("nutriment" = 1, "vitamin" = 2)


/obj/item/weapon/reagent_containers/food/snacks/pie/pumpkinpie
	filling_color = "#F5B951"
	name = "pumpkin pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	slices_num = 5
	bonus_reagents = list("nutriment" = 1, "vitamin" = 5)

/obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	filling_color = "#F5B951"
	name = "pumpkin pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon = 'icons/obj/food/pies&cakes.dmi'
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFA500"
	list_reagents = list("nutriment" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	bonus_reagents = list("nutriment" = 1, "vitamin" = 4)
	list_reagents = list("nutriment" = 8, "gold" = 5, "vitamin" = 4)

/obj/item/weapon/reagent_containers/food/snacks/pie/blumpkinpie
	name = "blumpkin pie"
	desc = "An odd blue pie made with toxic blumpkin."
	icon_state = "blumpkinpie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/blumpkinpieslice
	slices_num = 5
	bonus_reagents = list("nutriment" = 3, "vitamin" = 6)

/obj/item/weapon/reagent_containers/food/snacks/blumpkinpieslice
	name = "blumpkin pie slice"
	desc = "A slice of blumpkin pie, with whipped cream on top. Is this edible?"
	icon = 'icons/obj/food/pies&cakes.dmi'
	icon_state = "blumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#1E90FF"
	list_reagents = list("nutriment" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/dulcedebatata
	name = "dulce de batata"
	desc = "A delicious jelly made with sweet potatoes."
	icon_state = "dulcedebatata"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/dulcedebatataslice
	slices_num = 5
	bonus_reagents = list("nutriment" = 4, "vitamin" = 8)

/obj/item/weapon/reagent_containers/food/snacks/dulcedebatataslice
	name = "dulce de batata slice"
	desc = "A slice of sweet dulce de batata jelly."
	icon = 'icons/obj/food/pies&cakes.dmi'
	icon_state = "dulcedebatataslice"
	trash = /obj/item/trash/plate
	filling_color = "#8B4513"
	list_reagents = list("nutriment" = 2)

/obj/item/weapon/reagent_containers/food/snacks/pie/frostypie
	name = "frosty pie"
	desc = "Tastes like blue and cold."
	icon_state = "frostypie"
	bonus_reagents = list("nutriment" = 4, "vitamin" = 6)