/obj/effect/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1

	var/obj/target
	var/ticks = 0

/obj/effect/alien/acid/proc/tick()
	if(!target)
		del(src)
	ticks += 1
	for(var/mob/O in hearers(src, null))
		O.show_message("\green <B>[src.target] sizzles and begins to melt under the bubbling mess of acid!</B>", 1)
	if(prob(ticks*10))
		for(var/mob/O in hearers(src, null))
			O.show_message("\green <B>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</B>", 1)
//		if(target.occupant) //I tried to fix mechas-with-humans-getting-deleted. Made them unacidable for now.
//			target.ex_act(1)
		del(target)
		del(src)
		return
	spawn(rand(200, 400)) tick()