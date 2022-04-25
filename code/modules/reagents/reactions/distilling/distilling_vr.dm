/decl/chemical_reaction/distilling/slimejelly
	name = "Slime Jam"
	id = "m_jam"
	result = "slimejelly"
	required_reagents = list("phoron" = 20, "sugar" = 50, "lithium" = 50) //In case a xenobiologist is impatient and is willing to drain their dispenser resources, along with plasma!
	result_amount = 5

	reaction_rate = HALF_LIFE(5)

	temp_range = list(T0C + 350, T0C + 365)


/decl/chemical_reaction/distilling/slimevore
	name = "Slime Vore" // Hostile vore mobs only
	id = "m_tele"
	result = null
	required_reagents = list("phoron" = 20, "nutriment" = 20, "sugar" = 20, "mutationtoxin" = 20) //Can't do slime jelly as it'll conflict with another, but mutation toxin will do.
	result_amount = 1
	reaction_rate = HALF_LIFE(40)

	temp_range = list(T0C + 250, T0C + 265)

/decl/chemical_reaction/distilling/slimevore/on_reaction(var/datum/reagents/holder)
	var/mob_path = /mob/living/simple_mob
	var/blocked = list(														//List of things we do NOT want to spawn
		/mob/living/simple_mob,												//Technical parent mobs
		/mob/living/simple_mob/animal,
		/mob/living/simple_mob/animal/passive,
		/mob/living/simple_mob/animal/space,
		/mob/living/simple_mob/blob,
		/mob/living/simple_mob/mechanical,
		/mob/living/simple_mob/mechanical/mecha,
		/mob/living/simple_mob/slime,
		/mob/living/simple_mob/vore,
		/mob/living/simple_mob/vore/aggressive,
		/mob/living/simple_mob/illusion,									//Other technical mobs
		/mob/living/simple_mob/animal/passive/crab/Coffee,					//Unique pets/named mobs
		/mob/living/simple_mob/animal/passive/cat/runtime,
		/mob/living/simple_mob/animal/passive/cat/bones,
		/mob/living/simple_mob/animal/passive/cat/tabiranth,
		/mob/living/simple_mob/animal/passive/dog/corgi/puppy/Bockscar,
		/mob/living/simple_mob/animal/passive/dog/corgi/Ian,
		/mob/living/simple_mob/animal/passive/dog/corgi/Lisa,
		/mob/living/simple_mob/animal/passive/dog/tamaskan/Spice,
		/mob/living/simple_mob/animal/passive/fox/renault,
		/mob/living/simple_mob/animal/passive/bird/azure_tit/tweeter,
		/mob/living/simple_mob/animal/passive/bird/parrot/poly,
		/mob/living/simple_mob/animal/sif/fluffy,
		/mob/living/simple_mob/animal/sif/fluffy/silky,
		/mob/living/simple_mob/animal/passive/snake/python/noodle,
		/mob/living/simple_mob/slime/xenobio/rainbow/kendrick,
		/mob/living/simple_mob/animal/space/space_worm,						//Space Worm parts that aren't proper heads
		/mob/living/simple_mob/animal/space/space_worm/head/severed,
		/mob/living/simple_mob/animal/borer,								//Event/player-control-only mobs
		/mob/living/simple_mob/vore/hostile/morph
		)//exclusion list for things you don't want the reaction to create.
	blocked += typesof(/mob/living/simple_mob/mechanical/ward)				//Wards that should be created with ward items, are mobs mostly on technicalities
	blocked += typesof(/mob/living/simple_mob/construct)					//Should only exist
	blocked += typesof(/mob/living/simple_mob/vore/demon)					//as player-controlled
	blocked += typesof(/mob/living/simple_mob/shadekin)						//and/or event things
	var/list/voremobs = typesof(mob_path) - blocked // list of possible hostile mobs

	playsound(holder.my_atom, 'sound/effects/phasein.ogg', 100, 1)
	var/spawn_count = rand(1,3)
	for(var/i = 1, i <= spawn_count, i++)
		var/chosen = pick(voremobs)
		var/mob/living/simple_mob/C = new chosen
		C.faction = "slimesummon"
		C.loc = get_turf(holder.my_atom)
		if(prob(50))
			for(var/j = 1, j <= rand(1, 3), j++)
				step(C, pick(NORTH,SOUTH,EAST,WEST))