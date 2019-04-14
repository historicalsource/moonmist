

	.FUNCT	PLAYER-NAME-F
	CALL	DO-INSTEAD-OF,PLAYER,PLAYER-NAME
	RTRUE	


	.FUNCT	PLAYER-F,ARG=0,L=0
	EQUAL?	ARG,M-WINNER /?CCL3
	EQUAL?	PRSO,PLAYER \FALSE
	EQUAL?	PRSA,V?THANKS,V?SORRY /?CTR8
	EQUAL?	PRSA,V?HELLO,V?DANCE,V?ARREST \?CCL9
?CTR8:	CALL	HAR-HAR
	RTRUE	
?CCL9:	EQUAL?	PRSA,V?EXAMINE \?CCL13
	PRINTI	"You are wearing"
	ZERO?	NOW-WEARING \?PRG21
	PRINTI	" nothing"
	JUMP	?CND16
?PRG21:	CALL	PRINTT,NOW-WEARING
?CND16:	FIRST?	PLAYER >L /?PRG23
?PRG23:	ZERO?	L /?REP24
	FSET?	L,WORNBIT \?CND25
	EQUAL?	L,NOW-WEARING /?CND25
	PRINTI	" and"
	CALL	PRINTT,L
?CND25:	NEXT?	L >L /?PRG23
	JUMP	?PRG23
?REP24:	PRINTR	"."
?CCL13:	EQUAL?	PRSA,V?SEARCH \?CCL36
	CALL	PERFORM,V?INVENTORY
	RTRUE	
?CCL36:	EQUAL?	PRSA,V?SMELL \FALSE
	PRINTI	"You smell "
	ZERO?	WASHED /?PRG46
	PRINTR	"clean and fresh."
?PRG46:	PRINTR	"as if you need washing."
?CCL3:	CALL	DIVESTMENT?,NOW-WEARING
	ZERO?	STACK /?CCL49
	CALL	NO-CHANGING?
	ZERO?	STACK \TRUE
	ZERO?	NOW-WEARING /FALSE
	EQUAL?	PRSA,V?REMOVE,V?DISEMBARK /FALSE
	CALL	FIRST-YOU,STR?139,NOW-WEARING
	FCLEAR	NOW-WEARING,WORNBIT
	SET	'NOW-WEARING,FALSE-VALUE
	RFALSE	
?CCL49:	ZERO?	PRSI /?CCL58
	EQUAL?	PRSA,V?SEARCH-FOR /?CCL58
	FSET?	PRSI,SECRETBIT \?CCL58
	FSET?	PRSI,SEENBIT /?CCL58
	CALL	NOT-FOUND,PRSI
	RTRUE	
?CCL58:	ZERO?	PRSO /?CCL64
	EQUAL?	PRSA,V?WALK,V?FIND /?CCL64
	FSET?	PRSO,SECRETBIT \?CCL64
	FSET?	PRSO,SEENBIT /?CCL64
	CALL	NOT-FOUND,PRSO
	RTRUE	
?CCL64:	ZERO?	AWAITING-REPLY /?CCL70
	EQUAL?	PRSA,V?WALK-TO /?CTR69
	EQUAL?	PRSA,V?WALK,V?THROUGH,V?FOLLOW \?CCL70
?CTR69:	SET	'CLOCK-WAIT,TRUE-VALUE
	CALL	PLEASE-ANSWER
	RTRUE	
?CCL70:	LOC	PLAYER >L
	EQUAL?	L,HERE,CAR /FALSE
	ZERO?	P-WALK-DIR /?CCL79
	CALL	TOO-BAD-SIT-HIDE
	RSTACK	
?CCL79:	EQUAL?	PRSO,FALSE-VALUE,ROOMS,L /FALSE
	EQUAL?	PRSA,V?FIND /?CTR82
	EQUAL?	PRSA,V?SEARCH-FOR,V?SEARCH,V?WALK-TO \?CCL83
?CTR82:	EQUAL?	PRSO,SLEEP-GLOBAL /FALSE
	CALL	TOO-BAD-SIT-HIDE
	RSTACK	
?CCL83:	CALL	SPEAKING-VERB?
	ZERO?	STACK \FALSE
	CALL	GAME-VERB?
	ZERO?	STACK \FALSE
	CALL	REMOTE-VERB?
	ZERO?	STACK \FALSE
	EQUAL?	PRSA,V?SMILE /FALSE
	EQUAL?	PRSA,V?SHOOT,V?NOD,V?LOOK-ON /FALSE
	EQUAL?	PRSA,V?LISTEN,V?FAINT,V?AIM /FALSE
	CALL	HELD?,PRSO
	ZERO?	STACK \FALSE
	CALL	HELD?,PRSO,GLOBAL-OBJECTS
	ZERO?	STACK \FALSE
	EQUAL?	L,CHAIR-DINING \?CCL105
	IN?	PRSO,TABLE-DINING /FALSE
?CCL105:	EQUAL?	PRSA,V?EXAMINE /FALSE
	CALL	HELD?,PRSO,L
	ZERO?	STACK \?CCL111
	CALL	TOO-BAD-SIT-HIDE
	RSTACK	
?CCL111:	ZERO?	PRSI /FALSE
	CALL	HELD?,PRSI
	ZERO?	STACK \FALSE
	CALL	HELD?,PRSI,GLOBAL-OBJECTS
	ZERO?	STACK \FALSE
	CALL	HELD?,PRSI,L
	ZERO?	STACK \FALSE
	CALL	TOO-BAD-SIT-HIDE
	RSTACK	


	.FUNCT	PLEASE-ANSWER,P
	GETB	QUESTIONERS,AWAITING-REPLY >P
	PRINTD	P
	PRINTI	" says, """
	EQUAL?	P,BUTLER,DOCTOR \?PRG8
	PRINTI	"Pardon me, "
	CALL	TITLE-NAME
	PRINTI	", but"
	JUMP	?PRG10
?PRG8:	PRINTI	"Wait a mo'."
?PRG10:	PRINTR	" I asked you a question."""


	.FUNCT	TOO-BAD-SIT-HIDE
	MOVE	WINNER,HERE
	CALL	FIRST-YOU,STR?163
	RFALSE	


	.FUNCT	FRIEND-D,ARG=0
	CALL	DESCRIBE-PERSON,FRIEND
	RTRUE	


	.FUNCT	I-REPLY,GARG=0,P,X
	ZERO?	AWAITING-REPLY /FALSE
	EQUAL?	AWAITING-REPLY,BUTLER-1-R,BUTLER-2-R,BUTLER-3-R /?CTR4
	EQUAL?	AWAITING-REPLY,BUTLER-4-R \?CCL5
?CTR4:	CALL	QUEUED?,I-BUTLER-HINTS
	ZERO?	STACK /?CND8
	CALL	QUEUE,I-BUTLER-HINTS,CLOCKER-RUNNING
?CND8:	SET	'P,BUTLER
	JUMP	?CND1
?CCL5:	EQUAL?	AWAITING-REPLY,FRIEND-C \?CCL11
	EQUAL?	VARIATION,FRIEND-C \?CCL11
	SET	'P,FRIEND
	JUMP	?CND1
?CCL11:	EQUAL?	AWAITING-REPLY,DEB-C \?CCL15
	SET	'P,DEB
	JUMP	?CND1
?CCL15:	EQUAL?	AWAITING-REPLY,OFFICER-1-R,OFFICER-2-R \?CCL17
	SET	'P,OFFICER
	JUMP	?CND1
?CCL17:	EQUAL?	AWAITING-REPLY,DOCTOR-C \?CND1
	SET	'P,DOCTOR
?CND1:	ZERO?	P \?CCL21
	SET	'AWAITING-REPLY,FALSE-VALUE
	RFALSE	
?CCL21:	GETP	P,P?LINE >X
	ADD	1,X
	PUTP	P,P?LINE,STACK
	ZERO?	X \?CCL24
	CALL	QUEUE,I-REPLY,CLOCKER-RUNNING
	PRINTD	P
	PRINTI	" repeats, ""I said: "
	GET	QUESTIONS,AWAITING-REPLY
	PRINT	STACK
	PRINTI	"""
"
	RETURN	2
?CCL24:	SET	'AWAITING-REPLY,FALSE-VALUE
	PUTP	P,P?LDESC,20
	CALL	VISIBLE?,P
	ZERO?	STACK /?PRG41
	CALL	HE-SHE-IT,P,TRUE-VALUE
	PRINTI	" mutters, ""I'd "
	EQUAL?	P,FRIEND \?PRG37
	PRINTI	"wondered if you"
	JUMP	?PRG39
?PRG37:	PRINTI	"heard that Americans"
?PRG39:	PRINTI	" were rude, but really...!"""
	CRLF	
?PRG41:	RETURN	2


	.FUNCT	FRIEND-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	EQUAL?	AWAITING-REPLY,FRIEND-C \?CCL6
	EQUAL?	PRSA,V?NO,V?YES \?CCL6
	PUTP	FRIEND,P?LDESC,0
	PUTP	FRIEND,P?LINE,0
	SET	'AWAITING-REPLY,FALSE-VALUE
	PRINTI	"""Then you "
	EQUAL?	PRSA,V?YES /?CND11
	PRINTI	"don't "
?CND11:	SET	'P-IT-OBJECT,GHOST-NEW
	PRINTI	"know about my engagement, and the "
	PRINTD	GHOST-OLD
	PRINTR	", and the fact that... that someone is trying to kill me!"""
?CCL6:	CALL	GRAB-ATTENTION,FRIEND
	ZERO?	STACK \?CCL18
	RETURN	2
?CCL18:	EQUAL?	PRSA,V?DESCRIBE \?CCL22
	EQUAL?	PRSO,GHOST-NEW \?CCL22
	PRINTI	"Tammy shakes her head. ""I just don't know if the ghost was "
	PRINTD	LOVER
	PRINTR	". I never saw her, just that portrait by Vivien. The night I saw that ghastly face peering down at me... Well, I was too shaken to remember anything, except that horrible spider dropping down on me!"" She shudders at the memory."
?CCL22:	EQUAL?	PRSA,V?FOLLOW \?CCL28
	EQUAL?	PRSO,PLAYER \?CCL28
	CALL	WILLING?,FRIEND
	ZERO?	STACK /?PRG36
	PRINTI	"""I'll try my best, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"!"""
	CRLF	
	CALL	NEW-FOLLOWER,FRIEND
	RTRUE	
?PRG36:	PRINTR	"""Not just now."""
?CCL28:	EQUAL?	PRSA,V?YES \?CCL39
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?KISS,FRIEND
	RTRUE	
?CCL39:	CALL	COM-CHECK,FRIEND >X
	ZERO?	X /?CCL41
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL41:	CALL	WHY-ME
	RETURN	2
?CCL3:	EQUAL?	PRSA,V?TELL-ABOUT,V?SHOW,V?ASK-ABOUT \?CCL52
	EQUAL?	PRSI,SLEEP-OUTFIT,DINNER-OUTFIT /?CTR51
	EQUAL?	PRSI,EXERCISE-OUTFIT,TWEED-OUTFIT,CAR \?CCL52
?CTR51:	CALL	GRAB-ATTENTION,FRIEND
	ZERO?	STACK \?PRG62
	RETURN	2
?PRG62:	PRINTI	"""It's super!"
	EQUAL?	PRSI,TWEED-OUTFIT /?PRG68
	PRINTI	" And it's "
	PRINTD	YOUR-COLOR
	PRINTC	33
?PRG68:	PRINTR	""""
?CCL52:	CALL	ASKING-ABOUT?,FRIEND >OBJ
	ZERO?	OBJ /?CCL71
	CALL	GRAB-ATTENTION,FRIEND,OBJ
	ZERO?	STACK \?CCL74
	RETURN	2
?CCL74:	EQUAL?	OBJ,CASTLE \?CCL78
	PRINTR	"""Oh, it's such a lovely place. If only I felt safe here!"""
?CCL78:	EQUAL?	OBJ,SEARCHER /?PRD84
	CALL	EVIDENCE?,OBJ
	ZERO?	STACK /?CCL82
?PRD84:	ZERO?	CONFESSED \?PRD87
	GET	TOLD-ABOUT-EVID,FRIEND-C
	ZERO?	STACK /?CCL82
?PRD87:	EQUAL?	FRIEND,SEARCHER /?CCL82
	PRINT	IM-SHOCKED
	RTRUE	
?CCL82:	EQUAL?	OBJ,COUSIN,BUST \?CCL93
	PRINTR	"""Sorry, but I never met the man."""
?CCL93:	EQUAL?	OBJ,DEB \?CCL97
	EQUAL?	VARIATION,FRIEND-C \?CCL97
	PRINT	RHYMES-WITH-RICH
	CRLF	
	RTRUE	
?CCL97:	EQUAL?	OBJ,LENS,LENS-1,LENS-2 \?CCL103
	PRINTI	"""You know I've never worn glasses, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	", or "
	PRINTD	LENS
	PRINTI	"es, either."
	EQUAL?	VARIATION,DOCTOR-C,PAINTER-C \?PRG112
	ZERO?	FOUND-IT-PERM /?PRG112
	PRINTI	" I can't imagine who dropped it."
?PRG112:	PRINTR	""""
?CCL103:	EQUAL?	OBJ,PASSAGE \?CCL115
	ZERO?	FRIEND-FOUND-PASSAGES /?CCL115
	CALL	FRIEND-PASSAGE-STORY
	RSTACK	
?CCL115:	EQUAL?	OBJ,PRIEST-DOOR /?PRG124
	EQUAL?	OBJ,PASSAGE \?CCL119
	GET	FOUND-PASSAGES,FRIEND-C
	ZERO?	STACK \?CCL119
?PRG124:	PRINTC	34
	EQUAL?	OBJ,PASSAGE \?PRG130
	PRINTI	"You mean "
	PRINTD	PASSAGE
	PRINTI	"s like in horror movies? "
?PRG130:	PRINTI	"Golly, I don't know that much about the castle, "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	STACK /?PRG136
	PRINTC	46
?PRG136:	PRINTI	" Maybe Jack could tell you."
	EQUAL?	VARIATION,FRIEND-C \?PRG142
	PRINTI	" Or Iris, who's spent far too much time here."
?PRG142:	PRINTR	""""
?CCL119:	EQUAL?	OBJ,LORD,ROMANCE,FRIEND \?CCL145
	EQUAL?	OBJ,SEARCHER \?CTR144
	GETP	OBJ,P?LDESC
	EQUAL?	STACK,21 /?CCL145
?CTR144:	EQUAL?	OBJ,FRIEND /?PRG155
	FSET?	LORD,TOUCHBIT \?CCL152
?PRG155:	PRINTI	"""Oh, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	", I"
	EQUAL?	VARIATION,LORD-C \?PRG162
	PRINTI	" was"
	JUMP	?PRG164
?PRG162:	PRINTI	"'m"
?PRG164:	PRINTI	" so happy!"" "
	PRINTD	FRIEND
	PRINTI	" gushes. ""The whole thing seem"
	EQUAL?	VARIATION,LORD-C \?PRG171
	PRINTI	"ed "
	JUMP	?PRG173
?PRG171:	PRINTI	"s "
?PRG173:	PRINTI	"just like a fairy tale, or a paperback romance! But "
	EQUAL?	VARIATION,LORD-C \?PRG189
	PRINTI	"lately,"
	LOC	LORD
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \?PRG185
	PRINTI	""" she whispers, """
	JUMP	?PRG187
?PRG185:	PRINTC	32
?PRG187:	PRINTI	"Jack seems cool toward me"
	JUMP	?PRG191
?PRG189:	PRINTI	"I told you all about it in my letter"
?PRG191:	PRINTR	"."""
?CCL152:	MOVE	LORD,HERE
	CALL	LORD-INTRO
	RTRUE	
?CCL145:	EQUAL?	OBJ,LOVER \?CCL194
	PRINTI	"""She lived just down the beach, and from all accounts she spent most of her time hanging about the castle. If she'd stayed home a bit more, "
	PRINTD	ACCIDENT
	PRINTR	" never would've happened -- I mean, her falling in the well and drowning."""
?CCL194:	EQUAL?	OBJ,ACCIDENT \?CCL198
	PRINTI	"""I can't tell you much,"" says "
	PRINTD	FRIEND
	PRINTI	", ""because I wasn't here when it happened. But all the guests here tonight were also here that night. At dinner, they decided to have a wine tasting later in the evening. "
	PRINTD	LOVER
	PRINTI	" was to choose and pour the wine. But when the time came, she didn't show up, so they sent the butler down to the "
	PRINTD	BASEMENT
	PRINTR	", to find her and help carry up the bottles. He came back saying that she'd fallen down the well!"""
?CCL198:	EQUAL?	OBJ,GHOST-OLD \?CCL202
	PRINTI	"""I've told you all I know in my letter, "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	STACK /?PRG209
	PRINTC	46
?PRG209:	PRINTI	" But come to think of it, there's an old "
	PRINTD	HISTORY-BOOK
	PRINTI	" in the "
	PRINTD	LIBRARY
	PRINTI	" that tells about "
	PRINTD	CASTLE
	PRINTR	". You might learn more from that."""
