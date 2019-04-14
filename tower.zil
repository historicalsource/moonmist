"TOWER for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

[
<ROUTINE TELL-IN-BROCHURE ()
	<TELL "[This is described in the " D ,BROCHURE ".]" CR>>

;<ROUTINE OYSTER-PSEUDO ()
 <COND (<VERB? LOOK-INSIDE OPEN>
	<TELL "It's empty." CR>)
       (<VERB? EXAMINE>
	<TELL-IN-BROCHURE>)>>

<ROUTINE BROCHURE-PSEUDO ()
 <COND (<VERB? EXAMINE>
	<TELL-IN-BROCHURE>)
       (T ;<NOT <REMOTE-VERB?>>
	<RANDOM-PSEUDO>)>>

<OBJECT MEMENTO
	(IN OLD-GREAT-HALL)
	(DESC "memento")
	(ADJECTIVE OIL ART JADE)
	(SYNONYM PAINTING CARVING SKELETON)
	(GENERIC GENERIC-SKELETON)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION MEMENTO-F)>

<OBJECT MEMENTO-2
	(IN OLD-GREAT-HALL)
	(DESC "memento")
	(ADJECTIVE OYSTER PAPIER MACHE ;AMAZON WITCH)
	(SYNONYM SHELL FIGURE INDIAN DOCTOR)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION MEMENTO-F)>

<ROUTINE MEMENTO-F ()
 <COND (<VERB? TAKE>
	<TELL "But that would spoil the display!" CR>)
       (T <BROCHURE-PSEUDO>)>>

<ROOM OLD-GREAT-HALL
	(IN ROOMS)
	(FLAGS ONBIT VOWELBIT SEENBIT DOORBIT LOCKED)
	(DESC "old great hall")
	(ADJECTIVE GREAT OLD TOWER)
	(SYNONYM HALL ROOM DOOR ;DOORS ;"from COURTYARD")
	(GENERIC GENERIC-GREAT-HALL)
	;(LDESC "[E to junction, W to stairs]")
	(LINE 3)
	(STATION OLD-GREAT-HALL)
	(CHARACTER 2)
	(GLOBAL OLD-GREAT-HALL FIREPLACE CHAIR WINDOW STAIRS)
	(NE	TO COURTYARD ;ANTE-ROOM IF OLD-GREAT-HALL IS OPEN)
	(NORTH	TO COURTYARD ;ANTE-ROOM IF OLD-GREAT-HALL IS OPEN)
	(OUT	TO COURTYARD ;ANTE-ROOM IF OLD-GREAT-HALL IS OPEN)
	(EAST	TO JUNCTION)
	(IN	TO JUNCTION)
	(WEST	TO CORR-2 ;STAIRS-1)
	(UP	TO CORR-2 ;STAIRS-1)
	(ACTION OLD-GREAT-HALL-F)>

<ROUTINE OLD-GREAT-HALL-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL "Your footfalls echo across the ancient stone floor." CR>
	<RTRUE>)
       (<EQUAL? .RARG ,P?WEST ,P?UP>
	<TELL ,STAIRS-UP-RIGHT>
	<RTRUE>)
       (<T? .RARG>
	<RFALSE>)
       (<NOUN-USED? ,W?DOOR>
	<COND (<AND <VERB? UNLOCK> <==? ,HERE ,OLD-GREAT-HALL>>
	       <OKAY ,PRSO "unlocked">)
	      (<VERB? EXAMINE>
	       <CHECK-DOOR ,PRSO>
	       ;<NOTHING-SPECIAL>)>)>>

<GLOBAL STAIRS-UP-RIGHT "The stairs curve up to the right.|">
<GLOBAL STAIRS-DOWN-LEFT "The stairs curve down to the left.|">
]
<ROOM JUNCTION
	(IN ROOMS)
	(FLAGS ONBIT)
	(DESC "junction")
	(SYNONYM JUNCTION ;ROOM)
	;(LDESC "[W to old great hall, E to corridor, D to stairs]")
	(LINE 3)
	(STATION JUNCTION)
	(CHARACTER 2)
	(CORRIDOR 1)
	(GLOBAL STAIRS)
	(WEST	TO OLD-GREAT-HALL)
	(OUT	TO OLD-GREAT-HALL)
	(EAST	TO CORR-1)
	(IN	TO CORR-1)
	(NORTH	TO BASEMENT ;STAIRS-0)
	(DOWN	TO BASEMENT ;STAIRS-0)
	(ACTION JUNCTION-F)>

<ROUTINE JUNCTION-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The two halves of " 'CASTLE " meet here, as the past meets the present." CR>
	<RTRUE>)
       (<EQUAL? .RARG ,P?NORTH ,P?DOWN>
	<TELL ,STAIRS-DOWN-LEFT>
	<RTRUE>)>>
[
<ROOM BASEMENT
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT)
	(DESC "basement")
	(ADJECTIVE TOWER)
	(SYNONYM BASEMENT ;ROOM)
	(GLOBAL HOLE-IN-WALL STAIRS)
	(LINE 3)
	(STATION BASEMENT)
	(CHARACTER 1)
	(EAST	TO KITCHEN)
	(WEST	TO DUNGEON)
	(IN	PER BASEMENT-ENTER)
	(NORTH	TO JUNCTION ;STAIRS-0)
	(UP	TO JUNCTION ;STAIRS-0)
	(THINGS <PSEUDO ;"( BRICK OVEN	RANDOM-PSEUDO)
			( GRAIN BIN	RANDOM-PSEUDO)
			( ARMOR FORGE	RANDOM-PSEUDO)
			( ARMOR SMITHY	RANDOM-PSEUDO)"
			( <> ;EXPEDI GEAR	RANDOM-PSEUDO)>)
	(ACTION BASEMENT-F)>

<ROUTINE BASEMENT-ENTER () <COND (<T? ,BRICKS-DOWN> ,CRYPT) (T ,DUNGEON)>>

<ROUTINE BASEMENT-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The " 'BASEMENT " of the tower keep still holds traces of the
medieval past -- such as an " 'WELL ;", a brick oven, a grain bin, and
the remains of an armourer's forge and smithy" ". The "
'BASEMENT " now stores both Lionel's
expedition gear and the castle wine cellar">
	<COND (<EQUAL? ,VARIATION ,PAINTER-C ;,FRIEND-C>
	       <TELL " (a rack full of wine bottles)">)>
	<TELL ".|
The brick walls are damp and mossy">
	<COND (<AND <EQUAL? ,VARIATION ,FRIEND-C>
		    <FSET? ,CLUE-4 ,TOUCHBIT>>
	       <TELL ", and some bricks look loose">)>
	<TELL ". A stairway lies north, and doors lead east and west." CR>
	<RTRUE>)
       (<EQUAL? .RARG ,P?NORTH ,P?UP>
	<TELL ,STAIRS-UP-RIGHT>
	<RTRUE>)>>

<OBJECT WINE-RACK
	(IN BASEMENT)
	(DESC "wine rack")
	(ADJECTIVE WINE)
	(SYNONYM RACK CELLAR WINE)
	(GENERIC GENERIC-WINE)
	(FLAGS CONTBIT OPENBIT TRYTAKEBIT NDESCBIT SEENBIT
		TOUCHBIT ;"so GO TO works")
	(CAPACITY 99)
	(ACTION WINE-RACK-F)>

<ROUTINE WINE-RACK-F ("AUX" X)
	<FCLEAR ,WINE-RACK ,NDESCBIT>
	<COND (<VERB? TAKE>
	       <COND (<AND <IN? ,BOTTLE ,WINE-RACK>
			   <NOUN-USED? ,W?WINE>>
		      <PERFORM ,PRSA ,BOTTLE>
		      <RTRUE>)>)
	      (<VERB? EXAMINE LOOK-INSIDE>
	       <COND ;(<AND <IN? ,BOTTLE ,WINE-RACK>
			   <IN? ,MOONMIST ,BOTTLE>
			   <FSET? ,BOTTLE ,NDESCBIT>>
		      <FCLEAR ,BOTTLE ,NDESCBIT>
		      <MOVE ,BOTTLE ,WINNER>
		      <TELL
CHE ,WINNER notice " that one bottle looks odd. When" HE ,WINNER
take " it out," HE ,WINNER notice " that the wax seal looks quite new." CR>)
		     (T
		      <TELL-AS-WELL-AS ,WINE-RACK " an assortment of wine">
		      <RTRUE>)>)>>

<OBJECT BOTTLE
	(IN WINE-RACK)
	(DESC "bottle")
	(ADJECTIVE WINE)	;"(a rack full of wine bottles)"
	(SYNONYM BOTTLE WINE ;LABEL)	;"REMOVE LABEL"
	(GENERIC GENERIC-WINE)
	(FLAGS NDESCBIT TAKEBIT CONTBIT TRANSBIT ;OPENBIT READBIT WEAPONBIT)
	(SIZE 5)
	(CAPACITY 3)
	(ACTION BOTTLE-F)>

