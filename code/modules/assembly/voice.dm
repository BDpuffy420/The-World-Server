/obj/item/device/assembly/voice
	name = "voice analyzer"
	desc = "A small electronic device able to record a voice sample, and send a signal when that sample is repeated."
	icon_state = "voice"
	materials = list(MAT_METAL=500, MAT_GLASS=50)
	origin_tech = "magnets=1"
	flags = HEAR
	attachable = 1
	var/listening = 0
	var/recorded = "" //the activation message

/obj/item/device/assembly/voice/hear_talk(mob/living/M as mob, msg)
	if(listening)
		recorded = msg
		listening = 0
		var/turf/T = get_turf(src)	//otherwise it won't work in hand
		T.visible_message("\icon[src] beeps, \"Activation message is '[recorded]'.\"")
	else
		var/turf/T = get_turf(src)
		T.visible_message("i made it")
		if(findtext(msg, recorded))
			T.visible_message("all the way")
			pulse(0)

/obj/item/device/assembly/voice/activate()
	if(secured)
		if(!holder)
			listening = !listening
			var/turf/T = get_turf(src)
			T.visible_message("[listening ? "Now" : "No longer"] recording input.")

/obj/item/device/assembly/voice/attack_self(mob/user)
	if(!user)
		return 0
	activate()
	return 1

/obj/item/device/assembly/voice/toggle_secure()
	. = ..()
	listening = 0