?CCL202:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL212
	PRINTI	"""Since I wrote you, I've seen the ghost again, and this third time was the worst. After working late one night, I was "
	GET	LDESC-STRINGS,17
	PRINT	STACK
	PRINTI	" the office to go to my room. As I opened the door to the "
	PRINTD	CORR-2
	PRINTI	", I saw this ghostly figure with "
	PRINT	LONG-BLOND-HAIR
	PRINTI	" and a dead white face. It was holding a sword and about to attack me!""
"
	PRINTD	FRIEND
	PRINTI	" gulps and her voice quavers as she concludes, ""I s-s-screamed and shrank back inside the office and slammed the door! That's about all I can tell you, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"..."""
	CRLF	
	LOC	LORD
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \?PRG228
	GETP	LORD,P?LINE
	ZERO?	STACK \?PRG228
	PRINTI	"""I was just dozing off when Tammy's scream woke me,"" adds "
	PRINTD	LORD
	PRINTI	". ""By the time I ran into the "
	PRINTD	CORR-2
	PRINTI	", the ghost "
	EQUAL?	VARIATION,FRIEND-C \?PRG226
	PRINTI	"had disappeared."""
	CRLF	
	JUMP	?PRG228
?PRG226:	PRINTI	"was almost gone. I did catch"
	PRINT	WHITISH-GLIMPSE
	PRINTI	" as it disappeared down the tower stairs -- but frankly I was more concerned about "
	PRINTD	FRIEND
	PRINTI	"."""
	CRLF	
?PRG228:	PRINTD	FRIEND
	PRINTR	" fidgets nervously. ""I don't know whether this ghost is real, or someone just play-acting. It can sneak around anywhere it pleases in the whole castle. I just don't understand how a person dressed up like a spook can do that without being caught!"""
?CCL212:	EQUAL?	OBJ,COSTUME,BLOWGUN,TAMARA-EVIDENCE \?CCL231
	EQUAL?	VARIATION,FRIEND-C \?CCL231
	PRINTR	"""I've, uh, never seen it before."""
?CCL231:	CALL	COMMON-ASK-ABOUT,FRIEND,OBJ >X
	ZERO?	X /?CCL237
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL237:	FSET?	OBJ,PERSONBIT \?CCL242
	EQUAL?	OBJ,MAID /?CCL242
	SET	'CLOCK-WAIT,TRUE-VALUE
	PRINTI	"""I already told you about"
	CALL	HIM-HER-IT,OBJ
	PRINTR	" in my letter."""
?CCL242:	EQUAL?	PRSA,V?SHOW \?PRG252
	PRINTI	"""It looks like "
	CALL	PRINTA,OBJ
	PRINTR	" to me."""
?PRG252:	PRINTI	"""I just don't know, "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	STACK /?PRG258
	PRINTC	46
?PRG258:	PRINTR	""""
?CCL71:	EQUAL?	PRSA,V?FOLLOW \?CCL261
	CALL	TOUR?
	ZERO?	STACK \TRUE
?CCL261:	EQUAL?	PRSA,V?HELLO,V?KISS \?CCL265
	CALL	UNSNOOZE,FRIEND
	PUTP	FRIEND,P?LINE,0
	PUTP	FRIEND,P?LDESC,0
	CALL	HE-SHE-IT,FRIEND,TRUE-VALUE,STR?175
	PRINTR	" you with affection. ""I'm so glad you're here!"""
?CCL265:	CALL	PERSON-F,FRIEND,ARG
	RSTACK	


	.FUNCT	TAMARA-EVIDENCE-F
	EQUAL?	PRSA,V?READ,V?LOOK-INSIDE,V?EXAMINE \FALSE
	CALL	NOT-HOLDING?,PRSO
	ZERO?	STACK \TRUE
	PRINTI	"It's a receipt for the purchase of an adder from a pet shop in Frobzance. Someone has written the word ""Iris"" on it and then viciously crossed it out."
	CRLF	
	ZERO?	EVIDENCE-FOUND \?CND8
	CALL	CONGRATS
?CND8:	SET	'EVIDENCE-FOUND,TAMARA-EVIDENCE
	RTRUE	


	.FUNCT	ASKING-ABOUT?,WHO,DR
	EQUAL?	PRSA,V?SHOW,V?CONFRONT,V?ASK-ABOUT \FALSE
	EQUAL?	PRSI,PASSAGE \?CCL6
	CALL	FIND-FLAG-LG,HERE,DOORBIT,SECRETBIT >DR
	ZERO?	DR /?CCL6
	FSET?	DR,OPENBIT /FALSE
?CCL6:	EQUAL?	WHO,PRSO \FALSE
	RETURN	PRSI


	.FUNCT	LORD-INTRO
	SET	'FOLLOWER,LORD
	FSET	LORD,TOUCHBIT
	FSET	LORD,SEENBIT
	FCLEAR	LORD,NDESCBIT
	SET	'QCONTEXT,LORD
	CALL	THIS-IS-IT,LORD
	PRINTI	"""Here comes Jack now!"" exclaims "
	PRINTD	FRIEND
	PRINTI	", as he comes striding toward you. "
	CALL	COMMON-DESC,LORD
	PRINTI	"
""My fiance, "
	PRINTD	LORD
	PRINTC	32
	PRINT	TRESYLLIAN
	PRINTI	","" "
	PRINTD	FRIEND
	PRINT	INTRODUCES
	PRINTI	"him. ""Jack, this is my friend from the States, "
	CALL	TELL-FULL-NAME
	PRINTI	".""
""So you're that famous young sleuth whom the Yanks call "
	ZERO?	GENDER-KNOWN \?CCL9
	PRINTI	"Young "
	JUMP	?PRG12
?CCL9:	CALL	TITLE
?PRG12:	PRINTI	"Sherlock!"" says "
	PRINTD	LORD
	ZERO?	GENDER-KNOWN /?PRG18
	FSET?	PLAYER,FEMALE /?PRG20
?PRG18:	PRINTI	", shaking hands"
?PRG20:	PRINTI	". ""Tammy's told me about the mysteries you've solved"
	ZERO?	GENDER-KNOWN \?CCL24
	PRINTI	". She seems to think you can unravel the mystery of "
	PRINTD	CASTLE
	PRINTR	"."""
?CCL24:	FSET?	PLAYER,FEMALE \?PRG31
	PRINTI	" -- but she never let on you looked so smashing! Welcome to Cornwall, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	" luv!""
Before you know it, he sweeps you into his arms and kisses you warmly! Let's hope "
	PRINTD	FRIEND
	PRINTI	" doesn't mind -- but for the moment all you can see are "
	PRINTD	LORD
	PRINTR	"'s dazzling sapphire-blue eyes."
?PRG31:	PRINTR	"!""
His keen blue eyes size you up with a friendly twinkle. Yet his friendliness seems to be all on the surface -- it may take time to figure out where His Lordship's really coming from."


	.FUNCT	TELL-FULL-NAME
	CALL	TITLE
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	MIDDLE-WORD /?PRG9
	EQUAL?	MIDDLE-WORD,W?COMMA /?CND5
	PRINTC	32
?CND5:	PRINTB	MIDDLE-WORD
?PRG9:	PRINTC	32
	CALL	PRINT-NAME,LAST-NAME
	CALL	TELL-SUFFIX
	RSTACK	


	.FUNCT	LORD-D,ARG=0
	CALL	DESCRIBE-PERSON,LORD
	RTRUE	


	.FUNCT	LORD-GHOST-STORY
	PRINTI	"""No use asking ME, "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	STACK /?PRG7
	PRINTC	46
?PRG7:	PRINTI	" All I caught was"
	PRINT	WHITISH-GLIMPSE
	PRINTI	". "
	EQUAL?	VARIATION,DOCTOR-C,PAINTER-C \?CCL11
	PRINTR	"I couldn't even swear it was a woman; it might've been some bloke in drag."""
?CCL11:	FSET	GHOST-NEW,PERSONBIT
	PRINTI	"She was blonde, definitely female, and about Dee's height...""
"
	PRINTD	LORD
	PRINTR	"'s own face is pale as he adds, ""So, yes, it COULD have been her ghost... or Dee herself."""


	.FUNCT	LORD-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	CALL	GRAB-ATTENTION,LORD
	ZERO?	STACK \?CCL6
	RETURN	2
?CCL6:	EQUAL?	PRSA,V?DESCRIBE \?CCL10
	EQUAL?	PRSO,GHOST-NEW \?CCL10
	EQUAL?	VARIATION,FRIEND-C /?CCL10
	CALL	LORD-GHOST-STORY
	RTRUE	
?CCL10:	EQUAL?	PRSA,V?REPLY,V?ANSWER \?CCL15
	EQUAL?	3,LIONEL-SPEAKS-COUNTER \?CCL15
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK-ABOUT,LORD,ARTIFACT
	RTRUE	
?CCL15:	CALL	COM-CHECK,LORD >X
	ZERO?	X /?CCL19
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL19:	CALL	WHY-ME
	RETURN	2
?CCL3:	CALL	ASKING-ABOUT?,LORD >OBJ
	ZERO?	OBJ /?CCL30
	CALL	GRAB-ATTENTION,LORD,OBJ
	ZERO?	STACK \?CCL33
	RETURN	2
?CCL33:	EQUAL?	OBJ,ACCIDENT \?CCL37
	PRINTI	"Jack takes a deep breath. ""You've heard the bare facts, I assume -- she was in the "
	PRINTD	BASEMENT
	PRINTI	", slipped and fell down the well. The evidence proves what happened: a tent pole she'd stumbled over; her one shoe that came off, with the slippery sole and the loose heel; and of course "
	PRINTD	NECKLACE-OF-D
	PRINTI	". I even"
	PRINT	FOUND-FABRIC
	PRINTI	"""
He adds, ""The police never found "
	PRINTD	CORPSE
	PRINTR	". But the well is drawing tide water. No doubt she was swept out to sea."""
?CCL37:	EQUAL?	OBJ,ARTIFACT \?CCL41
	PRINTI	"Jack fidgets and replies, ""Well, ah, we've all HEARD of it, certainly. Uncle Lionel liked to drop teasing hints about how valuable it was. But he was frightfully secretive. He never identified it."
	EQUAL?	LIONEL-SPEAKS-COUNTER,INIT-LIONEL-SPEAKS-COUNTER /?PRG52
	PRINTI	" He's probably playing the same silly game right now."
	ZERO?	LIONEL-SPEAKS-COUNTER /?PRG52
	PRINTI	" Let's hear the old boy out."
?PRG52:	PRINTR	""""
?CCL41:	EQUAL?	OBJ,CASTLE \?CCL55
	PRINTI	"""Well, as I daresay you've heard, the castle's been infested lately with a spook. And it seems bent on harming "
	PRINTD	FRIEND
	PRINTR	". All in all, a very rum go."""
?CCL55:	EQUAL?	OBJ,SEARCHER \?CCL59
	ZERO?	CONFESSED \?PRD62
	GET	TOLD-ABOUT-EVID,LORD-C
	ZERO?	STACK /?CCL59
?PRD62:	EQUAL?	LORD,SEARCHER /?CCL59
	PRINT	IM-SHOCKED
	RTRUE	
?CCL59:	EQUAL?	OBJ,FRIEND,ROMANCE \?CCL68
	PRINTI	"""She's a darling girl, really first-rate."
	EQUAL?	VARIATION,FRIEND-C \?PRG82
	LOC	LORD
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \?PRG78
	PRINTI	""" He whispers, """
	JUMP	?PRG80
?PRG78:	PRINTC	32
?PRG80:	PRINTI	"Although lately she's seemed cool toward me."
?PRG82:	PRINTR	""""
?CCL68:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL85
	EQUAL?	VARIATION,FRIEND-C /?CCL85
	CALL	LORD-GHOST-STORY
	RTRUE	
?CCL85:	EQUAL?	OBJ,CLUE-2 \?CCL89
	EQUAL?	VARIATION,LORD-C /?CCL89
	IN?	OBJ,LORD /?CCL89
	CALL	CLUE-2-STORY,LORD
	RTRUE	
?CCL89:	EQUAL?	OBJ,LENS,LENS-1,LENS-2 \?CCL94
	CALL	HE-SHE-IT,LORD,TRUE-VALUE
	PRINTI	" gives a puzzled shrug, saying, """
	PRINTR	"There's nothing wrong with my eyesight."""
?CCL94:	EQUAL?	OBJ,MAID \?CCL101
	FSET?	LETTER,TOUCHBIT \?CCL101
	PRINT	JACK-THINKS-GLADYS
	PRINTR	""""
?CCL101:	EQUAL?	OBJ,PASSAGE \?CCL107
	GET	FOUND-PASSAGES,LORD-C
	ZERO?	STACK \?CCL107
	PRINTI	"""Hmm... good question. I know there are old tales about "
	PRINTD	CASTLE
	PRINTI	" being honeycombed with "
	PRINTD	PASSAGE
	PRINTR	"s, but I've never actually stumbled on any. Uncle Lionel would have known, but I never asked him before he died, worse luck."""
?CCL107:	EQUAL?	OBJ,PRIEST-DOOR \?CCL113
	PRINTI	"""It's in the "
	PRINTD	DUNGEON
	PRINTI	", close to the curtain wall. Dee used it because her cottage is just down the shore.""
He adds, ""By the way, the name '"
	PRINTD	PRIEST-DOOR
	PRINTI	"' dates back to when the Catholic Church was outlawed in England, and priests had to hide for fear of execution. Many British great houses have "
	PRINTD	PASSAGE
	PRINTR	"s, hiding places, and entrances."""
?CCL113:	CALL	COMMON-ASK-ABOUT,LORD,OBJ >X
	ZERO?	X /?CCL117
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL117:	CALL	TELL-DUNNO,LORD,OBJ
	RSTACK	
?CCL30:	EQUAL?	PRSA,V?RUB,V?KISS \?CCL122
	IN?	FRIEND,HERE \?CND123
	GETP	FRIEND,P?LINE
	ADD	1,STACK
	PUTP	FRIEND,P?LINE,STACK
	CALL	HE-SHE-IT,FRIEND,TRUE-VALUE
	PRINTI	" flashes you an angry look."
	CRLF	
?CND123:	FSET?	PLAYER,FEMALE \FALSE
	CALL	UNSNOOZE,LORD
	PUTP	LORD,P?LINE,0
	PUTP	LORD,P?LDESC,0
	PRINTI	"""I say! You Americans are frightfully friendly!"" says "
	PRINTD	LORD
	PRINTR	"."
?CCL122:	CALL	PERSON-F,LORD,ARG
	RSTACK	


	.FUNCT	CLUE-2-STORY,PER
	PRINTC	34
	PRINTR	"I thought it was just one more of Lionel's weird jokes, or the effect of jungle rot on his brain -- that sort of thing."""


	.FUNCT	TELL-DUNNO,PER,OBJ
	FSET?	OBJ,PERSONBIT \?PRG6
	PRINTR	"""I don't indulge much in idle gossip, you know."""
?PRG6:	PRINTI	"""You know as much as I do"
	EQUAL?	PER,OFFICER \?PRG13
	CALL	IAN-CALLS-YOU
	PRINTR	"."""
?PRG13:	PRINTI	", "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	STACK /?PRG19
	PRINTC	46
?PRG19:	PRINTR	""""


	.FUNCT	JACK-TAPE-F,P
	EQUAL?	PRSA,V?PLAY,V?LISTEN,V?LAMP-ON \FALSE
	PRINTI	"First you hear Lionel: ""This "
	PRINTD	JACK-TAPE
	PRINTI	" should capture any sound in the "
	PRINTD	JACK-ROOM
	PRINTI	" when I run it. Testing, testing,...""
Then you hear Lionel tell "
	PRINTD	LOVER
	PRINTI	" that he suspects Jack of coveting the inheritance and wanting to kill him.
After a pause, Jack tells Lionel, with a cold-blooded chuckle, that his time has come. Then "
	PRINT	LIONELS-VOICE
	PRINTI	" is urgent and muffled, as if he's being smothered! He calls out, ""Jack! Stop!"" and then... silence."
	CRLF	
	FIRST?	HERE >P /?KLU24
?KLU24:	ZERO?	P /?CND6
	CALL	FOUND-PASSAGES-REPEAT,P,JACK-TAPE,TOLD-ABOUT-EVID
?CND6:	IN?	FRIEND,HERE \?CND8
	EQUAL?	CAPTOR,FRIEND /?CND8
	CALL	THIS-IS-IT,FRIEND
	MOVE	FRIEND,TAMARA-ROOM
	PUT	FOLLOW-LOC,FRIEND-C,TAMARA-ROOM
	EQUAL?	FOLLOWER,FRIEND,LORD \?CND12
	SET	'FOLLOWER,0
?CND12:	GETP	FRIEND,P?CHARACTER
	GET	GOAL-TABLES,STACK
	PUT	STACK,GOAL-ENABLE,0
	PUTP	FRIEND,P?LDESC,7
	PRINTD	FRIEND
	PRINTI	"'s eyes fill with tears, and she runs to her room."
	CRLF	
?CND8:	ZERO?	EVIDENCE-FOUND \?CND16
	CALL	CONGRATS
?CND16:	SET	'EVIDENCE-FOUND,JACK-TAPE
	ZERO?	CONFESSED \TRUE
	IN?	LORD,HERE \?CCL22
	CALL	CONFESSION,LORD
	RTRUE	
?CCL22:	CALL	FIND-FLAG-HERE-NOT,PERSONBIT,MUNGBIT,WINNER >P
	ZERO?	P /TRUE
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK-ABOUT,P,JACK-TAPE
	RTRUE	


	.FUNCT	LOVER-D,ARG=0
	CALL	DESCRIBE-PERSON,LOVER
	RTRUE	


	.FUNCT	LOVER-F,ARG=0
	IN?	LOVER-PIC,HERE \?CCL3
	CALL	REMOTE-VERB?
	ZERO?	STACK \?CCL3
	CALL	DO-INSTEAD-OF,LOVER-PIC,LOVER
	RTRUE	
?CCL3:	CALL	PERSON-F,LOVER,ARG
	RSTACK	


	.FUNCT	DEB-D,ARG=0
	CALL	DESCRIBE-PERSON,DEB
	RTRUE	


	.FUNCT	DEB-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	SET	'FAWNING,FALSE-VALUE
	EQUAL?	AWAITING-REPLY,DEB-C \?CCL6
	EQUAL?	PRSA,V?NO,V?YES \?CCL6
	CALL	ESTABLISH-GOAL,DOCTOR,HERE
	PUTP	DEB,P?LDESC,0
	PUTP	DEB,P?LINE,0
	SET	'AWAITING-REPLY,FALSE-VALUE
	EQUAL?	PRSA,V?YES \?PRG14
	PRINTR	"""Splendid!"""
?PRG14:	PRINTR	"""What a pity!"""
?CCL6:	CALL	GRAB-ATTENTION,DEB
	ZERO?	STACK \?CCL17
	RETURN	2
?CCL17:	EQUAL?	PRSA,V?DESCRIBE \?CCL21
	EQUAL?	PRSO,GHOST-NEW \?CCL21
	FSET	GHOST-NEW,PERSONBIT
	PRINTI	"""Well, it appeared to be a woman with "
	PRINT	LONG-BLOND-HAIR
	PRINTI	" in a "
	EQUAL?	VARIATION,DOCTOR-C /?PRG30
	PRINTI	"sleeveless, "
