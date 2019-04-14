"THINGS for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

<OBJECT PSEUDO-OBJECT
	(IN LOCAL-GLOBALS)
	(DESC "pseudo")		;"Place holder (MUST BE 6 CHARACTERS!!!!!)"
	(ACTION NULL-F)		;"Place holder"
	(FLAGS SEENBIT)>

<ROUTINE RANDOM-PSEUDO ()
 <COND (<VERB? ASK-ABOUT ASK-CONTEXT-ABOUT LOOK-BEHIND LOOK-UNDER TELL-ABOUT>
	<RFALSE>)
       (<VERB? EXAMINE LOOK-INSIDE SEARCH>
	<NOTHING-SPECIAL>
	<RTRUE>)
       (T
	<WONT-HELP>
	;<TELL "You can't do anything useful with that." CR>)>>

<OBJECT LUGGAGE
	(IN CAR)
	(DESC "your luggage")
	(ADJECTIVE MY)
	(SYNONYM LUGGAGE BAG CASE SUITCASE)
	(FLAGS CONTBIT SEARCHBIT TAKEBIT NARTICLEBIT)
	;(LDESC "Your luggage is here.")
	(CAPACITY 88)
	(SIZE 30)
	(ACTION LUGGAGE-F)>

<ROUTINE LUGGAGE-F ("OPTIONAL" (RARG <>))
	 <COND (<REMOTE-VERB?> <RFALSE>)
	       (<AND <VERB? TAKE MOVE>
		     <EQUAL? ,PRSO ,LUGGAGE>
		     <FSET? <LOC ,LUGGAGE> ,PERSONBIT>
		     ;<NOT <IN? ,LUGGAGE ,PLAYER>>>
		<RFALSE>)
	       (<AND <FSET? <LOC ,LUGGAGE> ,PERSONBIT>
		     <NOT-HOLDING? ,LUGGAGE>>
		<RTRUE>)>>

<OBJECT BROCHURE
	(IN LUGGAGE)
	(DESC "tourist brochure")
	(ADJECTIVE TOURIST)
	(SYNONYM BROCHURE BOOK BOOKS ;BOOKLET ;GUIDE)
	(GENERIC GENERIC-BOOK)
	(FLAGS TAKEBIT READBIT ;BURNBIT)
	(SIZE 2)
	(ACTION BROCHURE-F)>

;<ROUTINE SCREENPLAY () <TELL "Screenplay by Jim Lawrence" CR>>

