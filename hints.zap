

	.FUNCT	V-HINTS-NO
	EQUAL?	GL-PRSO,ROOMS /?CCL3
	PRINT	K-DONT-UNDERSTAND-MSG
	CRLF	
	RETURN	2
?CCL3:	SET	'GL-HINTS-OFF,TRUE-VALUE
	PRINTI	"[Hints have been disallowed for this session.]"
	CRLF	
	RETURN	2


	.FUNCT	V-HINT,CHR,MAXC,C,Q,WHO
?FCN:	ZERO?	GL-HINTS-OFF /?CCL3
	ICALL	RT-PERFORM,V?HINTS-NO,ROOMS
	RETURN	2
?CCL3:	ZERO?	GL-HINT-WARNING \?CCL5
	SET	'GL-HINT-WARNING,TRUE-VALUE
	PRINTI	"[Warning: It is recognized that the temptation for help may at times be so exceedingly strong that you might fetch hints prematurely. Therefore, you may at any time during the story type HINTS OFF, and this will disallow the seeking out of help for the present session of the story. If you still want a hint now, indicate HINT.]"
	CRLF	
	RETURN	2
?CCL5:	ZERO?	WHO \?CND1
	CALL1	RT-WHO-SAYS? >WHO
	EQUAL?	WHO,CH-HOLMES,CH-WIGGINS \?CND1
	EQUAL?	WHO,CH-HOLMES \?CCL11
	PRINTI	"Holmes looks at you impatiently and sighs, ""Very well, Watson. If you must."""
	JUMP	?CND9
?CCL11:	PRINTI	"Wiggins looks up at you with relief and says, ""Good idea, guv. We'll never work this out on our own."""
?CND9:	CRLF	
	CRLF	
	PRINTI	"[Press any key to continue.]"
	CRLF	
	INPUT	1
?CND1:	SET	'SOUND-QUEUED?,FALSE-VALUE
	ICALL1	KILL-SOUNDS
	SET	'MAXC,18
	ICALL1	RT-INIT-HINT-SCREEN
	CURSET	5,1
	ICALL1	RT-PUT-UP-CHAPTERS
	SUB	GL-CHAPT-NUM,1 >GL-CUR-POS
	ICALL1	RT-NEW-CURSOR
?PRG12:	INPUT	1 >CHR
	EQUAL?	CHR,81,113 \?CCL16
	SET	'Q,TRUE-VALUE
	JUMP	?REP13
?CCL16:	EQUAL?	CHR,78,110 \?CCL18
	ICALL1	RT-ERASE-CURSOR
	EQUAL?	GL-CHAPT-NUM,MAXC \?CCL21
	SET	'GL-CUR-POS,0
	SET	'GL-CHAPT-NUM,1
	SET	'GL-QUEST-NUM,1
	JUMP	?CND19
?CCL21:	INC	'GL-CUR-POS
	INC	'GL-CHAPT-NUM
	SET	'GL-QUEST-NUM,1
?CND19:	ICALL1	RT-NEW-CURSOR
	JUMP	?PRG12
?CCL18:	EQUAL?	CHR,80,112 \?CCL23
	ICALL1	RT-ERASE-CURSOR
	EQUAL?	GL-CHAPT-NUM,1 \?CCL26
	SET	'GL-CHAPT-NUM,MAXC
	SUB	MAXC,1 >GL-CUR-POS
	JUMP	?CND24
?CCL26:	DEC	'GL-CUR-POS
	DEC	'GL-CHAPT-NUM
?CND24:	SET	'GL-QUEST-NUM,1
	ICALL1	RT-NEW-CURSOR
	JUMP	?PRG12
?CCL23:	EQUAL?	CHR,13,10 \?PRG12
	ICALL1	RT-PICK-QUESTION
?REP13:	ZERO?	Q /?FCN
	CLEAR	-1
	ICALL1	V-REFRESH
	CALL1	RT-WHO-SAYS? >WHO
	EQUAL?	WHO,CH-HOLMES \?CCL32
	CRLF	
	PRINTI	"Holmes barely glances at you and snaps, ""At last. Now may we proceed?"""
	CRLF	
	JUMP	?CND30
