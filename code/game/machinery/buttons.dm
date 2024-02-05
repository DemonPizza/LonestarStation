/obj/machinery/button
	name = "button"
	icon = 'icons/obj/objects.dmi'
	icon_state = "launcherbtt"
	layer = ABOVE_WINDOW_LAYER
	desc = "A remote control switch for something."
	var/id = null
	var/active = 0
	anchored = 1.0
	use_power = USE_POWER_IDLE
	idle_power_usage = 2
	active_power_usage = 4
	required_dexterity = MOB_DEXTERITY_SIMPLE_MACHINES

/obj/machinery/button/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/button/attackby(obj/item/item, mob/user)
	return attack_hand(user)
