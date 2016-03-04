//| used to determine whether or not an item can light something on fire
/proc/is_hot(obj/item/W)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/O = W
		if(O.isOn())
			return 3800
		else
			return 0
	if(istype(W, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/O = W
		if(O.lit)
			return 1500
		else
			return 0
	if(istype(W, /obj/item/weapon/match))
		var/obj/item/weapon/match/O = W
		if(O.lit == 1)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/clothing/mask/cigarette))
		var/obj/item/clothing/mask/cigarette/O = W
		if(O.lit)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/weapon/flame/candle))
		var/obj/item/weapon/flame/candle/O = W
		if(O.lit)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/device/flashlight/flare))
		var/obj/item/device/flashlight/flare/O = W
		if(O.on)
			return 1000
		else
			return 0
	if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		return 3800
	if(istype(W, /obj/item/weapon/melee/energy))
		var/obj/item/weapon/melee/energy/O = W
		if(O.active)
			return 3500
		else
			return 0
	if(istype(W, /obj/item/device/assembly/igniter))
		return 1000
	else
		return 0

//Quick type checks for some tools
var/global/list/common_tools = list(
/obj/item/stack/cable_coil,
/obj/item/weapon/wrench,
/obj/item/weapon/weldingtool,
/obj/item/weapon/screwdriver,
/obj/item/weapon/wirecutters,
/obj/item/device/multitool,
/obj/item/weapon/crowbar)

/proc/istool(O)
	if(O && is_type_in_list(O, common_tools))
		return 1
	return 0

/proc/iswrench(O)
	if(istype(O, /obj/item/weapon/wrench))
		return 1
	return 0

/proc/iswelder(O)
	if(istype(O, /obj/item/weapon/weldingtool))
		return 1
	return 0

/proc/iscoil(O)
	if(istype(O, /obj/item/stack/cable_coil))
		return 1
	return 0

/proc/iswirecutter(O)
	if(istype(O, /obj/item/weapon/wirecutters))
		return 1
	return 0

/proc/isscrewdriver(O)
	if(istype(O, /obj/item/weapon/screwdriver))
		return 1
	return 0

/proc/ismultitool(O)
	if(istype(O, /obj/item/device/multitool))
		return 1
	return 0

/proc/iscrowbar(O)
	if(istype(O, /obj/item/weapon/crowbar))
		return 1
	return 0

/proc/iswire(O)
	if(istype(O, /obj/item/stack/cable_coil))
		return 1
	return 0

//Whether or not the given item counts as sharp in terms of dealing damage
/proc/is_sharp(obj/O as obj)
	if (!O) return 0
	if (O.sharp) return 1
	if (O.edge) return 1
	return 0

//Whether or not the given item counts as cutting with an edge in terms of removing limbs
/proc/has_edge(obj/O as obj)
	if (!O) return 0
	if (O.edge) return 1
	return 0

//Returns 1 if the given item is capable of popping things like balloons, inflatable barriers, or cutting police tape.
/proc/can_puncture(obj/item/W as obj)		// For the record, WHAT THE HELL IS THIS METHOD OF DOING IT?
	if(!W) return 0
	if(W.sharp) return 1
	return ( \
		W.sharp													  || \
		istype(W, /obj/item/weapon/screwdriver)                   || \
		istype(W, /obj/item/weapon/pen)                           || \
		istype(W, /obj/item/weapon/weldingtool)					  || \
		istype(W, /obj/item/weapon/lighter/zippo)			      || \
		istype(W, /obj/item/weapon/match)            			  || \
		istype(W, /obj/item/clothing/mask/cigarette) 		      || \
		istype(W, /obj/item/weapon/shovel) \
	)

/proc/is_surgery_tool(obj/item/W as obj)
	return (	\
	istype(W, /obj/item/weapon/scalpel)			||	\
	istype(W, /obj/item/weapon/hemostat)		||	\
	istype(W, /obj/item/weapon/retractor)		||	\
	istype(W, /obj/item/weapon/cautery)			||	\
	istype(W, /obj/item/weapon/bonegel)			||	\
	istype(W, /obj/item/weapon/bonesetter)
	)