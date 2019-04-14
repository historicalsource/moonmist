"MISC for MOONMIST
Copyright (c) 1986 Infocom, Inc.  All rights reserved."

<ROUTINE GO ()
	;<SETG WINNER ,PLAYER>
	;<START-MOVEMENT>
	<V-VERSION>
	<INTRO>
	<MAIN-LOOP>
	<AGAIN>>

<ROUTINE PRINTT (OBJ)	;"THE"
	<COND (<AND <EQUAL? .OBJ ,TURN> <L? 1 ,P-NUMBER>>
	       <TELL !\  N ,P-NUMBER " minutes">)
	      (<EQUAL? .OBJ ,WINDOW>
	       <TELL " the window">)
	      ;(<AND <EQUAL? .OBJ ,P-IT-OBJECT>
		    <FSET? ,IT ,TOUCHBIT>>
	       <TELL " it">
	       <RTRUE>)
	      (T
	       <THE? .OBJ>
	       <TELL !\  D .OBJ>)>
	;<THIS-IS-IT .OBJ>>

<ROUTINE THE? (OBJ)
	<COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
	       <COND (<OR ;<NOT <FSET? .OBJ ,PERSONBIT>>
			  <IN? .OBJ ,ROOMS>
			  <FSET? .OBJ ,SEENBIT>>
		      <TELL " the">)
		     (<FSET? .OBJ ,VOWELBIT>
		      <TELL " an">)
		     (T <TELL " a">)>)>
	<COND (T ;<FSET? .OBJ ,PERSONBIT>
	       <FSET .OBJ ,SEENBIT>)>>

<ROUTINE START-SENTENCE (OBJ)	;"CTHE"
	<THIS-IS-IT .OBJ>
	<COND (<EQUAL? .OBJ ,PLAYER>	<TELL "You">		<RTRUE>)
	      (<EQUAL? .OBJ ,NIGHTLAMP>	<TELL "Your lamp">	<RTRUE>)
	      (<EQUAL? .OBJ ,LUGGAGE>	<TELL "Your luggage">	<RTRUE>)
	      (<EQUAL? .OBJ ,BED>	<TELL "Your bed">	<RTRUE>)
	      (<EQUAL? .OBJ ,YOUR-COLOR><TELL "Your favorite color"><RTRUE>)
	      (<EQUAL? .OBJ ,YOUR-ROOM>	<TELL "Your room">	<RTRUE>)
	      (<EQUAL? .OBJ ,YOUR-BATHROOM><TELL "Your bathroom"><RTRUE>)
	      (<EQUAL? .OBJ ,YOUR-CLOSET><TELL "Your secret entrance"><RTRUE>)
	      (<EQUAL? .OBJ ,DINNER>	<TELL "Your dinner">	<RTRUE>)>
	<COND (<NOT <FSET? .OBJ ,NARTICLEBIT>>
	       <COND (<OR ;<NOT <FSET? .OBJ ,PERSONBIT>>
			  <FSET? .OBJ ,SEENBIT>>
		      <TELL "The ">)
		     (<FSET? .OBJ ,VOWELBIT>
		      <TELL "An ">)
		     (T <TELL "A ">)>)>
	<COND (T ;<FSET? .OBJ ,PERSONBIT>
	       <FSET .OBJ ,SEENBIT>)>
	<TELL D .OBJ>>

<ROUTINE PRINTA (O)	;"A"
	 <COND (<OR ;<FSET? .O ,PERSONBIT> <FSET? .O ,NARTICLEBIT>> T)
	       (<FSET? .O ,VOWELBIT> <TELL "an ">)
	       (T <TELL "a ">)>
	 <TELL D .O>>

<GLOBAL P-IT-WORDS <TABLE 0 0>>	"adj & noun for IT"

<ROUTINE THIS-IS-IT (OBJ)
 <COND (<EQUAL? .OBJ <> ,NOT-HERE-OBJECT ,PLAYER>
	<RTRUE>)
       (<EQUAL? .OBJ ,INTDIR ,GLOBAL-HERE ,ROOMS>
	<RTRUE>)
       (<AND <VERB? WALK ;"WALK-TO FACE"> <==? .OBJ ,PRSO>>
	<RTRUE>)>
 <COND (<NOT <FSET? .OBJ ,PERSONBIT>>
	<PUT ,P-IT-WORDS 0 <GET ,P-ADJW ,NOW-PRSI>>
	<PUT ,P-IT-WORDS 1 <GET ,P-NAMW ,NOW-PRSI>>
	<FSET ,IT ,TOUCHBIT>	;"to cause pronoun 'it' in output"
	<SETG P-IT-OBJECT .OBJ>)
       (<FSET? .OBJ ,FEMALE>
	<FSET ,HER ,TOUCHBIT>
	<SETG P-HER-OBJECT .OBJ>)
       ;(<FSET? .OBJ ,PLURALBIT>
	<FSET ,THEM ,TOUCHBIT>
	<SETG P-THEM-OBJECT .OBJ>)
       (T
	<FSET ,HIM ,TOUCHBIT>
	<SETG P-HIM-OBJECT .OBJ>)>
 <RTRUE>>

