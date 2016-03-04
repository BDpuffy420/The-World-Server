/turf/simulated/floor/airless
	icon_state = "floor"
	name = "airless floor"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

	New()
		..()
		name = "floor"

/turf/simulated/floor/airless/ceiling
	icon_state = "rockvault"

/turf/simulated/floor/light
	name = "Light floor"
	light_range = 5
	icon_state = "light_on"
	floor_type = new/obj/item/stack/tile/light
	var/color_state = LIGHTFLOOR_ON

	New()
		var/obj/item/stack/tile/light/T = new /obj/item/stack/tile/light
		T.state = color_state
		floor_type = T
		var/n = name //just in case commands rename it in the ..() call
		update_icon()
		..()
		spawn(4)
			if(src)
				update_icon()
				name = n

//|| Pre-set colored lights for easier mapping
/turf/simulated/floor/light/white
	icon_state = "light_on-w"
	color_state = LIGHTFLOOR_WHITE
/turf/simulated/floor/light/red
	icon_state = "light_on-r"
	color_state = LIGHTFLOOR_RED
/turf/simulated/floor/light/green
	icon_state = "light_on-g"
	color_state = LIGHTFLOOR_GREEN
/turf/simulated/floor/light/yellow
	icon_state = "light_on-y"
	color_state = LIGHTFLOOR_YELLOW
/turf/simulated/floor/light/blue
	icon_state = "light_on-b"
	color_state = LIGHTFLOOR_BLUE
/turf/simulated/floor/light/purple
	icon_state = "light_on-p"
	color_state = LIGHTFLOOR_PURPLE

/turf/simulated/floor/wood
	name = "floor"
	icon_state = "wood"
	footstep_sounds = list(
	"human" = list('sound/effects/footsteps/wood1.wav','sound/effects/footsteps/wood2.wav'),
	"xeno"  = list('sound/effects/footsteps/wood1.wav','sound/effects/footsteps/wood2.wav')
	)
	floor_type = /obj/item/stack/tile/wood


/turf/simulated/floor/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/wall/vault
	icon_state = "rockvault"

	New(location,type)
		..()
		icon_state = "[type]vault"

/turf/simulated/wall/stone
	name = "stone wall"
	icon_state = "riveted"

/turf/simulated/floor/engine
	name = "reinforced floor"
	icon_state = "engine"
	thermal_conductivity = 0.025
	heat_capacity = 325000
	intact = 0

/turf/simulated/floor/engine/nitrogen
	oxygen = 0

/turf/simulated/floor/engine/attackby(obj/item/weapon/C as obj, mob/user as mob)
	if(!C)
		return
	if(!user)
		return
	if(istype(C, /obj/item/weapon/wrench))
		user << "\blue Removing rods..."
		playsound(src, 'sound/items/Ratchet.ogg', 80, 1)
		if(do_after(user, 30))
			new /obj/item/stack/rods(src, 2)
			ChangeTurf(/turf/simulated/floor)
			var/turf/simulated/floor/F = src
			F.make_plating()
			return

/turf/simulated/floor/engine/cult
	name = "engraved floor"
	icon_state = "cult"


/turf/simulated/floor/engine/n20
	New()
		. = ..()
		assume_gas("sleeping_agent", 2000)

/turf/simulated/floor/engine/vacuum
	name = "vacuum floor"
	icon_state = "engine"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/floor/plating
	name = "plating"
	icon_state = "plating"
	floor_type = null
	intact = 0

/turf/simulated/floor/plating/airless
	icon_state = "plating"
	name = "airless plating"
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

	New()
		..()
		name = "plating"

/turf/simulated/floor/plating/dirt
	name = "dirt"
	icon_state = "dirt"
	icon_plating = "dirt"
	footstep_sounds = list(
	"human" = list('sound/effects/footsteps/dirt1.wav','sound/effects/footsteps/dirt2.wav'),
	"xeno"  = list('sound/effects/footsteps/dirt1.wav','sound/effects/footsteps/dirt2.wav')
	)
	var/dug = 0 //0 = has not yet been dug, 1 = has already been dug
	var/overlay_detail

