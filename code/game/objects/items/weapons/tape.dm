/* All things tape-related
 * Contains:
 * 		Tape rolls
 * 		Duct tape muzzle
 * 		Tape-related crafting
 *
 * 		Notes:This used to be a subtype of stack, but the inheritance was getting
 *		to be more of a nuisance than a help. Feel free to refactor if you really want to.
 */

/*
 * Tape
 */

/obj/item/tape_roll
	name = "tape roll"
	desc = "A roll of sticky tape. Possibly for taping ducks... or was that ducts?"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "taperoll"
	w_class = 1
	var/amount = 10
	burn_state = 0

//|| proc overrides
/obj/item/tape_roll/New(var/loc, var/amount=null)
	..()
	update_icon()

/obj/item/tape_roll/examine(mob/user)
	if(..(user, 1))
		if(src.amount == 1) user << "There is enough tape here to make [src.amount] more piece."
		else
			user << "There is enough tape here to make [src.amount] more pieces."

//| Ripping a piece of tape off. It works, but there is currently no use for the tape pieces so I'm leaving it commented out until we find one : )
/*
/obj/item/tape_roll/attack_self(mob/user as mob)
	var/obj/item/ducttape/T = rip()
	if (T)
		user << "You remove a length of tape from [src]."
		user.put_in_hands(T)
		src.add_fingerprint(user)
		T.add_fingerprint(user)

	else new/obj/item/trash/tape_roll(src.loc)

/obj/item/tape_roll/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src)
		var/obj/item/ducttape/T = rip()
		if (T)
			user << "You remove a length of tape from [src]."
			user.put_in_hands(T)
			src.add_fingerprint(user)
			T.add_fingerprint(user)
	else
		..()
	return

//|| rip off a piece of tape
/obj/item/tape_roll/proc/rip()
	if (!amount)
		return null

	if(use(1))
		var/obj/item/ducttape/piece = new()
		transfer_fingerprints_to(piece)
		if(blood_DNA)
			piece.blood_DNA |= blood_DNA
		return piece

*/

//| stick to a piece of paper so that it can be stuck to things
/obj/item/tape_roll/proc/stick(var/obj/item/weapon/W, mob/user)
	if(!istype(W, /obj/item/weapon/paper))
		return

	user.unEquip(W)
	var/obj/item/ducttape/stuckto = new(get_turf(src))
	stuckto.attach(W)
	user.put_in_hands(stuckto)

//| this proc consumes a piece of tape
/obj/item/tape_roll/proc/use(var/used)
	if (amount < used)
		return 0

	amount -= used
	src.update_icon()
	playsound(loc, 'sound/items/ducttape1.ogg', 50, 1)

	if (amount <= 0)
		if(usr)
			usr.unEquip(src)
			var/obj/item/trash/tape_roll/trash = new (usr.loc)
			usr.put_in_hands(trash)
		qdel(src)
	return 1

/obj/item/tape_roll/update_icon()
	if((amount <= 2) && (amount > 0))
		icon_state = "taperoll"
	if((amount <= 4) && (amount > 2))
		icon_state = "taperoll-2"
	if((amount <= 6) && (amount > 4))
		icon_state = "taperoll-3"
	if(amount > 6)
		icon_state = "taperoll-4"

/obj/item/ducttape
	name = "tape"
	desc = "A piece of sticky tape."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape"
	w_class = 1
	layer = 4
	anchored = 1 //it's sticky, no you cant move it
	burn_state = 0

	var/obj/item/weapon/stuck = null

//| show the desc of the paper if there is one
/obj/item/ducttape/examine(mob/user)
	if(stuck) return stuck.examine(user)
	..()

/obj/item/ducttape/proc/attach(var/obj/item/weapon/W)
	stuck = W
	W.forceMove(src)
	icon_state = W.icon_state + "_taped"
	name = W.name + " (taped)"
	overlays = W.overlays

/obj/item/ducttape/attack_self(mob/user)
	if(!stuck)
		return

	playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
	user << "You remove \the [initial(name)] from [stuck]."

	user.unEquip(src)
	stuck.forceMove(get_turf(src))
	user.put_in_hands(stuck)
	stuck = null
	overlays = null
	qdel(src)

