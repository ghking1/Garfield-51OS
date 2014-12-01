
#include "config.inc"
#include "Garfield.inc"

NAME    TASK6

PUBLIC  TASK6

TASK6_  SEGMENT     CODE
RSEG    TASK6_



TASK6:

;********************************************************
;*                                                      *
;*              START YOUR CODE HERE                    *
;*                                                      *
;********************************************************




    MOV     DPTR,#DIG_code
    MOV     R2,#00H
F61:
    MOV     A,R2
    MOVC    A,@A+DPTR
    CPL     A
    MOV     P2,A

    CJNE    R2,#09H,F62
    MOV     R2,#0FFH
F62:
    INC     R2

    CLR     TR0
    MOV     TASK_NUM_LOC,#01H
    ACALL   WAKEUP
    SETB    TR0

    CLR     TR0
    MOV     TASK_NUM_LOC,#0FFH
    MOV     WAIT_TIME_LOC,#100
    ACALL   WAIT
    SETB    TR0

    SJMP    F61



DIG_code:   
    DB      3fH, 06H, 5bH, 4fH, 66H, 6dH, 7dH, 07H, 7fH, 6fH




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

