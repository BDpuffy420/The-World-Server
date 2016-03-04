/obj/item/weapon/phone
	name = "red phone"
	desc = "Should anything ever go wrong..."
	icon = 'icons/obj/items.dmi'
	icon_state = "red_phone"
	flags = CONDUCT
	force = 3.0
	throwforce = 2.0
	throw_speed = 1
	throw_range = 4
	w_class = 2
	attack_verb = list("called", "rang")
	hitsound = 'sound/weapons/ring.ogg'

/obj/item/weapon/rsp
	name = "\improper Rapid-Seed-Producer (RSP)"
	desc = "A device used to rapidly deploy seeds."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 0
	var/mode = 1
	w_class = 3.0

/obj/item/weapon/soap
	name = "soap"
	desc = "A cheap bar of soap. Doesn't smell."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "soap"
	w_class = 2.0
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/soap/nanotrasen
	desc = "A Nanotrasen brand bar of soap. Smells of plasma."
	icon_state = "soapnt"

/obj/item/weapon/soap/deluxe
	icon_state = "soapdeluxe"

/obj/item/weapon/soap/deluxe/New()
	desc = "A deluxe Waffle Co. brand bar of soap. Smells of [pick("lavender", "vanilla", "strawberry", "chocolate" ,"space")]."

/obj/item/weapon/soap/syndie
	desc = "An untrustworthy bar of soap. Smells of fear."
	icon_state = "soapsyndie"

/obj/item/weapon/c_tube
	name = "cardboard tube"
	desc = "A tube... of cardboard."
	icon = 'icons/obj/items.dmi'
	icon_state = "c_tube"
	throwforce = 1
	w_class = 2.0
	throw_speed = 4
	throw_range = 5


/obj/item/weapon/cane
	name = "cane"
	desc = "A cane used by a true gentlemen. Or a clown."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"
	flags = CONDUCT
	force = 5.0
	throwforce = 7.0
	w_class = 2.0
	materials = list(MAT_METAL=50)
	attack_verb = list("bludgeoned", "whacked", "disciplined", "thrashed")

/obj/item/weapon/disk
	name = "disk"
	icon = 'icons/obj/items.dmi'

/obj/item/weapon/disk/nuclear
	name = "nuclear authentication disk"
	desc = "Better keep this safe."
	icon_state = "nucleardisk"
	item_state = "card-id"
	w_class = 2.0

/*
/obj/item/weapon/game_kit
	name = "Gaming Kit"
	icon = 'icons/obj/items.dmi'
	icon_state = "game_kit"
	var/selected = null
	var/board_stat = null
	var/data = ""
	var/base_url = "http://svn.slurm.us/public/spacestation13/misc/game_kit"
	item_state = "sheet-metal"
	w_class = 5.0
*/

/obj/item/weapon/gift
	name = "gift"
	desc = "A wrapped item."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift3"
	var/size = 3.0
	var/obj/item/gift = null
	item_state = "gift"
	w_class = 4.0

/obj/item/weapon/caution
	desc = "Caution! Wet Floor!"
	name = "wet floor sign"
	icon = 'icons/obj/janitor.dmi'
	icon_state = "caution"
	force = 1.0
	throwforce = 3.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	attack_verb = list("warned", "cautioned", "smashed")

/obj/item/weapon/caution/cone
	desc = "This cone is trying to warn you of something!"
	name = "warning cone"
	icon_state = "cone"

/*
/obj/item/weapon/syndicate_uplink
	name = "station bounced radio"
	desc = "Remain silent about this..."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 10.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/mob/currentUser = null
	var/obj/item/device/radio/origradio = null
	flags = CONDUCT | ONBELT
	w_class = 2.0
	item_state = "radio"
	throw_speed = 4
	throw_range = 20
	materials = list(MAT_METAL=100
	origin_tech = "magnets=2;syndicate=3"*/


/obj/item/weapon/SWF_uplink
	name = "station-bounced radio"
	desc = "used to comunicate it appears."
	icon = 'icons/obj/radio.dmi'
	icon_state = "radio"
	var/temp = null
	var/uses = 4.0
	var/selfdestruct = 0.0
	var/traitor_frequency = 0.0
	var/obj/item/device/radio/origradio = null
	flags = CONDUCT
	slot_flags = SLOT_BELT
	item_state = "radio"
	throwforce = 5
	w_class = 2.0
	throw_speed = 4
	throw_range = 20
	materials = list(MAT_METAL=100)
	origin_tech = "magnets=1"

