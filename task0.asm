
#include "config.inc"
#include "Garfield.inc"

NAME    TASK0

PUBLIC  TASK0

TASK0_  SEGMENT     CODE
RSEG    TASK0_



TASK0:

;********************************************************
;*                                                      *
;*              START YOUR CODE HERE                    *
;*                                                      *
;********************************************************

















;********************************************************
;*                                                      *
;*              END OF YOUR CODE HERE                   *
;*                                                      *
;********************************************************

    ;close this task
    CLR     TR0
    MOV     TASK_NUM_LOC,#0FFH
    MOV     WAIT_TIME_LOC,#0FFH
    ACALL   WAIT
    SETB    TR0

    END
