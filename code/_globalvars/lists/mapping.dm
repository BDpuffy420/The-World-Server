#define Z_NORTH 1
#define Z_EAST 2
#define Z_SOUTH 3
#define Z_WEST 4

var/list/cardinal = list( NORTH, SOUTH, EAST, WEST )
var/list/alldirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
// reverse_dir[dir] = reverse of dir
var/list/reverse_dir = list(2, 1, 3, 8, 10, 9, 11, 4, 6, 5, 7, 12, 14, 13, 15, 32, 34, 33, 35, 40, 42, 41, 43, 36, 38, 37, 39, 44, 46, 45, 47, 16, 18, 17, 19, 24, 26, 25, 27, 20, 22, 21, 23, 28, 30, 29, 31, 48, 50, 49, 51, 56, 58, 57, 59, 52, 54, 53, 55, 60, 62, 61, 63)


//This list contains the z-level numbers which can be accessed via space travel and the percentile chances to get there.
//(Exceptions: extended, sandbox and nuke) -Errorage
//Was list("3" = 30, "4" = 70).
//Spacing should be a reliable method of getting rid of a body -- Urist.
//Go away Urist, I'm restoring this to the longer list. ~Errorage
var/list/accessable_z_levels = list(1,3,4,5,6,7) //Keep this to six maps, repeating z-levels is ok if needed

var/global/list/global_map = null
	//list/global_map = list(list(1,5),list(4,3))//an array of map Z levels.
	//Resulting sector map looks like
	//|_1_|_4_|
	//|_5_|_3_|
	//
	//1 - SS13
	//4 - Derelict
	//3 - AI satellite
	//5 - empty space

var/list/landmarks_list = list()				//list of all landmarks created
var/list/start_landmarks_list = list()			//list of all spawn points created
var/list/department_security_spawns = list()	//list of all department security spawns

var/list/latejoin = list()
var/list/latejoin_gateway = list()
var/list/latejoin_cryo = list()
var/list/latejoin_cyborg = list()

var/list/monkeystart = list()
var/list/wizardstart = list()
var/list/newplayer_start = list()
var/list/prisonwarp = list()	//prisoners go to these
var/list/holdingfacility = list()	//captured people go here
var/list/xeno_spawn = list()//Aliens spawn at these.
var/list/tdome1 = list()
var/list/tdome2 = list()
var/list/tdomeobserve = list()
var/list/tdomeadmin = list()
var/list/prisonsecuritywarp = list()	//prison security goes to these
var/list/prisonwarped = list()	//list of players already warped
var/list/blobstart = list()
var/list/ninjastart = list()
var/list/secequipment = list()
var/list/deathsquadspawn = list()
var/list/emergencyresponseteamspawn = list()

	//away missions
var/list/awaydestinations = list()	//a list of landmarks that the warpgate can take you to

	//used by jump-to-area etc. Updated by area/updateName()
var/list/sortedAreas = list()