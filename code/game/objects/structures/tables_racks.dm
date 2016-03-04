// Tables and racks.

/obj/structure/table
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures/tables.dmi'
	icon_state = "table"
	density = 1
	anchored = 1.0
	layer = 2.8
	throwpass = 1	//You can throw objects over this, despite it's density.")
	climbable = 1

	var/frame = /obj/structure/table_frame
	parts = /obj/item/weapon/table_parts
	var/flipped = 0
	var/health = 100
	var/busy = 0

/obj/structure/table/proc/update_adjacent()
	for(var/direction in list(1,2,4,8,5,6,9,10))
		if(locate(/obj/structure/table,get_step(src,direction)))
			var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))
			T.update_icon()

/obj/structure/table/New()
	..()
	for(var/obj/structure/table/T in src.loc)
		if(T != src)
			qdel(T)
	update_icon()
	update_adjacent()

/obj/structure/table/Destroy()
	update_adjacent()
	return ..()

/obj/structure/table/proc/destroy()
	new parts(loc)
	density = 0
	qdel(src)

/obj/structure/table/update_icon()
	if(flipped)
		var/type = 0
		var/tabledirs = 0
		for(var/direction in list(turn(dir,90), turn(dir,-90)) )
			var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))
			if (T && T.flipped)
				type++
				tabledirs |= direction
		var/base = "table"
		if (istype(src, /obj/structure/table/wooden))
			base = "wood"
		if (istype(src, /obj/structure/table/reinforced))
			base = "rtable"

		icon_state = "[base]flip[type]"
		if (type==1)
			if (tabledirs & turn(dir,90))
				icon_state = icon_state+"-"
			if (tabledirs & turn(dir,-90))
				icon_state = icon_state+"+"
		return 1

	spawn(2) //So it properly updates when deleting
		var/dir_sum = 0
		for(var/direction in list(1,2,4,8,5,6,9,10))
			var/skip_sum = 0
			for(var/obj/structure/window/W in src.loc)
				if(W.dir == direction) //So smooth tables don't go smooth through windows
					skip_sum = 1
					continue
			var/inv_direction //inverse direction
			switch(direction)
				if(1)
					inv_direction = 2
				if(2)
					inv_direction = 1
				if(4)
					inv_direction = 8
				if(8)
					inv_direction = 4
				if(5)
					inv_direction = 10
				if(6)
					inv_direction = 9
				if(9)
					inv_direction = 6
				if(10)
					inv_direction = 5
			for(var/obj/structure/window/W in get_step(src,direction))
				if(W.dir == inv_direction) //So smooth tables don't go smooth through windows when the window is on the other table's tile
					skip_sum = 1
					continue
			if(!skip_sum) //means there is a window between the two tiles in this direction
				var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,direction))
				if(T && !T.flipped)
					if(direction <5)
						dir_sum += direction
					else
						if(direction == 5)	//This permits the use of all table directions. (Set up so clockwise around the central table is a higher value, from north)
							dir_sum += 16
						if(direction == 6)
							dir_sum += 32
						if(direction == 8)	//Aherp and Aderp.  Jezes I am stupid.  -- SkyMarshal
							dir_sum += 8
						if(direction == 10)
							dir_sum += 64
						if(direction == 9)
							dir_sum += 128

		var/table_type = 0 //stand_alone table
		if(dir_sum%16 in cardinal)
			table_type = 1 //endtable
			dir_sum %= 16
		if(dir_sum%16 in list(3,12))
			table_type = 2 //1 tile thick, streight table
			if(dir_sum%16 == 3) //3 doesn't exist as a dir
				dir_sum = 2
			if(dir_sum%16 == 12) //12 doesn't exist as a dir.
				dir_sum = 4
		if(dir_sum%16 in list(5,6,9,10))
			if(locate(/obj/structure/table,get_step(src.loc,dir_sum%16)))
				table_type = 3 //full table (not the 1 tile thick one, but one of the 'tabledir' tables)
			else
				table_type = 2 //1 tile thick, corner table (treated the same as streight tables in code later on)
			dir_sum %= 16
		if(dir_sum%16 in list(13,14,7,11)) //Three-way intersection
			table_type = 5 //full table as three-way intersections are not sprited, would require 64 sprites to handle all combinations.  TOO BAD -- SkyMarshal
			switch(dir_sum%16)	//Begin computation of the special type tables.  --SkyMarshal
				if(7)
					if(dir_sum == 23)
						table_type = 6
						dir_sum = 8
					else if(dir_sum == 39)
						dir_sum = 4
						table_type = 6
					else if(dir_sum == 55 || dir_sum == 119 || dir_sum == 247 || dir_sum == 183)
						dir_sum = 4
						table_type = 3
					else
						dir_sum = 4
				if(11)
					if(dir_sum == 75)
						dir_sum = 5
						table_type = 6
					else if(dir_sum == 139)
						dir_sum = 9
						table_type = 6
					else if(dir_sum == 203 || dir_sum == 219 || dir_sum == 251 || dir_sum == 235)
						dir_sum = 8
						table_type = 3
					else
						dir_sum = 8
				if(13)
					if(dir_sum == 29)
						dir_sum = 10
						table_type = 6
					else if(dir_sum == 141)
						dir_sum = 6
						table_type = 6
					else if(dir_sum == 189 || dir_sum == 221 || dir_sum == 253 || dir_sum == 157)
						dir_sum = 1
						table_type = 3
					else
						dir_sum = 1
				if(14)
					if(dir_sum == 46)
						dir_sum = 1
						table_type = 6
					else if(dir_sum == 78)
						dir_sum = 2
						table_type = 6
					else if(dir_sum == 110 || dir_sum == 254 || dir_sum == 238 || dir_sum == 126)
						dir_sum = 2
						table_type = 3
					else
						dir_sum = 2 //These translate the dir_sum to the correct dirs from the 'tabledir' icon_state.
		if(dir_sum%16 == 15)
			table_type = 4 //4-way intersection, the 'middle' table sprites will be used.

		if(istype(src,/obj/structure/table/reinforced))
			switch(table_type)
				if(0)
					icon_state = "reinf_table"
				if(1)
					icon_state = "reinf_1tileendtable"
				if(2)
					icon_state = "reinf_1tilethick"
				if(3)
					icon_state = "reinf_tabledir"
				if(4)
					icon_state = "reinf_middle"
				if(5)
					icon_state = "reinf_tabledir2"
				if(6)
					icon_state = "reinf_tabledir3"
		else if(istype(src,/obj/structure/table/wooden/gamblingtable))
			switch(table_type)
				if(0)
					icon_state = "gamble_table"
				if(1)
					icon_state = "gamble_1tileendtable"
				if(2)
					icon_state = "gamble_1tilethick"
				if(3)
					icon_state = "gamble_tabledir"
				if(4)
					icon_state = "gamble_middle"
				if(5)
					icon_state = "gamble_tabledir2"
				if(6)
					icon_state = "gamble_tabledir3"
		else if(istype(src,/obj/structure/table/wooden))
			switch(table_type)
				if(0)
					icon_state = "wood_table"
				if(1)
					icon_state = "wood_1tileendtable"
				if(2)
					icon_state = "wood_1tilethick"
				if(3)
					icon_state = "wood_tabledir"
				if(4)
					icon_state = "wood_middle"
				if(5)
					icon_state = "wood_tabledir2"
				if(6)
					icon_state = "wood_tabledir3"
		else if(istype(src,/obj/structure/table/glasstable))
			var/obj/structure/table/glasstable/T = src
			switch(table_type)
				if(0)
					icon_state = "[T.glasscolor]_glass_table"
				if(1)
					icon_state = "[T.glasscolor]_glass_1tileendtable"
				if(2)
					icon_state = "[T.glasscolor]_glass_1tilethick"
				if(3)
					icon_state = "[T.glasscolor]_glass_tabledir"
				if(4)
					icon_state = "[T.glasscolor]_glass_middle"
				if(5)
					icon_state = "[T.glasscolor]_glass_tabledir2"
				if(6)
					icon_state = "[T.glasscolor]_glass_tabledir3"
		else
			switch(table_type)
				if(0)
					icon_state = "table"
				if(1)
					icon_state = "table_1tileendtable"
				if(2)
					icon_state = "table_1tilethick"
				if(3)
					icon_state = "tabledir"
				if(4)
					icon_state = "table_middle"
				if(5)
					icon_state = "tabledir2"
				if(6)
					icon_state = "tabledir3"
		if (dir_sum in list(1,2,4,8,5,6,9,10))
			dir = dir_sum
		else
			dir = 2

