/obj/structure/window
	name = "window"
	desc = "A window."
	icon = 'icons/obj/window.dmi'
	density = 1
	w_class = ITEMSIZE_NORMAL
	alpha = 122
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER
	var/maxhealth = 14.0
	var/maximal_heat = T0C + 100 		// Maximal heat before this window begins taking damage from fire
	var/damage_per_fire_tick = 2.0 		// Amount of damage per fire tick. Regular windows are not fireproof so they might as well break quickly.
	var/health
	var/force_threshold = 0
	var/ini_dir = null
	var/state = 2
	var/reinf = 0
	var/basestate = "window"
	var/shardtype = /obj/item/weapon/material/shard
	var/glasstype = null // Set this in subtypes. Null is assumed strange or otherwise impossible to dismantle, such as for shuttle glass.
	var/silicate = 0 // number of units of silicate
	var/on_frame = FALSE
	var/material_color
	blend_objects = list(/obj/machinery/door) // Objects which to blend with
	noblend_objects = list(/obj/machinery/door/window)

	unique_save_vars = list("health", "material_color", "on_frame", "silicate")

/obj/structure/window/examine(mob/user)
	. = ..(user)

	if(health == maxhealth)
		user << "<span class='notice'>It looks fully intact.</span>"
	else
		var/perc = health / maxhealth
		if(perc > 0.75)
			user << "<span class='notice'>It has a few cracks.</span>"
		else if(perc > 0.5)
			user << "<span class='warning'>It looks slightly damaged.</span>"
		else if(perc > 0.25)
			user << "<span class='warning'>It looks moderately damaged.</span>"
		else
			user << "<span class='danger'>It looks heavily damaged.</span>"
	if(silicate)
		if (silicate < 30)
			user << "<span class='notice'>It has a thin layer of silicate.</span>"
		else if (silicate < 70)
			user << "<span class='notice'>It is covered in silicate.</span>"
		else
			user << "<span class='notice'>There is a thick layer of silicate covering it.</span>"

/obj/structure/window/proc/take_damage(var/damage = 0,  var/sound_effect = 1)
	if(!damage)
		return 0

	var/initialhealth = health

	if(silicate)
		damage = damage * (1 - silicate / 200)

	health = max(0, health - damage)

	if(health <= 0)
		shatter()
	else
		if(sound_effect)
			playsound(loc, 'sound/effects/Glasshit.ogg', 100, 1)
		if(health < maxhealth / 4 && initialhealth >= maxhealth / 4)
			visible_message("[src] looks like it's about to shatter!" )
			update_icon()
		else if(health < maxhealth / 2 && initialhealth >= maxhealth / 2)
			visible_message("[src] looks seriously damaged!" )
			update_icon()
		else if(health < maxhealth * 3/4 && initialhealth >= maxhealth * 3/4)
			visible_message("Cracks begin to appear in [src]!" )
			update_icon()
	return 1

/obj/structure/window/proc/apply_silicate(var/amount)
	if(health < maxhealth) // Mend the damage
		health = min(health + amount * 3, maxhealth)
		if(health == maxhealth)
			visible_message("[src] looks fully repaired." )
	else // Reinforce
		silicate = min(silicate + amount, 100)
		updateSilicate()

/obj/structure/window/proc/updateSilicate()
	if (overlays)
		overlays.Cut()

	var/image/img = image(src.icon, src.icon_state)
	img.color = "#ffffff"
	img.alpha = silicate * 255 / 100
	overlays += img

/obj/structure/window/proc/shatter(var/display_message = 1)
	playsound(src, "shatter", 70, 1)
	if(display_message)
		visible_message("[src] shatters!")
	new shardtype(loc)
	if(reinf)
		new /obj/item/stack/rods(loc)
	if(is_fulltile())
		new shardtype(loc) //todo pooling?
		if(reinf)
			new /obj/item/stack/rods(loc)
	qdel(src)
	return