<ROUTINE NO-PRONOUN? (OBJ "OPTIONAL" (CAP 0))
	<COND (<EQUAL? .OBJ ,PLAYER>
	       <RFALSE>)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<AND <EQUAL? .OBJ ,P-IT-OBJECT>
			   <FSET? ,IT ,TOUCHBIT>>
		      <RFALSE>)>)
	      (<FSET? .OBJ ,FEMALE>
	       <COND (<AND <EQUAL? .OBJ ,P-HER-OBJECT>
			   <FSET? ,HER ,TOUCHBIT>>
		      <RFALSE>)>)
	      ;(<FSET? .OBJ ,PLURALBIT>
	       <COND (<AND <EQUAL? .OBJ ,P-THEM-OBJECT>
			   <FSET? ,THEM ,TOUCHBIT>>
		      <RFALSE>)>)
	      (T
	       <COND (<AND <EQUAL? .OBJ ,P-HIM-OBJECT>
			   <FSET? ,HIM ,TOUCHBIT>>
		      <RFALSE>)>)>
	<COND (<ZERO? .CAP> <TELL THE .OBJ>)
	      (<ONE? .CAP> <TELL CTHE .OBJ>)>
	<THIS-IS-IT .OBJ>
	<RTRUE>>

<ROUTINE HE-SHE-IT (OBJ "OPTIONAL" (CAP 0) (VERB <>))	;"C/HE"
	<COND (<NO-PRONOUN? .OBJ .CAP>
	       T)
	      (<NOT <FSET? .OBJ ,PERSONBIT>>
	       <COND (<ZERO? .CAP> <TELL " it">)
		     (<ONE? .CAP> <TELL "It">)>)
	      (<==? .OBJ ,PLAYER>
	       <COND (<ZERO? .CAP> <TELL " you">)
		     (<ONE? .CAP> <TELL "You">)>)
	      (<FSET? .OBJ ,FEMALE>
	       <COND (<ZERO? .CAP> <TELL " she">)
		     (<ONE? .CAP> <TELL "She">)>)
	      ;(<FSET? .OBJ ,PLURALBIT>
	       <COND (<ZERO? .CAP> <TELL " they">)
		     (<ONE? .CAP> <TELL "They">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " he">)
		     (<ONE? .CAP> <TELL "He">)>)>
	<COND (<NOT <ZERO? .VERB>>
	       <PRINTC 32>
	       <COND (<OR <EQUAL? .OBJ ,PLAYER>
			  ;<FSET? .OBJ ,PLURALBIT>>
		      <COND (<=? .VERB "is"> <TELL "are">)
			    (<=? .VERB "has"><TELL "have">)
			    (<=? .VERB "tri"><TELL "try">)
			    (<=? .VERB "empti"><TELL "empty">)
			    (T <TELL .VERB>)>)
		     (T
		      <TELL .VERB>
		      <COND (<OR <EQUAL? .VERB "do" "kiss" "push">
				 <EQUAL? .VERB "tri" "empti">>
			     <TELL !\e>)>
		      <COND (<NOT <EQUAL? .VERB "is" "has">>
			     <TELL !\s>)>)>)>>

<ROUTINE HIM-HER-IT (OBJ "OPTIONAL" (CAP 0) (POSSESS? <>))	;"C/HIS/M"
 <COND (<NO-PRONOUN? .OBJ .CAP>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL "'s">)>)
       (<NOT <FSET? .OBJ ,PERSONBIT>>
	<COND (<ZERO? .CAP> <TELL " it">) (T <TELL "It">)>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL !\s>)>)
       (<==? .OBJ ,PLAYER>
	<COND (<ZERO? .CAP> <TELL " you">) (T <TELL "You">)>
	<COND (<NOT <ZERO? .POSSESS?>> <TELL !\r>)>)
       ;(<FSET? .OBJ ,PLURALBIT>
	<COND (<NOT <ZERO? .POSSESS?>>
	       <COND (<ZERO? .CAP> <TELL " their">)
		     (T <TELL "Their">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " them">)
		     (T <TELL "Them">)>)>)
       (<FSET? .OBJ ,FEMALE>
	<COND (<ZERO? .CAP> <TELL " her">) (T <TELL "Her">)>)
       (T
	<COND (<NOT <ZERO? .POSSESS?>>
	       <COND (<ZERO? .CAP> <TELL " his">)
		     (T <TELL "His">)>)
	      (T
	       <COND (<ZERO? .CAP> <TELL " him">)
		     (T <TELL "Him">)>)>)>
 <RTRUE>>

