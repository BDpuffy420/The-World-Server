
/obj/structure/billboard
	name = "billboard"
	desc = "A blank billboard"
	icon = 'icons/obj/billboards.dmi'
	icon_state = "billboard"
	light_range = 4
	light_power = 2
	light_color = "#ebf7fe"  //white blue
	density = 1
	anchored = 1
	layer = 9
	bounds = "64,32"


/obj/structure/billboard/Destroy()
	set_light(0)
	return ..()

/obj/structure/billboard/New()
	..()
	icon_state = pick("ssl","ntbuilding","keeptidy")