?PRG30:	PRINTI	"silvery white gown. But if you're asking me, 'Was it really poor Dee?' I'm just not sure. "
	EQUAL?	VARIATION,FRIEND-C,LORD-C \?CCL34
	PRINTR	"I didn't see the face that well. But I'd say the figure was average height, and moved in a very feminine way, just as she did -- so it COULD have been her ghost."""
?CCL34:	EQUAL?	VARIATION,PAINTER-C \?PRG41
	PRINTR	"It seemed different from Dee in some way...""
She snaps her fingers, and her eyes brighten maliciously. ""Now I know! The ghost was too tall! Definitely taller than she!"""
?PRG41:	PRINTI	"It was "
	PRINTI	"about the right height, I suppose, but"
	PRINTR	" its gown, with long sleeves and a high neck, seemed different from hers. It lacked her femininity. She was a very feminine woman, you know -- almost seductive, as I'm sure Jack can testify. The ghost was just a sexless spook, one might say."""
?CCL21:	EQUAL?	PRSA,V?FOLLOW \?CCL49
	EQUAL?	PRSO,PLAYER \?CCL49
	CALL	WILLING?,DEB
	ZERO?	STACK /?CCL49
	PRINTI	"""Ooo! I love an adventure, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"!"""
	CRLF	
	CALL	NEW-FOLLOWER,DEB
	RTRUE	
?CCL49:	CALL	COM-CHECK,DEB >X
	ZERO?	X /?CCL56
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL56:	CALL	WINNER-DEFAULT,DEB
	RSTACK	
?CCL3:	CALL	ASKING-ABOUT?,DEB >OBJ
	ZERO?	OBJ /?CCL65
	CALL	GRAB-ATTENTION,DEB,OBJ
	ZERO?	STACK \?CCL68
	RETURN	2
?CCL68:	EQUAL?	OBJ,SEARCHER \?CCL72
	ZERO?	CONFESSED \?PRG77
	GET	TOLD-ABOUT-EVID,DEB-C
	ZERO?	STACK /?CCL72
?PRG77:	PRINT	IM-SHOCKED
	RTRUE	
?CCL72:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL80
	PRINTI	"""It was quite dramatic, really. One night I couldn't sleep, so I got a poetic urge to go up on the "
	PRINTD	DECK
	PRINTI	" in the moonlight and commune with my soul.""
"
	PRINTD	DEB
	PRINTR	" goes on, ""As I started up the tower stairs, I saw this figure in white coming 'round the curve of the stairway. My dear, I absolutely FROZE! The ghost turned 'round and flitted back up the stairs, and by the time I recovered, it was gone!"""
?CCL80:	EQUAL?	OBJ,TAMARA-EVIDENCE \?CCL84
	PRINTR	"""My word! It looks as if someone dislikes me!"""
?CCL84:	CALL	COMMON-ASK-ABOUT,DEB,OBJ >X
	ZERO?	X /?CCL88
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL88:	CALL	TELL-DUNNO,DEB,OBJ
	RSTACK	
?CCL65:	EQUAL?	PRSA,V?DANCE,V?KISS,V?RUB \?CCL93
	CALL	WILLING?,DEB,TRUE-VALUE
	ZERO?	STACK /FALSE
	CALL	UNSNOOZE,DEB
	PUTP	DEB,P?LINE,0
	PUTP	DEB,P?LDESC,0
	PRINTI	"""Oooo"
	CALL	I-JUST-LOVE-IT
	RTRUE	
?CCL93:	CALL	PERSON-F,DEB,ARG
	RSTACK	


	.FUNCT	WILLING?,PER,KISS=0
	ZERO?	KISS \?CCL3
	LESS?	BED-TIME,PRESENT-TIME /FALSE
	CALL	QUEUED?,I-TOUR
	ZERO?	STACK \FALSE
	EQUAL?	HERE,DINING-ROOM /FALSE
	CALL	QUEUED?,I-DINNER-SIT
	ZERO?	STACK \FALSE
	EQUAL?	PER,CONFESSED,CAPTOR /FALSE
	RTRUE	
?CCL3:	EQUAL?	PER,FRIEND \?CCL16
	EQUAL?	VARIATION,FRIEND-C /FALSE
	RTRUE	
?CCL16:	EQUAL?	PER,BUTLER \?CCL21
	EQUAL?	PRSA,V?EMPTY \?CCL24
	EQUAL?	HERE,YOUR-ROOM \FALSE
?CCL24:	EQUAL?	PRSA,V?FOLLOW /FALSE
	RTRUE	
?CCL21:	ZERO?	GENDER-KNOWN /FALSE
	EQUAL?	PER,DEB \?CCL33
	FSET?	PLAYER,FEMALE /FALSE
	RTRUE	
?CCL33:	EQUAL?	PER,OFFICER \FALSE
	FSET?	PLAYER,FEMALE /TRUE
	RFALSE	


	.FUNCT	OFFICER-D,ARG=0
	FSET?	OFFICER,TOUCHBIT \?CCL3
	CALL	DESCRIBE-PERSON,OFFICER
	RTRUE	
?CCL3:	FSET	OFFICER,TOUCHBIT
	FSET	OFFICER,SEENBIT
	RTRUE	


	.FUNCT	I-JUST-LOVE-IT
	PRINTI	"! I just love it when you do that, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTR	"!"""


	.FUNCT	WINNER-DEFAULT,PER
	ZERO?	GENDER-KNOWN /?CCL3
	PRINTC	34
	ZERO?	FAWNING /?PRG10
	PRINTI	"But "
?PRG10:	PRINTI	"I really can't help you with that"
	EQUAL?	PER,OFFICER \?PRG14
	CALL	IAN-CALLS-YOU
?PRG14:	PRINTR	"."""
?CCL3:	CALL	WHY-ME
	RETURN	2


	.FUNCT	OFFICER-F,ARG=0,P,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	SET	'FAWNING,FALSE-VALUE
	EQUAL?	AWAITING-REPLY,OFFICER-1-R,OFFICER-2-R \?CCL6
	EQUAL?	PRSA,V?NO,V?YES \?CCL6
	CALL	ESTABLISH-GOAL,DOCTOR,HERE
	PUTP	OFFICER,P?LDESC,0
	PUTP	OFFICER,P?LINE,0
	PRINTC	34
	EQUAL?	PRSA,V?YES \?CCL13
	PRINTI	"Jolly good"
	EQUAL?	AWAITING-REPLY,OFFICER-1-R \?CND11
	PRINTI	"! You're certainly quick"
	JUMP	?CND11
?CCL13:	EQUAL?	AWAITING-REPLY,OFFICER-1-R \?PRG24
	PRINTI	"I dare say you soon shall"
	JUMP	?CND11
?PRG24:	PRINTI	"Pity"
?CND11:	SET	'AWAITING-REPLY,FALSE-VALUE
	PRINTR	"!"""
?CCL6:	CALL	GRAB-ATTENTION,OFFICER
	ZERO?	STACK \?CCL29
	RETURN	2
?CCL29:	EQUAL?	PRSA,V?DESCRIBE \?CCL33
	EQUAL?	PRSO,GHOST-NEW \?CCL33
	EQUAL?	VARIATION,PAINTER-C \?CCL33
	PRINTI	"""Ghosts don't turn off lights, to my way of thinking. That alone makes me think our "
	PRINTD	GHOST-OLD
	PRINTI	"'s a fake. Somebody's sick idea of a joke, perhaps. "
	FSET	GHOST-NEW,PERSONBIT
	PRINTI	"Otherwise, the masquerade was highly effective. A female figure with "
	PRINT	LONG-BLOND-HAIR
	PRINTR	", wearing the same sort of gown Dee was wearing that awful night she died -- at first it left me breathless. The only flaw, I should say, was the spook's height: too tall for Dee."""
?CCL33:	EQUAL?	PRSA,V?FOLLOW \?CCL43
	EQUAL?	PRSO,PLAYER \?CCL43
	CALL	WILLING?,OFFICER
	ZERO?	STACK /?CCL43
	PRINTI	"""What ho! A bit of sleuthing, eh, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	"?"""
	CRLF	
	CALL	NEW-FOLLOWER,OFFICER
	RTRUE	
?CCL43:	CALL	COM-CHECK,OFFICER >X
	ZERO?	X /?CCL50
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL50:	CALL	WINNER-DEFAULT,OFFICER
	RSTACK	
?CCL3:	CALL	ASKING-ABOUT?,OFFICER >OBJ
	ZERO?	OBJ /?CCL59
	CALL	GRAB-ATTENTION,OFFICER,OBJ
	ZERO?	STACK \?CCL62
	RETURN	2
?CCL62:	EQUAL?	OBJ,SEARCHER \?CCL66
	ZERO?	CONFESSED \?PRG71
	GET	TOLD-ABOUT-EVID,OFFICER-C
	ZERO?	STACK /?CCL66
?PRG71:	PRINT	IM-SHOCKED
	RTRUE	
?CCL66:	EQUAL?	OBJ,LENS,LENS-1,LENS-2 \?CCL74
	CALL	HE-SHE-IT,OFFICER,TRUE-VALUE
	PRINTR	" grins, ""It's not mine. Her Majesty would hardly allow me to serve in her Coldstream Guards were my vision faulty!"""
?CCL74:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL78
	EQUAL?	VARIATION,PAINTER-C \?CCL78
	PRINTI	"""It was the last time I came down here to visit Jack. We had been up late, playing cards in the "
	PRINTD	GAME-ROOM
	PRINTR	". Then Jack toddled off to bed, but I stayed up to read and finish my drink. I must have dozed off with my glass in my hand, for I woke with a start as it crashed to the floor. And the first thing I saw was this figure in white at the other end of the room.""
He goes on, ""Blimey, I thought I was seeing things! For a moment I just gaped at it. Then the spook went haring off out the door, flicking off the light on the way. By the time I found the door, it was gone."""
?CCL78:	CALL	COMMON-ASK-ABOUT,OFFICER,OBJ >X
	ZERO?	X /?CCL84
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL84:	CALL	TELL-DUNNO,OFFICER,OBJ
	RSTACK	
?CCL59:	EQUAL?	PRSA,V?DANCE,V?KISS,V?RUB \?CCL89
	CALL	WILLING?,OFFICER,TRUE-VALUE
	ZERO?	STACK /FALSE
	CALL	UNSNOOZE,OFFICER
	PUTP	OFFICER,P?LINE,0
	PUTP	OFFICER,P?LDESC,0
	PRINTI	"""Hello"
	CALL	I-JUST-LOVE-IT
	RTRUE	
?CCL89:	CALL	PERSON-F,OFFICER,ARG
	RSTACK	


	.FUNCT	IAN-CALLS-YOU
	GETB	LAST-NAME,0
	ZERO?	STACK /FALSE
	PRINTI	", "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	GENDER-KNOWN /TRUE
	FSET?	PLAYER,FEMALE \?PRG12
	PRINTI	" luv"
	RTRUE	
?PRG12:	PRINTI	" old "
	BTST	PRESENT-TIME,1 \?PRG19
	PRINTI	"chap"
	RTRUE	
?PRG19:	PRINTI	"son"
	RTRUE	


	.FUNCT	DOCTOR-D,ARG=0
	FSET?	DOCTOR,TOUCHBIT \?CCL3
	CALL	DESCRIBE-PERSON,DOCTOR
	RTRUE	
?CCL3:	FSET	DOCTOR,TOUCHBIT
	CRLF	
	PRINTC	34
	ZERO?	TOUR-FORCED /?PRG13
	PRINTI	"Oh,"
	JUMP	?PRG15
?PRG13:	PRINTI	"Do excuse me for interrupting,"" "
	PRINTD	FRIEND
	PRINTI	" breaks in, ""but"
?PRG15:	PRINTI	" here comes "
	PRINTD	DOCTOR
	PRINTI	"! I'm sure "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	" wants to meet such a distinguished scientist!""
"
	PRINTI	"A man is coming downstairs. "
	CALL	COMMON-DESC,DOCTOR
	SET	'QCONTEXT,DOCTOR
	CALL	THIS-IS-IT,DOCTOR
	PUTP	DOCTOR,P?LDESC,12
	SET	'AWAITING-REPLY,DOCTOR-C
	CALL	QUEUE,I-REPLY,CLOCKER-RUNNING
	PRINTD	FRIEND
	PRINT	INTRODUCES
	PRINTI	"him as one of Lionel's oldest friends, Dr. Nicholas Wendish.
He's carelessly dressed in rumpled evening clothes, but his hawk eyes peering at you through gold-rimmed specs show ruthless intelligence.
""I read about one of your mystery cases when I was in New York last year, "
	CALL	TITLE-NAME
	PRINTI	","" he probes. """
	GET	QUESTIONS,AWAITING-REPLY
	PRINT	STACK
	PRINTI	"""
"
	RETURN	2


	.FUNCT	DOCTOR-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	EQUAL?	AWAITING-REPLY,DOCTOR-C \?CCL6
	EQUAL?	PRSA,V?NO,V?YES \?CCL6
	PUTP	DOCTOR,P?LDESC,0
	PUTP	DOCTOR,P?LINE,0
	SET	'AWAITING-REPLY,FALSE-VALUE
	PRINTR	"""I see..."""
?CCL6:	CALL	GRAB-ATTENTION,DOCTOR
	ZERO?	STACK \?CCL12
	RETURN	2
?CCL12:	EQUAL?	PRSA,V?DESCRIBE \?CCL16
	EQUAL?	PRSO,GHOST-NEW \?CCL16
	EQUAL?	VARIATION,DOCTOR-C \?CCL16
	PRINTD	DOCTOR
	PRINTI	" shrugs, with a look of distaste, as if he'd like to forget the episode. """
	PRINTI	"I'm afraid I can't tell you any more, "
	CALL	TITLE-NAME
	ZERO?	STACK /?PRG29
	PRINTC	46
?PRG29:	PRINTI	" I assumed the ghost was "
	PRINTD	LOVER
	PRINTI	". It certainly looked like her: a blonde, attractive young woman. If it WASN'T "
	PRINTD	LOVER
	PRINTR	", it was a convincing imposture."""
?CCL16:	CALL	DIVESTMENT?,MUSTACHE
	ZERO?	STACK /?CCL32
	EQUAL?	VARIATION,DOCTOR-C \?CCL35
	PRINT	MUSTACHE-STORY
	RTRUE	
?CCL35:	CALL	HAR-HAR
	RSTACK	
?CCL32:	CALL	COM-CHECK,DOCTOR >X
	ZERO?	X /?CCL39
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL39:	CALL	WHY-ME
	RETURN	2
?CCL3:	CALL	ASKING-ABOUT?,DOCTOR >OBJ
	ZERO?	OBJ /?CCL50
	CALL	GRAB-ATTENTION,DOCTOR,OBJ
	ZERO?	STACK \?CCL53
	RETURN	2
?CCL53:	EQUAL?	OBJ,SEARCHER \?CCL57
	ZERO?	CONFESSED \?PRD60
	GET	TOLD-ABOUT-EVID,DOCTOR-C
	ZERO?	STACK /?CCL57
?PRD60:	EQUAL?	DOCTOR,SEARCHER /?CCL57
	PRINT	IM-SHOCKED
	RTRUE	
?CCL57:	EQUAL?	OBJ,COUSIN,BUST \?CCL66
	PRINTR	"""He loved me as a brother."""
?CCL66:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL70
	EQUAL?	VARIATION,DOCTOR-C \?CCL70
	PRINTI	"The doctor pauses, looking troubled, as if reluctant to speak, or perhaps marshaling his thoughts.
""On the very night after "
	PRINTD	ACCIDENT
	PRINTI	","" he says at last, ""I couldn't sleep. I suppose the tragedy was on my mind. That and the medical cases I have in my London clinic for rare diseases. Anyhow, I took a stroll out in the "
	PRINTD	COURTYARD
	PRINTI	". The fresh sea breeze was very soothing. When I went back inside, I felt ready for sleep. I went in through the "
	PRINTD	OLD-GREAT-HALL
	PRINTI	", you see.""
