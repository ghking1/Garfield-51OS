
;****************************************************************************
;*																			*
;*								CONST										*
;*																			*
;****************************************************************************

;STACK INFO
STACK0	EQU	050H
STACK1	EQU	060H
STACK2	EQU	070H
STACK3	EQU	080H
STACK4	EQU	090H
STACK5	EQU	0A0H
STACK6	EQU	0C0H
STACK7	EQU	0E0H


;TIMER0 INFO
TIMEH0	EQU 0E0H
TIMEL0	EQU 018H


;SYSTEM RAM INFO
CUR_SP_LOC			EQU 040H
CUR_WAIT_LOC		EQU 041H


;WAIT INFO
EVERY_WAIT_TIMES	EQU 0AH


;SYSTEM CALL INFO
TASK_NUM_LOC		EQU 47H
WAIT_TIME_LOC		EQU	46H
RETURN_LOC			EQU 45H




;****************************************************************************
;*																			*
;*								INIT										*
;*																			*
;****************************************************************************

	ORG		0000H
	LJMP	_INIT_

	ORG		000BH
	LJMP	_SWITCH_

	ORG		0030H

	;init environment of TASK0~TASK6
_INIT_:
	MOV		38H,#00H		;init task0 WAIT TIME
	MOV		30H,#STACK0+6	;init task0	SP
	MOV		SP,#STACK0-1	;set SP to start of task0 stack 
	MOV		DPTR,#TASK0		;move task0's start location to DPTR
	PUSH	DPL				;PUSH start location low byte
	PUSH	DPH				;PUSH start location hight byte
	MOV		A,#00H			;task0 use group-0 register
	PUSH	ACC				;push PSW                            

	MOV		39H,#00H		;init task1 WAIT TIME
	MOV		31H,#STACK1+6   ;init task1	SP
	MOV		SP,#STACK1-1    ;set SP to start of task1 stack 
	MOV		DPTR,#TASK1     ;move task1's start location to DPTR
	PUSH	DPL             ;PUSH start location low byte
	PUSH	DPH             ;PUSH start location hight byte
	MOV		A,#08H          ;task1 use group-1 register
	PUSH	ACC             ;push PSW                           

	MOV		3AH,#00H		;init task2 WAIT TIME
	MOV		32H,#STACK2+6   ;init task2	SP
	MOV		SP,#STACK2-1    ;set SP to start of task2 stack 
	MOV		DPTR,#TASK2     ;move task2's start location to DPTR
	PUSH	DPL             ;PUSH start location low byte
	PUSH	DPH             ;PUSH start location hight byte
	MOV		A,#10H          ;task2 use group-2 register
	PUSH	ACC             ;push PSW                           
	
	MOV		3BH,#00H		;init task3 WAIT TIME
	MOV		33H,#STACK3+14  ;init task3	SP
	MOV		SP,#STACK3-1    ;set SP to start of task3 stack 
	MOV		DPTR,#TASK3     ;move task3's start location to DPTR
	PUSH	DPL             ;PUSH start location low byte
	PUSH	DPH             ;PUSH start location hight byte
	ACALL	_PSW_INIT_      ;task3 use group-3 register

	MOV		3CH,#00H		;init task4 WAIT TIME
	MOV		34H,#STACK4+14  ;init task4	SP
	MOV		SP,#STACK4-1    ;set SP to start of task4 stack 
	MOV		DPTR,#TASK4     ;move task4's start location to DPTR
	PUSH	DPL             ;PUSH start location low byte
	PUSH	DPH             ;PUSH start location hight byte
	ACALL	_PSW_INIT_      ;task4 use group-3 register

	MOV		3DH,#00H		;init task5 WAIT TIME
	MOV		35H,#STACK5+14  ;init task5	SP
	MOV		SP,#STACK5-1    ;set SP to start of task5 stack 
	MOV		DPTR,#TASK5     ;move task5's start location to DPTR
	PUSH	DPL             ;PUSH start location low byte
	PUSH	DPH             ;PUSH start location hight byte
	ACALL	_PSW_INIT_      ;task5 use group-3 register

	MOV		3EH,#00H		;init task6 WAIT TIME
	MOV		36H,#STACK6+14  ;init task6	SP
	MOV		SP,#STACK6-1    ;set SP to start of task6 stack 
	MOV		DPTR,#TASK6     ;move task6's start location to DPTR
	PUSH	DPL             ;PUSH start location low byte
	PUSH	DPH             ;PUSH start location hight byte
	ACALL	_PSW_INIT_      ;task6 use group-3 register


	;init hardware
	MOV		TMOD,#00H			;time slice generator init
	MOV		IP,#02H				;interupter priority
	MOV		IE,#82H				;interupter open

	MOV		TH0,#TIMEH0			;set TH0
	MOV		TL0,#TIMEL0			;set TL0
	SETB	TR0					;start clock

	MOV		CUR_WAIT_LOC,#00H	;init CUR_WAIT_LOC
	MOV		CUR_SP_LOC,#37H		;init CUR_SP_LOC

	;init and goto TASK7
	MOV		3FH,#00H		;init task7 WAIT TIME
	MOV		SP,#STACK7-1	;init task7 SP
	MOV		PSW,#18H		;task7 use group-3 register
	LJMP	TASK7			;goto task7


