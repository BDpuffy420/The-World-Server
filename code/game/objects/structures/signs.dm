/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			qdel(src)
			return
		if(3.0)
			qdel(src)
			return
		else
	return

/obj/structure/sign/blob_act()
	qdel(src)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(istype(tool, /obj/item/weapon/screwdriver) && !istype(src, /obj/structure/sign/double))
		user << "You unfasten the sign with your [tool]."
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		qdel(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = 3		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/weapon/screwdriver) && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		user << "You fasten \the [S] with your [tool]."
		qdel(src)
	else ..()

/*|	                                             */
/*| Neon Signs
   ----------------------------------------------*/

   //| Note: for a more varied range of colors, I chose not to use the pre- #defined colors and instead individually converted the RGB values from each sprite into hex code - Mal

/obj/structure/sign/neon/Destroy()
	set_light(0)
	return ..()

/obj/structure/sign/neon
	desc = "A glowing sign."
	icon = 'icons/obj/neondecor.dmi'
	light_range = 4
	light_power = 2

/obj/structure/sign/neon/item
	name = "item store"
	icon_state = "item"
	light_color = "#B79F41" //copper

/obj/structure/sign/neon/motel
	name = "motel"
	icon_state = "motel"
	light_color = "#59FF9B" //teal

/obj/structure/sign/neon/hotel
	name = "hotel"
	icon_state = "hotel"
	light_color = "#59FF9B" //teal

/obj/structure/sign/neon/flashhotel
	name = "hotel"
	icon_state = "flashhotel"
	light_color = "#FF8FF8" //hot pink

/obj/structure/sign/neon/lovehotel
	name = "hotel"
	icon_state = "lovehotel"
	light_color = "#59FF9B" //teal

/obj/structure/sign/neon/sushi
	name = "sushi"
	icon_state = "sushi"
	light_color = "#7DD3FF"  //sky blue

/obj/structure/sign/neon/bakery
	name = "bakery"
	icon_state = "bakery"
	light_color = "#FF8FEE" //hot pink

/obj/structure/sign/neon/beer
	name = "pub"
	icon_state = "beer"
	light_color = "#CBDC54" //yellow

/obj/structure/sign/neon/inn
	name = "inn"
	icon_state = "inn"
	light_color = "#F070FF"  //deeper hot pink

/obj/structure/sign/neon/cafe
	name = "cafe"
	icon_state = "cafe"
	light_color = "#FF8FEE" //hot pink

/obj/structure/sign/neon/diner
	name = "diner"
	icon_state = "diner"
	light_color = "#59FF9B" //teal

/obj/structure/sign/neon/bar_alt
	name = "bar"
	icon_state = "bar_alt"
	light_color = "#39FFA4" //teal

/obj/structure/sign/neon/casino
	name = "casino"
	icon_state = "casino"
	light_color = "#6CE08A" //teal

/obj/structure/sign/neon/cupcake
	name = "casino"
	icon_state = "casino"
	light_color = "#F4A9D8" //pink!

/obj/structure/sign/neon/peace
	name = "peace"
	icon_state = "peace"
	light_color = "#8559FF" //a cross between the blue and purple

/obj/structure/sign/neon/sale
	name = "sale"
	icon_state = "sale"
	light_color = "#6EB6FF" //sky blue

/obj/structure/sign/neon/exit
	name = "exit"
	icon_state = "exit"
	light_color = "#7FEA6A" //lime green

/obj/structure/sign/neon/disco
	name = "disco"
	icon_state = "disco"

/obj/structure/sign/neon/close
	name = "close"
	icon_state = "close"
	light_color = "#7FEA6A" //lime green

/obj/structure/sign/neon/open
	name = "open"
	icon_state = "open"
	light_color = "#FFFFFF" //white

/obj/structure/sign/neon/phone
	name = "phone"
	icon_state = "phone"
	light_color = "#7FEA6A" //lime green

/obj/structure/sign/neon/armory
	name = "armory"
	icon_state = "armory"
	light_color = "#7FEA6A" //lime green

/obj/structure/sign/neon/pizza
	name = "pizza"
	icon_state = "pizza"
	light_color = "#33CC00" //green

/obj/structure/sign/neon/clothes
	name = "clothes"
	icon_state = "clothes"
	light_color = "#FF9326" //orange

/obj/structure/sign/neon/bar
	name = "bar sign"
	desc = "The sign says 'Bar' on it."
	icon_state = "bar"
	light_color = "#63C4D6" //light blue

/*|	                                             */
/*| Double Signs
   ----------------------------------------------*/

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"


//Making area mapping simpler since 2240//


/obj/structure/sign/double/teleporter/left
	name = "teleporter"
	icon_state = "teleporter1"
/obj/structure/sign/double/teleporter/right
	name = "teleporter"
	icon_state = "teleporter2"