He goes on, ""Then I saw this ghostly figure in white -- Good Lord, what a shock it gave me! I couldn't move for a moment; I thought "
	PRINTD	LOVER
	PRINTI	" had come back from the dead. As I stood there, staring, the ghost flitted off toward the "
	PRINTD	BASEMENT
	PRINTR	"... I felt no impulse to go after it, I might add."""
?CCL70:	EQUAL?	OBJ,LENS,LENS-1,LENS-2 \?CCL76
	PRINTC	34
	EQUAL?	VARIATION,DOCTOR-C,PAINTER-C \?PRG85
	ZERO?	FOUND-IT-PERM /?PRG85
	PRINTI	"Not mine. "
?PRG85:	PRINTR	"As you see, I wear glasses at all times,"" he says."
?CCL76:	EQUAL?	OBJ,MUSTACHE \?CCL88
	EQUAL?	VARIATION,DOCTOR-C \?CCL88
	PRINT	MUSTACHE-STORY
	RTRUE	
?CCL88:	EQUAL?	OBJ,WENDISH-STUFF \?CCL94
	PRINTR	"""I always bring them along."""
?CCL94:	CALL	COMMON-ASK-ABOUT,DOCTOR,OBJ >X
	ZERO?	X /?CCL98
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL98:	CALL	TELL-DUNNO,DOCTOR,OBJ
	RSTACK	
?CCL50:	CALL	PERSON-F,DOCTOR,ARG
	RSTACK	


	.FUNCT	MUSTACHE-F
	EQUAL?	PRSA,V?TAKE,V?MOVE,V?ASK-FOR /?PRD5
	CALL	DIVESTMENT?,MUSTACHE
	ZERO?	STACK /?CCL3
?PRD5:	IN?	MUSTACHE,DOCTOR \?CCL3
	FSET?	DOCTOR,MUNGBIT \?CCL10
	EQUAL?	VARIATION,DOCTOR-C \FALSE
	FSET	MUSTACHE,TAKEBIT
	FCLEAR	MUSTACHE,TRYTAKEBIT
	RFALSE	
?CCL10:	EQUAL?	VARIATION,DOCTOR-C \?CTR13
	FSET?	MUSTACHE,TOUCHBIT \?CCL14
?CTR13:	CALL	FACE-RED,DOCTOR
	RTRUE	
?CCL14:	FSET	MUSTACHE,TOUCHBIT
	PRINTI	"It comes off, leaving "
	PRINTD	DOCTOR
	PRINTI	" blinking with embarrassment. He grabs it and puts it in place again. "
	PRINT	MUSTACHE-STORY
	RTRUE	
?CCL3:	EQUAL?	PRSA,V?WEAR /?CCL20
	EQUAL?	PRSA,V?PUT \FALSE
	FSET?	PRSI,PERSONBIT \FALSE
?CCL20:	CALL	WEAR-SCARE
	RSTACK	


	.FUNCT	WENDISH-BOOK-F
	EQUAL?	PRSA,V?READ,V?LOOK-INSIDE,V?EXAMINE \FALSE
	CALL	NOT-HOLDING?,PRSO
	ZERO?	STACK \TRUE
	PRINTI	"The "
	PRINTD	WENDISH-BOOK
	PRINTI	" contains an incriminating record of "
	PRINTD	DOCTOR
	PRINTI	"'s fiendish experiments on patients at his clinic. Near the end you read:
""Finally took care of Poldark's granddau. (comely wench), pity she disc'd facts of his end."""
	CRLF	
	ZERO?	EVIDENCE-FOUND \?CND8
	CALL	CONGRATS
?CND8:	SET	'EVIDENCE-FOUND,WENDISH-BOOK
	RETURN	EVIDENCE-FOUND


	.FUNCT	DEALER-D,ARG=0,PER
	CALL	DESCRIBE-PERSON,DEALER
	RTRUE	


	.FUNCT	DEALER-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	CALL	GRAB-ATTENTION,DEALER
	ZERO?	STACK \?CCL6
	RETURN	2
?CCL6:	EQUAL?	PRSA,V?DESCRIBE \?CCL10
	EQUAL?	PRSO,GHOST-NEW \?CCL10
	EQUAL?	VARIATION,PAINTER-C /?CCL10
	PRINTI	"""You're wondering, I presume, if it really was "
	PRINTD	LOVER
	PRINTI	" Hallam's ghost? Frankly, I don't put stock in ghosts, but my answer is... "
	FSET	GHOST-NEW,PERSONBIT
	EQUAL?	VARIATION,FRIEND-C,PAINTER-C,LORD-C \?PRG21
	PRINTI	"possibly. That's as far as I'd go. It was certainly a female figure, in a shimmering whitish gown, sleeveless and cut low. She had "
	PRINT	LONG-BLOND-HAIR
	PRINTI	" like "
	PRINTD	LOVER
	PRINTR	"'s and was about her size. But as for her face -- my view was too brief,"" Hyde shrugs."
?PRG21:	PRINTI	"I'm not at all convinced. Somehow it didn't match my memories of "
	PRINTD	LOVER
	PRINTR	". For one thing, the gown wasn't her style, at all. Her clothes were always quite revealing. The ghost seemed quite covered up at the throat and arms. You might say it totally lacked feminine sex appeal."""
?CCL10:	CALL	COM-CHECK,DEALER >X
	ZERO?	X /?CCL24
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL24:	CALL	WHY-ME
	RETURN	2
?CCL3:	CALL	ASKING-ABOUT?,DEALER >OBJ
	ZERO?	OBJ /?CCL35
	CALL	GRAB-ATTENTION,DEALER,OBJ
	ZERO?	STACK \?CCL38
	RETURN	2
?CCL38:	EQUAL?	OBJ,SEARCHER \?CCL42
	ZERO?	CONFESSED \?PRG47
	GET	TOLD-ABOUT-EVID,DEALER-C
	ZERO?	STACK /?CCL42
?PRG47:	PRINT	IM-SHOCKED
	RTRUE	
?CCL42:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL50
	EQUAL?	VARIATION,PAINTER-C /?CCL50
	PRINTI	"""I came down late one night to get a book that I'd left in the "
	PRINTD	SITTING-ROOM
	PRINTI	". I had just turned 'round to go back upstairs when I saw a ghostly figure in the doorway. It fled as soon as I noticed it, in the "
	PRINTD	INTDIR
	PRINTR	" of the tower.""
He goes on, ""I was stunned, I must admit, so I dare say it took me a moment to collect my wits and go after it. I ran into the tower, but the spectre had vanished. This happened, by the way, a couple of weeks ago, on my last visit to the castle."""
?CCL50:	EQUAL?	OBJ,LENS,LENS-1,LENS-2 \?CCL56
	CALL	HE-SHE-IT,DEALER,TRUE-VALUE
	PRINTR	" displays his monocle, saying, ""This is the only vision aid I require."""
?CCL56:	EQUAL?	OBJ,ARMOR,BUST /?PRG64
	EQUAL?	OBJ,FIGURINE,LOVER-PIC,OIL-PAINTING /?PRG64
	EQUAL?	OBJ,PAINTING-GALLERY,WRITING-DESK \?CCL60
?PRG64:	PRINTR	"""I haven't formed my professional opinion as yet."""
?CCL60:	CALL	COMMON-ASK-ABOUT,DEALER,OBJ >X
	ZERO?	X /?CCL67
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL67:	CALL	TELL-DUNNO,DEALER,OBJ
	RSTACK	
?CCL35:	CALL	PERSON-F,DEALER,ARG
	RSTACK	


	.FUNCT	PAINTER-D,ARG=0
	FSET?	PAINTER,TOUCHBIT \?CCL3
	CALL	DESCRIBE-PERSON,PAINTER
	RTRUE	
?CCL3:	FSET	PAINTER,TOUCHBIT
	FCLEAR	DEALER,NDESCBIT
	LOC	DEALER
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \TRUE
	GETP	DEALER,P?LDESC
	EQUAL?	STACK,2 /FALSE
	RTRUE	


	.FUNCT	PAINTER-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	CALL	GRAB-ATTENTION,PAINTER
	ZERO?	STACK \?CCL6
	RETURN	2
?CCL6:	EQUAL?	PRSA,V?DESCRIBE \?CCL10
	EQUAL?	PRSO,GHOST-NEW \?CCL10
	EQUAL?	VARIATION,PAINTER-C \?CCL10
	FSET	GHOST-NEW,PERSONBIT
	PRINTI	"""It was "
	PRINTD	LOVER
	PRINTI	", or her ghost. What more can I say? A female figure, her size, wearing the same sort of shimmering white gown she had on the night she died -- and unmistakably her face! The likeness was heart-stopping...""
Vivien chokes up for a moment, then dabs her eyes. ""I'm sorry. I shouldn't let my feelings take over this way, but "
	PRINTD	LOVER
	PRINTR	" was such a lovely person!"""
?CCL10:	CALL	COM-CHECK,PAINTER >X
	ZERO?	X /?CCL18
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL18:	CALL	WHY-ME
	RETURN	2
?CCL3:	CALL	ASKING-ABOUT?,PAINTER >OBJ
	ZERO?	OBJ /?CCL29
	CALL	GRAB-ATTENTION,PAINTER,OBJ
	ZERO?	STACK \?CCL32
	RETURN	2
?CCL32:	EQUAL?	OBJ,BUST,FIGURINE \?CCL36
	PRINTR	"""Yes, that's one of my works."""
?CCL36:	EQUAL?	OBJ,SEARCHER \?CCL40
	ZERO?	CONFESSED \?PRD43
	GET	TOLD-ABOUT-EVID,PAINTER-C
	ZERO?	STACK /?CCL40
?PRD43:	EQUAL?	PAINTER,SEARCHER /?CCL40
	PRINT	IM-SHOCKED
	RTRUE	
?CCL40:	EQUAL?	OBJ,FRIEND \?CCL49
	EQUAL?	VARIATION,PAINTER-C \?CCL49
	PRINT	RHYMES-WITH-RICH
	CRLF	
	RTRUE	
?CCL49:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL55
	EQUAL?	VARIATION,PAINTER-C \?CCL55
	CALL	HE-SHE-IT,PAINTER,TRUE-VALUE
	PRINTI	" is somber as she replies, ""I dare say it was morbid of me, but one night I went to the "
	PRINTD	BASEMENT
	PRINTI	", just to try to imagine the horrible scene when poor "
	PRINTD	LOVER
	PRINTI	" suffered her... tragic accident. Suddenly I heard someone calling my name softly. I turned 'round, and there was "
	PRINTD	LOVER
	PRINTI	" herself standing by the stairs"
	PRINTI	"! I went absolutely numb! She smiled faintly, then fled up the stairs. I started to follow, but then I knew it was no use. "
	PRINTD	LOVER
	PRINTR	" is dead and gone, and chasing her ghost won't bring her back to me!"""
?CCL55:	EQUAL?	OBJ,CLUE-2 \?CCL64
	EQUAL?	VARIATION,LORD-C \?CCL64
	IN?	OBJ,PAINTER /?CCL64
	CALL	CLUE-2-STORY,PAINTER
	RTRUE	
?CCL64:	EQUAL?	OBJ,LENS,LENS-1,LENS-2 \?CCL69
	CALL	HE-SHE-IT,PAINTER,TRUE-VALUE
	EQUAL?	VARIATION,PAINTER-C \?PRG77
	PRINTI	" says she wears"
	PRINT	GLASSES-FOR
	PRINTI	", as everyone knows; then she shudders, ""But "
	PRINTD	LENS
	PRINTR	"es -- ugh! -- I could never tolerate them!"""
?PRG77:	PRINTI	" admits to wearing "
	PRINTD	LENS
	PRINTI	"es at all times, and"
	PRINT	GLASSES-FOR
	EQUAL?	VARIATION,DOCTOR-C,PAINTER-C \?PRG86
	ZERO?	FOUND-IT-PERM /?PRG86
	PRINTR	", but she says the lens you found isn't hers. With a cynical smile, she pops out both lenses, one at a time, to show you."
?PRG86:	PRINTR	"."
?CCL69:	EQUAL?	OBJ,LOVER \?CCL89
	PUTP	PAINTER,P?LDESC,7
	PRINTI	"The artist shrugs with a sad, wistful smile. ""What can I say? "
	PRINTD	LOVER
	PRINTR	" was a most unusual girl... utterly unworldly... almost fey. She grew up in a cottage not far from here, you know. Her drowning was a terrible tragedy... and yet... sometimes I'm not sure she WANTED to go on living."" She turns her face away to hide a tear."
?CCL89:	EQUAL?	OBJ,LOVER-PIC \?CCL93
	PRINTI	"""Oh, you mean my portrait of dear "
	PRINTD	LOVER
	PRINTR	". I don't believe I ever saw such skin as hers... or such hair."" She stops speaking and bites her lip."
?CCL93:	EQUAL?	OBJ,OIL-PAINTING \?CCL97
	PRINTR	"""I don't admire the heroic style at all."""
?CCL97:	EQUAL?	OBJ,VIVIEN-STUFF \?CCL101
	PRINTR	"""That's private property. It's no business of yours."""
?CCL101:	CALL	COMMON-ASK-ABOUT,PAINTER,OBJ >X
	ZERO?	X /?CCL105
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?CCL105:	CALL	TELL-DUNNO,PAINTER,OBJ
	RSTACK	
?CCL29:	EQUAL?	PRSA,V?KISS \?CCL110
	GETP	PAINTER,P?LDESC
	EQUAL?	STACK,7 \?CCL110
	PUTP	PAINTER,P?LINE,0
	PRINTR	"""You're sweet."""
?CCL110:	CALL	PERSON-F,PAINTER,ARG
	RSTACK	


	.FUNCT	VIVIEN-DIARY-F
	EQUAL?	PRSA,V?READ /?CCL3
	EQUAL?	PRSA,V?OPEN,V?LOOK-INSIDE,V?EXAMINE \FALSE
?CCL3:	CALL	NOT-HOLDING?,PRSO
	ZERO?	STACK \TRUE
	PRINTD	VIVIEN-DIARY
	PRINTI	" falls open to a tear-stained page, and you read:
""O "
	PRINTD	LOVER
	PRINTI	", sweet "
	PRINTD	LOVER
	PRINTI	"! Jack will pay dearly for your cruel death by losing his new sweetheart..."""
	CRLF	
	ZERO?	EVIDENCE-FOUND \?CND10
	CALL	CONGRATS
?CND10:	SET	'EVIDENCE-FOUND,VIVIEN-DIARY
	RETURN	EVIDENCE-FOUND


	.FUNCT	COUSIN-F
	EQUAL?	HERE,DINING-ROOM \FALSE
	CALL	REMOTE-VERB?
	ZERO?	STACK \FALSE
	CALL	DO-INSTEAD-OF,BUST,COUSIN
	RTRUE	


	.FUNCT	BOLITHO-WILL
	PRINTC	32
	PRINTD	BUTLER
	PRINTI	" will see to the car and bring "
	PRINTD	LUGGAGE
	RTRUE	


	.FUNCT	BUTLER-D,ARG=0,GT,SAID=0,LL=0,L
	FSET?	BUTLER,TOUCHBIT \?CND1
	CALL	DESCRIBE-PERSON,BUTLER
	RTRUE	
?CND1:	FCLEAR	BUTLER,NDESCBIT
	FSET	BUTLER,TOUCHBIT
	EQUAL?	HERE,COURTYARD,FOYER \?CND3
	LOC	LORD
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \?CND3
	GETP	LORD,P?LINE
	ZERO?	STACK \?CND3
	SET	'LL,TRUE-VALUE
?CND3:	EQUAL?	HERE,COURTYARD,FOYER \?CND8
	LOC	FRIEND
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \?CND8
	SET	'SAID,TRUE-VALUE
	PRINTI	"
""We can talk more later, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	","" says "
	PRINTD	FRIEND
	PRINTI	", taking your arm, ""but let's go in now, so you can meet the other guests."
?CND8:	ZERO?	LL /?CCL16
	ZERO?	SAID /?CCL19
	PRINTC	34
	CRLF	
	PRINTI	"""Yes, d"
	JUMP	?PRG24
?CCL19:	SET	'SAID,TRUE-VALUE
	PRINTI	"""D"
?PRG24:	PRINTI	"o come in."
	CALL	BOLITHO-WILL
	PRINTI	","" says "
	PRINTD	LORD
	PRINTI	" as a"
	JUMP	?CND14
?CCL16:	ZERO?	SAID /?PRG32
	CALL	BOLITHO-WILL
	PRINTI	"."""
	CRLF	
	PRINTC	65
	JUMP	?CND14
?PRG32:	PRINTC	65
?CND14:	CALL	THIS-IS-IT,BUTLER
	PRINTI	"n elderly butler appears."
	ZERO?	SAID \?CND36
	PRINTI	" He bows slightly to you."
?CND36:	GETP	BUTLER,P?CHARACTER
	GET	GOAL-TABLES,STACK >GT
	CALL	META-LOC,LUGGAGE >L
	EQUAL?	L,YOUR-ROOM,YOUR-BATHROOM /?CND40
	GETP	L,P?LINE
	ZERO?	STACK /?CND40
	IN?	LUGGAGE,BUTLER \?CCL46
	PRINTI	" He has "
	PRINTD	LUGGAGE
	PRINTC	46
	JUMP	?CND44
?CCL46:	LOC	BUTLER
	EQUAL?	STACK,L \?CCL50
	PUT	GT,GOAL-FUNCTION,BUTLER-CARRIES
	CALL	ESTABLISH-GOAL,BUTLER,YOUR-ROOM
	FCLEAR	LUGGAGE,OPENBIT
	MOVE	LUGGAGE,BUTLER
	PRINTI	" He takes "
	PRINTD	LUGGAGE
	PRINTC	46
	JUMP	?CND44