?CCL32:	EQUAL?	WHO,CH-WIGGINS \?CCL34
	CRLF	
	PRINTI	"Wiggins tugs your sleeve and asks hopefully, ""Learn anything?"""
	CRLF	
	JUMP	?CND30
?CCL34:	CRLF	
	PRINTI	"Back to the story..."
	CRLF	
?CND30:	ZERO?	SOUND-ON? \?CCL36
	RETURN	2
?CCL36:	ICALL1	CHECK-LOOPING
	RETURN	2


	.FUNCT	RT-PICK-QUESTION,CHR,MAXQ,Q
?FCN:	ICALL2	RT-INIT-HINT-SCREEN,FALSE-VALUE
	ICALL	RT-LEFT-LINE,3,RETURN-SEE-HINT,RETURN-SEE-HINT-LEN
	ICALL	RT-RIGHT-LINE,3,Q-MAIN-MENU,Q-MAIN-MENU-LEN
	GET	K-HINTS,GL-CHAPT-NUM
	GET	STACK,0
	SUB	STACK,1 >MAXQ
	CURSET	5,1
	ICALL1	RT-PUT-UP-QUESTIONS
	SUB	GL-QUEST-NUM,1 >GL-CUR-POS
	ICALL1	RT-NEW-CURSOR
?PRG1:	INPUT	1 >CHR
	EQUAL?	CHR,81,113 \?CCL5
	SET	'Q,TRUE-VALUE
	JUMP	?REP2
?CCL5:	EQUAL?	CHR,78,110 \?CCL7
	ICALL1	RT-ERASE-CURSOR
	EQUAL?	GL-QUEST-NUM,MAXQ \?CCL10
	SET	'GL-CUR-POS,0
	SET	'GL-QUEST-NUM,1
	JUMP	?CND8
?CCL10:	INC	'GL-CUR-POS
	INC	'GL-QUEST-NUM
?CND8:	ICALL1	RT-NEW-CURSOR
	JUMP	?PRG1
?CCL7:	EQUAL?	CHR,80,112 \?CCL12
	ICALL1	RT-ERASE-CURSOR
	EQUAL?	GL-QUEST-NUM,1 \?CCL15
	SET	'GL-QUEST-NUM,MAXQ
	SUB	MAXQ,1 >GL-CUR-POS
	JUMP	?CND13
?CCL15:	DEC	'GL-CUR-POS
	DEC	'GL-QUEST-NUM
?CND13:	ICALL1	RT-NEW-CURSOR
	JUMP	?PRG1
?CCL12:	EQUAL?	CHR,13,10 \?PRG1
	ICALL1	RT-DISPLAY-HINT