/obj/structure/window/bullet_act(var/obj/item/projectile/Proj)

	var/proj_damage = Proj.get_structure_damage()
	if(!proj_damage) return
	if(proj_damage > 0)
		trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "\The [src] was hit by \the [Proj].")

	..()
	take_damage(proj_damage)
	return


/obj/structure/window/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			shatter(0)
			return
		if(3.0)
			if(prob(50))
				shatter(0)
				return

/obj/structure/window/blob_act()
	take_damage(50)

//TODO: Make full windows a separate type of window.
//Once a full window, it will always be a full window, so there's no point
//having the same type for both.
/obj/structure/window/proc/is_full_window()
	return (dir == SOUTHWEST || dir == SOUTHEAST || dir == NORTHWEST || dir == NORTHEAST)

/obj/structure/window/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return 1
	if(is_full_window())
		return 0	//full tile window, you can't move into it!
	if(get_dir(loc, target) & dir)
		return !density
	else
		return 1


/obj/structure/window/CheckExit(atom/movable/O as mob|obj, target as turf)
	if(istype(O) && O.checkpass(PASSGLASS))
		return 1
	if(get_dir(O.loc, target) == dir)
		return 0
	return 1


/obj/structure/window/hitby(var/atom/movable/AM)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else if(isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	if(reinf) tforce *= 0.25
	if(health - tforce <= 7 && !reinf)
		anchored = 0
		update_verbs()
		update_nearby_icons()
		step(src, get_dir(AM, src))
	take_damage(tforce)
	if(tforce > 0)
		trigger_lot_security_system(AM.thrower, /datum/lot_security_option/vandalism, "Threw \the [AM] at \the [src].")

/obj/structure/window/attack_tk(mob/user as mob)
	user.visible_message("<span class='notice'>Something knocks on [src].</span>")
	playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)

