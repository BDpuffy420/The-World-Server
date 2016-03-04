/obj
	var/can_buckle = 0
	var/buckle_movable = 0
	var/buckle_lying = -1 //bed-like behavior, forces mob.lying = buckle_lying if != -1
	var/buckle_require_restraints = 0 //require people to be handcuffed before being able to buckle. eg: pipes
	var/mob/living/buckled_mob = null

/obj/attack_hand(mob/living/user)
	. = ..()
	if(can_buckle && buckled_mob)
		if(user_unbuckle_mob(user))
			return 1
/obj/MouseDrop_T(mob/living/M, mob/living/user)
	. = ..()
	if(can_buckle && istype(M))
		if(user_buckle_mob(M, user))
			return 1
/obj/Destroy()
	. = ..()
	unbuckle_mob()


/obj/proc/buckle_mob(mob/living/M)
	if(!can_buckle || !istype(M) || (M.loc != loc) || M.buckled || M.pinned.len || (buckle_require_restraints && !M.restrained()))
		return 0

	if (isslime(M) || isAI(M))
		if(M == usr)
			M << "<span class='warning'>You are too squishy to buckle yourself to the [src]!</span>"
		else
			usr << "<span class='warning'>The [M] is too squishy to buckle to the [src].!</span>"
		return 0

	M.buckled = src
	M.dir = dir
	buckled_mob = M
	M.update_canmove()
	post_buckle_mob(M)
	//M.throw_alert("buckled", new_master = src) #TOREMOVE

	return 1

/obj/buckle_mob(mob/living/M)
	. = ..()
	if(.)
		if(burn_state == 1) //Sets the mob on fire if you buckle them to a burning atom/movableect
			M.adjust_fire_stacks(1)
			M.IgniteMob()

/obj/proc/unbuckle_mob()
	if(buckled_mob && buckled_mob.buckled == src)
		. = buckled_mob
		buckled_mob.buckled = null
		buckled_mob.anchored = initial(buckled_mob.anchored)
		buckled_mob.update_canmove()
		buckled_mob = null

		post_buckle_mob(.)

/obj/proc/post_buckle_mob(mob/living/M)
	return

/obj/proc/user_buckle_mob(mob/living/M, mob/user)
	if(!ticker)
		user << "<span class='warning'>You can't buckle anyone in before the game starts.</span>"
		return 0
	if(!user.Adjacent(M) || user.restrained() || user.lying || user.stat || istype(user, /mob/living/silicon/pai))
		return 0

	if(istype(M, /mob/living/carbon/slime))
		user << "<span class='warning'>The [M] is too squishy to buckle in.</span>"
		return 0

	add_fingerprint(user)
	unbuckle_mob()

	if(buckle_mob(M))
		if(M == user)
			M.visible_message(\
				"<span class='notice'>[M.name] buckles themselves to [src].</span>",\
				"<span class='notice'>You buckle yourself to [src].</span>",\
				"<span class='italics'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='warning'>[M.name] is buckled to [src] by [user.name]!</span>",\
				"<span class='warning'>You are buckled to [src] by [user.name]!</span>",\
				"<span class='italics'>You hear metal clanking.</span>")
		return 1

/obj/proc/user_unbuckle_mob(mob/user)
	var/mob/living/M = unbuckle_mob()
	if(M)
		if(M != user)
			M.visible_message(\
				"<span class='notice'>[M.name] was unbuckled by [user.name]!</span>",\
				"<span class='notice'>You were unbuckled from [src] by [user.name].</span>",\
				"<span class='italics'>You hear metal clanking.</span>")
		else
			M.visible_message(\
				"<span class='notice'>[M.name] unbuckled themselves!</span>",\
				"<span class='notice'>You unbuckle yourself from [src].</span>",\
				"<span class='italics'>You hear metal clanking.</span>")
		add_fingerprint(user)
	return M

