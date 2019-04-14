"CASTLE for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

<OBJECT CASTLE
	(IN GLOBAL-OBJECTS)
	(DESC "Tresyllian Castle")
	(ADJECTIVE TRESYLLIAN)
	(SYNONYM CASTLE WING HOUSE)
	(FLAGS NARTICLEBIT SEENBIT)
	(ACTION CASTLE-F)>

<GLOBAL DARK-TURRETS "The dark stone turrets rise toward the misty sky.|">

<ROUTINE CASTLE-F ()
 <COND (<VERB? EXAMINE FIND>
	<COND (<OUTSIDE? ,HERE>
	       <COND (<VERB? FIND>
		      <TELL "It's right here!" CR>)
		     (T
		      <TELL ,DARK-TURRETS>
		      <RTRUE>)>)
	      (<OR <DOBJ? CASTLE>
		   <NOT <FSET? ,HERE ,WEARBIT>>>
	       <TELL "It's all around you!" CR>)
	      (T <NOT-HERE ,TOWER>)>)
       (<VERB? BOARD ;CLIMB-UP THROUGH WALK-TO>
	<COND (<DOBJ? CASTLE>
	       <COND (<OUTSIDE? ,HERE>
		      <COND (<NOT <FSET? ,FRIEND ,TOUCHBIT>>
			     <PERFORM ,PRSA ,COURTYARD>)
			    (T <PERFORM ,PRSA ,FOYER>)>
		      <RTRUE>)
		     (T <HAR-HAR>)>)
	      (T
	       <COND (<OR <OUTSIDE? ,HERE>
			  <FSET? ,HERE ,WEARBIT>>
		      <PERFORM ,PRSA ,OLD-GREAT-HALL>
		      ;<OKAY>
		      <RTRUE>)
		     (T <HAR-HAR>)>)>)
       (<VERB? LEAVE>
	<COND (<NOT <OUTSIDE? ,HERE>>
	       <PERFORM ,V?WALK-TO ,COURTYARD>
	       <RTRUE>)
	      (T <HAR-HAR>)>)>>

<OBJECT TOWER
	(IN GLOBAL-OBJECTS)
	(DESC "tower")
	(ADJECTIVE STONE ;BATTLE TOWER)
	(SYNONYM TOWER TURRET KEEP)
	(FLAGS SEENBIT)
	(ACTION TOWER-F)>

<ROUTINE TOWER-F ()
 <COND (<VERB? BOARD EXAMINE FIND THROUGH WALK-TO LEAVE>
	<CASTLE-F>)
       (<REMOTE-VERB?>
	<RFALSE>)
       (<FSET? ,HERE ,WEARBIT> ;"WING-ROOMS"
	<NOT-HERE ,TOWER>
	<RTRUE>)>>

<OBJECT MOON
	(IN LOCAL-GLOBALS)
	(DESC "full moon")
	(ADJECTIVE FULL ;"LOVELY RISING")
	(SYNONYM MOON MIST SKY)
	(FLAGS SEENBIT)
	(ACTION MOON-F)>

