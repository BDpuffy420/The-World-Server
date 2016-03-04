/* Cards
 * Contains:
 *		DATA CARD
 *		ID CARD
 *		FINGERPRINT CARD HOLDER
 *		FINGERPRINT CARD
 */



/*
 * DATA CARDS - Used for the teleporter
 */
/obj/item/weapon/card
	name = "card"
	desc = "Does card things."
	icon = 'icons/obj/card.dmi'
	w_class = 1.0
	var/associated_account_number = 0

	var/list/files = list(  )

/obj/item/weapon/card/data
	name = "data disk"
	desc = "A disk of data."
	icon_state = "data"
	var/function = "storage"
	var/data = "null"
	var/special = null
	item_state = "card-id"

/obj/item/weapon/card/data/verb/label(t as text)
	set name = "Label Disk"
	set category = "Object"
	set src in usr

	if (t)
		src.name = text("data disk- '[]'", t)
	else
		src.name = "data disk"
	src.add_fingerprint(usr)
	return

/obj/item/weapon/card/data/clown
	name = "\proper the coordinates to clown planet"
	icon_state = "data"
	item_state = "card-id"
	layer = 3
	level = 2
	desc = "This card contains coordinates to the fabled Clown Planet. Handle with care."
	function = "teleporter"
	data = "Clown Land"

/*
 * ID CARDS
 */

/obj/item/weapon/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"

/obj/item/weapon/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = "magnets=2;syndicate=2"
	flags = NOBLUDGEON
	var/uses = 10
	// List of devices that cost a use to emag.
	var/list/devices = list(
		/obj/item/robot_parts,
		/obj/item/weapon/storage/lockbox,
		/obj/item/weapon/storage/secure,
		/obj/item/weapon/circuitboard,
		/obj/item/weapon/rig,
		/obj/item/device/eftpos,
		/obj/item/device/lightreplacer,
		/obj/item/device/taperecorder,
		/obj/item/device/hailer,
		/obj/item/device/megaphone,
		/obj/item/clothing/tie/holobadge,
		/obj/structure/closet/crate/secure,
		/obj/structure/closet/secure_closet,
		/obj/machinery/librarycomp,
		/obj/machinery/computer,
		/obj/machinery/power,
		/obj/machinery/suspension_gen,
		/obj/machinery/shield_capacitor,
		/obj/machinery/shield_gen,
		/obj/machinery/clonepod,
		/obj/machinery/deployable,
		/obj/machinery/door_control,
		/obj/machinery/porta_turret,
		/obj/machinery/shieldgen,
		/obj/machinery/turretid,
		/obj/machinery/vending,
		/obj/machinery/bot,
		/obj/machinery/door,
		/obj/machinery/telecomms,
		/obj/machinery/mecha_part_fabricator,
		/obj/machinery/gibber,
		/obj/vehicle
		)

/obj/item/weapon/card/emag/attack()
	return

/obj/item/weapon/card/emag/afterattack(atom/target, mob/user, proximity)

	if(uses<1)
		user.visible_message("[src] fizzles and sparks - it seems it's been used once too often, and is now broken.")
		user.drop_item()
		var/obj/item/weapon/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)
		return

	var/atom/A = target
	if(!proximity) return
	A.emag_act(user)

	for(var/type in devices)
		if(istype(target,type))
			uses--
			break

/obj/item/weapon/card/id
	name = "identification card"
	desc = "A card used to provide ID and determine access across the station."
	icon_state = "id"
	item_state = "card-id"
	var/access = list()
	var/registered_name = "Unknown" // The name registered_name on the card
	slot_flags = SLOT_ID

	var/blood_type = "\[UNSET\]"
	var/dna_hash = "\[UNSET\]"
	var/fingerprint_hash = "\[UNSET\]"

	//alt titles are handled a bit weirdly in order to unobtrusively integrate into existing ID system
	var/assignment = null	//can be alt title or the actual job
	var/rank = null			//actual job
	var/dorm = 0		// determines if this ID has claimed a dorm already

/obj/item/weapon/card/id/New()
	..()
	spawn(30)
	if(istype(loc, /mob/living/carbon/human))
		blood_type = loc:dna:b_type
		dna_hash = loc:dna:unique_enzymes
		fingerprint_hash = md5(loc:dna:uni_identity)

/obj/item/weapon/card/id/attack_self(mob/user as mob)
	for(var/mob/O in viewers(user, null))
		O.show_message(text("[] shows you: \icon[] []: assignment: []", user, src, src.name, src.assignment), 1)

	src.add_fingerprint(user)
	return

/obj/item/weapon/card/id/GetAccess()
	return access

/obj/item/weapon/card/id/GetID()
	return src

/obj/item/weapon/card/id/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W,/obj/item/weapon/id_wallet))
		user << "You slip [src] into [W]."
		src.name = "[src.registered_name]'s [W.name] ([src.assignment])"
		src.desc = W.desc
		src.icon = W.icon
		src.icon_state = W.icon_state
		qdel(W)
		return

