#define NEST_RESIST_TIME 1200

/obj/structure/bed/nest
	name = "alien nest"
	desc = "It's a swirling mass of crystaline material shaped like a nest."
	icon = 'icons/mob/alien.dmi'
	icon_state = "nest"
	var/health = 100

/obj/structure/bed/nest/update_icon()
	return

/obj/structure/bed/nest/user_unbuckle_mob(mob/living/buckled_mob, mob/user)
	if(buckled_mob)
		if(buckled_mob.buckled == src)
			if(buckled_mob != user)
				buckled_mob.visible_message(\
					"<span class='notice'>[user.name] pulls [buckled_mob.name] free from the ensnaring nest!</span>",\
					"<span class='notice'>[user.name] pulls you free from the hooked crystals.</span>",\
					"<span class='notice'>You hear cracking...</span>")
				buckled_mob.pixel_y = 0
				buckled_mob.old_y = 0
				unbuckle_mob(buckled_mob)
			else
				if(world.time <= buckled_mob.last_special+NEST_RESIST_TIME)
					return
				buckled_mob.last_special = world.time
				buckled_mob.visible_message(\
					"<span class='warning'>[buckled_mob.name] struggles to break free of the ensnaring nest...</span>",\
					"<span class='warning'>You struggle to break free from the hooked crystals...</span>",\
					"<span class='notice'>You hear cracking...</span>")
				spawn(NEST_RESIST_TIME)
					if(user && buckled_mob && user.buckled == src)
						buckled_mob.last_special = world.time
						buckled_mob.pixel_y = 0
						buckled_mob.old_y = 0
						unbuckle_mob(buckled_mob)
			src.add_fingerprint(user)
	return

/obj/structure/bed/nest/user_buckle_mob(mob/M as mob, mob/user as mob)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle_mob()

	var/mob/living/carbon/xenos = user
	var/mob/living/carbon/victim = M

	if(istype(victim) && locate(/obj/item/organ/internal/xenos/hivenode) in victim.internal_organs)
		return

	if(istype(xenos) && !(locate(/obj/item/organ/internal/xenos/hivenode) in xenos.internal_organs))
		return

	if(M == usr)
		return
	else
		M.visible_message(\
			"<span class='notice'>[user.name] secretes a rapidly solidifying liquid, securing [M.name] into [src]!</span>",\
			"<span class='warning'>[user.name] coats you in a crystaline substance, trapping you in the [src]!</span>",\
			"<span class='notice'>You hear cracking...</span>")
	M.buckled = src
	M.loc = src.loc
	M.set_dir(src.dir)
	M.update_canmove()
	M.pixel_y = 6
	M.old_y = 6
	src.buckled_mobs |= M
	src.add_fingerprint(user)
	return

/obj/structure/bed/nest/attackby(obj/item/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(src, 'sound/effects/glasshit.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()

/obj/structure/bed/nest/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return