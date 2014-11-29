
#include "config.inc"
#include "Garfield.inc"

NAME	TASK5

PUBLIC	TASK5

TASK5_	SEGMENT		CODE
RSEG	TASK5_



TASK5:

;********************************************************
;*														*
;*				START YOUR CODE HERE					*
;*														*
;********************************************************

	

	MOV		P1,#0DEH
	MOV		R2,#04H
F1:
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#0FAH
	ACALL	WAIT
	SETB	TR0
	DJNZ	R2,F1



	MOV		R2,#03H
F2:
	MOV		P1,#0EDH
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#50
	ACALL	WAIT
	SETB	TR0

	MOV		P1,#0FFH
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#50
	ACALL	WAIT
	SETB	TR0

	DJNZ	R2,F2



	MOV		P1,#0F3H
	MOV		R2,#04H
F3:
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#0FAH
	ACALL	WAIT
	SETB	TR0
	DJNZ	R2,F3



	MOV		R2,#03H
F4:
	MOV		P1,#0EDH
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#50
	ACALL	WAIT
	SETB	TR0

	MOV		P1,#0FFH
	CLR		TR0
	MOV		TASK_NUM_LOC,#0FFH
	MOV		WAIT_TIME_LOC,#50
	ACALL	WAIT
	SETB	TR0

	DJNZ	R2,F4

	SJMP	TASK5












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
