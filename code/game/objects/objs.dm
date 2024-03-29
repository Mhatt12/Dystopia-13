/obj
	layer = OBJ_LAYER
	plane = OBJ_PLANE
	//Used to store information about the contents of the object.
	var/list/matter
	var/w_class // Size of the object.
	var/unacidable = 0 //universal "unacidabliness" var, here so you can use it in any obj.
	animate_movement = 2
	var/throwforce = 1
	var/sharp = 0		// whether this object cuts
	var/edge = 0		// whether this object is more likely to dismember
	var/pry = 0			//Used in attackby() to open doors
	var/in_use = 0 // If we have a user using us, this will be set on. We will check if the user has stopped using us, and thus stop updating and LAGGING EVERYTHING!
	var/damtype = "brute"
	var/armor_penetration = 0
	var/show_messages
	var/burn_state = -1 // -1=fireproof | 0=will burn in fires | 1=currently on fire
	var/burntime = 10 //How long it takes to burn to ashes, in seconds
	var/burn_world_time //What world time the object will burn up completely
	var/preserve_item = 0 //whether this object is preserved when its owner goes into cryo-storage, gateway, etc
	var/can_speak = 0 //For MMIs and admin trickery. If an object has a brainmob in its contents, set this to 1 to allow it to speak.
	var/show_examine = TRUE	// Does this pop up on a mob when the mob is examined?

	var/table_drag = FALSE // Can this be click dragged onto a table?
	var/table_shift = 14	// If dragged onto a table, what's the pixel y of this?

	var/wall_drag = FALSE
	var/wall_shift = 0	// If dragged onto a wall, what's the pixel y of this?

/obj/Destroy()
	processing_objects -= src
	return ..()

/obj/examine(mob/user)
	. = ..()
	if(tagged_price)
		to_chat(user, "There is a price tag marking [src] to be <b>[cash2text( tagged_price, FALSE, TRUE, TRUE )]</b>.")
	if(dont_save)
		to_chat(user, "<b>You have a feeling this item is important or belongs to someone...</b>")

/obj/Topic(href, href_list, var/datum/topic_state/state = default_state)
	if(usr && ..())
		return 1

	// In the far future no checks are made in an overriding Topic() beyond if(..()) return
	// Instead any such checks are made in CanUseTopic()
	if(CanUseTopic(usr, state, href_list) == STATUS_INTERACTIVE)
		CouldUseTopic(usr)
		return 0

	CouldNotUseTopic(usr)
	return 1

/obj/CanUseTopic(var/mob/user, var/datum/topic_state/state)
	if(user.CanUseObjTopic(src))
		return ..()
	user << "<span class='danger'>\icon[src]Access Denied!</span>"
	return STATUS_CLOSE

/mob/living/silicon/CanUseObjTopic(var/obj/O)
	var/id = src.GetIdCard()
	return O.check_access(id)


/obj/CouldUseTopic(var/mob/user)
	var/atom/host = nano_host()
	host.add_hiddenprint(user)

/obj/item/proc/is_used_on(obj/O, mob/user)

/obj/process()
	processing_objects.Remove(src)
	return 0

/obj/assume_air(datum/gas_mixture/giver)
	if(loc)
		return loc.assume_air(giver)
	else
		return null

/obj/remove_air(amount)
	if(loc)
		return loc.remove_air(amount)
	else
		return null

/obj/return_air()
	if(loc)
		return loc.return_air()
	else
		return null

/obj/proc/updateUsrDialog()
	if(in_use)
		var/is_in_use = 0
		var/list/nearby = viewers(1, src)
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.attack_hand(M)
		if (istype(usr, /mob/living/silicon/ai) || istype(usr, /mob/living/silicon/robot))
			if (!(usr in nearby))
				if (usr.client && usr.machine==src) // && M.machine == src is omitted because if we triggered this by using the dialog, it doesn't matter if our machine changed in between triggering it and this - the dialog is probably still supposed to refresh.
					is_in_use = 1
					src.attack_ai(usr)

		// check for TK users

		if (istype(usr, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(H.get_type_in_hands(/obj/item/tk_grab))
				if(!(H in nearby))
					if(H.client && H.machine==src)
						is_in_use = 1
						src.attack_hand(H)
		in_use = is_in_use

/obj/proc/updateDialog()
	// Check that people are actually using the machine. If not, don't update anymore.
	if(in_use)
		var/list/nearby = viewers(1, src)
		var/is_in_use = 0
		for(var/mob/M in nearby)
			if ((M.client && M.machine == src))
				is_in_use = 1
				src.interact(M)
		var/ai_in_use = AutoUpdateAI(src)

		if(!ai_in_use && !is_in_use)
			in_use = 0

/obj/attack_ghost(mob/user)
	ui_interact(user)
	..()

/obj/proc/interact(mob/user)
	return

/mob/proc/unset_machine()
	src.machine = null

/mob/proc/set_machine(var/obj/O)
	if(src.machine)
		unset_machine()
	src.machine = O
	if(istype(O))
		O.in_use = 1

/obj/item/proc/updateSelfDialog()
	var/mob/M = src.loc
	if(istype(M) && M.client && M.machine == src)
		src.attack_self(M)

/obj/proc/hide(h)
	return

/obj/proc/hides_under_flooring()
	return 0

/obj/proc/hear_talk(mob/M as mob, text, verb, datum/language/speaking)
	if(talking_atom)
		talking_atom.catchMessage(text, M)
/*
	var/mob/mo = locate(/mob) in src
	if(mo)
		var/rendered = "<span class='game say'><span class='name'>[M.name]: </span> <span class='message'>[text]</span></span>"
		mo.show_message(rendered, 2)
		*/
	return


/obj/proc/container_resist()
	return

/obj/proc/see_emote(mob/M as mob, text, var/emote_type)
	return

/obj/proc/show_message(msg, type, alt, alt_type)//Message, type of message (1 or 2), alternative message, alt message type (1 or 2)
	return

/obj/water_act()
	if(!burn_state)
		return
	else
		extinguish()
	return ..()

/obj/proc/get_cell()
	return

/obj/fire_act(global_overlay=1)
	if(!burn_state)
		burn_state = 1
		burning_objects += src
		burn_world_time = world.time + burntime*rand(10,20)
		var/obj/effect/effect/smoke/bad/short/B = new(src.loc)
		B.time_to_live = 5
		if(global_overlay)
			overlays += fire_overlay
		set_light(2, 1, "#ED9200")
		return 1

/obj/proc/burn()
	for(var/obj/item/Item in contents) //Empty out the contents
		Item.loc = src.loc
		Item.fire_act() //Set them on fire, too
	var/obj/effect/decal/cleanable/ash/A = new(src.loc)
	A.desc = "Looks like this used to be a [name] some time ago."
	burning_objects -= src
	qdel(src)

/obj/proc/extinguish()
	if(burn_state == 1)
		burn_state = 0
		set_light(0)
		overlays -= fire_overlay
		var/obj/effect/effect/smoke/bad/B = new(src.loc)
		B.time_to_live = 1
		burning_objects -= src
		visible_message("<span class='notice'>The [src]'s flames dissipate.</span>")

/obj/attack_hand(var/mob/user)
	if(isundead(user))
		user << "<span class='notice'>This looks incredibly alien to you, and doesn't have brains.</span>"
		return
	..()