_PSW_INIT_:
	MOV		A,SP			;init PSW of TASK3~TASK6
	ADD		A,#07H
	MOV		R0,A
	MOV		@R0,#18H
	RET





;****************************************************************************
;*																			*
;*								SWITCH										*
;*																			*
;****************************************************************************
_SWITCH_:
	;close	interupter
	CLR		EA

	;reset clock
	MOV		TH0,#TIMEH0
	MOV		TL0,#TIMEL0
	SETB	TR0



	;save current task environment
_SAVE_:
	JNB		RS1,_SHFG1_		;TASK0 and TASK1 needn't save R0~R7
	JNB		RS0,_SHFG1_		;TASK2 needn't save R0~R7
	PUSH	18H				;save R0 of TASK3~TASK7
	PUSH	19H				;save R1 of TASK3~TASK7
	PUSH	1AH				;save R2 of TASK3~TASK7
	PUSH	1BH				;save R3 of TASK3~TASK7
	PUSH	1CH				;save R4 of TASK3~TASK7
	PUSH	1DH				;save R5 of TASK3~TASK7
	PUSH	1EH				;save R6 of TASK3~TASK7
	PUSH	1FH				;save R7 of TASK3~TASK7
_SHFG1_:
	PUSH	PSW				;save PSW
	PUSH	ACC				;save A
	PUSH	B				;save B
	PUSH	DPL				;save DPL
	PUSH	DPH				;save DPH



	SETB	RS1				;switch to group-3 register
	SETB	RS0
	MOV		R0,CUR_SP_LOC	;get SP location of current TASK
	MOV		@R0,SP			;save SP




	;dicrease WAIT time of every task
_DECREASE_:
	MOV		R2,CUR_WAIT_LOC				;get CUR_WAIT_LOC value
	INC		R2								;increas CUR_WAIT_loc value
	CJNE	R2,#EVERY_WAIT_TIMES,_SHFG6_	;if upto EVERY_WAIT_TIMES,then decrease WAIT time of every task,else just save increased EVERY_WAIT_TIMES
	MOV		R2,#00H
	
	MOV		R1,#37H
	MOV		R3,#08H				;there are eight task
_SHFG2_:
	INC		R1
	CJNE	@R1,#0FFH,_SHFG3_	;#FFH means stoped task, needn't decrease WAIT time
	SJMP	_SHFG5_
_SHFG3_:
	CJNE	@R1,#00H,_SHFG4_	;#00H means running task, needn't decrease WAIT time
	SJMP	_SHFG5_
_SHFG4_:
	DEC		@R1					;others need decrease WAIT time
_SHFG5_:
	DJNZ	R3,_SHFG2_
_SHFG6_:
	MOV		CUR_WAIT_LOC,R2	;save increased CUR_WAIT_LOC value




	;select next task
_SELECT_:
	MOV		A,R0			;add #08H to R0, get relative state location
	ADD		A,#08H
	MOV		R0,A

	MOV		R4,#09H			;there are eight task, but here, we need decrease it at start, so it is #09H
_SHFG7_:
	DJNZ	R4,_SHFG8_		;judge one circle, if no running task goto _ALL_WAIT_
	SJMP	_ALL_WAIT_
_SHFG8_:
	CJNE	R0,#3FH,_SHFG9_	;upto the end, let it get to start
	MOV		R0,#037H