/turf/simulated/floor/plating/dirt/New()
	update_grass_overlays(1)
	..()

/turf/simulated/floor/plating/dirt/deep
	name = "dirt"
	icon_state = "dirt_deep"
	icon_plating = "dirt_deep"
	dug = 1

/turf/simulated/floor/plating/dirt/deep/attackby(obj/item/C as obj, mob/user as mob)

	if(!C || !user)
		return 0

	if(istype(C, /obj/item/stack/tile/dirt))
		var/obj/item/stack/tile/dirt/D = C
		user << "\blue You fill the hole with some dirt."
		D.use(1)
		ChangeTurf(/turf/simulated/floor/plating/dirt)
	if(istype(C, /obj/item/stack/cable_coil))
		if(is_plating())
			var/obj/item/stack/cable_coil/coil = C
			coil.turf_place(src, user)
		else
			user << "\red You must remove the plating first."

/turf/simulated/floor/plating/dirt/ex_act(severity)
	switch(severity)
		if(3.0)
			return
		if(2.0)
			return
		if(1.0)
			return
	return

/turf/simulated/floor/bluegrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "bcircuit"

/turf/simulated/floor/greengrid
	icon = 'icons/turf/floors.dmi'
	icon_state = "gcircuit"


/turf/simulated/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle.dmi'
	thermal_conductivity = 0.05
	heat_capacity = 0
	layer = 2

/turf/simulated/shuttle/wall
	name = "wall"
	icon_state = "wall1"
	opacity = 1
	density = 1
	blocks_air = 1

/turf/simulated/shuttle/floor
	name = "floor"
	icon_state = "floor"

/turf/simulated/shuttle/plating
	name = "plating"
	icon = 'icons/turf/floors.dmi'
	icon_state = "plating"

/turf/simulated/shuttle/plating/vox	//Vox skipjack plating
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/shuttle/floor4 // Added this floor tile so that I have a seperate turf to check in the shuttle -- Polymorph
	name = "Brig floor"        // Also added it into the 2x3 brig area of the shuttle.
	icon_state = "floor4"

/turf/simulated/shuttle/floor4/vox	//Vox skipjack floors
	name = "skipjack floor"
	oxygen = 0
	nitrogen = MOLES_N2STANDARD + MOLES_O2STANDARD

/turf/simulated/floor/beach
	name = "Beach"
	icon = 'icons/misc/beach.dmi'

/turf/simulated/floor/beach/sand
	name = "Sand"
	icon_state = "sand"

/turf/simulated/floor/beach/coastline
	name = "Coastline"
	icon = 'icons/misc/beach2.dmi'
	icon_state = "sandwater"

/turf/simulated/floor/beach/water
	name = "Water"
	icon_state = "water"

/turf/simulated/floor/beach/water/New()
	..()
	overlays += image("icon"='icons/misc/beach.dmi',"icon_state"="water5","layer"=MOB_LAYER+0.1)

/turf/simulated/floor/grass
	name = "Grass patch"
	icon_state = "grass1"
	floor_type = /obj/item/stack/tile/grass
	icon_plating = "dirt"
	var/dug = 0 //0 = has not yet been dug, 1 = has already been dug

	New()
		icon_state = "grass[pick("1","2","3","4")]"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in cardinal)
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly


/turf/simulated/floor/carpet
	name = "Carpet"
	icon_state = "carpet"
	floor_type = /obj/item/stack/tile/carpet
	footstep_sounds = list(
	"human" = list('sound/effects/footsteps/carpet1.ogg'),
	"xeno"  = list('sound/effects/footsteps/carpet1.ogg')
	)

	New()
		if(!icon_state)
			icon_state = "carpet"
		..()
		spawn(4)
			if(src)
				update_icon()
				for(var/direction in list(1,2,4,8,5,6,9,10))
					if(istype(get_step(src,direction),/turf/simulated/floor))
						var/turf/simulated/floor/FF = get_step(src,direction)
						FF.update_icon() //so siding get updated properly



