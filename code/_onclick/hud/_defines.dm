/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/
/*
//Upper left action buttons, displayed when you pick up an item that has this enabled.
#define ui_action_slot1 "1:6,14:26"
#define ui_action_slot2 "2:8,14:26"
#define ui_action_slot3 "3:10,14:26"
#define ui_action_slot4 "4:12,14:26"
#define ui_action_slot5 "5:14,14:26"
*/
//Upper left vehicle buttons, displayed when you pick up an item that has this enabled.
#define ui_vehicle_slot1 "1:6,14:26"
#define ui_vehicle_slot2 "2:8,14:26"
#define ui_vehicle_slot3 "3:10,14:26"
#define ui_vehicle_slot4 "4:12,14:26"
#define ui_vehicle_slot5 "5:14,14:26"

//Entire Screen
#define ui_entire_screen "WEST,SOUTH to EAST,NORTH"

//Lower left, persistant menu
#define ui_inventory "WEST:6,SOUTH:5"

//Lower center, persistant menu
#define ui_sstore1 "CENTER-5:10,SOUTH:5"
#define ui_id "CENTER-4:12,SOUTH:5"
#define ui_belt "CENTER-3:14,SOUTH:5"
#define ui_back "CENTER-2:14,SOUTH:5"
#define ui_rhand "CENTER:-16,SOUTH:5"
#define ui_lhand "CENTER: 16,SOUTH:5"
#define ui_equip "CENTER:-16,SOUTH+1:5"
#define ui_swaphand1 "CENTER:-16,SOUTH+1:5"
#define ui_swaphand2 "CENTER: 16,SOUTH+1:5"
#define ui_storage1 "CENTER+1:18,SOUTH:5"
#define ui_storage2 "CENTER+2:20,SOUTH:5"

#define ui_alien_head "4:12,1:5"	//aliens
#define ui_alien_oclothing "5:14,1:5"	//aliens

#define ui_inv1 "7,1:5"			//borgs
#define ui_inv2 "8,1:5"			//borgs
#define ui_inv3 "9,1:5"			//borgs
#define ui_borg_store "10,1:5"	//borgs
#define ui_borg_inventory "6,1:5"//borgs

#define ui_monkey_mask "5:14,1:5"	//monkey
#define ui_monkey_back "6:14,1:5"	//monkey

//Lower right, persistant menu
#define ui_dropbutton "11:22,1:5"
#define ui_drop_throw "14:28,2:7"
#define ui_pull_resist "13:26,2:7"
#define ui_acti "13:26,1:5"
#define ui_movi "12:24,1:5"
#define ui_zonesel "14:28,1:5"
#define ui_acti_alt "14:28,1:5" //alternative intent switcher for when the interface is hidden (F12)

#define ui_borg_pull "12:24,2:7"
#define ui_borg_module "13:26,2:7"
#define ui_borg_panel "14:28,2:7"

//Gun buttons
#define ui_gun1 "EAST-2:26,SOUTH+2:7"
#define ui_gun2 "EAST-1:28,SOUTH+3:7"
#define ui_gun3 "EAST-2:26,SOUTH+3:7"
#define ui_gun_select "EAST-1:28,SOUTH+2:7"

//Upper-middle right (damage indicators)
#define ui_toxin "EAST-1:28,CENTER+5:27"
#define ui_fire "EAST-1:28,CENTER+4:25"
#define ui_oxygen "EAST-1:28,CENTER+3:23"
#define ui_pressure "EAST-1:28,CENTER+2:21"

#define ui_alien_toxin "EAST-1:28,CENTER+5:25"
#define ui_alien_fire "EAST-1:28,CENTER+4:25"
#define ui_alien_oxygen "EAST-1:28,CENTER+3:25"

//Middle right (status indicators)
#define ui_nutrition "EAST-1:28,CENTER-3:11"
#define ui_temp "EAST-1:28,CENTER-2:13"
#define ui_healthdoll "EAST-1:28,CENTER-1:15"
#define ui_health "EAST-1:28,CENTER:17"
#define ui_internal "EAST-1:28,CENTER+1:19"
									//borgs
#define ui_borg_health "EAST-1:28,CENTER-1:15" //borgs have the health display where humans have the pressure damage indicator.
#define ui_alien_health "EAST-1:28,CENTER-1:15" //aliens have the health display where humans have the pressure damage indicator.

#define ui_construct_pull "EAST-1:28,SOUTH+1:10" //above the zone_sel icon

//Pop-up inventory
#define ui_shoes "WEST+1:8,SOUTH:5"

#define ui_iclothing "WEST:6,SOUTH+1:7"
#define ui_oclothing "WEST+1:8,SOUTH+1:7"
#define ui_gloves "WEST+2:10,SOUTH+1:7"


#define ui_glasses "WEST:6,SOUTH+2:9"
#define ui_mask "WEST+1:8,SOUTH+2:9"
#define ui_l_ear "WEST+2:10,SOUTH+2:9"
#define ui_r_ear "WEST+2:10,SOUTH+3:11"

#define ui_head "WEST+1:8,SOUTH+3:11"

//Intent small buttons
#define ui_help_small "12:8,1:1"
#define ui_disarm_small "12:15,1:18"
#define ui_grab_small "12:32,1:18"
#define ui_harm_small "12:39,1:1"

//#define ui_swapbutton "6:-16,1:5" //Unused

//#define ui_headset "SOUTH,8"
#define ui_hand "6:14,1:5"
#define ui_hstore1 "5,5"
//#define ui_resist "EAST+1,SOUTH-1"
#define ui_sleep "EAST+1, NORTH-13"
#define ui_rest "EAST+1, NORTH-14"


#define ui_iarrowleft "SOUTH-1,11"
#define ui_iarrowright "SOUTH-1,13"