"CLOCK for MOONMIST
Copyright (C) 1986 Infocom, Inc.  All rights reserved."

"List of 22 queued routines:
I-ATTENTION
I-BEDTIME
I-BUTLER-COOKS
I-BUTLER-HINTS
I-BUTLER-SERVES
I-COME-TO
I-DINNER
I-DINNER-SIT
I-DINNER-TALK
I-DISCOVERED
I-DRAGON-EYE
I-FOLLOW
I-FOUND-IT
I-FOUND-PASSAGES
I-FRIEND-GREETS
I-LIONEL-SPEAKS
I-PROMPT
I-REPLY
I-SEARCH
I-SHOT
I-TOUR
I-WITHDRAW"

"SCORE INDICATES HOURS / MOVES = MINUTES"

<GLOBAL SCORE:NUMBER 19>
<GLOBAL MOVES:NUMBER 0>
<GLOBAL PRESENT-TIME:NUMBER <SETG PRESENT-TIME-ATOM 420 ;1140>>
<GLOBAL CLOCKER-RUNNING:NUMBER 0>

<CONSTANT DINNER-TIME <SETG DINNER-TIME 480>>
<CONSTANT LIONEL-TIME <SETG LIONEL-TIME 510>>
<CONSTANT SEARCH-TIME 600>
<CONSTANT BED-TIME 720>

<CONSTANT C-TABLELEN 138>	;"and one for good measure"

<GLOBAL C-TABLE
 <TABLE 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
	0 0 I-SHOT	;"first to run"
	0 0 I-COME-TO
	0 0 I-REPLY
	0 0 I-TOUR
	0 0 I-BUTLER-COOKS
	0 0 I-BUTLER-HINTS
	1 %<- ,DINNER-TIME ,PRESENT-TIME-ATOM 10> I-DINNER
	0 0 I-DINNER-SIT
	1 10 I-DRAGON-EYE
	1 -1 I-ATTENTION
	1 -1 I-FOLLOW	;"last to run"
	1  1 I-PROMPT>>

<GLOBAL C-INTS:NUMBER <- 138 <* 12 6>>>
<CONSTANT C-INTLEN 6>
<CONSTANT C-ENABLED? 0>
<CONSTANT C-TICK 1>
<CONSTANT C-RTN 2>

<ROUTINE QUEUE (RTN TICK "AUX" CINT)
	 ;#DECL ((RTN) ATOM (TICK) FIX (CINT) <PRIMTYPE VECTOR>)
	 <PUT <SET CINT <INT .RTN>> ,C-TICK .TICK>
	 <PUT .CINT ,C-ENABLED? 1>
	 .CINT>

<ROUTINE INT (RTN "OPTIONAL" (DEMON <>) E C INT)
	 ;#DECL ((RTN) ATOM (DEMON) <OR ATOM FALSE> (E C INT) <PRIMTYPE
							      VECTOR>)
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<SETG C-INTS <- ,C-INTS ,C-INTLEN>>
			;<AND .DEMON <SETG C-DEMONS <- ,C-DEMONS ,C-INTLEN>>>
			<SET INT <REST ,C-TABLE ,C-INTS>>
			<PUT .INT ,C-RTN .RTN>
			<RETURN .INT>)
		       (<EQUAL? <GET .C ,C-RTN> .RTN> <RETURN .C>)>
		 <SET C <REST .C ,C-INTLEN>>>>

;<ROUTINE ENABLED? (RTN)
	<NOT <ZERO? <GET <INT .RTN> ,C-ENABLED?>>>>

<ROUTINE QUEUED? (RTN "AUX" C)
	<SET C <INT .RTN>>
	<COND (<ZERO? <GET .C ,C-ENABLED?>> <RFALSE>)
	      (T <GET .C ,C-TICK>)>>

<GLOBAL CLOCK-WAIT:FLAG <>>

<ROUTINE CLOCKER ("AUX" C E TICK (FLG <>) VAL)
	 ;#DECL ((C E) <PRIMTYPE VECTOR> (TICK) FIX ;(FLG) ;<OR FALSE ATOM>)
	 <COND (,CLOCK-WAIT <SETG CLOCK-WAIT <>> <RFALSE>)>
	 <SETG PRESENT-TIME <+ ,PRESENT-TIME 1>>
	 <COND (<G? ,PRESENT-TIME 1139 ;1859>
		<TIMES-UP>)>
	 <COND (<G? <SETG MOVES <+ ,MOVES 1>> 59>
		<SETG MOVES 0>
		<COND (<G? <SETG SCORE <+ ,SCORE 1>> 23>
		       <SETG SCORE 0>)>)>
	 <SET C <REST ,C-TABLE ,C-INTS>>
	 <SET E <REST ,C-TABLE ,C-TABLELEN>>
	 <REPEAT ()
		 <COND (<==? .C .E>
			<RETURN .FLG>)
		       (<NOT <ZERO? <GET .C ,C-ENABLED?>>>
			<SET TICK <GET .C ,C-TICK>>
			<COND (<NOT <ZERO? .TICK>>
			       <PUT .C ,C-TICK <- .TICK 1>>
			       <COND (<AND <NOT <G? .TICK 1>>
				           <SET VAL <APPLY <GET .C ,C-RTN>>>>
				      <COND (<OR <ZERO? .FLG>
						 <==? .VAL ,M-FATAL>>
					     <SET FLG .VAL>)>)>)>)>
		 <SET C <REST .C ,C-INTLEN>>>>

