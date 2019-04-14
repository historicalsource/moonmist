"GOAL for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

"Rapid Transit Line Definitions and Identifiers"

<CONSTANT MAIN-LINE-C 1>
<CONSTANT BED-LINE-C 2>
<CONSTANT TOWER-LINE-C 3>
<CONSTANT PASS-LINE-C 4>
<CONSTANT GOAL-I-MULTIPLIER 8>	"<* 2 ,NUMBER-OF-LINES>"

<GLOBAL MAIN-LINE
	<PTABLE 0	GARDEN		P?OUT
		P?IN	MAZE		P?OUT
		P?EAST	COURTYARD	P?SOUTH
		P?NORTH	FOYER		P?SOUTH
		P?NORTH	GREAT-HALL	P?WEST
		P?EAST	CORR-1		P?NORTH
		P?SOUTH	DINING-ROOM	P?IN
		P?OUT	BACKSTAIRS	P?DOWN
		P?UP	KITCHEN		0>>

<GLOBAL BED-LINE
	<PTABLE 0	WEST-HALL	P?SOUTH
		P?NW	GALLERY		P?NE
		P?SOUTH	EAST-HALL	0>>

<GLOBAL TOWER-LINE
	<PTABLE 0	LOVER-PATH	P?IN
		P?NW	DUNGEON		P?EAST
		P?WEST	BASEMENT	P?UP
		P?DOWN	JUNCTION	P?WEST
		P?EAST	OLD-GREAT-HALL	P?UP
		P?DOWN	CORR-2		P?UP
		P?DOWN	CORR-3		P?UP
		P?DOWN	DECK		0>>

<GLOBAL PASS-LINE
	<PTABLE 0	SECRET-LANDING-JACK	P?DOWN
		P?WEST	PASSAGE-1		P?UP
		P?DOWN	SECRET-LANDING-TAM	P?NORTH
		P?SOUTH	SECRET-LANDING-LIB	P?EAST
		P?WEST	SECRET-IAN-PASSAGE	P?EAST
		P?WEST	HYDE-CLOSET		P?EAST
		P?WEST	MIDPOINT		P?EAST
		P?WEST	WENDISH-CORNER		P?EAST
		P?NORTH	IRIS-CLOSET		P?SOUTH
		P?NORTH	YOUR-CLOSET		P?DOWN
		P?UP	DRAWING-CLOSET		0>>

<GLOBAL TRANSFER-TABLE
	<PTABLE 0		0		;"transfers from MAIN-LINE"
		GREAT-HALL	GALLERY
		CORR-1		JUNCTION
		GREAT-HALL	GALLERY

		GALLERY		GREAT-HALL 	;"transfers from BED-LINE"
		0		0
		GALLERY		GREAT-HALL
		YOUR-ROOM	YOUR-CLOSET

		JUNCTION	CORR-1		;"transfers from TOWER-LINE"
		JUNCTION	CORR-1
		0		0
		LIBRARY		SECRET-LANDING-LIB

		YOUR-CLOSET	YOUR-ROOM	;"transfers from PASS-LINE"
		YOUR-CLOSET	YOUR-ROOM
		SECRET-LANDING-LIB	LIBRARY
		0		0>>

"CODE"

<ROUTINE FOLLOW-GOAL (PERSON
		      "AUX" (HEER <LOC .PERSON>) GT GOAL FLG (IGOAL <>) X)
	 <COND (<NOT <IN? .HEER ,ROOMS>>
		<SET HEER <META-LOC .HEER>>
		<MOVE .PERSON .HEER>)>
	 <SET GT <GT-O .PERSON>>
	 <COND (<==? .HEER <GET .GT ,GOAL-F>>
		<RETURN <GOAL-REACHED .PERSON>>)
	       (<ZERO? <GET .GT ,GOAL-ENABLE>>
		<RFALSE>)>
	 <SET IGOAL <GET .GT ,GOAL-I>>
	 <SET GOAL <GET ,TRANSFER-TABLE .IGOAL>>
	 <COND (<ZERO? .GOAL>
		<SET IGOAL <>>
		<SET GOAL <GET .GT ,GOAL-S>>)>
	 <SET X <GETP .HEER ,P?STATION>>
	 <COND (<NOT <EQUAL? .HEER .GOAL .X>>
		%<DEBUG-CODE <COND (<ZERO? .X>
				    <SET X .HEER>
				    <TELL "{!! NO STATION AT " D .HEER "}|">)>>
		<RETURN <MOVE-PERSON .PERSON .X>>)
	       (<NOT .GOAL>
		<RFALSE>)
	       (<==? .HEER .GOAL>
		<COND (.IGOAL
		       <SET FLG <GET ,TRANSFER-TABLE <+ .IGOAL 1>>>
		       %<DEBUG-CODE
			 <COND (<ZERO? .FLG>
				<SET FLG .HEER>
				<TELL "{!! NO TRANSFER #" N .IGOAL "}|">)>>
		       <SET FLG <MOVE-PERSON .PERSON .FLG>>
		       <ESTABLISH-GOAL .PERSON <GET .GT ,GOAL-F>>
		       <RETURN .FLG>)
		      (<NOT <==? .HEER <SET FLG <GET .GT ,GOAL-F>>>>
		       <RETURN <MOVE-PERSON .PERSON .FLG>>)
		      (T
		       <RETURN <GOAL-REACHED .PERSON>>)>)
	       (<==? .HEER <GETP .GOAL ,P?STATION>>
		<RETURN <MOVE-PERSON .PERSON .GOAL>>)>
	 <SET FLG <FOLLOW-GOAL-NEXT .HEER .GOAL ;.PERSON>>
	 <MOVE-PERSON .PERSON .FLG>>

<ROUTINE FOLLOW-GOAL-NEXT (HEER GOAL
			   "AUX" LINE (CNT 1) RM (GOAL-FLAG <>) LOC G)
	 <SET LINE <GET-LINE <GETP .GOAL ,P?LINE>>>
	 <SET G <GETP .GOAL ,P?STATION>>
	 <REPEAT ()
		 <SET RM <GET .LINE .CNT>>
		 <COND (<==? .RM .HEER>
		        <COND (.GOAL-FLAG
			       <SET LOC <GET .LINE <- .CNT 3>>>)
			      (T
			       <SET LOC <GET .LINE <+ .CNT 3>>>)>
			<RETURN .LOC>)
		       (<==? .RM .G>
			<SET GOAL-FLAG T>)>
		 <SET CNT <+ .CNT 3>>>>

<ROUTINE GET-LINE (LN)
	 <COND (<==? .LN ,MAIN-LINE-C>	,MAIN-LINE)
	       (<==? .LN ,BED-LINE-C>	,BED-LINE)
	       (<==? .LN ,TOWER-LINE-C>	,TOWER-LINE)
	       (<==? .LN ,PASS-LINE-C>	,PASS-LINE)>>

<ROUTINE IN-MOTION? (PERSON "OPTIONAL" (DISABLED-OK <>) "AUX" GT L F C)
	<SET C <GETP .PERSON ,P?CHARACTER>>
	<SET GT <GET ,GOAL-TABLES .C>>
	<COND (<AND <EQUAL? .PERSON ,BUTLER>
		    <BTST ,PRESENT-TIME 1>
		    <ZERO? .DISABLED-OK>>
	       <RFALSE>)
	      (<AND <GET .GT ,GOAL-S>
		    <NOT <==? <SET L <LOC .PERSON>>
			      <SET F <GET .GT ,GOAL-F>>>>>
	       <COND (.DISABLED-OK <RTRUE>)
		     (<NOT <ZERO? <GET .GT ,GOAL-ENABLE>>>
		      <RTRUE>
		      ;<FOLLOW-GOAL-DIR .L .F .PERSON>)>)>>

"Movement etc."

<ROUTINE ESTABLISH-GOAL (PERSON GOAL "OPTIONAL" (SPEED 1) "AUX" LOCN GT)
	 ;%<DEBUG-CODE
	   <COND (<ZERO? .PERSON>
		  <TELL "{!! E-G: PERSON=0, GOAL=" D .GOAL ".}|">)>>
	 <SET LOCN <LOC .PERSON>>
	 <COND (<==? .LOCN .GOAL>
		<RETURN <GOAL-REACHED .PERSON>>)>
	 <COND (<EQUAL? .PERSON ,CONFESSED ,CAPTOR>
		<RETURN .LOCN>)>
	 ;%<DEBUG-CODE
	   <COND (<ZERO? <GETP .LOCN ,P?LINE>>
		  <TELL
"{!! E-G: PERSON=" D .PERSON ", LOCN=" D .LOCN ", GOAL=" D .GOAL ".}|">)>>
	 ;%<DEBUG-CODE
	   <COND (<ZERO? <GETP .GOAL ,P?LINE>>
		  <TELL
"{!! E-G: PERSON=" D .PERSON", GOAL=" D .GOAL ".}|">)>>
	 <SET GT <GT-O .PERSON>>
	 <PUT .GT ,GOAL-I <+ <* <- <GETP .LOCN ,P?LINE> 1> ,GOAL-I-MULTIPLIER>
			     <* <- <GETP .GOAL ,P?LINE> 1> 2>>>
	 <PUT .GT ,GOAL-S <GETP .GOAL ,P?STATION>>
	 <PUT .GT ,GOAL-F .GOAL>
	 <PUT .GT ,GOAL-ENABLE .SPEED>
	 .LOCN>

<GLOBAL GOAL-PERSON:OBJECT <>>
<ROUTINE GOAL-REACHED (PERSON "AUX" GT (VAL <>))
	<SET GT <GT-O .PERSON>>
	;<COND (<ZERO? <GET .GT ,GOAL-S>> <RFALSE>)>
	<PUT .GT ,GOAL-S <>>
	<PUTP .PERSON ,P?LDESC 0> ;"default desc"
	<COND (<NOT <CREEPY? <SET VAL <META-LOC .PERSON>>>>
	       <FSET .VAL ,ONBIT>)>
	<SETG GOAL-PERSON .PERSON>
	<SET VAL <D-APPLY "Reached" <GET .GT ,GOAL-FUNCTION> ,G-REACHED>>
	<COND (<T? .VAL> <RETURN .VAL>)
	      (<AND <IN? .PERSON ,HERE>
		    <NOT <FSET? .PERSON ,TOUCHBIT>>>
	       <APPLY <GETP .PERSON ,P?DESCFCN> ,M-OBJDESC>)>>

<ROUTINE ENTERS? (DIR WHERE)
 <COND (<==? .DIR ,P?IN>
	<RTRUE>)
       (<FSET? .WHERE ,TOUCHBIT>
	<RTRUE>)>>

<ROUTINE TELL-OPEN-DOOR () <TELL " opens the door for a moment and">>

<ROUTINE TELL-HIS-HER-BEDROOM (CHR WHERE)
	<COND (<==? .CHR ,BUTLER-C>
	       <TELL THE .WHERE>
	       <RTRUE>)>
	<INC CHR>
	<COND (<NOT <EQUAL? .WHERE <GET ,CHAR-ROOM-TABLE .CHR>
				   <GET ,CHAR-CLOSET-TABLE .CHR>>>
	       <TELL THE .WHERE>
	       <RTRUE>)>
	<TELL " h">
	<COND (<FSET? <GET ,CHARACTER-TABLE <- .CHR 1>> ,FEMALE>
	       <TELL "er ">)
	      (T <TELL "is ">)>
	<COND (<FSET? .WHERE ,SECRETBIT>
	       <TELL "entrance">)
	      (T <TELL "bedroom">)>>

<ROUTINE TELL-LOCKING-THE-DOOR (DOOR)
	<COND (<AND <T? .DOOR> <FSET? .DOOR ,LOCKED>>
	       <TELL ", locking the door">)>>