/obj/item/ducttape/afterattack(var/A, mob/user, flag, params)
	if(!in_range(user, A) || istype(A, /obj/machinery/door) || !stuck)
		return

	var/turf/target_turf = get_turf(A)
	var/turf/source_turf = get_turf(user)

	var/dir_offset = 0
	if(target_turf != source_turf)
		dir_offset = get_dir(source_turf, target_turf)
		if(!(dir_offset in cardinal))
			user << "You cannot reach that from here."		// can only place stuck papers in cardinal directions, to
			return											// reduce papers around corners issue.

	user.unEquip(src)
	forceMove(source_turf)

	if(params)
		var/list/mouse_control = params2list(params)
		if(mouse_control["icon-x"])
			pixel_x = text2num(mouse_control["icon-x"]) - 16
			if(dir_offset & EAST)
				pixel_x += 32
			else if(dir_offset & WEST)
				pixel_x -= 32
		if(mouse_control["icon-y"])
			pixel_y = text2num(mouse_control["icon-y"]) - 16
			if(dir_offset & NORTH)
				pixel_y += 32
			else if(dir_offset & SOUTH)
				pixel_y -= 32

//|Duct taping a person's mouth shut

/obj/item/tape_roll/attack(mob/living/target as mob, mob/living/user as mob)
	if(ishuman(target) && (user.zone_sel.selecting == "mouth" || user.zone_sel.selecting == "head"))
		var/mob/living/carbon/human/H = target
		if( \
				(H.head && H.head.flags & HEADCOVERSMOUTH) || \
				(H.wear_mask && H.wear_mask.flags & MASKCOVERSMOUTH) \
			)
			user << "<span class='danger'>You're going to need to remove that mask/helmet first.</span>"
			return
		playsound(loc, 'sound/items/ducttape1.ogg', 30, 1)
		if(do_after(user, 20, 10, target = src))
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/muzzle/tape(H), slot_wear_mask)
			user << "<span class='notice'>You tape [H]'s mouth.</span>"
			H.update_inv_wear_mask()
			use(1)
			add_logs(user, H, "mouth-taped")
		else
			user << "<span class='warning'>You fail to tape [H]'s mouth.</span>"

/obj/item/clothing/mask/muzzle/tape
	name = "tape"
	desc = "Taking that off is going to hurt."
	icon_state = "tape"
	item_state = "tape"
	flags = MASKCOVERSMOUTH
	w_class = 2
	gas_transfer_coefficient = 0.90
	var/used = 0

/obj/item/clothing/mask/muzzle/tape/attack_hand(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		return ..()
	var/mob/living/carbon/human/H = user
	if(loc == user && H.wear_mask == src)
		qdel(src)
		user << "<span class='danger'>You take off the duct tape. It's not pleasant.</span>"
		playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
		H.apply_damage(2, BRUTE, "head")
	else
		..()

/obj/item/clothing/mask/muzzle/tape/dropped(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		return ..()
	var/mob/living/carbon/human/H = user
	..()
	if(H.wear_mask == src && !src.used)
		user << "<span class='danger'>Your tape was forcefully removed from your mouth. It's not pleasant.</span>"
		playsound(user, 'sound/items/ducttape2.ogg', 50, 1)
		H.apply_damage(2, BRUTE, "head")
		src.used = 1
		src.desc = "This one appears to be used."
		user.unEquip(src)
		qdel(src)

/*
 * Crafting recipes below
 */

/obj/item/tape_roll/afterattack(W, mob/user as mob)
	if(istype(W, /obj/item/weapon/shard))
		var/obj/item/weapon/shank/new_item = new(user.loc)
		user << "<span class='notice'>You use [src] to turn [W] into [new_item].</span>"
		var/replace = (user.get_inactive_hand()==W)
		qdel(W)
		src.use(1)
		if(replace)
			user.put_in_hands(new_item)
		playsound(user, 'sound/items/ducttape1.ogg', 50, 1)