/obj/structure/table/wooden
	name = "wooden table"
	desc = "Do not apply fire to this. Rumour says it burns easily."
	icon_state = "wood_table"
	frame = /obj/structure/table_frame/wood
	parts = /obj/item/weapon/table_parts/wood
	health = 50
	burn_state = 0 //Burnable
	burntime = 20

/obj/structure/table/wooden/fire_act()
	parts = null //won't drop its parts
	..()

/obj/structure/table/glasstable
	name = "glass table"
	desc = "What did I say about leaning on the glass tables? Now you need surgery."
	icon_state = "_glass_table"
	parts = /obj/item/weapon/shard
	health = 50
	var/glasscolor = ""

/obj/structure/table/glasstable/black
	name = "black glass table"
	icon_state = "black_glass_table"
	glasscolor = "black"

/obj/structure/table/glasstable/pink
	name = "pink glass table"
	icon_state = "pink_glass_table"
	glasscolor = "pink"

/obj/structure/table/glasstable/purple
	name = "purple glass table"
	icon_state = "purple_glass_table"
	glasscolor = "purple"

/obj/structure/table/glasstable/red
	name = "red glass table"
	icon_state = "red_glass_table"
	glasscolor = "red"

/obj/structure/table/glasstable/orange
	name = "orange glass table"
	icon_state = "orange_glass_table"
	glasscolor = "orange"

