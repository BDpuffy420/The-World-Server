/client/proc/griefpanel()
	set name = "Grief Panel"
	set desc = "Try this before going insane."
	set category = "Admin"
	if (holder)
		holder.griefpanel()
	feedback_add_details("admin_verb","GRFF") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return


/datum/admins/proc/griefpanel()
	if(!check_rights(0))	return

	var/dat = "<B>Learn how to cope, sweet friend. There will always be dark days.</B> - Kris Carr<HR>"

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Grief Panel</B><BR>
			<BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Delete all bombs</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Globally Disable Explosions</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>OOC Shadowmute</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>IC Shadowmute</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Cure all diseases</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Rejuv All</A><BR>

			"}


	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Panic Mode</B><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Disable everyone (Use sparingly)</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Stop fighting, kids (People can't fight)</A><BR>


			"}

	if(check_rights(R_ADMIN,0))
		dat += {"
			<B>Cleanup Mode</B><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Delete all blood spills</A><BR>
			<A href='?src=\ref[src];griefpanel=disablebomb'>Disable everyone (Use sparingly)</A><BR>


			"}