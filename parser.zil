"PARSER for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

"Parser global variable convention:  All parser globals will 
  begin with 'P-'.  Local variables are not restricted in any
  way." 
 
<SETG SIBREAKS ".,\"!?'"> 

<GLOBAL PRSA:NUMBER 0>
<GLOBAL PRSI:OBJECT 0>
<GLOBAL PRSO:OBJECT 0> 
<GLOBAL OPRSO:OBJECT 0>

<GLOBAL P-SYNTAX 0> 

<GLOBAL P-LEN:NUMBER 0>    

;<GLOBAL P-DIR 0>

<GLOBAL WINNER:OBJECT PLAYER>   

<GLOBAL P-LEXV		<ITABLE 79 (LEXV) 0 #BYTE 0 #BYTE 0>>
<GLOBAL AGAIN-LEXV	<ITABLE 79 (LEXV) 0 #BYTE 0 #BYTE 0>>
<GLOBAL RESERVE-LEXV	<ITABLE 79 (LEXV) 0 #BYTE 0 #BYTE 0>>
<GLOBAL RESERVE-PTR:NUMBER <>>

"INBUF - Input buffer for READ"
<GLOBAL P-INBUF		<ITABLE 80 (BYTE LENGTH) 0>>
<GLOBAL OOPS-INBUF	<ITABLE 80 (BYTE LENGTH) 0>>
<GLOBAL RESERVE-INBUF	<ITABLE 80 (BYTE LENGTH) 0>>

<GLOBAL OOPS-TABLE <TABLE <> <> <> <>>>
<CONSTANT O-PTR 0>	"word pointer to unknown token in P-LEXV"
<CONSTANT O-START 1>	"word pointer to sentence start in P-LEXV"
<CONSTANT O-LENGTH 2>	"byte length of unparsed tokens in P-LEXV"
<CONSTANT O-END 3>	"byte pointer to first free byte in OOPS-INBUF"

"Parse-cont variable"
<GLOBAL P-CONT:NUMBER <>>  

<GLOBAL P-IT-OBJECT:OBJECT <>>
<GLOBAL P-HER-OBJECT:OBJECT FRIEND>
<GLOBAL P-HIM-OBJECT:OBJECT LORD>
"<GLOBAL P-THEM-OBJECT:OBJECT <>>"

"Orphan flag"
<GLOBAL P-OFLAG:FLAG <>> 

<GLOBAL P-MERGED:FLAG <>>

<GLOBAL P-ACLAUSE <>>    

<GLOBAL P-ANAM <>>  

<GLOBAL P-AADJ <>>

"Byte offset to # of entries in LEXV"
<CONSTANT P-LEXWORDS 1>

"Word offset to start of LEXV entries"
<CONSTANT P-LEXSTART 1>

"Number of words per LEXV entry"
<CONSTANT P-LEXELEN 2>   
<CONSTANT P-WORDLEN 4>

"Offset to parts of speech byte"
<CONSTANT P-PSOFF %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 6) (T 4)>>

"Offset to first part of speech"
<CONSTANT P-P1OFF %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE> 7) (T 5)>>

"First part of speech bit mask in PSOFF byte"
<CONSTANT P-P1BITS 3>    

<CONSTANT P-ITBLLEN 9>   

<GLOBAL P-ITBL <TABLE 0 0 0 0 0 0 0 0 0 0>>  

<GLOBAL P-OTBL <TABLE 0 0 0 0 0 0 0 0 0 0>>  

<GLOBAL P-VTBL <TABLE 0 0 0 0>>

<GLOBAL P-OVTBL <TABLE 0 0 0 0>>

<GLOBAL P-NCN:NUMBER 0>    

<CONSTANT P-VERB 0> 

<CONSTANT P-VERBN 1>

<CONSTANT P-PREP1 2>

<CONSTANT P-PREP1N 3>    

<CONSTANT P-PREP2 4>

"<CONSTANT P-PREP2N 5>"    

<CONSTANT P-NC1 6>  

<CONSTANT P-NC1L 7> 

<CONSTANT P-NC2 8>  

<CONSTANT P-NC2L 9> 

<GLOBAL QUOTE-FLAG:FLAG <>>

;<GLOBAL P-ADVERB <>>
<GLOBAL P-PRSA-WORD <>>
<GLOBAL P-END-ON-PREP:FLAG <>>
<GLOBAL P-WON <>>
<CONSTANT M-FATAL 2>   

<CONSTANT M-BEG 1>  
<CONSTANT M-ENTER 2>
<CONSTANT M-LOOK 3> 
<CONSTANT M-FLASH 4>
<CONSTANT M-OBJDESC 5>
<CONSTANT M-END 6> 
<CONSTANT M-CONT 7> 
<CONSTANT M-WINNER 8> 
<CONSTANT M-EXIT 9>
<CONSTANT M-OTHER 69>

<ROUTINE MAIN-LOOP ("AUX" X) <REPEAT () <SET X <MAIN-LOOP-1>>>>

<ROUTINE MAIN-LOOP-1 ("AUX" ICNT OCNT NUM CNT OBJ ;TBL V PTBL OBJ1 TMP X GW)
     <SET CNT 0>
     <SET OBJ <>>
     <SET PTBL T>
     ;<COND (<NOT <==? ,QCONTEXT-ROOM ,HERE>>
	    <SETG QCONTEXT <>>)>
     <COND (<SETG P-WON <PARSER>>
	    <SETG CLOCK-WAIT <>>
	    <SET ICNT <GET/B ,P-PRSI ,P-MATCHLEN>>
	    <SET OCNT <GET/B ,P-PRSO ,P-MATCHLEN>>
	    <COND (<AND <ZERO? .OCNT> <ZERO? .ICNT>>
		   T)
		  (<AND ,P-IT-OBJECT <ACCESSIBLE? ,P-IT-OBJECT>>
		   <SET TMP <>>
		   <REPEAT ()
			   <COND (<IGRTR? CNT .ICNT>
				  <RETURN>)>
			   <COND (<EQUAL? <GET/B ,P-PRSI .CNT> ,IT>
				  <PUT/B ,P-PRSI .CNT ,P-IT-OBJECT>
				  <TELL-I-ASSUME ,P-IT-OBJECT>
				  <SET TMP T>
				  <RETURN>)>>
		   <COND (T ;<ZERO? .TMP>
			  <SET CNT 0>
			  <REPEAT ()
			   <COND (<IGRTR? CNT .OCNT>
				  <RETURN>)>
			   <COND (<EQUAL? <GET/B ,P-PRSO .CNT> ,IT>
				  <PUT/B ,P-PRSO .CNT ,P-IT-OBJECT>
				  <TELL-I-ASSUME ,P-IT-OBJECT>
				  <RETURN>)>>)>
		   <SET CNT 0>)>
	    <SET NUM
		 <COND (<0? .OCNT> .OCNT)
		       (<G? .OCNT 1>
			;<SET TBL ,P-PRSO>
			<COND (<0? .ICNT> <SET OBJ <>>)
			      (T <SET OBJ <GET/B ,P-PRSI 1>>)>
			.OCNT)
		       (<G? .ICNT 1>
			<SET PTBL <>>
			;<SET TBL ,P-PRSI>
			<SET OBJ <GET/B ,P-PRSO 1>>
			.ICNT)
		       (T ;.ICNT 1)>>
	    <COND (<AND <NOT .OBJ> <1? .ICNT>>
		   <SET OBJ <GET/B ,P-PRSI 1>>)>
	    <COND (<EQUAL? ,PRSA ,V?WALK ;,V?FACE>
		   <COND ;(<ZERO? ,PRSO>
			  <SET V <PERFORM ,PRSA <GET/B ,P-PRSO 1>>>)
			 (T <SET V <PERFORM ,PRSA ,PRSO>>)>)
		  (<0? .NUM>
		   <COND (<0? <BAND <GETB ,P-SYNTAX ,P-SBITS> ,P-SONUMS>>
			  <SET V <PERFORM ,PRSA>>
			  <SETG PRSO <>>)
			 (<AND <ZERO? ,LIT> <SEE-VERB?>>
			  ;<AND <NOT ,LIT>
			       <NOT <VERB? WAIT-FOR WAIT-UNTIL>>
			       <NOT <SPEAKING-VERB?>>
			       <NOT <GAME-VERB?>>>
			  <SETG QUOTE-FLAG <>>
			  <SETG P-CONT <>>
			  <TOO-DARK>)
			 (T
			  <SETG QUOTE-FLAG <>>
			  <SETG P-CONT <>>
			  <TELL "(There isn't any">
			  <COND (<OR <AND .PTBL
					  <==? <GETB ,P-SYNTAX ,P-SFWIM1>
					       ,PERSONBIT>>
				     <AND <NOT .PTBL>
					  <==? <GETB ,P-SYNTAX ,P-SFWIM2>
					       ,PERSONBIT>>>
				 <TELL "one">)
				(T <TELL "thing">)>
			  <TELL " to ">
			  <SET TMP <GET ,P-ITBL ,P-VERBN>>
			  <COND (<VERB? TELL>
				 <TELL "talk to">)
				(<OR ,P-MERGED ,P-OFLAG>
				 <PRINTB <GET .TMP 0>>)
				(T
				 <SET V <WORD-PRINT <GETB .TMP 2>
						    <GETB .TMP 3>>>)>
			  <TELL "!)" CR>
			  <SET V <>>)>)
		  (<AND .PTBL <G? .NUM 1> <VERB? COMPARE>>
		   <SET V <PERFORM ,PRSA ,OBJECT-PAIR>>)
		  (T
		   <SET X 0>
		   ;"<SETG P-MULT <>>
		   <COND (<G? .NUM 1> <SETG P-MULT T>)>"
		   <SET TMP 0>
		   <SET GW <>>
		   <REPEAT ()
		    <COND (<IGRTR? CNT .NUM>
			   <COND (<G? .X 0>
				  <TELL "The ">
				  <COND (<NOT <EQUAL? .X .NUM>>
					 <TELL "other ">)>
				  <TELL "object">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL !\s>)>
				  <TELL " that you mentioned ">
				  <COND (<NOT <EQUAL? .X 1>>
					 <TELL "are">)
					(T <TELL "is">)>
				  <TELL "n't here." CR>)
				 (<NOT .TMP>
				  <MORE-SPECIFIC ;REFERRING>)>
			   <RETURN>)
			  (T
			   <COND (.PTBL
				  <SET OBJ1 <GET/B ,P-PRSO .CNT>>)
				 (T <SET OBJ1 <GET/B ,P-PRSI .CNT>>)>
			   <COND (<OR <G? .NUM 1>
				      <EQUAL? <GET <GET ,P-ITBL ,P-NC1> 0>
					      ,W?ALL>>
				  <COND (<==? .OBJ1 ,NOT-HERE-OBJECT>
					 <SET X <+ .X 1>>
					 <AGAIN>)
					(<AND <EQUAL? ,P-GETFLAGS ,P-ALL>
					      <NOT<VERB-ALL-TEST .OBJ1 .OBJ>>>
					 <AGAIN>)
					(<NOT <ACCESSIBLE? .OBJ1>>
					 <AGAIN>)
					(<==? .OBJ1 ,PLAYER> <AGAIN>)
					;(<FSET? .OBJ1 ,DUPLICATE> <AGAIN>)
					(T
					 <COND (<==? .OBJ1 ,COSTUME>
						<COND (<T? .GW>
						       <AGAIN>)
						      (T <SET GW T>)>)>
					 <COND (<EQUAL? .OBJ1 ,IT>
						<PRINTD ,P-IT-OBJECT>)
					       (T <PRINTD .OBJ1>)>
					 <TELL ": ">)>)>
			   <SET TMP T>
			   <SET V <QCONTEXT-CHECK <COND (.PTBL .OBJ1)
							(T .OBJ)>>>
			   <COND (.PTBL
				  <SETG PRSO .OBJ1>
				  <SETG PRSI .OBJ>)
				 (T
				  <SETG PRSO .OBJ>
				  <SETG PRSI .OBJ1>)>
			   <SET V <PERFORM ,PRSA ,PRSO ,PRSI>>
			   <COND (<==? .V ,M-FATAL> <RETURN>)>)>>)>
	    <SETG OPRSO ,PRSO>
	    <COND (<==? .V ,M-FATAL> <SETG P-CONT <>>)>)
	   (T
	    <SETG CLOCK-WAIT T>
	    <SETG P-CONT <>>)>
     <COND (<AND <ZERO? ,CLOCK-WAIT> <T? ,P-WON>>
	    <COND (<OR ;<VERB? SAVE RESTORE>
		       <NOT <GAME-VERB?>>>
		   <SETG CLOCKER-RUNNING 1>
		   <SET V <CLOCKER>>
		   <SETG CLOCKER-RUNNING 2 ;0>)>)>
     <SETG PRSA <>>
     <SETG PRSO <>>
     <SETG PRSI <>>>

<ROUTINE TELL-I-ASSUME (OBJ "OPT" (STR 0))
	<COND (<OR <T? .STR>
		   <AND <NOT <==? ,OPRSO .OBJ>>
			<NOT <FSET? .OBJ ,SECRETBIT>>>>
	       <TELL ,I-ASSUME>
	       <COND (<T? .STR> <TELL .STR>)>
	       <TELL THE .OBJ ".]" CR>)>>

