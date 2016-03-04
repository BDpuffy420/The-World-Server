//mob/var/stat things
#define CONSCIOUS	0
#define UNCONSCIOUS	1
#define DEAD		2

//Bitflags defining which status effects could be or are inflicted on a mob
#define CANSTUN				1
#define CANWEAKEN			2
#define CANPARALYSE			4
#define CANPUSH				8
#define LEAPING				16
#define PASSEMOTES			32      //Mob has a cortical borer or holders inside of it that need to see emotes.
#define IGNORESLOWDOWN		64
#define GOTTAGOFAST			128
#define GOTTAGOREALLYFAST	256
#define GODMODE				4096
#define FAKEDEATH			8192	//Replaces stuff like changeling.changeling_fakedeath
#define DISFIGURED			16384	//I'll probably move this elsewhere if I ever get wround to writing a bitflag mob-damage system
#define XENO_HOST			32768	//Tracks whether we're gonna be a baby alien's mummy.

//Grab levels
#define GRAB_PASSIVE	1
#define GRAB_AGGRESSIVE	2
#define GRAB_NECK		3
#define GRAB_UPGRADING	4
#define GRAB_KILL		5

//intent flags, why wasn't this done the first time?
#define I_HELP		"help"
#define I_DISARM	"disarm"
#define I_GRAB		"grab"
#define I_HURT		"hurt"

//Species Diet Flags
#define DIET_CARN		1
#define DIET_OMNI		2
#define DIET_HERB		4

//Nutrition levels for humans.
#define NUTRITION_LEVEL_FAT 600
#define NUTRITION_LEVEL_FULL 550
#define NUTRITION_LEVEL_WELL_FED 450
#define NUTRITION_LEVEL_FED 350
#define NUTRITION_LEVEL_HUNGRY 250
#define NUTRITION_LEVEL_STARVING 150

/*
	These are used Bump() code for living mobs, in the mob_bump_flag, mob_swap_flags, and mob_push_flags vars to determine whom can bump/swap with whom.
*/
#define HUMAN 1
#define MONKEY 2
#define ALIEN 4
#define ROBOT 8
#define SLIME 16
#define SIMPLE_ANIMAL 32
#define HEAVY 64
#define ALLMOBS (HUMAN|MONKEY|ALIEN|ROBOT|SLIME|SIMPLE_ANIMAL|HEAVY)

// Organ defines.
#define ORGAN_CUT_AWAY   1
#define ORGAN_GAUZED     2
#define ORGAN_ATTACHABLE 4
#define ORGAN_BLEEDING   8
#define ORGAN_BROKEN     32
#define ORGAN_DESTROYED  64
#define ORGAN_ROBOT      128
#define ORGAN_SPLINTED   256
#define SALVED           512
#define ORGAN_DEAD       1024
#define ORGAN_MUTATED    2048
#define ORGAN_ASSISTED   4096

#define DROPLIMB_EDGE 0
#define DROPLIMB_BLUNT 1
#define DROPLIMB_BURN 2

//Sizes of mobs, used by mob/living/var/mob_size
#define MOB_SIZE_TINY 0
#define MOB_SIZE_SMALL 1
#define MOB_SIZE_HUMAN 2
#define MOB_SIZE_LARGE 3