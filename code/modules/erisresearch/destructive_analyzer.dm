/*
Destructive Analyzer

It is used to destroy hand-held objects and advance technological research. Controls are in the linked R&D console.

Note: Must be placed within 3 tiles of the R&D Console
*/

/obj/machinery/r_n_d/destructive_analyzer
	name = "destructive analyzer"
	icon_state = "d_analyzer"
	var/obj/item/loaded_item = null
	var/decon_mod = 0
	var/busy = FALSE
	circuit = /obj/item/weapon/circuitboard/destructive_analyzer

	idle_power_usage = 30
	active_power_usage = 2500

/obj/machinery/r_n_d/destructive_analyzer/Destroy()
	if(linked_console)
		if(linked_console.linked_destroy == src)
			linked_console.linked_destroy = null
		linked_console = null
	return ..()

/obj/machinery/r_n_d/destructive_analyzer/RefreshParts()
	var/T = 0
	for(var/obj/item/weapon/stock_parts/S in src)
		T += S.rating
	decon_mod = T * 0.1

/obj/machinery/r_n_d/destructive_analyzer/update_icon()
	if(panel_open)
		icon_state = "d_analyzer_t"
	else if(loaded_item)
		icon_state = "d_analyzer_l"
	else
		icon_state = "d_analyzer"

/obj/machinery/r_n_d/destructive_analyzer/attackby(obj/item/O, mob/user)
	if(busy)
		to_chat(user, "<span class='notice'>\The [src] is busy right now.</span>")
		return
	if(loaded_item)
		to_chat(user, "<span class='notice'>There is something already loaded into \the [src].</span>")
		return 1
	if(default_deconstruction_screwdriver(user, O))
		if(linked_console)
			linked_console.linked_destroy = null
			linked_console = null
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(default_part_replacement(user, O))
		return
	if(panel_open)
		to_chat(user, "<span class='notice'>You can't load \the [src] while it's opened.</span>")
		return 1
	if(!linked_console)
		to_chat(user, "<span class='notice'>\The [src] must be linked to an R&D console first.</span>")
		return
	if(!loaded_item)
		if(isrobot(user)) //Don't put your module items in there!
			return
		if(!O.origin_tech)
			to_chat(user, "<span class='notice'>This doesn't seem to have a tech origin.</span>")
			return
		if(O.origin_tech.len == 0)
			to_chat(user, "<span class='notice'>You cannot deconstruct this item.</span>")
			return
		busy = 1
		loaded_item = O
		user.drop_item()
		O.loc = src
		to_chat(user, "<span class='notice'>You add \the [O] to \the [src].</span>")
		flick("d_analyzer_la", src)
		spawn(10)
			update_icon()
			busy = 0
		return 1
	return

/obj/machinery/r_n_d/destructive_analyzer/proc/reset_busy()
	busy = FALSE
	update_icon()
	if(linked_console)
		SSnano.update_uis(linked_console)

// If this returns true, the rdconsole caller will set its screen to SCREEN_WORKING
/obj/machinery/r_n_d/destructive_analyzer/proc/deconstruct_item()
	if(busy)
		to_chat(usr, SPAN_WARNING("The destructive analyzer is busy at the moment."))
		return
	if(!loaded_item)
		return

	busy = TRUE
	flick("d_analyzer_process", src)
	addtimer(CALLBACK(src, .proc/finish_deconstructing), 2.4 SECONDS)
	return TRUE

/obj/machinery/r_n_d/destructive_analyzer/proc/finish_deconstructing()
	busy = FALSE
	if(!loaded_item)
		return
	if(linked_console)
		linked_console.handle_item_analysis(loaded_item)
	//for(var/mob/living/carbon/human/H in viewers(src))
	//	SEND_SIGNAL(H, COMSING_DESTRUCTIVE_ANALIZER, loaded_item)
	if(istype(loaded_item,/obj/item/stack))
		var/obj/item/stack/S = loaded_item
		if(S.amount <= 1)
			qdel(S)
			loaded_item = null
		else
			S.use(1)
	else
		qdel(loaded_item)
		loaded_item = null

	use_power(active_power_usage)
	update_icon()
	if(linked_console)
		linked_console.reset_screen()

/obj/machinery/r_n_d/destructive_analyzer/eject_item()
	if(busy)
		to_chat(usr, SPAN_WARNING("The destructive analyzer is busy at the moment."))
		return

	if(loaded_item)
		loaded_item.forceMove(loc)
		loaded_item = null
		update_icon()