"GLOBALS for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

<OBJECT GLOBAL-OBJECTS
	(DESC "GO")
	;(FDESC 0)
	(TEXT 0)
	(FLAGS	CONTBIT DOORBIT FEMALE
		INVISIBLE LIGHTBIT LOCKED MUNGBIT
		NARTICLEBIT NDESCBIT ONBIT OPENBIT
		;PERSONBIT READBIT RMUNGBIT
		SEARCHBIT SECRETBIT SEENBIT SURFACEBIT
		TAKEBIT TOOLBIT TOUCHBIT TRANSBIT TRYTAKEBIT
		VEHBIT VOWELBIT WEAPONBIT WEARBIT WORNBIT)>

<OBJECT LOCAL-GLOBALS
	(IN GLOBAL-OBJECTS)
	(DESC "stone" ;"LG")
	(SYNONYM STONE ;L.G)
	(FLAGS NARTICLEBIT)
	(ACTION LOCAL-GLOBALS-F)>

<ROUTINE LOCAL-GLOBALS-F ()
 <COND (<REMOTE-VERB?>
	<RFALSE>)
       (<OR <CREEPY? ,HERE> <OUTSIDE? ,HERE>>
	<RANDOM-PSEUDO>)
       (T <NOT-HERE ,LOCAL-GLOBALS>)>>

<OBJECT STAIRS
	(IN LOCAL-GLOBALS)
	(DESC "stairs")
	(SYNONYM STAIRS STAIRW STAIR)
	(GENERIC GENERIC-STAIRS)
	(FLAGS SEENBIT)
	(ACTION UPSTAIRS-DOWNSTAIRS)>

<GLOBAL WING-STAIRS <PLTABLE KITCHEN GREAT-HALL GALLERY>>
<GLOBAL TOWER-STAIRS <PLTABLE BASEMENT OLD-GREAT-HALL CORR-2 CORR-3>>

<ROUTINE UPSTAIRS-DOWNSTAIRS ("AUX" N TBL (HR <LOC ,WINNER>))
 <COND (<VERB? BOARD CLIMB-DOWN CLIMB-UP THROUGH WALK WALK-TO>
	<COND (<FSET? .HR ,SECRETBIT>
	       <RFALSE>)
	      (<FSET? .HR ,WEARBIT> ;"WING-ROOMS"
	       <SET TBL ,WING-STAIRS>)
	      (T <SET TBL ,TOWER-STAIRS>)>
	<COND (<OR <VERB? BOARD CLIMB-UP>
		   ;<NOUN-USED? ,W?UPSTAIRS>>
	       <COND (<T? <GETPT .HR ,P?UP>>
		      <DO-WALK ,P?UP>
		      <RTRUE>)
		     (<AND <SET N <GETP .HR ,P?CHARACTER>>
			   <NOT <L? <GET .TBL 0> <SET N <+ .N 1>>>>>
		      <SET N <GET .TBL .N>>
		      ;<TELL-I-ASSUME .N " Walk to">
		      <PERFORM ,V?WALK-TO .N>
		      <RTRUE>)>)
	      (T ;<NOUN-USED? ,W?DOWNSTAIRS>
	       <COND (<T? <GETPT .HR ,P?DOWN>>
		      <DO-WALK ,P?DOWN>
		      <RTRUE>)
		     (<AND <SET N <GETP .HR ,P?CHARACTER>>
			   <L? 0 <SET N <- .N 1>>>>
		      <SET N <GET .TBL .N>>
		      ;<TELL-I-ASSUME .N " Walk to">
		      <PERFORM ,V?WALK-TO .N>
		      <RTRUE>)>)>)>>

<ROUTINE DO-INSTEAD-OF (OBJ1 OBJ2)
	<COND (<EQUAL? ,PRSI .OBJ2> <PERFORM ,PRSA ,PRSO .OBJ1> <RTRUE>)
	      (<EQUAL? ,PRSO .OBJ2> <PERFORM ,PRSA .OBJ1 ,PRSI> <RTRUE>)
	      ;(T		    <PERFORM ,PRSA ,PRSO ,PRSI> <RTRUE>)
	      (T <V-FOO>)>>

<OBJECT TURN
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE INT.NUM ;NUMBER FULL)
	(SYNONYM TURN TURNS MINUTE)
	(DESC "minute")
	(ACTION TURN-F)>

<ROUTINE TURN-F ()
 <COND (<VERB? USE>
	<PERFORM ,V?WAIT-FOR ,PRSO>
	<RTRUE>)>>

<OBJECT IT
	(IN GLOBAL-OBJECTS)
	(SYNONYM IT THIS ;"FUCKER SUCKER")
	(DESC "it")
	(FLAGS VOWELBIT NARTICLEBIT)
	(ACTION IT-F)>

<ROUTINE IT-F ()
 <COND (<OR <AND <IOBJ? IT>
		 ;<FSET? ,PRSO ,PERSONBIT>
		 <VERB? ASK-ABOUT ASK-FOR SEARCH-FOR TELL-ABOUT>>
	    <AND <DOBJ? IT>
		 <VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR FIND ;WHAT>>>
	<TELL "\"I'm not sure what you're talking about.\"" CR>)>>

<OBJECT FLOOR
	(IN GLOBAL-OBJECTS)
	(DESC "floor")
	(ADJECTIVE DRAWING ;ROOM GREAT ;HALL)
	(SYNONYM FLOOR ;AREA GROUND CARPET RUG)
	(FLAGS SEENBIT SURFACEBIT OPENBIT)
	(ACTION FLOOR-F)>