<ROUTINE BROCHURE-F ("AUX" X)
 <COND (<VERB? ANALYZE ASK-ABOUT ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR ASK-FOR
	       DESCRIBE EXAMINE LOOK-INSIDE LOOK-UP OPEN READ TELL-ABOUT>
	<TELL
"[You'll find the " D ,BROCHURE " in your " D ,MOONMIST " package.]" CR>
	;"<TELL '|
But this copy has a scribbled note:||'>
	<SET X <RANDOM 2>>
	<COND (<1? .X> <SCREENPLAY>)>
	<TELL '  Directed by Stu Galley|'>
	<COND (<NOT <1? .X>> <SCREENPLAY>)>")>>

;<OBJECT PRINT-KIT
	(IN LUGGAGE)
	(DESC "fingerprint kit")
	(ADJECTIVE FINGER)
	(SYNONYM KIT)
	(FLAGS TAKEBIT)
	(SIZE 6)
	(ACTION PRINT-KIT-F)>

;<ROUTINE PRINT-KIT-F ()
 <COND (<VERB? OPEN CLOSE>
	<NO-NEED>)
       (<VERB? USE>
	<COND (,PRSI
	       <PERFORM ,V?ANALYZE ,PRSI ,FINGERPRINTS>
	       <RTRUE>)
	      (T
	       <SETG CLOCK-WAIT T>
	       <TELL "(You didn't say what to use it on.)" CR>)>)>>

<OBJECT BLOWGUN
	(DESC "blowgun")
	;(IN VILLAIN)
	(ADJECTIVE BLOW ;POISON)
	(SYNONYM GUN BLOWGUN ;DART)
	(FLAGS WEAPONBIT TAKEBIT SECRETBIT)
	(SIZE 9)
	(ACTION BLOWGUN-F)>

<ROUTINE BLOWGUN-F ()
 <COND (<VERB? EXAMINE>
	<COND ;(<NOUN-USED? ,W?DART>
	       )
	      (<QUEUED? ,I-SHOT>
	       <TELL "It's pointing right at you!" CR>)
	      (T <TELL
"It's a bamboo tube, two feet long and as thin as a small snake." CR>)>)
       (<VERB? LOOK-INSIDE LOOK-THROUGH ;OPEN>
	<COND (<FSET? ,BLOWGUN ,MUNGBIT>
	       <TELL "It's empty." CR>)
	      (T <TELL "There's a" ,POISON-DART " inside." CR>)>)
       (T
	<COND (<VERB? EMPTY>
	       <SETG PRSA ,V?USE>)>
	<SHOOTING ,BLOWGUN>)>>

<GLOBAL POISON-DART " poison dart">

<ROUTINE NO-VIOLENCE? (OBJ "AUX" P)
	<COND (<VERB? ATTACK KILL SHOOT SLAP>
	       <SET P ,PRSO>)
	      (T <SET P ,PRSI>)>
	<COND (<ZERO? .P>
	       <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>)>
	<COND (<ZERO? .P>
	       <SETG CLOCK-WAIT T>
	       <TELL "(You didn't say whom to use it on!)" CR>
	       <RFALSE>)>
	<COND (<AND <NOT <EQUAL? .P ,GHOST-NEW>>
		    <OR <NOT ,VILLAIN-KNOWN?>
			<NOT <EQUAL? .P ,VILLAIN-PER>>>>
	       <TELL ,NO-VIOLENCE>
	       <RFALSE>)
	      (<FSET? .P ,MUNGBIT>
	       <TELL ,NO-VIOLENCE>
	       <RFALSE>)
	      (<AND <NOT <EQUAL? ,VILLAIN-PER ,LOVER ;,LORD>>
		    <NOT <QUEUED? ,I-SHOT>>>
	       <TELL ,NO-VIOLENCE>
	       <RFALSE>)
	      (<NOT <ZERO? ,LIONEL-SPEAKS-COUNTER>>
	       <TELL-BAD-FORM>
	       <RFALSE>)
	      (T
	       <SETG SHOOTER <>>
	       <QUEUE I-SHOT 0>
	       <COND (<EQUAL? ,VILLAIN-PER ,LOVER ;,LORD>
		      <GHOST-FLEES>
		      <RFALSE>)>
	       ;<COND (<==? .P ,FOLLOWER>
		      <SETG FOLLOWER 0>)>
	       <FSET .P ,MUNGBIT>
	       <FCLEAR .P ,NDESCBIT>
	       <PUTP .P ,P?LDESC 19 ;"out cold">
	       <PUT <GT-O .P> ,ATTENTION 0>
	       <COND (<==? .P ,GHOST-NEW>
		      <PUT <GT-O ,VILLAIN-PER> ,ATTENTION 0>)>
	       <COND (<EQUAL? .OBJ ,CANE ,WAR-CLUB ,MACE>
		      <QUEUE I-COME-TO <+ 9 <RANDOM 6>>>)
		     (T
		      <PUT ,SHOT <GETP .P ,P?CHARACTER> T>
		      <COND (<==? .P ,GHOST-NEW>
			     <PUT ,SHOT <GETP ,VILLAIN-PER ,P?CHARACTER> T>)>)>
	       <PUTP .P ,P?LINE <+ 3 <GETP .P ,P?LINE>>>
	       <TELL CHE .P>
	       <COND (<IN? ,BLOWGUN .P>
		      <FSET ,BLOWGUN ,TAKEBIT>
		      <FCLEAR ,BLOWGUN ,NDESCBIT>
		      <MOVE ,BLOWGUN ,HERE>
		      <TELL " drops" THE ,BLOWGUN " and">)>
	       <COND (<==? .OBJ ,MACE>
		      <TELL
" claps both hands over" HIS .P " mouth and nose. " CHIS .P " face
takes on a greenish pallor, and strangled noises issue from" HIS .P
" throat">)
		     (T <TELL
" looks surprised and stunned. Then" HIS .P " eyes flutter">)>
	       <TELL ". Next moment" HE .P " collapses " <GROUND-DESC> "!|">
	       .P)>>

<ROUTINE SHOOTING (OBJ "AUX" (P <>) ;GT)
 <COND (<ATTACK-VERB? T>
	<COND ;(<EQUAL? .P ,PLAYER>
	       <HAR-HAR>
	       <RTRUE>)
	      (<ZERO? <NO-VIOLENCE? .OBJ>>
	       <RTRUE>)>
	<COND (<==? .OBJ ,BLOWGUN>
	       <FSET ,BLOWGUN ,MUNGBIT>)>
	;<COND (<T? <SET P <FIND-FLAG-HERE ,PERSONBIT ,PLAYER .P>>>
	       <TELL
CHE .P " can hardly believe" HIS .P " eyes. " CHE .P " holds you from behind,
saying, \"I do believe you're mad! But we can detain you until the police
arrive.\"|
As indeed they do. You ought to be more careful with weapons!|">
	       <FINISH>)>
	<RTRUE>)>>

<OBJECT MACE
	(DESC "aerosol device")
	(IN BUTLER)
	(ADJECTIVE AEROSOL DOG ;DETERRENT)
	(SYNONYM DEVICE SPRAY BUTTON WEAPON ;MACE)
	(FLAGS TAKEBIT VOWELBIT WEAPONBIT NDESCBIT)
	(TEXT "It says, \"JUST PRESS THE BUTTON.\"")
	(SIZE 2)
	(ACTION MACE-F)>

<ROUTINE MACE-F ("AUX" (P <>))
 <COND (<VERB? PUSH>
	<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,PLAYER>>
	<COND (<AND <QUEUED? ,I-SHOT>
		    <T? .P>>
	       <PERFORM ,V?SHOOT .P ,MACE>
	       <RTRUE>)>
	<TELL "The " 'MACE " emits a foul-smelling spray.">
	<COND (<T? .P>
	       <TELL !\  CHE .P" says, \"Have a care! You almost shot me!\"">)>
	<CRLF>)
       (<VERB? SMELL>
	<TELL "It smells foul!" CR>)
       (T <SHOOTING ,MACE>)>>

<OBJECT NECKLACE-OF-D
	(IN LOCAL-GLOBALS)
	(DESC "Deirdre's necklace")
	(ADJECTIVE ;DEIRDRE DEE\'S HER RED)
	(SYNONYM NECKLACE STRING SETTING SOCKET)
	(FLAGS NARTICLEBIT TAKEBIT NDESCBIT ;WEARBIT CONTBIT SECRETBIT OPENBIT)
	(CAPACITY 1)
	(SIZE 5)
	(ACTION NECKLACE-OF-D-F)>

<GLOBAL CLASP-MUNGED " the lips of the clasp are sprung apart">

<ROUTINE NECKLACE-OF-D-F ()
 <COND (<VERB? OPEN CLOSE>
	<YOU-CANT>)
       (<AND <VERB? COMPARE HOLD-UP PUT PUT-IN>
	     ;<EQUAL? ,VARIATION ,LORD-C>
	     <EQUAL? ,JEWEL ,PRSO ,PRSI>>
	<COND (<VERB? PUT-IN>
	       <MOVE ,JEWEL ,NECKLACE-OF-D>)>
	<TELL
"The " 'JEWEL " fits the empty socket and matches the other red stones." CR>)
       (<VERB? PUT-IN>
	<COND (<IOBJ? NECKLACE-OF-D>
	       <TOO-BAD-BUT ,PRSO "too big">)>)
       (<VERB? FIX>
	<YOU-CANT>)
       (<VERB? EXAMINE>
	<TELL
"It's a slender string of small, sparkling red, nonprecious stones. You
notice that" ,CLASP-MUNGED ", as if the clasp had been pulled open by
force.">
	<COND (<AND <NOT <IN? ,JEWEL ,NECKLACE-OF-D>>
		    ;<EQUAL? ,VARIATION ,LORD-C>>
	       <TELL
" You also notice an empty socket or setting, from which one of the red stones
is missing.">)>
	<CRLF>)
       (<OR <VERB? WEAR>
	    <AND <VERB? PUT> <FSET? ,PRSI ,PERSONBIT>>>
	<WEAR-SCARE>)>>

<OBJECT JEWEL
	(DESC "tiny red jewel")
	(ADJECTIVE TINY RED ;GLITTERING MISSING)
	(SYNONYM JEWEL SPECK GEM STONE)
	(FLAGS TAKEBIT SEENBIT)
	(SIZE 1)>
[
<OBJECT LENS
	(IN LENS-BOX)
	(DESC "contact lens")
	(ADJECTIVE CONTACT FIRST)
	(SYNONYM LENS LENSES)
	(FLAGS TAKEBIT ;SEENBIT ;NDESCBIT WEARBIT TRANSBIT)
	(SIZE 1)
	;(ACTION LENS-F)>

<OBJECT LENS-1
	(DESC "first contact lens")
	(ADJECTIVE FIRST CONTACT)
	(SYNONYM LENS LENSES)
	(GENERIC GENERIC-LENS)
	(FLAGS TAKEBIT SEENBIT ;NDESCBIT WEARBIT TRANSBIT ;TOUCHBIT)
	(SIZE 1)
	;(ACTION LENS-F)>

;<ROUTINE LENS-F ()
 <COND (<VERB? WEAR>
	<TELL "Your head starts to ache, so you remove it." CR>)>>

<OBJECT LENS-2
	(DESC "second contact lens")
	(ADJECTIVE SECOND CONTACT)
	(SYNONYM LENS LENSES)
	(GENERIC GENERIC-LENS)
	(FLAGS TAKEBIT ;SEENBIT ;NDESCBIT WEARBIT TRANSBIT ;TOUCHBIT)
	(SIZE 1)
	(ACTION LENS-2-F)>

<ROUTINE LENS-2-F ()
 <COND (<AND <VERB? COMPARE>
	     <EQUAL? ,LENS-1 ,PRSO ,PRSI>>
	<TELL "As near as you can tell, they're a matched set." CR>)
       ;(T <LENS-F>)>>

<OBJECT LENS-BOX
	(DESC "small plastic box")
	(ADJECTIVE SMALL PLASTIC LENS)
        (SYNONYM BOX)
	(GENERIC GENERIC-BOX)
	(FLAGS NDESCBIT CONTBIT SEARCHBIT ;TRANSBIT SECRETBIT)
	(CAPACITY 2)
	(SIZE 3)
	(ACTION LENS-BOX-F)>

<ROUTINE LENS-BOX-F ("AUX" X)
 <COND (<VERB? EXAMINE LOOK-INSIDE OPEN>
	<COND (<AND <FSET? ,LENS ;-1 ,SEENBIT>
		    <T? <SET X <LOC ,LENS>>>
		    ;<NOT <IN? ,LENS ,LENS-BOX>>>
	       <MOVE ,LENS-1 .X>
	       <REMOVE ,LENS>)>
	<FSET ,LENS-BOX ,OPENBIT>
	<TELL
"You lift the hinged cover. Inside is a bed of moist foam rubber">
	<SET X <FIRST? ,LENS-BOX>>
	<COND (<T? .X>
	       <TELL ", holding">
	       <PRINT-CONTENTS ,LENS-BOX>)>
	<TELL
". It's obvious that the box will hold two lenses." ;" You close it again."
CR>)>>
]
<OBJECT LETTER
	(IN BUTLER)
	(DESC "butler's note")
	(ADJECTIVE B\'S HIS JACK\'S ;"BUTLER BOLITHO JACK")
	(SYNONYM ;LETTER NOTE NOTES)
	(FLAGS SEENBIT NDESCBIT ;TAKEBIT READBIT)
	(SIZE 2)
	(ACTION LETTER-F)>

<ROUTINE LETTER-F ()
 <COND (<OR <VERB? EXAMINE LOOK-INSIDE READ>
	    <AND <VERB? SHOW> <NOT <FSET? ,LETTER ,TOUCHBIT>>>>
	<COND (<NOT-HOLDING? ,LETTER>
	       <RTRUE>)>
	<FSET ,LETTER-MAID ,SEENBIT>
	<TELL
"It says,|
\"Your Lordship:|
Following instructions in your late Uncle
Lionel's will, the other servants and I have left the castle after sounding
the dinner gong. We shall remain away until tomorrow morning.|
I regret to inform you that Gladys, the " 'MAID ", will not return
with the rest of us. She wrote a note to Your Lordship
explaining the reason. She told me
that she put it on the " 'WRITING-DESK " in the " 'SITTING-ROOM ".|
(signed) " 'BUTLER ".\"" CR>)>>

<OBJECT LETTER-MAID
	(IN WRITING-DESK)
	(DESC "maid's note")
	(ADJECTIVE MAID\'S HER ;"MAID GLADYS")
	(SYNONYM ;LETTER NOTE NOTES)
	(FLAGS NDESCBIT ;TRYTAKEBIT TAKEBIT READBIT)
	(SIZE 2)
	(ACTION LETTER-MAID-F)>

<ROUTINE LETTER-MAID-F ()
 <COND (<REMOTE-VERB?>
	<RFALSE>)>
 <FCLEAR ,LETTER-MAID ,NDESCBIT>
 <COND (<OR <VERB? EXAMINE LOOK-INSIDE READ>
	    <AND <VERB? SHOW> <NOT <FSET? ,LETTER-MAID ,TOUCHBIT>>>>
	<COND (<NOT-HOLDING? ,LETTER-MAID>
	       <RTRUE>)>
	<TELL
"It says, \"Today while cleaning the room of a certain person who shall
be nameless, I was SHOCKED to discover SUMMING DREDFUL!|
I hope I knows me place, Your Lordship, but I was brought up to be a
PERFECKLY RESPECTABLE young woman, and I cannot go on working under the
same roof where such WICKEDNESS takes place.|
I am not the type of girl given to idle gossip, so I will only say this.
Maybe there is more reason than ANYONE SUSPECKS why that so-called ghost
prowls about the castle at night, if you know what I mean.|">
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <TELL
"I am not the type who peeks through " 'KEYHOLE "s, either, but maybe it is
high time someone did">)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <TELL
"Maybe you will also be surprised to learn that a certain pet shop in
Frobzance sells more than just harmless puppies, kittens, and budgies">)
	      ;(<EQUAL? ,VARIATION ,DEALER-C>
	       <TELL
"I like a pretty picture meself, but at least I know what's mine and
what's not">)
	      (<EQUAL? ,VARIATION ,PAINTER-C ,DOCTOR-C>
	       <TELL
"Me Dad always says that the first sign of a nut case is when a person
starts talking to hisself. Well, if you was to ask me, there is more than
one way to talk to " 'PLAYER ". Some does it on paper, and that is the type
person to watch out for">)
	      ;(<EQUAL? ,VARIATION ,OFFICER-C>
	       <TELL
"I lay a wager meself now and again, but at least I use me own money">)>
	<TELL "!\"" CR>)>>

<OBJECT LETTER-DEE
	;(IN BUTLER)
	(DESC "Deirdre's note")
	(ADJECTIVE DEE\'S HER ;"DEE DEIRDRE")
	(SYNONYM NOTE NOTES)
	(FLAGS NARTICLEBIT NDESCBIT SECRETBIT ;TAKEBIT READBIT)
	(SIZE 2)
	(ACTION LETTER-DEE-F)>

<ROUTINE LETTER-DEE-F ()
 <COND (<OR <VERB? EXAMINE LOOK-INSIDE READ>
	    <AND <VERB? SHOW> <NOT <FSET? ,LETTER-DEE ,TOUCHBIT>>>>
	<COND (<NOT-HOLDING? ,LETTER-DEE>
	       <RTRUE>)>
	<TELL
"The writing is thick with loops and curls. It says,|
\"Dear Uncle Lionel,|
I'm writing this on the train, coming up from London, where I saw
Grandpapa in the clinic. He's so frightfully ill! I know " 'DOCTOR " is
your old friend, but I can't help thinking his 'special treatments' are
making Grandpapa worse, not better. Would you be a dear and find out
just what he's doing there? I'd be ever so grateful!|
Love,|
" 'LOVER ".\"" CR>)>>