/obj/item/weapon/card/id/verb/read()
	set name = "Read ID Card"
	set category = "Object"
	set src in usr

	usr << text("\icon[] []: The current assignment on the card is [].", src, src.name, src.assignment)
	usr << "The blood type on the card is [blood_type]."
	usr << "The DNA hash on the card is [dna_hash]."
	usr << "The fingerprint hash on the card is [fingerprint_hash]."
	return


/obj/item/weapon/card/id/silver
	name = "identification card"
	desc = "A silver card which shows honour and dedication."
	icon_state = "silver"
	item_state = "silver_id"

/obj/item/weapon/card/id/housekeys
	name = "house keys"
	desc = "A silver key attached to a metal keyring."
	icon = 'icons/obj/vehicles.dmi'
	icon_state = "keys"


/obj/item/weapon/card/id/housekeys/camilecrafter
	name = "Camile Crafter's house keys"
	registered_name = "Camile Crafter"
	access = list(1)

/obj/item/weapon/card/id/housekeys/donnydavidson
	name = "Donny Davidson's house keys"
	registered_name = "Donny Davidson"
	access = list(2)

/obj/item/weapon/card/id/housekeys/edmundflashman
	name = "Edmund Flashman-Adler's house keys"
	registered_name = "Edmund Flashman-Adler"
	access = list(3)

/obj/item/weapon/card/id/housekeys/talnejem
	name = "Tal Nejem's house keys"
	registered_name = "Tal Nejem"
	access = list(4)

/obj/item/weapon/card/id/housekeys/anatuparish
	name = "Anatu Parish's house keys"
	registered_name = "Anatu Parish"
	access = list(5)

/obj/item/weapon/card/id/housekeys/lisbeth
	name = "Lis'beth B'kai's house keys"
	registered_name = "Lis'beth B'kai"
	access = list(5)

/obj/item/weapon/card/id/housekeys/jenniferclewett
	name = "Jennifer Clewett's house keys"
	registered_name = "Jennifer Clewett"
	access = list(6)

/obj/item/weapon/card/id/housekeys/amytilley
	name = "Amy Tilley's house keys"
	registered_name = "Amy Tilley"
	access = list(6)

/obj/item/weapon/card/id/housekeys/berislavtarik
	name = "Berislav Tarik's house keys"
	registered_name = "Berislav Tarik"
	access = list(7)

/obj/item/weapon/card/id/housekeys/roywyatt
	name = "Roy Wyatt's house keys"
	registered_name = "Berislav Tarik"
	access = list(8)

/obj/item/weapon/card/id/housekeys/lunafountain
	name = "Luna Fountain's house keys"
	registered_name = "Luna Fountain"
	access = list(8)

/obj/item/weapon/card/id/housekeys/syruseto
	name = "Syrus Seto's house keys"
	registered_name = "Syrus Seto"
	access = list(9)

/obj/item/weapon/card/id/housekeys/elenaseto
	name = "Elena Seto's house keys"
	registered_name = "Elena Seto"
	access = list(9)

/obj/item/weapon/card/id/housekeys/igamyute
	name = "Igam Yute's house keys"
	registered_name = "Igam Yute"
	access = list(10)

/obj/item/weapon/card/id/housekeys/amiracook
	name = "Amira Cook's house keys"
	registered_name = "Amira Cook"
	access = list(11)

/obj/item/weapon/card/id/housekeys/beatrixsaylor
	name = "Beatrix Saylor's house keys"
	registered_name = "Beatrix Saylor"
	access = list(12)

/obj/item/weapon/card/id/housekeys/morganastatic
	name = "Morgana Static's house keys"
	registered_name = "Morgana Static"
	access = list(13)

/obj/item/weapon/card/id/housekeys/jamisonstamos
	name = "Jamison Stamos's house keys"
	registered_name = "Jamison Stamos"
	access = list(13)

/obj/item/weapon/card/id/housekeys/serenityneferet
	name = "Serenity Neferet's house keys"
	registered_name = "Serenity Neferet"
	access = list(14)

/obj/item/weapon/card/id/housekeys/leonardomull
	name = "Leonardo Mull's house keys"
	registered_name = "Leonardo Mull"
	access = list(14)

/obj/item/weapon/card/id/housekeys/pennyislington
	name = "Penny Islington's house keys"
	registered_name = "Penny Islington"
	access = list(15)

/obj/item/weapon/card/id/housekeys/viradesantos
	name = "Vira De Santos's office home keys"
	registered_name = "Vira De Santos"
	access = list(16)

/obj/item/weapon/card/id/housekeys/syrusseto2
	name = "Syrus Seto's office home keys"
	registered_name = "Syrus Seto"
	access = list(16)

/obj/item/weapon/card/id/housekeys/arabellamcclymonds
	name = "Arabella McClymonds's home keys"
	registered_name = "Arabella McClymonds"
	access = list(17)

/obj/item/weapon/card/id/housekeys/ryudaken
	name = "Ryud'aken Mo'Taki's home keys"
	registered_name = "Ryud'aken Mo'Taki"
	access = list(18)