/turf/simulated/floor/plating/ironsand/New()
	..()
	name = "Iron Sand"
	icon_state = "ironsand[rand(1,15)]"

/turf/simulated/floor/plating/snow
	name = "snow"
	icon = 'icons/turf/snow.dmi'
	icon_state = "snow"

/turf/simulated/floor/plating/snow/ex_act(severity)
	return


//|| Roads	#TODO - sometime in the future not a huge priority - handle directional icon changes in update_icon for road in-game construction as well as make damage icons
/turf/simulated/floor/road
	name = "Road"
	icon = 'icons/turf/roads.dmi'
	icon_state = "road"
	footstep_sounds = list(
	"human" = list('sound/effects/footsteps/tile1.wav'),
	"xeno"  = list('sound/effects/footsteps/tile1.wav')
	)

/turf/simulated/floor/road/vertical/
	icon_state = "road1"
/turf/simulated/floor/road/vertical/zebra
	icon_state = "zebra1"
/turf/simulated/floor/road/horizontal
	icon_state = "road10"
/turf/simulated/floor/road/horizontal/zebra
	icon_state = "zebra2"
/turf/simulated/floor/road/vertical/east/
	icon_state = "road3"
/turf/simulated/floor/road/vertical/west
	icon_state = "road2"
/turf/simulated/floor/road/horizontal/north
	icon_state = "road5"
/turf/simulated/floor/road/horizontal/south
	icon_state = "road4"

//| Road corners
/turf/simulated/floor/road/northeast
	icon_state = "road6"
/turf/simulated/floor/road/northwest
	icon_state = "road7"
/turf/simulated/floor/road/southeast
	icon_state = "road8"
/turf/simulated/floor/road/southwest
	icon_state = "road9"

//| Pavement corners
/turf/simulated/floor/pavement
	icon_state = "paved"
/turf/simulated/floor/pavement/east
	icon_state = "paved2"
/turf/simulated/floor/pavement/west
	icon_state = "paved4"
/turf/simulated/floor/pavement/north
	icon_state = "paved5"
/turf/simulated/floor/pavement/south
	icon_state = "paved6"
/turf/simulated/floor/pavement/edge/southeast
	icon_state = "paved10"
/turf/simulated/floor/pavement/edge/southeast/corner
	icon_state = "paved3"
/turf/simulated/floor/pavement/edge/northeast
	icon_state = "paved11"
/turf/simulated/floor/pavement/edge/northeast/corner
	icon_state = "paved7"
/turf/simulated/floor/pavement/edge/southwest
	icon_state = "paved12"
/turf/simulated/floor/pavement/edge/southwest/corner
	icon_state = "paved8"
/turf/simulated/floor/pavement/edge/northwest
	icon_state = "paved13"
/turf/simulated/floor/pavement/edge/northwest/corner
	icon_state = "paved9"

//| Stairs
	// - default is South, in terms of being at the top of the stairs looking down.
/turf/simulated/floor/stairs/
	icon_state = "ramptop"
/turf/simulated/floor/stairs/north
	dir = 1
	icon_state = "ramptop"
/turf/simulated/floor/stairs/east
	dir = 4
	icon_state = "ramptop"
/turf/simulated/floor/stairs/west
	dir = 8
	icon_state = "ramptop"

/turf/simulated/floor/stairsdark/
	icon_state = "rampbottom"
/turf/simulated/floor/stairsdark/north
	dir = 1
	icon_state = "rampbottom"
/turf/simulated/floor/stairsdark/east
	dir = 4
	icon_state = "rampbottom"
/turf/simulated/floor/stairsdark/west
	dir = 8
	icon_state = "rampbottom"