<ROUTINE BOTTLE-F ()
 <COND ;(<AND <VERB? EXAMINE LOOK-INSIDE SEARCH SEARCH-FOR>
	     <IN? ,MOONMIST ,BOTTLE>
	     <FSET? ,MOONMIST ,SECRETBIT>>
	<DISCOVER ,MOONMIST ,BOTTLE>
	<RTRUE>)	;"Moonmist hidden here"
       (<VERB? EXAMINE LOOK-INSIDE READ SEARCH SEARCH-FOR ;SHAKE>
	<COND (<NOT-HOLDING? ,BOTTLE>
	       <RTRUE>)>
	<TELL
"The label says it's wine from a Cornish winery called Our Own Vintage.">
	<COND (<EQUAL? ,VARIATION ,PAINTER-C ;,FRIEND-C>
	       <TELL
" Someone has drawn a star in red ink over the word \"OUR.\"">)>
	<CRLF>)
       (<VERB? DRINK EAT EMPTY MUNG OPEN SHAKE>
	<COND (<DOBJ? BOTTLE>
	       <TELL
"You instantly realize that you don't need any wine -- or any more, as the case
may be." CR>)>)
       (<OR <VERB? FILL>
	    <AND <VERB? PUT-IN> <IOBJ? BOTTLE>>>
	<TOO-BAD-BUT ,BOTTLE "closed">)
       (<ATTACK-VERB?>
	<NO-VIOLENCE? ,BOTTLE>
	<RTRUE>)>>

<OBJECT BRICKS
	;(IN BASEMENT)
	(DESC "bunch of loose bricks")
	(ADJECTIVE LOOSE)
	(SYNONYM BUNCH BRICKS BRICK)
	(FLAGS NDESCBIT)
	(DESCFCN BRICKS-D)
	(ACTION BRICKS-F)>

<GLOBAL BRICKS-DOWN:FLAG <>>

<ROUTINE BRICKS-D ("OPT" X)
	<TELL "There's a " 'BRICKS>
	<COND (<T? ,BRICKS-DOWN>
	       <TELL !\  <GROUND-DESC> ", and a hole" ;'HOLE-IN-WALL>)>
	<TELL " in the wall." CR>>

<ROUTINE BRICKS-F ()
 <COND (<VERB? ;DIG EXAMINE KNOCK RUB SEARCH>
	<COND (T ;<FSET? ,BRICKS ,NDESCBIT>
	       <FCLEAR ,BRICKS ,NDESCBIT>
	       <FSET ,BRICKS ,SEENBIT>
	       ;<TELL "You discover a " 'BRICKS " in the wall." CR>)>
	<BRICKS-D>)
       (<VERB? MOVE MOVE-DIR MUNG OPEN PUSH SLAP TAKE TURN>
	<COND (<AND <EQUAL? ,VARIATION ,FRIEND-C>
		    <ZERO? ,BRICKS-DOWN>>
	       <FCLEAR ,BRICKS ,NDESCBIT>
	       <SETG BRICKS-DOWN T>
	       <FCLEAR ,HOLE-IN-WALL ,INVISIBLE>
	       <TELL
"You manage to pull them down into a pile " <GROUND-DESC> ", making a large
hole in the wall." CR>)>)>>

<OBJECT HOLE-IN-WALL
	(IN LOCAL-GLOBALS)
	(DESC "brick hole")
	(ADJECTIVE SECRET BRICK)
	(SYNONYM HOLE OPENING WALL)
	(FLAGS INVISIBLE DOORBIT ;NDESCBIT OPENBIT SEENBIT)
	(ACTION HOLE-IN-WALL-F)>

<ROUTINE HOLE-IN-WALL-F ("AUX" RM)
 <COND (<VERB? CLOSE>
	<YOU-CANT>)
       (<VERB? EXAMINE LOOK-INSIDE LOOK-THROUGH>
	<COND (<==? ,HERE ,BASEMENT>
	       <TELL
"Through the dusty air, you can see only dark inside. But the hole looks
big enough to climb through." CR>)
	      (T <ROOM-PEEK ,BASEMENT T>)>
	<RTRUE>)
       (<VERB? BOARD DISEMBARK THROUGH>
	<COND (<==? ,HERE ,BASEMENT>
	       <SET RM ,CRYPT>)
	      (T <SET RM ,BASEMENT>)>
	<COND (<GOTO .RM>
	       <OKAY>)>
	<RTRUE>)>>

<OBJECT WELL
	(IN BASEMENT)
	(DESC "ancient well")
	(ADJECTIVE OLD ANCIENT)
	(SYNONYM WELL WELLSHAFT)
	(GENERIC GENERIC-WELL)
	(FLAGS CONTBIT OPENBIT VOWELBIT NDESCBIT SEENBIT)
	(CAPACITY 99)
	;(TEXT
"This ancient well was made at the time the castle was built.
It is about a yard wide and surrounded by decrepit brickwork
a couple of feet high.")
	(ACTION WELL-F)>

<ROUTINE WELL-F ()
	 <COND (<VERB? EXAMINE LOOK-DOWN LOOK-INSIDE SEARCH SEARCH-FOR>
		<COND ;(<AND <IN? ,CLUE-4 ,WELL>
			    <FSET? ,CLUE-4 ,SECRETBIT>>
		       <DISCOVER ,CLUE-4 ,WELL>
		       <RTRUE>)
		      (T <TELL "It's deep and dark." CR>)>)
	       (<VERB? OPEN CLOSE>
		<YOU-CANT>)
	       (<VERB? BOARD CLIMB-DOWN THROUGH>
		<TELL
"After a moment's thought, you remember " 'LOVER "'s fate and
decide that's much too dangerous." CR>)
	       (<VERB? PUT PUT-IN>
		<COND (<IOBJ? WELL>
		       <TELL
"As you watch," THE ,PRSO " disappears into the dark well shaft. After a
second or two, you hear a remote splash.|">
		       <REMOVE-CAREFULLY ,PRSO>
		       <RTRUE>)>)>>
][
<ROOM CRYPT
	(IN ROOMS)
	(FLAGS SECRETBIT ;ONBIT)
	(DESC "secret crypt")
	(ADJECTIVE SECRET)
	(SYNONYM CRYPT ;HOLE ;ROOM)
	;(GENERIC GENERIC-HOLE)
	(GLOBAL HOLE-IN-WALL)
	(LINE 3)
	(STATION BASEMENT)
	(CHARACTER 1)
	(OUT	TO BASEMENT)
	(ACTION CRYPT-F)>

<ROUTINE CRYPT-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"This space at the bottom of the tower is so gloomy and musty that
you should be glad there's an exit to the " 'BASEMENT "." CR>)
       ;(<AND <==? .RARG ,M-BEG>
	     <IN? ,SKULL ,CRYPT>
	     <FSET? ,SKULL ,SECRETBIT>>
	<DISCOVER ,SKULL ,CRYPT>
	<RTRUE>)>>

<OBJECT SKELETON
	(IN CRYPT)
	(DESC "skeleton")
	(ADJECTIVE OLD ;MOULDERING)
	(SYNONYM BONES SKELETON)
	(GENERIC GENERIC-SKELETON)
	(FLAGS SURFACEBIT OPENBIT SEARCHBIT)
	(SIZE 90)
	(ACTION SKELETON-F)>

<ROUTINE SKELETON-F ()
 <COND (<OR <VERB? EXAMINE LOOK-UNDER SEARCH SEARCH-FOR>
	    ;<VERB? MOVE MOVE-DIR PUSH TAKE>>
	<COND (<AND <IN? ,NECKLACE ,SKELETON>
		    <FSET? ,NECKLACE ,SECRETBIT>
		    <VERB? EXAMINE SEARCH SEARCH-FOR>>
	       <DISCOVER ,NECKLACE ,SKELETON>
	       <RTRUE>)
	      (T <TELL "Just old bones moldering in the dark."
		       ;", that's all." CR>)>)>>
][
<OBJECT PRIEST-DOOR
	(IN LOCAL-GLOBALS ;ROOMS)
	(DESC "priest hole")
	(ADJECTIVE PRIEST)
	(SYNONYM DOOR HOLE)
	(FLAGS DOORBIT SEENBIT)>

<ROOM DUNGEON
	(IN ROOMS)
	(FLAGS ;ONBIT)
	(DESC "dungeon")
	(SYNONYM DUNGEON ;ROOM)
	(GLOBAL ;DUNGEON PRIEST-DOOR LEVER)
	(LINE 3)
	(STATION DUNGEON)
	(CHARACTER 1)
	(EAST	TO BASEMENT)
	(OUT	TO BASEMENT)
	(NW	TO LOVER-PATH IF ;DUNGEON PRIEST-DOOR IS OPEN)
	(NORTH	TO LOVER-PATH IF ;DUNGEON PRIEST-DOOR IS OPEN)
	(WEST	TO LOVER-PATH IF ;DUNGEON PRIEST-DOOR IS OPEN)
	(ACTION DUNGEON-F)>

<ROUTINE DUNGEON-F ("OPTIONAL" (ARG 0))
 <COND (<==? .ARG ,M-LOOK>
	<TELL
"In the northwest corner is an ancient door called
a \"" 'PRIEST-DOOR ".\" Another exit is east to the " 'BASEMENT "." CR>)>>

<OBJECT IRON-MAIDEN
	(IN DUNGEON)
	(DESC "iron maiden")
	(ADJECTIVE IRON)
	(SYNONYM MAIDEN SPACE SPIKE SPIKES)
	(FLAGS VOWELBIT CONTBIT OPENBIT)
	(ACTION IRON-MAIDEN-F)>

<ROUTINE IRON-MAIDEN-F ("AUX" X)
 <COND (<VERB? CLOSE OPEN>
	<TELL "It has no door!" CR>
	;<OKAY ,IRON-MAIDEN "closed">)
       (<VERB? EXAMINE LOOK-INSIDE>
	<TELL
"The inner surface of this medieval torture device is covered with spikes.
The space is just big enough to hold an unfortunate victim." CR>)
       ;(<VERB? OPEN>
	<OKAY ,IRON-MAIDEN "open">)
       (<VERB? PUT-IN>
	<WONT-HELP>)
       (<VERB? KISS RUB>
	<TELL "Ouch!" CR>)
       (<VERB? BOARD CLIMB-ON THROUGH>
	<COND (<NOT <==? ,WINNER ,PLAYER>>
	       <TELL "\"No thank you!\"" CR>
	       <RTRUE>)>
	<TELL "As you step on the bottom of the " D ,IRON-MAIDEN ", it ">
	<COND (<EQUAL? ,HERE ,DUNGEON>
	       <SET X ,TOMB>
	       <TELL "sinks downward into">)
	      (T ;<EQUAL? ,HERE ,TOMB>
	       <SET X ,DUNGEON>
	       <TELL "rises again to">)>
	<TELL THE .X ". You step out again.|">
	<MOVE ,IRON-MAIDEN .X>
	<GOTO .X>
	<RTRUE>)>>
][
<ROOM TOMB
	(IN ROOMS)
	(FLAGS ;ONBIT)
	(DESC "secret tomb")
	(ADJECTIVE SECRET ;UNDERGROUND)
	(SYNONYM TOMB)
	(UP	"That's not the way to go up from here.")
	(DOWN	"That's not the way to go up from here.")>

<OBJECT COFFIN
	(IN TOMB)
	(DESC "stone coffin")
	(ADJECTIVE STONE)
	(SYNONYM COFFIN)
	(FLAGS CONTBIT ;OPENBIT VEHBIT)
	(CAPACITY 99)
	(ACTION COFFIN-F)>

<ROUTINE COFFIN-F () ;("OPT" (ARG 0))
 <COND ;(<T? .ARG> <RFALSE>)
       (<VERB? BOARD LIE SIT>
	<COND (<NOT <FSET? ,COFFIN ,OPENBIT>>
	       <FIRST-YOU "open" ,COFFIN>)>
	;<TELL "There's barely enough room next to the scratchy old bones." CR>
	<RFALSE>)
       (<VERB? CLOSE>
	<COND (<IN? ,PLAYER ,COFFIN>
	       ;<EQUAL? ,PLAYER-SEATED ,COFFIN <- 0 ,COFFIN>>
	       <TELL "The air is stifling, so you open it again." CR>)>)
       (<VERB? EXAMINE LOOK-INSIDE SEARCH SEARCH-FOR>
	<COND (<AND <IN? ,CLUE-4 ,COFFIN>
		    <FSET? ,CLUE-4 ,SECRETBIT>>
	       <COND (<NOT <FSET? ,COFFIN ,OPENBIT>>
		      <FIRST-YOU "open" ,COFFIN>)>
	       <DISCOVER ,CLUE-4 ,COFFIN>
	       <RTRUE>)
	      (<IN? ,PLAYER ,COFFIN>
	       ;<EQUAL? ,PLAYER-SEATED ,COFFIN <- 0 ,COFFIN>>
	       <TELL "All you can see is " 'PLAYER "." CR>)>)>>
]
<ROOM LOVER-PATH
	(IN ROOMS)
	(FLAGS ONBIT SURFACEBIT OPENBIT)
	(DESC "path")
	(ADJECTIVE ;"LOVER DEIRDRE" DEE\'S HER)
	(SYNONYM PATH)
	(LINE 3)
	(STATION LOVER-PATH)
	(CHARACTER 1)
	(GLOBAL PRIEST-DOOR LEVER MOON OCEAN STAIRS)
	(SE	TO DUNGEON IF PRIEST-DOOR IS OPEN)
	(SOUTH	TO DUNGEON IF PRIEST-DOOR IS OPEN)
	(EAST	TO DUNGEON IF PRIEST-DOOR IS OPEN)
	(IN	TO DUNGEON IF PRIEST-DOOR IS OPEN)
	(NORTH	PER LOVER-PATH-LOSE-N)
	;(WEST	PER LOVER-PATH-LOSE-W)
	;(DOWN	PER LOVER-PATH-LOSE-W)
	(ACTION LOVER-PATH-F)>

<ROUTINE LOVER-PATH-LOSE-N ()
	<LOVER-PATH-LOSE ,P?NORTH>
	<RFALSE>>

;<ROUTINE LOVER-PATH-LOSE-W ()
	<LOVER-PATH-LOSE ,P?WEST>
	<RFALSE>>

<ROUTINE LOVER-PATH-LOSE (X)
	<TELL CHE ,WINNER start>
	<COND (T ;<==? .X ,P?NORTH>
	       <TELL
" to follow the path, but it's too tricky in the dim light">)
	      ;(T <TELL
" down the steps, but they are too slippery in the mist">)>
	<TELL ", so" HE ,WINNER turn " back." CR>>

<ROUTINE LOVER-PATH-F ("OPTIONAL" (RARG <>))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"This is an area behind shrubbery by a steep cliff overlooking the sea. In the
dim light, you can barely see a path leading north along the cliff. "
;" both stone steps leading down and [SE/IN to dungeon]">
	<LEVER-AND-DOOR ,PRIEST-DOOR ,P?OUT>
	<RTRUE>)
       (<T? .RARG>
	<RFALSE>)
       (<VERB? FOLLOW>
	<DO-WALK ,P?NORTH>
	<RTRUE>)>>

<ROOM LIMBO
	(IN ROOMS)
	(FLAGS ;ONBIT NARTICLEBIT)
	(DESC "limbo")
	;(LDESC "[S to path]")
	(LINE 3)
	(STATION LOVER-PATH)
	(SOUTH	TO LOVER-PATH)>

<ROOM CORR-2
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT)
	(DESC "first-floor corridor")
	(ADJECTIVE FIRST)
	(SYNONYM CORRIDOR ROOM)
	(LINE 3)
	(STATION CORR-2)
	(CHARACTER 3)
	(GLOBAL JACK-ROOM ;JACK-DOOR STUDY ;STUDY-DOOR LIBRARY ;LIBRARY-DOOR
		OFFICE ;OFFICE-DOOR TAMARA-ROOM ;TAMARA-DOOR STAIRS)
	(WEST	TO JACK-ROOM IF JACK-ROOM ;JACK-DOOR IS OPEN)
	(NW	TO STUDY IF STUDY ;STUDY-DOOR IS OPEN)
	(NORTH	TO OLD-GREAT-HALL ;STAIRS-1)
	(DOWN	TO OLD-GREAT-HALL ;STAIRS-1)
	(OUT	TO OLD-GREAT-HALL ;STAIRS-1)
	(NE	TO LIBRARY IF LIBRARY ;LIBRARY-DOOR IS OPEN)
	(EAST	TO OFFICE IF OFFICE ;OFFICE-DOOR IS OPEN)
	(SE	TO TAMARA-ROOM IF TAMARA-ROOM ;TAMARA-DOOR IS OPEN)
	(SOUTH	TO CORR-3 ;STAIRS-2)
	(UP	TO CORR-3 ;STAIRS-2)
	(IN "Which direction do you want to go in?")
	(ACTION CORR-2-F)>

<ROUTINE CORR-2-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The " 'CORR-2 " is lined with doors. To the west, a heavy oak door with
ancient wrought-iron fittings b">
	<COND (<FSET? ,CREST ,NDESCBIT>
	       <TELL "ears">)
	      (T <TELL "ore">)>
	<TELL " a bronze bas-relief of the
" ,TRESYLLIAN !\  'CREST ", marking this as the " 'JACK-ROOM " of the
castle. Other doors lead to the northwest, east, northeast, and
southeast. Stairways go up at the south end and down at the north end."
;"[W to Jack's room, NW to study, N/D to stair, NE to library, E to office, SE to Tamara's room, S/U to stair]" CR>
	<RTRUE>)
       (<EQUAL? .RARG ,P?NORTH ,P?DOWN ,P?OUT>
	<TELL ,STAIRS-DOWN-LEFT>
	<RTRUE>)
       (<EQUAL? .RARG ,P?SOUTH ,P?UP>
	<TELL ,STAIRS-UP-RIGHT>
	<RTRUE>)>>

<OBJECT CREST
	(IN CORR-2)
	(DESC "family crest")
	(ADJECTIVE BRONZE TRESYLLIAN FAMILY)
	(SYNONYM CREST WYVERN BAS-RELIEF)
	(FLAGS TRYTAKEBIT NDESCBIT SEENBIT ;READBIT)
	(ACTION CREST-F)>

<ROUTINE CREST-F ()
 <COND (<VERB? EXAMINE READ SEARCH>
	<TELL "The " 'CREST " features a wyvern with wings raised.">
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <TELL " It seems to be loosely mounted on the door.">)>
	<CRLF>)
       (<EQUAL? ,VARIATION ,LORD-C>
	<COND (<AND <VERB? LOOK-BEHIND LOOK-UNDER MOVE MOVE-DIR
			   REMOVE TAKE TAKE-OFF>
		    <NOT <IN? ,JACK-TAPE ,HERE>>>
	       <MOVE ,JACK-TAPE ,HERE>
	       ;<FSET ,JACK-TAPE ,SEENBIT>
	       ;<MOVE ,CREST ,HERE>
	       <FSET ,CREST ,TAKEBIT>
	       <FCLEAR ,CREST ,NDESCBIT>
	       <TELL
"By removing the " 'CREST " from its place, you can see that a small
" 'JACK-TAPE " is built into the door." CR>)
	      (<AND <VERB? PUT>
		    <IOBJ? JACK-ROOM JACK-TAPE>
		    <IN? ,JACK-TAPE ,HERE>>
	       <MOVE ,JACK-TAPE ,LOCAL-GLOBALS>
	       ;<MOVE ,CREST ,HERE>
	       ;<FCLEAR ,CREST ,TAKEBIT>
	       <FSET ,CREST ,NDESCBIT>
	       <TELL
"The " 'CREST " fits neatly over the " 'JACK-TAPE "." CR>)>)>>
[
<OBJECT SECRET-JACK-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET PASSAGE JACK\'S HIS)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)>

<ROUTINE TV-PSEUDO ()
 <COND (<VERB? EXAMINE LAMP-ON LOOK-INSIDE>
	<TELL "It's boring compared to this mystery." CR>)
       (<VERB? LAMP-OFF>
	<ALREADY ,PRSO "off">)>>

<ROOM JACK-ROOM
	(IN ROOMS)
	(FLAGS ONBIT OPENBIT DOORBIT WORNBIT ;READBIT)
	(DESC "master bedroom")
	(ADJECTIVE JACK\'S HIS BED BEDROOM ;" LORD HEAVY OAK ROOM" MASTER WEST)
	(SYNONYM BEDROOM ROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 3)
	(STATION CORR-2)
	(CHARACTER 3)
	(GLOBAL JACK-ROOM SECRET-JACK-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG WINDOW)
	(THINGS <PSEUDO ( JACK\'S BED	BED-PSEUDO)
			( HIS BED	BED-PSEUDO)
			( COLOR TV	TV-PSEUDO)
			( COLOR TELEVI	TV-PSEUDO)
			( OVERST CHAIR	RANDOM-PSEUDO)>)
	(EAST	TO CORR-2 IF JACK-ROOM ;JACK-DOOR IS OPEN)
	(OUT	TO CORR-2 IF JACK-ROOM ;JACK-DOOR IS OPEN)
	(SW	TO SECRET-LANDING-JACK IF SECRET-JACK-DOOR IS OPEN)
	(IN	TO SECRET-LANDING-JACK IF SECRET-JACK-DOOR IS OPEN)
	(DOWN	TO SECRET-LANDING-JACK IF SECRET-JACK-DOOR IS OPEN)
	(ACTION JACK-ROOM-F)>

<ROUTINE JACK-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<COND ;(<AND <VERB? SEARCH SEARCH-FOR>
		    <WAR-CLUB-HACK <>>>
	       <CRLF>
	       <RTRUE>)
	      (<SECRET-CHECK .RARG>
	       <RTRUE>)>)
       (<EQUAL? .RARG ,P?SW ,P?IN ,P?DOWN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The " 'JACK-ROOM " has a canopied four-poster bed on a circular dais,
a marble-topped console and mirror, two oversized " 'WARDROBE "s, cheval glass,
tallboy, commode, overstuffed chair and color TV." ;" A large
window is curtained with a heavy damask material.">
	<OPEN-DOOR? ,SECRET-JACK-DOOR>
	<CRLF>)
       (<T? .RARG>
	<RFALSE>)
       (<AND <VERB? EXAMINE READ SEARCH>
	     <OR <EQUAL? ,HERE ,CORR-2>
		 ;<AND <EQUAL? ,HERE ,JACK-ROOM>
		      <FSET? ,JACK-ROOM ,OPENBIT>>>
	     <FSET? ,CREST ,NDESCBIT>>
	<PERFORM ,PRSA ,CREST ,PRSI>
	<RTRUE>)>>

<ROUTINE NOT-FOUND (OBJ "AUX" (WT <>))
	<COND (<VERB? WALK-TO>
	       <SET WT T>)>
	<COND (<ZERO? .WT>
	       <SETG CLOCK-WAIT T>
	       <TELL "(Y">)
	      (T <TELL "But y">)>
	<TELL "ou haven't found" HIM .OBJ " yet!">
	<COND (<ZERO? .WT>
	       <TELL !\)>)>
	<CRLF>
	<RTRUE>>

<ROUTINE FREE-VERB? ()
	<COND (<GAME-VERB?>
	       <RTRUE>)
	      (<DIVESTMENT? ,PRSO>
	       <RTRUE>)
	      (<VERB? ATTACK CHASTISE EXAMINE HELLO INVENTORY KILL LIE
		      LOOK LOOK-DOWN LOOK-INSIDE LOOK-ON
		      LOOK-OUTSIDE LOOK-THROUGH LOOK-UP
		      NO PUSH READ SHOOT SHOW SSHOW SIT SLAP SORRY
		      WAIT-FOR WAIT-UNTIL YELL YES>
	       <RTRUE>)
	      ;(<SPEAKING-VERB?>
	       <RTRUE>)>>

<ROUTINE SECRET-CHECK ("OPTIONAL" (RARG <>) "AUX" (OBJ <>) (PER <>) RM GT)
 <COND (<EQUAL? ,DISCOVERED-HERE ,HERE>
	<SET PER <GET ,CHARACTER-TABLE <- <ZMEMQ ,HERE ,CHAR-ROOM-TABLE> 1>>>
	<COND (<OR <FSET? .PER ,MUNGBIT>
		   <==? .PER ,CONFESSED>
		   <NOT <==? <META-LOC .PER> ,HERE>>>
	       <SET PER <>>)>)>
 <COND (<EQUAL? .RARG ,M-BEG>
	<COND (<OR <VERB? WALK>		;"handled at M-EXIT"
		   <AND <VERB? WALK-TO FOLLOW THROUGH>
			<NOT <==? ,HERE <META-LOC ,PRSO>>>>>
	       <RFALSE>)
	      (<AND <T? .PER>
		    <OR <T? <GETP .PER ,P?LINE>>
			<VERB? SEARCH SEARCH-FOR>>
		    <NOT <EQUAL? .PER ,PRSO ,PRSI>>
		    <NOT <FREE-VERB?>>>
	       <TELL CTHE .PER " prevents" HIS ,WINNER " action!" CR>
	       <RTRUE>)>)
       (<AND <EQUAL? .RARG ,M-EXIT>
	     <T? .PER>
	     ;<T? <GETP .PER ,P?LINE>>>
	<SET RM <GENERIC-CLOSET 0>>
	<SET GT <GT-O .PER>>
	<COND (<VERB? WALK> <SET OBJ ,PRSO>)
	      (<VERB? WALK-TO FOLLOW THROUGH>
	       <SET OBJ <META-LOC ,PRSO>>
	       <COND (<OR <EQUAL? .OBJ ,HERE>
			  <AND <EQUAL? .OBJ ,LOCAL-GLOBALS>
			       <NOT <FSET? ,PRSO ,DOORBIT>>>>
		      <RFALSE>)
		     (<VERB? THROUGH ;WALK-TO>
		      <COND (<EQUAL? .OBJ ;,PRSO .RM ,LOCAL-GLOBALS>
			     <ESTABLISH-GOAL .PER <GET .GT ,GOAL-F>>
			     <SETG DISCOVERED-HERE <>>
			     <RFALSE>)>
		      <SET OBJ ,P?OUT>
		      ;<SET OBJ <FOLLOW-GOAL-DIR ,HERE .OBJ>>)
		     (T <SET OBJ <DIR-FROM ,HERE .OBJ>>)>)>
	<COND (<AND <DIR-EQV? ,HERE .OBJ ,P?OUT>
		    <T? <GETP .PER ,P?LINE>>
		    ;<T? .PER>>
	       <TELL CHE .PER " blocks" HIS ,WINNER " exit!" CR>
	       <RTRUE>)>
	<COND (<==? .PER ,GHOST-NEW>
	       <MOVE ;-PERSON .PER .RM>)>	;"Back to the Passage"
	<ESTABLISH-GOAL .PER <GET .GT ,GOAL-F>>
	;<PUT .GT ,GOAL-ENABLE 1>
	<SETG DISCOVERED-HERE <>>
	<RFALSE>)>>

<OBJECT TELESCOPE
	(IN JACK-ROOM)
	(DESC "telescope")
	(SYNONYM TELESCOPE SCOPE)
	(LDESC
"There's a telescope mounted on a swinging wall bracket near a small
uncurtained window.")
	(FLAGS TRYTAKEBIT)
	(ACTION TELESCOPE-F)>

<ROUTINE OPEN-SECRET (ACT OBJ DR)
	<TELL "As">
	<HE-SHE-IT ,WINNER <> .ACT>
	<COND (<ZERO? .ACT>
	       <TELL !\ >
	       <VERB-PRINT>)>
	<COND (<AND <G? .OBJ 0> <L? .OBJ 256>>
	       <TELL THE .OBJ>
	       <FCLEAR .OBJ ,SECRETBIT>)
	      (T <PRINT .OBJ>)>
	<TELL !\,>
	<COND (<NOT <FSET? .DR ,TOUCHBIT>>
	       <FSET .DR ,TOUCHBIT>
	       ;<THIS-IS-IT .DR>
	       <COND (T ;<ZERO? <GET ,FOUND-PASSAGES ,PLAYER-C>>
		      <QUEUE I-FOUND-PASSAGES 1>)>
	       <COND (<T? <SET ACT <GENERIC-CLOSET 0>>>
		      <PUT ,FOUND-PASSAGES ,PLAYER-C .ACT>)
		     (T <PUT ,FOUND-PASSAGES ,PLAYER-C T>)>
	       <FSET ,PASSAGE ,SEENBIT>
	       <COND (<==? .OBJ ,HISTORY-BOOK>
		      <FSET ,HISTORY-BOOK ,TAKEBIT>
		      <FCLEAR ,HISTORY-BOOK ,TRYTAKEBIT>
		      <TELL THE ,BOOKCASE>)
		     (T
		      <TELL " a section of the ">
		      <COND (<==? .OBJ ,WYVERN>
			     <TELL 'WYVERN>)
			    (T <TELL "wall">)>)>)
	      (T <TELL THE .DR ;"the secret door">)>
	<OPEN-CLOSE .DR <>>>

<ROUTINE TELESCOPE-F ()
 <COND (<VERB? LOOK-INSIDE LOOK-THROUGH>
	<TELL "All you can see is the wall." CR>)
       (<VERB? AIM MOVE MOVE-DIR PUSH TAKE TURN>
	<OPEN-SECRET "swing" ,TELESCOPE ,SECRET-JACK-DOOR>)>>
]
<ROOM STUDY
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT OPENBIT DOORBIT)
	(DESC "study")
	(ADJECTIVE JACK\'S HIS STUDY NW)
	(SYNONYM STUDY DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LDESC
"Lord Jack's private study has rich mahogany furniture and hunting
prints on the walls."
;"[SE to corridor] office furniture and")
	(LINE 3)
	(STATION CORR-2)
	(CHARACTER 3)
	(GLOBAL STUDY FIREPLACE CHAIR TABLE-RANDOM)
	(THINGS <PSEUDO ( HUNTING PRINT		RANDOM-PSEUDO)
			( HUNTING PRINTS	RANDOM-PSEUDO)>)
	(SE	TO CORR-2 IF STUDY ;STUDY-DOOR IS OPEN)
	(EAST	TO CORR-2 IF STUDY ;STUDY-DOOR IS OPEN)
	(SOUTH	TO CORR-2 IF STUDY ;STUDY-DOOR IS OPEN)
	(OUT	TO CORR-2 IF STUDY ;STUDY-DOOR IS OPEN)>
[
<OBJECT SECRET-LIBRARY-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET PASSAGE LIBRARY)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	;(GENERIC GENERIC-LIBRARY)
	(FLAGS SECRETBIT DOORBIT)>

<ROOM LIBRARY
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT OPENBIT DOORBIT)
	(DESC "library")
	(ADJECTIVE LIBRARY NE)
	(SYNONYM LIBRARY DOOR)
	(GENERIC GENERIC-BEDROOM)
	;(GENERIC GENERIC-LIBRARY)
	(LINE 3)
	(STATION CORR-2)
	(CHARACTER 3)
	(GLOBAL LIBRARY SECRET-LIBRARY-DOOR FIREPLACE CHAIR)
	(SW	TO CORR-2 IF LIBRARY ;LIBRARY-DOOR IS OPEN)
	(WEST	TO CORR-2 IF LIBRARY ;LIBRARY-DOOR IS OPEN)
	(SOUTH	TO CORR-2 IF LIBRARY ;LIBRARY-DOOR IS OPEN)
	(OUT	TO CORR-2 IF LIBRARY ;LIBRARY-DOOR IS OPEN)
	(NE	TO SECRET-LANDING-LIB IF SECRET-LIBRARY-DOOR IS OPEN)
	(IN	TO SECRET-LANDING-LIB IF SECRET-LIBRARY-DOOR IS OPEN)
	;(DOWN	TO SECRET-LANDING-LIB IF SECRET-LIBRARY-DOOR IS OPEN)
	(ACTION LIBRARY-F)>

<ROUTINE LIBRARY-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ;,M-EXIT>
	<SECRET-CHECK .RARG>)
       (<EQUAL? .RARG ,P?NE ,P?IN ;,P?DOWN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"Dusty bookcases tower all around you. There is a table with reading
lamp and chair, and an armchair near the " 'FIREPLACE "."
;", card catalog, and a stepstool for reaching the highest shelves.">
	<OPEN-DOOR? ,SECRET-LIBRARY-DOOR>
	<CRLF>)>>

<OBJECT LIBRARY-CHAIR
	(IN LIBRARY)
	(DESC "armchair")
	(ADJECTIVE ARM)
	(SYNONYM CHAIR SEAT ARMCHAIR)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT VOWELBIT)
	(CAPACITY 99)>

<OBJECT TABLE-LIBRARY
	(IN LIBRARY)
	(DESC "table")
	(ADJECTIVE LIBRARY)
	(SYNONYM TABLE)
	(FLAGS SURFACEBIT OPENBIT NDESCBIT SEARCHBIT)
	(CAPACITY 999)>

<OBJECT BOOKS-GLOBAL
	(IN LIBRARY)
	(DESC "bunch of books")
	(SYNONYM BUNCH BOOK BOOKS)
	(GENERIC GENERIC-BOOK)
	(FLAGS TRYTAKEBIT NDESCBIT READBIT)
	(ACTION BOOKS-GLOBAL-F)>

<ROUTINE BOOKS-GLOBAL-F ("AUX" X)
 <COND (<VERB? LOOK-INSIDE OPEN READ TAKE>
	<TELL
"You pick one at random. It's frightfully obscure, so you put it back." CR>)
       (<VERB? EXAMINE SEARCH SEARCH-FOR>
	<TELL
"Some of the books date as far back as the 16th century. Although
some are fiction, most of the
books are scientific, covered with vellum or leather. Some are in foreign
languages, and many have pictures of skulls or spirits." CR>
	<COND (<SET X <FIND-FLAG ,BOOKCASE ,SECRETBIT>>
	       <DISCOVER .X>)
	      (<SET X <FIRST? ,BOOKCASE>>
	       <FSET .X ,TAKEBIT>
	       <FCLEAR .X ,NDESCBIT>
	       <TELL CTHE .X " catches your eye." CR>)
	      (<IN? ,JOURNAL ,TABLE-LIBRARY>
	       <FCLEAR ,JOURNAL ,SECRETBIT>
	       <TELL
"There are many books of adventure and exploration, as well as the
bound volumes of " D ,COUSIN "'s expedition journals." CR>)>
	<RTRUE>)>>

<OBJECT BOOKCASE
	(IN LIBRARY)
	(DESC ;"swinging " "bookcase")
	(ADJECTIVE SECRET ;SWINGING BOOK)
	(SYNONYM BOOKCASE CASE SHELF SHELVES)
	(FLAGS NDESCBIT CONTBIT OPENBIT SEARCHBIT SEENBIT)
	(CAPACITY 99)
	(ACTION BOOKCASE-F)>

<ROUTINE BOOKCASE-F ("AUX" X)
 <COND (<VERB? EXAMINE LOOK-INSIDE SEARCH>
	<PERFORM ,V?EXAMINE ,BOOKS-GLOBAL>
	<RTRUE>)
       (<VERB? MOVE MOVE-DIR PUSH TURN>
	<COND (<FSET? ,SECRET-LIBRARY-DOOR ,OPENBIT>
	       <OPEN-SECRET "move" ,BOOKCASE ,SECRET-LIBRARY-DOOR>
	       <RTRUE>)>)>>

<OBJECT HISTORY-BOOK
	(IN BOOKCASE ;TABLE-LIBRARY)
	(DESC "history book")
	(ADJECTIVE HISTORY)
	(SYNONYM BOOK BOOKS)
	(GENERIC GENERIC-BOOK)
	(FLAGS TRYTAKEBIT READBIT CONTBIT ;SECRETBIT ;NDESCBIT)
	(CAPACITY 4)
	(ACTION HISTORY-BOOK-F)>

<ROUTINE HISTORY-BOOK-F ()
 <COND (<OR <VERB? MOVE MOVE-DIR>
	    <AND <VERB? PUT-IN>
		 <IOBJ? BOOKCASE>
		 <MOVE ,HISTORY-BOOK ,BOOKCASE>>>
	<OPEN-SECRET "move" ,HISTORY-BOOK ,SECRET-LIBRARY-DOOR>
	<RTRUE>)
       (<VERB? EXAMINE OPEN LOOK-UP READ TAKE>
	<COND (<IN? ,HISTORY-BOOK ,BOOKCASE>
	       <MOVE ,HISTORY-BOOK ,WINNER>
	       <OPEN-SECRET "move" ,HISTORY-BOOK ,SECRET-LIBRARY-DOOR>
	       <RTRUE>)
	      (<VERB? TAKE>
	       <RFALSE>)
	      (<NOT-HOLDING? ,HISTORY-BOOK>
	       <RTRUE>)
	      (T <TELL
"This book
contains a detailed history of " D ,CASTLE " and the
" ,TRESYLLIAN " family, including the bitter fate of Lady Arabella
" ,TRESYLLIAN ", who was accused of infidelity and, by her husband's
command, was buried alive in the wall of the tower keep. The book also
describes the layout of the tower and residential wing, including the
various rooms and " 'PASSAGE "s." CR>)>)>>

<OBJECT JOURNAL
	(IN TABLE-LIBRARY)
	(DESC "journal")
	(ADJECTIVE LI\'S HIS ;EXPEDITION)
	(SYNONYM JOURNAL LOG BOOK BOOKS)
	(GENERIC GENERIC-BOOK)
	(FLAGS TAKEBIT READBIT CONTBIT SECRETBIT)
	(CAPACITY 4)
	(ACTION JOURNAL-F)>

<ROUTINE JOURNAL-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<TELL "This is a journal of Lionel's ">
	<COND (<EQUAL? ,VARIATION ,LORD-C>	<TELL "African">)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>	<TELL "Amazon">)
	      (T ;<EQUAL? ,VARIATION ,FRIEND-C>	<TELL "South Pacific">)>
	<TELL " expedition. As you leaf through it, ">
	<COND (<EQUAL? ,VARIATION ,PAINTER-C>
	       <TELL "no clues appear." CR>
	       <RTRUE>)>
	<TELL "you find a description of a treasure: ">
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <DESCRIBE-WAR-CLUB>
	       <TELL "It also served as his royal sceptre." CR>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <TELL "a " D ,NECKLACE "." CR>)
	      (T ;<EQUAL? ,VARIATION ,DOCTOR-C>
	       <TELL
D ,MOONMIST ", a drug taken from a rare Amazon plant called
the Moonflower. The natives use it to tip their" ,POISON-DART "s,
but it could also be a valuable medicine.
They insist that the plant should be gathered only when the
" 'MOON " is misted over." CR>
	       <COND (<AND <IN? ,MOONMIST ,INKWELL>
			   <FSET? ,INKWELL ,TOUCHBIT>>
		      <FCLEAR ,MOONMIST ,SECRETBIT>)>
	       <RTRUE>)>)>>
][
<ROOM OFFICE
	(IN ROOMS)
	(FLAGS ;ONBIT VOWELBIT SEENBIT OPENBIT DOORBIT)
	(DESC "office")
	(ADJECTIVE OFFICE EAST JACK\'S HIS)
	(SYNONYM OFFICE DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 3)
	(STATION CORR-2)
	(CHARACTER 3)
	(GLOBAL OFFICE ;OFFICE-DOOR CHAIR FIREPLACE)
	(THINGS <PSEUDO ( TALL STOOL	RANDOM-PSEUDO)
			;( LARGE DESK	RANDOM-PSEUDO)>)
	(WEST	TO CORR-2 IF OFFICE ;OFFICE-DOOR IS OPEN)
	(OUT	TO CORR-2 IF OFFICE ;OFFICE-DOOR IS OPEN)
	(ACTION OFFICE-F)>

<ROUTINE OFFICE-F ("OPTIONAL" (ARG 0))
 <COND (<==? .ARG ,M-LOOK>
	<TELL
;"a file cabinet and bookshelf, as well as both a typewriter and"
"This small office gets little light and less air. In one corner
is a computer. By the " 'FIREPLACE ",
there is a tall " 'DESK " with" ;"a quill pen">
	<COND (<FIRST? ,DESK>
	       <PRINT-CONTENTS ,DESK>
	       <TELL ", and">)>
	;<COND (<IN? ,INKWELL ,DESK>
	       <TELL " an " 'INKWELL " and">)>
	<TELL " a tall stool." CR>)>>

<OBJECT DESK
	(IN OFFICE)
	(DESC "old-fashioned desk")
	(ADJECTIVE TAM\'S HER ;"TAMARA TAMMY" OLD OLD-FASHION TALL)
	(SYNONYM DESK)
	(FLAGS SURFACEBIT VEHBIT OPENBIT VOWELBIT SEENBIT NDESCBIT)
	(CAPACITY 999)>

<OBJECT INKWELL
	(IN DESK)
	(DESC "inkwell")
	(ADJECTIVE INK)
	(SYNONYM INKWELL WELL)
	(GENERIC GENERIC-WELL)
	(FLAGS VOWELBIT TAKEBIT CONTBIT TRANSBIT OPENBIT ;SEENBIT)
	(SIZE 4)
	(CAPACITY 0 ;3)
	(ACTION INKWELL-F)>

<ROUTINE INKWELL-F ()
 <COND (<IN? ,MOONMIST ,INKWELL>
	<COND (<VERB? EMPTY>
	       <FCLEAR ,MOONMIST ,SECRETBIT>
	       <PERFORM ,V?POUR ,MOONMIST ,PRSI>
	       <RTRUE>)
	      (<VERB? EXAMINE LOOK-INSIDE OPEN SEARCH SEARCH-FOR>
	       <COND ;(<FSET? ,MOONMIST ,SECRETBIT>
		       ;<T? ,TREASURE-FOUND>
		       <FCLEAR ,MOONMIST ,SECRETBIT>
		       <PERFORM ,V?EXAMINE ,MOONMIST>)
		     (<FSET? ,MOONMIST ,SECRETBIT>
		      <DISCOVER ,MOONMIST ;,INKWELL>
		      <RTRUE>)>)>)>>

<OBJECT COMPUTER
	(IN OFFICE)
	(DESC "computer")
	(SYNONYM COMPUTER)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION COMPUTER-F)>

<ROUTINE COMPUTER-F ()
 <COND (<VERB? EXAMINE>
	<TELL "It looks just like the computer you're using now!" CR>)
       (<VERB? LAMP-OFF>
	<OKAY ,COMPUTER "off">
	<RTRUE>)
       (<VERB? LAMP-ON PLAY USE>
	<COND (T ;<NOT <FSET? ,COMPUTER ,ONBIT>>
	       ;<FSET ,COMPUTER ,ONBIT>
	       <TELL
CHE ,COMPUTER " starts running an interactive mystery from Infocom called \"">
	       <COND (<EQUAL? ,VARIATION ,LORD-C>
		      <TELL "DEADLINE (R">)
		     (<EQUAL? ,VARIATION ,PAINTER-C>
		      <TELL "THE WITNESS (R">)
		     (<EQUAL? ,VARIATION ,FRIEND-C>
		      <TELL "SUSPECT (TM">)
		     (T ;<EQUAL? ,VARIATION ,DOCTOR-C>
		      <TELL "BALLYHOO (TM">)>
	       <TELL
"),\" but you decide that " 'MOONMIST " (TM) is easier, so you turn it off."
CR>)>)>>
][
<OBJECT SECRET-TAMARA-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "sliding panel")
	(ADJECTIVE SECRET PASSAGE SLIDING TAM\'S HER ;"TAMARA TAMMY")
	(SYNONYM DOOR PANEL)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-TAMARA-DOOR-F)>

<ROOM TAMARA-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WORNBIT)
	(DESC "Tamara's bedroom")
	(ADJECTIVE TAM\'S HER BED ;ROOM BEDROOM SE)
	(SYNONYM BEDROOM ROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 3)
	(STATION CORR-2)
	(CHARACTER 3)
	(GLOBAL TAMARA-ROOM SECRET-TAMARA-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG ;CHAIR WINDOW)
	(THINGS <PSEUDO ;( MAKE-UP KIT "conflicts w/ ghost's" RANDOM-PSEUDO)
			( <> KIT		RANDOM-PSEUDO)
			( ;<> HAND MIRROR	DRESSING-MIRROR-F)>)
	(NW	TO CORR-2 IF TAMARA-ROOM ;TAMARA-DOOR IS OPEN)
	(NORTH	TO CORR-2 IF TAMARA-ROOM ;TAMARA-DOOR IS OPEN)
	(WEST	TO CORR-2 IF TAMARA-ROOM ;TAMARA-DOOR IS OPEN)
	(OUT	TO CORR-2 IF TAMARA-ROOM ;TAMARA-DOOR IS OPEN)
	(SE	TO SECRET-LANDING-TAM IF SECRET-TAMARA-DOOR IS OPEN)
	(IN	TO SECRET-LANDING-TAM IF SECRET-TAMARA-DOOR IS OPEN)
	(DOWN	TO SECRET-LANDING-TAM IF SECRET-TAMARA-DOOR IS OPEN)
	(ACTION TAMARA-ROOM-F)>

<ROUTINE TAMARA-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<SECRET-CHECK .RARG>)
       (<EQUAL? .RARG ,P?SE ,P?IN ,P?DOWN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The room is utterly feminine in its decoration, yet neater than you might
expect for a young woman of " 'FRIEND "'s age. " ;"No garments are strewn about
carelessly. ">
	<DRESSING-TABLE-TAM>
	<OPEN-DOOR? ,SECRET-TAMARA-DOOR>
	<CRLF>)>>

<ROUTINE DRESSING-TABLE-TAM ()
	<TELL
"Even her " 'DRESSING-TABLE-LG " is in apple-pie order, with her hand
mirror, comb, brush, makeup kit and " 'JEWELRY-CASE " all precisely
placed on its gleaming surface.">>

<OBJECT TAMARA-BED
	(IN TAMARA-ROOM)
	(DESC "bed" ;"post")
	(ADJECTIVE TAM\'S HER BED ;" TAMARA TAMMY")
	(SYNONYM BED KNOB BEDPOST POST)
	(FLAGS SEENBIT SURFACEBIT OPENBIT VEHBIT NDESCBIT ;NARTICLEBIT)
	(CAPACITY 999)
	(ACTION TAMARA-BED-F)>

<ROUTINE TAMARA-BED-F ("AUX" OBJ) ;("OPT" (ARG 0))
 <COND ;(<T? .ARG> <RFALSE>)
       (<VERB? EXAMINE ;"SEARCH SEARCH-FOR">
	<TELL
'FRIEND " has a curtained four-poster bed on a circular dais.
You notice that the knob on one bedpost looks loose." CR>)
       (<VERB? LOOK-UNDER SEARCH ;SEARCH-FOR>
	<COND (<SET OBJ <FIND-FLAG ,TAMARA-BED ,NDESCBIT ,PLAYER>>
	       <DISCOVER .OBJ ;,TAMARA-BED>)>)
       (<VERB? PUT-UNDER>
	<COND (<IOBJ? TAMARA-BED>
	       <FSET ,PRSO ,NDESCBIT>
	       <MOVE ,PRSO ,TAMARA-BED>
	       <OKAY>)>)
       (<VERB? MOVE MOVE-DIR PUSH RUB TURN>
	<OPEN-SECRET "turn" ;,TAMARA-BED " the bedpost" ,SECRET-TAMARA-DOOR>)>>

<OBJECT JEWELRY-CASE
	(IN TAMARA-ROOM)
	(DESC "jewelry case")
	(ADJECTIVE JEWELRY ;"TAMARA TAMMY" HER TAM\'S)
	(SYNONYM CASE BOX)
	(FLAGS TRYTAKEBIT NDESCBIT CONTBIT ;OPENBIT SEENBIT)
	(CAPACITY 8)
	(ACTION JEWELRY-CASE-F)>

<ROUTINE JEWELRY-CASE-F ()
	<COND (<VERB? TAKE>
	       <COND (<DOBJ? JEWELRY-CASE>
		      <YOU-SHOULDNT>
		      <RTRUE>)>)
	      (<VERB? EXAMINE LOOK-INSIDE OPEN>
	       ;<FSET ,JEWELRY-CASE ,OPENBIT>	;"done in TELL-AS-WELL-AS"
	       <TELL-AS-WELL-AS ,JEWELRY-CASE " an assortment of jewelry">
	       <COND (<AND <IN? ,EARRING ,JEWELRY-CASE>
			   <FSET? ,EARRING ,NDESCBIT>>
		      <FCLEAR ,EARRING ,NDESCBIT>
		      <FCLEAR ,EARRING ,SECRETBIT>
		      <THIS-IS-IT ,EARRING>
		      <TELL
"Almost the first thing you notice is a delicate " 'EARRING "." CR>)>
	       <RTRUE>)>>

<OBJECT EARRING
	;(IN JEWELRY-CASE)
	(DESC "earring")
	(ADJECTIVE ;"DELICATE TAMARA TAMMY" TAM\'S HER)
	(SYNONYM EARRING SETTING SOCKET)
	(FLAGS TAKEBIT VOWELBIT NDESCBIT WEARBIT SECRETBIT SEENBIT)
	(SIZE 1)
	(TEXT "The jewel is missing from its setting!")
	(ACTION EARRING-F)>

<ROUTINE EARRING-F ()
 <COND ;(<NOT <EQUAL? ,VARIATION ,FRIEND-C>>
	<SETG CLOCK-WAIT T>
	<TELL "(You can't see any red-jewelled earrings here.)" CR>)
       (<AND <VERB? COMPARE HOLD-UP PUT PUT-IN>
	     <EQUAL? ,JEWEL ,PRSO ,PRSI>>
	<FSET ,EARRING ,LOCKED>	;"Remember player did this."
	<TELL "The jewel fits the empty " 'EARRING " perfectly.">
	<COND (<VERB? PUT PUT-IN>
	       <TELL " You remove the jewel again.">
	       ;<MOVE ,JEWEL ,EARRING>)>
	<CRLF>
	<COND (<ZERO? ,EVIDENCE-FOUND>
	       <CONGRATS>)>
	<RTRUE>)>>
]
<ROOM CORR-3
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT)
	(DESC "second-floor corridor")
	(ADJECTIVE SECOND)
	(SYNONYM CORRIDOR ROOM)
	(LINE 3)
	(STATION CORR-3)
	(CHARACTER 4)
	(GLOBAL LUMBER-ROOM ;LUMBER-DOOR CHAPEL ;CHAPEL-DOOR
		GAME-ROOM ;GAME-DOOR STAIRS)
	(SE	TO LUMBER-ROOM IF LUMBER-ROOM ;LUMBER-DOOR IS OPEN)
	(SOUTH	TO CHAPEL IF CHAPEL ;CHAPEL-DOOR IS OPEN)
	(WEST	TO CORR-2 ;STAIRS-2)
	(DOWN	TO CORR-2 ;STAIRS-2)
	(OUT	TO CORR-2 ;STAIRS-2)
	(NORTH	TO GAME-ROOM IF GAME-ROOM ;GAME-DOOR IS OPEN)
	(UP	TO DECK ;STAIRS-3)
	(EAST	TO DECK ;STAIRS-3)
	(IN "Which direction do you want to go in?")
	(ACTION CORR-3-F)>

<GLOBAL WHICH-DIR "Which direction do you want to go in?">

<ROUTINE CORR-3-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The " 'CORR-3 " has doors leading to the north, south, and
southeast. Stairways go up at the east end and down at the west end." CR>
	<RTRUE>)
       (<EQUAL? .RARG ,P?WEST ,P?DOWN ,P?OUT>
	<TELL ,STAIRS-DOWN-LEFT>
	<RTRUE>)
       (<EQUAL? .RARG ,P?EAST ,P?UP>
	<TELL ,STAIRS-UP-RIGHT>
	<RTRUE>)>>
[
<ROUTINE CAGE-PSEUDO ()
 <COND (<VERB? LOOK-INSIDE OPEN>
	<TELL "It's empty." CR>)
       (T <RANDOM-PSEUDO>)>>

<ROOM LUMBER-ROOM
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT OPENBIT DOORBIT)
	(DESC "lumber room")
	(ADJECTIVE LUMBER ROOM)
	(SYNONYM ROOM DOOR)
	(CORRIDOR 0)	;"becomes 4 when LUMBER-RING lifted"
	(LINE 3)
	(STATION CORR-3)
	(CHARACTER 4)
	(GLOBAL LUMBER-ROOM ;LUMBER-DOOR ;SECRET-LUMBER-DOOR)
	(THINGS <PSEUDO ;( ORNATE BIRDCAGE	CAGE-PSEUDO)
			( ORNATE CAGE		CAGE-PSEUDO)
			( BIRD CAGE		CAGE-PSEUDO)
			( HOBBY HORSE		RANDOM-PSEUDO)>)
	(NW	TO CORR-3 IF LUMBER-ROOM ;LUMBER-DOOR IS OPEN)
	(NORTH	TO CORR-3 IF LUMBER-ROOM ;LUMBER-DOOR IS OPEN)
	(WEST	TO CORR-3 IF LUMBER-ROOM ;LUMBER-DOOR IS OPEN)
	(OUT	TO CORR-3 IF LUMBER-ROOM ;LUMBER-DOOR IS OPEN)
	(ACTION LUMBER-ROOM-F)>

<ROUTINE LUMBER-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG>
	<COND (<SECRET-CHECK .RARG>
	       <RTRUE>)
	      (<VERB? LOOK-DOWN>
	       <COND (<FSET? ,LUMBER-RING ,TOUCHBIT>
		      <PERFORM ,V?LOOK-THROUGH ,PEEPHOLE-2>
		      <RTRUE>)
		     (<FSET? ,LUMBER-CHEST ,TOUCHBIT>
		      <PERFORM ,V?MOVE ,LUMBER-RING>
		      <RTRUE>)>)>)
       (<EQUAL? .RARG ,M-ENTER>
	<COND (<IN? ,PEEPHOLE-2 ,LUMBER-ROOM>
	       <PUTP ,LUMBER-ROOM ,P?CORRIDOR 4>)>
	<RFALSE>)
       (<EQUAL? .RARG ,M-EXIT>
	<PUTP ,LUMBER-ROOM ,P?CORRIDOR 0>
	<RFALSE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"This is lumber in the British sense, meaning useless stuff
like old " 'MAGAZINE "s, an ornate bird cage, an " 'LUMBER-CHEST " from
the 1700's, and a broken Victorian hobby horse." ;" Much of it was moved
here during the War, when the Royal Navy used the  'DECK  as an
observation post. [NW to corridor]">
	;<OPEN-DOOR? ,SECRET-LUMBER-DOOR>
	<CRLF>)>>

<OBJECT LUMBER-CHEST
	(IN LUMBER-ROOM)
	(DESC "ancient chest")
	(ADJECTIVE ANCIENT)
	(SYNONYM CHEST)
	(ACTION LUMBER-CHEST-F)
	(FLAGS VOWELBIT SEENBIT NDESCBIT)>

<ROUTINE LUMBER-CHEST-F ()
 <COND (<VERB? LOOK-INSIDE OPEN>
	<TOO-BAD-BUT ,PRSO "rusted shut">)
       (<VERB? MOVE MOVE-DIR PUSH TURN>
	;<OPEN-SECRET "move" ,LUMBER-CHEST ,SECRET-LUMBER-DOOR>
	<COND (<NOT <IN? ,LUMBER-RING ,LUMBER-ROOM>>
	       <MOVE ,LUMBER-RING ,LUMBER-ROOM>
	       ;<MOVE ,PEEPHOLE-2 ,LUMBER-ROOM>
	       ;<PUTP ,LUMBER-ROOM ,P?CORRIDOR 4>
	       <TELL
"You reveal" THE ,LUMBER-RING " in the stone floor." CR>
	       <RTRUE>)>)>>

<OBJECT LUMBER-RING
	;(IN LUMBER-ROOM)
	(DESC "sunken handle" ;"ring")
	(ADJECTIVE SUNKEN)
	(SYNONYM HANDLE ;RING)
	(FLAGS TRYTAKEBIT)
	(ACTION LUMBER-RING-F)>

<ROUTINE LUMBER-RING-F ("AUX" P)
 <COND (<VERB? MOVE MOVE-DIR OPEN PUSH TAKE>
	<COND (<IN? ,PEEPHOLE-2 ,LUMBER-ROOM>
	       <ALREADY ,LUMBER-RING "open">
	       <RTRUE>)>
	<MOVE ,PEEPHOLE-2 ,LUMBER-ROOM>
	<PUTP ,LUMBER-ROOM ,P?CORRIDOR 4>
	<TELL
"As you pull up on" THE ,LUMBER-RING ", you reveal" THE ,PEEPHOLE-2
", enabling you to peer directly downward at " 'TAMARA-ROOM " below.|">
	<COND (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,PLAYER>>
	       <TELL CHE .P " says, \"So that explains the ghostly face that ">
	       <COND (<==? .P ,FRIEND> <TELL !\I>) (T <TELL D ,FRIEND>)>
	       <TELL " saw peering down that night.\"" CR>)>
	<RTRUE>)
       (<VERB? CLOSE>
	<COND (<NOT <IN? ,PEEPHOLE-2 ,LUMBER-ROOM>>
	       <ALREADY ,LUMBER-RING "closed">
	       <RTRUE>)>
	<MOVE ,PEEPHOLE-2 ,LOCAL-GLOBALS>
	<PUTP ,LUMBER-ROOM ,P?CORRIDOR 0>
	<OKAY ,LUMBER-RING "closed">
	<RTRUE>)>>

<OBJECT PEEPHOLE-2
	(IN LOCAL-GLOBALS)
	(DESC "peephole")
	(ADJECTIVE SECRET PEEP ;PEEK)
	(SYNONYM HOLE PEEKHOLE PEEPHOLE OPENING)
	(FLAGS NDESCBIT ;SECRETBIT ONBIT)
	(ACTION PEEPHOLE-2-F)>

<ROUTINE PEEPHOLE-2-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-OUTSIDE LOOK-THROUGH>
	<COND (T ;<NOT <SECRET-CHECK ,M-BEG>>
	       <ROOM-PEEK ,TAMARA-ROOM T>)>
	<RTRUE>)
       (<VERB? THROUGH>
	<TOO-BAD-BUT ,PEEPHOLE-2 "too small">
	<RTRUE>)>>

<OBJECT MAGAZINE
	(IN LUMBER-ROOM)
	(DESC "magazine")
	(ADJECTIVE OLD PUNCH)
	(SYNONYM MAGAZINE PUNCH)
	(FLAGS ;TRY TAKEBIT NDESCBIT READBIT ;SECRETBIT)
	(SIZE 4)
	(ACTION MAGAZINE-F)>

<ROUTINE MAGAZINE-F ()
 <COND ;(<AND <VERB? EXAMINE TAKE SEARCH SEARCH-FOR>
	     <EQUAL? ,VARIATION ,PAINTER-C>
	     <FSET? ,MAGAZINE ,NDESCBIT>>
	<FCLEAR ,MAGAZINE ,TRYTAKEBIT>
	<COND (<VERB? TAKE>
	       <MOVE ,MAGAZINE ,WINNER>)>
	<DISCOVER ,MAGAZINE>
	<RTRUE>)
       (<VERB? EXAMINE LOOK-INSIDE OPEN READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<TELL "This is a">
	<COND (<EQUAL? ,VARIATION ,PAINTER-C>
	       <TELL
" copy of \"Reader's Digest\" for Sept. 1976. As you leaf through
it, you find an article about the skull of Peking Man, which
disappeared after the Pearl Harbor Attack, when it was
shipped from China. Once it was
mysteriously offered for sale for a million
dollars, as reported in the New York Times." CR>)
	      (T <TELL
"n old copy of \"Punch,\" good for a laugh or two." CR>)>)>>
][
<ROOM CHAPEL
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT OPENBIT DOORBIT)
	(DESC "chapel")
	(ADJECTIVE CHAPEL)
	(SYNONYM CHAPEL DOOR)
	(LINE 3)
	(STATION CORR-3)
	(CHARACTER 4)
	(GLOBAL CHAPEL ;CHAPEL-DOOR CHAIR)
	(THINGS <PSEUDO ( <> ALTAR	RANDOM-PSEUDO)
			( <> PULPIT	RANDOM-PSEUDO)
			( <> FONT	RANDOM-PSEUDO)
			( FAMILY PEW	RANDOM-PSEUDO)
			( FAMILY PEWS	RANDOM-PSEUDO)>)
	(NORTH	TO CORR-3 IF CHAPEL ;CHAPEL-DOOR IS OPEN)
	(OUT	TO CORR-3 IF CHAPEL ;CHAPEL-DOOR IS OPEN)
	(ACTION CHAPEL-F)>

<ROUTINE CHAPEL-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"A bare and austere yet poignantly atmospheric relic of the medieval
past, the chapel contains an altar, pulpit, font, and family pews of
elaborately carved oak. The most memorable feature is a splendid "
D ,STAINED-WINDOW ". " <GETP ,STAINED-WINDOW ,P?TEXT> CR>)>>

<OBJECT STAINED-WINDOW
	(IN CHAPEL)
	(DESC "stained-glass window")
	(ADJECTIVE STAINED GLASS)
	(SYNONYM WINDOW APPLE GLASS)
	(FLAGS ;CONTBIT OPENBIT NDESCBIT)
	(CAPACITY 3)
	(TEXT
"It portrays, in vividly glowing colors, Eve
tempting Adam with the forbidden apple in the Garden of Eden.")
	(ACTION STAINED-WINDOW-F)>

<ROUTINE STAINED-WINDOW-F ()
 <COND (<AND <VERB? EXAMINE TAKE SEARCH SEARCH-FOR>
	     <IN? ,CLUE-3 ,STAINED-WINDOW>
	     <FSET? ,CLUE-3 ,SECRETBIT>>
	<DISCOVER ,CLUE-3>
	<RTRUE>
	;<TELL
CHE ,WINNER notice " that the " D ,STAINED-WINDOW " looks odd. When"HE ,WINNER
remove " the apple, it's obviously " <GETP ,RUBY ,P?TEXT> "!" CR>)
       (<VERB? MUNG>
	<YOU-SHOULDNT>)>>
][
<ROUTINE BILLIARD-PSEUDO ()
 <COND (<VERB? LOOK-ON>
	<WONT-HELP>)
       (<VERB? PLAY>
	<TELL
CHE ,WINNER knock " the balls around for a minute before getting bored." CR>)>>

<ROOM GAME-ROOM
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT OPENBIT DOORBIT)
	(DESC "game room")
	(ADJECTIVE GAME GAME-ROOM ROOM BILLIARD)
	(SYNONYM ROOM DOOR)
	(LDESC
"The game room has a billiard table and card table, with various chairs
and standing ash trays. On the wall are a cue rack, gun rack, and mounted
heads of a rhino and a cape buffalo."
;"[S to corridor]")
	(LINE 3)
	(STATION CORR-3)
	(CHARACTER 4)
	(GLOBAL GAME-ROOM ;GAME-DOOR CHAIR ;TABLE-RANDOM)
	(THINGS <PSEUDO ( CARD TABLE	BILLIARD-PSEUDO)
			( BILLIARD TABLE BILLIARD-PSEUDO)
			;( <> BILLIARD	BILLIARD-PSEUDO)
			( CUE RACK	RANDOM-PSEUDO)
			( <> CUE	RANDOM-PSEUDO)
			( GUN RACK	RANDOM-PSEUDO)
			( <> GUN	RANDOM-PSEUDO)
			( ASH TRAY	RANDOM-PSEUDO)
			( ASH TRAYS	RANDOM-PSEUDO)>)
	(SOUTH	TO CORR-3 IF GAME-ROOM ;GAME-DOOR IS OPEN)
	(OUT	TO CORR-3 IF GAME-ROOM ;GAME-DOOR IS OPEN)>

<OBJECT BUFFALO-HEAD
	(IN GAME-ROOM)
	(DESC "stuffed buffalo head")
	(ADJECTIVE STUFFED ;CAPE BUFFALO BUF\'S ;EYE)
	(SYNONYM BUFFALO HEAD EYE ;SOCKET)
	(GENERIC GENERIC-EYE)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION BUFFALO-HEAD-F)>

<ROUTINE BUFFALO-HEAD-F ()
 <COND (<AND <NOUN-USED? ,W?EYE>
	     <ADJ-USED? <>>
	     <VISIBLE? ,GLASS-EYE>>
	<DO-INSTEAD-OF ,GLASS-EYE ,BUFFALO-HEAD>
	<RTRUE>)>>

<OBJECT RHINO-HEAD
	(IN GAME-ROOM)
	(DESC "stuffed rhino head")
	(ADJECTIVE STUFFED RHINO RH\'S)
	(SYNONYM RHINO HEAD)
	(FLAGS ;TRYTAKEBIT CONTBIT OPENBIT NDESCBIT SEENBIT SEARCHBIT)
	(CAPACITY 3)
	(ACTION RHINO-HEAD-F)>

<ROUTINE RHINO-HEAD-F ()
 <COND ;(<VERB? TAKE>
	<TELL "The trophy is fastened securely to the wall." CR>)
       (<VERB? EXAMINE ;TAKE SEARCH SEARCH-FOR OPEN LOOK-INSIDE FIX>
	<COND (<AND <IN? ,CLUE-3 ,RHINO-HEAD>
		    <FSET? ,CLUE-3 ,SECRETBIT>>
	       <FSET ,GLASS-EYE ,TAKEBIT>
	       <FCLEAR ,GLASS-EYE ,TRYTAKEBIT>
	       <FCLEAR ,GLASS-EYE ,NDESCBIT>
	       <FSET ,GLASS-EYE ,SEENBIT>
	       <TELL
"There's something odd about this trophy. One of the " 'GLASS-EYE "s is
backwards." CR>)>)>>

<OBJECT GLASS-EYE
	(IN RHINO-HEAD)
	(DESC "glass eye")
	(ADJECTIVE GLASS RHINO YELLOW RH\'S)
	(SYNONYM EYE)
	(GENERIC GENERIC-EYE)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(SIZE 2)
	(ACTION GLASS-EYE-F)>

<ROUTINE GLASS-EYE-F ()
 <COND (<AND <DOBJ? GLASS-EYE>
	     <IN? ,RHINO-HEAD ,HERE>
	     <VERB? EXAMINE FIX LOOK-BEHIND LOOK-INSIDE MOVE MOVE-DIR
		OPEN SEARCH SEARCH-FOR TAKE>>
        <COND (<AND <IN? ,CLUE-3 ,RHINO-HEAD>
		    ;<FSET? ,CLUE-3 ,SECRETBIT>>
	       <FSET ,RHINO-HEAD ,OPENBIT>
	       <FCLEAR ,GLASS-EYE ,NDESCBIT>
	       <FCLEAR ,GLASS-EYE ,TRYTAKEBIT>
	       <FSET ,GLASS-EYE ,TAKEBIT>
	       <COND (<VERB? TAKE>
		      <V-TAKE>
		      ;<MOVE ,GLASS-EYE ,WINNER>)>
	       <DISCOVER ,CLUE-3>
	       <RTRUE>)>)>>
][
<ROOM DECK
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT SURFACEBIT OPENBIT)
	(DESC "fighting deck")
	(ADJECTIVE THIRD TOP STORY STOREY FIGHTING OBSERVE)
	(SYNONYM ;CORRIDOR DECK ROOF)
	(GLOBAL MOON OCEAN STAIRS)
	(LINE 3)
	(STATION DECK)
	(CHARACTER 5)
	;(NORTH	;"TO CURTAIN-WALL"
"The curtain wall looks too precarious for walking.")
	;(EAST
"You almost step on thin air instead of the curtain wall that has long
since crumbled away.")
	(OUT	TO CORR-3)
	(DOWN	TO CORR-3 ;STAIRS-3)
	(IN	TO CORR-3 ;STAIRS-3)
	(SOUTH	TO CORR-3 ;STAIRS-3)
	(ACTION DECK-F)>

<ROUTINE DECK-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The \"roof\" of the tower keep has a stone floor and battlements all
around. Far below,
the faint sound of the sea cries from the darkness. In the moonlight
you see a huge bell mounted on a heavy frame."
;"[N to curtain wall, S/D to stair]" CR>
	<RTRUE>)
       (<EQUAL? .RARG ,P?SOUTH ,P?DOWN ,P?IN>
	<TELL ,STAIRS-DOWN-LEFT>
	<RTRUE>)>>

<OBJECT BELL
	(IN DECK)
	(DESC "bell")
	(ADJECTIVE DINNER ;HUGE)
	(SYNONYM BELL GONG)
	(GENERIC GENERIC-BELL)
	(FLAGS NDESCBIT SEENBIT CONTBIT OPENBIT)
	(ACTION BELL-F)>

<ROUTINE BELL-F ("AUX" (N 0) P GT)
 <COND (<VERB? MOVE MOVE-DIR PUSH TURN>
	<TOO-BAD-BUT ,BELL "too heavy">)
       (<VERB? EXAMINE LOOK-INSIDE LOOK-UNDER SEARCH SEARCH-FOR>
	<COND (<AND <EQUAL? ,VARIATION ,PAINTER-C>
		    <FSET? ,SKULL ,SECRETBIT>>
	       ;<FCLEAR ,SKULL ,SECRETBIT>
	       <DISCOVER ,SKULL>
	       <RTRUE ;FALSE>)
	      (<AND ;<EQUAL? ,VARIATION ,FRIEND-C>
		    <IN? ,CLUE-3 ,BELL>
		    <FSET? ,CLUE-3 ,SECRETBIT>>
	       ;<FCLEAR ,CLUE-3 ,SECRETBIT>
	       <DISCOVER ,CLUE-3>
	       <RTRUE ;FALSE>)
	      (T
	       <TELL-AS-WELL-AS ,BELL " the clapper">
	       <RTRUE>
	       ;<TELL "There's nothing inside it but the clapper." CR>)>)
       (<VERB? RING>
	<COND ;(<AND <EQUAL? ,VARIATION ,PAINTER-C>
		    <FSET? ,SKULL ,SECRETBIT>>
	       <TELL "It just goes \"klunk.\"" CR>
	       <RTRUE>)
	      (<T? ,PLAYER-RANG-BELL?>
	       T)
	      (<NOT <IN? ,BUTLER ,LOCAL-GLOBALS>>
	       <COND (<NOT <IN? ,BUTLER ,KITCHEN ;,HERE>>
		      <GO-TO-SOUND ,KITCHEN ;,HERE ,BUTLER>)>)
	      (<ZERO? ,LIONEL-SPEAKS-COUNTER>
	       <SETG MASS-SAID <>>
	       <REPEAT ()
		       <COND (<IGRTR? N ,DEB-C> <RETURN>)>
		       <SET P <GET ,CHARACTER-TABLE .N>>
		       <COND (<AND <NOT <EQUAL? .P ,CONFESSED ,CAPTOR>>
				   <NOT <EQUAL? .P ,GHOST-NEW ,SEARCHER>>
				   ;<NOT <IN? .P ,DECK>>>
			      <GO-TO-SOUND ,DECK .P>)>>)>
	<SETG PLAYER-RANG-BELL? T>
	<TELL
"Its deep booming \"gong\" can be felt in every room of the castle.">
	;<COND (<FIRST? ,BELL>
	       <TELL " But it doesn't ring true.">)>
	<CRLF>
	<COND (<AND <==? ,HERE ,DECK>
		    <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,PLAYER>>>
	       <TELL D .P " whispers, \"That's ">
	       <COND (<FIRST? ,BELL> <TELL "not " ;"a bit odd.\"">)>
	       <TELL "too loud for comfort!\"">
	       <CRLF>)>
	<RTRUE>)>>

<GLOBAL BUTLER-DUTY 0>

<ROUTINE GO-TO-SOUND (RM ;OBJ P "AUX" GT GF (L <LOC .P>))
 <COND (<AND <NOT <IN? .P .RM>>
	     <NOT <FSET? .P ,MUNGBIT>>>
	<SET GT <GT-O .P>>
	<SET GF <GET .GT ,GOAL-FUNCTION>>
	<COND (<AND <==? .P ,BUTLER>
		    <NOT <==? .GF ,X-TO-BELL>>>
	       <SETG BUTLER-DUTY .GF>)>
	<PUT .GT ,GOAL-FUNCTION ,X-TO-BELL>
	<COND (<IN-MOTION? .P T>
	       <PUT .GT ,GOAL-QUEUED <GET .GT ,GOAL-F>>)
	      (T ;<ZERO? <GET .GT ,GOAL-ENABLE>>
	       <PUT .GT ,GOAL-QUEUED .L>)>
	<COND (<AND <1? <RANDOM 2>>
		    <OR <AND <FSET? .RM ,WEARBIT> ;"WING-ROOMS"
			     <NOT <FSET? .L ,WEARBIT>>>
			<AND <NOT <FSET? .RM ,WEARBIT>>
			     <FSET? .L ,WEARBIT>>>>
	       ;<PUTP .P ,P?LDESC 0>
	       <MOVE .P ,JUNCTION>)>
	<ESTABLISH-GOAL .P .RM ;,HERE>)>>

<ROUTINE X-TO-BELL ("OPTIONAL" (GARG <>)
		    "AUX" (L <LOC ,GOAL-PERSON>) (GT <GT-O ,GOAL-PERSON>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[X-TO-BELL:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<OR <EQUAL? .GARG ,G-REACHED>
	    <EQUAL? .L ,HERE>>
	<COND (<L? ,BED-TIME ,PRESENT-TIME>
	       <QUEUE I-BEDTIME 15>)>
	<PUT .GT ,ATTENTION <GET .GT ,ATTENTION-SPAN>>
	<COND (<==? ,GOAL-PERSON ,BUTLER>
	       <PUT .GT ,GOAL-FUNCTION ,BUTLER-DUTY>)
	      (T <PUT .GT ,GOAL-FUNCTION ,NULL-F>)>
	;<ESTABLISH-GOAL ,GOAL-PERSON <GET .GT ,GOAL-QUEUED>>	;I-ATTENTION
	;<PUT .GT ,GOAL-ENABLE 0>
	;<PUT .GT ,GOAL-S <>>
	<PUTP ,GOAL-PERSON ,P?LDESC 4 ;"looking at you with suspicion">
	<COND (<AND <EQUAL? .L ,HERE>
		    <ZERO? ,MASS-SAID>>
	       <SETG MASS-SAID T>
	       <TELL
CHE ,GOAL-PERSON " appears and says, \"What's all this, then?\"|">
	       <RFATAL>)>)>>
]

<GLOBAL INTO-DARKNESS " into darkness.|">

<OBJECT LADDER
	(IN LOCAL-GLOBALS)
	(DESC "ladder")
	(ADJECTIVE NARROW)
	(SYNONYM LADDER ;" STAIRW STAIRS STAIR")
	(ACTION LADDER-F)>

<ROUTINE LADDER-F ("AUX" (U <>) (D <>))
 <COND (<VERB? CLIMB-DOWN>
	<DO-WALK ,P?DOWN>
	<RTRUE>)
       (<VERB? CLIMB-UP>
	<DO-WALK ,P?UP>
	<RTRUE>)
       (<VERB? BOARD CLIMB-ON>
	<COND (<SET U <GETPT ,HERE ,P?UP>>
	       <COND (<NOT <==? <PTSIZE .U> ,UEXIT>>
		      <SET U <>>)>)>
	<COND (<SET D <GETPT ,HERE ,P?DOWN>>
	       <COND (<NOT <==? <PTSIZE .D> ,UEXIT>>
		      <SET D <>>)>)>
	<COND (<ZERO? .U>
	       <DO-WALK ,P?DOWN>)
	      (<ZERO? .D>
	       <DO-WALK ,P?UP>)
	      (T
	       <SETG CLOCK-WAIT T>
	       <TELL !\( ,WHICH-DIR ")" CR>)>
	<RTRUE>)>>

<ROUTINE LEVER-AND-DOOR (DR DIR)
	<FSET .DR ,SEENBIT>
	<TELL !\A>
	<COND (<FSET? .DR ,OPENBIT> <TELL "n open">)>
	<TELL " " D .DR " and a lever are on the ">
	<DIR-PRINT .DIR>
	<TELL " wall." CR>>

<ROOM SECRET-LANDING-JACK
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "Jack's landing")
	(ADJECTIVE JACK\'S HIS SECRET)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-JACK-DOOR JACK-ROOM LEVER STAIRS)
	(LINE 4)
	(STATION SECRET-LANDING-JACK)
	(CHARACTER 3)
	(NORTH	TO JACK-ROOM IF SECRET-JACK-DOOR IS OPEN)
	(NE	TO JACK-ROOM IF SECRET-JACK-DOOR IS OPEN)
	(IN	TO JACK-ROOM IF SECRET-JACK-DOOR IS OPEN)
	(OUT	TO JACK-ROOM IF SECRET-JACK-DOOR IS OPEN)
	(EAST	TO PASSAGE-1)
	(SE	TO PASSAGE-1)
	(DOWN	TO PASSAGE-1)
	(ACTION SECRET-LANDING-JACK-F)>

<ROUTINE SECRET-LANDING-JACK-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,JACK-ROOM>
	<LEVER-AND-DOOR ,SECRET-JACK-DOOR ,P?IN>
	<TELL "Stone steps curve down to the east." CR>)>>

<ROOM PASSAGE-1
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "tower passage")
	(ADJECTIVE ;GROUND SECRET TOWER)
	(SYNONYM PASSAGE ENTRANCE LANDING)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL LADDER STAIRS)
	(LINE 4)
	(STATION PASSAGE-1)
	(CHARACTER 2)
	(SW	TO SECRET-LANDING-JACK)
	(WEST	TO SECRET-LANDING-JACK)
	(OUT	TO SECRET-LANDING-JACK)
	(EAST	TO SITTING-PASSAGE)
	(DOWN	TO SITTING-PASSAGE)
	(IN	TO SECRET-LANDING-TAM)
	(UP	TO SECRET-LANDING-TAM)
	(ACTION PASSAGE-1-F)>

<ROUTINE PASSAGE-1-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL
"Stone steps lead west, a " 'PASSAGE " leads east, and a ladder leads
straight up" ,INTO-DARKNESS>
	<RTRUE>)
       ;(<EQUAL? .RARG ,P?EAST ,P?DOWN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,P?WEST ,P?OUT ,P?SW>
	<TELL ,STAIRS-UP-RIGHT>
	<RTRUE>)>>

<ROOM SECRET-LANDING-TAM
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "Tamara's landing")
	(ADJECTIVE SECRET TAM\'S HER)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-TAMARA-DOOR TAMARA-ROOM LEVER LADDER STAIRS)
	(LINE 4)
	(STATION SECRET-LANDING-TAM)
	(CHARACTER 3)
	(WEST	TO TAMARA-ROOM IF SECRET-TAMARA-DOOR IS OPEN)
	(NW	TO TAMARA-ROOM IF SECRET-TAMARA-DOOR IS OPEN)
	(OUT	TO TAMARA-ROOM IF SECRET-TAMARA-DOOR IS OPEN)
	(IN	TO TAMARA-ROOM IF SECRET-TAMARA-DOOR IS OPEN)
	(EAST	TO SECRET-VIVIEN-PASSAGE)
	(DOWN	TO PASSAGE-1)
	(NE	TO SECRET-LANDING-LIB)
	(NORTH	TO SECRET-LANDING-LIB)
	(ACTION SECRET-LANDING-TAM-F)>

<ROUTINE SECRET-LANDING-TAM-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,TAMARA-ROOM>
	<LEVER-AND-DOOR ,SECRET-TAMARA-DOOR ,P?IN>
	<TELL ,SECRET-TAM-LIB "north" ,INTO-DARKNESS>)>>

<ROOM SECRET-VIVIEN-PASSAGE
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "Vivien's entrance")
	(ADJECTIVE SECRET VIV\'S HER)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-VIVIEN-DOOR VIVIEN-ROOM LEVER)
	(LINE 4)
	(STATION SECRET-LANDING-TAM)
	(CHARACTER 3)
	(WEST	TO SECRET-LANDING-TAM)
	(EAST	TO YOUR-CLOSET)
	(NORTH	TO VIVIEN-ROOM IF SECRET-VIVIEN-DOOR IS OPEN)
	(IN	TO VIVIEN-ROOM IF SECRET-VIVIEN-DOOR IS OPEN)
	(OUT	TO VIVIEN-ROOM IF SECRET-VIVIEN-DOOR IS OPEN)
	(ACTION SECRET-VIVIEN-PASSAGE-F)>

<ROUTINE SECRET-VIVIEN-PASSAGE-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,VIVIEN-ROOM>
	<LEVER-AND-DOOR ,SECRET-VIVIEN-DOOR ,P?NORTH>
	<TELL "A " 'PASSAGE " leads west and east" ,INTO-DARKNESS>)
       (<==? .RARG ,P?EAST>
	<TELL
"The " 'PASSAGE " turns north at the corner of the building." CR>)>>

<ROOM DINING-PASSAGE
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "dining passage")
	(ADJECTIVE SECRET DINING)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-DINING-DOOR BACKSTAIRS LADDER STAIRS LEVER)
	(LINE 4)
	(STATION SECRET-LANDING-LIB)
	(CHARACTER 2)
	(UP	TO SECRET-LANDING-LIB)
	(EAST	TO BACKSTAIRS IF SECRET-DINING-DOOR IS OPEN)
	(IN	TO BACKSTAIRS IF SECRET-DINING-DOOR IS OPEN)
	(OUT	TO BACKSTAIRS IF SECRET-DINING-DOOR IS OPEN)
	(ACTION DINING-PASSAGE-F)>

<ROUTINE DINING-PASSAGE-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<LEVER-AND-DOOR ,SECRET-DINING-DOOR ,P?EAST>
	<TELL "A ladder leads up" ,INTO-DARKNESS>
	<RTRUE>)>>

<ROOM SECRET-LANDING-LIB
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "library landing")
	(ADJECTIVE SECRET LIBRARY)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-LIBRARY-DOOR LIBRARY LEVER LADDER STAIRS)
	(LINE 4)
	(STATION SECRET-LANDING-LIB)
	(CHARACTER 3)
	(WEST	TO LIBRARY IF SECRET-LIBRARY-DOOR IS OPEN)
	(SW	TO LIBRARY IF SECRET-LIBRARY-DOOR IS OPEN)
	(IN	TO LIBRARY IF SECRET-LIBRARY-DOOR IS OPEN)
	(OUT	TO LIBRARY IF SECRET-LIBRARY-DOOR IS OPEN)
	(EAST	TO SECRET-IAN-PASSAGE)
	(SOUTH	TO SECRET-LANDING-TAM)
	;(SE	TO SECRET-LANDING-TAM)
	(DOWN	TO DINING-PASSAGE)
	(ACTION SECRET-LANDING-LIB-F)>

<ROUTINE SECRET-LANDING-LIB-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,LIBRARY>
	<LEVER-AND-DOOR ,SECRET-LIBRARY-DOOR ,P?IN>
	<TELL ,SECRET-TAM-LIB "south" ,INTO-DARKNESS>)>>

<GLOBAL SECRET-TAM-LIB
	"A ladder leads down, a passage leads east, and a walkway leads ">

<ROOM SECRET-IAN-PASSAGE
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT VOWELBIT)
	(DESC "Ian's entrance")
	(ADJECTIVE SECRET IAN\'S HIS)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-IAN-DOOR IAN-ROOM LEVER)
	(LINE 4)
	(STATION SECRET-IAN-PASSAGE)
	(CHARACTER 3)
	(WEST	TO SECRET-LANDING-LIB)
	(EAST	TO HYDE-CLOSET)
	(SOUTH	TO IAN-ROOM IF SECRET-IAN-DOOR IS OPEN)
	(IN	TO IAN-ROOM IF SECRET-IAN-DOOR IS OPEN)
	(OUT	TO IAN-ROOM IF SECRET-IAN-DOOR IS OPEN)
	(ACTION SECRET-IAN-PASSAGE-F)>

<ROUTINE SECRET-IAN-PASSAGE-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,IAN-ROOM>
	<LEVER-AND-DOOR ,SECRET-IAN-DOOR ,P?SOUTH>
	<TELL ,PASSAGE-EAST-WEST>
	<RTRUE>)>>

<GLOBAL PASSAGE-EAST-WEST "The passage leads east and west into darkness.|">

<ROOM SITTING-PASSAGE
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "sitting passage")
	(ADJECTIVE SECRET SITTING)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-SITTING-DOOR ;"SITTING-ROOM ;LEVER ;LADDER")
	(LINE 4)
	(STATION PASSAGE-1)
	(CHARACTER 2)
	(WEST	TO PASSAGE-1)
	(IN	TO PASSAGE-1)
	(OUT	TO PASSAGE-1)
	(UP	PER SITTING-PASSAGE-LOSE)
	;(UP	TO SITTING-ROOM IF SECRET-SITTING-DOOR IS OPEN)
	(ACTION SITTING-PASSAGE-F)>

