/obj/item/weapon/storage/box/bloodpacks
	name = "blood packs bags"
	desc = "This box contains blood packs."
	icon_state = "sterile"
	drop_sound = 'sound/items/drop/food.ogg'


/obj/item/weapon/storage/box/bloodpacks/New()
		..()
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)
		new /obj/item/weapon/reagent_containers/blood/empty(src)

/obj/item/weapon/reagent_containers/blood
	name = "IV pack"
	var/base_name = " "
	desc = "Holds liquids used for transfusion."
	var/base_desc = " "
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	item_state = "bloodpack_empty"
	volume = 200
	var/label_text = ""

	var/blood_type = null

/obj/item/weapon/reagent_containers/blood/can_empty()
	return TRUE

/obj/item/weapon/reagent_containers/blood/New()
	..()
	base_name = name
	base_desc = desc
	if(blood_type != null)
		label_text = "[blood_type]"
		update_iv_label()
		reagents.add_reagent("blood", 200, list("donor"=null,"viruses"=null,"blood_DNA"=null,"blood_type"=blood_type,"resistances"=null,"trace_chem"=null))
		update_icon()

/obj/item/weapon/reagent_containers/blood/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/blood/update_icon()
	var/percent = round((reagents.total_volume / volume) * 100)
	if(percent >= 0 && percent <= 9)
		icon_state = "empty"
		item_state = "bloodpack_empty"
	else if(percent >= 10 && percent <= 50)
		icon_state = "half"
		item_state = "bloodpack_half"
	else if(percent >= 51 && percent < INFINITY)
		icon_state = "full"
		item_state = "bloodpack_full"

/obj/item/weapon/reagent_containers/blood/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/pen) || istype(W, /obj/item/device/flashlight/pen))
		var/tmp_label = sanitizeSafe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(length(tmp_label) > 50)
			to_chat(user, "<span class='notice'>The label can be at most 50 characters long.</span>")
		else if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>You set the label.</span>")
			label_text = tmp_label
			update_iv_label()
		else
			to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
			label_text = tmp_label
			update_iv_label()

/obj/item/weapon/reagent_containers/blood/proc/update_iv_label()
	if(label_text == "")
		name = base_name
	else if(length(label_text) > 10)
		var/short_label_text = copytext(label_text, 1, 11)
		name = "IV Pack ([short_label_text]...)"
	else
		name = "IV Pack ([label_text])"
	desc = "Holds liquids used for transfusion. It is labeled \"[label_text]\"."

/obj/item/weapon/reagent_containers/blood/APlus
	name= "Blood Pack (A+)"
	blood_type = "A+"

/obj/item/weapon/reagent_containers/blood/AMinus
	name= "Blood Pack (A-)"
	blood_type = "A-"

/obj/item/weapon/reagent_containers/blood/BPlus
	name= "Blood Pack (B+)"
	blood_type = "B+"

/obj/item/weapon/reagent_containers/blood/BMinus
	name= "Blood Pack (B-)"
	blood_type = "B-"

/obj/item/weapon/reagent_containers/blood/OPlus
	name= "Blood Pack (O+)"
	blood_type = "O+"

/obj/item/weapon/reagent_containers/blood/OMinus
	name= "Blood Pack (A-)"
	blood_type = "O-"

/obj/item/weapon/reagent_containers/blood/empty
	name = "Empty Blood Pack"
	desc = "Seems pretty useless... Maybe if there were a way to fill it?"
	icon_state = "empty"
	item_state = "bloodpack_empty"