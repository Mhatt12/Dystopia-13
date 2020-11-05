// Sif Planetside stuff
#define O2MARS 0.181
#define N2MARS 0.819

#define MOLES_CELLMARS 114.50978

#define MOLES_O2MARS (MOLES_CELLMARS * O2MARS) // O2 value on Sif(18%)
#define MOLES_N2MARS (MOLES_CELLMARS * N2MARS) // N2 value on Sif(82%)

#define TEMPERATURE_MARS 293
#define TEMPERATURE_ALTMARS 190.15

/turf/simulated/floor/outdoors/mud/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/outdoors/rocks/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/tiled/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS
	outdoors = TRUE

/turf/simulated/floor/tiled/steel/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS
	outdoors = TRUE

/turf/simulated/floor/plating/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS
	outdoors = TRUE

/turf/simulated/floor/outdoors/snow/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/outdoors/grass/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/outdoors/grass/mars/forest/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/outdoors/dirt/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/mineral/mars
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/mineral/ignore_mapgen/mars
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/mineral/floor/mars
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS
	outdoors = TRUE
/turf/simulated/mineral/floor/ignore_mapgen/mars
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/outdoors/mud/mars/planetuse
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

// PoI compatability, to stop active edges.
// In hindsight it would've been better to do this first instead of making a billion /MARS subtypes above,
// but maybe we can transition to this instead now and over time get rid of the /MARS subtypes.
// The downside is if someone wants to use this in normal/vaccum they'll need to make a new subtype, but since the typical use case has changed, this might be acceptable.

/turf/simulated/mineral
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/outdoors
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/water
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/shuttle/floor/alienplating/external
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/shuttle/floor/voidcraft/external
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/shuttle/floor/voidcraft/external/dark
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/shuttle/floor/voidcraft/external/light
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/plating/external
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/floor/tiled/external
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_MARS

/turf/simulated/sky
	oxygen		= MOLES_O2MARS
	nitrogen	= MOLES_N2MARS
	temperature	= TEMPERATURE_ALTMARS

// Space mineral tiles are now not the default, so they get demoted to subtype status.

/turf/simulated/mineral/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/mineral/ignore_mapgen/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/mineral/floor/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

/turf/simulated/mineral/floor/ignore_mapgen/vacuum
	oxygen = 0
	nitrogen = 0
	temperature = TCMB

// Step trigger to fall down to planet MARS
/obj/effect/step_trigger/teleporter/planetary_fall/mars/initialize()
	planet = planet_mars
	. = ..()

/turf/simulated/floor/redspace
	icon = 'icons/turf/redspace.dmi'
	icon_state = "basalt"
	oxygen = MOLES_O2MARS
	nitrogen = MOLES_N2MARS
	temperature = 430