?CCL50:	PUT	GT,GOAL-FUNCTION,BUTLER-FETCHES
	CALL	ESTABLISH-GOAL,BUTLER,L
?CND44:	ZERO?	SAID \?CND40
	PRINTI	" ""I'll carry "
	PRINTD	LUGGAGE
	PRINTI	" to "
	PRINTD	YOUR-ROOM
	PRINTI	"."""
?CND40:	CRLF	
	RETURN	2


	.FUNCT	BUTLER-SORRY
	PRINTI	"""Sorry, but I have duties to perform, "
	CALL	TITLE-NAME
	ZERO?	STACK /?PRG7
	PRINTC	46
?PRG7:	PRINTR	""""


	.FUNCT	BUTLER-F,ARG=0,OBJ,X
	EQUAL?	ARG,M-WINNER \?CCL3
	EQUAL?	AWAITING-REPLY,BUTLER-1-R,BUTLER-2-R /?PRD8
	EQUAL?	AWAITING-REPLY,BUTLER-3-R,BUTLER-4-R \?CCL6
?PRD8:	EQUAL?	PRSA,V?NO,V?YES \?CCL6
	PUTP	BUTLER,P?LDESC,0
	PUTP	BUTLER,P?LINE,0
	EQUAL?	AWAITING-REPLY,BUTLER-1-R \?CCL13
	SET	'AWAITING-REPLY,FALSE-VALUE
	EQUAL?	PRSA,V?YES \?PRG16
	CALL	ROB,LUGGAGE,CHEST-OF-DRAWERS
?PRG16:	PRINTD	BUTLER
	PRINTR	" responds politely, like the well-trained butler he is. But he seems to have something important on his mind."
?CCL13:	EQUAL?	AWAITING-REPLY,BUTLER-2-R \?CCL19
	SET	'AWAITING-REPLY,FALSE-VALUE
	EQUAL?	PRSA,V?YES /?PRG25
	PRINTR	"""Oh!... Please pardon me."""
?PRG25:	PRINTI	"""Then no doubt you are here to investigate the spectral figure which has recently been seen about the castle."
	ZERO?	BUTLER-GHOST-STORY-TOLD \?PRG32
	PRINTC	32
	CALL	BUTLER-GHOST-STORY
	RTRUE	
?PRG32:	PRINTR	""""
?CCL19:	EQUAL?	AWAITING-REPLY,BUTLER-3-R \?CCL35
	SET	'AWAITING-REPLY,FALSE-VALUE
	EQUAL?	PRSA,V?YES \?PRG41
	MOVE	MACE,PLAYER
	FSET	MACE,SEENBIT
	FCLEAR	MACE,NDESCBIT
	CALL	THIS-IS-IT,MACE
	PRINTI	"""Should you find "
	PRINTD	PLAYER
	PRINTI	" in any danger from our "
	PRINTD	GHOST-NEW
	PRINTI	", perhaps you could use this.""
"
	PRINTD	BUTLER
	PRINTI	" gives you a small "
	PRINTD	MACE
	PRINTI	".

"
	RTRUE	
?PRG41:	PRINTR	"""As you wish,"" he sniffs."
?CCL35:	SET	'AWAITING-REPLY,FALSE-VALUE
	EQUAL?	PRSA,V?YES /?PRG48
	PRINTI	"""No doubt you soon shall. "
	JUMP	?CND43
?PRG48:	PRINTC	34
?CND43:	EQUAL?	VARIATION,LORD-C,FRIEND-C \?PRG55
	PRINTI	"To be precise, the ghost was just beyond the archway. It was bending over, groping for something on the "
	PRINTD	DRAWING-ROOM
	PRINTI	" carpet."
	JUMP	?PRG62
?PRG55:	PRINTI	"If I may express an opinion, our "
	PRINTD	GHOST-NEW
	PRINTI	" must need reading glasses. The hall was ablaze with lights, yet it was bending down, groping blindly for something on the marble floor."
	EQUAL?	VARIATION,DOCTOR-C \?PRG62
	PRINTI	" And, I might add, it must also be left-handed. You see, "
	CALL	TITLE-NAME
	PRINTI	", while bending over, the figure was using its left hand to grope with. I tried it myself, as did other servants, and we agree that such behavior indicates left-handedness."
?PRG62:	PRINTI	"""
He continues, ""The ghost must have heard my footsteps, for"
	PRINTI	" it stood up, flashed me a startled glance, and fled into the darkness of the "
	PRINTD	DRAWING-ROOM
	PRINTI	". I pursued, turning on the lights, but the thing had disappeared. I went into the foyer, but it was not there either, and the "
	PRINTD	FRONT-DOOR
	PRINTR	" was still locked -- from the inside."""
?CCL6:	CALL	GRAB-ATTENTION,BUTLER
	ZERO?	STACK \?CCL67
	RETURN	2
?CCL67:	EQUAL?	PRSA,V?DESCRIBE \?CCL71
	EQUAL?	PRSO,GHOST-NEW \?CCL71
	FSET	GHOST-NEW,PERSONBIT
	PRINTI	"""Frankly, I found it unconvincing. I don't see why a ghost would grope about on the floor to find something -- especially in a spot that wasn't even built when the "
	PRINTD	GHOST-OLD
	PRINTI	" was walled up in the tower. Besides, why should a ghost be scared away by a human being? It's usually the opposite, is it not?... No, "
	CALL	TITLE-NAME
	PRINTI	", in my opinion that figure just didn't behave like a proper ghost. It had "
	PRINT	LONG-BLOND-HAIR
	PRINTI	" and was clad in a silvery-white "
	EQUAL?	VARIATION,DOCTOR-C \?PRG81
	PRINTI	"long-sleeved"
	JUMP	?PRG83
?PRG81:	PRINTI	"sleeveless"
?PRG83:	PRINTI	" gown. I caught only a brief glimpse of its face, deadly white. As to height, it was too bent over for me to make out. If someone was masquerading as a ghost, of course, the imposter might well have been a man. However, as for the figure I saw -- "
	EQUAL?	VARIATION,DOCTOR-C \?PRG90
	PRINTR	"I cannot be sure of its sex."""
?PRG90:	PRINTR	"it seemed to me quite feminine."""
?CCL71:	EQUAL?	PRSA,V?WALK-TO,V?WALK /?PRD95
	EQUAL?	PRSA,V?THROUGH,V?STAND,V?SIT-AT /?PRD95
	EQUAL?	PRSA,V?SIT,V?OPEN,V?LEAVE /?PRD95
	EQUAL?	PRSA,V?EMPTY,V?DISEMBARK,V?CLOSE \?CCL93
?PRD95:	CALL	WILLING?,BUTLER
	ZERO?	STACK /?CCL93
	EQUAL?	PRSA,V?LEAVE /FALSE
	EQUAL?	PRSA,V?WALK-TO,V?THROUGH \?PRG106
	EQUAL?	PRSO,PASSAGE,DINNER /FALSE
?PRG106:	PRINTI	"""As you wish, "
	CALL	TITLE-NAME
	ZERO?	STACK /?PRG112
	PRINTC	46
?PRG112:	PRINTI	"""
"
	RFALSE	
?CCL93:	CALL	COM-CHECK,BUTLER >X
	ZERO?	X /?CCL115
	EQUAL?	X,M-FATAL /FALSE
	EQUAL?	X,M-OTHER \TRUE
	RETURN	2
?CCL115:	CALL	BUTLER-SORRY
	RETURN	2
?CCL3:	CALL	ASKING-ABOUT?,BUTLER >OBJ
	ZERO?	OBJ /?CCL126
	CALL	GRAB-ATTENTION,BUTLER,OBJ
	ZERO?	STACK \?CCL129
	RETURN	2
?CCL129:	EQUAL?	OBJ,ACCIDENT,LOVER \?CCL133
	PRINTI	"""Perhaps you've heard how I was sent to the "
	PRINTD	BASEMENT
	PRINTI	" to find her. I found a tent pole and a shoe in front of the well, near one end of the "
	PRINTD	WINE-RACK
	PRINTI	". The pole belonged to Lord Lionel. The shoe's spike heel was wrenched loose. I knew at once there had been an accident. Apparently Miss "
	PRINTD	LOVER
	PRINTI	", in her cups, had stumbled over the pole and grabbed at the well for support. But as she was nowhere in sight, and her red necklace was lying beside the well, I assumed she had toppled down the well. When "
	PRINTD	LORD
	PRINTI	" arrived, he shone an electric torch down the well and"
	PRINT	FOUND-FABRIC
	PRINTI	" Evidently it was ripped off as she fell. At any rate, the police concluded that she had drowned. They lowered a diver into the well, but "
	PRINTD	CORPSE
	PRINTR	" was never found."""
?CCL133:	EQUAL?	OBJ,BUTLER \?CCL137
	PRINTR	"""There's not much to tell. I've served the family all my life. Should you require anything, feel free to ask."""
?CCL137:	EQUAL?	OBJ,SEARCHER \?CCL141
	ZERO?	CONFESSED \?PRG146
	GET	TOLD-ABOUT-EVID,BUTLER-C
	ZERO?	STACK /?CCL141
?PRG146:	PRINT	IM-SHOCKED
	RTRUE	
?CCL141:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL149
	PRINTC	34
	CALL	BUTLER-GHOST-STORY
	RSTACK	
?CCL149:	EQUAL?	OBJ,GHOST-OLD \?CCL153
	PRINTI	"""They do say "
	PRINTD	CASTLE
	PRINTR	" is haunted."""
?CCL153:	EQUAL?	OBJ,LAMP \?CCL157
	PRINTI	"""Yes, we keep"
	CALL	IN-CASE-OF-BLACKOUT
	RTRUE	
?CCL157:	EQUAL?	OBJ,YOUR-MIRROR,DRESSING-MIRROR \?CCL161
	PRINTI	"""S"
	CALL	BUTLER-MIRROR-STORY
	RSTACK	
?CCL161:	EQUAL?	OBJ,PRIEST-DOOR /?PRG170
	EQUAL?	OBJ,PASSAGE \?CCL165
	GET	FOUND-PASSAGES,BUTLER-C
	ZERO?	STACK \?CCL165
?PRG170:	PRINTI	"The butler hesitates, looking thoughtful. ""I daresay that sort of thing would be better known to his lordship than to any of the staff, "
	CALL	TITLE-NAME
	PRINTR	"."""
?CCL165:	CALL	COMMON-ASK-ABOUT,BUTLER,OBJ >X
	ZERO?	X /?PRG177
	EQUAL?	X,M-FATAL /FALSE
	RTRUE	
?PRG177:	PRINTI	"""I'm afraid it's not my place to say, "
	CALL	TITLE-NAME
	ZERO?	STACK /?PRG183
	PRINTC	46
?PRG183:	PRINTR	""""
?CCL126:	CALL	PERSON-F,BUTLER,ARG
	RSTACK	


	.FUNCT	IN-CASE-OF-BLACKOUT
	PRINTR	" that in case of a power outage."""


	.FUNCT	BUTLER-GHOST-STORY
	SET	'BUTLER-GHOST-STORY-TOLD,TRUE-VALUE
	SET	'QCONTEXT,BUTLER
	CALL	THIS-IS-IT,BUTLER
	PUTP	BUTLER,P?LDESC,12
	SET	'AWAITING-REPLY,BUTLER-4-R
	SET	'CLOCK-WAIT,TRUE-VALUE
	EQUAL?	HERE,GREAT-HALL \?PRG3
	PUT	QUESTIONS,AWAITING-REPLY,STR?193
?PRG3:	PRINTI	"I myself glimpsed the ghost just last night. "
	PRINTD	LORD
	PRINTI	" and some guests were sitting up late, "
	GET	LDESC-STRINGS,13
	PRINT	STACK
	PRINTI	" in the "
	PRINTD	GREAT-HALL
	PRINTI	". After they retired, I came upstairs to clean up and turn off the lights. As I entered the "
	PRINTD	GREAT-HALL
	PRINTI	" from the west, I saw the ghost on the far side of the room. "
	GET	QUESTIONS,AWAITING-REPLY
	PRINT	STACK
	PRINTC	34
	CRLF	
	RETURN	2


	.FUNCT	BUTLER-MIRROR-STORY
	PRINTI	"hould you wish to view "
	PRINTD	PLAYER
	PRINTI	" from all angles while dressing, you can do so by adjusting the "
	PRINTD	YOUR-MIRROR
	PRINTI	" and the hinged "
	PRINTD	DRESSING-MIRROR
	PRINTI	" of the "
	PRINTD	DRESSING-TABLE
	PRINTR	"."""


	.FUNCT	GHOST-NEW-D,ARG=0
	FSET?	GHOST-NEW,TOUCHBIT \?CCL3
	CALL	DESCRIBE-PERSON,GHOST-NEW
	RTRUE	
?CCL3:	FCLEAR	GHOST-NEW,NDESCBIT
	FSET	GHOST-NEW,PERSONBIT
	FSET	GHOST-NEW,TOUCHBIT
	FSET	GHOST-NEW,SEENBIT
	FSET	COSTUME,SEENBIT
	CRLF	
	FSET?	GHOST-NEW,MUNGBIT \?PRG9
	PRINTI	"Lying "
	CALL	GROUND-DESC
	PRINT	STACK
	PRINTI	" i"
	JUMP	?PRG11
?PRG9:	PRINTI	"Out of the dark come"
?PRG11:	PRINTI	"s a figure with "
	PRINT	LONG-BLOND-HAIR
	PRINTR	", dressed all in silvery white and glowing with an almost unearthly light."


	.FUNCT	GHOST-NEW-F,ARG=0,OBJ
	EQUAL?	ARG,M-WINNER \?CCL3
	CALL	GRAB-ATTENTION,GHOST-NEW
	ZERO?	STACK \?PRG9
	RETURN	2
?PRG9:	PRINT	GHOST-CACKLES
	RETURN	2
?CCL3:	CALL	ASKING-ABOUT?,GHOST-NEW >OBJ
	ZERO?	OBJ /?CCL14
	CALL	GRAB-ATTENTION,GHOST-NEW,OBJ
	ZERO?	STACK /?PRG23
	EQUAL?	VARIATION,LORD-C /?CCL19
	PRINT	GHOST-CACKLES
	RETURN	2
?CCL19:	CALL	LOVER-SPEECH
	ZERO?	STACK \?PRG23
	CALL	GHOST-FLEES
?PRG23:	RETURN	2
?CCL14:	EQUAL?	PRSA,V?EXAMINE \?CCL26
	CALL	HE-SHE-IT,GHOST-NEW,TRUE-VALUE
	PRINTI	" is wearing heavy white makeup with black eyes and lips. "
	CALL	DESCRIBE-GOWN
	CRLF	
	CALL	COMMON-OTHER,GHOST-NEW
	RSTACK	
?CCL26:	EQUAL?	PRSA,V?UNDRESS,V?SEARCH,V?BRUSH /?CTR29
	EQUAL?	PRSA,V?SEARCH-FOR \?CCL30
	EQUAL?	PRSI,COSTUME \?CCL30
?CTR29:	FSET?	GHOST-NEW,MUNGBIT /?CCL37
	PRINT	GHOST-CACKLES
	RTRUE	
?CCL37:	IN?	COSTUME,GHOST-NEW \FALSE
	CALL	UNDRESS-GHOST
	RTRUE	
?CCL30:	CALL	GHOST-NEW-VERBS >OBJ
	ZERO?	OBJ /?CCL44
	CALL	GRAB-ATTENTION,GHOST-NEW
	ZERO?	STACK /?PRG55
	EQUAL?	VARIATION,LORD-C /?CCL49
	PRINT	GHOST-CACKLES
	RETURN	2
?CCL49:	EQUAL?	OBJ,2 /?CCL52
	CALL	LOVER-SPEECH
	ZERO?	STACK \?PRG55
?CCL52:	CALL	GHOST-FLEES
?PRG55:	RETURN	2
?CCL44:	CALL	PERSON-F,GHOST-NEW,ARG
	RSTACK	


	.FUNCT	GHOST-NEW-VERBS
	EQUAL?	PRSA,V?SGIVE,V?GIVE,V?BOW /TRUE
	EQUAL?	PRSA,V?RUB,V?LISTEN,V?KISS /TRUE
	EQUAL?	PRSA,V?SMILE /TRUE
	CALL	SPEAKING-VERB?,GHOST-NEW
	ZERO?	STACK \TRUE
	EQUAL?	PRSA,V?YELL,V?STOP,V?SLAP /?CTR10
	EQUAL?	PRSA,V?PUSH,V?MUNG,V?ARREST \?CCL11
?CTR10:	RETURN	2
?CCL11:	EQUAL?	PRSA,V?TAKE \FALSE
	FSET?	GHOST-NEW,MUNGBIT /FALSE
	RETURN	2


	.FUNCT	UNDRESS-GHOST,L,ADJ
	LOC	GHOST-NEW >L
	MOVE	COSTUME,WINNER
	FCLEAR	COSTUME,NDESCBIT
	FCLEAR	COSTUME,WORNBIT
	FSET	COSTUME,TOUCHBIT
	FSET	COSTUME,TAKEBIT
	MOVE	GHOST-NEW,LOCAL-GLOBALS
	MOVE	VILLAIN-PER,L
	GETP	VILLAIN-PER,P?STATION >ADJ
	ZERO?	ADJ /?CND1
	ZERO?	OTHER-POSS-POS /?CND1
	GETPT	HEAD,P?ADJECTIVE
	PUTB	STACK,OTHER-POSS-POS,ADJ
	GETPT	HANDS,P?ADJECTIVE
	PUTB	STACK,OTHER-POSS-POS,ADJ
	GETPT	EYE,P?ADJECTIVE
	PUTB	STACK,OTHER-POSS-POS,ADJ
	GETPT	OTHER-OUTFIT,P?ADJECTIVE
	PUTB	STACK,OTHER-POSS-POS,ADJ