<ROUTINE SITTING-PASSAGE-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<FSET ,SECRET-SITTING-DOOR ,SEENBIT>
	<PASSAGE-DESC? ,SITTING-ROOM>
	<SITTING-PASSAGE-LOSE>
	<TELL "A " 'PASSAGE " leads up to the west" ,INTO-DARKNESS>)>>

<ROUTINE SITTING-PASSAGE-LOSE ()
	<TELL
CTHE ,SECRET-SITTING-DOOR " is overhead, too high to climb through.|">
	<RFALSE>>

<ROOM YOUR-CLOSET
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "your entrance")
	(ADJECTIVE MY SECRET)
	(SYNONYM ENTRANCE SPACE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-YOUR-DOOR YOUR-ROOM STAIRS LEVER)
	(LINE 4)
	(STATION YOUR-CLOSET)
	(CHARACTER 3)
	(SOUTH	TO SECRET-VIVIEN-PASSAGE)
	(IN	TO YOUR-ROOM IF SECRET-YOUR-DOOR IS OPEN)
	(OUT	TO YOUR-ROOM IF SECRET-YOUR-DOOR IS OPEN)
	(WEST	TO YOUR-ROOM IF SECRET-YOUR-DOOR IS OPEN)
	(NORTH	TO IRIS-CLOSET)
	(DOWN	TO DRAWING-CLOSET)
	(ACTION YOUR-CLOSET-F)>

