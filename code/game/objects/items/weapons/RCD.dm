//Contains the rapid construction device.
/obj/item/weapon/rcd
	name = "rapid construction device"
	desc = "A device used to rapidly build walls and floors."
	icon = 'icons/obj/items.dmi'
	icon_state = "rcd"
	opacity = 0
	density = 0
	anchored = 0.0
	flags = CONDUCT
	force = 10.0
	throwforce = 10.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 50000)
	preserve_item = 1
	var/datum/effect/effect/system/spark_spread/spark_system
	var/stored_matter = 0
	var/max_stored_matter = 30
	var/working = 0
	var/mode = 1
	var/list/modes = list("Floor & Walls","Airlock","Deconstruct")
	var/canRwall = 0
	var/disabled = 0

	unique_save_vars = list("stored_matter")

/obj/item/weapon/rcd/attack()
	return 0

/obj/item/weapon/rcd/proc/can_use(var/mob/user,var/turf/T)
	var/usable = 0
	if(user.Adjacent(T) && user.get_active_hand() == src && !user.stat && !user.restrained())
		usable = 1
	if(!user.IsAdvancedToolUser() && istype(user, /mob/living/simple_animal))
		var/mob/living/simple_animal/S = user
		if(!S.IsHumanoidToolUser(src))
			usable = 0
	return usable

/obj/item/weapon/rcd/examine()
	..()
	if(src.type == /obj/item/weapon/rcd && loc == usr)
		usr << "It currently holds [stored_matter]/[max_stored_matter] matter-units."

/obj/item/weapon/rcd/New()
	..()
	src.spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

/obj/item/weapon/rcd/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/item/weapon/rcd/attackby(obj/item/weapon/W, mob/user)

	if(istype(W, /obj/item/weapon/rcd_ammo))
		var/obj/item/weapon/rcd_ammo/cartridge = W
		if((stored_matter + cartridge.remaining) > max_stored_matter)
			to_chat(user, "<span class='notice'>The RCD can't hold that many additional matter-units.</span>")
			return
		stored_matter += cartridge.remaining
		user.drop_from_inventory(W)
		qdel(W)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		return
	..()

/obj/item/weapon/rcd/attack_self(mob/user)
	//Change the mode
	if(++mode > 3) mode = 1
	user << "<span class='notice'>Changed mode to '[modes[mode]]'</span>"
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if(prob(20)) src.spark_system.start()

/obj/item/weapon/rcd/afterattack(atom/A, mob/user, proximity)
	if(!proximity) return
	if(disabled && !isrobot(user))
		return 0
	if(istype(get_area(A),/area/shuttle)||istype(get_area(A),/turf/space/transit))
		return 0
	return alter_turf(A,user,(mode == 3))

/obj/item/weapon/rcd/proc/useResource(var/amount, var/mob/user)
	if(stored_matter < amount)
		return 0
	stored_matter -= amount
	return 1

/obj/item/weapon/rcd/proc/alter_turf(var/turf/T,var/mob/user,var/deconstruct)

	var/build_cost = 0
	var/build_type
	var/build_turf
	var/build_delay
	var/build_other

	if(working == 1)
		return 0

	if(mode == 3 && istype(T,/obj/machinery/door/airlock))
		build_cost =  10
		build_delay = 50
		build_type = "airlock"
	else if(mode == 2 && !deconstruct && istype(T,/turf/simulated/floor))
		build_cost =  10
		build_delay = 50
		build_type = "airlock"
		build_other = /obj/machinery/door/airlock
	else if(!deconstruct && isturf(T) && (istype(T,/turf/space) || istype(T,get_base_turf_by_area(T))))
		build_cost =  1
		build_type =  "floor"
		build_turf =  /turf/simulated/floor/airless
	else if(!deconstruct && istype(T,/turf/simulated/mineral/floor))
		build_cost =  1
		build_type =  "floor"
		build_turf =  /turf/simulated/floor/plating
	else if(deconstruct && istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W = T
		build_delay = deconstruct ? 50 : 40
		build_cost =  5
		build_type =  (!canRwall && W.reinf_material) ? null : "wall"
		build_turf =  /turf/simulated/floor
	else if(istype(T,/turf/simulated/floor) || (istype(T,/turf/simulated/mineral) && !T.density))
		var/turf/simulated/F = T
		build_delay = deconstruct ? 50 : 20
		build_cost =  deconstruct ? 10 : 3
		build_type =  deconstruct ? "floor" : "wall"
		build_turf =  deconstruct ? get_base_turf_by_area(F) : /turf/simulated/wall

	if(!build_type)
		working = 0
		return 0

	if(!useResource(build_cost, user))
		user << "Insufficient resources."
		return 0

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)

	working = 1
	user << "[(deconstruct ? "Deconstructing" : "Building")] [build_type]..."

	if(build_delay && !do_after(user, build_delay))
		working = 0
		return 0

	working = 0
	if(build_delay && !can_use(user,T))
		return 0

	if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "[(deconstruct ? "Deconstructing the" : "Building on")] [T] with [src]."))
		return 0

	if(build_turf)
		T.ChangeTurf(build_turf, preserve_outdoors = TRUE)
	else if(build_other)
		new build_other(T)
	else
		qdel(T)

	playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
	return 1

/obj/item/weapon/rcd_ammo
	name = "compressed matter cartridge"
	desc = "Highly compressed matter for the RCD."
	icon = 'icons/obj/ammo.dmi'
	icon_state = "rcd"
	item_state = "rcdammo"
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_MATERIAL = 2)
	matter = list(DEFAULT_WALL_MATERIAL = 30000,"glass" = 15000)
	var/remaining = 10

/obj/item/weapon/rcd_ammo/large
	name = "high-capacity matter cartridge"
	desc = "Do not ingest."
	matter = list(DEFAULT_WALL_MATERIAL = 45000,"glass" = 22500)
	remaining = 30
	origin_tech = list(TECH_MATERIAL = 4)

/obj/item/weapon/rcd/borg
	canRwall = 1

/obj/item/weapon/rcd/borg/lesser
	canRwall = FALSE

/obj/item/weapon/rcd/borg/useResource(var/amount, var/mob/user)
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			var/cost = amount*30
			if(R.cell.charge >= cost)
				R.cell.use(cost)
				return 1
	return 0

/obj/item/weapon/rcd/borg/attackby()
	return

/obj/item/weapon/rcd/borg/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat)


/obj/item/weapon/rcd/mounted/useResource(var/amount, var/mob/user)
	var/cost = amount*130 //so that a rig with default powercell can build ~2.5x the stuff a fully-loaded RCD can.
	if(istype(loc,/obj/item/rig_module))
		var/obj/item/rig_module/module = loc
		if(module.holder && module.holder.cell)
			if(module.holder.cell.charge >= cost)
				module.holder.cell.use(cost)
				return 1
	return 0

/obj/item/weapon/rcd/mounted/attackby()
	return

/obj/item/weapon/rcd/mounted/can_use(var/mob/user,var/turf/T)
	return (user.Adjacent(T) && !user.stat && !user.restrained())
