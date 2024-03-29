//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/item/weapon/airlock_electronics
	name = "airlock electronics"
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_electronics"
	w_class = ITEMSIZE_SMALL //It should be tiny! -Agouri

	matter = list(DEFAULT_WALL_MATERIAL = 50,"glass" = 50)

	req_access = list()

	unique_save_vars = list("req_access", "conf_access", "one_access", "last_configurator", "locked")

	var/secure = 0 //if set, then wires will be randomized and bolts will drop if the door is broken
	var/list/conf_access = null
	var/one_access = 0 //if set to 1, door would receive req_one_access instead of req_access
	var/last_configurator = null
	var/locked = 1

	attack_self(mob/user as mob)
		if (!ishuman(user) && !istype(user,/mob/living/silicon/robot))
			return ..(user)

		var/t1 = text("<B>Access control</B><br>\n")

		if (last_configurator)
			t1 += "Operator: [last_configurator]<br>"

		if (locked)
			t1 += "<a href='?src=\ref[src];login=1'>Swipe ID</a><hr>"
		else
			t1 += "<a href='?src=\ref[src];logout=1'>Block</a><hr>"

			t1 += "Access requirement is set to "
			t1 += one_access ? "<a style='color: green' href='?src=\ref[src];one_access=1'>ONE</a><hr>" : "<a style='color: red' href='?src=\ref[src];one_access=1'>ALL</a><hr>"

			t1 += conf_access == null ? "<font color=red>All</font><br>" : "<a href='?src=\ref[src];access=all'>All</a><br>"

			t1 += "<br>"
			t1 += "<b>City Accesses:</b><br>"
			var/list/accesses = get_all_station_access()
			for (var/acc in accesses)
				var/aname = get_access_desc(acc)

				if (!conf_access || !conf_access.len || !(acc in conf_access))
					t1 += "<a href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
				else if(one_access)
					t1 += "<a style='color: green' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"
				else
					t1 += "<a style='color: red' href='?src=\ref[src];access=[acc]'>[aname]</a><br>"

			t1 += "<br><b>Business Accesses:</b><br>"
			var/list/baccesses = SSbusiness.business_access_list
			for (var/datum/access/accb in baccesses)
				var/bname = get_biz_access_name_id(accb.id)

				if (!conf_access || !conf_access.len || !(accb.id in conf_access))
					t1 += "<a href='?src=\ref[src];access=[accb.id]'>[bname]</a><br>"
				else if(one_access)
					t1 += "<a style='color: green' href='?src=\ref[src];access=[accb.id]'>[bname]</a><br>"
				else
					t1 += "<a style='color: red' href='?src=\ref[src];access=[accb.id]'>[bname]</a><br>"

		t1 += text("<p><a href='?src=\ref[];close=1'>Close</a></p>\n", src)

		user << browse(t1, "window=airlock_electronics")
		onclose(user, "airlock")

	Topic(href, href_list)
		..()
		if (usr.stat || usr.restrained() || (!ishuman(usr) && !istype(usr,/mob/living/silicon)))
			return
		if (href_list["close"])
			usr << browse(null, "window=airlock")
			return

		if (href_list["login"])
			if(istype(usr,/mob/living/silicon))
				src.locked = 0
				src.last_configurator = usr.name
			else
				var/obj/item/I = usr.get_active_hand()
				if (istype(I, /obj/item/device/pda))
					var/obj/item/device/pda/pda = I
					I = pda.id
				if (I && src.check_access(I))
					src.locked = 0
					if("registered_name" in I.vars)	// some check_access things don't have this.
						last_configurator = I:registered_name

		if (locked)
			return

		if (href_list["logout"])
			locked = 1

		if (href_list["one_access"])
			one_access = !one_access

		if (href_list["access"])
			toggle_access(href_list["access"])

		attack_self(usr)

	proc
		toggle_access(var/acc)
			if (acc == "all")
				conf_access = null
			else
				var/req = text2num(acc)

				if(!req)
					req = acc

				if (conf_access == null)
					conf_access = list()

				if (!(req in conf_access))
					conf_access += req
				else
					conf_access -= req
					if (!conf_access.len)
						conf_access = null


/obj/item/weapon/airlock_electronics/secure
	name = "secure airlock electronics"
	desc = "designed to be somewhat more resistant to hacking than standard electronics."
	origin_tech = list(TECH_DATA = 2)
	secure = 1