_SHFG9_:
	INC		R0
	CJNE	@R0,#00H,_SHFG7_;#00H means running task, choose it!



	CLR		C				;subb #08H from R0, get relative SP location
	MOV		A,R0
	SUBB	A,#08H
	MOV		R0,A



	MOV		40H,R0			;get SP location of next TASK
	MOV		SP,@R0			;restore SP




	;restore next task environment
_RESTORE_:
	POP		DPH				;restore DPH
	POP		DPL				;restore DPL
	POP		B				;restore B
	POP		ACC				;restore A
	POP		PSW				;restore PSW
	JNB		RS1,_SHFGA_		;TASK0 and TASK1 needn't restore R0~R7
	JNB		RS0,_SHFGA_		;TASK2 needn't restore R0~R7
	POP		1FH				;restore R7 of TASK3~TASK7
	POP		1EH				;restore R6 of TASK3~TASK7
	POP		1DH				;restore R5 of TASK3~TASK7
	POP		1CH				;restore R4 of TASK3~TASK7
	POP		1BH				;restore R3 of TASK3~TASK7
	POP		1AH				;restore R2 of TASK3~TASK7
	POP		19H				;restore R1 of TASK3~TASK7
	POP		18H				;restore R0 of TASK3~TASK7
_SHFGA_:



	;open interupter
	SETB	EA



	;return to the next task
	RETI





_ALL_WAIT_:				;when all of the task is not running, SWITCH goto here wait 1ms then get back to check task again
	CLR		TF0
_SHFGB_:
	JB		TF0,_SHFGC_		;waite for timer flow, about 1ms
	JMP		_SHFGB_
_SHFGC_:
	CLR		TF0
	MOV		TH0,#TIMEH0		;reset clock	
	MOV		TL0,#TIMEL0
	CLR		C				;subb #08H from R0, get relative SP location
	MOV		A,R0
	SUBB	A,#08H
	MOV		R0,A
	LJMP	_DECREASE_		;then goto DECREASE
	




;****************************************************************************
;*																			*
;*							SYSTEM CALL										*
;*																			*
;****************************************************************************


;*********************************WAIT***************************************
WAIT:
	;save environment
	PUSH	PSW
	PUSH	ACC
	SETB	RS1					;switch to register group-3
	SETB	RS0
	PUSH	18H

	;judge is the operator is current task 
	MOV		A,TASK_NUM_LOC		;get value of TASK_NUM_LOC
	CJNE	A,#0FFH,_SLFG1_		;#0FFH means current task

	;is current task
	MOV		A,CUR_SP_LOC		;get value of CUR_SP_LOC
	ADD		A,#08H				;caculate WAIT TIME location
	SJMP	_SLFG3_

	;not current task, need judge if the task number is legal
_SLFG1_:
	CLR		C
	PUSH	ACC
	SUBB	A,#08H				;all task number should be smaller then #08H
	POP		ACC
	JNC		_SLFG4_				;test C, C==1 means TASK NUM larger then seven, it's illegal
	ADD		A,#38H				;caculate WAIT TIME location
	SJMP	_SLFG3_
_SLFG4_:
	MOV		RETURN_LOC,#01H		;set RETURN_LOC value to #01H, means encountered error
	SJMP	_SLFG2_

	;set value of wait state
_SLFG3_:
	MOV		RETURN_LOC,#00H		;set RETURN_LOC value to #00H, means successed
	MOV		R0,A				
	MOV		A,WAIT_TIME_LOC		;get value of WAIT_TIME_LOC
	MOV		@R0,A				;save WAIT TIME to WAIT TIME location

	;if is current task, we need SWITCH, else just return
	MOV		A,CUR_SP_LOC		;get value of CUR_SP_LOC
	ADD		A,#08H				;caculate WAIT TIME location
	CJNE	A,18H,_SLFG2_		;current task WAIT TIME location(A) == TASK_NUM_LOC's task WAIT TIME location(R0) means is curren task 
	POP		18H
	POP		ACC
	POP		PSW
	LJMP	_SWITCH_			;will use RETI in _SWITCH_ to return to next task

	;restore environment
_SLFG2_:
	POP		18H				
	POP		ACC
	POP		PSW
	RET