/obj/structure/window/attack_hand(mob/user as mob)
	user.setClickCooldown(user.get_attack_speed())
	if(HULK in user.mutations)
		if(trigger_lot_security_system(user, /datum/lot_security_option/vandalism, "Smashed \the [src]."))
			return
		user.say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!"))
		user.visible_message("<span class='danger'>[user] smashes through [src]!</span>")
		user.do_attack_animation(src)
		shatter()


	else if (usr.a_intent == I_HURT)

		if (istype(usr,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = usr
			if(H.species.can_shred(H))
				attack_generic(H,25)
				return

		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		user.do_attack_animation(src)
		usr.visible_message("<span class='danger'>\The [usr] bangs against \the [src]!</span>",
							"<span class='danger'>You bang against \the [src]!</span>",
							"You hear a banging sound.")
	else
		playsound(src.loc, 'sound/effects/glassknock.ogg', 80, 1)
		usr.visible_message("[usr.name] knocks on the [src.name].",
							"You knock on the [src.name].",
							"You hear a knocking sound.")
	return

/obj/structure/window/attack_generic(var/mob/user, var/damage)
	user.setClickCooldown(user.get_attack_speed())
	if(!damage)
		return

	var/harmless = 0

	if(isanimal(user))
		var/mob/living/simple_animal/A = user
		playsound(src, A.attack_sound, 75, 1)
		if(!A.can_destroy_structures())
			damage = 0
			harmless = TRUE

	if(damage && trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to break \the [src]."))
		return

	if(damage >= 10)
		visible_message("<span class='danger'>[user] smashes into [src]!</span>")
		if(reinf)
			damage = damage / 2
		take_damage(damage)

	else
		if(!harmless)
			visible_message("<span class='notice'>\The [user] bonks \the [src] harmlessly.</span>")


	user.do_attack_animation(src)
	return 1

/obj/structure/window/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W)) return//I really wish I did not need this

	if(istype(W, /obj/item/device/floor_painter) && user.a_intent == I_HELP)
		return // windows are paintable now, so no accidental damage should happen.

	if(user.IsAntiGrief() && (user.a_intent != I_HELP || W))
		to_chat(user, "<span class='notice'>You don't feel like messing with windows.</span>")
		return

	// Fixing.
	if(istype(W, /obj/item/weapon/weldingtool) && user.a_intent == I_HELP)
		var/obj/item/weapon/weldingtool/WT = W
		if(health < maxhealth)
			if(WT.remove_fuel(1 ,user))
				to_chat(user, "<span class='notice'>You begin repairing [src]...</span>")
				playsound(src, WT.usesound, 50, 1)
				if(do_after(user, 40 * WT.toolspeed, target = src))
					health = maxhealth
			//		playsound(src, 'sound/items/Welder.ogg', 50, 1)
					update_icon()
					to_chat(user, "<span class='notice'>You repair [src].</span>")
		else
			to_chat(user, "<span class='warning'>[src] is already in good condition!</span>")
		return

	// Slamming.
	if (istype(W, /obj/item/weapon/grab) && get_dist(src,user)<2)
		var/obj/item/weapon/grab/G = W
		if(istype(G.affecting,/mob/living))
			var/mob/living/M = G.affecting
			var/state = G.state
			qdel(W)	//gotta delete it here because if window breaks, it won't get deleted
			switch (state)
				if(1)
					M.visible_message("<span class='warning'>[user] slams [M] against \the [src]!</span>")
					M.apply_damage(7)
					hit(10)
				if(2)
					M.visible_message("<span class='danger'>[user] bashes [M] against \the [src]!</span>")
					if (prob(50))
						M.Weaken(1)
					M.apply_damage(10)
					hit(25)
				if(3)
					M.visible_message("<span class='danger'><big>[user] crushes [M] against \the [src]!</big></span>")
					M.Weaken(5)
					M.apply_damage(20)
					hit(50)
			trigger_lot_security_system(user, /datum/lot_security_option/vandalism, "Slamming \the [M] against \the [src].")
			return

	if(W.flags & NOBLUDGEON) return

	if(istype(W, /obj/item/weapon/screwdriver))
		if(trigger_lot_security_system(user, /datum/lot_security_option/vandalism, "Using \the [W] to modify \the [src]."))
			return
		if(reinf && state >= 1)
			state = 3 - state
			update_nearby_icons()
			playsound(src, W.usesound, 75, 1)
			user << (state == 1 ? "<span class='notice'>You have unfastened the window from the frame.</span>" : "<span class='notice'>You have fastened the window to the frame.</span>")
		else if(reinf && state == 0)
			anchored = !anchored
			update_nearby_icons()
			update_verbs()
			playsound(src, W.usesound, 75, 1)
			user << (anchored ? "<span class='notice'>You have fastened the frame to the floor.</span>" : "<span class='notice'>You have unfastened the frame from the floor.</span>")
		else if(!reinf)
			anchored = !anchored
			update_nearby_icons()
			update_verbs()
			playsound(src, W.usesound, 75, 1)
			user << (anchored ? "<span class='notice'>You have fastened the window to the floor.</span>" : "<span class='notice'>You have unfastened the window.</span>")
	else if(istype(W, /obj/item/weapon/crowbar) && reinf && state <= 1)
		if(trigger_lot_security_system(user, /datum/lot_security_option/vandalism, "Using \the [W] to modify \the [src]."))
			return

		state = 1 - state
		playsound(src, W.usesound, 75, 1)
		user << (state ? "<span class='notice'>You have pried the window into the frame.</span>" : "<span class='notice'>You have pried the window out of the frame.</span>")
	else if(istype(W, /obj/item/weapon/wrench) && !anchored && (!state || !reinf))
		if(!glasstype)
			user << "<span class='notice'>You're not sure how to dismantle \the [src] properly.</span>"
		else
			if(trigger_lot_security_system(user, /datum/lot_security_option/vandalism, "Using \the [W] to dismantle \the [src]."))
				return

			playsound(src, W.usesound, 75, 1)
			visible_message("<span class='notice'>[user] dismantles \the [src].</span>")
			var/obj/item/stack/material/mats = new glasstype(loc)
			if(is_fulltile())
				mats.amount = 4
			qdel(src)
	else if(istype(W,/obj/item/frame) && anchored)
		var/obj/item/frame/F = W
		F.try_build(src)
	else
		user.setClickCooldown(user.get_attack_speed(W))
		if(W.damtype == BRUTE || W.damtype == BURN)
			user.do_attack_animation(src)
			hit(W.force)
			trigger_lot_security_system(user, /datum/lot_security_option/vandalism, "Damaging \the [src] with \a [W].")
			if(health <= 7)
				anchored = 0
				update_nearby_icons()
				step(src, get_dir(user, src))
		else
			playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
		..()
	return

/obj/structure/window/proc/hit(var/damage, var/sound_effect = 1)
	if(damage < force_threshold || force_threshold < 0)
		return
	if(reinf) damage *= 0.5
	take_damage(damage)
	return


/obj/structure/window/proc/rotate()
	set name = "Rotate Window Counter-Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(is_fulltile())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 90))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return


/obj/structure/window/proc/revrotate()
	set name = "Rotate Window Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.incapacitated())
		return 0

	if(is_fulltile())
		return 0

	if(anchored)
		usr << "It is fastened to the floor therefore you can't rotate it!"
		return 0

	update_nearby_tiles(need_rebuild=1) //Compel updates before
	set_dir(turn(dir, 270))
	updateSilicate()
	update_nearby_tiles(need_rebuild=1)
	return

/obj/structure/window/New(Loc, start_dir=null, constructed=0)
	..()

	if (start_dir)
		set_dir(start_dir)

	//player-constructed windows
	if (constructed)
		anchored = 0
		state = 0
		update_verbs()
		if(is_fulltile())
			maxhealth *= 2

	health = maxhealth

	ini_dir = dir

	update_connections(1)

	update_nearby_tiles(need_rebuild=1)
	update_nearby_icons()


/obj/structure/window/Destroy()
	density = 0
	update_nearby_tiles()
	var/turf/location = loc
	. = ..()
	for(var/obj/structure/window/W in orange(location, 1))
		W.update_icon()

/obj/structure/window/Move()
	var/ini_dir = dir
	update_nearby_tiles(need_rebuild=1)
	..()
	set_dir(ini_dir)
	update_nearby_tiles(need_rebuild=1)

//checks if this window is full-tile one
/obj/structure/window/proc/is_fulltile()
	if(dir & (dir - 1))
		return 1
	return 0

//This proc is used to update the icons of nearby windows. It should not be confused with update_nearby_tiles(), which is an atmos proc!
/obj/structure/window/proc/update_nearby_icons()
	update_icon()
	for(var/obj/structure/window/W in orange(src, 1))
		W.update_icon()

//Updates the availabiliy of the rotation verbs
/obj/structure/window/proc/update_verbs()
	if(anchored || is_fulltile())
		verbs -= /obj/structure/window/proc/rotate
		verbs -= /obj/structure/window/proc/revrotate
	else if(!is_fulltile())
		verbs += /obj/structure/window/proc/rotate
		verbs += /obj/structure/window/proc/revrotate

//merges adjacent full-tile windows into one (blatant ripoff from game/smoothwall.dm)
/obj/structure/window/update_icon()
	//A little cludge here, since I don't know how it will work with slim windows. Most likely VERY wrong.
	//this way it will only update full-tile ones
	overlays.Cut()
	update_onframe()
	if(!is_fulltile())
		icon_state = "[basestate]"
		return
	else
		var/image/I
		icon_state = ""
		if(on_frame)
			for(var/i = 1 to 4)
				if(other_connections[i] != "0")
					I = image(icon, "[basestate]_other_onframe[connections[i]]", dir = 1<<(i-1))
				else
					I = image(icon, "[basestate]_onframe[connections[i]]", dir = 1<<(i-1))
				overlays += I
		else
			for(var/i = 1 to 4)
				if(other_connections[i] != "0")
					I = image(icon, "[basestate]_other[connections[i]]", dir = 1<<(i-1))
				else
					I = image(icon, "[basestate][connections[i]]", dir = 1<<(i-1))
				overlays += I
	return

	/*
	// Unreachable code. Left incase it is needed later.

	// Damage overlays.
	var/ratio = health / maxhealth
	ratio = Ceiling(ratio * 4) * 25

	if(ratio > 75)
		return
	var/image/I = image(icon, "damage[ratio]", layer + 0.1)
	overlays += I

	return
	*/

/obj/structure/window/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > maximal_heat)
		hit(damage_per_fire_tick, 0)
	..()



