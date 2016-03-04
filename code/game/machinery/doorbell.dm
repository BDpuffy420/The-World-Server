// It is a gizmo that alerts people when you've rang the door.
/obj/machinery/doorbell
	name = "Doorbell"
	desc = "A wall-mounted doorbell."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "doorbell"

	anchored = 1

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		return attack_hand(user)

	attack_hand(mob/user)
		switch(alert("Ring the doorbell?",,"Ring","Ring Passionately","Don't Ring"))
			if("Ring")
				playsound(src.loc, 'sound/effects/doorbell.ogg', 40, 1)
				user.visible_message(text("\red [] rings the doorbell.",user))
				return

			if("Ring Passionately")
				playsound(src.loc, 'sound/effects/Doorbell Fast Repeating.ogg', 40, 1)
				user.visible_message(text("\red [] rings the doorbell very enthusiastically!",user))
				return

			if("Don't Ring")
				return
