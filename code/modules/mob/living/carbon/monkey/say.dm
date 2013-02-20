/mob/living/carbon/monkey/say_quote(var/text)
	return "[src.say_message], \"[text]\"";

/mob/living/carbon/monkey/say(var/message)

	if (length(message) >= 2)
		if (copytext(message, 1, 3) == ":a")
			message = copytext(message, 3)
			message = trim(copytext(sanitize(message), 1, MAX_MESSAGE_LEN))
			if (stat == 2)
				return say_dead(message)
			else
				alien_talk(message)
		else
			if (copytext(message, 1, 2) != "*" && !stat)
				playsound(loc, "chimpers", 25, 1, 1)//So aliens can hiss while they hiss yo/N
			return ..(message)