<ROUTINE MOON-F ()
 <COND (<VERB? EXAMINE>
	<TELL "Strange shapes of mist dance in front of the " 'MOON "." CR>)
       (<VERB? EAT SMELL>
	<PERFORM ,V?SMELL ,OCEAN>
	<RTRUE>)>>

<OBJECT OCEAN
	(IN LOCAL-GLOBALS)
	(DESC "ocean")
	(ADJECTIVE BLUE)
	(SYNONYM SEA OCEAN BREAKER)
	(FLAGS SEENBIT VOWELBIT)
	(ACTION OCEAN-F)>

<ROUTINE OCEAN-F ()
 <COND (<VERB? LISTEN>
	<TELL "The breakers seem to be warning you."
	      ;"The shooshing breakers could lull you to sleep." CR>)
       (<VERB? THROUGH WALK-TO>
	<TELL "The cliffs are too dangerous in the dark." CR>)>>
[
<ROUTINE CAR-DOOR-PSEUDO ()
 <COND (<VERB? OPEN CLOSE LOCK UNLOCK>
	<NO-NEED ;"do that">)>>

<OBJECT CAR
	(IN DRIVEWAY ;ROOMS)
	(FLAGS ;ONBIT VEHBIT SEENBIT CONTBIT OPENBIT)
	(CAPACITY 9999)
	(DESC "sports car" ;"Porsche")
	(ADJECTIVE MY NEW ;SPORT SPORTS LITTLE F.C F.C)
	(SYNONYM ;PORSCHE CAR)
	;(GENERIC GENERIC-CAR)
	(DESCFCN TELL-ABOUT-CAR)
	(ACTION CAR-F)>

;<	(GLOBAL ;CAR-WINDOW FRONT-GATE CAR MOON OCEAN COURTYARD)
	(THINGS <PSEUDO ( CAR DOOR	CAR-DOOR-PSEUDO)
			( <> BLAST	NULL-F)>)
	(LINE 1)
	(STATION DRIVEWAY)
	(CHARACTER 2)	;"floor number"
	(OUT PER DECAR-F)>

<ROUTINE DRIVING? ()
 <COND (<AND <NOT <ZERO? ,P-PRSA-WORD>>
	     <NOT <EQUAL? ,P-PRSA-WORD ,W?DRIVE ,W?ENTER ,W?STEER>>
	     ;<NOT <EQUAL? ,P-PRSA-WORD ,W?GO>>>
	<RFALSE>)
       (<VERB? CLIMB-UP THROUGH WALK-TO>
	<COND (<AND <VERB? THROUGH>
		    <DOBJ? CAR>>
	       <COND (<T? ,PRSI>	;"DRIVE CAR THRU object"
		      <COND (<NOT <==? ,HERE <META-LOC ,PRSI>>>
			     <SETG PRSO ,PRSI>
			     <RTRUE>)
			    (T <RFALSE>)>)
		     (T			;"DRIVE CAR IN"
		      <SETG PRSO ,FRONT-GATE>
		      <RTRUE>)>)
	      (<NOT <==? ,HERE <META-LOC ,PRSO>>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<VERB? LEAVE>
	<COND (<NOT <EQUAL? ,PRSO ;<> ,ROOMS ,CAR>>
	       <RTRUE>)>)
       (<VERB? WALK>
	<COND (<OR <NOT <ZERO? ,P-PRSA-WORD>>
		   <NOT <DOBJ? P?OUT>>>
	       <RTRUE>)>)>>

<ROUTINE CAR-F ("OPTIONAL" (ARG <>) "AUX" S)
 <SET S ,HERE ;<GETP ,CAR ,P?STATION>>
 <COND (<EQUAL? .ARG ,M-BEG>
	<COND (<DRIVING?>
	       <COND (<DOBJ? FRONT-GATE>
		      <COND (<VERB? THROUGH>
			     <COND (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (<EQUAL? .S ,DRIVEWAY>
				    <PERFORM ,V?WALK-TO ,COURTYARD>
				    <RTRUE>)
				   (T
				    <PERFORM ,V?WALK-TO ,DRIVEWAY>
				    <RTRUE>)>)
			    (T <WALK-WITHIN-ROOM>)>)
		     (<EQUAL? .S ,DRIVEWAY>
		      <COND (<VERB? CLIMB-UP THROUGH WALK-TO>
			     <COND (<EQUAL? ,DRIVEWAY <META-LOC ,PRSO>>
				    <WALK-WITHIN-ROOM>)
				   (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T ;<DOBJ? COURTYARD>
				    <CAR-TO-COURTYARD>)>)
			    (<VERB? LEAVE>
			     <COND (<DOBJ? COURTYARD>
				    <HAR-HAR>)
				   (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T ;<DOBJ? DRIVEWAY>
				    <CAR-TO-COURTYARD>)>)
			    (<OR <DOBJ? P?SOUTH P?IN>
				 <AND <DOBJ? INTDIR> <ADJ-USED? ,W?SOUTH>>>
			     <COND (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T <CAR-TO-COURTYARD>)>)
			    (T ;<DOBJ? P?NORTH>
			     <SETG CLOCK-WAIT T>
			     <TELL ,CASTLE-IS-SOUTH>
			     <RTRUE>
			     ;<YOU-CANT "drive">)>)
		     (T ;<EQUAL? .S ,COURTYARD>
		      <COND (<VERB? CLIMB-UP THROUGH WALK-TO>
			     <COND (<EQUAL? ,COURTYARD <META-LOC ,PRSO>>
				    ;<EQUAL? ,PRSO <> ,COURTYARD ,CASTLE>
				    <WALK-WITHIN-ROOM>)
				   (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T ;<DOBJ? DRIVEWAY>
				    <CAR-TO-DRIVEWAY>)>)
			    (<VERB? LEAVE>
			     <COND (<DOBJ? DRIVEWAY>
				    <HAR-HAR>)
				   (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T ;<DOBJ? COURTYARD>
				    <CAR-TO-DRIVEWAY>)>)
			    (<OR <DOBJ? P?NORTH>
				 <AND <DOBJ? INTDIR> <ADJ-USED? ,W?NORTH>>>
			     <COND (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T <CAR-TO-DRIVEWAY>)>)
			    (<DOBJ? P?OUT>
			     <COND (<EQUAL? ,P-PRSA-WORD <> ,W?GO>
				    <RFALSE>)
				   (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
				    <TOO-BAD-BUT ,FRONT-GATE "closed">)
				   (T <CAR-TO-DRIVEWAY>)>)
			    (T <YOU-CANT "drive">)>)
		     ;(T <YOU-CANT "drive">)>)
	      (<AND <VERB? WALK> <DOBJ? P?OUT>>
	       <MOVE ,WINNER ,HERE>
	       <OWN-FEET>)
	      (<OR <VERB? FOLLOW STAND WALK>
		   <AND <VERB? LEAVE THROUGH WALK-TO>
			<NOT <ZERO? ,PRSO>>
			<NOT <EQUAL? ,PRSO ,LUGGAGE ,ROOMS ,CAR>>>
		   ;<AND <VERB? WALK>
			<NOT <DOBJ? P?OUT>>>>
	       ;<TELL "(You get out of the car first.)" CR>
	       <FIRST-YOU "leave" ,CAR>
	       ;<GOTO <GETP ,CAR ,P?STATION>>
	       <MOVE ,WINNER ,HERE>
	       <COND (<VERB? STAND> <RTRUE>)
		     (T <RFALSE>)>)
	      (<DOBJ? ROOMS>
	       <COND ;(<VERB? RING>	;"only if syntax allows it"
		      <PERFORM ,PRSA ,HORN>
		      <RTRUE>)
		     (<VERB? STOP>
		      <PERFORM ,PRSA ,CAR>
		      <RTRUE>)>)>)
       (<EQUAL? .ARG ,M-LOOK>
	<COND (<==? <LOC ,WINNER> ;,HERE ,CAR>
	       <TELL "You are sitting in your new little " 'CAR "." CR>)>
	<RTRUE>)
       (.ARG <RFALSE>)
       (<VERB? EXAMINE>
	<TELL-ABOUT-CAR>
	<RTRUE>)
       ;(<VERB? LAMP-ON>
	<COND (<FSET? ,CAR ,MUNGBIT>
	       <TELL "The starter runs, but the engine won't start."CR>)
	      (<FSET? ,CAR ,FEMALE>
	       <TELL
"You hear gears clash! The quiet engine must be running already." CR>)
	      (T
	       <FSET ,CAR ,FEMALE>
	       <TELL "The engine starts immediately." CR>)>)
       ;(<VERB? LOCK>
	<SETG CLOCK-WAIT T>
	<TELL
"(You're out in the country. You don't need to lock the car.)" CR>)
       (<VERB? CLIMB-ON CLOSE OPEN LAMP-OFF LAMP-ON LOCK UNLOCK>
	<NO-NEED "do that to">)>>

<ROUTINE CAR-TO-COURTYARD ()
	<MOVE ,CAR ,COURTYARD>
	<TELL
"Your headlights bravely pierce the gloom as you enter the " 'COURTYARD ".
You get out of your car.|">
	<GOTO ,COURTYARD>>

<ROUTINE CAR-TO-DRIVEWAY ()
	<SETG CLOCK-WAIT T>
	<TELL "(You can't leave yet. There's a mystery to be solved!)" CR>>

<ROUTINE TELL-ABOUT-CAR ("OPT" X)
	<TELL "Your new little ">
	<COND (<PRINT-COLOR> <TELL !\ >)>
	<TELL 'CAR " is parked here." CR>>

<OBJECT VOICE
	(DESC "voice")
	(ADJECTIVE LOUD ;CONCEAL HIDDEN LI\'S B\'S HIS)
	(SYNONYM VOICE SPEAKER LOUDSPEAKER)
	(FLAGS NDESCBIT)
	(ACTION VOICE-F)>

<ROUTINE VOICE-F ()
 <COND (<EQUAL? ,HERE ;,CAR ,DRIVEWAY>
	<COND (<AND <NOT <ZERO? ,DRAGON-EYE-COLOR>>
		    <OR <VERB? LISTEN>
			<SPEAKING-VERB?>>>
	       <COND ;(<EQUAL? ,HERE ,CAR>
		      <TELL "You still can't make out what's being said." CR>)
		     (T <VOICE-SAYS>)>)>)
       (<EQUAL? ,HERE ,DINING-ROOM>
	<COND (<VERB? LISTEN>
	       <BUST-F>)>)>>

<OBJECT HORN
	(IN CAR)
	(DESC "horn")
	(ADJECTIVE MY MOTOR ;CAR)
	(SYNONYM HORN)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION HORN-F)>

<ROUTINE HORN-F ()
 <COND (<VERB? RING PUSH RUB SLAP SOUND>
	<COND (<NOT <ZERO? <GETB ,LAST-NAME 0>>>
	       <COND (<GATE-OPENS> <RTRUE>)
		     (T <TELL "\"H-O-O-O-N-K!\"" CR>)>)
	      (T
	       <THIS-IS-IT ,VOICE>
	       <MOVE ,VOICE ,DRIVEWAY ;,CAR>
	       <PERFORM ,V?PUSH ,DRAGON-EYE>
	       <RTRUE>)
	      ;(T
	       <COND (<NOT <L? ,DRAGON-EYE-COLOR 0>>
		      <TELL "A red light flickers, on the gate. ">)>
	       <SETG DRAGON-EYE-COLOR -1>
	       <THIS-IS-IT ,VOICE>
	       <MOVE ,VOICE ,DRIVEWAY ;,CAR>
	       <TELL
"You can hear a voice indistinctly. It seems to be coming from the gate."
CR>)>)>>
][
<ROOM DRIVEWAY
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT)
	(DESC "driveway")
	(ADJECTIVE DRIVE)
	(SYNONYM DRIVEWAY WAY)
	(LINE 1)
	(STATION COURTYARD ;DRIVEWAY)
	(CHARACTER 2)
	(GLOBAL FRONT-GATE MOON OCEAN WINDOW CHAIR)
	(THINGS <PSEUDO ( CAR DOOR	CAR-DOOR-PSEUDO)>)
	(SOUTH	TO COURTYARD IF FRONT-GATE IS OPEN)
	(IN	TO COURTYARD IF FRONT-GATE IS OPEN)
	(ACTION DRIVEWAY-F)>

<ROUTINE DRIVEWAY-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-BEG>
	<COND (<VERB? YELL>
	       <PERFORM ,V?KNOCK ,FRONT-GATE>
	       <RTRUE>)
	      (<AND <NOT <ZERO? ,DRAGON-EYE-COLOR>>
		    <OR <SPEAKING-VERB?>
			<AND <VERB? LISTEN>
			     <DOBJ? FRONT-GATE DRAGON DRAGON-EYE>>>>
	       <VOICE-SAYS>
	       <RTRUE>)>)
       (<==? .RARG ,M-LOOK>
	<TELL
;"This is the end of the  'DRIVEWAY" "You are by the ">
	<COND (<FSET? ,FRONT-GATE ,OPENBIT>
	       <TELL "open ">)>
	<TELL
'FRONT-GATE " of " 'CASTLE ". You can hear the ocean beating urgently
against the rocks far below.|">
	<TELL-ABOUT-DRAGON>
	<RTRUE>)>>

<OBJECT DRAGON
	(IN DRIVEWAY ;FRONT-GATE)
	(DESC "dragon")
	;(ADJECTIVE WINGED TWO-LEGGED)
	(ADJECTIVE DRAGON WYVERN ORNAMENT ;"for possessives")
	(SYNONYM DRAGON WYVERN ORNAMENT)
	(FLAGS NDESCBIT TRYTAKEBIT)
	(ACTION DRAGON-F)>

<ROUTINE DRAGON-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE>
	<TELL-ABOUT-DRAGON>
	<RTRUE>)
       (T ;<VERB? PUSH RUB TURN>
	<DRAGON-EYE-F>)>>

<ROUTINE TELL-ABOUT-DRAGON ()
	<TELL
"In the moonlit gloom, you can make out an ornament on the gate.
It's a winged, two-legged dragon called a wyvern,
which crests the " ,TRESYLLIAN " family's coat of
arms.|
The dragon appears in profile. ">
	<THIS-IS-IT ,DRAGON-EYE>
	<TELL-ABOUT-EYE>
	<RTRUE>>

<ROUTINE I-DRAGON-EYE ("OPTIONAL" (GARG <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[I-DRAGON-EYE:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<ZERO? <GETB ,LAST-NAME 0>>
	;<NOT <L? ,DRAGON-EYE-COLOR 0>>
	<PERFORM ,V?PUSH ,DRAGON-EYE>
	<RFATAL>)>>

<OBJECT DRAGON-EYE
	(IN DRIVEWAY ;FRONT-GATE)
	(DESC "dragon's eye")
	(ADJECTIVE ;"WINGED TWO-LEGGED" DRAGON WYVERN WORM\'S RED GREEN DOOR)
	(SYNONYM EYE DOORBELL ;BUTTON LIGHT BELL)
	(GENERIC GENERIC-BELL)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION DRAGON-EYE-F)>

<ROUTINE DRAGON-EYE-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE>
	<TELL-ABOUT-EYE>
	<RTRUE>)
       (<VERB? BOARD CLIMB-ON LEAP>
	<TELL ,TOO-SLIPPERY>
	<RTRUE>)
       (<VERB? KNOCK MOVE MUNG PUSH RING RUB SLAP TURN>
	<COND (<NOT <L? ,DRAGON-EYE-COLOR 0>>
	       <SETG DRAGON-EYE-COLOR -1>
	       <TELL "The " 'DRAGON-EYE " glows red. ">)>
	<COND (<NOT <VERB? PUSH>>
	       <TELL "Evidently you just pushed a button. ">)>
	<TELL "A voice comes from a hidden speaker. It says:|">
	<VOICE-SAYS>
	<RTRUE>)
       (<VERB? TAKE>
	<TELL "It's part of the " 'FRONT-GATE "." CR>)>>

<ROUTINE TELL-ABOUT-EYE ()
	<COND (<ZERO? ,DRAGON-EYE-COLOR>
	       <TELL "The moonlight glints on its lone visible eye." CR>)
	      (T
	       <TELL "The " 'DRAGON-EYE " is glowing ">
	       <COND (<G? ,DRAGON-EYE-COLOR 0>
		      <TELL "green." CR>)
		     (T <TELL "red." CR>)>)>>

<ROUTINE VOICE-SAYS ()
	<QUEUE I-DRAGON-EYE 0>
	<COND (<NOT <ZERO? <GETB ,LAST-NAME 0>>>
	       <TELL "\"Please enter, ">
	       <COND (<TITLE-NAME> <TELL !\.>)>
	       <TELL "\"|">
	       <GATE-OPENS>
	       <RTRUE>)>
	<QUEUE I-FRIEND-GREETS 6 ;9>
	<TELL
"\"Please announce " 'PLAYER ". State your title -- such as Lord or Lady,
Sir or Dame, Mr. or Ms. -- and your first and last name.\"|">
	<GET-NAME>
	<TELL "\"And what is " 'YOUR-COLOR ", "TN"?\"|">
	<GET-COLOR>
	<TELL "\"Jolly good! The spare bedroom is decorated in ">
	<PRINT-COLOR>
	<TELL "! ">
	;<TELL "Are you driving, "TN"?\"">
	<COND ;(<YES?>
	       <TELL ;"return to your car and ... a blast on "
"\"Then please sound your motor horn when you are ready to enter.\""
CR>)
	      (T
	       ;<TELL "\"Then p">
	       <TELL "Please enter.\"" CR>
	       <GATE-OPENS>)>
	<RTRUE>>

<ROUTINE GATE-OPENS ()
 <COND (<AND <EQUAL? ,HERE ,DRIVEWAY>
	     <NOT <FSET? ,FRONT-GATE ,OPENBIT>>>
	;<ESTABLISH-GOAL ,FRIEND ,COURTYARD>
	;<ESTABLISH-GOAL ,LORD ,COURTYARD>
	;<PUT <GT-O ,FRIEND>	,GOAL-FUNCTION ,FRIEND-GREETS>
	;<PUT <GT-O ,LORD>	,GOAL-FUNCTION ,NULL-F ;,LORD-GREETS>
	<REMOVE ,VOICE>
	<FSET ,FRONT-GATE ,OPENBIT>
	<FCLEAR ,FRONT-GATE ,LOCKED>
	<THIS-IS-IT ,FRONT-GATE>
	<TELL "The ">
	<COND (<NOT <EQUAL? ,DRAGON-EYE-COLOR +1>>
	       <COND (<L? ,DRAGON-EYE-COLOR 0> <TELL "red ">)>
	       <SETG DRAGON-EYE-COLOR +1>
	       <TELL "eye turns green, and the ">)>
	<TELL 'FRONT-GATE " creaks open." CR>)>>

<GLOBAL DRAGON-EYE-COLOR:NUMBER 0>
]
<GLOBAL TOO-SLIPPERY "The thickening mist has made it too slippery.|">

<OBJECT FRONT-GATE
	(IN LOCAL-GLOBALS)
	(DESC "front gate")
	(ADJECTIVE FRONT TALL IRON)
	(SYNONYM GATE ;DOOR)
	(FLAGS TRANSBIT LOCKED DOORBIT SEENBIT ;SURFACEBIT)
	(ACTION FRONT-GATE-F)>

;<GLOBAL FRONT-GATE-KNOCKED:NUMBER 0>
<ROUTINE FRONT-GATE-F ()
 <COND (<VERB? KNOCK>
	;<SETG FRONT-GATE-KNOCKED <+ 1 ,FRONT-GATE-KNOCKED>>
	<COND (T ;<ZERO? <MOD ,FRONT-GATE-KNOCKED 2>>
	       <TELL "Apparently no one hears you." CR>)
	      ;(T <TELL
"Some of the castle windows show light, but the " 'COURTYARD " remains
shrouded in silence." CR>)>)
       (<VERB? MUNG SHAKE UNLOCK>
	<TELL
"Except for your rattling the gate, the silence remains unbroken." CR>)
       (<VERB? BOARD CLIMB-ON LEAP>
	<TELL ,TOO-SLIPPERY>
	<RTRUE>)
       (<AND <VERB? WALK-TO>
	     <NOT <EQUAL? ,HERE ,DRIVEWAY ,COURTYARD>>>
	<PERFORM ,PRSA ,COURTYARD>
	<RTRUE>)
       (<VERB? OPEN>
	<COND (<FSET? ,FRONT-GATE ,LOCKED>
	       <TELL "It seems to be locked." CR>)>)
       (<VERB? EXAMINE LOOK-ON SEARCH SEARCH-FOR>
	<COND (<OR <EQUAL? ,HERE ,DRIVEWAY>
		   ;<AND <EQUAL? ,HERE ,CAR>
			<EQUAL? <GETP ,HERE ,P?STATION> ,DRIVEWAY>>>
	       <TELL-ABOUT-DRAGON>
	       <RTRUE>)
	      ;(<AND <IN? ,CLUE-4 ,FRONT-GATE>
		    <FSET? ,CLUE-4 ,SECRETBIT>>
	       <DISCOVER ,CLUE-4>)>)
       (<IN? ,VOICE ,HERE>
	<VOICE-F>)>>

<ROOM COURTYARD
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT)
	(DESC "courtyard")
	(ADJECTIVE CASTLE COURT)
	(SYNONYM COURTYARD YARD ROOM)
	(LINE 1)
	(STATION COURTYARD)
	(CHARACTER 2)
	(GLOBAL FRONT-GATE MOON FRONT-DOOR OLD-GREAT-HALL
		OCEAN WINDOW CHAIR)
	(THINGS <PSEUDO ( CAR DOOR	CAR-DOOR-PSEUDO)>)
	(OUT	TO DRIVEWAY IF FRONT-GATE IS OPEN)
	(NORTH	TO DRIVEWAY IF FRONT-GATE IS OPEN)
	(SW	TO OLD-GREAT-HALL IF OLD-GREAT-HALL ;TOWER-DOOR IS OPEN)
	(SOUTH	TO FOYER IF FRONT-DOOR IS OPEN)
	(IN	TO FOYER IF FRONT-DOOR IS OPEN)
	;(IN	"Do you want to go south or southwest?")
	(EAST	TO MAZE ;GARDEN)
	(ACTION COURTYARD-F)>

<ROUTINE COURTYARD-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-ENTER>
	<COND (<IN? ,FRIEND ,LIMBO>
	       <MOVE ,FRIEND ,COURTYARD>)>
	<COND (<NOT <ZERO? ,DRAGON-EYE-COLOR>>
	       <SETG DRAGON-EYE-COLOR 0>)>
	<COND (<NOT <FSET? ,FRONT-GATE ,LOCKED>>
	       <FCLEAR ,FRONT-GATE ,OPENBIT>
	       <FSET ,FRONT-GATE ,LOCKED>
	       <TELL "The " 'FRONT-GATE " closes and locks behind you." CR>)>)
       (<EQUAL? .RARG ,M-LOOK>
	<COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
	       <FSET ,HERE ,TOUCHBIT>
	       <TELL "As flood lights blaze on, you look around. ">)>
	<TELL-LIKE-BROCHURE>
	<TELL ,DARK-TURRETS>
	<RTRUE>)
       (<EQUAL? .RARG ,M-FLASH>
	<COND (<AND <IN? ,FRIEND ,COURTYARD>
		    <NOT <FSET? ,FRIEND ,TOUCHBIT>>
		    <ZERO? ,CLOCK-WAIT>>
	       <FSET ,FRIEND ,TOUCHBIT>
	       <FCLEAR ,FRIEND ,NDESCBIT>
	       <SETG FOLLOWER ,FRIEND>
	       <SETG QCONTEXT ,FRIEND>
	       ;<PUT <GET ,GOAL-TABLES ,FRIEND-C> ,GOAL-ENABLE 0>
	       <QUEUE I-FRIEND-GREETS 0>
	       ;<PUTP ,FRIEND ,P?LDESC 0>
	       <QUEUE I-TOUR 7 ;3>
	       <ESTABLISH-GOAL ,BUTLER ,COURTYARD>
	       ;<PUT <GT-O ,BUTLER> ,GOAL-FUNCTION ,BUTLER-APPEARS>
	       <FCLEAR ,FRONT-DOOR ,LOCKED>
	       <SETG QCONTEXT ,FRIEND>
	       <THIS-IS-IT ,FRIEND>
	       <PUTP ,FRIEND ,P?LDESC 12 ;"listening to you">
	       <SETG AWAITING-REPLY ,FRIEND-C>
	       <QUEUE I-REPLY ;2 ,CLOCKER-RUNNING>
	       <TELL "|
Someone comes running out of the wing to greet you. " <GETP ,FRIEND ,P?TEXT>
" You recognize her as your friend, " 'FRIEND " Lynd.|
\""FN"!\" she cries with outflung arms. \"You sweet thing, to answer
my letter in person this way! And all the people I wrote about are
here tonight for Lionel's memorial birthday dinner!\"|
After a warm hug, she asks anxiously, \""
<GET ,QUESTIONS ,AWAITING-REPLY> "\"|">
	       <RFATAL>)>)
       ;(<EQUAL? .RARG ,M-EXIT>
	<COND (<T? ,AWAITING-REPLY>
	       <SETG CLOCK-WAIT T>
	       <PLEASE-ANSWER>
	       <RTRUE>)>)>>

<ROUTINE TELL-LIKE-BROCHURE ("OPTIONAL" (DR <>))
	<TELL
"It looks even lovelier than it sounds in the " D ,BROCHURE ".">
	<COND (<T? .DR>
	       <OPEN-DOOR? .DR>)>
	<CRLF>>

<ROOM MAZE
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT)
	(DESC "hedge maze")
	(ADJECTIVE HEDGE)
	(SYNONYM MAZE ;HEDGEMAZE)
	(LDESC
"Tall dark hedges surround you like walls, with walkways in all directions.")
	(LINE 1)
	(STATION MAZE ;COURTYARD)
	(CHARACTER 2)
	(GLOBAL MOON OCEAN)
	(NORTH	PER MAZE-EXIT)
	(NE	PER MAZE-EXIT)
	(EAST	PER MAZE-EXIT)
	(SE	PER MAZE-EXIT)
	(SOUTH	PER MAZE-EXIT)
	(SW	PER MAZE-EXIT)
	(WEST	PER MAZE-EXIT)
	(NW	PER MAZE-EXIT)
	(IN	TO GARDEN)
	(OUT	TO COURTYARD)
	(ACTION MAZE-F)>

<ROUTINE MAZE-EXIT ("AUX" RM)
	<COND (<==? ,OHERE ,GARDEN>
	       <SET RM ,COURTYARD>)
	      (T ;<==? ,OHERE ,COURTYARD>
	       <SET RM ,GARDEN>)>
	<COND (<==? ,WINNER ,PLAYER>
	       <TELL
"You stumble blindly through the maze and suddenly emerge in the " D .RM".|">)>
	.RM>

<ROUTINE MAZE-F ("OPT" (RARG 0))
 <COND (<T? .RARG>
	<RFALSE>)
       (<VERB? THROUGH>
	<COND (<EQUAL? ,HERE ,MAZE>
	       <GOTO <MAZE-EXIT>>)>)>>

<ROOM GARDEN
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT)
	(DESC "garden")
	(ADJECTIVE CASTLE)
	(SYNONYM GARDEN BOWER)
	(LINE 1)
	(STATION GARDEN ;COURTYARD)
	(CHARACTER 2)
	(GLOBAL MOON OCEAN)
	(NORTH	TO MAZE)
	(NE	TO MAZE)
	(EAST	TO MAZE)
	(SE	TO MAZE)
	(SOUTH	TO MAZE)
	(SW	TO MAZE)
	(WEST	TO MAZE)
	(NW	TO MAZE)
	(OUT	TO MAZE)
	(ACTION GARDEN-F)>

<ROUTINE GARDEN-F ("OPTIONAL" (RARG <>) "AUX" OBJ)
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"Here in the central garden the plants quake nervously in
the mist. In the very middle is a " 'POND "." CR
;" You can go west to the courtyard or southwest to enter the castle.">)
       (<T? .RARG>
	<RFALSE>)
       (<VERB? EXAMINE SEARCH SEARCH-FOR>
	<COND (<SET OBJ <FIND-FLAG-HERE ,SECRETBIT>>
	       <DISCOVER .OBJ ,HERE>
	       <RTRUE>)>
	;<COND (<AND <IN? ,CLUE-4 ,GARDEN>
		    <FSET? ,CLUE-4 ,SECRETBIT>>
	       <DISCOVER ,CLUE-4 ,GARDEN>
	       <RTRUE>)
	      ;(<AND <IN? ,NECKLACE ,GARDEN>
		    <FSET? ,NECKLACE ,SECRETBIT>>
	       <DISCOVER ,NECKLACE ,GARDEN>
	       <RTRUE>)>)>>

<OBJECT POND
	(IN GARDEN)
	(DESC "goldfish pond")
	(ADJECTIVE ;GOLDFISH ;FISH STONE)
	(SYNONYM POND WATER FOUNTAIN)
	(FLAGS CONTBIT OPENBIT NDESCBIT SEENBIT)
	(CAPACITY 999)
	(ACTION POND-F)>

<ROUTINE POND-F ()
 <COND (<VERB? BOARD LEAP SWIM THROUGH>
	<TELL "On second thought, it looks too dark and slippery." CR>
	<RTRUE>)
       (<VERB? EXAMINE LOOK-INSIDE LOOK-UNDER>
	<COND ;(<AND <IN? ,NECKLACE ,POND>
		    <FSET? ,NECKLACE ,SECRETBIT>>
	       <DISCOVER ,NECKLACE ,POND>
	       ;<TELL
CHE ,WINNER notice " something projecting above the water. When" HE ,WINNER
take " it, it's obviously a " D ,NECKLACE "!" CR>)
	      (T
	       <TELL-AS-WELL-AS ,POND " dark water">
	       <RTRUE>)>)>>

<OBJECT FRONT-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "front door")
	(ADJECTIVE FRONT CASTLE)
	(SYNONYM DOOR ;DOORS ;"from COURTYARD" ;KEYHOLE)
	(FLAGS OPENBIT DOORBIT SEENBIT LOCKED)
	(ACTION FRONT-DOOR-F)>

<ROUTINE FRONT-DOOR-F ()
 <COND (<VERB? WALK-TO>
	<COND (<OUTSIDE? ,HERE>
	       <PERFORM ,V?WALK-TO ,COURTYARD>
	       <RTRUE>)
	      (T
	       <PERFORM ,V?WALK-TO ,FOYER>
	       <RTRUE>)>)>>
[
<ROOM FOYER
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT DOORBIT WEARBIT)
	(DESC "foyer")
	(ADJECTIVE NEW FOYER DOUBLE BRONZE)
	(SYNONYM FOYER ROOM DOOR ;DOORS ;"can't handle multiple doors")
	(LINE 1)
	(STATION FOYER)
	(CHARACTER 2)
	(GLOBAL FRONT-DOOR FOYER ;FOYER-DOOR CHAIR TABLE-RANDOM
		WINDOW OIL-PAINTING)
	(SOUTH	TO GREAT-HALL IF FOYER ;FOYER-DOOR IS OPEN)
	(EAST	TO DRAWING-ROOM IF DRAWING-ROOM IS OPEN)
	(IN	TO DRAWING-ROOM IF DRAWING-ROOM IS OPEN)
	(OUT	TO COURTYARD IF FRONT-DOOR IS OPEN)
	(NORTH	TO COURTYARD IF FRONT-DOOR IS OPEN)
	(ACTION FOYER-F)>

<ROUTINE FOYER-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-ENTER>
	<COND (<NOT <FSET? ,FOYER ,TOUCHBIT>>
	       <FSET ,FOYER ,TOUCHBIT>
	       <TELL
"As you enter the foyer, you're overwhelmed by the English
past. Those barbarous times when
Jack's ancestors had to shut themselves up in a fortified castle have
softened into gracious country living. Yet " 'FRIEND " is clearly anxious." CR>
	       ;<COND (<AND <IN? ,BUTLER ,FOYER>
			    <NOT <FSET? ,BUTLER ,TOUCHBIT>>>
		       <FSET ,BUTLER ,TOUCHBIT>
		       <FCLEAR ,BUTLER ,NDESCBIT>
		       <TELL
CHE ,BUTLER " says, \"Welcome to " D ,CASTLE ", ">
		       <COND (<TITLE-NAME> <TELL !\.>)>
		       <TELL " I hope you had no
trouble with the security gate. We've all been on edge since the 'ghost'
appeared again last night. Of course, I put no stock in ghosts. I hope you
don't either. Please follow me.\"" CR>
		       <ESTABLISH-GOAL ,BUTLER ,GREAT-HALL>
		       <RTRUE>)>
	       <RTRUE>)>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL-LIKE-BROCHURE>
	<DESCRIBE-CONTENTS ,COAT-RACK>
	<RTRUE>)
       (<EQUAL? .RARG ,M-FLASH>
	<COND (<AND <NOT <FSET? ,LORD ,TOUCHBIT>>
		    <IN? ,LORD ,FOYER>>
	       <LORD-INTRO>)>
	<RTRUE>)>>

<ROUTINE DESCRIBE-CONTENTS (OBJ)
	<COND (<FIND-FLAG-NOT .OBJ ,NDESCBIT>
	       ;<FIRST? .OBJ>
	       <TELL "On" THE .OBJ " you see">
	       <PRINT-CONTENTS .OBJ>
	       <TELL ".|">)>>

<OBJECT UMBRELLA-STAND
	(IN FOYER)
	(DESC "umbrella stand")
	(ADJECTIVE UMBRELLA)
	(SYNONYM STAND ;CASE UMBRELLA)
	(FLAGS CONTBIT OPENBIT NDESCBIT VOWELBIT SEENBIT)
	(CAPACITY 99)
	;(LDESC
"In a dark corner is an umbrella stand." ;", containing various
umbrellas.")
	(ACTION UMBRELLA-STAND-F)>

<ROUTINE UMBRELLA-STAND-F ()
	<FCLEAR ,UMBRELLA-STAND ,NDESCBIT>
	<COND (<VERB? OPEN CLOSE>
	       <YOU-CANT>)
	      (<VERB? TAKE>
	       <COND (<NOUN-USED? ,W?UMBRELLA>
		      <TELL "But it's not raining!" CR>)>)
	      (<VERB? EXAMINE LOOK-INSIDE SEARCH SEARCH-FOR>
	       <COND (<AND <IN? ,CANE ,UMBRELLA-STAND>
			   <FSET? ,CANE ,NDESCBIT>>
		      <FCLEAR ,CANE ,NDESCBIT>
		      <FCLEAR ,CANE ,SECRETBIT>
		      <FSET ,CANE ,SEENBIT>
		      <FSET ,CANE ,TAKEBIT>
		      <FSET ,CANE ,TOUCHBIT>
		      ;<MOVE ,CANE ,WINNER>
		      <THIS-IS-IT ,CANE>
		      <TELL
"Among the umbrellas there's a cane that looks odd." CR>
		      <RTRUE>)
		     (<VERB? EXAMINE>
		      <TELL-LIKE-BROCHURE>
		      ;<TELL
CTHE ,UMBRELLA-STAND " is made from the foot of an elephant." CR>)
		     (T
		      <TELL-AS-WELL-AS ,UMBRELLA-STAND
				       " an assortment of umbrellas">
		      <RTRUE>)>)>>

<OBJECT COAT-RACK
	(IN FOYER)
	(DESC "coat rack")
	(ADJECTIVE COAT)
	(SYNONYM RACK)
	(FLAGS SURFACEBIT OPENBIT NDESCBIT SEENBIT)
	(CAPACITY 999)>
][
<OBJECT SECRET-DRAWING-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-DRAWING-DOOR)>

<ROOM DRAWING-ROOM
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "drawing room")
	(ADJECTIVE DRAWING ;ROOM)
	(SYNONYM ROOM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(LINE 1)
	(STATION GREAT-HALL)
	(CHARACTER 2)
	(GLOBAL GREAT-HALL DRAWING-ROOM SECRET-DRAWING-DOOR CHAIR
		FIREPLACE WINDOW TABLE-RANDOM OIL-PAINTING)
	(IN	TO GREAT-HALL IF GREAT-HALL ;DRAWING-DOOR IS OPEN)
	(WEST	TO GREAT-HALL IF GREAT-HALL ;DRAWING-DOOR IS OPEN)
	(OUT	TO FOYER IF DRAWING-ROOM IS OPEN)
	(NW	TO FOYER IF DRAWING-ROOM IS OPEN)
	(NORTH	TO FOYER IF DRAWING-ROOM IS OPEN)
	(SOUTH	TO DRAWING-CLOSET IF SECRET-DRAWING-DOOR IS OPEN)
	(ACTION DRAWING-ROOM-F)>

<GLOBAL INTRODUCES " introduces ">

<ROUTINE DRAWING-ROOM-F ("OPTIONAL" (RARG 0) "AUX" PER)
 <COND (<EQUAL? .RARG ,M-BEG ;,M-EXIT>
	<COND (<AND <VERB? OPEN CLOSE>
		    <DOBJ? SECRET-DRAWING-DOOR>>
	       <YOU-CANT <> ,PLAYER "in this room">
	       <RTRUE>)
	      (T <SECRET-CHECK .RARG>)>)
       ;(<EQUAL? .RARG ,P?NORTH>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL-LIKE-BROCHURE ,SECRET-DRAWING-DOOR>)
       (<EQUAL? .RARG ,M-FLASH>
	<COND (<AND <IN? ,DEALER ,DRAWING-ROOM>
		    <NOT <FSET? ,DEALER ,TOUCHBIT>>>
	       <FSET ,DEALER ,TOUCHBIT>
	       <COND (<AND <EQUAL? <LOC ,PAINTER> ,HERE ,PSEUDO-OBJECT>
			   <=? <GETP ,DEALER ,P?LDESC> 2 ;"sipping sherry">>
		      <TELL
"A tall graceful older couple in evening clothes are chatting and "
<GET ,LDESC-STRINGS 2> ;"sipping sherry" ".|">
		      <SETG QCONTEXT ,PAINTER>
		      <COND (<EQUAL? <LOC ,LORD> ,HERE ,PSEUDO-OBJECT>
			     <SET PER ,LORD>)
			    (<EQUAL? <LOC ,FRIEND> ,HERE ,PSEUDO-OBJECT>
			     <THIS-IS-IT ,FRIEND>
			     <SET PER ,FRIEND>)>
		      <COND (<T? .PER>
			     <TELL
D .PER ,INTRODUCES "them as Montague Hyde and Vivien Pentreath.|
Hyde smiles and bows stiffly. And Vivien murmurs in an attractively low
voice, \"How do you do, ">
			     <COND (<TITLE-NAME> <TELL !\.>)>
			     <TELL "\"|
\"Believe it or not, this young ">
			     <COND (<ZERO? ,GENDER-KNOWN> <TELL "person">)
				   (<FSET? ,PLAYER ,FEMALE> <TELL "lady">)
				   (T <TELL "man">)>
			     <TELL
" is a famous American detective,\" " D .PER " tells them.|">
			     <COND (<EQUAL? <LOC ,FRIEND>,HERE ,PSEUDO-OBJECT>
				    <TELL
"\"Not a police detective, of course,\" " 'FRIEND " adds as they both
stiffen, \"but a
solver of all sorts of mysteries in the States. We're hoping
to find out who or what is haunting " 'CASTLE ".\"" CR>)>)>)>)>)>>

<OBJECT LOVER-PIC
	(IN DRAWING-ROOM)
	(DESC "Deirdre's portrait")
	(ADJECTIVE VIV\'S DEE\'S HER ART DEIRDRE DEE;"handles PICTURE OF DEE!")
	(SYNONYM PORTRAIT PICTURE PAINTING WATERCOLOR)
	;(GENERIC GENERIC-PAINTING)
	(FLAGS NDESCBIT NARTICLEBIT)
	(ACTION LOVER-PIC-F)>

<ROUTINE LOVER-PIC-F ()
 <COND (<VERB? EXAMINE>
	<TELL
"It's a portrait by " 'PAINTER " of " 'LOVER ", a lovely young woman
with flowing blonde hair, standing on a grassy slope, gazing out to sea.
It's painted in pastel tones, which emphasize " 'LOVER "'s violet eyes.
There's something ethereal and fairylike about her. Ironically, her
silvery white, sleeveless gown is the very one she was wearing at the
time of her accident." CR>)>>

<OBJECT OIL-PAINTING
	(IN LOCAL-GLOBALS ;DRAWING-ROOM)
	(DESC "oil painting")
	(ADJECTIVE OIL ART)
	(SYNONYM PORTRAIT PICTURE PAINTING)
	;(GENERIC GENERIC-PAINTING)
	(FLAGS NDESCBIT VOWELBIT SEENBIT)
	(ACTION BROCHURE-PSEUDO)>

<OBJECT TAPESTRY
	(IN DRAWING-ROOM)
	(DESC "tapestry")
	(SYNONYM TAPESTRY UNICORN MAIDEN ARM)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION TAPESTRY-F)>

<ROUTINE TAPESTRY-F ()
 <COND (<VERB? EXAMINE SEARCH>
	<TELL-LIKE-BROCHURE>
	;<TELL "The " 'TAPESTRY " depicts a unicorn and a maiden." CR>
	<COND (<EQUAL? ,VARIATION ,PAINTER-C ;,FRIEND-C>
	       <TELL
"Someone has added a star in red thread on the maiden's ARM." CR>)>
	<RTRUE>)
       (<VERB? LOOK-BEHIND LOOK-UNDER>
	<FSET ,SECRET-DRAWING-DOOR ,TOUCHBIT>
	<THIS-IS-IT ,SECRET-DRAWING-DOOR>
	<TELL
"Hidden behind the " 'TAPESTRY " is" THE ,SECRET-DRAWING-DOOR "!" CR>)>>

<OBJECT VICTORIA-CHAIR
	(IN DRAWING-ROOM)
	(DESC "armchair")
	(ADJECTIVE ARM SATIN)
	(SYNONYM CHAIR SEAT ARMCHAIR CUSHION)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT VOWELBIT)
	(CAPACITY 99)>
][
<ROOM GREAT-HALL
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT DOORBIT WEARBIT)
	(DESC "new great hall")
	(ADJECTIVE GREAT NEW ;DRAWING)
	(SYNONYM HALL DOOR ;DOORS ROOM)
	(GENERIC GENERIC-GREAT-HALL)
	(LINE 1)
	(STATION GREAT-HALL)
	(CHARACTER 2)
	(GLOBAL GREAT-HALL FOYER CHAIR FIREPLACE
		WINDOW TABLE-RANDOM STAIRS DRAWING-ROOM)
	(THINGS <PSEUDO ( <> RADIO	RANDOM-PSEUDO)
			( TRESYLLIAN ARMS	BROCHURE-PSEUDO)
			( TRESYLLIAN CREST	BROCHURE-PSEUDO)
			( WOOD CARVING	BROCHURE-PSEUDO)>)
	(UP	TO GALLERY)
	;(SOUTH	TO GALLERY)
	(OUT	TO FOYER IF FOYER ;FOYER-DOOR IS OPEN)
	(NORTH	TO FOYER IF FOYER ;FOYER-DOOR IS OPEN)
	(IN	TO DRAWING-ROOM IF GREAT-HALL IS OPEN)
	(EAST	TO DRAWING-ROOM IF GREAT-HALL ;DRAWING-DOOR IS OPEN)
	;(SW	TO SITTING-ROOM IF SITTING-ROOM ;SITTING-DOOR IS OPEN)
	(WEST	TO CORR-1)
	(ACTION GREAT-HALL-F)>

<ROUTINE GREAT-HALL-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL-LIKE-BROCHURE>
	<GREAT-HALL-IS-FLOORED>
	<RTRUE>)
       (<EQUAL? .RARG ,M-FLASH>
	<COND (<AND <IN? ,DEB ,GREAT-HALL>
		    <NOT <FSET? ,DEB ,TOUCHBIT>>
		    <ZERO? ,CLOCK-WAIT>>
	       <FSET ,DEB ,TOUCHBIT>
	       <FCLEAR ,DEB ,NDESCBIT>
	       <COND (<AND <EQUAL? <LOC ,OFFICER> ,HERE ,PSEUDO-OBJECT>
			   <=? <GETP ,DEB ,P?LDESC> 1 ;"dancing">>
		      <TELL
"A young couple are dancing to the faint sound of rock music from
a portable radio on a table nearby.|">)>
	       <TELL <GETP ,DEB ,P?TEXT> CR>
	       <COMMON-DESC ,OFFICER>	;<PERFORM ,V?EXAMINE ,OFFICER>
	       <TELL "|
They stop dancing, turn off the radio, and greet you."
;", with affected smiles and half-hidden curiosity.">
	       <COND (<EQUAL? <LOC ,FRIEND> ,HERE ,PSEUDO-OBJECT>
		      <TELL
!\  'FRIEND ,INTRODUCES "them as the Honourable Iris Vane and Lt.
Ian Fordyce of Her Majesty's Coldstream Guards.|">)>
	       <PUTP ,DEB ,P?LDESC 0>
	       <THIS-IS-IT ,DEB>
	       <PUTP ,OFFICER ,P?LDESC 0>
	       <THIS-IS-IT ,OFFICER>
	       <QUEUE I-TOUR 0>
	       <QUEUE I-REPLY ;1 ,CLOCKER-RUNNING>
	       ;<ESTABLISH-GOAL ,DOCTOR ,HERE>
	       <COND (<OR <ZERO? ,GENDER-KNOWN>
			  <NOT <FSET? ,PLAYER ,FEMALE>>>
		      <COND (<ZERO? ,GENDER-KNOWN>
			     <TELL
"\"What a lark, having a Yank sleuth in our midst">)
			    (T <TELL
"\"My dear! What a handsome addition to your guest list">)>
		      <TELL "!\" chirps Iris. Her green eyes sparkle ">
		      <COND (<ZERO? ,GENDER-KNOWN>
			     <TELL "a trifle malic">)
			    (T <TELL "flirtat">)>
		      <TELL "iously as she offers you her delicate hand. ">
		      <COND (<ZERO? ,GENDER-KNOWN>
			     <SETG QCONTEXT ,OFFICER>
			     ;<THIS-IS-IT ,OFFICER>
			     <PUTP ,OFFICER ,P?LDESC 12 ;"listening to you">
			     <SETG AWAITING-REPLY ,OFFICER-1-R>
			     <TELL
"\"I always find Americans so innocently fascinating! I'm sure you'll
have loads to tell us about the baffling mysteries you've solved...\"|
\"Belt up, Iris, there's a good girl,\" says Ian. Flashing
you an apologetic smile, he comments, \"Spoiled rotten, I'm afraid.
Personally I should like nothing better than to hear all about your
mystery cases. But first tell us: " <GET ,QUESTIONS ,AWAITING-REPLY> "\"|">
			     <RFATAL>)
			    (T
			     <SETG QCONTEXT ,DEB>
			     ;<THIS-IS-IT ,DEB>
			     <PUTP ,DEB ,P?LDESC 12 ;"listening to you">
			     <SETG AWAITING-REPLY ,DEB-C>
			     <TELL
"\"Tell me, "TN" -- " <GET ,QUESTIONS ,AWAITING-REPLY> "\"|">
			     <RFATAL>)>)
		     (T
		      <COND (<EQUAL? ,VARIATION ,FRIEND-C>
			     <TELL
'DEB " pulls Jack aside, whispers something to him, and giggles." CR>)>
		      <SETG QCONTEXT ,OFFICER>
		      <THIS-IS-IT ,OFFICER>
		      <PUTP ,OFFICER ,P?LDESC 12 ;"listening to you">
		      <SETG AWAITING-REPLY ,OFFICER-2-R>
		      <TELL
"\"I say!\" exclaims Ian, bringing your hand to his lips.
His glance runs swiftly over your face and figure with an
air of expert appraisal. \"" <GET ,QUESTIONS ,AWAITING-REPLY> "\"|">
		      <RFATAL>)>)>)
       ;(<EQUAL? .RARG ,M-EXIT>
	<COND (<T? ,AWAITING-REPLY>
	       <SETG CLOCK-WAIT T>
	       <PLEASE-ANSWER>
	       <RTRUE>)>)>>

<ROUTINE GREAT-HALL-IS-FLOORED ()
	<TELL
"The hall is floored with black and white marble tiles. They've been worn
smooth by footsteps over the centuries, especially near
the archway to the " 'DRAWING-ROOM "." CR>>

<OBJECT ARMOR
	(IN GREAT-HALL)
	(DESC "suit of armour")
	;(ADJECTIVE ARMOR ARMOUR)
	(SYNONYM SUIT ARMOR ARMOUR HELMET)
	(FLAGS CONTBIT ;OPENBIT NDESCBIT SEENBIT)
	(CAPACITY 99)
	(ACTION ARMOR-F)>

<ROUTINE ARMOR-F ()
 <FCLEAR ,ARMOR ,NDESCBIT>
 <COND (<VERB? EXAMINE>
	<TELL
"This is a full suit of steel body armour. It creaks as you walk past."
;", from helmet down to sabbaton." CR>)
       (<VERB? ;EXAMINE LOOK-INSIDE OPEN SEARCH SEARCH-FOR>
	<COND (<AND <IN? ,CLUE-3 ,ARMOR>
		    <FSET? ,CLUE-3 ,SECRETBIT>>
	       <FSET ,ARMOR ,OPENBIT>
	       <DISCOVER ,CLUE-3>)>)>>
][
<OBJECT SECRET-SITTING-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET ;TRAP PASSAGE SEAT)	;"TRAP is verb?"
	(SYNONYM DOOR)
	(FLAGS SECRETBIT DOORBIT LOCKED)
	;(GENERIC GENERIC-SITTING-DOOR)
	(ACTION SECRET-SITTING-DOOR-F)>

<ROUTINE SECRET-SITTING-DOOR-F ()
 <COND (<VERB? LOOK-INSIDE OPEN>
	<COND (T ;<NOT <FSET? ,SECRET-SITTING-DOOR ,OPENBIT>>
	       <TELL "It seems to be stuck closed." CR>)>)>>

<ROOM SITTING-ROOM
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT OPENBIT DOORBIT WEARBIT)
	(DESC "sitting room")
	(ADJECTIVE SITTING ;ROOM SLIDING)
	(SYNONYM ROOM DOOR ;DOORS)
	;(LDESC "[N to corridor]")
	(LINE 1)
	(STATION CORR-1)
	(CHARACTER 2)
	(GLOBAL SITTING-ROOM ;SITTING-DOOR SECRET-SITTING-DOOR CHAIR FIREPLACE
		WINDOW)
	;(WEST	TO SITTING-PASSAGE IF SECRET-SITTING-DOOR IS OPEN)
	(DOWN	TO SITTING-PASSAGE IF SECRET-SITTING-DOOR IS OPEN)
	(IN	TO SITTING-PASSAGE IF SECRET-SITTING-DOOR IS OPEN)
	;(EAST	TO GREAT-HALL IF SITTING-ROOM ;SITTING-DOOR IS OPEN)
	(OUT	TO CORR-1 IF SITTING-ROOM ;SITTING-DOOR IS OPEN)
	(NORTH	TO CORR-1 IF SITTING-ROOM ;SITTING-DOOR IS OPEN)
	(ACTION SITTING-ROOM-F)>

<ROUTINE SITTING-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ;,M-EXIT>
	<SECRET-CHECK .RARG>)
       ;(<EQUAL? .RARG ,P?WEST ,P?IN ,P?DOWN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL-LIKE-BROCHURE ;,SECRET-SITTING-DOOR>
	<TELL
"It's a comfy place to read a book, play the piano, or just relax." CR>
	<DESCRIBE-CONTENTS ,PIANO>
	<DESCRIBE-CONTENTS ,WRITING-DESK>
	<RTRUE>)>>