;*********************************WAKEUP*************************************
WAKEUP:
	;save environment
	PUSH	PSW
	PUSH	ACC
	SETB	RS1					;switch to register group-3
	SETB	RS0
	PUSH	18H

	 ;get and judge if the task number is legal
	MOV		A,TASK_NUM_LOC		;get value of TASK_NUM_LOC
	MOV		R0,A
	CLR		C
	SUBB	A,#08H				;all task number should be smaller then #08H
	JC		_SLFG5_				;test C, C==1 means TASK NUM larger then seven, it's illegal

	;illegal task number
	MOV		RETURN_LOC,#01H		;set RETURN_LOC value to #01H, means encountered error
	SJMP	_SLFG6_

	;set value of wait state, then if is current task, we need SWITCH, else just return
_SLFG5_:
	MOV		RETURN_LOC,#00H		;set RETURN_LOC value to #00H, means successed
	MOV		A,R0				;caculate WAIT TIME location
	ADD		A,#38H
	MOV		R0,A
	MOV		@R0,#00H			;save WAIT TIME to WAIT TIME location, #00H means running

	;restore environment
_SLFG6_:
	POP		18H				
	POP		ACC
	POP		PSW
	RET





;****************************************************************************
;*																			*
;*								TASK0										*
;*																			*
;****************************************************************************
TASK0:
	MOV		38H,#0FFH
	SJMP	$










;****************************************************************************
;*																			*
;*								TASK1										*
;*																			*
;****************************************************************************
TASK1:
	MOV		R0,#01H
TA2:
	MOV		A,R0
	RL		A
	MOV		R0,A
	MOV		P0,R0 

	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0
	SJMP	TA2







;****************************************************************************
;*																			*
;*								TASK2										*
;*																			*
;****************************************************************************
TASK2:
	MOV		3AH,#0FFH
	SJMP	$










;****************************************************************************
;*																			*
;*								TASK3										*
;*																			*
;****************************************************************************
TASK3:
	MOV		3BH,#0FFH
	SJMP	$












;****************************************************************************
;*																			*
;*								TASK4										*
;*																			*
;****************************************************************************
TASK4:
	MOV		3CH,#0FFH
	SJMP	$















;****************************************************************************
;*																			*
;*								TASK5										*
;*																			*
;****************************************************************************
TASK5:
	MOV		P1,#0DEH
	MOV		R2,#04H
F51:
	MOV		3DH,#250
	ACALL	_SWITCH_
	DJNZ	R2,F51


	MOV		R2,#03H
F52:
	MOV		P1,#0EDH
	MOV		3DH,#50
	ACALL	_SWITCH_
	MOV		P1,#0FFH
	MOV		3DH,#50
	ACALL	_SWITCH_
	DJNZ	R2,F52


	MOV		P1,#0F3H
	MOV		R2,#04H
F53:
	MOV		3DH,#250
	ACALL	_SWITCH_
	DJNZ	R2,F53


	MOV		R2,#03H
F54:
	MOV		P1,#0EDH
	MOV		3DH,#50
	ACALL	_SWITCH_
	MOV		P1,#0FFH
	MOV		3DH,#50
	ACALL	_SWITCH_
	DJNZ	R2,F54

	SJMP	TASK5











;****************************************************************************
;*																			*
;*								TASK6										*
;*																			*
;****************************************************************************

DIG_code:	
	DB		3fH, 06H, 5bH, 4fH, 66H, 6dH, 7dH, 07H, 7fH, 6fH


TASK6:
	MOV		DPTR,#DIG_code
	MOV		R2,#00H
F61:
	MOV		A,R2
	MOVC	A,@A+DPTR
	CPL		A
	MOV		P2,A

	CJNE	R2,#09H,F62
	MOV		R2,#0FFH
F62:
	INC		R2

	CLR		TR0
	MOV		TASK_NUM_LOC,#01H
	ACALL	WAKEUP
	SETB	TR0

	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#100
	ACALL	WAIT
	SETB	TR0

	SJMP	F61















;****************************************************************************
;*																			*
;*								TASK7										*
;*																			*
;****************************************************************************
TASK7:
	CLR		TR0
	MOV		TASK_NUM_LOC,#00H
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0

	CLR		TR0
	MOV		TASK_NUM_LOC,#02H
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0

	CLR		TR0
	MOV		TASK_NUM_LOC,#03H
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0

	CLR		TR0
	MOV		TASK_NUM_LOC,#04H
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0

	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0

	SJMP	$















;****************************************************************************
;*																			*
;*								THE END										*
;*																			*
;****************************************************************************
	
	END  

