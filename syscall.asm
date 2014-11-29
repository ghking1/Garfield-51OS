#include "config.inc"

NAME	SYSCALL

EXTRN	CODE	(_SWITCH_)

PUBLIC	WAIT, WAKEUP

SYSCALL	SEGMENT		CODE
RSEG	SYSCALL


;********************************************************
;*														*
;*						WAKEUP							*
;*														*
;********************************************************
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



;********************************************************
;*														*
;*						WAKEUP							*
;*														*
;********************************************************
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

	END
