//TODO: rewrite and standardise all controller datums to the datum/controller type
//TODO: allow all controllers to be deleted for clean restarts (see WIP master controller stuff) - MC done - lighting done

// Clickable stat() button.
/obj/effect/statclick
	name = "Initializing..."
	var/target

/obj/effect/statclick/New(loc, text, target) //Don't port this to Initialize it's too critical
	..()
	name = text
	src.target = target

/obj/effect/statclick/proc/update(text)
	name = text
	return src

/obj/effect/statclick/debug
	var/class

/obj/effect/statclick/debug/Click()
	if(!usr.client.holder || !target)
		return
	if(!class)
		if(istype(target, /datum/controller/subsystem))
			class = "subsystem"
		else if(istype(target, /datum/controller))
			class = "controller"
		else if(istype(target, /datum))
			class = "datum"
		else
			class = "unknown"

	usr.client.debug_variables(target)
	message_admins("Admin [key_name_admin(usr)] is debugging the [target] [class].")


// Debug verbs.
/client/proc/restart_controller(controller in list("Master", "Failsafe"))
	set category = "Debug"
	set name = "Restart Controller"
	set desc = "Restart one of the various periodic loop controllers for the game (be careful!)"

	if(!holder)
		return
	switch(controller)
		if("Master")
			Recreate_MC()
			feedback_add_details("admin_verb","RMC")
		if("Failsafe")
			new /datum/controller/failsafe()
			feedback_add_details("admin_verb","RFailsafe")

	message_admins("Admin [key_name_admin(usr)] has restarted the [controller] controller.")

/client/proc/debug_antagonist_template(antag_type in all_antag_types)
	set category = "Debug"
	set name = "Debug Antagonist"
	set desc = "Debug an antagonist template."

	var/datum/antagonist/antag = all_antag_types[antag_type]
	if(antag)
		usr.client.debug_variables(antag)
		message_admins("Admin [key_name_admin(usr)] is debugging the [antag.role_text] template.")


/client/proc/debug_controller(controller in list("Master","Ticker","Ticker Process","Air","Jobs","Sun","Economy","Payroll", \
	"Laws","Emails","Lots","Radio","Supply","Shuttles","Emergency Shuttle","Configuration","pAI", "Cameras", "Transfer Controller", \
	"Gas Data","Event","Plants","Alarm","Nano","Chemistry","Vote","Xenobio","Planets", "Websites", "Businesses", "Bounties"))

	set category = "Debug"
	set name = "Debug Controller"
	set desc = "Debug the various periodic loop controllers for the game (be careful!)"

	if(!holder)	return
	switch(controller)
		if("Master")
			debug_variables(master_controller)
			feedback_add_details("admin_verb","DMC")
		if("Ticker")
			debug_variables(ticker)
			feedback_add_details("admin_verb","DTicker")
		if("Ticker Process")
			debug_variables(tickerProcess)
			feedback_add_details("admin_verb","DTickerProcess")
		if("Air")
			debug_variables(air_master)
			feedback_add_details("admin_verb","DAir")
		if("Jobs")
			debug_variables(SSjobs)
			feedback_add_details("admin_verb","DJobs")
		if("Radio")
			debug_variables(radio_controller)
			feedback_add_details("admin_verb","DRadio")
		if("Supply")
			debug_variables(supply_controller)
			feedback_add_details("admin_verb","DSupply")
		if("Shuttles")
			debug_variables(shuttle_controller)
			feedback_add_details("admin_verb","DShuttles")
		if("Emergency Shuttle")
			debug_variables(emergency_shuttle)
			feedback_add_details("admin_verb","DEmergency")
		if("Configuration")
			debug_variables(config)
			feedback_add_details("admin_verb","DConf")
		if("pAI")
			debug_variables(paiController)
			feedback_add_details("admin_verb","DpAI")
		if("Cameras")
			debug_variables(cameranet)
			feedback_add_details("admin_verb","DCameras")
		if("Transfer Controller")
			debug_variables(transfer_controller)
			feedback_add_details("admin_verb","DAutovoter")
		if("Gas Data")
			debug_variables(gas_data)
			feedback_add_details("admin_verb","DGasdata")
		if("Event")
			debug_variables(SSevents)
			feedback_add_details("admin_verb", "DEvent")
		if("Plants")
			debug_variables(plant_controller)
			feedback_add_details("admin_verb", "DPlants")
		if("Alarm")
			debug_variables(alarm_manager)
			feedback_add_details("admin_verb", "DAlarm")
		if("Chemistry")
			debug_variables(chemistryProcess)
			feedback_add_details("admin_verb", "DChem")
		if("Vote")
			debug_variables(SSvote)
			feedback_add_details("admin_verb", "DVote")
		if("Planets")
			debug_variables(SSplanets)
			feedback_add_details("admin_verb", "DPlanets")
		if("Lots")
			debug_variables(SSlots)
			feedback_add_details("admin_verb", "DLots")
		if("Emails")
			debug_variables(SSemails)
			feedback_add_details("admin_verb", "DEmails")
		if("Laws")
			debug_variables(SSlaw)
			feedback_add_details("admin_verb", "DLaw")
		if("Economy")
			debug_variables(SSeconomy)
			feedback_add_details("admin_verb", "DEconomy")
		if("Payroll")
			debug_variables(SSpayroll)
			feedback_add_details("admin_verb", "DPayroll")
		if("Websites")
			debug_variables(SSwebsites)
			feedback_add_details("admin_verb", "DWebsites")
		if("Businesses")
			debug_variables(SSbusiness)
			feedback_add_details("admin_verb", "DBusinesses")
		if("Bounties")
			debug_variables(SSbounties)
			feedback_add_details("admin_verb", "DBounties")

	message_admins("Admin [key_name_admin(usr)] is debugging the [controller] controller.")