/obj/structure/sign/double/museum/left
	icon_state = "museum1"
/obj/structure/sign/double/museum/right
	icon_state = "museum2"

/obj/structure/sign/double/police/left
	icon_state = "police1"
/obj/structure/sign/double/police/right
	icon_state = "police2"

/obj/structure/sign/double/warden/left
	icon_state = "warden1"
/obj/structure/sign/double/warden/right
	icon_state = "warden2"

/obj/structure/sign/double/copoffice/left
	icon_state = "copoffice1"
/obj/structure/sign/double/copoffice/right
	icon_state = "copoffice2"

/obj/structure/sign/double/visit/left
	icon_state = "visit1"
/obj/structure/sign/double/visit/right
	icon_state = "visit2"

/obj/structure/sign/double/prosecution/left
	icon_state = "prosecution1"
/obj/structure/sign/double/prosecution/right
	icon_state = "prosecution2"

/obj/structure/sign/double/defense/left
	icon_state = "defense1"
/obj/structure/sign/double/defense/right
	icon_state = "defense2"

/obj/structure/sign/double/courtyard/left
	icon_state = "courtyard1"
/obj/structure/sign/double/courtyard/right
	icon_state = "courtyard2"

/obj/structure/sign/double/training/left
	icon_state = "train1"
/obj/structure/sign/double/training/right
	icon_state = "train2"

/obj/structure/sign/double/cityhall/left
	icon_state = "cityhall1"
/obj/structure/sign/double/cityhall/right
	icon_state = "cityhall2"

/obj/structure/sign/double/mayor/left
	icon_state = "mayor1"
/obj/structure/sign/double/mayor/right
	icon_state = "mayor2"

/obj/structure/sign/directional/left
	icon_state = "cityhalldir1"
	pixel_y = 32
/obj/structure/sign/directional/right
	icon_state = "cityhalldir2"
	pixel_y = 32


/obj/structure/sign/double/challcar/left
	icon_state = "challcar1"
/obj/structure/sign/double/challcar/right
	icon_state = "challcar2"


/obj/structure/sign/double/meetingroom/left
	icon_state = "meetingroom1"
/obj/structure/sign/double/meetingroom/right
	icon_state = "meetingroom2"

/obj/structure/sign/double/hospital/left
	icon_state = "hospital1"
/obj/structure/sign/double/hospital/right
	icon_state = "hospital2"

/obj/structure/sign/double/court/left
	icon_state = "court1"
/obj/structure/sign/double/court/right
	icon_state = "court2"
//

/obj/structure/sign/double/gamecenter/
	name = "Game Center"
	desc = "A flashing sign which reads 'Game Center'."
	icon = 'icons/obj/neondecor.dmi'
	light_color = "#FFA851" //orange
	light_range = 4
	light_power = 2

/obj/structure/sign/double/gamecenter/right
	icon_state = "gamecenter-right"

/obj/structure/sign/double/gamecenter/left
	icon_state = "gamecenter-left"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/*|	                                             */
/*| Misc Wall Decor
   ----------------------------------------------*/

/obj/structure/sign/decor
	name = "Decoration"
	icon = 'icons/obj/decor.dmi'

/obj/structure/sign/decor/painting
	name = "painting"
	icon = 'icons/obj/decor.dmi'
	icon_state = "0,0"
	pixel_y = 32

/obj/structure/sign/decor/number
	name = "Door Number"
	icon_state = "door1"

/obj/structure/sign/decor/techshop
	name = "tech shop"
	icon_state = "techshop"

/*|	                                             */
/*| Normal Signs
   ----------------------------------------------*/

/obj/structure/sign/rent
	name = "Rent sign"
	icon = 'icons/obj/decor.dmi'
	icon_state = "rent"
	desc = "A sign that says 'For Rent' on it. This house might be vacant."

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/coffee
	name = "Coffee And Sweets"
	desc = "A sign which reads 'Coffee and Sweets'."
	icon_state = "coffee-left"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/cells
	name = "\improper Cells"
	desc = "A sign which reads 'Cells'."
	icon_state = "cells"


/obj/structure/sign/techshop
	name = "\improper techshop"
	desc = "A sign which reads 'tech shop'."
	icon_state = "techshop"

/obj/structure/sign/briefroom
	name = "\improper Brief Room"
	desc = "A warning sign which reads 'Brief Room'."
	icon_state = "briefroom"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "redcross"

/obj/structure/sign/toilets
	name = "unisex restroom"
	desc = "Toilets ahead."
	icon_state = "toilets"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "\improper AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA atmospherics division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/directions/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "\improper Escape Arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"

/obj/structure/sign/barber
	name = "\improper barber shop sign"
	desc = "A spinning sign indicating a barbershop is near."
	icon_state = "barber"