/obj/item/weapon/staff
	name = "wizards staff"
	desc = "Apparently a staff used by the wizard."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "staff"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = NOSHIELD
	attack_verb = list("bludgeoned", "whacked", "disciplined")
	burn_state = 0 //Burnable

/obj/item/weapon/staff/broom
	name = "broom"
	desc = "Used for sweeping, and flying into the night while cackling. Black cat not included."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "broom"

/obj/item/weapon/staff/gentcane
	name = "Gentlemans Cane"
	desc = "An ebony can with an ivory tip."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "cane"
	item_state = "stick"

/obj/item/weapon/staff/stick
	name = "stick"
	desc = "A great tool to drag someone else's drinks across the bar."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "stick"
	item_state = "stick"
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = 2.0
	flags = NOSHIELD

/obj/item/weapon/wire
	desc = "This is just a simple piece of regular insulated wire."
	name = "wire"
	icon = 'icons/obj/power.dmi'
	icon_state = "item_wire"
	var/amount = 1.0
	var/laying = 0.0
	var/old_lay = null
	materials = list(MAT_METAL=40)
	attack_verb = list("whipped", "lashed", "disciplined", "tickled")

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is strangling \himself with the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (OXYLOSS)

/obj/item/weapon/module
	icon = 'icons/obj/module.dmi'
	icon_state = "std_module"
	w_class = 2.0
	item_state = "electronic"
	flags = CONDUCT
	var/mtype = 1						// 1=electronic 2=hardware

/obj/item/weapon/module/card_reader
	name = "card reader module"
	icon_state = "card_mod"
	desc = "An electronic module for reading data and ID cards."

/obj/item/weapon/module/power_control
	name = "power control module"
	icon_state = "power_mod"
	desc = "Heavy-duty switching circuits for power control."
	materials = list(MAT_METAL=50, MAT_GLASS=50)

/obj/item/weapon/module/power_control/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if (istype(W, /obj/item/device/multitool))
		var/obj/item/weapon/circuitboard/ghettosmes/newcircuit = new/obj/item/weapon/circuitboard/ghettosmes(user.loc)
		qdel(src)
		user.put_in_hands(newcircuit)


/obj/item/weapon/module/id_auth
	name = "\improper ID authentication module"
	icon_state = "id_mod"
	desc = "A module allowing secure authorization of ID cards."

/obj/item/weapon/module/cell_power
	name = "power cell regulator module"
	icon_state = "power_mod"
	desc = "A converter and regulator allowing the use of power cells."

/obj/item/weapon/module/cell_power
	name = "power cell charger module"
	icon_state = "power_mod"
	desc = "Charging circuits for power cells."


/obj/item/device/camera_bug
	name = "camera bug"
	icon = 'icons/obj/device.dmi'
	icon_state = "flash"
	w_class = 1.0
	item_state = "electronic"
	throw_speed = 4
	throw_range = 20

/obj/item/weapon/camera_bug/attack_self(mob/usr as mob)
	var/list/cameras = new/list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		if (C.bugged && C.status)
			cameras.Add(C)
	if (length(cameras) == 0)
		usr << "\red No bugged functioning cameras found."
		return

	var/list/friendly_cameras = new/list()

	for (var/obj/machinery/camera/C in cameras)
		friendly_cameras.Add(C.c_tag)

	var/target = input("Select the camera to observe", null) as null|anything in friendly_cameras
	if (!target)
		return
	for (var/obj/machinery/camera/C in cameras)
		if (C.c_tag == target)
			target = C
			break
	if (usr.stat == 2) return

	usr.client.eye = target

/*
/obj/item/weapon/cigarpacket
	name = "Pete's Cuban Cigars"
	desc = "The most robust cigars on the planet."
	icon = 'icons/obj/cigarettes.dmi'
	icon_state = "cigarpacket"
	item_state = "cigarpacket"
	w_class = 1
	throwforce = 2
	var/cigarcount = 6
	flags = ONBELT */

/obj/item/weapon/pai_cable
	desc = "A flexible coated cable with a universal jack on one end."
	name = "data cable"
	icon = 'icons/obj/power.dmi'
	icon_state = "wire1"

	var/obj/machinery/machine