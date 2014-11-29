
#include "config.inc"
#include "Garfield.inc"

NAME	TASK3

PUBLIC	TASK3

TASK3_	SEGMENT		CODE
RSEG	TASK3_



TASK3:

;********************************************************
;*														*
;*				START YOUR CODE HERE					*
;*														*
;********************************************************

















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
