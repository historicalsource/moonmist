"COLORS for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."    

<GLOBAL HERE:OBJECT DRIVEWAY ;CAR>
<GLOBAL OHERE:OBJECT 0>

;<ROUTINE START-MOVEMENT ()
	<QUEUE I-LIONEL-SPEAKS %<- ,LIONEL-TIME ,PRESENT-TIME-ATOM>>>

<ROUTINE INTRO ()
	<TELL "|
You drove west from London all day in your new little British " 'CAR ". Now at
last you've arrived in the storied land of Cornwall.|
|
Dusk has fallen as you pull up in front of " D ,CASTLE ". A ghostly "
'MOON " is rising, and a tall iron gate between two pillars bars the way
into the " 'COURTYARD ".|">>

<OBJECT YOUR-COLOR
	(DESC "your favorite color")
	(IN GLOBAL-OBJECTS)
	(ADJECTIVE MY FAVORITE F.C F.C)
	(SYNONYM COLOR)
	(FLAGS NARTICLEBIT)
	(ACTION YOUR-COLOR-F)>

<ROUTINE YOUR-COLOR-F ()
 <COND (<REMOTE-VERB?>
	<RFALSE>)
       (<AND <NOT <EQUAL? ,HERE ,YOUR-ROOM>>
	     <NOT <VISIBLE? ,CAR>>
	     <NOT <VISIBLE? ,EXERCISE-OUTFIT>>
	     <NOT <VISIBLE? ,DINNER-OUTFIT>>
	     <NOT <VISIBLE? ,SLEEP-OUTFIT>>>
	<NOT-HERE ,YOUR-COLOR>)
       (T <TELL "It's " 'YOUR-COLOR "!" CR>)>>

<ROUTINE GET-COLOR ("AUX" NUM N WD (SUM 0) X)
  <PUTB ,P-INBUF 0 30>	;"for CoCo"
  <REPEAT ()
	<TELL !\>>
	<READ ,P-INBUF ,P-LEXV>
	<SET NUM <GETB ,P-LEXV ,P-LEXWORDS>>
	<COND (<0? .NUM>
	       <TELL !\" ,BEG-PARDON "\" ">
	       <AGAIN>)>
	<SET N ,P-LEXSTART>
	<REPEAT ()
		<SET WD <GET ,P-LEXV .N>>
		;<COND (<EQUAL? .WD ,W?PURPLE>
		       <SET WD ,W?VIOLET>)>
		<COND (<SET X <ZMEMQ .WD ,COLOR-WORDS>>
		       <SETG VARIATION .X>
		       <RETURN>)
		      (<DLESS? NUM 1>
		       <RETURN>)
		      (T <SET N <+ .N ,P-LEXELEN>>)>>
	<SET WD <+ ,P-LEXSTART
		   <* ,P-LEXELEN <- <GETB ,P-LEXV ,P-LEXWORDS> 1>>>>
	<COND (<EQUAL? <GET ,P-LEXV .WD> ,W?PERIOD ,W?\! ,W??>
	       <SET WD <- .WD ,P-LEXELEN>>)>
	<SET N <* 2 <+ .WD 1>>>
	<SET WD <+ -1 <+ <GETB ,P-LEXV .N> <GETB ,P-LEXV <+ 1 .N>>>>>
	;<COND (<G? .WD ,NAME-LENGTH>
	       <SET WD ,NAME-LENGTH>)>
	<NON-BLANK-STUFF ,FAVE-COLOR <REST ,P-INBUF 1> .WD>
	<TELL "\"Did you say " 'YOUR-COLOR " is ">
	<PRINT-COLOR T>
	<TELL "?\"">
	<COND (<YES?>
	       <COND (<0? ,VARIATION>
		      <SET SUM <GETB ,P-INBUF	;"1st char in 1st word"
				     <GETB ,P-LEXV <+ 3 <* 2 ,P-LEXSTART>>>>>
		      ;<SET NUM
			   <* 2 <+ ,P-LEXSTART
				   <* ,P-LEXELEN
				      <GETB ,P-LEXV ,P-LEXWORDS>>>>>
		      ;<SET NUM <+ <GETB ,P-LEXV <- .NUM 1>>	;"last+1 char"
				  <GETB ,P-LEXV <- .NUM 2>>>>
		      ;<REPEAT ()
			   <COND (<DLESS? NUM 1> <RETURN>)
				 (T <SET SUM <+ .SUM <GETB ,P-INBUF .NUM>>>)>>
		      <COND (<SET X <ZMEMQ .SUM ,COLOR-LETTERS>>
			     <SETG VARIATION .X>)
			    (<EQUAL? .SUM %<ASCII !\p>>	;"pink => blue"
			     <SETG VARIATION ,PAINTER-C>)
			    (T <SETG VARIATION <+ 1 <MOD .SUM ,MAX-VARS>>>)>
		      <SETG COLOR-FORCED <GET ,COLOR-WORDS ,VARIATION>>)>
	       <DO-VARIATION>
	       <PUTB ,P-INBUF 0 80>
	       <RETURN>)
	      (T
	       ;<PUTB ,FAVE-COLOR 1 0>
	       <TELL "\"What, then?\"" CR>
	       <SETG VARIATION 0>)>>>

<GLOBAL VILLAIN-PER:OBJECT 0>
<GLOBAL TREASURE:OBJECT 0>
<GLOBAL HIDING-PLACE:OBJECT 0>
<GLOBAL COLOR-FORCED:FLAG 0>
<CONSTANT MAX-VARS 4>

<GLOBAL COLOR-WORDS
       <PLTABLE	<VOC "YELLOW" ADJ>	;FRIEND-C
		<VOC "RED" ADJ>		;LORD-C
		<VOC "BLUE" ADJ>	;PAINTER-C
		<VOC "GREEN" ADJ>	;DOCTOR-C
		;<VOC "VIOLET" BUZZ>	;OFFICER-C
		;<VOC "ORANGE" BUZZ>	;DEALER-C>>

<GLOBAL COLOR-ADJS
       <PLTABLE	A?YELLOW	;FRIEND-C
		A?RED		;LORD-C
		A?BLUE		;PAINTER-C
		A?GREEN		;DOCTOR-C
		;A?VIOLET	;OFFICER-C
		;A?ORANGE	;DEALER-C>>

<GLOBAL COLOR-LETTERS
       <PLTABLE	%<ASCII !\y>
		%<ASCII !\r>
		%<ASCII !\b>
		%<ASCII !\g>
		;%<ASCII !\v>
		;%<ASCII !\o>>>

<ROUTINE FIX-COLOR-ADJ (OBJ "AUX" PT N)
 <COND (<AND <SET PT <GETPT .OBJ ,P?ADJECTIVE>>
	     <SET N <ZMEMQB ,A?F.C .PT <RMGL-SIZE .PT>>>>
	<PUTB .PT .N <GET ,COLOR-ADJS ,VARIATION>>)>>

<ROUTINE DO-VARIATION ("AUX" C)
	<FIX-COLOR-ADJ ,YOUR-COLOR>
	<FIX-COLOR-ADJ ,YOUR-ROOM>
	<FIX-COLOR-ADJ ,CAR>
	<FIX-COLOR-ADJ ,SLEEP-OUTFIT>
	<FIX-COLOR-ADJ ,EXERCISE-OUTFIT>
	<FIX-COLOR-ADJ ,DINNER-OUTFIT>
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <SET C <LOC ,LOVER>>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <SET C ,IRIS-CLOSET>)
	      (<EQUAL? ,VARIATION ,PAINTER-C>
	       <SET C ,VIVIEN-BOX>)
	      (T <SET C ,WENDISH-KIT>)>
	<SETG HIDING-PLACE .C>
	<MOVE ,COSTUME .C>
	<MOVE ,BLOWGUN .C>
	<COND (<EQUAL? ,VARIATION ,LORD-C>	;"RED"
	       <SETG VILLAIN-PER ,LOVER ;,LORD>
	       <MOVE ,NECKLACE-OF-D ,JACK-ROOM>
	       ;<FSET ,NECKLACE-OF-D ,SECRETBIT>
	       <MOVE ,JEWEL ,LOCAL-GLOBALS>
	       ;<MOVE ,JOURNAL ,DESK>
	       <SETG TREASURE ,WAR-CLUB>
	       <MOVE ,CLUE-2 ,PAINTER>
	       <FSET ,STAINED-WINDOW ,CONTBIT>
	       <MOVE ,CLUE-3 ,STAINED-WINDOW>
	       <MOVE ,CLUE-4 ,GARDEN>
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <MOVE ,CURTAIN-ROD ,JACK-ROOM>)
		     (T <MOVE ,CANE ,UMBRELLA-STAND>)>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>	;"YELLOW"
	       <SETG VILLAIN-PER ,FRIEND>
	       <MOVE ,TAMARA-EVIDENCE ,TAMARA-BED ;,TAMARA-ROOM>
	       <PUT <GETPT ,FRIEND ,P?WEST> ,NEXITSTR "ignoring you">
	       <MOVE ,JOURNAL ,TAMARA-BED>
	       <FSET ,JOURNAL ,NDESCBIT>
	       <MOVE ,EARRING ,JEWELRY-CASE>
	       <MOVE ,JEWEL ,LOCAL-GLOBALS>
	       <SETG TREASURE ,NECKLACE>
	       <MOVE ,NECKLACE ,SKELETON>
	       <MOVE ,CLUE-4 ,COFFIN>
	       <FCLEAR ,CLUE-4 ,NDESCBIT>
	       <FSET ,CLUE-4 ,TAKEBIT>
	       <MOVE ,CLUE-3 ,BELL>
	       <MOVE ,BRICKS ,BASEMENT>
	       ;<COND ;(<FSET? ,PLAYER ,FEMALE>
		      <MOVE ,NECKLACE ,POND>)
		     (T
		      ;<FSET ,NECKLACE ,NDESCBIT>
		      <MOVE ,NECKLACE ,SKELETON>)>)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>	;"GREEN"
	       <SETG VILLAIN-PER ,DOCTOR>
	       <MOVE ,WENDISH-BOOK ,BOOKCASE ;,LIBRARY>
	       <MOVE ,LENS-BOX ,WENDISH-KIT>
	       <FCLEAR ,LENS-BOX ,NDESCBIT>
	       <FSET ,LENS-BOX ,TAKEBIT>
	       <MOVE ,JOURNAL ,DESK>
	       <MOVE ,LETTER-DEE ,STUDY>
	       <SETG TREASURE ,MOONMIST>
	       <FSET ,MOONMIST ,SECRETBIT>
	       ;<REMOVE ,GAME>
	       ;<FSET ,RHINO-HEAD ,CONTBIT>
	       ;<FSET ,RHINO-HEAD ,OPENBIT>
	       <MOVE ,CLUE-3 ,RHINO-HEAD>
	       <MOVE ,CLUE-4 ,GALLERY-CORNER ;,FRONT-GATE>
	       <FCLEAR ,CLUE-4 ,NDESCBIT>
	       <FSET ,CLUE-4 ,TAKEBIT>
	       ;<PUTP ,CLUE-4 ,P?FDESC
		  "A shaft of light from the peephole lands on a fourth clue.">
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <MOVE ,MOONMIST ,BOTTLE>)
		     (T <MOVE ,MOONMIST ,INKWELL>)>)
	      (<EQUAL? ,VARIATION ,PAINTER-C>	;"BLUE"
	       <SETG VILLAIN-PER ,PAINTER>
	       <MOVE ,VIVIEN-DIARY ,VIVIEN-BOX>
	       <MOVE ,LENS-BOX ,VIVIEN-BOX>
	       <FCLEAR ,LENS-BOX ,NDESCBIT>
	       <FSET ,LENS-BOX ,TAKEBIT>
	       ;<REMOVE ,JOURNAL>
	       ;<MOVE ,MAGAZINE ,LUMBER-ROOM>
	       <SETG TREASURE ,SKULL>
	       <MOVE ,SKULL ,BELL>
	       <FSET ,MUSIC ,SECRETBIT>
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <MOVE ,SKULL ,COFFIN>)
		     (T <MOVE ,CLUE-3 ,ARMOR>)>)
	      ;(<EQUAL? ,VARIATION ,DEALER-C>
	       <SETG VILLAIN-PER ,DEALER>
	       <MOVE ,HYDE-IOU ,HYDE-ROOM>
	       <MOVE ,LENS-BOX ,HYDE-ROOM>
	       <SETG TREASURE ,HEADDRESS>
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <MOVE ,HEADDRESS ,BRITANNIA>)
		     (T <MOVE ,HEADDRESS ,ARMOR>)>)
	      ;(<EQUAL? ,VARIATION ,OFFICER-C>
	       <SETG VILLAIN-PER ,OFFICER>
	       <MOVE ,IAN-EVIDENCE ,IAN-ROOM>
	       <SETG TREASURE ,RUBY>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <FSET ,STAINED-WINDOW ,CONTBIT>
		      <MOVE ,RUBY ,STAINED-WINDOW>)
		     (T
		      <FSET ,RHINO-HEAD ,CONTBIT>
		      <MOVE ,RUBY ,RHINO-HEAD>)>)>
	<COND (<==? ,VILLAIN-PER ,LOVER>
	       <SETG SEARCHER ,LORD>)
	      (T <SETG SEARCHER ,VILLAIN-PER>)>
	<COND (<FSET? ,VILLAIN-PER ,FEMALE>
	       <FSET ,GHOST-NEW ,FEMALE>)>
	;<SET C <GETP ,VILLAIN-PER ,P?CHARACTER>>
	;<PUTP ,GHOST-NEW ,P?CHARACTER .C>	;"in DRESS-GHOST">
