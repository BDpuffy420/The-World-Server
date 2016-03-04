/mob/living
	see_invisible = SEE_INVISIBLE_LIVING

	//Health and life related vars
	var/maxHealth = 100 //Maximum health that should be possible.
	var/health = 100 	//A mob's health

	var/hud_updateflag = 0

	//Damage related vars, NOTE: THESE SHOULD ONLY BE MODIFIED BY PROCS
	var/bruteloss = 0.0	//Brutal damage caused by brute force (punching, being clubbed by a toolbox ect... this also accounts for pressure damage)
	var/oxyloss = 0.0	//Oxygen depravation damage (no air in lungs)
	var/toxloss = 0.0	//Toxic damage caused by being poisoned or radiated
	var/fireloss = 0.0	//Burn damage caused by being way too hot, too cold or burnt.
	var/cloneloss = 0	//Damage caused by being cloned or ejected from the cloner early. slimes also deal cloneloss damage to victims
	var/brainloss = 0	//'Retardation' damage caused by someone hitting you in the head with a bible or being infected with brainrot.
	var/halloss = 0		//Hallucination damage. 'Fake' damage obtained through hallucinating or the holodeck. Sleeping should cause it to wear off.
	var/staminaloss = 0		//Stamina damage, or exhaustion. You recover it slowly naturally, and are stunned if it gets too high. Holodeck and hallucinations deal this.


	var/hallucination = 0 //Directly affects how long a mob will hallucinate for
	var/list/atom/hallucinations = list() //A list of hallucinated people that try to attack the mob. See /obj/effect/fake_attacker in hallucinations.dm


	var/last_special = 0 //Used by the resist verb, likely used to prevent players from bypassing next_move by logging in/out.

	var/t_plasma = null
	var/t_oxygen = null
	var/t_sl_gas = null
	var/t_n2 = null

	var/now_pushing = null
	var/mob_bump_flag = 0
	var/mob_swap_flags = 0
	var/mob_push_flags = 0
	var/mob_always_swap = 0

	var/footstep = 0

	var/cameraFollow = null

	var/tod = null // Time of death

	var/step_count = 0 //Paradise footstep code

	var/on_fire = 0 //The "Are we on fire?" var
	var/fire_stacks = 0 //Tracks how many stacks of fire we have on, max is usually 20

	var/update_slimes = 1
	var/silent = null 		// Can't talk. Value goes down every life proc.

	var/ventcrawler = 0 //0 No vent crawling, 1 vent crawling in the nude, 2 vent crawling always
	var/list/pipes_shown = list()  //Used by ventcrawl
	var/last_played_vent

	var/floating = 0
	var/metabolism_efficiency = 1 //more or less efficiency to metabolize helpful/harmful reagents and regulate body temperature..