/obj/structure/window/basic
	desc = "It looks thin and flimsy. A few knocks with... almost anything, really should shatter it."
	icon_state = "window"
	material_color = GLASS_COLOR
	color = GLASS_COLOR
	glasstype = /obj/item/stack/material/glass
	maximal_heat = T0C + 100
	damage_per_fire_tick = 2.0
	maxhealth = 12.0
	force_threshold = 3

/obj/structure/window/basic/full
	dir = SOUTHWEST
	icon_state = "rwindow_full"
	maxhealth = 80

/obj/structure/window/phoronbasic
	name = "phoron window"
	desc = "A borosilicate alloy window. It seems to be quite strong."
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronglass
	icon_state = "window"
	basestate = "window"
	maximal_heat = T0C + 2000
	damage_per_fire_tick = 1.0
	maxhealth = 40.0
	force_threshold = 5
	material_color = GLASS_COLOR_PHORON
	color = GLASS_COLOR_PHORON

/obj/structure/window/phoronbasic/full
	dir = 5
	icon_state = "phoronwindow0"

/obj/structure/window/phoronreinforced
	name = "reinforced borosilicate window"
	desc = "A borosilicate alloy window, with rods supporting it. It seems to be very strong."
	icon_state = "rwindow"
	basestate = "rwindow"
	shardtype = /obj/item/weapon/material/shard/phoron
	glasstype = /obj/item/stack/material/glass/phoronrglass
	reinf = 1
	maximal_heat = T0C + 4000
	damage_per_fire_tick = 1.0 // This should last for 80 fire ticks if the window is not damaged at all. The idea is that borosilicate windows have something like ablative layer that protects them for a while.
	maxhealth = 80.0
	force_threshold = 10
	material_color = GLASS_COLOR_PHORON
	color = GLASS_COLOR_PHORON