?CND1:	CALL	THIS-IS-IT,VILLAIN-PER
	FSET	VILLAIN-PER,MUNGBIT
	PUTP	VILLAIN-PER,P?LDESC,19
	SET	'VILLAIN-KNOWN?,TRUE-VALUE
	PRINTI	"When you remove the "
	PRINTD	COSTUME
	PRINTI	", you discover "
	PRINTD	VILLAIN-PER
	PRINTI	" underneath!"
	CRLF	
	CALL	CONGRATS,COSTUME
	RSTACK	


	.FUNCT	DESCRIBE-GOWN
	FSET	GHOST-NEW,PERSONBIT
	PRINTI	"The gown "
	EQUAL?	LIT,HERE /?PRG7
	PRINTI	"seems to fluoresce in the dark. It "
?PRG7:	PRINTI	"has a "
	EQUAL?	VARIATION,DOCTOR-C \?PRG14
	PRINTI	"high"
	JUMP	?PRG16
?PRG14:	PRINTI	"low"
?PRG16:	PRINTI	" neckline and "
	EQUAL?	VARIATION,DOCTOR-C \?PRG23
	PRINTI	"long"
	JUMP	?PRG25
?PRG23:	PRINTI	"no"
?PRG25:	PRINTI	" sleeves."
	RTRUE	


	.FUNCT	COSTUME-F
	EQUAL?	PRSA,V?TELL-ABOUT \?CCL3
	FSET?	PRSO,PERSONBIT \FALSE
	GETP	PRSO,P?CHARACTER
	EQUAL?	VARIATION,STACK \?CCL9
	SET	'PRSA,V?ASK-ABOUT
	RFALSE	
?CCL9:	CALL	TELL-ABOUT-OBJECT,PRSO,COSTUME,FOUND-COSTUME
	RSTACK	
?CCL3:	CALL	REMOTE-VERB?
	ZERO?	STACK \FALSE
	CALL	NOUN-USED?,W?WIG
	ZERO?	STACK /?CCL13
	EQUAL?	VARIATION,LORD-C \?CCL13
	SET	'CLOCK-WAIT,TRUE-VALUE
	PRINTR	"(There is no wig!)"
?CCL13:	EQUAL?	PRSA,V?LOOK-INSIDE,V?EXAMINE \?CCL19
	CALL	NOUN-USED?,W?WIG
	ZERO?	STACK \?CND20
	CALL	DESCRIBE-GOWN
	LOC	COSTUME
	EQUAL?	STACK,GHOST-NEW,VILLAIN-PER \?PRG27
	PRINTI	" It's on"
	JUMP	?PRG29
?PRG27:	PRINTI	" When you hold it up, you can see it would fit"
?PRG29:	PRINTI	" a "
	EQUAL?	VARIATION,LORD-C,FRIEND-C,DOCTOR-C \?PRG36
	PRINTI	"person of average height."
	JUMP	?CND31
?PRG36:	PRINTI	"tall person."
?CND31:	CRLF	
?CND20:	CALL	NOUN-USED?,W?GOWN
	ZERO?	STACK \TRUE
	EQUAL?	VARIATION,LORD-C /TRUE
	PRINTI	"It's obvious that the wig was designed to resemble "
	PRINTD	LOVER
	PRINTI	"'s long, flowing hair."
	CRLF	
	LOC	COSTUME
	EQUAL?	STACK,GHOST-NEW,VILLAIN-PER /TRUE
	PRINTI	"Inside, you notice several individual "
	EQUAL?	VARIATION,FRIEND-C \?CCL50
	PRINTI	"red"
	JUMP	?PRG59
?CCL50:	EQUAL?	VARIATION,DOCTOR-C \?PRG57
	PRINTI	"grayish"
	JUMP	?PRG59
?PRG57:	PRINTI	"tawny"
?PRG59:	PRINTI	" hairs, the same color as "
	GET	CHARACTER-TABLE,VARIATION
	PRINTD	STACK
	PRINTI	"'s hair."
	CRLF	
	CALL	CONGRATS,COSTUME
	RTRUE	
?CCL19:	EQUAL?	PRSA,V?TAKE-OFF,V?TAKE,V?LOOK-UNDER \?CCL67
	IN?	COSTUME,GHOST-NEW \FALSE
	CALL	PERFORM,V?UNDRESS,GHOST-NEW
	RTRUE	
?CCL67:	EQUAL?	PRSA,V?WEAR /?CCL72
	EQUAL?	PRSA,V?PUT \FALSE
	ZERO?	PRSI /FALSE
	FSET?	PRSI,PERSONBIT \FALSE
?CCL72:	CALL	WEAR-SCARE
	RSTACK	


	.FUNCT	WEAR-SCARE
	PRINTI	"You start to put"
	CALL	PRINTT,PRSO
	PRINTI	" on"
	ZERO?	PRSI /?PRG7
	PRINTC	32
	PRINTD	PRSI
?PRG7:	PRINTI	", but"
	EQUAL?	PRSO,NECKLACE-OF-D \?PRG14
	PRINT	CLASP-MUNGED
	PRINTR	"."
?PRG14:	PRINTR	" then decide it might scare the other guests."


	.FUNCT	WHY-ME
	BTST	PRESENT-TIME,1 \?PRG6
	PRINTI	"""You could do that "
	PRINTD	PLAYER
	PRINTR	", you know."""
?PRG6:	PRINTI	"""I think you can do that better "
	PRINTD	PLAYER
	PRINTR	"."""


	.FUNCT	DESCRIBE-PERSON,PER,STR=0
	GETP	PER,P?LDESC >STR
	EQUAL?	PER,BUTLER,LOVER /?CND1
	CALL	ALL-TOGETHER-NOW?
	ZERO?	STACK /?CND1
	EQUAL?	PER,LORD \TRUE
	SET	'P-HIM-OBJECT,FALSE-VALUE
	SET	'P-HER-OBJECT,FALSE-VALUE
	PRINTD	PER
	PRINTI	" and all his guests are here."
	ZERO?	CONFESSED \?CND9
	CALL	QUEUED?,I-LIONEL-SPEAKS
	ZERO?	STACK \?CND9
	PRINTR	" They smile pleasantly but, with typical British reserve, seem willing to leave you to your own devices."
?CND9:	CRLF	
	RTRUE	
?CND1:	ZERO?	STR /?PRG18
	GETP	PER,P?CHARACTER
	PUT	TOUCHED-LDESCS,STACK,STR
	RFALSE	
?PRG18:	CALL	START-SENTENCE,PER
	PRINTI	" is "
	GETPT	PER,P?WEST >STR
	ZERO?	STR /?PRG26
	GET	STR,NEXITSTR >STR
	ZERO?	STR /?PRG26
	PRINT	STR
?PRG26:	PRINTC	46
	EQUAL?	STR,6 \?CCL30
	PRINTC	32
	RTRUE	
?CCL30:	CRLF	
	RTRUE	


	.FUNCT	ALL-TOGETHER-NOW?
	LOC	LORD
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \FALSE
	LOC	FRIEND
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \FALSE
	LOC	DEB
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \FALSE
	LOC	OFFICER
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \FALSE
	LOC	DOCTOR
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \FALSE
	LOC	DEALER
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \FALSE
	LOC	PAINTER
	EQUAL?	STACK,HERE,PSEUDO-OBJECT /TRUE
	RFALSE	


	.FUNCT	TELL-ABOUT-OBJECT,PER,OBJ,GL,C
	GET	GL,PLAYER-C
	ZERO?	STACK /FALSE
	GETP	PER,P?CHARACTER >C
	GET	GL,C
	ZERO?	STACK \?PRG9
	PUT	GL,C,TRUE-VALUE
	EQUAL?	C,VARIATION /?CND7
	PUTP	PER,P?LINE,0
?CND7:	CALL	GOOD-SHOW,PER,OBJ
	RSTACK	
?PRG9:	PRINTI	"""I know that you found a "
	PRINTD	OBJ
	PRINTR	"."""


	.FUNCT	PERSON-F,PER,ARG,OBJ,X,L,C,N
	LOC	PER >L
	GETP	PER,P?CHARACTER >C
	EQUAL?	PRSA,V?SHAKE,V?ALARM \?CCL3
	EQUAL?	PRSO,PER \FALSE
	CALL	QUEUED?,I-COME-TO
	ZERO?	STACK /?CCL9
	EQUAL?	PER,VILLAIN-PER,GHOST-NEW \?CCL9
	CALL	QUEUE,I-COME-TO,1
	RTRUE	
?CCL9:	CALL	UNSNOOZE,PER,TRUE-VALUE
	ZERO?	STACK /?PRG16
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTR	" gasps to see you so close!"
?PRG16:	CALL	HE-SHE-IT,PER,TRUE-VALUE,STR?1
	PRINTI	" still "
	GETP	PER,P?LDESC >X
	ZERO?	X /?CCL20
	GET	LDESC-STRINGS,X
	PRINT	STACK
	JUMP	?PRG26
?CCL20:	GETPT	PER,P?WEST >X
	ZERO?	X /?PRG26
	GET	X,NEXITSTR
	PRINT	STACK
?PRG26:	PRINTR	"."
?CCL3:	EQUAL?	PRSA,V?FORGIVE \?CCL29
	CALL	GRAB-ATTENTION,PER
	ZERO?	STACK \?PRG34
	RETURN	2
?PRG34:	PRINTR	"""Thank you so much. I didn't realize I'd offended you."""
?CCL29:	EQUAL?	PRSA,V?GIVE \?CCL37
	EQUAL?	PRSI,PER \FALSE
	CALL	HELD?,PRSO
	ZERO?	STACK /FALSE
	CALL	GRAB-ATTENTION,PER
	ZERO?	STACK \FALSE
	RETURN	2
?CCL37:	EQUAL?	PRSA,V?LAMP-OFF \?CCL48
	GETP	PER,P?LINE
	ZERO?	STACK /?CCL51
	PRINTR	"Seems you've already done that."
?CCL51:	CALL	WONT-HELP
	RSTACK	
?CCL48:	EQUAL?	PRSA,V?SEARCH-FOR,V?SEARCH,V?MUNG \?CCL55
	EQUAL?	PER,PRSO \FALSE
	FSET?	PER,PERSONBIT \FALSE
	FSET?	PER,MUNGBIT /FALSE
	GETP	PER,P?LINE
	ADD	1,STACK
	PUTP	PER,P?LINE,STACK
	GETP	PER,P?LDESC
	EQUAL?	STACK,4 /?PRG64
	PUTP	PER,P?LDESC,20
?PRG64:	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTR	" pushes you away and mutters, ""I don't think that's called for."""
?CCL55:	EQUAL?	PRSA,V?SHOW \?CCL67
	EQUAL?	PER,PRSO \FALSE
	CALL	GRAB-ATTENTION,PER
	ZERO?	STACK \?CCL73
	RETURN	2
?CCL73:	CALL	PERFORM,V?TELL-ABOUT,PRSO,PRSI
	RTRUE	
?CCL67:	EQUAL?	PRSA,V?SMILE \?CCL78
	EQUAL?	PER,PRSO \FALSE
	CALL	GRAB-ATTENTION,PER
	ZERO?	STACK \?PRG87
	RETURN	2
?PRG87:	CALL	HE-SHE-IT,PRSO,TRUE-VALUE,STR?218
	PRINTR	" back at you."
?CCL78:	EQUAL?	PRSA,V?TELL-ABOUT \?CCL90
	EQUAL?	PER,PRSO \FALSE
	CALL	GRAB-ATTENTION,PER
	ZERO?	STACK \?CND94
	RETURN	2
?CND94:	PUTP	PER,P?LDESC,12
	FSET?	PRSI,RMUNGBIT \?CCL100
	FSET?	PRSI,SEENBIT \?CCL100
	FSET?	PRSI,PERSONBIT /?CCL100
	GETP	PER,P?CHARACTER
	PUT	TOLD-ABOUT-EVID,STACK,TRUE-VALUE
	PRINT	THATS-INTERESTING
	RTRUE	
?CCL100:	EQUAL?	PRSI,CLUE-1 \?CCL107
	PRINT	THATS-INTERESTING
	RTRUE	
?CCL107:	EQUAL?	PRSI,CONFESSED \?CCL112
	EQUAL?	PER,CONFESSED /?PRG126
	PRINT	IM-SHOCKED
	RTRUE	
?CCL112:	EQUAL?	PRSI,GHOST-NEW \?CCL118
	FSET?	GHOST-NEW,TOUCHBIT \?PRG126
	EQUAL?	PER,GHOST-NEW /?PRG126
	GETP	PER,P?CHARACTER
	PUT	TOLD-ABOUT-GHOST,STACK,TRUE-VALUE
	PRINTR	"""You saw the ghost? Tell me, how can I help?"""
?CCL118:	CALL	SECRET-PASSAGE-OR-DOOR?,PRSI
	ZERO?	STACK /?PRG126
	CALL	TELL-ABOUT-OBJECT,PRSO,PASSAGE,FOUND-PASSAGES
	RTRUE	
?PRG126:	PRINTR	"""I don't know what you mean."""
?CCL90:	EQUAL?	PRSA,V?THROW-AT \?CCL129
	EQUAL?	PER,PRSI \FALSE
	FSET?	PER,PERSONBIT \FALSE
	FSET?	PER,MUNGBIT /FALSE
	MOVE	PRSO,PRSI
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTI	" catches"
	CALL	PRINTT,PRSO
	PRINTI	" with"
	CALL	HIM-HER-IT,PER,FALSE-VALUE,TRUE-VALUE
	PRINTC	32
	EQUAL?	PER,DEB,DOCTOR \?PRG143
	PRINTI	"lef"
	JUMP	?PRG145
?PRG143:	PRINTI	"righ"
?PRG145:	PRINTR	"t hand."
?CCL129:	CALL	COMMON-OTHER,PER
	RSTACK	


	.FUNCT	SECRET-PASSAGE-OR-DOOR?,OBJ
	EQUAL?	OBJ,PASSAGE,SECRET-JACK-DOOR,SECRET-TAMARA-DOOR /TRUE
	EQUAL?	OBJ,SECRET-LIBRARY-DOOR,SECRET-DRAWING-DOOR,SECRET-SITTING-DOOR /TRUE
	EQUAL?	OBJ,SECRET-DINING-DOOR,SECRET-YOUR-DOOR,SECRET-IRIS-DOOR /TRUE
	EQUAL?	OBJ,SECRET-WENDISH-DOOR,SECRET-VIVIEN-DOOR,SECRET-IAN-DOOR /TRUE
	EQUAL?	OBJ,SECRET-HYDE-DOOR /TRUE
	RFALSE	


	.FUNCT	CARRY-CHECK,PER
	FIRST?	PER \FALSE
	CALL	HE-SHE-IT,PER,TRUE-VALUE,STR?1
	PRINTI	" holding"
	CALL	PRINT-CONTENTS,PER
	PRINTR	"."


	.FUNCT	WINNER-DESCRIBE,OBJ,RM
	PRINTI	"""You can see "
	PRINTD	OBJ
	EQUAL?	HERE,RM \?PRG8
	PRINTI	" right over there"
	JUMP	?PRG10
?PRG8:	PRINTI	" in the "
	PRINTD	RM
?PRG10:	PRINTR	"."""


	.FUNCT	TRANSIT-TEST,PER
	EQUAL?	PRSA,V?WALK-TO,V?WALK,V?THROUGH /?CCL3
	EQUAL?	PRSA,V?TAKE-TO,V?LEAVE,V?DISEMBARK \FALSE
?CCL3:	CALL	WILLING?,PER
	RSTACK	


	.FUNCT	COM-CHECK,PER,N,TAG
	GETP	PER,P?LINE >N
	GETP	PER,P?CHARACTER
	GET	TOLD-ABOUT-GHOST,STACK >TAG
	EQUAL?	PRSA,V?$CALL \?CCL3
	CALL	DONT-UNDERSTAND
	RETURN	M-OTHER
?CCL3:	CALL	TRANSIT-TEST,PER
	ZERO?	STACK /?CCL5
	RETURN	2
?CCL5:	EQUAL?	PRSA,V?SORRY,V?HELLO,V?ALARM \?CCL9
	EQUAL?	PRSO,ROOMS /?CTR11
	EQUAL?	PRSO,PER \FALSE
?CTR11:	SET	'WINNER,PLAYER
	CALL	PERFORM,PRSA,PER
	RTRUE	
?CCL9:	EQUAL?	PRSA,V?YES /?PRG19
	EQUAL?	PRSA,V?THANKS,V?NO,V?ARREST \?CCL16
?PRG19:	RETURN	2
?CCL16:	EQUAL?	PRSA,V?DESCRIBE \?CCL22
	EQUAL?	PRSO,GHOST-NEW \?CCL25
	PRINTI	"""I'm sorry, but I didn't see"
	CALL	HIM-HER-IT,GHOST-NEW
	PRINTR	"."""
?CCL25:	EQUAL?	PRSO,MAID \?CCL29
	PRINT	NEVER-NOTICED-HER
	RTRUE	