?REP2:	ZERO?	Q /?FCN
	RFALSE	


	.FUNCT	RT-ERASE-CURSOR,?TMP1
	GET	GL-LINE-TABLE,GL-CUR-POS >?TMP1
	GET	GL-COLUMN-TABLE,GL-CUR-POS
	SUB	STACK,2
	CURSET	?TMP1,STACK
	PRINTC	32
	RTRUE	


	.FUNCT	RT-NEW-CURSOR,?TMP1
	GET	GL-LINE-TABLE,GL-CUR-POS >?TMP1
	GET	GL-COLUMN-TABLE,GL-CUR-POS
	SUB	STACK,2
	CURSET	?TMP1,STACK
	PRINTC	62
	RTRUE	


	.FUNCT	RT-INVERSE-LINE,CENTER-HALF
	HLIGHT	K-H-INV
	GETB	0,33
	ICALL2	RT-PRINT-SPACES,STACK
	HLIGHT	K-H-NRM
	RTRUE	


	.FUNCT	RT-DISPLAY-HINT,H,MX,CNT,CHR,FLG,N,CV,SHIFT?,COUNT-OFFS,CURCX,CURC,?TMP1
	SET	'CNT,2
	SET	'FLG,TRUE-VALUE
	CLEAR	-1
	SPLIT	3
	SCREEN	K-S-WIN
	CURSET	1,1
	ICALL1	RT-INVERSE-LINE
	ICALL	RT-CENTER-LINE,1,STR?641,16
	CURSET	3,1
	ICALL1	RT-INVERSE-LINE
	ICALL	RT-LEFT-LINE,3,STR?642
	ICALL	RT-RIGHT-LINE,3,STR?643,17
	CURSET	2,1
	ICALL1	RT-INVERSE-LINE
	HLIGHT	K-H-BLD
	GET	K-HINTS,GL-CHAPT-NUM >?TMP1
	ADD	GL-QUEST-NUM,1
	GET	?TMP1,STACK >H
	SUB	GL-CHAPT-NUM,1
	GET	K-HINT-COUNTS,STACK >CV
	GET	H,1
	ICALL	RT-CENTER-LINE,2,STACK
	HLIGHT	K-H-NRM
	GET	H,0 >MX
	SCREEN	K-S-NOR
	CRLF	
	MOD	GL-QUEST-NUM,2 >SHIFT?
	SUB	GL-QUEST-NUM,1
	DIV	STACK,2 >COUNT-OFFS
	GETB	CV,COUNT-OFFS >CURCX
	ZERO?	SHIFT? /?CCL3
	SHIFT	CURCX,-4
	JUMP	?CND1
?CCL3:	PUSH	CURCX
?CND1:	BAND	STACK,15
	ADD	2,STACK >CURC
?PRG4:	EQUAL?	CNT,CURC /?PRG9
	GET	H,CNT
	PRINT	STACK
	CRLF	
	INC	'CNT
	JUMP	?PRG4
?PRG9:	ZERO?	FLG /?CCL13
	GRTR?	CNT,MX \?CCL13
	SET	'FLG,FALSE-VALUE
	PRINTI	"[That's all.]"
	CRLF	
	JUMP	?CND11
?CCL13:	ZERO?	FLG /?CND11
	SUB	MX,CNT
	ADD	STACK,1 >N
	PRINTC	91
	PRINTN	N
	PRINTI	" hint"
	EQUAL?	N,1 /?CND17
	PRINTC	115
?CND17:	PRINTI	" left.]"
	PRINTI	" -> "
	SET	'FLG,FALSE-VALUE
?CND11:	INPUT	1 >CHR
	EQUAL?	CHR,81,113 \?CCL21
	ZERO?	SHIFT? /?CCL24
	GETB	CV,COUNT-OFFS
	BAND	STACK,15 >?TMP1
	SUB	CNT,2
	SHIFT	STACK,4
	BOR	?TMP1,STACK
	PUTB	CV,COUNT-OFFS,STACK
	RTRUE	
?CCL24:	GETB	CV,COUNT-OFFS
	BAND	STACK,240 >?TMP1
	SUB	CNT,2
	BOR	?TMP1,STACK
	PUTB	CV,COUNT-OFFS,STACK
	RTRUE	
?CCL21:	EQUAL?	CHR,13,10 \?PRG9
	GRTR?	CNT,MX /?PRG9
	SET	'FLG,TRUE-VALUE
	GET	H,CNT
	PRINT	STACK
	CRLF	
	IGRTR?	'CNT,MX \?PRG9
	SET	'FLG,FALSE-VALUE
	PRINTI	"[Final hint]"
	CRLF	
	JUMP	?PRG9


	.FUNCT	RT-PUT-UP-QUESTIONS,ST,MXQ,MXL,?TMP1
	SET	'ST,1
	GET	K-HINTS,GL-CHAPT-NUM
	GET	STACK,0
	SUB	STACK,1 >MXQ
	GETB	0,32
	SUB	STACK,1 >MXL