<ROUTINE YOUR-CLOSET-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,YOUR-ROOM>
	<TELL "The " 'PASSAGE " leads north and south. ">
	<LEVER-AND-DOOR ,SECRET-YOUR-DOOR ,P?WEST>
	<TELL "A narrow stairway snakes down" ,INTO-DARKNESS>)
       (<==? .RARG ,P?SOUTH>
	<TELL
"The " 'PASSAGE " turns west at the corner of the building." CR>)>>

<ROUTINE PASSAGE-DESC? (RM)
 <COND (<EQUAL? ,HERE <GET ,FOUND-PASSAGES ,PLAYER-C>>
	<TELL
"This is a musty and cobwebby " 'PASSAGE " between the wall of" THE .RM
" and the outside wall of the castle." CR>)>>

<ROOM IRIS-CLOSET
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "Iris's entrance")
	(ADJECTIVE IRIS\'S HER SECRET)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-IRIS-DOOR IRIS-ROOM LEVER ;LADDER)
	(LINE 4)
	(STATION IRIS-CLOSET)
	(CHARACTER 3)
	(NORTH	TO WENDISH-CORNER)
	(SOUTH	TO YOUR-CLOSET)
	(WEST	TO IRIS-ROOM IF SECRET-IRIS-DOOR IS OPEN)
	(IN	TO IRIS-ROOM IF SECRET-IRIS-DOOR IS OPEN)
	(OUT	TO IRIS-ROOM IF SECRET-IRIS-DOOR IS OPEN)
	(ACTION IRIS-CLOSET-F)>

<ROUTINE IRIS-CLOSET-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-BEG>
	<COND (<IN? ,COSTUME ,IRIS-CLOSET>
	       <FCLEAR ,COSTUME ,SECRETBIT>
	       <RFALSE>)>)
       (<==? .RARG ,M-LOOK>
	<LEVER-AND-DOOR ,SECRET-IRIS-DOOR ,P?WEST>
	<TELL "The " 'PASSAGE " leads north and south" ,INTO-DARKNESS>)
       (<==? .RARG ,P?NORTH>
	<TELL
"The " 'PASSAGE " turns west at the corner of the building." CR>)>>

<ROOM WENDISH-CORNER
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "Wendish's entrance")
	(ADJECTIVE SECRET DOC\'S HIS)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-WENDISH-DOOR WENDISH-ROOM LEVER)
	(LINE 4)
	(STATION WENDISH-CORNER)
	(CHARACTER 3)
	(EAST	TO IRIS-CLOSET)
	(WEST	TO MIDPOINT)
	(SOUTH	TO WENDISH-ROOM IF SECRET-WENDISH-DOOR IS OPEN)
	(IN	TO WENDISH-ROOM IF SECRET-WENDISH-DOOR IS OPEN)
	(OUT	TO WENDISH-ROOM IF SECRET-WENDISH-DOOR IS OPEN)
	(ACTION WENDISH-CORNER-F)>

<ROUTINE WENDISH-CORNER-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,WENDISH-ROOM>
	<LEVER-AND-DOOR ,SECRET-WENDISH-DOOR ,P?SOUTH>
	<TELL ,PASSAGE-EAST-WEST>
	<RTRUE>)
       (<==? .RARG ,P?EAST>
	<TELL
"The " 'PASSAGE " turns south at the corner of the building." CR>)>>

<ROOM MIDPOINT
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "midpoint")
	(SYNONYM MIDPOINT)
	(LINE 4)
	(STATION MIDPOINT)
	(CHARACTER 3)
	(SOUTH	TO GALLERY-CORNER)
	(EAST	TO WENDISH-CORNER)
	(OUT	TO WENDISH-CORNER)
	(WEST	TO HYDE-CLOSET)
	(ACTION MIDPOINT-F)>

<ROUTINE MIDPOINT-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"At the " 'MIDPOINT " of the " 'PASSAGE ", another " 'PASSAGE " leads south. "
,PASSAGE-EAST-WEST>
	<RTRUE>)>>

