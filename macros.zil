"MACROS for MOONMIST
Copyright (c) 1986 Infocom, Inc.  All rights reserved."

;<TELL-TOKENS	CR	<CRLF>
		N *	<PRINTN .X>
		C *	<PRINTC .X>
		D *	<PRINTD .X>
		A *	<PRINTA .X>
		FN	<PRINT-NAME ,FIRST-NAME>
		LN	<PRINT-NAME ,LAST-NAME>
		TN	<TITLE-NAME>
		THE *		<PRINTT .X>
		CTHE *		<START-SENTENCE .X>
		CHE * *:ATOM	<HE-SHE-IT .X 1 .Y>
		CHE *		<HE-SHE-IT .X 1>
		HE * *:ATOM	<HE-SHE-IT .X 0 .Y>
		HE *		<HE-SHE-IT .X>
		V * *		<HE-SHE-IT .X -1 .Y>
		HIM *		<HIM-HER-IT .X>
		HIS *		<HIM-HER-IT .X 0 T>
		CHIS *		<HIM-HER-IT .X 1 T>>

<DEFMAC VERB? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				     (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L
			     (<CHTYPE <PARSE <STRING "V?"<SPNAME .ATM>>> GVAL>
			      !.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSA !.L> !.O)>
		<SET L ()>>>

<DEFMAC DOBJ? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L (<COND (<TYPE? .ATM ATOM>
				       <CHTYPE .ATM GVAL>)
				      (T .ATM)>
				!.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSO !.L> !.O)>
		<SET L ()>>>

<DEFMAC IOBJ? ("TUPLE" ATMS "AUX" (O ()) (L ())) 
	<REPEAT ()
		<COND (<EMPTY? .ATMS>
		       <RETURN!- <COND (<LENGTH? .O 1> <NTH .O 1>)
				       (ELSE <FORM OR !.O>)>>)>
		<REPEAT ()
			<COND (<EMPTY? .ATMS> <RETURN!->)>
			<SET ATM <NTH .ATMS 1>>
			<SET L (<COND (<TYPE? .ATM ATOM>
				       <CHTYPE .ATM GVAL>)
				      (T .ATM)>
				!.L)>
			<SET ATMS <REST .ATMS>>
			<COND (<==? <LENGTH .L> 3> <RETURN!->)>>
		<SET O (<FORM EQUAL? ',PRSI !.L> !.O)>
		<SET L ()>>>

<DEFMAC RFATAL ()
	'<PROG () <PUSH 2> <RSTACK>>>

<DEFMAC PROB ('BASE?)
	<FORM NOT <FORM L? .BASE? '<RANDOM 100>>>>

<DEFMAC TELL ("ARGS" A)
 <FORM PROG ()
  !<MAPF ,LIST
    <FUNCTION ("AUX" E P O)
     <COND (<EMPTY? .A> <MAPSTOP>)
	   (<SET E <NTH .A 1>>
	    <SET A <REST .A>>)>
     <COND (<TYPE? .E ATOM>
	    <COND (<OR <=? <SET P <SPNAME .E>>
			   "CRLF">
		       <=? .P "CR">>
		   <MAPRET '<CRLF>>)
		  (<=? .P "FN">
		   <MAPRET '<PRINT-NAME ,FIRST-NAME>>)
		  (<=? .P "LN">
		   <MAPRET '<PRINT-NAME ,LAST-NAME>>)
		  (<=? .P "TN">
		   <MAPRET '<TITLE-NAME>>)
		  (<EMPTY? .A>
		   <ERROR INDICATOR-AT-END? .E>)
		  (ELSE
		   <SET O <NTH .A 1>>
		   <SET A <REST .A>>
		   <COND (<OR <=? <SET P <SPNAME .E>>
				  "DESC">
			      <=? .P "D">
			      <=? .P "OBJ">
			      <=? .P "O">>
			  <MAPRET <FORM PRINTD .O>>)
			 (<OR <=? .P "A">
			      <=? .P "AN">>
			  <MAPRET <FORM PRINTA .O>>)
			 (<OR ;<=? .P "T">
			      <=? .P "THE">>
			  <MAPRET <FORM PRINTT .O>>)
			 (<OR ;<=? .P "CT">
			      <=? .P "CTHE">>
			  <MAPRET <FORM START-SENTENCE .O>>)
			 (<=? .P "CHE">
			  <COND (<OR <EMPTY? .A>
				     <NOT <TYPE? <NTH .A 1> ATOM>>>
				 <MAPRET <FORM HE-SHE-IT .O T>>)
				(T
				 <SET P <SPNAME <NTH .A 1>>>
				 <SET A <REST .A>>
				 <MAPRET <FORM HE-SHE-IT .O T .P>>)>)
			 (<=? .P "HE">
			  <COND (<OR <EMPTY? .A>
				     <NOT <TYPE? <NTH .A 1> ATOM>>>
				 <MAPRET <FORM HE-SHE-IT .O>>)
				(T
				 <SET P <SPNAME <NTH .A 1>>>
				 <SET A <REST .A>>
				 <MAPRET <FORM HE-SHE-IT .O 0 .P>>)>)
			 (<=? .P "V">
			  <SET P <SPNAME <NTH .A 1>>>
			  <SET A <REST .A>>
			  <MAPRET <FORM HE-SHE-IT .O -1 .P>>)
			 (<=? .P "HIM">
			  <MAPRET <FORM HIM-HER-IT .O>>)
			 ;(<=? .P "CHIM">
			  <MAPRET <FORM HIM-HER-IT .O T>>)
			 (<=? .P "HIS">
			  <MAPRET <FORM HIM-HER-IT .O '<> T>>)
			 (<=? .P "CHIS">
			  <MAPRET <FORM HIM-HER-IT .O T T>>)
			 (<OR <=? .P "NUM">
			      <=? .P "N">>
			  <MAPRET <FORM PRINTN .O>>)
			 (<OR ;<=? .P "CHAR">
			      ;<=? .P "CHR">
			      <=? .P "C">>
			  <MAPRET <FORM PRINTC <ASCII .O>>>)
			 (ELSE
			  <MAPRET <FORM PRINT <FORM GETP .O .E>>>)>)>)
	   (<TYPE? .E CHARACTER>
	    <MAPRET <FORM PRINTC <ASCII .E>>>)
	   (<TYPE? .E STRING ZSTRING>
	    <MAPRET <FORM PRINTI .E>>)
	   (<AND <TYPE? .E FORM>
		 <==? <NTH .E 1> QUOTE>>
	    <MAPRET <FORM PRINTD <FORM GVAL <NTH .E 2>>>>)
	   (<TYPE? .E FORM LVAL GVAL>
	    <MAPRET <FORM PRINT .E>>)
	   (ELSE <ERROR UNKNOWN-TYPE .E>)>>>>>

<DEFMAC ONE? ('TERM)
	<FORM EQUAL? .TERM 1 T>>

;<ROUTINE ONE? (NUM) <EQUAL? .NUM 1 T>>

<SETG C-ENABLED? 0>
<SETG C-ENABLED 1>
<SETG C-DISABLED 0>

<DEFMAC ENABLE ('INT) <FORM PUT .INT ,C-ENABLED? 1>>

<DEFMAC DISABLE ('INT) <FORM PUT .INT ,C-ENABLED? 0>>

;<DEFMAC FLAMING? ('OBJ)
	<FORM AND <FORM FSET? .OBJ ',FLAMEBIT>
	          <FORM FSET? .OBJ ',ONBIT>>>

<DEFMAC OPENABLE? ('OBJ)
	<FORM OR <FORM FSET? .OBJ ',DOORBIT>
	         <FORM FSET? .OBJ ',CONTBIT>>> 

<DEFMAC ABS ('NUM)
	<FORM COND (<FORM L? .NUM 0> <FORM - 0 .NUM>)
	           (T .NUM)>>

<DEFMAC GET-REXIT-ROOM ('PT)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM GET .PT ',REXIT>)
	      (T <FORM GETB .PT ',REXIT>)>>

<DEFMAC GET-DOOR-OBJ ('PT)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM GET .PT ',DEXITOBJ>)
	      (T <FORM GETB .PT ',DEXITOBJ>)>>

<DEFMAC GET/B ('TBL 'PTR)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM GET .TBL .PTR>)
	      (T <FORM GETB .TBL .PTR>)>>

<DEFMAC PUT/B ('TBL 'PTR 'OBJ)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM PUT .TBL .PTR .OBJ>)
	      (T <FORM PUTB .TBL .PTR .OBJ>)>>

<DEFMAC ZMEMQ/B ('OBJ 'TBL)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM ZMEMQ .OBJ .TBL>)
	      (T <FORM ZMEMQB .OBJ .TBL>)>>

<DEFMAC RMGL-SIZE ('TBL)
	<COND (<AND <GASSIGNED? PLUS-MODE> ,PLUS-MODE>
	       <FORM - <FORM / <FORM PTSIZE .TBL> 2> 1>)
	      (T <FORM - <FORM PTSIZE .TBL> 1>)>>

<DEFMAC GT-O ('OBJ)
	<FORM GET ',GOAL-TABLES <FORM GETP .OBJ ',P?CHARACTER>>>

<DEFMAC T? ('TERM)
	<FORM NOT <FORM ZERO? .TERM>>>

<DEFINE PSEUDO ("TUPLE" V)
	<MAPF ,PLTABLE
	      <FUNCTION (OBJ)
		   <COND (<N==? <LENGTH .OBJ> 3>
			  <ERROR BAD-THING .OBJ>)>
		   <MAPRET <COND (<NTH .OBJ 2>
				  <VOC <SPNAME <NTH .OBJ 2>> NOUN>)>
			   <COND (<NTH .OBJ 1>
				  <VOC <SPNAME <NTH .OBJ 1>> ADJECTIVE>)>
			   <3 .OBJ>>>
	      .V>>