<ROUTINE FLOOR-F ("AUX" (OBJ <>) N)
 <COND ;(<REMOTE-VERB?> <RFALSE>)
       (<VERB? CLIMB-ON>
	<ALREADY ,WINNER "on it">)
       (<AND <VERB? PUT THROW-AT>
	     <NOT <DOBJ? MOONMIST>>
	     <IOBJ? FLOOR>>
	<MOVE ,PRSO ,HERE>
	<TELL "Okay." CR>
	<RTRUE>)
       (<VERB? EXAMINE LOOK-ON SEARCH SEARCH-FOR>
	<COND (<EQUAL? ,HERE ,DRAWING-ROOM>
	       <TELL
"The carpet ends flush with the archway to the " 'GREAT-HALL ",
where the footsteps of visitors have begun to wear it thin.
It's a magnificent red Brussels carpet with deep pile and a medieval
design." CR>)
	      (<EQUAL? ,HERE ,GREAT-HALL>
	       <GREAT-HALL-IS-FLOORED>)>
	<COND (<AND <EQUAL? ,HERE ,GARDEN>
		    <EQUAL? ,VARIATION ,LORD-C>
		    <FSET? ,CLUE-4 ,SECRETBIT>>
	       <SET OBJ ,CLUE-4>)
	      (<AND <EQUAL? ,HERE ,DRAWING-ROOM>
		    <EQUAL? ,VARIATION ,LORD-C ,FRIEND-C ;,OFFICER-C>
		    <NOT <FSET? ,JEWEL ,TOUCHBIT>>>
	       <SET OBJ ,JEWEL>)
	      (<AND <EQUAL? ,HERE ,GREAT-HALL>
		    <EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ,PAINTER-C>
		    <NOT <EQUAL? ,FOUND-IT-PERM ,LENS ;,LENS-1 ,LENS-2>>>
	       <SET OBJ ,LENS>)>
	<START-SEARCH .OBJ>
	<RTRUE>)
       (<ADJ-USED? ,W?DRAWING>
	<COND (<NOT <==? ,HERE ,DRAWING-ROOM>>
	       <DO-INSTEAD-OF ,DRAWING-ROOM ,FLOOR>
	       <RTRUE>)>)
       (<ADJ-USED? ,W?GREAT>
	<COND (<NOT <==? ,HERE ,GREAT-HALL>>
	       <DO-INSTEAD-OF ,GREAT-HALL ,FLOOR>
	       <RTRUE>)>)>>

<ROUTINE START-SEARCH ("OPTIONAL" (OBJ <>))
	<TELL
"Nothing suspicious meets your eye after a moment's scrutiny. Do you want
to continue?">
	<COND (<NOT <YES?>>
	       <OKAY>
	       <RTRUE>)
	      (T
	       <COND (T ;<T? .OBJ>
		      <SETG FOUND-IT .OBJ>)>
	       <SETG FOUND-LOC ,HERE>
	       <QUEUE I-FOUND-IT <RANDOM 7>>
	       <V-WAIT 8 <> T>
	       <RTRUE>)>>

<GLOBAL FOUND-IT:OBJECT <>>
<GLOBAL FOUND-IT-PERM:OBJECT <>>
<GLOBAL FOUND-LOC:OBJECT <>>
<GLOBAL NOTHING-NEW "You don't find anything new there.|">

<ROUTINE I-FOUND-IT ("OPTIONAL" (GARG <>) "AUX" OBJ)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-FOUND-IT:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND (<NOT <EQUAL? ,FOUND-LOC ,HERE>>
	       <RFALSE>)
	      (<EQUAL? ,FOUND-IT ,JEWEL>
	       <MOVE ,FOUND-IT ,HERE>
	       <TELL
"Suddenly you notice a glittering speck. Probing for it with your fingers,
you discover a " 'JEWEL "." ;"extract from the strands of carpet pile" CR>)
	      (<EQUAL? ,FOUND-IT ,LENS>
	       <COND (<NOT <FSET? ,LENS ,SEENBIT>>
		      <MOVE ,LENS-2 <LOC ,LENS>>
		      ;<REMOVE ,LENS>)
		     (<NOT <FSET? ,LENS-2 ,SEENBIT>>
		      <SETG FOUND-IT ,LENS-2>
		      <MOVE ,LENS-1 <LOC ,LENS>>
		      <REMOVE ,LENS>)
		     (T <RFALSE>)>
	       <MOVE ,FOUND-IT ,HERE>
	       <TELL
"Suddenly you find something small, smooth and slippery -- a "
D ,FOUND-IT "! Its transparency, of course, made it practically invisible.">
	       <COND (<T? ,BUTLER-GHOST-STORY-TOLD>
		      <TELL
" No wonder you and the ghost had such a hard time finding it!">)>
	       <CRLF>)
	      (<ZERO? ,FOUND-IT>
	       <TELL ,NOTHING-NEW>
	       <RFATAL>)
	      (<FSET? ,FOUND-IT ,SECRETBIT>
	       ;<SET OBJ <FIND-FLAG ,HERE ,SECRETBIT>>
	       <DISCOVER ,FOUND-IT ;.OBJ>
	       ;<RFATAL>)
	      (T
	       <TELL
!\Y ,OU-STOP-SEARCHING " when you find" THE ,FOUND-IT ".|">)>
	<COND (T ;<NOT <EQUAL? ,FOUND-IT ,MOONMIST ,YOUR-SWITCH>>
	       ;<MOVE ,FOUND-IT ,PLAYER>
	       <FSET ,FOUND-IT ,TOUCHBIT>)>
	<FSET ,FOUND-IT ,SEENBIT>
	<COND (<NOT <EQUAL? ,FOUND-IT ,YOUR-SWITCH>>
	       <FCLEAR ,FOUND-IT ,NDESCBIT>)>
	<COND (<EQUAL? ,FOUND-IT ,LENS ;,LENS-1 ,LENS-2>
	       <SETG FOUND-IT-PERM ,FOUND-IT>)>
	<SETG FOUND-IT <>>
	<RFATAL>>

<OBJECT DANGER
	(IN GLOBAL-OBJECTS)
	(DESC "danger")
	(SYNONYM DANGER THREAT ATTACK)>

<OBJECT INTNUM
	(IN GLOBAL-OBJECTS)
	(SYNONYM INT.NUM ;NUMBER)
	(DESC "number")>

<OBJECT YOU
	(IN GLOBAL-OBJECTS)
	(SYNONYM YOU YOURSELF HIMSELF HERSELF)
	(DESC "self" ;"himself or herself")
	(FLAGS ;NARTICLEBIT)
	(ACTION YOU-F)>

<ROUTINE YOU-F ("AUX" X)
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<DO-INSTEAD-OF ,WINNER ,YOU>
	<RTRUE>)
       (<AND <VERB? ASK-ABOUT> <IOBJ? YOU>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSO>
	<RTRUE>)
       (<AND <VERB? THANKS>
	     <SET X <QCONTEXT-GOOD?>>>
	<PERFORM ,V?THANKS .X>
	<RTRUE>)>>

;<OBJECT HINT
	(DESC "hint")
	(IN GLOBAL-OBJECTS)
	(SYNONYM HINT HELP)
	(ACTION HINT-F)>

;<ROUTINE HINT-F ()
 <COND (<VERB? FIND>
	<HELP-TEXT>)
       (<VERB? ASK-FOR ASK-CONTEXT-FOR TAKE>
	<MORE-SPECIFIC>)>>

;<OBJECT CORRIDOR-GLOBAL
	(IN GLOBAL-OBJECTS)
	(DESC "corridor")
	(SYNONYM CORRIDOR)
	(ACTION CORRIDOR-GLOBAL-F)>

;<ROUTINE CORRIDOR-GLOBAL-F ("AUX" RM)
 <COND (<VERB? ANALYZE EXAMINE LOOK-INSIDE LOOK-DOWN LOOK-UP>
	<COND (<SET RM <NEXT-ROOM ,HERE ,P?OUT>>
	       <ROOM-PEEK .RM T>)>)>>

<OBJECT WALL
	(IN GLOBAL-OBJECTS)
	(DESC "wall")
	(ADJECTIVE CASTLE TOWER BRICK)
	(SYNONYM WALL WALLS BRICK BRICKS)
	(FLAGS SEENBIT SURFACEBIT OPENBIT)
	(ACTION WALL-F)>

<ROUTINE WALL-F ("AUX" OBJ)
 <COND (<AND <EQUAL? ,VARIATION ,FRIEND-C>
	     <EQUAL? ,HERE ,BASEMENT ,CRYPT>
	     ;<VERB? ;DIG EXAMINE KNOCK MUNG OPEN RUB SEARCH>>
	<BRICKS-F>)
       (<AND <VERB? OPEN CLOSE>
	     <T? <SET OBJ <FIND-FLAG-LG ,HERE ,DOORBIT ,SECRETBIT>>>>
	<DO-INSTEAD-OF .OBJ ,WALL>
	<RTRUE>)
       (<VERB? KNOCK>
	<COND (<OR <NOT <FSET? ,HERE ,WEARBIT> ;"WING-ROOMS">
		   <FIND-FLAG-LG ,HERE ,DOORBIT ,SECRETBIT>>
	       <TELL "You hear a hollow sound." CR>)
	      (T <TELL
"Knocking on the walls reveals nothing unusual." CR>)>)>>

<OBJECT GLOBAL-HERE
	(IN GLOBAL-OBJECTS)
	(DESC "here")
	(ADJECTIVE THIS)
	(SYNONYM HERE AREA ROOM PLACE)
	(GENERIC GENERIC-ROOM)
	(FLAGS NARTICLEBIT)
	(ACTION GLOBAL-HERE-F)>

<ROUTINE GLOBAL-HERE-F ("AUX" OBJ (X <>))
 <COND (<VERB? EXAMINE LIE SIT SMELL WALK-TO>
	<DO-INSTEAD-OF ,HERE ,GLOBAL-HERE>
	<RTRUE>)
       (<VERB? PUT PUT-IN ;TIE-TO>
	<MORE-SPECIFIC>)
       (<VERB? SEARCH SEARCH-FOR>
	<COND (<AND <IN? ,MAGAZINE ,HERE>
		    ;<EQUAL? ,VARIATION ,PAINTER-C>
		    <FSET? ,MAGAZINE ,NDESCBIT>>
	       <SET X ,MAGAZINE>)
	      (<AND <IN? ,BRICKS ,HERE>
		    ;<EQUAL? ,VARIATION ,FRIEND-C>
		    <FSET? ,BRICKS ,NDESCBIT>>
	       <SET X ,BRICKS>)
	      ;(<AND <EQUAL? ,HERE ,COURTYARD>
		    <SET X <FIRST? ,FRONT-GATE>>>	;"for CLUE-4"
	       T)
	      (<AND <T? ,PRSI>
		    <==? <META-LOC ,PRSI> ,HERE>>
	       <SET X ,PRSI>)
	      (T
	       <SET OBJ <FIRST? ,HERE>>
	       <REPEAT ()
		       <COND (<ZERO? .OBJ>
			      <RETURN>)
			     (<FSET? .OBJ ,SECRETBIT>
			      <SET X .OBJ>
			      <RETURN>)
			     (<AND <NOT <FSET? .OBJ ,PERSONBIT>>
				   <OR <FSET? .OBJ ,CONTBIT>
				       <FSET? .OBJ ,SURFACEBIT>>
				   <OR <SET X <FIND-FLAG .OBJ ,SECRETBIT>>
				       <SET X <FIND-FLAG .OBJ ,RMUNGBIT>>>>
			      <FSET .OBJ ,OPENBIT>
			      <RETURN>)
			     (T <SET OBJ <NEXT? .OBJ>>)>>)>
	<START-SEARCH .X>
	<RTRUE>)>>

<OBJECT CHAIR
	(IN LOCAL-GLOBALS)
	(DESC "chair")
	(ADJECTIVE WING)
	(SYNONYM CHAIR SEAT CHAIRS BENCH)
	(FLAGS SEENBIT SURFACEBIT ;VEHBIT)
	(ACTION CHAIR-F)>

<ROUTINE CHAIR-F () ;("OPT" (ARG 0))
 <COND ;(<T? .ARG> <RFALSE>)
       (<VERB? SIT ;LOOK-UNDER CLIMB-ON ;CLIMB-DOWN BOARD>
	<WONT-HELP>
	;<SETG PLAYER-SEATED ,CHAIR>
	;<TELL "Okay." ;"That's just a waste of time." CR>)
       (T <RANDOM-PSEUDO>)>>

<OBJECT TABLE-RANDOM
	(IN LOCAL-GLOBALS)
	(DESC "table")
	(ADJECTIVE BILLIARD CARD)
	(SYNONYM TABLE DESK)
	(FLAGS SEENBIT)
	(ACTION RANDOM-PSEUDO)>

[
<OBJECT TWEED-OUTFIT
	(IN PLAYER)
	(DESC "tweed outfit")
	(ADJECTIVE MY TWEED WOOLEN WOOL)
        (SYNONYM CLOTHES OUTFIT TWEEDS SUIT ;" SWEATER CLOTHING")
	(GENERIC GENERIC-CLOTHES)
	(FLAGS WORNBIT WEARBIT TAKEBIT MUNGBIT SEENBIT)
	(SIZE 20)
	(ACTION CLOTHES-FCN)>

<OBJECT SLEEP-OUTFIT
	(IN LUGGAGE)
	(DESC "nightshirt" ;"set of pajamas, sleeping outfit")
	(ADJECTIVE MY NIGHT F.C F.C ;" FINE INDIAN SILK SLEEPING")
        (SYNONYM CLOTHES OUTFIT NIGHTS SHIRT ;" PAJAMA NIGHTG")
	(GENERIC GENERIC-CLOTHES)
	(FLAGS WEARBIT TAKEBIT)
	(SIZE 20)
	(ACTION CLOTHES-FCN)>

<OBJECT EXERCISE-OUTFIT
	(IN LUGGAGE)
	(DESC "exercise outfit")
	(ADJECTIVE MY EXERCISE F.C F.C ;"COTTON COMFORT RUNNING")
        (SYNONYM CLOTHES OUTFIT SWEATS SUIT ;"SHOES CLOTHING")
	(GENERIC GENERIC-CLOTHES)
	(FLAGS WEARBIT TAKEBIT VOWELBIT)
	(SIZE 20)
	(ACTION CLOTHES-FCN)>

<OBJECT DINNER-OUTFIT
	(IN LUGGAGE)
	(DESC "dinner outfit")
	(ADJECTIVE MY DINNER FORMAL F.C F.C ;"FRILLY PERFECT")
        (SYNONYM CLOTHES OUTFIT ;"ENSEMBLE CLOTHING" DRESS GOWN)
	(GENERIC GENERIC-CLOTHES)
	(FLAGS WEARBIT TAKEBIT)
	(SIZE 20)
	(ACTION CLOTHES-FCN)>

<ROUTINE CLOTHES-FCN ()
 <COND (<VERB? EXAMINE LOOK-INSIDE>
	<COND (<DOBJ? TWEED-OUTFIT>
	       <TELL
"These are sensible clothes for this clammy climate: your new tweed ">
	       <COND (<ZERO? ,GENDER-KNOWN>
		      <TELL "suit">)
		     (T
		      <TELL "blazer and ">
		      <COND (<FSET? ,PLAYER ,FEMALE> <TELL "skirt">)
			    (T <TELL "pants">)>)>
	       <TELL ", with woolen sweater, should keep you warm enough.">)
	      (<DOBJ? EXERCISE-OUTFIT>
	       <TELL
"This is your favorite outfit for workouts: a cotton sweatsuit with a sporty ">
	       <COND (<PRINT-COLOR> <TELL !\ >)>
	       <TELL "stripe." ;", and comfortable running shoes.">)
	      (<DOBJ? DINNER-OUTFIT>
	       <COND (<ZERO? ,GENDER-KNOWN>
		      <TELL
"You have a decent formal ensemble, with frills in the right places">)
		     (T
		      <TELL "Your new ">
		      <COND (<FSET? ,PLAYER ,FEMALE>
			     <TELL "floor-length dinner gown">)
			    (T <TELL "tuxedo">)>
		      <TELL " is particularly good-looking">)>
	       <TELL " and a perfect fit">
	       <COND (<NOT <0? ,VARIATION>>
		      <TELL ", ">
		      <COND (<FSET? ,PLAYER ,FEMALE>
			     <TELL "not to mention that it's all">)
			    (T <TELL "with shirt and accessories">)>
		      <TELL " in ">
		      <PRINT-COLOR>)>
	       <TELL ".">)
	      (T ;<DOBJ? SLEEP-OUTFIT>
	       <TELL "Your new ">
	       <COND (<PRINT-COLOR> <TELL !\ >)>
	       <TELL D ,SLEEP-OUTFIT ;"nightshirt" " is ">
	       <COND (<ZERO? ,GENDER-KNOWN>
		      <TELL
"nothing to write home about, but it is so-o-o comfy for sleeping.">)
		     (<FSET? ,PLAYER ,FEMALE>
		      <TELL "made of fine Chinese silk.">)
		     (T <TELL "decorated with a Union Jack flag.">)>)>
	<CRLF>)
       (<VERB? DISEMBARK ;TAKE>	;"GET OUT OF MY CLOTHES"
	<PERFORM ,V?TAKE-OFF ,PRSO>
	<RTRUE>)
       (<VERB? EMPTY>		;"UNPACK MY CLOTHES"
	<COND (<EQUAL? <META-LOC ,LUGGAGE> ,HERE>
	       <PERFORM ,V?EMPTY ,LUGGAGE>
	       <RTRUE>)
	      (T <NOT-HERE ,LUGGAGE>)>)>>
]
<OBJECT SLEEP-GLOBAL
	(IN GLOBAL-OBJECTS)
	;(ADJECTIVE ;SOME MY)
	(SYNONYM SLEEP)
	(DESC "sleep")
	(FLAGS NARTICLEBIT)
	(ACTION SLEEP-GLOBAL-F)>

<ROUTINE SLEEP-GLOBAL-F ()
 <COND (<VERB? DRESS ;-FOR>
	<COND (<EQUAL? ,HERE <META-LOC ,SLEEP-OUTFIT>>
	       <PERFORM ,V?WEAR ,SLEEP-OUTFIT>
	       <RTRUE>)>)
       (<VERB? WALK-TO>
	<PERFORM ,V?FAINT>
	<RTRUE>)>>

<GLOBAL NOW-WEARING:OBJECT TWEED-OUTFIT>

<ROUTINE ROB (WHAT THIEF "OPTIONAL" (TELL? <>) "AUX" N X (TOLD? <>))
	 <SET X <FIRST? .WHAT>>
	 <REPEAT ()
		 <COND (<NOT .X> <RETURN>)>
		 <SET N <NEXT? .X>>
		 ;<COND (<NOT <FSET? .X ,TAKEBIT>>
			<SET X .N>
			<AGAIN>)>
		 <COND (<AND <NOT .N> .TOLD? .TELL?>
			<TELL " and">)>
		 <SET TOLD? T>
		 <COND (.TELL?
			<TELL THE .X>
			<COND (.N <TELL !\,>)
			      (T <TELL ". ">)>)>
		 <MOVE .X .THIEF>
		 ;<FCLEAR .X ,TAKEBIT>
		 <SET X .N>>>

<OBJECT LIGHT-GLOBAL 
	(IN GLOBAL-OBJECTS)
	(DESC "light")
	(ADJECTIVE FLOOD MOON)
	(SYNONYM LIGHT LIGHTS LAMP MOONLIGHT)
	(FLAGS SEENBIT TRYTAKEBIT)
	(ACTION LIGHT-GLOBAL-F)>

<ROUTINE LIGHT-GLOBAL-F ("AUX" P)
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<VERB? LAMP-ON LAMP-OFF>
	<COND (<CREEPY? ,HERE>
	       <COND (<ACCESSIBLE? ,LAMP>
		      <PERFORM ,PRSA ,LAMP>
		      <RTRUE>)
		     (T <NOT-HERE ,LIGHT-GLOBAL>)>)
	      (<AND <OUTSIDE? ,HERE> ;<NOT <EQUAL? ,HERE ,CAR>>>
	       <TELL "You can't reach it from here." CR>)
	      (<VERB? LAMP-ON>
	       <COND (<FSET? ,HERE ,ONBIT>
		      <ALREADY ,LIGHT-GLOBAL "on">)
		     (T
		      <FSET ,HERE ,ONBIT>
		      <OKAY ,LIGHT-GLOBAL "on">)>)
	      (<VERB? LAMP-OFF>
	       <COND (<NOT <FSET? ,HERE ,ONBIT>>
		      <ALREADY ,LIGHT-GLOBAL "off">)
		     (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,PLAYER>>
		      <TELL
D .P " says, \"Please don't leave us in the dark.\"" CR>)
		     (T
		      <FCLEAR ,HERE ,ONBIT>
		      <OKAY ,LIGHT-GLOBAL "off">)>)>)>>