[
<OBJECT CANE
	;(IN LOCAL-GLOBALS)
	(DESC "cane")
	(SYNONYM CANE HANDLE)
	(FLAGS TAKEBIT NDESCBIT SURFACEBIT OPENBIT SEARCHBIT SECRETBIT)
	(ACTION CANE-F)>

<ROUTINE CANE-F ("AUX" P)
 <COND (<ATTACK-VERB?>
	<NO-VIOLENCE? ,CANE>
	<RTRUE>)
       (T <DISCOVER-WAR-CLUB ,CANE>)>>

<OBJECT PAINT
	(IN CANE)
	(DESC "coat of paint")
	(ADJECTIVE NEW)
	(SYNONYM PAINT COAT)
	(FLAGS NDESCBIT TRYTAKEBIT SEENBIT SECRETBIT)
	(ACTION PAINT-F)>

<ROUTINE PAINT-F ()
 <COND (<VERB? EXAMINE>
	<TELL "It seems to be hiding something." CR>)
       (<OR <VERB? BRUSH LOOK-UNDER REMOVE RUB TAKE-OFF>
	    <AND <VERB? TAKE> <T? ,PRSI>>>
	<DISCOVER-WAR-CLUB ,CANE ;<LOC ,PAINT> T>
	<RTRUE>)
       (<DIVESTMENT? ,PAINT>
	<HAR-HAR>)>>

;<OBJECT CURTAIN-ROD
	;(IN LOCAL-GLOBALS)
	(DESC "curtain rod")
	(ADJECTIVE CURTAIN)
	(SYNONYM ROD)
	(FLAGS NDESCBIT)
	(ACTION CURTAIN-ROD-F)>

;<ROUTINE CURTAIN-ROD-F () <DISCOVER-WAR-CLUB ,CURTAIN-ROD>>

<ROUTINE DISCOVER-WAR-CLUB (OBJ "OPTIONAL" (DO-IT <>) "AUX" PER)
 <COND (<OR <VERB? BRUSH RUB> <T? .DO-IT>>
	<COND (<FSET? ,WAR-CLUB ,SECRETBIT>
	       <DISCOVER ,WAR-CLUB ,PAINT>
	       <MOVE ,WAR-CLUB <LOC .OBJ>>
	       <ROB .OBJ <LOC .OBJ>>
	       <MOVE .OBJ ,LOCAL-GLOBALS>
	       <MOVE ,PAINT ,LOCAL-GLOBALS>
	       <RTRUE>)>)
       (<VERB? EXAMINE SEARCH>
	<COND (<FSET? ,WAR-CLUB ,SECRETBIT>
	       <FCLEAR ,PAINT ,SECRETBIT>
	       <TELL
"There's something strange about this " D .OBJ ".
It's shaped like a baseball bat, but with hard, faceted bumps all over it.
It has a new " 'PAINT "." CR>)
	      ;(T <DESCRIBE-WAR-CLUB>)>)>>

<ROUTINE ATTACK-VERB? ("OPT" (SHOOT <>))
 <COND (<VERB? ATTACK KILL SLAP>
	<COND (<FSET? ,PRSO ,PERSONBIT>
	       <RTRUE>)>)
       (<VERB? SHOOT>
	<COND (<AND <T? .SHOOT>
		    <FSET? ,PRSO ,PERSONBIT>>
	       <RTRUE>)>)
       (<VERB? RING PUT>
	<COND (<AND <T? .SHOOT>
		    <OR <ZERO? ,PRSI>
			<FSET? ,PRSI ,PERSONBIT>>>
	       <RTRUE>)>)
       (<VERB? USE>
	<COND (<OR <ZERO? ,PRSI>
		   <FSET? ,PRSI ,PERSONBIT>>
	       <RTRUE>)>)>>

<OBJECT WAR-CLUB
	;(IN LOCAL-GLOBALS)
	(DESC "war club")
	(ADJECTIVE WAR ;" ZULU DINGAAN KING\'S DIAMOND")
	(SYNONYM CLUB HANDLE CANE ;KNOBKERRIE ;SCEPTER SCEPTRE)
	(FLAGS NDESCBIT SECRETBIT SEENBIT)
	(ACTION WAR-CLUB-F)>

<ROUTINE WAR-CLUB-F ()
 <COND (<VERB? COMPARE>
	<COND (<EQUAL? ,JEWEL ,PRSO ,PRSI>
	       <TELL
CTHE ,WAR-CLUB " has no " 'JEWEL " like this one." CR>)>)
       (<VERB? EXAMINE>
	<DESCRIBE-WAR-CLUB>)
       (<ATTACK-VERB?>
	<NO-VIOLENCE? ,WAR-CLUB>
	<RTRUE>)
       ;(T <SHOOTING ,WAR-CLUB>)>>

<ROUTINE DESCRIBE-WAR-CLUB ()
	<TELL
"It's a " 'WAR-CLUB " that once belonged to the Zulu king
Dingaan -- and it's studded with large diamonds!"
;"the brilliant diamond-studded knobkerrie, or war club, of Dingaan the
Vulture, the Zulu king who fought the Boers!" CR>>

<OBJECT SKULL
	;(IN LOCAL-GLOBALS)
	(DESC "fossil skull")
	(ADJECTIVE FOSSIL)
	(SYNONYM SKULL)
	(FLAGS NDESCBIT SECRETBIT)
	(SIZE 9)
	(ACTION SKULL-F)>

<ROUTINE SKULL-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE SEARCH>
	<TELL
"This staring skull is frightfully old -- even older than the castle." CR>)>>

<OBJECT NECKLACE
	;(IN SKELETON)
	(DESC "black pearl necklace")
	(ADJECTIVE BLACK PEARL)
	(SYNONYM PEARLS NECKLACE STRING)
	(FLAGS TAKEBIT NDESCBIT SECRETBIT WEARBIT ;WORNBIT)
	(SIZE 5)
	(TEXT
"It's a strand of shiny black pearls, the rarest and most precious kind
in the world!")>

;<OBJECT GAME
	(IN GLOBAL-OBJECTS)
	(DESC "MOONMIST")
	(ADJECTIVE MOON)
	(SYNONYM GAME MOONMIST MIST)
	(FLAGS NARTICLEBIT)
	(ACTION GAME-F)>

;<ROUTINE GAME-F ()
 	 <COND (<VERB? EXAMINE FIND LAMP-ON PLAY READ THROUGH>
	        <SETG CLOCK-WAIT T>
	        <TELL "[You're playing it now!]" CR>)>>

<OBJECT MOONMIST
	(IN GLOBAL-OBJECTS)
	(DESC "Moonmist")
	(ADJECTIVE MOON GREEN)
	(SYNONYM MOONMIST MIST INK ;DRUG LIQUID ;GAME)
	(FLAGS NARTICLEBIT ;SECRETBIT)
	(ACTION MOONMIST-F)>

<ROUTINE MOONMIST-F ()
 <COND (<OR <VERB? PLAY READ>
	    <AND <VERB? EXAMINE FIND>
		 <IN? ,MOONMIST ,GLOBAL-OBJECTS>>>
	<SETG CLOCK-WAIT T>
	<TELL "[You're playing it now!]" CR>)
       (<REMOTE-VERB?>
	<RFALSE>)
       (<VERB? TAKE>
	<COND (<AND <NOT <IN? ,MOONMIST ,GLOBAL-OBJECTS>>
		    <VISIBLE? ,MOONMIST>>
	       <PERFORM ,PRSA <LOC ,MOONMIST> ,PRSI>
	       <RTRUE>)
	      (T <YOU-CANT>)>)
       (<NOT-HOLDING? ,PRSO>
	<RTRUE>)
       (<VERB? POUR PUT>
	<COND (<AND <T? ,PRSI>
		    <FSET? ,PRSI ,PERSONBIT>
		    <SHOOTING ,MOONMIST>>
	       <RFATAL>)>
	<MOVE ,MOONMIST ,LOCAL-GLOBALS ;,GLOBAL-OBJECTS>
	<TELL CTHE ,MOONMIST " dribbles ">
	<COND (<ZERO? ,PRSI> <TELL <GROUND-DESC>>)
	      (<NOT <FSET? ,PRSI ,SURFACEBIT>>
	       <TELL "into" THE ,PRSI>)
	      (T <TELL "on" THE ,PRSI>)>
	<TELL ", sizzles, and evaporates." CR>)
       (<AND <DIVESTMENT? ,MOONMIST>
	     ;<OR <NOT <VERB? PUT>>
		 <ZERO? ,PRSI>
		 <NOT <FSET? ,PRSI ,PERSONBIT>>>>
	<PERFORM ,PRSA ,INKWELL ,PRSI>
	<RTRUE>)
       (<VERB? DRINK EAT>
	<COND (<==? ,WINNER ,PLAYER>
	       <TELL
"First it puts your tongue to sleep. Then your tummy. Then your brain.">
	       <FINISH>)>)
       (<VERB? EXAMINE SMELL>
	<TELL "It's a greenish liquid with a strong odor." CR>)
       (T <SHOOTING ,MOONMIST>)>>
][
<OBJECT GENERIC-CLUE
	(IN GLOBAL-OBJECTS)
	(DESC "clue")>

<OBJECT CLUE-1
	(IN SIDEBOARD ;"BUTLER ;LOCAL-GLOBALS")
	(DESC "first clue")
	(ADJECTIVE FIRST 1ST ;IDENTITY CLUE PICTURE)
	(SYNONYM CLUE CLUES CARD)
	(GENERIC GENERIC-CLUE-FCN)
	(FLAGS NDESCBIT ;TAKEBIT SEENBIT SECRETBIT READBIT)
	(SIZE 1)
	(ACTION CLUE-1-F)>

;<GLOBAL CLUE-1-SHOWN:FLAG <>>
<ROUTINE CLUE-1-F ()
 <COND ;(<VERB? SHOW>
	<COND (<FSET? ,PRSO ,PERSONBIT>
	       <PUT ,CLUE-1-KNOWN <GETP ,PRSO ,P?CHARACTER> T>
	       <RFALSE>)>)
       (<VERB? COMPARE>
	<COND (<EQUAL? ,TREASURE ,PRSO ,PRSI>
	       <TELL CTHE ,TREASURE>
	       <COND (<AND <EQUAL? ,VARIATION ,LORD-C>
			   <NOT <FSET? ,PLAYER ,FEMALE>>>
		      <TELL " looks just like the one on">)
		     (T <TELL " seems to match">)>
	       <TELL " the " 'CLUE-1 "!" CR>)>)
       (<VERB? EXAMINE READ>
	<COND (<NOT <FSET? ,CLUE-1 ,TOUCHBIT>>
	       <TELL "You can't see its face." CR>
	       <RTRUE>)>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	;<PUT ,CLUE-1-KNOWN ,PLAYER-C T>
	<TELL "The " D ,CLUE-1 " shows ">
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <TELL "the King of ">
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL "Spades, holding a sceptre." CR>)
		     (T <TELL
"Clubs in one corner, with a picture of an African
chief holding a " 'WAR-CLUB "; in the other corner is the King of Diamonds,
with a picture of a crowned vulture clutching a diamond." CR>)>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL
"a Polynesian diver, holding a knife and plunging
through black water." CR>)
		     (T <TELL "a photo of singer Pearl Bailey." CR>)>)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL
D ,CASTLE ", with a cloud of mist hiding the " 'MOON "." CR>)
		     (T <TELL
"an Amazon hunter, aiming a " 'BLOWGUN " at the tree tops." CR>)>)
	      ;(<EQUAL? ,VARIATION ,DEALER-C>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL
"a coiled cobra weaving its head in time to a snake charmer's flute music."
CR>)
		     (T <TELL
"a woman with yellow headband standing in front of the Sphinx." CR>)>)
	      (<EQUAL? ,VARIATION ,PAINTER-C>
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <TELL
"a man, who looks rather Chinese, peeking around a curtain." CR>)
		     (T <TELL
"a " 'SKELETON " in Chinese mandarin costume." CR>)>)
	      ;(<EQUAL? ,VARIATION ,OFFICER-C>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL
"a pigeon in flight, shot by an arrow and dripping blood." CR>)
		     (T <TELL
"a wintry park scene, with a thinly clad mother holding her baby and
shivering violently. A voice balloon from her mouth says, \"BR-R-R-R!\"
A reddish pigeon is perched on a frozen fountain nearby." CR>)>)>)>>

<OBJECT CLUE-2
	(IN LORD ;LOCAL-GLOBALS)
	(DESC "second clue")
	(ADJECTIVE SECOND 2ND ;LOCATION JACK\'S ;JACK HIS VIV\'S ;VIVIEN HER)
	(SYNONYM CLUE CLUES CARD POEM)
	(GENERIC GENERIC-CLUE-FCN)
	(FLAGS NDESCBIT TAKEBIT SEENBIT SECRETBIT READBIT)
	(SIZE 1)
	(ACTION CLUE-2-F)>

<ROUTINE CLUE-2-F ()
 <COND (<VERB? EXAMINE READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<FSET ,CLUE-2 ,TOUCHBIT>
	<TELL CHE ,CLUE-2 " says," CR>
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <TELL
"\"It's curtains for anyone whose head gets in the way of this!\"" CR>)
		     (T
		      <SETG CLUE-LOC ,CHAPEL>
		      <TELL
"\"Forbidden fruit tempted the very first lass.|
'Twas once in a garden but now in a glass.\""
;"\"Look here, friend!\"
on an inscribed photo of British Prime Minister Neville Chamberlain
with his famous umbrella, returning from his meeting with Hitler at
Munich. The last stroke of the pen points to the umbrella." CR>)>)
	      (<EQUAL? ,VARIATION ,PAINTER-C>
	       <COND (<NOT <FSET? ,MUSIC ,TOUCHBIT>>
		      <SETG CLUE-LOC ,SITTING-ROOM>)
		     (<NOT <FSET? ,BOTTLE ,TOUCHBIT>>
		      <SETG CLUE-LOC ,BASEMENT>)
		     (T <SETG CLUE-LOC ,DRAWING-ROOM>)>
	       <TELL
"\"Three fellows argued about life:|
1. 'Using this motto, no chap can go wrong:|
    Leave the wench and the grape, but go with a ____!'|
2. 'On the seas of my life sails a ship that is laden|
    Not with bottles or tunes, but with innocent ______s!'|
3. 'Women and singing are both very fine,|
    But for me there is nothing to equal good ____!'\"" CR>
	       ;<COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL
"\"The Road to Mandalay is now underwater, and the only way
to communicate is by submarine cable.\"" CR>)
		     (T <TELL "\"Get to the root of it!\"" CR>)>)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>
	       <SETG CLUE-LOC ,GAME-ROOM>
	       <TELL
"\"My first is an 'I,' but find an 'eye' that sees not.\"" CR>)
	      (T ;<EQUAL? ,VARIATION ,FRIEND-C>
	       <COND ;(<FSET? ,PLAYER ,FEMALE>
		      <TELL
"\"A woman knows the secret, but to get inside her mind is difficult
and often dangerous.\"" CR>)
		     (T
		      <SETG CLUE-LOC ,DECK>
		      <TELL
"\"... Yet the ear distinctly tells,...|
How the danger sinks and swells,|
By the sinking or the swelling in the anger of the ____s...\"" CR>)>)
	      ;(<EQUAL? ,VARIATION ,DEALER-C>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL
"\"If Cleopatra ruled the Nile, who ruled the waves -- and what did
they have in common?\"" CR>)
		     (T <TELL
"\"Know ye that a woman may proudly flaunt her
crowning glory, but the wise man keeps his under his hat.\"" CR>)>)
	      ;(<EQUAL? ,VARIATION ,OFFICER-C>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <TELL "[to be supplied]" CR>)
		     (T <TELL
"\"Too much card-playing again!\"
It's a " 'CARTOON " of a red-eyed woozy rhino, clad in rumpled evening
clothes and holding both front hoofs painfully to its head, obviously
\"coming to\" after a night's hard drinking with glasses and bottles
nearby." CR>)>)>)>>

<OBJECT CLUE-3
	(DESC "third clue")
	(ADJECTIVE THIRD 3RD)
	(SYNONYM CLUE CLUES CARD POEM)
	(GENERIC GENERIC-CLUE-FCN)
	(FLAGS NDESCBIT SECRETBIT ;TAKEBIT READBIT)
	(SIZE 1)
	(ACTION CLUE-3-F)>

<ROUTINE CLUE-3-F ()
 <COND (<VERB? EXAMINE READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<FSET ,CLUE-3 ,TOUCHBIT>
	<FSET ,CLUE-3 ,TAKEBIT>
	<TELL CHE ,CLUE-3 " says,|">
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <SETG CLUE-LOC ,GARDEN>
	       <TELL
"\"Despite its appearance, the fruit was quite sour.|
One bite of the apple drove Eve from her bower.\"" CR>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <SETG CLUE-LOC 0>
	       <TELL
"\"... And so, all the night-tide, I lie down by the side|
Of my darling -- my darling -- my life and my bride,...|
In her tomb by the sounding sea.\"" CR>)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>
	       <SETG CLUE-LOC ,GALLERY>
	       <TELL
"\"My second is in never but not in ever, and lies in a hidden 'end'.\""
;"but find" CR>)
	      (T ;<EQUAL? ,VARIATION ,PAINTER-C>
	       <SETG CLUE-LOC ,DECK>
	       <TELL
"\"My al___ has no glamour;|
Its '____e' tones do clam___.|
Can you find me?\"" CR>)>)>>

<OBJECT CLUE-4
	(DESC "fourth clue")
	(ADJECTIVE FOURTH 4TH LAST)
	(SYNONYM CLUE CLUES CARD POEM)
	(GENERIC GENERIC-CLUE-FCN)
	(FLAGS NDESCBIT SECRETBIT ;TAKEBIT READBIT)
	(SIZE 1)
	;(FDESC 0)
	(ACTION CLUE-4-F)>

<ROUTINE CLUE-4-F ()
 <COND (<VERB? EXAMINE READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<FSET ,CLUE-4 ,TOUCHBIT>
	<FSET ,CLUE-4 ,TAKEBIT>
	<TELL CHE ,CLUE-4 " says,|">
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <SETG CLUE-LOC ,FOYER>
	       <TELL
"\"Out of the sunshine, into the rain...|
The end of the story is... Abel and CAIN.\"|
The last word is underlined." CR>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <SETG CLUE-LOC ,BASEMENT>
	       <TELL
"\"If you search for 'A Cask of Amontillado,' don't get
trapped!\"" CR>)
	      (T ;<EQUAL? ,VARIATION ,DOCTOR-C>
	       <SETG CLUE-LOC ,OFFICE>
	       <TELL
"\"My third is the silent side of knight.|
All together I am
what you could use for poison-pen letters.\"" CR>)>)>>
]

<ROUTINE PRINT-COLOR ("OPTIONAL" (X <>))
 <COND (<OR <NOT <0? ,VARIATION>> .X>
	<WORD-PRINT <GETB ,FAVE-COLOR 0> 1 ,FAVE-COLOR>
	<COND (<T? ,COLOR-FORCED>
	       <TELL " and ">
	       <PRINTB ,COLOR-FORCED>)>
	<RTRUE>)>>

;<CONSTANT NAME-LENGTH <SETG NAME-LENGTH 39>>
<GLOBAL FAVE-COLOR <TABLE #BYTE 3 #BYTE 114 #BYTE 101 #BYTE 100
				0 0 0 0 0 0 0 0 0 0 0 0 0 0>> "red"
<GLOBAL FIRST-NAME <TABLE #BYTE 0 #BYTE 120
				0 0 0 0 0 0 0 0 0 0 0 0 0 0 0>> "x"
<GLOBAL LAST-NAME  <TABLE #BYTE 0 #BYTE 116 #BYTE 101 #BYTE 115
				  #BYTE 116 #BYTE 101 #BYTE 114 #BYTE 0
				0 0 0 0 0 0 0 0 0 0 0 0>> "tester"

<GLOBAL SUFFIX <TABLE #BYTE 0 #BYTE 0 0 0>>
<CONSTANT JUNIOR-C 8>
<CONSTANT SENIOR-C 9>
<BUZZ JUNIOR JR SENIOR SR>

<ROUTINE TELL-SUFFIX ("AUX" I (J 1))
 <SET I <GETB ,SUFFIX 0>>
 <COND (<0? .I>
	<RFALSE>)>
 <TELL ", ">
 <COND (<==? ,JUNIOR-C .I>
	<TELL "Junior">
	<RTRUE>)
       (<==? ,SENIOR-C .I>
	<TELL "Senior">
	<RTRUE>)>
 <REPEAT ()
	 <PRINTC <GETB ,SUFFIX .J>>
	 <COND (<DLESS? I 1> <RTRUE>)>
	 <INC J>>>

<ROUTINE TITLE-NAME ()
	<TITLE>
	<COND (<OR <EQUAL? ,TITLE-WORD ,W?MRS ,W?MS ,W?MISS>
		   <EQUAL? ,TITLE-WORD ,W?MISTER ,W?MR>
		   <EQUAL? ,TITLE-WORD ,W?DOCTOR ,W?DR>>
	       <TELL LN>)
	      (T <TELL FN>)>>

<ROUTINE TITLE ()
	<COND (<EQUAL? ,TITLE-WORD ,W?MRS>	<TELL "Mrs. ">)
	      (<EQUAL? ,TITLE-WORD ,W?MS>	<TELL "Ms. ">)
	      (<EQUAL? ,TITLE-WORD ,W?MISS>	<TELL "Miss ">)
	      (<EQUAL? ,TITLE-WORD ,W?LADY>	<TELL "Lady ">)
	      (<EQUAL? ,TITLE-WORD ,W?DAME>	<TELL "Dame ">)
	      (<EQUAL? ,TITLE-WORD ,W?MADAME ,W?MADAM>	<TELL "Madame ">)
	      (<EQUAL? ,TITLE-WORD ,W?DOCTOR ,W?DR>	<TELL "Dr. ">)
	      (<EQUAL? ,TITLE-WORD ,W?LORD>	<TELL "Lord ">)
	      (<EQUAL? ,TITLE-WORD ,W?SIR>	<TELL "Sir ">)
	      (<EQUAL? ,TITLE-WORD ,W?MISTER ,W?MR>	<TELL "Mr. ">)
	      (<EQUAL? ,TITLE-WORD ,W?MASTER>		<TELL "Master ">)>>

<ROUTINE NON-BLANK-STUFF (DEST SRC CNT "AUX" (ND 1) (NS 0) B (OB 32))
 <DEC CNT>
 <REPEAT ()
	<SET B <GETB .SRC .NS>>
	<COND (<NOT <AND <==? .B 32>
			 <OR <==? .NS .CNT> <==? .OB 32>>>>
	       <PUTB .DEST .ND .B>
	       <INC ND>
	       <SET OB .B>)>
	<COND (<IGRTR? NS .CNT> <RETURN>)>>
 <PUTB .DEST 0 <- .ND 1>>>

<GLOBAL GENDER-KNOWN:FLAG <>>

<ROUTINE FULL-NAME ("OPT" (NO-TELL <>))
	<PUTB ,SUFFIX 0 0>
	<PUTB ,LAST-NAME 0 0>
	<SETG MIDDLE-WORD 0>
	<SETG TITLE-WORD 0>
	<COND (<ZERO? .NO-TELL>
	       <TELL "\"I said: Please state your full name.\"" CR>)>
	<RTRUE>>

<GLOBAL MIDDLE-WORD 0>

<ROUTINE GET-NAME ("AUX" NUM N M I BEG END)
  <PUTB ,P-INBUF 0 30>	;"for CoCo"
  <REPEAT ()
	<TELL !\>>
	<READ ,P-INBUF ,P-LEXV>
	<SET NUM <GETB ,P-LEXV ,P-LEXWORDS>>
	<COND (<0? .NUM>
	       <TELL !\" ,BEG-PARDON "\" ">
	       <AGAIN>)>
	<SET N ,P-LEXSTART>
	<SET BEG <GET ,P-LEXV .N>>
	<COND (<TITLE-NOUN? .BEG>
	       <DEC NUM>	;"We found a title!"
	       <SET N <+ .N ,P-LEXELEN>>
	       <SETG TITLE-WORD .BEG>
	       <COND (<AND ;<NOT <EQUAL? .BEG ,W?LT>>
			   <NOT <EQUAL? .BEG ,W?DOCTOR ,W?DR ,W?DETECT>>>
		      <SETG GENDER-KNOWN T>)>	;"And a gender!"
	       <COND (<OR <EQUAL? .BEG ,W?MR ,W?MISTER ,W?MASTER>
			  <EQUAL? .BEG ,W?LORD ,W?SIR>>
		      ;<TAILOR-OUTFITS ,P?EAST>
		      <FCLEAR ,PLAYER ,FEMALE>)
		     ;(T
		      <TAILOR-OUTFITS ,P?WEST>)>
	       <REPEAT ()	;"Skip over period(s) after title."
		       <COND (<EQUAL? <GET ,P-LEXV .N> ,W?PERIOD>
			      <DEC NUM>
			      <SET N <+ .N ,P-LEXELEN>>)
			     (T <RETURN>)>>)>
	<COND (<L? .NUM 2>	;"Too few words?"
	       <COND (<EQUAL? .BEG ,W?QUIT ,W?Q>
		      <V-QUIT>)
		     (<EQUAL? .BEG ,W?RESTART>
		      <V-RESTART>)
		     (<EQUAL? .BEG ,W?RESTORE>
		      <V-RESTORE>)>
	       <FULL-NAME>
	       <AGAIN>)>
	;%<DEBUG-CODE <COND (,DBUG <TELL !\{ N .NUM " tokens}" CR>)>>
	<SET BEG .N>					;"1st word"
	<SET END <+ .N <* ,P-LEXELEN <- .NUM 1>>>>	;"last word"
	<REPEAT ()	;"Ignore final punctuation."
		<COND (<EQUAL? <GET ,P-LEXV .END> ,W?PERIOD ,W?\! ,W??>
		       ;<DEC NUM>
		       <SET END <- .END ,P-LEXELEN>>)
		      (T <RETURN>)>>
	<COND (<G=? .BEG .END>	;"Too few words?"
	       <FULL-NAME>
	       <AGAIN>)>
	<COND (<EQUAL? <GET ,P-LEXV .END> ,W?SR ,W?SENIOR>
	       <SET END <- .END ,P-LEXELEN>>
	       <PUTB ,SUFFIX 0 ,SENIOR-C>)
	      (<EQUAL? <GET ,P-LEXV .END> ,W?JR ,W?JUNIOR>
	       <SET END <- .END ,P-LEXELEN>>
	       <PUTB ,SUFFIX 0 ,JUNIOR-C>)
	      (<L? <SET NUM <GETB ,P-LEXV <SET N <* 2 <+ .END 1>>>>> 6>
			;"no. chars in last word"
	       <SET M <GETB ,P-LEXV <+ 1 .N>>>	;"start of last word"
	       <SET I 0>
	       <REPEAT ()
		       <COND (<NOT <DLESS? NUM 0>>
			      <COND (<NOT <EQUAL? <GETB ,P-INBUF .M>
						  %<ASCII !\i>
						  %<ASCII !\v>
						  %<ASCII !\x>>>
				     <RETURN>)>
			      <INC I>
			      <PUTB ,SUFFIX .I <- <GETB ,P-INBUF .M> 32>>
			      <INC M>)
			     (T
			      <PUTB ,SUFFIX 0 .I>
			      <SET END <- .END ,P-LEXELEN>> ;"back over suffix"
			      <RETURN>)>>)>
	<REPEAT ()	;"Ignore pre-suffix punctuation."
		<COND (<EQUAL? <GET ,P-LEXV .END> ,W?PERIOD ,W?COMMA ,W?THE>
		       <SET END <- .END ,P-LEXELEN>>)
		      (T <RETURN>)>>
	<COND (<G=? .BEG .END>	;"Too few words?"
	       <FULL-NAME>
	       <AGAIN>)>
	<SET N <* 2 <+ .END 1>>>
	<SET NUM <GETB ,P-LEXV .N>>	;"no. chars in last word"
	<SET END <- .END ,P-LEXELEN>>	;"penultimate word"
	<COND (<EQUAL? <GET ,P-LEXV .END> ,W?APOSTROPHE>
	       <SET END <- .END ,P-LEXELEN>>	;"antepenultimate word"
	       <SET N <* 2 <+ .END 1>>>		;"update"
	       <SET NUM <+ .NUM <GETB ,P-LEXV .N>>>
	       <INC NUM>		;"for apostrophe")>
	<COND (<G? .BEG .END>	;"Too few words?"
	       <FULL-NAME>
	       <AGAIN>)>
	<SET I <+ .BEG ,P-LEXELEN>>	;"second word"
	<REPEAT ()
		<COND (<G? .I .END>
		       <SETG MIDDLE-WORD 0>
		       <RETURN>)
		      (<NOT <EQUAL? <SET M <GET ,P-LEXV .I>>
				    ,W?THE ,W?OF ,W?COMMA>>
		       <SET I <+ .I ,P-LEXELEN>>)
		      (T
		       <SETG MIDDLE-WORD .M>
		       <SET M <* 2 <+ 1 <+ .I ,P-LEXELEN>>>>;"1st wd last name"
		       <SET NUM <+ .NUM <- <GETB ,P-LEXV <+ 1 .N>>
					   <GETB ,P-LEXV <+ 1 .M>>>>>
		       <SET N .M>
		       <RETURN>)>>
	;<COND (<G? .NUM ,NAME-LENGTH>
	       <SET NUM ,NAME-LENGTH>)>
	<NON-BLANK-STUFF ,LAST-NAME	;"Copy last name"
			 <REST ,P-INBUF <GETB ,P-LEXV <+ 1 .N>>>
			 .NUM>
	<SET N <- .N ,P-WORDLEN>>		;"last token in 1st name"
	;<SET END <- <GETB ,P-LEXV <+ 1 .N>> 2>>;"last char in 1st name"
	<COND (<T? ,MIDDLE-WORD>
	       <SET N <- .N ,P-WORDLEN>>
	       ;<SET END <- .END <+ 1 <GETB ,P-LEXV <- .M ,P-WORDLEN>>>>>)>
	<SET BEG <GETB ,P-LEXV <+ 3 <* 2 .BEG>>>>;"1st char in 1st name"
	<SET END <+ -1 <+ <GETB ,P-LEXV .N> <GETB ,P-LEXV <+ 1 .N>>>>>
						;"last char in 1st name"
	<SET N <+ 1 <- .END .BEG>>>		;"no. chars in 1st name"
	;<COND (<G? .N ,NAME-LENGTH>
	       <SET N ,NAME-LENGTH>)>
	<NON-BLANK-STUFF ,FIRST-NAME	;"Copy 1st name"
			 <REST ,P-INBUF .BEG ;<GETB ,P-LEXV <- .N 1>>>
			 .N>
	<TELL "\"Did you say your name is ">
	<TELL-FULL-NAME>
	<TELL "?\"">
	<COND (<YES?>
	       <PUTB ,P-INBUF 0 80>
	       <RETURN>)
	      (T
	       <TELL "\"Then please speak up.\"|">
	       <FULL-NAME T>)>>>

<BUZZ ;"DUKE DUCHESS" DAME MADAME ;MASTER>
<GLOBAL TITLE-WORD 0>

<ROUTINE PRINT-NAME (TBL "AUX" (PTR 0) LEN CH OCH (SP? T))
	 <SET LEN <GETB .TBL 0>>
	 <REPEAT ()
		<COND (<IGRTR? PTR .LEN> <RETURN>)>
		<SET OCH .CH>
		<SET CH <GETB .TBL .PTR>>
		<COND (<OR <L? .CH 97> <G? .CH 122>>
		       <PRINTC .CH>)
		      (<T? .SP?>
		       <PRINTC <- .CH 32>>)
		      (<OR <NOT <EQUAL? .OCH 39>>	;"'"
			   <EQUAL? .PTR .LEN>
			   <EQUAL? 32 <GETB .TBL <+ 1 .PTR>>>>
		       <PRINTC .CH>)
		      (T <PRINTC <- .CH 32>>)>
		<COND (<OR <EQUAL? .CH 32 46>	;" ."
			   <EQUAL? .CH 45 38>>	;"-&"
		       <SET SP? T>)
		      (T <SET SP? <>>)>>
	 <COND (<EQUAL? .CH 46> <RFALSE>)	;"Don't TELL period next."
	       (T <RTRUE>)>>
