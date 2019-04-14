"PEOPLE for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

"By Lan, Ros, Car, Pol, Tre, and Pen
Ye may know the Cornishmen."

"Constants used as table offsets for each character, including the player:"
<CONSTANT PLAYER-C 0>
<CONSTANT FRIEND-C 1>
<CONSTANT LORD-C 2>
<CONSTANT LOVER-C 9>
<CONSTANT DEB-C 7>
<CONSTANT OFFICER-C 5>
<CONSTANT DOCTOR-C 4>
<CONSTANT DEALER-C 6>
<CONSTANT PAINTER-C 3>
<CONSTANT COUSIN-C 11>
<CONSTANT BUTLER-C 8>
<CONSTANT MAID-C 12>
<CONSTANT DRAGON-C 13>
<CONSTANT BUFFALO-HEAD-C 14>
<CONSTANT RHINO-HEAD-C 15>
<CONSTANT GHOST-NEW-C 10>
<CONSTANT GHOST-OLD-C 16>
<CONSTANT CHARACTER-MAX 8 ;14>
<CONSTANT DINNER-FOR 8>

<OBJECT PLAYER
	(DESC "yourself")
	(IN CAR)
	(SYNONYM ;"I" ME MYSELF)
	(ACTION PLAYER-F)
	(FLAGS NDESCBIT NARTICLEBIT SEARCHBIT PERSONBIT SEENBIT TOUCHBIT FEMALE
		;TRANSBIT OPENBIT ;"see GET-OBJECT")
	(LDESC 0)	;"for generality"
	(LINE 0)	;"for generality"
	(CHARACTER 0)>

<OBJECT PLAYER-NAME
	(IN GLOBAL-OBJECTS)
	(DESC "yourself")
	(ADJECTIVE F.N L.N ;"for poss's")
	(SYNONYM ;F.N L.N WE US)
	(ACTION PLAYER-NAME-F)
	(FLAGS NARTICLEBIT PERSONBIT SEENBIT TOUCHBIT)>

<ROUTINE PLAYER-NAME-F ()
	<DO-INSTEAD-OF ,PLAYER ,PLAYER-NAME>
	<RTRUE>>

;<GLOBAL PLAYER-SEATED:NUMBER <>>	"negative => lying down"
;<GLOBAL PLAYER-HIDING:OBJECT <>>

;<ROUTINE NOISY? (RM) <RFALSE>>

<ROUTINE PLAYER-F ("OPTIONAL" (ARG <>) "AUX" (L <>))
 <COND (<NOT <==? .ARG ,M-WINNER>>
	<COND (<DOBJ? PLAYER>
	       <COND (<VERB? ARREST DANCE ;GOODBYE HELLO SORRY THANKS>
		      <HAR-HAR>
		      <RTRUE>)
		     (<VERB? EXAMINE>
		      <TELL "You are wearing">
		      <COND (<ZERO? ,NOW-WEARING> <TELL " nothing">)
			    (T <TELL THE ,NOW-WEARING>)>
		      <SET L <FIRST? ,PLAYER>>
		      <REPEAT ()
			      <COND (<ZERO? .L>
				     <RETURN>)
				    (<AND <FSET? .L ,WORNBIT>
					  <NOT <==? .L ,NOW-WEARING>>>
				     <TELL " and" THE .L>)>
			      <SET L <NEXT? .L>>>
		      <TELL "." CR>
		      <RTRUE>)
		     (<VERB? SEARCH>
		      <PERFORM ,V?INVENTORY>
		      <RTRUE>)
		     (<VERB? SMELL>
		      <TELL "You smell ">
		      <COND (<T? ,WASHED> <TELL "clean and fresh." CR>)
			    (T <TELL "as if you need washing." CR>)>
		      <RTRUE>)>)
	      (T <RFALSE>)>)
       (<DIVESTMENT? ,NOW-WEARING>
	<COND (<NO-CHANGING?> <RTRUE>)
	      (T
	       <COND (<AND <NOT <ZERO? ,NOW-WEARING>>
			   <NOT <VERB? DISEMBARK REMOVE>>>
		      ;<MOVE ,NOW-WEARING ,WINNER>
		      <FIRST-YOU "remove" ,NOW-WEARING>
		      <FCLEAR ,NOW-WEARING ,WORNBIT>
		      <SETG NOW-WEARING <>>)>
	       <RFALSE>)>)
       (<AND <T? ,PRSI>
	     <NOT <VERB? SEARCH-FOR>>
	     <FSET? ,PRSI ,SECRETBIT>
	     <NOT <FSET? ,PRSI ,SEENBIT>>>
	<NOT-FOUND ,PRSI>
	<RTRUE>)
       (<AND <T? ,PRSO>
	     <NOT <VERB? FIND WALK ;$WHERE>>
	     <FSET? ,PRSO ,SECRETBIT>
	     <NOT <FSET? ,PRSO ,SEENBIT>>>
	<NOT-FOUND ,PRSO>
	<RTRUE>)
       (<AND <T? ,AWAITING-REPLY>
	     <VERB? FOLLOW THROUGH WALK WALK-TO>>
	<SETG CLOCK-WAIT T>
	<PLEASE-ANSWER>
	<RTRUE>)
       (<AND <EQUAL? <SET L <LOC ,PLAYER>> ,HERE ,CAR>
	     ;<NOT ,PLAYER-SEATED>
	     ;<NOT ,PLAYER-HIDING>>
	<RFALSE>)
       (<T? ,P-WALK-DIR>		<TOO-BAD-SIT-HIDE>)
       (<EQUAL? ,PRSO <> ,ROOMS .L>
					<RFALSE>)
       ;(<EQUAL? ,PRSO ,PLAYER-SEATED <- 0 ,PLAYER-SEATED>>
					<RFALSE>)
       (<VERB? WALK-TO SEARCH SEARCH-FOR FIND>
	<COND (<DOBJ? SLEEP-GLOBAL>	<RFALSE>)
	      (T			<TOO-BAD-SIT-HIDE>)>)
       (<SPEAKING-VERB?>		<RFALSE>)
       (<GAME-VERB?>			<RFALSE>)
       (<REMOTE-VERB?>			<RFALSE>)
       (<VERB? AIM FAINT LISTEN LOOK-ON NOD SHOOT SMILE>
					<RFALSE>)
       (<HELD? ,PRSO>			<RFALSE>)
       (<HELD? ,PRSO ,GLOBAL-OBJECTS>	<RFALSE>)
       (<AND <EQUAL? .L ,CHAIR-DINING>
	     <IN? ,PRSO ,TABLE-DINING>>
					<RFALSE>)
       (<VERB? EXAMINE>			<RFALSE>)
       (<NOT <HELD? ,PRSO .L ;,PLAYER-SEATED>>	<TOO-BAD-SIT-HIDE>)
       (<NOT ,PRSI>			<RFALSE>)
       (<HELD? ,PRSI>			<RFALSE>)
       (<HELD? ,PRSI ,GLOBAL-OBJECTS>	<RFALSE>)
       (<NOT <HELD? ,PRSI .L ;,PLAYER-SEATED>>	<TOO-BAD-SIT-HIDE>)>>

<ROUTINE PLEASE-ANSWER ("AUX" (P <GETB ,QUESTIONERS ,AWAITING-REPLY>))
	<TELL D .P " says, \"">
	<COND (<EQUAL? .P ,BUTLER ,DOCTOR>
	       <TELL "Pardon me, "TN", but">)
	      (T <TELL "Wait a mo'.">)>
	<TELL " I asked you a question.\"" CR>>

<ROUTINE TOO-BAD-SIT-HIDE ()
 <COND ;(<T? ,PLAYER-SEATED>
	<COND (<AND <VERB? LIE> <G? 0 ,PLAYER-SEATED>>
	       <ALREADY ,WINNER "lying down">)
	      (<AND <VERB? SIT> <L? 0 ,PLAYER-SEATED>>
	       <ALREADY ,WINNER "sitting down">)
	      (T
	       <SETG PLAYER-SEATED <>>
	       <FIRST-YOU "stand up">
	       <RFALSE>)>)
       (T
	<MOVE ,WINNER ,HERE>
	<FIRST-YOU "stand up">
	<RFALSE>)
       ;(,PLAYER-HIDING
	<SETG CLOCK-WAIT T>
	<COND (<AND <VERB? HIDE-BEHIND> <ZERO? ,PRSI>>
	       <ALREADY ,WINNER "hiding">
	       ;<TELL "(You're already hiding.)" CR>)
	      (T <TELL "(You can't do that while you're hiding.)" CR>)>)>>

<OBJECT FRIEND
	(DESC "Tamara")
	(IN LIMBO ;COURTYARD)
	(ADJECTIVE MS MISS
		 TAMARA TAMMY LYND WOMAN ;"for poss's")
	(SYNONYM TAMARA TAMMY LYND WOMAN)
	(ACTION FRIEND-F)
	(DESCFCN FRIEND-D)
	(LDESC 0)
	(WEST "looking at you hopefully")
	(TEXT
"She's a beautiful red-haired young woman of average height.")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT FEMALE NARTICLEBIT NDESCBIT)
	(CAPACITY 40)
	(LINE 0)	;"unfriendliness"
	(CHARACTER 1)>

<ROUTINE FRIEND-D ("OPTIONAL" (ARG <>))
	<COND (T ;<OR <FSET? ,FRIEND ,TOUCHBIT>
		   <T? ,CLOCK-WAIT>>
	       <DESCRIBE-PERSON ,FRIEND>
	       <RTRUE>)>>