/obj/structure/window/phoronreinforced/full
	dir = SOUTHWEST
	maxhealth = 160
	material_color = GLASS_COLOR
	color = GLASS_COLOR

/obj/structure/window/reinforced
	name = "reinforced window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon_state = "rwindow"
	basestate = "rwindow"
	material_color = GLASS_COLOR
	color = GLASS_COLOR
	maxhealth = 40.0
	reinf = 1
	maximal_heat = T0C + 750
	damage_per_fire_tick = 2.0
	glasstype = /obj/item/stack/material/glass/reinforced
	force_threshold = 6

/obj/structure/window/reinforced/full
	dir = SOUTHWEST
	icon_state = "rwindow_full"
	maxhealth = 80

/obj/structure/window/reinforced/tinted
	name = "tinted window"
	desc = "It looks rather strong and opaque. Might take a few good hits to shatter it."
	icon_state = "window"
	opacity = 1
	color = GLASS_COLOR_TINTED

/obj/structure/window/reinforced/tinted/full
	dir = SOUTHWEST
	icon_state = "rwindow_full"
	maxhealth = 80

/obj/structure/window/reinforced/tinted/frosted
	name = "frosted window"
	desc = "It looks rather strong and frosted over. Looks like it might take a few less hits than a normal reinforced window."
	icon_state = "window"
	maxhealth = 30
	color = GLASS_COLOR_FROSTED
	force_threshold = 5

