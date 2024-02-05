var/global/list/_cat_default_emotes = list(
	/decl/emote/visible,
	/decl/emote/visible/scratch,
	/decl/emote/visible/drool,
	/decl/emote/visible/nod,
	/decl/emote/visible/sway,
	/decl/emote/visible/sulk,
	/decl/emote/visible/twitch,
	/decl/emote/visible/twitch_v,
	/decl/emote/visible/dance,
	/decl/emote/visible/roll,
	/decl/emote/visible/shake,
	/decl/emote/visible/jump,
	/decl/emote/visible/shiver,
	/decl/emote/visible/collapse,
	/decl/emote/visible/spin,
	/decl/emote/visible/sidestep,
	/decl/emote/audible,
	/decl/emote/audible/hiss,
	/decl/emote/audible/whimper,
	/decl/emote/audible/gasp,
	/decl/emote/audible/scretch,
	/decl/emote/audible/choke,
	/decl/emote/audible/moan,
	/decl/emote/audible/gnarl,
	/decl/emote/audible/purr,
	/decl/emote/audible/purrlong
)

/mob/living/simple_mob/animal/passive/cat
	name = "cat"
	desc = "A domesticated, feline pet. Has a tendency to adopt crewmembers."
	tt_desc = "E Felis silvestris catus"
	icon_state = "cat2"
	item_state = "cat2"
	icon_living = "cat2"
	icon_dead = "cat2_dead"
	icon_rest = "cat2_rest"

	movement_cooldown = 0.5 SECONDS

	see_in_dark = 6 // Not sure if this actually works.
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"

	holder_type = /obj/item/holder/cat
	mob_size = MOB_SMALL

	has_langs = list("Cat")

	var/mob/living/friend = null // Our best pal, who we'll follow. Meow.
	var/named = FALSE //have I been named yet?

/mob/living/simple_mob/animal/passive/cat/Initialize()
	icon_living = "[initial(icon_state)]"
	icon_dead = "[initial(icon_state)]_dead"
	icon_rest = "[initial(icon_state)]_rest"
	update_icon()
	return ..()

/mob/living/simple_mob/animal/passive/cat/get_available_emotes()
	return global._cat_default_emotes

/mob/living/simple_mob/animal/passive/cat/handle_special()
	if(!stat && prob(2)) // spooky
		var/mob/observer/dead/spook = locate() in range(src, 5)
		if(spook)
			var/turf/T = get_turf(spook)
			var/list/visible = list()
			for(var/obj/O in T.contents)
				if(!O.invisibility && O.name)
					visible += O
			if(visible.len)
				var/atom/A = pick(visible)
				visible_emote("suddenly stops and stares at something unseen[istype(A) ? " near [A]":""].")

// Instakills mice.
/mob/living/simple_mob/animal/passive/cat/apply_melee_effects(var/atom/A)
	if(ismouse(A))
		var/mob/living/simple_mob/animal/passive/mouse/mouse = A
		if(mouse.getMaxHealth() < 20) // In case a badmin makes giant mice or something.
			mouse.splat()
			visible_emote(pick("bites \the [mouse]!", "toys with \the [mouse].", "chomps on \the [mouse]!"))
	else
		..()

/mob/living/simple_mob/animal/passive/cat/IIsAlly(mob/living/L)
	if(L == friend) // Always be pals with our special friend.
		return TRUE

	. = ..()

	if(.) // We're pals, but they might be a dirty mouse...
		if(ismouse(L))
			return FALSE // Cats and mice can never get along.

/mob/living/simple_mob/animal/passive/cat/verb/become_friends()
	set name = "Become Friends"
	set category = "IC"
	set src in view(1)

	var/mob/living/L = usr
	if(!istype(L))
		return // Fuck off ghosts.

	if(friend)
		if(friend == usr)
			to_chat(L, span("notice", "\The [src] is already your friend! Meow!"))
			return
		else
			to_chat(L, span("warning", "\The [src] ignores you."))
			return

	friend = L
	face_atom(L)
	to_chat(L, span("notice", "\The [src] is now your friend! Meow."))
	visible_emote(pick("nuzzles [friend].", "brushes against [friend].", "rubs against [friend].", "purrs."))

	if(has_AI())
		var/datum/ai_holder/AI = ai_holder
		AI.set_follow(friend)