?CCL29:	EQUAL?	PRSO,BUST,COUSIN \?CCL33
	CALL	WINNER-DESCRIBE,BUST,DINING-ROOM
	RTRUE	
?CCL33:	EQUAL?	PRSO,LOVER \?PRG36
	CALL	WINNER-DESCRIBE,LOVER-PIC,DRAWING-ROOM
	RTRUE	
?PRG36:	PRINTI	"""You could "
	CALL	META-LOC,PRSO
	EQUAL?	STACK,HERE /?PRG42
	PRINTI	"go "
?PRG42:	PRINTI	"have a look for "
	PRINTD	PLAYER
	PRINTR	", you know."""
?CCL22:	EQUAL?	PRSA,V?WALK-TO,V?FOLLOW \?CCL45
	EQUAL?	PER,BUTLER /FALSE
	EQUAL?	PRSA,V?WALK-TO \?PRG57
	ZERO?	TAG \?PRG55
	EQUAL?	PRSO,TAMARA-BED,BED,SLEEP-GLOBAL \?PRG57
?PRG55:	RETURN	2
?PRG57:	PRINTR	"""I will go where I please, thank you very much."""
?CCL45:	EQUAL?	PRSA,V?INVENTORY \?CCL60
	CALL	CARRY-CHECK,PER
	ZERO?	STACK \TRUE
	CALL	HE-SHE-IT,PER,TRUE-VALUE,STR?1
	PRINTR	"n't holding anything."
?CCL60:	EQUAL?	PRSA,V?LISTEN \?CCL66
	EQUAL?	PRSO,PLAYER-NAME,PLAYER /?PRG72
	IN?	PRSO,GLOBAL-OBJECTS /FALSE
?PRG72:	PRINTI	"""I'm trying to, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTR	"!"""
?CCL66:	EQUAL?	PRSA,V?RUB \?CND1
	CALL	FACE-RED
	RTRUE	
?CND1:	RANDOM	3
	EQUAL?	STACK,1 \?CND75
	CALL	WILLING?,PER,TRUE-VALUE
	ZERO?	STACK /?CND75
	EQUAL?	PER,DEB \?CCL81
	SET	'FAWNING,TRUE-VALUE
	PRINTI	"""My dear "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	", how could I refuse someone as handsome as you?"" Iris murmurs, batting her eyelashes. "
	JUMP	?CND75
?CCL81:	EQUAL?	PER,OFFICER \?CND75
	SET	'FAWNING,TRUE-VALUE
	PRINTI	"""Delighted to help you if I can, "
	CALL	PRINT-NAME,FIRST-NAME
	PRINTI	" luv! One feels those great luminous eyes of yours can see right through a chap!"" says the handsome young guardsman. "
?CND75:	EQUAL?	PRSA,V?DANCE \?CCL89
	EQUAL?	PRSO,PLAYER \?CCL89
	SET	'WINNER,PLAYER
	CALL	PERFORM,PRSA,PER
	RTRUE	
?CCL89:	EQUAL?	PRSA,V?DANCE /?PRG101
	EQUAL?	PRSA,V?WALK \?CCL93
	EQUAL?	PRSO,P?OUT /?PRG101
	ZERO?	TAG /?CCL93
?PRG101:	RETURN	2
?CCL93:	EQUAL?	PRSA,V?SIGN \?CCL104
	PRINTI	"You notice that"
	CALL	HE-SHE-IT,PER
	PRINTI	" is "
	EQUAL?	PER,DEB,DOCTOR \?PRG112
	PRINTI	"lef"
	JUMP	?PRG114
?PRG112:	PRINTI	"righ"
?PRG114:	PRINTR	"t-handed."
?CCL104:	EQUAL?	PRSA,V?KISS \?CCL117
	CALL	UNSNOOZE,PER
	PRINTR	"""I really don't think this is the proper time or place."""
?CCL117:	EQUAL?	PRSA,V?TAKE \?CCL121
	IN?	PRSO,PLAYER \FALSE
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?GIVE,PRSO,PER
	RTRUE	
?CCL121:	EQUAL?	PRSA,V?READ,V?LOOK-INSIDE,V?EXAMINE \?CCL126
	IN?	PRSO,PLAYER \FALSE
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?SHOW,PER,PRSO
	RTRUE	
?CCL126:	EQUAL?	PRSA,V?FORGIVE \?CCL131
	SET	'WINNER,PRSO
	CALL	PERFORM,V?SORRY,PER
	RTRUE	
?CCL131:	EQUAL?	PRSA,V?THROW-AT,V?GIVE \?CCL133
	FSET?	PRSI,PERSONBIT \?CCL133
	SET	'WINNER,PRSI
	CALL	PERFORM,V?ASK-FOR,PER,PRSO
	RTRUE	
?CCL133:	EQUAL?	PRSA,V?SGIVE \?CCL137
	FSET?	PRSO,PERSONBIT \?CCL137
	SET	'WINNER,PRSO
	CALL	PERFORM,V?ASK-FOR,PER,PRSI
	RTRUE	
?CCL137:	EQUAL?	PRSA,V?HELP \?CCL141
	EQUAL?	PRSO,FALSE-VALUE,PLAYER,PLAYER-NAME \?PRG145
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK,PER
	RTRUE	
?PRG145:	RETURN	2
?CCL141:	EQUAL?	PRSA,V?SSHOW,V?SHOW,V?FIND \?CCL148
	EQUAL?	PRSA,V?SHOW \?CND149
	SET	'PRSA,V?SSHOW
	SET	'N,PRSI
	SET	'PRSI,PRSO
	SET	'PRSO,N
?CND149:	IN?	PRSO,ROOMS \?CCL153
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?WALK-TO,PRSO
	RTRUE	
?CCL153:	IN?	PRSO,PER \?CCL155
	CALL	ITAKE
	EQUAL?	STACK,TRUE-VALUE \TRUE
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTI	" fumbles in"
	CALL	HIM-HER-IT,PER,FALSE-VALUE,TRUE-VALUE
	PRINTI	" pocket and produces"
	CALL	HIM-HER-IT,PRSO
	PRINTR	"."
?CCL155:	EQUAL?	PRSA,V?FIND \FALSE
	RETURN	2
?CCL148:	EQUAL?	PRSA,V?PLAY \?CCL165
	EQUAL?	PRSO,PIANO \FALSE
	PRINTI	"""I'm not very good at this sort of thing, but...""
"
	RETURN	2
?CCL165:	EQUAL?	PRSA,V?TELL \?CCL174
	EQUAL?	PRSO,PLAYER-NAME,PLAYER \FALSE
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK,PER
	RTRUE	
?CCL174:	EQUAL?	PRSA,V?TELL-ABOUT \?CCL179
	FSET?	PRSO,PERSONBIT \FALSE
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK-ABOUT,PER,PRSI
	RTRUE	
?CCL179:	EQUAL?	PRSA,V?WAIT-FOR,V?STOP \?CCL184
	EQUAL?	PRSO,ROOMS,PLAYER-NAME /?CCL187
	EQUAL?	PRSO,PLAYER,GLOBAL-HERE,HERE \FALSE
?CCL187:	EQUAL?	PER,FOLLOWER \?CCL192
	SET	'FOLLOWER,0
	PRINTI	"""As you wish, "
	CALL	PRINT-NAME,FIRST-NAME
	ZERO?	STACK /?PRG199
	PRINTC	46
?PRG199:	PRINTR	""""
?CCL192:	SET	'WINNER,PLAYER
	CALL	PERFORM,V?$CALL,PER
	RTRUE	
?CCL184:	EQUAL?	PRSA,V?TALK-ABOUT \FALSE
	SET	'WINNER,PLAYER
	CALL	PERFORM,V?ASK-ABOUT,PER,PRSO
	RTRUE	


	.FUNCT	EVIDENCE?,OBJ,PER=0
	ZERO?	PER /?CCL3
	GETP	PER,P?CHARACTER
	EQUAL?	VARIATION,STACK \FALSE
?CCL3:	EQUAL?	OBJ,LETTER-MAID,PASSAGE,JEWEL /TRUE
	EQUAL?	OBJ,LENS,LENS-1,LENS-2 /TRUE
	EQUAL?	OBJ,COSTUME,LENS-BOX,EARRING /TRUE
	EQUAL?	OBJ,BLOWGUN /TRUE
	ZERO?	OBJ /FALSE
	FSET?	OBJ,PERSONBIT /FALSE
	FSET?	OBJ,RMUNGBIT /TRUE
	RFALSE	


	.FUNCT	SETUP-SHOT,PER
	SET	'VILLAIN-KNOWN?,TRUE-VALUE
	MOVE	BLOWGUN,PER
	FCLEAR	BLOWGUN,NDESCBIT
	FCLEAR	BLOWGUN,TAKEBIT
	PUTP	PER,P?LINE,2
	PUTP	PER,P?LDESC,8
	SET	'AIMED-HERE,HERE
	SET	'SHOOTER,PER
	CALL	QUEUE,I-SHOT,CLOCKER-RUNNING
	RSTACK	


	.FUNCT	COMMON-ASK-ABOUT,PER,OBJ
	CALL	EVIDENCE?,OBJ,PER
	ZERO?	STACK /?CCL3
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTI	" flinches a little before answering.
"
?CND1:	FSET?	OBJ,RMUNGBIT \?CND23
	EQUAL?	PRSA,V?SHOW,V?CONFRONT \?CND23
	FSET?	OBJ,PERSONBIT /?CND23
	GETP	PER,P?CHARACTER
	PUT	TOLD-ABOUT-EVID,STACK,TRUE-VALUE
?CND23:	EQUAL?	OBJ,SEARCHER \?CCL30
	GETP	OBJ,P?LDESC
	EQUAL?	STACK,21 \?CCL30
	EQUAL?	PER,SEARCHER \?PRG38
	PRINTR	"""You mean, why am I searching? I'm sure you can guess."""
?CCL3:	CALL	EVIDENCE?,OBJ
	ZERO?	STACK /?CND1
	ZERO?	CONFESSED /?PRG12
	PRINT	IM-SHOCKED
	RTRUE	
?PRG12:	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTI	" says, """
	RANDOM	2
	EQUAL?	STACK,1 \?PRG19
	PRINTI	"Good Lord"
	JUMP	?PRG21
?PRG19:	PRINTI	"I say"
?PRG21:	PRINTR	"! I think you're onto something here."""
?PRG38:	PRINTI	"""I imagine that "
	PRINTD	OBJ
	PRINTI	" is searching because"
	CALL	THIS-IS-IT,OBJ
	CALL	HE-SHE-IT,OBJ
	PRINTI	" got a bright idea. I prefer to let our"
	PRINT	FAMOUS-YOUNG-DETECTIVE
	PRINTR	" do the work."""
?CCL30:	EQUAL?	OBJ,PER \?CCL43
	PRINTR	"""I have no secrets. Anyone can see what I am."""
?CCL43:	EQUAL?	OBJ,PLAYER,PLAYER-NAME \?CCL47
	PRINTI	"""You're "
	CALL	TELL-FULL-NAME
	PRINTI	", the"
	PRINT	FAMOUS-YOUNG-DETECTIVE
	PRINTR	"."""
?CCL47:	EQUAL?	OBJ,BUTLER \?CCL53
	PRINTR	"""He's served the family all his life."""
?CCL53:	EQUAL?	OBJ,LOVER \?CCL57
	PRINTI	"""Poor thing, her life came to a sad ending."
	EQUAL?	PER,DOCTOR \?PRG64
	PRINTI	" As did her grandfather, whom I treated at my clinic."
?PRG64:	PRINTR	""""
?CCL57:	EQUAL?	OBJ,COUSIN,BUST \?CCL67
	PRINTR	"""He was a bit of a strange bird, was Lionel."""
?CCL67:	EQUAL?	OBJ,GHOST-NEW,DANGER,HAUNTING \?CCL72
	PRINTI	"""I myself haven't seen"
	CALL	HIM-HER-IT,GHOST-NEW
	PRINTR	"."""
?CCL72:	EQUAL?	OBJ,GHOST-OLD \?CCL76
	PRINTI	"""Oh, she has haunted "
	PRINTD	CASTLE
	PRINTI	" for centuries -- a lovely phantom in a white gown, with long pale hair. She was said to be the unfaithful wife of an early Lord "
	PRINT	TRESYLLIAN
	PRINTR	", who had her walled up alive in the tower."""
?CCL76:	EQUAL?	OBJ,MAID \?CCL80
	PRINT	NEVER-NOTICED-HER
	RTRUE	
?CCL80:	FSET?	OBJ,PERSONBIT /FALSE
	GETP	PER,P?CHARACTER
	EQUAL?	VARIATION,STACK \?CCL86
	FSET?	OBJ,RMUNGBIT /?CTR85
	EQUAL?	OBJ,BLOWGUN \?CCL86
?CTR85:	PUTP	PER,P?LINE,2
	PRINTI	"""What can I say?"""
	CALL	HE-SHE-IT,PER
	PRINTI	" shrugs. ""It's a fair cop. You've caught me with damning evidence."
	EQUAL?	VARIATION,FRIEND-C,LORD-C /?PRG98
	GETP	PER,P?CHARACTER
	ADD	1,STACK
	GET	CHAR-ROOM-TABLE,STACK
	EQUAL?	HERE,STACK \?PRG98
	CALL	FIND-FLAG-HERE,PERSONBIT,PLAYER,PER
	ZERO?	STACK /?CND93
?PRG98:	PRINTR	""""
?CND93:	IN?	BLOWGUN,PER \?PRG105
	PRINTI	""" "
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	JUMP	?CND100
?PRG105:	PRINTI	" But there's something you don't know yet"
	CALL	IAN-CALLS-YOU
	PRINTI	", which may put the matter in a different light.""
Still smiling,"
	CALL	HE-SHE-IT,PER
	PRINTI	" puts"
	CALL	HIM-HER-IT,PER,FALSE-VALUE,TRUE-VALUE
	PRINTI	" hand into"
	CALL	PRINTT,HIDING-PLACE
	PRINTI	", and"
?CND100:	LOC	BLOWGUN
	EQUAL?	STACK,PER,HIDING-PLACE \?PRG121
	SET	'DISCOVERED-HERE,HERE
	CALL	SETUP-SHOT,PER
	FSET?	BLOWGUN,NDESCBIT /?CCL114
	PRINTI	" takes"
	JUMP	?PRG119
?CCL114:	FCLEAR	BLOWGUN,NDESCBIT
	PRINTI	" suddenly extracts"
?PRG119:	CALL	PRINTT,BLOWGUN
	PRINTR	" and aims it at you!"
?PRG121:	CALL	HIM-HER-IT,PER,FALSE-VALUE,TRUE-VALUE
	PRINTI	" jaw drops as"
	CALL	HIM-HER-IT,PER,FALSE-VALUE,TRUE-VALUE
	PRINTR	" hand comes out, empty."
?CCL86:	EQUAL?	OBJ,ACCIDENT \?CCL124
	PRINTI	"""You'd best ask Jack about that, or "
	PRINTD	BUTLER
	PRINTR	"."""
?CCL124:	EQUAL?	OBJ,BELL \?CCL128
	PRINTR	"""It's actually a ship's bell off an old British man-o'-war."""
?CCL128:	EQUAL?	PER,SEARCHER \?CCL132
	ZERO?	LIONEL-SPEAKS-COUNTER \?CCL132
	CALL	SHOWING-CLUE?,OBJ
	ZERO?	STACK /?CCL132
	EQUAL?	PRSA,V?ASK-ABOUT /?CCL132
	CALL	QUEUE,I-SEARCH,1
	PRINT	THATS-INTERESTING
	RTRUE	
?CCL132:	EQUAL?	OBJ,CORPSE \?CCL140
	PRINTC	34
	PRINTD	CORPSE
	PRINTR	" was never recovered from the well. They think it was carried out to sea by an underground tidal stream."""
?CCL140:	EQUAL?	OBJ,COSTUME,BLOWGUN,LENS-BOX \?CCL144
	EQUAL?	PER,PAINTER,DOCTOR \?PRD148
	GETP	PER,P?CHARACTER
	EQUAL?	VARIATION,STACK /?CTR143
?PRD148:	EQUAL?	PER,DEB \?CCL144
	EQUAL?	VARIATION,FRIEND-C \?CCL144
?CTR143:	GETP	PER,P?CHARACTER
	ADD	1,STACK
	GET	CHAR-ROOM-TABLE,STACK >OBJ
	PRINTD	PER
	PRINTI	"'s look changes to a puzzled and angry frown. "
	EQUAL?	PER,LORD,FRIEND /?PRG165
	PRINTI	"""You mean you found that "
	EQUAL?	HERE,OBJ \?PRG163
	PRINTI	"here "
?PRG163:	PRINTI	"in my room?"""
	CALL	HE-SHE-IT,PER
	PRINTI	" gasps. "
?PRG165:	PRINTI	"""How can I explain it when it doesn't belong to me? If you didn't bring it "
	EQUAL?	HERE,OBJ /?PRG171
	PRINTC	116
?PRG171:	PRINTI	"here "
	PRINTD	PLAYER
	PRINTI	", then someone else planted it, trying to frame me as the maniac who's been posing as "
	PRINTD	LOVER
	PRINTR	"'s ghost!"""