<ROOM DRAWING-CLOSET
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "drawing-room entrance")
	(ADJECTIVE DRAWING SECRET)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-DRAWING-DOOR DRAWING-ROOM LEVER LADDER STAIRS)
	(LINE 4)
	(STATION DRAWING-CLOSET)
	(CHARACTER 2)
	(UP	TO YOUR-CLOSET)
	(NORTH	TO DRAWING-ROOM IF SECRET-DRAWING-DOOR IS OPEN)
	(IN	TO DRAWING-ROOM IF SECRET-DRAWING-DOOR IS OPEN)
	(OUT	TO DRAWING-ROOM IF SECRET-DRAWING-DOOR IS OPEN)
	(ACTION DRAWING-CLOSET-F)>

<ROUTINE DRAWING-CLOSET-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<PASSAGE-DESC? ,DRAWING-ROOM>
	<LEVER-AND-DOOR ,SECRET-DRAWING-DOOR ,P?NORTH>
	<TELL "A narrow stairway snakes up" ,INTO-DARKNESS>
	<RTRUE>)>>

<ROOM GALLERY-CORNER
	(IN ROOMS)
	(FLAGS SECRETBIT)
	(DESC "dead end")
	(ADJECTIVE SECRET HIDDEN DEAD)
	(SYNONYM ENTRANCE LANDING PASSAGE END)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL PEEPHOLE)
	(CORRIDOR 2)
	(LINE 4)
	(STATION MIDPOINT)
	(CHARACTER 3)
	(NORTH	TO MIDPOINT)
	(OUT	TO MIDPOINT)
	(ACTION GALLERY-CORNER-F)>