/obj/structure/table/glasstable/grey
	name = "grey glass table"
	icon_state = "grey_glass_table"
	glasscolor = "grey"

/obj/structure/table/glasstable/green
	name = "green glass table"
	icon_state = "green_glass_table"
	glasscolor = "green"

/obj/structure/table/wooden/gamblingtable
	name = "gambling table"
	desc = "A curved wooden table with a thin carpet of green fabric."
	icon_state = "gamble_table"
	parts = /obj/item/weapon/table_parts/gambling

/obj/structure/table/reinforced
	icon_state = "reinf_table"
	health = 200
	parts = /obj/item/weapon/table_parts/reinforced
	var/status = 2

/obj/structure/table/reinforced/flip(var/direction)
	if (status == 2)
		return 0
	else
		return ..()

/obj/structure/table/reinforced/attackby(obj/item/weapon/W as obj, mob/user as mob, params)
	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(0, user))
			if(src.status == 2)
				user << "\blue Now weakening the reinforced table"
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if (do_after(user, 50))
					if(!src || !WT.isOn()) return
					user << "\blue Table weakened"
					src.status = 1
			else
				user << "\blue Now strengthening the reinforced table"
				playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
				if (do_after(user, 50))
					if(!src || !WT.isOn()) return
					user << "\blue Table strengthened"
					src.status = 2
			return
		return

	if (istype(W, /obj/item/weapon/wrench))
		if(src.status == 2)
			return

	..()

/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	health = 100
	parts = /obj/item/weapon/table_parts/rack
	flipped = -1 //Cannot flip.

/obj/structure/table/rack/coatrack
	name = "coat rack"
	desc = "Great for hanging up clothes."
	parts = /obj/item/stack/sheet/wood
	icon = 'icons/obj/coatrack.dmi'
	icon_state = "coatrack0"

/obj/structure/table/rack/grave
	name = "grave"
	desc = "A gravestone where someone has been apparently buried. You can place flowers and gifts on it."
	icon = 'icons/obj/decor.dmi'
	icon_state = "grave1"

/obj/structure/table/examine()
	..()
	if(health > 100)
		usr << "This one looks like it has been reinforced."

/obj/structure/table/Destroy() //#TOREMOVE
	update_adjacent()
	..()

/obj/structure/table/attack_tk() // no telehulk sorry
	return

/obj/structure/table/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))
	if(ismob(mover))
		var/mob/M = mover
		if(M.flying)
			return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	if(locate(/obj/structure/table) in get_turf(mover))
		return 1
	if (flipped)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	return 0

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/obj/structure/table/proc/check_cover(obj/item/projectile/P, turf/from)
	var/turf/cover = flipped ? get_turf(src) : get_step(loc, get_dir(from, loc))
	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if (get_turf(P.original) == cover)
		var/chance = 20
		if (ismob(P.original))
			var/mob/M = P.original
			if (M.lying)
				chance += 20				//Lying down lets you catch less bullets
		if(flipped)
			if(get_dir(loc, from) == dir)	//Flipped tables catch mroe bullets
				chance += 20
			else
				return 1					//But only from one side
		if(prob(chance))
			health -= P.damage/2
			if (health > 0)
				visible_message("<span class='warning'>[P] hits \the [src]!</span>")
				return 0
			else
				visible_message("<span class='warning'>[src] breaks down!</span>")
				destroy()
				return 1
	return 1

/obj/structure/table/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSTABLE))
		return 1
	if (flipped)
		if (get_dir(loc, target) == dir)
			return !density
		else
			return 1
	return 1

/obj/structure/table/MouseDrop_T(obj/O as obj, mob/user as mob)
	..()
	if ((!( istype(O, /obj/item/weapon) ) || user.get_active_hand() != O))
		return
	if(isrobot(user))
		return
	if(!user.drop_item())
		return
	if (O.loc != src.loc)
		step(O, get_dir(O, src))
	return