?CCL144:	EQUAL?	OBJ,COSTUME \?CCL174
	GET	FOUND-COSTUME,PLAYER-C
	ZERO?	STACK /FALSE
	PRINTI	"""So that's how "
	ZERO?	CONFESSED \?PRG185
	PRINTI	"somebody"
	JUMP	?PRG187
?PRG185:	PRINTD	VILLAIN-PER
?PRG187:	PRINTR	" posed as a ghost!"""
?CCL174:	EQUAL?	OBJ,DINNER,DINNER-2 \?CCL190
	LESS?	PRESENT-TIME,DINNER-TIME \?CCL193
	PRINTI	"""Tonight's a dinner in honor of "
	EQUAL?	PER,BUTLER \?PRG200
	PRINTI	"the late Lord "
?PRG200:	PRINTI	"Lionel's birthday. In his will, he asked for these particular guests -- except "
	EQUAL?	PER,FRIEND \?CCL204
	PRINTI	"me"
	JUMP	?PRG207
?CCL204:	PRINTD	FRIEND
?PRG207:	PRINTI	", of course. It's at eight o'clock"
	EQUAL?	PER,BUTLER /?PRG213
	PRINTI	" -- or whenever "
	PRINTD	BUTLER
	PRINTI	" gets 'round to it"
?PRG213:	PRINTR	"."""
?CCL193:	CALL	META-LOC,DINNER
	EQUAL?	STACK,HERE \?CCL216
	PRINTR	"""It looks delicious!"""
?CCL216:	GETP	PER,P?LDESC
	EQUAL?	STACK,10 \?PRG224
	PRINTI	"""I'm enjoying"
	JUMP	?PRG226
?PRG224:	PRINTI	"""I enjoyed"
?PRG226:	PRINTI	" it immensely."
	ZERO?	MISSED-DINNER /?PRG232
	PRINTI	" We started without you, as we assumed you were sleuthing."
?PRG232:	PRINTR	""""
?CCL190:	EQUAL?	OBJ,BRICKS,COFFIN,CRYPT /?PRG239
	EQUAL?	OBJ,DUNGEON,IRON-MAIDEN,TOMB /?PRG239
	EQUAL?	OBJ,WELL \?CCL235
?PRG239:	PRINT	ANCIENT-SECRETS
	CRLF	
	RTRUE	
?CCL235:	EQUAL?	OBJ,JEWEL \?CCL242
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	EQUAL?	PER,FRIEND \?CCL247
	FSET?	EARRING,LOCKED \?CCL247
	PRINTR	" says, ""Oh, thank you for finding it! I've looked everywhere!"""
?CCL247:	CALL	META-LOC,JEWEL
	EQUAL?	HERE,STACK \?PRG260
	PRINTI	" looks at it with interest"
	EQUAL?	PER,DEALER \?PRG262
	PRINTI	", putting a monocle in one eye to see better"
	JUMP	?PRG262
?PRG260:	PRINTI	" listens to your description of it"
?PRG262:	PRINTI	". But"
	CALL	HE-SHE-IT,PER
	PRINTI	" says"
	CALL	HE-SHE-IT,PER
	PRINTR	" can't identify it."
?CCL242:	EQUAL?	OBJ,LAMP \?CCL265
	PRINTI	"""I think "
	PRINTD	BUTLER
	PRINTI	" keeps"
	CALL	IN-CASE-OF-BLACKOUT
	RTRUE	
?CCL265:	EQUAL?	OBJ,LUGGAGE \?CCL269
	IN?	LUGGAGE,BUTLER \?CCL269
	PRINTI	"""Don't panic."
	CALL	BOLITHO-WILL
	PRINTR	"."""
?CCL269:	EQUAL?	OBJ,MACE \?CCL277
	PRINTI	"""That is a long story, "
	CALL	TITLE-NAME
	ZERO?	STACK /?PRG284
	PRINTC	46
?PRG284:	PRINTI	" When Lord Lionel was alive, he had a pit bulldog to protect the castle. A right vicious brute it was, too! Several times it attacked the servants, so the master gave out these "
	PRINTD	MACE
	PRINTR	"s. Just press the button on the side, and it sprays something foul. It always worked a treat on that wretched dog, and I daresay it could stop a ghost just as well."""
?CCL277:	EQUAL?	OBJ,NECKLACE-OF-D \?CCL287
	PRINTI	"""The police returned it to "
	EQUAL?	PER,LORD \?PRG295
	PRINTI	"me"
	JUMP	?PRG297
?PRG295:	PRINTD	LORD
?PRG297:	PRINTR	" after the inquest."""
?CCL287:	CALL	SECRET-PASSAGE-OR-DOOR?,OBJ
	ZERO?	STACK /?CCL300
	CALL	TELL-ABOUT-OBJECT,PER,PASSAGE,FOUND-PASSAGES
	RSTACK	
?CCL300:	EQUAL?	OBJ,SKELETON \?CCL302
	PRINTI	"""Ugh! Those must be the bones of the "
	PRINTD	GHOST-OLD
	PRINTR	"!"""
?CCL302:	CALL	TREASURE-FOUND?,OBJ,PER
	ZERO?	STACK \TRUE
	EQUAL?	OBJ,YOUR-ROOM \?CCL308
	PRINTR	"""It's fortunate that one bedroom was available for you."""
?CCL308:	EQUAL?	OBJ,CASTLE /?PRG315
	IN?	OBJ,ROOMS \?CCL312
?PRG315:	PRINTI	"""Oh, it is a lovely piece of real estate, "
	EQUAL?	PER,FRIEND \?PRG322
	PRINTI	"isn't it"
	JUMP	?PRG324
?PRG322:	PRINTI	"what"
?PRG324:	PRINTC	63
	EQUAL?	PER,DOCTOR,PAINTER,DEALER \?PRG330
	PRINTI	" Almost a shame to admit riffraff on weekends."
?PRG330:	PRINTR	""""
?CCL312:	IN?	OBJ,PER \FALSE
	PRINTI	"""I have it right here, "
	CALL	TITLE-NAME
	ZERO?	STACK /?PRG340
	PRINTC	46
?PRG340:	PRINTR	""""


	.FUNCT	SHOWING-CLUE?,OBJ
	EQUAL?	OBJ,CLUE-1,CLUE-2 /TRUE
	EQUAL?	OBJ,CLUE-3,CLUE-4 /TRUE
	EQUAL?	OBJ,MAGAZINE \FALSE
	EQUAL?	VARIATION,PAINTER-C /TRUE
	RFALSE	


	.FUNCT	TREASURE-FOUND?,OBJ,PER,X
	EQUAL?	OBJ,TREASURE /?CCL3
	EQUAL?	OBJ,INKWELL \FALSE
	IN?	MOONMIST,INKWELL \FALSE
?CCL3:	FCLEAR	OBJ,SECRETBIT
	PRINTI	"""That must be the "
	PRINTD	ARTIFACT
	PRINTC	33
	CALL	TELL-STOP-SEARCHING?,PER >X
	PRINTI	"""
"
	SET	'PER,FRIEND
	IN?	PER,HERE /?CCL14
	SET	'PER,LORD
	IN?	PER,HERE \?CND13
?CCL14:	EQUAL?	PER,CONFESSED /?CND13
	PUTP	PER,P?LINE,0
	CALL	THIS-IS-IT,PER
	PRINTI	"""That's super!"" adds "
	PRINTD	PER
	PRINTI	". ""We can't thank you enough!"
	ZERO?	X \?PRG23
	CALL	TELL-STOP-SEARCHING?,PER >X
?PRG23:	PRINTI	"""
"
?CND13:	IN?	SEARCHER,HERE \?CND25
	ZERO?	X \?CND25
	CALL	TELL-STOP-SEARCHING?,SEARCHER,TRUE-VALUE,TRUE-VALUE
	ZERO?	STACK /?CND25
	PRINTI	""" says "
	PRINTD	SEARCHER
	PRINTI	".
"
?CND25:	ZERO?	TREASURE-FOUND \TRUE
	CALL	CONGRATS,ARTIFACT
	RTRUE	


	.FUNCT	TELL-STOP-SEARCHING?,PER,COMMA=0,NOSP=0,OBJ
	EQUAL?	PER,SEARCHER \FALSE
	GETP	PER,P?CHARACTER
	GET	GOAL-TABLES,STACK >OBJ
	GET	OBJ,GOAL-FUNCTION
	EQUAL?	STACK,X-SEARCHES \FALSE
	PUT	OBJ,GOAL-FUNCTION,NULL-F
	ZERO?	NOSP \?PRG11
	PRINTC	32
	JUMP	?PRG13
?PRG11:	PRINTC	34
?PRG13:	PRINTI	"Then that's the end of my searching"
	ZERO?	COMMA /?PRG20
	PRINTC	44
	JUMP	?CND15
?PRG20:	PRINTC	46
?CND15:	CALL	ZMEMQ,HERE,CHAR-ROOM-TABLE >OBJ
	ZERO?	OBJ /?CCL23
	SUB	OBJ,1
	GET	CHARACTER-TABLE,STACK
	EQUAL?	PER,STACK /TRUE
?CCL23:	CALL	ESTABLISH-GOAL,PER,SITTING-ROOM
	RTRUE	


	.FUNCT	GOOD-SHOW,PER,OBJ
	EQUAL?	PER,GHOST-NEW,CONFESSED /FALSE
	PRINTC	34
	GETP	PER,P?CHARACTER
	EQUAL?	VARIATION,STACK \?CCL7
	PRINTI	"How nice"
	JUMP	?PRG20
?CCL7:	EQUAL?	PER,FRIEND \?CCL11
	PRINTI	"That's keen"
	JUMP	?PRG20
?CCL11:	RANDOM	2
	EQUAL?	STACK,1 \?PRG18
	PRINTI	"Well done"
	JUMP	?PRG20
?PRG18:	PRINTI	"Good show"
?PRG20:	PRINTI	"! You found "
	CALL	PRINTA,OBJ
	PRINTC	33
	EQUAL?	OBJ,TREASURE \?PRG24
	CALL	TELL-STOP-SEARCHING?,PER,TRUE-VALUE
?PRG24:	PRINTI	""" says "
	PRINTD	PER
	PRINTR	"."


	.FUNCT	COMMON-DESC,PER
	PRINTI	"He's a "
	EQUAL?	PER,DOCTOR \?PRG13
	PRINTI	"middle-sized man in his fifties"
	IN?	MUSTACHE,DOCTOR \?PRG11
	PRINTI	", with spectacles and a grizzled mustache"
?PRG11:	PRINTR	"."
?PRG13:	PRINTI	"tall"
	EQUAL?	PER,LORD \?CCL17
	PRINTI	", handsome, dark-browed young man"
	GRTR?	BED-TIME,PRESENT-TIME \?PRG39
	PRINTI	" in dinner jacket and black tie"
	JUMP	?PRG39
?CCL17:	EQUAL?	PER,OFFICER \?CCL25
	PRINTI	" blond"
	GRTR?	BED-TIME,PRESENT-TIME \?PRG39
	PRINTI	", sporting a white dinner jacket and scarlet cummerbund. He moves with the elegant swagger of a Guards officer and young-man-about-Mayfair, both of which he is"
	JUMP	?PRG39
?CCL25:	EQUAL?	PER,DEALER \?PRG39
	PRINTI	", foppish art and antiques dealer"
	FSET?	PER,MUNGBIT /?PRG39
	PRINTI	". Despite his languid manner, you're aware of his penetrating glance. If you were buying a used car from this man, you'd want to check it out carefully"
?PRG39:	PRINTR	"."


	.FUNCT	COMMON-OTHER,PER,X=0,N
	EQUAL?	PRSA,V?ASK /FALSE
	EQUAL?	PRSA,V?EXAMINE \?CCL5
	EQUAL?	PER,DOCTOR /?CTR7
	EQUAL?	PER,LORD,OFFICER,DEALER \?CCL8
?CTR7:	CALL	COMMON-DESC,PER
	JUMP	?CND6
?CCL8:	EQUAL?	PER,GHOST-NEW /?CND6
	GETP	PER,P?TEXT
	PRINT	STACK
	CRLF	
?CND6:	IN?	PER,HERE \?CND14
	FIRST?	PER >N \?CND14
	FSET?	N,NDESCBIT /?CND14
	CALL	CARRY-CHECK,PER
	ZERO?	STACK /?CND14
	SET	'X,TRUE-VALUE
?CND14:	FSET?	PER,MUNGBIT \?CND21
	ZERO?	X /?CND23
	PRINTI	"And"
?CND23:	ZERO?	X /?PRT27
	PUSH	0
	JUMP	?PRE29
?PRT27:	PUSH	1
?PRE29:	CALL	HE-SHE-IT,PER,STACK,STR?1
	PRINTC	32
	GETP	PER,P?LDESC
	GET	LDESC-STRINGS,STACK
	PRINT	STACK
	PRINTC	46
	CRLF	
?CND21:	EQUAL?	PER,DEALER \?CCL34
	LOC	LORD
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \TRUE
	GETP	DEALER,P?LDESC
	EQUAL?	STACK,2 \TRUE
	GETP	LORD,P?LINE
	ZERO?	STACK \TRUE
	PRINTI	"""Montague began appraising the art works in the castle for Uncle Lionel before he died,"" explains "
	PRINTD	LORD
	PRINTR	". ""I've asked him to continue and make up a catalog."""
?CCL34:	EQUAL?	PER,PAINTER \TRUE
	LOC	FRIEND
	EQUAL?	STACK,HERE,PSEUDO-OBJECT \?CCL45
	SET	'X,FRIEND
	JUMP	?CND43
?CCL45:	CALL	FIND-FLAG-HERE,PERSONBIT,PLAYER,PAINTER >X
?CND43:	ZERO?	X /TRUE
	LOC	PAINTER
	EQUAL?	STACK,DRAWING-ROOM \TRUE
	PRINTI	"""Vivien painted that portrait of "
	PRINTD	LOVER
	PRINTI	" Hallam, the girl who drowned in the castle well,"" says "
	PRINTD	X
	PRINTI	". She gestures to a framed picture hanging by the "
	PRINTD	FIREPLACE
	PRINTR	"."
?CCL5:	EQUAL?	PRSO,PER \FALSE
	EQUAL?	PRSA,V?SHOW \FALSE
	CALL	PERFORM,V?ASK-ABOUT,PRSO,PRSI
	RTRUE	


	.FUNCT	UNSNOOZE,PER,NO-TELL?=0,RM,GT,C
	GETP	PER,P?LDESC >C
	EQUAL?	C,14 \?CCL3
	CALL	FIX-MUSTACHE,PER
	GETP	PER,P?CHARACTER >C
	GET	GOAL-TABLES,C >GT
	GET	GT,ATTENTION-SPAN
	PUT	GT,ATTENTION,STACK
	PUT	GT,GOAL-ENABLE,0
	PUT	GT,GOAL-FUNCTION,X-RETIRES
	PUT	GT,GOAL-S,TRUE-VALUE
	ADD	1,C
	GET	CHAR-ROOM-TABLE,STACK >RM
	IN?	PER,RM /?CND4
	CALL	ESTABLISH-GOAL,PER,RM
?CND4:	EQUAL?	VARIATION,C \?CCL8
	PUTP	PER,P?LDESC,4
	JUMP	?CND6
?CCL8:	PUTP	PER,P?LDESC,25
?CND6:	FCLEAR	PER,MUNGBIT
	CALL	META-LOC,PER >RM
	IN?	PER,HERE \?CND9
	ZERO?	NO-TELL? \?CND9
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTI	" wakes up first. "
	FSET?	RM,ONBIT /?CND9
	CALL	HE-SHE-IT,PER,TRUE-VALUE
	PRINTI	" turns on the light. "
?CND9:	FSET	RM,ONBIT
	RTRUE	
?CCL3:	EQUAL?	C,19 \FALSE
	GETP	PER,P?CHARACTER
	GET	SHOT,STACK
	ZERO?	STACK \FALSE
	CALL	FIX-MUSTACHE,PER
	CALL	QUEUE,I-COME-TO,0
	CALL	I-COME-TO
	RTRUE	


	.FUNCT	FIX-MUSTACHE,PER
	EQUAL?	PER,DOCTOR \FALSE
	EQUAL?	VARIATION,DOCTOR-C \FALSE
	FCLEAR	MUSTACHE,TAKEBIT
	FSET	MUSTACHE,TRYTAKEBIT
	RTRUE	


	.FUNCT	OBJECT-PAIR-F,P1,P2,?TMP1
	GETB	P-PRSO,P-MATCHLEN
	LESS?	2,STACK \?CCL3
	SET	'CLOCK-WAIT,TRUE-VALUE
	PRINTR	"(That's too many things to compare all at once!)"
?CCL3:	GETB	P-PRSO,1 >?TMP1
	GETB	P-PRSO,2
	CALL	PERFORM,PRSA,?TMP1,STACK
	RTRUE	


	.FUNCT	CREW-GLOBAL-F,L
	CALL	QUEUED?,I-TOUR
	ZERO?	STACK /?CCL3
	EQUAL?	PRSA,V?WALK-TO \?CCL3
	GET	TOUR-PATH,TOUR-INDEX
	CALL	PERFORM,PRSA,STACK
	RTRUE	
?CCL3:	CALL	ALL-TOGETHER-NOW?
	ZERO?	STACK \?CCL7
	SET	'CLOCK-WAIT,TRUE-VALUE
	PRINTI	"(The guests aren't all together!)"
	CRLF	
	RETURN	2
?CCL7:	EQUAL?	PRSA,V?EXAMINE \?CCL13
	PRINTR	"There are seven people, not counting you."
?CCL13:	EQUAL?	PRSA,V?HELLO \?PRG20
	CALL	START-SENTENCE,PRSO
	PRINTR	" nods at you."
?PRG20:	PRINTI	"You'd better stick to one guest at a time."
	CRLF	
	RETURN	2

	.ENDI
