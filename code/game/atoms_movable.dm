/atom/movable
	layer = 3
	var/last_move = null
	var/anchored = 0
	// var/elevation = 2    - not used anywhere
	var/move_speed = 10
	var/l_move_time = 1
	var/m_flag = 1
	var/throwing = 0
	var/thrower
	var/turf/throw_source = null
	var/throw_speed = 2
	var/throw_range = 7
	var/moved_recently = 0
	var/mob/pulledby = null
	var/inertia_dir = 0

	var/auto_init = 1


/atom/movable/Del()
	if(isnull(gcDestroyed) && loc)
		testing("GC: -- [type] was deleted via del() rather than qdel() --")
//		generate_debug_runtime() // stick a stack trace in the runtime logs
//	else if(isnull(gcDestroyed))
//		testing("GC: [type] was deleted via GC without qdel()") //Not really a huge issue but from now on, please qdel()
//	else
//		testing("GC: [type] was deleted via GC with qdel()")
	..()

/atom/movable/Destroy()
	. = ..()
	if(reagents)
		qdel(reagents)
		reagents = null
	for(var/atom/movable/AM in contents)
		qdel(AM)
	loc = null
	if (pulledby)
		if (pulledby.pulling == src)
			pulledby.pulling = null
		pulledby = null

/atom/movable/proc/initialize()
	return

/atom/movable/Bump(var/atom/A, yes)
	if((A && yes))
		if(throwing)
			throwing = 0
			throw_impact(A)
			. = 1
		A.Bumped(src)

/atom/movable/proc/forceMove(atom/destination)
	if(destination)
		if(loc)
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		for(var/atom/movable/AM in loc)
			AM.Crossed(src)
		return 1
	return 0

//Called whenever an object moves and by mobs when they attempt to move themselves through space
//And when an object or action applies a force on src, see newtonian_move() below
//Return 0 to have src start/keep drifting in a no-grav area and 1 to stop/not start drifting
//Mobs should return 1 if they should be able to move of their own volition, see client/Move() in mob_movement.dm
//movement_dir == 0 when stopping or any dir when trying to move
/atom/movable/proc/Process_Spacemove(movement_dir = 0)

	var/area/A = get_area(src)   //modified for bs12
	if(A.has_gravity)
		return 1

	//if(has_gravity(src))
	//	return 1

	if(pulledby)
		return 1

	if(locate(/obj/structure/lattice) in range(1, get_turf(src))) //Not realistic but makes pushing things in space easier
		return 1

	return 0

/atom/movable/proc/newtonian_move(direction) //Only moves the object if it's under no gravity

	if(!loc || Process_Spacemove(0))
		inertia_dir = 0
		return 0

	inertia_dir = direction
	if(!direction)
		return 1

	var/old_dir = dir
	. = step(src, direction)
	dir = old_dir

//called when src is thrown into hit_atom
/atom/movable/proc/throw_impact(atom/hit_atom, var/speed)
	if(istype(hit_atom,/mob/living))
		var/mob/living/M = hit_atom
		M.hitby(src,speed)

	else if(isobj(hit_atom))
		var/obj/O = hit_atom
		if(!O.anchored)
			step(O, src.dir)
		O.hitby(src,speed)

	else if(isturf(hit_atom))
		src.throwing = 0
		var/turf/T = hit_atom
		if(T.density)
			spawn(2)
				step(src, turn(src.dir, 180))
			if(istype(src,/mob/living))
				var/mob/living/M = src
				M.turf_collision(T, speed)

//decided whether a movable atom being thrown can pass through the turf it is in.
/atom/movable/proc/hit_check(var/speed)
	if(src.throwing)
		for(var/atom/A in get_turf(src))
			if(A == src) continue
			if(istype(A,/mob/living))
				if(A:lying) continue
				src.throw_impact(A,speed)
			if(isobj(A))
				if(A.density && !A.throwpass)	// **TODO: Better behaviour for windows which are dense, but shouldn't always stop movement
					src.throw_impact(A,speed)

/atom/movable/proc/throw_at(atom/target, range, speed, thrower, spin=1, diagonals_first = 0)
	if(!target || !src || (flags & NODROP))	return 0
	//use a modified version of Bresenham's algorithm to get from the atom's current position to that of the target

	throwing = 1
	if(spin) //if we don't want the /atom/movable to spin.
		SpinAnimation(5, 1)
	src.thrower = thrower
	src.throw_source = get_turf(src)	//store the origin turf

	if(usr)
		if(HULK in usr.mutations)
			src.throwing = 2 // really strong throw!

	var/dist_travelled = 0
	var/dist_since_sleep = 0

	var/dist_x = abs(target.x - src.x)
	var/dist_y = abs(target.y - src.y)
	var/dx = (target.x > src.x) ? EAST : WEST
	var/dy = (target.y > src.y) ? NORTH : SOUTH

	var/pure_diagonal = 0
	if(dist_x == dist_y)
		pure_diagonal = 1

	if(dist_x <= dist_y)
		var/olddist_x = dist_x
		var/olddx = dx
		dist_x = dist_y
		dist_y = olddist_x
		dx = dy
		dy = olddx

	var/error = dist_x/2 - dist_y //used to decide whether our next move should be forward or diagonal.
	var/atom/finalturf = get_turf(target)
	var/area/a = get_area(src.loc)
	var/hit = 0
	var/init_dir = get_dir(src, target)

	while(target &&((dist_travelled < range && loc != finalturf) || (a && a.has_gravity == 0)  || istype(src.loc, /turf/space)) && src.throwing)

		if(!istype(loc, /turf))
			hit = 1
			break

		var/atom/step
		if(dist_travelled < max(dist_x, dist_y)) //if we haven't reached the target yet we home in on it, otherwise we use the initial direction
			step = get_step(src, get_dir(src, finalturf))
		else
			step = get_step(src, init_dir)

		if(!pure_diagonal && !diagonals_first) // not a purely diagonal trajectory and we don't want all diagonal moves to be done first
			if(error >= 0 && max(dist_x,dist_y) - dist_travelled != 1) //we do a step forward unless we're right before the target
				step = get_step(src, dx)
			error += (error < 0) ? dist_x/2 : -dist_y
		if(!step) // going off the edge of the map makes get_step return null, don't let things go off the edge
			break
		Move(step, get_dir(loc, step))
		if(!throwing) // we hit something during our move
			hit = 1
			break
		dist_travelled++
		dist_since_sleep++

		if(dist_travelled > 600) //safety to prevent infinite while loop.
			break
		if(dist_since_sleep >= speed)
			dist_since_sleep = 0
			sleep(1)

		if(!dist_since_sleep && hitcheck()) //to catch sneaky things moving on our tile during our sleep(1)
			hit = 1
			break

	//done throwing, either because it hit something or it finished moving
	throwing = 0
	thrower = null
	throw_source = null
	if(!hit)
		for(var/atom/A in get_turf(src)) //looking for our target on the turf we land on.
			if(A == target)
				hit = 1
				throw_impact(A)
				return 1

		throw_impact(get_turf(src))  // we haven't hit something yet and we still must, let's hit the ground.
		return 1

/atom/movable/proc/hitcheck()
	for(var/atom/movable/AM in get_turf(src))
		if(AM == src)
			continue
		if(AM.density && !(AM.pass_flags & LETPASSTHROW) && !(AM.flags & ON_BORDER))
			throwing = 0
			throw_impact(AM)
			return 1

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	for(var/x in src.verbs)
		src.verbs -= x
	return

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/proc/water_act(var/volume, var/temperature, var/source) //amount of water acting : temperature of water in kelvin : object that called it (for shennagins)
	return 1