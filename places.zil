"PLACES for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

"The usual globals"

<OBJECT ROOMS
	(DESC "that")
	(FLAGS NARTICLEBIT)>

<ROUTINE NULL-F ("OPTIONAL" A1 A2)
	<RFALSE>>

<ROUTINE DOOR-ROOM (RM DR "AUX" (P 0) TBL)
	 ;<COND (<==? .RM ,CAR>
		<SET RM <GETP ,CAR ,P?STATION>>)>
	 <REPEAT ()
		 <COND (<OR <0? <SET P <NEXTP .RM .P>>>
			    <L? .P ,LOW-DIRECTION>>
			<RFALSE>)
		       (<AND <==? ,DEXIT <PTSIZE <SET TBL <GETPT .RM .P>>>>
			     <==? .DR <GET-DOOR-OBJ .TBL>>>
			<RETURN <GET-REXIT-ROOM .TBL>>)>>>

;<ROUTINE DOOR-DIR (RM DR "AUX" (P 0) TBL)
	 <REPEAT ()
		 <COND (<OR <0? <SET P <NEXTP .RM .P>>>
			    <L? .P ,LOW-DIRECTION>>
			<RFALSE>)
		       (<AND <==? ,DEXIT <PTSIZE <SET TBL <GETPT .RM .P>>>>
			     <==? .DR <GET-DOOR-OBJ .TBL>>
			     <OR <EQUAL? .P ,P?NORTH ,P?EAST>
				 <EQUAL? .P ,P?SOUTH ,P?WEST>>>
			<RETURN .P>)>>>

<ROUTINE FIND-FLAG (RM FLAG "OPTIONAL" (EXCLUDED <>) "AUX" O)
	<SET O <FIRST? .RM>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <==? .O .EXCLUDED>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-NOT (RM FLAG ;"OPTIONAL" ;(EXCLUDED <>) "AUX" O)
	<SET O <FIRST? .RM>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <NOT <FSET? .O .FLAG>>
		     <NOT <FSET? .O ,INVISIBLE>>
		     ;<NOT <==? .O .EXCLUDED>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-LG (RM FLAG "OPTIONAL" (FLAG2 0) "AUX" TBL O (CNT 0) SIZE)
	 <COND (<SET TBL <GETPT .RM ,P?GLOBAL>>
		<SET SIZE <RMGL-SIZE .TBL>>
		<REPEAT ()
			<SET O <GET/B .TBL .CNT>>
			<COND (<AND <FSET? .O .FLAG>
				    <NOT <FSET? .O ,INVISIBLE>>
				    <OR <0? .FLAG2> <FSET? .O .FLAG2>>>
			       <RETURN .O>)
			      (<IGRTR? CNT .SIZE> <RFALSE>)>>)>>

<ROUTINE FIND-FLAG-HERE (FLAG "OPTIONAL" (NOT1 <>) (NOT2 <>) "AUX" O)
	<SET O <FIRST? ,HERE>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <EQUAL? .O .NOT1 .NOT2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

;<ROUTINE FIND-FLAG-HERE-BOTH (FLAG FLAG2 "OPTIONAL" (NOT2 <>) "AUX" O)
	<SET O <FIRST? ,HERE>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <FSET? .O .FLAG2>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <EQUAL? .O .NOT2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<ROUTINE FIND-FLAG-HERE-NOT (FLAG NFLAG "OPTIONAL" (NOT2 <>) "AUX" O)
	<SET O <FIRST? ,HERE>>
	<REPEAT ()
	 <COND (<NOT .O> <RETURN <>>)
	       (<AND <FSET? .O .FLAG>
		     <NOT <FSET? .O .NFLAG>>
		     <NOT <FSET? .O ,INVISIBLE>>
		     <NOT <EQUAL? .O .NOT2>>>
		<RETURN .O>)
	       (T <SET O <NEXT? .O>>)>>>

<OBJECT LEVER
	(IN LOCAL-GLOBALS)
	(DESC "lever")
	(SYNONYM LEVER HANDLE)
	(FLAGS TRYTAKEBIT SEENBIT)
	(ACTION LEVER-F)>

<ROUTINE LEVER-F ("AUX" (X <>))
	<COND (<FSET? ,HERE ,SECRETBIT>
	       <SET X <FIND-FLAG-LG ,HERE ,DOORBIT>>)
	      (<EQUAL? ,HERE ,DUNGEON ,LOVER-PATH>
	       <SET X ,PRIEST-DOOR>)>
	<COND (<ZERO? .X>
	       <NOT-HERE ,LEVER>
	       <RTRUE>)
	      (<VERB? MOVE MOVE-DIR PUSH RUB TAKE TURN>
	       <FSET .X ,TOUCHBIT ;,SEENBIT>
	       <OPEN-CLOSE .X>)
	      (<VERB? OPEN>
	       <FSET .X ,TOUCHBIT ;,SEENBIT>
	       <OKAY .X "open">
	       <RTRUE>)
	      (<VERB? CLOSE>
	       <FSET .X ,TOUCHBIT ;,SEENBIT>
	       <OKAY .X "closed">
	       <RTRUE>)>>

<ROUTINE OPEN-CLOSE (DR "OPTIONAL" (SAY-NAME T) X)
	<COND (.SAY-NAME
	       <TELL CTHE .DR>)>
	<TELL " creaks ">
	<COND (<FSET? .DR ,OPENBIT>
	       <FCLEAR .DR ,OPENBIT>
	       <THIS-IS-IT .DR>
	       <TELL "closed.|">
	       <REMOVE-CAREFULLY>
	       <RTRUE>)
	      (<SET X <DOOR-ROOM ,HERE .DR>>
	       <FSET .DR ,OPENBIT>
	       <THIS-IS-IT .X>
	       <TELL "open, revealing">
	       <COND (<FSET? ,HERE ,SECRETBIT>
		      <TELL THE .X>)
		     (<==? ,HERE ,LOVER-PATH>
		      <TELL THE ,DUNGEON>)
		     (T
		      <TELL " a " D ,PASSAGE>
		      ;<PRINTB <GET <GETPT .X ,P?SYNONYM> 0>>)>
	       <FSET .DR ,SEENBIT>
	       <FSET .X ,SEENBIT>
	       <TELL "!" CR>)>>

