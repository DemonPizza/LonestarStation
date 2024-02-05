/obj/structure/shuttle
	name = "shuttle"
	icon = 'icons/turf/shuttle_parts.dmi'

/obj/structure/shuttle/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "0_0" //The states are a bitflag for connecting window directions, then connecting shuttle wall directions
	density = 1
	opacity = 0
	anchored = 1
	can_atmos_pass = ATMOS_PASS_NO

	var/window_flags = 0 // Bitflags to indicate connected windows
	var/wall_flags = 0 // Bitflags to indicate connected walls

/obj/structure/shuttle/window/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return TRUE
	return ..()

/obj/structure/shuttle/window/Initialize()
	. = ..()
	auto_join()

/obj/structure/shuttle/window/proc/auto_join()
	match_windows(NORTH, NORTH)
	match_windows(EAST, EAST)
	match_windows(SOUTH, SOUTH)
	match_windows(WEST, WEST)

	icon_state = "[window_flags]_[wall_flags]"

	return icon_state

/obj/structure/shuttle/window/proc/match_windows(direction, flag, mask=0)
	var/turf/adj = get_step(src, direction)

	if(istype(adj,/turf/simulated/shuttle/wall))
		wall_flags |= flag      // turn on the bit flag
	else
		var/obj/structure/shuttle/window/window = locate(src.type) in adj
		if(window)
			window_flags |= flag      // turn on the bit flag
		else
			window_flags &= ~flag     // turn off the bit flag
			wall_flags &= ~flag     // turn off the bit flag

/obj/structure/shuttle/engine
	name = "engine"
	density = 1
	anchored = 1.0

/obj/structure/shuttle/engine/heater
	name = "heater"
	icon_state = "heater"

/obj/structure/shuttle/engine/platform
	name = "platform"
	icon_state = "platform"

/obj/structure/shuttle/engine/propulsion
	name = "propulsion"
	icon_state = "propulsion"
	opacity = 1

/obj/structure/shuttle/engine/propulsion/burst
	name = "burst"

/obj/structure/shuttle/engine/propulsion/burst/left
	name = "left"
	icon_state = "burst_l"

/obj/structure/shuttle/engine/propulsion/burst/right
	name = "right"
	icon_state = "burst_r"

/obj/structure/shuttle/engine/router
	name = "router"
	icon_state = "router"

/obj/structure/shuttle/falsewall_no_join //For faking the appearance of joinable walls when joinable walls won't behave correctly on specific shuttle tiles.
	name = "shuttle wall"
	icon = 'icons/turf/shuttle_white.dmi'
	icon_state = "light" //Should be switched out as needed
	layer = TURF_LAYER
	density = 1
	anchored = 1
	can_atmos_pass = ATMOS_PASS_NO

/obj/structure/shuttle/falsewall_no_join/window
	name = "shuttle window"
	icon = 'icons/obj/podwindows.dmi'
	icon_state = "0_0"
	opacity = 0
