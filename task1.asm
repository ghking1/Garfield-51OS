
#include "config.inc"
#include "Garfield.inc"

NAME	TASK1

PUBLIC	TASK1

TASK1_	SEGMENT		CODE
RSEG	TASK1_



TASK1:

;********************************************************
;*														*
;*				START YOUR CODE HERE					*
;*														*
;********************************************************


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














;********************************************************
;*														*
;*				END OF YOUR CODE HERE					*
;*														*
;********************************************************

	;close this task
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#0FFH
	ACALL	WAIT
	SETB	TR0

	END