[
<GLOBAL AWAITING-REPLY:NUMBER <>>

"<CONSTANT FRIEND-R 1>
<CONSTANT DEB-R 7>
<CONSTANT DOCTOR-R 4>"
<CONSTANT OFFICER-1-R 5>
<CONSTANT OFFICER-2-R 8>
<CONSTANT BUTLER-1-R 2>
<CONSTANT BUTLER-2-R 3>
<CONSTANT BUTLER-3-R 6>
<CONSTANT BUTLER-4-R 9>
;<CONSTANT BUTLER-5-R 10>

<GLOBAL QUESTIONERS
	<PLTABLE (BYTE) FRIEND BUTLER BUTLER DOCTOR OFFICER
			BUTLER DEB OFFICER BUTLER>>

<GLOBAL QUESTIONS
 <LTABLE 
	"You did read my letter, and not just give it a hasty glance?"
	"Do you wish me to do so before I leave?"
	"Am I right in assuming that you are the well-known young American detective?"
	"Is it a case that brings you to Cornwall?"
	"Have you a theory about the castle ghost?"
	"May I offer one last suggestion?"
	"Are you one of those brutally fascinating American private eyes?"
	"Are there more girl sleuths like you in the States, my dear?"
	"You've seen that room, have you not?">>

<ROUTINE I-REPLY ("OPTIONAL" (GARG <>) "AUX" P X)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-REPLY:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND (<ZERO? ,AWAITING-REPLY>
	       <RFALSE>)
	      (<OR <EQUAL? ,AWAITING-REPLY ,BUTLER-1-R ,BUTLER-2-R ,BUTLER-3-R>
		   <EQUAL? ,AWAITING-REPLY ,BUTLER-4-R ;,BUTLER-5-R>>
	       <COND (<QUEUED? ,I-BUTLER-HINTS>
		      <QUEUE I-BUTLER-HINTS ,CLOCKER-RUNNING>)>
	       <SET P ,BUTLER>)
	      (<AND <EQUAL? ,AWAITING-REPLY ,FRIEND-C>
		    <EQUAL? ,VARIATION ,FRIEND-C>>
	       <SET P ,FRIEND>)
	      ;(T
	       <SET P <GET ,CHARACTER-TABLE ,AWAITING-REPLY>>)
	      (<EQUAL? ,AWAITING-REPLY ,DEB-C>
	       <SET P ,DEB>)
	      (<EQUAL? ,AWAITING-REPLY ,OFFICER-1-R ,OFFICER-2-R>
	       <SET P ,OFFICER>)
	      (<EQUAL? ,AWAITING-REPLY ,DOCTOR-C>
	       <SET P ,DOCTOR>)
	      ;(T <SET P ,QCONTEXT>)>
	<COND (<ZERO? .P>
	       <SETG AWAITING-REPLY <>>
	       <RFALSE>)
	      (T
	       <SET X <GETP .P ,P?LINE>>
	       <PUTP .P ,P?LINE <+ 1 .X>>
	       <COND (<0? .X>
		      <QUEUE I-REPLY ,CLOCKER-RUNNING>
		      <TELL
D .P " repeats, \"I said: " <GET ,QUESTIONS ,AWAITING-REPLY> "\"|">)
		     (T
		      <SETG AWAITING-REPLY <>>
		      <PUTP .P ,P?LDESC 20 ;"ignoring you">
		      <COND (<AND <VISIBLE? .P>
				  ;<NOT <FSET? .P ,MUNGBIT>>>
			     <TELL CHE .P " mutters, \"I'd ">
			     <COND (<EQUAL? .P ,FRIEND>
				    <TELL "wondered if you">)
				   (T <TELL "heard that Americans">)>
			     <TELL " were rude, but really...!\"" CR>)>)>
	       <RFATAL>)>>
]
<ROUTINE FRIEND-F ("OPTIONAL" (ARG <>) "AUX" OBJ X ;(L <LOC ,FRIEND>))
 <COND (<==? .ARG ,M-WINNER>
	<COND (<AND <EQUAL? ,AWAITING-REPLY ,FRIEND-C>
		    <VERB? YES NO>>
	       <PUTP ,FRIEND ,P?LDESC 0>
	       <PUTP ,FRIEND ,P?LINE 0>
	       <SETG AWAITING-REPLY <>>
	       <TELL "\"Then you ">
	       <COND (<NOT <VERB? YES>>
		      <TELL "don't " ;"know yet">)>
	       <SETG P-IT-OBJECT ,GHOST-NEW>
	       <TELL
"know about my engagement, and the " 'GHOST-OLD ", and the fact that...
that someone is trying to kill me!\"" CR>)
	      (<NOT <GRAB-ATTENTION ,FRIEND>> <RFATAL>)
	      (<AND <VERB? DESCRIBE> <DOBJ? GHOST-NEW>>
	       <TELL
"Tammy shakes her head. \"I just don't know if the ghost was
" 'LOVER ". I never saw her, just that portrait by Vivien.
The night I saw that ghastly face peering down at me...
Well, I was too shaken to remember anything, except that horrible
spider dropping down on me!\" She shudders at the memory." CR>)
	      (<AND <VERB? FOLLOW>
		    <DOBJ? PLAYER>>
	       <COND (<WILLING? ,FRIEND>
		      ;<NOT <EQUAL? ,VARIATION ,FRIEND-C>>
		      <TELL "\"I'll try my best, " FN "!\"" CR>
		      <NEW-FOLLOWER ,FRIEND>
		      <RTRUE>)
		     (T
		      <TELL "\"Not just now.\"" CR>
		      <RTRUE>)>)
	      (<VERB? YES>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?KISS ,FRIEND>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,FRIEND>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WHY-ME> <RFATAL>)>)
       ;(<VERB? RUB>
	<COND (<NOT <GRAB-ATTENTION ,FRIEND>>
	       <RFATAL>)
	      (T <TELL "\"But... I'm engaged!\"" CR>)>)
       (<AND <VERB? ASK-ABOUT SHOW TELL-ABOUT>
	     <IOBJ? CAR TWEED-OUTFIT EXERCISE-OUTFIT
			DINNER-OUTFIT SLEEP-OUTFIT>>
	<COND (<NOT <GRAB-ATTENTION ,FRIEND>>
	       <RFATAL>)
	      (T
	       <TELL "\"It's super!">
	       <COND (<NOT <IOBJ? TWEED-OUTFIT>>
		      <TELL " And it's " 'YOUR-COLOR "!">)>
	       <TELL "\"" CR>)>)
       (<SET OBJ <ASKING-ABOUT? ,FRIEND>>
	<COND (<NOT <GRAB-ATTENTION ,FRIEND .OBJ>>
	       <RFATAL>)
	      (<EQUAL? .OBJ ,CASTLE>
	       <TELL
"\"Oh, it's such a lovely place. If only I felt safe here!\"" CR>)
	      (<AND <OR <EQUAL? .OBJ ,SEARCHER>
			<EVIDENCE? .OBJ>>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,FRIEND-C>>>
		    <NOT <==? ,FRIEND ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<EQUAL? .OBJ ,COUSIN ,BUST ;,RECORDER>
	       <TELL "\"Sorry, but I never met the man.\"" CR>)
	      (<AND <EQUAL? .OBJ ,DEB>
		    <==? ,VARIATION ,FRIEND-C>>
	       ;<DISCRETION ,FRIEND .OBJ>
	       <TELL ,RHYMES-WITH-RICH CR>)
	      (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	       <TELL
"\"You know I've never worn glasses, "FN", or " 'LENS "es, either.">
	       <COND (<AND <EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ,PAINTER-C>
			   <T? ,FOUND-IT-PERM>
			   ;<FSET? ,FOUND-IT-PERM ,SEENBIT>
			   ;<FSET? ,LENS ,TOUCHBIT>>
		      <TELL " I can't imagine who dropped it.">)>
	       <TELL "\"" CR>)
	      (<AND <EQUAL? .OBJ ,PASSAGE>
		    <T? ,FRIEND-FOUND-PASSAGES>>
	       <FRIEND-PASSAGE-STORY>)
	      (<OR <EQUAL? .OBJ ,PRIEST-DOOR>
		   <AND <EQUAL? .OBJ ,PASSAGE>
			<ZERO? <GET ,FOUND-PASSAGES ,FRIEND-C>>>>
	       <TELL !\">
	       <COND (<EQUAL? .OBJ ,PASSAGE>
		      <TELL "You mean " 'PASSAGE "s like in horror movies? ">)>
	       <TELL "Golly, I don't know that much about the castle, ">
	       <COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
	       <TELL " Maybe Jack could tell you.">
	       <COND (<EQUAL? ,VARIATION ,FRIEND-C>
		      <TELL " Or Iris, who's spent far too much time here.">)>
	       <TELL "\"" CR>)
	      (<AND <EQUAL? .OBJ ,LORD ,ROMANCE ,FRIEND>
		    <OR <NOT <EQUAL? .OBJ ,SEARCHER>>
			<NOT <==? <GETP .OBJ ,P?LDESC> 21 ;"searching">>>>
	       <COND (<OR <EQUAL? .OBJ ,FRIEND>
			  <FSET? ,LORD ,TOUCHBIT>>
		      <TELL "\"Oh, "FN", I">
		      <COND (<EQUAL? ,VARIATION ,LORD-C>
			     <TELL " was">)
			    (T <TELL "'m">)>
		      <TELL
" so happy!\" " 'FRIEND " gushes. \"The whole thing seem">
		      <COND (<EQUAL? ,VARIATION ,LORD-C>
			     <TELL "ed ">)
			    (T <TELL "s ">)>
		      <TELL
"just like a fairy tale, or a paperback romance! But ">
		      <COND (<EQUAL? ,VARIATION ,LORD-C>
			     <TELL "lately,">
			     <COND (<EQUAL? <LOC ,LORD> ,HERE ,PSEUDO-OBJECT>
				    <TELL "\" she whispers, \"">)
				   (T <TELL !\ >)>
			     <TELL "Jack seems cool toward me">)
			    (T <TELL "I told you all about it in my letter">)>
		      <TELL ".\"" CR>)
		     (T
		      <MOVE ,LORD ,HERE>
		      <LORD-INTRO>
		      <RTRUE>)>)
	      (<EQUAL? .OBJ ,LOVER>
	       <TELL
;"\"You may be reading between the lines -- perhaps too much.
Oh, I know people hint the two of them had something going -- but if so,
I'm sure it was just a passing fancy on Jack's part.\"|
She adds, \"Mind you,  'LOVER  may have been in love with HIM -- that
wouldn't surprise me. " "\"She lived just down the beach, and from all
accounts she spent most of her time hanging about the castle. If she'd
stayed home a bit more, " 'ACCIDENT " never would've happened -- I mean,
her falling in the well and drowning.\"" CR>)
	      (<EQUAL? .OBJ ,ACCIDENT>
	       <TELL
"\"I can't tell you much,\" says " 'FRIEND ", \"because I wasn't here
when it happened. But all the guests here tonight were also here that
night. At dinner, they decided to have a wine tasting later in the
evening. " 'LOVER " was to choose and pour the wine. But when the time
came, she didn't show up, so they sent the butler down to the "
'BASEMENT ", to find her and help carry up the bottles. He came back
saying that she'd fallen down the well!\"" CR>)
	      (<EQUAL? .OBJ ,GHOST-OLD>
	       <TELL "\"I've told you all I know in my letter, ">
	       <COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
	       <TELL
" But come to think of it, there's an old " 'HISTORY-BOOK " in the "
'LIBRARY " that tells about " 'CASTLE ". You might learn more from
that.\"" CR>)
	      (<EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
	       <TELL
"\"Since I wrote you, I've seen the ghost again, and this third time was
the worst. After working late one night, I was " <GET ,LDESC-STRINGS 17>
;"preparing to leave" " the office to go to my room. As I opened the
door to the " 'CORR-2 ", I saw this ghostly figure with "
,LONG-BLOND-HAIR " and a dead white face. It was holding a sword and
about to attack me!\"|
" 'FRIEND " gulps and her voice quavers as she concludes,
\"I s-s-screamed and shrank back inside the office and slammed
the door! That's about all I can tell you, "FN"...\"" CR>
	       <COND (<AND <EQUAL? <LOC ,LORD> ,HERE ,PSEUDO-OBJECT>
			   <ZERO? <GETP ,LORD ,P?LINE>>>
		      <TELL
"\"I was just dozing off when Tammy's scream woke
me,\" adds " 'LORD ". \"By the time I ran into the " 'CORR-2 ",
the ghost ">
		      <COND (<EQUAL? ,VARIATION ,FRIEND-C>
			     <TELL "had disappeared.\"" CR>)
			    (T <TELL
"was almost gone. I did catch" ,WHITISH-GLIMPSE " as it disappeared down
the tower stairs -- but frankly I was more concerned about " 'FRIEND
".\"" CR>)>)>
	       <TELL
'FRIEND " fidgets nervously. \"I don't know whether this ghost is real,
or someone just play-acting. It can sneak around anywhere it pleases in
the whole castle. I just don't understand how a person dressed up like a
spook can do that without being caught!\"" CR>
	       <RTRUE>)
	      (<AND <EQUAL? .OBJ ,COSTUME ,BLOWGUN ,TAMARA-EVIDENCE>
		    <EQUAL? ,VARIATION ,FRIEND-C>>
	       <TELL "\"I've, uh, never seen it before.\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,FRIEND .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (<AND <FSET? .OBJ ,PERSONBIT>
		    <NOT <EQUAL? .OBJ ,MAID>>>
	       <SETG CLOCK-WAIT T>
	       <TELL
"\"I already told you about" HIM .OBJ " in my letter.\"" CR>)
	      (T
	       <COND (<VERB? SHOW>
		      <TELL "\"It looks like " A .OBJ " to me.\"" CR>)
		     (T
		      <TELL "\"I just don't know, ">
		      <COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
		      <TELL "\"" ;" That's why I wrote and asked you to come
here after you landed in England and took delivery of your new 'CAR .\""
CR>)>)>)
       (<AND <VERB? FOLLOW>
	     <TOUR?>>
	<RTRUE>)
       (<VERB? KISS HELLO ;DANCE>
	<UNSNOOZE ,FRIEND>
	<PUTP ,FRIEND ,P?LINE 0>
	<PUTP ,FRIEND ,P?LDESC 0>
	;<COND (<EQUAL? ,AWAITING-REPLY ,FRIEND-C>
	       <QUEUE I-REPLY 0>)>
	<TELL
CHE ,FRIEND hug " you with affection. \"I'm so glad you're here!\"" CR>)
       (T <PERSON-F ,FRIEND .ARG>)>>

<GLOBAL RHYMES-WITH-RICH
"\"I won't say what I think of her, but it rhymes with 'rich.'\"">

<OBJECT TAMARA-EVIDENCE
	(DESC "Tamara's receipt")
	(ADJECTIVE TAM\'S HER)
	(SYNONYM EVIDENCE RECEIPT)
	(FLAGS NDESCBIT READBIT NARTICLEBIT SECRETBIT RMUNGBIT ;"evidence")
	(CHARACTER 1)	;"for this char"
	(SIZE 2)
	(ACTION TAMARA-EVIDENCE-F)>

<ROUTINE TAMARA-EVIDENCE-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<TELL
"It's a receipt for the purchase of an adder from a pet shop in
Frobzance. Someone has written the word \"Iris\" on it and then
viciously crossed it out." CR>
	<COND (<ZERO? ,EVIDENCE-FOUND>
	       <CONGRATS>)>
	<SETG EVIDENCE-FOUND ,TAMARA-EVIDENCE>
	<RTRUE>)>>

<ROUTINE ASKING-ABOUT? (WHO "AUX" DR)
	<COND (<VERB? ASK-ABOUT CONFRONT SHOW>
	       <COND (<AND <IOBJ? PASSAGE>
			   <SET DR <FIND-FLAG-LG ,HERE ,DOORBIT ,SECRETBIT>>
			   <FSET? .DR ,OPENBIT>> ;"SHOW [open] PASSAGE TO x"
		      <RFALSE>)
		     (<EQUAL? .WHO ,PRSO>
		      <RETURN ,PRSI>)>)
	      ;(<VERB? FIND ;WHAT>
	       <COND (<EQUAL? .WHO ,WINNER>
		      <RETURN ,PRSO>)>)
	      (T <RFALSE>)>>

<ROUTINE LORD-INTRO ()
	<SETG FOLLOWER ,LORD>
	<FSET ,LORD ,TOUCHBIT>
	<FSET ,LORD ,SEENBIT>
	<FCLEAR ,LORD ,NDESCBIT>
	<SETG QCONTEXT ,LORD>
	<THIS-IS-IT ,LORD>
	<TELL
"\"Here comes Jack now!\" exclaims " 'FRIEND ", as he comes striding
toward you. ">
	<COMMON-DESC ,LORD>
	<TELL "|
\"My fiance, " 'LORD !\  ,TRESYLLIAN ",\" " 'FRIEND ,INTRODUCES "him.
\"Jack, this is my friend from the States, ">
	<TELL-FULL-NAME>
	<TELL ".\"|
\"So you're that famous young sleuth whom the Yanks call ">
	<COND (<ZERO? ,GENDER-KNOWN> <TELL "Young ">)
	      (T <TITLE>)>
	<TELL "Sherlock!\" says " 'LORD>
	<COND (<OR <ZERO? ,GENDER-KNOWN>
		   <NOT <FSET? ,PLAYER ,FEMALE>>>
	       <TELL ", shaking hands">)
	      ;(<FSET? ,PLAYER ,FEMALE>
	       <TELL "\" says " 'LORD ". \"">)
	      ;(T <TELL !\ >)>
	<TELL ". \"Tammy's told me about the mysteries you've solved">
	<COND (<ZERO? ,GENDER-KNOWN>
	       <TELL
". She seems to think you can unravel the mystery of " 'CASTLE ".\""
CR>)
	      (<FSET? ,PLAYER ,FEMALE>
	       <TELL
" -- but she never let on you looked so smashing! Welcome to
Cornwall, "FN" luv!\"|
Before you know it, he sweeps you into his arms
and kisses you warmly! Let's hope " 'FRIEND " doesn't mind --
but for the moment all you can see are " 'LORD "'s dazzling sapphire-blue
eyes." CR>)
	      (T <TELL "!\"|
His keen blue eyes size you up with a friendly twinkle. Yet his
friendliness seems to be all on the surface --
it may take time to figure out where His Lordship's really
coming from." CR>)>>

<ROUTINE TELL-FULL-NAME ()
	<TITLE>
	<TELL FN>
	<COND (<T? ,MIDDLE-WORD>
	       <COND (<NOT <==? ,MIDDLE-WORD ,W?COMMA>>
		      <TELL !\ >)>
	       <PRINTB ,MIDDLE-WORD>)>
	<TELL !\  LN>
	<TELL-SUFFIX>>

<OBJECT LORD
	(DESC "Lord Jack")
	(IN FOYER)
	(ADJECTIVE TALL MY
		 LORD JACK TRESYLLIAN MAN ;"for poss's")
	(SYNONYM LORD JACK TRESYLLIAN MAN)
	(ACTION LORD-F)
	(DESCFCN LORD-D)
	(LDESC 0 ;"Lord Jack Tresyllian is here, looking just as you want.")
	(WEST "surveying his domain")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT NARTICLEBIT NDESCBIT)
	(CAPACITY 40)
	(LINE 0)
	(CHARACTER 2)>

<GLOBAL TRESYLLIAN "Tresyllian">
;<GLOBAL LORD-SAID-FOYER:FLAG <>>

<ROUTINE LORD-D ("OPTIONAL" (ARG <>))
 <COND ;(<AND <==? ,HERE ,FOYER>
	     ;<FSET? ,LORD ,TOUCHBIT>	;"delays speech till 2nd turn"
	     <ZERO? ,LORD-SAID-FOYER>
	     <QUEUED? ,I-TOUR>
	     <ZERO? <GETP ,LORD ,P?LINE>>>
	<SETG LORD-SAID-FOYER T>
	<TELL
"\"This is the residential wing,\" says " 'LORD ". \"I'm told it was
added on to the tower keep in the 1500's, when life here became more
civilized. Of course there was more of the old castle standing then.\""
CR>)
       (T <DESCRIBE-PERSON ,LORD>)>
 <RTRUE>>

<GLOBAL WHITISH-GLIMPSE " a glimpse of a whitish figure from the rear">

<ROUTINE LORD-GHOST-STORY ()
	<TELL "\"No use asking ME, ">
	<COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
	<TELL " All I caught was" ,WHITISH-GLIMPSE ". ">
	<COND (<EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ,PAINTER-C>
	       <TELL "I couldn't even swear it was
a woman; it might've been some bloke in drag.\"" CR>)
	      (T
	       <FSET ,GHOST-NEW ,PERSONBIT>
	       <TELL
"She was blonde, definitely female, and about Dee's height...\"|
" 'LORD "'s own face is pale as he adds,
\"So, yes, it COULD have been her ghost... or Dee herself.\"" CR>)>>

<ROUTINE LORD-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,LORD>> <RFATAL>)
	      (<AND <VERB? DESCRIBE>
		    <DOBJ? GHOST-NEW>
		    <NOT <EQUAL? ,VARIATION ,FRIEND-C>>>
	       <LORD-GHOST-STORY>
	       <RTRUE>)
	      (<AND <VERB? ANSWER REPLY>
		    <==? 3 ,LIONEL-SPEAKS-COUNTER>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT ,LORD ,ARTIFACT>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,LORD>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WHY-ME> <RFATAL>)>)
       (<SET OBJ <ASKING-ABOUT? ,LORD>>
	<COND (<NOT <GRAB-ATTENTION ,LORD .OBJ>>
	       <RFATAL>)
	      (<EQUAL? .OBJ ,ACCIDENT>
	       <TELL
"Jack takes a deep breath. \"You've heard the bare facts, I assume --
she was in the " 'BASEMENT ", slipped and fell down the well.
The evidence proves what happened: a tent pole she'd
stumbled over; her one shoe that came off, with the slippery sole and
the loose heel; and of course " 'NECKLACE-OF-D ". I even"
,FOUND-FABRIC "\"|
He adds, \"The police never found " 'CORPSE ". But
the well is drawing tide water. No doubt she was swept out to sea.\"" CR>)
	      (<EQUAL? .OBJ ,ARTIFACT>
	       <TELL
"Jack fidgets and replies, \"Well, ah, we've all HEARD of
it, certainly. Uncle Lionel liked to drop teasing hints about how
valuable it was. But he was frightfully secretive. He never identified
it.">
	       <COND (<NOT <==? ,LIONEL-SPEAKS-COUNTER
				,INIT-LIONEL-SPEAKS-COUNTER>>
		      <TELL
" He's probably playing the same silly game right now.">
		      <COND (<T? ,LIONEL-SPEAKS-COUNTER>
			     <TELL " Let's hear the old boy out.">)>)>
	       <TELL "\"" CR>)
	      (<EQUAL? .OBJ ,CASTLE ;,HAUNTING>
	       <TELL
"\"Well, as I daresay you've heard, the castle's been infested lately
with a spook. And it seems bent on harming " 'FRIEND
". All in all, a very rum go.\"" CR>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,LORD-C>>>
		    <NOT <==? ,LORD ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<EQUAL? .OBJ ,FRIEND ,ROMANCE>
	       <TELL "\"She's a darling girl, really first-rate.">
	       <COND (<EQUAL? ,VARIATION ,FRIEND-C>
		      <COND (<EQUAL? <LOC ,LORD> ,HERE ,PSEUDO-OBJECT>
			     <TELL "\" He whispers, \"">)
			    (T <TELL !\ >)>
		      <TELL "Although lately she's seemed cool toward me.">)>
	       <TELL "\"" CR>)
	      (<AND <EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
		    <NOT <EQUAL? ,VARIATION ,FRIEND-C>>>
	       <LORD-GHOST-STORY>
	       <RTRUE>)
	      (<AND <EQUAL? .OBJ ,CLUE-2>
		    <NOT <EQUAL? ,VARIATION ,LORD-C>>
		    <NOT <IN? .OBJ ,LORD>>>
	       <CLUE-2-STORY ,LORD>
	       <RTRUE>)
	      ;(<EQUAL? .OBJ ,IAN-EVIDENCE>
	       <TELL
"\"Good Lord! But... I meant for him to woo her, not kill her!\"" CR>)
	      (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	       <COND ;(<AND <EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ,PAINTER-C>
			   <T? ,FOUND-IT-PERM>
			   ;<FSET? ,FOUND-IT-PERM ,SEENBIT>
			   ;<FSET? ,LENS ,TOUCHBIT>>
		      <TELL
"\"I've no idea where it came from. It's certainly not mine. ">)
		     (T <TELL
CHE ,LORD " gives a puzzled shrug, saying, \"">)>
	       <TELL "There's nothing wrong with my eyesight.\"" CR>)
	      (<AND <EQUAL? .OBJ ,MAID>
		    <FSET? ,LETTER ,TOUCHBIT>>
	       <TELL ,JACK-THINKS-GLADYS "\"" CR>)
	      (<AND <EQUAL? .OBJ ,PASSAGE>
		    <ZERO? <GET ,FOUND-PASSAGES ,LORD-C>>>
	       <TELL
"\"Hmm... good question. I know there are old tales about " 'CASTLE "
being honeycombed with " 'PASSAGE "s, but I've never actually stumbled
on any. Uncle Lionel would have known, but I never asked him before he
died, worse luck.\"" CR>)
	      (<EQUAL? .OBJ ,PRIEST-DOOR>
	       <TELL
"\"It's in the " 'DUNGEON ", close to the curtain wall. Dee used it
because her cottage is just down the shore.\"|
He adds, \"By the way, the name '" D ,PRIEST-DOOR "' dates back to when
the Catholic Church was outlawed in England, and priests had to hide for
fear of execution. Many British great houses have " 'PASSAGE "s,
hiding places, and entrances.\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,LORD .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,LORD .OBJ>)>)
       (<VERB? KISS RUB>
	<COND (<IN? ,FRIEND ,HERE>
	       <PUTP ,FRIEND ,P?LINE <+ 1 <GETP ,FRIEND ,P?LINE>>>
	       <TELL CHE ,FRIEND " flashes you an angry look." CR>)>
	<COND (<FSET? ,PLAYER ,FEMALE>
	       <UNSNOOZE ,LORD>
	       <PUTP ,LORD ,P?LINE 0>
	       <PUTP ,LORD ,P?LDESC 0>
	       <TELL
"\"I say! You Americans are frightfully friendly!\" says " 'LORD "." CR>)>)
       (T <PERSON-F ,LORD .ARG>)>>

<ROUTINE CLUE-2-STORY (PER)
	<TELL !\">
	;<COND (<NOT <FSET? ,CLUE-2 ,TOUCHBIT>>
	       <TELL
"Well, er, Lionel did give me a card once,\" " D .PER " mumbles. \"Don't
recall just what was on it -- some odd picture or jingle. ">)>
	<TELL
"I thought it was just one more of Lionel's weird jokes, or the effect
of jungle rot on his brain -- that sort of thing.\"" CR>>

<ROUTINE TELL-DUNNO (PER OBJ)
 <COND (<FSET? .OBJ ,PERSONBIT>
	<TELL "\"I don't indulge much in idle gossip, you know.\"" CR>)
       (T
	<TELL "\"You know as much as I do">
	<COND (<EQUAL? .PER ,OFFICER>
	       <IAN-CALLS-YOU>
	       <TELL ".\"" CR>)
	      (T
	       <TELL ", ">
	       <COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
	       <TELL "\"" CR>)>)>>

<GLOBAL JACK-THINKS-GLADYS
"\"Dashed if I'm going to have my digestion upset
by Gladys's whining, the odious little twit!">

<OBJECT JACK-TAPE
	;(IN LOCAL-GLOBALS)
	(DESC "secret tape recorder" ;"instant camera")
	(ADJECTIVE SECRET TAPE JACK\'S HIS ;INSTANT)
	(SYNONYM TAPE RECORD EVIDENCE ;"CAMERA PHOTO")
	(GENERIC GENERIC-RECORDER)
	(FLAGS ;NDESCBIT SEENBIT SECRETBIT RMUNGBIT ;"evidence")
	(CHARACTER 2)	;"for this char"
	;(TEXT "If you played it, you'd hear Jack smothering Lionel to death!")
	;(SIZE 2)
	(ACTION JACK-TAPE-F)>

<ROUTINE JACK-TAPE-F ("AUX" P)
 <COND (<VERB? LAMP-ON LISTEN PLAY>
	<TELL
"First you hear Lionel: \"This " 'JACK-TAPE " should capture any sound in the "
'JACK-ROOM " when I run it. Testing, testing,...\"|
Then you hear Lionel tell
" 'LOVER " that he suspects Jack of coveting the inheritance and wanting to
kill him.|
After a pause, Jack tells Lionel, with a cold-blooded chuckle,
that his time has come. Then " ,LIONELS-VOICE " is urgent and muffled, as if
he's being smothered! He calls out, \"Jack! Stop!\" and then...
silence." CR>
	<SET P <FIRST? ,HERE>>
	<COND (<T? .P>
	       <FOUND-PASSAGES-REPEAT .P ,JACK-TAPE ,TOLD-ABOUT-EVID>)>
	<COND (<AND <IN? ,FRIEND ,HERE>
		    <NOT <==? ,CAPTOR ,FRIEND>>>
	       <THIS-IS-IT ,FRIEND>
	       <MOVE ,FRIEND ,TAMARA-ROOM>
	       <PUT ,FOLLOW-LOC ,FRIEND-C ,TAMARA-ROOM>
	       <COND (<EQUAL? ,FOLLOWER ,FRIEND ,LORD>
		      <SETG FOLLOWER 0>)>
	       <PUT <GT-O ,FRIEND> ,GOAL-ENABLE 0>
	       <PUTP ,FRIEND ,P?LDESC 7 ;"sobbing quietly">
	       <TELL
'FRIEND "'s eyes fill with tears, and she runs to her room." CR>)>
	<COND (<ZERO? ,EVIDENCE-FOUND>
	       <CONGRATS>)>
	<SETG EVIDENCE-FOUND ,JACK-TAPE>
	<COND (<T? ,CONFESSED>
	       <RTRUE>)
	      (<IN? ,LORD ,HERE>
	       <CONFESSION ,LORD>)
	      (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	       <SETG WINNER ,PLAYER>
	       <PERFORM ,V?ASK-ABOUT .P ,JACK-TAPE>)>
	<RTRUE>)>>

;<OBJECT LOVER-MISPELLED
	(DESC "Deirdre")
	(IN LIMBO ;LOCAL-GLOBALS)
	(SYNONYM DEIDRE DEIDRA DIERDRE DIEDRE)
	(ACTION LOVER-MISPELLED-F)
	(LDESC 0)
	(FLAGS OPENBIT PERSONBIT SEARCHBIT FEMALE NARTICLEBIT ;TOUCHBIT)
	(LINE 0)
	(CHARACTER 9)>

<OBJECT LOVER
	(DESC "Deirdre")
	(IN LIMBO ;LOCAL-GLOBALS)
	(ADJECTIVE BLOND BLONDE MS MISS
		 DEIRDRE DEE HALLAM WOMAN ;"for poss's")
	(SYNONYM DEIRDRE DEE HALLAM WOMAN)
	(ACTION LOVER-F)
	(DESCFCN LOVER-D)
	(LDESC 0)
	;(TEXT "She looks almost as lovely as her portrait.")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT FEMALE NARTICLEBIT ;TOUCHBIT)
	(LINE 0)
	(STATION A?DEE\'S)
	(CHARACTER 9)>

<ROUTINE LOVER-D ("OPTIONAL" (ARG <>))
	<DESCRIBE-PERSON ,LOVER>
	<RTRUE>>

<GLOBAL LOVER-SAID:FLAG <>>
<ROUTINE LOVER-F ("OPTIONAL" (ARG 0))
 <COND ;(<AND <IN? ,LOVER ,HERE>	;"never happens"
	     <OR <VERB? ALARM SHAKE>
		 <SPEAKING-VERB?>>
	     <DOBJ? LOVER>>
	;<COND (<NOT <GRAB-ATTENTION ,LOVER>> <RFATAL>)>
	<COND (<UNSNOOZE ,LOVER>
	       <RFATAL>)
	      (T <LOVER-SPEECH>)>)
       (<AND <IN? ,LOVER-PIC ,HERE>
	     <NOT <REMOTE-VERB?>>>
	<DO-INSTEAD-OF ,LOVER-PIC ,LOVER>
	<RTRUE>)
       (T <PERSON-F ,LOVER .ARG>)>>

<OBJECT DEB
	(DESC "Iris")
	(IN GREAT-HALL)
	(ADJECTIVE MS MISS
		 IRIS VANE WOMAN ;DEB ;"for poss's")
	(SYNONYM IRIS VANE WOMAN ;DEB)
	(ACTION DEB-F)
	(DESCFCN DEB-D)
	(LDESC 1 ;"dancing")
	(WEST "looking coy")
	(TEXT
"The girl is a stylish London deb type.
Her dark hair is cut boyishly short. Her height and figure would make
her a perfect high-fashion model.")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT FEMALE NARTICLEBIT NDESCBIT)
	(CAPACITY 40)
	(LINE 0)
	(CHARACTER 7)>

<ROUTINE DEB-D ("OPTIONAL" (ARG 0))
	<COND (T ;<OR <FSET? ,DEB ,TOUCHBIT>
		   <T? ,CLOCK-WAIT>>
	       <DESCRIBE-PERSON ,DEB>)>
	<RTRUE>>

<ROUTINE DEB-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<SETG FAWNING <>>
	<COND (<AND <EQUAL? ,AWAITING-REPLY ,DEB-C>
		    <VERB? YES NO>>
	       <ESTABLISH-GOAL ,DOCTOR ,HERE>
	       <PUTP ,DEB ,P?LDESC 0>
	       <PUTP ,DEB ,P?LINE 0>
	       <SETG AWAITING-REPLY <>>
	       <COND (<VERB? YES> <TELL "\"Splendid!\"" CR>)
		     (T <TELL "\"What a pity!\"" CR>)>)
	      (<NOT <GRAB-ATTENTION ,DEB>> <RFATAL>)
	      (<AND <VERB? DESCRIBE> <DOBJ? GHOST-NEW>>
	       <FSET ,GHOST-NEW ,PERSONBIT>
	       <TELL
"\"Well, it appeared to be a woman with " ,LONG-BLOND-HAIR " in a ">
	       <COND (<NOT<EQUAL? ,VARIATION,DOCTOR-C ;,DEALER-C ;,OFFICER-C>>
		      ;<EQUAL? ,VARIATION ,FRIEND-C ,PAINTER-C ,LORD-C>
		      <TELL "sleeveless, ">)>
	       <TELL
"silvery white gown. But if you're asking me, 'Was it really poor Dee?'
I'm just not sure. ">
	       <COND (<EQUAL? ,VARIATION ,FRIEND-C ,LORD-C>
		      <TELL
"I didn't see the face that well.
But I'd say the figure was average height, and moved in a very
feminine way, just as she did -- so it COULD have been her ghost.\"" CR>)
		     (<EQUAL? ,VARIATION ,PAINTER-C>
		      <TELL
"It seemed different from Dee in some way...\"|
She snaps her fingers, and her eyes brighten maliciously.
\"Now I know! The ghost was too tall! Definitely taller than she!\"" CR>)
		     (T
		      <TELL "It was ">
		      <COND ;(<EQUAL? ,VARIATION ,DEALER-C ,OFFICER-C>
			     <TELL "definitely taller than Dee, and">)
			    (T <TELL"about the right height, I suppose, but">)>
		      <TELL
" its gown, with long sleeves and a high neck, seemed different from
hers. It lacked her femininity. She was a very feminine woman, you know
-- almost seductive, as I'm sure Jack can testify. The ghost was just a
sexless spook, one might say.\"" CR>)>)
	      (<AND <VERB? FOLLOW>
		    <DOBJ? PLAYER>
		    <WILLING? ,DEB>>
	       <TELL "\"Ooo! I love an adventure, "FN"!\"" CR>
	       <NEW-FOLLOWER ,DEB>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,DEB>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WINNER-DEFAULT ,DEB>)>)
       (<SET OBJ <ASKING-ABOUT? ,DEB>>
	<COND (<NOT <GRAB-ATTENTION ,DEB .OBJ>>
	       <RFATAL>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,DEB-C>>>
		    ;<NOT <==? ,DEB ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
	       <TELL
"\"It was quite dramatic, really. One night I couldn't
sleep, so I got a poetic urge to go up on the " 'DECK " in the moonlight
and commune with my soul.\"|"
'DEB " goes on, \"As I started up the tower stairs, I saw this
figure in white coming 'round the curve of the stairway. My dear, I
absolutely FROZE! The ghost turned 'round and flitted
back up the stairs, and by the time I recovered, it was
gone!\"" CR>)
	      (<EQUAL? .OBJ ,TAMARA-EVIDENCE>
	       <TELL "\"My word! It looks as if someone dislikes me!\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,DEB .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,DEB .OBJ>)>)
       (<VERB? RUB KISS DANCE>
	<COND (<WILLING? ,DEB T>
	       <UNSNOOZE ,DEB>
	       <PUTP ,DEB ,P?LINE 0>
	       <PUTP ,DEB ,P?LDESC 0>
	       ;<COND (<EQUAL? ,AWAITING-REPLY ,DEB-C>
		      <QUEUE I-REPLY 0>)>
	       <TELL "\"Oooo">
	       <I-JUST-LOVE-IT>
	       <RTRUE>)>)
       (T <PERSON-F ,DEB .ARG>)>>

<ROUTINE WILLING? (PER "OPT" (KISS <>))
 <COND (<ZERO? .KISS>
	<COND (<L? ,BED-TIME ,PRESENT-TIME>
	       <RFALSE>)
	      (<QUEUED? ,I-TOUR>
	       <RFALSE>)
	      (<OR <EQUAL? ,HERE ,DINING-ROOM>
		   <QUEUED? ,I-DINNER-SIT> ;"not during dinner">
	       <RFALSE>)
	      (<EQUAL? .PER ,CONFESSED ,CAPTOR>
	       <RFALSE>)
	      (T <RTRUE>)>)
       (<EQUAL? .PER ,FRIEND>
	<COND (<NOT <EQUAL? ,VARIATION ,FRIEND-C>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<EQUAL? .PER ,BUTLER>
	<COND (<AND <VERB? EMPTY ;"UNPACK">
		    <NOT <==? ,HERE ,YOUR-ROOM>>>
	       <RFALSE>)
	      (<VERB? FOLLOW>
	       <RFALSE>)
	      (T <RTRUE>)>)
       (<T? ,GENDER-KNOWN>
	<COND (<==? .PER ,DEB>
	       <COND (<NOT <FSET? ,PLAYER ,FEMALE>>
		      <RTRUE>)
		     (T <RFALSE>)>)
	      (<==? .PER ,OFFICER>
	       <COND (<FSET? ,PLAYER ,FEMALE>
		      <RTRUE>)
		     (T <RFALSE>)>)
	      (T <RFALSE>)>)>>

<OBJECT OFFICER
	(DESC "Ian")
	(IN GREAT-HALL)
	(ADJECTIVE TALL BLOND ;LT MR MISTER
		 IAN FORDYCE OFFICE MAN ;"for poss's")
	(SYNONYM IAN FORDYCE OFFICE MAN)
	(ACTION OFFICER-F)
	(DESCFCN OFFICER-D)
	(LDESC 1 ;"dancing")
	(WEST "looking debonair")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT NARTICLEBIT ;TOUCHBIT)
	(CAPACITY 40)
	(LINE 0)
	(CHARACTER 5)>

<ROUTINE OFFICER-D ("OPTIONAL" (ARG 0))
	<COND (<FSET? ,OFFICER ,TOUCHBIT>
	       <DESCRIBE-PERSON ,OFFICER>)
	      (T
	       <FSET ,OFFICER ,TOUCHBIT>
	       <FSET ,OFFICER ,SEENBIT>)>
	<RTRUE>>

<ROUTINE I-JUST-LOVE-IT ()
	<TELL "! I just love it when you do that, "FN"!\"" CR>>

<ROUTINE WINNER-DEFAULT (PER)
	<COND (<T? ,GENDER-KNOWN>
	       <TELL !\">
	       <COND (<T? ,FAWNING> <TELL "But ">)>
	       <TELL "I really can't help you with that">
	       <COND (<EQUAL? .PER ,OFFICER>
		      <IAN-CALLS-YOU>)>
	       <TELL ".\"" CR>)
	      (T <WHY-ME> <RFATAL>)>>

<ROUTINE OFFICER-F ("OPTIONAL" (ARG 0) "AUX" P OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<SETG FAWNING <>>
	<COND (<AND <EQUAL? ,AWAITING-REPLY ,OFFICER-1-R ,OFFICER-2-R>
		    <VERB? YES NO>>
	       <ESTABLISH-GOAL ,DOCTOR ,HERE>
	       <PUTP ,OFFICER ,P?LDESC 0>
	       <PUTP ,OFFICER ,P?LINE 0>
	       <TELL !\">
	       <COND (<VERB? YES>
		      <TELL "Jolly good">
		      <COND (<EQUAL? ,AWAITING-REPLY ,OFFICER-1-R>
			     <TELL "! You're certainly quick">)>)
		     (<EQUAL? ,AWAITING-REPLY ,OFFICER-1-R>
		      <TELL "I dare say you soon shall">)
		     (T <TELL "Pity">)>
	       <SETG AWAITING-REPLY <>>
	       <TELL "!\"" CR>
	       <RTRUE>)
	      (<NOT <GRAB-ATTENTION ,OFFICER>> <RFATAL>)
	      (<AND <VERB? DESCRIBE>
		    <DOBJ? GHOST-NEW>
		    <EQUAL? ,VARIATION ;,DEALER-C ,PAINTER-C>>
	       <TELL
"\"Ghosts don't turn off lights, to my way of thinking.
That alone makes me think our " 'GHOST-OLD "'s a fake. Somebody's sick idea
of a joke, perhaps. ">
	       <COND ;(<EQUAL? ,VARIATION ,DEALER-C>
		      <TELL
"Come to that, I'm not even sure it WAS a lady.
It was too tall for Dee, and there was nothing feminine about its gown,
which covered up everything but its face and hands. Just the sort of outfit
a bloke might wear with a blonde wig to go flitting about in drag.\""
CR>)
		     (T
		      <FSET ,GHOST-NEW ,PERSONBIT>
		      <TELL
"Otherwise, the masquerade was highly effective.
A female figure with " ,LONG-BLOND-HAIR ", wearing the same sort of gown
Dee was wearing that awful night she died -- at first
it left me breathless. The only flaw, I should say,
was the spook's height: too tall for Dee.\"" CR>)>)
	      (<AND <VERB? FOLLOW>
		    <DOBJ? PLAYER>
		    <WILLING? ,OFFICER>>
	       <TELL "\"What ho! A bit of sleuthing, eh, "FN"?\"" CR>
	       <NEW-FOLLOWER ,OFFICER>
	       <RTRUE>)
	      (<SET X <COM-CHECK ,OFFICER>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WINNER-DEFAULT ,OFFICER>)>)
       (<SET OBJ <ASKING-ABOUT? ,OFFICER>>
	<COND (<NOT <GRAB-ATTENTION ,OFFICER .OBJ>>
	       <RFATAL>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,OFFICER-C>>>
		    ;<NOT <==? ,OFFICER ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      ;(<AND <EQUAL? .OBJ ,JEWEL>
		    <EQUAL? ,VARIATION ,OFFICER-C>
		    <SET P <FIND-JEWEL-EXPLAINER>>>
	       <SETG EXPLAINED-JEWEL .P>
	       <TELL
"Suddenly" THE .P " exclaims, \"Why, Ian! Isn't this that " 'JEWEL "
you wear in one ear? I seem to recall you had it on at dinner just last
night!\"|
Fordyce looks startled and a trifle embarrassed. \"By jove, perhaps you're
right!\"|
He fingers his left ear lobe and appears surprised to discover that the
jewel is no longer there.|
\"Must have dropped off just a few minutes ago. I put it on when I dressed
for dinner. Thanks very much for finding it">
	       <IAN-CALLS-YOU>
	       <TELL ".\"" CR>)
	      (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	       <TELL
CHE ,OFFICER " grins, \"It's not mine. Her Majesty would hardly allow me
to serve in her Coldstream Guards were my vision faulty!\"" CR>)
	      (<AND <EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
		    <EQUAL? ,VARIATION ;,DEALER-C ,PAINTER-C>>
	       <TELL
"\"It was the last time I came down here to visit Jack. We had been up
late, playing cards in the " 'GAME-ROOM ". Then Jack toddled off to bed,
but I stayed up to read and finish my drink. I must have dozed off with
my glass in my hand, for I woke with a start as it crashed to the floor.
And the first thing I saw was this figure in white at the other end of
the room.\"|
He goes on, \"Blimey, I thought I was seeing things!
For a moment I just gaped at it. Then the spook went haring off
out the door, flicking off the light on the way.
By the time I found the door, it was gone.\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,OFFICER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,OFFICER .OBJ>)>)
       (<VERB? RUB KISS DANCE>
	<COND (<WILLING? ,OFFICER T>
	       <UNSNOOZE ,OFFICER>
	       <PUTP ,OFFICER ,P?LINE 0>
	       <PUTP ,OFFICER ,P?LDESC 0>
	       ;<COND (<EQUAL? ,AWAITING-REPLY ,OFFICER-1-R ,OFFICER-2-R>
		      <QUEUE I-REPLY 0>)>
	       <TELL"\"Hello">
	       <I-JUST-LOVE-IT>
	       <RTRUE>)>)
       (T <PERSON-F ,OFFICER .ARG>)>>

<ROUTINE IAN-CALLS-YOU ()
	<COND (<ZERO? <GETB ,LAST-NAME 0>>
	       <RFALSE>)>
	<TELL ", " FN>
	<COND (<NOT <ZERO? ,GENDER-KNOWN>>
	       <COND (<FSET? ,PLAYER ,FEMALE> <TELL " luv">)
		     (T
		      <TELL " old ">
		      <COND (<BTST ,PRESENT-TIME 1> <TELL "chap">)
			    (T <TELL "son">)>)>)>
	<RTRUE>>
[
<OBJECT DOCTOR
	(DESC "Dr. Wendish")
	(IN GALLERY ;STAIRS-NEW)
	(ADJECTIVE DR ;DOC
		 DOCTOR NICHOLAS WENDISH MAN ;"for poss's")
	(SYNONYM DOCTOR NICHOLAS WENDISH MAN) ;"DR here screws parsing"
	(ACTION DOCTOR-F)
	(DESCFCN DOCTOR-D)
	(LDESC 0)
	(WEST "looking muddled" ;"anxious")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT NARTICLEBIT ;RMUNGBIT)
	(CAPACITY 40)
	(LINE 0)
	(STATION A?DOC\'S)
	(CHARACTER 4)>

<ROUTINE DOCTOR-D ("OPTIONAL" (ARG 0))
 <COND ;(<OR <FSET? ,DOCTOR ,RMUNGBIT>
	    ;<T? ,CLOCK-WAIT>>
	<FCLEAR ,DOCTOR ,RMUNGBIT>
	<RTRUE>)
       (<FSET? ,DOCTOR ,TOUCHBIT>
	<DESCRIBE-PERSON ,DOCTOR>
	<RTRUE>)
       (T
	<FSET ,DOCTOR ,TOUCHBIT>
	;<COND (<EQUAL? <LOC ,FRIEND> ,HERE ,PSEUDO-OBJECT>
	       <SET P ,FRIEND>)
	      (T <SET P ,DEB>)>
	<COND (T ;<NOT <FSET? ,DOCTOR ,TOUCHBIT>>
	       ;<FSET ,DOCTOR ,TOUCHBIT>
	       <CRLF>
	       <COND (T ;<T? .P>
		      <TELL !\">
		      <COND (<T? ,TOUR-FORCED>
			     <TELL "Oh,">)
			    (T <TELL
"Do excuse me for interrupting,\" " D ,FRIEND ;.P " breaks in, \"but">)>
		      <TELL " here comes
" D ,DOCTOR "! I'm sure "FN" wants to meet such a distinguished
scientist!\"|">)
		     ;(T <TELL "Your conversation is interrupted. ">)>
	       <TELL "A man is coming downstairs. ">
	       <COMMON-DESC ,DOCTOR>
	       ;<TELL <GETP ,DOCTOR ,P?TEXT> CR>
	       <SETG QCONTEXT ,DOCTOR>
	       <THIS-IS-IT ,DOCTOR>
	       <PUTP ,DOCTOR ,P?LDESC 12 ;"listening to you">
	       <SETG AWAITING-REPLY ,DOCTOR-C>
	       <QUEUE I-REPLY ,CLOCKER-RUNNING>
	       <TELL
D ,FRIEND ;.P ,INTRODUCES "him as one of Lionel's
oldest friends, Dr. Nicholas Wendish.|
He's carelessly dressed in rumpled evening clothes, but his
hawk eyes peering at you through gold-rimmed specs show ruthless intelligence.|
\"I read about one of your mystery cases when I was in New York last year,
"TN",\" he probes. \"" <GET ,QUESTIONS ,AWAITING-REPLY> "\"|">)>
	<RFATAL>)>>

<ROUTINE DOCTOR-F ("OPTIONAL" (ARG 0) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<AND <EQUAL? ,AWAITING-REPLY ,DOCTOR-C>
		    <VERB? YES NO>>
	       <PUTP ,DOCTOR ,P?LDESC 0>
	       <PUTP ,DOCTOR ,P?LINE 0>
	       <SETG AWAITING-REPLY <>>
	       <TELL "\"I see...\"" CR>)
	      (<NOT <GRAB-ATTENTION ,DOCTOR>> <RFATAL>)
	      (<AND <VERB? DESCRIBE>
		    <DOBJ? GHOST-NEW>
		    <EQUAL? ,VARIATION ,DOCTOR-C ;,OFFICER-C>>
	       <TELL
'DOCTOR " shrugs, with a look of distaste, as if he'd like to forget
the episode. \"">
	       <COND (T ;<EQUAL? ,VARIATION ,DOCTOR-C>
		      <TELL "I'm afraid I can't tell you any more, ">
		      <COND (<TITLE-NAME> <TELL !\.>)>
		      <TELL
" I assumed the ghost was " 'LOVER ". It certainly looked like her: a blonde,
attractive young woman. If it WASN'T " 'LOVER ", it was a
convincing imposture.\"" CR>)
		     ;(T
		      <TELL "The truth is, ">
		      <TITLE-NAME>
		      <TELL
", I'm afraid I over-reacted. Once I'd collected myself and was able to
think normally, I had a strong feeling that I'd been the victim of a
vulgar hoax. Whomever I saw bore only a superficial resemblance to poor
" 'LOVER " Hallam. For one thing, it was definitely too tall. And aside
from the " ,LONG-BLOND-HAIR ", which could easily have been a wig, there
was really nothing very feminine about it. Judging by its posture and
movements, it could have been a man. Even its
gown was the kind a man would need to pass as a woman:
long sleeves and high neck.\"" CR>)>)
	      (<DIVESTMENT? ,MUSTACHE>
	       <COND (<EQUAL? ,VARIATION ,DOCTOR-C>
		      <TELL ,MUSTACHE-STORY>
		      <RTRUE>)
		     (T <HAR-HAR>)>)
	      (<SET X <COM-CHECK ,DOCTOR>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WHY-ME> <RFATAL>)>)
       (<SET OBJ <ASKING-ABOUT? ,DOCTOR>>
	<COND (<NOT <GRAB-ATTENTION ,DOCTOR .OBJ>>
	       <RFATAL>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,DOCTOR-C>>>
		    <NOT <==? ,DOCTOR ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<EQUAL? .OBJ ,COUSIN ,BUST ;,RECORDER>
	       <TELL "\"He loved me as a brother.\"" CR>)
	      (<AND <EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
		    <EQUAL? ,VARIATION ,DOCTOR-C ;,OFFICER-C>>
	       <TELL
"The doctor pauses, looking troubled, as if reluctant
to speak, or perhaps marshaling his thoughts.|
\"On the very night after " 'ACCIDENT ",\" he says at last,
\"I couldn't sleep. I suppose the tragedy was on my mind. That and the
medical cases I have in my London clinic for rare diseases. Anyhow, I
took a stroll out in the " 'COURTYARD ". The fresh sea breeze was very
soothing. When I went back inside, I felt ready for sleep. I went in
through the " 'OLD-GREAT-HALL ;"tower door" ", you see.\"|
He goes on, \"Then I saw this ghostly figure in white -- Good Lord, what
a shock it gave me! I couldn't move for a moment; I thought " 'LOVER "
had come back from the dead. As I stood there, staring, the ghost
flitted off toward the " 'BASEMENT "... I felt no impulse to go after
it, I might add.\"" CR>)
	      (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	       <TELL !\">
	       <COND (<AND <EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ,PAINTER-C>
			   <T? ,FOUND-IT-PERM>
			   ;<FSET? ,FOUND-IT-PERM ,SEENBIT>
			   ;<FSET? ,LENS ,TOUCHBIT>>
		      <TELL "Not mine. ">)>
	       <TELL
"As you see, I wear glasses at all times,\" he says." CR>)
	      (<AND <EQUAL? .OBJ ,MUSTACHE>
		    <EQUAL? ,VARIATION ,DOCTOR-C>>
	       <TELL ,MUSTACHE-STORY>
	       <RTRUE>)
	      (<EQUAL? .OBJ ,WENDISH-STUFF>
	       <TELL "\"I always bring them along.\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,DOCTOR .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,DOCTOR .OBJ>)>)
       (T <PERSON-F ,DOCTOR .ARG>)>>

<OBJECT MUSTACHE
	(DESC "Wendish's mustache")
	(IN DOCTOR)
	(ADJECTIVE DOC\'S HIS)
	(SYNONYM MUSTACHE)
	(FLAGS NDESCBIT TRYTAKEBIT NARTICLEBIT)
	(ACTION MUSTACHE-F)>

<ROUTINE MUSTACHE-F ()
 <COND (<AND <OR <VERB? ASK-FOR MOVE TAKE>
		 <DIVESTMENT? ,MUSTACHE>>
	     <IN? ,MUSTACHE ,DOCTOR>>
	<COND (<FSET? ,DOCTOR ,MUNGBIT>
	       <COND (<EQUAL? ,VARIATION ,DOCTOR-C>
		      <FSET ,MUSTACHE ,TAKEBIT>
		      <FCLEAR ,MUSTACHE ,TRYTAKEBIT>)>
	       <RFALSE>)
	      (<OR <NOT <EQUAL? ,VARIATION ,DOCTOR-C>>
		   <FSET? ,MUSTACHE ,TOUCHBIT>>
	       <FACE-RED ,DOCTOR>
	       <RTRUE>)
	      (T
	       <FSET ,MUSTACHE ,TOUCHBIT>
	       <TELL
"It comes off, leaving " 'DOCTOR " blinking with embarrassment.
He grabs it and puts it in place again. " ,MUSTACHE-STORY>
	       <RTRUE>)>)
       (<OR <VERB? WEAR>
	    <AND <VERB? PUT> <FSET? ,PRSI ,PERSONBIT>>>
	<WEAR-SCARE>)>>

<GLOBAL MUSTACHE-STORY
"\"Dear me,\" he giggles nervously, \"I'm afraid you've found out my little
secret! A lady friend, you see, begged me to shave off my mustache.
I did so just before coming to Cornwall. But then I felt so naked without
it, that I bought a hair piece until I could grow back my own.\"|">

<OBJECT WENDISH-BOOK
	(DESC "lab notebook")
	(ADJECTIVE DOC\'S HIS NOTE LAB LABORATORY)
	(SYNONYM NOTEBOOK BOOK BOOKS EVIDENCE ;TEXT)
	(GENERIC GENERIC-BOOK)
	(FLAGS READBIT CONTBIT NDESCBIT SECRETBIT RMUNGBIT ;"evidence")
	(CHARACTER 4)	;"for this char"
	(CAPACITY 4)
	(ACTION WENDISH-BOOK-F)>

<ROUTINE WENDISH-BOOK-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<TELL
"The " 'WENDISH-BOOK " contains an incriminating record of " 'DOCTOR "'s
fiendish experiments on patients at his clinic. Near the end you
read:|
\"Finally took care of Poldark's granddau. (comely wench), pity
she disc'd facts of his end.\"">
	;<TELL
" that he \"took care of\" " 'LOVER " after she discovered his fatal
mistreatment of her grandfather.">
	<CRLF>
	<COND (<ZERO? ,EVIDENCE-FOUND>
	       <CONGRATS>)>
	<SETG EVIDENCE-FOUND ,WENDISH-BOOK>)>>
]
<OBJECT DEALER
	(DESC "Hyde")
	(IN DRAWING-ROOM)
	(ADJECTIVE TALL ART MR MISTER
		 MONTAGUE ;MONTY HYDE DEALER MAN ;"for poss's")
	(SYNONYM MONTAGUE ;MONTY HYDE DEALER MAN)
	(ACTION DEALER-F)
	(DESCFCN DEALER-D)
	(LDESC 2 ;"sipping sherry")
	(WEST "examining objects")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT NARTICLEBIT NDESCBIT)
	(CAPACITY 40)
	(LINE 0)
	(CHARACTER 6)>

<ROUTINE DEALER-D ("OPTIONAL" (ARG 0) "AUX" PER)
	<COND (T ;<FSET? ,DEALER ,TOUCHBIT>
	       <DESCRIBE-PERSON ,DEALER>)>
	;<THIS-IS-IT ,PAINTER>
	;<THIS-IS-IT ,DEALER>
	<RTRUE>>

<ROUTINE DEALER-F ("OPTIONAL" (ARG 0) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,DEALER>> <RFATAL>)
	      (<AND <VERB? DESCRIBE> 
		    <DOBJ? GHOST-NEW>
		    <NOT <EQUAL? ,VARIATION ,PAINTER-C ;,OFFICER-C>>>
	       <TELL
"\"You're wondering, I presume, if it really was " 'LOVER " Hallam's
ghost? Frankly, I don't put stock in ghosts, but my answer is... ">
	       <FSET ,GHOST-NEW ,PERSONBIT>
	       <COND (<EQUAL? ,VARIATION
			      ;,DEALER-C ,FRIEND-C ,PAINTER-C ,LORD-C>
		      <TELL
"possibly. That's as far as I'd go.
It was certainly a female figure, in a shimmering whitish gown,
sleeveless and cut low. She had " ,LONG-BLOND-HAIR " like "
'LOVER "'s and was about her size. But as for her face -- my
view was too brief,\" Hyde shrugs." CR>)
		     (T <TELL
"I'm not at all convinced. Somehow it didn't match
my memories of " 'LOVER ".
For one thing, the gown wasn't her style, at all. Her clothes were
always quite revealing. The ghost seemed quite covered up
at the throat and arms. You might say it totally lacked
feminine sex appeal.\"" CR>)>)
	      (<SET X <COM-CHECK ,DEALER>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WHY-ME> <RFATAL>)>)
       (<SET OBJ <ASKING-ABOUT? ,DEALER>>
	<COND (<NOT <GRAB-ATTENTION ,DEALER .OBJ>>
	       <RFATAL>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,DEALER-C>>>
		    ;<NOT <==? ,DEALER ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<AND <EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
		    <NOT <EQUAL? ,VARIATION ,PAINTER-C ;,OFFICER-C>>>
	       <TELL
"\"I came down late one night to get a book that I'd left in the "
'SITTING-ROOM ". I had just turned 'round to go back upstairs when I saw
a ghostly figure in the doorway. It fled as soon as I noticed it, in the
" D ,INTDIR " of the tower.\"|
He goes on, \"I was stunned, I must admit, so I dare say it took me a
moment to collect my wits and go after it. I ran into the tower, but the
spectre had vanished. This happened, by the way, a couple of weeks ago, on
my last visit to the castle.\"" CR>)
	      (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	       <TELL
CHE ,DEALER " displays his monocle, saying, \"This is the only vision
aid I require.\"" CR>)
	      (<OR <EQUAL? .OBJ ,ARMOR ,BUST ;,CARTOON>
		   <EQUAL? .OBJ ,FIGURINE ,LOVER-PIC ,OIL-PAINTING>
		   <EQUAL? .OBJ ,PAINTING-GALLERY ,WRITING-DESK>>
	       <TELL "\"I haven't formed my professional opinion as yet.\""CR>)
	      (<SET X <COMMON-ASK-ABOUT ,DEALER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,DEALER .OBJ>)>)
       (T <PERSON-F ,DEALER .ARG>)>>

<OBJECT PAINTER
	(DESC "Vivien")
	(IN DRAWING-ROOM)
	(ADJECTIVE TALL MS MISS MRS
		 VIVIEN VIV PENTREATH WOMAN ;"for poss's")
	(SYNONYM VIVIEN VIV PENTREATH WOMAN)
	(ACTION PAINTER-F)
	(DESCFCN PAINTER-D)
	(LDESC 2 ;"sipping sherry")
	(WEST "studying colors")
	(TEXT
"She is a tall, tawny-haired woman of vintage beauty and uncertain age.")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT FEMALE NARTICLEBIT ;TOUCHBIT)
	(CAPACITY 40)
	(LINE 0)
	(STATION A?VIV\'S)
	(CHARACTER 3)>

<ROUTINE PAINTER-D ("OPTIONAL" (ARG 0))
	<COND (<FSET? ,PAINTER ,TOUCHBIT>
	       <DESCRIBE-PERSON ,PAINTER>)
	      (T
	       <FSET ,PAINTER ,TOUCHBIT>
	       <FCLEAR ,DEALER ,NDESCBIT>
	       <COND (<AND <EQUAL? <LOC ,DEALER> ,HERE ,PSEUDO-OBJECT>
			   <=? <GETP ,DEALER ,P?LDESC> 2>>
		      <RFALSE>)>)>
	<RTRUE>>

<GLOBAL GLASSES-FOR " glasses for closeup art work">

<ROUTINE PAINTER-F ("OPTIONAL" (ARG 0) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,PAINTER>> <RFATAL>)
	      (<AND <VERB? DESCRIBE>
		    <DOBJ? GHOST-NEW>
		    <EQUAL? ,VARIATION ,PAINTER-C ;,OFFICER-C>>
	       <FSET ,GHOST-NEW ,PERSONBIT>
	       <COND (T ;<EQUAL? ,VARIATION ,PAINTER-C>
		      <TELL
"\"It was " 'LOVER ", or her ghost. What more can I say? A female
figure, her size, wearing the same sort of shimmering white gown she had
on the night she died -- and unmistakably her face! The likeness was
heart-stopping...\"|
Vivien chokes up for a moment, then dabs her eyes. \"I'm sorry. I
shouldn't let my feelings take over this way, but " 'LOVER " was such a
lovely person!\"" CR>)
		     ;(T <TELL
"\"Well, it was a figure with a white gown and " ,LONG-BLOND-HAIR ". But
other than that, there was nothing very feminine about it. And it was
taller than " 'LOVER ". I admit I didn't get a good look at its face,
because it was dark and far away. All I can say is, if someone was
posing as " 'LOVER "'s ghost, he or she didn't convince me.\"" CR>)>)
	      (<SET X <COM-CHECK ,PAINTER>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WHY-ME> <RFATAL>)>)
       (<SET OBJ <ASKING-ABOUT? ,PAINTER>>
	<COND (<NOT <GRAB-ATTENTION ,PAINTER .OBJ>>
	       <RFATAL>)
	      (<EQUAL? .OBJ ,BUST ,FIGURINE ;,LOVER-PIC>
	       <TELL "\"Yes, that's one of my works.\"" CR>)
	      ;(<EQUAL? .OBJ ,CARTOON>
	       <TELL "\"I don't recall who drew that.\"" CR>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,PAINTER-C>>>
		    <NOT <==? ,PAINTER ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<AND <EQUAL? .OBJ ,FRIEND>
		    <EQUAL? ,VARIATION ,PAINTER-C>
		    ;<T? ,CONFESSED>>
	       ;<DISCRETION ,PAINTER .OBJ>
	       <TELL ,RHYMES-WITH-RICH CR>)
	      (<AND <EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
		    <EQUAL? ,VARIATION ,PAINTER-C ;,OFFICER-C>>
	       <TELL
CHE ,PAINTER " is somber as she replies, \"I dare say it was morbid of
me, but one night I went to the " 'BASEMENT ", just to try to imagine
the horrible scene when poor " 'LOVER " suffered her... tragic accident.
Suddenly I heard someone calling my name softly. I turned 'round, and
there was " 'LOVER " herself standing by the stairs">
	       <COND (T ;<EQUAL? ,VARIATION ,PAINTER-C>
		      <TELL
"! I went absolutely numb! She smiled faintly, then fled up the stairs.
I started to follow, but then I knew it was no use. " 'LOVER " is dead
and gone, and chasing her ghost won't bring her back to me!\"" CR>)
		     ;(T <TELL
". Or so I thought at first. But then I realized it WASN'T " 'LOVER ",
that it COULDN'T be she.
My disbelief must have been obvious. The imposter suddenly turned and fled.
And that was the last I saw of it.\"" CR>)>)
	      (<AND <EQUAL? .OBJ ,CLUE-2>
		    <EQUAL? ,VARIATION ,LORD-C>
		    <NOT <IN? .OBJ ,PAINTER>>>
	       <CLUE-2-STORY ,PAINTER>
	       <RTRUE>)
	      (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	       <TELL CHE ,PAINTER>
	       <COND (<EQUAL? ,VARIATION ,PAINTER-C>
		      <TELL
" says she wears" ,GLASSES-FOR ", as everyone
knows; then she shudders, \"But " 'LENS "es -- ugh! --
I could never tolerate them!\"" CR>)
		     (T
		      <TELL
" admits to wearing " 'LENS "es at all times, and" ,GLASSES-FOR>
		      <COND (<AND <EQUAL? ,VARIATION
					  ,DOCTOR-C ;,DEALER-C ,PAINTER-C>
				  <T? ,FOUND-IT-PERM>
				  ;<FSET? ,FOUND-IT-PERM ,SEENBIT>
				  ;<FSET? ,LENS ,TOUCHBIT>>
			     <TELL
", but she says the lens you found isn't hers.
With a cynical smile, she pops out both lenses, one at a time, to show you."
;"-- and murmurs, \"Satisfied?\"" CR>)
			    (T <TELL "." CR>)>)>)
	      (<EQUAL? .OBJ ,LOVER>
	       <PUTP ,PAINTER ,P?LDESC 7 ;"sobbing quietly">
	       <TELL
"The artist shrugs with a sad, wistful smile. \"What can I say?
" 'LOVER " was a most unusual girl... utterly unworldly... almost fey.
She grew up in a cottage not far from here, you know. Her drowning was
a terrible tragedy... and yet... sometimes I'm not sure she WANTED
to go on living.\" She turns her face away to hide a tear."
;"You feel Vivien knows much more about  'LOVER , but she's too discreet
to tell." CR>)
	      (<EQUAL? .OBJ ,LOVER-PIC>
	       <TELL
"\"Oh, you mean my portrait of dear " 'LOVER ". I don't believe I ever saw
such skin as hers... or such hair.\" She stops speaking and bites her lip."
CR>)
	      (<EQUAL? .OBJ ,OIL-PAINTING>
	       <TELL "\"I don't admire the heroic style at all.\"" CR>)
	      (<EQUAL? .OBJ ;,VIVIEN-DIARY ;"pass to I-SHOT" ,VIVIEN-STUFF>
	       <TELL
"\"That's private property. It's no business of yours.\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,PAINTER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <TELL-DUNNO ,PAINTER .OBJ>)>)
       (<AND <VERB? KISS>
	     <==? <GETP ,PAINTER ,P?LDESC> 7 ;"sobbing quietly">>
	<PUTP ,PAINTER ,P?LINE 0>
	<TELL "\"You're sweet.\"" CR>)
       (T <PERSON-F ,PAINTER .ARG>)>>

<OBJECT VIVIEN-DIARY
	(DESC "Vivien's diary")
	(ADJECTIVE VIV\'S HER ;VIVIEN)
	(SYNONYM EVIDENCE DIARY BOOK BOOKS)
	(GENERIC GENERIC-BOOK)
	(FLAGS TAKEBIT NARTICLEBIT READBIT CONTBIT SECRETBIT RMUNGBIT ;"evidence")
	(CHARACTER 3)	;"for this char"
	(CAPACITY 4)
	(ACTION VIVIEN-DIARY-F)>

<ROUTINE VIVIEN-DIARY-F ()
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN READ>
	<COND (<NOT-HOLDING? ,PRSO>
	       <RTRUE>)>
	<TELL
'VIVIEN-DIARY " falls open to a tear-stained page, and you read:|
\"O " 'LOVER ", sweet " 'LOVER "! Jack will pay dearly
for your cruel death by losing his new sweetheart...\"" CR>
	;<TELL
'VIVIEN-DIARY " reveals her intense attachment to " 'LOVER ", her
obsessive belief that " 'LORD " drove " 'LOVER " to suicide, and her
plot for revenge." CR>
	<COND (<ZERO? ,EVIDENCE-FOUND>
	       <CONGRATS>)>
	<SETG EVIDENCE-FOUND ,VIVIEN-DIARY>)>>

<OBJECT COUSIN
	(DESC "Lionel Tresyllian")
	(IN GLOBAL-OBJECTS ;"LOCAL-GLOBALS produces [Which Lionel ...]")
	(ADJECTIVE JACK\'S HIS
		 LIONEL ;TRESYLLIAN UNCLE ;"for poss's")
	(SYNONYM LIONEL ;TRESYLLIAN UNCLE)
	(FLAGS PERSONBIT NARTICLEBIT NDESCBIT)
	(CHARACTER 11)
	(ACTION COUSIN-F)>

<ROUTINE COUSIN-F ()
 <COND (<AND <EQUAL? ,HERE ,DINING-ROOM>
	     <NOT <REMOTE-VERB?>>>
	<DO-INSTEAD-OF ,BUST ,COUSIN>
	<RTRUE>)>>
[
<OBJECT BUTLER
	(DESC "Bolitho")
	(IN CORR-1 ;KITCHEN)
	(ADJECTIVE WHITE
		 BOLITHO BUTLER MAN ;"for poss's")
	(SYNONYM BOLITHO BUTLER MAN)
	(ACTION BUTLER-F)
	(DESCFCN BUTLER-D)
	(LDESC 0)
	(WEST "awaiting orders")
	(TEXT
"He's a short white-haired gentle man, impeccably dressed tonight in
white gloves and tails.")
	(FLAGS OPENBIT PERSONBIT SEARCHBIT NARTICLEBIT NDESCBIT)
	(CAPACITY 40)
	(LINE 0)
	(CHARACTER 8)>

<ROUTINE BOLITHO-WILL ()
	<TELL !\  'BUTLER " will see to the car and bring " 'LUGGAGE>>

<ROUTINE BUTLER-D ("OPTIONAL" (ARG <>) "AUX" GT (SAID <>) (LL <>) L)
	<COND (<FSET? ,BUTLER ,TOUCHBIT>
	       <DESCRIBE-PERSON ,BUTLER>
	       <RTRUE>)>
	<FCLEAR ,BUTLER ,NDESCBIT>
	<FSET ,BUTLER ,TOUCHBIT>
	<COND (<AND <EQUAL? ,HERE ,COURTYARD ,FOYER>
		    <EQUAL? <LOC ,LORD> ,HERE ,PSEUDO-OBJECT>
		    <ZERO? <GETP ,LORD ,P?LINE>>>
	       <SET LL T>)>
	<COND (<AND <EQUAL? ,HERE ,COURTYARD ,FOYER>
		    <EQUAL? <LOC ,FRIEND> ,HERE ,PSEUDO-OBJECT>>
	       <SET SAID T>
	       <TELL
"|
\"We can talk more later, "FN",\" says " 'FRIEND ", taking your arm,
\"but let's go in now, so you can meet the other guests.">)>
	<COND (.LL
	       <COND (.SAID
		      <TELL !\" CR "\"Yes, d">)
		     (T
		      <SET SAID T>
		      <TELL "\"D">)>
	       <TELL "o come in.">
	       <BOLITHO-WILL>
	       <TELL ",\" says " 'LORD " as a">)
	      (.SAID
	       <BOLITHO-WILL>
	       <TELL ".\"" CR !\A>)
	      (T <TELL !\A>)>
	<THIS-IS-IT ,BUTLER>
	<TELL "n elderly butler appears.">
	<COND (<ZERO? .SAID>
	       <TELL " He bows slightly to you.">)>
	<SET GT <GT-O ,BUTLER>>
	<COND ;(<NOT <EQUAL? <GET .GT ,GOAL-FUNCTION>
			    ,BUTLER-FETCHES ,BUTLER-CARRIES>>
	       T)
	      (<AND <NOT <EQUAL? <SET L <META-LOC ,LUGGAGE>>
				 ,YOUR-ROOM ,YOUR-BATHROOM>>
		    <T? <GETP .L ,P?LINE>>>
	       <COND (<IN? ,LUGGAGE ,BUTLER>
		      <TELL " He has " D ,LUGGAGE ".">)
		     (<==? <LOC ,BUTLER> .L>
		      <PUT .GT ,GOAL-FUNCTION ,BUTLER-CARRIES>
		      <ESTABLISH-GOAL ,BUTLER ,YOUR-ROOM>
		      <FCLEAR ,LUGGAGE ,OPENBIT>
		      <MOVE ,LUGGAGE ,BUTLER>
		      <TELL " He takes " D ,LUGGAGE ".">)
		     (T
		      <PUT .GT ,GOAL-FUNCTION ,BUTLER-FETCHES>
		      <ESTABLISH-GOAL ,BUTLER .L>)>
	       <COND (<ZERO? .SAID>
		      <TELL
" \"I'll carry " D ,LUGGAGE " to " 'YOUR-ROOM ".\"">)>)>
	<CRLF>
	<RFATAL>>

<GLOBAL FOUND-FABRIC
" discovered a strand of fabric from her gown, snagged on a jagged bit
of brickwork.">

<ROUTINE BUTLER-SORRY ()
	;<TELL "\"I'm afraid I can't do that now, ">
	<TELL "\"Sorry, but I have duties to perform, ">
	<COND (<TITLE-NAME> <TELL !\.>)>
	<TELL "\"" CR>>

<ROUTINE BUTLER-F ("OPTIONAL" (ARG <>) "AUX" OBJ X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<AND <OR <EQUAL? ,AWAITING-REPLY ,BUTLER-1-R ,BUTLER-2-R>
			<EQUAL? ,AWAITING-REPLY ,BUTLER-3-R ,BUTLER-4-R>>
		    <VERB? YES NO>>
	       <PUTP ,BUTLER ,P?LDESC 0>
	       <PUTP ,BUTLER ,P?LINE 0>
	       <COND (<EQUAL? ,AWAITING-REPLY ,BUTLER-1-R>
		      <SETG AWAITING-REPLY <>>
		      <COND (<VERB? YES>
			     <ROB ,LUGGAGE ,CHEST-OF-DRAWERS>)>
		      <TELL
'BUTLER " responds politely, like the well-trained butler he is. But he
seems to have something important on his mind." CR>)
		     (<EQUAL? ,AWAITING-REPLY ,BUTLER-2-R>
		      <SETG AWAITING-REPLY <>>
		      <COND (<NOT <VERB? YES>>
			     <TELL "\"Oh!... Please pardon me.\"" CR>)
			    (T
			     <TELL
"\"Then no doubt you are here to investigate the spectral figure which
has recently been seen about the castle.">
			     <COND (<ZERO? ,BUTLER-GHOST-STORY-TOLD>
				    <TELL !\ >
				    <BUTLER-GHOST-STORY>)
				   (T <TELL "\"" CR>)>)>)
		     (<EQUAL? ,AWAITING-REPLY ,BUTLER-3-R>
		      <SETG AWAITING-REPLY <>>
		      <COND (<VERB? YES>
			     <MOVE ,MACE ,PLAYER>
			     <FSET ,MACE ,SEENBIT>
			     <FCLEAR ,MACE ,NDESCBIT>
			     <THIS-IS-IT ,MACE>
			     <TELL
"\"Should you find " 'PLAYER " in any danger from our " 'GHOST-NEW ",
perhaps you could use this.\"|
" 'BUTLER " gives you a small " D ,MACE ".||">)
			    (T <TELL "\"As you wish,\" he sniffs." CR>)>)
		     (T ;<EQUAL? ,AWAITING-REPLY ,BUTLER-4-R>
		      <SETG AWAITING-REPLY <>>
		      <COND (<NOT <VERB? YES>>
			     <TELL "\"No doubt you soon shall. ">)
			    (T <TELL !\">)>
		      <COND (<EQUAL? ,VARIATION ,LORD-C ,FRIEND-C ;,OFFICER-C>
			     <TELL
"To be precise, the ghost was just beyond the archway. It was bending
over, groping for something on the " 'DRAWING-ROOM " carpet.">)
			    (T
			     <TELL
"If I may express an opinion, our " 'GHOST-NEW " must need reading
glasses. The hall was ablaze with lights, yet it was bending down,
groping blindly for something on the marble floor.">
			     <COND (<EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C>
				    <TELL
" And, I might add, it must also be left-handed. You see, "TN", while
bending over, the figure was using its left hand to grope with. I tried
it myself, as did other servants, and we agree that such behavior
indicates left-handedness.">)>)>
		      <COND (T ;<NOT <EQUAL? ,VARIATION ,DEALER-C>>
			     <TELL "\"|
He continues, \"The ghost must have heard my footsteps, for">)
			    ;(T <TELL
"To be frank, "TN", I was quite taken aback when I saw the ghost.
I'm afraid I just stood there for a moment, gaping at it stupidly.
Then when it found whatever it was looking for,">)>
		      <TELL
" it stood up, flashed me a startled glance, and fled into the darkness
of the " 'DRAWING-ROOM ". I pursued, turning on the lights, but the
thing had disappeared. I went into the foyer, but it was not there
either, and the " 'FRONT-DOOR " was still locked -- from the inside.\"" CR>)>
	       <RTRUE>)
	      (<NOT <GRAB-ATTENTION ,BUTLER>> <RFATAL>)
	      (<AND <VERB? DESCRIBE> <DOBJ? GHOST-NEW>>
	       <FSET ,GHOST-NEW ,PERSONBIT>
	       <TELL
"\"Frankly, I found it unconvincing. I don't see why a ghost would grope
about on the floor to find something -- especially in a spot that wasn't
even built when the " 'GHOST-OLD " was walled up in the tower. Besides,
why should a ghost be scared away by a human being? It's usually the
opposite, is it not?... No, "TN", in my opinion that figure just didn't
behave like a proper ghost. It had " ,LONG-BLOND-HAIR " and was clad in
a silvery-white ">
	       <COND (<EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ;,OFFICER-C>
		      <TELL "long-sleeved">)
		     (T <TELL "sleeveless">)>
	       <TELL " gown.
I caught only a brief glimpse of its face, deadly white.
As to height, it was too bent over for me to make out.
If someone was masquerading as a ghost, of course, the imposter
might well have been a man. However, as for the figure I saw -- ">
	       <COND (<EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ;,OFFICER-C>
		      <TELL "I cannot be sure of its sex.\"" CR>)
		     (T <TELL "it seemed to me quite feminine.\"" CR>)>)
	      (<AND <VERB? CLOSE DISEMBARK EMPTY LEAVE OPEN SIT SIT-AT STAND
		      THROUGH WALK WALK-TO>
		    <WILLING? ,BUTLER>>
	       <COND (<AND <NOT <VERB? LEAVE>>
			   <OR <NOT <VERB? THROUGH WALK-TO>>
			       <NOT <DOBJ? DINNER PASSAGE>>>>
		      <TELL "\"As you wish, ">
		      <COND (<TITLE-NAME> <TELL !\.>)>
		      <TELL "\"|">)>
	       <RFALSE>)
	      ;(<VERB? WALK-TO>
	       <COND (<DOBJ? HERE GLOBAL-HERE>
		      <TELL "\"I am here, "TN"!\"" CR>)>)
	      (<SET X <COM-CHECK ,BUTLER>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T
	       <BUTLER-SORRY>
	       <RFATAL>)>)
       (<SET OBJ <ASKING-ABOUT? ,BUTLER>>
	<COND ;(<T? <GET <GET ,GOAL-TABLES ,BUTLER-C> ,GOAL-S>>
	       <BUTLER-SORRY>
	       <RFATAL>)
	      (<NOT <GRAB-ATTENTION ,BUTLER .OBJ>>
	       <RFATAL>)
	      (<EQUAL? .OBJ ,ACCIDENT ,LOVER>
	       <TELL
"\"Perhaps you've heard how I was sent to the " 'BASEMENT " to find her.
I found a tent pole and a shoe in front of the well, near one end of the
" 'WINE-RACK ". The pole belonged to Lord Lionel. The shoe's spike heel
was wrenched loose. I knew at once there had been an accident.
Apparently Miss " 'LOVER ", in her cups, had stumbled over the pole and
grabbed at the well for support. But as she was nowhere in sight, and
her red necklace was lying beside the well, I assumed she had toppled
down the well. When " 'LORD " arrived, he shone an electric torch down
the well and" ,FOUND-FABRIC " Evidently it was ripped off as
she fell. At any rate, the police concluded that she had drowned. They
lowered a diver into the well, but " 'CORPSE " was never found.\"" CR>)
	      (<EQUAL? .OBJ ,BUTLER>
	       <TELL
"\"There's not much to tell. I've served the family all my life.
Should you require anything, feel free to ask.\"" CR>)
	      (<AND <EQUAL? .OBJ ,SEARCHER>
		    <OR <T? ,CONFESSED>
			<T? <GET ,TOLD-ABOUT-EVID ,BUTLER-C>>>
		    ;<NOT <==? ,BUTLER ,SEARCHER>>>
	       <TELL ,IM-SHOCKED>)
	      (<EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
	       <TELL !\">
	       <BUTLER-GHOST-STORY>)
	      (<EQUAL? .OBJ ,GHOST-OLD>
	       <TELL
"\"They do say " 'CASTLE " is haunted.\"" ;"in the past, before that, er,
unfortunate lady's bones were exhumed and reburied.\"" CR>)
	      (<EQUAL? .OBJ ,LAMP>
	       <TELL "\"Yes, we keep">
	       <IN-CASE-OF-BLACKOUT>
	       <RTRUE>)
	      (<EQUAL? .OBJ ,YOUR-MIRROR ,DRESSING-MIRROR>
	       <TELL "\"S">
	       <BUTLER-MIRROR-STORY>)
	      (<OR <EQUAL? .OBJ ,PRIEST-DOOR>
		   <AND <EQUAL? .OBJ ,PASSAGE>
			<ZERO? <GET ,FOUND-PASSAGES ,BUTLER-C>>>>
	       <TELL
"The butler hesitates, looking thoughtful.
\"I daresay that sort of thing would be better known to his lordship
than to any of the staff, "TN".\"" CR>)
	      (<SET X <COMMON-ASK-ABOUT ,BUTLER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T
	       <TELL "\"I'm afraid it's not my place to say, ">
	       <COND (<TITLE-NAME> <TELL !\.>)>
	       <TELL "\"" CR>)>)
       (T <PERSON-F ,BUTLER .ARG>)>>

<ROUTINE IN-CASE-OF-BLACKOUT ()
	<TELL " that in case of a power outage.\"" CR>>

<GLOBAL BUTLER-GHOST-STORY-TOLD:FLAG <>>
<ROUTINE BUTLER-GHOST-STORY ()
	<SETG BUTLER-GHOST-STORY-TOLD T>
	<SETG QCONTEXT ,BUTLER>
	<THIS-IS-IT ,BUTLER>
	<PUTP ,BUTLER ,P?LDESC 12 ;"listening to you">
	<SETG AWAITING-REPLY ,BUTLER-4-R>
	<SETG CLOCK-WAIT T>
	<COND (<==? ,HERE ,GREAT-HALL>
	       <PUT ,QUESTIONS ,AWAITING-REPLY "Can you see where I mean?">)>
	<TELL
"I myself glimpsed the ghost just last night. " 'LORD " and some guests
were sitting up late, " <GET ,LDESC-STRINGS 13> ;"lounging and chatting"
" in the " 'GREAT-HALL ".
After they retired, I came upstairs to clean up and turn off the lights.
As I entered the " 'GREAT-HALL " from the west, I saw the ghost on the
far side of the room. " <GET ,QUESTIONS ,AWAITING-REPLY> "\"" CR>
	<RFATAL>>

<ROUTINE BUTLER-MIRROR-STORY ()
	<TELL
"hould you wish to view " 'PLAYER " from all angles while dressing,
you can do so by adjusting the " 'YOUR-MIRROR " and the hinged "
'DRESSING-MIRROR " of the " 'DRESSING-TABLE ".\"" CR>>
]
<OBJECT MAID
	(DESC "upstairs maid")
	(IN LOCAL-GLOBALS)
	(ADJECTIVE UPSTAIRS
		 GLADYS MAID ;"for poss's")
	(SYNONYM GLADYS MAID)
	(FLAGS PERSONBIT FEMALE SEENBIT VOWELBIT)
	;(LDESC 0)
	(CHARACTER 12)>

<OBJECT GHOST-OLD
	(DESC "White Lady" ;"old ghost spirit")
	(IN LOCAL-GLOBALS)
	(ADJECTIVE OLD ;ORIGINAL WHITE)
	(SYNONYM SPIRIT PHANTOM LADY LEGEND ;WIFE)
		;(GHOST GHOSTS SPOOK SPECTER SPECTRE)
	(FLAGS PERSONBIT FEMALE SEENBIT)
	(CHARACTER 16)>
[
<OBJECT GHOST-NEW
	(DESC ;"new " "ghost")
	(IN LOCAL-GLOBALS)
	(ADJECTIVE BLOND BLONDE NEW DEE\'S HER CASTLE
		 GHOST ;"for poss's")
	(SYNONYM GHOST
		;"GHOSTS SPECTER SPECTRE SPOOK MURDER")
		;(SPIRIT PHANTOM)
	(FLAGS SEENBIT OPENBIT ;PERSONBIT SEARCHBIT NDESCBIT ;ONBIT)
	(LDESC 0)
	(WEST "lurking in the shadows")
	(CAPACITY 40)
	(LINE 0)
	(CHARACTER 10 ;0)
	(DESCFCN GHOST-NEW-D)
	(ACTION GHOST-NEW-F)>

<ROUTINE GHOST-NEW-D ("OPTIONAL" (ARG <>))
	<COND (<FSET? ,GHOST-NEW ,TOUCHBIT>
	       <DESCRIBE-PERSON ,GHOST-NEW>)
	      (T
	       <FCLEAR ,GHOST-NEW ,NDESCBIT>
	       <FSET ,GHOST-NEW ,PERSONBIT>
	       <FSET ,GHOST-NEW ,TOUCHBIT>
	       <FSET ,GHOST-NEW ,SEENBIT>
	       <FSET ,COSTUME ,SEENBIT>
	       <CRLF>
	       <COND (<FSET? ,GHOST-NEW ,MUNGBIT>
		      <TELL "Lying " <GROUND-DESC> " i">)
		     (T <TELL "Out of the dark come">)>
	       <TELL
"s a figure with " ,LONG-BLOND-HAIR ", dressed all in
silvery white and glowing with an almost unearthly light." CR>)>
	<RTRUE>>

<GLOBAL GHOST-CACKLES "The ghost only cackles in response.|">

<ROUTINE GHOST-NEW-F ("OPTIONAL" (ARG <>) "AUX" OBJ ;X)
 <COND (<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION ,GHOST-NEW>> <RFATAL>)
	      ;(<SET X <COM-CHECK ,GHOST-NEW>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T
	       <TELL ,GHOST-CACKLES>
	       <RFATAL>)>)
       (<SET OBJ <ASKING-ABOUT? ,GHOST-NEW>>
	<COND (<GRAB-ATTENTION ,GHOST-NEW .OBJ>
	       <COND (<NOT <EQUAL? ,VARIATION ,LORD-C>>
		      <TELL ,GHOST-CACKLES>)
		     (<NOT <LOVER-SPEECH>>
		      <GHOST-FLEES>)>)>
	<RFATAL>)
       (<VERB? EXAMINE>
	<TELL
CHE ,GHOST-NEW " is wearing heavy white makeup with black eyes and lips. ">
	<DESCRIBE-GOWN>
	<CRLF>
	<COMMON-OTHER ,GHOST-NEW>)
       (<OR <VERB? BRUSH SEARCH UNDRESS>
	    <AND <VERB? SEARCH-FOR> <IOBJ? COSTUME>>>
	<COND (<NOT <FSET? ,GHOST-NEW ,MUNGBIT>>
	       <TELL ,GHOST-CACKLES>
	       <RTRUE>)
	      (<AND <IN? ,COSTUME ,GHOST-NEW> ;<FSET? ,GHOST-NEW ,MUNGBIT>>
	       <UNDRESS-GHOST>
	       <RTRUE>)>)
       (<SET OBJ <GHOST-NEW-VERBS>>
	<COND (<GRAB-ATTENTION ,GHOST-NEW>
	       <COND (<NOT <EQUAL? ,VARIATION ,LORD-C>>
		      <TELL ,GHOST-CACKLES>)
		     (<OR <==? .OBJ 2>
			  <NOT <LOVER-SPEECH>>>
		      <GHOST-FLEES>)>)>
	<RFATAL>)
       (T <PERSON-F ,GHOST-NEW .ARG>)>>

<ROUTINE GHOST-NEW-VERBS ()
 <COND (<VERB? BOW GIVE SGIVE>	;"friendly"
	<RTRUE>)
       (<VERB? KISS LISTEN RUB>	;"friendly"
	<RTRUE>)
       (<VERB? SMILE>		;"friendly"
	<RTRUE>)
       (<SPEAKING-VERB? ,GHOST-NEW>		;"friendly"
	<RTRUE>)
       (<VERB? ARREST MUNG PUSH SLAP STOP YELL>	;"unfriendly"
	<RETURN 2>)
       (<VERB? TAKE>		;"unfriendly"
	<COND (<NOT <FSET? ,GHOST-NEW ,MUNGBIT>>
	       <RETURN 2>)>)>>

<GLOBAL VILLAIN-KNOWN?:FLAG <>>

<ROUTINE UNDRESS-GHOST ("AUX" (L <LOC ,GHOST-NEW>) ADJ
			      ;(C <GETP ,GHOST-NEW ,P?CHARACTER>))
	;<FSET ,GHOST-NEW ,PERSONBIT>
	<MOVE ,COSTUME ,WINNER>
	<FCLEAR ,COSTUME ,NDESCBIT>
	<FCLEAR ,COSTUME ,WORNBIT>
	<FSET ,COSTUME ,TOUCHBIT>
	<FSET ,COSTUME ,TAKEBIT>
	<MOVE ,GHOST-NEW ,LOCAL-GLOBALS>
	<MOVE ,VILLAIN-PER .L>
	;<SETG OTHER-CHAR ,GHOST-NEW>
	;<PUT ,CHARACTER-TABLE .C ,VILLAIN-PER>
	;<PUT ,CHAR-POSS-TABLE <+ 1 .C> ,OTHER-POSS>
	;<SETG OTHER-POSS ,W?G\'S>
	<COND (<SET ADJ <GETP ,VILLAIN-PER ,P?STATION>>
	       <COND (<T? ,OTHER-POSS-POS>
		      <PUTB <GETPT ,HEAD ,P?ADJECTIVE>
			    ,OTHER-POSS-POS .ADJ>
		      <PUTB <GETPT ,HANDS ,P?ADJECTIVE>
			    ,OTHER-POSS-POS .ADJ>
		      <PUTB <GETPT ,EYE ,P?ADJECTIVE>
			    ,OTHER-POSS-POS .ADJ>
		      <PUTB <GETPT ,OTHER-OUTFIT ,P?ADJECTIVE>
			    ,OTHER-POSS-POS .ADJ>)>)>
	<THIS-IS-IT ,VILLAIN-PER>
	<FSET ,VILLAIN-PER ,MUNGBIT>
	<PUTP ,VILLAIN-PER ,P?LDESC 19 ;"out cold">
	<SETG VILLAIN-KNOWN? T>
	<TELL
"When you remove the " D ,COSTUME ", you discover " D ,VILLAIN-PER
" underneath!" CR>
	<CONGRATS ,COSTUME>
	;<COND (<==? ,VILLAIN-PER ,LOVER ;,LORD>
	       <UNSNOOZE ,LOVER> ;"because no body parts!")>>

<ROUTINE DESCRIBE-GOWN ()
	<FSET ,GHOST-NEW ,PERSONBIT>
	<TELL "The gown ">
	<COND (<NOT <==? ,LIT ,HERE>>
	       <TELL "seems to fluoresce in the dark. It ">)>
	<TELL "has a ">
	<COND (<EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ;,OFFICER-C>
	       <TELL "high">)
	      (T <TELL "low">)>
	<TELL " neckline and ">
	<COND (<EQUAL? ,VARIATION ,DOCTOR-C ;,DEALER-C ;,OFFICER-C>
	       <TELL "long">)
	      (T <TELL "no">)>
	<TELL " sleeves.">>

<OBJECT COSTUME
	(DESC "ghost costume")
	(ADJECTIVE GHOST G\'S HER HIS WHITE BLOND BLONDE PALE)
        (SYNONYM COSTUME DISGUISE GOWN WIG ;SHEET)
	;(GENERIC GENERIC-CLOTHES)
	(FLAGS WEARBIT TAKEBIT SECRETBIT ONBIT)
	(SIZE 20)
	(ACTION COSTUME-F)>

<ROUTINE COSTUME-F ()
 <COND (<VERB? TELL-ABOUT>
	<COND (<FSET? ,PRSO ,PERSONBIT>
	       <COND (<==? ,VARIATION <GETP ,PRSO ,P?CHARACTER>>
		      <SETG PRSA ,V?ASK-ABOUT>
		      <RFALSE>)
		     (T <TELL-ABOUT-OBJECT ,PRSO ,COSTUME ,FOUND-COSTUME>)>)>)
       (<REMOTE-VERB?>
	<RFALSE>)
       (<AND <NOUN-USED? ,W?WIG>
	     <EQUAL? ,VARIATION ,LORD-C>>
	<SETG CLOCK-WAIT T>
	<TELL "(There is no wig!)" CR>)
       (<VERB? EXAMINE LOOK-INSIDE>
	<COND (<NOT <NOUN-USED? ,W?WIG>>
	       <DESCRIBE-GOWN>
	       <COND (<EQUAL? <LOC ,COSTUME> ,GHOST-NEW ,VILLAIN-PER>
		      <TELL " It's on">)
		     (T <TELL
" When you hold it up, you can see it would fit">)>
	       <TELL " a ">
	       <COND (<EQUAL? ,VARIATION ,LORD-C ,FRIEND-C ,DOCTOR-C>
		      <TELL "person of average height.">)
		     (T ;<EQUAL? ,VARIATION ;,DEALER-C ,PAINTER-C ;,OFFICER-C>
		      <TELL "tall person.">)>
	       <CRLF>)>
	<COND (<AND <NOT <NOUN-USED? ,W?GOWN>>
		    <NOT <EQUAL? ,VARIATION ,LORD-C>>>
	       <TELL
"It's obvious that the wig was designed to resemble " 'LOVER "'s long, flowing
hair." CR>
	       <COND (<NOT <EQUAL? <LOC ,COSTUME> ,GHOST-NEW ,VILLAIN-PER>>
		      <TELL "Inside, you notice several individual ">
		      <COND (<EQUAL? ,VARIATION ,FRIEND-C> <TELL "red">)
			    (<EQUAL? ,VARIATION ,DOCTOR-C> <TELL "grayish">)
			    ;(<EQUAL?,VARIATION,DEALER-C><TELL "sandy-brown">)
			    (T ;<EQUAL? ,VARIATION ,PAINTER-C> <TELL "tawny">)
			    ;(<EQUAL?,VARIATION,OFFICER-C><TELL"dark blond">)>
		      <TELL " hairs, the same color as ">
		      <COND ;(<EQUAL? ,VARIATION ,LORD-C> <TELL 'LOVER>)
			    (T <TELL D <GET ,CHARACTER-TABLE ,VARIATION>>)>
		      <TELL "'s hair." CR>
		      <CONGRATS ,COSTUME>)>)>
	<RTRUE>)
       ;(<VERB? FIND>
	<COND (<IN? ,COSTUME ,HERE>
	       <COND (<FSET? ,COSTUME ,NDESCBIT>
		      <DISCOVER ,COSTUME>)
		     (T <TELL "It's right here!" CR>)>)
	      (T <TELL "Results are negative." CR>)>)
       (<VERB? LOOK-UNDER TAKE TAKE-OFF>
	<COND (<IN? ,COSTUME ,GHOST-NEW>
	       <PERFORM ,V?UNDRESS ,GHOST-NEW>
	       <RTRUE>)>)
       (<OR <VERB? WEAR>
	    <AND <VERB? PUT>
		 <T? ,PRSI>
		 <FSET? ,PRSI ,PERSONBIT>>>
	<WEAR-SCARE>)>>

<ROUTINE WEAR-SCARE ()
	<TELL "You start to put" THE ,PRSO " on">
	<COND (<T? ,PRSI> <TELL !\  'PRSI>)>
	<TELL ", but">
	<COND (<DOBJ? NECKLACE-OF-D>
	       <TELL ,CLASP-MUNGED "." CR>)
	      (T <TELL " then decide it might scare the other guests." CR>)>>

<GLOBAL LONG-BLOND-HAIR "long blonde hair">

;<OBJECT WIG
	(DESC "blonde wig")
	(ADJECTIVE BLOND BLONDE PALE GHOST)
        (SYNONYM WIG)
	(FLAGS WEARBIT NDESCBIT)
	(SIZE 8)
	(ACTION WIG-F)>
]
<GLOBAL CHARACTER-TABLE
	<PTABLE PLAYER FRIEND LORD PAINTER DOCTOR OFFICER ;5
		DEALER DEB BUTLER LOVER GHOST-NEW ;10
		COUSIN MAID DRAGON BUFFALO-HEAD RHINO-HEAD GHOST-OLD ;16>>

<GLOBAL GUEST-TABLE
	<PLTABLE FRIEND DEB OFFICER DOCTOR DEALER PAINTER>>

<GLOBAL CHAR-ROOM-TABLE
	<PLTABLE YOUR-ROOM TAMARA-ROOM JACK-ROOM
		VIVIEN-ROOM WENDISH-ROOM IAN-ROOM
		HYDE-ROOM IRIS-ROOM KITCHEN LIMBO LIMBO ;10
		;"just for convenience:"
		DRAWING-ROOM LIBRARY ;LUMBER-ROOM
		SITTING-ROOM BACKSTAIRS>>

<GLOBAL CHAR-CLOSET-TABLE
	<LTABLE YOUR-CLOSET SECRET-LANDING-TAM SECRET-LANDING-JACK
		SECRET-VIVIEN-PASSAGE WENDISH-CORNER SECRET-IAN-PASSAGE
		HYDE-CLOSET IRIS-CLOSET KITCHEN SECRET-LANDING-JACK 0
		;"just for convenience:"
		DRAWING-CLOSET SECRET-LANDING-LIB ;SECRET-LANDING-2
		SITTING-PASSAGE DINING-PASSAGE>>

;<GLOBAL OTHER-CHAR:OBJECT GHOST-NEW>
;<GLOBAL OTHER-POSS <VOC "G'S"	ADJECTIVE>>
<GLOBAL OTHER-POSS-POS:NUMBER 0>

<GLOBAL CHAR-POSS-TABLE
	<LTABLE <VOC "MY"	ADJECTIVE>
		<VOC "TAM'S"	ADJECTIVE>
		<VOC "JACK'S"	ADJECTIVE>
		<VOC "VIV'S"	ADJECTIVE>
		<VOC "DOC'S"	ADJECTIVE>
		<VOC "IAN'S"	ADJECTIVE>
		<VOC "HYDE'S"	ADJECTIVE>
		<VOC "IRIS'S"	ADJECTIVE>
		<VOC "B'S"	ADJECTIVE>
		<VOC "DEE'S"	ADJECTIVE>
		<VOC "G'S"	ADJECTIVE>
		<VOC "LI'S"	ADJECTIVE>
		<VOC "MAID'S"	ADJECTIVE>
		<VOC "WORM'S"	ADJECTIVE>
		<VOC "BUF'S"	ADJECTIVE>
		<VOC "RH'S"	ADJECTIVE>>>

<GLOBAL FOLLOW-LOC	<TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ;16>>

<GLOBAL TOUCHED-LDESCS	<TABLE 0 0 0 0 0 0 0 0 0 0 0>>

<GLOBAL FOUND-COSTUME	<TABLE 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL FOUND-PASSAGES	<TABLE 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL TOLD-ABOUT-GHOST<TABLE 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL TOLD-ABOUT-EVID	<TABLE 0 0 0 0 0 0 0 0 0 0>>
<GLOBAL SHOT		<TABLE 0 0 0 0 0 0 0 0 0 0 0>>

<ROUTINE WHY-ME ()
 <COND (<BTST ,PRESENT-TIME 1>
	<TELL "\"You could do that " 'PLAYER ", you know.\"" CR>
	;<TELL "\"If you think that will help, do it!\"" CR>)
       (T <TELL "\"I think you can do that better " 'PLAYER ".\"" CR>)>>

<ROUTINE DESCRIBE-PERSON (PER "AUX" (STR <>))
	<SET STR <GETP .PER ,P?LDESC>>
	<COND (<AND <NOT <EQUAL? .PER ,BUTLER ,LOVER>>
		    <ALL-TOGETHER-NOW?>>
	       <COND (<==? .PER ,LORD>
		      <SETG P-HIM-OBJECT <>>
		      <SETG P-HER-OBJECT <>>
		      <TELL D .PER " and all his guests are here.">
		      ;<COND (<AND .STR ;<NOT <==? .STR 6 ;"walking along">>>
			     <TELL <GET ,LDESC-STRINGS .STR>>)
			    (<AND <SET STR <GETPT .PER ,P?WEST>>
				  <SET STR <GET .STR ,NEXITSTR>>>
			     <TELL .STR>)
			    (T <TELL <GET ,LDESC-STRINGS 13>
				     ;"lounging and chatting">)>
		      <COND (<AND <ZERO? ,CONFESSED>
				  <NOT <QUEUED? ,I-LIONEL-SPEAKS>>>
			     <TELL
" They smile pleasantly but, with typical British reserve, seem
willing to leave you to your own devices."
;"probably think you're no match for a ghost.">)>
		      <CRLF>)>
	       <RTRUE>)>
	<COND (<AND .STR ;<NOT <==? .STR 6 ;"walking along">>>
	       <PUT ,TOUCHED-LDESCS <GETP .PER ,P?CHARACTER> .STR>
	       ;<TELL <GET ,LDESC-STRINGS .STR>>
	       <RFALSE>)>
	<TELL CTHE .PER " is ">
	<COND (<AND <SET STR <GETPT .PER ,P?WEST>>
		    <SET STR <GET .STR ,NEXITSTR>>>
	       <TELL .STR>)
	      ;(T
	       <TELL "looking just as you want">)>
	<TELL ".">
	<COND (<==? .STR 6 ;"walking along"> <PRINTC 32>)
	      (T <CRLF>)>
	<RTRUE>>

<ROUTINE ALL-TOGETHER-NOW? ()
 <COND (<AND <EQUAL? <LOC ,LORD>	,HERE ,PSEUDO-OBJECT>
	     <EQUAL? <LOC ,FRIEND>	,HERE ,PSEUDO-OBJECT>
	     <EQUAL? <LOC ,DEB>		,HERE ,PSEUDO-OBJECT>
	     <EQUAL? <LOC ,OFFICER>	,HERE ,PSEUDO-OBJECT>
	     <EQUAL? <LOC ,DOCTOR>	,HERE ,PSEUDO-OBJECT>
	     <EQUAL? <LOC ,DEALER>	,HERE ,PSEUDO-OBJECT>
	     <EQUAL? <LOC ,PAINTER>	,HERE ,PSEUDO-OBJECT>>
	;<MOVE ,CREW ,HERE>
	;<PUTP ,LORD ,P?LDESC 13>
	<RTRUE>)
       (T
	;<REMOVE ,CREW>
	;<PUTP ,LORD ,P?LDESC 0>
	<RFALSE>)>>

<GLOBAL LDESC-STRINGS
 <PLTABLE	"dancing"
		"sipping sherry"
	;3	"watching you" ;"talking quietly"
		"looking at you with suspicion"
		0 ;"gazing out the window"
	;6	"walking along"
		"sobbing quietly"
		"poised to attack"
	;9	"waiting patiently"
		"eating with relish"
		"preparing dinner"
	;12	"listening to you"
		"lounging and chatting"
		"asleep"
	;15	0 ;"reading a note"
		"listening"
		"preparing to leave"
	;18	"deep in thought"
		"out cold"
		"ignoring you"
	;21	"searching"
		"playing the piano"
		"following you"
	;24	"brushing her hair"
		"looking sleepy">>

<ROUTINE TELL-ABOUT-OBJECT (PER OBJ GL "AUX" C)
	<COND (<T? <GET .GL ,PLAYER-C>>
	       <SET C <GETP .PER ,P?CHARACTER>>
	       <COND (<ZERO? <GET .GL .C>>
		      <PUT .GL .C T>
		      <COND (<NOT <==? .C ,VARIATION>>
			     <PUTP .PER ,P?LINE 0>)>
		      ;<TELL "\"You mean you found a " D .OBJ "? ">
		      <RETURN <GOOD-SHOW .PER .OBJ>>)
		     (T <TELL"\"I know that you found a " D .OBJ ".\"" CR>)>)>>

<ROUTINE PERSON-F (PER ARG "AUX" OBJ X L C N)
 <SET L <LOC .PER>>
 <SET C <GETP .PER ,P?CHARACTER>>
 <COND ;(<==? .ARG ,M-WINNER>
	<COND (<NOT <GRAB-ATTENTION .PER>> <RFATAL>)
	      (<SET X <COM-CHECK .PER>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>)
		     (<==? .X ,M-OTHER> <RFATAL>)
		     (T <RTRUE>)>)
	      (T <WHY-ME> <RFATAL>)>)
       (<VERB? ALARM SHAKE>
	<COND (<==? ,PRSO .PER>
	       <COND (<AND <QUEUED? ,I-COME-TO>
			   <EQUAL? .PER ,VILLAIN-PER ,GHOST-NEW>>
		      <QUEUE I-COME-TO 1>	;"will respond"
		      <RTRUE>)
		     (<UNSNOOZE .PER T>
		      <TELL CHE .PER " gasps to see you so close!" CR>
		      <RTRUE>)
		     (T ;<VERB? SHAKE>
		      <TELL CHE .PER is " still ">
		      <COND (<SET X <GETP .PER ,P?LDESC>>
			     <TELL <GET ,LDESC-STRINGS .X>>)
			    (<SET X <GETPT .PER ,P?WEST>>
			     <TELL <GET .X ,NEXITSTR>>)>
		      <TELL "." CR>)>)>)
       (<VERB? FORGIVE>
	<COND (<NOT <GRAB-ATTENTION .PER>> <RFATAL>)>
	<TELL "\"Thank you so much. I didn't realize I'd offended you.\"" CR>)
       (<VERB? GIVE>
	<COND (<AND <EQUAL? ,PRSI .PER> <HELD? ,PRSO>>
	       <COND (<NOT <GRAB-ATTENTION .PER>> <RFATAL>)>
	       <RFALSE>)>)
       ;(<VERB? LISTEN>		;"moved to PRE-LISTEN"
	<COND (<==? <GETP .PER ,P?LDESC> 22 ;"playing the piano">
	       <TELL "The music sounds lovely." CR>
	       <RTRUE>)>)
       (<VERB? LAMP-OFF>
	<COND (<T? <GETP .PER ,P?LINE>>
	       <TELL "Seems you've already done that." CR>)
	      (T <WONT-HELP>)>)
       (<VERB? MUNG SEARCH SEARCH-FOR>
	<COND (<AND <==? .PER ,PRSO>
		    ;<OR <NOT <==? .PER ,FRIEND>>
			<EQUAL? ,VARIATION ,FRIEND-C>>
		    <FSET? .PER ,PERSONBIT>
		    <NOT <FSET? .PER ,MUNGBIT>>>
	       <PUTP .PER ,P?LINE <+ 1 <GETP .PER ,P?LINE>>>
	       <COND (<NOT <EQUAL? <GETP .PER ,P?LDESC>
				   4 ;"looking at you with suspicion">>
		      ;<EQUAL? .PER ,FRIEND>
		      <PUTP .PER ,P?LDESC 20 ;"ignoring you">)>
	       <TELL
CHE .PER " pushes you away and mutters, \"I don't think that's
called for.\"" CR>
	       <RTRUE>)>)
       (<VERB? SHOW>
	<COND (<==? .PER ,PRSO>
	       <COND (<AND ;<NOT <EQUAL? ,PRSI ,PASSAGE>>
			   <NOT <GRAB-ATTENTION .PER>>>
		      <RFATAL>)
		     ;(<EQUAL? ,PRSI ,LOVER>
		      <TELL "\"She's alive! That's incredible!\"" CR>
		      <RTRUE>)
		     (T
		      <PERFORM ,V?TELL-ABOUT ,PRSO ,PRSI>
		      <RTRUE>)>)>)
       (<VERB? SMILE>
	<COND (<==? .PER ,PRSO>
	       <COND (<NOT <GRAB-ATTENTION .PER>>
		      <RFATAL>)
		     (T
		      <TELL CHE ,PRSO smile " back at you." CR>
		      <RTRUE>)>)>)
       (<VERB? TELL-ABOUT>
	<COND (<==? .PER ,PRSO>
	       <COND (<NOT <GRAB-ATTENTION .PER>>
		      <RFATAL>)>
	       <PUTP .PER ,P?LDESC 12 ;"listening to you">
	       <COND ;(<EQUAL? ,PRSI ,BELL>
		      <COND (<==? <GET <GT-O .PER> ,GOAL-FUNCTION> ,X-TO-BELL>
			     ;"GOAL-FUNCTION is already changed by now."
			     <TELL "\"Oh, I see. You rang the bell.\"" CR>
			     <RTRUE>)>)
		     (<AND <FSET? ,PRSI ,RMUNGBIT>
			   <FSET? ,PRSI ,SEENBIT>
			   <NOT <FSET? ,PRSI ,PERSONBIT>>>
		      <PUT ,TOLD-ABOUT-EVID <GETP .PER ,P?CHARACTER> T>
		      <TELL ,THATS-INTERESTING>
		      <RTRUE>)
		     (<AND <EQUAL? ,PRSI ,CLUE-1>
			   ;<T? <GET ,CLUE-1-KNOWN ,PLAYER-C>>>
		      ;<PUT ,CLUE-1-KNOWN <GETP .PER ,P?CHARACTER> T>
		      <TELL ,THATS-INTERESTING>
		      <RTRUE>)
		     (<EQUAL? ,PRSI ,CONFESSED>
		      <COND (<NOT <==? .PER ,CONFESSED>>
			     <TELL ,IM-SHOCKED>
			     <RTRUE>)>)
		     (<EQUAL? ,PRSI ,GHOST-NEW>
		      <COND (<AND <FSET? ,GHOST-NEW ,TOUCHBIT>
				  <NOT <==? .PER ,GHOST-NEW>>>
			     <PUT ,TOLD-ABOUT-GHOST <GETP .PER ,P?CHARACTER> T>
			     <TELL
"\"You saw the ghost? Tell me, how can I help?\"" CR>
			     <RTRUE>)>)
		     (<SECRET-PASSAGE-OR-DOOR? ,PRSI>
		      <TELL-ABOUT-OBJECT ,PRSO ,PASSAGE ,FOUND-PASSAGES>
		      <RTRUE>)>
	       <TELL "\"I don't know what you mean.\"" CR>)>)
       (<VERB? THROW-AT>
	<COND (<AND <==? .PER ,PRSI>
		    <FSET? .PER ,PERSONBIT>
		    <NOT <FSET? .PER ,MUNGBIT>>>
	       <MOVE ,PRSO ,PRSI>
	       <TELL CHE .PER " catches" THE ,PRSO " with" HIS .PER !\ >
	       <COND (<EQUAL? .PER ,DEB ,DOCTOR ;,DEALER> <TELL "lef">)
		     (T <TELL "righ">)>
	       <TELL "t hand." CR>
	       <RTRUE>)>)
       ;(<SET OBJ <ASKING-ABOUT? .PER>>
	<COND (<NOT <GRAB-ATTENTION .PER>>
	       <RFATAL>)
	      ;(<SET X <COMMON-ASK-ABOUT .PER .OBJ>>
	       <COND (<==? .X ,M-FATAL> <RFALSE>) (T <RTRUE>)>)
	      (T <DONT-KNOW .PER .OBJ>)>)
       (T <COMMON-OTHER .PER>)>>

<ROUTINE SECRET-PASSAGE-OR-DOOR? (OBJ)
 <COND (<EQUAL? .OBJ	,PASSAGE ,SECRET-JACK-DOOR ,SECRET-TAMARA-DOOR
			,SECRET-LIBRARY-DOOR ,SECRET-DRAWING-DOOR
			,SECRET-SITTING-DOOR ,SECRET-DINING-DOOR
			,SECRET-YOUR-DOOR ,SECRET-IRIS-DOOR
			,SECRET-WENDISH-DOOR ,SECRET-VIVIEN-DOOR
			,SECRET-IAN-DOOR ,SECRET-HYDE-DOOR>
	<RTRUE>)>>

"People Functions"

<ROUTINE CARRY-CHECK (PER)
 <COND (<FIRST? .PER>
	<TELL CHE .PER is " holding">
	<PRINT-CONTENTS .PER>
	<TELL "." CR>)>>

<ROUTINE WINNER-DESCRIBE (OBJ RM)
	<TELL "\"You can see " D .OBJ>
	<COND (<==? ,HERE .RM>
	       <TELL " right over there">)
	      (T <TELL " in the " D .RM>)>
	<TELL ".\"" CR>>

<ROUTINE TRANSIT-TEST (PER)
	<COND (<OR <VERB? DISEMBARK LEAVE TAKE-TO THROUGH WALK WALK-TO>
		   ;<AND <VERB? FOLLOW>
			<DOBJ? PLAYER>>>
	       <WILLING? .PER>)>>

<GLOBAL FAWNING:FLAG <>>
<ROUTINE COM-CHECK (PER "AUX" N TAG)
 	 <SET N <GETP .PER ,P?LINE>>
	 <SET TAG <GET ,TOLD-ABOUT-GHOST <GETP .PER ,P?CHARACTER>>>
;"First section is w/o fawning."
	 <COND (<VERB? $CALL>	;"e.g. TAMARA, LOVE ME"
		<DONT-UNDERSTAND>
		<RETURN ,M-OTHER>)
	       (<TRANSIT-TEST .PER>
		;<COND (<OR <EQUAL? ,HERE ,DINING-ROOM>
			   <QUEUED? ,I-TOUR>>
		       <TELL "\"Not just now.\"" CR>
		       <RTRUE>)>
		<RFATAL>)
	       (<VERB? ALARM HELLO SORRY>
		<COND (<OR <DOBJ? ROOMS> <==? ,PRSO .PER>>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,PRSA .PER>
		       <RTRUE>)
		      (T <RFALSE>)>)
	       ;(<AND <L? 0 .N>
		     ;<OR <NOT <==? .PER ,FRIEND>>
			 <EQUAL? ,VARIATION ,FRIEND-C>>>
		<TELL "\"I'm too ">
		<COND (<1? .N> <TELL "peeved">) (T <TELL "angry">)>
		<TELL " with you now.\"" CR>
		<RTRUE>)
	       (<VERB? ARREST NO THANKS YES>
		<RFATAL>		;"let thru to next handler")
	       (<VERB? DESCRIBE>
		<COND (<DOBJ? GHOST-NEW>
		       <TELL
"\"I'm sorry, but I didn't see" HIM ,GHOST-NEW ".\"" CR>
		       <RTRUE>)
		      (<DOBJ? MAID>
		       <TELL ,NEVER-NOTICED-HER>
		       ;<TELL "\"I've never really noticed" HIM ,PRSO ".\"" CR>
		       <RTRUE>)
		      (<DOBJ? COUSIN BUST ;RECORDER>
		       <WINNER-DESCRIBE ,BUST ,DINING-ROOM>
		       <RTRUE>)
		      (<DOBJ? LOVER>
		       <WINNER-DESCRIBE ,LOVER-PIC ,DRAWING-ROOM>
		       <RTRUE>)
		      ;(<DOBJ? TREASURE>
		       <RFALSE>)
		      (T
		       <TELL "\"You could ">
		       <COND (<NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
			      <TELL "go ">)>
		       <TELL "have a look for " 'PLAYER ", you know.\"" CR>
		       <RTRUE>)>)
	       (<VERB? FOLLOW WALK-TO>
		<COND (<==? .PER ,BUTLER>
		       <RFALSE>)
		      (<AND <VERB? WALK-TO>
			    <OR <T? .TAG>
				<DOBJ? SLEEP-GLOBAL BED TAMARA-BED>>>
		       <RFATAL>)
		      (T
		       <TELL
"\"I will go where I please, thank you very much.\"" CR>
		       <RTRUE>)>)
	       (<VERB? INVENTORY>
		<COND (<NOT <CARRY-CHECK .PER>>
		       <TELL CHE .PER is "n't holding anything." CR>)>
		<RTRUE>)
	       (<VERB? LISTEN>
		<COND (<OR <DOBJ? PLAYER PLAYER-NAME>
			   <NOT <IN? ,PRSO ,GLOBAL-OBJECTS>>>
		       <TELL "\"I'm trying to, " FN "!\"" CR>
		       <RTRUE>)
		      (T <RFALSE>)>)
	       (<VERB? RUB>
		<FACE-RED>
		<RTRUE>)>
	 <COND (<AND <1? <RANDOM 3>>
		     <WILLING? .PER T>>
		<COND (<EQUAL? .PER ,DEB>
		       <SETG FAWNING T>
		       <TELL
"\"My dear "FN", how could I refuse someone
as handsome as you?\" Iris murmurs, batting her eyelashes. ">)
		      (<EQUAL? .PER ,OFFICER>
		       <SETG FAWNING T>
		       <TELL
"\"Delighted to help you if I can, "FN" luv! One feels those
great luminous eyes of yours can see right through a chap!\" says the
handsome young guardsman. ">)>)>
	 <COND (<AND <VERB? DANCE> <DOBJ? PLAYER>>
		<SETG WINNER ,PLAYER>
		<PERFORM ,PRSA .PER>
		<RTRUE>)
	       (<OR <VERB? DANCE ;GOODBYE>
		    <AND <VERB? WALK>
			 <OR <DOBJ? P?OUT>
			     <T? .TAG>>>>
		<COND ;(<==? .PER ,GHOST-NEW>
		       <TELL "\"Don't be silly.\"" CR>
		       <RTRUE>)
		      (T
		       ;<TELL "\"As you wish.\"" CR>
		       <RFATAL>	;"let thru to next handler")>)
	       (<VERB? SIGN>
		<TELL "You notice that" HE .PER " is ">
		<COND (<EQUAL? .PER ,DEB ,DOCTOR ;,DEALER> <TELL "lef">)
		      (T <TELL "righ">)>
		<TELL "t-handed." CR>)
	       (<VERB? KISS>
		<UNSNOOZE .PER>
		<TELL
"\"I really don't think this is the proper time or place.\"" CR>)
	       ;(<VERB? WALK-TO>
		<COND (<DOBJ? HERE GLOBAL-HERE>
		       <TELL "\"I am here, "TN"!\"" CR>)>)
	       (<VERB? TAKE ;"GET SEND SEND-TO BRING">
		<COND (<IN? ,PRSO ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?GIVE ,PRSO .PER>
		       <RTRUE>)>)
	       (<VERB? EXAMINE LOOK-INSIDE READ>
		<COND (<IN? ,PRSO ,PLAYER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?SHOW .PER ,PRSO>
		       <RTRUE>)>)
	       (<VERB? FORGIVE>
		<SETG WINNER ,PRSO>
		<PERFORM ,V?SORRY .PER>
		<RTRUE>)
	       (<AND <VERB? GIVE THROW-AT> <FSET? ,PRSI ,PERSONBIT>>
		<SETG WINNER ,PRSI>
		<PERFORM ,V?ASK-FOR .PER ,PRSO>
		<RTRUE>)
	       (<AND <VERB? SGIVE> <FSET? ,PRSO ,PERSONBIT>>
		<SETG WINNER ,PRSO>
		<PERFORM ,V?ASK-FOR .PER ,PRSI>
		<RTRUE>)
	       (<VERB? HELP>
		<COND (<EQUAL? ,PRSO <> ,PLAYER ,PLAYER-NAME>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PER>
		       <RTRUE>)
		      (T <RFATAL>)>)
	       (<VERB? FIND SHOW SSHOW>
		<COND (<VERB? SHOW>
		       <SETG PRSA ,V?SSHOW>
		       <SET N ,PRSI>
		       <SETG PRSI ,PRSO>
		       <SETG PRSO .N>)>
		<COND (<IN? ,PRSO ,ROOMS>	;"SHOW ME MY ROOM"
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?WALK-TO ,PRSO>
		       <RTRUE>)
		      (<IN? ,PRSO .PER>
		       <COND (<==? <ITAKE> T>
			      <TELL
CHE .PER " fumbles in" HIS .PER " pocket and produces" HIM ,PRSO "." CR>)>
		       <RTRUE>)
		      (<VERB? FIND>
		       ;<SETG WINNER ,PLAYER>
		       ;<PERFORM ,PRSA ,PRSO>
		       <RFATAL>)>)
	       (<VERB? PLAY>
		<COND (<DOBJ? PIANO>
		       <TELL
"\"I'm not very good at this sort of thing, but...\"|">
		       <RFATAL>)
		      (T <RFALSE>)>)
	       (<VERB? TELL>
		<COND (<DOBJ? PLAYER PLAYER-NAME>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .PER>
		       <RTRUE>)>)
	       (<VERB? TELL-ABOUT>
		<COND (<FSET? ,PRSO ,PERSONBIT>
		       ;<DOBJ? PLAYER PLAYER-NAME>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK-ABOUT .PER ,PRSI>
		       <RTRUE>)>)
	       (<VERB? STOP WAIT-FOR>
		<COND (<DOBJ? HERE GLOBAL-HERE PLAYER PLAYER-NAME ROOMS>
		       <COND (<==? .PER ,FOLLOWER>
			      <SETG FOLLOWER 0>
			      <TELL "\"As you wish, ">
			      <COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
			      <TELL "\"" CR>)
			     (T
			      <SETG WINNER ,PLAYER>
			      <PERFORM ,V?$CALL .PER>
			      <RTRUE>)>)>)
	       (<VERB? ;WHAT TALK-ABOUT>
		<SETG WINNER ,PLAYER>
	        <PERFORM ,V?ASK-ABOUT .PER ,PRSO>
		<RTRUE>)>>

<GLOBAL NEVER-NOTICED-HER "\"I can't say that I ever noticed her much.\"|">

<ROUTINE EVIDENCE? (OBJ "OPTIONAL" (PER 0))
 <COND (<AND <T? .PER>
	     <NOT <EQUAL? ,VARIATION <GETP .PER ,P?CHARACTER>>>>
	<RFALSE>)
       (<EQUAL? .OBJ ,LETTER-MAID ,PASSAGE ,JEWEL>
	<RTRUE>)
       (<EQUAL? .OBJ ,LENS ,LENS-1 ,LENS-2>
	<RTRUE>)
       (<EQUAL? .OBJ ,COSTUME ,LENS-BOX ,EARRING>
	<RTRUE>)
       (<EQUAL? .OBJ ,BLOWGUN>
	<RTRUE>)
       (<AND <T? .OBJ>
	     <NOT <FSET? .OBJ ,PERSONBIT>>
	     <FSET? .OBJ ,RMUNGBIT> ;"evidence">
	<RTRUE>)>>

<GLOBAL IM-SHOCKED "\"I'm shocked!\"|">
<GLOBAL THATS-INTERESTING "\"Hmm... That certainly is interesting.\"|">
<GLOBAL ANCIENT-SECRETS
"\"Yes, the oldest parts of the castle hold ancient secrets,
some fascinating and some not.\"">

<ROUTINE SETUP-SHOT (PER)
	<SETG VILLAIN-KNOWN? T>
	<MOVE ,BLOWGUN .PER>
	<FCLEAR ,BLOWGUN ,NDESCBIT>
	<FCLEAR ,BLOWGUN ,TAKEBIT>
	<PUTP .PER ,P?LINE 2>
	<PUTP .PER ,P?LDESC 8 ;"poised to attack">
	<SETG AIMED-HERE ,HERE>
	<SETG SHOOTER .PER>
	<QUEUE I-SHOT ,CLOCKER-RUNNING ;2>>

<ROUTINE COMMON-ASK-ABOUT (PER OBJ)
 %<DEBUG-CODE <COND (,DBUG <TELL "{CAB: " D .PER !\/ D .OBJ "}|">)>>
 <COND (<EVIDENCE? .OBJ .PER>
	<TELL CHE .PER " flinches a little before answering.|">)
       (<EVIDENCE? .OBJ>
	<COND (<T? ,CONFESSED>
	       <TELL ,IM-SHOCKED>
	       <RTRUE>)
	      (T
	       <TELL CHE .PER " says, \"">
	       <COND (<1? <RANDOM 2>>
		      <TELL "Good Lord">)
		     (T <TELL "I say">)>
	       <TELL "! I think you're onto something here.\"" CR>
	       <RTRUE>)>)>
 <COND (<AND <FSET? .OBJ ,RMUNGBIT> ;"evidence"
	     <VERB? CONFRONT SHOW>
	     <NOT <FSET? .OBJ ,PERSONBIT>>>
	<PUT ,TOLD-ABOUT-EVID <GETP .PER ,P?CHARACTER> T>)>
 <COND (<AND <EQUAL? .OBJ ,SEARCHER>
	     <==? <GETP .OBJ ,P?LDESC> 21 ;"searching">>
	<COND (<EQUAL? .PER ,SEARCHER>
	       <TELL
"\"You mean, why am I searching? I'm sure you can guess.\"" CR>)
	      (T
	       <TELL "\"I imagine that " D .OBJ " is searching because">
	       <THIS-IS-IT .OBJ>
	       <TELL
HE .OBJ " got a bright idea. I prefer to let our" ,FAMOUS-YOUNG-DETECTIVE
" do the work.\"" CR>)>)
       (<EQUAL? .OBJ .PER>
	<TELL "\"I have no secrets. Anyone can see what I am.\"" CR>)
       (<EQUAL? .OBJ ,PLAYER ,PLAYER-NAME>
	<TELL "\"You're ">
	<TELL-FULL-NAME>
	<TELL ", the" ,FAMOUS-YOUNG-DETECTIVE ".\"" CR>)
       (<EQUAL? .OBJ ,BUTLER>
	<TELL "\"He's served the family all his life.\"" CR>)
       (<EQUAL? .OBJ ,LOVER>
	<TELL "\"Poor thing, her life came to a sad ending.">
	<COND (<==? .PER ,DOCTOR>
	       <TELL " As did her grandfather, whom I treated at my clinic.">)>
	<TELL "\"" CR>)
       (<EQUAL? .OBJ ,COUSIN ,BUST ;,RECORDER>
	<COND (T ;<NOT <EQUAL? .PER ,BUTLER ,PAINTER>>
	       <TELL "\"He was a bit of a strange bird, was Lionel.\"" CR>)>)
       (<EQUAL? .OBJ ,GHOST-NEW ,DANGER ,HAUNTING>
	<TELL "\"I myself haven't seen" HIM ,GHOST-NEW ".\"" CR>)
       (<EQUAL? .OBJ ,GHOST-OLD>
	<TELL
"\"Oh, she has haunted " 'CASTLE " for centuries -- a lovely phantom in
a white gown, with long pale hair. She was said to be the unfaithful
wife of an early Lord " ,TRESYLLIAN ", who had her walled up alive in
the tower.\""
;" Her spirit was sometimes seen at night, until poor "
;"they finally un-walled her bones and gave them decent burial. After
that, the haunting stopped -- until a couple of months ago, when poor
'LOVER Hallam drowned in the castle well.\""
;" That was just before  'LORD  hired me to catalog the castle library." CR>)
       (<EQUAL? .OBJ ,MAID>
	<TELL ,NEVER-NOTICED-HER>
	<RTRUE>)
       (<FSET? .OBJ ,PERSONBIT>
	<RFALSE>)
       (<AND <EQUAL? ,VARIATION <GETP .PER ,P?CHARACTER>>
	     <OR <FSET? .OBJ ,RMUNGBIT> ;"evidence"
		 <EQUAL? .OBJ ,BLOWGUN ;,COSTUME>>>
	;<PUT ,TOLD-ABOUT-EVID <GETP .PER ,P?CHARACTER> T>	;"done above"
	<PUTP .PER ,P?LINE 2>	;"angry"
	<TELL
"\"What can I say?\"" HE .PER " shrugs. \"It's a fair cop. You've caught
me with damning evidence.">
	<COND (<OR <EQUAL? ,VARIATION ,FRIEND-C ,LORD-C>
		   <NOT <EQUAL? ,HERE <GET ,CHAR-ROOM-TABLE
					   <+ 1 <GETP .PER ,P?CHARACTER>>>>>
		   <FIND-FLAG-HERE ,PERSONBIT ,PLAYER .PER>>
	       <TELL "\"" CR>
	       <RTRUE>)>
	<COND (<IN? ,BLOWGUN .PER>
	       <TELL "\" " CHE .PER>)
	      (T
	       <TELL " But there's something you don't know yet">
	       <IAN-CALLS-YOU>
	       <TELL
", which may put the matter in a different light.\"|
Still smiling," HE .PER " puts" HIS .PER " hand into" THE ,HIDING-PLACE
", and">)>
	<COND (<EQUAL? <LOC ,BLOWGUN> .PER ,HIDING-PLACE>
	       <SETG DISCOVERED-HERE ,HERE>
	       <SETUP-SHOT .PER>
	       <COND (<NOT <FSET? ,BLOWGUN ,NDESCBIT>>
		      ;<VERB? GIVE SGIVE>
		      <TELL " takes">)
		     (T
		      <FCLEAR ,BLOWGUN ,NDESCBIT>
		      <TELL " suddenly extracts">)>
	       <TELL THE ,BLOWGUN " and aims it at you!" CR>
	       <RTRUE>)
	      (T
	       ;<FSET? ,BLOWGUN ,TOUCHBIT>
	       <TELL
HIS .PER " jaw drops as" HIS .PER " hand comes out, empty." CR>
	       <RTRUE>)>)
       (<EQUAL? .OBJ ,ACCIDENT>
	<TELL "\"You'd best ask Jack about that, or " 'BUTLER ".\"" CR>)
       (<EQUAL? .OBJ ,BELL>
	<TELL
"\"It's actually a ship's bell off an old British man-o'-war.\""
;" that was part of Nelson's fleet at Trafalgar.\"" CR>)
       (<AND <EQUAL? .PER ,SEARCHER>
	     <ZERO? ,LIONEL-SPEAKS-COUNTER>
	     <SHOWING-CLUE? .OBJ>
	     <NOT <VERB? ASK-ABOUT>>>
	<QUEUE I-SEARCH 1>
	<TELL ,THATS-INTERESTING>
	<RTRUE>)
       (<EQUAL? .OBJ ,CORPSE>
	<TELL
!\" 'CORPSE " was never recovered from the well. They think it
was carried out to sea by an underground tidal stream.\"" CR>)
       (<AND <EQUAL? .OBJ ,COSTUME ,BLOWGUN ,LENS-BOX>
	     <OR <AND <EQUAL? .PER ,PAINTER ,DOCTOR>	;"lie"
		      <EQUAL? ,VARIATION <GETP .PER ,P?CHARACTER>>>
		 <AND <EQUAL? .PER ,DEB>		;"truth"
		      <EQUAL? ,VARIATION ,FRIEND-C>>>
	     ;<EQUAL? ,VARIATION <GETP .PER ,P?CHARACTER>>>
	<SET OBJ <GET ,CHAR-ROOM-TABLE <+ 1 <GETP .PER ,P?CHARACTER>>>>
	<TELL D .PER "'s look changes to a puzzled and angry frown. ">
	<COND (<NOT <EQUAL? .PER ,LORD ,FRIEND>>
	       <TELL "\"You mean you found that ">
	       <COND (<EQUAL? ,HERE .OBJ> <TELL "here ">)>
	       <TELL "in my room?\"" HE .PER " gasps. ">)>
	<TELL
"\"How can I explain it when it doesn't belong to me? If you didn't
bring it ">
	<COND (<NOT <EQUAL? ,HERE .OBJ>> <TELL !\t>)>
	<TELL
"here " 'PLAYER ", then someone else planted it, trying to frame me as
the maniac who's been posing as " 'LOVER "'s ghost!\"" CR>)
       (<EQUAL? .OBJ ,COSTUME>
	<COND (<T? <GET ,FOUND-COSTUME ,PLAYER-C>>
	       <TELL "\"So that's how ">
	       <COND (<ZERO? ,CONFESSED>
		      <TELL "somebody">)
		     (T <TELL 'VILLAIN-PER>)>
	       <TELL " posed as a ghost!\"" CR>)>)
       (<EQUAL? .OBJ ,DINNER ,DINNER-2 ;,DINNER-3>
	<COND (<L? ,PRESENT-TIME ,DINNER-TIME>
	       <TELL "\"Tonight's a dinner in honor of ">
	       <COND (<==? .PER ,BUTLER>
		      <TELL "the late Lord ">)>
	       <TELL
"Lionel's birthday. In his will, he asked for these particular guests --
except ">
	       <COND (<==? .PER ,FRIEND> <TELL "me">)
		     (T <PRINTD ,FRIEND>)>
	       <TELL ", of course. It's at eight o'clock">
	       <COND (<NOT <==? .PER ,BUTLER>>
		      <TELL " -- or whenever " 'BUTLER " gets 'round to it">)>
	       <TELL ".\"" CR>)
	      (<EQUAL? <META-LOC ,DINNER> ,HERE>
	       <TELL "\"It looks delicious!\"" CR>)
	      (T
	       <COND (<==? <GETP .PER ,P?LDESC> 10 ;"eating with relish">
		      <TELL "\"I'm enjoying">)
		     (T <TELL "\"I enjoyed">)>
	       <TELL " it immensely.">
	       <COND (<T? ,MISSED-DINNER>
		      <TELL
" We started without you, as we assumed you were sleuthing.">)>
	       <TELL "\"" CR>)>)
       (<OR <EQUAL? .OBJ ,BRICKS ,COFFIN ,CRYPT>
	    <EQUAL? .OBJ ,DUNGEON ,IRON-MAIDEN ,TOMB>
	    <EQUAL? .OBJ ,WELL>>
	<TELL ,ANCIENT-SECRETS CR>)
       (<EQUAL? .OBJ ,JEWEL>
	<TELL CHE .PER>
	<COND (<AND <==? .PER ,FRIEND>
		    <FSET? ,EARRING ,LOCKED>>	;"matched to stone"
	       <TELL
" says, \"Oh, thank you for finding it! I've looked everywhere!\"" CR>
	       <RTRUE>)
	      (<==? ,HERE <META-LOC ,JEWEL>>
	       <TELL " looks at it with interest">
	       <COND (<EQUAL? .PER ,DEALER>
		      <TELL ", putting a monocle in one eye to see better">)>)
	      (T
	       <TELL " listens to your description of it">)>
	<TELL ". But" HE .PER " says" HE .PER " can't identify it." CR>)
       (<EQUAL? .OBJ ,LAMP>
	<TELL "\"I think " 'BUTLER " keeps">
	<IN-CASE-OF-BLACKOUT>
	<RTRUE>)
       (<AND <EQUAL? .OBJ ,LUGGAGE>
	     <IN? ,LUGGAGE ,BUTLER>>
	<TELL "\"Don't panic.">
	<BOLITHO-WILL>
	<TELL ".\"" CR>)
       (<EQUAL? .OBJ ,MACE>
	<TELL "\"That is a long story, ">
	<COND (<TITLE-NAME> <TELL !\.>)>
	<TELL
" When Lord Lionel was alive, he had a pit bulldog to protect the
castle. A right vicious brute it was, too! Several
times it attacked the servants, so the master gave out
these " 'MACE "s. Just press the button on the side, and it sprays
something foul. It always
worked a treat on that wretched dog, and I daresay it could stop a
ghost just as well.\"" CR>)
       (<EQUAL? .OBJ ,NECKLACE-OF-D>
	<TELL "\"The police returned it to ">
	<COND (<==? .PER ,LORD> <TELL "me">) (T <TELL 'LORD>)>
	<TELL " after the inquest.\"" CR>)
       (<SECRET-PASSAGE-OR-DOOR? .OBJ>
	<TELL-ABOUT-OBJECT .PER ,PASSAGE ,FOUND-PASSAGES>)
       ;(<EQUAL? .OBJ ,SERVANTS-QUARTERS>
	<COND (<IN? ,LETTER .PER>
	       <MOVE ,LETTER ,WINNER>
	       <TELL
"\"Just read this.\" " CHE .PER " hands you" THE ,LETTER "." CR>)
	      (T <TELL "\"Just read the " 'LETTER ".\"" CR>)>)
       (<EQUAL? .OBJ ,SKELETON>
	<TELL
"\"Ugh! Those must be the bones of the " 'GHOST-OLD "!\""
;"very first Lady Tresyllian. I suppose Lionel was morbid indeed if he
moved her bones here from the village.\"" CR>)
       (<TREASURE-FOUND? .OBJ .PER>
	<RTRUE>)
       (<EQUAL? .OBJ ,YOUR-ROOM>
	<TELL
"\"It's fortunate that one bedroom was available for you.\"" CR>)
       (<OR <EQUAL? .OBJ ,CASTLE>
	    <IN? .OBJ ,ROOMS>>
	<TELL "\"Oh, it is a lovely piece of real estate, ">
	<COND (<EQUAL? .PER ,FRIEND>
	       <TELL "isn't it">)
	      (T <TELL "what">)>
	<TELL !\?>
	<COND (<EQUAL? .PER ,DOCTOR ,PAINTER ,DEALER>
	       <TELL " Almost a shame to admit riffraff on weekends.">)>
	<TELL "\"" CR>)
       (<IN? .OBJ .PER>
	<TELL "\"I have it right here, ">
	<COND (<TITLE-NAME> <TELL !\.>)>
	<TELL "\"" CR>)>>

<ROUTINE SHOWING-CLUE? (OBJ)
 <COND (<EQUAL? .OBJ ,CLUE-1 ,CLUE-2>
	<RTRUE>)
       (<EQUAL? .OBJ ,CLUE-3 ,CLUE-4>
	<RTRUE>)
       (<AND <==? .OBJ ,MAGAZINE>
	     <EQUAL? ,VARIATION ,PAINTER-C>>
	<RTRUE>)>>

<ROUTINE TREASURE-FOUND? (OBJ PER "AUX" X)
 <COND (<AND ;<T? ,CLUE-1-KNOWN>
	     <OR <==? .OBJ ,TREASURE>
		 ;<AND <==? .OBJ ,BOTTLE> <IN? ,MOONMIST ,BOTTLE>>
		 <AND <==? .OBJ ,INKWELL> <IN? ,MOONMIST ,INKWELL>>>>
	;<SETG TREASURE-FOUND .OBJ>
	<FCLEAR .OBJ ,SECRETBIT>
	<TELL "\"That must be the " 'ARTIFACT "!">
	<SET X <TELL-STOP-SEARCHING? .PER>>
	<TELL "\"|">
	<COND (<OR <IN? <SET PER ,FRIEND> ,HERE>
		   <IN? <SET PER ,LORD> ,HERE>>
	       <COND (<NOT <==? .PER ,CONFESSED>>
		      ;<SET OBJ <GT-O .PER>>
		      <PUTP .PER ,P?LINE 0>
		      <THIS-IS-IT .PER>
		      <TELL
"\"That's super!\" adds " D .PER ". \"We can't thank you enough!">
		      <COND (<ZERO? .X>
			     <SET X <TELL-STOP-SEARCHING? .PER>>)>
		      <TELL "\"|">)>)>
	<COND (<AND <IN? ,SEARCHER ,HERE>
		    <ZERO? .X>
		    <TELL-STOP-SEARCHING? ,SEARCHER T T>>
	       <TELL "\" says " D ,SEARCHER ".|">)>
	<COND (<AND ;<T? ,CLUE-1-KNOWN>
		    <ZERO? ,TREASURE-FOUND>>
	       <CONGRATS ,ARTIFACT>)>
	<RTRUE>)>>

<ROUTINE TELL-STOP-SEARCHING? (PER "OPT" (COMMA <>) (NOSP <>) "AUX" OBJ)
	<COND (<AND <EQUAL? .PER ,SEARCHER>
		    <==? <GET <SET OBJ <GT-O .PER>> ,GOAL-FUNCTION>
			 ,X-SEARCHES>>
	       <PUT .OBJ ,GOAL-FUNCTION ,NULL-F>
	       ;<SETG SEARCHER <>>
	       ;<QUEUE I-SEARCH 0>
	       <COND (<ZERO? .NOSP> <TELL !\ >)
		     (T <TELL !\">)>
	       <TELL "Then that's the end of my searching">
	       <COND (<T? .COMMA> <TELL !\,>)
		     (T <TELL !\.>)>
	       <COND (<OR <NOT <SET OBJ <ZMEMQ ,HERE ,CHAR-ROOM-TABLE>>>
			  <NOT <==? .PER <GET ,CHARACTER-TABLE <- .OBJ 1>>>>>
		      <ESTABLISH-GOAL .PER ,SITTING-ROOM>)>
	       <RTRUE>)>>

<ROUTINE GOOD-SHOW (PER OBJ)
 <COND (<EQUAL? .PER ,GHOST-NEW ,CONFESSED>
	<RFALSE>)>
 <TELL !\">
 <COND (<==? ,VARIATION <GETP .PER ,P?CHARACTER>>
	<TELL "How nice">)
       (<==? .PER ,FRIEND>
	<TELL "That's keen">)
       (<1? <RANDOM 2>>
	<TELL "Well done">)
       (T <TELL "Good show">)>
 <TELL "! You found " A .OBJ !\!>
 <COND (<==? .OBJ ,TREASURE>
	<TELL-STOP-SEARCHING? .PER T>)>
 <TELL "\" says " D .PER "." CR>>

;<ROUTINE DISCRETION (P1 P2 ;"OPTIONAL" ;(P3 <>) "AUX" L2 ;L3)
	 <SET L2 <META-LOC .P2>>
	 ;<COND (<T? .P3> <SET L3 <META-LOC .P3>>)>
	 <COND (<NOT <==? ,HERE .L2>>
		<COND ;(<AND .P3 <==? ,HERE .L3>>
		       <SET P2 .P3>
		       <SET P3 <>>)
		      (T <RFALSE>)>)>
	 <TELL CHE .P1 " looks briefly toward" HIM .P2>
	 ;<COND (<AND .P3 <==? ,HERE .L3>>
	        <TELL " and" HIM .P3>)>
	 <TELL " and then speaks in a whisper." CR>>

<ROUTINE COMMON-DESC (PER)
	<TELL "He's a ">
	<COND (<==? .PER ,DOCTOR>
	       <TELL "middle-sized man in his fifties">
	       <COND (<IN? ,MUSTACHE ,DOCTOR> ;<ZERO? ,WENDISH-BARE>
		      <TELL ", with spectacles and a grizzled mustache">)>
	       <TELL "." CR>
	       <RTRUE>)>
	<TELL "tall">
	<COND (<==? .PER ,LORD>
	       <TELL ", handsome, dark-browed young man">
	       <COND (<G? ,BED-TIME ,PRESENT-TIME>
		      <TELL " in dinner jacket and black tie">)>)
	      (<==? .PER ,OFFICER>
	       <TELL " blond">
	       <COND (<G? ,BED-TIME ,PRESENT-TIME>
		      <TELL
", sporting a white dinner jacket and
scarlet cummerbund. He moves with the elegant swagger of a
Guards officer and young-man-about-Mayfair, both of which he is">)>)
	      (<==? .PER ,DEALER>
	       <TELL ", foppish art and antiques dealer">
	       <COND (<NOT <FSET? .PER ,MUNGBIT>>
		      <TELL
". Despite his languid
manner, you're aware of his penetrating glance. If you were
buying a used car from this man, you'd want to check it out carefully">)>)>
	<TELL "." CR>>

<ROUTINE COMMON-OTHER (PER "AUX" (X <>) N)
 <COND (<VERB? ASK> <RFALSE>)
       (<VERB? EXAMINE>
	<COND (<OR <EQUAL? .PER ,DOCTOR>
		   <EQUAL? .PER ,LORD ,OFFICER ,DEALER>>
	       <COMMON-DESC .PER>)
	      (<NOT <==? .PER ,GHOST-NEW>>
	       <TELL <GETP .PER ,P?TEXT> CR>)>
	;<THIS-IS-IT .PER>
	<COND (<AND <IN? .PER ,HERE>
		    <SET N <FIRST? .PER>>
		    <NOT <FSET? .N ,NDESCBIT>>>
	       <COND (<CARRY-CHECK .PER>
		      <SET X T>)>)>
	<COND (<FSET? .PER ,MUNGBIT>
	       <COND (<NOT <ZERO? .X>> <TELL "And">)>
	       <HE-SHE-IT .PER <NOT .X> "is">
	       ;<SET X T>
	       <PRINTC 32>
	       <TELL <GET ,LDESC-STRINGS <GETP .PER ,P?LDESC>> "." CR>)
	      ;(<NOT <FSET? .PER ,PERSONBIT>>
	       <COND (<NOT <ZERO? .X>> <TELL "And">)>
	       <FSET .PER ,PERSONBIT>
	       <HE-SHE-IT .PER <NOT .X> "is">
	       <FCLEAR .PER ,PERSONBIT>
	       <SET X T>
	       <TELL " dead." CR>)>
	<COND (<EQUAL? .PER ,DEALER>
	       <COND (<AND <EQUAL? <LOC ,LORD> ,HERE ,PSEUDO-OBJECT>
			   <=? <GETP ,DEALER ,P?LDESC> 2>
			   <ZERO? <GETP ,LORD ,P?LINE>>>
		      <TELL
"\"Montague began appraising the art works in the castle for Uncle
Lionel before he died,\" explains " 'LORD ". \"I've asked him to continue
and make up a catalog.\"" CR>)>)
	      (<EQUAL? .PER ,PAINTER>
	       <COND (<EQUAL? <LOC ,FRIEND> ,HERE ,PSEUDO-OBJECT>
		      <SET X ,FRIEND>)
		     (T <SET X <FIND-FLAG-HERE ,PERSONBIT ,PLAYER ,PAINTER>>)>
	       <COND (<AND <T? .X>
			   <==? <LOC ,PAINTER> ,DRAWING-ROOM>>
		      <TELL
"\"Vivien painted that portrait of " 'LOVER " Hallam, the girl who drowned
in the castle well,\" says " D .X ". She gestures to a framed picture
hanging by the " 'FIREPLACE "." CR>)>)>
	<RTRUE>)
       (<AND <EQUAL? ,PRSO .PER> <VERB? SHOW>>
	<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI>
	<RTRUE>)>>

<ROUTINE UNSNOOZE (PER "OPTIONAL" (NO-TELL? <>)
		       "AUX" RM GT (C <GETP .PER ,P?LDESC>))
 <COND (<EQUAL? .C 14 ;"asleep">
	<FIX-MUSTACHE .PER>
	<SET C <GETP .PER ,P?CHARACTER>>
	<SET GT <GET ,GOAL-TABLES .C>>
	<PUT .GT ,ATTENTION <GET .GT ,ATTENTION-SPAN>>
	<PUT .GT ,GOAL-ENABLE 0>
	<PUT .GT ,GOAL-FUNCTION ,X-RETIRES>
	<PUT .GT ,GOAL-S T>	;"so GOAL-REACHED will work"
	<SET RM <GET ,CHAR-ROOM-TABLE <+ 1 .C>>>
	<COND (<NOT <IN? .PER .RM>>
	       <ESTABLISH-GOAL .PER .RM>)>
	<COND ;(<EQUAL? .PER ,GHOST-NEW>
	       <PUTP .PER ,P?LDESC 0>)
	      (<EQUAL? ,VARIATION .C>
	       <PUTP .PER ,P?LDESC 4 ;"looking at you with suspicion">)
	      (T <PUTP .PER ,P?LDESC 25 ;"looking sleepy">)>
	<FCLEAR .PER ,MUNGBIT>
	<SET RM <META-LOC .PER>>
	<COND (<AND <IN? .PER ,HERE> <ZERO? .NO-TELL?>>
	       <TELL CHE .PER " wakes up first. ">
	       ;<THIS-IS-IT .PER>
	       <COND (<NOT <FSET? .RM ,ONBIT>>
		      <TELL CHE .PER " turns on the light. ">)>)>
	<FSET .RM ,ONBIT>
	<RTRUE>)
       (<AND <EQUAL? .C 19 ;"out cold">
	     <ZERO? <GET ,SHOT <GETP .PER ,P?CHARACTER>>>>
	<FIX-MUSTACHE .PER>
	<QUEUE I-COME-TO 0>
	<I-COME-TO>
	<RTRUE>)>>

<ROUTINE FIX-MUSTACHE (PER)
	<COND (<AND <==? .PER ,DOCTOR>
		    <EQUAL? ,VARIATION ,DOCTOR-C>>
	       <FCLEAR ,MUSTACHE ,TAKEBIT>
	       <FSET ,MUSTACHE ,TRYTAKEBIT>)>>

<OBJECT OBJECT-PAIR
	(DESC "such things")
	(ACTION OBJECT-PAIR-F)>

<ROUTINE OBJECT-PAIR-F ("AUX" P1 P2)
 <COND (<L? 2 <GET/B ,P-PRSO ,P-MATCHLEN>>
	<SETG CLOCK-WAIT T>
	<TELL
"(That's too many things to compare all at once!)" CR>
	<RTRUE>)
       (T
	<PERFORM ,PRSA <GET/B ,P-PRSO 1> <GET/B ,P-PRSO 2>>
	<RTRUE>)>>

<OBJECT CREW-GLOBAL
	(IN GLOBAL-OBJECTS)
	(DESC "bunch of guests")
	(SYNONYM BUNCH GUESTS)
	(FLAGS SEENBIT)
	(ACTION CREW-GLOBAL-F)>

<ROUTINE CREW-GLOBAL-F ("AUX" L)
 <COND (<AND <QUEUED? ,I-TOUR>
	     <VERB? WALK-TO>>
	<PERFORM ,PRSA <GET ,TOUR-PATH ,TOUR-INDEX>>
	<RTRUE>)
       (<NOT <ALL-TOGETHER-NOW?>>
	<SETG CLOCK-WAIT T>
	<TELL "(The guests aren't all together!)" CR>
	<RFATAL>)
       (<VERB? EXAMINE>
	<TELL "There are seven people, not counting you." CR>)
       (<VERB? ;GOODBYE HELLO>
	<TELL CTHE ,PRSO " nods at you." CR>)
       (T ;<SPEAKING-VERB? ,CREW-GLOBAL>
	<TELL "You'd better stick to one guest at a time." CR>
	<RFATAL>)>>