//RUNTIME IS ALIVE! SQUEEEEEEEE~
/mob/living/simple_mob/animal/passive/cat/runtime
	name = "Runtime"
	desc = "Her fur has the look and feel of velvet, and her tail quivers occasionally."
	tt_desc = "E Felis silvestris medicalis" // a hypoallergenic breed produced by NT for... medical purposes? Sure.
	gender = FEMALE
	icon_state = "cat"
	item_state = "cat"
	icon_living = "cat"
	icon_dead = "cat_dead"
	icon_rest = "cat_rest"
	named = TRUE
	holder_type = /obj/item/holder/cat/runtime

/mob/living/simple_mob/animal/passive/cat/kitten
	name = "kitten"
	desc = "D'aaawwww!"
	icon_state = "kitten"
	item_state = "kitten"
	icon_living = "kitten"
	icon_dead = "kitten_dead"
	icon_rest = "kitten_rest"
	gender = NEUTER

/mob/living/simple_mob/animal/passive/cat/kitten/Initialize()
	if(gender == NEUTER)
		gender = pick(MALE, FEMALE)
	return ..()

/mob/living/simple_mob/animal/passive/cat/black
	icon_state = "cat"
	item_state = "cat"

// Leaving this here for now.
/obj/item/holder/cat/fluff/bones
	name = "Bones"
	desc = "It's Bones! Meow."
	gender = MALE
	icon_state = "cat3"

/obj/item/holder/cat/penny

/mob/living/simple_mob/animal/passive/cat/bones
	name = "Bones"
	desc = "That's Bones the cat. He's a laid back, black cat. Meow."
	gender = MALE
	icon_state = "cat3"
	item_state = "cat3"
	icon_living = "cat3"
	icon_dead = "cat3_dead"
	icon_rest = "cat3_rest"
	named = TRUE
	holder_type = /obj/item/holder/cat/fluff/bones

/mob/living/simple_mob/animal/passive/cat/penny
	name = "Penny"
	desc = "An important cat, straight from Central Command."
	named = TRUE
	icon_state = "penny"
	item_state = "penny"
	icon_living = "penny"
	icon_dead = "penny_dead"
	icon_rest = "penny_rest"

/mob/living/simple_mob/animal/passive/cat/crusher
	name = "Crusher"
	desc = "A cream coloured, young, and cuddly cat, with a small tag on her collar that says \"Dr. Crusher\". She never lets an opportunity pass to receive some pets or prey on some unsuspecting mice."
	named = TRUE
	gender = FEMALE
	icon_state = "crusher"
	icon_state = "crusher"
	icon_living = "crusher"
	icon_dead = "crusher_dead"
	icon_rest = "crusher_rest"

/datum/say_list/cat
	speak = list("Meow!","Esp!","Purr!","HSSSSS")
	emote_hear = list("meows","mews")
	emote_see = list("shakes their head", "shivers")
	say_maybe_target = list("Meow?","Mew?","Mao?")
	say_got_target = list("MEOW!","HSSSS!","REEER!")

/mob/living/simple_mob/animal/passive/cat/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		if(named)
			to_chat(user, "<span class='notice'>\the [name] already has a name!</span>")
		else
			var/tmp_name = sanitizeSafe(input(user, "Give \the [name] a name", "Name"), MAX_NAME_LEN)
			if(length(tmp_name) > 50)
				to_chat(user, "<span class='notice'>The name can be at most 50 characters long.</span>")
			else
				to_chat(user, "<span class='notice'>You name \the [name]. Meow!</span>")
				name = tmp_name
				named = TRUE
	else
		..()

/obj/item/cat_box
	name = "faintly purring box"
	desc = "This box is purring faintly. You're pretty sure there's a cat inside it."
	icon = 'icons/obj/storage.dmi'
	icon_state = "box"
	var/cattype = /mob/living/simple_mob/animal/passive/cat

/obj/item/cat_box/attack_self(var/mob/user)
	var/turf/catturf = get_turf(src)
	to_chat(user, "<span class='notice'>You peek into \the [name]-- and a cat jumps out!</span>")
	new cattype(catturf)
	new /obj/item/stack/material/cardboard(catturf) //if i fits i sits
	qdel(src)

/obj/item/cat_box/black
	cattype = /mob/living/simple_mob/animal/passive/cat/black