<OBJECT HAUNTING
	(DESC "haunting")
	(IN OFFICE)
	(SYNONYM MYSTERY HAUNTING ATTEMPTS CASE)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION HAUNTING-F)>

<ROUTINE HAUNTING-F ()
 <COND (<VERB? LAMP-ON PLAY>
	<PERFORM ,PRSA ,COMPUTER>
	<RTRUE>)>>

<OBJECT KEYHOLE
	(IN GLOBAL-OBJECTS)
	(DESC "keyhole")
	(ADJECTIVE MY TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S)
	(SYNONYM KEYHOLE HOLE)
	;(FLAGS NARTICLEBIT ;PLURALBIT)
	(ACTION KEYHOLE-F)>

<ROUTINE KEYHOLE-F ("AUX" P RM)
 <COND (<AND <REMOTE-VERB?>
	     <NOT <VERB? SEARCH SEARCH-FOR>>>
	<RFALSE>)
       (<ADJ-USED? <>>
	;<ZERO? ,P-ADJN>
	<COND (<ZMEMQ ,HERE ,CHAR-ROOM-TABLE>
	       <SET RM <GET-REXIT-ROOM <GETPT ,HERE ,P?OUT>>>)
	      (<OR <EQUAL? ,HERE ,CORR-2>
		   <EQUAL? ,HERE ,WEST-HALL ,GALLERY ,EAST-HALL>>
	       <TELL ,YOU-DIDNT-SAY-W "hose " 'KEYHOLE "!]" CR>
	       <RTRUE>)
	      (T <NOT-HERE ,KEYHOLE> <RTRUE>)>)
       (<OR <SET P <ZMEMQ <ADJ-USED?> ;,P-ADJN ,CHAR-POSS-TABLE>>
	    ;<AND <==? <ADJ-USED?> ,OTHER-POSS>
		 <SET P <GETP ,OTHER-CHAR ,P?CHARACTER>>>>
	<SET RM <GET ,CHAR-ROOM-TABLE .P>>
	<COND (<EQUAL? ,HERE .RM>
	       <SET RM <GET-REXIT-ROOM <GETPT ,HERE ,P?OUT>>>)
	      (<NOT <EQUAL? ,HERE <GET-REXIT-ROOM <GETPT .RM ,P?OUT>>>>
	       <NOT-HERE ,KEYHOLE>
	       <RTRUE>)>)>
 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-THROUGH SEARCH SEARCH-FOR>
	<COND (<AND <EQUAL? ,JACK-ROOM ,HERE .RM>
		    <EQUAL? ,VARIATION ,LORD-C>>
	       <TELL
"You see a microphone with its wires leading toward the " 'CREST "." CR>
	       ;<TELL
"Total darkness greets your eye. Something is obstructing your view
through the " 'KEYHOLE "." CR>)
	      (T <ROOM-PEEK .RM T>)>
	<RTRUE>)>>