<ROUTINE MOVE-PERSON (PERSON WHERE
		  "AUX" DIR EDIR (GT <>) OL COR PCOR CHR (DOOR <>) (VAL <>) X)
	 <COND (<FSET? .PERSON ,MUNGBIT>
		<RFALSE>)
	       (<EQUAL? .PERSON ,CONFESSED ,CAPTOR ,FOLLOWER>
		<RFALSE>)
	       (<AND <EQUAL? .PERSON ,BUTLER>
		     <OR <EQUAL? ,AWAITING-REPLY ,BUTLER-1-R ,BUTLER-2-R>
			 <EQUAL? ,AWAITING-REPLY ,BUTLER-3-R ,BUTLER-4-R>>>
		<RFALSE>)>
	 <PUTP .PERSON ,P?LDESC 6 ;"walking along">
	 <COND (<AND <EQUAL? .PERSON ,BUTLER>
		     <BTST ,PRESENT-TIME 1>>
		<RFALSE>)>
	 <SET CHR <GETP .PERSON ,P?CHARACTER>>
	 <SET GT <GET ,GOAL-TABLES .CHR>>
	 <SET OL <LOC .PERSON>>
	 <SET DIR <DIR-FROM .OL .WHERE>>
	 <SET EDIR <COMPASS-EQV .OL .DIR>>
	 <SETG GOAL-PERSON .PERSON>
	 <COND (<AND <NOT <ZERO? .DIR>>
		     <SET X <GETPT .OL .DIR>>
		     <==? <PTSIZE .X> ,DEXIT>>
		<SET DOOR <GET-DOOR-OBJ .X>>)>
	 <SET PCOR <CORRIDOR-LOOK .PERSON>>
	 <COND (<==? ,M-FATAL <D-APPLY "Enroute" <GET .GT ,GOAL-FUNCTION>
						 ,G-ENROUTE>>
		<THIS-IS-IT .PERSON>
		<RFATAL>)
	       (<EQUAL? .PERSON ,PLAYER>
		<COND (.DOOR
		       <FSET .DOOR ,SEENBIT>
		       <COND (<NOT <WALK-THRU-DOOR? .X>>
			      <RFATAL>)>)>)
	       (<AND <T? ,NOW-WEARING>
		     <OR <ZERO? ,LIT>
			 <FSET? .PERSON ,NDESCBIT>>>
		T)
	       (<==? .OL ,HERE>
		<SET VAL T>
		<TELL CHE .PERSON>
		<COND (<AND <T? .DOOR>
			    <NOT <FSET? .DOOR ,OPENBIT>>>
		       <FSET .DOOR ,TOUCHBIT ;,SEENBIT>
		       <TELL-OPEN-DOOR>)>
		<COND (<==? .DIR ,P?OUT>
		       <TELL " leaves.|">)
		      (<ENTERS? .DIR .WHERE>
		       <TELL " enters">
		       <TELL-HIS-HER-BEDROOM .CHR .WHERE>
		       <TELL-LOCKING-THE-DOOR .DOOR>
		       <TELL ".|">)
		      (T
		       <TELL " walks ">
		       <COND (<EQUAL? .DIR ,P?UP ,P?DOWN>
			      <DIR-PRINT .DIR>)
			     (<FSET? .WHERE ,TOUCHBIT>
			      <TELL "to">
			      <TELL-HIS-HER-BEDROOM .CHR .WHERE>)
			     (T
			      <DIR-PRINT .EDIR>)>
		       <TELL-LOCKING-THE-DOOR .DOOR>
		       <TELL ".|">)>)
	       (<==? .WHERE ,HERE>
		<COND (<ZERO? ,NOW-WEARING>
		       <TELL
"When you hear the door begin to open, you" ,REMEMBER-NOT-DRESSED " and
hop into " 'YOUR-BATHROOM ".|">
		       <GOTO ,YOUR-BATHROOM>
		       <SET VAL ,M-FATAL>)
		      (<OR <NOT .GT>
			   <NOT <==? ,HERE <GET .GT ,GOAL-F>>>>
		       <SET VAL T>
		       <START-SENTENCE .PERSON>
		       <COND (<AND <T? .DOOR>
				   <NOT <FSET? .DOOR ,OPENBIT>>>
			      <FSET .DOOR ,TOUCHBIT ;,SEENBIT>
			      <TELL-OPEN-DOOR>)>
		       <COND (<AND <VERB? WALK>
				   <==? .OL ,OHERE>>
			      <TELL " follows you">)
			     (T
			      <TELL " walks past you from">
			      <COND (<EQUAL? .DIR ,P?UP ,P?DOWN>
				     <TELL !\ >
				     <DIR-PRINT <OPP-DIR .DIR>>)
				    (T
				     <TELL-HIS-HER-BEDROOM .CHR .OL>)>)>
		       <TELL ".|">)>)
	       (<SET COR <GETP ,HERE ,P?CORRIDOR>>
		<COND (<NOT <ZERO? .PCOR>>
		       <COND (<ZERO? <CORRIDOR-LOOK .WHERE>>
			      <SET VAL T>
			      <COND (<AND <EQUAL? .PERSON ,P-HER-OBJECT>
					  <FSET? ,HER ,TOUCHBIT>>
				     <TELL "She">)
				    (<AND <EQUAL? .PERSON ,P-HIM-OBJECT>
					  <FSET? ,HIM ,TOUCHBIT>>
				     <TELL "He">)
				    (T
				     <START-SENTENCE .PERSON>
				     <TELL !\,>
				     <WHERE? .PERSON .PCOR>
				     <TELL !\,>)>
			      <COND (<AND <T? .DOOR>
					  <NOT <FSET? .DOOR ,OPENBIT>>>
				     <FSET .DOOR ,TOUCHBIT ;,SEENBIT>
				     <TELL-OPEN-DOOR>)>
			      <COND (<ENTERS? .DIR .WHERE>
				     <TELL " enters">
				     <TELL-HIS-HER-BEDROOM .CHR .WHERE>)
				    (T
				     <TELL " disappears ">
				     <COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
					    <TELL "to the ">)>
				     <DIR-PRINT .EDIR>)>
			      <TELL-LOCKING-THE-DOOR .DOOR>
			      <TELL ".|">)
			     (T
			      <SET VAL T>
			      <START-SENTENCE .PERSON>
			      <TELL " is">
			      <WHERE? .PERSON .PCOR>
			      <TELL ", heading ">
			      <COND (<==? .PCOR .DIR>
				     <TELL "away from you">)
				    (<==? .PCOR <OPP-DIR .DIR>>
				     <TELL "toward you">)
				    (T
				     <COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
					    <TELL "toward the ">)>
				     <DIR-PRINT .EDIR>)>
			      <TELL ".|">)>)
		      (<T? <SET PCOR <CORRIDOR-LOOK .WHERE>>>
		       <SET VAL T>
		       <WHERE? .PERSON .PCOR T>
		       <TELL HE .PERSON appear>
		       <SET DIR <COMPASS-EQV ,HERE <DIR-FROM .WHERE .OL>>>
		       <COND (<NOT <EQUAL? .DIR ,P?IN>>
			      <TELL " from">
			      <TELL-HIS-HER-BEDROOM .CHR .OL>)>
		       <TELL ".|">)>)>
	<COND (<AND .VAL
		    <IN? ,LUGGAGE .PERSON>
		    <T? ,NOW-WEARING>
		    ;<==? ,HERE .WHERE>>
	       <TELL CHE .PERSON is " carrying " D ,LUGGAGE ".|">)>
	<COND (<T? .PERSON> <MOVE .PERSON .WHERE>)>
	<COND (.GT
	       <COND (<==? <GET .GT ,GOAL-F> .WHERE>
		      <SET X <GOAL-REACHED .PERSON>>
		      <COND (<AND <ZERO? .X>
				  <==? ,HERE .WHERE>
				  <NOT <FSET? .PERSON ,NDESCBIT>>>
			     <SET VAL T>
			     <TELL CHE .PERSON " enters and nods to you." CR>)
			    (<AND <T? .X>
				  <NOT <==? .VAL ,M-FATAL>>>
			     <SET VAL .X>)>)
		     (T
		      <SET X <D-APPLY "Enroute" <GET .GT ,GOAL-FUNCTION>
						,G-ENROUTE>>
		      <COND (<AND <ZERO? .X>
				  <IN? .PERSON ,HERE>
				  <NOT <FSET? .PERSON ,TOUCHBIT>>>
			     <COND (<SET X <APPLY <GETP .PERSON ,P?DESCFCN>
						  ,M-OBJDESC>>
				    <SET VAL T>)>)
			    (<AND <T? .X>
				  <NOT <==? .VAL ,M-FATAL>>>
			     <SET VAL .X>)>)>)>
	;%<DEBUG-CODE <COND (,DBUG
			    <TELL !\{>
			    <TELL-$WHERE .PERSON .WHERE>
			    <TELL "}|">)>>
	<COND (<T? .VAL>
	       <THIS-IS-IT .PERSON>
	       <COND (<NOT <==? .VAL ,M-FATAL>>
		      <FSET .WHERE ,SEENBIT>	;"so FOLLOW CHR works"
		      <PUT ,FOLLOW-LOC .CHR .WHERE>)>
	       <RETURN .VAL>)>>

"? combine next two routines?"

<ROUTINE COMPASS-EQV (RM DIR "AUX" DIRTBL DIRL P L TBL (VAL <>))
 <COND ;(<ZERO? .DIR> <RFALSE>)
       (<AND <NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
	     <NOT <EQUAL? .DIR ,P?IN ,P?OUT>>>
	<RETURN .DIR>)>
 <SET DIRTBL <GETPT .RM .DIR>>
 <SET DIRL <PTSIZE .DIRTBL>>
 <SET P 0>
 <REPEAT ()
	 <COND (.VAL <RETURN .VAL>)
	       (<0? <SET P <NEXTP .RM .P>>> <RFALSE>)
	       (<NOT <L? .P ,LOW-DIRECTION>>
		<SET TBL <GETPT .RM .P>>
		<SET L <PTSIZE .TBL>>
		<COND (<NOT <==? .L .DIRL>> <AGAIN>)>
		<DEC L>
		<REPEAT ()
			<COND (<NOT <==? <GETB .TBL .L> <GETB .DIRTBL .L>>>
			       <RETURN>)
			      (<DLESS? L 0>
			       <SET VAL .P>
			       <RETURN>)>>)>>>

<ROUTINE DIR-EQV? (RM DIR1 DIR2 "AUX" DIR1TBL DIR2TBL L)
	<COND (<==? .DIR1 .DIR2>
	       <RTRUE>)
	      (<ZERO? <SET DIR1TBL <GETPT .RM .DIR1>>>
	       <RFALSE>)
	      (<ZERO? <SET DIR2TBL <GETPT .RM .DIR2>>>
	       <RFALSE>)>
	<SET L <PTSIZE .DIR1TBL>>
	<COND (<NOT <==? .L <PTSIZE .DIR2TBL>>>
	       <RFALSE>)>
	<DEC L>
	<REPEAT ()
		<COND (<NOT <==? <GETB .DIR1TBL .L> <GETB .DIR2TBL .L>>>
		       <RFALSE>)
		      (<DLESS? L 0>
		       <RTRUE>)>>>

<ROUTINE DIR-FROM (HERE THERE "AUX" (V <>) P D)
 <COND (<DIR-FROM-TEST .HERE .THERE ,P?UP>	<RETURN ,P?UP>)
       (<DIR-FROM-TEST .HERE .THERE ,P?DOWN>	<RETURN ,P?DOWN>)
       (<DIR-FROM-TEST .HERE .THERE ,P?IN>	<RETURN ,P?IN>)
       (<DIR-FROM-TEST .HERE .THERE ,P?OUT>	<RETURN ,P?OUT>)>
 <SET P 0>
 <REPEAT ()
	 <COND (<L? <SET P <NEXTP .HERE .P>> ,LOW-DIRECTION>
		<RETURN .V>)
	       (<SET D <DIR-FROM-TEST .HERE .THERE .P>>
		<COND (<AND <L? .D ,LOW-DIRECTION> <NOT .V>>
		       <SET V .P>)
		      (T <RETURN .P>)>)>>>

<ROUTINE DIR-FROM-TEST (HERE THERE P "AUX" L TBL)
	<COND (<ZERO? <SET TBL <GETPT .HERE .P>>>
	       <RFALSE>)>
	<SET L <PTSIZE .TBL>>
	<COND (<AND <EQUAL? .L ,DEXIT ,UEXIT ,CEXIT>
		    <==? <GET-REXIT-ROOM .TBL> .THERE>>
	       <RETURN .P>)>>

"These routines were moved to low addresses in MISC: I-FOLLOW I-ATTENTION."

<ROUTINE I-PLAYER (ARG "AUX" (VAL <>))
  <SETG HERE <LOC ,PLAYER>>
  <COND (<==? .ARG ,G-REACHED>
	 <MAKE-ALL-PEOPLE -12 ;"listening to you">
	 <RTRUE>)
	(<==? .ARG ,G-ENROUTE>
	 %<DEBUG-CODE <COND (<T? ,DBUG> <RFALSE>)>>
	 <COND (<==? ,OHERE ,HERE>
		<RFALSE>)
	       (<OR <ZERO? <LIT?>>
		    <EQUAL? ,HERE ,MAZE>
		    <AND <FSET? <SET VAL ,HERE> ,SECRETBIT>
			 <NOT <FSET? ,HERE ,SEENBIT>>>
		    <AND <PROB 50>
			 <SET VAL
			    <FIND-FLAG-HERE-NOT ,PERSONBIT ,MUNGBIT ,PLAYER>>>>
		<COND ;(<DIR-FROM ,HERE ,OHERE>
		       <TELL "You have just started walking, when">)
		      (T
		       <TELL "But ">
		       <COND (<FSET? ,HERE ,SURFACEBIT> <TELL "on">)
			     (T <TELL "in">)>
		       <TELL THE ,HERE>)>
		<COND (<ZERO? .VAL>
		       <TELL " you get lost in the dark">)
		      (<FSET? .VAL ,SECRETBIT>
		       <TELL " you realize that you don't know the way">)
		      (<EQUAL? .VAL ,GHOST-NEW>
		       <TELL " the ghost blocks your way">)
		      (T
		       <TELL HE .VAL <PICK-ONE-NEW ,PLAYER-OBSTACLES>>)>
		<TELL ".|">
		<MAKE-ALL-PEOPLE -12 ;"listening to you">
		<RFATAL>)
	       (T <RFALSE>)>)>>

<GLOBAL PLAYER-OBSTACLES
	<LTABLE 0
		" gets in your way"
		" says hello">>

<ROUTINE GOODNIGHT (RM PER "OPTIONAL" (CLOSET <>) "AUX" DR (VAL <>))
 <COND (<EQUAL? .RM ,HERE>
	<TELL D .PER>
	<THIS-IS-IT .PER>
	<TELL
" shows you firmly to the door, saying" HE .PER is " going to bed." CR>
	<SET VAL ,WINNER>
	<SETG WINNER ,PLAYER>
	<PUTP .PER ,P?LINE 0>	;"so s/he won't prevent your leaving"
	<GOTO <GET-REXIT-ROOM <GETPT ,HERE ,P?OUT>>>
	<SETG WINNER .VAL>)
       (<AND <EQUAL? .CLOSET ,HERE>
	     <SET DR <FIND-FLAG-LG .CLOSET ,DOORBIT ,SECRETBIT>>
	     <NOT <EQUAL? .DR ,SECRET-HYDE-DOOR ,SECRET-IRIS-DOOR>>
	     <FSET? .DR ,OPENBIT>>
	<FCLEAR .DR ,OPENBIT>
	<PUT ,FOUND-PASSAGES <GETP .PER ,P?CHARACTER> T>
	<SETG LIT <LIT?>>
	<TELL D .PER " closes the " D .DR " without noticing you." CR>
	<SET VAL T>)>
 <FCLEAR .RM ,ONBIT>
 <FSET .PER ,MUNGBIT>
 <FCLEAR .RM ,OPENBIT>
 <FSET .RM ,LOCKED>
 <COND (<EQUAL? .PER ,FOLLOWER>
	<SETG FOLLOWER 0>)>
 <PUTP .PER ,P?LDESC 14 ;"asleep">
 .VAL>

<ROUTINE GRAB-ATTENTION (PERSON "OPTIONAL" (OBJ <>) "AUX" N GT ATT)
	 <COND (<FSET? .PERSON ,MUNGBIT>
		<COND (<EQUAL? <GETP .PERSON ,P?LDESC> 14 ;"asleep">
		       <TOO-BAD-BUT .PERSON "asleep">
		       <RFALSE>)
		      (T
		       <TOO-BAD-BUT .PERSON "out cold">
		       <RFALSE>)>)
	       (<AND <==? <GET <SET GT <GET ,GOAL-TABLES
					    <GETP .PERSON ,P?CHARACTER>>>
			       ,GOAL-FUNCTION>
			  ,X-RETIRES>
		     <NOT <EQUAL? .PERSON ,GHOST-NEW ,CONFESSED ,CAPTOR>>
		     <NOT <EQUAL? ,VARIATION <GETP .PERSON ,P?CHARACTER>>>
		     <OR <ZERO? .OBJ>
			 <FSET? .OBJ ,PERSONBIT>
			 <NOT <FSET? .OBJ ,RMUNGBIT>> ;"evidence">>
		<TOO-BAD-BUT .PERSON "too sleepy to listen">
		<RFALSE>)
	       (<AND <==? .PERSON ,BUTLER>
		     <OR <VERB? ASK-FOR>
			 <T? <GET .GT ,GOAL-S>>>
		     <NOT <VERB? SORRY TAKE THANKS>>
		     <NOT <VERB? YES NO>>
		     <NOT <DOBJ? LUGGAGE DINNER>>>
		<BUTLER-SORRY>
		<RFALSE>)
	       (<SET N <ANGRY-REJECT? .PERSON .OBJ>>
		<TOO-BAD-BUT .PERSON
			     <COND (<1? .N> "peeved")
				   (T "angry")>>
		<RFALSE>)>
	 <COND (<GET .GT ,GOAL-S>
		<SET ATT <GET .GT ,ATTENTION-SPAN>>
		<PUT .GT ,ATTENTION .ATT>
		<COND (<==? .ATT 0>
		       <PUT .GT ,GOAL-ENABLE 1>
		       <TOO-BAD-BUT .PERSON <GET ,LDESC-STRINGS 17>
					    ;"preparing to leave">
		       <RFALSE>)
		      (T
		       <PUT .GT ,GOAL-ENABLE 0>)>)>
	 <SETG QCONTEXT .PERSON>
	 <COND (<NOT <==? <GETP .PERSON ,P?LDESC> 21 ;"searching">>
		<PUTP .PERSON ,P?LDESC 12 ;"listening to you">)>
	 <RTRUE>>

<ROUTINE ANGRY-REJECT? (PERSON OBJ "AUX" N)
 <COND (<==? .PERSON ,GHOST-NEW>
	<RFALSE>)
       (<0? <SET N <GETP .PERSON ,P?LINE>>>
	<RFALSE>)
       (<VERB? FORGIVE SORRY TELL ;"JACK,SORRY">
	<RFALSE>)
       (<AND <VERB? GIVE> <==? ,PRSI .PERSON>>
	<RFALSE>)
       (<EVIDENCE? .OBJ .PERSON>
	<RFALSE>)
       (T .N)>>

<ROUTINE WHERE? (PER "OPTIONAL" (X 0) (CAP 0))
	<COND (<NOT <IN? .PER ,HERE>>
	       <COND (<ZERO? .X>
		      <TELL !\,>
		      <SET X <CORRIDOR-LOOK .PER>>
		      ;<SET X <COR-DIR ,HERE <LOC .PER> <GETP .PER ,P?CAR>>>)>
	       <COND (<ZERO? .CAP> <PRINTC 32>)>
	       <COND (<EQUAL? .X ,P?DOWN>
		      <COND (<ZERO? .CAP> <TELL !\d>)
			    (T		  <TELL !\D>)>
		      <TELL "ownstairs">)
		     (<EQUAL? .X ,P?IN>
		      <COND (<ZERO? .CAP> <TELL "in">) (T <TELL "In">)>
		      <TELL-HIS-HER-BEDROOM <GETP .PER ,P?CHARACTER>
					    <LOC .PER>>)
		     (<EQUAL? .X ,P?OUT>
		      <COND (<ZERO? .CAP> <TELL !\j>)
			    (T		  <TELL !\J>)>
		      <TELL "ust outside">)
		     (T
		      <COND (<ZERO? .CAP> <TELL !\t>)
			    (T		  <TELL !\T>)>
		      <TELL "o the ">
		      <DIR-PRINT .X>)>
	       <RTRUE>)>>

<ROUTINE DIR-PRINT (DIR "AUX" (CNT 0) TBL X)
	 <COND (<NOT .DIR>
		<TELL "out of view">
		<RTRUE>)>
	 <SET TBL ,DIR-STRINGS>
	 <REPEAT ()
		 <SET X <GET .TBL .CNT>>
		 <COND (<ZERO? .X>
			<TELL "out of view">
			<RTRUE>)
		       (<==? .X .DIR>
			;<COND (<NOT <EQUAL? .DIR ,P?UP ,P?DOWN>>
			       <TELL "the ">)>
			<PRINT <GET .TBL <+ .CNT 1>>>
			<RTRUE>)>
		 <SET CNT <+ .CNT 2>>>>

<GLOBAL DIR-STRINGS
	<PTABLE P?SOUTH	"south"		P?NORTH	"north"
		P?EAST	"east"		P?WEST	"west"
		P?UP	"upstairs"	P?DOWN	"downstairs"
		P?IN	"inner"		P?OUT	"outer"
		P?SE	"southeast"	P?NW	"northwest"
		P?SW	"southwest"	P?NE	"northeast"
		0>>

<ROUTINE OPP-DIR (DIR "AUX" (CNT 0) X)
	<REPEAT ()
		 <SET X <GET ,DIR-STRINGS .CNT>>
		 <COND (<ZERO? .X> <RFALSE>)
		       (<==? .X .DIR>
			<COND (<0? <MOD .CNT 4>>
			       <RETURN <GET ,DIR-STRINGS <+ .CNT 2>>>)
			      (T
			       <RETURN <GET ,DIR-STRINGS <- .CNT 2>>>)>)>
		 <SET CNT <+ .CNT 2>>>>

"Goal tables for the characters, offset by a constant,
which, for a given character, is the P?CHARACTER property of the object."

<GLOBAL GOAL-TABLES
	<PTABLE	<TABLE <> <> <> 1 <> I-PLAYER	5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> X-WAITS		5 0>
		<TABLE <> <> <> 1 <> BUTLER-APPEARS	1 0>
		<TABLE <> <> <> 1 <> LOVER-XFER		5 0>
		<TABLE <> <> <> 1 <> GHOST-LURKS	5 0>>>
[
"Offsets into GOAL-TABLEs"

<CONSTANT GOAL-F 0> "final goal"
<CONSTANT GOAL-S 1> "station of final goal"
<CONSTANT GOAL-I 2> "intermediate goal (transfer point)"
<CONSTANT GOAL-ENABLE 3> "character can move: 0=no 1=slow 2=fast"
<CONSTANT GOAL-QUEUED 4> "queued goal to go to after interruption"
<CONSTANT GOAL-FUNCTION 5> "routine to apply on arrival"
<CONSTANT ATTENTION-SPAN 6> "how long character will wait when interrupted"
<CONSTANT ATTENTION 7> "used to count down from ATTENTION-SPAN to 0"
]

"Goal-function constants, similar to M-xxx in MAIN"

<CONSTANT G-REACHED 1>
<CONSTANT G-ENROUTE 2>
<CONSTANT G-IMPATIENT 3>
<CONSTANT G-DEBUG 4>

<GLOBAL TOUR-INDEX:NUMBER 0>
<GLOBAL TOUR-PATH
	<PTABLE FOYER DRAWING-ROOM GREAT-HALL GALLERY YOUR-ROOM 0>>

<ROUTINE I-TOUR ("OPTIONAL" (GARG <>) "AUX" L)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-TOUR:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SET L <GET ,TOUR-PATH ,TOUR-INDEX>>
	<COND (<ZERO? .L>
	       <COND (<EQUAL? ,FOLLOWER ,FRIEND ,LORD>
		      <SETG FOLLOWER 0>)>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL "0]" CR>)>>
	       <RFALSE>)>
	<COND (<AND <==? ,HERE ,GREAT-HALL>
		    <NOT <FSET? ,DOCTOR ,TOUCHBIT>>>
	       <QUEUE I-TOUR 3>
	       <MOVE ,DOCTOR ,HERE>
	       <SET L <DOCTOR-D>>
	       <SETG TOUR-FORCED <>>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL N .L "]" CR>)>>
	       <RETURN .L>)>
	<INC TOUR-INDEX>
	<SETG AWAITING-REPLY <>>
	<MAKE-ALL-PEOPLE 0>
	<COND (<AND <NOT <QUEUED? ,I-FOUND-IT>>
		    <ZERO? ,TOUR-FORCED>>
	       <CRLF>)>
	<SETG FOUND-IT <>>
	<QUEUE I-FOUND-IT 0>
	<COND (<EQUAL? .L ,GALLERY>
	       <TELL
"\"You two will have time to chat later,\" says " 'FRIEND ",
\"but you must excuse us now, ">
	       <COND (<NOT <EQUAL? ,QCONTEXT <> ,FRIEND ,BUTLER>>
		      <PRINTD ,QCONTEXT>)
		     (T <PRINTD ,DOCTOR>)>
	       <TELL ", while I show "FN" up to ">
	       <COND (<ZERO? ,GENDER-KNOWN> <TELL "the "> <PRINT-COLOR>)
		     (<FSET? ,PLAYER ,FEMALE> <TELL "her">)
		     (T <TELL "his">)>
	       <TELL " bedroom. I'm sure ">
	       <COND (<ZERO? ,GENDER-KNOWN> <TELL "our guest">)
		     (<FSET? ,PLAYER ,FEMALE> <TELL "she">)
		     (T <TELL "he">)>
	       <TELL " wants to freshen up for dinner!\"" CR>)>
	<TELL 'FRIEND " guides you ">
	<COND (<EQUAL? .L ,GALLERY>
	       <PUTP ,LORD	,P?LDESC 13 ;"lounging and chatting">
	       <PUTP ,DEB	,P?LDESC 13 ;"lounging and chatting">
	       <PUTP ,OFFICER	,P?LDESC 13 ;"lounging and chatting">
	       <TELL "up to">)
	      (T <TELL "into">)>
	<TELL THE .L ".||">
	<FSET ,FRIEND ,RMUNGBIT>	;"to skip description"
	<THIS-IS-IT ,FRIEND>
	<MOVE ,FRIEND .L>
	<COND (<EQUAL? .L ,GALLERY ,YOUR-ROOM>
	       <PUTP ,FRIEND ,P?LINE 0>
	       <TELL "She says, \"">
	       <COND (<EQUAL? .L ,GALLERY>
		      <TELL
"I know it's confusing, but the British call this the
'first' floor. We just left the 'ground' floor.\"" CR>)
		     (T <TELL
"You'll be sleeping in the same room that Queen Victoria
slept in!\"" CR>)>)>
	<COND (<NOT <EQUAL? .L ,GALLERY ,YOUR-ROOM>>
	       <COND (<FSET? ,LORD ,TOUCHBIT>
		      <FSET ,LORD ,RMUNGBIT>	;"to skip description")>
	       <MOVE ,LORD .L>
	       <PUT ,FOLLOW-LOC ,LORD-C .L>)>
	<SETG WINNER ,PLAYER>
	<GOTO .L T <>>
	<COND (<NOT <EQUAL? .L ,YOUR-ROOM>>
	       <QUEUE I-TOUR 3>)
	      (T
	       <COND (<EQUAL? ,FOLLOWER ,FRIEND ,LORD>
		      <SETG FOLLOWER 0>)>
	       <COND (<IN? ,BUTLER .L>
		      <ESTABLISH-GOAL ,FRIEND <LOC ,OFFICER>>
		      <TAMARA-LEAVES-YOU>)>)>
	<SETG TOUR-FORCED <>>
	%<DEBUG-CODE <COND (,IDEBUG <TELL "2]" CR>)>>
	<RFATAL>>