<ROUTINE GALLERY-CORNER-F ("OPT" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<FCLEAR ,PEEPHOLE ,SECRETBIT>
	<TELL
CTHE ,PEEPHOLE " is in the south wall. A " 'PASSAGE " leads north." CR>)>>

<OBJECT PEEPHOLE
	(IN LOCAL-GLOBALS)
	(DESC "peephole")
	(ADJECTIVE SECRET PEEP ;PEEK)
	(SYNONYM HOLE PEEKHOLE PEEPHOLE OPENING)
	(FLAGS SECRETBIT ONBIT)
	(ACTION PEEPHOLE-F)>

<ROUTINE PEEPHOLE-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-OUTSIDE LOOK-THROUGH>
	<COND (<==? ,HERE ,GALLERY-CORNER>
	       <FCLEAR ,PEEPHOLE ,SECRETBIT>
	       <ROOM-PEEK ,GALLERY T>
	       <RTRUE>)
	      (<==? ,HERE ,GALLERY>
	       <COND (<NOT <SECRET-CHECK ,M-BEG>>
		      <ROOM-PEEK ,GALLERY-CORNER T>)>
	       <RTRUE>)>)
       (<VERB? THROUGH>
	<TOO-BAD-BUT ,PEEPHOLE "too small">
	<RTRUE>)>>

<ROOM HYDE-CLOSET
	(IN ROOMS)
	(FLAGS SECRETBIT NARTICLEBIT)
	(DESC "Hyde's entrance")
	(ADJECTIVE HYDE\'S HIS SECRET)
	(SYNONYM ENTRANCE LANDING PASSAGE)
	(GENERIC GENERIC-CLOSET)
	(GLOBAL SECRET-HYDE-DOOR HYDE-ROOM LEVER)
	(LINE 4)
	(STATION HYDE-CLOSET)
	(CHARACTER 3)
	(SOUTH	TO HYDE-ROOM IF SECRET-HYDE-DOOR IS OPEN)
	(IN	TO HYDE-ROOM IF SECRET-HYDE-DOOR IS OPEN)
	(OUT	TO HYDE-ROOM IF SECRET-HYDE-DOOR IS OPEN)
	(EAST	TO MIDPOINT)
	(WEST	TO SECRET-IAN-PASSAGE)
	(ACTION HYDE-CLOSET-F)>

<ROUTINE HYDE-CLOSET-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<LEVER-AND-DOOR ,SECRET-HYDE-DOOR ,P?SOUTH>
	<TELL ,PASSAGE-EAST-WEST>
	<RTRUE>)>>
