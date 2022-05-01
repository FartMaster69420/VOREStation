/datum/ai_holder/simple_mob/bot
	//ranged = FALSE
	wander = TRUE
/*
/datum/ai_holder/simple_mob/bot/post_melee_attack(A)

/datum/ai_holder/simple_mob/bot/post_ranged_attack(A)
*/
/datum/ai_holder/simple_mob/bot/can_act()
	. = ..()
	var/mob/living/simple_mob/bot/botMob = holder

	if(!botMob.on)
		return FALSE

/datum/ai_holder/simple_mob/bot/on_engagement(atom/A)
	var/mob/living/simple_mob/bot/botMob = holder
	if(target)
		botMob.target = target
	else
		botMob.target = null

/datum/ai_holder/simple_mob/bot/secbot
	firing_lanes = TRUE
	wander = FALSE
	conserve_ammo = TRUE

/datum/ai_holder/simple_mob/bot/secbot/can_attack(atom/movable/the_target)
	. = ..()
	var/mob/living/simple_mob/bot/botMob = holder

	if(!the_target || !botMob.confirmTarget(the_target))
		return FALSE
	//if(holder.Adjacent(the_target))
	//	botMob.handleAdjacentTarget(the_target)
	/*
	if(istype(the_target, /mob/living/simple_mob/slime/xenobio))
		var/mob/living/simple_mob/slime/xenobio/target = the_target
		if(!target.is_justified_to_discipline())
			return FALSE
	*/
/datum/ai_holder/simple_mob/bot/secbot/ed209
	//ranged = TRUE