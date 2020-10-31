//Todo: add leather and cloth for arbitrary coloured stools.
var/global/list/stool_cache = list() //haha stool

/obj/item/weapon/stool
	name = "stool"
	desc = "Apply butt."
	icon = 'icons/obj/furniture.dmi'
	icon_state = "stool_preview" //set for the map
	force = 10
	throwforce = 10
	w_class = ITEMSIZE_HUGE
	var/base_icon = "stool_base"
	var/padding_icon = "stool_padding"
	var/material/material
	var/material/padding_material

/obj/item/weapon/stool/get_persistent_metadata()
	if(!material)
		return FALSE

	var/list/stool_data = list()
	stool_data["material"] = material.name
	if(padding_material)
		stool_data["padding_material"] = padding_material.name

	return stool_data

/obj/item/weapon/stool/load_persistent_metadata(metadata)
	var/list/stool_data = metadata
	if(!islist(stool_data))
		return
	if(get_material_by_name(stool_data["material"]))
		material = get_material_by_name(stool_data["material"])
	if(get_material_by_name(stool_data["padding_material"]))
		padding_material = get_material_by_name(stool_data["padding_material"])

	update_icon()

	return TRUE


/obj/item/weapon/stool/wooden
	burn_state = 0 //Buuuurn baby burn. Disco inferno!
	burntime = SHORT_BURN

/obj/item/weapon/stool/wooden/New(var/newloc, var/new_material)
	..(newloc, "wood")


/obj/item/weapon/stool/padded
	icon_state = "stool_padded_preview" //set for the map

/obj/item/weapon/stool/New(var/newloc, var/new_material, var/new_padding_material)
	..(newloc)
	if(!new_material)
		new_material = DEFAULT_WALL_MATERIAL
	material = get_material_by_name(new_material)
	if(new_padding_material)
		padding_material = get_material_by_name(new_padding_material)
	if(!istype(material))
		qdel(src)
		return
	force = round(material.get_blunt_damage()*0.4)
	update_icon()

/obj/item/weapon/stool/padded/New(var/newloc, var/new_material)
	..(newloc, "steel", "carpet")

/obj/item/weapon/stool/update_icon()
	// Prep icon.
	icon_state = ""
	overlays.Cut()
	// Base icon.
	var/cache_key = "[base_icon]-[material.name]"
	if(isnull(stool_cache[cache_key]))
		var/image/I = image(icon, base_icon)
		I.color = material.icon_colour
		stool_cache[cache_key] = I
	overlays |= stool_cache[cache_key]
	// Padding overlay.
	if(padding_material)
		var/padding_cache_key = "[base_icon]-padding-[padding_material.name]"
		if(isnull(stool_cache[padding_cache_key]))
			var/image/I =  image(icon, padding_icon)
			I.color = padding_material.icon_colour
			stool_cache[padding_cache_key] = I
		overlays |= stool_cache[padding_cache_key]
	// Strings.
	if(padding_material)
		name = "[padding_material.display_name] [initial(name)]" //this is not perfect but it will do for now.
		desc = "A padded stool. Apply butt. It's made of [material.use_name] and covered with [padding_material.use_name]."
	else
		name = "[material.display_name] [initial(name)]"
		desc = "A stool. Apply butt with care. It's made of [material.use_name]."

/obj/item/weapon/stool/proc/add_padding(var/padding_type)
	padding_material = get_material_by_name(padding_type)
	update_icon()

/obj/item/weapon/stool/proc/remove_padding()
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
		padding_material = null
	update_icon()

/obj/item/weapon/stool/attack(mob/M as mob, mob/user as mob)
	if (prob(5) && istype(M,/mob/living))
		user.visible_message("<span class='danger'>[user] breaks [src] over [M]'s back!</span>")
		user.setClickCooldown(user.get_attack_speed())
		user.do_attack_animation(M)

		user.drop_from_inventory(src)

		user.remove_from_mob(src)
		dismantle()
		qdel(src)
		var/mob/living/T = M
		T.Weaken(10)
		T.apply_damage(20)
		return
	..()

/obj/item/weapon/stool/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return

/obj/item/weapon/stool/proc/dismantle()
	if(material)
		material.place_sheet(get_turf(src))
	if(padding_material)
		padding_material.place_sheet(get_turf(src))
	qdel(src)

/obj/item/weapon/stool/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/wrench))
		if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to deassemble \the [src] with [W]."))
			return
		playsound(src, W.usesound, 50, 1)
		dismantle()
		qdel(src)
	else if(istype(W,/obj/item/stack))
		if(padding_material)
			user << "\The [src] is already padded."
			return
		var/obj/item/stack/C = W
		if(C.get_amount() < 1) // How??
			user.drop_from_inventory(C)
			qdel(C)
			return
		var/padding_type //This is awful but it needs to be like this until tiles are given a material var.
		if(istype(W,/obj/item/stack/tile/carpet))
			padding_type = "carpet"
		else if(istype(W,/obj/item/stack/material))
			var/obj/item/stack/material/M = W
			if(M.material && (M.material.flags & MATERIAL_PADDING))
				padding_type = "[M.material.name]"
		if(!padding_type)
			user << "You cannot pad \the [src] with that."
			return
		C.use(1)
		if(!istype(src.loc, /turf))
			user.drop_from_inventory(src)
			src.loc = get_turf(src)
		user << "You add padding to \the [src]."
		add_padding(padding_type)
		return
	else if (istype(W, /obj/item/weapon/wirecutters))
		if(!padding_material)
			user << "\The [src] has no padding to remove."
			return
		if(trigger_lot_security_system(null, /datum/lot_security_option/vandalism, "Attempted to remove padding from \the [src] with [W]."))
			return
		to_chat(user, "You remove the padding from \the [src].")
		playsound(src.loc, W.usesound, 50, 1)
		remove_padding()
	else
		..()


/obj/item/weapon/stool/bar
	name = "bar stool"
	icon_state = "barstool"

	base_icon = "barstool"
	padding_icon = "barstool_padding"

/obj/item/weapon/stool/bar/padded/New(var/newloc, var/new_material)
	..(newloc, "steel", "carpet")

/obj/item/weapon/stool/bar/wooden/New(var/newloc, var/new_material)
	..(newloc, "wood")

/obj/item/weapon/stool/bar/wooden/padded/New(var/newloc, var/new_material)
	..(newloc, "wood", "carpet")