<ROUTINE VERB-ALL-TEST (O I "AUX" L)	;"O=PRSO I=PRSI"
 <SET L <LOC .O>>
 <COND (<EQUAL? .O ,PAINT>
	<RFALSE>)
       (<VERB? DROP GIVE>
	<COND (<EQUAL? .O ;,POCKET ,NOW-WEARING>
	       <RFALSE>)
	      (<OR <==? .L ,WINNER> ;<IN? ,P-IT-OBJECT ,WINNER>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<VERB? PUT PUT-IN>
	<COND (<EQUAL? .O .I ;,POCKET ,NOW-WEARING>
	       <RFALSE>)
	      (<NOT <IN? ;HELD? .O .I>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<VERB? TAKE>
	<COND (<FSET? .O ,SECRETBIT>
	       <RFALSE>)
	      (<AND <NOT <FSET? .O ,TAKEBIT>>
		    <NOT <FSET? .O ,TRYTAKEBIT>>>
	       <RFALSE>)>
	<COND (<NOT <ZERO? .I>>
	       <COND (<NOT <==? .L .I>>
		      <RFALSE>)
		     ;(T
		      <SET L .I>)>)
	      (<EQUAL? .L ;,WINNER ,HERE>
	       <COND (<AND <==? .O ,CANDLE>
			   <NOT <EQUAL? ,P-PRSA-WORD ,W?RAISE ,W?LIFT>>>
		      <RFALSE>)
		     (T <RTRUE>)>)>
	<COND (<OR <FSET? .L ,PERSONBIT>
		   <FSET? .L ,SURFACEBIT>>
	       <RTRUE>)
	      (<AND <FSET? .L ,CONTBIT>
		    <FSET? .L ,OPENBIT>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (<NOT <ZERO? .I>>
	<COND (<NOT <==? .O .I>>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (T <RTRUE>)>>

<ROUTINE GAME-VERB? ()
 %<DEBUG-CODE <COND (<VERB? $GENDER $GOAL $QUEUE
			    $RANDOM $COMMAND $RECORD $UNRECORD ;$WHERE DEBUG>
		     <RTRUE>)>>
 <COND (<VERB? BRIEF QUIT RESTART RESTORE SAVE SCORE SCRIPT SUPER-BRIEF
	       TELL TIME UNSCRIPT VERBOSE VERSION $VERIFY>
	<RTRUE>)>>

<ROUTINE QCONTEXT-CHECK (PER "AUX" OTHER (WHO <>) (N 0))
	 <COND (<OR <VERB? ;FIND HELP ;WHAT>
		    <AND <VERB? SHOW TELL-ABOUT>
			 <==? .PER ,PLAYER>>> ;"? more?"
		<SET OTHER <FIRST? ,HERE>>
		<REPEAT ()
			<COND (<NOT .OTHER> <RETURN>)
			      (<AND <FSET? .OTHER ,PERSONBIT>
				    <NOT <FSET? .OTHER ,INVISIBLE>>
				    <NOT <==? .OTHER ,PLAYER>>>
			       <SET N <+ 1 .N>>
			       <SET WHO .OTHER>)>
			<SET OTHER <NEXT? .OTHER>>>
		<COND (<AND <==? 1 .N> <ZERO? ,QCONTEXT>>
		       <SETG QCONTEXT .WHO>)>
		<COND (<AND <QCONTEXT-GOOD?>
			    <==? ,WINNER ,PLAYER>> ;"? more?"
		       <SETG WINNER ,QCONTEXT>
		       <TELL "(said to " D ,QCONTEXT ")" CR>)>)>>

<ROUTINE QCONTEXT-GOOD? ()
 <COND (<AND <NOT <ZERO? ,QCONTEXT>>
	     <FSET? ,QCONTEXT ,PERSONBIT>
	     <NOT <FSET? ,QCONTEXT ,MUNGBIT ;,INVISIBLE>>
	     ;<==? ,HERE ,QCONTEXT-ROOM>
	     <==? ,HERE <META-LOC ,QCONTEXT>>>
	<RETURN ,QCONTEXT>)>>

<ROUTINE NOT-IT (WHO)
 <COND (<EQUAL? .WHO ,P-HER-OBJECT>
	<FCLEAR ,HER ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-HIM-OBJECT>
	<FCLEAR ,HIM ,TOUCHBIT>)
       ;(<EQUAL? .WHO ,P-THEM-OBJECT>
	<FCLEAR ,THEM ,TOUCHBIT>)
       (<EQUAL? .WHO ,P-IT-OBJECT>
	<FCLEAR ,IT  ,TOUCHBIT>)>>

<OBJECT NOT-HERE-OBJECT
	(DESC "that thing")
	(FLAGS NARTICLEBIT)
	(ACTION NOT-HERE-OBJECT-F)>

<ROUTINE NOT-HERE-OBJECT-F ("AUX" TBL (PRSO? <>) (OBJ <>))
	;"Protocol: return ,M-FATAL if case was handled and msg TELLed,
			  <> if PRSO/PRSI ready to use"
	 <COND (<AND <EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		     <EQUAL? ,PRSI ,NOT-HERE-OBJECT>>
		<TELL "(Those things aren't here!)" CR>
		<RFATAL>)
	       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
		<SET TBL ,P-PRSO>
		<SET PRSO? T>)
	       (T
		<SET TBL ,P-PRSI>)>
	 <COND (<EQUAL? ,P-XADJ ,A?MY>
		<COND (<EQUAL? ,P-XNAM ,W?EYE ,W?EYES>
		       <SET OBJ ,EYE>)
		      (<EQUAL? ,P-XNAM ,W?HANDS ,W?HAND>
		       <SET OBJ ,HANDS>)
		      (<EQUAL? ,P-XNAM ,W?HEAD>
		       <SET OBJ ,HEAD>)>
		<COND (<T? .OBJ>
		       <COND (<T? .PRSO?>
			      <SETG PRSO .OBJ>)
			     (T <SETG PRSI .OBJ>)>
		       <RFALSE>)>)>
	 ;<COND (<AND <VERB? ASK-ABOUT ASK-FOR SEARCH-FOR>
		     <FSET? ,PRSO ,PERSONBIT>
		     <IN? ,PRSO ,GLOBAL-OBJECTS>>
		<NOT-HERE-PERSON ,PRSO>
		<RFATAL>)>
	 <COND (<AND <EQUAL? ,P-ADJN ,W?YOUR ,W?HER ,W?HIS>
		     <T? ,P-NAM>>
		<RESOLVE-YOUR-HER-HIS>)>
	 <COND (<OR <AND .PRSO? <PRSO-VERB?>>
		    <AND <NOT .PRSO?> <PRSI-VERB?>>>
		<COND (<SET OBJ <FIND-NOT-HERE .TBL .PRSO?>>
		       <COND (<NOT <==? .OBJ ,NOT-HERE-OBJECT>>
			      <RFATAL>)>)
		      (T
		       <RFALSE>)>)>
	 ;"Here is the default 'cant see any' printer"
	 <TELL !\( CHE ,WINNER ;"You" " can't ">
	 <COND (<VERB? LISTEN> <TELL "hear">)
	       (T <TELL "see">)>
	 <COND (<NOT <CAPITAL-NOUN? ,P-XNAM>>
		<TELL " any">)>
	 <NOT-HERE-PRINT>
	 <TELL " right here!)" CR>
	 <RFATAL>>

<ROUTINE PRSO-VERB? ()
 <COND (<VERB? ;ARREST ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR
	       BOARD CLIMB-DOWN CLIMB-UP	;"GO DOWN/UP TO room"
	       DISEMBARK DRESS DESCRIBE ;EXAMINE
	       FIND FOLLOW LEAVE TALK-ABOUT TELL ;"YELL TO person"
	       THROUGH USE WAIT-FOR WALK-TO ;$WHERE>
	<RTRUE>)
       (<AND <NOT <==? ,WINNER ,PLAYER>>
	     <VERB? ;BRING GIVE TAKE SSHOW>>
	<RTRUE>)>>

<ROUTINE PRSI-VERB? ()
 <COND (<VERB? ASK-ABOUT ASK-FOR SEARCH-FOR ;SSHOOT TAKE-TO TELL-ABOUT ;$WHERE>
	<RTRUE>)
       (<NOT <==? ,WINNER ,PLAYER>>
	<COND (<VERB? ;SBRING SGIVE SHOW>
	       <RTRUE>)
	      (<VERB? SSHOW>
	       <COND (T ;<IN? ,PRSI ,ROOMS>	;"SHOW ME TO MY ROOM"
		      <RTRUE>)>)>)>>

<ROUTINE GEN-TEST (OBJ)
	<COND (<VISIBLE? .OBJ> ;<IN? .OBJ ,HERE>
	       <RTRUE>)
	      (<CORRIDOR-LOOK .OBJ>
	       <RTRUE>)
	      (<AND <OR <VERB? FOLLOW> <REMOTE-VERB?>>
		    <FSET? .OBJ ,PERSONBIT>
		    <FSET? .OBJ ,SEENBIT>>
	       <RTRUE>)>>

<ROUTINE NOT-SECRET-TEST (OBJ)
	<COND (<AND <FSET? .OBJ ,SECRETBIT>
		    <NOT <FSET? .OBJ ,SEENBIT>>>
	       <RFALSE>)
	      (T
	       <RTRUE>)>>

<ROUTINE PRUNE (TBL LEN FCN "AUX" (CNT 1) OBJ)
	<REPEAT ()
		<SET OBJ <GET/B .TBL .CNT>>
		<COND (<ZERO? <APPLY .FCN .OBJ>>
		       <DEC LEN>
		       <ELIMINATE .TBL .CNT .LEN>
		       <COND (<NOT <G? .CNT .LEN>> <AGAIN>)>)>
		<COND (<IGRTR? CNT .LEN> <RETURN>)>>
	<PUT/B .TBL ,P-MATCHLEN .LEN>
	.LEN>

<ROUTINE ELIMINATE (TBL CNT N)
	;<COND (<NOT <L? .CNT .N>> <RFALSE>)>
	<REPEAT ()
		<PUT/B .TBL .CNT <GET/B .TBL <+ 1 .CNT>>>
		<COND (<IGRTR? CNT .N> <RETURN>)>>>

<GLOBAL P-MOBY-FOUND:OBJECT <>>
<GLOBAL P-MOBY-FLAG:FLAG <>>	"Needed only for ZIL"
<CONSTANT LAST-OBJECT 0> "ZILCH should stick the # of the last object here"

<ROUTINE MOBY-FIND (TBL "AUX" (OBJ 1) LEN FOO)
  <SETG P-NAM ,P-XNAM>
  <SETG P-ADJ ,P-XADJ>
  <PUT/B .TBL ,P-MATCHLEN 0>
  %<COND (<GASSIGNED? PREDGEN>	;<NOT <ZERO? <GETB 0 18>>>	;"ZIP case"
	  '<PROG ()
	    <REPEAT ()
		 <COND (<AND <SET FOO <META-LOC .OBJ T>>
			     <SET FOO <THIS-IT? .OBJ>>>
			<SET FOO <OBJ-FOUND .OBJ .TBL>>)>
		 <COND (<IGRTR? OBJ ,LAST-OBJECT>
			<RETURN>)>>>)
	 (T		;"ZIL case"
	  '<PROG ()
		 <SETG P-MOBY-FLAG T>
		 <SETG P-TABLE .TBL>
		 <SETG P-SLOCBITS -1>
		 <SET FOO <FIRST? ,ROOMS>>
		 <REPEAT ()
			 <COND (<NOT .FOO> <RETURN>)
			       (T
				<SEARCH-LIST .FOO .TBL ,P-SRCALL ;T>
				<SET FOO <NEXT? .FOO>>)>>
		 <COND (T ;<EQUAL? <SET LEN <GET/B .TBL ,P-MATCHLEN>> 0>
			<DO-SL ,LOCAL-GLOBALS 1 1 ;".TBL T">)>
		 <COND (T ;<EQUAL? <SET LEN <GET/B .TBL ,P-MATCHLEN>> 0>
			<SEARCH-LIST ,ROOMS .TBL ,P-SRCTOP ;T>)>
		 <SETG P-MOBY-FLAG <>>>)>
  <SETG P-NAM <>>
  <SETG P-ADJ <>>
  <SET LEN <GET/B .TBL ,P-MATCHLEN>>
  <COND (<EQUAL? .LEN 1>
	 <SETG P-MOBY-FOUND <GET/B .TBL 1>>)>
  .LEN>

<ROUTINE FIND-NOT-HERE (TBL PRSO? "AUX" M-F OBJ LEN CNT (LOCAL 0))
	;"Protocol: return T if case was handled and msg TELLed,
	    ,NOT-HERE-OBJECT if 'can't see' msg TELLed,
			  <> if PRSO/PRSI ready to use"
	;"Here is where special-case code goes. <MOBY-FIND .TBL> returns
	   number of matches. If 1, then P-MOBY-FOUND is it. One may treat
	   the 0 and >1 cases alike or different. It doesn't matter. Always
	   return FALSE (not handled) if you have resolved the problem."
	<SET M-F <MOBY-FIND .TBL>>
	%<DEBUG-CODE 
	  <COND (,DBUG
	       <TELL "{Found " N .M-F " objects}" CR>
	       <COND (<NOT <==? 1 .M-F>>
		      <TELL "{Namely: ">
		      <SET CNT 1>
		      <SET LEN <GET/B .TBL ,P-MATCHLEN>>
		      <REPEAT ()
			      <COND (<DLESS? LEN 0> <RETURN>)
				    (T <TELL D <GET/B .TBL .CNT> ", ">)>
			      <INC CNT>>
		      <TELL "}" CR>)>)>>
	<COND (<G? .M-F 1>
	       <SET CNT 0>
	       <REPEAT ()
		       <COND (<G? <SET CNT <+ .CNT 1>> .M-F>
			      <RETURN>)>
		       <SET OBJ <GET/B .TBL .CNT>>
		       <COND (<GEN-TEST .OBJ>
			      <COND (<G? <SET LOCAL <+ .LOCAL 1>> 1>
				     <RETURN>)
				    (ELSE
				     <SETG P-MOBY-FOUND .OBJ>)>)>>
	       <COND (<EQUAL? .LOCAL 1>
		      <SET M-F 1>)>)>
	<COND (<==? 1 .M-F>
	       %<DEBUG-CODE
		 <COND (,DBUG <TELL "{Namely: " D ,P-MOBY-FOUND "}" CR>)>>
	       <COND (<AND <NOT <REMOTE-VERB?>>
			   <FSET? ,P-MOBY-FOUND ,SECRETBIT>>
		      <NOT-FOUND ,P-MOBY-FOUND>
		      <RETURN T ;,NOT-HERE-OBJECT>)
		     (<AND <NOT <REMOTE-VERB?>>
			   <NOT <VERB? $CALL>>
			   <NOT <VISIBLE? ,P-MOBY-FOUND>>>
		      <NOT-HERE ,P-MOBY-FOUND>
		      <RETURN T ;,NOT-HERE-OBJECT>)
		     (<T? .PRSO?>
		      ;<SETG OPRSO ,PRSO>
		      <SETG PRSO ,P-MOBY-FOUND>)
		     (T
		      <SETG PRSI ,P-MOBY-FOUND>)>
	       ;<THIS-IS-IT ,P-MOBY-FOUND>
	       <RFALSE>)
	     (<AND <L? 1 .M-F>
		   <FSET? <SET OBJ <GET/B .TBL 1>> ,PERSONBIT>>
	      ;<SET FOUND 0>
	      <SET LEN <PRUNE .TBL <GET/B .TBL ,P-MATCHLEN> ,GEN-TEST>>
	      <COND (<0? .LEN>
		     <RETURN ,NOT-HERE-OBJECT>)
		    (<NOT <1? .LEN>>
		     <WHICH-PRINT 0 .LEN .TBL>
		     <COND (<==? .TBL ,P-PRSO>	<SETG P-ACLAUSE ,P-NC1>)
			   (T			<SETG P-ACLAUSE ,P-NC2>)>
		     <SETG P-AADJ ,P-ADJ>
		     <SETG P-ANAM ,P-NAM>
		     <ORPHAN <> <>>
		     <SETG P-OFLAG T>
		     <RTRUE>)>
	      %<DEBUG-CODE <COND (,DBUG <TELL "{Corridor: " D .OBJ "}" CR>)>>
	      <COND (<FSET? .OBJ ,SECRETBIT>
		     <NOT-FOUND .OBJ>
		     <RETURN T ;,NOT-HERE-OBJECT>)
		    (<T? .PRSO?>
		     ;<SETG OPRSO ,PRSO>
		     <SETG PRSO .OBJ>)
		    (T
		     <SETG PRSI .OBJ>)>
	      <RFALSE>)
	     (<AND <L? 1 .M-F>
		   <SET OBJ <APPLY <GETP <SET OBJ <GET/B .TBL 1>> ,P?GENERIC>
				   .TBL .M-F ;"?">>>
	;"Protocol: returns .OBJ if that's the one to use,
		,NOT-HERE-OBJECT if case was handled and msg TELLed,
			      <> if WHICH-PRINT should be called"
	       %<DEBUG-CODE <COND (,DBUG <TELL "{Generic: " D .OBJ "}" CR>)>>
	       <COND (<==? .OBJ ,NOT-HERE-OBJECT>
		      <RTRUE>)
		     (<FSET? .OBJ ,SECRETBIT>
		      <NOT-FOUND .OBJ>
		      <RETURN T ;,NOT-HERE-OBJECT>)
		     (.PRSO?
		      ;<SETG OPRSO ,PRSO>
		      <SETG PRSO .OBJ>)
		     (T
		      <SETG PRSI .OBJ>)>
	       ;<THIS-IS-IT .OBJ>
	       <RFALSE>)
	      (<OR <AND <NOT .PRSO?>
			<IN? ,PRSO ,HERE>
			<VERB? ASK-ABOUT ASK-FOR TELL-ABOUT>>
		   <AND .PRSO?
			<QCONTEXT-GOOD?>
			<VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR>>
		   <AND <NOT <==? ,WINNER ,PLAYER>>
			<VERB? FIND ;WHAT GIVE SGIVE>>>
	       <SET LEN <>>
	       <COND (<NOT <==? ,WINNER ,PLAYER>>
		      <SET LEN ,WINNER>)
		     (<VERB? ASK-ABOUT ASK-FOR TELL-ABOUT>
		      <SET LEN ,PRSO>)
		     (<QCONTEXT-GOOD?>
		      <SET LEN ,QCONTEXT>)
		     ;(<SET OBJ <FIND-FLAG ,HERE ,PERSONBIT ,WINNER ;,PLAYER>>
		      <SET LEN .OBJ>)
		     ;(<VISIBLE? ,FRIEND>
		      <SET LEN ,FRIEND>)
		     ;(T <SET LEN ,GAME>)>
	       <COND (<NOT <EQUAL? .LEN 0 ,PLAYER>>
		      <START-SENTENCE .LEN>
		      <TELL " looks confused. ">)>
	       <TELL "\"I don't know wh">
	       <COND (<0? .M-F>
		      <TELL "at you mean by">
		      <NOT-HERE-PRINT>)
		     (T
		      <TELL "ich">
		      <NOT-HERE-PRINT>
		      <TELL " you mean">)>
	       <TELL "!\"" CR>
	       <RTRUE>)
	      (<NOT .PRSO?>
	       <TELL CHE ,WINNER " wouldn't find">
	       <COND (<NOT <CAPITAL-NOUN? ,P-XNAM>>
		      <TELL " any">)>
	       <NOT-HERE-PRINT>
	       <TELL " there." CR>
	       <RTRUE>)
	      (T ,NOT-HERE-OBJECT)>>

<ROUTINE NOT-HERE-PRINT ()
 ;<TELL " any">
 <COND (<OR ,P-OFLAG ,P-MERGED>
	<COND (<T? ,P-XADJ>
	       <TELL !\ >
	       <PRINTB ,P-XADJN>)>
	<COND (<T? ,P-XNAM>
	       <TELL !\ >
	       <PRINTB ,P-XNAM>)>)
       (<EQUAL? ,PRSO ,NOT-HERE-OBJECT>
	<CLAUSE-PRINT ,P-NC1 ,P-NC1L <>>
	;<BUFFER-PRINT <GET ,P-ITBL ,P-NC1> <GET ,P-ITBL ,P-NC1L> <>>)
       (T
	<CLAUSE-PRINT ,P-NC2 ,P-NC2L <>>
	;<BUFFER-PRINT <GET ,P-ITBL ,P-NC2> <GET ,P-ITBL ,P-NC2L> <>>)>>

%<DEBUG-CODE
<ROUTINE TELL-D-LOC (OBJ)
	<TELL D .OBJ>
	<COND (<IN? .OBJ ,GLOBAL-OBJECTS>	<TELL "(gl)">)
	      (<IN? .OBJ ,LOCAL-GLOBALS>	<TELL "(lg)">)
	      (<IN? .OBJ ,ROOMS>		<TELL "(rm)">)>
	<COND (<EQUAL? .OBJ ,TURN ,INTNUM>
	       <TELL !\( N ,P-NUMBER !\)>)>>>

<ROUTINE SEE-VERB? ()
	<VERB? ANALYZE SANALYZE CHASTISE ;COUNT EXAMINE FIND
	       ;INVENTORY LOOK LOOK-BEHIND LOOK-DOWN LOOK-INSIDE LOOK-ON
	       LOOK-OUTSIDE LOOK-THROUGH LOOK-UNDER LOOK-UP
	       READ SEARCH SEARCH-FOR SSEARCH-FOR>>

<ROUTINE FIX-HIM-HER-IT (PRON OBJ)
 <COND (<OR <ZERO? .OBJ>
	    <AND <NOT <ACCESSIBLE? .OBJ>>
		 <OR <AND <==? .PRON ,PRSI> <NOT <PRSI-VERB?>>>
		     <AND <==? .PRON ,PRSO> <NOT <PRSO-VERB?>>>>>>
	<COND (<EQUAL? 0 .OBJ ,PRSI>
	       <FAKE-ORPHAN>)
	      (T <NOT-HERE .OBJ>)>
	<RFALSE>)
       (T
	<COND (<==? ,PRSO .PRON>
	       <COND (<==? .PRON ,IT>
		      <PUT ,P-ADJW 0 <GET ,P-IT-WORDS 0>>
		      <PUT ,P-NAMW 0 <GET ,P-IT-WORDS 1>>)>
	       <SETG PRSO .OBJ>
	       <TELL-I-ASSUME .OBJ>)>
	<COND (<==? ,PRSI .PRON>
	       <COND (<==? .PRON ,IT>
		      <PUT ,P-ADJW 1 <GET ,P-IT-WORDS 0>>
		      <PUT ,P-NAMW 1 <GET ,P-IT-WORDS 1>>)>
	       <SETG PRSI .OBJ>
	       <TELL-I-ASSUME .OBJ>)>
	<RTRUE>)>>

<ROUTINE FAKE-ORPHAN ("AUX" TMP)
	 <ORPHAN ,P-SYNTAX <>>
	 <TELL "[Please be specific: wh">
	 <COND ;(<VERB? WALK WALK-TO>
		<TELL "ere">)
	       (<==? <GETB ,P-SYNTAX ,P-SFWIM1> ,PERSONBIT>
		<TELL "om">)
	       (T <TELL "at">)>
	 <TELL " do you want to ">
	 <VERB-PRINT>
	 ;<SET TMP <GET ,P-OTBL ,P-VERBN>>
	 ;<COND (<==? .TMP 0> <TELL "tell">)
	       (<0? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
		<PUTB ,P-VTBL 2 0>)>
	 ;<PREP-PRINT <GETB ,P-SYNTAX ,P-SPREP2>>
	 <SETG P-OFLAG T>
	 <SETG P-WON <>>
	 ;<SETG CLOCK-WAIT T>
	 <TELL "?]" CR>>

<GLOBAL NOW-PRSI:FLAG <>>

<ROUTINE PERFORM (A "OPTIONAL" (O <>) (I <>) "AUX" V OA OO OI X)
	%<DEBUG-CODE <COND (,DBUG
	       <TELL "{Perform: ">
	       %<COND (<GASSIGNED? PREDGEN> '<TELL N .A>)
		      (T '<PRINC <NTH ,ACTIONS <+ <* .A 2> 1>>>)>
	       <COND (.O
		      <TELL !\/>
		      <COND (<EQUAL? .A ,V?WALK ;,V?FACE> <TELL N .O>)
			    (T <TELL-D-LOC .O>)>)>
	       <COND (.I
		      <TELL !\/>
		      <TELL-D-LOC .I>)>
	       <TELL "}" CR>)>>
	<SET OA ,PRSA>
	<SET OO ,PRSO>
	<SET OI ,PRSI>
	<SETG PRSA .A>
	<SETG PRSI .I>
	<SETG PRSO .O>
	<COND (<AND <ZERO? ,LIT>
		    <SEE-VERB?>
		    ;<NOT <DOBJ? GHOST-NEW COSTUME BLOWGUN>>
		    ;<NOT <IOBJ? GHOST-NEW COSTUME BLOWGUN>>>
	       <TOO-DARK>
	       <RFATAL>)
	      (<NOT <VERB? WALK ;FACE>>
	       <COND (<EQUAL? ,IT ,PRSI ,PRSO>
		      <COND (<NOT <FIX-HIM-HER-IT ,IT ,P-IT-OBJECT>>
			     <RFATAL>)>)>
	       <COND (<EQUAL? ,HER ,PRSI ,PRSO>
		      <COND (<NOT <FIX-HIM-HER-IT ,HER ,P-HER-OBJECT>>
			     <RFATAL>)>)>
	       <COND (<EQUAL? ,HIM ,PRSI ,PRSO>
		      <COND (<NOT <FIX-HIM-HER-IT ,HIM ,P-HIM-OBJECT>>
			     <RFATAL>)>)>)>
	<SET V <>>
	<COND (<AND <NOT <EQUAL? .A ,V?WALK ;,V?FACE>>
		    <EQUAL? ,NOT-HERE-OBJECT ,PRSO ,PRSI>>
	       <SET V <D-APPLY "Not Here" ,NOT-HERE-OBJECT-F>>
	       <COND (.V
		      <SETG P-WON <>>
		      ;<SETG CLOCK-WAIT T>)>)>
	<THIS-IS-IT ,PRSI>
	<THIS-IS-IT ,PRSO>
	<COND (<NOT <EQUAL? ,WINNER ,PLAYER>>
	       <THIS-IS-IT ,WINNER>)>
	<SET O ,PRSO>
	<SET I ,PRSI>
	%<DEBUG-CODE <COND (,DBUG
	       <TELL !\{ D ,WINNER "=}"> ;"extra output for next (...)")>>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY "Actor" <GETP ,WINNER ,P?ACTION>
			       ,M-WINNER>>)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY "Room (M-BEG)"
			       <GETP <COND (<IN? ,WINNER ,CAR> ,CAR)
					   (T ,HERE)> ;<LOC ,WINNER>
				     ,P?ACTION>
			       ,M-BEG>>)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY "Preaction" <GET ,PREACTIONS .A>>>)>
	<SETG NOW-PRSI 1>
	;<COND (<AND <ZERO? .V>
		    .I	;"This new clause applies CONTFCN to PRSI, BM 2/85"
		    <NOT <EQUAL? .A ,V?WALK>>
		    <LOC .I>>
	       <SET V <GETP <LOC .I> ,P?CONTFCN>>
	       <COND (.V
		      <SET V <APPLY .V ,M-CONT>>)>)>
	<COND (<AND <ZERO? .V>
		    .I>
	       <SET V <D-APPLY "PRSI" <GETP .I ,P?ACTION>>>)>
	<SETG NOW-PRSI 0>
	;<COND (<AND <ZERO? .V>
		    .O
		    <NOT <EQUAL? .A ,V?WALK ;,V?FACE>>
		    <LOC .O>>
	       <SET V <GETP <LOC .O> ,P?CONTFCN>>
	       <COND (.V
		      <SET V <APPLY .V ,M-CONT>>)>)>
	<COND (<AND <ZERO? .V>
		    .O
		    <NOT <EQUAL? .A ,V?WALK ;,V?FACE>>>
	       <SET V <D-APPLY "PRSO" <GETP .O ,P?ACTION>>>
	       ;<COND (.V <THIS-IS-IT .O>)>)>
	<COND (<ZERO? .V>
	       <SET V <D-APPLY <> <GET ,ACTIONS .A>>>)>
	;<COND (<NOT <==? .V ,M-FATAL>>
	       <COND (<OR ;<VERB? SAVE RESTORE> <NOT <GAME-VERB?>>>
		      <SET V <D-APPLY "Room (M-END)"
				<GETP ,HERE ;<LOC ,WINNER> ,P?ACTION>
				,M-END>>)>)>
	<SETG PRSA .OA>
	<SETG PRSO .OO>
	<SETG PRSI .OI>
	.V>

<ROUTINE D-APPLY (STR FCN "OPTIONAL" (FOO <>) "AUX" RES)
 <COND (<T? .FCN>
	%<DEBUG-CODE <COND (,DBUG
	       <COND (<ZERO? .STR>
		      <TELL "{Action:}" CR>)
		     (T <TELL !\{ .STR ": ">)>)>>
	<COND (<=? .STR "Container">
	       <SET FOO ,M-CONT>)>
	<COND (.FOO <SET RES <APPLY .FCN .FOO>>)
	      (T <SET RES <APPLY .FCN>>)>
	%<DEBUG-CODE <COND (<AND ,DBUG .STR>
	       <COND (<==? .RES ,M-FATAL>
		      <TELL "Fatal}" CR>)
		     (<ZERO? .RES>
		      <TELL "Not handled}" CR>)
		     (T <TELL "Handled}" CR>)>)>>
	.RES)>>

<CONSTANT P-PROMPT-START 4>
<GLOBAL P-PROMPT:NUMBER 4>

<ROUTINE I-PROMPT ("OPTIONAL" (GARG <>))
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "{I-PROMPT:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <SETG P-PROMPT <- ,P-PROMPT 1>>
 %<DEBUG-CODE <COND (,IDEBUG <TELL "(0)}" CR>)>>
 <RFALSE>>

<ROUTINE BUZZER-WORD? (WRD PTR)
 <COND (<OR <QUESTION-WORD? .WRD>
	    <NAUGHTY-WORD? .WRD>
	    <NUMBER-WORD? .WRD>>
	<PUT ,OOPS-TABLE ,O-PTR .PTR>
	<RTRUE>)>>

<BUZZ	WHAT WHEN WHERE WHO WHY \(SOME
	;"ANY WHAT\'S WHEN\'S WHERE\'S WHO\'S WHY\'S">

;<GLOBAL QUESTION-WORD-PAIR-TABLE
       <PLTABLE	<PTABLE <VOC "AREN" BUZZ>	<VOC "T" BUZZ>>
	       	<PTABLE <VOC "COULDN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "DIDN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "DON" <>>		<VOC "T" <>>>
		<PTABLE <VOC "HASN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "HAVEN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "HE" BUZZ ;NOUN>	<VOC "S" <>>>
	       	<PTABLE <VOC "I" <>>		<VOC "LL" BUZZ>>
	       	<PTABLE <VOC "I" <>>		<VOC "M" BUZZ>>
	       	<PTABLE <VOC "I" <>>		<VOC "VE" BUZZ>>
	       	<PTABLE <VOC "ISN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "IT" <>>		<VOC "S" <>>>
		<PTABLE <VOC "LET" BUZZ>	<VOC "S" <>>>
		;<PTABLE <VOC "SHAN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "SHE" BUZZ ;NOUN>	<VOC "S" <>>>
		<PTABLE <VOC "SHOULD" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "THAT" BUZZ>	<VOC "S" <>>>
		<PTABLE <VOC "THEY" BUZZ>	<VOC "RE" BUZZ>>
		<PTABLE <VOC "WASN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "WE" <>>		<VOC "RE" BUZZ>>
		<PTABLE <VOC "WEREN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "WON" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "WOULDN" BUZZ>	<VOC "T" <>>>
		<PTABLE <VOC "YOU" <>>		<VOC "RE" BUZZ>>>>

<GLOBAL QWP1-TABLE
       <PLTABLE	<VOC "AREN" BUZZ>
		<VOC "COULDN" BUZZ>
		<VOC "DIDN" BUZZ>
		<VOC "DON" <>>
		<VOC "HASN" BUZZ>
		<VOC "HAVEN" BUZZ>
		<VOC "HE" BUZZ ;NOUN>
		<VOC "I" <>>
		<VOC "I" <>>
		<VOC "I" <>>
		<VOC "I" <>>
		<VOC "ISN" BUZZ>
		<VOC "IT" <>>
		<VOC "LET" BUZZ>
		;<VOC "SHAN" BUZZ>
		<VOC "SHE" BUZZ ;NOUN>
		<VOC "SHOULD" BUZZ>
		<VOC "THAT" BUZZ>
		<VOC "THEY" BUZZ>
		<VOC "WASN" BUZZ>
		<VOC "WE" <>>
		<VOC "WE" <>>
		<VOC "WEREN" BUZZ>
		<VOC "WON" BUZZ>
		<VOC "WOULDN" BUZZ>
		<VOC "YOU" <>>>>

<GLOBAL QWP2-TABLE
       <PLTABLE	<VOC "T" BUZZ>
		<VOC "T" <>>
		<VOC "T" <>>
		<VOC "T" <>>
		<VOC "T" <>>
		<VOC "T" <>>
		<VOC "S" <>>
		<VOC "D" <>>
		<VOC "LL" BUZZ>
		<VOC "M" BUZZ>
		<VOC "VE" BUZZ>
		<VOC "T" <>>
		<VOC "S" <>>
		<VOC "S" <>>
		;<VOC "T" <>>
		<VOC "S" <>>
		<VOC "T" <>>
		<VOC "S" <>>
		<VOC "RE" BUZZ>
		<VOC "T" <>>
		<VOC "RE" BUZZ>
		<VOC "LL" BUZZ>
		<VOC "T" <>>
		<VOC "T" <>>
		<VOC "T" <>>
		<VOC "RE" BUZZ>>>

<GLOBAL QUESTION-WORD-TABLE
       <PLTABLE	<VOC "AM" BUZZ>
		<VOC "ARE" BUZZ>
		<VOC "CAN" BUZZ>
		<VOC "COULD" BUZZ>
		<VOC "DID" BUZZ>
		<VOC "DO" BUZZ>
		<VOC "HAS" BUZZ>
		<VOC "HAVE" BUZZ>
		<VOC "HOW" BUZZ>
		<VOC "IS" BUZZ>
		<VOC "LIKE" BUZZ>
		<VOC "MAY" BUZZ>
		<VOC "SHALL" BUZZ>
		<VOC "SHOULD" BUZZ>
		<VOC "WANT" BUZZ>
		<VOC "WAS" BUZZ>
		<VOC "WERE" BUZZ>
		<VOC "WHEN" BUZZ>
		<VOC "WHICH" BUZZ>
		<VOC "WHY" BUZZ>
		;<VOC "WILL" BUZZ>
		<VOC "WOULD" BUZZ>>>

<GLOBAL SOMETHING " (something).]|">
<GLOBAL QUESTION-WORD-COUNT:NUMBER 2>

<ROUTINE QUESTION-WORD? (WORD "OPTIONAL" (DO-IT <>))
	<COND (<EQUAL? .WORD ,W?\(SOME>
	       <TELL "[Type a real word instead of" ,SOMETHING>
	       <RTRUE>)
	      (<EQUAL? .WORD ,W?WHERE>
	       <TO-DO-X-USE-Y "locate" "FIND">
	       <RTRUE>)
	      (<OR <EQUAL? .WORD ,W?WHAT ,W?WHO ,W?WHEN>
		   <EQUAL? .WORD ,W?WHY>>
	       <TO-DO-X-USE-Y "ask about" "TELL ME ABOUT">
	       <RTRUE>)
	      (<OR <T? .DO-IT> <ZMEMQ .WORD ,QUESTION-WORD-TABLE>>
	       <TELL "[Please use commands">
	       <SETG QUESTION-WORD-COUNT <+ 1 ,QUESTION-WORD-COUNT>>
	       <COND (<ZERO? <MOD ,QUESTION-WORD-COUNT 4 ;9>>
		      <TELL
" to tell the computer what you want to do in the story.
Here are some commands:|
   GO TO MY ROOM|
   LOOK UNDER THE RUG|
   MADAM, DESCRIBE THE GHOST|
Now you can try again">)
		     (T <TELL ", not statements or questions">)>
	       <TELL ".]" CR>)>>

<ROUTINE TO-DO-X-USE-Y (STR1 STR2)
	<TELL
"[To " .STR1 " something, use the command: " .STR2 ,SOMETHING>
	<RTRUE>>

<GLOBAL NUMBER-WORD-TABLE
       <PLTABLE	<VOC "ZERO" BUZZ>
		<VOC "ONE" BUZZ>
		<VOC "TWO" BUZZ>
		<VOC "THREE" BUZZ>
		<VOC "FOUR" BUZZ>
		<VOC "FIVE" BUZZ>
		<VOC "SIX" BUZZ>
		<VOC "SEVEN" BUZZ>
		<VOC "EIGHT" BUZZ>
		<VOC "NINE" BUZZ>
		<VOC "TEN" BUZZ>
		<VOC "ELEVEN" BUZZ>
		<VOC "TWELVE" BUZZ>
		;"<VOC 'THIRTEEN' BUZZ>
		<VOC 'FOURTEEN' BUZZ>
		<VOC 'FIFTEEN' BUZZ>
		<VOC 'SIXTEEN' BUZZ>
		<VOC 'SEVENT' BUZZ>
		<VOC 'EIGHTEEN' BUZZ>
		<VOC 'NINETEEN' BUZZ>"
		<VOC "TWENTY" BUZZ>
		<VOC "THIRTY" BUZZ>
		<VOC "FORTY" BUZZ>
		<VOC "FIFTY" BUZZ>
		<VOC "SIXTY" BUZZ>
		;<VOC "EIGHTY" BUZZ>
		;<VOC "NINETY" BUZZ>
		<VOC "HUNDRED" BUZZ>
		<VOC "THOUSAND" BUZZ>
		;<VOC "MILLION" BUZZ>
		;<VOC "BILLION" BUZZ>>>

<ROUTINE NUMBER-WORD? (WRD)
	<COND (<ZMEMQ .WRD ,NUMBER-WORD-TABLE>
	       <TELL "[Use numerals for numbers, for example \"10.\"]" CR>
	       <RTRUE>)>>

<GLOBAL NAUGHTY-WORD-TABLE
       <PLTABLE	<VOC "ASSHOLE" BUZZ>
		<VOC "BASTARD" BUZZ>
		<VOC "BITCH" BUZZ>
		;<VOC "CHOMP" BUZZ>
		;<VOC "CHOMPING" BUZZ>
		<VOC "COCK" BUZZ>
		<VOC "COCKSUCKER" BUZZ>
		<VOC "CRAP" BUZZ>
		<VOC "CUNT" BUZZ>
		<VOC "CURSE" BUZZ>
		;<VOC "CURSES" BUZZ>
		<VOC "CUSS" BUZZ>
		<VOC "DAMN" BUZZ>
		<VOC "DAMNED" BUZZ>
		<VOC "DARN" BUZZ>
		<VOC "FUCK" BUZZ>
		<VOC "FUCKED" BUZZ>
		<VOC "FUCKING" BUZZ>
		<VOC "FUDGE" BUZZ>
		<VOC "GODDAMN" BUZZ>
		<VOC "HELL" BUZZ>
		<VOC "PEE" BUZZ>
		<VOC "PISS" BUZZ>
		<VOC "SCREW" BUZZ>
		<VOC "SHIT" BUZZ>
		<VOC "SHITHEAD" BUZZ>
		<VOC "SUCK" BUZZ>
		<VOC "SUCKS" BUZZ>>>

<ROUTINE NAUGHTY-WORD? (WORD)
 <COND (<ZMEMQ .WORD ,NAUGHTY-WORD-TABLE>
	<TELL !\[ <PICK-ONE-NEW ,OFFENDED> !\] CR>)>>

<GLOBAL OFFENDED
	<LTABLE 0
		"What charming language!"
		"Computers aren't impressed by naughty words!"
		"You ought to be ashamed of yourself!"
		"Hey, save that talk for the locker room!"
		"Step outside and say that!"
		"And so's your old man!">>

" Grovel down the input finding the verb, prepositions, and noun phrases.
   If the input is <direction> or <walk> <direction>, fall out immediately
   setting PRSA to ,V?WALK and PRSO to <direction>.  Otherwise, perform
   all required orphaning, syntax checking, and noun phrase lookup."   

<BUZZ AGAIN G OOPS>
<GLOBAL BEG-PARDON "I beg your pardon?">

<ROUTINE NOT-THAT-WAY (STR)
	<TELL "[You can't use " .STR " that way.]" CR>>

<ROUTINE PARSER ("AUX" (PTR ,P-LEXSTART) WRD (VAL 0) (VERB <>) (OF-FLAG <>)
		       LEN (DIR <>) (NW 0) (LW 0) (CNT -1) OMERGED OWINNER
		       TMP) 
	<REPEAT ()
		<COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN> <RETURN>)
		      (T
		       <COND (<NOT ,P-OFLAG>
			      <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>
		       <PUT ,P-ITBL .CNT 0>)>>
	<SETG P-NAM <>>
	<SETG P-ADJ <>>
	<SETG P-ADJN <>>
	<SETG P-XNAM <>>
	<SETG P-XADJ <>>
	<SETG P-XADJN <>>
	;<SETG P-ADVERB <>>
	<COND (<ZERO? ,P-OFLAG>
	       <PUT ,P-NAMW 0 <>>
	       <PUT ,P-NAMW 1 <>>
	       <PUT ,P-ADJW 0 <>>
	       <PUT ,P-ADJW 1 <>>
	       <PUT ,P-OFW 0 <>>
	       <PUT ,P-OFW 1 <>>)>
	<SETG P-PRSA-WORD <>>
	<SET OMERGED ,P-MERGED>
	<SETG P-MERGED <>>
	<SETG P-END-ON-PREP <>>
	<PUT/B ,P-PRSO ,P-MATCHLEN 0>
	<PUT/B ,P-PRSI ,P-MATCHLEN 0>
	<PUT/B ,P-BUTS ,P-MATCHLEN 0>
	<SET OWINNER ,WINNER>
	<COND (<AND <NOT ,QUOTE-FLAG> <N==? ,WINNER ,PLAYER>>
	       <SETG WINNER ,PLAYER>
	       <COND (<NOT <FSET? <LOC ,WINNER> ,VEHBIT>>
		      ;<SETG OHERE ,HERE>
		      <SETG HERE <LOC ,WINNER>>)>
	       <SETG LIT <LIT? ;,HERE>>)>
	<COND (<NOT <ZERO? ,RESERVE-PTR>>
	       <SET PTR ,RESERVE-PTR>
	       <STUFF ,P-LEXV ,RESERVE-LEXV>
	       <INBUF-STUFF ,P-INBUF ,RESERVE-INBUF>
	       <COND (<AND <NOT <0? ,VERBOSITY>>
			   <==? ,PLAYER ,WINNER>>
		      <CRLF>)>
	       <SETG RESERVE-PTR <>>
	       ;<SETG P-CONT <>>)
	      (<NOT <ZERO? ,P-CONT>>
	       <SET PTR ,P-CONT>
	       ;<SETG P-CONT <>>
	       <COND (<AND <NOT <0? ,VERBOSITY>>
			   <==? ,PLAYER ,WINNER>>
		      <CRLF>)>
	       ;<COND (<NOT <VERB? ASK TELL SAY>> <CRLF>)>)
	      (T
	       <SETG WINNER ,PLAYER>
	       <SETG QUOTE-FLAG <>>
	       <COND (<ZERO? <GET ,OOPS-TABLE ,O-PTR>>
		      <PUT ,OOPS-TABLE ,O-END <>>)>
	       <COND (<NOT <FSET? <LOC ,WINNER> ,VEHBIT>>
		      ;<SETG OHERE ,HERE>
		      <SETG HERE <LOC ,WINNER>>)>
	       <SETG LIT <LIT? ;,HERE>>
	       <FCLEAR ,IT  ,TOUCHBIT>	;"to prevent pronouns w/o referents"
	       <FCLEAR ,HER ,TOUCHBIT>
	       <FCLEAR ,HIM ,TOUCHBIT>
	       ;<FCLEAR,THEM ,TOUCHBIT>
	       <COND (<NOT <0? ,VERBOSITY>>
		      ;<NOT ,SUPER-BRIEF>
		      <CRLF>)>
	       <COND (<AND ,P-PROMPT <ZERO? ,P-OFLAG> <ZERO? ,AWAITING-REPLY>>
		      <COND (<EQUAL? ,P-PROMPT ,P-PROMPT-START>
			     <TELL "What would you like to do?">)
			    (<L? <SETG P-PROMPT <- ,P-PROMPT 1>> 1>
			     <TELL
"[You won't see \"What next?\" any more.]|
">)
			    (T <TELL "What next?">)>
		      <CRLF>)>
	       %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
		       '<PROG ()
			      <USL>
			      <TELL !\>>>)
		      (T
		       '<TELL !\>>)>
	       <READ ,P-INBUF ,P-LEXV>)>
	<SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
	;<PUT ,P-LEXV <+ 1 <* ,P-LEN ,P-LEXELEN>> 0>	;"for NW in SNARFEM"
	<COND (<AND <==? ,W?QUOTE <GET ,P-LEXV .PTR>>
		    <QCONTEXT-GOOD?>>		;"Is quote first input token?"
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<==? ,W?THEN <GET ,P-LEXV .PTR>>	;"Is THEN first input word?"
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<AND <L? 1 ,P-LEN>
		    <EQUAL? <GET ,P-LEXV .PTR>
			    ,W?YOU>		;"Is this the first word ..."
		    <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		    <WT? .NW ,PS?VERB ;,P1?VERB> ;" followed by verb?">
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<AND <L? 1 ,P-LEN>
		    <EQUAL? <GET ,P-LEXV .PTR>
			    ,W?GO ,W?TO>	;"Is this the first word ..."
		    <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		    <WT? .NW ,PS?VERB ;,P1?VERB> ;" followed by verb?">
	       <SET PTR <+ .PTR ,P-LEXELEN>>	;"If so, ignore it."
	       <SETG P-LEN <- ,P-LEN 1>>)>
	<COND (<0? ,P-LEN>
	       <TELL !\[ ,BEG-PARDON "]" CR>
	       <RFALSE>)
	      (<EQUAL? <GET ,P-LEXV .PTR> ,W?OOPS>
	       <COND (<EQUAL? <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>
			      ,W?PERIOD ,W?COMMA ,W?\!>
		      <SET PTR <+ .PTR ,P-LEXELEN>>
		      <SETG P-LEN <- ,P-LEN 1>>)>
	       <COND (<NOT <G? ,P-LEN 1>>
		      <NOT-THAT-WAY "OOPS">
		      <RFALSE>)
		     (<SET VAL <GET ,OOPS-TABLE ,O-PTR>>
		      <COND (<AND <G? ,P-LEN 2>
				  ;<NOT <FIX-POSSESSIVES .PTR
							<+ .PTR
							   <* ,P-LEXELEN 3>>
							,P-LEXELEN>>>
			     <TELL
"[Warning: only the first word after OOPS is used.]" CR>)>
		      <PUT ,AGAIN-LEXV .VAL <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
		      ;<COND (<G? ,P-LEN 2>
			     )>
		      <SETG WINNER .OWINNER> ;"Fixes OOPS w/chars"
		      <SET PTR <+ <* .PTR ,P-LEXELEN> 6>>
		      <INBUF-ADD <GETB ,P-LEXV .PTR>
				 <GETB ,P-LEXV <+ .PTR 1>>
				 <+ <* .VAL ,P-LEXELEN> 3>>
		      ;<COND (<G? ,P-LEN 2>
			     )>
		      <STUFF ,P-LEXV ,AGAIN-LEXV>
		      <SETG P-LEN <GETB ,P-LEXV ,P-LEXWORDS>>
		      <SET PTR <GET ,OOPS-TABLE ,O-START>>
		      <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>
		      <SETG OOPS-PRINT T>
		      <PRINT-LEXV .PTR>
		      <SETG OOPS-PRINT <>>)
		     (T
		      <PUT ,OOPS-TABLE ,O-END <>>
		      <TELL "[There was no word to replace!]" CR>
		      <RFALSE>)>)
	      (<ZERO? ,P-CONT>
	       <PUT ,OOPS-TABLE ,O-END <>>)>
	<SETG P-CONT <>>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?AGAIN ,W?G>
	       <COND (<ZERO? <GETB ,OOPS-INBUF 1>>
		      <TELL "[What do you want to do again?]" CR>
		      <RFALSE>)
		     (<NOT <ZERO? ,P-OFLAG>>
		      <NOT-THAT-WAY "AGAIN">
		      <RFALSE>)
		     (<NOT ,P-WON> ;<T? ,CLOCK-WAIT>
		      <TELL "[That would just repeat a mistake!]" CR>
		      <RFALSE>)
		     (<G? ,P-LEN 1>
		      <COND (<OR <EQUAL? <SET CNT <GET ,P-LEXV
						       <+ .PTR ,P-LEXELEN>>>
					 ,W?PERIOD ,W?COMMA ,W?THEN>
				 <EQUAL? .CNT ,W?AND ,W?\! ,W??>>
			     <SET PTR <+ .PTR <* 2 ,P-LEXELEN>>>
			     <PUTB ,P-LEXV ,P-LEXWORDS
				   <- <GETB ,P-LEXV ,P-LEXWORDS> 2>>)
			    (T
			     <DONT-UNDERSTAND>
			     <RFALSE>)>)
		     (T
		      <SET PTR <+ .PTR ,P-LEXELEN>>
		      <PUTB ,P-LEXV ,P-LEXWORDS 
			    <- <GETB ,P-LEXV ,P-LEXWORDS> 1>>)>
	       <COND (<G? <GETB ,P-LEXV ,P-LEXWORDS> 0>
		      <STUFF ,RESERVE-LEXV ,P-LEXV>
		      <INBUF-STUFF ,RESERVE-INBUF ,P-INBUF>
		      <SETG RESERVE-PTR .PTR>)
		     (T
		      <SETG RESERVE-PTR <>>)>
	       ;<SETG P-LEN <GETB ,AGAIN-LEXV ,P-LEXWORDS>>
	       <SETG WINNER .OWINNER>
	       <SETG P-MERGED .OMERGED>
	       <INBUF-STUFF ,P-INBUF ,OOPS-INBUF>
	       <STUFF ,P-LEXV ,AGAIN-LEXV>
	       <SET CNT -1>
	       <SET DIR ,AGAIN-DIR>
	       <REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>)
	      (T
	       <SETG P-NUMBER -1>
	       <SET LEN <+ .PTR <* ,P-LEXELEN <GETB ,P-LEXV ,P-LEXWORDS>>>>
	       <COND (<==? T <FIX-POSSESSIVES .PTR .LEN>>
		      <RFALSE>)>
	       <STUFF ,AGAIN-LEXV ,P-LEXV>
	       <INBUF-STUFF ,OOPS-INBUF ,P-INBUF>
	       <PUT ,OOPS-TABLE ,O-START .PTR>
	       <PUT ,OOPS-TABLE ,O-LENGTH <* 4 ,P-LEN>>
	       <COND (<ZERO? <GET ,OOPS-TABLE ,O-END>>
		      <SET LEN <* 2 .LEN>>
		      <PUT ,OOPS-TABLE ,O-END <+ <GETB ,P-LEXV <- .LEN 1>>
						 <GETB ,P-LEXV <- .LEN 2>>>>)>
	       <SETG RESERVE-PTR <>>
	       <SET LEN ,P-LEN>
	       <SETG P-DIRECTION <>>
	       <SETG P-NCN 0>
	       <SETG P-GETFLAGS 0>
	       ;"3/25/83: Next statement added."
	       <PUT ,P-ITBL ,P-VERBN 0>
	       <REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <SETG QUOTE-FLAG <>>
		       <RETURN>)
		      (<OR <T? <SET WRD <GET ,P-LEXV .PTR>>>
			   <SET WRD <NUMBER? .PTR>>
			   <SET WRD <NAME? .PTR>>>
		       <COND (<0? ,P-LEN> <SET NW 0>)
			     (T <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>)>
		       <COND (<AND <==? .WRD ,W?TO>
				   <EQUAL? .VERB ,ACT?TELL ,ACT?ASK>>
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      ;<SET VERB ,ACT?TELL>
			      <SET WRD ,W?QUOTE>)
			     (<AND <EQUAL? .WRD ,W?THEN ;,W?PERIOD>
				   ;<NOT <EQUAL? .NW ,W?THEN ;,W?PERIOD>>
				   <G? ,P-LEN 0>
				   <ZERO? .VERB>
				   <ZERO? ,QUOTE-FLAG>>
			      <PUT ,P-ITBL ,P-VERB ,ACT?TELL>
			      <PUT ,P-ITBL ,P-VERBN 0>
			      <SET WRD ,W?QUOTE>)>
		       <COND (<AND <EQUAL? .WRD ,W?PERIOD>
				   <OR <EQUAL? .LW ,W?MRS ,W?MR ,W?MS>
				       <EQUAL? .LW ,W?DR ;,W?LT>>>
			      <SET LW 0>)
			     (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD ,W?QUOTE>
				  <EQUAL? .WRD ,W?\! ,W??>> 
			      <COND (<EQUAL? .WRD ,W?QUOTE>
				     <COND (<NOT <ZERO? ,QUOTE-FLAG>>
					    <SETG QUOTE-FLAG <>>)
					   (T <SETG QUOTE-FLAG T>)>)>
			      <OR <0? ,P-LEN>
				  <SETG P-CONT <+ .PTR ,P-LEXELEN>>>
			      <PUTB ,P-LEXV ,P-LEXWORDS ,P-LEN>
			      <RETURN>)
			     (<AND <SET VAL
					<WT? .WRD
					     ,PS?DIRECTION
					     ,P1?DIRECTION>>
				   <EQUAL? .VERB <> ,ACT?HEAD ;WALK>
				   <OR <==? .LEN 1>
				       <AND <==? .LEN 2>
					    <EQUAL? .VERB ,ACT?HEAD ;WALK>>
				       <AND <EQUAL? .NW
						    ,W?THEN ,W?PERIOD ,W?QUOTE>
					    <G? .LEN 1 ;2>>
				       <AND <EQUAL? .NW ,W?\! ,W??>
					    <G? .LEN 1 ;2>>
				       <AND ,QUOTE-FLAG
					    <==? .LEN 2>
					    <EQUAL? .NW ,W?QUOTE>>
				       <AND <G? .LEN 2>
					    <EQUAL? .NW ,W?COMMA ,W?AND>>>>
			      ;<COND (<ZERO? ,P-PRSA-WORD>
				     <SETG P-PRSA-WORD .WRD>)>
			      <SET DIR .VAL>
			      <COND (<EQUAL? .NW ,W?COMMA ,W?AND>
				     <CHANGE-LEXV <+ .PTR ,P-LEXELEN>
					          ,W?THEN>)>
			      <COND (<NOT <G? .LEN 2>>
				     <SETG QUOTE-FLAG <>>
				     <RETURN>)>)
			     (<AND <SET VAL <WT? .WRD ,PS?VERB ,P1?VERB>>
				   <ZERO? .VERB>>
			      <COND (<ZERO? ,P-OFLAG>
				     <SETG P-PRSA-WORD .WRD>)>
			      <SET VERB .VAL>
			      <PUT ,P-ITBL ,P-VERB .VAL>
			      <PUT ,P-ITBL ,P-VERBN ,P-VTBL>
			      <PUT ,P-VTBL 0 .WRD>
			      <PUTB ,P-VTBL 2 <GETB ,P-LEXV
						    <SET TMP
							 <+ <* .PTR 2> 2>>>>
			      <PUTB ,P-VTBL 3 <GETB ,P-LEXV <+ .TMP 1>>>)
			     (<OR <SET VAL <WT? .WRD ,PS?PREPOSITION 0>>
				  <AND <OR <EQUAL? .WRD ,W?ALL ,W?ONE ,W?A>
					   ;<EQUAL? .WRD ,W?BOTH>
					   <WT? .WRD ,PS?ADJECTIVE>
					   <WT? .WRD ,PS?OBJECT>>
				       ;<SET VAL 0>>>
			      <COND (<AND <G? ,P-LEN 1 ;0>
					  <==? .NW ,W?OF>
					  ;<NOT <EQUAL? .VERB
						       ,ACT?MAKE ,ACT?TAKE>>
					  <0? .VAL>
					  <NOT<EQUAL? .WRD ,W?ALL ,W?ONE ,W?A>>
					  ;<NOT <EQUAL? .WRD ,W?BOTH>>>
				     <PUT ,P-OFW ,P-NCN .WRD>	;"Save OF-word"
				     <SET OF-FLAG T>)
				    (<AND <NOT <0? .VAL>>
				          <OR <0? ,P-LEN>
					      <EQUAL? .NW ,W?THEN ,W?PERIOD>
					      <EQUAL? .NW ,W?\! ,W??>>>
				     <SETG P-END-ON-PREP T>
				     <COND (<L? ,P-NCN 2>
					    <PUT ,P-ITBL ,P-PREP1 .VAL>
					    <PUT ,P-ITBL ,P-PREP1N .WRD>)>)
				    (<==? ,P-NCN 2>
				     <TELL
"[I found too many nouns in that sentence!]" CR>
				     <RFALSE>)
				    (T
				     <SETG P-NCN <+ ,P-NCN 1>>
				     <COND (<ZERO?
					     <SET PTR <CLAUSE .PTR .VAL .WRD>>>
					    <RFALSE>)>
				     <COND (<L? .PTR 0>
					    <SETG QUOTE-FLAG <>>
					    <RETURN>)>)>)
			     ;(<==? .WRD ,W?CLOSELY>
			      <SETG P-ADVERB ,W?CAREFULLY>)
			     ;(<OR <EQUAL? .WRD
					 ,W?CAREFULLY ,W?QUIETLY>
				  <EQUAL? .WRD
					  ,W?SLOWLY ,W?QUICKLY ,W?BRIEFLY>>
			      <SETG P-ADVERB .WRD>)
			     (<EQUAL? .WRD ,W?OF>
			      <COND (<OR <ZERO? .OF-FLAG>
					 <EQUAL? .NW ,W?PERIOD ,W?THEN>
					 <EQUAL? .NW ,W?\! ,W??>>
				     <CANT-USE .PTR>
				     <RFALSE>)
				    (T
				     <SET OF-FLAG <>>)>)
			     (<WT? .WRD ,PS?BUZZ-WORD>
			      <COND (<BUZZER-WORD? .WRD .PTR>
				     <RFALSE>)>)
			     (<AND <EQUAL? .VERB ,ACT?TELL>
				   <WT? .WRD ,PS?VERB ;,P1?VERB>>
			      <TELL
"[Please consult your manual on how to talk to people.]" CR>
			      <RFALSE>)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T
		       <UNKNOWN-WORD .PTR>
		       <RFALSE>)>
		<SET LW .WRD>
		<SET PTR <+ .PTR ,P-LEXELEN>>>)>
	<PUT ,OOPS-TABLE ,O-PTR <>>
	<COND (<NOT <ZERO? .DIR>>
	       <SETG PRSA ,V?WALK>
	       <SETG P-WALK-DIR .DIR>
	       <SETG AGAIN-DIR .DIR>
	       <SETG PRSO .DIR>
	       <SETG P-OFLAG <>>
	       <RETURN T>)>
	<SETG P-WALK-DIR <>>
	<SETG AGAIN-DIR <>>
	<COND (<AND ,P-OFLAG
		    <ORPHAN-MERGE>>
	       <SETG WINNER .OWINNER>)>
	<COND (<==? <GET ,P-ITBL ,P-VERB> 0>
	       <SET PTR <- .PTR ,P-LEXELEN>>
	       <SET TMP <>>
	       <COND (<G? .PTR 0>
		      <SET TMP <GET ,P-LEXV .PTR>>)>
	       <COND (<EQUAL? .TMP ,W?PLEASE>
		      <PUT ,P-ITBL ,P-VERB ,ACT?YES>)
		     (<EQUAL? .TMP ,W?PERIOD>
		      <MISSING "verb">
		      <RFALSE>)
		     (T <PUT ,P-ITBL ,P-VERB ,ACT?$CALL>)>)>
	<COND (<AND <SYNTAX-CHECK> <SNARF-OBJECTS> <MANY-CHECK> <TAKE-CHECK>>
	       T)>>

<ROUTINE CHANGE-LEXV (PTR WRD)
	 <PUT ,P-LEXV .PTR .WRD>
	 <PUT ,AGAIN-LEXV .PTR .WRD>>

<GLOBAL OOPS-PRINT <>>
<ROUTINE PRINT-LEXV (PTR "AUX" X)
	<TELL ,I-ASSUME>
	<SET X <+ ,P-LEXV <* 2 .PTR>>>
	<BUFFER-PRINT .X <+ .X <* ,P-WORDLEN ,P-LEN>> <>>
	<TELL "]" CR>>

<GLOBAL P-WALK-DIR <>>
<GLOBAL AGAIN-DIR <>>

"For AGAIN purposes, put contents of one LEXV table into another:"

<ROUTINE STUFF (DEST SRC "OPTIONAL" (MAX 29) "AUX" (PTR ,P-LEXSTART) (CTR 1)
						   BPTR)
	 <PUTB .DEST 0 <GETB .SRC 0>>
	 <PUTB .DEST 1 <GETB .SRC 1>>
	 <REPEAT ()
	  <PUT .DEST .PTR <GET .SRC .PTR>>
	  <SET BPTR <+ <* .PTR 2> 2>>
	  <PUTB .DEST .BPTR <GETB .SRC .BPTR>>
	  <SET BPTR <+ <* .PTR 2> 3>>
	  <PUTB .DEST .BPTR <GETB .SRC .BPTR>>
	  <SET PTR <+ .PTR ,P-LEXELEN>>
	  <COND (<IGRTR? CTR .MAX>
		 <RETURN>)>>>

"Put contents of one INBUF into another:"

<ROUTINE INBUF-STUFF (DEST SRC "OPTIONAL" (CNT 80))
	 <REPEAT ()
	  <COND (<DLESS? CNT 0> <RETURN>)
		(T <PUTB .DEST .CNT <GETB .SRC .CNT>>)>>> 

"Put the word in the positions specified from P-INBUF to the end of
OOPS-INBUF, leaving the appropriate pointers in AGAIN-LEXV:"

<ROUTINE INBUF-ADD (LEN BEG SLOT "AUX" DBEG (CTR 0) TMP)
	 <COND (<SET TMP <GET ,OOPS-TABLE ,O-END>>
		<SET DBEG .TMP>)
	       (T
		<SET TMP <GET ,OOPS-TABLE ,O-LENGTH>>
		<SET DBEG <+ <GETB ,AGAIN-LEXV .TMP>
			     <GETB ,AGAIN-LEXV <+ .TMP 1>>>>)>
	 <PUT ,OOPS-TABLE ,O-END <+ .DBEG .LEN>>
	 <REPEAT ()
	  <PUTB ,OOPS-INBUF <+ .DBEG .CTR> <GETB ,P-INBUF <+ .BEG .CTR>>>
	  <SET CTR <+ .CTR 1>>
	  <COND (<EQUAL? .CTR .LEN> <RETURN>)>>
	 <PUTB ,AGAIN-LEXV .SLOT .DBEG>
	 <PUTB ,AGAIN-LEXV <- .SLOT 1> .LEN>>

<ROUTINE FIX-POSSESSIVES (START END "OPTIONAL" (WHERE 0)
				    "AUX" PTR N PNAM PADJ (VAL <>) X)
 <SET PNAM ,P-NAM>
 <SET PADJ ,P-ADJ>
 <SETG P-ADJ <>>
 <SET PTR .END>
 <REPEAT ()
	<SET PTR <- .PTR ,P-LEXELEN>>
	<COND (<==? .PTR .START> <RETURN>)
	      (<==? <GET ,P-LEXV .PTR> ,W?APOSTROPHE>
	       <SETG P-NAM <GET ,P-LEXV <- .PTR ,P-LEXELEN>>>
	       <SET N ,RHINO-HEAD-C ;,CHARACTER-MAX>
	       <REPEAT ()
		       <COND (<AND <T? ,P-NAM>
				   <THIS-IT? <GET ,CHARACTER-TABLE .N>>>
			      <THIS-IS-IT <GET ,CHARACTER-TABLE .N>>
			      <SET VAL <GET ,CHAR-POSS-TABLE <+ 1 .N>>>
			      <CHANGE-LEXV ;.PTR <- .PTR .WHERE> .VAL>
			      <RETURN>)
			     (<DLESS? N 0 ;1>
			      <RETURN>)>>
	       <COND (<NOT <L? .N 0 ;1>> <AGAIN>)>
	       <COND (<NAME? <- .PTR ,P-LEXELEN>>
		      <CHANGE-LEXV ;.PTR <- .PTR .WHERE> ,W?MY>
		      <AGAIN>)>
	       <SET N <GET ,QWP1-TABLE 0>>
	       <SET X <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
	       <REPEAT ()
		<COND (<AND <==? <GET ,QWP1-TABLE .N> ,P-NAM>
			    <==? <GET ,QWP2-TABLE .N> .X>>
		       <QUESTION-WORD? ,P-NAM T>
		       <RTRUE>)
		      (<DLESS? N 1> <RETURN>)>>
	       ;<UNKNOWN-WORD .PTR ,P-LEXELEN>)>>
 ;%<DEBUG-CODE <COND (<T? .VAL> <PRINT-LEXV .PTR>)>>
 <SETG P-NAM .PNAM>
 <SETG P-ADJ .PADJ>
 <RETURN .VAL>>

<ROUTINE NAME? (PTR)
	<OR <XNAME? .PTR ,FIRST-NAME>
	    <XNAME? .PTR ,LAST-NAME>
	    <XNAME? .PTR ,FAVE-COLOR>>>

<ROUTINE XNAME? (PTR TBL "AUX" MAX CNT BPTR CHR (N? T) (NCNT 0))
	 <SET BPTR <REST ,P-LEXV <* .PTR 2>>>
	 <SET CNT <GETB .BPTR 2>>
	 <COND (<G? .CNT 6>
		<SET CNT 6>)>
	 <SET BPTR <GETB .BPTR 3>>
	 <SET MAX <GETB .TBL 0>>
	 <COND (<NOT <L? .MAX 7>>
		<SET MAX 6>)>
	 ;%<DEBUG-CODE <COND (,DBUG <TELL "{Namelen=" N .MAX "}" CR>)>>
	 <REPEAT ()
		 <COND (<IGRTR? NCNT .MAX>
			;%<DEBUG-CODE <COND (,DBUG
			      <TELL "{NCNT=" N .NCNT " CNT=" N .CNT "}" CR>)>>
			<COND (<NOT <0? .CNT>> <SET N? <>>)>
			<RETURN>)
		       (<DLESS? CNT 0>
			;%<DEBUG-CODE <COND (,DBUG
					    <TELL "{CNT=" N .CNT "}" CR>)>>
			<SET N? <>>
			<RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			;%<DEBUG-CODE <COND (,DBUG <TELL "{CHR=" N .CHR>)>>
			<COND (<NOT <EQUAL? .CHR 45 39 38>>
			       <SET CHR <+ *140* <MOD .CHR 32>>>
			       ;%<DEBUG-CODE <COND (,DBUG
						   <TELL "->" N .CHR>)>>)>
			;%<DEBUG-CODE <COND (,DBUG
			      <TELL " Namechr=" N <GETB .TBL .NCNT> "}" CR>)>>
			<COND (<NOT <==? .CHR <GETB .TBL .NCNT>>>
			       <SET N? <>>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <COND (.N?
		<COND (<==? .TBL ,FIRST-NAME>
		       <CHANGE-LEXV .PTR ,W?F.N>
		       ,W?F.N)
		      (<==? .TBL ,FAVE-COLOR>
		       <CHANGE-LEXV .PTR ,W?F.C>
		       ,W?F.C)
		      (T
		       <CHANGE-LEXV .PTR ,W?L.N>
		       ,W?L.N)>)>>

"Check whether word pointed at by PTR is the correct part of speech.
   The second argument is the part of speech (,PS?<part of speech>).  The
   3rd argument (,P1?<part of speech>), if given, causes the value
   for that part of speech to be returned."

<ROUTINE WT? (PTR BIT "OPTIONAL" (B1 5) "AUX" (OFFS ,P-P1OFF) TYP)
	<COND (<BTST <SET TYP <GETB .PTR ,P-PSOFF>> .BIT>
	       <COND (<G? .B1 4> <RTRUE>)
		     (<EQUAL? .BIT ,PS?OBJECT> 1)	;"NEW-VOC"
		     (T
		      <SET TYP <BAND .TYP ,P-P1BITS>>
		      <COND (<NOT <EQUAL? .TYP .B1>> <SET OFFS <+ .OFFS 1>>)>
		      <GETB .PTR .OFFS>)>)>>

"Scan through a noun phrase, leaving a pointer to its starting location:"

<ROUTINE CLAUSE (PTR VAL WRD "AUX" OFF NUM (ANDFLG <>) (FIRST?? T) NW (LW 0))
	<SET OFF <* <- ,P-NCN 1> 2>>
	<COND (<NOT <==? .VAL 0>>
	       <PUT ,P-ITBL <SET NUM <+ ,P-PREP1 .OFF>> .VAL>
	       <PUT ,P-ITBL <+ .NUM 1> .WRD>
	       <SET PTR <+ .PTR ,P-LEXELEN>>)
	      (T <SETG P-LEN <+ ,P-LEN 1>>)>
	<COND (<0? ,P-LEN> <SETG P-NCN <- ,P-NCN 1>> <RETURN -1>)>
	<PUT ,P-ITBL <SET NUM <+ ,P-NC1 .OFF>> <REST ,P-LEXV <* .PTR 2>>>
	<COND (<EQUAL? <GET ,P-LEXV .PTR> ,W?THE ,W?A ,W?AN>
	       <PUT ,P-ITBL .NUM <REST <GET ,P-ITBL .NUM> 4>>)>
	<REPEAT ()
		<COND (<L? <SETG P-LEN <- ,P-LEN 1>> 0>
		       <PUT ,P-ITBL <+ .NUM 1> <REST ,P-LEXV <* .PTR 2>>>
		       <RETURN -1>)>
		<COND (<OR <T? <SET WRD <GET ,P-LEXV .PTR>>>
			   <SET WRD <NUMBER? .PTR>>
			   <SET WRD <NAME? .PTR>>>
		       <COND (<0? ,P-LEN> <SET NW 0>)
			     (T
			      <SET NW <GET ,P-LEXV <+ .PTR ,P-LEXELEN>>>
			      <COND (<ZERO? .NW>	;"added 8/14/86 SWG"
				     <SET NW <NUMBER? <+ .PTR ,P-LEXELEN>>>)>)>
		       ;<COND (<AND <==? .WRD ,W?OF>
				   <EQUAL? <GET ,P-ITBL ,P-VERB>
					   ,ACT?MAKE ,ACT?TAKE>>
			      <CHANGE-LEXV .PTR ,W?WITH>
			      <SET WRD ,W?WITH>)>
		       <COND (<AND <EQUAL? .WRD ,W?PERIOD>
				   <OR <EQUAL? .LW ,W?MRS ,W?MR ,W?MS>
				       <EQUAL? .LW ,W?DR ;,W?LT>>>
			      <SET LW 0>)
			     (<EQUAL? .WRD ,W?AND ,W?COMMA> <SET ANDFLG T>)
			     (<EQUAL? .WRD ,W?ALL ;,W?BOTH ,W?ONE>
			      <COND (<==? .NW ,W?OF>
				     <SETG P-LEN <- ,P-LEN 1>>
				     <SET PTR <+ .PTR ,P-LEXELEN>>)>)
			     (<OR <EQUAL? .WRD ,W?THEN ,W?PERIOD>
				  <EQUAL? .WRD ,W?\! ,W??>
				  <AND <WT? .WRD ,PS?PREPOSITION>
				       <GET ,P-ITBL ,P-VERB>
				       <NOT .FIRST??>>>
			      <SETG P-LEN <+ ,P-LEN 1>>
			      <PUT ,P-ITBL
				   <+ .NUM 1>
				   <REST ,P-LEXV <* .PTR 2>>>
			      <RETURN <- .PTR ,P-LEXELEN>>)
			     ;"3/16/83: This clause used to be later."
			     (<AND .ANDFLG
				   <OR <EQUAL? <GET ,P-ITBL ,P-VERBN> 0>
				       <VERB-DIR-ONLY? .WRD>>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?OBJECT>
			      <COND (<AND <G? ,P-LEN 0>
					  <EQUAL? .NW ,W?OF>
					  <NOT <EQUAL? .WRD ,W?ALL ,W?ONE>>>
				     <PUT ,P-OFW <- ,P-NCN 1> .WRD>)
				    (<AND <WT? .WRD ,PS?ADJECTIVE>
					  <T? .NW>
					  <NOT <WT? .NW ,PS?DIRECTION>>
						;"DRIVE CAR SOUTH"
					  <OR <WT? .NW ,PS?OBJECT>
					      <WT? .NW ,PS?ADJECTIVE>>>)
				    (<AND <NOT .ANDFLG>
					  <NOT <EQUAL? .NW ,W?BUT ,W?EXCEPT>>
					  <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
				     <PUT ,P-ITBL
					  <+ .NUM 1>
					  <REST ,P-LEXV <* <+ .PTR 2> 2>>>
				     <RETURN .PTR>)
				    (T <SET ANDFLG <>>)>)
			     (<WT? .WRD ,PS?ADJECTIVE>)
			     (<WT? .WRD ,PS?BUZZ-WORD>
			      <COND (<BUZZER-WORD? .WRD .PTR>
				     <RFALSE>)>)
			     (<AND .ANDFLG
				   <EQUAL? <GET ,P-ITBL ,P-VERB> 0>>
			      <SET PTR <- .PTR 4>>
			      <CHANGE-LEXV <+ .PTR 2> ,W?THEN>
			      <SETG P-LEN <+ ,P-LEN 2>>)
			     (<WT? .WRD ,PS?PREPOSITION> T)
			     (T
			      <CANT-USE .PTR>
			      <RFALSE>)>)
		      (T <UNKNOWN-WORD .PTR> <RFALSE>)>
		<SET LW .WRD>
		<SET FIRST?? <>>
		<SET PTR <+ .PTR ,P-LEXELEN>>>> 

<ROUTINE VERB-DIR-ONLY? (WRD)
	<AND <NOT <WT? .WRD ,PS?OBJECT>>
	     <NOT <WT? .WRD ,PS?ADJECTIVE>>
	     <OR <WT? .WRD ,PS?DIRECTION>
		 <WT? .WRD ,PS?VERB>>>>

<ROUTINE NUMBER? (PTR "AUX" CNT BPTR CHR (SUM 0) (TIM <>) TMP)
	 <SET TMP <REST ,P-LEXV <* .PTR 2>>>
	 <SET CNT  <GETB .TMP 2>>
	 <SET BPTR <GETB .TMP 3>>
	 <REPEAT ()
		 <COND (<L? <SET CNT <- .CNT 1>> 0> <RETURN>)
		       (T
			<SET CHR <GETB ,P-INBUF .BPTR>>
			<COND (<==? .CHR %<ASCII !\:>>
			       <SET TIM .SUM>
			       <SET SUM 0>)
			      (<G? .SUM 29999> <RFALSE>)
			      (<OR <G? .CHR %<ASCII !\9>>
				   <L? .CHR %<ASCII !\0>>>
			       <RFALSE>)
			      (T
			       <SET SUM <+ <* .SUM 10>
					   <- .CHR %<ASCII !\0>>>>)>
			<SET BPTR <+ .BPTR 1>>)>>
	 <CHANGE-LEXV .PTR ,W?INT.NUM ;NUMBER>
	 <COND (<G? .SUM 9999> <RFALSE>)
	       (.TIM
		<COND (<G? .TIM 23> <RFALSE>)>
		<SET SUM <+ .SUM <* .TIM 60>>>)>
	 <SETG P-TIME .TIM>
	 <SETG P-NUMBER .SUM>
	 ,W?INT.NUM>

<GLOBAL P-NUMBER:NUMBER -1>
<GLOBAL P-TIME:FLAG <>>
<GLOBAL P-DIRECTION 0>

<ROUTINE ORPHAN-MERGE ("AUX" (CNT -1) TEMP VERB BEG END
		       (ADJ <>) (ADJB <>) (VRB <>) (NOUN <>) ADJE WRD) 
   <SETG P-OFLAG <>>
   <COND (<AND <SET WRD <GET ,P-ITBL ,P-VERBN>>
	       <SET WRD <GET .WRD 0>>>
	  <COND (<EQUAL? <WT? .WRD ,PS?VERB ,P1?VERB>
			 <GET ,P-OTBL ,P-VERB>>
		 <SET VRB T>)>
	  <COND (<WT? .WRD ,PS?ADJECTIVE>
		 <SET ADJ T>)>
	  <COND (<WT? .WRD ,PS?OBJECT>
		 <SET NOUN T>)>)>
   <COND (<AND <NOT .VRB> ;"convert apparent verb into noun clause"
	       <NOT .ADJ>
	       <WT? .WRD ,PS?OBJECT ,P1?OBJECT>
	       <EQUAL? ,P-NCN 0>>
	  <PUT ,P-ITBL ,P-VERB 0>
	  <PUT ,P-ITBL ,P-VERBN 0>
	  <PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV <* 2 ,P-LEXSTART>>>
	  <PUT ,P-ITBL ,P-NC1L <REST ,P-LEXV <+ ,P-WORDLEN <* 2 ,P-LEXSTART>>>>
	  <SETG P-NCN 1>)>
   <COND (<AND <NOT <ZERO? <SET VERB <GET ,P-ITBL ,P-VERB>>>>
	       <NOT .ADJ>
	       <NOT .VRB>
	       <NOT <EQUAL? .VERB <GET ,P-OTBL ,P-VERB>>>>
	  <RFALSE>)
	 (<EQUAL? ,P-NCN 2> <RFALSE>)
	 (<EQUAL? <GET ,P-OTBL ,P-NC1> 1>
	  <COND (<EQUAL? <GET ,P-ITBL ,P-PREP1>
			 0
			 <GET ,P-OTBL ,P-PREP1>>
		 <COND (.ADJ
			<PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV <* 2 ,P-LEXSTART>>>
			<COND (<ZERO? <GET ,P-ITBL ,P-NC1L>>
			       <PUT ,P-ITBL ,P-NC1L
				    <REST ,P-LEXV <+ ,P-WORDLEN
						     <* 2 ,P-LEXSTART>>>>)>
			<COND (<ZERO? ,P-NCN> <SETG P-NCN 1>)>)>
		 <PUT ,P-OTBL ,P-NC1 <GET ,P-ITBL ,P-NC1>>
		 <PUT ,P-OTBL ,P-NC1L <GET ,P-ITBL ,P-NC1L>>)
		(T <RFALSE>)>)
	 (<EQUAL? <GET ,P-OTBL ,P-NC2> 1>
	  <COND (<EQUAL? <GET ,P-ITBL ,P-PREP1>
			 <>
			 <GET ,P-OTBL ,P-PREP2>>
		 <COND (<OR .ADJ
			    <AND <ZERO? ,P-NCN> .NOUN>>
			<PUT ,P-ITBL ,P-NC1 <REST ,P-LEXV <* 2 ,P-LEXSTART>>>
			<COND (<ZERO? <GET ,P-ITBL ,P-NC1L>>
			       <PUT ,P-ITBL ,P-NC1L
				    <REST ,P-LEXV <+ ,P-WORDLEN
						     <* 2 ,P-LEXSTART>>>>)>)>
		 <PUT ,P-OTBL ,P-NC2 <GET ,P-ITBL ,P-NC1>>
		 <PUT ,P-OTBL ,P-NC2L <GET ,P-ITBL ,P-NC1L>>
		 <SETG P-NCN 2>)
		(T <RFALSE>)>)
	 (,P-ACLAUSE
	  <COND (<AND <NOT <EQUAL? ,P-NCN 1>> <NOT .ADJ>>
		 <SETG P-ACLAUSE <>>
		 <RFALSE>)
		(T
		 <SET BEG <GET ,P-ITBL ,P-NC1>>
		 <COND (.ADJ
			<SET BEG <REST ,P-LEXV <* 2 ,P-LEXSTART>>>
			<PUT ,P-ITBL ,P-NC1 .BEG>
			<SET ADJ <>>)>
		 <SET END <GET ,P-ITBL ,P-NC1L>>
		 <REPEAT ()
			 <COND (<EQUAL? .BEG .END>
				<COND (.ADJB <CLAUSE-WIN .ADJB .ADJE> <RETURN>)
				      (T
				       <SETG P-ACLAUSE <>>
				       <RFALSE>)>)>
			 <SET WRD <GET .BEG 0>>
			 <COND (<OR <EQUAL? .WRD ,W?ALL ,W?ONE> 
				    <AND <BTST <GETB .WRD ,P-PSOFF>
					       ,PS?ADJECTIVE> ;"same as WT?"
					 <ADJ-CHECK .WRD .ADJ .ADJ>>>
				<COND (<NOT .ADJB> <SET ADJB .BEG>)>
				<SET ADJ .WRD>
				<SET ADJE <REST .BEG ,P-WORDLEN>>)
			       (<AND <BTST <GETB .WRD ,P-PSOFF> ,PS?OBJECT>
				     <EQUAL? <+ .BEG ,P-WORDLEN> .END>>
				<COND (<AND ,P-ANAM
					    <NOT <EQUAL? .WRD ,P-ANAM>>>
				       <SETG P-ANAM <>>
				       <SET ADJB <GET ,P-ITBL ,P-NC1>>
				       <SET ADJE .END>)>)>
			 <SET BEG <REST .BEG ,P-WORDLEN>>
			 <COND (<EQUAL? .END 0>
				<SET END .BEG>
				<SETG P-NCN 1>
				<PUT ,P-ITBL ,P-NC1 <BACK .BEG ,P-WORDLEN>>
				<PUT ,P-ITBL ,P-NC1L .BEG>)>>)>)>
   <PUT ,P-VTBL 0 <GET ,P-OVTBL 0>>
   <PUTB ,P-VTBL 2 <GETB ,P-OVTBL 2>>
   <PUTB ,P-VTBL 3 <GETB ,P-OVTBL 3>>
   <PUT ,P-OTBL ,P-VERBN ,P-VTBL>
   <PUTB ,P-VTBL 2 0>
   ;<AND <NOT <EQUAL? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
   <REPEAT ()
	   <COND (<G? <SET CNT <+ .CNT 1>> ,P-ITBLLEN>
		  <SETG P-MERGED T>
		  <RTRUE>)
		 (T <PUT ,P-ITBL .CNT <GET ,P-OTBL .CNT>>)>>
   T>

<ROUTINE CLAUSE-WIN ("OPT" (ADJB <>) (ADJE <>)) 
	<COND (.ADJB
	       <PUT ,P-ITBL ,P-VERB <GET ,P-OTBL ,P-VERB>>)>
	<PUT ,P-CCTBL ,CC-BEG ,P-ACLAUSE>
	<PUT ,P-CCTBL ,CC-END <+ ,P-ACLAUSE 1>>
	<PUT ,P-CCTBL ,CC-IBEG .ADJB>
	<PUT ,P-CCTBL ,CC-IEND .ADJE>
	<COND (<EQUAL? ,P-ACLAUSE ,P-NC1>
	       <PUT ,P-CCTBL ,CC-CLAUSE ,P-OCL1>)
	      (ELSE
	       <PUT ,P-CCTBL ,CC-CLAUSE ,P-OCL2>)>
	<CLAUSE-COPY ,P-OTBL ,P-OTBL>
	<AND <NOT <EQUAL? <GET ,P-OTBL ,P-NC2> 0>> <SETG P-NCN 2>>
	<SETG P-ACLAUSE <>>
	<RTRUE>>

"Print undefined word in input. PTR points to the unknown word in P-LEXV:"   

<ROUTINE WORD-PRINT (CNT BUF "OPTIONAL" (TBL 0))
	 ;<COND (<G? .CNT 6> <SET CNT 6>)>
	 <COND (<ZERO? .TBL> <SET TBL ,P-INBUF>)>
	 <REPEAT ()
		 <COND (<DLESS? CNT 0> <RETURN>)
		       (ELSE
			<PRINTC <GETB .TBL .BUF>>
			<SET BUF <+ .BUF 1>>)>>>

<ROUTINE UNKNOWN-WORD (PTR ;"OPT" ;(APOST 0) "AUX" BUF)
	<PUT ,OOPS-TABLE ,O-PTR .PTR ;<- .PTR .APOST>>
	<COND (<T? ,P-OFLAG>
	       <PUT ,OOPS-TABLE ,O-END 0>)>
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL !\[>)
	      ;(T <TELL "\"I'm sorry, but ">)>
	<TELL "I don't know the word ">
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL !\">)
	      ;(T <TELL !\'>)>
	<SET BUF <* 2 .PTR ;<- .PTR .APOST>>>
	<WORD-PRINT <GETB <REST ,P-LEXV .BUF> 2>
		    <GETB <REST ,P-LEXV .BUF> 3>>
	;<COND (<T? .APOST>
	       <TELL !\'>
	       <SET BUF <* 2 <+ .PTR ,P-LEXELEN>>>
	       <WORD-PRINT <GETB <REST ,P-LEXV .BUF> 2>
			   <GETB <REST ,P-LEXV .BUF> 3>>)>
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL ".\"]" CR>)
	      ;(T <TELL ".'\"" CR>)>>

<ROUTINE CANT-USE (PTR "AUX" BUF) 
	;#DECL ((PTR BUF) FIX)
	<SETG QUOTE-FLAG <>>
	<SETG P-OFLAG <>>
	<COND (T ;<EQUAL? ,WINNER ,PLAYER>
	       <TELL "[Sorry, but I don't understand the word \"">
	       <WORD-PRINT <GETB <REST ,P-LEXV <SET BUF <* .PTR 2>>> 2>
			   <GETB <REST ,P-LEXV .BUF> 3>>
	       <TELL "\" when you use it that way.]" CR>)
	      ;(T <TELL "\"Please, to me simple English speak.\"" CR>)>>

" Perform syntax matching operations, using P-ITBL as the source of
   the verb and adjectives for this input.  Returns false if no
   syntax matches, and does it's own orphaning.  If return is true,
   the syntax is saved in P-SYNTAX."   

<GLOBAL P-SLOCBITS 0>    

<CONSTANT P-SYNLEN 8>    

<CONSTANT P-SBITS 0> 
<CONSTANT P-SPREP1 1>
<CONSTANT P-SPREP2 2>
<CONSTANT P-SFWIM1 3>
<CONSTANT P-SFWIM2 4>
<CONSTANT P-SLOC1 5>
<CONSTANT P-SLOC2 6>
<CONSTANT P-SACTION 7>   

<CONSTANT P-SONUMS 3>    

<ROUTINE SYNTAX-CHECK ("AUX" SYN LEN NUM OBJ (DRIVE1 <>) (DRIVE2 <>)
			     PREP VERB)
	<COND (<0? <SET VERB <GET ,P-ITBL ,P-VERB>>>
	       <MISSING "verb">
	       <RFALSE>)>
	<SET SYN <GET ,VERBS <- 255 .VERB>>>
	<SET LEN <GETB .SYN 0>>
	<SET SYN <REST .SYN>>
	<REPEAT ()
		<SET NUM <BAND <GETB .SYN ,P-SBITS> ,P-SONUMS>>
		<COND (<G? ,P-NCN .NUM> T) ;"Added 4/27/83"
		      (<AND <NOT <L? .NUM 1>>
			    <0? ,P-NCN>
			    <OR <0? <SET PREP <GET ,P-ITBL ,P-PREP1>>>
				<==? .PREP <GETB .SYN ,P-SPREP1>>>>
		       <SET DRIVE1 .SYN>)
		      (<==? <GETB .SYN ,P-SPREP1> <GET ,P-ITBL ,P-PREP1>>
		       <COND (<AND <==? .NUM 2> <==? ,P-NCN 1>>
			      <SET DRIVE2 .SYN>)
			     (<==? <GETB .SYN ,P-SPREP2>
				   <GET ,P-ITBL ,P-PREP2>>
			      <SYNTAX-FOUND .SYN>
			      <RTRUE>)>)>
		<COND (<DLESS? LEN 1>
		       <COND (<OR <T? .DRIVE1> <T? .DRIVE2>>
			      <RETURN>)
			     (T
			      <DONT-UNDERSTAND>
			      <RFALSE>)>)
		      (T <SET SYN <REST .SYN ,P-SYNLEN>>)>>
	<COND (<AND .DRIVE1
		    <SET OBJ
			 <GWIM <GETB .DRIVE1 ,P-SFWIM1>
			       <GETB .DRIVE1 ,P-SLOC1>
			       <GETB .DRIVE1 ,P-SPREP1>>>>
	       <PUT/B ,P-PRSO ,P-MATCHLEN 1>
	       <PUT/B ,P-PRSO 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE1>)
	      (<AND .DRIVE2
		    <SET OBJ
			 <GWIM <GETB .DRIVE2 ,P-SFWIM2>
			       <GETB .DRIVE2 ,P-SLOC2>
			       <GETB .DRIVE2 ,P-SPREP2>>>>
	       <PUT/B ,P-PRSI ,P-MATCHLEN 1>
	       <PUT/B ,P-PRSI 1 .OBJ>
	       <SYNTAX-FOUND .DRIVE2>)
	      ;(<EQUAL? .VERB ,ACT?FIND ;,ACT?NAME>
	       <TELL "[Sorry, but I can't answer that question.]" CR>
	       <RFALSE>)
	      (T
	       <SET OBJ <>>
	       <COND (<AND <EQUAL? ,WINNER ,PLAYER>
			   <NOT <EQUAL? ,P-PRSA-WORD;"can't orphan DRIVE/SOUTH"
					,W?DRIVE ,W?PROCEED ,W?STEER>>>
		      <ORPHAN .DRIVE1 .DRIVE2>
		      <SET OBJ T>
		      <TELL "[Wh">)
		     (T
		      <TELL
"[Your command was not complete. Next time, type wh">)>
	       <COND (<EQUAL? .VERB ,ACT?HEAD ;WALK>
		      <TELL "ere">)
		     (<OR <AND .DRIVE1
			       <==? <GETB .DRIVE1 ,P-SFWIM1> ,PERSONBIT>>
			  <AND .DRIVE2
			       <==? <GETB .DRIVE2 ,P-SFWIM2> ,PERSONBIT>>>
		      <TELL "om">)
		     (T <TELL "at">)>
	       <COND (<T? .OBJ> ;<EQUAL? ,WINNER ,PLAYER>
		      <TELL " do you want to ">)
		     (T
		      <TELL " you want" HIM ,WINNER " to ">)>
	       <VERB-PRINT>
	       ;<PREP-PRINT <COND (.DRIVE1 <GETB .DRIVE1 ,P-SPREP1 ;2>)
				 (T <GETB .DRIVE2 ,P-SPREP1>)>> ;"not in X1"
	       <COND (.DRIVE2
		      <SET PREP ,P-MERGED>
		      <SETG P-MERGED <>>
		      <SETG P-OFLAG <>>
		      <CLAUSE-PRINT ,P-NC1 ,P-NC1L>
		      <SETG P-MERGED .PREP>)>
	       <SETG P-END-ON-PREP <>>
	       <PREP-PRINT <COND (.DRIVE1 <GETB .DRIVE1 ,P-SPREP1 ;2>)
				 (T <GETB .DRIVE2 ,P-SPREP2>)>>
	       <COND (<T? .OBJ> ;<EQUAL? ,WINNER ,PLAYER>
		      <SETG P-OFLAG T>
		      <TELL "?]" CR>)
		     (T
		      ;<SETG P-OFLAG <>>
		      <TELL ".]" CR>)>
	       <RFALSE>)>>

;<GLOBAL CANT-UNDERSTAND "[Sorry, but I don't understand that sentence.]"
			;"[I couldn't understand that sentence.]">
<ROUTINE DONT-UNDERSTAND ()
	<SETG CLOCK-WAIT T>
	<TELL
"[Sorry, but I don't understand. Please say that another way, or try
something else.]" CR>>

<ROUTINE VERB-PRINT ("OPTIONAL" (GERUND <>) "AUX" TMP)
	<SET TMP <GET ,P-ITBL ,P-VERBN>>	;"? ,P-OTBL?"
	<COND (<==? .TMP 0>
	       <COND (<ZERO? .GERUND> <TELL "tell"> <RTRUE>)
		     (T <TELL "walk">)>)
	      (<OR <T? .GERUND> <0? <GETB ,P-VTBL 2>>>
	       <SET TMP <GET .TMP 0>>
	       <COND (<==? .TMP ,W?L> <PRINTB ,W?LOOK>)
		     (<==? .TMP ,W?X> <PRINTB ,W?EXAMINE>)
		     (<==? .TMP ,W?Z> <PRINTB ,W?WAIT>)
		     (<T? .GERUND>
		      <COND (<==? .TMP ,W?BATHE> <PRINTB ,W?BATH>)
			    (<==? .TMP ,W?DIG> <PRINTI "digg">)
			    (<==? .TMP ,W?GET> <PRINTI "gett">)
			    (T <PRINTB .TMP>)>)
		     (T <PRINTB .TMP>)>)
	      (T
	       <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>
	       <PUTB ,P-VTBL 2 0>)>
	<COND (<T? .GERUND> <TELL "ing?">)>>

<ROUTINE ORPHAN (D1 D2 "AUX" (CNT -1))
	<COND (<NOT ,P-MERGED>
	       <PUT ,P-OCL1 ,P-MATCHLEN 0>
	       <PUT ,P-OCL2 ,P-MATCHLEN 0>)>
	<PUT ,P-OVTBL 0 <GET ,P-VTBL 0>>
	<PUTB ,P-OVTBL 2 <GETB ,P-VTBL 2>>
	<PUTB ,P-OVTBL 3 <GETB ,P-VTBL 3>>
	<REPEAT ()
		<COND (<IGRTR? CNT ,P-ITBLLEN> <RETURN>)
		      (T <PUT ,P-OTBL .CNT <GET ,P-ITBL .CNT>>)>>
	<COND (<EQUAL? ,P-NCN 2>
	       <PUT ,P-CCTBL ,CC-BEG ,P-NC2>
	       <PUT ,P-CCTBL ,CC-END ,P-NC2L>
	       <PUT ,P-CCTBL ,CC-CLAUSE ,P-OCL2>
	       <PUT ,P-CCTBL ,CC-IBEG <>>
	       <PUT ,P-CCTBL ,CC-IEND <>>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL>)>
	<COND (<NOT <L? ,P-NCN 1>>
	       <PUT ,P-CCTBL ,CC-BEG ,P-NC1>
	       <PUT ,P-CCTBL ,CC-END ,P-NC1L>
	       <PUT ,P-CCTBL ,CC-CLAUSE ,P-OCL1>
	       <PUT ,P-CCTBL ,CC-IBEG <>>
	       <PUT ,P-CCTBL ,CC-IEND <>>
	       <CLAUSE-COPY ,P-ITBL ,P-OTBL>)>
	<COND (.D1
	       <PUT ,P-OTBL ,P-PREP1 <GETB .D1 ,P-SPREP1>>
	       <PUT ,P-OTBL ,P-NC1 1>)
	      (.D2
	       <PUT ,P-OTBL ,P-PREP2 <GETB .D2 ,P-SPREP2>>
	       <PUT ,P-OTBL ,P-NC2 1>)>>

<ROUTINE CLAUSE-PRINT (BPTR EPTR "OPTIONAL" (THE? T)) 
	<BUFFER-PRINT <GET ,P-ITBL .BPTR> <GET ,P-ITBL .EPTR> .THE?>>    

<ROUTINE BUFFER-PRINT (BEG END CP "AUX" (NOSP <>) WRD NW (FIRST?? T) (PN <>))
 <REPEAT ()
	 <COND (<==? .BEG .END> <RETURN>)>
	 <COND (<OR <T? .NOSP>
		    <EQUAL? .WRD ,W?APOSTROPHE>
		    <EQUAL? .NW ,W?PERIOD ,W?COMMA ,W?APOSTROPHE>>
		<SET NOSP <>>)
	       (T <TELL !\ >)>
	 <SET WRD <GET .BEG 0>>
	 ;<SET NW <GET .BEG ,P-LEXELEN>>
	 <COND (<==? .END <REST .BEG ,P-WORDLEN>>
		<SET NW 0>)
	       (T <SET NW <GET .BEG ,P-LEXELEN>>)>
	 <COND (<AND <NOT <==? .WRD ,W?MY>>
		     <ZMEMQ .WRD ,CHAR-POSS-TABLE>>
		<SET NOSP T>)
	       (<AND <NOT <==? .NW ,W?MY>>
		     <ZMEMQ .NW ,CHAR-POSS-TABLE>>
		<SET NOSP T>)
	       (<AND <T? ,OOPS-PRINT>
		     <OR <AND <EQUAL? .WRD ,W?HIM>
			      <NOT <VISIBLE? ,P-HIM-OBJECT>>>
			 <AND <EQUAL? .WRD ,W?HER>
			      <NOT <VISIBLE? ,P-HER-OBJECT>>>
			 ;<AND <EQUAL? .WRD ,W?THEM>
			      <NOT <VISIBLE? ,P-THEM-OBJECT>>>>>
		<SET PN T>)>
	 <COND ;(<EQUAL? .WRD ,W?PERIOD ,W?\! ,W??>
		<SET NOSP T>)
	       (<EQUAL? .WRD ,W?MY>
		<COND (<ZERO? ,OOPS-PRINT>
		       <PRINTB ,W?YOUR>)
		      (T <PRINTB ,W?MY>)>
		;<SET NOSP T>)
	       (<ZMEMQ .WRD ,CHAR-POSS-TABLE>
		<TELL !\'>)
	       (<AND <ZERO? ,OOPS-PRINT>
		     <NOT <EQUAL? .WRD ,W?ALL ,W?PERIOD ,W?APOSTROPHE>>
		     <OR <WT? .WRD ,PS?BUZZ-WORD>
			 <WT? .WRD ,PS?PREPOSITION>>
		     <NOT <WT? .WRD ,PS?ADJECTIVE>>
		     <NOT <WT? .WRD ,PS?OBJECT>>>
		<SET NOSP T>)
	       (<AND <EQUAL? .WRD ,W?ME>
		     <ZERO? ,OOPS-PRINT>>
		<PRINTD ,PLAYER>
		<SET PN T>)
	       (<CAPITAL-NOUN? .WRD>
		<CAPITALIZE .BEG>
		<SET PN T>)
	       (T
		<COND (<AND .FIRST?? <NOT .PN> .CP>
		       <COND (<NOT <EQUAL? .WRD ,W?HER ,W?HIM ,W?YOUR;,W?THEM>>
			      <TELL "the ">)>)>
		<COND (<OR <T? ,P-OFLAG> <T? ,P-MERGED>>
		       <PRINTB .WRD>)
		      (<AND <==? .WRD ,W?IT>
			    <VISIBLE? ,P-IT-OBJECT>>
		       <PRINTD ,P-IT-OBJECT>)
		      (<AND <EQUAL? .WRD ,W?HER>
			    <NOT .PN>	;"VISIBLE check above"
			    ;<VISIBLE? ,P-HER-OBJECT>>
		       <PRINTD ,P-HER-OBJECT>)
		      ;(<AND <EQUAL? .WRD ,W?THEM>
			     <NOT .PN>
			     ;<VISIBLE? ,P-THEM-OBJECT>>
			<PRINTD ,P-THEM-OBJECT>)
		      (<AND <EQUAL? .WRD ,W?HIM>
			    <NOT .PN>
			    ;<VISIBLE? ,P-HIM-OBJECT>>
		       <PRINTD ,P-HIM-OBJECT>)
		      (T
		       <WORD-PRINT <GETB .BEG 2> <GETB .BEG 3>>)>
		<SET FIRST?? <>>)>
	 <SET BEG <REST .BEG ,P-WORDLEN>>>>

<ROUTINE TITLE-NOUN? (WRD)
    <OR <EQUAL? .WRD ,W?MR ,W?MRS ,W?MS>
	<EQUAL? .WRD ,W?MISTER ,W?MISS ,W?SIR>
	<EQUAL? .WRD ,W?LADY ,W?DAME ,W?LORD>
	<EQUAL? .WRD ,W?DR ,W?DOCTOR ,W?DETECT>
	<EQUAL? .WRD ,W?MADAME ,W?MADAM ,W?MASTER>
	;<EQUAL? .WRD ,W?LT>>>

<ROUTINE CAPITAL-NOUN? (WRD)
    <OR <TITLE-NOUN? .WRD>
	<EQUAL? .WRD ,W?BOLITHO ,W?DEE>
	<EQUAL? .WRD ,W?DEIRDRE ,W?FORDYCE ,W?HALLAM>
	<EQUAL? .WRD ,W?HYDE ,W?IAN ,W?INDIAN>
	<EQUAL? .WRD ,W?IRIS ,W?JACK ,W?LIONEL>
	<EQUAL? .WRD ,W?LYND ,W?MONTAGUE ,W?MOONMIST>
	<EQUAL? .WRD ,W?NICHOLAS ,W?PENTREATH ,W?TAMARA>
	<EQUAL? .WRD ,W?TAMMY ,W?TRESYLLIAN ,W?VIV>
	<EQUAL? .WRD ,W?VIVIEN ,W?WENDISH>
	;<EQUAL? .WRD ,W?AMAZON ,W?DINGAAN ,W?EGYPTIAN ,W?LONDON ,W?MAYFAIR ,W?PORSCHE ,W?ZULU>>>

<ROUTINE CAPITALIZE (PTR)
	 <COND (<OR <T? ,P-OFLAG> <T? ,P-MERGED>>
		<PRINTB <GET .PTR 0>>)
	       (T
		<PRINTC <- <GETB ,P-INBUF <GETB .PTR 3>> 32>>
		<WORD-PRINT <- <GETB .PTR 2> 1> <+ <GETB .PTR 3> 1>>)>>

<ROUTINE PREP-PRINT (PREP "OPTIONAL" (SP? T) "AUX" WRD VRB)
	<COND (<0? .PREP>
	       <RFALSE>)>
	<SET VRB <GET <GET ,P-ITBL ,P-VERBN> 0>>
	<COND (<AND <T? ,P-END-ON-PREP>
		    <OR <NOT <EQUAL? .VRB ,W?LIE ,W?SIT>>
			<NOT <==? .PREP ,PR?DOWN>>>>
	       <RFALSE>)
	      (T
	       <COND (.SP? <TELL !\ >)>
	       <SET WRD <PREP-FIND .PREP>>
	       <COND (<==? .WRD ,W?AGAINST> <TELL "against">)
		     (<==? .WRD ,W?THROUGH> <TELL "through">)
		     (T <PRINTB .WRD>)>
	       <COND (<AND <EQUAL? .VRB ,W?SIT ,W?LIE>
			   <EQUAL? .WRD ,W?DOWN>>
		      <TELL " on">)>
	       <COND (<AND <EQUAL? .VRB ,W?GET>
			   <EQUAL? .WRD ,W?OUT>>
		      <TELL " of">)>
	       <RTRUE>)>>    

"CLAUSE-COPY"

<GLOBAL P-CCTBL <TABLE 0 0 0 0 0>>

"pointers used by CLAUSE-COPY (source/destination beginning/end pointers)"
<CONSTANT CC-BEG 0>	"slot in source to start from"
<CONSTANT CC-END 1>	"slot in source to end at"
<CONSTANT CC-CLAUSE 2>	"which orphan table to use"
<CONSTANT CC-IBEG 3>	"insertion beginning (from lexv)"
<CONSTANT CC-IEND 4>	"insertion ending"

"do something about duplicate words in clause?"

<ROUTINE CLAUSE-COPY (SRC DEST
		      "AUX" (IBEG <>) IEND OCL BEG END BB EE OBEG CNT B E)
	<SET BB <GET ,P-CCTBL ,CC-BEG>>
	<SET EE <GET ,P-CCTBL ,CC-END>>
	<SET OCL <GET ,P-CCTBL ,CC-CLAUSE>>
	<SET IBEG <GET ,P-CCTBL ,CC-IBEG>>
	<SET IEND <GET ,P-CCTBL ,CC-IEND>>
	<SET BEG <GET .SRC .BB>>
	<SET END <GET .SRC .EE>>
	<SET OBEG <GET .OCL ,P-MATCHLEN>>
	<REPEAT ()
		<COND (<EQUAL? .BEG .END>
		       <COND (<AND .IBEG <NOT ,P-ANAM>>
			      <CLAUSE-SUBSTRUC .IBEG .IEND>)>
		       <RETURN>)>
		<COND (<AND .IBEG
			    <EQUAL? ,P-ANAM <GET .BEG 0>>>
		       <CLAUSE-SUBSTRUC .IBEG .IEND>)>
		<CLAUSE-ADD <GET .BEG 0>>
		<SET BEG <REST .BEG ,P-WORDLEN>>>
	<COND (<AND <G? .OBEG 0>
		    <G? <SET CNT <- <GET .OCL ,P-MATCHLEN> .OBEG>> 0>>
	       <PUT .OCL ,P-MATCHLEN 0>
	       <SET OBEG <+ .OBEG 1>>
	       <REPEAT ()
		       <CLAUSE-ADD <GET .OCL .OBEG> T>
		       <COND (<ZERO? <SET CNT <- .CNT 2>>>
			      <RETURN>)>
		       <SET OBEG <+ .OBEG 2>>>
	       <SET OBEG 0>)>
	<PUT .DEST
	     .BB
	     <REST .OCL <+ <* .OBEG ,P-LEXELEN> 2>>>
	<PUT .DEST
	     .EE
	     <REST .OCL
		   <+ <* <GET .OCL ,P-MATCHLEN> ,P-LEXELEN> 2>>>>

<ROUTINE CLAUSE-SUBSTRUC (B E)
	 <REPEAT ()
		 <COND (<EQUAL? .B .E> <RETURN>)>
		 <CLAUSE-ADD <GET .B 0>>
		 <SET B <REST .B ,P-WORDLEN>>>>

<ROUTINE CLAUSE-ADD (WRD "OPT" (CHECK? <>) "AUX" OCL PTR)
	<SET OCL <GET ,P-CCTBL ,CC-CLAUSE>>
	<SET PTR <GET .OCL ,P-MATCHLEN>>
	<COND (<AND .CHECK? <NOT <ZERO? .PTR>> <ZMEMQ .WRD .OCL>>
	       <RFALSE>)
	      (ELSE
	       <SET PTR <+ .PTR 2>>
	       <PUT .OCL <- .PTR 1> .WRD>
	       <PUT .OCL .PTR 0>
	       <PUT .OCL ,P-MATCHLEN .PTR>)>>

<ROUTINE PREP-FIND (PREP "AUX" (CNT 0) SIZE) 
	;#DECL ((PREP CNT SIZE) FIX)
	<SET SIZE <* <GET ,PREPOSITIONS 0> 2>>
	<REPEAT ()
		<COND (<IGRTR? CNT .SIZE> <RFALSE>)
		      (<==? <GET ,PREPOSITIONS .CNT> .PREP>
		       <RETURN <GET ,PREPOSITIONS <- .CNT 1>>>)>>>  
 
<ROUTINE SYNTAX-FOUND (SYN) 
	;#DECL ((SYN) <PRIMTYPE VECTOR>)
	<SETG P-SYNTAX .SYN>
	<SETG PRSA <GETB .SYN ,P-SACTION>>>   
 
<GLOBAL P-GWIMBIT 0>
 
<ROUTINE GWIM (GBIT LBIT PREP "AUX" OBJ ;WPREP)
	;#DECL ((GBIT LBIT) FIX (OBJ) OBJECT)
	<COND (<==? .GBIT ,RMUNGBIT>
	       <RETURN ,ROOMS>)>
	<SETG P-GWIMBIT .GBIT>
	<SETG P-SLOCBITS .LBIT>
	<PUT/B ,P-MERGE ,P-MATCHLEN 0>
	<COND (<GET-OBJECT ,P-MERGE <>>
	       <SETG P-GWIMBIT 0>
	       <COND (<==? <GET/B ,P-MERGE ,P-MATCHLEN> 1>
		      <SET OBJ <GET/B ,P-MERGE 1>>
		      <TELL !\(>
		      <COND (<PREP-PRINT .PREP <>>
			     <THE? .OBJ>
			     <TELL !\ >)>
		      <TELL D .OBJ !\) CR>
		      .OBJ)>)
	      (T <SETG P-GWIMBIT 0> <RFALSE>)>>   

<GLOBAL P-PHR:NUMBER 0>		"Which noun phrase is being parsed?"
<GLOBAL P-NAMW <TABLE 0 0>>	"noun for PRSO & PRSI"
<GLOBAL P-ADJW <TABLE 0 0>>	"adjective for ditto"
<GLOBAL P-OFW  <TABLE 0 0>>	"noun before OF for ditto"
<VOC "FRONT" NOUN>		"to make P-OFW work"

<ROUTINE SNARF-OBJECTS ("AUX" PTR)
	<COND (<NOT <==? <SET PTR <GET ,P-ITBL ,P-NC1>> 0>>
	       <SETG P-PHR 0>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC1>>
	       <COND (<NOT <SNARFEM .PTR <GET ,P-ITBL ,P-NC1L> ,P-PRSO>>
		      <RFALSE>)>
	       <COND (<T? <GET/B ,P-BUTS ,P-MATCHLEN>>
		      <SETG P-PRSO <BUT-MERGE ,P-PRSO>>)>)>
	<COND (<NOT <==? <SET PTR <GET ,P-ITBL ,P-NC2>> 0>>
	       <SETG P-PHR 1>
	       <SETG P-SLOCBITS <GETB ,P-SYNTAX ,P-SLOC2>>
	       <COND (<NOT <SNARFEM .PTR <GET ,P-ITBL ,P-NC2L> ,P-PRSI>>
		      <RFALSE>)>
	       <COND (<NOT <0? <GET/B ,P-BUTS ,P-MATCHLEN>>>
		      <COND (<==? <GET/B ,P-PRSI ,P-MATCHLEN> 1>
			     <SETG P-PRSO <BUT-MERGE ,P-PRSO>>)
			    (T <SETG P-PRSI <BUT-MERGE ,P-PRSI>>)>)>)>
	<RTRUE>>  

<ROUTINE BUT-MERGE (TBL "AUX" LEN BUTLEN (CNT 1) (MATCHES 0) OBJ NTBL)
	<SET LEN <GET/B .TBL ,P-MATCHLEN>>
	<PUT/B ,P-MERGE ,P-MATCHLEN 0>
	;<SET LB <GET/B ,P-BUTS ,P-MATCHLEN>>
	<REPEAT ()
	 <COND (<DLESS? LEN 0> <RETURN>)
	       (<NOT <ZMEMQ/B <SET OBJ <GET/B .TBL .CNT>> ,P-BUTS>>
		<SET MATCHES <+ .MATCHES 1>>
		<PUT/B ,P-MERGE .MATCHES .OBJ>)>
	 <SET CNT <+ .CNT 1>>>
	<PUT/B ,P-MERGE ,P-MATCHLEN .MATCHES>
	<SET NTBL ,P-MERGE>
	<SETG P-MERGE .TBL>
	.NTBL>    
 
<GLOBAL P-NAM <>>
<GLOBAL P-XNAM <>>

<GLOBAL P-ADJ:NUMBER <>>
<GLOBAL P-XADJ:NUMBER <>>

<GLOBAL P-ADJN <>>
<GLOBAL P-XADJN <>>

"These three must be same length:"
<GLOBAL P-MERGE	<ITABLE 45 (BYTE) 0> ;<ITABLE NONE 23 ;45>>
<GLOBAL P-PRSO	<ITABLE 45 (BYTE) 0> ;<ITABLE NONE 23 ;45>>
<GLOBAL P-PRSI	<ITABLE 45 (BYTE) 0> ;<ITABLE NONE 23 ;45>>

<GLOBAL P-BUTS	<ITABLE 25 (BYTE) 0> ;<ITABLE NONE 12 ;25>>

<GLOBAL P-OCL1 <ITABLE NONE 25>>
<GLOBAL P-OCL2 <ITABLE NONE 25>>

<CONSTANT P-MATCHLEN 0>    

<GLOBAL P-GETFLAGS 0>    

<CONSTANT P-ALL 1>  
<CONSTANT P-ONE 2>  
<CONSTANT P-INHIBIT 4>   

"<GLOBAL P-CSPTR <>>
<GLOBAL P-CEPTR <>>"
<GLOBAL P-AND:FLAG <>>

"grabs the first adjective, unless it comes across a special-cased adjective:"
<ROUTINE ADJ-CHECK (WRD ADJ "OPT" (NW <>))
	 <COND (<ZERO? .ADJ>
		<RTRUE>)
	       (<EQUAL? .WRD ,W?RHINO ,W?BUFFALO> ;"STUFFED x HEAD"
		<RTRUE>)
	       (<EQUAL? .WRD ,W?BLOND ,W?BLONDE> ;"TALL BLOND(E) MAN"
		<RTRUE>)
	       (<EQUAL? .WRD ,W?FIRST ,W?SECOND>;"x CONTACT LENS (why needed?)"
		<RTRUE>)
	       (<EQUAL? .NW ,W?OUTFIT> ;"MY x OUTFIT"
		<RTRUE>)
	       (<ZMEMQ .WRD ,CHAR-POSS-TABLE>
		<RTRUE>)>>

<ROUTINE SNARFEM (PTR EPTR TBL
		  "AUX" (BUT <>) LEN WV WRD NW (WAS-ALL <>) ONEOBJ) 
   ;"Next SETG 6/21/84 for WHICH retrofix"
   <SETG P-NAM <>>
   <SETG P-ADJ <>>
   <SETG P-ADJN <>>
   <SETG P-AND <>>
   <COND (<EQUAL? ,P-GETFLAGS ,P-ALL>
	  <SET WAS-ALL T>)>
   <SETG P-GETFLAGS 0>
   ;"<SETG P-CSPTR .PTR>
   <SETG P-CEPTR .EPTR>"
   <PUT/B ,P-BUTS ,P-MATCHLEN 0>
   <PUT/B .TBL ,P-MATCHLEN 0>
   <SET WRD <GET .PTR 0>>
   <REPEAT ()
	   <COND (<==? .PTR .EPTR>
		  <SET WV <GET-OBJECT <OR .BUT .TBL>>>
		  <COND (.WAS-ALL <SETG P-GETFLAGS ,P-ALL>)>
		  <RETURN .WV>)
		 (T
		  <COND (<==? .EPTR <REST .PTR ,P-WORDLEN>>
			 <SET NW 0>)
			(T <SET NW <GET .PTR ,P-LEXELEN>>)>
		  <COND (<EQUAL? .WRD ,W?ALL ;,W?BOTH>
			 <SETG P-GETFLAGS ,P-ALL>
			 <COND (<==? .NW ,W?OF>
				<SET PTR <REST .PTR ,P-WORDLEN>>)>)
			(<EQUAL? .WRD ,W?BUT ,W?EXCEPT>
			 <COND (<NOT <GET-OBJECT <OR .BUT .TBL>>>
				<RFALSE>)>
			 <SET BUT ,P-BUTS>
			 <PUT/B .BUT ,P-MATCHLEN 0>)
			(<EQUAL? .WRD ,W?A ,W?ONE>
			 <COND (<ZERO? ,P-ADJ>
				<SETG P-GETFLAGS ,P-ONE>
				<COND (<==? .NW ,W?OF>
				       <SET PTR <REST .PTR ,P-WORDLEN>>)>)
			       (T
				<SETG P-NAM .ONEOBJ>
				<COND (<NOT <GET-OBJECT <OR .BUT .TBL>>>
				       <RFALSE>)>
				<AND <0? .NW> <RTRUE>>)>)
			(<AND <EQUAL? .WRD ,W?AND ,W?COMMA>
			      <NOT <EQUAL? .NW ,W?AND ,W?COMMA>>>
			 ;"Next SETG 6/21/84 for WHICH retrofix"
			 <SETG P-AND T>
			 <COND (<NOT <GET-OBJECT <OR .BUT .TBL>>>
				<RFALSE>)>
			 T)
			(<WT? .WRD ,PS?BUZZ-WORD>
			 <COND (<BUZZER-WORD? .WRD .PTR>
				<RFALSE>)>)
			(<EQUAL? .WRD ,W?AND ,W?COMMA>)
			(<==? .WRD ,W?OF>
			 <COND (<0? ,P-GETFLAGS>
				<SETG P-GETFLAGS ,P-INHIBIT>)>)
			(<AND <SET WV <WT? .WRD ,PS?ADJECTIVE ,P1?ADJECTIVE>>
			      <ADJ-CHECK .WRD ,P-ADJ .NW ;,P-ADJN>
			      <NOT <EQUAL? .NW ,W?OF>>>
			 <SETG P-ADJ .WV>
			 <SETG P-ADJN .WRD>)
			(<WT? .WRD ,PS?OBJECT ;,P1?OBJECT>
			 <SETG P-NAM .WRD>
			 <SET ONEOBJ .WRD>)>)>
	   <COND (<NOT <==? .PTR .EPTR>>
		  <SET PTR <REST .PTR ,P-WORDLEN>>
		  <SET WRD .NW>)>>>

<CONSTANT SH 128>
<CONSTANT SC 64>
<CONSTANT SIR 32>
<CONSTANT SOG 16>
<CONSTANT STAKE 8>
<CONSTANT SMANY 4>
<CONSTANT SHAVE 2>  

<ROUTINE RESOLVE-YOUR-HER-HIS ("AUX" (OBJ 0))
	<COND (<EQUAL? ,P-ADJN ,W?YOUR>
	       <COND (<NOT <==? ,WINNER ,PLAYER>>
		      <SET OBJ ,WINNER>)
		     ;(T <SET OBJ <QCONTEXT-GOOD?>>)>)
	      (<EQUAL? ,P-ADJN ,W?HER>
	       <SET OBJ ,P-HER-OBJECT>)
	      (<EQUAL? ,P-ADJN ,W?HIS>
	       <SET OBJ ,P-HIM-OBJECT>)>
	<COND (<T? .OBJ>
	       <SETG P-ADJN <GET ,CHAR-POSS-TABLE
				 <+ 1 <GETP .OBJ ,P?CHARACTER>>>>
	       <SETG P-ADJ <WT? ,P-ADJN ,PS?ADJECTIVE ,P1?ADJECTIVE>>)>>

<ROUTINE GET-OBJECT (TBL
		    "OPTIONAL" (VRB T)
		 "AUX" BTS LEN XBITS TLEN (GCHECK <>) (OLEN 0) (OBJ 0) (ADJ 0))
 <SET XBITS ,P-SLOCBITS>
 <SET TLEN <GET/B .TBL ,P-MATCHLEN>>
 <COND (<BTST ,P-GETFLAGS ,P-INHIBIT> <RTRUE>)>
 <COND (<AND <EQUAL? ,P-ADJN ,W?YOUR ,W?HER ,W?HIS>
	     <T? ,P-NAM>>
	<RESOLVE-YOUR-HER-HIS>)>
 <SET ADJ ,P-ADJN>
 <COND (<AND <NOT ,P-NAM> ,P-ADJ>
	<COND (<WT? ,P-ADJN ,PS?OBJECT>
	       <SETG P-NAM ,P-ADJN>
	       <SETG P-ADJ <>>
	       <SETG P-ADJN <>>)
	      (<SET BTS <WT? ,P-ADJN ,PS?DIRECTION ,P1?DIRECTION>>
	       <SETG P-ADJ <>>
	       <SETG P-ADJN <>>
	       <PUT/B .TBL ,P-MATCHLEN 1>
	       <PUT/B .TBL 1 ,INTDIR>
	       <SETG P-DIRECTION .BTS>
	       <RTRUE>)>)>
 <COND (<AND <ZERO? ,P-NAM>
	     <ZERO? ,P-ADJ>
	     <NOT <==? ,P-GETFLAGS ,P-ALL>>
	     <0? ,P-GWIMBIT>>
	<COND (.VRB <MISSING "noun" .ADJ>)>
	<RFALSE>)>
 <COND (<OR <NOT <==? ,P-GETFLAGS ,P-ALL>> <0? ,P-SLOCBITS>>
	<SETG P-SLOCBITS -1>)>
 <SETG P-TABLE .TBL>
 <PROG ()
  <COND (.GCHECK
	 <GLOBAL-CHECK .TBL>)
	(T
	 <COND (<T? ,LIT>
		;<COND (<EQUAL? ,HERE ,CAR>
		       <DO-SL <GETP ,HERE ,P?STATION> ,SOG ,SIR ;.TBL>)>
		;<COND (<AND <EQUAL? ,HERE ,COURTYARD>
			    <FIRST? ,FRONT-GATE>	;"for CLUE-4">
		       <SEARCH-LIST ,FRONT-GATE .TBL ,P-SRCALL>)>
		<FCLEAR ,WINNER ;,PLAYER ,OPENBIT ;,TRANSBIT>
		<DO-SL ,HERE ,SOG ,SIR ;.TBL>
		<FSET ,WINNER ;,PLAYER ,OPENBIT ;,TRANSBIT>)>
	 <DO-SL ,WINNER ,SH ,SC ;.TBL>)>
  <SET LEN <- <GET/B .TBL ,P-MATCHLEN> .TLEN>>
  <COND (<BTST ,P-GETFLAGS ,P-ALL>)
	(<AND <BTST ,P-GETFLAGS ,P-ONE>
	      <NOT <0? .LEN>>>
	 <COND (<NOT <==? .LEN 1>>
		<PUT/B .TBL 1 <GET/B .TBL <RANDOM .LEN>>>
		<TELL-I-ASSUME <GET/B .TBL 1>>)>
	 <PUT/B .TBL ,P-MATCHLEN 1>)
	(<AND <NOT <EQUAL? ,P-GETFLAGS ,P-ALL>>
	      <OR <G? .LEN 1>
		  <AND <0? .LEN> <NOT <==? ,P-SLOCBITS -1>>>>>
	 <COND (<==? ,P-SLOCBITS -1>
		<SETG P-SLOCBITS .XBITS>
		<SET OLEN .LEN>
		<PUT/B .TBL ,P-MATCHLEN <- <GET/B .TBL ,P-MATCHLEN> .LEN>>
		<AGAIN>)
	       (T
		<PUT-ADJ-NAM>
		<COND (<0? .LEN> <SET LEN .OLEN>)>
		<COND (<AND <G? .LEN 1>
			    ;,P-NAM
			    ;<REMOTE-VERB?>
			    <AND <SET OBJ <GET/B .TBL .LEN>>
				 <SET OBJ <APPLY <GETP .OBJ ,P?GENERIC>
						 .TBL .LEN>>>>
		       <COND (<==? .OBJ ,NOT-HERE-OBJECT>
			      <RFALSE>)
			     (<==? .OBJ ,ROOMS> ;"SWG put it here 7/17/86"
			      <SET LEN <GET/B .TBL ,P-MATCHLEN>>)
			     (T
			      <PUT/B .TBL ,P-MATCHLEN <SET LEN <+ .TLEN 1>>>
			      <PUT/B .TBL .LEN .OBJ>
			      ;<PUT/B .TBL 1 .OBJ>
			      ;<PUT/B .TBL ,P-MATCHLEN 1>
			      <SETG P-NAM <>>
			      <SETG P-ADJ <>>
			      <SETG P-ADJN <>>
			      <RTRUE>)>)
		      (<AND .VRB ;".VRB added 8/14/84 by JW"
			    <NOT <==? ,WINNER ,PLAYER>>>
		       <MORE-SPECIFIC> ;<CANT-ORPHAN>
		       <RFALSE>)>
		<COND (<AND .VRB <OR ,P-NAM ;,P-ADJ>>
		       <COND (<WHICH-PRINT .TLEN .LEN ;<GET/B .TBL 0> .TBL>
			      <COND (<==? .TBL ,P-PRSO>
				     <SETG P-ACLAUSE ,P-NC1>)
				    (T <SETG P-ACLAUSE ,P-NC2>)>
			      <SETG P-AADJ ,P-ADJ>
			      <SETG P-ANAM ,P-NAM>
			      <ORPHAN <> <>>
			      <SETG P-OFLAG T>)>)
		      (.VRB
		       <MISSING "noun" .ADJ>)>
		<SETG P-NAM <>>
		<SETG P-ADJ <>>
		<SETG P-ADJN <>>
		<RFALSE>)>)>
  <COND (<AND <0? .LEN> .GCHECK>
	 <PUT-ADJ-NAM>
	 <COND (.VRB
		<SETG P-SLOCBITS .XBITS>
		<COND (<OR <T? ,LIT> <NOT <SEE-VERB?>>>
		       ;<OR ,LIT
			   <VERB? WAIT-FOR WAIT-UNTIL>
			   <SPEAKING-VERB?>
			   <GAME-VERB?>>
		       <OBJ-FOUND ,NOT-HERE-OBJECT .TBL>
		       <SETG P-XNAM ,P-NAM>
		       <SETG P-NAM <>>
		       <SETG P-XADJ ,P-ADJ>
		       <SETG P-XADJN ,P-ADJN>
		       ;"<SETG P-ADJ <>>
		       <SETG P-ADJN <>>"
		       <RTRUE>)
		      (T <TOO-DARK>)>)>
	 <SETG P-NAM <>>
	 <SETG P-ADJ <>>
	 <SETG P-ADJN <>>
	 <RFALSE>)
	(<0? .LEN>
	 <SET GCHECK T>
	 <AGAIN>)>
  <COND (<AND ,P-ADJ <NOT ,P-NAM>>
	 <SET OBJ <GET/B .TBL <+ .TLEN 1>>>
	 <TELL-I-ASSUME .OBJ>
	 <THIS-IS-IT .OBJ>)>
  <SETG P-SLOCBITS .XBITS>
  <PUT-ADJ-NAM>
  <SETG P-NAM <>>
  <SETG P-ADJ <>>
  <SETG P-ADJN <>>
  <RTRUE>>>

<ROUTINE GENERIC-CLUE-FCN (TBL "OPTIONAL" (LEN 0))
 <COND (<VERB? FIND ;SEARCH SEARCH-FOR>
	,GENERIC-CLUE)
       (T
	<COND (<0? .LEN> <SET LEN <GET/B .TBL 0>>)>
	<COND (<1? <SET LEN <PRUNE .TBL .LEN ,CLUE-TEST>>>
	       <GET/B .TBL 1>)
	      ;(<0? .LEN>
	       <TELL CHE ,PRSI do "n't have" HIM ,PRSO "!" CR>
	       ,NOT-HERE-OBJECT)
	      (T <RETURN ,ROOMS ;<>>)>)>>

<ROUTINE CLUE-TEST (OBJ)
 <COND (<AND ;<NOT <==? ,WINNER ,PLAYER>>
	     <IN? .OBJ ,WINNER>>
	<RTRUE>)
       (<AND <T? ,PRSI>	;"TAKE CLUE FROM JACK"
	     <IN? .OBJ ,PRSI>>
	<RTRUE>)
       (<==? .OBJ ,P-IT-OBJECT>
	<RTRUE>)
       ;(<NOT <FSET? .OBJ ,NDESCBIT>>
	<RTRUE>)>>

<ROUTINE GENERIC-STAIRS (X "OPTIONAL" Y)	;"in KITCHEN"
 <COND (<VERB? BOARD CLIMB-DOWN CLIMB-UP>
	,STAIRS)
       (T ,BACKSTAIRS)>>

;<ROUTINE GENERIC-STAIRS-F (X "OPTIONAL" Y)
 <COND ;(<EQUAL? ,HERE ,JUNCTION ,BASEMENT>	,STAIRS-0)
       ;(<EQUAL? ,HERE ,OLD-GREAT-HALL>		,STAIRS-1)
       ;(<EQUAL? ,HERE ,CORR-2>
	<COND (<VERB? BOARD CLIMB-UP>	,STAIRS-2)
	      (<VERB? CLIMB-DOWN>	,STAIRS-1)>)
       ;(<EQUAL? ,HERE ,CORR-3>
	<COND (<VERB? BOARD CLIMB-UP>	,STAIRS-3)
	      (<VERB? CLIMB-DOWN>	,STAIRS-2)>)
       ;(<EQUAL? ,HERE ,DECK>			,STAIRS-3)
       (<FSET? ,HERE ,WEARBIT> ;"WING-ROOMS"	,STAIRS-NEW)>>

<ROUTINE GENERIC-CLOTHES (X "OPTIONAL" Y)
 <COND (<VERB? CHANGE REMOVE ;TAKE TAKE-OFF>
	,NOW-WEARING)>>

"use of WINDOW in CAR in COURTYARD:"
;<ROUTINE GENERIC-WINDOW (X "OPTIONAL" Y)
 <COND (<GLOBAL-IN? ,WINDOW ,HERE>
	,WINDOW)>>

;<ROUTINE GENERIC-JACK-DOOR-F (X "OPTIONAL" Y)
 <COND (<NOT <FSET? ,SECRET-JACK-DOOR ,TOUCHBIT>>
	,JACK-ROOM ;,JACK-DOOR)
       (<VERB? OPEN CLOSE>
	,JACK-ROOM ;,JACK-DOOR)>>

;<ROUTINE GENERIC-LIBRARY-DOOR-F (X "OPTIONAL" Y)
 <COND (<NOT <FSET? ,SECRET-LIBRARY-DOOR ,TOUCHBIT>>
	,LIBRARY ;,LIBRARY-DOOR)
       (<VERB? OPEN CLOSE>
	,LIBRARY ;,LIBRARY-DOOR)>>

;<ROUTINE GENERIC-TAMARA-DOOR-F (X "OPTIONAL" Y)
 <COND (<NOT <FSET? ,SECRET-TAMARA-DOOR ,TOUCHBIT>>
	,TAMARA-ROOM ;,TAMARA-DOOR)
       (<VERB? OPEN CLOSE>
	,TAMARA-ROOM ;,TAMARA-DOOR)>>

;<ROUTINE GENERIC-LUMBER-DOOR-F (X "OPTIONAL" Y)
 <COND (<NOT <FSET? ,SECRET-LUMBER-DOOR ,TOUCHBIT>>
	,LUMBER-ROOM ;,LUMBER-DOOR)
       (<VERB? OPEN CLOSE>
	,LUMBER-ROOM ;,LUMBER-DOOR)>>

<ROUTINE GENERIC-CLOSET (TBL "OPTIONAL" (LEN 0) "AUX" N)
  <COND (<SET N <ZMEMQ ,HERE ,CHAR-ROOM-TABLE ,CHARACTER-MAX>>
	 <RETURN <GET ,CHAR-CLOSET-TABLE .N>>)
	(<0? .TBL>
	 <RFALSE>)>
  <COND (<ZMEMQ/B ,HERE .TBL>
	 <RETURN ,HERE>)>
  <COND (<0? .LEN>
	 <SET LEN <GET/B .TBL 0>>)>
  <COND (<0? <SET LEN <PRUNE .TBL .LEN ,NOT-SECRET-TEST>>>
	 <TELL "(You haven't found a secret entrance yet!)" CR>
	 ,NOT-HERE-OBJECT)
	(<1? .LEN>
	 <GET/B .TBL 1>)
	(T <RETURN ,ROOMS ;<>>)>>

<ROUTINE GENERIC-DINNER (X "OPTIONAL" Y)
	<COND (<OR <REMOTE-VERB?>
		   <VERB? EXAMINE>>
	       ,DINNER)
	      (<AND <EQUAL? ,P-ADJ <> ,A?MY>
		    <EQUAL? ,P-XADJ <> ,A?MY>>
	       ,DINNER)
	      ;(<NOT <VISIBLE? ,DINNER>>
	       <NOT-HERE ,DINNER>
	       ,NOT-HERE-OBJECT)
	      (T
	       <SETG CLOCK-WAIT T>
	       <TELL "(That wouldn't be polite!)" CR>
	       ,NOT-HERE-OBJECT)>>

<ROUTINE GENERIC-BEDROOM (TBL "OPTIONAL" (N 0) "AUX" RM)
 <COND (<ZERO? .N>
	<SET N <GET/B .TBL ,P-MATCHLEN>>)>
 <COND (<SET RM <ZMEMQ ,HERE ,CHAR-CLOSET-TABLE>>
	<COND (<EQUAL? ,W?DOOR ,P-NAM ,P-XNAM>
	       <RETURN <FIND-FLAG-LG ,HERE ,DOORBIT>>)
	      (T <RETURN <GET ,CHAR-ROOM-TABLE .RM>>)>)
       (<AND <EQUAL? ,A?JACK\'S ,P-ADJ ,P-XADJ>
	     <EQUAL? ,W?DOOR ,P-NAM ,P-XNAM>>
	<RETURN ,JACK-ROOM>)
       (<ZMEMQ/B ,P-IT-OBJECT .TBL>
	<RETURN ,P-IT-OBJECT>)
       (<ZMEMQ/B ,HERE .TBL>
	<RETURN ,HERE>)
       (<REMOTE-VERB?>
	<COND (<EQUAL? ,A?BATH ,P-ADJ ,P-XADJ>
	       <RETURN ,YOUR-BATHROOM>)
	      (<EQUAL? ,W?ROOM ,P-NAM ,P-XNAM>
	       <RETURN ,YOUR-ROOM>)
	      (T <SET RM <>>)>)
       (<EQUAL? ,HERE ,GALLERY ,YOUR-BATHROOM>
	<RETURN ,YOUR-ROOM>)
       (<ZMEMQ ,HERE ,CHAR-ROOM-TABLE>
	<RETURN ,HERE>)
       (<VERB? CLIMB-DOWN CLIMB-UP WALK-TO>
	<RETURN ,YOUR-ROOM>)
       (T
	<REPEAT ()
	 <COND (<EQUAL? ,HERE <GETP <SET RM <GET/B .TBL .N>> ,P?STATION>>
		<RETURN>)
	       (<DLESS? N 1>
		<SET RM <>>
		<RETURN>)>>)>
 <COND (<T? .RM>
	<RETURN .RM>)
       (<EQUAL? ,WINNER ,FRIEND ,LORD>
	<RETURN ,YOUR-ROOM>)
       (T <RFALSE>)>>

<ROUTINE GENERIC-GREAT-HALL (X "OPTIONAL" Y)
 <COND (<EQUAL? ,W?ROOM ,P-NAM ,P-XNAM>
	,HERE)	;"kludge!"
       (<FSET? ,HERE ,WEARBIT> ;"WING-ROOMS"
	,GREAT-HALL)
       (T ,OLD-GREAT-HALL)>>

<ROUTINE GENERIC-LENS (X "OPTIONAL" Y)
 <COND (<REMOTE-VERB?>
	,LENS)
       (<NOT <FSET? ,LENS-2 ,SEENBIT>>
	,LENS-1)>>

<ROUTINE GENERIC-RECORDER (X "OPTIONAL" Y)
 <COND (<NOT <FSET? ,JACK-TAPE ,SEENBIT>>
	,RECORDER)>>

<ROUTINE GENERIC-BOX (X "OPTIONAL" Y)
 <COND (<FSET? ,LENS-BOX ,SECRETBIT>
	,VIVIEN-BOX)>>

<ROUTINE GENERIC-BOOK (X "OPTIONAL" Y)
 <COND (<EQUAL? ,HERE ,LIBRARY>
	,BOOKS-GLOBAL)>>

<ROUTINE GENERIC-WELL (X "OPTIONAL" Y)
 <COND (<NOT <EQUAL? ,HERE ,BASEMENT>>
	,WELL)>>

<ROUTINE GENERIC-SKELETON (X "OPTIONAL" Y)
 <COND (<FSET? ,SKELETON ,SEENBIT>
	,SKELETON)>>

<ROUTINE GENERIC-ROOM (X "OPTIONAL" Y) ,GLOBAL-HERE>

<ROUTINE GENERIC-EYE (X "OPTIONAL" Y)
 <COND (<EQUAL? ,W?EYE ,P-NAM ,P-XNAM>
	,GLASS-EYE)>>

<ROUTINE GENERIC-BELL (X "OPTIONAL" Y)
 <COND (<REMOTE-VERB?> ,BELL)>>

<ROUTINE GENERIC-WINE (X "OPTIONAL" Y)
 <COND (<VERB? TAKE> ,BOTTLE)>>

<ROUTINE SPEAKING-VERB? ("OPTIONAL" (PER 0))
 <COND (<VERB? ANSWER ASK ASK-ABOUT ASK-FOR FORGIVE
	       ;GOODBYE HELLO NO REPLY SORRY TELL TELL-ABOUT YES $CALL>
	<COND (<EQUAL? .PER 0 ,PRSO>
	       <RTRUE>)>)
       (<VERB? ASK-CONTEXT-ABOUT ASK-CONTEXT-FOR TALK-ABOUT>
	<COND (<EQUAL? .PER 0>
	       <RTRUE>)>)>>

;<ROUTINE CANT-ORPHAN ()
	 <TELL "[Please try saying that another way.]" CR>
	 <RFALSE>>

<ROUTINE MISSING (NV "OPTIONAL" ADJ)
	<COND ;(<EQUAL? .ADJ ,W?INT.NUM ;NUMBER>
	       <TELL "[Please use units with numbers.]" CR>)
	      (T <TELL
"[I think there's a " .NV " missing in that sentence!]" CR>)>>

<ROUTINE WHICH-PRINT (TLEN LEN TBL "AUX" OBJ RLEN)
	 ;%<DEBUG-CODE <TELL
"{Note to Stu:  TLEN=" N .TLEN " LEN=" N .LEN " TBL=" N .TBL "}" CR>>
	 <COND (<ZERO? .LEN>
		<MORE-SPECIFIC ;REFERRING>
		<RFALSE>)>
	 <SET RLEN .LEN>
	 <COND (<NOT <==? ,WINNER ,PLAYER>>
		<TELL "\"I don't understand ">
		<COND (<EQUAL? ,P-NAM ,W?DOOR>
		       <TELL "which door">)
		      ;(<EQUAL? ,P-NAM ,W?KEYHOLE>
		       <TELL "which " 'KEYHOLE>)
		      (T
		       <TELL "if">)>
		<TELL " you mean">)
	       (T
		<TELL "[Which">
		<COND (<OR <T? ,P-OFLAG> <T? ,P-MERGED> <T? ,P-AND>>
		       <COND (<T? ,P-NAM>
			      <TELL !\ >
			      <PRINTB ,P-NAM>)>)
		      (<EQUAL? .TBL ,P-PRSO>
		       <CLAUSE-PRINT ,P-NC1 ,P-NC1L <>>)
		      (T
		       <CLAUSE-PRINT ,P-NC2 ,P-NC2L <>>)>
		<TELL " do you mean">
		<COND (<NOT <EQUAL? ,P-NAM ,W?DOOR ;,W?KEYHOLE>>
		       <TELL ",">)>)>
	 <COND (<NOT <EQUAL? ,P-NAM ,W?DOOR ;,W?KEYHOLE>>
		<REPEAT ()
		 <SET TLEN <+ .TLEN 1>>
		 <SET OBJ <GET/B .TBL .TLEN>>
		 <TELL THE .OBJ>
		 <COND (<==? .LEN 2>
		        <COND (<NOT <==? .RLEN 2>> <TELL !\,>)>
		        <TELL " or">)
		       (<G? .LEN 2> <TELL !\,>)>
		 <COND (<L? <SET LEN <- .LEN 1>> 1>
		        <RETURN>)>>)>
	 <COND (<NOT <==? ,WINNER ,PLAYER>>
		<TELL ".\"" CR>)
	       (T
		<TELL "?]" CR>)>>

<ROUTINE GLOBAL-SEARCH (TBL RMG "AUX" CNT OBJ)
	<SET CNT <RMGL-SIZE .RMG>>
	<REPEAT ()
		<SET OBJ <GET/B .RMG .CNT>>
		;<COND (<AND <EQUAL? .OBJ ,FRONT-GATE>	;"for CLUE-4"
			    <FIRST? .OBJ>>
		       <SEARCH-LIST .OBJ .TBL ,P-SRCALL>)>
		<COND (<THIS-IT? .OBJ>
		       <OBJ-FOUND .OBJ .TBL>)>
		<COND (<DLESS? CNT 0> <RETURN>)>>>

<ROUTINE GLOBAL-CHECK (TBL "AUX" LEN RMG RMGL (CNT 0) ;OBJ OBITS FOO)
	<SET LEN <GET/B .TBL ,P-MATCHLEN>>
	<SET OBITS ,P-SLOCBITS>
	<COND (<SET RMG <GETPT ,HERE ,P?GLOBAL>>
	       <GLOBAL-SEARCH .TBL .RMG>)>
	<COND (<NOT <EQUAL? ,P-NAM ,W?DOOR ;,W?KEYHOLE>>
	       <COND (<AND <THIS-IT? ,HERE>
			   <NOT <ZMEMQ/B ,HERE .TBL>>>
		      <OBJ-FOUND ,HERE .TBL>)>
	       <COND (<VERB? BOARD CLIMB-DOWN CLIMB-UP EXAMINE LOOK-INSIDE
			     ;"SEARCH SEARCH-FOR SMELL" THROUGH>
		      <ROOM-SEARCH .TBL>)>)>
	<COND (<SET RMG <GETP ,HERE ,P?THINGS>>
	       <SET RMGL <GET .RMG 0>>
	       <SET CNT 0>
	       <REPEAT ()
		       <COND (<AND <EQUAL? ,P-NAM <GET .RMG <+ .CNT 1>>>
				   <OR <ZERO? ,P-ADJ>
				       <EQUAL? ,P-ADJN <GET .RMG <+ .CNT 2>>>>>
			      <SETG LAST-PSEUDO-LOC ,HERE>
			      <PUTP ,PSEUDO-OBJECT
				    ,P?ACTION
				    <GET .RMG <+ .CNT 3>>>
			      <SET FOO
				   <BACK <GETPT ,PSEUDO-OBJECT ,P?ACTION> 5>>
			      <PUT .FOO 0 <GET ,P-NAM 0>>
			      <PUT .FOO 1 <GET ,P-NAM 1>>
			      <OBJ-FOUND ,PSEUDO-OBJECT .TBL>
			      <RETURN>)>
		       <SET CNT <+ .CNT 3>>
		       <COND (<NOT <L? .CNT .RMGL>> <RETURN>)>>)>
	<COND (<==? <GET/B .TBL ,P-MATCHLEN> .LEN>
	       <SETG P-SLOCBITS -1>
	       <SETG P-TABLE .TBL>
	       <DO-SL ,GLOBAL-OBJECTS 1 1 ;.TBL>
	       <SETG P-SLOCBITS .OBITS>
	       <COND (<0? <GET/B .TBL ,P-MATCHLEN>>
		      <COND (<VERB? ;$WHERE CLIMB-DOWN CLIMB-UP FIND
				    SHOW SSHOW TAKE-TO THROUGH WALK-TO>
			     <SEARCH-LIST ,ROOMS ,P-TABLE ,P-SRCTOP>
			     ;<DO-SL ,ROOMS 1 1 ;.TBL>)>)>)>>

<ROUTINE DO-SL (OBJ BIT1 BIT2 "AUX" BITS) 
	<COND (<BTST ,P-SLOCBITS <+ .BIT1 .BIT2>>
	       <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCALL>)
	      (T
	       <COND (<BTST ,P-SLOCBITS .BIT1>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCTOP>)
		     (<BTST ,P-SLOCBITS .BIT2>
		      <SEARCH-LIST .OBJ ,P-TABLE ,P-SRCBOT>)
		     (T <RTRUE>)>)>>  

<GLOBAL P-TABLE:TABLE 0>
<CONSTANT P-SRCBOT 2>
<CONSTANT P-SRCTOP 0>
<CONSTANT P-SRCALL 1>    

<ROUTINE SEARCH-LIST (OBJ TBL LVL)
 <COND (<SET OBJ <FIRST? .OBJ>>
	<REPEAT ()
		<COND (<AND <NOT <==? .LVL ,P-SRCBOT>>
			    ;<GETPT .OBJ ,P?SYNONYM>
			    <THIS-IT? .OBJ>>
		       <OBJ-FOUND .OBJ .TBL>)>
		<COND (<AND <OR <NOT <==? .LVL ,P-SRCTOP>>
				<FSET? .OBJ ,SEARCHBIT>
				<FSET? .OBJ ,SURFACEBIT>>
			    <FIRST? .OBJ>
			    ;<OR ,P-MOBY-FLAG
				<SEE-INSIDE? .OBJ>>
			    <OR <FSET? .OBJ ,OPENBIT>
				<FSET? .OBJ ,TRANSBIT>
				,P-MOBY-FLAG
				<AND <FSET? .OBJ ,PERSONBIT>
				     <NOT <==? .OBJ ,WINNER ;,PLAYER>>>>
			    ;<NOT <EQUAL? .OBJ ,PLAYER ,LOCAL-GLOBALS>>>
		       <SEARCH-LIST .OBJ .TBL
				    <COND (<FSET? .OBJ ,SURFACEBIT> ,P-SRCALL)
					  (<FSET? .OBJ ,SEARCHBIT> ,P-SRCALL)
					  (T ,P-SRCTOP)>
				    ;,P-MOBY-FLAG>)>
		<COND (<SET OBJ <NEXT? .OBJ>>) (T <RETURN>)>>)>>

<ROUTINE ROOM-SEARCH (TTBL "AUX" (P 0) L TBL O)
 <SET O <CORRIDOR-LOOK ,ROOMS>>
 <COND (<T? .O>
	<OBJ-FOUND .O .TTBL>)>
 <REPEAT ()
	 <COND (<OR <0? <SET P <NEXTP ,HERE .P>>>
		    <L? .P ,LOW-DIRECTION>>
		<RFALSE>)>
	 <SET TBL <GETPT ,HERE .P>>
	 <SET L <PTSIZE .TBL>>
	 <SET O <GET-REXIT-ROOM .TBL>>
	 <COND (<ZMEMQ/B .O .TTBL>
		<AGAIN>)
	       (<==? .L ,UEXIT>
		<COND (<THIS-IT? .O>
		       <OBJ-FOUND .O .TTBL>)>)
	       (<==? .L ,DEXIT>
		<COND (<AND <FSET? <GET-DOOR-OBJ .TBL> ,OPENBIT>
			    <THIS-IT? .O>>
		       <OBJ-FOUND .O .TTBL>)>)
	       (<==? .L ,CEXIT>
		<COND (<AND <VALUE <GETB .TBL ,CEXITFLAG>>
			    <THIS-IT? .O>>
		       <OBJ-FOUND .O .TTBL>)>)>>>

<ROUTINE THIS-IT? (OBJ "AUX" SYNS) 
 <COND (<FSET? .OBJ ,INVISIBLE>
	<RFALSE>)
       (<AND <T? ,P-NAM>
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?SYNONYM>>>
		 <NOT <ZMEMQ ,P-NAM .SYNS <- </ <PTSIZE .SYNS> 2> 1>>>>>
	<RFALSE>)
       (<AND <T? ,P-ADJ>
	     <OR <NOT <SET SYNS <GETPT .OBJ ,P?ADJECTIVE>>>
		 <NOT %<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
			      '<ZMEMQ  ,P-ADJ .SYNS <RMGL-SIZE .SYNS>>)
			     (T
			      '<ZMEMQB ,P-ADJ .SYNS <RMGL-SIZE .SYNS>>)>>>>
	<RFALSE>)
       (<AND <NOT <0? ,P-GWIMBIT>> <NOT <FSET? .OBJ ,P-GWIMBIT>>>
	<RFALSE>)>
 <RTRUE>>

<ROUTINE OBJ-FOUND (OBJ TBL "AUX" PTR)
	<COND (<AND <NOT <==? .OBJ ,NOT-HERE-OBJECT>>
		    <ZMEMQ/B .OBJ .TBL>>
	       <RFALSE>)>
	<SET PTR <GET/B .TBL ,P-MATCHLEN>>
	<INC PTR>
	<PUT/B .TBL .PTR .OBJ>
	<PUT/B .TBL ,P-MATCHLEN .PTR>> 
 
<ROUTINE TAKE-CHECK () 
	<AND <ITAKE-CHECK ,P-PRSO <GETB ,P-SYNTAX ,P-SLOC1>>
	     <ITAKE-CHECK ,P-PRSI <GETB ,P-SYNTAX ,P-SLOC2>>>> 

<ROUTINE ITAKE-CHECK (TBL BITS "AUX" PTR OBJ TAKEN)
 <COND (<AND <SET PTR <GET/B .TBL ,P-MATCHLEN>>
	     <OR <BTST .BITS ,SHAVE>
		 <BTST .BITS ,STAKE>>
	     ;<EQUAL? ,WINNER ,PLAYER>>
	<REPEAT ()
	 <COND (<L? <SET PTR <- .PTR 1>> 0> <RETURN>)>
	 <SET OBJ <GET/B .TBL <+ .PTR 1>>>
	 <COND (<==? .OBJ ,IT>
		<COND (<NOT <ACCESSIBLE? ,P-IT-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-IT-OBJECT>)>)
	       (<==? .OBJ ,HER>
		<COND (<NOT <ACCESSIBLE? ,P-HER-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-HER-OBJECT>)>)
	       (<==? .OBJ ,HIM>
		<COND (<NOT <ACCESSIBLE? ,P-HIM-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-HIM-OBJECT>)>)
	       ;(<==? .OBJ ,THEM>
		<COND (<NOT <ACCESSIBLE? ,P-THEM-OBJECT>>
		       <MORE-SPECIFIC>
		       <RFALSE>)
		      (T
		       <SET OBJ ,P-THEM-OBJECT>)>)>
	 <COND (<AND <NOT <HELD? .OBJ ,WINNER>>
		     <NOT <EQUAL? .OBJ ,HANDS ,ROOMS>>>
		<SETG PRSO .OBJ>
		<COND (<FSET? .OBJ ,TRYTAKEBIT>
		       <SET TAKEN T>)
		      (<NOT <==? ,WINNER ,PLAYER>>
		       <SET TAKEN <>>)
		      (<AND <BTST .BITS ,STAKE>
			    <==? <ITAKE <>> T>>
		       <SET TAKEN <>>)
		      (T <SET TAKEN T>)>
		<COND (<AND .TAKEN <BTST .BITS ,SHAVE>>
		       <TELL !\(>
		       <TELL CHE ,WINNER is "n't holding">
		       <COND (<L? 1 <GET/B .TBL ,P-MATCHLEN>>
			      <TELL ;" all" " those things">)
			     (<EQUAL? .OBJ ,NOT-HERE-OBJECT>
			      <TELL " that">)
			     (T
			      <TELL THE .OBJ>
			      <THIS-IS-IT .OBJ>)>
		       <TELL "!)" CR>
		       <RFALSE>)
		      ;(<AND <NOT .TAKEN> <==? ,WINNER ,PLAYER>>
		       <FIRST-YOU "take" .OBJ ;,PRSO ,ITAKE-LOC>)>)>>)
       (T)>>

<ROUTINE MANY-CHECK ("AUX" (LOSS <>) TMP)
	<COND (<AND <G? <GET/B ,P-PRSO ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC1> ,SMANY>>>
	       <SET LOSS 1>)
	      (<AND <G? <GET/B ,P-PRSI ,P-MATCHLEN> 1>
		    <NOT <BTST <GETB ,P-SYNTAX ,P-SLOC2> ,SMANY>>>
	       <SET LOSS 2>)>
	<COND (.LOSS
	       <COND ;(<NOT <EQUAL? ,WINNER ,PLAYER>>
		      <TELL "\"Please, to me simple English speak.\"" CR>
		      <RFALSE>)
		     (T
		      <TELL "[You can't use more than one ">
		      <COND (<==? .LOSS 2> <TELL "in">)>
		      <TELL "direct object with \"">
		      <SET TMP <GET ,P-ITBL ,P-VERBN>>
		      <COND (<0? .TMP> <TELL "tell">)
			    (<OR <T? ,P-OFLAG> <T? ,P-MERGED>>
			     <PRINTB <GET .TMP 0>>)
			    (T
			     <WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>
		      <TELL "\"!]" CR>
		      <RFALSE>)>)
	      (T)>>

<ROUTINE ZMEMQ (ITM TBL "OPTIONAL" (SIZE -1) "AUX" (CNT 1)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<COND (<NOT <L? .SIZE 0>> <SET CNT 0>)
	      (ELSE
	       <SET SIZE <GET .TBL 0>>
	       <COND (<NOT <G? .SIZE 0>>
		      <RFALSE>)>)>
	<REPEAT ()
		<COND (<==? .ITM <GET .TBL .CNT>>
		       <COND (<0? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>

<ROUTINE ZMEMQB (ITM TBL "OPTIONAL" (SIZE -1) "AUX" (CNT 1)) 
	<COND (<NOT .TBL> <RFALSE>)>
	<COND (<NOT <L? .SIZE 0>> <SET CNT 0>)
	      (ELSE
	       <SET SIZE <GETB .TBL 0>>
	       <COND (<NOT <G? .SIZE 0>>
		      <RFALSE>)>)>
	<REPEAT ()
		<COND (<==? .ITM <GETB .TBL .CNT>>
		       <COND (<0? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>

;<ROUTINE ZMEMQB (ITM TBL SIZE "AUX" (CNT 0))
	<REPEAT ()
		<COND (<==? .ITM <GETB .TBL .CNT>>
		       <COND (<0? .CNT> <RTRUE>)
			     (T <RETURN .CNT>)>)
		      (<IGRTR? CNT .SIZE> <RFALSE>)>>>  

<GLOBAL LIT:OBJECT DRIVEWAY ;CAR>	"source of light, 0=dark"
			;"2=light here, 1=light from next room, 0=dark"

<ROUTINE LIT? ("OPTIONAL" (RM <>) (RMBIT <>) "AUX" OHERE (LIT <>) (P 0) TBL L)
	<COND (<ZERO? .RM>
	       <SET RM ,HERE>)>
	<COND (<T? .RMBIT>
	       <COND (<NOT <FSET? .RM ,ONBIT>>
		      <RETURN <>>)
		     (T <RETURN .RM>)>)>
	<COND (<FSET? .RM ,ONBIT>
	       <SET LIT .RM>)
	      (T
	       <SETG P-GWIMBIT ,ONBIT>
	       <SET OHERE ,HERE>
	       <SETG HERE .RM>
	       <PUT/B ,P-MERGE ,P-MATCHLEN 0>
	       <SETG P-TABLE ,P-MERGE>
	       <SETG P-SLOCBITS -1>
	       ;<COND (<==? .OHERE .RM>
		      <DO-SL ,WINNER 1 1>
		      <COND (<AND <NOT <EQUAL? ,WINNER ,PLAYER>>
				  <IN? ,PLAYER .RM>>
			     <DO-SL ,PLAYER 1 1>)>)>
	       <SEARCH-LIST .RM ,P-TABLE ,P-SRCALL>
	       ;<DO-SL .RM 1 1>
	       <COND (<NOT <ZERO? <GET/B ,P-MERGE ,P-MATCHLEN>>>
		      <SET LIT <GET/B ,P-MERGE 1>>)>
	       <SETG HERE .OHERE>
	       <SETG P-GWIMBIT 0>)>
	<COND (<T? .LIT> <RETURN .LIT>)
	      (<AND <==? .RM ,GALLERY-CORNER>
		    <FSET? ,GALLERY ,ONBIT>>
	       <RETURN ,GALLERY>)
	      (T
	       <REPEAT ()
		 <COND (<0? <SET P <NEXTP .RM .P>>>
			<RETURN <>>)
		       (<EQUAL? .P ,P?UP ,P?DOWN>
			<AGAIN>)	;"not up or down stairs"
		       (<NOT <L? .P ,LOW-DIRECTION>>
			<SET TBL <GETPT .RM .P>>
			<SET L <PTSIZE .TBL>>
			<SET OHERE <GET-REXIT-ROOM .TBL>>
			<COND (<AND <==? .L ,UEXIT>
				    <LIT? .OHERE T>>
			       <RETURN .OHERE>)
			      (<AND <==? .L ,DEXIT>
				    <FSET? <GET-DOOR-OBJ .TBL> ,OPENBIT>
				    <LIT? .OHERE T>>
			       <RETURN .OHERE>)
			      (<AND <==? .L ,CEXIT>
				    <VALUE <GETB .TBL ,CEXITFLAG>>
				    <LIT? .OHERE T>>
			       <RETURN .OHERE>)>)>>)>>

;<ROUTINE VPRINT ("AUX" TMP)
	 <SET TMP <GET ,P-OTBL ,P-VERBN>>
	 <COND (<==? .TMP 0> <TELL "tell">)
	       (<0? <GETB ,P-VTBL 2>>
		<PRINTB <GET .TMP 0>>)
	       (T
		<WORD-PRINT <GETB .TMP 2> <GETB .TMP 3>>)>>

<ROUTINE NOT-HERE (OBJ "OPT" (CLOCK <>))
	<COND (<ZERO? .CLOCK>
	       <SETG CLOCK-WAIT T>
	       <TELL !\(>)>
	<TELL CTHE .OBJ " isn't ">
	<COND (<VISIBLE? .OBJ>
	       <TELL "close enough">
	       <COND (<SPEAKING-VERB?> <TELL " to hear you">)>
	       <TELL !\.>)
	      (T <TELL "here!">)>
	 <THIS-IS-IT .OBJ>
	 <COND (<ZERO? .CLOCK>
		<TELL !\)>)>
	 <CRLF>>

;<ROUTINE NOT-HERE (OBJ "OPT" (CLOCK <>))
	 <COND (<ZERO? .CLOCK>
		<SETG CLOCK-WAIT T>
		<TELL !\(>)>
	 <TELL "You can't see ">
	 <COND (<NOT <FSET? .OBJ ,NARTICLEBIT>> <TELL "any ">)>
	 <THIS-IS-IT .OBJ>
	 <TELL D .OBJ " here.">
	 <COND (<ZERO? .CLOCK>
		<TELL !\)>)>
	 <CRLF>>

<OBJECT HER
	(IN GLOBAL-OBJECTS)
	(SYNONYM ;SHE HER MADAM)
	(DESC "her")
	(FLAGS NARTICLEBIT)>

<OBJECT HIM
	(IN GLOBAL-OBJECTS)
	(SYNONYM ;HE HIM SIR)
	(DESC "him")
	(FLAGS NARTICLEBIT)>

;<OBJECT THEM
	(IN GLOBAL-OBJECTS)
	(SYNONYM THEY THEM)
	(DESC "them")
	(FLAGS NARTICLEBIT)>

<GLOBAL QCONTEXT:OBJECT <>>
;<GLOBAL QCONTEXT-ROOM:OBJECT <>>
<GLOBAL LAST-PSEUDO-LOC:OBJECT <>>
<GLOBAL I-ASSUME "[I assume you mean:">

<OBJECT INTDIR
	(IN GLOBAL-OBJECTS)
	(SYNONYM DIRECTION)
	(ADJECTIVE NORTH EAST SOUTH WEST NE NW SE SW)
	(DESC ;"compass " "direction")>

<ROUTINE PUT-ADJ-NAM ()
	 <COND (<NOT <EQUAL? ,P-NAM ,W?IT ,W?HIM ,W?HER>>
		<PUT ,P-NAMW ,P-PHR ,P-NAM>
		<PUT ,P-ADJW ,P-PHR ,P-ADJN>)>>

<ROUTINE NOUN-USED? (WORD1 "OPTIONAL" (WORD2 1) (WORD3 1))
	 <COND (<ZERO? ,NOW-PRSI>
		<COND (<EQUAL? <GET ,P-NAMW 0> .WORD1 .WORD2 .WORD3>
		       <RTRUE>)
		      (<EQUAL? <GET ,P-OFW 0>  .WORD1 .WORD2 .WORD3>
		       <RTRUE>)>)
	       (T
		<COND (<EQUAL? <GET ,P-NAMW 1> .WORD1 .WORD2 .WORD3>
		       <RTRUE>)
		      (<EQUAL? <GET ,P-OFW 1>  .WORD1 .WORD2 .WORD3>
		       <RTRUE>)>)>>

<ROUTINE ADJ-USED? ("OPTIONAL" (WORD1 1) (WORD2 1) (WORD3 1))
 <COND (<ZERO? ,NOW-PRSI>
	<COND (<EQUAL? .WORD1 1>
	       <RETURN <GET ,P-ADJW 0>>)
	      (<EQUAL? <GET ,P-ADJW 0> .WORD1 .WORD2 .WORD3>
	       <RTRUE>)
	      (T <RFALSE>)>)
       (T
	<COND (<EQUAL? .WORD1 1>
	       <RETURN <GET ,P-ADJW 1>>)
	      (<EQUAL? <GET ,P-ADJW 1> .WORD1 .WORD2 .WORD3>
	       <RTRUE>)
	      (T <RFALSE>)>)>>
