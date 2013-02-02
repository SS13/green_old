/proc/showcredits()
	var/crname
	var/crjob
	var/crckey
	var/dat={"<html>
<body>
<center>
	<font color="white" face="Courier New">
    <marquee behavior="up" bgcolor="black" direction="up" height="800" loop="1" width="1000" scrollamount="1">"}


	var/title=pick("War Of ", "The One In ", "Explosion In ", "The Lord Of The ", "Smell Of ", "Captain Of ", "Alien In ", "Robust ")
	title+=pick("Kitchen", "Brig", "Clown", "Mine", "Toilet", "Coffe", "Toolbox")
	dat += "<center><h1>"
	dat+=title
	dat+="</h1></center><br><br><center><h3> CAST </h3></center><br>"
	for(var/mob/living/carbon/human/H in world)
		if(H.ckey)
			crname = "[H.name]"
			crjob = "[H.get_assignment()]"
			crckey = "[H.ckey]"
			dat += "<center>"
			dat += crname
			dat+=" as "
			dat+=crjob
			var/i=0
			while(i<(60-length(crname)-length(crjob)-length(crckey)))
				dat+= "."
				i++
			dat+=crckey
			dat+="</center><br>"
	dat+="<center>Thanks for watching <br> Stay robust </center>"
	dat+={"</marquee></center>
	</font>
</html>
</body>"}
	for(var/client/C)
		C << browse(dat,"window=credits;size=1040x840")

/*/mob/verb/credittest()
	set category = "Special Verbs"
	set name = "credittest"
	set desc = "creditiest"
	showcredits()*/