<OBJECT WYVERN
	(IN SITTING-ROOM)
	(DESC "window seat" ;"wyvern")
	(ADJECTIVE WINDOW OTHER)
	(SYNONYM SEAT WYVERN GARGOYLE DRAGON)
	(FLAGS NDESCBIT VEHBIT SURFACEBIT SEENBIT)
	(ACTION WYVERN-F)>

<ROUTINE WYVERN-F () ;("OPT" (ARG 0))
 <COND ;(<T? .ARG> <RFALSE>)
       ;(<VERB? EXAMINE>
	<TELL
"Like a tiny gargoyle, a carved wyvern projects over each end of
the " 'WYVERN "." CR>)
       (<VERB? LOOK-INSIDE OPEN>
	<SECRET-SITTING-DOOR-F>)
       (<VERB? BOARD CLIMB-ON SIT SIT-AT>
	;<SETG PLAYER-SEATED ,WYVERN>
	<MOVE ,PLAYER ,WYVERN>
	<TELL "Okay, but it's not that comfortable." CR>)
       (<VERB? MOVE MOVE-DIR MUNG PUSH RUB SLAP TURN>
	<OPEN-SECRET "tug at" ,WYVERN ,SECRET-SITTING-DOOR>
	<FCLEAR ,SECRET-SITTING-DOOR ,OPENBIT>
	<TELL "Before you know it, ">
	<COND (<IN? ,PLAYER ,WYVERN>
	       ;<EQUAL? ,PLAYER-SEATED ,WYVERN>
	       ;<SETG PLAYER-SEATED <>>
	       <TELL "you're dumped into it.|">
	       <GOTO ,SITTING-PASSAGE>)
	      (T
	       <TELL "it creaks upward to close again." CR>)>
	<RTRUE>)>>

<OBJECT WRITING-DESK
	(IN SITTING-ROOM)
	(DESC "writing desk")
	(ADJECTIVE WRITING)
	(SYNONYM DESK)
	(FLAGS SURFACEBIT OPENBIT NDESCBIT SEENBIT)
	(CAPACITY 999)
	(ACTION WRITING-DESK-F)>

<ROUTINE WRITING-DESK-F ()
 <COND (<REMOTE-VERB?>
	<RFALSE>)
       (<IN? ,LETTER-MAID ,WRITING-DESK>
	<FCLEAR ,LETTER-MAID ,NDESCBIT>
	<RFALSE>)>>

<OBJECT PIANO
	(IN SITTING-ROOM)
	(DESC "piano")
	;(ADJECTIVE DINING)
	(SYNONYM PIANO)
	(FLAGS NDESCBIT SURFACEBIT OPENBIT SEENBIT SEARCHBIT VEHBIT)
	(CAPACITY 999)
	(ACTION PIANO-F)>

<GLOBAL PIANO-PIECES
	<PTABLE "solo" "duet" "trio" "quar" "quin" "sex" "sep" "oc">>

<ROUTINE PIANO-F ("AUX" O (N 0))
 <COND (<VERB? LISTEN>
	<SET O <FIRST? <LOC ,PIANO>>>
	<REPEAT ()
	 <COND (<NOT .O>
		<RFALSE>)
	       (<AND <FSET? .O ,PERSONBIT>
		     <==? <GETP .O ,P?LDESC> 22 ;"playing the piano">>
		<TELL "The music sounds lovely." CR>
		<RTRUE>)
	       (T <SET O <NEXT? .O>>)>>)
       (<VERB? PLAY>
	<PUTP ,WINNER ,P?LDESC 22 ;"playing the piano">
	<COND (<AND <T? ,PRSI>
		    <FSET? ,PRSI ,PERSONBIT>>
	       <PUTP ,PRSI ,P?LDESC 22 ;"playing the piano">)>
	<TELL CHE ,WINNER sit " down">
	<SET O <FIRST? ,SITTING-ROOM>>
	<REPEAT ()
		<COND (<NOT .O>
		       <COND (<ZERO? .N>
			      <TELL " and">)>
		       <RETURN>)
		      (<AND <EQUAL? <GETP .O ,P?LDESC> 22 ;"playing the piano">
			    ;<FSET? .O ,PERSONBIT>
			    <NOT <==? .O ,WINNER>>>
		       <COND (<ZERO? .N> <TELL " with">)>
		       <INC N>
		       <TELL !\  D .O " and">)>
		<SET O <NEXT? .O>>>
	<COND (<ZERO? .N>
	       <TELL V ,WINNER play>)
	      (T
	       <COND (<==? <GETP ,PLAYER ,P?LDESC> 22 ;"playing the piano">
		      <TELL " you ">
		      <COND (<1? .N> <TELL "both">)
			    (T <TELL "all">)>)
		     (T <TELL " they">)>
	       <TELL " play">)>
	<TELL " a lovely " <GET ,PIANO-PIECES .N>>
	<COND (<G? .N 2> <TELL "tet">)>
	<TELL "." CR>)
       (<REMOTE-VERB?>
	<RFALSE>)
       (<IN? ,MUSIC ,PIANO>
	<FCLEAR ,MUSIC ,NDESCBIT>
	<RFALSE>)>>

<OBJECT MUSIC
	(IN PIANO)
	(DESC "piece of music")
	(SYNONYM PIECE ;SHEET MUSIC SONG)
	(FLAGS TAKEBIT READBIT NDESCBIT)
	(SIZE 2)
	(ACTION MUSIC-F)>

<ROUTINE MUSIC-F ()
 <COND (<VERB? LISTEN PLAY>
	<COND (<IN? ,PIANO ,HERE>
	       <PIANO-F>)
	      (T <NOT-HERE ,PIANO>)>
	<RTRUE>)
       (<REMOTE-VERB?>
	<RFALSE>)>
 <FCLEAR ,MUSIC ,NDESCBIT>
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<TELL "It's ">
	<COND ;(<EQUAL? ,VARIATION ,LORD-C>
	       <TELL
"called \"Fave Heavy Metal Songs of H.R.H. Prince Charles.\"" CR>)
	      (<EQUAL? ,VARIATION ,PAINTER-C ;,FRIEND-C>
	       <TELL
"Beethoven's \"Suite No. 9.\" Someone has drawn a star in red ink
over the first four letters of the word \"SUITe.\"" CR>)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>
	       <TELL
"\"Funeral March of a Marionette.\"" CR>)
	      (T ;<EQUAL? ,VARIATION ,FRIEND-C>
	       <TELL
"theme music from the American radio show, \"A Prairie Home
Companion.\"" CR>)>)
       (T <RFALSE>)>>
]
<ROOM CORR-1
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT WEARBIT)
	(DESC "ground-floor corridor")
	(ADJECTIVE GROUND)
	(SYNONYM CORRIDOR ROOM)
	(LINE 1)
	(STATION CORR-1)
	(CHARACTER 2)
	(CORRIDOR 1)
	(GLOBAL SITTING-ROOM DINING-ROOM)
	(EAST	TO GREAT-HALL)
	(OUT	TO GREAT-HALL)
	(WEST	TO JUNCTION)
	(NORTH	TO DINING-ROOM IF DINING-ROOM IS OPEN)
	(SOUTH	TO SITTING-ROOM IF SITTING-ROOM IS OPEN)
	(ACTION CORR-1-F)>

