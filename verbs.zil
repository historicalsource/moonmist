"VERBS for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

<ROUTINE TRANSCRIPT (STR)
	<TELL "Here " .STR "s a transcript of interaction with" CR>>

<ROUTINE V-SCRIPT ()
	<LOWCORE FLAGS <BOR <LOWCORE FLAGS> 1>>
	<TRANSCRIPT "begin">
	<V-VERSION>
	<RTRUE>>

<ROUTINE V-UNSCRIPT ()
	<TRANSCRIPT "end">
	<V-VERSION>
	<LOWCORE FLAGS <BAND <LOWCORE FLAGS> -2>>
	<RTRUE>>

<ROUTINE V-$VERIFY ()
 <COND (<T? ,PRSO>
	<COND (<AND <EQUAL? ,PRSO ,INTNUM>
		    <EQUAL? ,P-NUMBER 105>>
	       <TELL N ,SERIAL CR>)
	      (T <DONT-UNDERSTAND>)>)
       (T
	<TELL "Verifying disk..." CR>
	<COND (<VERIFY> <TELL "The disk is correct." CR>)
	      (T <TELL
"Oh, oh! The disk seems to have a defect. Try verifying again. (If
you've already done that, the disk surely has a defect.)" CR>)>)>>

<GLOBAL VARIATION:NUMBER 0>

%<DEBUG-CODE [
<ROUTINE V-$CHEAT ("AUX" (N 0) CH)
	 <COND (<OR <NOT <DOBJ? INTNUM>>
		    <NOT <EQUAL? ,P-NUMBER 1 2 3>>>
		<SETG CLOCK-WAIT T>
		<TELL "{Try $CHEAT 1, 2 or 3.}" CR>
		<RTRUE>)>
	 <COND (<NOT <EQUAL? ,PRESENT-TIME %,PRESENT-TIME-ATOM>>
		<TELL "Don't you want to restart first?">
		<COND (<YES?> <RESTART>)
		      (T <TELL "Okay, but this may not work!" CR>)>)>
	 <COND (<ZERO? <GETB ,LAST-NAME 0>>
		<REPEAT ()
			<COND (<IGRTR? N 8> <RETURN>)
			      (<ZERO? <SET CH <GETB 0 <+ .N 55>>>> <RETURN>)
			      (T <PUTB ,FIRST-NAME .N <+ .CH *40*>>)>>
		<COND (<1? .N> <SET N 2>)>
		<PUTB ,FIRST-NAME 0 <- .N 1>>
		<PUTB ,LAST-NAME 0 6>
		;<TELL "Full name? ">
		;<GET-NAME>
		<TELL "Favorite color? ">
		<GET-COLOR>
		<TELL CR>)>
	 <FSET ,DRIVEWAY ,TOUCHBIT>
	 <FSET ,FRONT-GATE ,LOCKED>
	 <QUEUE I-DRAGON-EYE 0>
	 <COND (<EQUAL? ,P-NUMBER 1>
		<GATE-OPENS>
		<GOTO ,COURTYARD>)
	       (<EQUAL? ,P-NUMBER 2 3>
		<QUEUE I-FRIEND-GREETS 0>
		<SET N ,CHARACTER-MAX>
		<REPEAT ()
			<SET CH <GET ,CHARACTER-TABLE .N>>
			<FSET .CH ,TOUCHBIT>
			<FCLEAR .CH ,NDESCBIT>
			<COND (<DLESS? N 1> <RETURN>)>>
		<PUT <GT-O ,BUTLER> ,GOAL-ENABLE 0>
		<MOVE ,LUGGAGE ,BED>
		<MOVE ,BUTLER ,YOUR-ROOM>
		<COND (<EQUAL? ,P-NUMBER 2>
		       ;<SETG BUTLER-HINTS-COUNTER 1>
		       <QUEUE I-BUTLER-HINTS 2 ;-1>
		       <QUEUE I-BUTLER-COOKS 9>
		       <FCLEAR ,BUTLER ,NDESCBIT>
		       <GOTO ,YOUR-ROOM>)
		      (T
		       ;<QUEUE I-PRE-DINNER 0>
		       <QUEUE I-DINNER 0>
		       <SETG SCORE 0>
		       <SETG PRESENT-TIME ,BED-TIME>
		       <QUEUE I-BEDTIME 1>
		       <MOVE ,BUTLER ,LOCAL-GLOBALS>
		       <MOVE ,LAMP ,PLAYER>
		       <MOVE ,MACE ,PLAYER>
		       <FCLEAR ,MACE ,NDESCBIT>
		       <GOTO ,GREAT-HALL>)>)>>

<ROUTINE V-$GENDER ()
	 <TELL "{Your gender is ">
	 <COND (<OR <NOT <DOBJ? INTNUM>>
		    <NOT <EQUAL? ,P-NUMBER 1 2 3>>>
		<COND (<ZERO? ,GENDER-KNOWN>	<TELL "neuter">)
		      (<FSET? ,PLAYER ,FEMALE>	<TELL "female">)
		      (T			<TELL "male">)>)
	       (T
		<TELL "now ">
		<COND (<EQUAL? ,P-NUMBER 1>
		       <SETG GENDER-KNOWN T>
		       <FSET ,PLAYER ,FEMALE>
		       <TELL "female (1)">)
		      (<EQUAL? ,P-NUMBER 2>
		       <SETG GENDER-KNOWN T>
		       <FCLEAR ,PLAYER ,FEMALE>
		       <TELL "male (2)">)
		      (T
		       <SETG GENDER-KNOWN <>>
		       <TELL "neuter (3)">)>)>
	 <TELL ".}" CR>>

<GLOBAL IDEBUG:FLAG <>>
<ROUTINE V-$GOAL ("AUX" (CNT 0) O L C S)
 <REPEAT ()
  <COND (<G? <SET CNT <+ .CNT 1>> ,GHOST-NEW-C ;,CHARACTER-MAX>
	 <RETURN>)>
  <SET C <GET ,CHARACTER-TABLE .CNT>>
  <SET O <GET ,GOAL-TABLES .CNT>>
  <SET S <GET .O ,GOAL-S>>
  <COND (<AND <SET L <LOC .C>> <NOT <ZERO? .S>>>
	 <TELL D .C " (in " D .L "): " D .S>
	 <SET L <GET .O ,GOAL-F>>
	 <COND (<NOT <EQUAL? .S .L>>
		<TELL " F:" D .L>)>
	 <SET L <GET .O ,GOAL-I>>
	 <COND (<NOT <ZERO? .L>>
		<SET L <GET ,TRANSFER-TABLE .L>>
		<COND (<ZERO? .L> <TELL " I:0">)
		      (T
		       <TELL " I:" D .L>)>)>
	 <COND (<ZERO? <GET .O ,GOAL-ENABLE>>
		<TELL " (DISABLED)">)>
	 <PRINTC 32>
	 <APPLY <GET .O ,GOAL-FUNCTION> ,G-DEBUG>
	 <CRLF>)>>>

<ROUTINE V-$QUEUE ("AUX" C E TICK)
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E> <RETURN>)
		       (<AND <NOT <ZERO? <GET .C ,C-ENABLED?>>>
			     <NOT <ZERO? <SET TICK <GET .C ,C-TICK>>>>>
			<APPLY <GET .C ,C-RTN> ,G-DEBUG>
			<PRINTC 9>
			<TELL N .TICK CR>)>
		 <SET C <REST .C ,C-INTLEN>>>>

<ROUTINE V-$VARIATION ()
 <SETG CLOCK-WAIT T>
 <COND (<AND <EQUAL? ,PRSO ,INTNUM>
	     <L? ,P-NUMBER 5>
	     <G? ,P-NUMBER 0>>
	<SETG VARIATION ,P-NUMBER>
	<DO-VARIATION>
	<PRINTB <GET ,COLOR-WORDS ,VARIATION>>
	<TELL " variation" CR>)
       (<EQUAL? ,PRSO ,ROOMS>
	<PRINTB <GET ,COLOR-WORDS ,VARIATION>>
	<TELL " variation" CR>)
       (T
	<TELL "Wrong object!" CR>)>>

<ROUTINE V-$COMMAND ()
	 <DIRIN 1>
	 <RTRUE>>

<ROUTINE V-$RANDOM ()
	 <COND (<NOT <DOBJ? INTNUM>>
		<TELL "Illegal." CR>)
	       (T
		<RANDOM <- 0 ,P-NUMBER>>
		<RTRUE>)>>

<CONSTANT D-RECORD-ON 4>
<CONSTANT D-RECORD-OFF -4>

<ROUTINE V-$RECORD ()
	 <DIROUT ,D-RECORD-ON> ;"all READS and INPUTS get sent to command file"
	 <RTRUE>>

<ROUTINE V-$UNRECORD ()
	 <DIROUT ,D-RECORD-OFF>
	 <RTRUE>>

<GLOBAL DBUG:FLAG <>>
<ROUTINE V-DEBUG ()
 %<DEBUG-CODE <COND (<T? ,PRSO>
		     <SETG IDEBUG <NOT ,IDEBUG>>
		     <TELL !\{ N ,IDEBUG "}" CR>
		     <RTRUE>)>>
 <COND (<SETG DBUG <NOT ,DBUG>>
	<TELL "Find them bugs, boss!" CR>)
       (T <TELL "No bugs left, eh?" CR>)>>
]>

;<ROUTINE V-$WHERE ("AUX" (CNT 0) O L MSG)
 <COND ;(<ZERO? ,DBUG>
	<SET MSG <PICK-ONE ,UNKNOWN-MSGS>>
	<TELL <GET .MSG 0> "#wher" <GET .MSG 1> CR>)
       (<T? ,PRSI>
	<COND (<==? ,PRSI ,PLAYER>
	       <FSET ,PRSO ,TOUCHBIT>
	       <FCLEAR ,PRSO ,NDESCBIT>
	       <FCLEAR ,PRSO ,INVISIBLE>)>
	<MOVE ,PRSO ,PRSI>)
       (<T? ,PRSO>
	<TELL-$WHERE ,PRSO>)
       (T
	 <REPEAT ()
		 <COND (<SET O <GET ,CHARACTER-TABLE .CNT>>
			;<SET L <LOC .O>>
			<TELL-$WHERE .O>)>
		 <COND (<G? <SET CNT <+ .CNT 1>> ,GHOST-NEW-C ;,CHARACTER-MAX>
			<RETURN>)>>)>>

;<ROUTINE TELL-$WHERE (O "OPTIONAL" (L 0))
	<TELL D .O "	is ">
	<COND (<ZERO? .L> <SET L <LOC .O>>)>
	<COND (.L
	       <TELL "in">
	       <TELL THE .L>
	       <TELL "." CR>)
	      (T  <TELL "nowhere." CR>)>>

"ZORK game commands"

"SUBTITLE SETTINGS FOR VARIOUS LEVELS OF DESCRIPTION"

<GLOBAL VERBOSITY:NUMBER 1>	"0=SUPERB 1=BRIEF 2=VERBOS"

<ROUTINE YOU-WILL-GET (STR)
	<TELL "[Okay, you will get " .STR " descriptions.]" CR>>

<ROUTINE V-SUPER-BRIEF ()
	 <SETG VERBOSITY 0>
	 <YOU-WILL-GET "superbrief">>

<ROUTINE V-BRIEF ()
	 <SETG VERBOSITY 1>
	 <YOU-WILL-GET "brief">>

<ROUTINE V-VERBOSE ()
	<SETG VERBOSITY 2>
	<YOU-WILL-GET "verbose">
	<V-LOOK>>

<ROUTINE V-INVENTORY ()
	;<COND (<ZERO? ,LIT>
	       <TOO-DARK>
	       <RFATAL>)>
	<TELL CHE ,WINNER is " holding">
	<COND (<ZERO? <PRINT-CONTENTS ,WINNER>>	;"was PRINT-CONT"
	       <TELL " nothing">)>
	<TELL !\.>
	<COND ;(<AND <==? ,WINNER ,PLAYER>
		    <T? ,NOW-WEARING>>
	       <TELL !\ >
	       <PERFORM ,V?LOOK-INSIDE ,POCKET>)
	      (T <CRLF>)>>

<ROUTINE V-QUIT ("OPTIONAL" (ASK? T))
	 <V-SCORE>
	 <COND (<NOT .ASK?> <QUIT>)>
	 <TELL
"[If you want to continue from this point at another time, you must
\"SAVE\" first. Do you want to stop the story now?]">
	 <COND (<YES?> <QUIT>)
	       (T <TELL "Okay." CR>)>>

<ROUTINE V-RESTART ()
	 <V-SCORE>
	 <TELL "[Do you want to start over from the beginning?]">
	 <COND (<YES?>
		<RESTART>
		<TELL-FAILED>)
	       (T <TELL "Okay." CR>)>>

<ROUTINE TELL-FAILED ()
	<TELL
"[Sorry, but it didn't work. Maybe your instruction manual or Reference
Card can tell you why.]" CR>>

<ROUTINE V-SAVE ("AUX" X)
	 <PUTB ,OOPS-INBUF 1 0>
	 <SETG CLOCK-WAIT T>
	 <COND (<SET X <SAVE>>
	        <TELL "[Okay.]" CR>
		%<DEBUG-CODE <PROG ()
				   <TELL "{" ;"Note to Stu: ">
				   <TIME-PRINT ,PRESENT-TIME>
				   <TELL "}|">>>
		<V-FIRST-LOOK>)
	       (T
		<TELL-FAILED>)>
	 <RTRUE>>

<ROUTINE V-RESTORE ()
	 ;<TELL
"[Do you want to go back to a position you saved?]">
	 <COND ;(<NOT <YES?>>
		<TELL "Okay." CR>)
	       (<NOT <RESTORE>>
		<TELL-FAILED>
		<RFALSE>)>>

<ROUTINE V-FIRST-LOOK ()
	 <COND (<DESCRIBE-ROOM>
		<COND (<NOT <0? ,VERBOSITY>>
		       <DESCRIBE-OBJECTS>)>)>>

<ROUTINE V-VERSION ("AUX" (CNT 17) V)
	 <SET V <BAND <LOWCORE ZORKID> *3777*>>
	 <TELL D ,MOONMIST "|
Infocom interactive fiction - a mystery story|
Copyright (c) 1986 by Infocom, Inc.  All rights reserved." CR
D ,MOONMIST " is a trademark of Infocom, Inc.|
Release number " N .V " / Serial number ">
	 <LOWCORE-TABLE SERIAL 6 PRINTC>
	 <COND (<NOT <0? ,VARIATION>>
		<TELL " / ">
		<PRINTB <GET ,COLOR-WORDS ,VARIATION>>
		<TELL " variation">)>
	 <CRLF>
	 ;<PROG ()
		<TELL "{This fine game was made just for you, ">
		<SET CNT 55>
		<REPEAT ()
			<COND (<G? <SET CNT <+ .CNT 1>> 63>
			       <RETURN>)
			      (<ZERO? <SET V <GETB 0 .CNT>>>
			       <RETURN>)
			      (T <PRINTC .V>)>>
		<TELL "!}" CR>>>

<GLOBAL TREASURE-FOUND:OBJECT <>>
<GLOBAL ARRESTED-THE-VILLAIN "arrested the villain">
<GLOBAL IDENTIFIED-THE-GHOST "identified the ghost">

<ROUTINE V-SCORE ("AUX" (N 0) I (FC <GET ,FOUND-COSTUME ,PLAYER-C>))
	<COND (<AND <T? ,CONFESSED>
		    <T? ,TREASURE-FOUND>
		    <T? .FC>>
	       <TELL "[Congratulations, "TN"! You've won the game!]" CR>
	       <RTRUE>)>
	<TELL "[Well, so far you've ">
	<COND (<ZERO? <GETB ,LAST-NAME 0>>
	       <TELL "just gotten started.]" CR>
	       <RTRUE>)>
	<TELL "met ">
	<COND (<FSET? ,LORD ,TOUCHBIT>
	       <TELL 'LORD " and ">)>
	<SET I <GET ,GUEST-TABLE 0>>
	<REPEAT ()
		<COND (<FSET? <GET ,GUEST-TABLE .I> ,TOUCHBIT>
		       <INC N>)>
		<COND (<DLESS? I 1> <RETURN>)>>
	<COND (<==? .N <GET ,GUEST-TABLE 0>> <TELL "all">)
	      (<0? .N> <TELL "none">)
	      (<1? .N> <TELL "one">)
	      (T <TELL "some">)>
	<TELL " of the guests">
	<COND (<T? ,WASHED>
	       <TELL ", washed up from your trip">)>
	<COND (<T? ,WRONG-OUTFIT>
	       <TELL ", worn the ">
	       <COND (<1? ,WRONG-OUTFIT> <TELL "proper">) (T <TELL "wrong">)>
	       <TELL " outfit to dinner">)>
	<COND (<T? <GET ,FOUND-PASSAGES ,PLAYER-C>>
	       <TELL ", discovered " 'PASSAGE "s">)>
	;<COND (<OR <NOT <FSET? ,COSTUME ,SEENBIT>>
		   <EQUAL? ,VARIATION ,PAINTER-C ,DOCTOR-C>>
	       <SET I "found ">)
	      (<EQUAL? ,VARIATION ,LORD-C>
	       <SET I "detected ">)
	      (T ;<EQUAL? ,VARIATION ,FRIEND-C>
	       <SET I "examined ">)>
	;<COND (<T? .FC>
	       <TELL ", " .I "a " ,COSTUME>)>
	<COND (<FSET? ,GHOST-NEW ,TOUCHBIT>
	       <TELL ", seen the ghost">)>
	<COND (<T? .FC>
	       <TELL ", " ,IDENTIFIED-THE-GHOST>)>
	;<COND (<T? ,VILLAIN-KNOWN?>
	       <TELL ", unmasked the ghost">)>
	<COND (<T? ,EVIDENCE-FOUND>
	       <TELL ", discovered evidence">)>
	<COND (<T? ,CONFESSED>
	       <TELL ", " ,ARRESTED-THE-VILLAIN>)>
	<COND (<T? ,TREASURE-FOUND>
	       <TELL ", discovered the " 'ARTIFACT>)>
	<TELL "... ">
	<COND (<0? .N> <TELL "and">) (T <TELL "but">)>
	<TELL " you haven't ">
	<COND (<ZERO? ,TREASURE-FOUND>
	       <TELL "found the " 'ARTIFACT>)>
	<COND (<ZERO? ,EVIDENCE-FOUND>
	       <COND (<ZERO? ,TREASURE-FOUND>
		      <TELL " nor ">)>
	       <TELL "enough evidence">
	       <COND (<OR <T? ,VILLAIN-KNOWN?>
			  <T? .FC>>
		      <TELL " of why ">
		      <COND (<AND <==? ,VILLAIN-PER ,LOVER>
				  <T? ,LOVER-SAID>>
			     <TELL 'LORD " killed " 'COUSIN>)
			    (T <TELL 'VILLAIN-PER " haunted " 'CASTLE>)>)>)
	      (<ZERO? ,CONFESSED>
	       <COND (<ZERO? ,TREASURE-FOUND>
		      <TELL " nor ">)>
	       <TELL ,ARRESTED-THE-VILLAIN>)>
	<COND (<ZERO? .FC>
	       <COND (<OR <ZERO? ,TREASURE-FOUND>
			  <ZERO? ,EVIDENCE-FOUND>
			  <ZERO? ,CONFESSED>>
		      <TELL " nor ">)>
	       ;<TELL .I "a " D ,COSTUME>
	       <TELL ,IDENTIFIED-THE-GHOST>)>
	<TELL "!]" CR>>

<GLOBAL YES-INBUF <ITABLE 19 (BYTE LENGTH) 0>
		  ;<TABLE #BYTE 19 #BYTE 0	0 0 0 0 0 0 0 0 0>>
<GLOBAL YES-LEXV  <ITABLE 3 (LEXV) 0 0>
		  ;<TABLE #BYTE  3 #BYTE 0	0 0 0 0 0 0>>

<ROUTINE YES? ("AUX" WORD VAL)
	<REPEAT ()
		<PRINTI "|>">
		<READ ,YES-INBUF ,YES-LEXV>
		<COND (<AND <NOT <0? <GETB ,YES-LEXV ,P-LEXWORDS>>>
			    <SET WORD <GET ,YES-LEXV ,P-LEXSTART>>>
		       <SET VAL <WT? .WORD ,PS?VERB ,P1?VERB>>
		       <COND (<EQUAL? .VAL ,ACT?YES>
			      <SET VAL T>
			      <RETURN>)
			     (<OR <EQUAL? .VAL ,ACT?NO>
				  <EQUAL? .WORD ,W?N>>
			      <SET VAL <>>
			      <RETURN>)
			     (<EQUAL? .VAL ,ACT?RESTART>
			      <V-RESTART>)
			     (<EQUAL? .VAL ,ACT?RESTORE>
			      <V-RESTORE>)
			     (<EQUAL? .VAL ,ACT?QUIT>
			      <V-QUIT>)>)>
		<TELL "[Please type YES or NO.]">>
	.VAL>

<ROUTINE NO-NEED ("OPTIONAL" (STR <>) (OBJ <>))
	<SETG CLOCK-WAIT T>
	<TELL !\( CHE ,WINNER do "n't need to ">
	<COND (.STR <TELL .STR>) (T <VERB-PRINT>)>
	<COND (<EQUAL? .STR "go" "drive">
	       <TELL " in that " D ,INTDIR>)
	      (<T? .OBJ>
	       <TELL THE .OBJ>)
	      (T <TELL THE ,PRSO>)>
	<TELL ".)" CR>>

<ROUTINE YOU-CANT ("OPTIONAL" (STR <>) (WHILE <>) (STR1 <>))
	<SETG CLOCK-WAIT T>
	<TELL !\( CHE ,WINNER " can't ">
	<COND (<ZERO? .STR>
	       <VERB-PRINT>)
	      (T <TELL .STR>)>
	<COND (<EQUAL? .STR "go" "drive">
	       <TELL " in that " D ,INTDIR>)
	      (T
	       <COND (<==? ,PRSO ,PSEUDO-OBJECT>
		      <TELL " it">)
		     (<AND <DOBJ? BUST>
			   <NOUN-USED? ,W?TAPE>
			   <OR <EQUAL? .STR "wait until" ;"throw off">
			       <EQUAL? .STR "pick up" "turn off" "turn on">>>
		      <TELL " the tape">)
		     (<AND <DOBJ? FLOOR>
			   <OUTSIDE? ,HERE>
			   <NOT <EQUAL? <LOC ,WINNER> ;,HERE ,CAR>>>
		      <TELL " the ground">)
		     (T <TELL THE ,PRSO>)>
	       <COND (.STR1
		      <TELL " while">
		      <COND (.WHILE
			     <TELL HE .WHILE is>
			     ;<THIS-IS-IT .WHILE>)
			    (T <TELL HE ,PRSO is>)>
		      <TELL !\  .STR1>)
		     ;(T <TELL " now">)>)>
	<TELL ".)" CR>>

<ROUTINE YOU-SHOULDNT ("OPT" (PREP <>))
	<SETG CLOCK-WAIT T>
	<TELL !\( CHE ,WINNER " shouldn't ">
	<VERB-PRINT>
	<TELL THE ;HIM ,PRSO>
	<COND (<T? .PREP>
	       <TELL .PREP THE ,PRSI>)>
	<TELL ".)" CR>>

""

"SUBTITLE - GENERALLY USEFUL ROUTINES & CONSTANTS"

<ROUTINE TELL-BEING-WORN (OBJ)
	<COND (<FSET? .OBJ ,WORNBIT>
	       <TELL " (actually, wearing it)">)
	      ;(<AND <FSET? .OBJ ,ONBIT>
		    <NOT <EQUAL? ,LIT ,HERE ;1>>>
	       <TELL " (providing light)">)>>

<GLOBAL YAWNS <LTABLE 0 "unusual" "interesting" "extraordinary" "special">>

<ROUTINE PRINT-CONTENTS (THING "AUX" OBJ NXT (1ST? T) (VAL <>))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <FSET? .OBJ ,NDESCBIT> ;"was semied"
				  <EQUAL? .OBJ ,WINNER ;,NOW-WEARING>>
			      <MOVE .OBJ ,INTDIR>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
	 <SET OBJ <FIRST? .THING>>
	 <COND (<NOT .OBJ>
		<COND (<NOT <==? .THING ,PLAYER>>
		       <TELL " nothing " <PICK-ONE-NEW ,YAWNS>>)>)
	       (T
		<REPEAT ()
		        <COND (.OBJ
		               <SET NXT <NEXT? .OBJ>>
		               <COND (.1ST?
			              <SET VAL T>
				      <SET 1ST? <>>)
			             (T
			              <COND (.NXT <TELL !\,>)
				            (T <TELL " and">)>)>
		               <TELL THE .OBJ>
		               <TELL-BEING-WORN .OBJ>
			       <THIS-IS-IT .OBJ>
		               <FCLEAR .OBJ ,SECRETBIT>
			       <FSET .OBJ ,SEENBIT>
			       <SET OBJ .NXT>)
			      (T
		               <RETURN>)>>)>
	 <ROB ,INTDIR .THING>
	 .VAL>

<ROUTINE DESCRIBE-OBJECTS ("OPTIONAL" (THING <>)
			   "AUX" OBJ NXT STR (VAL <>) (HE 0) (SHE 0)
				 (FIRST T) (TWO? <>) (IT? <>) (ANY? <>))
	 <COND (<ZERO? .THING>
		<SET THING ,HERE>)>
	 <COND (<ZERO? ,LIT>
	        <TOO-DARK>
	        <RTRUE>)>
      ;"Hide invisible objects"
	<SET OBJ <FIRST? .THING>>
	<COND (<ZERO? .OBJ>
	       <RFALSE>)>
	<REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <COND (<OR <FSET? .OBJ ,INVISIBLE>
				  <FSET? .OBJ ,NDESCBIT>
				  <EQUAL? .OBJ ,WINNER>
				  <AND <FSET? .OBJ ,PERSONBIT>
				       <OR <FSET? .OBJ ,RMUNGBIT>;"not desc'd"
					   ;<IN-MOTION? .OBJ>>>
				  <EQUAL? .OBJ <LOC ,PLAYER>>>
			      <FCLEAR .OBJ ,RMUNGBIT>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
      <COND (<EQUAL? .THING ,HERE>
	;"Describe people in proper order:"
       <SET NXT ,GHOST-NEW-C ;,CHARACTER-MAX>
       <REPEAT ()
	       <PUT ,TOUCHED-LDESCS .NXT 0>
	       <COND (<DLESS? NXT 1> <RETURN>)>>
       <SET NXT 0>
       <REPEAT ()
	       <COND (<IGRTR? NXT ,GHOST-NEW-C ;,CHARACTER-MAX>
		      <RETURN>)
		     (<IN? <SET OBJ <GET ,CHARACTER-TABLE .NXT>> ,HERE>
		      <PUT ,FOLLOW-LOC .NXT ,HERE>
		      <SET VAL <APPLY <GETP .OBJ ,P?DESCFCN> ,M-OBJDESC>>
		      <FSET .OBJ ,SEENBIT>
		      <COND (<OR <==? .VAL ,M-FATAL>
				 <ZERO? .ANY?>>
			     <SET ANY? .VAL>)>
		      <COND (<FSET? .OBJ ,FEMALE>
			     <COND (<0? .SHE> <SET SHE .OBJ>)
				   (T <SET SHE 1>)>)
			    (T
			     <COND (<0? .HE> <SET HE .OBJ>)
				   (T <SET HE 1>)>)>
		      <MOVE .OBJ ,PSEUDO-OBJECT>)>>
       <SET NXT 0>
       <REPEAT ()
	       <COND (<IGRTR? NXT ,GHOST-NEW-C ;,CHARACTER-MAX>
		      <RETURN>)
		     (<T? <SET OBJ <GET ,TOUCHED-LDESCS .NXT>>>
		      ;<PUT ,TOUCHED-LDESCS .NXT 0>
		      <SET FIRST T>
		      <SET STR <GET ,CHARACTER-TABLE .NXT>>
		      <TELL CTHE .STR>
		      <SET STR .NXT>
		      <REPEAT ()
			      <COND (<IGRTR? STR ,GHOST-NEW-C ;,CHARACTER-MAX>
				     <COND (.FIRST <TELL " is ">)
					   (T <TELL " are ">)>
				     <TELL <GET ,LDESC-STRINGS .OBJ> !\. CR>
				     <RETURN>)
				    (<==? .OBJ <GET ,TOUCHED-LDESCS .STR>>
				     <PUT ,TOUCHED-LDESCS .STR 0>
				     <SET FIRST <>>
				     <TELL " and" THE
					   <GET ,CHARACTER-TABLE .STR>>)>>)>>
	<COND (<NOT <EQUAL? .SHE 0 1>>
	       <THIS-IS-IT .SHE>)
	      (<EQUAL? .SHE 1>
	       <SETG P-HER-OBJECT <>>)>
	<COND (<NOT <EQUAL? .HE 0 1>>
	       <THIS-IS-IT .HE>)
	      (<EQUAL? .HE 1>
	       <SETG P-HIM-OBJECT <>>)>
	<SET FIRST T>
	; "Apply all DESCFCNs and hide those objects"
       <SET OBJ <FIRST? .THING>>
       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?DESCFCN>>
		       <COND (.STR
		              ;<CRLF>
			      <SET VAL <APPLY .STR ,M-OBJDESC>>
			      <COND (<OR <==? .VAL ,M-FATAL>
					 <ZERO? .ANY?>>
				     <SET ANY? .VAL>)>
			      <THIS-IS-IT .OBJ>
			      <FSET .OBJ ,SEENBIT>
			      ;<CRLF>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
      ;"Apply all FDESCs and eliminate those objects"
	;<SET OBJ <FIRST? .THING>>
	;<REPEAT ()
		<COND (<AND .OBJ
			    <NOT <FSET? .OBJ ,TOUCHBIT>>>
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?FDESC>>
		       <COND (.STR
			      ;<SET VAL T>
			      <COND (<ZERO? .ANY?> <SET ANY? T>)>
			      <TELL ;CR .STR CR>
			      <FCLEAR .OBJ ,SECRETBIT>
			      <FSET .OBJ ,SEENBIT>
			      <THIS-IS-IT .OBJ>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>
       ;"Apply all LDESC's and eliminate those objects"
       <SET OBJ <FIRST? .THING>>
       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET STR <GETP .OBJ ,P?LDESC>>
		       <COND (.STR
		              ;<SET VAL T>
			      <COND (<ZERO? .ANY?> <SET ANY? T>)>
			      <TELL ;CR .STR CR>
			      <FCLEAR .OBJ ,SECRETBIT>
			      <FSET .OBJ ,SEENBIT>
			      <THIS-IS-IT .OBJ>
			      <MOVE .OBJ ,PSEUDO-OBJECT>)>
		       <SET OBJ .NXT>)
		      (T
		       <RETURN>)>>)>
       ;"Print whatever's left in a nice sentence"
	<SET OBJ <FIRST? ,HERE>>
	<SET VAL <>>
	<COND (.OBJ
	       <REPEAT ()
		<COND (.OBJ
		       <SET NXT <NEXT? .OBJ>>
		       <SET VAL T>
		       <COND (.FIRST
			      <SET FIRST <>>
			      ;<CRLF>
			      <COND (<EQUAL? .THING ,HERE>
				     <CRLF>
				     <COND (<FSET? ,HERE ,ONBIT>
					    <TELL "You see">)
					   ;(<OR <FIND-FLAG ,WINNER ,ONBIT>
						<FIND-FLAG ,HERE ,ONBIT>>
					    <TELL
CHIS ,WINNER " light reveals">)
					   (T <TELL
"The light reveals" ;" from the next room">)>)>)
			     (T
			      <COND (.NXT <TELL !\,>)
				    (T <TELL " and">)>)>
		       <TELL THE .OBJ>
		       <FCLEAR .OBJ ,SECRETBIT>
		       <FSET .OBJ ,SEENBIT>
		       <THIS-IS-IT .OBJ>
		       <TELL-BEING-WORN .OBJ>	
		       <COND (<AND <SEE-INSIDE? .OBJ>
				   <SEE-ANYTHING-IN? .OBJ>>
			      <MOVE .OBJ ,INTNUM>)>
		       <COND (<AND <NOT .IT?>
				   <NOT .TWO?>>
			      <SET IT? .OBJ>)
			     (T
			      <SET TWO? T>
			      <SET IT? <>>)>
		       <SET OBJ .NXT>)
		      (T
		       <COND (<AND .IT?
				   <NOT .TWO?>>
			      <SETG P-IT-OBJECT .IT?>)>
		       <COND (<EQUAL? .THING ,HERE>
			      <TELL " here">)>
		       <TELL !\.>
		       <COND (<ZERO? .ANY?> <SET ANY? T>)>
		       <RETURN>)>>)>
	<SET OBJ <FIRST? ,INTNUM>>
	<REPEAT ()
		<COND (<ZERO? .OBJ>
		       <RETURN>)>
		<COND (<FSET? .OBJ ,SURFACEBIT>
		       <TELL ;CR CR "On">)
		      (T
		       <TELL ;CR CR "Inside">)>
		<SET VAL T>
		<TELL THE .OBJ>
		<TELL " you see">
		<PRINT-CONTENTS .OBJ>
		<TELL !\.>
		<SET OBJ <NEXT? .OBJ>>>
	<COND (<T? .VAL ;.ANY?> <CRLF>)>
	<ROB ,INTNUM .THING>
	<ROB ,PSEUDO-OBJECT .THING>
	.ANY? ;.VAL>

<ROUTINE SEE-ANYTHING-IN? (THING "AUX" OBJ NXT (ANY? <>))
	 <SET OBJ <FIRST? .THING>>
	 <REPEAT ()
		 <COND (.OBJ
			<COND (<AND <NOT <FSET? .OBJ ,INVISIBLE>>
				    <NOT <FSET? .OBJ ,NDESCBIT>>
				    <NOT <EQUAL? .OBJ ,WINNER>>>
			       <SET ANY? T>
			       <RETURN>)>
			<SET OBJ <NEXT? .OBJ>>)
		       (T
			<RETURN>)>>
	 <RETURN .ANY?>>

<ROUTINE DESCRIBE-ROOM ("OPTIONAL" (LOOK? <>) "AUX" V? STR L)
	 <COND (<T? .LOOK?> <SET V? T>)
	       (<==? 2 ,VERBOSITY> <SET V? T>)
	       (<==? 0 ,VERBOSITY> <SET V? <>>)
	       (<NOT <FSET? ,HERE ,TOUCHBIT>>
		<SET V? T>)>
	 <COND (T ;<IN? ,HERE ,ROOMS>
		<TELL !\(>
		<COND (<ZERO? ,VERBOSITY>
		       <TELL D ,HERE>)
		      (T
		       <TELL "You are">
		       <COND (<NOT <FSET? ,HERE ,TOUCHBIT>>
			      <TELL " now">)>
		       <COND (<FSET? ,HERE ,SURFACEBIT>
			      <TELL " on">)
			     (<NOT <==? ,HERE ,BACKSTAIRS>>
			      <TELL " in">)>
		       <TELL THE ,HERE !\.>)>
		<TELL ")|">)>
	 <COND (<ZERO? ,LIT>
		<TOO-DARK>
		;<TELL "It is pitch black." CR>
		<RETURN <>>)
	       (<NOT <EQUAL? ,LIT ,HERE>>
		;<1? ,LIT>	;<NOT <FSET? ,HERE ,ONBIT>>
		<TELL "Light comes from" THE ,LIT ;" the next room" "." CR>)>
	 <COND (.V?
		<COND (<FSET? <SET L <LOC ,WINNER>> ,VEHBIT>
		       <TELL "(You're ">
		       <COND (<EQUAL? .L ,COFFIN> <TELL "ly">)
			     (T <TELL "sitt">)>
		       <TELL "ing ">
		       <COND (<EQUAL? .L ,CAR ,COFFIN>
			      <TELL "in">)
			     (T ;<FSET? .L ,SURFACEBIT>
			      <TELL "on">)
			     ;(T <TELL "standing in">)>
		       <THIS-IS-IT .L>
		       <TELL THE .L ".)" CR>)>
		<COND (<AND .V? <APPLY <GETP ,HERE ,P?ACTION> ,M-LOOK>>
		       T)
		      ;(<AND .V? <SET STR <GETP ,HERE ,P?FDESC>>>
		       <TELL .STR CR>)
		      (<AND .V? <SET STR <GETP ,HERE ,P?LDESC>>>
		       <TELL .STR CR>)
		      (T <APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>)>
		;<COND (<NOT <==? ,HERE .L>>
		       <APPLY <GETP .L ,P?ACTION> ,M-LOOK>)>)>
	 <COND (<GETP ,HERE ,P?CORRIDOR>
		<CORRIDOR-LOOK>)>
	 <FSET ,HERE ,SEENBIT>
	 <FSET ,HERE ,TOUCHBIT>
	 T>

"Lengths:"
<CONSTANT REXIT 0>
<CONSTANT UEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 2) (T 1)>>
	"Uncondl EXIT:	(dir TO rm)		 = rm"
<CONSTANT NEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 3) (T 2)>>
	"Non EXIT:	(dir ;SORRY string)	 = str-ing"
<CONSTANT FEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 4) (T 3)>>
	"Fcnl EXIT:	(dir PER rtn)		 = rou-tine, 0"
<CONSTANT CEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 5) (T 4)>>
	"Condl EXIT:	(dir TO rm IF f)	 = rm, f, str-ing"
<CONSTANT DEXIT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 6) (T 5)>>
	"Door EXIT:	(dir TO rm IF dr IS OPEN)= rm, dr, str-ing, 0"

<CONSTANT NEXITSTR 0>
<CONSTANT FEXITFCN 0>
<CONSTANT CEXITFLAG %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 4) (T 1)>>	"GET/B"
<CONSTANT CEXITSTR 1>		"GET"
<CONSTANT DEXITOBJ 1>		"GET/B"
<CONSTANT DEXITSTR %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 2) (T 1)>>	"GET"

<ROUTINE HAR-HAR ()
	<SETG CLOCK-WAIT T>
	<TELL !\( <PICK-ONE-NEW ,YUKS> !\) CR>>

<ROUTINE PICK-ONE-NEW (FROB "AUX" L CNT RND MSG RFROB)
	 <SET L <- <GET .FROB 0> 1>>
	 <SET CNT <GET .FROB 1>>
	 <SET FROB <REST .FROB 2>>
	 <SET RFROB <REST .FROB <* .CNT 2>>>
	 <SET RND <- .L .CNT>>
	 <SET RND <RANDOM .RND>>
	 %<DEBUG-CODE
	   <COND (<NOT <G? .RND 0>>
		  <TELL
"{PICK-ONE-NEW: L=" N .L " CNT=" N .CNT " RND=" N .RND " FROB="N .FROB"}"CR>)>>
	 <SET MSG <GET .RFROB .RND>>
	 <PUT .RFROB .RND <GET .RFROB 1>>
	 <PUT .RFROB 1 .MSG>
	 <SET CNT <+ .CNT 1>>
	 <COND (<==? .CNT .L> <SET CNT 0>)>
	 <PUT .FROB 0 .CNT>
	 .MSG>

<ROUTINE PICK-ONE (FROB) <GET .FROB <RANDOM <GET .FROB 0>>>>

<ROUTINE NOT-HOLDING? (OBJ)
	<COND (<AND <NOT <IN? .OBJ ,WINNER>>
		    <NOT <IN? <LOC .OBJ> ,WINNER>>>
	       <SETG CLOCK-WAIT T>
	       <TELL !\( CHE ,WINNER is " not holding" HIM .OBJ ".)" CR>)>>

;<ROUTINE LKP (ITM TBL "AUX" (CNT 0) (LEN <GET .TBL 0>))
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> .LEN>
			<RFALSE>)
		       (<EQUAL? <GET .TBL .CNT> .ITM>
			<COND (<EQUAL? .CNT .LEN> <RFALSE>)
			      (T
			       <RETURN <GET .TBL <+ .CNT 1>>>)>)>>>

<GLOBAL FOLLOWER:OBJECT 0>	"LORD=Tamara+Jack"

<ROUTINE NEW-FOLLOWER (PER)
	<COND (<NOT <EQUAL? ,FOLLOWER <> .PER>>
	       <PUTP ,FOLLOWER ,P?LDESC 0>
	       <TELL
"\"I'll leave you two alone, then,\" says " D ,FOLLOWER ".|">)>
	<SETG FOLLOWER .PER>
	<PUT <GT-O .PER> ,GOAL-ENABLE 0>>

<ROUTINE FRIEND-FOLLOWS-YOU (RM "AUX" C)
 <COND (<EQUAL? .RM ,CAR ,YOUR-BATHROOM>
	<RFALSE>)
       (<OR <FSET? .RM ,SECRETBIT>
	    <EQUAL? .RM ,CRYPT>>
	<NOT-INTO-PASSAGE ,FOLLOWER T>
	<PUTP ,FOLLOWER ,P?LDESC 9 ;"waiting patiently">
	<SETG FOLLOWER 0>
	<RFALSE>)
       (<ZERO? <GETP .RM ,P?LINE>>
	<RFALSE>)
       (<IN? ,FOLLOWER .RM>
	<RFALSE>)
       (T ;<NOT <==? ,OHERE .RM>>
	;<SETG OHERE .RM>
	;<COND (<NOT <EQUAL? .RM ;,SUB <LOC ,FOLLOWER>>>
	       <FCLEAR ,FOLLOWER ,TOUCHBIT>)>
	<MOVE ,FOLLOWER .RM>
	<PUTP ,FOLLOWER ,P?LDESC 23 ;"following you">
	<COND (<==? ,FOLLOWER ,LORD>
	       <TELL D ,FRIEND>)
	      (T <TELL D ,FOLLOWER>)>
	<TELL <PICK-ONE ,TRAILS-ALONG>>
	<COND (<AND <==? ,FOLLOWER ,LORD>
		    <NOT <EQUAL? .RM ,YOUR-ROOM ,YOUR-BATHROOM>>>
	       <MOVE ,LORD .RM>
	       <PUTP ,LORD ,P?LDESC 23 ;"following you">
	       <TELL " So does " D ,LORD !\.>)>
	;<SET C <GETP ,FOLLOWER ,P?CHARACTER>>
	;<COND (<AND <FSET? ,HERE ,SECRETBIT>
		    <ZERO? <GET ,FOUND-PASSAGES .C>>>
	       <PUT ,FOUND-PASSAGES .C T>
	       <COND (<NOT <==? .C ,VARIATION>>
		      <PUTP ,FOLLOWER ,P?LINE 0>)>
	       <TELL " She gasps, \"Wow! You found a " D ,PASSAGE "!\"">)>
	<CRLF>)>>

<ROUTINE NOT-INTO-PASSAGE (PER "OPT" (FOLLOW <>) (PASS T))
	<COND (<T? .PASS>
	       <PUT ,FOUND-PASSAGES <GETP .PER ,P?CHARACTER> T>)>
	<THIS-IS-IT .PER>
	<TELL "\"I'm not ">
	<COND (<T? .FOLLOW>
	       <TELL <GET ,LDESC-STRINGS 23> ;"following you">)
	      (T <TELL "going">)>
	<TELL " into that ">
	<COND (<T? .PASS>
	       <COND (<EQUAL? .PER ,OFFICER ,BUTLER>
		      <TELL "dirty">)
		     (T <TELL "spooky">)>
	       <TELL !\ >)>
	<TELL "place!\" says " D .PER>
	<COND (<T? .FOLLOW>
	       <TELL " as" HE .PER " stays behind">)>
	<TELL "." CR>>

<GLOBAL TRAILS-ALONG
 <PLTABLE " walks a few steps behind."
	" trails along."
	" stays at your side."
	" walks along with you.">>

<GLOBAL TOUR-FORCED:FLAG <>>
<ROUTINE TOUR? ("AUX" RM)
	<COND (<QUEUED? ,I-TOUR>
	       <QUEUE I-TOUR 1>
	       <SETG TOUR-FORCED T>
	       <COND (<QUEUED? ,I-REPLY> <QUEUE I-REPLY 1>)>
	       <COND (<OR <NOT <EQUAL? ,HERE ,GREAT-HALL>>
			  <FSET? ,DOCTOR ,TOUCHBIT>>
		      <SET RM <GET ,TOUR-PATH ,TOUR-INDEX>>
		      <COND (<VERB? FOLLOW>
			     <COND (<DOBJ? FRIEND>
				    <RTRUE>)>)
			    (<VERB? WALK>
			     <COND (<DIR-EQV? ,HERE ,PRSO <DIR-FROM ,HERE .RM>>
				    <RTRUE>)>)
			    (<VERB? WALK-TO THROUGH>
			     <COND (<==? <META-LOC ,PRSO> .RM>
				    <RTRUE>)>)>)>
	       <TELL
'FRIEND " says, \"Please don't wander off yet. I want you to ">
	       <COND (<FSET? ,DOCTOR ,TOUCHBIT>
		      <TELL "see " 'YOUR-ROOM ".\"" CR>)
		     (T <TELL "meet the other guests.\"" CR>)>
	       <RTRUE>)>>

<ROUTINE CREEPY? (RM)
 <COND (<FSET? .RM ,SECRETBIT>
	<RTRUE>)
       (<EQUAL? .RM ,TOMB ,DUNGEON ,CRYPT>
	<RTRUE>)
       ;(<EQUAL? .RM ,BASEMENT>
	<RTRUE>)>>

<ROUTINE GOTO (RM "OPTIONAL" (TEST T) (FOLLOW? T) "AUX" X)
	<COND (<IN? ,WINNER .RM>
	       <WALK-WITHIN-ROOM>
	       <RFALSE>)>
	<COND (<APPLY <GETP ,HERE ,P?ACTION> ,M-EXIT>
	       <RFALSE>)
	      (<==? ,WINNER ,PLAYER>
	       <COND (<TOUR?>
		      <RFALSE>)>
	       <COND (<AND .FOLLOW?
			   <T? ,FOLLOWER>>
		      <FRIEND-FOLLOWS-YOU .RM>)>
	       <COND (<AND <1? <RANDOM 2 ;3>>
			   <ZERO? ,FOLLOWER>
			   <CREEPY? ,HERE>
			   <CREEPY? .RM>>
		      <TELL "You " <PICK-ONE-NEW ,CREEPIES> CR>)>)
	      ;(<FSET? ,WINNER ,MUNGBIT>
	       <TELL "\"I wish I could!\"" CR>
	       <RFALSE>)
	      (<FSET? .RM ,SECRETBIT>
	       <NOT-INTO-PASSAGE ,WINNER>
	       <RFALSE>)
	      (<EQUAL? .RM ,YOUR-BATHROOM>
	       <NOT-INTO-PASSAGE ,WINNER <> <>>
	       <RFALSE>)>
	<COND (<AND <T? .TEST>
		    <==? ,WINNER ,PLAYER>>
	       <SET X <DIR-FROM ,HERE .RM>>
	       <COND (<T? .X>
		      <COND (<==? ,M-FATAL <APPLY <GETP ,HERE ,P?ACTION> .X>>
			     <RFALSE>)>)>)>
	<PUT ,FOLLOW-LOC <GETP ,WINNER ,P?CHARACTER> .RM>
	<COND (<AND <IN? ,WINNER ,CAR>
		    <EQUAL? .RM ,COURTYARD>>
	       <MOVE ,CAR .RM>)>
	<MOVE ,WINNER .RM>
	<COND (<==? ,WINNER ,PLAYER>
	       <SETG OHERE ,HERE>
	       <SETG HERE .RM>
	       <MAKE-ALL-PEOPLE -12 ;"listening to you">
	       <ENTER-ROOM>
	       <RTRUE>)
	      (T <RTRUE>)>>

<GLOBAL CREEPIES
	<LTABLE 0
		"feel a cold shiver run down your back."
		"hear footsteps behind you, but no one is there."
		"hear a door creak open... or was it the wind?"
		;"almost trip over a protruding stone."
		"feel a cobweb brush your face."
		"hear a scurrying sound underfoot.">>

<ROUTINE HACK-HACK (STR)
	 <TELL .STR HIM ,PRSO <PICK-ONE ,HO-HUM> CR>>

<GLOBAL HO-HUM
	<PLTABLE
	 " won't help any."
	 " is a waste of time.">>

<ROUTINE HELD? (OBJ "OPTIONAL" (CONT <>) "AUX" L)
	 <COND (<ZERO? .CONT> <SET CONT ,PLAYER ;,WINNER>)>
	 <COND (<AND <EQUAL? .OBJ ,ARTIFACT>
		     <T? ,TREASURE-FOUND>>
		<SET OBJ ,TREASURE>)>
	 <REPEAT ()
		 <SET L <LOC .OBJ>>
		 <COND (<NOT .L> <RFALSE>)
		       (<EQUAL? .L .CONT> <RTRUE>)
		       (<EQUAL? .CONT ,PLAYER ,WINNER>
			<COND (<EQUAL? .OBJ ,HANDS ,HEAD ,EYE>
			       <RTRUE>)
			      (<EQUAL? .OBJ ,NOW-WEARING ;,POCKET>
			       <RTRUE>)
			      ;(<AND <EQUAL? .OBJ ,ARTIFACT>
				    <EQUAL? ,WINNER .L <LOC .L>>>
			       <RTRUE>)
			      (<AND <EQUAL? .OBJ ,CAR>
				    <VERB? MUNG>>
			       <RTRUE>)
			      (T <SET OBJ .L>)>)
		       (<EQUAL? .L ,ROOMS ,GLOBAL-OBJECTS> <RFALSE>)
		       (T <SET OBJ .L>)>>>

<ROUTINE IDROP ()
	 <COND ;(<FSET? ,PRSO ,PERSONBIT>
		<TELL CTHE ,PRSO " wouldn't enjoy that." CR>
		<RFALSE>)
	       (<NOT-HOLDING? ,PRSO>
		<RFALSE>)
	       (<AND <NOT <IN? ,PRSO ,WINNER>>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<TOO-BAD-BUT <LOC ,PRSO> "closed">
		<RFALSE>)
	       (T
		<MOVE ,PRSO ,HERE ;"<LOC ,WINNER>">
		<FCLEAR ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<RTRUE>)>>

;<GLOBAL INDENTS
	<PTABLE ""
	       "  "
	       "    "
	       "      "
	       "        "
	       "          ">>

<GLOBAL FUMBLE-NUMBER:NUMBER 7>
<GLOBAL FUMBLE-PROB:NUMBER 8>
;<GLOBAL ITAKE-LOC:OBJECT <>>

<ROUTINE ITAKE ("OPTIONAL" (VB T) "AUX" CNT OBJ L)
	 <SET L <LOC ,PRSO>>
	 <COND (<AND .L <FSET? .L ,PERSONBIT>>
		<COND (<AND <NOT <FSET? ,PRSO ,TAKEBIT>>
			    <NOT <FSET? .L ,MUNGBIT>>>
		       <COND (.VB <YOU-CANT "take">)>
		       <RFALSE>)
		      (T <FSET ,PRSO ,TAKEBIT>)>)>
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<COND (.VB <YOU-CANT "take">)>
		<RFALSE>)
	       (<AND <G? <SET CNT <CCOUNT ,WINNER>> ,FUMBLE-NUMBER>
		     <PROB <* .CNT ,FUMBLE-PROB>>
		     <SET OBJ <FIND-FLAG-NOT ,WINNER ,WORNBIT>>>
		<TOO-BAD-BUT>
		<TELL
THE .OBJ " slips from" HIS ,WINNER " arms while" HE ,WINNER is " taking"
HIM ,PRSO ", and both tumble " <GROUND-DESC> ". " CHE ,WINNER is
" carrying too many things.|">
		<MOVE .OBJ ,HERE>	;<PERFORM ,V?DROP .OBJ>
		<MOVE ;-FROM ,PRSO ,HERE>
		<RFATAL>)
	       (T
		<MOVE ;-FROM ,PRSO ,WINNER>
		<FSET ,PRSO ,SEENBIT>
		<FSET ,PRSO ,TOUCHBIT>
		<FCLEAR ,PRSO ,NDESCBIT>
		<FCLEAR ,PRSO ,INVISIBLE>
		<FCLEAR ,PRSO ,SECRETBIT>
		;<COND (<==? ,WINNER ,PLAYER> <SCORE-OBJ ,PRSO>)>
		;<SETG ITAKE-LOC <>>
		<COND (<AND <NOT <VERB? TAKE>>
			    <NOT <==? .L ,WINNER>>
			    <OR <FSET? .L ,PERSONBIT>
				<EQUAL? .L ,SIDEBOARD>>>
		       <FIRST-YOU "take" ,PRSO .L>
		       ;<COND (<NOT .VB> <SETG ITAKE-LOC .L>)>)>
		<RTRUE>)>>

<ROUTINE CCOUNT (OBJ "AUX" (CNT 0) X)
	 <COND (<SET X <FIRST? .OBJ>>
		<REPEAT ()
			<COND (<NOT <FSET? .X ,WORNBIT>>
			       <SET CNT <+ .CNT 1>>)>
			<COND (<NOT <SET X <NEXT? .X>>>
			       <RETURN>)>>)>
	 .CNT>

<ROUTINE CHECK-DOOR (DR)
	<TELL CTHE .DR " is ">
	<THIS-IS-IT .DR>
	<COND (<FSET? .DR ,OPENBIT> <TELL "open">)
	      (T
	       <TELL "closed and ">
	       <COND (<NOT <FSET? .DR ,LOCKED>> <TELL "un">)>
	       <TELL "locked">)>
	<TELL "." CR>>

<ROUTINE ROOM-CHECK ("AUX" P PA)
	 <SET P ,PRSO>
	 <COND (<EQUAL? .P ,ROOMS>
		<RFALSE>)
	       (<IN? .P ,ROOMS>
		<COND (<EQUAL? ,HERE .P>
		       <RFALSE>)
		      (<OR <EQUAL? ,HERE <GETP .P ,P?STATION>>
			   <GLOBAL-IN? .P ,HERE>>
		       <COND (<AND <VERB? LIE SIT SEARCH SEARCH-FOR>
				   <NOT <==? <SET P <META-LOC .P>> ,HERE>>>
			      <FIRST-YOU "try to enter" .P>
			      <SET PA ,PRSA>
			      <SET P <PERFORM ,V?THROUGH .P>>
			      <SETG PRSA .PA>
			      <COND (<==? ,M-FATAL .P>
				     <RTRUE>)
				    (T <RFALSE>)>)
			     (T <RFALSE>)>)
		      (<NOT <SEE-INTO? .P>>
		       <RTRUE>)
		      (T <RFALSE>)>)
	       (<OR ;<==? .P ,PSEUDO-OBJECT>
		    <EQUAL? <META-LOC .P>
			    ,HERE ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>>
		<RFALSE>)
	       (<NOT <VISIBLE? .P>>
		<NOT-HERE .P>)>>

<ROUTINE SEE-INSIDE? (OBJ "OPTIONAL" (ONLY-IN <>))
	<COND ;(<FSET? .OBJ ,INVISIBLE> <RFALSE>)	;"for LIT? - PLAYER"
	      (<FSET? .OBJ ,TRANSBIT> <RTRUE>)
	      (<FSET? .OBJ ,OPENBIT> <RTRUE>)
	      (.ONLY-IN <RFALSE>)
	      (<FSET? .OBJ ,SURFACEBIT> <RTRUE>)>>

<ROUTINE ARENT-TALKING ()
	<SETG CLOCK-WAIT T>
	<TELL "(You aren't talking to anyone!)" CR>>

<ROUTINE ALREADY (OBJ "OPTIONAL" (STR <>))
	<SETG CLOCK-WAIT T>
	<TELL !\(>
	<COND ;(<NOUN-USED? ,W?DOOR>	;"confusing in secret passage"
	       <TELL "The door">)
	      (T <TELL CTHE .OBJ>)>
	<COND (<EQUAL? .OBJ ,PLAYER> <TELL " are">)
	      (T <TELL " is">)>
	<TELL " already ">
	<COND (.STR <TELL .STR "!)" CR>)>
	<RTRUE>>

<ROUTINE NOT-CLEAR-WHOM ()
	<SETG QUOTE-FLAG <>>
	<SETG P-CONT <>>
	<TELL "[It's not clear whom you're talking to.]"
;"[To talk to someone, type their name, then a comma, then what you want
them to do.]" CR>>

<ROUTINE OKAY ("OPTIONAL" (OBJ <>) (STR <>))
	<COND (<EQUAL? ,WINNER ,PLAYER ,BUTLER>
	       <COND (<VERB? THROUGH WALK WALK-TO>
		      <RTRUE>)>)
	      (T <TELL "\"">)>
	<TELL "Okay">
	<COND (.OBJ
	       <TELL !\, HE .OBJ>
	       <COND (.STR <TELL " is now " .STR>)>
	       <COND (<=? .STR "on">		<FSET .OBJ ,ONBIT>)
		     (<=? .STR "off">		<FCLEAR .OBJ ,ONBIT>)
		     (<=? .STR "open">		<FSET .OBJ ,OPENBIT>)
		     (<=? .STR "closed">	<FCLEAR .OBJ ,OPENBIT>)
		     (<=? .STR "locked">	<FSET .OBJ ,LOCKED>)
		     (<=? .STR "unlocked">	<FCLEAR .OBJ ,LOCKED>)>)>
	<COND (<OR .STR <NOT .OBJ>>
	       <COND (<NOT <==? ,WINNER ,PLAYER>>
		      <TELL ",\" says " 'WINNER ". " CHE ,WINNER " does so."CR>
		      <RTRUE>)>
	       <TELL "." CR>)>
	<COND (<AND <ZERO? ,LIT>
		    <T? <SETG LIT <LIT? ;,HERE>>>>
	       <CRLF>
	       <V-LOOK>)>
	<RTRUE>>

<ROUTINE TOO-BAD-BUT ("OPTIONAL" (OBJ <>) (STR <>))
	<TELL "Too bad, but">
	<COND (.OBJ
	       <TELL HE .OBJ>)>
	;<THIS-IS-IT .OBJ>
	<COND (.STR
	       <TELL " is " .STR>
	       <COND (<EQUAL? .STR "angry" "peeved">
		      <TELL " with you">)>
	       <TELL "." CR>)>
	<RTRUE>>

<ROUTINE TOO-DARK () ;("OPTIONAL" (OBJ 0)) <TELL "(It's too dark to see!)" CR>>

"<ROUTINE NOT-ACCESSIBLE? (OBJ)
 <COND (<EQUAL? <META-LOC .OBJ> ,WINNER ,HERE ,GLOBAL-OBJECTS> <RFALSE>)
       (<VISIBLE? .OBJ> <RFALSE>)
       (T <RTRUE>)>>"

<ROUTINE VISIBLE? ;"can player SEE object?"
		  (OBJ "AUX" H L (X <>))
	 <COND (<NOT .OBJ> <RFALSE>)
	       (<ACCESSIBLE? .OBJ> <RTRUE>)>
	 <SET X <CORRIDOR-LOOK .OBJ>>
	 <COND (<NOT <ZERO? .X>>
		<RETURN T ;.X>)>
	 <SET L <LOC .OBJ>>
	 <COND (<SEE-INSIDE? .L>
		<VISIBLE? .L>)>>

<ROUTINE ACCESSIBLE? (OBJ "AUX" L)	;"can player TOUCH object?"
	 <COND (<NOT .OBJ> <RFALSE>)
	       (T <SET L <LOC .OBJ>>)>
	 <COND (<FSET? .OBJ ,INVISIBLE>
		<RFALSE>)
	       (<EQUAL? .OBJ ,PSEUDO-OBJECT>
		<COND (<EQUAL? ,LAST-PSEUDO-LOC ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       ;(<EQUAL? .OBJ ,CAR>
		<COND (<EQUAL? <GETP ,CAR ,P?STATION> ,HERE>
		       <RTRUE>)
		      (T
		       <RFALSE>)>)
	       (<NOT .L>
		<RFALSE>)
	       (<EQUAL? .L ,GLOBAL-OBJECTS>
		<RTRUE>)	       
	       ;(<EQUAL? .L ,ROOMS>
		<RETURN <SEE-INTO? .OBJ <>>>)	       
	       (<EQUAL? .L ,LOCAL-GLOBALS>
		<RETURN <GLOBAL-IN? .OBJ ,HERE>>)
	       (<NOT <EQUAL? <META-LOC .OBJ> ,HERE>>
		<RFALSE>)
	       (<EQUAL? .L ,WINNER ,HERE>
		<RTRUE>)
	       (<OR <FSET? .L ,OPENBIT>
		    <FSET? .L ,SURFACEBIT>
		    <FSET? .L ,PERSONBIT>>
		<ACCESSIBLE? .L>)
	       (T
		<RFALSE>)>>

<ROUTINE META-LOC (OBJ "OPTIONAL" (INV <>) "AUX" L)
	<SET L <LOC .OBJ>>
	<REPEAT ()
		<COND (<NOT .L>
		       <RFALSE>)
		      (<EQUAL? .L ;,POCKET ,NOW-WEARING>
		       <RETURN ,HERE>)
		      (<EQUAL? .L ,LOCAL-GLOBALS ,GLOBAL-OBJECTS>
		       <RETURN .L>)
		      (<IN? .OBJ ,ROOMS>
		       <RETURN .OBJ>)
		      (T
		       <COND (<AND .INV <FSET? .OBJ ,INVISIBLE>>
			      <RFALSE>)>
		       <SET OBJ .L>
		       <SET L <LOC .OBJ>>)>>>

<CONSTANT WHO-CARES-LENGTH 4>

<GLOBAL WHO-CARES-VERB
	<PLTABLE "do" "do" "let" "seem">>

<GLOBAL WHO-CARES-TBL
	<PLTABLE "n't appear interested"
		"n't care"
		" out a loud yawn"
		" impatient">>

<ROUTINE WHO-CARES ("AUX" N)
	<SET N <RANDOM ,WHO-CARES-LENGTH>>
	<HE-SHE-IT ,PRSO T <GET ,WHO-CARES-VERB .N>>
	<TELL <GET ,WHO-CARES-TBL .N> "." CR>>

<GLOBAL YUKS
	<LTABLE 0
		"That's ridiculous!"
		"Surely you jest."
		;"Not a chance."
		"Don't be silly."
		"Not bloody likely."
		;"What a fruitcake!"
		"What a concept!"
		;"What a screwball!"
		"Like, totally grody, for sure."
		"You can't be serious!">>
""
"SUBTITLE REAL VERBS"

<ROUTINE PRE-SAIM () <PERFORM ,V?AIM ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SAIM () <V-FOO>>

<ROUTINE V-AIM () <YOU-CANT ;"aim">>

<ROUTINE PRE-SANALYZE () <PERFORM ,V?ANALYZE ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SANALYZE () <V-FOO>>

<ROUTINE PRE-ANALYZE ()
 <COND (<ROOM-CHECK>
	<RTRUE>)
       (<OR <FSET? ,PRSO ,PERSONBIT> ;<EQUAL? ,PRSO ,YOU ,ME>>
	<SETG CLOCK-WAIT T>
	<TELL "(Leave that to the police.)" CR>)
       ;(<AND <EQUAL? ,PRSI ,FINGERPRINTS>
	     <NOT <EQUAL? <META-LOC ,PRINT-KIT> ,HERE>>>
	<NOT-HERE ,PRINT-KIT>
	<RTRUE>)>>

<ROUTINE V-ANALYZE ()
 <COND ;(<EQUAL? ,PRSI ,FINGERPRINTS>
	<TELL "You don't find any interesting prints." CR>
	<RTRUE>)
       (<FSET? ,PRSO ,PERSONBIT> <TELL "How?" CR>)
       ;(<FSET? ,PRSO ,LIGHTBIT> <CHECK-ON-OFF>)
       (<FSET? ,PRSO ,DOORBIT> <CHECK-DOOR ,PRSO>)
       (T <TELL CHE ,PRSO look " normal." CR> ;<YOU-CANT "check">)>>

<ROUTINE V-ANSWER ()
	 <COND (<T? ,AWAITING-REPLY>
		<COND (<EQUAL? <GET ,P-LEXV ,P-CONT> ,W?YES>
		       <PERFORM ,V?YES>)
		      (T ;<EQUAL? <GET ,P-LEXV ,P-CONT> ,W?NO>
		       <PERFORM ,V?NO>)>)
	       (T <NOT-CLEAR-WHOM>
		;<TELL "Nobody is waiting for an answer." CR>)>
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <RTRUE>>

<ROUTINE V-REPLY ()
	 <SETG P-CONT <>>
	 <SETG QUOTE-FLAG <>>
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<WAITING-FOR-YOU-TO-SPEAK>)
	       (T <YOU-CANT ;"answer">)>> 

<ROUTINE WAITING-FOR-YOU-TO-SPEAK ()
	<TELL CHE ,PRSO seem " to be waiting for you to speak." CR>>

<GLOBAL EVIDENCE-FOUND:OBJECT <>>
<ROUTINE PRE-ARREST ()
	 <COND (<EQUAL? ,PRSI ,ROOMS>
		<SETG PRSI <>>)>
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    ;,PRSI>
		<SETG CLOCK-WAIT T>
		<TELL
"(Are you sure you're a" ,FAMOUS-YOUNG-DETECTIVE "? Arresting " A ,PRSO "?!)"
CR>)
	       (<T? ,CONFESSED>
		<ALREADY ,CONFESSED "arrested">)
	       (<NOT <ZERO? ,LIONEL-SPEAKS-COUNTER>>
		<TELL-BAD-FORM>
		<RTRUE>)
	       (<NOT <DOBJ? GHOST-NEW>>
		<UNSNOOZE ,PRSO>
		<RFALSE>)>>

<ROUTINE TELL-BAD-FORM ()
	<SETG CLOCK-WAIT T>
	<TELL "(Bad form">
	<IAN-CALLS-YOU>
	<TELL ". Wait until after dinner.)" CR>>

<GLOBAL FAMOUS-YOUNG-DETECTIVE " famous young detective">
<GLOBAL CONFESSED:OBJECT <>>
<GLOBAL CAPTOR:OBJECT <>>

<ROUTINE V-ARREST ()
	<COND (<1? <QUEUED? ,I-SHOT>>
	       <RTRUE>)		;"I-SHOT will respond"
	      (<AND <==? ,VARIATION <GETP ,PRSO ,P?CHARACTER>>
		    ;<T? <GET ,FOUND-COSTUME ,PLAYER-C>>
		    <T? ,EVIDENCE-FOUND>>
	       <CONFESSION ,PRSO>)
	      (T
	       <SETG CLOCK-WAIT T>
	       <TELL
"(It would be difficult to convict" HIM ,PRSO " with the evidence you've found.
If you hope
to put the culprit behind bars, you'll need more convincing proof.)"
;" to solve this case so conclusively that the police will be able"
CR>)>>

<ROUTINE CONFESSION (PER "AUX" P (DEAD <>))
	<SETG CONFESSED .PER>
	<PUTP .PER ,P?LINE 2>	;"angry"
	;<QUEUE I-SEARCH 0>
	<COND (<AND <T? ,TREASURE-FOUND>
		    <T? <GET ,FOUND-COSTUME ,PLAYER-C>>>
	       <SET P ,BUTLER>)
	      (<==? ,VARIATION ,LORD-C>
	       <SET P ,DOCTOR>)
	      (T <SET P ,LORD>)>
	<SETG CAPTOR .P>
	<UNSNOOZE .P T>
	<PUTP .P ,P?LDESC 9 ;"waiting patiently">
	<COND (<AND <FSET? .PER ,MUNGBIT>
		    <ZERO? <UNSNOOZE .PER>>>
	       <SET DEAD T>)
	      (T
	       <COND (<OR <ZERO? <GET ,TOLD-ABOUT-EVID
				      <GETP .PER ,P?CHARACTER>>>
			  <FIND-FLAG-HERE ,PERSONBIT ,PLAYER .PER>>
		      <TELL
"At first" HE .PER " denies everything, but when you tell about" THE
,EVIDENCE-FOUND "," HE .PER>)
		     (T <TELL CHE .PER>)>
	       <TELL " rushes at you! ">
	       <PUT <GT-O .PER> ,GOAL-FUNCTION ,NULL-F>)>
	<TELL "Suddenly ">
	<TELL D .P>
	<COND (<NOT <IN? .P ,HERE>>
	       <MOVE .P ,HERE>
	       <PUT <GT-O .P> ,GOAL-ENABLE 0>
	       <TELL " appears and">)>
	<COND (<ZERO? .DEAD>
	       <TELL
" grabs" HIM .PER " from behind, saying, \"I'll guard this villain for
you.\" Then " D .PER " glares at you and confesses to ">)
	      (T <TELL
" agrees that" THE ,EVIDENCE-FOUND " proves " D .PER " guilty of ">)>
	<COND (<EQUAL? .PER ,FRIEND>
	       <TELL "fraud.|">)
	      (T
	       <COND ;(<EQUAL? .PER ,LORD>
		      <TELL "double ">)
		     (<EQUAL? .PER ,PAINTER>
		      <TELL "attempted ">)>
	       <TELL "murder.|">)>
	<COND (<ZERO? .DEAD>
	       <PUTP .PER ,P?LDESC 20 ;"ignoring you">)>
	<COND (<AND <T? ,TREASURE-FOUND>
		    <T? <GET ,FOUND-COSTUME ,PLAYER-C>>>
	       <WRAP-UP>
	       <FINISH>)>
	<RTRUE>>

<ROUTINE WRAP-UP ()
	<TELL "|
(Congratulations, "TN"! Would you like to read the authors' version of
the crime?)">
	<COND (<NOT <YES?>>
	       <TELL "Okay." CR>)
	      (<EQUAL? ,VARIATION ,LORD-C>
	       <TELL
'LORD " murdered Lionel in order to inherit the title and castle.|"
'LOVER " was blackmailing " 'LORD " to marry her, because she knew he
was plotting to kill Lionel. So Jack tried to do away with her, too, by
dumping her down the well.|
But Jack was wrong in thinking he killed " 'LOVER ". She survived and
came back to the castle at night -- to play on " 'FRIEND "'s nerves,
since her arrival seemed to be part of Jack's plot; to hunt for proof
that Jack murdered Lionel; and to try to frame him for her own
\"murder\" by planting" THE ,JEWEL " in his trouser cuff, until she lost
it in the " 'DRAWING-ROOM "." CR>)
	      (<EQUAL? ,VARIATION ,FRIEND-C>
	       <TELL
'FRIEND " doubted that she could hold " 'LORD "'s love. She was both
jealous and fearful of " 'DEB " as a rival who might someday take Jack
away from her. So she tried to defame " 'DEB " by making it appear "
'DEB " was a vengeful ghost bent on killing Jack's new love, " 'FRIEND
". " 'LOVER "'s death was purely an accident." CR>)
	      (<EQUAL? ,VARIATION ,DOCTOR-C>
	       <TELL
'LOVER " strongly suspected that her grandfather died because of " 'DOCTOR
"'s fiendish experiments on his patients. So she wrote a letter to
Lionel, begging him to use his influence to investigate " 'DOCTOR ", which
he did. However, " 'DOCTOR " found out what they were up to, and silenced
both of them.|
He has masqueraded as a ghost to cover his midnight searches for the "
'ARTIFACT ". He intended the attacks on " 'FRIEND " to create the belief that
" 'LOVER " might still be alive." CR>)
	      (T ;<EQUAL? ,VARIATION ,PAINTER-C>
	       <TELL
'PAINTER " was intensely attached to " 'LOVER ", and
she jealously hated " 'LORD " for coming between them. When " 'LOVER "
accidentally fell down the well, " 'PAINTER " was convinced that she had
committed suicide because she felt abandoned by Jack.|
So " 'PAINTER " began her vengeful ghostly masquerade -- to find proof
that Jack was responsible for " 'LOVER "'s death, to prick his guilty
conscience and make him confess, and to terrorize " 'FRIEND ", who
replaced " 'LOVER " in Jack's affections." CR>)>>

;<ROUTINE PRE-ASK () <PRE-ASK-ABOUT>>

<ROUTINE V-ASK ()
 <COND (<AND <T? ,P-CONT>
	     <FSET? ,PRSO ,PERSONBIT>
	     <NOT <FSET? ,PRSO ,MUNGBIT>>>
	<SETG WINNER ,PRSO>
	<SETG QCONTEXT ,PRSO>)
       (T <V-ASK-ABOUT>)>>

<ROUTINE PRE-ASK-ABOUT ()
 <COND (<DOBJ? BUST CREW-GLOBAL JACK-TAPE MUSIC OCEAN PIANO
	       PLAYER-NAME RECORDER VOICE>
	<RFALSE>)
       (<AND <DOBJ? COUSIN>
	     <IN? ,BUST ,HERE>>
	<RETURN <DO-INSTEAD-OF ,BUST ,COUSIN>>)
       (<AND <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
	     <NOT <GLOBAL-IN? ,PRSO ,HERE>>>
	<NOT-HERE ;-PERSON ,PRSO>
	<RFATAL>)
       (<OR <DOBJ? PLAYER>
	    ;<DOBJ? COUSIN MAID GHOST-OLD>
	    <NOT <FSET? ,PRSO ,PERSONBIT>>
	    ;<FSET? ,PRSO ,MUNGBIT>>
	<COND (<AND <VERB? $CALL> <ZERO? ,P-CONT>>
	       <MISSING "verb">
	       <RFATAL>)
	      (<NOT <VERB? LISTEN>>
	       <WONT-HELP-TO-TALK-TO ,PRSO>
	       <RFATAL>)>)
       (<NOT <GRAB-ATTENTION ,PRSO ,PRSI>>
	<RFATAL>)>>

;<ROUTINE NOT-HERE-PERSON (PER "AUX" L)
	<SETG CLOCK-WAIT T>
	<TELL !\( CTHE .PER " isn't ">
	<COND (<VISIBLE? .PER>
	       <TELL "close enough">
	       <COND (<SPEAKING-VERB?> <TELL " to hear you">)>
	       <TELL !\.>)
	      (T <TELL "here!">)>
	<TELL ")" CR>>

<ROUTINE V-ASK-ABOUT ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <FSET? ,PRSO ,MUNGBIT>>
		<WONT-HELP-TO-TALK-TO ,PRSO>
		<RFATAL>)
	       (<AND <VERB? ASK> <NOT <==? ,PRSO ,PLAYER>>>
		<TELL "\"Ask me about something in particular.\"" CR>)
	       (T
		<TELL CHE ,PRSO do "n't know anything interesting about">
		<COND (<ZERO? ,PRSI> <TELL " that">)
		      (T <TELL THE ,PRSI>)>
		<TELL "." CR>)>>

<ROUTINE WONT-HELP-TO-TALK-TO (OBJ)
	;<VERB-PRINT>
	<TELL
"You talk to" THE .OBJ " for a minute before you realize that" HE .OBJ
" won't respond." CR>>

<ROUTINE PRE-ASK-CONTEXT-ABOUT ("OPTIONAL" (V 0) "AUX" P)
 <COND (<ZERO? .V> <SET V ,V?ASK-ABOUT>)>
 <COND (<QCONTEXT-GOOD?>
	<PERFORM .V ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL-I-ASSUME .P " Ask">
	<PERFORM .V .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-ASK-CONTEXT-ABOUT () <ARENT-TALKING>>

;<ROUTINE PRE-ASK-FOR () <PRE-ASK-ABOUT>>

<ROUTINE V-ASK-FOR ()
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>
		     <NOT <==? ,PRSO ,PLAYER>>>
		<TELL CTHE ,PRSO>
		<COND (<IN? ,PRSI ,PRSO>
		       <MOVE ,PRSI ,WINNER>
		       <FSET ,PRSI ,TAKEBIT>
		       <FSET ,PRSI ,TOUCHBIT>
		       <FCLEAR ,PRSI ,NDESCBIT>
		       <FCLEAR ,PRSI ,SECRETBIT>
		       <TELL " hands you" THE ,PRSI>
		       <FSET ,PRSI ,SEENBIT>
		       <TELL "." CR>)
		      (T <TELL " doesn't have" THE ,PRSI "." CR>)>)
	       (T <HAR-HAR>)>>

<ROUTINE PRE-ASK-CONTEXT-FOR ("AUX" P)
 <COND (<FSET? <SET P <LOC ,PRSO>> ,PERSONBIT>
	<PERFORM ,V?ASK-FOR .P ,PRSO>
	<RTRUE>)
       (T <PRE-ASK-CONTEXT-ABOUT ,V?ASK-FOR>)>>

<ROUTINE V-ASK-CONTEXT-FOR () <ARENT-TALKING>>

<ROUTINE V-ATTACK () <IKILL "attack">>

<ROUTINE V-BOW ("AUX" P)
	<SET P ,PRSO>
	<COND (<ZERO? .P>
	       <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	       <COND (<ZERO? .P>
		      <TELL "No one notices." CR>
		      <RTRUE>)>)>
	<COND (<OR <NOT <FSET? .P ,PERSONBIT>>
		   <EQUAL? .P ,PLAYER>>
	       <HAR-HAR>)
	      (<NOT <GRAB-ATTENTION .P>>
	       <RTRUE>)
	      (T
	       <TELL CHE .P !\ >
	       <COND (<FSET? .P ,FEMALE> <TELL "curtsey">) (T <TELL "bow">)>
	       <TELL "s back to you." CR>)>>

;<ROUTINE PRE-BRING ()
 <COND (<AND <NOT <EQUAL? ,PRSI <> ,PLAYER ,GLOBAL-HERE>>
	     <NOT <EQUAL? ,PRSI ,PLAYER-NAME>>>
	<DONT-UNDERSTAND>)>>

;<ROUTINE V-BRING () <V-TAKE> ;<YOU-CANT ;"bring">>

;<ROUTINE PRE-SBRING () <PERFORM ,V?BRING ,PRSI ,PRSO> <RTRUE>>
;<ROUTINE   V-SBRING () <V-FOO>>

<ROUTINE PRE-BRUSH ()
 <COND (<AND <DOBJ? ROOMS>
	     <NOT <EQUAL? ,P-PRSA-WORD ,W?SCRAPE ,W?SCRATCH>>>
	<SETG PRSO ,WINNER>
	<RFALSE>)>>

<GLOBAL AHHH "Ahhh! How refreshing!|">

<ROUTINE V-BRUSH ()
 <COND (<OR <NOT <EQUAL? ,P-PRSA-WORD ,W?SCRAPE ,W?SCRATCH>>
	    <FSET? ,PRSO ,PERSONBIT>>
	<COND (<EQUAL? ,HERE ,YOUR-BATHROOM ,KITCHEN>
	       <COND (<DOBJ? HANDS HEAD PLAYER ;ROOMS>
		      <SETG WASHED T>
		      <TELL ,AHHH>)
		     (<FSET? ,PRSO ,PERSONBIT>
		      <FACE-RED>)
		     (T <UNCLEAN>)>)
	      (T <TELL-FIND-NONE "a sink">)>)
       (T <UNCLEAN>)>>

<ROUTINE UNCLEAN ()
	<TELL
"You try for a minute and then decide it's an endless task." CR>>

;<ROUTINE PRE-BURN ()
	 <COND (<ZERO? ,PRSI>
		<TELL-NO-PRSI>)
	       ;(<EQUAL? ,PRSI ,LIGHTER>
	        <RFALSE>)
	       (T
	        <SETG CLOCK-WAIT T>
		<TELL "(With a " D ,PRSI "??!?)" CR>)>>

;<ROUTINE V-BURN () <YOU-CANT>>

<ROUTINE REMOVE-CAREFULLY ("OPTIONAL" (OBJ <>) "AUX" OLIT)
	 <SET OLIT ,LIT>
	 <COND (<T? .OBJ>
		<NOT-IT .OBJ>
		<MOVE .OBJ ,LOCAL-GLOBALS>)>
	 <SETG LIT <LIT? ;,HERE>>
	 <COND (<AND <T? .OLIT> <ZERO? ,LIT>>
		<TELL "You are left in the dark..." CR>)>
	 T>

;<ROUTINE PRE-$CALL () <PRE-ASK-ABOUT>>

<ROUTINE V-$CALL () ;("AUX" (MOT <>))
	 <UNSNOOZE ,PRSO>
	 <COND (<FSET? ,PRSO ,PERSONBIT>
		<COND (<==? <META-LOC ,PRSO> ,HERE>
		       <COND (<GRAB-ATTENTION ,PRSO>
			      ;<FCLEAR ,PRSO ,TOUCHBIT>
			      <PUTP ,PRSO ,P?LDESC 12 ;"listening to you">
			      <TELL CTHE ,PRSO>
			      <COND ;(.MOT
				     <TELL
V ,PRSO stop " and" V ,PRSO turn " toward you." CR>)
			      	    (T <TELL
" is " <GET ,LDESC-STRINGS 12> ;"listening to you" "." CR>)>)
			     (T
			      ;<TELL " ignores you." CR>
			      <RFATAL>)>)
		      (<CORRIDOR-LOOK ,PRSO>
		       <COND ;(<COR-GRAB-ATTENTION ;,PRSO>
			      <RTRUE>)
			     (T
			      <TELL CTHE ,PRSO " ignores you." CR>)>)
		      (T <NOT-HERE ,PRSO>)>)
	       (T <SETG CLOCK-WAIT T> <MISSING "verb">)>>

<ROUTINE V-CHASTISE ()
	<COND (<NOT <EQUAL? ,PRSO ,INTDIR>>
	       <TELL
,I-ASSUME " Look at" HIM ,PRSO ", not look in" HIM ,PRSO " nor look for"
HIM ,PRSO " nor any other preposition.]" CR>)>
	<PERFORM ,V?EXAMINE ,PRSO>
	<RTRUE>>

<ROUTINE V-BOARD ()
 <COND (<OR <IN? ,PRSO ,ROOMS> <FSET? ,PRSO ,DOORBIT>>
	<V-THROUGH>)
       (<AND <FSET? ,PRSO ,VEHBIT>
	     ;<FSET? ,PRSO ,CONTBIT>>
	;<V-SIT T>
	<COND (<IN? ,WINNER ,PRSO>
	       <ALREADY ,PLAYER>
	       <TELL "in" THE ,PRSO ".)" CR>)
	      (T
	       <MOVE ,WINNER ,PRSO>
	       <TELL "You are now ">
	       <COND (<FSET? ,PRSO ,SURFACEBIT>
		      <TELL "on">)
		     (T <TELL "in">)>
	       <TELL THE ,PRSO "." CR>
	       ;<APPLY <GETP ,PRSO ,P?ACTION> ,M-ENTER>
	       <RTRUE>)>)
       (T <YOU-CANT "get in">)>>

<ROUTINE V-CLIMB-ON ()
	<PERFORM ,V?SIT ,PRSO>
	<RTRUE>>

<ROUTINE V-CLIMB-UP ("OPTIONAL" (DIR ,P?UP) (OBJ <>) "AUX" X)
	 <COND (<IN? ,PRSO ,ROOMS>	;"GO UP TO room"
		<PERFORM ,V?WALK-TO ,PRSO>
		<RTRUE>)
	       (<GETPT ,HERE .DIR>
		<DO-WALK .DIR>
		<RTRUE>)
	       (<NOT .OBJ>
		<YOU-CANT "go">)
	       (ELSE <HAR-HAR>)>>

<ROUTINE V-CLIMB-DOWN () <V-CLIMB-UP ,P?DOWN>>

<ROUTINE V-CLOSE ()
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <EQUAL? ,PRSO ,WINDOW>>>
		<YOU-CANT ;"close">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <EQUAL? ,PRSO ,WINDOW>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <COND ;(<FSET? ,PRSO ,MUNGBIT>
			      <TELL
"It won't stay closed. The latch is broken." CR>)
			     (T
			      <OKAY ,PRSO "closed">)>)
		      (T <ALREADY ,PRSO "closed">)>)
	       (<AND <NOT <FSET? ,PRSO ,SURFACEBIT>>
		     <NOT <0? <GETP ,PRSO ,P?CAPACITY>>>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <OKAY ,PRSO "closed">)
		      (T <ALREADY ,PRSO "closed">)>)
	       (T <YOU-CANT ;"close">)>>

<ROUTINE PRE-COMPARE ()
 <COND (<AND <ZERO? ,PRSI>
	     <==? 1 <GET/B ,P-PRSO ,P-MATCHLEN>>>
	<SETG CLOCK-WAIT T>
	<TELL "[Oops! Try: COMPARE IT TO" ,SOMETHING>
	<RTRUE>)
       (<==? 2 <GET/B ,P-PRSO ,P-MATCHLEN>>
	<PUT/B ,P-PRSO ,P-MATCHLEN 1>
	<PERFORM ,PRSA <GET/B ,P-PRSO 1> <GET/B ,P-PRSO 2>>
	<RTRUE>)>>

<ROUTINE V-COMPARE ()
 <COND (<==? ,PRSO ,PRSI> <TELL "They're the same thing!" CR>)
       (T
	<COND (<EQUAL? ,PLAYER ,PRSO ,PRSI>
	       <TELL "You">)
	      (T <TELL "They">)>
	<TELL "'re not a bit alike." CR>)>>

<ROUTINE V-CONFRONT ()
	 <COND (<==? ,PRSO ,PLAYER>
		<ARENT-TALKING>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "Wow! That ought to put a scare into" HIM ,PRSO "!" CR>)
	       (T <WHO-CARES>)>>

;<ROUTINE V-COUNT () <TELL "Uhhh... ONE!" CR>>

;<ROUTINE V-CUT () <YOU-CANT ;"cut">>

<ROUTINE V-MUNG ()
	 <COND (<AND <FSET? ,PRSO ,DOORBIT> <ZERO? ,PRSI>>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <TELL
"You'd fly through the open door if you tried." CR>)
		      (<UNLOCK-DOOR? ,PRSO>
		       <TELL "Why don't you just open it instead?" CR>)
		      (T <IF-SPY>)>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<IF-SPY>)
	       (T <IKILL "hurt">)>>

<ROUTINE V-DANCE ("AUX" OW)
	 <COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
		     <EQUAL? ,PRSO ;<> ,PLAYER>>
		<SET OW ,WINNER>
		<SETG WINNER ,PLAYER>
		<PERFORM ,V?DANCE .OW>
		<SETG WINNER .OW>
		<RTRUE>)
	       ;(<ZERO? ,PRSO>
		<TELL "You dance by " 'PLAYER " for a minute." CR>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<HAR-HAR>)
	       (<IN-MOTION? ,PRSO>
		<TOO-BAD-BUT ,PRSO "too busy">
		;<TELL CHE ,PRSO " seems too busy to dance right now." CR>)
	       (<OR <AND <ZERO? ,GENDER-KNOWN>
			 <EQUAL? ,WINNER ,PLAYER>>
		    <AND <NOT <FSET? ,WINNER ,FEMALE>>
			 <FSET? ,PRSO ,FEMALE>>
		    <AND <FSET? ,WINNER ,FEMALE>
			 <NOT <FSET? ,PRSO ,FEMALE>>>>
		<TELL CHE ,WINNER dance " with" HIM ,PRSO " for a minute." CR>)
	       (T <TELL CHE ,PRSO " doesn't fancy a dance with you." CR>)>>

<ROUTINE PRE-DESCRIBE ()
 <COND (<==? ,WINNER ,PLAYER>
	<COND (<EQUAL? ,PRSI <> ,ROOMS>
	       <COND (<QCONTEXT-GOOD?>
		      <SETG WINNER ,QCONTEXT>
		      <PERFORM ,PRSA ,PRSO>
		      <RTRUE>)
		     (T <ARENT-TALKING>)>)
	      (T
	       <PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO>
	       <RTRUE>)>)>>

<ROUTINE V-DESCRIBE () <V-FOO>>

;<ROUTINE V-DIAGNOSE ()
 <COND (<T? ,PRSO> <YOU-CANT ;"diagnose">)
       (T <TELL CHE ,WINNER is " wide awake and in good health." CR>)>>

;<ROUTINE PRE-DISCUSS ()
	<COND (<ZERO? ,PRSI> <SETG PRSI ,PLAYER>)>
	<PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO>
	<RTRUE>>

;<ROUTINE V-DISCUSS () <V-FOO>>

<ROUTINE V-UNDRESS ()
 <COND (<EQUAL? ,PRSO ,ROOMS ,PLAYER>
	<COND (<ZERO? ,NOW-WEARING>
	       <ALREADY ,PLAYER "undressed">)
	      (T
	       <SETG PRSO <>>
	       <V-WEAR>)>)
       (<FSET? ,PRSO ,PERSONBIT>
	<COND (<FSET? ,PRSO ,MUNGBIT>
	       <SETG CLOCK-WAIT T>
	       <TELL "(Not in a family story!)" CR>)
	      (T <FACE-RED>)>)
       (T <HAR-HAR>)>>

<ROUTINE V-DRESS ("AUX" X)
 <COND (<DOBJ? ROOMS PLAYER>
	<COND (<AND <ZERO? ,NOW-WEARING>
		    <EQUAL? ,PLAYER ,WINNER ,PRSO>>
	       <COND (<OR <SET X <FIND-FLAG ,WINNER ,WEARBIT>>
			  <SET X <FIND-FLAG ,HERE ,WEARBIT>>>
		      <TELL-I-ASSUME .X " Wear">
		      <PERFORM ,V?WEAR .X>
		      <RTRUE>)
		     (T
		      <SETG CLOCK-WAIT T>
		      <TELL "(You didn't say what to wear!)" CR>)>)
	      (T <ALREADY ,WINNER "dressed">)>)
       (<FSET? ,PRSO ,PERSONBIT>
	<ALREADY ,WINNER "dressed">)
       (<FSET? ,PRSO ,WEARBIT>
	<V-WEAR>
	<RTRUE>)
       (<SET X <FIND-OUTFIT>>
	<TELL-I-ASSUME .X>
	<SETG PRSO .X>
	<V-WEAR>
	<RTRUE>)
       (T <HAR-HAR>)>>

<ROUTINE FIND-OUTFIT ("AUX" X)
    <OR <FIND-FLAG ,WINNER ,WEARBIT ,NOW-WEARING>
	<FIND-FLAG-HERE ,WEARBIT>
	<FIND-OUTFIT-IN ,LUGGAGE>
	<FIND-OUTFIT-IN ,BED>
	<FIND-OUTFIT-IN ,CHEST-OF-DRAWERS>
	<FIND-OUTFIT-IN ,WARDROBE>>>

<ROUTINE FIND-OUTFIT-IN (OBJ "AUX" X)
 <COND (<AND <==? <META-LOC .OBJ> ,HERE>
	     <SET X <FIND-FLAG .OBJ ,WEARBIT>>>
	<COND (<NOT <FSET? .OBJ ,OPENBIT>>
	       <FSET .OBJ ,OPENBIT>
	       <FIRST-YOU "open" .OBJ>)>
	.X)>>

<ROUTINE V-CHANGE ("AUX" X)
	 <COND (<DOBJ? SLEEP-OUTFIT DINNER-OUTFIT
		       EXERCISE-OUTFIT TWEED-OUTFIT ROOMS ;CLOTHES>
		<COND (<SET X <FIND-OUTFIT>>
		       <PERFORM ,V?WEAR .X>
		       <RTRUE>)
		      (<NOT <EQUAL? <META-LOC ,LUGGAGE> ,HERE>>
		       <TELL
"You look around for " D ,LUGGAGE " but don't find it." CR>)
		      (<SET X <FIND-FLAG ,LUGGAGE ,WEARBIT>>
		       <FSET ,LUGGAGE ,OPENBIT>
		       <PERFORM ,V?WEAR .X>
		       <RTRUE>)
		      (T <TELL "You can't find anything to change into."CR>)>)
	       (T <YOU-CANT ;"change">)>>

<ROUTINE PRE-DRIVE-TO ()
	<COND (<NOT <DOBJ? CAR>>
	       <DONT-UNDERSTAND>)
	      (<NOT <EQUAL? <LOC ,WINNER> ;,HERE ,CAR>>
	       <TELL-NOT-IN ,CAR>
	       <RTRUE>)
	      (<IOBJ? INTDIR>
	       <DO-WALK ,P-DIRECTION>
	       <RTRUE>)
	      (T
	       <PERFORM ,V?WALK-TO ,PRSI>
	       <RTRUE>)>>

<ROUTINE TELL-NOT-IN (OBJ)
	<SETG CLOCK-WAIT T>
	<TELL !\( CHE ,WINNER is " not in" HIM .OBJ "!)" CR>>

<ROUTINE V-DRIVE-TO () <V-FOO>>

<ROUTINE V-DRINK () <YOU-CANT ;"drink">>

<ROUTINE V-DROP ("AUX" L)
 <COND (<IDROP>
	<COND (<OR <IN? <SET L ,TABLE-DINING> ,HERE>
		   <SET L <FIND-FLAG-HERE ,VEHBIT;,SURFACEBIT ,PRSO>>>
	       <MOVE ,PRSO .L>
	       <OKAY ,PRSO>
	       <TELL " is now on" THE .L "." CR>)
	      (T
	       <OKAY ,PRSO <GROUND-DESC>>)>)>>

<ROUTINE GROUND-DESC ()
	 <COND (<OR <NOT <OUTSIDE? ,HERE>>
		    <EQUAL? <LOC ,WINNER> ;,HERE ,CAR>>
		"on the floor")
	       (T "on the ground")>>

<ROUTINE PRE-EAT ()
 <COND (<EQUAL? ,PRSO <> ,ROOMS>
	<COND (<EQUAL? <META-LOC ,DINNER> ,HERE>
	       ;<SETG PRSO ,DINNER>
	       <PERFORM ,PRSA ,DINNER>
	       <RTRUE>)
	      (T
	       <NOT-HERE ,DINNER>
	       <RTRUE>)>)>>

<ROUTINE V-EAT () <TELL "It's hard to believe you're that hungry." CR>>

<ROUTINE PRE-EMPTY ()
	<COND (<DOBJ? ROOMS>
	       <COND (<==? ,HERE <META-LOC ,LUGGAGE>>
		      <SETG PRSO ,LUGGAGE>)	;"works if LUGGAGE-F passes"
		     (T <NOT-HERE ,LUGGAGE> <RTRUE>)>)>
	<COND (<DOBJ? POND>
	       <WONT-HELP>)
	      (<DOBJ? VIVIEN-BOX WENDISH-KIT>
	       <YOU-SHOULDNT>)
	      (<AND <NOT <DOBJ? BOTTLE>>
		    <NOT <FIRST? ,PRSO>>>
	       <ALREADY ,PRSO "empty">)
	      (<AND <T? ,PRSI>
		    <NOT <IN? ,PRSI ,ROOMS>>
		    <NOT <FSET? ,PRSI ,CONTBIT>>>
	       <TELL-FIND-NONE "an opening in" ,PRSI>
	       <RFATAL>)
	      (<AND <DOBJ? CAR>
		    <ZERO? ,PRSI>>
	       <PERFORM ,PRSA ,PRSO <LOC ,CAR>>
	       <RTRUE>)>>

<ROUTINE V-EMPTY ()
 <COND ;(<AND <DOBJ? LUGGAGE>
	     <NOT <==? ,HERE ,YOUR-ROOM>>>
	<TELL-FIND-NONE "a place for your stuff">)
       (<FSET? ,PRSO ,CONTBIT>
	<TELL CHE ,WINNER empti THE ,PRSO>
	<COND (<ZERO? ,PRSI>
	       <COND (<AND <NOT <DOBJ? COFFIN>>
			   <SETG PRSI <FIND-FLAG-HERE ,CONTBIT ,PRSO>>>
		      <FSET ,PRSI ,OPENBIT>
		      <TELL " into" THE ,PRSI>)
		     (T
		      <SETG PRSI ,HERE>
		      <TELL !\  <GROUND-DESC>>)>)>
	<TELL "." CR>
	<COND (<AND <NOT <==? ,PRSI ,HERE>>
		    <G? <+ <WEIGHT ,PRSI> <WEIGHT ,PRSO>>
			<GETP ,PRSI ,P?CAPACITY>>>
	       <TELL ,NOT-ENOUGH-ROOM>)
	      (T
	       <ROB ,PRSO ,PRSI>
	       <RTRUE>)>)
       (T <YOU-CANT>)>>

<ROUTINE PRE-THROUGH ()
 <COND (<DOBJ? ROOMS GLOBAL-HERE>
	<DO-WALK ,P?IN>
	<RTRUE>)
       (<T? ,PRSI>	;"DRIVE CAR THRU object"
	<COND (<DOBJ? CAR>
	       <COND (<EQUAL? <LOC ,WINNER> ;,HERE ,CAR>
		      <SETG PRSO ,PRSI>
		      <RFALSE>)
		     (T
		      <TELL-NOT-IN ,CAR>
		      <RTRUE>)>)
	      (T <DONT-UNDERSTAND>)>)>>

<ROUTINE V-THROUGH ;("OPTIONAL" (OBJ <>)) ("AUX" RM DIR)
	<COND (<AND <OR <NOUN-USED? ,W?DOOR ,W?GATE ,W?HOLE>
			<NOUN-USED? ,W?PANEL>>
		    ;<FSET? ,PRSO ,DOORBIT>
		    <OR <FSET? ,PRSO ,OPENBIT>
			<WALK-THRU-DOOR? <> ,PRSO <>>>>
	       <COND (<AND <SET RM <DOOR-ROOM ,HERE ,PRSO>>
			   <GOTO .RM>>
		      ;<OKAY>
		      T)
		     (T
		      <V-FOO>
		      ;<TELL
"(Sorry, but" THE ,PRSO " must be somewhere else.)" CR>)>)
	      (<IN? ,PRSO ,ROOMS>
	       <COND (<==? ,PRSO ,HERE>
		      <WALK-WITHIN-ROOM>)
		     (<SEE-INTO? ,PRSO <>>
		      <GOTO ,PRSO>)
		     (T <PERFORM ,V?WALK-TO ,PRSO>)>
	       <RTRUE>)
	      (<AND <FSET? ,PRSO ,VEHBIT>
		    ;<FSET? ,PRSO ,CONTBIT>>
	       <PERFORM ,V?BOARD ,PRSO>
	       ;<V-SIT T>)
	      (<FSET? ,PRSO ,PERSONBIT>
	       <HAR-HAR>)
	      (<AND ;<NOT .OBJ> <NOT <FSET? ,PRSO ,TAKEBIT>>>
	       <TELL CHE ,WINNER bang " into" THE ,PRSO>
	       <THIS-IS-IT ,PRSO>
	       <TELL " trying to go through" HIM ,PRSO "." CR>)
	      ;(.OBJ <TELL "You can't do that!" CR>)
	      ;(<IN? ,PRSO ,WINNER>
	       <TELL "You must think you're a contortionist!" CR>)
	      (ELSE <HAR-HAR>)>>

<ROUTINE PRE-EXAMINE () <ROOM-CHECK>>

<ROUTINE V-EXAMINE ("AUX" (TXT <>))
	 <COND (<OR <==? ,PRSO ,PSEUDO-OBJECT>
		    <AND <NOUN-USED? ,W?DOOR ;,W?DOORS ,W?PANEL ;,W?KEYHOLE>
			 <GLOBAL-IN? ,PRSO ,HERE>>>
		<SET TXT T>)>
	 <COND (<DOBJ? INTDIR>
		<SETG CLOCK-WAIT T>
		<TELL "(If you want to see what's there, go there!)" CR>)
	       (<DOBJ? CASTLE HANDS HEAD OTHER-OUTFIT TOWER WALL LIGHT-GLOBAL>
		<NOTHING-SPECIAL>)
	       ;(<DOBJ? NOW-WEARING>
		<TELL <GETP ,PRSO ,P?TEXT> CR>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<AND <IN? ,PRSO ,ROOMS>	;<FSET? ,PRSO ,RLANDBIT>
		     <ZERO? .TXT>>
		<ROOM-PEEK ,PRSO>)
	       (<AND <NOT <EQUAL? <META-LOC ,PRSO> ,HERE>>
		     <NOT <GLOBAL-IN? ,PRSO ,HERE>>
		     <ZERO? .TXT>>
		<TOO-BAD-BUT ,PRSO "too far away">)
	       (<SET TXT <GETP ,PRSO ,P?TEXT>>
		<TELL .TXT CR>)
	       (<FSET? ,PRSO ,DOORBIT>
		<CHECK-DOOR ,PRSO>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,SURFACEBIT>
		    ;<NOUN-USED? ,W?KEYHOLE>>
		<V-LOOK-INSIDE>)
	       (T <NOTHING-SPECIAL>)>>

<ROUTINE NOTHING-SPECIAL ()
	<TELL
"You look over" THE ,PRSO " for a minute and find nothing suspicious
-- for now." CR>>

<ROUTINE GLOBAL-IN? (OBJ1 OBJ2 "AUX" TBL (VAL <>))
	 <COND (<SET TBL <GETPT .OBJ2 ,P?GLOBAL>>
		%<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			'<SET VAL <ZMEMQ  .OBJ1 .TBL <RMGL-SIZE .TBL>>>)
		       (T
			'<SET VAL <ZMEMQB .OBJ1 .TBL <RMGL-SIZE .TBL>>>)>)>
	 <COND (<AND <ZERO? .VAL> <EQUAL? .OBJ1 .OBJ2>>
		<SET VAL T>)>
	 .VAL>

<ROUTINE V-FAINT ()
	<TELL
CHE ,WINNER tri HIS ,WINNER " best, but" HE ,WINNER is " too excited." CR>>

;<ROUTINE PRE-FILL ()
 <COND (<AND ,PRSI ;<NOT <EQUAL? ,PRSI ,GLOBAL-WATER>>>
	<HAR-HAR>)>>

<ROUTINE V-FILL ()
	 <YOU-CANT>
	 ;<TELL "You may know how to do that, but this story doesn't." CR>>

<ROUTINE PRE-FIND ()
	 <COND (<DOBJ? PLAYER PLAYER-NAME>
		<RFALSE>)
	       (<AND <FSET? ,PRSO ,SECRETBIT>
		     <NOT <FSET? ,PRSO ,SEENBIT>>>
		<NO-FUN>)
	       (<IN? ,PRSO ,ROOMS>
		<COND (<==? ,PRSO ,HERE>
		       <ALREADY ,WINNER "here">)
		      (T
		       <PERFORM ,V?WALK-TO ,PRSO>
		       <RTRUE>)>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     ;<NOT <==? ,PRSO ,OTHER-CHAR>>>
		<COND (<AND <==? <META-LOC ,WINNER> <META-LOC ,PRSO>>
			    <NOT <FSET? ,PRSO ,NDESCBIT>>>
		       <BITE-YOU>
		       <RTRUE>)
		      (<NOT <FOLLOW-LOC?>>
		       <WHO-KNOWS? ,PRSO>
		       <RFATAL>)>
		<RTRUE>)>>

<ROUTINE BITE-YOU ()
	<TELL "If" HE ,PRSO " were any closer," HE ,PRSO "'d bite you!" CR>>

<ROUTINE FAR-AWAY? (L)
 <COND (<ZERO? <GETP ,HERE ,P?LINE>>
	<RTRUE>)
       (<EQUAL? .L ,GLOBAL-OBJECTS>
	<RTRUE>)
       (<AND <FSET? .L ,SECRETBIT>
	     <NOT <FSET? .L ,SEENBIT>>>
	<RTRUE>)
       (<AND <EQUAL? .L ,YOUR-ROOM>
	     <EQUAL? ,HERE ,YOUR-BATHROOM>>
	<RFALSE>)
       (<AND <EQUAL? .L ,YOUR-BATHROOM>
	     <EQUAL? ,HERE ,YOUR-ROOM>>
	<RFALSE>)
       (<ZERO? <GETP .L ,P?LINE>>
	<RTRUE>)
       (<AND <NOT <FSET? ,FRIEND ,TOUCHBIT>>
	     <NOT <EQUAL? .L ,CAR ,DRIVEWAY ,COURTYARD>>>
	<RTRUE>)
       (<EQUAL? ,HERE ;,CAR ,DRIVEWAY>
	<COND (<EQUAL? .L ,CAR ,DRIVEWAY>
	       <RFALSE>)
	      (<ZERO? <GETB ,LAST-NAME 0>>
	       <RTRUE>)>)>
 <COND (<OR <AND <FSET? ,HERE ,SECRETBIT>
		 <NOT <FSET? .L ,SECRETBIT>>>
	    <AND <NOT <FSET? ,HERE ,SECRETBIT>>
		 <FSET? .L ,SECRETBIT>>>
	<RETURN <NOT <SEE-INTO? .L <> ;T> ;<GLOBAL-IN? .L ,HERE>>>)>
 <RFALSE>>

<ROUTINE V-FIND ("AUX" (L <LOC ,PRSO>))
	 <COND (<==? ,PRSO ,PLAYER>
		<TELL "You're right here, ">
		<TELL-LOCATION>
		<CRLF>)
	       (<DOBJ? ;EYE HEAD HANDS>
		<BITE-YOU>)
	       (<HELD? ,PRSO>
		<TELL "You have it." CR>)
	       (<OR <FSET? ,PRSO ,SECRETBIT>
		    <==? ,PRSO ,ARTIFACT>>
		<NO-FUN>)
	       (<VISIBLE? ,PRSO>
		;<OR <GLOBAL-IN? ,PRSO ,HERE>
		    ;<EQUAL? <META-LOC ,PRSO> ,HERE>
		    <IN? ,PRSO ,HERE>
		    <==? ,PRSO ,PSEUDO-OBJECT>>
		<COND (<FSET? ,PRSO ,SECRETBIT>
		       <DISCOVER ,PRSO>)
		      (T <TELL "It's right here." CR>)>)
	       (<AND ;<NOT <FSET? ,PRSO ,TOUCHBIT>>
		     <NOT <FSET? ,PRSO ,SEENBIT>>
		     ;<OR <IN? ,PRSO ,ROOMS>
			 ;<FSET? ,PRSO ,PERSONBIT>
			 <FSET? ,PRSO ,SECRETBIT>>>
		<NOT-HERE ,PRSO T>)
	       (<OR <EQUAL? .L ,GLOBAL-OBJECTS ,LOCAL-GLOBALS>
		    ;<EQUAL? ,PRSO ,DRAPES>>
		<TELL "It's around somewhere." CR>)
	       (<FAR-AWAY? <META-LOC ,PRSO>>
		<TELL "It's far away from here." CR>)
	       (<FSET? .L ,PERSONBIT>
		<THIS-IS-IT .L>
		<TELL CTHE .L " probably has it." CR>)
	       (<OR <FSET? .L ,SURFACEBIT>
		    <FSET? .L ,CONTBIT>
		    <IN? .L ,ROOMS>>
		<THIS-IS-IT .L>
		<TELL "It's probably ">
		<COND (<FSET? .L ,SURFACEBIT> <TELL "on">) (T <TELL "in">)>
		<TELL THE .L "." CR>)
	       (ELSE
		<TELL "It's nowhere in particular." CR>)>>

<ROUTINE NO-FUN ()
	<SETG CLOCK-WAIT T>
	<TELL "(If it's that easy, it spoils the fun!)" CR>>

<ROUTINE TELL-LOCATION ("AUX" DIR)
	;<COND (<EQUAL? ,HERE ,UNCONSCIOUS>
	       <TELL "unconscious.">
	       <RTRUE>)>
	<COND (<NOT <IN? ,PLAYER ,HERE>>
	       <TELL "sitting ">)>
	;<COND (<ZERO? ,PLAYER-SEATED>	T)
	      (<L? 0 ,PLAYER-SEATED>	<TELL "sitting ">)
	      (T 			<TELL "lying ">)>
	<COND (<FSET? ,HERE ,SURFACEBIT>
	       <TELL "on">)
	      (T
	       <TELL "in">)>
	<TELL THE ,HERE ".">>

;<ROUTINE V-FIND-WITH () <V-FIND>>

<ROUTINE V-FIX () <MORE-SPECIFIC>>

<ROUTINE FOLLOW-LOC? ("AUX" L)
	 <SET L <GETP ,PRSO ,P?CHARACTER>>
	 <COND ;(<L? ,GHOST-NEW-C .L>
		<RFALSE>)
	       (<SET L <GET ,FOLLOW-LOC .L>>
		<TELL "The last you knew," HE ,PRSO " was ">
		<COND (<FSET? .L ,SURFACEBIT>
		       <TELL "on">)
		      (T <TELL "in">)>
		<TELL-HIS-HER-BEDROOM <GETP ,PRSO ,P?CHARACTER> .L>
		<TELL ".|">
		.L)>>

<ROUTINE V-FOLLOW ("AUX" L)
	 <COND (<==? ,PRSO ,WINNER>
		<YOU-CANT>
		;<NOT-CLEAR-WHOM>)
	       (<AND <NOT <DOBJ? GHOST-NEW>>
		     <NOT <FSET? ,PRSO ,PERSONBIT>>>
		<TELL
"How tragic to see you, a" ,FAMOUS-YOUNG-DETECTIVE", stalking " A ,PRSO "!"CR>)
	       (<==? ,HERE <SET L <META-LOC ,PRSO>>>
		<TELL "You're in the same place as" HE ,PRSO "!" CR>)
	       (<SET L <GET ,FOLLOW-LOC <GETP ,PRSO ,P?CHARACTER>>
		       ;<FOLLOW-LOC?>>
		<PERFORM ,V?WALK-TO .L>)
	       ;(<EQUAL? .L <> ,LOCAL-GLOBALS>
		<TELL CTHE ,PRSO " has left the story." CR>)
	       (T
		<WHO-KNOWS? ,PRSO>
		;<PERFORM ,V?WALK-TO ,PRSO>
		<RFATAL>)>>

<ROUTINE V-FOO () <TELL "[Foo!! This is a bug!!]" CR>>

<ROUTINE V-FORGIVE () <YOU-CANT>>

;<ROUTINE PRE-GIVE ()
	 <COND (<AND <NOT <HELD? ,PRSO>>
		     <NOT <EQUAL? ,PRSI ,PLAYER ,PLAYER-NAME>>>
		<TELL
"That's easy for you to say, since " HE ,WINNER is "n't holding" HIM ,PRSO "."
CR>)>>

<ROUTINE PRE-GIVE ()
	 <COND (<AND <NOT <EQUAL? ,PRSI ,PLAYER ,PLAYER-NAME>>
		     <NOT-HOLDING? ,PRSO>>
		<RTRUE>)>>

<ROUTINE V-GIVE ()
	 <COND (<ZERO? ,PRSI> <YOU-CANT ;"give">)
	       (<NOT <FSET? ,PRSI ,PERSONBIT>>
		<TELL
CHE ,WINNER " can't give " A ,PRSO " to " A ,PRSI "!" CR>)
	       ;(<FSET? ,PRSI ,MUNGBIT>
		<TELL CHE ,PRSI do "n't respond." CR>)
	       (<IOBJ? PLAYER>
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)
	       (<AND <DOBJ? LUGGAGE>
		     <FIRST? ,PRSO>
		     <FSET? ,YOUR-ROOM ,TOUCHBIT>>
		<TELL CHE ,PRSI refuse " your gift." CR>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<TELL CHE ,PRSI accept " your gift." CR>
		<TREASURE-FOUND? ,PRSO ,PRSI>
		<COND (<AND <EQUAL? ,VARIATION <GETP ,PRSI ,P?CHARACTER>>
			    <OR <FSET? ,PRSO ,RMUNGBIT> ;"evidence"
				<EQUAL? ,PRSO ,BLOWGUN ,COSTUME>>>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK-ABOUT ,PRSI ,PRSO>)>
		<RTRUE>)>>

<ROUTINE PRE-SGIVE ("AUX" X)
	<SET X <GET ,P-NAMW 0>>
	<PUT ,P-NAMW 0 <GET ,P-NAMW 1>>
	<PUT ,P-NAMW 1 .X>
	<PERFORM ,V?GIVE ,PRSI ,PRSO>
	<RTRUE>>

<ROUTINE   V-SGIVE () <V-FOO>>

"<ROUTINE PRE-GOODBYE () <PRE-HELLO>>
<ROUTINE V-GOODBYE () <V-HELLO <>>>"

;<ROUTINE PRE-HEAT () <PRE-BURN>>

;<ROUTINE V-HEAT () <TELL CHE ,PRSO " gets a little bit hotter." CR>>

<ROUTINE PRE-HELLO (;"OPTIONAL" ;(STR 0) "AUX" P (WORD <>))
 <COND (<EQUAL? ,P-PRSA-WORD ,W?HELLO ,W?HI>
	<SET WORD " Greet">)
       (<EQUAL? ,P-PRSA-WORD ,W?SORRY>
	<SET WORD " Apologize to">)>
 <COND (<NOT <DOBJ? ROOMS>>
	<COND (<AND <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <NOT <DOBJ? CREW-GLOBAL>>>
	       <WONT-HELP-TO-TALK-TO ,PRSO>
	       <RTRUE>)
	      (<FSET? ,PRSO ,MUNGBIT>
	       <PERFORM ,V?ALARM ,PRSO>
	       <RTRUE>)
	      (<T? .WORD>
	       <TELL ,I-ASSUME .WORD HIM ,PRSO ".]" CR>
	       <RFALSE>)>
	;<UNSNOOZE ,PRSO>
	<COND ;(<NOT <GRAB-ATTENTION ,PRSO>>
	       <RFATAL>)
	      (T <RFALSE>)>)
       (<QCONTEXT-GOOD?>
	<TELL ,I-ASSUME>
	;<COND (<T? .WORD>
	       <TELL .WORD>)>
	<TELL !\  D ,QCONTEXT ".]" CR>
	<PERFORM ,PRSA ,QCONTEXT>
	<RTRUE>)
       (<AND <EQUAL? ,WINNER ,PLAYER>
	     <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	<TELL ,I-ASSUME>
	;<COND (<T? .WORD>
	       <TELL .WORD>)>
	<TELL !\  D .P ".]" CR>
	<PERFORM ,PRSA .P>
	<RTRUE>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELLO () ;("OPTIONAL" (HELL T))
 <COND (<FSET? ,PRSO ,PERSONBIT> ;<GETP ,PRSO ,P?CHARACTER>
	<COND (<NOT <FSET? ,PRSO ,MUNGBIT>>
	       <COND (<ZERO? ,LIT>
		      <TELL "\"Hello.\"" CR>)
		     (T <TELL CHE ,PRSO nod " at you." CR>)>)
	      (T <WONT-HELP-TO-TALK-TO ,PRSO>)>)
       ;(<NOT <DOBJ? ROOMS>>
	<TELL "Only nuts say \""
		<COND (.HELL "Hello") (T "Good-bye")>
		"\" to " A ,PRSO "." CR>)
       (T <NOT-CLEAR-WHOM>)>>

<ROUTINE V-HELP ()
 <COND (<EQUAL? ,PRSO <> ,PLAYER>
	<HELP-TEXT>)
       (T <MORE-SPECIFIC>)>>

<ROUTINE HELP-TEXT ()
	<SETG CLOCK-WAIT T>
	<TELL
"[You'll find plenty of help in your " D ,MOONMIST " package.|
If you're really stuck, you can order an InvisiClues (TM) hint booklet and map
from your dealer or via mail with the form in your package.]" CR>>

<ROUTINE V-KILL () <IKILL "kill">>

<GLOBAL YOU-DIDNT-SAY-W "[You didn't say w">

<ROUTINE IKILL ("OPTIONAL" (STR <>))
	 <COND (<ZERO? ,PRSO>
		<SETG CLOCK-WAIT T>
		<TELL "(There's nothing here to " .STR ".)" CR>)
	       (<ZERO? ,PRSI>
		<SETG CLOCK-WAIT T>
		<TELL ,YOU-DIDNT-SAY-W "hat to " .STR THE ,PRSO>
		<COND (<FSET? ,PRSO ,WEAPONBIT>
		       <TELL " at">)
		      (T ;<FSET? ,PRSO ,PERSONBIT>
		       <TELL " with">)>
		<TELL ".]" CR>)
	       (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<HAR-HAR>)
	       (T <TELL ,NO-VIOLENCE> <RTRUE>)>>

<GLOBAL NO-VIOLENCE "You think it over. There's no need to get violent.|">

<ROUTINE V-KISS ("AUX" X)
	 <COND (<EQUAL? ,PRSO ,PLAYER>
		<TELL "You kiss " 'PLAYER " for a minute. Yuk!" CR>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<FACE-RED>)
	       (T <TELL "What a (ahem!) strange idea!" CR>)>>

<ROUTINE V-KNOCK ("AUX" P)
 <COND (<OR <FSET? ,PRSO ,DOORBIT>
	    ;<EQUAL? ,PRSO ,WINDOW>>
	<COND (<FSET? ,PRSO ,OPENBIT>
	       <TELL "It's open!" CR>)
	      (<AND <SET P <DOOR-ROOM ,HERE ,PRSO>>
		    <SET P <FIND-FLAG .P ,PERSONBIT ,PLAYER>>>
	       <FCLEAR ,PRSO ,LOCKED>
	       <FSET ,PRSO ,OPENBIT>
	       <FSET ,PRSO ,ONBIT>
	       <UNSNOOZE .P>
	       <THIS-IS-IT .P>
	       <TELL CHE .P " opens the door, then retreats into the room."
			  ;"Someone shouts \"Come!\"" CR>)
	      (T <TELL "There's no answer." CR>)>)
       (ELSE
	<SETG CLOCK-WAIT T>
	<TELL "(Why knock on " A ,PRSO "?)" CR>)>>

<ROUTINE V-STAND ("AUX" P)
	 <COND (<AND <==? ,WINNER ,PLAYER>
		     <NOT <IN? ,PLAYER ,HERE>>
		     ;<T? ,PLAYER-SEATED>>
		<OWN-FEET>)
	       (T
		<ALREADY ,WINNER "standing up">)>>

<ROUTINE V-LEAP ()
	 <COND (<AND ,PRSO
		     <NOT <DOBJ? INTDIR>>>
		<YOU-CANT>
		;<PERFORM ,V?BOARD ,PRSO>
		<RTRUE>)
	       (<EQUAL? ,HERE ,DECK ,LOVER-PATH> ;<GETPT ,HERE ,P?DOWN>
		<TELL "This was not a very safe place to try jumping.">
		<FINISH>)
	       (T <V-SKIP>)>>

<ROUTINE V-SKIP ()
	 <COND ;(<FSET? <LOC ,PLAYER> ,VEHBIT>
		<TELL "That would be tough from your current position." CR>)
	       (T <WHEE>)>>

<ROUTINE WHEE ("AUX" X)
	<SET X <RANDOM 5>>
	<COND (<==? 1 .X>
	       <TELL "Very good. Now you can go to the second grade." CR>)
	      (<==? 2 .X>
	       <TELL "I hope you enjoyed that more than I did." CR>)
	      (<==? 3 .X>
	       <TELL "Are you enjoying " 'PLAYER "?" CR>)
	      (<==? 4 .X>
	       <TELL "Wheeeeeeeeee!!!!!" CR>)
	      (T <TELL "Do you expect someone to applaud?" CR>)>>

<ROUTINE V-LEAVE ("AUX" GT)
	<COND (<==? ,WINNER ,FOLLOWER>
	       <SETG FOLLOWER 0>)>
	<COND (<EQUAL? ,PRSO ;<> ,ROOMS ,HERE ,GLOBAL-HERE>
	       <DO-WALK ,P?OUT>
	       <PUTP ,WINNER ,P?LDESC 9 ;"waiting patiently">
	       <COND (<AND <EQUAL? ,WINNER ,FRIEND>
			   <NOT <EQUAL? ,VARIATION ,FRIEND-C>>>
		      <SET GT <GET ,GOAL-TABLES ,FRIEND-C>>
		      <COND (<L? ,BED-TIME ,PRESENT-TIME>
			     <COND (<NOT <EQUAL? ,HERE ,TAMARA-ROOM>>
				    <PUT .GT ,GOAL-FUNCTION ,X-RETIRES>
				    <ESTABLISH-GOAL ,FRIEND ,TAMARA-ROOM>)>)
			    (T
			     <PUT .GT ,GOAL-FUNCTION ,NULL-F>
			     <COND (<NOT <IN? ,LORD ,HERE>>
				    <ESTABLISH-GOAL ,FRIEND <LOC ,LORD>>)>)>)>
	       <RTRUE>)
	      (<EQUAL? <LOC ,PRSO> ,PLAYER ;,POCKET>
	       <PERFORM ,V?DROP ,PRSO>
	       <RTRUE>)
	      (<NOT <==? <LOC ,WINNER> ,PRSO>>
	       <TELL-NOT-IN ,PRSO>
	       <RFATAL>)
	      (T
	       <DO-WALK ,P?OUT>
	       <RTRUE>)>>

<ROUTINE PRE-LIE () <ROOM-CHECK>>

<ROUTINE V-LIE () <V-SIT T>>

<ROUTINE PRE-LISTEN ()
 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
	     <==? <GETP ,PRSO ,P?LDESC> 22 ;"playing the piano">>
	<PERFORM ,V?LISTEN ,PIANO>
	<RTRUE>)
       (T <PRE-ASK-ABOUT>)>>

<ROUTINE V-LISTEN ()
 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
	     <NOT <FSET? ,PRSO ,MUNGBIT>>>
	<WAITING-FOR-YOU-TO-SPEAK>
	<RTRUE>)
       (T
	<TOO-BAD-BUT ,PRSO>
	<TELL " makes no sound." CR>)>>

<ROUTINE V-LOCK ()
 <COND (<FSET? ,PRSO ,DOORBIT>
	<COND (<EQUAL? ,PRSO ,HERE>
	       <OKAY ,PRSO "locked">)
	      (T <TELL-FIND-NONE "a way to lock" ,PRSO>)>)
       (T <YOU-CANT>)>>

<ROUTINE V-LOOK ()
	 <COND (<DESCRIBE-ROOM T>
		<DESCRIBE-OBJECTS ;T>
		;<CRLF>)>>

<ROUTINE V-LOOK-BEHIND ()
 <COND (<AND <FSET? ,PRSO ,DOORBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
	<TOO-BAD-BUT ,PRSO "closed">)
       (T <TELL "There's nothing behind" HIM ,PRSO "." CR>)>>

<ROUTINE V-LOOK-DOWN ()
 <COND (<==? ,PRSO ,ROOMS>
	<TELL
"You see nothing suspicious " <GROUND-DESC> "." CR>)
       (T <HAR-HAR>)>>

<ROUTINE PRE-LOOK-INSIDE () <ROOM-CHECK>>

<ROUTINE V-LOOK-INSIDE ("OPTIONAL" (DIR ,P?IN) "AUX" RM)
	 <COND (<DOBJ? ROOMS>
		<COND (<==? .DIR ,P?OUT>
		       <COND (<GLOBAL-IN? ,WINDOW ,HERE>
			      <PERFORM ,PRSA ,WINDOW ,PRSI>
			      <RTRUE>)>)
		      (T
		       <COND (<OR <FSET? <SET RM ,P-IT-OBJECT> ,CONTBIT>
				  <SET RM <FIND-FLAG-LG ,HERE ,CONTBIT>>
				  <GLOBAL-IN? <SET RM ,WINDOW> ,HERE>
				  <SET RM <FIND-FLAG-LG ,HERE ,DOORBIT>>>
			      <TELL-I-ASSUME .RM>
			      <PERFORM ,PRSA .RM ,PRSI>
			      <RTRUE>)>)>)>
	 <COND (<DOBJ? GLOBAL-HERE>
		<PERFORM ,V?LOOK>
		<RTRUE>)
	       (<AND <IN? ,PRSO ,ROOMS>	;<FSET? ,PRSO ,RLANDBIT>
		     <NOT <NOUN-USED? ,W?DOOR>>
		     <OR <GLOBAL-IN? ,PRSO ,HERE>
			 <SEE-INTO? ,PRSO <>>
			 ;<VISIBLE? ,PRSO>>>
		<ROOM-PEEK ,PRSO>)
	       (<V-LOOK-THROUGH T> <RTRUE>) ;"SWG swapped this & next 5/21/86"
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,SURFACEBIT>>
		<COND (<NOT <SEE-INSIDE? ,PRSO T>>
		       <FIRST-YOU "open" ,PRSO>)>
		<COND (<FIRST? ,PRSO>
		       <TELL "You can see">
		       <PRINT-CONTENTS ,PRSO>
		       ;<PRINT-CONT ,PRSO>
		       <COND (<FSET? ,PRSO ,SURFACEBIT> <TELL " on">)
			     (T <TELL " inside">)>
		       <TELL HIM ,PRSO "." CR>
		       <RTRUE>)
		      (<DOBJ? VICTORIA-CHAIR WRITING-DESK COAT-RACK WYVERN
			      PIANO TABLE-DINING CHAIR-DINING SIDEBOARD>
		       <TELL-LIKE-BROCHURE>)
		      (<FSET? ,PRSO ,SURFACEBIT>
		       <TELL "There's nothing on" HIM ,PRSO>
		       <COND (<IN? ,PLAYER ,PRSO>
			      ;<EQUAL? ,PLAYER-SEATED ,PRSO <- 0 ,PRSO>>
			      <TELL " except you">)>
		       <TELL "." CR>)
		      (T <TOO-BAD-BUT ,PRSO "empty">)>)
	       (<==? .DIR ,P?IN> <YOU-CANT "look inside">)
	       (T ;<==? .DIR ,P?OUT> <YOU-CANT "look outside">)>>

<ROUTINE FIRST-YOU (STR "OPTIONAL" (OBJ 0) (OBJ2 0))
	<TELL !\(>
	<HE-SHE-IT ,WINNER T .STR>
	<COND (<T? .OBJ>
	       <TELL THE ;HIM .OBJ>
	       <COND (<=? .STR "open">
		      <FSET .OBJ ,OPENBIT>)>
	       <COND (<T? .OBJ2>
		      <TELL " from" THE ;HIM .OBJ2>)>)>
	<TELL " first.)" CR>>

<ROUTINE V-LOOK-THROUGH ("OPTIONAL" (INSIDE <>) "AUX" RM)
	 <COND (<FSET? ,PRSO ,DOORBIT>
		<COND (<OR <FSET? ,PRSO ,OPENBIT>
			   <FSET? ,PRSO ,TRANSBIT>
			   ;<NOUN-USED? ,W?KEYHOLE>>
		       <COND (<SET RM <DOOR-ROOM ,HERE ,PRSO>>
			      <ROOM-PEEK .RM T>)
			     (T <NO-BEYOND>)>)
		      (<ZMEMQ ,PRSO ,CHAR-ROOM-TABLE>
		       <PERFORM ,PRSA ,KEYHOLE>
		       <RTRUE>)
		      (T
		       <TOO-BAD-BUT ,PRSO "closed">)>)
	       (<EQUAL? ,PRSO ,WINDOW>
		<COND ;(<SET RM <WINDOW-ROOM ,HERE ,PRSO>>
		       <ROOM-PEEK .RM T>)
		      (T <NO-BEYOND>)>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL "You forgot to bring your X-ray glasses." CR>)
	       (.INSIDE <RFALSE>)
	       (<FSET? ,PRSO ,TRANSBIT>
		<TELL "Everything looks bigger." CR>)
	       (T <YOU-CANT "look through">)>>

<ROUTINE NO-BEYOND () <TELL "You can't tell what's beyond" HIM ,PRSO "." CR>>

<ROUTINE ROOM-PEEK (RM "OPTIONAL" (SAFE <>) "AUX" (X <>) OHERE OLIT TXT)
	 <COND (<EQUAL? .RM ,HERE>
		<V-LOOK>
		<RTRUE>)
	       (<OR .SAFE <SEE-INTO? .RM>>
		<SET OHERE ,HERE>
		<SET OLIT ,LIT>
		<SETG HERE .RM>
		<MAKE-ALL-PEOPLE -12 ;"listening to you">
		<SETG LIT <LIT? ;,HERE>>
		<TELL "You peer ">
		<COND (<FSET? .RM ,SURFACEBIT> <TELL "at">) (T <TELL "into">)>
		<TELL HIM .RM !\: CR>
		<COND (<DESCRIBE-OBJECTS ;T> <SET X T>)
		      (<SET TXT <GETP .RM ,P?LDESC>>
		       <SET X T>
		       <TELL .TXT CR>)>
		;<COND (<CORRIDOR-LOOK> <SET X T>)>
		<COND (<ZERO? .X>
		       <TELL "You can't see anything suspicious." CR>)>
		<SETG HERE .OHERE>
		<SETG LIT .OLIT>
		<RTRUE>)>>

<ROUTINE SEE-INTO? (THERE "OPTIONAL" (TELL? T) (IGNORE-DOOR <>)"AUX" P L TBL O)
 ;<COND (<AND <EQUAL? ,CAR ,HERE .THERE>
	     <EQUAL? <GETP ,CAR ,P?STATION> ,HERE .THERE>>
	<RTRUE>)>
 <COND (<CORRIDOR-LOOK .THERE>
	<RTRUE>)>
 <SET P 0>
 <REPEAT ()
	 <COND (<OR <0? <SET P <NEXTP ,HERE .P>>>
		    <L? .P ,LOW-DIRECTION>>
		<COND (.TELL? <TELL-CANT-FIND>)>
		<RFALSE>)>
	 <SET TBL <GETPT ,HERE .P>>
	 <SET L <PTSIZE .TBL>>
	 <COND (<==? .L ,UEXIT>
		<COND (<==? <GET-REXIT-ROOM .TBL> .THERE>
		       <RTRUE>)>)
	       (<==? .L ,DEXIT>
		<COND (<==? <GET-REXIT-ROOM .TBL> .THERE>
		       <COND (<FSET? <GET-DOOR-OBJ .TBL> ,OPENBIT>
			      <RTRUE>)
			     (<WALK-THRU-DOOR? .TBL <GET-DOOR-OBJ .TBL> <>
								       ;.TELL?>
			      <RTRUE>)
			     (<T? .IGNORE-DOOR>
			      <RTRUE>)
			     (T
			      <COND (.TELL?
				     <SETG CLOCK-WAIT T>
				     <TELL
"(The door to that room is closed.)" CR>)>
			      <RFALSE ;RTRUE>)>)>)
	       (<==? .L ,CEXIT>
		<COND (<==? <GET-REXIT-ROOM .TBL> .THERE>
		       <COND (<VALUE <GETB .TBL ,CEXITFLAG>>
			      <RTRUE>)
			     (T
			      <COND (.TELL? <TELL-CANT-FIND>)>
			      <RFALSE>)>)>)>>>

<ROUTINE TELL-CANT-FIND ()
	<SETG CLOCK-WAIT T>
	<TELL "(That place isn't close enough.)"
	      ;"You can't seem to find that room." CR>>

<ROUTINE V-LOOK-ON ()
	 <COND (<FSET? ,PRSO ,SURFACEBIT>
		<V-LOOK-INSIDE>)
	       (T <TELL "There's no good surface on" HIM ,PRSO "." CR>)>>

<ROUTINE V-LOOK-OUTSIDE () <V-LOOK-INSIDE ,P?OUT>>

<ROUTINE PRE-LOOK-UNDER () <ROOM-CHECK>>

<ROUTINE V-LOOK-UNDER ()
	 <COND (<DOBJ? EYE HANDS HEAD>
		<WONT-HELP>)
	       (<HELD? ,PRSO>
		<TELL "You're ">
		<COND (<FSET? ,PRSO ,WORNBIT>
		       <TELL "wear">)
		      (T <TELL "hold">)>
		<TELL "ing" THE ,PRSO "!" CR>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<TELL "Nope. Nothing hiding under" HIM ,PRSO "." CR>)
	       (<AND ;<EQUAL? ,PRSO ,COSTUME ,BLOWGUN>
		     <EQUAL? <LOC ,PRSO> ,VIVIEN-BOX ,WENDISH-KIT>>
		<TELL "There's more stuff there." CR>)
	       (<EQUAL? <LOC ,PRSO> ,HERE ,LOCAL-GLOBALS ;,GLOBAL-OBJECTS>
		<TELL "There's nothing there but dust." CR>)
	       (T
		<TELL "That's not a bit useful." CR>)>>

<ROUTINE V-LOOK-UP ("AUX" HR)
	 <COND (<T? ,PRSI>
		<TELL
"There's no information in" THE ,PRSI " about" THE ,PRSO "." CR>)
	       (<DOBJ? ROOMS>
		<COND (<OUTSIDE? ,HERE>
		       <PERFORM ,V?EXAMINE ,MOON>
		       <RTRUE>)
		      (<CREEPY? ,HERE>
		       <TELL "Shadows play on the stone ceiling">
		       <COND (<EQUAL? ,HERE ,SITTING-PASSAGE>
			      <TELL " and" THE ,SECRET-SITTING-DOOR>)>
		       <TELL "." CR>)
		      (T
		       <TELL
"The ceiling is decorated with swirly lines and patterns.">
		       <COND (<AND <==? ,HERE ,TAMARA-ROOM>
				   <T? <GETP ,LUMBER-ROOM ,P?CORRIDOR>>>
			      <TELL " There's a hole directly over the bed.">)>
		       <CRLF>)>)
	       (T <YOU-CANT "look up">)>>

;<ROUTINE V-MAKE () <YOU-CANT>>

<ROUTINE PRE-MEET ()
 <COND (<IN? ,PRSO ,HERE>
	<PERFORM ,V?HELLO ,PRSO>
	<RTRUE>)
       (T
	<PERFORM ,V?WALK-TO ,PRSO>
	<RTRUE>)>>

<ROUTINE V-MEET () <V-FOO>>

<ROUTINE PRE-MOVE ()
	 <COND (<HELD? ,PRSO>
		<TELL "Juggling isn't one of your talents." CR>)>>

<ROUTINE V-MOVE ()
	 <COND (<FSET? ,PRSO ,TAKEBIT>
		<TELL "Moving" HIM ,PRSO " reveals nothing." CR>)
	       (T <YOU-CANT ;"move">)>>

<ROUTINE PRE-MOVE-DIR ()
 <COND (<NOT <IOBJ? INTDIR>>
	<DONT-UNDERSTAND>
	<RTRUE>)>>

<ROUTINE V-MOVE-DIR ()
	<TELL
"You can't move" HIM ,PRSO " in any particular " D ,INTDIR "." CR>>

<ROUTINE V-NOD ()
 <COND (<NOT <DOBJ? ROOMS>>
	<YOU-CANT>)
       (<T? ,AWAITING-REPLY>
	<PERFORM ,V?YES>
	<RTRUE>)
       (T
	<PERFORM ,V?HELLO ,ROOMS>
	<RTRUE>)>>

<ROUTINE V-OPEN ("AUX" F STR)
	 <COND (<NOT <OR <FSET? ,PRSO ,CONTBIT>
			 <FSET? ,PRSO ,DOORBIT>
			 <EQUAL? ,PRSO ,WINDOW>>>
		<YOU-CANT ;"open">)
	       (<OR <FSET? ,PRSO ,DOORBIT>
		    <EQUAL? ,PRSO ,WINDOW>
		    <NOT <==? <GETP ,PRSO ,P?CAPACITY> 0>>>
		;<COND (<AND <FSET? ,PRSO ,SECRETBIT>
			    <NOT <FSET? ,PRSO ,SEENBIT>>>
		       <NOT-FOUND ,PRSO>
		       <RTRUE>)>	;"in PLAYER-F"
		<COND (<FSET? ,PRSO ,LOCKED>
		       <COND (<UNLOCK-DOOR? ,PRSO>
			      <FCLEAR ,PRSO ,LOCKED>
			      <FIRST-YOU "unlock" ,PRSO>)
			     (T <TOO-BAD-BUT ,PRSO "locked"> <RTRUE>)>)>
		<COND (<FSET? ,PRSO ,OPENBIT>
		       <ALREADY ,PRSO "open">)
		      ;(<FSET? ,PRSO ,MUNGBIT>
		       <TELL
"You can't open it. The latch is broken." CR>)
		      (T
		       <FSET ,PRSO ,OPENBIT>
		       <COND (<OR <FSET? ,PRSO ,DOORBIT>
				  <EQUAL? ,PRSO ,WINDOW>
				  <NOT <FIRST? ,PRSO>>
				  <FSET? ,PRSO ,TRANSBIT>>
			      <OKAY ,PRSO "open">)
			     ;(<AND <SET F <FIRST? ,PRSO>>
				   <NOT <NEXT? .F>>
				   <SET STR <GETP .F ,P?FDESC>>>
			      <TELL "You open" HIM ,PRSO !\. CR>
			      <TELL .STR CR>)
			     (T
			      <TELL "You open" HIM ,PRSO " and see">
			      <PRINT-CONTENTS ,PRSO>
			      <TELL "." CR>)>)>)
	       (T <YOU-CANT ;"open">)>>

<ROUTINE PRE-OPEN-WITH ()
 <COND (<NOT-HOLDING? ,PRSI> <RTRUE>)>>

<ROUTINE V-OPEN-WITH () <PERFORM ,V?OPEN ,PRSO> <RTRUE>>

;<ROUTINE V-PASS () <PERFORM ,V?WALK-TO ,PRSO> <RTRUE>>

<ROUTINE V-PLAY ()
	 <SETG CLOCK-WAIT T>
	 <TELL
"[Speaking of playing, you'd enjoy Infocom's other fictions, too!]" CR>>

"<ROUTINE PRE-POCKET () <PERFORM ,V?PUT-IN ,PRSO ,POCKET> <RTRUE>>
<ROUTINE   V-POCKET () <V-FOO>>"

<ROUTINE V-POUR () <YOU-CANT>>

<ROUTINE V-PRAY ()
	<TELL
"\"From ghoulies and ghosties and long-leggety beasties|
And things that go bump in the night, Good Lord, deliver us!\"" CR>>

<ROUTINE V-PUSH () <HACK-HACK "Pushing">>

<ROUTINE WEAR-CHECK ("AUX" X)
	 <COND (<EQUAL? ,NOW-WEARING ,PRSO>
		<COND (<AND <NOUN-USED? ,W?CLOTHES>
			    <SET X <FIND-OUTFIT>>>
		       <TELL-I-ASSUME .X>
		       <SETG PRSO .X>
		       <RFALSE>)
		      (T
		       <YOU-CANT <> <> "being worn">
		       <RTRUE>)>)>>

<ROUTINE PRE-PUT ()
	 <COND (<WEAR-CHECK> <RTRUE>)>
	 <FCLEAR ,PRSO ,WORNBIT>
	 <COND ;(<HELD? ,PRSO>			;"SYNTAX says HAVE"
		<RFALSE>)
	       ;(<NOT <FSET? ,PRSO ,TAKEBIT>>	;"SYNTAX says TAKE"
		<YOU-CANT "pick up">
		<RTRUE>)
	       (<DOBJ? HEAD HANDS OTHER-OUTFIT>
		<WONT-HELP>
		<RTRUE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>
		<RTRUE>)
	       (<IOBJ? FLOOR GLOBAL-HERE ;POCKET>
		<RFALSE>)
	       (<IN? ,PRSI ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSI>
		<RTRUE>)>>

<ROUTINE V-PUT ()
	 <COND (<FSET? ,PRSI ,PERSONBIT>
		<SETG WINNER ,PRSI>
		<PERFORM ,V?WEAR ,PRSO>
		<RTRUE>)
	       (<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <IOBJ? BOOKCASE>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<COND (T ;<NOT <FSET? ,PRSI ,SURFACEBIT>>
		       <TELL "There's no good surface on" HIM ,PRSI "." CR>)>
		<RTRUE>)>
	 <PUT-ON-OR-IN>>

<ROUTINE TELL-FIND-NONE (STR "OPTIONAL" (OBJ <>))
	<TELL "You search for " .STR>
	<COND (<T? .OBJ> <TELL THE .OBJ>)>
	<TELL " but find none." CR>>

<ROUTINE PRE-PUT-IN ()
 <COND (<EQUAL? <GET ,P-OFW 1> ,W?FRONT>
	<PERFORM ,V?DROP ,PRSO>
	<RTRUE>)
       (<IOBJ? CHAIR EARRING FIREPLACE PSEUDO-OBJECT>
	<RETURN <PRE-PUT>>)
       (<IOBJ? INKWELL MOONMIST>
	<YOU-SHOULDNT " in">
	<RFATAL>)
       (<IOBJ? EYE HANDS HOLE-IN-WALL OCEAN PEEPHOLE PEEPHOLE-2>
	<WONT-HELP>
	<RFATAL>)
       (<FSET? ,PRSI ,READBIT>
	<WONT-HELP>
	<RFATAL>)
       (<NOT <FSET? ,PRSI ,CONTBIT>>
	<TELL-FIND-NONE "an opening in" ,PRSI>
	<RFATAL>)>
 <COND (<NOT <FSET? ,PRSI ,OPENBIT>>
	<FIRST-YOU "open" ,PRSI>
	;<TOO-BAD-BUT ,PRSI "closed">)>
 <PRE-PUT>>

<ROUTINE V-PUT-IN ()
	 <COND (<AND <NOT <FSET? ,PRSI ,OPENBIT>>
		     <NOT <FSET? ,PRSI ,VEHBIT>>>
		<COND (<OPENABLE? ,PRSI>
		       <TOO-BAD-BUT ,PRSI "closed">)
		      (T <TELL "You can't open" HIM ,PRSI "." CR>)>
		<RTRUE>)>
	 <PUT-ON-OR-IN>>

<GLOBAL NOT-ENOUGH-ROOM "There's not enough room.|">

<ROUTINE PUT-ON-OR-IN ()
	 <COND (<ZERO? ,PRSI> <YOU-CANT ;"put">)
	       (<==? ,PRSI ,PRSO>
		<HAR-HAR>)
	       (<IN? ,PRSO ,PRSI>
		<TOO-BAD-BUT ,PRSO>
		<TELL " is already "
			<COND (<FSET? ,PRSI ,SURFACEBIT> "on") (T "in")>
			HIM ,PRSI "!" CR>)
	       ;(<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
		     <NOT <FSET? ,PRSI ,OPENBIT>>>
		<TOO-BAD-BUT ,PRSI "closed">)
	       (<G? <+ <WEIGHT ,PRSI> <GETP ,PRSO ,P?SIZE>>
		    ;<- * <GETP ,PRSI ,P?SIZE>>
		    <GETP ,PRSI ,P?CAPACITY>>
		<TELL ,NOT-ENOUGH-ROOM>
		<RTRUE>)
	       (<AND <NOT <HELD? ,PRSO>>
		     <NOT <ITAKE>>>
		<RTRUE>)
	       (T
		<MOVE ,PRSO ,PRSI>
		<FSET ,PRSO ,TOUCHBIT>
		<COND (<AND <FSET? ,PRSI ,PERSONBIT>
			    <FSET? ,PRSO ,WEARBIT>>
		       <FSET ,PRSO ,WORNBIT>)>
		<TELL "Okay." CR>)>>

"WEIGHT:  Get sum of SIZEs of supplied object," ;" recursing to the nth level."

<ROUTINE WEIGHT (OBJ "AUX" CONT (WT 0))
	 <COND (<SET CONT <FIRST? .OBJ>>
		<REPEAT ()
			<COND ;(<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? .CONT ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"worn things shouldn't count"
			      ;(<AND <EQUAL? .OBJ ,PLAYER>
				    <FSET? <LOC .CONT> ,WORNBIT>>
			       <SET WT <+ .WT 1>>)
			              ;"things in worn things shouldn't count"
			      (T
			       <SET WT <+ .WT <GETP .CONT ,P?SIZE>>>)>
			<COND (<NOT <SET CONT <NEXT? .CONT>>> <RETURN>)>>)>
	 .WT ;<+ .WT <GETP .OBJ ,P?SIZE>>>

<ROUTINE V-PUT-UNDER () <TELL ,NOT-ENOUGH-ROOM>>

<ROUTINE PRE-SREAD () <PERFORM ,V?READ ,PRSI ,PRSO> <RTRUE>>
<ROUTINE V-SREAD () <V-FOO>>

<ROUTINE PRE-READ ("AUX" VAL)
	 <COND ;(<ZERO? ,LIT> <TOO-DARK> <RTRUE>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)>>

<ROUTINE V-READ ()
	 <COND (<NOT <FSET? ,PRSO ,READBIT>> <YOU-CANT ;"read">)
	       (ELSE <TELL <GETP ,PRSO ,P?TEXT> CR>)>>

<ROUTINE V-REMOVE ()
	 <COND (<FSET? ,PRSO ,WORNBIT>
		<PERFORM ,V?TAKE-OFF ,PRSO>
		<RTRUE>)
	       (T
		<PERFORM ,V?TAKE ,PRSO>
		<RTRUE>)>>

<ROUTINE V-RING () <YOU-CANT>>

<ROUTINE V-RUB ()
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>
		     <NOT <EQUAL? ,PRSO ,PLAYER>>>
		<FACE-RED>)
	       (T <HACK-HACK "Rubbing" ;"Fiddling with">)>>

<ROUTINE V-SAY ("AUX" P)
 <COND (<QCONTEXT-GOOD?>
	<PERFORM ,V?TELL ,QCONTEXT>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL-I-ASSUME .P " Say to">
	<PERFORM ,V?TELL .P>
	<RTRUE>)
       (T
	<NOT-CLEAR-WHOM>)>>

;<ROUTINE PRE-SAY-INTO ()
 <COND (<NOT <FSET? ,PRSO ,ONBIT>>
	<TELL "Sorry, but" HE ,PRSO is "n't on!" CR>)>>

;<ROUTINE V-SAY-INTO () <YOU-CANT "talk into">>

<ROUTINE PRE-SEARCH () <ROOM-CHECK>>

<ROUTINE V-SEARCH ("AUX" OBJ)
	 <COND (<IN? ,PRSO ,ROOMS>
		<PERFORM ,PRSA ,GLOBAL-HERE>
		<RTRUE>
		;<START-SEARCH>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <SET OBJ <FIRST? ,PRSO>>>
		<FSET .OBJ ,TAKEBIT>
		<FCLEAR .OBJ ,NDESCBIT>
		<FCLEAR .OBJ ,WORNBIT>
		<FCLEAR .OBJ ,SECRETBIT>
		<THIS-IS-IT .OBJ>
		<MOVE .OBJ ,PLAYER>
		;<COND (<EQUAL? .OBJ ,MUSTACHE>
		       <SETG WENDISH-BARE T>)>
		<TELL
"You find " A .OBJ " and take it. " !\Y ,OU-STOP-SEARCHING "." CR>)
	       (<AND <SET OBJ <FIND-FLAG ,PRSO ,SECRETBIT>>
		     ;<FSET? .OBJ ,NDESCBIT>>
		<DISCOVER .OBJ ,PRSO>)
	       (<FSET? ,PRSO ,DOORBIT>
		<NOTHING-SPECIAL>)
	       (<OR <FSET? ,PRSO ,CONTBIT>
		    <FSET? ,PRSO ,SURFACEBIT>>
		<PERFORM ,V?LOOK-INSIDE ,PRSO>
		<RTRUE>)
	       (T <NOTHING-SPECIAL>
		;<TELL "You find nothing suspicious." CR>)>>

<GLOBAL OU-STOP-SEARCHING "ou stop searching">

<ROUTINE DISCOVER (OBJ "OPTIONAL" (WHERE 0))
	<COND (<NOT <EQUAL? .OBJ ,YOUR-SWITCH>>
	       <FCLEAR .OBJ ,NDESCBIT>)>
	<FCLEAR .OBJ ,SECRETBIT>
	<FCLEAR .OBJ ,WORNBIT>
	<COND (<ZERO? .WHERE>
	       <SET WHERE <LOC .OBJ>>)>
	<COND (<NOT <EQUAL? .OBJ ,MOONMIST ,YOUR-SWITCH>>
	       <FSET .OBJ ,TAKEBIT>)>
	<COND (<OR <EQUAL? .WHERE ,COFFIN ,INKWELL ,JEWELRY-CASE>
		   ;<EQUAL? .WHERE ,BOTTLE ,WELL>>
	       <TELL "Inside the " D .WHERE>)
	      (<EQUAL? .WHERE ,PAINT>
	       <TELL "Under the " D .WHERE>)
	      (<EQUAL? ,HERE ,GARDEN ;,DRIVEWAY>
	       <COND ;(<==? .WHERE ,POND>
		      <TELL "Projecting above the water">)
		     (T <TELL "Buried in the dirt">)>)
	      (<EQUAL? ,HERE ,CRYPT>
	       <TELL "Hanging on the neck of the " D .WHERE>)
	      ;(<EQUAL? ,HERE ,LIBRARY>
	       <TELL "Sitting in the " D ,BOOKCASE>)
	      (<EQUAL? ,HERE ,YOUR-ROOM>
	       <TELL "Behind the " D ,YOUR-MIRROR>)
	      ;(<EQUAL? ,HERE ,COURTYARD>
	       <TELL "Resting on the " D ,FRONT-GATE>)
	      (<EQUAL? ,HERE ,GREAT-HALL>
	       <TELL "Inside the helmet of the " D ,ARMOR>)
	      (<EQUAL? ,HERE ,CHAPEL>
	       <TELL "Stuck on the apple of the " D ,STAINED-WINDOW>)
	      (<EQUAL? ,HERE ,GAME-ROOM>
	       <TELL "Hidden behind the " 'GLASS-EYE " of the " D ,RHINO-HEAD>)
	      (<EQUAL? ,HERE ,WENDISH-ROOM>
	       <TELL "Underneath some items in the " 'WENDISH-KIT>)
	      ;(<EQUAL? ,HERE ,HYDE-ROOM>
	       <COND (<EQUAL? .OBJ ,COSTUME>
		      <TELL ,HIDDEN-UNDER-PILLOWS>)
		     (T <TELL "Inside Hyde's zip leather toilet kit">)>)
	      (<EQUAL? ,HERE ,TAMARA-ROOM>
	       <TELL "Neatly hidden under the bed">)
	      (<EQUAL? ,HERE ,JACK-ROOM>
	       <TELL "Inside a drawer of the tallboy"
		     ;"Hidden on a high shelf; Inside the 'CREST">)
	      (<EQUAL? ,HERE ,STUDY ,LUMBER-ROOM>
	       <TELL "Among some papers">)
	      (<EQUAL? ,HERE ,VIVIEN-ROOM>
	       <COND ;(<EQUAL? .OBJ ,COSTUME ,BLOWGUN>
		      <TELL
"Snugly stashed inside a wraparound batik cotton skirt in a drawer">)
		     (T <TELL "Inside" THE ,VIVIEN-BOX>)>)
	      ;(<EQUAL? ,HERE ,IAN-ROOM>
	       <TELL "Tightly stuffed into his riding boots">)
	      ;(<EQUAL? ,HERE ,BASEMENT>
	       <TELL "Inside the " 'WELL>)
	      (T ;<T? .WHERE>
	       <COND (<OR <FSET? .WHERE ,SURFACEBIT>
			  <FSET? .WHERE ,PERSONBIT>>
		      <TELL "On">)
		     (T <TELL "In">)>
	       <TELL THE .WHERE>)
	      ;(T <TELL "Here">)>
	<COND (<EQUAL? .OBJ ,COSTUME>
	       <TELL " are a shimmering white gown and blonde wig">)
	      (T <TELL " is " A .OBJ>)>
	<THIS-IS-IT .OBJ>
	<FSET .OBJ ,SEENBIT>
	<COND (<VERB? SEARCH SEARCH-FOR>
	       <TELL ", so y" ,OU-STOP-SEARCHING>)>
	<COND (<EQUAL? ,HERE ,TAMARA-ROOM>
	       ;<NOT <EQUAL? .OBJ ,MOONMIST>>
	       <MOVE .OBJ ,PLAYER>
	       <COND (<VERB? SEARCH SEARCH-FOR>
		      <TELL " and ">)
		     (T <TELL ", so you ">)>
	       <TELL "take it">)>
	<TELL ".|">
	<COND (<AND <EQUAL? .OBJ ,COSTUME>
		    <ZERO? <GET ,FOUND-COSTUME ,PLAYER-C>>>
	       <CONGRATS ,COSTUME>)
	      (<AND <SET WHERE <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT,PLAYER>>
		    <NOT <EVIDENCE? .OBJ .WHERE>>>
	       <GOOD-SHOW .WHERE .OBJ>)>
	<COND (<AND ;<T? ,CLUE-1-KNOWN>
		    <==? .OBJ ,TREASURE>>
	       <CONGRATS ,ARTIFACT>)>
	<RTRUE>>

<ROUTINE CONGRATS ("OPT" (FOUND <>))
	<TELL "|
(Congratulations, "TN"! You've ">
	<COND (<==? .FOUND ,COSTUME>
	       <TELL ,IDENTIFIED-THE-GHOST>)
	      (T
	       <TELL "found">
	       <COND (<ZERO? .FOUND>
		      <TELL " evidence of the crime">)
		     (T <TELL THE .FOUND>)>)>
	<TELL "!)" CR>
	<COND (<==? .FOUND ,ARTIFACT>
	       <SETG TREASURE-FOUND ,TREASURE>
	       <COND (<AND <T? <GET ,FOUND-COSTUME ,PLAYER-C>>
			   <T? ,CONFESSED>>
		      <WRAP-UP>
		      <FINISH>)>)
	      (<==? .FOUND ,COSTUME>
	       <PUT ,FOUND-COSTUME ,PLAYER-C T>
	       <COND (<AND <T? ,TREASURE-FOUND>
			   <T? ,CONFESSED>>
		      <WRAP-UP>
		      <FINISH>)>)>
	<RTRUE>>

<ROUTINE PRE-SSEARCH-FOR () <PERFORM ,V?SEARCH-FOR ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSEARCH-FOR () <V-FOO>>

<ROUTINE PRE-SEARCH-FOR ("AUX" OBJ)
 <COND (<ROOM-CHECK> <RTRUE>)
       ;(<AND <IN? ,PRSI ,PLAYER>
	     ;<GETP ,PRSI ,P?GENERIC>
	     <SET OBJ <APPLY <GETP ,PRSI ,P?GENERIC> ,PRSI>>>
	<SETG PRSI .OBJ>)>
 ;<COND (<DOBJ? ;GLOBAL-ROOM GLOBAL-HERE>
	<PERFORM ,PRSA ,HERE>
	<RTRUE>)>
 <RFALSE>>

<ROUTINE V-SEARCH-FOR ()
	 <COND (<IN? ,PRSO ,ROOMS>
		<PERFORM ,PRSA ,GLOBAL-HERE ,PRSI>
		<RTRUE>
		;<START-SEARCH>)
	       (<FSET? ,PRSO ,PERSONBIT>
		<COND (<IN? ,PRSI ,PRSO>
		       <TELL "Indeed," HE ,PRSO has HIM ,PRSI "." CR>)
		      (T
		       <TELL CTHE ,PRSO " doesn't have">
		       <COND (<IN? ,PRSI ,GLOBAL-OBJECTS>
			      <TELL THE ,PRSI "." CR>)
			     (<ZERO? ,PRSI>
			      <TELL " that." CR>)
			     (T
			      <TELL
THE ,PRSI " hidden on" HIS ,PRSO " person." CR>)>)>
		<RTRUE>)
	       (<AND <FSET? ,PRSO ,CONTBIT> <NOT <FSET? ,PRSO ,OPENBIT>>>
		<TELL "You'll have to open" HIM ,PRSO " first." CR>)
	       (<IN? ,PRSI ,PRSO>
		<COND (<FSET? ,PRSI ,SECRETBIT>
		       <DISCOVER ,PRSI>)
		      (T <TELL
"How observant you are! There" HE ,PRSI is "!" CR>)>)
	       (<ZERO? ,PRSI> <YOU-CANT ;"search">)
	       (T
		<TELL "You don't find">
		<COND (<FSET? ,PRSI ,SECRETBIT>
		       ;<==? <GET ,P-NAMW 1> ,W?EVIDENCE>
		       <TELL " it" ;" any evidence">)
		      (T <TELL HIM ,PRSI>)>
		<TELL " there." CR>)>>

;<ROUTINE V-SEND () <YOU-CANT ;"send">>

;<ROUTINE PRE-SSEND () <PERFORM ,V?SEND ,PRSI ,PRSO> <RTRUE>>
;<ROUTINE   V-SSEND () <V-FOO>>

;<ROUTINE V-SEND-OUT () <V-SEND>>

;<ROUTINE PRE-SEND-TO ()
 <COND (<OR <EQUAL? ,PRSI <> ,PLAYER ,GLOBAL-HERE>
	    <EQUAL? ,PRSI ,PLAYER-NAME>>
	<RFALSE>)
       (<FSET? ,PRSO ,PERSONBIT>
	<PERFORM ,V?$CALL ,PRSO>
	<COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
	       <PERFORM ,V?WALK-TO ,PRSI>)>
	<RTRUE>)
       (T
	<DONT-UNDERSTAND>)>>

;<ROUTINE V-SEND-TO () <V-SEND>>

<ROUTINE V-SHAKE ("AUX" X)
	 <COND (<NOT <FSET? ,PRSO ,TAKEBIT>>
		<SETG CLOCK-WAIT T>
		<TELL "(You can't shake it if you can't take it!)" CR>)
	       (<AND <NOT <FSET? ,PRSO ,OPENBIT>>
		     <FIRST? ,PRSO>>
		<TELL
"It sounds as if there is something inside" HIM ,PRSO "." CR>)
	       (<AND <FSET? ,PRSO ,OPENBIT> <SET X <FIRST? ,PRSO>>>
		<TELL "Right " <GROUND-DESC> ;"Onto the ">
		;<COND (<OUTSIDE? ,HERE> <TELL "ground">)
		      (T <TELL "floor">)>
		<TELL " spill">
		<COND (<ZERO? <NEXT? .X>> <TELL !\s>)>
		<ROB ,PRSO ,HERE T>
	        <CRLF>)
	       (T <TELL "You hear nothing inside" HIM ,PRSO "." CR>)>>

<ROUTINE V-SHOOT ()
 <COND (<AND <OR <ZERO? ,PRSI>
		 <NOT <EQUAL? <LOC ,PRSI> ,WINNER ;,POCKET>>>
	     <NOT <FIND-FLAG ,WINNER ,WEAPONBIT>>
	     ;<NOT <FIND-FLAG ,POCKET ,WEAPONBIT>>>
	<TELL "You're not holding anything to shoot with." CR>)
       (T <IKILL "shoot">)>>

<ROUTINE PRE-SSHOOT () <PERFORM ,V?SHOOT ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-SSHOOT () <V-FOO>>

;<ROUTINE PRE-SHOW ()
	 <COND (<IN? ,PRSO ,ROOMS>	;"SHOW ME TO MY ROOM"
		<PERFORM ,V?TAKE-TO ,PRSI ,PRSO>
		<RTRUE>)>>

<ROUTINE V-SHOW ()
	 <COND (<==? ,PRSO ,PLAYER>
		<SETG WINNER ,PLAYER>
		<COND (<VISIBLE? ,PRSO> <PERFORM ,V?EXAMINE ,PRSI>)
		      (T <PERFORM ,V?FIND ,PRSI>)>
		<RTRUE>)
	       (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <FSET? ,PRSO ,MUNGBIT>>
		<TELL "Don't wait for" HIM ,PRSO " to applaud." CR>)
	       (T <WHO-CARES>)>>

<ROUTINE PRE-SSHOW ("AUX" P)
  <COND (<T? ,PRSI>
	 <SETG P-MERGED T>
	 <COND (<IN? ,PRSI ,ROOMS>	;"SHOW ME TO MY ROOM"
		<PERFORM ,V?TAKE-TO ,PRSO ,PRSI>
		<RTRUE>)>
	 <PERFORM ,V?SHOW ,PRSI ,PRSO>
	 <RTRUE>)
	(<NOT <HELD? ,PRSO>>
	 <COND (<FSET? <LOC ,PRSO> ,PERSONBIT>
		<PERFORM ,V?TAKE ,PRSO>)
	       (T
		<TELL-I-ASSUME ,PRSO " Ask about">
		<PERFORM ,V?ASK-CONTEXT-ABOUT ,PRSO>)>
	 <RTRUE>)
	(<QCONTEXT-GOOD?>
	 <PERFORM ,V?SHOW ,QCONTEXT ,PRSO>
	 <RTRUE>)
	(<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	 <TELL-I-ASSUME .P " Show">
	 <PERFORM ,V?SHOW .P ,PRSO>
	 <RTRUE>)
	(T
	 <TELL-I-ASSUME ,PLAYER " Show">
	 <PERFORM ,V?SHOW ,PLAYER ,PRSO>
	 <RTRUE>)>>

<ROUTINE V-SSHOW () <V-FOO>>

<ROUTINE V-SIGN () <TELL "You would use your usual hand." CR>
		   ;<YOU-CANT "write on">>

<ROUTINE PRE-SIT () <ROOM-CHECK>>

<ROUTINE V-SIT ("OPTIONAL" (LIE? <>))
 <COND (<AND <==? ,WINNER ,PLAYER>
	     <OR <FSET? ,PRSO ,VEHBIT>
		 <AND <DOBJ? GLOBAL-HERE HERE FLOOR>
		      ;<FSET? ,HERE ,SURFACEBIT>>>>
	<TELL "You're now ">
	<COND (<ZERO? .LIE?>
	       ;<SETG PLAYER-SEATED ,PRSO>
	       <TELL "sitt">)
	      (T
	       ;<SETG PLAYER-SEATED <- 0 ,PRSO>>
	       <TELL "ly">)>
	<COND (<FSET? ,PRSO ,VEHBIT>
	       <MOVE ,PLAYER ,PRSO>)>
	<TELL "ing ">
	<COND (<FSET? ,PRSO ,SURFACEBIT> <TELL "on">) (T <TELL "in">)>
	<TELL THE ;HIM ,PRSO "." CR>)
       (T <WONT-HELP>)>>

<ROUTINE WONT-HELP ()
	<SETG CLOCK-WAIT T>
	<TELL "(That won't help solve this case!)" CR>>

<ROUTINE V-SIT-AT () <V-SIT>>

<ROUTINE V-SLAP ()
 <COND (<IOBJ? ROOMS> <SETG PRSI <>>)>
 <COND ;(<AND ,PRSI <NOT-HOLDING? ,PRSI>>
	<RTRUE>)
       (<DOBJ? PLAYER>
	<TELL
"That sounds like a sign you could wear on your back." CR>)
       (<NOT <FSET? ,PRSO ,PERSONBIT>>
	<IF-SPY>)
       (<FSET? ,PRSO ,MUNGBIT>
	<TELL
"If" HE ,PRSO " could," HE ,PRSO " would slap you right back." CR>)
       (T <FACE-RED>)>>

<ROUTINE IF-SPY ()
	;<COND (<NOT <FSET? ,PRSO ,PERSONBIT>> <TELL "break">)
	      (T <TELL "drop">)>
	<COND (<ZERO? ,PRSI>
	       <TELL "You give" HIM ,PRSO " a swift ">
	       <COND (<==? ,P-PRSA-WORD ,W?KICK>
		      <TELL "kick">)
		     (T <TELL "hand chop">)>)
	      (T <TELL "You swing" HIM ,PRSI " at" HIM ,PRSO>)>
	;<THIS-IS-IT ,PRSO>
	<TELL ", but" HE ,PRSO " seems indestructible." CR>>

<ROUTINE FACE-RED ("OPTIONAL" (P 0) "AUX" X)
	<COND (<ZERO? .P> <SET P ,PRSO>)>
	<UNSNOOZE .P>
	<SET X <GETP .P ,P?LINE>>
	<PUTP .P ,P?LINE <+ 1 .X>>
	<COND (<EQUAL? ,FOLLOWER .P>
	       <SETG FOLLOWER <>>)>
	<COND (<NOT <EQUAL? <GETP .P ,P?LDESC>
			    4 ;"looking at you with suspicion">>
	       ;<EQUAL? .P ,FRIEND>
	       <PUTP .P ,P?LDESC 20 ;"ignoring you">)>
	<TELL CHE .P>
	<COND (<ZERO? .X>
	       <TELL " looks at you as if you were insane." CR>)
	      (T <TELL " gives you a good slap. It hurts, too!"
		       ;" slaps you right back. Wow, is your face red!" CR>)>>

;<ROUTINE V-SLIDE () <YOU-CANT>>

<ROUTINE V-SMELL ()
	<TELL CHE ,PRSO smell " just like " A ,PRSO "!" CR>>

<ROUTINE V-SMILE () <HAR-HAR>>

;<ROUTINE V-SMOKE () <YOU-CANT ;"burn">>

;<ROUTINE PRE-SORRY () <PRE-HELLO ;" sorry ">>

<ROUTINE V-SORRY ()
 <COND (<OR ;<NOT <FSET? ,PRSO ,PERSONBIT>>
	    <==? ,PRSO ,CONFESSED>>
	<WONT-HELP-TO-TALK-TO ,PRSO>)
       (<NOT <GRAB-ATTENTION ,PRSO>>
	<RFATAL>)
       (<NOT <L? 0 <GETP ,PRSO ,P?LINE>>>
	<TELL "\"I'm not angry with" HIM ,WINNER " now.\"" CR>)
       (T
	;<SETG DISCOVERED-HERE <>>	;"leave info for SECRET-CHECK"
	<PUTP ,PRSO ,P?LINE 0 ;<- <GETP ,PRSO ,P?LINE> 1>>
	<COND (T ;<EQUAL? ,PRSO ,FRIEND>
	       <PUTP ,PRSO ,P?LDESC 3 ;"watching you">)>
	<TELL "\"Apology accepted.\"" CR>)>>

<ROUTINE V-SOUND () <YOU-CANT>>

<ROUTINE V-STOP ()
	<COND (<EQUAL? ,PRSO <> ,GLOBAL-HERE>
	       <TELL "Hey, no problem." CR>)
	      (<FSET? ,PRSO ,PERSONBIT>
	       <PERFORM ,V?$CALL ,PRSO>
	       <RTRUE>)
	      (T
	       <PERFORM ,V?LAMP-OFF ,PRSO>
	       <RTRUE>)>>

<ROUTINE V-SWIM ()
	 <SETG CLOCK-WAIT T>
	 <TELL "(" CHE ,WINNER " can't swim ">
	 <COND (<T? ,PRSO>
	        <TELL "in" HIM ,PRSO>)
	       (T
		<TELL <GROUND-DESC>>)>
	 <TELL ".)" CR>>

<ROUTINE PRE-TAKE ("AUX" L)
	 <SET L <LOC ,PRSO>>
	 <COND (<AND <DOBJ? MOONMIST>
		     <EQUAL? ,VARIATION ,DOCTOR-C>
		     <IN? ,MOONMIST ,INKWELL>
		     <T? ,TREASURE-FOUND>>
		<SET L <LOC ,INKWELL>>)>
	 <COND (<DOBJ? CASTLE MOON OCEAN
		       NOW-WEARING OTHER-OUTFIT TOWER FLOOR
		       WALL KEYHOLE>
		<HAR-HAR>)
	       (<DOBJ? ARTIFACT HANDS PASSAGE TREASURE YOU>
		<RFALSE>)
	       (<DOBJ? LIGHT-GLOBAL NIGHTLAMP>
		<COND (<CREEPY? ,HERE>
		       <NOT-HERE ,PRSO>)
		      (T <TELL "The cord isn't long enough." CR>)>)
	       (<DOBJ? MIRROR-GLOBAL>
		<YOU-CANT>)
	       (<DOBJ? UNDRESSED>
		<COND (<NOUN-USED? ,W?DRESSE>
		       <COND (<T? ,PRSI>
			      <PERFORM ,V?WEAR ,PRSI>
			      <RTRUE>)
			     (T
			      <PERFORM ,V?DRESS ,WINNER>
			      <RTRUE>)>)
		      (T ;<NOUN-USED? ,W?UNDRESS>
		       <PERFORM ,V?UNDRESS ,WINNER>
		       <RTRUE>)
		      ;(T <NOT-HERE ,PRSO>)>)
	       (<IN? ,PRSO ,GLOBAL-OBJECTS>
		<NOT-HERE ,PRSO>)
	       (<AND .L
		     <FSET? .L ,CONTBIT>
		     <NOT <FSET? .L ,OPENBIT>>>
		<TOO-BAD-BUT .L "closed">
		<RTRUE>)
	       (<T? ,PRSI>
		<COND (<EQUAL? ,PRSI ,WALL ;,POCKET .L>
		       <SETG PRSI <>>
		       <RFALSE>)
		      ;(<EQUAL? ,PRSI ,WALL>
		       <TOO-BAD-BUT ,PRSO "stuck tight">
		       <RTRUE>)
		      (<AND <NOT <FSET? ,PRSI ,SURFACEBIT>>
			    <NOT <FSET? ,PRSI ,OPENBIT>>
			    <NOT <FSET? ,PRSI ,PERSONBIT>>>
		       <TOO-BAD-BUT ,PRSI "closed">
		       <RTRUE>)
		      (<NOT <==? ,PRSI .L>>
		       <COND (<NOT <FSET? ,PRSI ,PERSONBIT>>
			      <TELL CHE ,PRSO is "n't in" THE ,PRSI "!" CR>)
			     (T <TELL
CHE ,PRSI do "n't have" THE ,PRSO "!" CR>)>)>)
	       (T <PRE-TAKE-WITH>)>>

<ROUTINE PRE-TAKE-WITH ("AUX" X)
	 <COND (<DOBJ? YOU>
		<RFALSE>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <DOBJ? GHOST-NEW>>
		     <EQUAL? ,P-PRSA-WORD ,W?SEIZE ,W?GRAB>> ;"SEIZE villain"
		<PERFORM ,V?ARREST ,PRSO>
		<RTRUE>)
	       (<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
		<COND (<AND <NOT <HELD? ,PRSO>>
			    <NOT <FSET? ,PRSO ,PERSONBIT>>>
		       <NOT-HERE ,PRSO>)>)
	       (<IN? ,PRSO ,WINNER>
		<ALREADY ,PLAYER>
		<TELL "holding" THE ,PRSO "!)" CR>)
	       (<AND <FSET? <LOC ,PRSO> ,CONTBIT>
		     <NOT <FSET? <LOC ,PRSO> ,OPENBIT>>>
		<YOU-CANT "reach">)
	       (<AND <IN? ,WINNER ,PRSO>
		     <NOT <NOUN-USED? ,W?DOOR ,W?KEYHOLE>>>
		<SETG CLOCK-WAIT T>
		<TELL !\( CHE ,WINNER is " in" HIM ,PRSO ", nitwit!)" CR>)>>

<ROUTINE V-TAKE ()
	 <COND (<==? <ITAKE> T>
		<TELL CHE ,WINNER is " now holding" THE ;HIM ,PRSO "." CR>)>>

<ROUTINE V-TAKE-OFF ()
	 <COND (<DOBJ? NOW-WEARING>
		<SETG PRSO <>>
		<V-WEAR>
		<RTRUE>)
	       ;(<WEAR-CHECK>
		<RTRUE>)
	       (<FSET? ,PRSO ,WORNBIT>
		<FCLEAR ,PRSO ,WORNBIT>
		<TELL "Okay," HE <LOC ,PRSO> is " no longer wearing">
		<MOVE ,PRSO ,WINNER>
		<TELL HIM ,PRSO "." CR>)
	       (T
		<TELL CHE <LOC ,PRSO> is "n't wearing" HIM ,PRSO "!" CR>)>>

<ROUTINE V-TAKE-TO ()	;"Parser should have ITAKEn PRSO."
	<PERFORM ,V?WALK-TO ,PRSI>
	<RTRUE>>

;<ROUTINE V-TAKE-WITH ()
	<TELL "You can't remove" HIM ,PRSO " with" HIM ,PRSI "!" CR>>

<ROUTINE V-DISEMBARK ()
	 <COND (<ROOM-CHECK>
		<RTRUE>)
	       (<DOBJ? ROOMS HERE GLOBAL-HERE ;GLOBAL-WATER>
		<COND (<AND <==? ,WINNER ,PLAYER>
			    <NOT <IN? ,PLAYER ,HERE>>
			    ;<T? ,PLAYER-SEATED>>
		       <OWN-FEET>)
		      (T
		       <DO-WALK ,P?OUT>
		       <RTRUE>)>)
	       (<DOBJ? NOW-WEARING>
		<V-TAKE-OFF>
		<RTRUE>)
	       (<==? <LOC ,PRSO> ,WINNER>
		<TELL
"You don't need to take" HIM ,PRSO " out to use" HIM ,PRSO "." CR>)
	       ;(<==? <LOC ,PRSO> ,POCKET>
		<MOVE ,PRSO ,WINNER>
		<TELL CHE ,WINNER is " now holding" HIM ,PRSO "." CR>)
	       (<AND <NOT <==? <LOC ,WINNER> ,PRSO>>
		     <NOT <IN? ,PLAYER ,PRSO>>
		     ;<NOT <EQUAL? ,PLAYER-SEATED ,PRSO <- 0 ,PRSO>>>>
		<TELL "You're not ">
		<COND (<FSET? ,PRSO ,SURFACEBIT> <TELL "on">) (T <TELL "in">)>
		<TELL HIM ,PRSO "!|">
		<RFATAL>)
	       (T
		<OWN-FEET>)>>

<ROUTINE OWN-FEET ()
	 <MOVE ,WINNER ,HERE>
	 ;<COND (<==? ,WINNER ,PLAYER>
		<SETG PLAYER-SEATED <>>)>
	 <TELL CHE ,WINNER is " on" HIS ,WINNER " own feet again." CR>
	 <COND (<EQUAL? ,DRIVEWAY ,HERE>
		<ENTER-ROOM>)>	;"to conform with manual"
	 <RTRUE>>

<ROUTINE V-HOLD-UP ()
 <COND (<DOBJ? ROOMS>
	<PERFORM ,V?STAND>
	<RTRUE>)
       (T
	<WONT-HELP>
	;<TELL "That doesn't seem to help at all." CR>)>>

;<ROUTINE PRE-TELL () <PRE-ASK-ABOUT>>

<ROUTINE V-TELL ("AUX" P)
	 <COND (<==? ,PRSO ,PLAYER>
		<COND (<NOT <==? ,WINNER ,PLAYER>>
		       <SET P ,WINNER>
		       <SETG WINNER ,PLAYER>
		       <PERFORM ,V?ASK .P>
		       <RTRUE>)
		      (<T? ,QCONTEXT>
		       <SETG QCONTEXT <>>
		       <COND (<T? ,P-CONT>
			      <SETG WINNER ,PLAYER>)
			     (T <TELL
"Okay, you're not talking to anyone else." CR>)>)
		      (T
		       <WONT-HELP-TO-TALK-TO ,PLAYER>
		       <SETG QUOTE-FLAG <>>
		       <SETG P-CONT <>>
		       <RFATAL>)>)
	       (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<UNSNOOZE ,PRSO>
		<SETG QCONTEXT ,PRSO>
		<COND (<T? ,P-CONT>
		       <SETG CLOCK-WAIT T>
		       <SETG WINNER ,PRSO>)
		      (T
		       <TELL
CHE ,PRSO is !\  <GET ,LDESC-STRINGS 12> ;"listening to you" "." CR>)>)
	       (T
		<WONT-HELP-TO-TALK-TO ,PRSO>
		;<YOU-CANT "talk to">
		<SETG QUOTE-FLAG <>>
		<SETG P-CONT <>>
		<RFATAL>)>>

<ROUTINE PRE-STELL-ABOUT () <PERFORM ,V?TELL-ABOUT ,PRSI ,PRSO> <RTRUE>>
<ROUTINE   V-STELL-ABOUT () <V-FOO>>

<ROUTINE PRE-TELL-ABOUT ("AUX" P)
 <COND (<DOBJ? PLAYER PLAYER-NAME>
	<COND (<QCONTEXT-GOOD?>
	       <PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSI>)
	      (<AND <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	       <TELL-I-ASSUME .P " Ask">
	       <PERFORM ,V?ASK-ABOUT .P ,PRSI>)
	      (T <ARENT-TALKING>)>
	<RTRUE>)
       (<AND <NOT <FSET? ,PRSI ,SEENBIT>>
	     <NOT <FSET? ,PRSI ,TOUCHBIT>>>
	<NOT-FOUND ,PRSI>
	<RTRUE>)
       (<OR <EQUAL? ,PRSI ,BRICKS ,COFFIN ,CRYPT>
	    <EQUAL? ,PRSI ,DUNGEON ,IRON-MAIDEN ,TOMB>
	    <EQUAL? ,PRSI ,WELL>>
	<TELL ,ANCIENT-SECRETS CR>)
       (T <PRE-ASK-ABOUT>)>>

<ROUTINE V-TELL-ABOUT ("AUX" P)
 <COND ;(<DOBJ? PLAYER>
	<COND (<SET P <GETP ,PRSI ,P?TEXT>>
	       <TELL .P CR>)
	      (T <ARENT-TALKING>)>)
       (T
	<TELL "\"I'm afraid you'll have to show me instead of telling me.\""
	      ;"\"I don't see why that's important now.\"" CR>
	;<PERFORM ,V?ASK-ABOUT ,PRSO ,PRSI>
	<RTRUE>)>>

<ROUTINE PRE-TALK-ABOUT ("AUX" P)
 <COND (<NOT <==? ,WINNER ,PLAYER>>
	<SET P ,WINNER>
	<SETG WINNER ,PLAYER>
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)
       (<QCONTEXT-GOOD?>
	<PERFORM ,V?ASK-ABOUT ,QCONTEXT ,PRSO>
	<RTRUE>)
       (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<TELL-I-ASSUME .P " to">
	<PERFORM ,V?ASK-ABOUT .P ,PRSO>
	<RTRUE>)>>

<ROUTINE V-TALK-ABOUT () <ARENT-TALKING>>

<GLOBAL QUITE-WELCOME "\"You're quite welcome, I'm sure.\"|">

<ROUTINE V-THANKS ()
  <COND (<T? ,PRSO>
	 <COND (<AND <FSET? ,PRSO ,PERSONBIT>
		     <NOT <FSET? ,PRSO ,MUNGBIT>>>
		<TELL ,QUITE-WELCOME>
		<RTRUE>)
	       (T <YOU-CANT>)>)
	(T
	 <COND (<OR <QCONTEXT-GOOD?>
		    <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
		<TELL ,QUITE-WELCOME>)
	       (T <TELL "You're more than welcome." CR>)>)>>

<ROUTINE V-THROW () <COND (<IDROP> <TELL "Thrown." CR>)>>

<ROUTINE V-THROW-AT ()
	 <COND (<NOT <IDROP>>
		<RTRUE>)>
	 <COND ;(<AND <FSET? ,PRSI ,PERSONBIT>
		     <NOT <FSET? ,PRSI ,MUNGBIT>>>
		<TELL CHE ,PRSI duck>)
	       (T <TELL CHE ,PRSI do "n't duck">)>
	 <TELL " as" HE ,PRSO " flies by." CR>>

;<ROUTINE V-THROW-OFF ("AUX" X) <YOU-CANT "throw off">>

<ROUTINE PRE-THROW-THROUGH ()
	<FCLEAR ,PRSO ,WORNBIT>
	<RFALSE>>

<ROUTINE V-THROW-THROUGH ()
	 <COND (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "Let's not resort to vandalism, please." CR>)
	       (T <V-THROW>)>>

;<ROUTINE PRE-TIE-TO ()
	 <COND (<NOT <FSET? ,PRSO ,PERSONBIT>>
		<TELL "That won't do any good." CR>)>>

;<ROUTINE V-TIE-TO ()
	<TELL "You can't tie" HIM ,PRSO " to" THE ,PRSI "." CR>>

;<ROUTINE PRE-TIE-WITH ()
	 <COND (<OR <NOT <FSET? ,PRSO ,PERSONBIT>>
		    <NOT <FSET? ,PRSI ,TOOLBIT>>>
		<TELL "That won't do any good." CR>)>>

;<ROUTINE V-TIE-WITH ()
	<TELL "\"If you don't formally arrest me first, I'll sue!\"" CR>>

<ROUTINE V-TIME ()
	 <TELL "The time is now ">
	 <TIME-PRINT ,PRESENT-TIME>
	 <TELL "." CR>>

<ROUTINE TIME-PRINT (NUM "AUX" HR ;(AM <>))
	 <SET HR </ .NUM 60>>
	 <COND (<G? .HR 12>
		<SET HR <- .HR 12>>
		;<SET AM T>)
	       ;(<==? .HR 12> <SET AM T>)>
	 <PRINTN .HR>
	 <TELL !\:>
	 <COND (<L? <SET HR <MOD .NUM 60>> 10>
		<TELL !\0>)>
	 <TELL N .HR>
	 ;<TELL !\  <COND (.AM "a.m.") (T "p.m.")>>>

<ROUTINE V-TURN ()
 <COND ;(<EQUAL? <META-LOC ,PRSO> ,GLOBAL-OBJECTS>
	<NOT-HERE ,PRSO>)
       (<AND <FSET? ,PRSO ,DOORBIT> <FSET? ,PRSO ,OPENBIT>>
	<PERFORM ,V?CLOSE ,PRSO>
	<RTRUE>)
       (T <TELL "What do you want that to do?" CR>)>>

<ROUTINE V-LAMP-OFF ()
	 <COND (<NOT <FSET? ,PRSO ,LIGHTBIT>>
		<YOU-CANT "turn off">)
	       (<NOT <FSET? ,PRSO ,ONBIT>>
		<ALREADY ,PRSO "off">)
	       (T
		<OKAY ,PRSO "off">)>>

<ROUTINE V-LAMP-ON ()
	 <COND (<FSET? ,PRSO ,ONBIT>
		<ALREADY ,PRSO "on">)
	       (<FSET? ,PRSO ,LIGHTBIT>
		<OKAY ,PRSO "on">)
	       (<FSET? ,PRSO ,PERSONBIT>
		<HAR-HAR>)
	       (T <YOU-CANT "turn on">)>>

<ROUTINE V-UNLOCK ()
	 <COND (<OR <FSET? ,PRSO ,DOORBIT>
		    <AND <FSET? ,PRSO ,CONTBIT>
			 <NOT <ZERO? <GETP ,PRSO ,P?CAPACITY>>>>>
		<COND (<NOT <FSET? ,PRSO ,LOCKED>>
		       <ALREADY ,PRSO "unlocked">)
		      (<ZERO? <UNLOCK-DOOR? ,PRSO>>
		       <YOU-CANT>)
		      (T
		       ;<COND (<FSET? ,PRSO ,OPENBIT>
			      <FCLEAR ,PRSO ,OPENBIT>
			      <FIRST-YOU "close" ,PRSO>)>
		       <FCLEAR ,PRSO ,LOCKED>
		       <OKAY ,PRSO "unlocked">)>)
	       (T
		<SETG CLOCK-WAIT T>
		<TELL !\( CHE ,PRSO is "n't locked!)" CR>)>>

;<ROUTINE V-UNTIE ()
 <TELL "You can't tie" HIM ,PRSO ", so you can't untie" HIM ,PRSO "!" CR>>

<ROUTINE MORE-SPECIFIC ()
	<SETG CLOCK-WAIT T>
	<TELL "[Please be more specific.]" CR>>

<ROUTINE V-USE () <MORE-SPECIFIC>>

"V-WAIT has three modes, depending on the arguments:
1) If only one argument is given, it will wait for that many moves.
2) If a second argument is given, it will wait the least of the first
   argument number of moves and the time at which the second argument
   (an object) is in the room with the player.
3) If the third argument is given, the second should be FALSE.  It will
   wait <first argument> number of moves (or at least try to).  The
   third argument means that an 'internal wait' is happening (e.g. for
   a 'careful' search)."

;<GLOBAL WHO-WAIT:NUMBER 0>

<GLOBAL KEEP-WAITING <>>

<ROUTINE V-WAIT ("OPTIONAL" (NUM -1) (WHO <>) (INT <>)
		 "AUX" (WHO-WAIT 0) VAL HR (RESULT T))
	 <COND (<==? -1 .NUM>
		<SET NUM 10>)>
	 <COND (<AND <ZERO? .INT>
		     <AND <NOT <FSET? ,PRSO ,PERSONBIT>>
			  <NOT <DOBJ? INTNUM TURN GHOST-NEW>>>>
		<TELL ,I-ASSUME " Wait " N .NUM " minute">
		<COND (<NOT <1? .NUM>>
		       <TELL !\s>)>
		<TELL ".]" CR>)>
	 <SET HR ,HERE>
	 <COND (<NOT .INT> <TELL "Time passes..." CR>)>
	 <DEC NUM>
	 <REPEAT ()
		 <COND (<L? <SET NUM <- .NUM 1>> 0>
			<SETG KEEP-WAITING <>>
			<RETURN>)
		       (<SET VAL <CLOCKER>>
			<COND (<OR <==? .VAL ,M-FATAL>
				   <NOT <==? .HR ,HERE>>>
			       <SETG CLOCK-WAIT T>
			       <SET RESULT ,M-FATAL>
			       <RETURN>)
			      ;(<0? .NUM> <RETURN>)
			      (<AND .WHO <IN? .WHO ,HERE>>
			       <SETG CLOCK-WAIT T>
			       <NOT-IT .WHO>
			       <TELL CTHE .WHO ", for wh">
			       <COND (<FSET? .WHO ,PERSONBIT>
				      <TELL "om">)
				     (T <TELL "ich">)>
			       <TELL " you're waiting, has arrived." CR>
			       <RETURN>)
			      (T
			       <SET WHO-WAIT <+ .WHO-WAIT 1>>
			       <COND (<T? <BAND <LOWCORE ZVERSION> 16>>
				      <TELL !\(>
				      <SET VAL <TIME-PRINT ,PRESENT-TIME>>
				      <TELL ") ">)>
			       <COND (<T? ,KEEP-WAITING>
				      <USL>
				      <AGAIN>)>
			       <TELL "Do you want to keep ">
			       <SET VAL <VERB-PRINT T>>
			       <COND (<YES?> <USL>)
				     (T
				      <SETG CLOCK-WAIT T>
				      <SET RESULT ,M-FATAL>
				      <RETURN>)>)>)
		       (<AND .WHO <G? <SET WHO-WAIT <+ .WHO-WAIT 1>> 30>>
			<SET VAL <START-SENTENCE .WHO>>
			<TELL
" still hasn't arrived. Do you want to keep waiting?">
			<COND (<NOT <YES?>> <RETURN>)>
			<SET WHO-WAIT 0>
			<USL>)
		       (T <USL>)>>
	 %<DEBUG-CODE <COND (<NOT .INT>
			     <TELL "{" ;"Note to Stu: ">
			     <TIME-PRINT ,PRESENT-TIME>
			     <TELL "}|">
			     ;<V-TIME>)>>
	 .RESULT>

;<ROUTINE INT-WAIT (N "AUX" TIM REQ VAL)
	 <SET TIM ,PRESENT-TIME>
	 <COND (<==? ,M-FATAL <V-WAIT <SET REQ <RANDOM <* .N 2>>> <> T>>
		<RFATAL>)
	       (<NOT <L? <- ,PRESENT-TIME .TIM> .REQ>>
		<RTRUE>)
	       (T <RFALSE>)>>

<ROUTINE V-WAIT-FOR ("AUX" WHO)
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>>
		     <DOBJ? ROOMS TURN INTNUM>>
		<COND ;(<G? ,P-NUMBER ,PRESENT-TIME> <V-WAIT-UNTIL> <RTRUE>)
		      ;(<G? ,P-NUMBER 180>
		       <TELL "That's too long to wait." CR>)
		      (<T? ,P-TIME>
		       <V-WAIT-UNTIL>)
		      (T <V-WAIT ,P-NUMBER>)>)
	       (<DOBJ? ROOMS TURN GLOBAL-HERE>
		<V-WAIT>)
	       (<DOBJ? PLAYER>
		<ALREADY ,PLAYER "here">)
	       (<OR <FSET? ,PRSO ,PERSONBIT>
		    <DOBJ? GHOST-NEW>>
		<COND (<==? <META-LOC ,PRSO> ,HERE>
		       <ALREADY ,PRSO "here">)
		      (T <V-WAIT 10000 ,PRSO>)>)
	       (T <TELL "Not a good idea. You might wait forever." CR>)>>

<ROUTINE V-WAIT-UNTIL ("AUX" N)
	 <COND (<AND <NOT <==? -1 ,P-NUMBER>>
		     <DOBJ? ROOMS TURN INTNUM>>
		<SET N ,P-NUMBER>
		<COND (<T? ,P-TIME>
		       <COND (<L? .N 420>
			      <SET N <+ .N 720>>)>)
		      (T
		       <COND (<L? .N 8 ;7>
			      <SET N <+ <* .N 60> 720>>)
			     (<L? .N 13>
			      <SET N <* .N 60>>)
			     (<L? .N 24>
			      <SET N <- <* .N 60> 720>>)
			     (<G? .N 99>
			      <SET N <+ <MOD .N 100>
					<* </ .N 100> 60>>>)>
		       <COND (<L? .N 420>
			      <SET N <+ .N 720>>)>
		       <TELL ,I-ASSUME !\ >
		       <TIME-PRINT .N>
		       <TELL "]" CR>)>
		<COND (<G? .N ,PRESENT-TIME>
		       <V-WAIT <- .N ,PRESENT-TIME>>)
		      (T
		       <SETG CLOCK-WAIT T>
		       <TELL "(It's already past that time!)" CR>)>)
	       (T <YOU-CANT "wait until">)>>

<ROUTINE V-ALARM ()
	 <COND (<==? ,PRSO ,ROOMS>
		;<SETG OPRSO ,PRSO>
		<SETG PRSO ,WINNER>)>
	 <COND ;(<FSET? ,PRSO ,PERSONBIT>
		<COND (<FSET? ,PRSO ,MUNGBIT>
		       <WONT-HELP-TO-TALK-TO ,PRSO>
		       ;<TELL " doesn't respond." CR>)
		      (T <TELL
CHE ,PRSO " is wide awake, or haven't you noticed?" CR>)>)
	       (T
		<TOO-BAD-BUT ,PRSO "not asleep">)>>

<ROUTINE DO-WALK (DIR "AUX" P)
	 <SETG P-WALK-DIR .DIR>
	 <PERFORM ,V?WALK .DIR>>

<ROUTINE V-WALK ("AUX" PT PTS STR RM)
	 <COND (<ZERO? ,P-WALK-DIR>
		<COND (<AND <==? ,PRSO ,P?IN>
			    <OR <IN? ,P-IT-OBJECT ,ROOMS>
				<FSET? ,P-IT-OBJECT ,VEHBIT>
				<FSET? ,P-IT-OBJECT ,CONTBIT>>>
		       <TELL-I-ASSUME ,P-IT-OBJECT ;" Go in">
		       <PERFORM ,V?THROUGH ,P-IT-OBJECT>
		       <RTRUE>)
		      (T
		       <V-WALK-AROUND>
		       <RFATAL>)>)>
	 <COND (<SET PT <GETPT <LOC ,WINNER> ,PRSO>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <SET RM <GET-REXIT-ROOM .PT>>
		       <COND (<GOTO .RM> <OKAY>)>
		       <RTRUE>)
		      (<==? .PTS ,NEXIT>
		       <SETG CLOCK-WAIT T>
		       <TELL !\( <GET .PT ,NEXITSTR> !\) CR>
		       <RFATAL>)
		      (<==? .PTS ,FEXIT>
		       <COND (<SET RM <APPLY <GET .PT ,FEXITFCN>>>
			      <COND (<GOTO .RM> <OKAY>)>
			      <RTRUE>)
			     (T
			      <RFATAL>)>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <COND (<GOTO <GET-REXIT-ROOM .PT>> <OKAY>)>
			      <RTRUE>)
			     (<SET STR <GET .PT ,CEXITSTR>>
			      <TELL .STR CR>
			      <RFATAL>)
			     (T
			      <YOU-CANT "go">
			      <RFATAL>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (<WALK-THRU-DOOR? .PT>
			      <COND (<GOTO <GET-REXIT-ROOM .PT>> <OKAY>)>
			      <RTRUE>)
			     (T <RFATAL>)>)>)
	       (<EQUAL? ,PRSO ,P?IN ,P?OUT>
		<V-WALK-AROUND>)
	       (<EQUAL? ,PRSO ,P?UP>
		<PERFORM ,V?CLIMB-UP ,STAIRS>
		<RTRUE>)
	       (<EQUAL? ,PRSO ,P?DOWN>
		<PERFORM ,V?CLIMB-DOWN ,STAIRS>
		<RTRUE>)
	       (<EQUAL? ,HERE ,DRIVEWAY>
		<TELL ,CASTLE-IS-SOUTH>
		<RFATAL>)
	       (T
		<YOU-CANT "go">
		<RFATAL>)>>

<GLOBAL CASTLE-IS-SOUTH "(The castle is south of here.)|">

<ROUTINE UNLOCK-DOOR? (DR)
 <COND (<EQUAL? ,HERE .DR>
	<RTRUE>)
       (<EQUAL? ,HERE ;,CAR ,DRIVEWAY <GETP ,HERE ,P?STATION>>
	<RFALSE>)
       (<EQUAL? .DR ,SECRET-SITTING-DOOR ,FRONT-GATE>
	<RFALSE>)
       (T <RTRUE>)>>

<ROUTINE WALK-THRU-DOOR? (PT "OPTIONAL" (OBJ 0) (TELL? T)
			     "AUX" RM)
	<COND (<ZERO? .OBJ>
	       <SET OBJ <GET-DOOR-OBJ .PT>>)>
	;<SET RM <GET-REXIT-ROOM .PT>>
	<COND (<FSET? .OBJ ,OPENBIT>
	       <RTRUE>)
	      (<AND <FSET? .OBJ ,SECRETBIT>
		    <NOT <FSET? .OBJ ,TOUCHBIT ;,SEENBIT>>>
	       <COND (<EQUAL? <> .TELL? ,VERBOSITY>
		      <RFALSE>)
		     (<NOT <FSET? ,HERE ,SECRETBIT>>
		      <YOU-CANT "go">
		      <RFALSE>)
		     (<ZERO? ,LIT>
		      <NOT-FOUND .OBJ>
		      <RFALSE>)
		     (T
		      <COND (<NOT <VERB? WALK-TO>>
			     <OPEN-DOOR-AND-CLOSE-IT-AGAIN .OBJ>)>
		      <RTRUE>)>)
	      (<NOT <FSET? .OBJ ,LOCKED>>
	       <COND (<NOT <VERB? WALK-TO>>
		      <FCLEAR .OBJ ,SECRETBIT>
		      <FSET .OBJ ,SEENBIT ;,TOUCHBIT>
				;"Don't put TOUCHBIT on ROOM"
		      <COND (<NOT <EQUAL? <> .TELL? ,VERBOSITY>>
			     <OPEN-DOOR-AND-CLOSE-IT-AGAIN .OBJ>)>)>
	       <RTRUE>)
	      (<AND <T? .PT>
		    <SET RM <GET .PT ,DEXITSTR>>>
	       <COND (<T? .TELL?>
		      <TELL .RM CR>)>
	       <RFALSE>)
	      (T
	       <COND (<ZERO? .TELL?>
		      <RFALSE>)
		     (<T? <UNLOCK-DOOR? .OBJ>>
		      <COND (<AND <NOT <VERB? WALK-TO>>
				  <T? ,VERBOSITY>>
			     <OPEN-DOOR-AND-CLOSE-IT-AGAIN .OBJ>)>
		      <RTRUE>)
		     ;(<IN? .OBJ ,ROOMS>
		      ;<COND (<VERB? WALK-TO>
			     <TELL ", but t">)
			    (T )>
		      <TELL "The door is locked." CR>
		      ;<COND (<NOT <VERB? WALK-TO>>
			     )>)
		     (T <TOO-BAD-BUT .OBJ "locked">)>
	       <THIS-IS-IT .OBJ>
	       <RFALSE>)>>

<ROUTINE OPEN-DOOR-AND-CLOSE-IT-AGAIN (OBJ)
	<FSET .OBJ ,SEENBIT ;,TOUCHBIT>	;"Don't put TOUCHBIT on ROOM"
	<COND (<NOT <==? ,WINNER ,PLAYER>>
	       <RTRUE>)>
	<TELL "(You ">
	<COND (<FSET? .OBJ ,LOCKED>
	       <FCLEAR .OBJ ,LOCKED>
	       <TELL "unlock and ">)>
	<TELL "open the ">
	<COND (<EQUAL? .OBJ ,FRONT-GATE> <TELL "gate">)
	      (T <TELL "door">)>
	<COND (<FSET? .OBJ ,SECRETBIT>
	       <FSET .OBJ ,OPENBIT>)
	      (T <TELL " and close it again">)>
	<TELL ".)" CR>>

<ROUTINE V-WALK-AROUND ()
	 <SETG CLOCK-WAIT T>
	 <TELL !\[ ,WHICH-DIR "]|">
	 <RFATAL>>

<ROUTINE WHO-KNOWS? (OBJ)
	<SETG CLOCK-WAIT T>
	<TELL "(Who knows where" HE .OBJ is "?)" CR>>

;<ROUTINE V-BACK-UP () <WALK-WITHIN-ROOM>>

<ROUTINE WALK-WITHIN-ROOM () <NO-NEED "move around within" ,HERE ;" a place">>

<ROUTINE V-WALK-TO ("AUX" L VAL)
 <SET L <META-LOC ,PRSO>>
 <COND (<FSET? ,PRSO ,PERSONBIT>
	<COND (<AND <==? <META-LOC ,WINNER> .L>
		    <NOT <FSET? ,PRSO ,NDESCBIT>>>
	       <BITE-YOU>
	       <RTRUE>)
	      (<NOT <SET L <FOLLOW-LOC?>>>
	       ;<ZERO? <SET L <GET ,FOLLOW-LOC <GETP ,PRSO ,P?CHARACTER>>>>
	       <WHO-KNOWS? ,PRSO>
	       <RFATAL>)
	      ;(<==? <PRE-FIND> ,M-FATAL>
	       <RFATAL>)>)>
 %<DEBUG-CODE <COND (<T? ,DBUG> <TELL "{WALK-TO: " D ,PRSO !\/ D .L "}|">)>>
 <COND (<AND <FSET? ,PRSO ,SECRETBIT>
	     <NOT <==? .L ,PRSO>>>
	<NO-FUN>)
       (<AND <EQUAL? ,HERE <LOC ,WINNER>>
	     <OR <EQUAL? .L ,HERE>
		 <EQUAL? ,PRSO ,PSEUDO-OBJECT ,WALL>
		 <AND <NOT <IN? .L ,ROOMS>>
		      <GLOBAL-IN? ,PRSO ,HERE>>>>
	<WALK-WITHIN-ROOM>)
       (<AND <OR <EQUAL? .L ,LOCAL-GLOBALS> ;<FSET? ,PRSO ,DOORBIT>>
	     ;<GLOBAL-IN? ,PRSO ,HERE>>
	<MORE-SPECIFIC>)
       (<TOUR?>
	<RTRUE>)
       (<APPLY <GETP ,HERE ,P?ACTION> ,M-EXIT>
	<RTRUE>)
       (<DOBJ? INTDIR>
	<V-WALK-AROUND>)
       (<OR ;<AND <FSET? ,PRSO ,PERSONBIT>	;"done above"
		 <FSET? ,PRSO ,NDESCBIT>>
	    <AND <NOT <IN? ,PRSO ;.L ,ROOMS>>
		 <NOT <FSET? ,PRSO ,TOUCHBIT>>>>
	<WHO-KNOWS? ,PRSO>
	<RFATAL>)
       (<FAR-AWAY? .L>
	<SETG CLOCK-WAIT T>
	<TELL !\( CHE ,WINNER " can't go there from here">
	<COND (<NOT <EQUAL? .L ,GLOBAL-OBJECTS>>
	       <TELL ", at least not directly">)>
	<TELL ".)" CR>)
       (<NOT <EQUAL? ,WINNER ,PLAYER>>
	<COND (<GOTO .L>
	       <COND (<EQUAL? ,WINNER ,FOLLOWER>
		      <SETG FOLLOWER 0>)>
	       <SET L <GT-O ,WINNER>>
	       <COND (<T? <GET .L ,GOAL-S>>
		      <ESTABLISH-GOAL ,WINNER
				      <GET .L ,GOAL-F>
				      <GET .L ,GOAL-ENABLE>>)>
	       <OKAY>
	       ;<TELL "\"Okay.\"" CR>)>
	<RTRUE>)
       (T
	<COND (<SEE-INTO? ,PRSO <> ;T>
	       <SET VAL <DIR-FROM ,HERE .L>>
	       <COND (<T? .VAL>
		      <COND (<==? ,M-FATAL <APPLY <GETP ,HERE ,P?ACTION> .VAL>>
			     <RFATAL>)>)>
	       <GOTO ,PRSO <>>
	       <RTRUE>)
	      (<ZERO? ,NOW-WEARING>
	       <YOUR-ROOM-F ,P?OUT>
	       <RFATAL>)>
	<TELL "You go quickly toward" THE .L ;" that place" ".|">
	;<COND (<EQUAL? ,HERE ,YOUR-BATHROOM>
	       <MOVE ,PLAYER ,YOUR-ROOM>)>
	<ESTABLISH-GOAL ,PLAYER .L>
	<SETG OHERE ,HERE>
	<FSET ,PLAYER ,INVISIBLE>
	<REPEAT ()
		<COND (<SET VAL <FOLLOW-GOAL ,PLAYER>>
		       <RETURN>)>>
	<FCLEAR ,PLAYER ,INVISIBLE>
	<COND (<T? ,FOLLOWER>
	       <FRIEND-FOLLOWS-YOU ,HERE>)>
	<COND (<NOT <==? ,OHERE ,HERE>>
	       <ENTER-ROOM>)>
	.VAL)>>

<GLOBAL DISCOVERED-HERE:OBJECT <>>
<ROUTINE ENTER-ROOM ("AUX" VAL)
	<SETG LIT <LIT? ;,HERE>>
	<COND (<FSET? ,HERE ,SECRETBIT>
	       <SETG WASHED <>>)
	      (<OR <EQUAL? ,HERE ,JACK-ROOM ,TAMARA-ROOM ,IRIS-ROOM>
		   <EQUAL? ,HERE ,WENDISH-ROOM ,VIVIEN-ROOM ,IAN-ROOM>
		   <EQUAL? ,HERE ,HYDE-ROOM>>
	       <TELL
"You enter the room cautiously after a preliminary peek.">
	       <COND (<AND ;<ZERO? ,LIONEL-SPEAKS-COUNTER>
			   <NOT <EQUAL? <LOC <GET ,CHARACTER-TABLE
					 <- <ZMEMQ ,HERE ,CHAR-ROOM-TABLE> 1>>>
					,HERE ,LOCAL-GLOBALS>>>
		      <SETG DISCOVERED-HERE ,HERE>
		      <QUEUE I-DISCOVERED 6 ;5>)>
	       <COND (<AND <T? ,LIT>
			   <ZERO? <FIND-FLAG-HERE ,PERSONBIT ,PLAYER>>>
		      <TELL " No one is there.">)>
	       <CRLF>)>
	<APPLY <GETP ,HERE ,P?ACTION> ,M-ENTER>
	<SET VAL <V-FIRST-LOOK>>
	<APPLY <GETP ,HERE ,P?ACTION> ,M-FLASH>
	.VAL>

;<ROUTINE V-WALK-UNDER () <YOU-CANT "go under">>

<ROUTINE V-RUN-OVER () <TELL "That doesn't make much sense." CR>>

<GLOBAL NO-CHANGING
"Before you unfasten even the first button, you decide
that this isn't a good place to undress.|">

<ROUTINE NO-CHANGING? ("AUX" X)
 ;<SET X <FIRST? ,HERE>>
 ;<REPEAT ()
	 <COND (<ZERO? .X> <RETURN>)
	       (<AND <FSET? .X ,PERSONBIT>
		     <NOT <FSET? .X ,MUNGBIT>>
		     <NOT <FSET? .X ,RMUNGBIT>>
		     <NOT <FSET? .X ,NDESCBIT>>
		     <NOT <EQUAL? .X ,WINNER>>>
		<RETURN>)
	       (T <SET X <NEXT? .X>>)>>
 <COND (<SET X <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>
	<COND (<EQUAL? .X ,GHOST-NEW>
	       <TELL ,NO-CHANGING>
	       <RTRUE>)
	      (T <TELL
CHE .X " says, \"I wish you wouldn't change clothes while I'm here!\"" CR>
	       <RTRUE>)>)
       (<EQUAL? ,HERE ,YOUR-BATHROOM ,YOUR-ROOM>
	;<COND (<NOT <ZERO? ,NOW-WEARING>>
	       ;<MOVE ,NOW-WEARING ,WINNER>
	       <FCLEAR ,NOW-WEARING ,WORNBIT>
	       <SETG NOW-WEARING <>>)>
	<RFALSE>)
       (T
	<TELL ,NO-CHANGING>
	;<COND (<EQUAL? ,HERE ,YOUR-ROOM>
	       <TELL " Someone might come in without knocking.">)>
	<RTRUE>)>>

<ROUTINE V-WEAR ("AUX" X)
	<COND (<NOT <ZERO? ,PRSO>>
	       <COND (<NOT <FSET? ,PRSO ,WEARBIT>>
		      <TELL CHE ,WINNER " can't wear" HIM ,PRSO>
		      <COND (<DOBJ? NECKLACE-OF-D>
			     <TELL ", because" ,CLASP-MUNGED>)>
		      <TELL "." CR>
		      <RTRUE>)
		     (<FSET? ,PRSO ,WORNBIT>
		      <ALREADY ,PRSO "being worn">
		      <RTRUE>)>)>
	<COND (<NOT <DOBJ? NECKLACE ;NECKLACE-OF-D EARRING ;HEADDRESS
			   ;WIG LENS LENS-1 LENS-2>>
	       <COND (<NO-CHANGING?>
		      <RTRUE>)
		     (<NOT <ZERO? ,NOW-WEARING>>
		      ;<MOVE ,NOW-WEARING ,WINNER>
		      <COND (<T? ,PRSO>
			     <FIRST-YOU "remove" ,NOW-WEARING>)>
		      <FCLEAR ,NOW-WEARING ,WORNBIT>
		      ;<SETG NOW-WEARING <>>)>
	       <SETG NOW-WEARING ,PRSO>)>
	<COND (<NOT <ZERO? ,PRSO>>
	       <MOVE ,PRSO ,PLAYER ;,GLOBAL-OBJECTS>
	       <FSET ,PRSO ,WORNBIT>
	       <COND (<OR <DOBJ? NECKLACE ;NECKLACE-OF-D EARRING ;HEADDRESS
				 ;WIG LENS LENS-1 LENS-2>
			  <FSET? ,PRSO ,MUNGBIT>>
		      <TELL "Okay." CR>)
		     (T
		      <FSET ,PRSO ,MUNGBIT>
		      <TELL
"Ahhh! Nothing like a new outfit to change your whole outlook!" CR>)>
	       <RTRUE>)
	      (T
	       <TELL "Okay... ">
	       <COND (<ZERO? ,GENDER-KNOWN>
		      <TELL "You immediately wish for central heating!" CR>)
		     (T
		      <TELL "My, what a fine figure of a ">
		      <COND (<FSET? ,PLAYER ,FEMALE> <TELL "wo">)>
		      <TELL "man!" CR>)
		     ;(<FSET? ,PLAYER ,FEMALE>
		      <TELL "Wow, are you ever beautiful!" CR>)>)>>

<ROUTINE V-YELL ("AUX" (N 0) RM P)
 <COND (<OR <SET P <QCONTEXT-GOOD?>>
	    <SET P <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,WINNER>>>
	<TELL CTHE .P " says, \"I'm right here. You needn't yell.\"" CR>
	<RTRUE>)
       (T
	<COND (<AND <==? 3 <GETP ,HERE ,P?CHARACTER>>
		    <OR <FSET? ,HERE ,WEARBIT> ;"WING-ROOMS"
			<AND <NOT <FSET? ,HERE ,WEARBIT>>
			     <NOT <FSET? ,HERE ,SECRETBIT>>>>>
	       <REPEAT ()
		      <COND (<IGRTR? N ,DEB-C> <RETURN>)>
		      <SET P <GET ,CHARACTER-TABLE .N>>
		      <COND (<NOT <EQUAL? .P ,GHOST-NEW ,CONFESSED ,CAPTOR>>
			     <SET RM <META-LOC .P>>
			     <COND (<AND <==? 3 <GETP .RM ,P?CHARACTER>>
					 <OR <AND <FSET? ,HERE ,WEARBIT>
						  <FSET? .RM ,WEARBIT>>
					     <AND <NOT <FSET? ,HERE ,WEARBIT>>
						  <NOT <FSET? .RM ,WEARBIT>>>>>
				    <GO-TO-SOUND ,HERE .P>)>)>>)>
	<TELL "\"Aaaarrrrgggghhhh!\"" CR>)>>

"<ROUTINE V-YELL-FOR () <V-YES>>"

<ROUTINE V-YES ("OPTIONAL" (NO? <>) "AUX" PER)
 <COND (<AND <OR <NOT <==? <SET PER ,WINNER> ,PLAYER>>
		 <AND <T? ,AWAITING-REPLY>
		      <SET PER <GETB ,QUESTIONERS ,AWAITING-REPLY>>>
		 <SET PER <QCONTEXT-GOOD?>>>
	     ;<VERB? YES NO ANSWER>>
	<COND (<NOT <D-APPLY "Actor" <GETP .PER ,P?ACTION> ,M-WINNER>>
	       <TELL "\"I see...\"" CR>
	       ;<SETG CLOCK-WAIT T>
	       ;<TELL "(That was a rhetorical question.)" CR>)>
	<RTRUE>)
       (<EQUAL? ,HERE ,DRIVEWAY>
	<TELL "The echoes fade and silence is soon restored." CR>)
       (T <ARENT-TALKING>)>>

<ROUTINE V-NO () <V-YES T>>

<ROUTINE FINISH ("OPTIONAL" (REPEATING <>) VAL)
	 %<DEBUG-CODE <COND (<T? ,DBUG> <RTRUE>)>>
	 <CRLF>
	 <CRLF>
	 <COND (<NOT .REPEATING>
		<V-SCORE>
		<CRLF>)>
	 <TELL
"Would you like to:|
   RESTORE your place from where you saved it,|
   RESTART the story from the beginning, or|
   QUIT for now?" CR>
	<REPEAT ()
	 <TELL !\>>
	 <READ ,P-INBUF ,P-LEXV>
	 <SET VAL <GET ,P-LEXV ,P-LEXSTART>>
	 <COND (<NOT <0? .VAL>>
		<SET VAL <WT? .VAL ,PS?VERB ,P1?VERB>>
		<COND (<EQUAL? .VAL ,ACT?RESTART>
		       <RESTART>
		       ;<TELL-FAILED>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?RESTORE>
		       <COND (<V-RESTORE> <RETURN>)>
		       <FINISH T>)
		      (<EQUAL? .VAL ,ACT?QUIT>
		       <QUIT>)>)>
	 <TELL "[Type RESTORE, RESTART, or QUIT.] ">>>

<ROUTINE DIVESTMENT? (OBJ)
	<AND <==? ,PRSO .OBJ>
	     <VERB? DISEMBARK DROP GIVE POUR PUT PUT-IN PUT-UNDER
		    REMOVE THROW-AT THROW-THROUGH>>>

;<ROUTINE EXIT-VERB? ("AUX" P)
 <COND (<VERB? WALK> <RETURN ,PRSO>)
       (<VERB? WALK-TO FOLLOW THROUGH>
	<SET P <META-LOC ,PRSO>>
	<COND (<==? ,HERE .P> <RFALSE>)
	      (<VERB? WALK-TO>
	       <FOLLOW-GOAL-DIR ,HERE .P>)
	      (T <DIR-FROM ,HERE .P>)>)>>

<ROUTINE REMOTE-VERB? ()
 <COND (<VERB? ;ARREST ASK-ABOUT ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR ASK-FOR ;BUY
	       DESCRIBE DISEMBARK DRESS FIND FOLLOW LEAVE LOOK-UP
	       ;MAKE SEARCH SEARCH-FOR SHOW SSHOW
	       TAKE-TO TALK-ABOUT TELL-ABOUT WAIT-FOR WAIT-UNTIL WALK-TO
	       ;$WHERE>
	<RTRUE>)>
 <RFALSE>>