<ROUTINE OUTSIDE? (RM) <GLOBAL-IN? ,MOON .RM>>

;<OBJECT CAR-WINDOW
	(IN CAR ;LOCAL-GLOBALS)
	(DESC "car window")
	(ADJECTIVE CAR)
	(SYNONYM WINDOW WINDSHIELD WINDSCREEN DOOR)
	(GENERIC GENERIC-WINDOW)
	(FLAGS SEENBIT NDESCBIT)
	(ACTION WINDOW-F)>

<OBJECT WINDOW
	(IN LOCAL-GLOBALS)
	(DESC ;"room " "window")
	;(ADJECTIVE ROOM)
	(SYNONYM WINDOW WINDSHIELD WINDSCREEN DOOR)
	;(GENERIC GENERIC-WINDOW)
	(FLAGS SEENBIT NDESCBIT)
	(ACTION WINDOW-F)>

<ROUTINE WINDOW-F ()
 <COND (<VERB? OPEN CLOSE LOCK UNLOCK>
	<COND (<OR <EQUAL? ,HERE ,DRIVEWAY>
		   <EQUAL? <LOC ,PLAYER> ,CAR>>
	       ;<DOBJ? CAR-WINDOW>
	       <NO-NEED ;"do that">
	       ;<CAR-DOOR-PSEUDO>
	       <RTRUE>)
	      (<VERB? OPEN>
	       <TELL "The night air is too damp and chilly." CR>)
	      (T ;<VERB? CLOSE>
	       <ALREADY ,WINDOW "closed">
	       <RTRUE>)>)
       (<VERB? DISEMBARK ;"CLIMB OUT" LEAVE THROUGH>
	<TELL "It's closed tight against the mist." CR>)
       (<VERB? LOOK-INSIDE LOOK-THROUGH LOOK-OUTSIDE>
	<COND (<EQUAL? <LOC ,WINNER> ,CAR>
	       <V-LOOK>
	       ;<ROOM-PEEK <GETP ,CAR ,P?STATION> T>)
	      (T <TELL
"All you can see are grey shapes in the moonlight." CR>)>)>>

"Other stuff"

<GLOBAL COR-1 <PTABLE P?EAST P?WEST	CORR-1 JUNCTION 0>>
<GLOBAL COR-2 <PTABLE P?NORTH P?SOUTH	GALLERY-CORNER GALLERY 0>>
<GLOBAL COR-4 <PTABLE P?UP P?DOWN	LUMBER-ROOM TAMARA-ROOM 0>>

<ROUTINE CORRIDOR-LOOK ("OPTIONAL" (ITM <>) ;(GRAB <>)
			"AUX" C Z COR VAL (FOUND <>))
  <COND ;(<EQUAL? .ITM ,PLAYER>
	 <RFALSE>)
        (<T? <SET C <GETP ,HERE ,P?CORRIDOR>>>
	 <COND ;(<L? .C 0>
		<CORRIDOR-CHECK <> .ITM .GRAB>)
	       (T
		<REPEAT ()
			<COND (<NOT <L? <SET Z <- .C 4>> 0>>
			       <SET COR ,COR-4>)
			      (<NOT <L? <SET Z <- .C 2>> 0>>
			       <SET COR ,COR-2>)
			      (<NOT <L? <SET Z <- .C 1>> 0>>
			       <SET COR ,COR-1>)
			      (T <RETURN>)>
			<SET VAL <CORRIDOR-CHECK .COR .ITM ;.GRAB>>
			<COND (<NOT .FOUND> <SET FOUND .VAL>)>
			<SET C .Z>>
		.FOUND)>)>>

<ROUTINE CORRIDOR-CHECK (COR ITM "AUX" (CNT 1) (PAST 0) (FOUND <>) RM OBJ)
 <REPEAT ()
	 <SET CNT <+ .CNT 1>>
	 <SET RM <GET .COR .CNT>>
	 <COND (<==? .RM 0>
		<RFALSE>)
	       (<==? .RM .ITM>
		<RETURN <GET .COR .PAST> ;.RM>)
	       (<AND <==? .ITM ,ROOMS>
		     <THIS-IT? .RM>	;"ROOM-SEARCH">
		<RETURN .RM>
		;<COND (
		       <SET FOUND .RM>
		       <RETURN>)>)
	       (<AND <ZERO? <LIT? .RM>>
		     <NOT <==? .ITM ,ROOMS>>>
		<AGAIN>)
	       (<==? .RM ,HERE>
		<SET PAST 1>)
	       (<SET OBJ <FIRST? .RM>>
		<REPEAT ()
			<COND (.ITM
			       <COND (<==? .OBJ .ITM>
				      <SET FOUND <GET .COR .PAST>>
				      <RETURN>)>)
			      (<AND <FSET? .OBJ ,PERSONBIT>
				    <NOT <IN-MOTION? .OBJ T>>>
			       <TELL D ;CTHE .OBJ " is in" THE .RM "." CR>)>
			<SET OBJ <NEXT? .OBJ>>
			<COND (<NOT .OBJ> <RETURN>)>>
		<COND (.FOUND <RETURN .FOUND>)>)>>>