"These routines were moved here from GOAL:"

<ROUTINE I-FOLLOW ("OPTIONAL" (GARG <>) "AUX" (FLG <>) (CNT 0) GT (VAL 0))
       %<DEBUG-CODE
	 <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		<TELL "[I-FOLLOW:">
		<COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
	 <REPEAT ()
		 <COND (<G? <SET CNT <+ .CNT 1>> ,GHOST-NEW-C ;,CHARACTER-MAX>
			<RETURN>)
		       (<AND <GET <SET GT <GET ,GOAL-TABLES .CNT>> ,GOAL-S>
			     <OR <NOT <ZERO? <GET .GT ,GOAL-ENABLE>>>
				 ;<0? <GET .GT ,ATTENTION>>>>
			;<PUT .GT ,GOAL-ENABLE 1>
			<COND (<SET VAL
				    <FOLLOW-GOAL <GET ,CHARACTER-TABLE .CNT>>>
			       <COND (<NOT <==? .FLG ,M-FATAL>>
				      <SET FLG .VAL>)>)>)>>
	 %<DEBUG-CODE <COND (,IDEBUG <TELL N .FLG !\] CR>)>>
	 .FLG>

<ROUTINE I-ATTENTION ("OPTIONAL" (GARG <>)
		      "AUX" (FLG <>) (CNT 0) ATT GT PER RM)
 %<DEBUG-CODE <COND (<OR ,IDEBUG <==? .GARG ,G-DEBUG>>
		     <TELL "[I-ATTENTION:">
		     <COND (<==? .GARG ,G-DEBUG> <RFALSE>)>)>>
 <REPEAT ()
	<COND (<IGRTR? CNT ,GHOST-NEW-C ;,CHARACTER-MAX>
	       <RETURN>)>
	<SET GT <GET ,GOAL-TABLES .CNT>>
	<SET ATT <GET .GT ,ATTENTION>>
	<COND (<NOT <G? .ATT 0>> <AGAIN>)>
	<DEC ATT>
	<SET PER <GET ,CHARACTER-TABLE .CNT>>
	<COND (<EQUAL? .PER ,CONFESSED ,CAPTOR ,FOLLOWER>
	       <AGAIN>)>
	<SETG GOAL-PERSON .PER>
	<COND ;(<0? .PER>
	       <TELL "[!! I-ATT: PER=0]" CR>)
	      (<0? .ATT>
	       ;<FCLEAR .PER ,TOUCHBIT>
	       <COND ;(<==? .PER ,BUTLER>
		      <SET FLG T>
		      <MOVE ,BUTLER <GET .GT ,GOAL-F>>
		      <TELL
'BUTLER " says, \"You really must excuse me now, "TN",\" and leaves." CR>)
		     (<OR <L? ,BED-TIME ,PRESENT-TIME>
			  <==? <GET .GT ,GOAL-FUNCTION> ,X-RETIRES>>
		      <SET RM <GET ,CHAR-ROOM-TABLE <+ 1 .CNT>>>
		      <COND (<IN? .PER .RM>
			     <GOODNIGHT .RM .PER>)
			    (T
			     <PUT .GT ,GOAL-FUNCTION ,X-RETIRES>
			     <ESTABLISH-GOAL .PER .RM>)>)
		     (<T? <SET RM <GET .GT ,GOAL-QUEUED>>>
		      <PUT .GT ,GOAL-QUEUED 0>
		      <ESTABLISH-GOAL .PER .RM>)
		     (T
		      <PUTP .PER ,P?LDESC 17 ;"preparing to leave">
		      <PUT .GT ,GOAL-ENABLE 1>)>)
	      (<AND <==? .ATT 1>
		    <IN? .PER ,HERE>
		    <D-APPLY "Impatient"<GET .GT ,GOAL-FUNCTION>,G-IMPATIENT>>
	       <SET FLG T>)>
	<PUT .GT ,ATTENTION .ATT>>
 %<DEBUG-CODE <COND (,IDEBUG <TELL N .FLG !\] CR>)>>
 .FLG>