/obj/structure/table/proc/shatter(var/display_message = 1)
	if (!istype(src, /obj/structure/table/glasstable)) return

	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
		new frame(src.loc)
	qdel(src)
	return

/obj/structure/table/glasstable/tablepush(obj/item/W, mob/user)

	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		var/mob/living/carbon/human/M = G.affecting
		if (istype(G.affecting, /mob/living))
			if(G.affecting.buckled)
				user << "<span class='warning'>[G.affecting] is buckled to [G.affecting.buckled]!</span>"
				return 0
			if(!G.confirm())
				return 0
			if (G.state < 2)
				if(user.a_intent == "hurt")
					G.affecting.loc = src.loc
					G.affecting.Weaken(5)
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					visible_message("<span class='warning'>[src] breaks!</span>")
					M.adjustBruteLoss(5)
					if(prob(50))
						var/obj/item/weapon/shard/S = new(M)
						var/obj/item/organ/external/affecting = M.get_organ("head")
						S.add_blood(M)
						affecting.embed(S) //Lodge the object into the limb
						visible_message("<span class='warning'>The [S] has embedded into [M]'s head!</span>",
													"<span class='userdanger'>You feel [S] lodge into your head!</span>")
						M.emote("scream")
					src.shatter()
				else
					user << "<span class='danger'>You need a better grip to do that!</span>"
					return
			else
				G.affecting.loc = src.loc
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
		else
			if (G.state < 2)
				if(user.a_intent == "hurt")
					if (prob(15))	M.Weaken(5)
					M.apply_damage(8,def_zone = "head")
					visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
					playsound(src.loc, 'sound/weapons/tablehit1.ogg', 50, 1)
				else
					user << "<span class='danger'>You need a better grip to do that!</span>"
					return
			else
				G.affecting.loc = src.loc
				G.affecting.Weaken(5)
				visible_message("<span class='danger'>[G.assailant] puts [G.affecting] on \the [src].</span>")
			qdel(W)
		return

/obj/structure/table/proc/tablepush(obj/item/W, mob/user)
	if(get_dist(src, user) < 2)
		var/obj/item/weapon/grab/G = W
		var/mob/living/carbon/human/M = G.affecting
		if(G.affecting.buckled)
			user << "<span class='warning'>[G.affecting] is buckled to [G.affecting.buckled]!</span>"
			return 0
		if(!G.confirm())
			return 0

		if(G.state < GRAB_AGGRESSIVE)
			if(user.a_intent == "hurt")
				if (prob(15))	M.Weaken(5)
				M.apply_damage(8,def_zone = "head")
				visible_message("<span class='danger'>[G.assailant] slams [G.affecting]'s face against \the [src]!</span>")
				playsound(src.loc, 'sound/weapons/tablehit1.ogg', 50, 1)
			else
				user << "<span class='warning'>You need a better grip to do that!</span>"
				return
		else
			G.affecting.loc = src.loc
			if(G.affecting.stat == CONSCIOUS)
				G.affecting.Weaken(5)
			G.affecting.visible_message("<span class='danger'>[G.assailant] pushes [G.affecting] onto [src].</span>", \
										"<span class='userdanger'>[G.assailant] pushes [G.affecting] onto [src].</span>")
			add_logs(G.assailant, G.affecting, "tabled")
			M = G.affecting
			qdel(W)
			return M
	qdel(W)