<ROUTINE CORR-1-F ("OPTIONAL" (ARG 0))
 <COND (<==? .ARG ,M-LOOK>
	<TELL
"The " 'CORR-1 " goes between the two great halls to east and west.
Behind sliding doors, the " 'DINING-ROOM " is north and the " 'SITTING-ROOM "
is south." CR>)>>

[
<ROOM DINING-ROOM
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT DOORBIT WEARBIT)
	(DESC "dining room")
	(ADJECTIVE DINING SLIDING)
	(SYNONYM ROOM DOOR ;DOORS)
	(GLOBAL ;CHAIR DINING-ROOM FIREPLACE WINDOW OIL-PAINTING)
	(THINGS <PSEUDO ( PORCEL VASE	BROCHURE-PSEUDO)
			( PORCEL VASES	BROCHURE-PSEUDO)
			( <> SHELF	BROCHURE-PSEUDO)
			( <> SHELVES	BROCHURE-PSEUDO)>)
	(LINE 1)
	(STATION DINING-ROOM)
	(CHARACTER 2)
	(IN	TO BACKSTAIRS)
	(WEST	TO BACKSTAIRS)
	(OUT	TO CORR-1 IF DINING-ROOM IS OPEN)
	(SOUTH	TO CORR-1 IF DINING-ROOM IS OPEN)
	(ACTION DINING-ROOM-F)>

<GLOBAL DINING-DESC
"This room is impeccably furnished, but it's too formal for relaxing.|">

<ROUTINE DINING-ROOM-F ("OPTIONAL" (RARG 0) "AUX" N)
 <COND (<EQUAL? .RARG ,M-LOOK>
	<TELL ,DINING-DESC>
	<RTRUE>)
       (<==? .RARG ,M-ENTER>
	<COND (<QUEUED? ,I-DINNER-SIT>
	       ;<COND (<NOT <FSET? ,DINING-ROOM ,TOUCHBIT>>
		      <FSET ,DINING-ROOM ,TOUCHBIT>
		      <TELL ,DINING-DESC>)>
	       <COND (<IN? ,LORD ,DINING-ROOM>
		      <QUEUE I-DINNER-SIT 1>
		      <RFALSE>)
		     (T
		      <SET N <FIND-FLAG-HERE ,PERSONBIT ,PLAYER ,BUTLER>>
		      <COND (<ZERO? .N> <RFALSE>)>
		      <TELL CHE .N" says, \"Let's wait for his lordship.\""CR>
		      <RTRUE>)>)
	      (<AND ;<FSET? ,DINNER ,TAKEBIT>
		    <T? ,MISSED-DINNER>
		    ;<QUEUED? ,I-LIONEL-SPEAKS>
		    <IN? ,FRIEND ,HERE>>
	       <SETG MISSED-DINNER <>>
	       <COND (<NOT <FSET? ,DINING-ROOM ,TOUCHBIT>>
		      <FSET ,DINING-ROOM ,TOUCHBIT>
		      <TELL ,DINING-DESC>)>
	       <THIS-IS-IT ,FRIEND>
	       <SETG QCONTEXT ,FRIEND>
	       ;<MAKE-ALL-PEOPLE 10 ;"eating with relish" ,DINING-ROOM>
			;"in I-DINNER-SIT"
	       <TELL
'FRIEND " says, \"We didn't know when you would come to dinner, so we
started without you.">
	       <COND (<==? ,LIONEL-SPEAKS-COUNTER ,INIT-LIONEL-SPEAKS-COUNTER>
		      <TELL "\"" CR>)
		     (T
		      <QUEUE I-DINNER-TALK 1>
		      <TELL " And ">
		      <COND (<ZERO? ,LIONEL-SPEAKS-COUNTER>
			     <TELL "then Lionel spoke">)
			    (T
			     <TELL "now Lionel is speaking">)>
		      <TELL " on tape!\"" CR>)>)>)
       (<==? .RARG ,M-EXIT>
	<COND (<AND <QUEUED? ,I-LIONEL-SPEAKS>
		    ;<NOT <==? ,LIONEL-SPEAKS-COUNTER
			      ,INIT-LIONEL-SPEAKS-COUNTER>>
		    ;<T? ,LIONEL-SPEAKS-COUNTER>>
	       <TELL 'LORD " politely but firmly vetoes any such move. \"">
	       <COND (<==? ,LIONEL-SPEAKS-COUNTER ,INIT-LIONEL-SPEAKS-COUNTER>
		      <TELL
"It's annoying enough to have the servants abscond at dinner time,\"
he points out drily. " ,JACK-THINKS-GLADYS
" Cigars and port will be time enough for that sort of aggro!\"" CR>)
		     (T <TELL "Let's hear what old Lionel has to say.\"" CR>)>
	       <RTRUE>)>)>>

<ROUTINE I-DINNER-TALK ("OPTIONAL" (GARG <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-DINNER-TALK:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<FSET ,DINNER ,TAKEBIT>
	<FCLEAR ,DINNER ,TRYTAKEBIT>
	<MOVE ,DINNER-2 ,TABLE-DINING ;,GLOBAL-OBJECTS>
	;<MOVE ,DINNER-3 ,TABLE-DINING ;,GLOBAL-OBJECTS>
	<DINNER-TALK <QUEUED? ,I-LIONEL-SPEAKS>>
	<RFATAL>>

<GLOBAL WRONG-OUTFIT:NUMBER 0>
<GLOBAL WASHED:FLAG 0>

<ROUTINE DINNER-TALK (N "AUX" X)
	;<SET X <GET ,P-ITBL ,P-VERBN>>
	;<COND (<T? .X>		;"for VERB-PRINT"
	       <PUT .X 0 ,W?EAT>)>
	<MOVE ,PLAYER ,CHAIR-DINING>
	<TELL "Several people glance at your outfit with ">
	<COND (<NOT <EQUAL? ,NOW-WEARING ,DINNER-OUTFIT>>
	       <SETG WRONG-OUTFIT 2>
	       <TELL "dis">)
	      (T <SETG WRONG-OUTFIT 1>)>
	<TELL "approval.">
	<COND (<ZERO? ,WASHED>
	       <TELL " They whisper about how dirty you still look.">)>
	<CRLF>
	<COND (<==? ,LIONEL-SPEAKS-COUNTER
		    ,INIT-LIONEL-SPEAKS-COUNTER>
	       <TELL
'LORD " announces his engagement to " 'FRIEND ", prompting various reactions
from the guests.|
The dinner is excellent, with a flow of subdued conversation...|">)>
	<PUTP ,LORD ,P?LDESC 0>
	<SETG KEEP-WAITING T>
	<V-WAIT .N <> T>>

<ROUTINE POPULATION (RM "OPTIONAL" (NOT1 <>) (NOT2 <>) "AUX" (CNT 0) OBJ)
 <SET OBJ <FIRST? .RM>>
 <COND (<ZERO? .OBJ> <RFALSE>)>
 <REPEAT ()
	 <COND (<AND <FSET? .OBJ ,PERSONBIT>
		     <NOT <FSET? .OBJ ,INVISIBLE>>
		     <OR <ZERO? .NOT1> <NOT <EQUAL? .OBJ .NOT1>>>
		     <OR <ZERO? .NOT2> <NOT <EQUAL? .OBJ .NOT2>>>>
		<SET CNT <+ .CNT 1>>)
	       (<FSET? .OBJ ,CONTBIT>
		<SET CNT <+ .CNT <POPULATION .OBJ .NOT1 .NOT2>>>)>
	 <SET OBJ <NEXT? .OBJ>>
	 <COND (<ZERO? .OBJ> <RETURN .CNT>)>>>

<OBJECT BUST
	(IN DINING-ROOM)
	(DESC "bronze bust")
	(DESCFCN BUST-D)
	(ADJECTIVE BRONZE LI\'S LIONEL ;"handles BUST OF LIONEL!")
	(SYNONYM BUST STATUE SCULPT LIONEL)
	(FLAGS CONTBIT ;OPENBIT SEARCHBIT TRYTAKEBIT)
	(CAPACITY 5)
	(SIZE 13)
	(ACTION BUST-F)>

<ROUTINE BUST-D (ARG)
	<THIS-IS-IT ,COUSIN>
	<TELL
"A brooding bust of " 'COUSIN " (sculpted by " 'PAINTER ") is
displayed in a corner." CR>>

<ROUTINE BUST-F ()
 <COND (<OR <VERB? EXAMINE LOOK-UNDER MOVE MOVE-DIR OPEN PUSH ;TURN>
	    <AND <VERB? TAKE>
		 <EQUAL? ,P-PRSA-WORD ,W?RAISE ,W?LIFT>>>
	<COND (<AND <VERB? EXAMINE>
		    <==? ,LIONEL-SPEAKS-COUNTER ,INIT-LIONEL-SPEAKS-COUNTER>>
	       <TELL-LIKE-BROCHURE>
	       <RTRUE>)>
	<TELL
"The " 'BUST " is hollow. When you lift it from its shelf, you discover"
THE ,RECORDER " underneath, with an elaborate clockwork timer.">
	<FSET ,BUST ,OPENBIT>	;"in I-LIONEL-SPEAKS too"
	<FSET ,RECORDER ,SEENBIT>
	<COND (<NOT <==? ,LIONEL-SPEAKS-COUNTER ,INIT-LIONEL-SPEAKS-COUNTER>>
	       <TELL
" Evidently the timer was set to play the tape during the usual dinner
hour on this date.">)>
	<CRLF>)
       (<VERB? LISTEN PLAY>
	<COND (<AND <QUEUED? ,I-LIONEL-SPEAKS>
		    ;<NOT <==? ,LIONEL-SPEAKS-COUNTER
			      ,INIT-LIONEL-SPEAKS-COUNTER>>
		    ;<T? ,LIONEL-SPEAKS-COUNTER>>
	       <SETG LIONEL-FORCED T>		;"to suppress CR"
	       <QUEUE I-LIONEL-SPEAKS 1>	;"will respond"
	       <RTRUE>)
	      (T <TELL ,TIMER-PREVENTS-IT> <RTRUE>)>)>>

<GLOBAL TIMER-PREVENTS-IT "The clockwork timer prevents it.|">

<OBJECT RECORDER
	(IN BUST)
	(DESC "small tape recorder")
	(ADJECTIVE LI\'S HIS TAPE SMALL CLOCKWORK)
	(SYNONYM RECORD TAPE ;LIONEL TIMER)
	(GENERIC GENERIC-RECORDER)
	;(CAPACITY 2)
	;(SIZE 5)
	(ACTION RECORDER-F)>

<ROUTINE RECORDER-F ()
 <COND (<VERB? EXAMINE LISTEN PLAY>
	<BUST-F>)
       (<VERB? LAMP-ON LAMP-OFF>
	<TELL ,TIMER-PREVENTS-IT>
	<RTRUE>)
       (<VERB? TAKE>
	<TELL "It's fastened tightly to the shelf." CR>)
       (<SPEAKING-VERB? ,RECORDER>
	<WONT-HELP-TO-TALK-TO ,RECORDER>)>>

<OBJECT TABLE-DINING
	(IN DINING-ROOM)
	(DESC "dining table")
	(ADJECTIVE DINING)
	(SYNONYM TABLE)
	(FLAGS SURFACEBIT OPENBIT SEENBIT SEARCHBIT ;NDESCBIT)
	(CAPACITY 999)
	(ACTION TABLE-DINING-F)>

<ROUTINE TABLE-DINING-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-ON>
	<COND (<FSET? ,DINNER ,TAKEBIT>
	       <TELL-AS-WELL-AS ,TABLE-DINING " the remains of dinner">
	       <RTRUE>)>)
       (<VERB? SIT-AT>
	<PERFORM ,V?SIT ,CHAIR-DINING>
	<RTRUE>)
       (<VERB? SIT>
	<HAR-HAR>
	<RTRUE>)>>

<OBJECT CHAIR-DINING
	(IN DINING-ROOM)
	(DESC "chair")
	(ADJECTIVE DINING MY)
	(SYNONYM CHAIR SEAT CHAIRS BENCH)
	(FLAGS SURFACEBIT OPENBIT SEARCHBIT VEHBIT NDESCBIT)
	(CAPACITY 99)
	;(ACTION CHAIR-DINING-F)>

<OBJECT SIDEBOARD
	(IN DINING-ROOM)
	(DESC "sideboard")
	(ADJECTIVE DINING SIDE)
	(SYNONYM SIDEBOARD BOARD)
	(FLAGS SURFACEBIT OPENBIT SEENBIT SEARCHBIT)
	(CAPACITY 99)>

<OBJECT PUNCHBOWL
	(IN SIDEBOARD)
	(DESC "punchbowl")
	(ADJECTIVE PUNCH)
	(SYNONYM PUNCHBOWL BOWL)
	(FLAGS CONTBIT OPENBIT SEARCHBIT TRYTAKEBIT)
	(CAPACITY 9)
	(SIZE 10)
	(ACTION PUNCHBOWL-F)>

<ROUTINE PUNCHBOWL-F ("AUX" OBJ)
 <COND (<VERB? OPEN CLOSE>
	<HAR-HAR>)
       (<VERB? PUT-UNDER>
	<COND (<IOBJ? PUNCHBOWL>
	       <FSET ,PRSO ,NDESCBIT>
	       <MOVE ,PRSO ,SIDEBOARD>
	       <TELL "Okay." CR>)>)
       (<AND <VERB? LOOK-UNDER MOVE TAKE>
	     <DOBJ? PUNCHBOWL>>
	<COND ;(<AND <IN? ,CLUE-1 ,SIDEBOARD>
		    <FSET? ,CLUE-1 ,NDESCBIT>>
	       <FSET ,CLUE-1 ,TAKEBIT>
	       ;<FSET ,CLUE-1 ,SEENBIT>
	       <FCLEAR ,CLUE-1 ,NDESCBIT>
	       <THIS-IS-IT ,CLUE-1>
	       <TELL "You see" THE ,CLUE-1 ", lying face down." CR>)
	      (<SET OBJ <FIND-FLAG ,SIDEBOARD ,NDESCBIT>>
	       <FSET .OBJ ,TAKEBIT>
	       <FSET .OBJ ,TOUCHBIT>
	       <FCLEAR .OBJ ,NDESCBIT>
	       <MOVE .OBJ ,PLAYER>
	       <THIS-IS-IT .OBJ>
	       <TELL "You find" THE .OBJ " underneath, so you take it." CR>)
	      (T
	       ;<WONT-HELP>
	       <TELL "There's nothing under it." CR>)>)>>

<OBJECT DINNER
	(IN KITCHEN ;SIDEBOARD)
	(DESC "your dinner")
	(ADJECTIVE COVERED MY)
	(SYNONYM DINNER FOOD ;ARRAY DISHES PLATE ;FISH)
	(GENERIC GENERIC-DINNER)
	(FLAGS NARTICLEBIT TRYTAKEBIT)
	(SIZE 10)
	(DESCFCN DINNER-D)
	(ACTION DINNER-F)>

<ROUTINE DINNER-D (ARG "AUX" (L <LOC ,DINNER>))
 <COND (<EQUAL? .L ,KITCHEN ,SIDEBOARD>
	<TELL "An appetizing aroma wafts from an array of covered dishes">
	<COND (<==? .L ,KITCHEN>
	       <TELL " sitting about">)
	      (<==? .L ,SIDEBOARD>
	       <TELL " on the " 'SIDEBOARD>)>
	<TELL "." CR>)>>

<ROUTINE DINNER-F ("AUX" I (L <LOC ,DINNER>))
 <COND (<VERB? DRESS>
	<COND (<EQUAL? ,HERE <META-LOC ,DINNER-OUTFIT>>
	       <PERFORM ,V?WEAR ,DINNER-OUTFIT>
	       <RTRUE>)
	      (T
	       <NOT-HERE ,DINNER-OUTFIT>
	       <RTRUE>)>)
       (<VERB? EAT>
	<COND ;(<FSET? ,DINNER ,TRYTAKEBIT>	;<QUEUED? ,I-DINNER-SIT>
	       <TELL
"You look around and notice that no one else is eating yet." CR>)
	      (T <TELL "You take a bite and find it delicious." CR>)>)
       (<VERB? EXAMINE ;SMELL>
	<TELL
"A lovely assortment of fish, fowl, greens, and sweets fills the ">
	<COND (<EQUAL? .L ,KITCHEN ,SIDEBOARD>
	       <TELL "dishes." CR>)
	      (T <TELL "plate." CR>)>)
       (<VERB? TAKE LAMP-ON ;"start">
	<COND (<FSET? ,DINNER ,TRYTAKEBIT>
	       <COND (<==? .L ,KITCHEN>
		      <TELL "It's not ready yet." CR>)
		     (<==? .L ,SIDEBOARD>
		      <SET L <I-DINNER-SIT>>
		      <COND (<ZERO? .L>
			     <TELL
"You look around and notice that no one else is eating yet."
;"Not all the guests are ready yet." CR>
			     <RTRUE>)
			    (T <RETURN .L>)>)>)
	      ;(<==? <ITAKE> T>
	       <COND (<EQUAL? ,HERE ,DINING-ROOM>
		      <MOVE ,DINNER ,TABLE-DINING>
		      <FSET ,DINNER ,NDESCBIT>
		      <TELL
CHE ,WINNER put " it on the " 'TABLE-DINING "." CR>)>)>)
       (<VERB? WAIT-FOR>
	<COND (<SET I <QUEUED? ,I-DINNER>>
	       <V-WAIT <- ,DINNER-TIME ,PRESENT-TIME> ;.I <> T>
	       <RTRUE>)>)
       (<VERB? WALK-TO>
	<COND (<EQUAL? ,HERE ,DINING-ROOM>
	       <PERFORM ,PRSA <META-LOC ,DINNER>>)
	      (T <PERFORM ,PRSA ,DINING-ROOM>)>
	<RTRUE>)>>

<OBJECT DINNER-2
	;(IN GLOBAL-OBJECTS)
	(DESC "other dinner")
	(ADJECTIVE OTHER JACK\'S HYDE\'S IAN\'S DOC\'S TAM\'S VIV\'S IRIS\'S)
	(SYNONYM DINNER)
	(FLAGS VOWELBIT NDESCBIT)
	(GENERIC GENERIC-DINNER)>

;<OBJECT DINNER-3
	;(IN GLOBAL-OBJECTS)
	(DESC "her dinner")
	(ADJECTIVE OTHER HER TAM\'S VIV\'S IRIS\'S)
	(SYNONYM DINNER)
	(FLAGS NARTICLEBIT NDESCBIT)
	(GENERIC GENERIC-DINNER)>
]
<OBJECT SECRET-DINING-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET PASSAGE)
	(SYNONYM DOOR)
	(FLAGS SECRETBIT DOORBIT)>

<ROOM BACKSTAIRS
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT WEARBIT NARTICLEBIT)
	(DESC "backstairs")
	;(ADJECTIVE BACKST BACK)
	(SYNONYM BACKST) ;( STAIR STAIRS AREA)
	;(GENERIC GENERIC-STAIRS)
	(GLOBAL SECRET-DINING-DOOR STAIRS)
	(LINE 1)
	(STATION BACKSTAIRS)
	(CHARACTER 2)
	(WEST	TO DINING-PASSAGE IF SECRET-DINING-DOOR IS OPEN)
	(IN	TO DINING-PASSAGE IF SECRET-DINING-DOOR IS OPEN)
	(OUT	TO DINING-ROOM)
	(EAST	TO DINING-ROOM)
	(DOWN	TO KITCHEN)
	(ACTION BACKSTAIRS-F)>

<ROUTINE BACKSTAIRS-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ;,M-EXIT>
	<SECRET-CHECK .RARG>)
       ;(<EQUAL? .RARG ,P?WEST ,P?IN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"You can go east to the " 'DINING-ROOM " or down narrow stairs
to the " 'KITCHEN ".">
	<OPEN-DOOR? ,SECRET-DINING-DOOR>
	<CRLF>)>>
[
<ROOM KITCHEN
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT WEARBIT)
	(DESC "kitchen")
	(SYNONYM KITCHEN)
	(GLOBAL CHAIR BELL ;SERVANTS-QUARTERS STAIRS)
	(THINGS <PSEUDO ( KITCHEN SINK	RANDOM-PSEUDO)>)
	(LINE 1)
	(STATION KITCHEN)
	(CHARACTER 1)
	(WEST	TO BASEMENT)
	(IN	TO BASEMENT)
	(EAST	"You peek in and see nothing interesting in there.")
	;(EAST	TO SERVANTS-QUARTERS IF SERVANTS-QUARTERS IS OPEN)
	(UP	TO BACKSTAIRS)
	(OUT	TO BACKSTAIRS)
	(ACTION KITCHEN-F)>

<ROUTINE KITCHEN-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-LOOK>
	<TELL
"The " 'KITCHEN " is large yet cramped. From here, you can go west to
the tower " 'BASEMENT ", east to the servants' quarters, or up the
stairs." CR>)>>

<OBJECT LAMP
	(IN KITCHEN)
	(ADJECTIVE BRASS ;BATTER)
	(SYNONYM LAMP LANTERN ;LIGHT)
	(DESC "brass lantern")
	(FLAGS TAKEBIT LIGHTBIT ;SEENBIT)
	(ACTION LANTERN)
	;(FDESC "A dusty brass lantern is sitting in a corner.")
	;(LDESC "There is a brass lantern (battery-powered) here.")
	(SIZE 15)>

<ROUTINE LANTERN ()
	 <COND (<VERB? AIM>
		<TELL
CTHE ,LAMP " shines in all " 'INTDIR "s, so you can't point it." CR>)
	       ;(<VERB? THROW-AT ;THROW-OFF THROW-THROUGH>
		<TELL
"The lamp has smashed into the floor, and the light has gone out.|">
		;<DISABLE <INT I-LANTERN>>
		<REMOVE-CAREFULLY ,LAMP>
		<MOVE ,BROKEN-LAMP ,HERE>
		<RTRUE>)
	       (<VERB? USE>
		<PERFORM ,V?LAMP-ON ,PRSO>
		<RTRUE>)
	       (<VERB? EXAMINE>
		<TELL "The lamp ">
		<COND (<FSET? ,LAMP ,ONBIT>
		       <TELL "is on.">)
		      (T
		       <TELL "is turned off.">)>
		<CRLF>)>>
]
;<ROOM SERVANTS-QUARTERS
	(IN ROOMS)
	(FLAGS ;ONBIT SEENBIT WEARBIT DOORBIT LOCKED)
	(DESC ;"servants'" "butler's quarters")
	(ADJECTIVE B\'S HIS ;"BUTLER BOLITHO ;SERVANT")
	(SYNONYM QUARTERS ROOM BEDROOM DOOR ;KEYHOLE)>

;<	(LDESC
"The only exit is west to the kitchen." ;"[W/OUT to kitchen]")
	(GLOBAL CHAIR)
	(LINE 1)
	(STATION KITCHEN)
	(CHARACTER 1)
	(WEST	TO KITCHEN)
	(OUT	TO KITCHEN)>

[
<ROOM GALLERY
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT WEARBIT)
	(DESC "gallery")
	(ADJECTIVE GALLERY)
	(SYNONYM GALLERY ROOM)
	(LINE 2)
	(STATION GALLERY)
	(CHARACTER 3)
	(GLOBAL	YOUR-ROOM VIVIEN-ROOM FIREPLACE WINDOW
		PEEPHOLE STAIRS)
	(OUT	TO GREAT-HALL ;STAIRS-NEW)
	(DOWN	TO GREAT-HALL ;STAIRS-NEW)
	;(SOUTH	TO GREAT-HALL)
	(EAST	TO YOUR-ROOM IF YOUR-ROOM ;YOUR-DOOR IS OPEN)
	(IN	TO YOUR-ROOM IF YOUR-ROOM ;YOUR-DOOR IS OPEN)
	(NE	TO EAST-HALL)
	(WEST	TO VIVIEN-ROOM IF VIVIEN-ROOM ;VIVIEN-DOOR IS OPEN)
	(NW	TO WEST-HALL)
	(ACTION GALLERY-F)>

<ROUTINE GALLERY-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-BEG>
	<COND (<AND <VERB? EXAMINE LOOK-BEHIND LOOK-UNDER SEARCH SEARCH-FOR>
		    <DOBJ? PAINTING-GALLERY WALL>>
	       <FCLEAR ,PEEPHOLE ,SECRETBIT>
	       <TELL
"You discover" HIM ,PEEPHOLE " in the eye of one ancestor." CR>)>)
       (<==? .RARG ,M-LOOK>
	<TELL
"The " 'GALLERY " spans the top of the double stairways. You can go east to
" 'YOUR-ROOM " or west to " 'VIVIEN-ROOM ". Hallways lead to the northeast and
northwest.
On the wall is a " D ,PAINTING-GALLERY " of " 'LORD "'s ancestors." CR>)>>

<OBJECT PAINTING-GALLERY
	(IN GALLERY)
	(DESC "series of oil paintings")
	(ADJECTIVE OIL ART DOUBLE)
	(SYNONYM PORTRAIT PICTURE PAINTING SERIES)
	;(GENERIC GENERIC-PAINTING)
	(FLAGS NDESCBIT SEENBIT)
	(ACTION PICTURE-F)>

<ROUTINE PICTURE-F ("OPTIONAL" (RARG 0))
 <COND (<VERB? EXAMINE>
	<TELL-LIKE-BROCHURE>)>>
][
<OBJECT BATHROOM
	(IN LOCAL-GLOBALS)
	(DESC "bathroom")
	(ADJECTIVE ;BATH TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S)
	(SYNONYM ;ROOM BATHROOM)
	;(GENERIC GENERIC-BEDROOM)
	(FLAGS SEENBIT)
	(ACTION BATHROOM-F)>

<ROUTINE BATHROOM-F ()
 <COND (<VERB? BOARD EXAMINE LOOK-INSIDE THROUGH WALK-TO>
	<COND (<EQUAL? ,HERE ,YOUR-ROOM>
	       <PERFORM ,PRSA ,YOUR-BATHROOM>
	       <RTRUE>)
	      (T <RANDOM-PSEUDO>)>)>>

<OBJECT FIREPLACE
	(IN LOCAL-GLOBALS)
	(DESC "fireplace")
	(ADJECTIVE FIRE ;"TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S")
	(SYNONYM PLACE FIREPLACE CHIMNEY FENDER)
	(FLAGS SEENBIT)
	(ACTION FIREPLACE-F)>

<ROUTINE FIREPLACE-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE LOOK-UP>
	<COND (<EQUAL? ,HERE ,IAN-ROOM>
	       <TELL-IAN-FIREPLACE>)
	      (T <TELL "It's empty, except for soot on the walls.">)>
	<CRLF>)
       (<VERB? LAMP-ON>	;"LIGHT FIRE"
	<WONT-HELP>)
       (<VERB? PUT-IN>
	<TELL
"When you think how sooty" THE ,PRSO " would get, you change your mind." CR>)>>

<ROUTINE BED-PSEUDO ()
 <COND (<VERB? BOARD CLIMB-ON LIE SIT THROUGH>
	<WONT-HELP>)>>

<OBJECT NIGHTSTAND-LG
	(IN LOCAL-GLOBALS)
	(DESC "night table")
	(ADJECTIVE NIGHT ;MARBLE
		TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S)
	(SYNONYM ;NIGHTT TABLE ;STAND CONSOLE TALLBOY COMMODE)
	(FLAGS SEENBIT)
	(ACTION NIGHTSTAND-LG-F)>

<ROUTINE NIGHTSTAND-LG-F ()
 <COND (<AND <EQUAL? ,HERE ,JACK-ROOM>
	     <VERB? EXAMINE LOOK-INSIDE OPEN SEARCH SEARCH-FOR>>
	<COND (<IN? ,NECKLACE-OF-D ,JACK-ROOM>
	       <DISCOVER ,NECKLACE-OF-D>)
	      (T <TELL ,NOTHING-NEW> <RTRUE>)>)
       (<AND <EQUAL? ,HERE ,JACK-ROOM>
	     <VERB? PUT-IN>
	     <DOBJ? NECKLACE-OF-D>>
	<MOVE ,NECKLACE-OF-D ,JACK-ROOM>
	<FSET ,NECKLACE-OF-D ,NDESCBIT>
	<OKAY>)
       (T <RANDOM-PSEUDO>)>>

<OBJECT DRESSING-TABLE-LG
	(IN LOCAL-GLOBALS)
	(DESC "dressing table")
	(ADJECTIVE DRESSING ROLL-TOP WRITING)
	(SYNONYM TABLE BENCH CHEST DRESSE ;DRAWER)
	(FLAGS SEENBIT CONTBIT SURFACEBIT OPENBIT)
	(ACTION DRESSING-TABLE-LG-F)>

<ROUTINE DRESSING-TABLE-LG-F ()
 <COND (<VERB? OPEN CLOSE SEARCH SEARCH-FOR>
	<NOTHING-SPECIAL>)
       (<VERB? EXAMINE LOOK-INSIDE LOOK-ON>
	<COND (<EQUAL? ,HERE ,WENDISH-ROOM>
	       <WENDISH-STUFF-D>
	       <RTRUE>)
	      (<EQUAL? ,HERE ,TAMARA-ROOM>
	       <DRESSING-TABLE-TAM>
	       <CRLF>)
	      (T <NOTHING-SPECIAL>)>)>>

<OBJECT WARDROBE-LG
	(IN LOCAL-GLOBALS)
	(DESC "wardrobe")
	(ADJECTIVE CLOTHES)
	(SYNONYM WARDROBE PRESS)
	(FLAGS SEENBIT)
	(ACTION RANDOM-PSEUDO)>

<OBJECT MIRROR-GLOBAL
	(IN GLOBAL-OBJECTS)
	(DESC "mirror")
	(ADJECTIVE LOOKING CHEVAL)
	(SYNONYM MIRROR GLASS)
	(FLAGS SEENBIT CONTBIT)
	(ACTION MIRROR-GLOBAL-F)>

<ROUTINE MIRROR-GLOBAL-F ()
 <COND (<REMOTE-VERB?>
	<RFALSE>)
       (<NOT <FSET? ,HERE ,WORNBIT>>
	<NOT-HERE ,MIRROR-GLOBAL>)
       (<VERB? EXAMINE FIX LOOK-INSIDE MOVE>
	<DRESSING-MIRROR-F>)
       (T <RANDOM-PSEUDO>)>>

<ROUTINE OPEN-DOOR? (DR "OPTIONAL" (NOSP <>))
 <COND (<FSET? .DR ,OPENBIT>
	<COND (<ZERO? .NOSP> <TELL !\ >)>
	<THIS-IS-IT .DR>
	<COND (<SET NOSP <DOOR-ROOM ,HERE .DR>>
	       <FSET .NOSP ,SEENBIT>)>
	<TELL "And there's a wide-open " D .DR "!">)>>

;<OBJECT FURNITURE
	(IN LOCAL-GLOBALS)
	(DESC "furniture")
	(ADJECTIVE TAM\'S JACK\'S VIV\'S HYDE\'S IAN\'S DOC\'S IRIS\'S)
	(SYNONYM FURNITURE)
	(FLAGS SEENBIT)
	(ACTION RANDOM-PSEUDO)>
][
<OBJECT SECRET-YOUR-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE MY SECRET PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)>

<ADJ-SYNONYM MY MINE YOUR>

<ROOM YOUR-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "your bedroom")
	(ADJECTIVE MY BED ROOM BEDROOM SPARE F.C F.C)
	(SYNONYM ROOM BEDROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION GALLERY)
	(CHARACTER 3)
	(GLOBAL YOUR-ROOM ;YOUR-DOOR SECRET-YOUR-DOOR YOUR-BATHROOM FIREPLACE
		WINDOW YOUR-BATHROOM-DOOR)
	(OUT	TO GALLERY IF YOUR-ROOM ;YOUR-DOOR IS OPEN)
	(WEST	TO GALLERY IF YOUR-ROOM ;YOUR-DOOR IS OPEN)
	(NORTH	TO YOUR-BATHROOM IF YOUR-BATHROOM-DOOR IS OPEN)
	;(IN	TO YOUR-BATHROOM IF YOUR-BATHROOM-DOOR IS OPEN)
	(IN	TO YOUR-CLOSET IF SECRET-YOUR-DOOR IS OPEN)
	(EAST	TO YOUR-CLOSET IF SECRET-YOUR-DOOR IS OPEN)
	(ACTION YOUR-ROOM-F)>

<ROUTINE YOUR-ROOM-F ("OPTIONAL" (RARG <>))
 <COND (<EQUAL? .RARG ,M-BEG>
	<COND (<AND <VERB? WALK-TO> <DOBJ? BED>>
	       <PERFORM ,V?LIE ,BED>
	       <RTRUE>)
	      (T
	       <SECRET-CHECK .RARG>)>)
       (<OR <EQUAL? .RARG ,P?WEST ,P?OUT>
	    <EQUAL? .RARG ,P?EAST ,P?IN>>
	<COND (<AND ;<==? .RARG ,M-EXIT>
		    <ZERO? ,NOW-WEARING>>
	       <TELL
"Before you even take a step, you" ,REMEMBER-NOT-DRESSED "." CR>
	       <RFATAL>)
	      (<EQUAL? .RARG ,P?EAST ,P?IN>
	       <ENTER-PASSAGE>
	       <RTRUE>)>)
       (<EQUAL? .RARG ,M-ENTER>
	<QUEUE I-TOUR 0>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL CTHE ,YOUR-ROOM " is decorated in shades of ">
	<PRINT-COLOR>
	<TELL
". You see " 'YOUR-BATHROOM " to the north and a cozy " 'FIREPLACE " in
one corner. The room is furnished with a bed, a " 'NIGHTSTAND " with a
lamp on it, a " 'CHEST-OF-DRAWERS ", a " 'WARDROBE ", a " 'YOUR-CHAIR ",
and a " 'DRESSING-TABLE " with mirror and bench. There's also a
full-length " 'YOUR-MIRROR ".">
	<OPEN-DOOR? ,SECRET-YOUR-DOOR>
	<CRLF>
	<DESCRIBE-CONTENTS ,BED>
	<DESCRIBE-CONTENTS ,YOUR-CHAIR>
	<COND (<AND <NOT <FSET? ,HERE ,TOUCHBIT>>
		    <NOT <EQUAL? <LOC ,BUTLER> ,GALLERY ,YOUR-ROOM>>
			;"timing bug"
		    <NOT <G? 2 <QUEUED? ,I-DINNER>>>
		    <NOT <IN-MOTION? ,FRIEND>>>
	       <PUTP ,FRIEND ,P?LINE 0>
	       <SETG QCONTEXT ,FRIEND>
	       <TELL CHE ,FRIEND>
	       <COND (<NOT <IN? ,FRIEND ,HERE>>
		      <MOVE ,FRIEND ,HERE>
		      <TELL " enters and">)>
	       <TELL " says, \"Let's chat a bit">
	       <COND (<ZERO? <FIND-FLAG-HERE ,PERSONBIT ,PLAYER ,FRIEND>>
		      <TELL ", now that we're alone">)>
	       <TELL ".\"" CR>)>
	<RTRUE>)
       ;(<EQUAL? .RARG ,M-EXIT>
	<COND (<T? ,AWAITING-REPLY>
	       <SETG CLOCK-WAIT T>
	       <PLEASE-ANSWER>
	       <RTRUE>)>)
       (T ;<T? .RARG>
	<RFALSE>)
       ;(<VERB? LOCK UNLOCK>
	<TELL "It appears the lock is broken." CR>)>>

<GLOBAL REMEMBER-NOT-DRESSED " remember that you're not dressed">

<ROUTINE ENTER-PASSAGE ()
	<TELL "You step down into a narrow " 'PASSAGE "." CR>
	<RTRUE>>

<OBJECT BED
	(IN YOUR-ROOM)
	(DESC "your bed")
	(ADJECTIVE MY)
	(SYNONYM BED)
	(FLAGS SURFACEBIT OPENBIT VEHBIT NDESCBIT NARTICLEBIT)
	(CAPACITY 999)
	(ACTION BED-F)>

<ROUTINE BED-F () ;("OPT" (ARG 0))
 <COND ;(<T? .ARG> <RFALSE>)
       (<VERB? BOARD THROUGH>
	<PERFORM ,V?LIE ,PRSO>
	<RTRUE>)
       (<VERB? CLIMB-ON>
	<PERFORM ,V?SIT ,PRSO>
	<RTRUE>)>>

<OBJECT NIGHTSTAND
	(IN YOUR-ROOM)
	(DESC "night table" ;"nightstand")
	(ADJECTIVE MY NIGHT)
	(SYNONYM NIGHTT TABLE STAND)
	(FLAGS SURFACEBIT OPENBIT NDESCBIT SEENBIT SEARCHBIT)
	(CAPACITY 99)
	(ACTION NIGHTSTAND-F)>

<ROUTINE NIGHTSTAND-F ()
 <COND (<VERB? EXAMINE LOOK-ON>
	<TELL-AS-WELL-AS ,NIGHTSTAND <> ,NIGHTLAMP>
	<RTRUE>)>>

<ROUTINE TELL-AS-WELL-AS (CONT STR "OPTIONAL" (OBJ <>) (X <>))
	<COND (<FSET? .CONT ,SURFACEBIT>
	       <TELL !\O>)
	      (T
	       <FSET .CONT ,OPENBIT>
	       <TELL !\I>)>
	<TELL !\n THE .CONT " you see">
	<COND (<FIND-FLAG-NOT .CONT ,NDESCBIT>
	       <SET X T>)
	      (T <TELL " only">)>
	<COND (<T? .OBJ>
	       <TELL THE .OBJ>)
	      (T <TELL .STR>)>
	<COND (<T? .X>
	       <TELL ", as well as">
	       <PRINT-CONTENTS .CONT>)>
	<TELL "." CR>>

<OBJECT NIGHTLAMP
	(IN NIGHTSTAND)
	(DESC "your lamp")
	(ADJECTIVE MY)
	(SYNONYM LAMP)
	(FLAGS ONBIT LIGHTBIT NDESCBIT SEENBIT NARTICLEBIT)>

<OBJECT DRESSING-TABLE
	(IN YOUR-ROOM)
	(DESC "dressing table")
	(ADJECTIVE MY DRESSING)
	(SYNONYM TABLE)
	(FLAGS SURFACEBIT OPENBIT NDESCBIT SEENBIT SEARCHBIT)
	(CAPACITY 99)>

<OBJECT DRESSING-BENCH
	(IN YOUR-ROOM)
	(DESC "bench")
	(ADJECTIVE MY DRESSING)
	(SYNONYM BENCH)
	(FLAGS SURFACEBIT OPENBIT VEHBIT NDESCBIT SEENBIT)
	(CAPACITY 99)>

<OBJECT DRESSING-MIRROR
	(IN DRESSING-TABLE)
	(DESC "side mirror")
	(ADJECTIVE MY DRESSING SIDE TABLE)
	(SYNONYM MIRROR)
	;(DESCFCN DRESSING-MIRROR-D)
	(FLAGS SEENBIT)
	(ACTION DRESSING-MIRROR-F)>

;<ROUTINE DRESSING-MIRROR-D (X)
	<TELL
"There's a hinged " 'DRESSING-MIRROR " on the " 'DRESSING-TABLE "." CR>>

<ROUTINE DRESSING-MIRROR-F ()
 <COND (<VERB? FIX MOVE MOVE-DIR PUSH RUB TURN>
	<TELL "Now you can see " 'PLAYER " perfectly." CR>)
       (<VERB? EXAMINE LOOK-INSIDE>
	<TELL "You look ">
	<COND (<T? ,WASHED>
	       <TELL "smashing">)
	      (T <TELL "a trifle dirty">)>
	<TELL " in your ">
	<COND (<ZERO? ,NOW-WEARING> <TELL "birthday suit">)
	      (T <TELL D ,NOW-WEARING>)>
	<TELL "." CR>)>>

<OBJECT YOUR-MIRROR
	(IN YOUR-ROOM)
	(DESC "wall mirror")
	(ADJECTIVE MY WALL FULL-LENGTH FULL)
	(SYNONYM MIRROR)
	;(LDESC
"There's a mirror with an elaborate frame mounted on the wall.")
	(FLAGS NDESCBIT SEENBIT TRYTAKEBIT)
	(ACTION YOUR-MIRROR-F)>

<ROUTINE YOUR-MIRROR-F ()
 <COND (<OR <VERB? EXAMINE LOOK-BEHIND RUB SEARCH>
	    <AND <VERB? SEARCH-FOR> <DOBJ? YOUR-MIRROR>>>
	<COND (<NOT <IN? ,PLAYER ,HERE>>
	       ;<T? ,PLAYER-SEATED>
	       <TOO-BAD-SIT-HIDE>)>
	<TELL
"By running your fingers around the frame, you discover" THE ,YOUR-SWITCH>
	<THIS-IS-IT ,YOUR-SWITCH>
	<TELL "." CR>)
       (<AND <VERB? OPEN CLOSE>
	     <FSET? ,SECRET-YOUR-DOOR ,TOUCHBIT>>
	<PERFORM ,PRSA ,SECRET-YOUR-DOOR>
	<RTRUE>)
       (<VERB? FIX MOVE MOVE-DIR PUSH RUB TAKE TURN>
	<TELL "It seems to be fastened to the wall." CR>
	<RTRUE>)
       (T <DRESSING-MIRROR-F>)>>

<OBJECT YOUR-SWITCH
	(IN YOUR-ROOM)
	(DESC "hidden switch")
	(ADJECTIVE MY SMALL HIDDEN)
	(SYNONYM SWITCH)
	(FLAGS NDESCBIT ;TRYTAKEBIT SECRETBIT)
	(ACTION YOUR-SWITCH-F)>

<ROUTINE YOUR-SWITCH-F ()
 <COND (<VERB? EXAMINE>
	<TELL "You can't tell by looking what it might do." CR>)
       (<VERB? OPEN>
	<FCLEAR ,YOUR-SWITCH ,SECRETBIT>
	<OKAY ,SECRET-YOUR-DOOR "open">
	<RTRUE>)
       (<VERB? CLOSE>
	<FCLEAR ,YOUR-SWITCH ,SECRETBIT>
	<OKAY ,SECRET-YOUR-DOOR "closed">
	<RTRUE>)
       (<VERB? LAMP-OFF LAMP-ON MOVE MOVE-DIR PUSH RUB SLAP ;TAKE TURN>
	<OPEN-SECRET <> ;"push" ,YOUR-SWITCH ,SECRET-YOUR-DOOR>
	<RTRUE>)>>

<OBJECT WARDROBE
	(IN YOUR-ROOM)
	(DESC "wardrobe")
	(SYNONYM WARDROBE)
	(FLAGS CONTBIT NDESCBIT SEENBIT)
	(CAPACITY 999)>

<OBJECT CHEST-OF-DRAWERS
	(IN YOUR-ROOM)
	(DESC "chest of drawers")
	(SYNONYM CHEST DRAWER DRESSE)
	(FLAGS CONTBIT NDESCBIT SEENBIT)
	(CAPACITY 999)>

<OBJECT YOUR-CHAIR
	(IN YOUR-ROOM)
	(DESC "wing chair")
	(ADJECTIVE WING MY)
	(SYNONYM CHAIR)
	(FLAGS SURFACEBIT OPENBIT VEHBIT NDESCBIT SEENBIT)
	(CAPACITY 99)>
][
<OBJECT YOUR-BATHROOM-DOOR
	(IN LOCAL-GLOBALS)
	(DESC "bathroom door")
	(ADJECTIVE MY BATH ;ROOM BATHROOM)
	(SYNONYM DOOR)
	(FLAGS OPENBIT DOORBIT SEENBIT)>

<ROOM YOUR-BATHROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "your bathroom")
	(ADJECTIVE MY BATH)
	(SYNONYM ROOM BATHROOM)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION YOUR-ROOM)
	(CHARACTER 3)
	(OUT	TO YOUR-ROOM IF YOUR-BATHROOM-DOOR IS OPEN)
	(SOUTH	TO YOUR-ROOM IF YOUR-BATHROOM-DOOR IS OPEN)
	(ACTION YOUR-BATHROOM-F)
	(GLOBAL YOUR-BATHROOM-DOOR)
	(THINGS <PSEUDO ( MY BATH	BATH-PSEUDO)
			( BATH TUB	BATH-PSEUDO)
			( MY BATHTUB	BATH-PSEUDO)
			( MY TUB	BATH-PSEUDO)
			( MY TOILET	TOILET-PSEUDO)
			( MY SINK	RANDOM-PSEUDO)>)>

<ROUTINE YOUR-BATHROOM-F ("OPTIONAL" (RARG 0))
 <COND (<==? .RARG ,M-BEG>
	<COND (<AND <VERB? WALK-TO> <DOBJ? YOUR-BATHROOM>>
	       <TELL ,AHHH>
	       <RTRUE>)>)
       (<==? .RARG ,M-LOOK>
	<TELL
"From the look of it, " 'YOUR-BATHROOM " was added in recently. It is
comfortable and inviting, especially for Cornwall." CR>
	<RTRUE>)
       (<==? .RARG ,M-EXIT>
	<COND (<AND <ZERO? ,NOW-WEARING>
		    <SET RARG <FIND-FLAG ,YOUR-ROOM ,PERSONBIT>>>
	       <TELL
"You peek in and see " D .RARG ", then" ,REMEMBER-NOT-DRESSED "." CR>
	       <RFATAL>)>)
       (<T? .RARG>
	<RFALSE>)
       (<VERB? OPEN CLOSE LOCK UNLOCK>
	<PERFORM ,PRSA ,YOUR-BATHROOM-DOOR>
	<RTRUE>)>>

<ROUTINE TOILET-PSEUDO ()
 <COND (<VERB? LOOK-INSIDE>
	<NOTHING-SPECIAL>
	<RTRUE>)
       (<VERB? SIT USE>
	<TELL ,AHHH>
	<RTRUE>)>>

<ROUTINE BATH-PSEUDO ()
	<COND (<VERB? CLOSE ;"=DRAW" FILL LAMP-ON>
	       <COND (<EQUAL? ,WINNER ,PLAYER>
		      <TELL "Okay, then what?" CR>)>
	       <RTRUE>)
	      (<VERB? BOARD SWIM TAKE THROUGH>
	       <COND (<ZERO? ,NOW-WEARING>
		      <COND (<FIRST? ,PLAYER>
			     <TELL "First you drop everything...|">
			     <ROB ,PLAYER ,HERE>)>
		      <PUT <GET ,P-ITBL ,P-VERBN> 0 ,W?BATHE>;"for VERB-PRINT"
		      <V-WAIT 9 <> T>
		      <SETG WASHED T>
		      <TELL
"You're now squeaky clean. After toweling off, you feel nicely relaxed
and ready to tackle the mystery of " D ,CASTLE "." CR>)
		     (T <TELL
"You almost step into the tub before you realize that your " D ,NOW-WEARING
" would get wet." CR>)>)
	      (T <RANDOM-PSEUDO>)>>
]
<ROOM EAST-HALL
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT WEARBIT)
	(DESC "east hall")
	(ADJECTIVE EAST)
	(SYNONYM HALL HALLWAY ROOM)
	(LDESC
"There are bedrooms to the east and west. The gallery lies south."
;"[W to Wendish, E to Iris, S to gallery]")
	(LINE 2)
	(STATION EAST-HALL)
	(CHARACTER 3)
	(GLOBAL WENDISH-ROOM ;WENDISH-DOOR IRIS-ROOM ;IRIS-DOOR)
	(EAST	TO IRIS-ROOM IF IRIS-ROOM ;IRIS-DOOR IS OPEN)
	(WEST	TO WENDISH-ROOM IF WENDISH-ROOM ;WENDISH-DOOR IS OPEN)
	(SOUTH	TO GALLERY)
	(SW	TO GALLERY)
	(OUT	TO GALLERY)>

[
<OBJECT SECRET-IRIS-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET IRIS\'S HER PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-IRIS-DOOR-F)>

<ROOM IRIS-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "Iris's bedroom")
	(ADJECTIVE IRIS\'S ;IRIS HER BED ROOM BEDROOM EAST)
	(SYNONYM ROOM BEDROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION EAST-HALL)
	(CHARACTER 3)
	(GLOBAL IRIS-ROOM SECRET-IRIS-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG WINDOW)
	(THINGS <PSEUDO ( IRIS\'S BED	BED-PSEUDO)
			( HER BED	BED-PSEUDO)>)
	(OUT	TO EAST-HALL IF IRIS-ROOM ;IRIS-DOOR IS OPEN)
	(WEST	TO EAST-HALL IF IRIS-ROOM ;IRIS-DOOR IS OPEN)
	(IN	TO IRIS-CLOSET IF SECRET-IRIS-DOOR IS OPEN)
	(EAST	TO IRIS-CLOSET IF SECRET-IRIS-DOOR IS OPEN)
	(ACTION IRIS-ROOM-F)>

<ROUTINE IRIS-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<COND (<AND <VERB? OPEN CLOSE>
		    <DOBJ? SECRET-IRIS-DOOR>>
	       <YOU-CANT <> ,PLAYER "in this room">
	       <RTRUE>)
	      (T <SECRET-CHECK .RARG>)>)
       (<EQUAL? .RARG ,P?EAST ,P?IN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
'IRIS-ROOM " is furnished much like yours, but with a canopied bed and
" 'IRIS-CHAIR "." ;"[W to east hall]">
	<OPEN-DOOR? ,SECRET-IRIS-DOOR>
	<CRLF>)>>

<OBJECT IRIS-CHAIR
	(IN IRIS-ROOM)
	(DESC "love seat")
	(ADJECTIVE IRIS\'S HER LOVE)
	(SYNONYM CHAIR SEAT)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT)
	(CAPACITY 99)>
][
<OBJECT SECRET-WENDISH-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET DOC\'S HIS PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-WENDISH-DOOR)>

;<ROUTINE HIDING-PSEUDO ("AUX" OBJ)
 <COND (<VERB? HIDE-BEHIND PUT-IN PUT-UNDER>
	<COND (<DOBJ? COSTUME BLOWGUN LENS-BOX>
	       <MOVE ,PRSO ,HERE>
	       <FSET ,PRSO ,NDESCBIT>
	       <FSET ,PRSO ,SECRETBIT>
	       <TELL "Done." CR>)
	      (T <TELL CHE ,PRSO " won't fit." CR>)>)
       (<VERB? EXAMINE LOOK-INSIDE SEARCH SEARCH-FOR>
	<COND (<SET OBJ <FIND-FLAG-HERE ,SECRETBIT>>
	       <DISCOVER .OBJ>)
	      (T <NOTHING-SPECIAL>)>)>>

<ROOM WENDISH-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "Wendish's bedroom")
	(ADJECTIVE DOC\'S HIS BED ROOM BEDROOM WEST)
	(SYNONYM ROOM BEDROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION EAST-HALL)
	(CHARACTER 3)
	(GLOBAL WENDISH-ROOM SECRET-WENDISH-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG WINDOW)
	(THINGS <PSEUDO ( DOC\'S BED	BED-PSEUDO)
			( HIS BED	BED-PSEUDO)>)
	(OUT	TO EAST-HALL IF WENDISH-ROOM ;WENDISH-DOOR IS OPEN)
	(EAST	TO EAST-HALL IF WENDISH-ROOM ;WENDISH-DOOR IS OPEN)
	(NORTH	TO WENDISH-CORNER IF SECRET-WENDISH-DOOR IS OPEN)
	(IN	TO WENDISH-CORNER IF SECRET-WENDISH-DOOR IS OPEN)
	(ACTION WENDISH-ROOM-F)>

<ROUTINE WENDISH-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<COND ;(<AND <VERB? OPEN CLOSE>
		    <DOBJ? SECRET-WENDISH-DOOR>>
	       <YOU-CANT <> ,PLAYER "in this room" ;"here">
	       <RTRUE>)
	      (T <SECRET-CHECK .RARG>)>)
       (<EQUAL? .RARG ,P?NORTH ,P?IN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The room shows the doctor's precise, scientific personality.
Everything is in its place. " ;"Luggage has been unpacked, and clothes
neatly stowed in a commode (a low ' 'CHEST-OF-DRAWERS ') and a clothes press
(recessed in the wall). ">
	<WENDISH-STUFF-D>
	<TELL
"His " 'WENDISH-KIT " is on a marble-topped console
attached to the wall. On the north wall is" THE ,CANDLE !\.>
	<OPEN-DOOR? ,SECRET-WENDISH-DOOR>
	<CRLF>)>>

<OBJECT CANDLE
	(IN WENDISH-ROOM)
	(DESC "ornate candle sconce")
	(ADJECTIVE ORNATE CANDLE DOC\'S HIS)
	(SYNONYM CANDLE SCONCE)
	(FLAGS NDESCBIT TRYTAKEBIT VOWELBIT)
	(ACTION CANDLE-F)>

<ROUTINE CANDLE-F ()
 <COND (<VERB? EXAMINE>
	<TELL "It seems to be fastened loosely to the wall." CR>)
       (<OR <VERB? LOOK-BEHIND LOOK-UNDER MOVE MOVE-DIR PUSH TURN>
	    <AND <VERB? TAKE>
		 <EQUAL? ,P-PRSA-WORD ,W?RAISE ,W?LIFT>>>
	<OPEN-SECRET "lift" ,CANDLE ,SECRET-WENDISH-DOOR>)>>

<OBJECT WENDISH-CHAIR
	(IN WENDISH-ROOM)
	(DESC "armchair")
	(ADJECTIVE ARM)
	(SYNONYM CHAIR SEAT ARMCHAIR)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT VOWELBIT)
	(CAPACITY 99)>

<OBJECT WENDISH-STUFF
	(IN WENDISH-ROOM)
	(DESC "medical text")
	(ADJECTIVE MEDICAL)
	(SYNONYM TEXT TEXTS BOOK BOOKS)
	(GENERIC GENERIC-BOOK)
	(FLAGS NDESCBIT READBIT CONTBIT)
	(CAPACITY 4)
	(DESCFCN WENDISH-STUFF-D)
	(ACTION WENDISH-STUFF-F)>

<ROUTINE WENDISH-STUFF-D ("OPTIONAL" X)
	<TELL
"Several " 'WENDISH-STUFF "s are lying on the " 'DRESSING-TABLE-LG "."
	       ;"a roll-top writing table." CR>>

<ROUTINE WENDISH-STUFF-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN READ>
	<TELL "They are too technical to understand." CR>)
       (T <RANDOM-PSEUDO>)>>

<OBJECT WENDISH-KIT
	(IN WENDISH-ROOM)
	(DESC ;"Wendish's " "medical kit")
	(ADJECTIVE DOC\'S ;DOCTOR HIS MEDICAL)
	(SYNONYM KIT BAG)
	(FLAGS NDESCBIT SEENBIT ;NARTICLEBIT CONTBIT TRYTAKEBIT)
	(SIZE 38)
	(CAPACITY 37)	;"for COSTUME + BLOWGUN + LENS-BOX + book"
	(ACTION WENDISH-KIT-F)>

<ROUTINE WENDISH-KIT-F ("AUX" X)
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN SEARCH SEARCH-FOR>
	<SEARCH-KIT-BOX ,WENDISH-KIT " a bunch of nasty-looking instruments">
	<RTRUE>)
       (<AND <VERB? TAKE> <EQUAL? ,PRSO ,WENDISH-KIT>>
	<YOU-SHOULDNT>)
       ;(<AND <VERB? TAKE> <EQUAL? ,PRSI <> ,WENDISH-KIT>>
	<RFALSE>)
       ;(<VERB? CLOSE FIND>
	<RFALSE>)>>
]
<ROUTINE SEARCH-KIT-BOX (OBJ STR "AUX" (X <>))
	<FSET .OBJ ,OPENBIT>
	<COND ;(<OR <SET X <FIND-FLAG .OBJ ,SECRETBIT>>
		   <SET X <FIND-FLAG .OBJ ,RMUNGBIT>>>
	       T)
	      (<IN? ,LENS-BOX .OBJ>
	       <SET X ,LENS-BOX>)
	      (<IN? ,VIVIEN-DIARY .OBJ>
	       <SET X ,VIVIEN-DIARY>)
	      (<IN? ,COSTUME .OBJ>
	       <SET X ,COSTUME>)
	      (<IN? ,BLOWGUN .OBJ>
	       <SET X ,BLOWGUN>)>
	<COND (<T? .X>
	       <DISCOVER .X>
	       <COND (<NOT <VERB? SEARCH SEARCH-FOR>>
		      <TELL !\Y ,OU-STOP-SEARCHING "." CR>)>
	       <RTRUE>)
	      (T
	       <TELL-AS-WELL-AS .OBJ .STR>
	       <RTRUE>)>>
[
<OBJECT SECRET-VIVIEN-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET VIV\'S HER PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-VIVIEN-DOOR)>

<ROOM VIVIEN-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT ;OPENBIT DOORBIT ;LOCKED WEARBIT WORNBIT)
	(DESC "Vivien's bedroom")
	(ADJECTIVE ;VIVIEN VIV\'S HER BED ROOM BEDROOM WEST)
	(SYNONYM ROOM BEDROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION GALLERY)
	(CHARACTER 3)
	(GLOBAL VIVIEN-ROOM SECRET-VIVIEN-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG WINDOW)
	(THINGS <PSEUDO ( <> BOOK	RANDOM-PSEUDO)
			( <> BOOKS	RANDOM-PSEUDO)
			( VIV\'S BED	BED-PSEUDO)
			( HER BED	BED-PSEUDO)>)
	(OUT	TO GALLERY IF VIVIEN-ROOM ;VIVIEN-DOOR IS OPEN)
	(EAST	TO GALLERY IF VIVIEN-ROOM ;VIVIEN-DOOR IS OPEN)
	(SOUTH	TO SECRET-VIVIEN-PASSAGE IF SECRET-VIVIEN-DOOR IS OPEN)
	(IN	TO SECRET-VIVIEN-PASSAGE IF SECRET-VIVIEN-DOOR IS OPEN)
	(ACTION VIVIEN-ROOM-F)>

<ROUTINE VIVIEN-ROOM-F ("OPTIONAL" (RARG <>))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<SECRET-CHECK .RARG>)
       (<EQUAL? .RARG ,P?SOUTH ,P?IN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
"The room is untidy, probably because Vivien is an artist.
Sketches and garments are strewn on the
canopied bed and " 'VIVIEN-CHAIR ". Leaning against the wall are
stretched canvases, and a fold-up easel
for her outdoor art work. On the tallboy are
a sketch pad, and a paint-smeared " 'VIVIEN-BOX ".
On the south wall is a cheval glass and" THE ,FIGURINE "."
;"(full-length tilting mirror in frame) [E to gallery]">
	<OPEN-DOOR? ,SECRET-VIVIEN-DOOR>
	<CRLF>
	<DESCRIBE-CONTENTS ,VIVIEN-CHAIR>
	<RTRUE>)>>

<OBJECT VIVIEN-STUFF
	(IN VIVIEN-ROOM)
	(DESC "art supplies" ;"Vivien's stuff")
	(ADJECTIVE VIV\'S HER WATERCOLOR SKETCH ART PICTURE)
	(SYNONYM PAD CANVAS SUPPLIES EASEL)
	(FLAGS NDESCBIT SEENBIT ;NARTICLEBIT)
	(ACTION RANDOM-PSEUDO)>

<OBJECT VIVIEN-BOX
	(IN VIVIEN-ROOM)
	(DESC ;"Vivien's " "wooden box")
	(ADJECTIVE VIV\'S HER WOODEN PAINT)
	(SYNONYM BOX)
	(GENERIC GENERIC-BOX)
	(FLAGS NDESCBIT SEENBIT ;NARTICLEBIT CONTBIT TRYTAKEBIT)
	(SIZE 38)
	(CAPACITY 37)	;"for COSTUME + BLOWGUN + LENS-BOX + book"
	(ACTION VIVIEN-BOX-F)>

<ROUTINE VIVIEN-BOX-F ("AUX" X)
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN SEARCH SEARCH-FOR>
	<SEARCH-KIT-BOX ,VIVIEN-BOX " Vivien's brushes and thinner";" and oil">
	<RTRUE>)
       ;(<AND <VERB? PUT-IN> <IOBJ? VIVIEN-BOX>>
	<MOVE ,PRSO ,PRSI>
	<FSET ,PRSO ,TOUCHBIT>
	<TELL "Okay." CR>)
       (<AND <VERB? TAKE> <EQUAL? ,PRSO ,VIVIEN-BOX>>
	<YOU-SHOULDNT>)
       ;(<AND <VERB? TAKE> <EQUAL? ,PRSI <> ,VIVIEN-BOX>>
	<RFALSE>)
       ;(<VERB? CLOSE FIND>
	<RFALSE>)>>

<OBJECT FIGURINE
	(IN VIVIEN-ROOM)
	(DESC "sculpted figurine")
	(ADJECTIVE SCULPT VIV\'S HER)
	(SYNONYM FIGURINE FIGURE)
	(FLAGS TRYTAKEBIT NDESCBIT ;SEENBIT)
	(ACTION FIGURINE-F)>

<ROUTINE FIGURINE-F ()
 <COND (<VERB? EXAMINE>
	<TELL "It's turned toward the wall, so you can't see its face." CR>)
       (<VERB? MOVE MOVE-DIR PUSH TURN>
	<OPEN-SECRET "turn" ,FIGURINE ,SECRET-VIVIEN-DOOR>)
       ;(<VERB? LOOK-UNDER OPEN TAKE>
	<FSET ,FIGURINE ,OPENBIT>
	<TELL
"The " 'FIGURINE " is hollow. Lifting it from its shelf reveals">
	<PRINT-CONTENTS ,FIGURINE>
	<TELL "." CR>)>>

<OBJECT VIVIEN-CHAIR
	(IN VIVIEN-ROOM)
	(DESC "chaise longue")
	(ADJECTIVE CHAISE)
	(SYNONYM CHAIR CHAISE LONGUE LOUNGE)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT SEENBIT)
	(CAPACITY 99)>
]
<ROOM WEST-HALL
	(IN ROOMS)
	(FLAGS ONBIT SEENBIT WEARBIT)
	(DESC "west hall")
	(ADJECTIVE WEST)
	(SYNONYM HALL HALLWAY ROOM)
	(LDESC
"There are bedrooms to the east and west. The gallery lies south."
;"[E to Hyde, W to Ian, S to gallery]")
	(LINE 2)
	(STATION WEST-HALL)
	(CHARACTER 3)
	(GLOBAL HYDE-ROOM ;HYDE-DOOR IAN-ROOM ;IAN-DOOR)
	(WEST	TO IAN-ROOM IF IAN-ROOM ;IAN-DOOR IS OPEN)
	(EAST	TO HYDE-ROOM IF HYDE-ROOM ;HYDE-DOOR IS OPEN)
	(SOUTH	TO GALLERY)
	(SE	TO GALLERY)
	(OUT	TO GALLERY)>
[
<OBJECT SECRET-IAN-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET IAN\'S HIS PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-IAN-DOOR)>

<ROOM IAN-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "Ian's bedroom")
	(ADJECTIVE IAN\'S HIS BED ROOM BEDROOM WEST)
	(SYNONYM ROOM BEDROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION WEST-HALL)
	(CHARACTER 3)
	(GLOBAL IAN-ROOM SECRET-IAN-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG WINDOW)
	(THINGS <PSEUDO ( IAN\'S BED	BED-PSEUDO)
			( HIS BED	BED-PSEUDO)>)
	(NORTH	TO SECRET-IAN-PASSAGE IF SECRET-IAN-DOOR IS OPEN)
	(IN	TO SECRET-IAN-PASSAGE IF SECRET-IAN-DOOR IS OPEN)
	(OUT	TO WEST-HALL IF IAN-ROOM ;IAN-DOOR IS OPEN)
	(EAST	TO WEST-HALL IF IAN-ROOM ;IAN-DOOR IS OPEN)
	(ACTION IAN-ROOM-F)>

<ROUTINE IAN-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<SECRET-CHECK .RARG>)
       (<EQUAL? .RARG ,P?NORTH ,P?IN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
'IAN-ROOM " has rich wood panelling, a four-poster bed, Victorian
washstand, and " 'IAN-CHAIR ". ">
	<TELL-IAN-FIREPLACE>
	<CRLF>
	<COND (<OPEN-DOOR? ,SECRET-IAN-DOOR T>
	       <CRLF>)>
	<RTRUE>)>>

<ROUTINE TELL-IAN-FIREPLACE ()
	<TELL
"In the " 'FIREPLACE ", the fender has
flashy grillwork, and the " 'ANDIRON "s have fancy carved heads.">>

<OBJECT ANDIRON
	(IN IAN-ROOM)
	(DESC "andiron")
	;(ADJECTIVE CARVED)
	(SYNONYM ANDIRON HEAD ;HEADS GRILLWORK)
	(FLAGS VOWELBIT NDESCBIT)
	(ACTION ANDIRON-F)>

<ROUTINE ANDIRON-F ()
 <COND (<VERB? EXAMINE>
	<TELL "By looking closely, you find that the head can turn." CR>)
       (<VERB? MOVE MOVE-DIR PUSH RUB TURN>
	<OPEN-SECRET "turn" ,ANDIRON ,SECRET-IAN-DOOR>
	;<TELL "As you turn the carved head,">)>>

<OBJECT IAN-CHAIR
	(IN IAN-ROOM)
	(DESC "reclining Morris chair")
	(ADJECTIVE RECLINE MORRIS)
	(SYNONYM CHAIR SEAT)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT)
	(CAPACITY 99)>
][
<OBJECT SECRET-HYDE-DOOR
	(IN ROOMS ;LOCAL-GLOBALS)
	(DESC "secret door")
	(ADJECTIVE SECRET HYDE\'S HIS PASSAGE)
	(SYNONYM DOOR)
	(GENERIC GENERIC-BEDROOM)
	(FLAGS SECRETBIT DOORBIT)
	;(GENERIC GENERIC-HYDE-DOOR)>

<ROOM HYDE-ROOM
	(IN ROOMS)
	(FLAGS ONBIT NARTICLEBIT OPENBIT DOORBIT WEARBIT WORNBIT)
	(DESC "Hyde's bedroom")
	(ADJECTIVE HYDE\'S HIS ;HYDE BED ROOM BEDROOM EAST)
	(SYNONYM ROOM BEDROOM DOOR ;KEYHOLE)
	(GENERIC GENERIC-BEDROOM)
	(LINE 2)
	(STATION WEST-HALL)
	(CHARACTER 3)
	(GLOBAL HYDE-ROOM SECRET-HYDE-DOOR BATHROOM FIREPLACE
		NIGHTSTAND-LG DRESSING-TABLE-LG WARDROBE-LG WINDOW)
	(THINGS <PSEUDO ( HYDE\'S BED	BED-PSEUDO)
			( HIS BED	BED-PSEUDO)>)
	(OUT	TO WEST-HALL IF HYDE-ROOM ;HYDE-DOOR IS OPEN)
	(WEST	TO WEST-HALL IF HYDE-ROOM ;HYDE-DOOR IS OPEN)
	(IN	TO HYDE-CLOSET IF SECRET-HYDE-DOOR IS OPEN)
	(NORTH	TO HYDE-CLOSET IF SECRET-HYDE-DOOR IS OPEN)
	(ACTION HYDE-ROOM-F)>

<ROUTINE HYDE-ROOM-F ("OPTIONAL" (RARG 0))
 <COND (<EQUAL? .RARG ,M-BEG ,M-EXIT>
	<COND (<AND <VERB? OPEN CLOSE>
		    <DOBJ? SECRET-HYDE-DOOR>>
	       <YOU-CANT <> ,PLAYER "in this room" ;"here">
	       <RTRUE>)
	      (T <SECRET-CHECK .RARG>)>)
       (<EQUAL? .RARG ,P?NORTH ,P?IN>
	<ENTER-PASSAGE>
	<RTRUE>)
       (<EQUAL? .RARG ,M-LOOK>
	<TELL
'HYDE-ROOM " has many tasteful antiques, such as " A ,HYDE-CHAIR
" in one corner."
;" looks like  'DOCTOR 's, but with a 'WARDROBE not a clothes press.">
	<OPEN-DOOR? ,SECRET-HYDE-DOOR>
	<CRLF>)>>

<OBJECT HYDE-CHAIR
	(IN HYDE-ROOM)
	(DESC "armchair")
	(ADJECTIVE ARM)
	(SYNONYM CHAIR ARMCHAIR)
	(FLAGS SURFACEBIT VEHBIT OPENBIT NDESCBIT VOWELBIT SEENBIT)
	(CAPACITY 99)>
]