/obj/item/weapon/card/id/housekeys/hasnarishat
	name = "Hasna Rishat's home keys"
	registered_name = "Hasna Rishat"
	access = list(19)

/obj/item/weapon/card/id/housekeys/harlowebennit
	name = "Harlowe Bennit's home keys"
	registered_name = "Harlowe Bennit"
	access = list(20)

/obj/item/weapon/card/id/housekeys/revvyblack
	name = "Revvy Black's home keys"
	registered_name = "Revvy Black"
	access = list(21)

/obj/item/weapon/card/id/housekeys/marvinhall
	name = "Marvin Hall's home keys"
	registered_name = "Marvin Hall"
	access = list(22)

/obj/item/weapon/card/id/housekeys/samanthamason
	name = "Samantha Mason's home keys"
	registered_name = "Samantha Mason"
	access = list(23)

/obj/item/weapon/card/id/housekeys/Praetorian
	name = "Praetorian's home keys"
	registered_name = "Praetorian"
	access = list(24)

/obj/item/weapon/card/id/housekeys/Haruspex
	name = "Haruspex's home keys"
	registered_name = "Haruspex"
	access = list(25)

/obj/item/weapon/card/id/housekeys/Dendritic
	name = "Dendritic's home keys"
	registered_name = "Dendritic"
	access = list(26)



/obj/item/weapon/card/id/gold
	name = "identification card"
	desc = "A golden card which shows power and might."
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/syndicate
	name = "agent card"
	access = list(access_maint_tunnels, access_syndicate, access_external_airlocks)
	origin_tech = "syndicate=3"
	var/registered_user=null

/obj/item/weapon/card/id/syndicate/New(mob/user as mob)
	..()
	if(!isnull(user)) // Runtime prevention on laggy starts or where users log out because of lag at round start.
		registered_name = ishuman(user) ? user.real_name : user.name
	else
		registered_name = "Agent Card"
	assignment = "Agent"
	name = "[registered_name]'s ID Card ([assignment])"

/obj/item/weapon/card/id/syndicate/afterattack(var/obj/item/weapon/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if(istype(O, /obj/item/weapon/card/id))
		var/obj/item/weapon/card/id/I = O
		src.access |= I.access
		if(istype(user, /mob/living) && user.mind)
			if(user.mind.special_role)
				usr << "\blue The card's microscanners activate as you pass it over the ID, copying its access."

/obj/item/weapon/card/id/syndicate/attack_self(mob/user as mob)
	if(!src.registered_name)
		//Stop giving the players unsanitized unputs! You are giving ways for players to intentionally crash clients! -Nodrak
		var t = reject_bad_name(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name))
		if(!t) //Same as mob/new_player/prefrences.dm
			alert("Invalid name.")
			return
		src.registered_name = t

		var u = sanitize(copytext(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Agent"),1,MAX_MESSAGE_LEN))
		if(!u)
			alert("Invalid assignment.")
			src.registered_name = ""
			return
		src.assignment = u
		src.name = "[src.registered_name]'s ID Card ([src.assignment])"
		user << "\blue You successfully forge the ID card."
		registered_user = user
	else if(!registered_user || registered_user == user)

		if(!registered_user) registered_user = user  //

		switch(alert("Would you like to display the ID, or retitle it?","Choose.","Rename","Show"))
			if("Rename")
				var t = sanitize(copytext(input(user, "What name would you like to put on this card?", "Agent card name", ishuman(user) ? user.real_name : user.name),1,26))
				if(!t || t == "Unknown" || t == "floor" || t == "wall" || t == "r-wall") //Same as mob/new_player/prefrences.dm
					alert("Invalid name.")
					return
				src.registered_name = t

				var u = sanitize(copytext(input(user, "What occupation would you like to put on this card?\nNote: This will not grant any access levels other than Maintenance.", "Agent card job assignment", "Civilian"),1,MAX_MESSAGE_LEN))
				if(!u)
					alert("Invalid assignment.")
					return
				src.assignment = u
				src.name = "[src.registered_name]'s ID Card ([src.assignment])"
				user << "\blue You successfully forge the ID card."
				return
			if("Show")
				..()
	else
		..()



/obj/item/weapon/card/id/syndicate_command
	name = "syndicate ID card"
	desc = "An ID straight from the Syndicate."
	registered_name = "Syndicate"
	assignment = "Syndicate Overlord"
	access = list(access_syndicate, access_external_airlocks)

/obj/item/weapon/card/id/captains_spare
	name = "captain's spare ID"
	desc = "The spare ID of the High Lord himself."
	icon_state = "gold"
	item_state = "gold_id"
	registered_name = "Captain"
	assignment = "Captain"
	New()
		var/datum/job/captain/J = new/datum/job/captain
		access = J.get_access()
		..()

/obj/item/weapon/card/id/centcom
	name = "\improper CentCom. ID"
	desc = "An ID straight from Cent. Com."
	icon_state = "centcom"
	registered_name = "Central Command"
	assignment = "General"
	New()
		access = get_all_centcom_access()
		..()