/obj/structure/table/attackby(obj/item/W as obj, mob/user as mob, params)
	if (!W) return

	// Handle harm intent grabbing/tabling.
	if (istype(W, /obj/item/weapon/grab))
		tablepush(W, user)
		return

	// Handle dissembly.
	if (istype(W, /obj/item/weapon/wrench))
		if(health > 100)
			user << "<span class='danger'>\The [src] is too well constructed to be collapsed. Weaken it first.</span>"
			return
		user << "<span class='notice'>You locate the bolts and begin disassembling \the [src]...</span>"
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user,50))
			qdel(src)
		return

	// Handle weakening.
	if (istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())
			if(initial(health)>100)
				if(WT.remove_fuel(0, user))
					if(src.health>100)
						user << "<span class='notice'>You start weakening \the [src]...</span>"
						playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
						if(!do_after(user, 50) || !src || health<100 || !WT.isOn())
							return
						user << "<span class='notice'>You have weakened \the [src].</span>"
						health -= 100
					else if(src.health <= 100)
						user << "<span class='notice'>You start strengthening \the [src]...</span>"
						playsound(src.loc, 'sound/items/Welder.ogg', 50, 1)
						if(!do_after(user, 50) || !src || health > 100 || !WT.isOn())
							return
						user << "<span class='notice'>You have strengthened \the [src].</span>"
						health += 100
				update_icon()
			else
				user << "<span class='notice'>\The [src] is too flimsy to be reinforced or weakened.</span>"
			return

	if(isrobot(user))
		return

	if(W.loc != user) // This should stop mounted modules ending up outside the module.
		return

	if(istype(W, /obj/item/weapon/melee/energy/blade))
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, src.loc)
		spark_system.start()
		playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
		playsound(src.loc, "sparks", 50, 1)
		user.visible_message("<span class='danger'>The [src] was sliced apart by [user]!</span>")
		qdel(src)

	if(!(W.flags & ABSTRACT)) //rip more parems rip in peace ;_;
		if(user.drop_item())
			W.Move(loc)
			var/list/click_params = params2list(params)
			//Center the icon where the user clicked.
			if(!click_params || !click_params["icon-x"] || !click_params["icon-y"])
				return
			//Clamp it so that the icon never moves more than 16 pixels in either direction (thus leaving the table turf)
			W.pixel_x = Clamp(text2num(click_params["icon-x"]) - 16, -(world.icon_size/2), world.icon_size/2)
			W.pixel_y = Clamp(text2num(click_params["icon-y"]) - 16, -(world.icon_size/2), world.icon_size/2)

	user.drop_item(src)
	return

/obj/structure/table/proc/straight_table_check(var/direction)
	var/obj/structure/table/T
	for(var/angle in list(-90,90))
		T = locate() in get_step(src.loc,turn(direction,angle))
		if(T && !T.flipped)
			return 0
	T = locate() in get_step(src.loc,direction)
	if (!T || T.flipped)
		return 1
	if (istype(T,/obj/structure/table/reinforced/))
		var/obj/structure/table/reinforced/R = T
		if (R.status == 2)
			return 0
	return T.straight_table_check(direction)

/obj/structure/table/verb/do_flip()
	set name = "Flip table"
	set desc = "Flips a non-reinforced table"
	set category = null
	set src in oview(1)

	if (!can_touch(usr) || ismouse(usr))
		return

	if(!flip(get_cardinal_dir(usr,src)))
		usr << "<span class='notice'>It won't budge.</span>"
		return

	usr.visible_message("<span class='warning'>[usr] flips \the [src]!</span>")

	if(climbable)
		structure_shaken()

	return

/obj/structure/table/proc/do_put()
	set name = "Put table back"
	set desc = "Puts flipped table back"
	set category = "Object"
	set src in oview(1)

	if (!unflip())
		usr << "<span class='notice'>It won't budge.</span>"
		return


/obj/structure/table/proc/flip(var/direction)
	if (flipped)
		return 0

	if( !straight_table_check(turn(direction,90)) || !straight_table_check(turn(direction,-90)) )
		return 0

	verbs -=/obj/structure/table/verb/do_flip
	verbs +=/obj/structure/table/proc/do_put

	var/list/targets = list(get_step(src,dir),get_step(src,turn(dir, 45)),get_step(src,turn(dir, -45)))
	for (var/atom/movable/A in get_turf(src))
		if (!A.anchored)
			spawn(0)
				A.throw_at(pick(targets),1,1)

	dir = direction
	if(dir != NORTH)
		layer = 5
	flipped = 1
	flags |= ON_BORDER
	for(var/D in list(turn(direction, 90), turn(direction, -90)))
		if(locate(/obj/structure/table,get_step(src,D)))
			var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,D))
			T.flip(direction)
	update_icon()
	update_adjacent()

	return 1

/obj/structure/table/proc/unflip()
	if (!flipped)
		return 0

	var/can_flip = 1
	for (var/mob/A in oview(src,0))//src.loc)
		if (istype(A))
			can_flip = 0
	if (!can_flip)
		return 0

	verbs -=/obj/structure/table/proc/do_put
	verbs +=/obj/structure/table/verb/do_flip

	layer = initial(layer)
	flipped = 0
	flags &= ~ON_BORDER
	for(var/D in list(turn(dir, 90), turn(dir, -90)))
		if(locate(/obj/structure/table,get_step(src,D)))
			var/obj/structure/table/T = locate(/obj/structure/table,get_step(src,D))
			T.unflip()
	update_icon()
	update_adjacent()

	return 1

// No need to handle any of this, racks are not contiguous..
/obj/structure/table/rack/update_icon()
	return
/obj/structure/table/rack/update_adjacent()
	return