/obj/structure/window/shuttle
	name = "shuttle window"
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "0_0"
	basestate = "window"
	maxhealth = 40
	reinf = 1
	basestate = "w"
	dir = 5
	force_threshold = 7

/obj/structure/window/reinforced/polarized
	name = "electrochromic window"
	desc = "Adjusts its tint with voltage. Might take a few good hits to shatter it."
	basestate = "rwindow"
	var/id

/obj/structure/window/reinforced/polarized/proc/toggle()
	if(opacity)
		animate(src, color=material_color, time=5)
		set_opacity(0)
	else
		animate(src, color=GLASS_COLOR_TINTED, time=5)
		set_opacity(1)

/obj/structure/window/reinforced/polarized/full
	dir = 5
	icon_state = "rwindow_full"

/obj/structure/window/framed
	name = "framed window"
	alpha = 255
	desc = "It looks rather strong. Might take a few good hits to shatter it."
	icon = 'icons/obj/structures.dmi'
	icon_state = "framewindow"
	plane = MOB_PLANE + 10 //I think?
	dir = 2
	shardtype = /obj/structure/grille/frame

/obj/structure/window/framed/update_icon()
//Framed window tiles do not change.
	return

/obj/machinery/button/windowtint
	name = "window tint control"
	icon = 'icons/obj/power.dmi'
	icon_state = "light0"
	desc = "A remote control switch for polarized windows."
	var/range = 7

/obj/machinery/button/windowtint/attack_hand(mob/user as mob)
	if(..())
		return 1

	toggle_tint()

/obj/machinery/button/windowtint/proc/toggle_tint()
	use_power(5)

	active = !active
	update_icon()

	for(var/obj/structure/window/reinforced/polarized/W in range(src,range))
		if (W.id == src.id || !W.id)
			spawn(0)
				W.toggle()
				return

/obj/machinery/button/windowtint/power_change()
	..()
	if(active && !powered(power_channel))
		toggle_tint()

/obj/machinery/button/windowtint/update_icon()
	icon_state = "light[active]"

/obj/structure/window/proc/update_onframe()
	var/success = FALSE
	var/turf/T = get_turf(src)
	for(var/obj/O in T)
		if(istype(O, /obj/structure/wall_frame))
			success = TRUE
		if(success)
			break
	if(success)
		on_frame = TRUE
	else
		on_frame = FALSE

/proc/place_window(mob/user, loc, dir_to_set, obj/item/stack/material/ST)
	var/required_amount = (dir_to_set & (dir_to_set - 1)) ? 4 : 1
	if (!ST.can_use(required_amount))
		to_chat(user, "<span class='notice'>You do not have enough sheets.</span>")
		return
	for(var/obj/structure/window/WINDOW in loc)
		if(WINDOW.dir == dir_to_set)
			to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
			return
		if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1))) //two fulltile windows
			to_chat(user, "<span class='notice'>There is already a window there.</span>")
			return
	to_chat(user, "<span class='notice'>You start placing the window.</span>")
	if(do_after(user,20))
		for(var/obj/structure/window/WINDOW in loc)
			if(WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
				to_chat(user, "<span class='notice'>There is already a window facing this way there.</span>")
				return
			if(WINDOW.is_fulltile() && (dir_to_set & (dir_to_set - 1)))
				to_chat(user, "<span class='notice'>There is already a window there.</span>")
				return

		if (ST.use(required_amount))
			var/obj/structure/window/WD = new(loc, dir_to_set, FALSE, ST.material.name)
			to_chat(user, "<span class='notice'>You place [WD].</span>")
			WD.anchored = FALSE
		else
			to_chat(user, "<span class='notice'>You do not have enough sheets.</span>")
			return