?PRG1:	GRTR?	ST,MXQ /TRUE
	SUB	ST,1
	GET	GL-LINE-TABLE,STACK >?TMP1
	SUB	ST,1
	GET	GL-COLUMN-TABLE,STACK
	SUB	STACK,1
	CURSET	?TMP1,STACK
	PRINTC	32
	GET	K-HINTS,GL-CHAPT-NUM >?TMP1
	ADD	ST,1
	GET	?TMP1,STACK
	GET	STACK,1
	PRINT	STACK
	INC	'ST
	JUMP	?PRG1


	.FUNCT	RT-PUT-UP-CHAPTERS,ST,MXC,MXL,?TMP1
	SET	'ST,1
	SET	'MXC,18
	GETB	0,32
	SUB	STACK,1 >MXL
?PRG1:	GRTR?	ST,MXC /TRUE
	SUB	ST,1
	GET	GL-LINE-TABLE,STACK >?TMP1
	SUB	ST,1
	GET	GL-COLUMN-TABLE,STACK
	SUB	STACK,1
	CURSET	?TMP1,STACK
	PRINTC	32
	GET	K-HINTS,ST
	GET	STACK,1
	PRINT	STACK
	INC	'ST
	JUMP	?PRG1


	.FUNCT	RT-INIT-HINT-SCREEN,THIRD
	ASSIGNED?	'THIRD /?CND1
	SET	'THIRD,TRUE-VALUE
?CND1:	CLEAR	-1
	GETB	0,32
	SUB	STACK,1
	SPLIT	STACK
	SCREEN	K-S-WIN
	CURSET	1,1
	ICALL1	RT-INVERSE-LINE
	CURSET	2,1
	ICALL1	RT-INVERSE-LINE
	CURSET	3,1
	ICALL1	RT-INVERSE-LINE
	ICALL	RT-CENTER-LINE,1,STR?641,16
	ICALL	RT-LEFT-LINE,2,STR?644
	ICALL	RT-RIGHT-LINE,2,STR?645,12
	ZERO?	THIRD /FALSE
	ICALL	RT-LEFT-LINE,3,STR?646
	CALL	RT-RIGHT-LINE,3,STR?647,16
	RSTACK	


	.FUNCT	RT-CENTER-LINE,LN,STR,LEN,INV
	ASSIGNED?	'INV /?CND1
	SET	'INV,TRUE-VALUE
?CND1:	ZERO?	LEN \?CND3
	DIROUT	K-D-TBL-ON,GL-DIROUT-TBL
	PRINT	STR
	DIROUT	K-D-TBL-OFF
	GET	GL-DIROUT-TBL,0 >LEN
?CND3:	GETB	0,33
	SUB	STACK,LEN
	DIV	STACK,2
	CURSET	LN,STACK
	ZERO?	INV /?CND5
	HLIGHT	K-H-INV
?CND5:	PRINT	STR
	ZERO?	INV /FALSE
	HLIGHT	K-H-NRM
	RTRUE	


	.FUNCT	RT-LEFT-LINE,LN,STR,INV
	ASSIGNED?	'INV /?CND1
	SET	'INV,TRUE-VALUE
?CND1:	CURSET	LN,1
	ZERO?	INV /?CND3
	HLIGHT	K-H-INV
?CND3:	PRINT	STR
	ZERO?	INV /FALSE
	HLIGHT	K-H-NRM
	RTRUE	


	.FUNCT	RT-RIGHT-LINE,LN,STR,LEN,INV
	ASSIGNED?	'INV /?CND1
	SET	'INV,TRUE-VALUE
?CND1:	ZERO?	LEN \?CND3
	DIROUT	3,GL-DIROUT-TBL
	PRINT	STR
	DIROUT	-3
	GET	GL-DIROUT-TBL,0 >LEN
?CND3:	GETB	0,33
	SUB	STACK,LEN
	CURSET	LN,STACK
	ZERO?	INV /?CND5
	HLIGHT	K-H-INV
?CND5:	PRINT	STR
	ZERO?	INV /FALSE
	HLIGHT	K-H-NRM
	RTRUE	

	.ENDI