[
<OBJECT HANDS
	(IN GLOBAL-OBJECTS)
	(DESC "hand" ;"your hands")
	(ADJECTIVE TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S MY
		   ;"ordering same as HEAD & EYE for UN/DRESS-GHOST"
		   ;" B\'S DEE\'S")
	(SYNONYM HANDS HAND)
	(FLAGS TRYTAKEBIT ;NARTICLEBIT ;PLURALBIT SEENBIT)
	(ACTION HANDS-F)>

<ROUTINE HANDS-F ("AUX" P A)
 <COND (<NOT <SET P <FIND-BODY ,HANDS>>>
	<RTRUE>)
       (<REMOTE-VERB?>
	<RFALSE>)>
 <COND ;(<EQUAL? .P ,PLAYER>
	<COND (<VERB? BRUSH>
	       <RFALSE>)>)
       (<VERB? KISS>
	<COND (<AND <FSET? .P ,FEMALE>
		    <T? ,GENDER-KNOWN>
		    <NOT <FSET? ,PLAYER ,FEMALE>>>
	       <PERFORM ,V?HELLO .P>)
	      (T
	       <PERFORM ,V?KISS .P>)>
	<RTRUE>)
       (<AND <VERB? SHAKE TAKE> <DOBJ? HANDS>>
	<COND (<T? ,PRSI> ;<ZERO? .P>
	       <SET P ,PRSI>)>
	;<COND (<ZERO? .P>
	       <COND ;(<ADJ-USED? ,W?HER>
		      <SET P <FIND-FLAG-HERE-BOTH ,PERSONBIT ,FEMALE ,WINNER>>
		      <COND (<ZERO? .P>
			     <TELL "There's no woman here!" CR>
			     <RTRUE>)>)
		     ;(<ADJ-USED? ,W?HIS>
		      <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,FEMALE ,WINNER>>
		      <COND (<ZERO? .P>
			     <TELL "There's no man here!" CR>
			     <RTRUE>)>)
		     (T
		      <SET P <FIND-FLAG-HERE ,PERSONBIT ,WINNER>>
		      <COND (<ZERO? .P>
			     <TELL "There's no one here!" CR>
			     <RTRUE>)>)>)>
	<PERFORM ,V?HELLO .P>
	<RTRUE>)>>

<OBJECT HEAD
	(IN GLOBAL-OBJECTS)
	(DESC "head" ;"your head")
	(ADJECTIVE TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S B\'S
		   ;" MY DEE\'S")
	(SYNONYM HEAD ;FACE)
	(FLAGS ;NARTICLEBIT SEENBIT)
	(ACTION HEAD-F)>

<ROUTINE HEAD-F ("AUX" P P2)
 <COND (<NOT <SET P <FIND-BODY ,HEAD>>>
	<RTRUE>)
       (<REMOTE-VERB?>
	<RFALSE>)
       ;(<AND <EQUAL? .P ,PLAYER>
	     <NOT <FSET? ,HERE ,WORNBIT>>>
	<NOT-HERE ,MIRROR-GLOBAL ;,HEAD>)
       (<VERB? NOD>
	<PERFORM ,V?YES>
	<RTRUE>)
       (<VERB? SHAKE>
	<PERFORM ,V?NO>
	<RTRUE>)>>

<OBJECT EYE
	(IN GLOBAL-OBJECTS)
	(DESC "eye")
	(ADJECTIVE TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S B\'S
		   ;" MY DEE\'S")
	(SYNONYM EYE EYES)
	(FLAGS VOWELBIT ;PLURALBIT SEENBIT)
	(ACTION EYE-F)>

<ROUTINE EYE-F ("AUX" P P2)
 <COND (<NOT <SET P <FIND-BODY ,EYE>>>
	<RTRUE>)
       (<REMOTE-VERB?>
	<RFALSE>)
       ;(<AND <EQUAL? .P ,PLAYER>
	     <NOT <FSET? ,HERE ,WORNBIT>>>
	<COND (<VERB? OPEN>
	       <TELL "Your eyes are wide open." CR>)
	      (T <NOT-HERE ,MIRROR-GLOBAL ;,EYE>)>)
       (<VERB? OPEN>
	<SETG WINNER ,PLAYER>
	<PERFORM ,V?ALARM .P>
	<RTRUE>)
       (<VERB? CLOSE>
	<SETG WINNER .P>
	<PERFORM ,V?FAINT>
	<RTRUE>)
       (<VERB? EXAMINE FIND LOOK-INSIDE>
	<COND (<AND <EQUAL? .P ,PLAYER>
		    <NOT <FSET? ,HERE ,WORNBIT>>>
	       <NOT-HERE ,MIRROR-GLOBAL ;,EYE>)
	      (<==? ,GHOST-NEW .P>
	       <PERFORM ,PRSA ,GHOST-NEW>
	       <RTRUE>)
	      (T
	       <COND (<NOT <FSET? ,LENS ;-1 ,SEENBIT>>
		      <COND (<FSET? .P ,MUNGBIT>
			     <TELL CHE .P " has closed eyes." CR>)
			    (<==? ,VARIATION <GETP .P ,P?CHARACTER>>
			     <TELL CHE .P " turns away from you." CR>)
			    (<L? ,BED-TIME ,PRESENT-TIME>
			     <TELL CHE .P look " sleepy." CR>)
			    (T
			     <TELL CHE .P smile " at you." CR>)>)
		     (T
		      <TELL CHE .P is>
		      <COND (<OR <NOT <EQUAL? .P ,DEALER>>
				 <EQUAL? ,VARIATION ,PAINTER-C>>
			     <TELL " not">)>
		      <TELL " wearing a " D ,LENS "." CR>)>)
	      ;(T
	       <TELL
"Despite some initial demurrals and questioning glances, ">
	       <COND (<ZERO? <SET P2 <FIND-FLAG-HERE ,PERSONBIT ,PLAYER .P>>>
		      <TELL D .P>)
		     (T <TELL "everyone">)>
	       <TELL " allows your examination">
	       <COND (<OR <EQUAL? ,VARIATION ,PAINTER-C>
			  <NOT <IN? ,DEALER ,HERE>>>
		      <TELL ". You discover that">
		      <COND (<ZERO? .P2>
			     <TELL HE .P " is not">)
			    (T <TELL " no one is">)>
		      <TELL " wearing a " D ,LENS "." CR>)
		     (T <TELL
" -- except " 'DEALER ", who is wearing " D ,LENS "es
but confesses that he hates even to admit that he needs them." CR>)>)>)>>

<OBJECT OTHER-OUTFIT
	(IN GLOBAL-OBJECTS)
	(DESC "clothes")
	(ADJECTIVE TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S B\'S
		   ;" MY DEE\'S")
	(SYNONYM CLOTHES OUTFIT DRESS GOWN ; SUIT)
	;(GENERIC GENERIC-CLOTHES)
	(FLAGS SEENBIT)
	;(SIZE 20)
	(ACTION OTHER-OUTFIT-F)>

<ROUTINE OTHER-OUTFIT-F ("AUX" P P2)
 <COND (<NOT <SET P <FIND-BODY ,OTHER-OUTFIT>>>
	<RTRUE>)
       (<REMOTE-VERB?>
	<RFALSE>)
       (<VERB? EXAMINE FIND LOOK-INSIDE>
	<COND (<==? ,GHOST-NEW .P>
	       <PERFORM ,PRSA ,GHOST-NEW>
	       <RTRUE>)>)
       (<VERB? DISEMBARK REMOVE TAKE-OFF>
	<YOU-SHOULDNT>
	<RTRUE>)>>

<ROUTINE FIND-BODY (OBJ "AUX" A P)
 <SET A <ADJ-USED?> ;,P-ADJN>
 <COND (<ZERO? .A>
	<TELL ,I-ASSUME !\ >
	<COND (<OR <VERB? CLOSE FIND SEARCH-FOR>
		   <AND <VERB? ATTACK KILL MUNG SLAP>
			<T? ,NOW-PRSI>>>
	       <SET P ,PLAYER>
	       <TELL "your">)
	      (<OR <AND <VERB? SHAKE>	;"SHAKE HANDS WITH JACK"
			<T? ,PRSI>
			<FSET? <SET P ,PRSI> ,PERSONBIT>>
		   <SET P <QCONTEXT-GOOD?>>
		   <SET P <FIND-FLAG-HERE ,PERSONBIT ,PLAYER>>>
	       <TELL D .P "'s">)
	      (T
	       <SET P ,PLAYER>
	       <TELL "your">)>
	<PUT ,P-ADJW ,NOW-PRSI
		     <GET ,CHAR-POSS-TABLE <+ 1 <GETP .P ,P?CHARACTER>>>>
	<TELL !\ >
	<COND (<SET A <GET ,P-NAMW ,NOW-PRSI>>
	       <PRINTB .A>)
	      (T <TELL D .OBJ>)>
	<TELL ".]" CR>)
       (<SET P <ZMEMQ .A ,CHAR-POSS-TABLE>>
	<SET P <GET ,CHARACTER-TABLE <- .P 1>>>)
       ;(<==? .A ,OTHER-POSS>
	<SET P ,OTHER-CHAR>)
       (<==? .A ,W?HER>
	<SET P ,P-HER-OBJECT>)
       (<==? .A ,W?HIS>
	<SET P ,P-HIM-OBJECT>)>
 <COND (<ZERO? .P>
	<DONT-UNDERSTAND>
	<RFALSE>)>
 <THIS-IS-IT .P>
 <COND (<NOT <==? <META-LOC .P> ,HERE>>
	<NOT-HERE .P>
	<RFALSE>)
       (<DIVESTMENT? .OBJ>
	<HAR-HAR>
	<RFALSE>)
       (T .P)>>
]
<OBJECT PASSAGE
	(DESC "secret passage")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE SECRET HIDING HIDDEN)
	(SYNONYM PASSAGE ROOM PLACE PLACES)
	(GENERIC GENERIC-ROOM)
	(ACTION PASSAGE-F)>

<ROUTINE PASSAGE-F ("AUX" (RM <FIND-FLAG-LG ,HERE ,DOORBIT ,SECRETBIT>))
 <COND (<VERB? TAKE WALK-TO>
	<PERFORM ,V?THROUGH ,PRSO>
	<RTRUE>)
       (<AND <VERB? OPEN CLOSE>
	     <T? .RM>>
	<DO-INSTEAD-OF .RM ,PASSAGE>
	<RTRUE>)
       (<FSET? ,HERE ,SECRETBIT>
	<DO-INSTEAD-OF ,HERE ,PASSAGE>
	<RTRUE>)
       (<REMOTE-VERB?>	;"includes LEAVE"
	<RFALSE>)
       (T ;<VERB? BOARD CLOSE EXAMINE FOLLOW LOOK-INSIDE OPEN THROUGH WALK-TO>
	<COND (<AND <T? .RM>
		    <SET RM <DOOR-ROOM ,HERE .RM>>
		    <FSET? .RM ,SEENBIT>>
	       <DO-INSTEAD-OF .RM ,PASSAGE>
	       <RTRUE>)
	      (<SET RM <GENERIC-CLOSET 0>>
	       <DO-INSTEAD-OF .RM ,PASSAGE>
	       <RTRUE>)
	      (T <NOT-HERE ,PASSAGE>)>)>>

<OBJECT ROMANCE
	(DESC "Tamara's romance")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE TAM\'S JACK\'S HER HIS)
	(SYNONYM ROMANCE ENGAGE MARRIAGE LOVE ;AFFAIR)
	(FLAGS NARTICLEBIT)
	;(ACTION ROMANCE-F)>

;<ROUTINE ROMANCE-F ()
 <COND (<AND <VERB? MAKE>
	     <FSET? ,PRSI ,PERSONBIT>>
	<PERFORM ,V?RUB ,PRSI>
	<RTRUE>)>>

<OBJECT ACCIDENT
	(DESC "Deirdre's accident")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE ;DEIRDRE DEE\'S HER)
	(SYNONYM ACCIDENT DROWNING DEATH)
	(FLAGS NARTICLEBIT)>

<OBJECT CORPSE
	(DESC "Deirdre's body")
	(IN LOCAL-GLOBALS ;GLOBAL-OBJECTS ;"not really anywhere")
	(ADJECTIVE ;DEIRDRE DEE\'S HER DEAD)
	(SYNONYM CORPSE ;BODY ;"foo's body")
	(FLAGS NARTICLEBIT)
	(ACTION CORPSE-F)>

<ROUTINE CORPSE-F ()
 <COND ;(<REMOTE-VERB?> <RFALSE>)
       (<VERB? ;EXAMINE FIND>
	<WHO-KNOWS? ,CORPSE>)
       ;(T <NOT-HERE ,CORPSE>)>>

<OBJECT UNDRESSED
	(DESC "undressed")
	(IN GLOBAL-OBJECTS)
	(SYNONYM DRESSE UNDRESS)
	(FLAGS NARTICLEBIT)
	(ACTION UNDRESSED-F)>

<ROUTINE UNDRESSED-F ()
 <COND (<REMOTE-VERB?> <RFALSE>)
       (<VERB? TAKE> <RFALSE>)	;"GET UN/DRESSED"
       (<VERB? OPEN CLOSE SEARCH SEARCH-FOR EXAMINE LOOK-INSIDE LOOK-ON>
	<COND (<GLOBAL-IN? ,DRESSING-TABLE-LG ,HERE>
	       <DO-INSTEAD-OF ,DRESSING-TABLE-LG ,UNDRESSED>
	       <RTRUE>)
	      (T <NOT-HERE ,DRESSING-TABLE-LG>)>)
       (T <DONT-UNDERSTAND>)>>

<OBJECT ARTIFACT
	(IN GLOBAL-OBJECTS ;LOCAL-GLOBALS)
	(DESC "hidden treasure" ;"artifact")
	(ADJECTIVE VALUABLE MISSING HIDDEN)
	(SYNONYM ARTIFACT TREASURE)
	(FLAGS SEENBIT VOWELBIT)
	(ACTION ARTIFACT-F)>

<ROUTINE ARTIFACT-F ()
 <COND (<T? ,TREASURE-FOUND>
	<DO-INSTEAD-OF ,TREASURE ,ARTIFACT>
	<RTRUE>)
       (<OR <VERB? SHOW SSHOW TAKE-TO>
	    <NOT <REMOTE-VERB?>>>
	<NOT-FOUND ,ARTIFACT>
	<RTRUE>)>>

<ROUTINE TIMES-UP ()
	<TELL
"At first light, the police arrive and take over the investigation." CR>
	<FINISH>>
