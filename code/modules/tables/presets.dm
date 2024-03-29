//TABLE PRESETS
/obj/structure/table/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/standard/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	..()

/obj/structure/table/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/steel/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/marble/New()
	material = get_material_by_name("marble")
	..()

/obj/structure/table/gold
	icon_state = "plain_preview"
	color = COLOR_GOLD

/obj/structure/table/gold/New()
	material = get_material_by_name("gold")
	..()

/obj/structure/table/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/reinforced/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/steel_reinforced/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/wooden_reinforced/New()
	material = get_material_by_name("wood")
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/woodentable
	burn_state = 0 //Burnable
	burntime = MEDIUM_BURN
	icon_state = "plain_preview"

/obj/structure/table/woodentable/New()
	material = get_material_by_name("wood")
	..()

/obj/structure/table/gamblingtable
	icon_state = "gamble_preview"
	burn_state = 0 //Burnable
	burntime = MEDIUM_BURN

/obj/structure/table/gamblingtable/New()
	material = get_material_by_name("wood")
	carpeted = 1
	..()

/obj/structure/table/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255
	var/glass_type = "glass"

/obj/structure/table/glass/New()
	material = get_material_by_name(glass_type)
	..()

/obj/structure/table/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/holotable/New()
	material = get_material_by_name("holo[DEFAULT_TABLE_MATERIAL]")
	..()

/obj/structure/table/woodentable/holotable
	icon_state = "holo_preview"

/obj/structure/table/woodentable/holotable/New()
	material = get_material_by_name("holowood")
	..()

/obj/structure/table/alien
	name = "alien table"
	desc = "Advanced flat surface technology at work!"
	icon_state = "alien_preview"
	can_reinforce = FALSE
	can_plate = FALSE

/obj/structure/table/alien/New()
	material = get_material_by_name("alium")
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put
	..()

/obj/structure/table/alien/dismantle(obj/item/weapon/wrench/W, mob/user)
	to_chat(user, "<span class='warning'>You cannot dismantle \the [src].</span>")
	return

//BENCH PRESETS
/obj/structure/table/bench/standard
	icon_state = "plain_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/standard/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	..()

/obj/structure/table/bench/steel
	icon_state = "plain_preview"
	color = "#666666"

/obj/structure/table/bench/steel/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()


/obj/structure/table/bench/marble
	icon_state = "stone_preview"
	color = "#CCCCCC"

/obj/structure/table/bench/marble/New()
	material = get_material_by_name("marble")
	..()
/*
/obj/structure/table/bench/reinforced
	icon_state = "reinf_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/reinforced/New()
	material = get_material_by_name(DEFAULT_TABLE_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/bench/steel_reinforced
	icon_state = "reinf_preview"
	color = "#666666"

/obj/structure/table/bench/steel_reinforced/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()

/obj/structure/table/bench/wooden_reinforced
	icon_state = "reinf_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden_reinforced/New()
	material = get_material_by_name("wood")
	reinforced = get_material_by_name(DEFAULT_WALL_MATERIAL)
	..()
*/
/obj/structure/table/bench/wooden
	icon_state = "plain_preview"
	color = "#824B28"

/obj/structure/table/bench/wooden/New()
	material = get_material_by_name("wood")
	..()

/obj/structure/table/bench/padded
	icon_state = "padded_preview"

/obj/structure/table/bench/padded/New()
	material = get_material_by_name(DEFAULT_WALL_MATERIAL)
	carpeted = 1
	..()

/obj/structure/table/bench/glass
	icon_state = "plain_preview"
	color = "#00E1FF"
	alpha = 77 // 0.3 * 255

/obj/structure/table/bench/glass/New()
	material = get_material_by_name("glass")
	..()

/*
/obj/structure/table/bench/holotable
	icon_state = "holo_preview"
	color = "#EEEEEE"

/obj/structure/table/bench/holotable/New()
	material = get_material_by_name("holo[DEFAULT_TABLE_MATERIAL]")
	..()

/obj/structure/table/bench/wooden/holotable
	icon_state = "holo_preview"

/obj/structure/table/bench/wooden/holotable/New()
	material = get_material_by_name("holowood")
	..()
*/



/obj/structure/table/woodentable_reinforced/walnut/New()
	..()
	icon_state = "reinf_preview"
	material = get_material_by_name(MATERIAL_WALNUT)
	reinforced = MATERIAL_WALNUT

/obj/structure/table/woodentable/mahogany/New()
	..()
	material = get_material_by_name(MATERIAL_MAHOGANY)

/obj/structure/table/woodentable/maple/New()
	..()
	material = get_material_by_name(MATERIAL_MAPLE)

/obj/structure/table/woodentable/ebony/New()
	..()
	material = get_material_by_name(MATERIAL_EBONY)

/obj/structure/table/woodentable/walnut/New()
	..()
	material = get_material_by_name(MATERIAL_WALNUT)