<ROUTINE I-FRIEND-GREETS ("OPTIONAL" (GARG <>))
  %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[I-FRIEND-GREETS:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
  <TELL "When a door opens in the castle">
  <COND (<NOT <FSET? ,FRONT-GATE ,OPENBIT>>
	 <FSET ,FRONT-GATE ,OPENBIT>
	 <TELL " and the " 'FRONT-GATE " creaks open">)>
  <TELL ", you decide to ">
  <COND (<NOT <EQUAL? ,HERE ,COURTYARD>>
	 <MOVE ,CAR ,COURTYARD>
	 <TELL "drive through the gate and ">)>
  <TELL "get out of the car." CR>
  <GOTO ,COURTYARD>
  <RTRUE>>

<ROUTINE BUTLER-APPEARS ("OPTIONAL" (GARG <>) "AUX" LL L)
  %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[BUTLER-APPEARS:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
  <COND (<==? .GARG ,G-REACHED>
	 ;<FCLEAR ,BUTLER ,NDESCBIT>	;"in BUTLER-D"
	 <PUT <GT-O ,BUTLER> ,GOAL-FUNCTION ,BUTLER-FETCHES>
	 <PUTP ,BUTLER ,P?LDESC 6 ;"walking along">
	 <COND (<NOT <FSET? ,COURTYARD ,TOUCHBIT>>
		<ESTABLISH-GOAL ,BUTLER ,COURTYARD>)
	       (T
		<SET L <LOC ,BUTLER>>
		<SET LL <META-LOC ,LUGGAGE>>
		<COND (<EQUAL? .LL ,YOUR-ROOM ,YOUR-BATHROOM>
		       <COND (<EQUAL? ,FOLLOWER ,FRIEND ,LORD>
			      <SETG FOLLOWER 0>)>
		       <ESTABLISH-GOAL ,BUTLER <LOC ,BUTLER>>	;"no-op")
		      (<EQUAL? .LL .L>
		       <BUTLER-FETCHES ,G-REACHED>)
		      (T
		       <ESTABLISH-GOAL ,BUTLER .LL>)>)>
	 <RFALSE>)>>

<ROUTINE BUTLER-FETCHES ("OPTIONAL" (GARG <>) "AUX" (L <LOC ,BUTLER>) LL GT)
  %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		      <TELL "[BUTLER-FETCHES:">
		      <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
  <SET LL <META-LOC ,LUGGAGE>>
  <SET GT <GT-O ,BUTLER>>
  <PUTP ,BUTLER ,P?LDESC 6 ;"walking along">
  <COND (<EQUAL? .LL ,YOUR-ROOM ,YOUR-BATHROOM>
	 <COND (<EQUAL? ,FOLLOWER ,FRIEND ,LORD>
		<SETG FOLLOWER 0>)>
	 <PUT .GT ,GOAL-FUNCTION ,BUTLER-CARRIES>
	 <ESTABLISH-GOAL ,BUTLER <LOC ,BUTLER>>	;"no-op"
	 <RFALSE>)
	(<AND <EQUAL? .L .LL>
	      <NOT <IN? ,LUGGAGE ,BUTLER>>>
	 <PUT .GT ,GOAL-FUNCTION ,BUTLER-CARRIES>
	 <ESTABLISH-GOAL ,BUTLER ,YOUR-ROOM>
	 <FCLEAR ,LUGGAGE ,OPENBIT>
	 <MOVE ,LUGGAGE ,BUTLER>
	 <MOVE ,CAR ,COURTYARD>
	 <COND (<AND <EQUAL? .L ,HERE>
		     <NOT <FSET? ,BUTLER ,NDESCBIT>>>
		<TELL CHE ,BUTLER " takes " 'LUGGAGE ".|">)>
	 ;<FCLEAR ,BUTLER ,NDESCBIT>
	 <RFALSE>)
	(<==? .GARG ,G-REACHED>
	 <COND (<FSET? ,COURTYARD ,TOUCHBIT>
		<ESTABLISH-GOAL ,BUTLER <META-LOC ,LUGGAGE>>)
	       (T
		<ESTABLISH-GOAL ,BUTLER ,COURTYARD>)>
	 <RFALSE>)>>

<ROUTINE TAMARA-LEAVES-YOU ()
	<TELL
CHE ,FRIEND " turns to leave, saying, \"Here's " 'BUTLER>
	<COND (<IN? ,LUGGAGE ,BUTLER>
	       <TELL " with " D ,LUGGAGE>)>
	<TELL ", so I'll leave you to rest or freshen up, ">
	<COND (<PRINT-NAME ,FIRST-NAME> <TELL !\.>)>
	<TELL
" Dinner's at eight, by the way -- or whenever you hear the gong.\"" CR>>

<ROUTINE BUTLER-CARRIES ("OPTIONAL" (GARG <>) "AUX" (L <LOC ,BUTLER>) (LL <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[BUTLER-CARRIES:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<==? .GARG ,G-ENROUTE>
	<COND (<EQUAL? .L ,FOYER> <FCLEAR ,FRONT-DOOR ,OPENBIT>)>
	<RFALSE>)
       (<==? .GARG ,G-REACHED>
	<PUT <GT-O ,BUTLER> ,GOAL-ENABLE 0>
	<QUEUE I-BUTLER-HINTS 7>
	<QUEUE I-BUTLER-COOKS 9>
	<PUTP ,BUTLER ,P?LDESC 9 ;"waiting patiently">
	<FCLEAR ,BUTLER ,NDESCBIT>
	<COND (<IN? ,LUGGAGE ,BUTLER>
	       <SET LL T>
	       <MOVE ,LUGGAGE ,BED>)>
	<COND (<AND <NOT <QUEUED? ,I-TOUR>>
		    <NOT <==? ,FRIEND ,FOLLOWER>>>
	       <ESTABLISH-GOAL ,FRIEND <LOC ,OFFICER>>)>
	<COND (<EQUAL? .L ,HERE>
	       <COND (<AND <IN? ,FRIEND ,HERE>
			   <NOT <==? ,FRIEND ,FOLLOWER>>>
		      <TAMARA-LEAVES-YOU>)>
	       <TELL "The butler enters">
	       <COND (.LL<TELL " with " D ,LUGGAGE" and lays it on the bed">)>
	       <SETG QCONTEXT ,BUTLER>
	       <THIS-IS-IT ,BUTLER>
	       <FSET ,BUTLER ,TOUCHBIT>
	       <PUTP ,BUTLER ,P?LDESC 12 ;"listening to you">
	       <SETG AWAITING-REPLY ,BUTLER-1-R>
	       <QUEUE I-REPLY ,CLOCKER-RUNNING>
	       <TELL ".|
\"I regret to say, "TN", that the maid will be unable to unpack for you,
due to the arrangements for the
late Lord Lionel's memorial birthday dinner,\" he apologizes.
\"" <GET ,QUESTIONS ,AWAITING-REPLY> "\"|">
	       <RFATAL>)>)>>

<GLOBAL BUTLER-HINTS-COUNTER:NUMBER 0>
<ROUTINE I-BUTLER-HINTS ("OPTIONAL" (GARG <>) "AUX" (SAID <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-BUTLER-HINTS:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND ;(<FIND-FLAG-HERE ,PERSONBIT ,PLAYER ,BUTLER>
	       <QUEUE I-BUTLER-HINTS 1>)
	      (<OR <EQUAL? ,AWAITING-REPLY ,BUTLER-1-R ,BUTLER-2-R>
		   <EQUAL? ,AWAITING-REPLY ,BUTLER-3-R ,BUTLER-4-R>>
	       <QUEUE I-BUTLER-HINTS 1>)
	      (<L? 2 ,BUTLER-HINTS-COUNTER>
	       <QUEUE I-BUTLER-HINTS 0>
	       <RFALSE>)
	      (<AND <EQUAL? ,HERE <LOC ,BUTLER>>
		    <ZERO? <GETP ,BUTLER ,P?LINE>>>
	       <SET SAID T>
	       <PUT <GT-O ,BUTLER> ,ATTENTION 5>
	       <SETG BUTLER-HINTS-COUNTER <+ ,BUTLER-HINTS-COUNTER 1>>
	       <QUEUE I-BUTLER-HINTS 2>
	       <SETG QCONTEXT ,BUTLER>
	       <THIS-IS-IT ,BUTLER>
	       <PUTP ,BUTLER ,P?LDESC 12 ;"listening to you">
	       <COND (<==? 1 ,BUTLER-HINTS-COUNTER>
		      <SETG AWAITING-REPLY ,BUTLER-2-R>
		      <QUEUE I-REPLY ,CLOCKER-RUNNING>
		      <TELL
'BUTLER " coughs diffidently and asks, \""TN"? "
<GET ,QUESTIONS ,AWAITING-REPLY> "\"|">
		      <SET SAID ,M-FATAL>)
		     (<==? 2 ,BUTLER-HINTS-COUNTER>
		      <COND (<NOT <IN? ,MACE ,BUTLER>>
			     <RFALSE>)>
		      <SETG AWAITING-REPLY ,BUTLER-3-R>
		      <QUEUE I-REPLY ,CLOCKER-RUNNING>
		      <TELL
"|\"" <GET ,QUESTIONS ,AWAITING-REPLY> "\" adds " 'BUTLER ".|">
		      <SET SAID ,M-FATAL>)
		     (<==? 3 ,BUTLER-HINTS-COUNTER>
		      <I-BUTLER-COOKS>
		      <COND (<NOT <FSET? ,SECRET-YOUR-DOOR ,OPENBIT>>
			     <TELL "\"Ah, by the way, "TN" -- s">
			     <BUTLER-MIRROR-STORY>
			     <TELL "Without explaining further, " 'BUTLER>
			     <COND (<EQUAL? ,HERE ,YOUR-ROOM>
				    <PUT ,FOLLOW-LOC ,BUTLER-C ,GALLERY>
				    <MOVE ,BUTLER ,GALLERY>
				    <PUTP ,BUTLER ,P?LDESC 6 ;"walking along">
				    <TELL " abruptly leaves the room." CR>)
				   (T
				    <PUTP ,BUTLER ,P?LDESC 20 ;"ignoring you">
				    <TELL " turns to his work." CR>)>)
			    (T
			     <TELL
"\"I hope you have a pleasant stay with us, ">
			     <COND (<TITLE-NAME> <TELL !\.>)>
			     <TELL " Dinner is at eight.\"" CR>)>)>)
	      (<NOT <IN? ,BUTLER ,LOCAL-GLOBALS>>
	       <QUEUE I-BUTLER-HINTS 1>)
	      ;(<==? 3 ,BUTLER-HINTS-COUNTER>
	       <QUEUE I-BUTLER-HINTS 0>
	       ;<COND (<QUEUED? ,I-BUTLER-COOKS>
		      <I-BUTLER-COOKS>)>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	<RETURN .SAID>>

<ROUTINE I-BUTLER-COOKS ("OPTIONAL" (GARG <>) (VAL <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[I-BUTLER-COOKS:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<OR <EQUAL? ,AWAITING-REPLY ,BUTLER-1-R ,BUTLER-2-R>
	    <EQUAL? ,AWAITING-REPLY ,BUTLER-3-R ,BUTLER-4-R>
	    <AND <NOT <==? 3 ,BUTLER-HINTS-COUNTER>>
		 <SET VAL <I-BUTLER-HINTS>>>>
	<QUEUE I-BUTLER-COOKS ;-HINTS 2>)
       (<IN? ,DINNER ,KITCHEN>
	<PUTP ,BUTLER ,P?LDESC 17 ;"preparing to leave">
	<PUT <GT-O ,BUTLER> ,GOAL-FUNCTION ,BUTLER-COOKS>
	<ESTABLISH-GOAL ,BUTLER ,KITCHEN>)
       (T <BUTLER-COOKS ,G-REACHED>)>
 <RETURN .VAL>>

<ROUTINE BUTLER-COOKS ("OPTIONAL" (GARG <>) "AUX" N)
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[BUTLER-COOKS:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<==? .GARG ,G-REACHED>
	<PUTP ,BUTLER ,P?LDESC 11 ;"preparing dinner">
	<SET N <- %<- ,DINNER-TIME 8> ,PRESENT-TIME>>
	<COND (<NOT <G? .N 0>> <SET N 1>)>
	<COND (<IN? ,DINNER ,KITCHEN>
	       <QUEUE I-BUTLER-SERVES .N>)
	      (T
	       <PUT <GT-O ,BUTLER> ,GOAL-FUNCTION ,BUTLER-LEAVES>
	       <PUTP ,BUTLER ,P?LDESC 17 ;"preparing to leave">
	       <ESTABLISH-GOAL ,BUTLER ,KITCHEN>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL "0]" CR>)>>
	<RFALSE>)>>

<ROUTINE I-BUTLER-SERVES ("OPTIONAL" (GARG <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-BUTLER-SERVES:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<MOVE ,DINNER ,BUTLER>
	<PUTP ,BUTLER ,P?LDESC 17 ;"preparing to leave">
	<PUT <GT-O ,BUTLER> ,GOAL-FUNCTION ,BUTLER-SERVES>
	<ESTABLISH-GOAL ,BUTLER ,DINING-ROOM>
	<COND (<IN? ,BUTLER ,HERE>
	       <TELL 'BUTLER " takes dinner." CR>)>>

<ROUTINE BUTLER-SERVES ("OPTIONAL" (GARG <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[BUTLER-SERVES:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<==? .GARG ,G-REACHED>
	<COND (<EQUAL? ,HERE ,DINING-ROOM>
	       <TELL CHE ,BUTLER " appears">)>
	<COND (<IN? ,DINNER ,BUTLER>
	       <COND (<EQUAL? ,HERE ,DINING-ROOM>
		      <TELL ", puts dinner on the " 'SIDEBOARD>)>
	       <MOVE ,DINNER ,SIDEBOARD>)>
	<COND (<IN? ,LETTER ,BUTLER>
	       <COND (<EQUAL? ,HERE ,DINING-ROOM>
		      <FCLEAR ,LETTER ,NDESCBIT>
		      <TELL ", leaves a note on Jack's napkin">)>
	       <MOVE ,LETTER ,TABLE-DINING>
	       <FSET ,LETTER ,TAKEBIT>)>
	;<COND (<IN? ,CLUE-1 ,BUTLER>
	       <COND (<EQUAL? ,HERE ,DINING-ROOM>
		      <FCLEAR ,CLUE-1 ,NDESCBIT>
		      <TELL ", puts a card on the " 'SIDEBOARD>)>
	       <MOVE ,CLUE-1 ,SIDEBOARD>)>
	<FSET ,CLUE-1 ,TAKEBIT>
	<PUTP ,BUTLER ,P?LDESC 17 ;"preparing to leave">
	<PUT <GT-O ,BUTLER> ,GOAL-FUNCTION ,BUTLER-LEAVES>
	<ESTABLISH-GOAL ,BUTLER ,KITCHEN>
	<COND (<EQUAL? ,HERE ,DINING-ROOM>
	       <TELL ", and looks around the room." CR>)>)>>

<ROUTINE X-WAITS ("OPTIONAL" (GARG <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[X-WAITS:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<==? .GARG ,G-REACHED>
	<PUTP ,GOAL-PERSON ,P?LDESC 9 ;"waiting patiently">
	<RFALSE>)>>

<GLOBAL MASS-SAID:FLAG 0>
<GLOBAL MASS-COUNTER:NUMBER 0>

<ROUTINE I-DINNER ("OPTIONAL" (GARG <>) "AUX" N CH (SAID <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-DINNER:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SET N ,MASS-COUNTER>
	<REPEAT ()
		<COND (<IGRTR? N ,DEB-C>
		       <SETG MASS-SAID <>>
		       <SETG MASS-COUNTER 0>
		       <COND (<NOT <QUEUED? ,I-DINNER-SIT>>
			      <QUEUE I-DINNER-SIT 5>)>
		       <RFALSE>)
		      (<AND <==? .N ,FRIEND-C>
			    <QUEUED? ,I-TOUR>>
		       <QUEUE I-TOUR 1>
		       <RFALSE>)>
		<SET CH <GET ,CHARACTER-TABLE .N>>
		<COND (<==? .CH ,FOLLOWER>
		       <SETG FOLLOWER 0>)>
		<COND (<AND <NOT <==? .CH ,SHOOTER>>
			    <NOT <FSET? .CH ,MUNGBIT>>
			    <NOT <IN? .CH ,DINING-ROOM>>>
		       <RETURN>)>>
	<QUEUE I-DINNER 1>
	<SETG MASS-COUNTER .N>
	<PUT <GET ,GOAL-TABLES .N> ,GOAL-FUNCTION ,X-WAITS>
	<ESTABLISH-GOAL .CH ,DINING-ROOM>
	<COND (<AND <EQUAL? <META-LOC .CH> ,HERE>
		    <NOT <EQUAL? ,HERE ,DINING-ROOM>>
		    <OR <ZERO? ,MASS-SAID>
			<==? .CH ,FOLLOWER>>>
	       <SET SAID T>
	       <SETG MASS-SAID T>
	       <COND (<==? .CH ,FOLLOWER>
		      <SETG FOLLOWER 0>)>
	       <TELL CHE .CH " says, \"It's time for dinner now. ">
	       <COND (<OR <NOT <EQUAL? ,NOW-WEARING ,DINNER-OUTFIT>>
			  <ZERO? ,WASHED>>
		      <TELL "I'll see you in">)
		     (T <TELL "Let's go to">)>
	       <TELL " the " 'DINING-ROOM ".\"" CR>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID "]|">)>>
	<RETURN .SAID>>

<GLOBAL BUTLER-RANG-BELL?:FLAG <>>
<GLOBAL PLAYER-RANG-BELL?:FLAG <>>

<ROUTINE BUTLER-RINGS-BELL? ("OPT" (FAKE <>) "AUX" P)
	<COND (<OR <T? .FAKE>
		   <ZERO? ,BUTLER-RANG-BELL?>>
	       <SETG BUTLER-RANG-BELL? T>
	       <QUEUE I-DINNER 1>	;"in case someone's delayed"
	       <FSET ,CLUE-1 ,TAKEBIT>
	       <COND (<AND <ZERO? .FAKE>
			   <EQUAL? ,HERE ,KITCHEN>>
		      <TELL 'BUTLER>
		      <COND (<NOT <==? ,HERE <GET ,FOLLOW-LOC ,BUTLER-C>>>
			     <TELL " appears and">)>
		      <TELL " pushes a hidden button. ">)>
	       <TELL "Suddenly, the dinner bell sounds">
	       ;<COND (<FIRST? ,BELL>
		      <TELL ", but it doesn't ring true">
		      <COND (<SET P <FIND-FLAG-HERE-NOT ,PERSONBIT
							,MUNGBIT ,PLAYER>>
			     <TELL
". \"That's a bit odd,\" " D .P " comments">)>)>
	       <TELL "." CR>)>>

<ROUTINE BUTLER-LEAVES ("OPTIONAL" (GARG <>) "AUX" L (VAL <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[BUTLER-LEAVES:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND (<==? .GARG ,G-REACHED>
	       <SET VAL <BUTLER-RINGS-BELL?>>
	       <MOVE ,BUTLER ,LOCAL-GLOBALS>
	       <PUT ,FOLLOW-LOC ,BUTLER-C 0>
	       <COND (<EQUAL? ,HERE ,DINING-ROOM>
		      <QUEUE I-DINNER-SIT 1>)
		     (<EQUAL? ,HERE ,KITCHEN>
		      <TELL "Then he ">
		      <COND (<IN? ,MACE ,BUTLER>
			     <TELL "drops " A ,MACE ", ">)>
		      <TELL
"bids you good night, ducks into the areaway, locks the door
behind him, and leaves the castle." CR>
		      <SET VAL ,M-FATAL>)>
	       <COND (<IN? ,MACE ,BUTLER>
		      <FCLEAR ,MACE ,NDESCBIT>
		      <MOVE ,MACE ,KITCHEN>)>
	       .VAL)>>

<GLOBAL DINNER-SIT-COUNTER:NUMBER 0>
<GLOBAL DINNER-SAT:FLAG <>>

<ROUTINE I-DINNER-SIT ("OPTIONAL" (GARG <>) "AUX" (SAID <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-DINNER-SIT:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND (<T? ,DINNER-SAT>
	       <RFALSE>)
	      (<OR <FSET? ,DINNER ,TAKEBIT>
		   <L? 1 <- ,DINNER-FOR <POPULATION ,DINING-ROOM ,PLAYER>>>>
	       <COND (<L? ,DINNER-SIT-COUNTER 20>
		      <SETG DINNER-SIT-COUNTER <+ 1 ,DINNER-SIT-COUNTER>>
		      <COND (<AND <ZERO? <MOD ,DINNER-SIT-COUNTER 8>>
				  <NOT <EQUAL? ,HERE ,KITCHEN>>>
			     <BUTLER-RINGS-BELL? T>
			     <RTRUE>)>)>
	       <QUEUE I-DINNER-SIT 1>
	       <RFALSE>)>
	<SETG DINNER-SAT T>
	;<QUEUE I-DINNER-SIT 0>
	<QUEUE I-LIONEL-SPEAKS <- ,LIONEL-TIME ,PRESENT-TIME>>
	<MAKE-ALL-PEOPLE 10 ;"eating with relish" ,DINING-ROOM>
	<FSET ,DINNER ,TAKEBIT>
	<FCLEAR ,DINNER ,TRYTAKEBIT>
	<MOVE ,DINNER-2 ,TABLE-DINING>
	;<MOVE ,DINNER-3 ,TABLE-DINING>
	<BUTLER-RINGS-BELL?>
	<COND (<EQUAL? ,DINING-ROOM ,HERE>
	       <SET SAID ,M-FATAL>
	       <MOVE ,DINNER ,TABLE-DINING>
	       <TELL 'DEB " playfully suggests">
	       <COND (<==? ,VARIATION ,FRIEND-C>
		      <THIS-IS-IT ,LORD>
		      <TELL " to " 'LORD>)>
	       <TELL
" that everyone form a self-serve food line at the buffet.
" CHE ,LORD " and the others good-naturedly accept her suggestion." CR>
	       <COND (<IN? ,LETTER ,TABLE-DINING>
		      <TELL
"As " 'LORD " takes his place as host,
he notices a note lying on his napkin. He picks it up and reads it
with a troubled expression." CR>
		      ;<THIS-IS-IT ,LORD>)>
	       <DINNER-TALK 28>)
	      (T <SETG MISSED-DINNER T>)>
	<COND (<IN? ,LETTER ,TABLE-DINING>
	       <MOVE ,LETTER ,LORD>
	       <FCLEAR ,LETTER ,NDESCBIT>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	<RETURN .SAID>>

<GLOBAL MISSED-DINNER:FLAG <>>
<CONSTANT INIT-LIONEL-SPEAKS-COUNTER 6>
<GLOBAL LIONEL-SPEAKS-COUNTER:NUMBER 6>
<GLOBAL LIONEL-FORCED:FLAG <>>
<GLOBAL LIONELS-VOICE "Lionel's voice">

<ROUTINE I-LIONEL-SPEAKS ("OPTIONAL" (GARG <>) "AUX" (SAID <>) P)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-LIONEL-SPEAKS:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SETG LIONEL-SPEAKS-COUNTER <- ,LIONEL-SPEAKS-COUNTER 1>>
	<COND (<NOT <ZERO? ,LIONEL-SPEAKS-COUNTER>>
	       <QUEUE I-LIONEL-SPEAKS 2>)
	      (T
	       <QUEUE I-WITHDRAW 9>)>
	<SET P ,SEARCHER>
	<COND (<AND <T? .P>
		    <OR <NOT <IN? .P ,DINING-ROOM>>
			<NOT <IN? ,CLUE-1 ,SIDEBOARD>>
			<FSET? ,CLUE-1 ,TOUCHBIT>>>
	       <SET P <>>)>
	<COND (<==? 5 ,LIONEL-SPEAKS-COUNTER>
	       <MOVE ,VOICE ,DINING-ROOM>
	       <MAKE-ALL-PEOPLE 16 ;"listening" ,DINING-ROOM>)
	      (<==? 1 ,LIONEL-SPEAKS-COUNTER>
	       <FCLEAR ,CLUE-2 ,NDESCBIT>
	       <FCLEAR ,CLUE-2 ,SECRETBIT>
	       <FCLEAR ,CLUE-1 ,SECRETBIT>)
	      (<==? 0 ,LIONEL-SPEAKS-COUNTER>
	       <COND (<T? .P>
		      <FSET ,CLUE-1 ,TAKEBIT>
		      <FCLEAR ,CLUE-1 ,NDESCBIT>
		      <MOVE ,CLUE-1 .P>)>
	       <MOVE ,VOICE ,LOCAL-GLOBALS>
	       <MAKE-ALL-PEOPLE 18 ;"deep in thought" ,DINING-ROOM>)>
	<COND (<EQUAL? ,DINING-ROOM ,HERE>
	       <SET SAID ,M-FATAL>
	       <COND (<T? ,LIONEL-FORCED>
		      <SETG LIONEL-FORCED <>>)
		     (T <CRLF>)>
	       <COND (<==? 5 ,LIONEL-SPEAKS-COUNTER>
		      <THIS-IS-IT ,BUST>
		      <FSET ,BUST ,OPENBIT>
		      <TELL
D ,LORD " and his guests are startled as an unexpected voice suddenly speaks!|
\"Good evening, all,\" it says, then breaks into a low chuckle.|
\"Good Lord!\" Jack gasps. \"That's Uncle " ,LIONELS-VOICE "!\"|
" D ,DOCTOR " points to" THE ,BUST ". \"There's where it's coming
from!\"" CR>)
		     (<==? 4 ,LIONEL-SPEAKS-COUNTER>
		      <TELL
,LIONELS-VOICE " continues, \"You are all here, I trust, to honor the wish
expressed in my will -- that the seven of you should dine together
at " D ,CASTLE " on the evening of my birthday.\"" CR>)
		     (<==? 3 ,LIONEL-SPEAKS-COUNTER>
		      <THIS-IS-IT ,ARTIFACT>
		      <THIS-IS-IT ,LORD>
		      <TELL
,LIONELS-VOICE " continues, \"As you know, I enjoyed adventuring to
remote corners of the world. And doubtless you've all heard of the loss of that
valuable artifact, which I brought back from one of my
expeditions, have you not?\"|
The guests nod or mumble vaguely. They all glance toward Jack,
as if looking for an official response." CR>)
		     (<==? 2 ,LIONEL-SPEAKS-COUNTER>
		      <TELL ,LIONELS-VOICE " goes on, ">
		      <COND (<==? ,LORD-C ,VARIATION>
			     <THIS-IS-IT ,LORD>
			     <TELL
"\"Jack, I'm sure, is only too eager for me to shuffle off this mortal coil
so he can inherit the family title and estate. Thus he should be
particularly interested in what I'm about to say...\" Once again
" ,LIONELS-VOICE " chuckles slyly, then continues." CR>)>
		      <THIS-IS-IT ,PUNCHBOWL>
		      <TELL
"\"The truth is that the artifact is not lost, but hidden.
Although I am not yet ready to reveal what it is,
I suggest you look under the " 'PUNCHBOWL ".\"" CR>)
		     (<==? 1 ,LIONEL-SPEAKS-COUNTER>
		      <THIS-IS-IT ,CLUE-2>
		      <TELL
"\"This " 'CLUE-1 " is merely to sharpen your wits,\"
" ,LIONELS-VOICE " goes on.|
\"" 'LOVER ", my dear: your one goal in life, I believe, is to become
Jack's wife, heaven knows why! Not being Cupid, there is little I can do
to help. Knowing the others, I suspect each one has private reasons for
wanting my " 'ARTIFACT ". So, for your amusement, I have given a
" 'CLUE-2 " to my ">
		      <COND (<EQUAL? ,VARIATION ,LORD-C>
			     <TELL "dear friend">)
			    (T <TELL "heir">)>
		      <TELL
", which may start you down the path to finding it.\"|
With another sardonic chuckle, " ,LIONELS-VOICE " adds, \"Perhaps, ">
		      <COND (<EQUAL? ,VARIATION ,LORD-C>
			     <THIS-IS-IT ,PAINTER>
			     <TELL 'PAINTER>)
			    (T
			     <THIS-IS-IT ,LORD>
			     <TELL 'LORD>)>
		      <TELL ", you would
care to SHARE your clue with all the others -- eh, what?\"" CR>)
		     (<==? 0 ,LIONEL-SPEAKS-COUNTER>
		      <TELL
,LIONELS-VOICE " finishes, \"So now, my friends, let the game begin!\"" CR>
		      <COND (<T? .P>
			     <TELL
D .P " says, \"Well, I for one want to see that " 'CLUE-1 ".\" ">
			     <THIS-IS-IT .P>
			     <TELL
CHE .P " lifts the " 'PUNCHBOWL " and takes it." CR>)>)>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	<RETURN .SAID>>

<ROUTINE MAKE-ALL-PEOPLE (NUM "OPTIONAL" (RM 0) "AUX" P NNUM)
	<COND (<ZERO? .RM>
	       <SET RM ,HERE>)>
	<COND (<L? .NUM 0>
	       <SET NNUM <- 0 .NUM>>)>
	<SET P <FIRST? .RM>>
	<REPEAT ()
		<COND (<ZERO? .P>
		       <RETURN>)
		      (<FSET? .P ,PERSONBIT>
		       <COND (<G? .NUM 0>
			      <PUTP .P ,P?LDESC .NUM>)
			     (<==? .NNUM <GETP .P ,P?LDESC>>
			      <PUTP .P ,P?LDESC 0>)>)>
		<SET P <NEXT? .P>>>>

<ROUTINE I-WITHDRAW ("OPTIONAL" (GARG <>) "AUX" OBJ NXT (SAID <>))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-WITHDRAW:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND (<ZERO? ,TREASURE-FOUND>
	       <QUEUE I-SEARCH 9>
	       <PUT <GT-O ,SEARCHER> ,GOAL-FUNCTION ,X-SEARCHES>)>
	<QUEUE I-BEDTIME <- ,BED-TIME ,PRESENT-TIME>>
	<COND (<EQUAL? ,HERE ,DINING-ROOM ,CORR-1 ,SITTING-ROOM>
	       <SETG P-HIM-OBJECT <>>
	       <SETG P-HER-OBJECT <>>
	       <SET SAID T>
	       <TELL "|
Normally the gentlemen would remain at the table to enjoy
cigars and port, while the ladies repair to the " 'DRAWING-ROOM ". But because
of tonight's mysterious developments, everyone ">
	       <COND (<EQUAL? ,HERE ,DINING-ROOM>
		      <TELL "leaves the " 'DINING-ROOM>)
		     (T
		      <TELL "goes to the " 'SITTING-ROOM>)>
	       <TELL " by unspoken agreement." CR>)
	      (<OR <EQUAL? ,HERE ,JACK-ROOM ,TAMARA-ROOM ,IRIS-ROOM>
		   <EQUAL? ,HERE ,WENDISH-ROOM ,VIVIEN-ROOM ,IAN-ROOM>
		   <EQUAL? ,HERE ,HYDE-ROOM>>
	       <COND (<NOT <EQUAL? <LOC <GET ,CHARACTER-TABLE
					 <- <ZMEMQ ,HERE ,CHAR-ROOM-TABLE> 1>>>
				   ,HERE ,LOCAL-GLOBALS>>
		      <SETG DISCOVERED-HERE ,HERE>
		      <QUEUE I-DISCOVERED 1>)>)>
	<COND (<FSET? <LOC ,DINNER  > ,PERSONBIT>
	       <MOVE ,DINNER   ,TABLE-DINING>)>
	<COND (<FSET? <LOC ,DINNER-2> ,PERSONBIT>
	       <MOVE ,DINNER-2 ,TABLE-DINING>)>
	;<COND (<FSET? <LOC ,DINNER-3> ,PERSONBIT>
	       <MOVE ,DINNER-3 ,TABLE-DINING>)>
	<SET OBJ <FIRST? ,DINING-ROOM>>
	<SET NXT <NEXT? .OBJ>>
	<REPEAT ()
		<COND (<ZERO? .NXT>
		       <RETURN>)
		      (<FSET? .OBJ ,PERSONBIT>
		       <COND (<NOT <EQUAL? .OBJ ,PLAYER ,CONFESSED ,CAPTOR>>
			      <PUTP .OBJ ,P?LDESC 18 ;"deep in thought">
			      <PUT ,FOLLOW-LOC <GETP .OBJ ,P?CHARACTER>
				   ,SITTING-ROOM>
			      <MOVE .OBJ ,SITTING-ROOM>)>)>
		<SET OBJ .NXT>
		<SET NXT <NEXT? .OBJ>>>
	<COND (<EQUAL? ,HERE ,DINING-ROOM>
	       <SETG WINNER ,PLAYER>
	       <GOTO ,SITTING-ROOM ;,CORR-1>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	<RETURN .SAID>>

<GLOBAL SEARCHER:OBJECT 0>
<GLOBAL CLUE-LOC:OBJECT 0>

<GLOBAL SEARCH-ROOMS
   <PLTABLE
	OLD-GREAT-HALL BASEMENT ;DUNGEON STUDY LIBRARY OFFICE
	LUMBER-ROOM CHAPEL GAME-ROOM DECK COURTYARD MAZE GARDEN GALLERY
	FOYER DRAWING-ROOM GREAT-HALL SITTING-ROOM DINING-ROOM KITCHEN>>

<ROUTINE I-SEARCH ("OPTIONAL" (GARG <>)
		   "AUX" (SAID <>) GT L (X 0))
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-SEARCH:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SET L <LOC ,SEARCHER>>
	<COND (<OR <==? .L ,DISCOVERED-HERE>
		   <QUEUED? ,I-LIONEL-SPEAKS>>
	       <QUEUE I-SEARCH 3>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	       <RFALSE>)>
	<QUEUE I-SEARCH 19>
	<SET X <GET ,CHARACTER-TABLE <+ 1 <RANDOM 6>>>>
	<COND (<AND <IN? .X ,SITTING-ROOM>
		    <NOT <EQUAL? .X ,FOLLOWER ,CONFESSED ,CAPTOR>>
		    <NOT <==? <GETP .X ,P?LDESC> 22>>>
	       <PUTP .X ,P?LDESC 22 ;"playing the piano">
	       <COND (<==? ,HERE ,SITTING-ROOM>
		      <SET SAID T>
		      <THIS-IS-IT .X>
		      <TELL D .X " begins " <GET ,LDESC-STRINGS 22> ".">)>
	       <SET X <NEXT? .X>>
	       <COND (<AND <T? .X>
			   <FSET? .X ,PERSONBIT>
			   <NOT <==? .X ,PLAYER>>>
		      <COND (<AND <T? .SAID>
				  <==? <GETP .X ,P?LDESC>
				       22 ;"playing the piano">>
			     <THIS-IS-IT .X>
			     <TELL " And " D .X " stops.">)>
		      <PUTP .X ,P?LDESC 13 ;"lounging and chatting">)>
	       <COND (<T? .SAID> <CRLF>)>)>
	<SET X ,DEB-C>
	<REPEAT ()
		<SET GT <GET ,CHARACTER-TABLE .X>>
		<COND (<AND <NOT <EQUAL? .GT ,FOLLOWER>>
			    <NOT <EQUAL? <META-LOC .GT> ,HERE ,SITTING-ROOM>>
			    <NOT <IN-MOTION? .GT>>
			    <NOT <==? <GETP .GT ,P?LDESC>7;"sobbing quietly">>
			    <NOT <EQUAL? <GET <GET ,GOAL-TABLES .X>
					      ,GOAL-FUNCTION>
					 ,X-RETIRES ,X-SEARCHES>>>
		       <PUT <GET ,GOAL-TABLES .X> ,GOAL-FUNCTION ,NULL-F>
		       <ESTABLISH-GOAL .GT ,SITTING-ROOM>)>
		<COND (<DLESS? X 1> <RETURN>)>>
	<COND (<T? ,CONFESSED>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	       <RFALSE>)>
	<SET GT <GT-O ,SEARCHER>>
	<COND (<EQUAL? <GET .GT ,GOAL-FUNCTION> ,X-SEARCHES>
	       <REPEAT ()
		       <COND (<AND <SET X ,CLUE-LOC>
				   <ZMEMQ .X ,SEARCH-ROOMS>>
			      <SETG CLUE-LOC 0>)
			     (T <SET X <PICK-ONE ,SEARCH-ROOMS>>)>
		       <COND (<NOT <==? .X .L>>
			      <RETURN>)>>
	       <ESTABLISH-GOAL ,SEARCHER .X>
	       <COND (<EQUAL? ,HERE .L>
		      <SET SAID T>
		      <TELL "|
Suddenly" HE ,SEARCHER " heads for the ">
		      <COND (<EQUAL? ,HERE ,MAZE ,GARDEN>
			     <TELL "exit">)
			    (T <TELL "door">)>
		      <TELL ", mumbling, \"Please excuse me.\"" CR>)>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	<RETURN .SAID>>

<ROUTINE X-SEARCHES ("OPTIONAL" (GARG <>) "AUX" (VAL <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[X-SEARCHES:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<==? .GARG ,G-REACHED>
	<PUTP ,GOAL-PERSON ,P?LDESC 21 ;"searching">)>
 %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
 <RETURN .VAL>>

<ROUTINE I-DISCOVERED ("OPTIONAL" (GARG <>) "AUX" (VAL <>) L GT)
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[I-DISCOVERED:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<AND <EQUAL? ,DISCOVERED-HERE ,HERE>
	     <OR ;<ZERO? ,BUTLER-RANG-BELL?>	;"before dinner"
		 <ZERO? ,LIONEL-SPEAKS-COUNTER>	;"after dinner">>
	<SET L <- <ZMEMQ ,HERE ,CHAR-ROOM-TABLE> 1>>
	<SET VAL <GET ,CHARACTER-TABLE .L>>
	<COND (<ZERO? .GARG>
	       <COND (<IN? .VAL ,HERE>
		      <RFALSE>)
		     (<FSET? .VAL ,MUNGBIT>
		      <RFALSE>)
		     (<EQUAL? .VAL ,CONFESSED>
		      <RFALSE>)
		     (<EQUAL? <GET <GT-O .VAL> ,GOAL-FUNCTION> ,X-RETIRES>
		      <RFALSE>)>)>
	<PUT ,FOLLOW-LOC .L ,HERE>
	<QUEUE I-FOUND-IT 0>
	<COND (<EQUAL? .VAL ,GHOST-NEW>
	       <MOVE ,GHOST-NEW ,HERE>
	       <GHOST-LURKS>
	       <RFATAL>)>
	<TELL "You freeze as">
	<COND (T ;<NOT <EQUAL? .VAL ,GHOST-NEW>>
	       <COND (<FSET? ,HERE ,LOCKED>
		      <FCLEAR ,HERE ,LOCKED>
		      <TELL " a key turns in the lock,">)>
	       <TELL " the door bursts open and">)>
	<FCLEAR ,HERE ,OPENBIT>
	<PUTP .VAL ,P?LINE <+ 1 <GETP .VAL ,P?LINE>>>
	<PUTP .VAL ,P?LDESC 4 ;"looking at you with suspicion">
	<TELL HE .VAL " appears. ">
	<TELL CHE .VAL " stares at you with a shocked look. ">
	<COND ;(<EQUAL? ,HERE ,WENDISH-ROOM>
	       <TELL
"\"May I ask what you are doing here?\" he inquires gently.">)
	      ;(<EQUAL? ,HERE ,HYDE-ROOM>
	       <TELL
"\"To what do I owe the honor of this... shall we say, uninvited
visit?\" he inquires with a sarcastic smile.">)
	      ;(<EQUAL? ,HERE ,IAN-ROOM>
	       <TELL
"Then a mocking smile quirks the handsome young guardsman's lips.
\"Here now, what's all this then?\" he murmurs.">)
	      (T <TELL
"\"Well! I didn't expect MY room to be searched!\"" HE .VAL" says
angrily. ">)>
	<SET L <LOC .VAL>>
	<MOVE .VAL ,HERE>
	<SET GT <GT-O .VAL>>
	<COND (<ZERO? <GET .GT ,GOAL-S>>
	       <ESTABLISH-GOAL .VAL .L>)
	      (T
	       <ESTABLISH-GOAL .VAL <GET .GT ,GOAL-F>>)>
	<PUT .GT ,GOAL-ENABLE 0>
	<TELL
CHE .VAL " enters the room and closes the door behind" HIM .VAL ".|">
	<COND (<AND <IN? ,BLOWGUN .VAL>
		    <EQUAL? .VAL ,PAINTER ,DOCTOR>
		    <NOT <FIND-FLAG-HERE ,PERSONBIT ,PLAYER .VAL>>>
	       <SETUP-SHOT .VAL>
	       <TELL "Then" HE .VAL " pulls out" THE ,BLOWGUN "!" CR>)>
	<SET VAL ,M-FATAL>)>
 %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
 .VAL>

<ROUTINE I-FOUND-PASSAGES ("OPTIONAL" (GARG <>) "AUX" (SAID <>) X)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-FOUND-PASSAGES:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SET X <FIRST? ,HERE>>
	<COND (<T? .X>
	       <SET SAID <FOUND-PASSAGES-REPEAT .X ,PASSAGE ,FOUND-PASSAGES>>)>
	<COND (<AND <FSET? ,HERE ,SECRETBIT>
		    <SET X <FIND-FLAG-LG ,HERE ,DOORBIT>>
		    <SET X <DOOR-ROOM ,HERE .X>>>
	       <SET X <FIRST? .X>>
	       <COND (<AND <T? .X>
			   <FOUND-PASSAGES-REPEAT .X ,PASSAGE ,FOUND-PASSAGES>>
		      <SET SAID T>)>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .SAID !\] CR>)>>
	<RETURN .SAID>>

<ROUTINE FOUND-PASSAGES-REPEAT (PER OBJ GL "AUX" C (SAID <>))
 <REPEAT ()
	 <COND (<ZERO? .PER> <RETURN>)>
	 <COND (<AND <FSET? .PER ,PERSONBIT>
		     <NOT <FSET? .PER ,MUNGBIT>>>
		<PUTP .PER ,P?LDESC 3 ;"watching you">
		<SET C <GETP .PER ,P?CHARACTER>>
		<COND (<ZERO? <GET .GL .C>>
		       <PUT .GL .C T>
		       <COND (<NOT <==? .C ,VARIATION>>
			      <PUTP .PER ,P?LINE 0>
			      <COND (<ZERO? .SAID>
				     <SET SAID .PER>
				     <COND (<==? .OBJ ,PASSAGE>
					    <GOOD-SHOW .PER .OBJ>)>)>)>)>)>
	 <SET PER <NEXT? .PER>>>
 .SAID>

<ROUTINE I-BEDTIME ("OPTIONAL" (GARG <>) "AUX" N CH (VAL <>) L)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-BEDTIME:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SET N ,MASS-COUNTER>
	<COND (<IGRTR? N ,DEB-C>
	       <SETG MASS-SAID <>>
	       <SETG MASS-COUNTER 0>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
	       <RFALSE>)>
	<QUEUE I-BEDTIME 5>
	<SETG MASS-COUNTER .N>
	<SET CH <GET ,CHARACTER-TABLE .N>>
	<COND (<EQUAL? .CH ,SEARCHER>
	       <QUEUE I-SEARCH 0>)>
	<COND (<==? .CH ,CONFESSED ,CAPTOR>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
	       <RFALSE>)
	      (<FSET? .CH ,MUNGBIT>
	       %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
	       <RFALSE>)>
	<PUT <GET ,GOAL-TABLES .N> ,GOAL-FUNCTION ,X-RETIRES>
	<ESTABLISH-GOAL .CH <GET ,CHAR-ROOM-TABLE <+ 1 .N>>>
	<SET L <META-LOC .CH>>
	<COND (<AND <NOT <OUTSIDE? .L>>
		    <ZERO? <FIND-FLAG .L ,PERSONBIT .CH>>>
	       <FCLEAR .L ,ONBIT>)>
	<COND (<AND <EQUAL? .L ,HERE>
		    <OR <ZERO? ,MASS-SAID>
			<==? .CH ,FOLLOWER>>>
	       <SETG MASS-SAID T>
	       <SET VAL T>
	       <PUTP .CH ,P?LDESC 17 ;"preparing to leave">
	       <TELL
D .CH " says, \"It's time for bed now.
I'll see you in the morning.\"" CR>)>
	<COND (<==? .CH ,FOLLOWER>
	       <SETG FOLLOWER 0>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL "]|">)>>
	<RETURN .VAL>>

<GLOBAL FRIEND-FOUND-PASSAGES <>>
<ROUTINE FRIEND-PASSAGE-STORY ()
	<TELL "\"Guess what? I just
discovered a " 'PASSAGE " in my room! But it's so late that I'm going
to bed now. We'll explore in the morning.\"" CR>>

<ROUTINE X-RETIRES ("OPTIONAL" (GARG <>)
		    "AUX" (L <LOC ,GOAL-PERSON>) RM C (VAL <>) OBJ GT)
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[X-RETIRES:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<EQUAL? ,GOAL-PERSON ,CONFESSED ,CAPTOR>
	<RFALSE>)
       (<==? .GARG ,G-IMPATIENT>
	<COND (<EQUAL? .L ,HERE>
	       <SET VAL T>
	       <TELL
CHE ,GOAL-PERSON " says, \"I'm dead tired. Good night.\"" CR>)>)
       (<==? .GARG ,G-REACHED>
	<SET C <GETP ,GOAL-PERSON ,P?CHARACTER>>
	<SET RM <GET ,CHAR-ROOM-TABLE <+ 1 .C>>>
	<SET GT <GET ,GOAL-TABLES .C>>
	<COND (<NOT <==? .L .RM>>	;"unmasked ghost is quitting"
	       <COND (<NOT <FSET? .L ,SECRETBIT>> ;"or you entered a bedroom"
		      <ESTABLISH-GOAL ,GOAL-PERSON .RM>
		      <RFALSE>)>
	       <SET OBJ <FIND-FLAG-LG .L ,DOORBIT>>
	       <COND (<T? .OBJ>
		      <FSET .OBJ ,OPENBIT>)>
	       <SET VAL <MOVE-PERSON ,GOAL-PERSON .RM>>
	       <COND (<T? .OBJ>
		      <FCLEAR .OBJ ,OPENBIT>)>)>
	;<COND (<AND <QUEUED? ,I-DISCOVERED>
		    <EQUAL? ,DISCOVERED-HERE ,HERE>
		    <EQUAL? ,DISCOVERED-HERE .RM>>
	       <QUEUE I-DISCOVERED 0>
	       <RETURN <I-DISCOVERED ,G-REACHED>>)>
	<SET OBJ <FIND-FLAG .RM ,SURFACEBIT>>
	<COND (<T? .OBJ>
	       <ROB ,GOAL-PERSON .OBJ>)
	      (T <ROB ,GOAL-PERSON .RM>)>
	<FCLEAR .RM ,OPENBIT>
	<FSET .RM ,LOCKED>
	<COND (<EQUAL? ,VARIATION ,LORD-C>
	       <SET RM ,LIMBO>)>
	<COND (<AND <EQUAL? ,GOAL-PERSON ,FRIEND>
		    <NOT <EQUAL? ,VARIATION ,FRIEND-C>>
		    <ZERO? <GET ,FOUND-PASSAGES ,PLAYER-C>>
		    <ZERO? ,FRIEND-FOUND-PASSAGES>
		    <T? <GETP ,HERE ,P?LINE>>
		    <T? ,NOW-WEARING>
		    <NOT <FSET? ,HERE ,SECRETBIT>>
		    <NOT <1? <GETP ,HERE ,P?CHARACTER>>>	;"Dee's path"
		    <NOT <EQUAL? ,HERE ,BACKSTAIRS>>>
	       <FCLEAR ,SECRET-TAMARA-DOOR ,SECRETBIT>
	       <SET VAL T ;,M-FATAL>
	       <COND (<NOT <VERB? SEARCH SEARCH-FOR>>
		      <CRLF>)>
	       <COND (<EQUAL? ,HERE ,TAMARA-ROOM>
		      <PUT .GT ,ATTENTION <GET .GT ,ATTENTION-SPAN>>
		      <SETG WINNER ,FRIEND>
		      <COND (<==? ,HERE <GET ,FOLLOW-LOC ,FRIEND-C>>
			     <TELL "Preparing for bed," 'FRIEND>)
			    (T <TELL 'FRIEND " enters and">)>
		      <TELL " accidentally touches the bedpost. ">
		      <THIS-IS-IT ,FRIEND>
		      <OPEN-SECRET "turn" " the bedpost" ,SECRET-TAMARA-DOOR>
		      <SETG WINNER ,PLAYER>)
		     (<NOT <QUEUED? ,I-SHOT>>
		      <FSET ,PASSAGE ,SEENBIT>
		      <FSET ,SECRET-TAMARA-DOOR ,OPENBIT>
		      <MOVE ,FRIEND ,HERE>
		      <PUT ,FOLLOW-LOC ,FRIEND-C ,HERE>
		      <PUT .GT ,GOAL-FUNCTION ,X-RETIRES>
		      <ESTABLISH-GOAL ,FRIEND ,TAMARA-ROOM>
		      <TELL "Suddenly " 'FRIEND " appears and says, ">
		      <FRIEND-PASSAGE-STORY>)>)
	      (<TIME-FOR-GHOST? .RM>
	       <QUEUE I-SEARCH 0>
	       <COND (<==? ,VILLAIN-PER ,LOVER>
		      <PUTP ,DEB ,P?LDESC 24 ;"brushing her hair">
		      <PUT .GT ,ATTENTION <GET .GT ,ATTENTION-SPAN>>
		      <DRESS-GHOST <LOC ,LOVER> ,LOVER-C>
		      <PUT <GET ,GOAL-TABLES ,GHOST-NEW-C>
			   ,GOAL-FUNCTION ,LOVER-XFER>
		      <ESTABLISH-GOAL ,GHOST-NEW ,BASEMENT>
		      <SET VAL <MOVE-PERSON ,GHOST-NEW ,LOVER-PATH>>)
		     (T 
		      <DRESS-GHOST .RM .C>
		      <SET VAL <GHOST-INTO-PASSAGE .C>>
		      <ESTABLISH-GOAL ,GHOST-NEW ,YOUR-CLOSET>)>)
	      (T
	       <COND (<FSET? ,GOAL-PERSON ,FEMALE>
		      <PUTP ,GOAL-PERSON ,P?LDESC 24 ;"brushing her hair">)
		     (T
		      <PUTP ,GOAL-PERSON ,P?LDESC 25 ;"looking sleepy">)>
	       <PUT .GT ,ATTENTION-SPAN 5>
	       <PUT .GT ,ATTENTION 5>)>
	<SETG FRIEND-FOUND-PASSAGES T>)>
 %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
 <RETURN .VAL>>

<ROUTINE GHOST-INTO-PASSAGE (C "AUX" RM)
	<SET RM <GET ,CHAR-CLOSET-TABLE <+ 1 .C>>>
	<MOVE ,GHOST-NEW .RM>
	<COND (<EQUAL? .RM ,HERE>
	       <SET RM <FIND-FLAG-LG .RM ,DOORBIT ,SECRETBIT>>
	       <FSET .RM ,OPENBIT>
	       <TELL CR CTHE .RM " bursts open!|">
	       <RETURN ,M-FATAL>)>>

<ROUTINE TIME-FOR-GHOST? (RM "AUX" X)
 <COND (<EQUAL? ,VILLAIN-PER ,LOVER>
	<COND (<NOT <EQUAL? ,GOAL-PERSON ,DEB>>
	       <RFALSE>)>)
       (T
	<COND (<NOT <EQUAL? ,GOAL-PERSON ,VILLAIN-PER>>
	       <RFALSE>)>)>
 <COND (<IN? ,VILLAIN-PER ,LOCAL-GLOBALS>
	<RFALSE>)
       (<EQUAL? ,GOAL-PERSON ,FRIEND>
	<RFALSE>)
       (<T? <GET ,FOUND-COSTUME ,PLAYER-C>>
	<RFALSE>)
       (<FSET? ,BLOWGUN ,TOUCHBIT>
	<RFALSE>)
       (<AND <SET X <FIND-FLAG-LG .RM ,DOORBIT ,SECRETBIT>>
	     <FSET? .X ,OPENBIT>>
	<RFALSE>)
       (<T? <FIND-FLAG .RM ,PERSONBIT ,VILLAIN-PER>>
	<RFALSE>)
       (T <RTRUE>)>>

<ROUTINE DRESS-GHOST (L C "AUX" ADJ PT)
	<MOVE ,GHOST-NEW .L>
	<MOVE ,VILLAIN-PER ,LOCAL-GLOBALS>
	<PUT ,CHAR-CLOSET-TABLE <+ 1 ,GHOST-NEW-C>
	     <GET ,CHAR-CLOSET-TABLE <+ 1 .C>>>
	<COND (<SET ADJ <GETP ,VILLAIN-PER ,P?STATION>>
	       <SET PT <GETPT ,HEAD ,P?ADJECTIVE>>
	       <COND (<SETG OTHER-POSS-POS <ZMEMQB .ADJ .PT <RMGL-SIZE .PT>>>
		      <PUTB .PT
			    ,OTHER-POSS-POS ,A?G\'S>
		      <PUTB <GETPT ,HANDS ,P?ADJECTIVE>
			    ,OTHER-POSS-POS ,A?G\'S>
		      <PUTB <GETPT ,EYE ,P?ADJECTIVE>
			    ,OTHER-POSS-POS ,A?G\'S>
		      <PUTB <GETPT ,OTHER-OUTFIT ,P?ADJECTIVE>
			    ,OTHER-POSS-POS ,A?G\'S>)>)>
	<FSET ,COSTUME ,NDESCBIT>
	<FCLEAR ,COSTUME ,TAKEBIT>
	<FSET ,COSTUME ,WORNBIT>
	<MOVE ,COSTUME ,GHOST-NEW>
	<COND (<==? .C ,DOCTOR-C>
	       <MOVE ,MUSTACHE ,WENDISH-KIT>
	       <FCLEAR ,MUSTACHE ,NDESCBIT>
	       <FSET ,MUSTACHE ,TAKEBIT>)>
	<COND (<NOT <EQUAL? ,VARIATION ,LORD-C>>	;"Dee is nonviolent."
	       <FSET ,BLOWGUN ,NDESCBIT>
	       <FCLEAR ,BLOWGUN ,TAKEBIT>
	       <MOVE ,BLOWGUN ,GHOST-NEW>)>
	<PUT <GET ,GOAL-TABLES .C> ,GOAL-FUNCTION ,GHOST-LURKS>
	<PUT <GET ,GOAL-TABLES .C> ,ATTENTION-SPAN 0 ;1>>

<ROUTINE LOVER-XFER ("OPTIONAL" (GARG <>)
		     "AUX" (VAL <>) (L <LOC ,GOAL-PERSON>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[LOVER-XFER:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<==? .GARG ,G-ENROUTE>
	<SET VAL <GHOST-LURKS .GARG>>)
       (<==? .GARG ,G-REACHED>
	<COND (<EQUAL? .L ,HERE>
	       <SET VAL <GHOST-LURKS .GARG>>)
	      (<EQUAL? .L ,BASEMENT>
	       <MOVE ,GOAL-PERSON ,KITCHEN>
	       <ESTABLISH-GOAL ,GOAL-PERSON ,BACKSTAIRS>
	       <SET VAL <GHOST-LURKS ,G-ENROUTE>>)
	      (<EQUAL? .L ,BACKSTAIRS>
	       <MOVE ,GOAL-PERSON ,DINING-PASSAGE>
	       <ESTABLISH-GOAL ,GOAL-PERSON ,YOUR-CLOSET>
	       <PUT <GT-O ,GOAL-PERSON> ,GOAL-FUNCTION ,GHOST-LURKS>
	       <SET VAL <GHOST-LURKS ,G-ENROUTE>>)>)>
 %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
 <RETURN .VAL>>

<ROUTINE I-COME-TO ("OPTIONAL" (GARG <>) "AUX" P (L <>) V)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[I-COME-TO:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<COND (<IN? ,GHOST-NEW ,LOCAL-GLOBALS>
	       <SET P ,VILLAIN-PER>
	       <PUTP .P ,P?LDESC 4 ;"looking at you with suspicion">
	       <COND (<NOT <==? .P ,LOVER>>
		      <PUT <GT-O .P> ,GOAL-FUNCTION ,X-RETIRES>
		      <SET L <+ 1 <GETP .P ,P?CHARACTER>>>
		      <COND (<FSET? <META-LOC .P> ,SECRETBIT>
			     <SET L <GET ,CHAR-CLOSET-TABLE .L>>)
			    (T <SET L <GET ,CHAR-ROOM-TABLE .L>>)>)>)
	      (T
	       <SET P ,GHOST-NEW>
	       <PUTP .P ,P?LDESC 0>
	       <FSET .P ,NDESCBIT>
	       <PUT <GT-O .P> ,GOAL-FUNCTION ,GHOST-LURKS>
	       <SET L ,YOUR-CLOSET>
	       <COND (<NOT <FSET? <LOC .P> ,SECRETBIT>>
		     <GHOST-INTO-PASSAGE <GETP ,VILLAIN-PER ,P?CHARACTER>>)>)>
	<FCLEAR .P ,MUNGBIT>
	<SET V <VISIBLE? .P>>
	<COND (<T? .V>
	       <TELL CTHE .P>
	       <COND (<WHERE? .P> <TELL !\,>)>
	       <TELL " shakes" HIS .P " head and comes to." CR>
	       <COND (<AND <EQUAL? ,VILLAIN-PER ,LOVER>
			   <LOVER-SPEECH>>
		      <SET V ,M-FATAL>)
		     (<NOT <==? .P ,GHOST-NEW>>
		      <SET V ,M-FATAL>
		      <TELL
CHE .P " says, \"I feel... sleepy. I think...\"" CR>)>)>
	<COND (<T? .L>
	       <PUT <GT-O .P> ,GOAL-S T>
	       <ESTABLISH-GOAL .P .L>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .V !\] CR>)>>
	.V>

<ROUTINE LOVER-SPEECH ()
	<COND (<IN? ,GHOST-NEW ,HERE>
	       <SETG LOVER-SAID T>
	       <TELL
CHE ,GHOST-NEW " says, \"Please don't speak, just listen! I'm really
" 'LOVER ", and I'm alive. Jack tried to murder me, and I think he murdered
Lionel! He pushed me down the well, but an underground stream carried me
quickly to sea, where I was rescued by a yacht.|
I have come back to " 'CASTLE " in disguise -- both to frighten him and
to find some proof of Lionel's murder. And to incriminate " 'LORD " for
my own 'murder' by planting the " 'JEWEL " from my necklace in the
clothes he wore that night -- but then I lost it in the " 'DRAWING-ROOM
".\"|
She goes on, \"But now that you're on the case, I can leave the country
with the yacht captain. Find proof of Lionel's murder, and we both can
rest easily!\"|
She races off ">
	       <GHOST-FLEES T>
	       <CONGRATS ,COSTUME>
	       <FSET ,LOVER ,SEENBIT>)>
	<MOVE ,GHOST-NEW ,LIMBO>
	<FSET ,GHOST-NEW ,MUNGBIT>
	<PUT ,FOLLOW-LOC ,GHOST-NEW-C 0>
	,LOVER-SAID>

<ROUTINE GHOST-FLEES ("OPT" (PART <>))
	<COND (<ZERO? .PART>
	       <MOVE ,GHOST-NEW ,LIMBO>
	       <FSET ,GHOST-NEW ,MUNGBIT>
	       <PUT ,FOLLOW-LOC ,GHOST-NEW-C 0>
	       <TELL CHE ,GHOST-NEW " dodges your attack and flees ">)>
	<COND (<==? ,HERE ,LOVER-PATH>
	       <TELL "down the path">)
	      (T <TELL "toward the " 'PRIEST-DOOR>)>
	<TELL "." CR>>

;<ROUTINE NEXT-ROOM (RM DIR "AUX" PT PTS)
	 <COND (<SET PT <GETPT .RM .DIR>>
		<COND (<==? <SET PTS <PTSIZE .PT>> ,UEXIT>
		       <GET-REXIT-ROOM .PT>)
		      (<==? .PTS ,NEXIT>
		       <RFALSE>)
		      (<==? .PTS ,FEXIT>
		       <APPLY <GET .PT ,FEXITFCN>>)
		      (<==? .PTS ,CEXIT>
		       <COND (<VALUE <GETB .PT ,CEXITFLAG>>
			      <GET-REXIT-ROOM .PT>)>)
		      (<==? .PTS ,DEXIT>
		       <COND (T ;<FSET? <GET-DOOR-OBJ .PT> ,OPENBIT>
			      <GET-REXIT-ROOM .PT>)>)>)>>

<GLOBAL SHOOTER:OBJECT 0>
<GLOBAL AIMED-HERE:OBJECT 0>

;<GLOBAL TRIPPEE:OBJECT 0>
;<ROUTINE FIND-TRIPPEE (RM "AUX" O)
	<SET O <FIRST? .RM>>
	<REPEAT ()
	 <COND (<ZERO? .O> <RETURN <>>)
	       (<AND <FSET? .O ,TAKEBIT>
		     <L? 3 <GETP .O ,P?SIZE>>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <==? .O ,TRIPPEE>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE GHOST-LURKS ("OPTIONAL" (GARG <>)
		      "AUX" L OBJ (VAL <>) GT C)
	%<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
			    <TELL "[GHOST-LURKS:">
			    <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	<SET L <LOC ,GHOST-NEW>>
	<SET C ,GHOST-NEW-C>
	<SET GT <GET ,GOAL-TABLES .C>>
	<COND ;(<AND <EQUAL? .GARG ,G-ENROUTE ,G-REACHED>
		    <SET OBJ <FIND-TRIPPEE .L>>>
	       <SETG TRIPPEE .OBJ>
	       <SETG SHOOTER <>>
	       <QUEUE I-SHOT 0>
	       <FCLEAR ,GHOST-NEW ,NDESCBIT>
	       <PUTP ,GOAL-PERSON ,P?LDESC 19 ;"out cold">
	       <QUEUE I-COME-TO <+ 9 <RANDOM 6>>>
	       <COND (<EQUAL? .L ,HERE>
		      <COND (<NOT <FSET? ,GHOST-NEW ,TOUCHBIT>>
			     <GHOST-NEW-D>)>
		      <SET VAL ,M-FATAL>
		      <TELL
CHE ,GOAL-PERSON " trips over" THE .OBJ " and falls heavily "
<GROUND-DESC> "!" CR>)>
	       <FSET ,GOAL-PERSON ,MUNGBIT>)
	      (<EQUAL? .L ,HERE>
	       <COND (<NOT <FSET? ,GHOST-NEW ,TOUCHBIT>>
		      <GHOST-NEW-D>)>
	       <SET VAL ,M-FATAL>
	       <SETG AIMED-HERE ,HERE>
	       <TELL "The ghost ">
	       <COND (<QUEUED? ,I-SHOT>
		      <TELL "follows">)
		     (T <TELL "approaches">)>
	       <THIS-IS-IT ,GHOST-NEW>
	       <TELL
" you," HIS ,GHOST-NEW " cold eyes shining. In a moment," HE ,GHOST-NEW>
	       <COND ;(<EQUAL? ,VILLAIN-PER ,LOVER>
		      <MOVE ,GHOST-NEW ,LIMBO>
		      <FSET ,GHOST-NEW ,MUNGBIT>
		      <PUT ,FOLLOW-LOC .C 0>
		      <TELL " slips away." CR>)
		     (T ;<NOT <QUEUED? ,I-SHOT>>
		      <PUT .GT ,GOAL-ENABLE 0>
		      <FSET ,PLAYER ,SEENBIT>
		      <SETG SHOOTER ,GHOST-NEW>
		      <QUEUE I-SHOT ,CLOCKER-RUNNING>
		      <COND (<EQUAL? ,VILLAIN-PER ,LOVER>
			     <PUTP ,GHOST-NEW,P?LDESC 17;"preparing to leave">
			     <TELL " sees you and freezes." CR>)
			    (T
			     <PUTP ,GHOST-NEW ,P?LDESC 8 ;"poised to attack">
			     <TELL " poi">
			     <COND (<IN? ,BLOWGUN ,GHOST-NEW>
				    <SETG AIMED-HERE ,HERE>
				    <FCLEAR ,BLOWGUN ,NDESCBIT>
				    <TELL "nts" THE ,BLOWGUN " at">)
				   (T <TELL "ses to attack">)>
			     <TELL " you." CR>)>)>)
	      (<==? .GARG ,G-REACHED>
	       <COND (<NOT <EQUAL? .L ,YOUR-CLOSET>>
		      <ESTABLISH-GOAL ,GHOST-NEW ,YOUR-CLOSET>)
		     (T
		      <ESTABLISH-GOAL ,GHOST-NEW
				      <GET ,CHAR-CLOSET-TABLE <+ 1 .C>>>)>)>
	%<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL "]|">)>>
	<RETURN .VAL>>

<ROUTINE I-SHOT ("OPTIONAL" (GARG <>) "AUX" (VAL <>) L (GT <GT-O ,SHOOTER>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[I-SHOT:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <COND (<EQUAL? ,VILLAIN-PER ,LOVER>
	<COND (<IN? ,GHOST-NEW ,HERE>
	       <SET VAL T>
	       <TELL CHE ,GHOST-NEW " flees into the dark." CR>)>
	<MOVE ,GHOST-NEW ,LIMBO>
	<FSET ,GHOST-NEW ,MUNGBIT>
	<PUT ,FOLLOW-LOC ,GHOST-NEW-C 0>)
       (<EQUAL? ,AIMED-HERE ,HERE>
	<COND (<NOT <IN? ,BLOWGUN ,SHOOTER>>
	       <TELL
"You struggle to get free, but"
THE ,SHOOTER "'s hands clench tighter around your throat! Soon
the pain grows until the room begins to black out">
	       <COND (<==? ,SHOOTER ,GHOST-NEW>
		      <TELL
". Your only consolation is that the ghost's wig falls off, and just as
you take your last breath, you see
that it's really " D ,VILLAIN-PER>)>
	       <TELL "! But">)
	      (T
	       <COND (<FSET? ,HERE ,ONBIT>
		      <TELL
CHE ,SHOOTER " puts" THE ,BLOWGUN " to" HIS ,SHOOTER " lips and puffs"
HIS ,SHOOTER " cheeks out and in. ">)>
	       <TELL
"You feel a sharp pain in the chest. Your vision
mists over, the room blacks out, and your legs give way beneath you.|
The sad fact is, "FN", that you've been shot with a" ,POISON-DART ", and">)>
	<TELL " for you, the game is over!|">
	<FINISH>)
       (<AND <T? ,SHOOTER>
	     <NOT <FSET? ,SHOOTER ,MUNGBIT>>>
	<PUT .GT ,GOAL-ENABLE 2>
	<COND (<FSET? ,HERE ,SECRETBIT>
	       <SET L ,HERE>)
	      (<EQUAL? ,SHOOTER ,GHOST-NEW>
	       <SET L <GET .GT ,GOAL-F>>)
	      (<ZERO? <SET L <GENERIC-CLOSET 0>>>
	       <SET L <GET ,CHAR-CLOSET-TABLE
			   <+ 1 <GETP ,VILLAIN-PER ,P?CHARACTER>>>>)>
	<PUT .GT ,GOAL-S .L>	;"in case GOAL-REACHED called"
	<ESTABLISH-GOAL ,SHOOTER .L>
	<SETG SHOOTER <>>
	<FSET ,BLOWGUN ,NDESCBIT>)>
 %<DEBUG-CODE <COND (,IDEBUG <TELL N .VAL !\] CR>)>>
 .VAL>
