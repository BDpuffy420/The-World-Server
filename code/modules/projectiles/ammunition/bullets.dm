/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet"

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = "/obj/item/projectile/bullet"

/obj/item/ammo_casing/a418
	desc = "A .418 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet/suffocationbullet"


/obj/item/ammo_casing/a75
	desc = "A .75 bullet casing."
	caliber = "75"
	projectile_type = "/obj/item/projectile/bullet/gyro"


/obj/item/ammo_casing/a666
	desc = "A .666 bullet casing."
	caliber = "357"
	projectile_type = "/obj/item/projectile/bullet/cyanideround"


/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = "38"
	projectile_type = "/obj/item/projectile/bullet/weakbullet"


/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = "/obj/item/projectile/bullet/midbullet2"


/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = "/obj/item/projectile/bullet/midbullet"

/obj/item/ammo_casing/c45r
	desc = "A .45 rubber bullet casing."
	caliber = ".45"
	projectile_type = "/obj/item/projectile/bullet/weakbullet/rubber"

/obj/item/ammo_casing/a12mm
	desc = "A 12mm bullet casing."
	caliber = "12mm"
	projectile_type = "/obj/item/projectile/bullet/midbullet2"


/obj/item/ammo_casing/shotgun
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	caliber = "shotgun"
	projectile_type = "/obj/item/projectile/bullet"
	materials = list(MAT_METAL=12500)


/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = "/obj/item/projectile/bullet/chameleon"
	materials = list(MAT_METAL=250)


/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A weak beanbag shell."
	icon_state = "bshell"
	projectile_type = "/obj/item/projectile/bullet/weakbullet/beanbag"
	materials = list(MAT_METAL=500)

/obj/item/ammo_casing/shotgun/improvised
	name = "improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards."
	icon_state = "improvshell"
//	projectile_type = /obj/item/projectile/bullet/pellet/weak
	materials = list(MAT_METAL=250)
	//pellets = 5
	//variance = 0.8 #TOREMOVE


/obj/item/ammo_casing/shotgun/improvised/overload
	name = "overloaded improvised shell"
	desc = "An extremely weak shotgun shell with multiple small pellets made out of metal shards. This one has been packed with even more \
	propellant. It's like playing russian roulette, with a shotgun."
	icon_state = "improvshell"
//	projectile_type = /obj/item/projectile/bullet/pellet/random
	materials = list(MAT_METAL=250)
	//pellets = 5
	//variance = 1

/obj/item/ammo_casing/shotgun/meteorshot
	name = "meteorshot shell"
	desc = "A shotgun shell rigged with CMC technology, which launches a massive slug when fired."
	icon_state = "mshell"
//	projectile_type = /obj/item/projectile/bullet/meteorshot

/obj/item/ammo_casing/shotgun/pulseslug
	name = "pulse slug"
	desc = "A delicate device which can be loaded into a shotgun. The primer acts as a button which triggers the gain medium and fires a powerful \
	energy blast. While the heat and power drain limit it to one use, it can still allow an operator to engage targets that ballistic ammunition \
	would have difficulty with."
	icon_state = "pshell"
//	projectile_type = /obj/item/projectile/beam/pulse/shot

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary slug"
	desc = "An incendiary-coated shotgun slug."
	icon_state = "ishell"
//	projectile_type = /obj/item/projectile/bullet/incendiary/shell

/obj/item/ammo_casing/shotgun/frag12
	name = "FRAG-12 slug"
	desc = "A high explosive breaching round for a 12 gauge shotgun."
	icon_state = "heshell"
//	projectile_type = /obj/item/projectile/bullet/frag12

/obj/item/ammo_casing/shotgun/incendiary/dragonsbreath
	name = "dragonsbreath shell"
	desc = "A shotgun shell which fires a spread of incendiary pellets."
	icon_state = "ishell2"
//	projectile_type = /obj/item/projectile/bullet/incendiary/shell/dragonsbreath
//	pellets = 4
//	variance = 0.9

/obj/item/ammo_casing/shotgun/ion
	name = "ion shell"
	desc = "An advanced shotgun shell which uses a subspace ansible crystal to produce an effect similar to a standard ion rifle. \
	The unique properties of the crystal splot the pulse into a spread of individually weaker bolts."
	icon_state = "ionshell"
//	projectile_type = /obj/item/projectile/ion/weak
//	pellets = 4
//	variance = 0.9

/obj/item/ammo_casing/shotgun/laserslug
	name = "laser slug"
	desc = "An advanced shotgun shell that uses a micro laser to replicate the effects of a laser weapon in a ballistic package."
	icon_state = "lshell"
//	projectile_type = /obj/item/projectile/beam

/obj/item/ammo_casing/shotgun/techshell
	name = "unloaded technological shell"
	desc = "A high-tech shotgun shell which can be loaded with materials to produce unique effects."
	icon_state = "cshell"
	projectile_type = null

/obj/item/ammo_casing/shotgun/stunshell
	name = "stun shell"
	desc = "A stunning shell."
	icon_state = "stunshell"
	projectile_type = "/obj/item/projectile/bullet/stunshot"
	materials = list(MAT_METAL=2500)

/obj/item/ammo_casing/shotgun/dart
	name = "shotgun darts"
	desc = "A dart for use in shotguns."
	icon_state = "dart"
	projectile_type = "/obj/item/projectile/energy/dart"
	materials = list(MAT_METAL=12500)

/obj/item/ammo_casing/a762
	desc = "A 7.62 bullet casing."
	caliber = "a762"
	projectile_type = "/obj/item/projectile/bullet/a762"

/obj/item/ammo_casing/rocket
	name = "rocket shell"
	desc = "A high explosive designed to be fired from a launcher."
	icon_state = "rocketshell"
	projectile_type = "/obj/item/missile"
	caliber = "rocket"

/obj/item/ammo_casing/chameleon
	name = "chameleon bullets"
	desc = "A set of bullets for the Chameleon Gun."
	projectile_type = "/obj/item/projectile/bullet/chameleon"
	caliber = ".45"
