/obj/vehicle/train/cargo/engine/motorcycle
	name = "motorcycle"
	desc = "A fast and highly maneuverable vehicle."
	icon = 'icons/vehicles/motorcycle.dmi'
	icon_state = "motorcycle_4dir"
	emagged = 0
	mob_offset_y = 6
	load_offset_x = 0
	health = 100
	charge_use = 0
	engine_start = 'sound/vehicles/motorbikeignition.ogg'
	engine_fail = 'sound/vehicles/motorbikewontstart.ogg'

/obj/vehicle/train/cargo/engine/motorcycle/start_engine()
	set name = "Start engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(on)
		usr << "<span class='warning'>The engine is already running.</span>"
		return

	if(!spam_flag)
		spam_flag = 1
		cooldowntime = 30
		turn_on()
		if (on)
			playsound(src.loc, engine_start, 100, 0, 44100)
			usr << "<span class='notice'>You start [src]'s engine.</span>"
			spawn(cooldowntime)
				spam_flag = 0
		else
			if(cell.charge < charge_use)
				usr << "<span class='warning'>[src] is out of power.</span>"
			else
				spam_flag = 1
				cooldowntime = 20
				usr << "<span class='warning'>[src]'s engine won't start.</span>"
				playsound(src.loc, engine_fail, 80, 0, 44100)
				spawn(cooldowntime)
					spam_flag = 0

/obj/vehicle/train/cargo/engine/motorcycle/stop_engine()
	set name = "Stop engine"
	set category = "Vehicle"
	set src in view(0)

	if(!istype(usr, /mob/living/carbon/human))
		return

	if(!on)
		usr << "<span class='warning'>The engine is already stopped.</span>"
		return

	turn_off()
	if (!on)
		usr << "<span class='notice'>You stop [src]'s engine.</span>"

/obj/vehicle/train/cargo/engine/motorcycle/turn_on()
	if(!key)
		return
	if(health <= 10)
		return
	else
		..()

/obj/vehicle/train/cargo/engine/motorcycle/proc/update_dir_motorcycle_overlays()
	overlays = null
	if(src.dir == NORTH||SOUTH)
		if(src.dir == NORTH)
			var/image/I = new(icon = 'icons/vehicles/motorcycle.dmi', icon_state = "motorcycle_overlay_n", layer = src.layer + 0.2) //over mobs
			overlays += I
		else if(src.dir == SOUTH)
			var/image/I = new(icon = 'icons/vehicles/motorcycle.dmi', icon_state = "motorcycle_overlay_s", layer = src.layer + 0.2) //over mobs
			overlays += I
	else
		var/image/I = new(icon = 'icons/vehicles/motorcycle.dmi', icon_state = "motorcycle_overlay_side", layer = src.layer + 0.2) //over mobs
		overlays += I

/obj/vehicle/train/cargo/engine/motorcycle/New()
	..()
	update_dir_motorcycle_overlays()
	populate_verbs()

/obj/vehicle/train/cargo/engine/motorcycle/Move()
	..()
	update_dir_motorcycle_overlays()

/obj/vehicle/train/cargo/engine/motorcycle/handle_rotation()
	update_dir_motorcycle_overlays() //this goes first, because vehicle/handle_rotation() just returns
	..()

/obj/vehicle/train/cargo/engine/motorcycle/populate_verbs()
	..()
	verbs -= /obj/vehicle/train/cargo/engine/motorcycle/stop_engine
	verbs -= /obj/vehicle/train/cargo/engine/motorcycle/start_engine
	verbs -= /obj/vehicle/train/verb/unlatch_v