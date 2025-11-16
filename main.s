    radix   dec

    processor 10F202

    CONFIG  WDTE = OFF
    CONFIG  CP = OFF
    CONFIG  MCLRE = OFF

    #include "xc.inc"

    PSECT resetVector, global, class=CODE, delta=2
resetVector:
    MOVLW 69h ; if you need to reset/override OSCCAL

    PSECT main, global, class=CODE, delta=2
main:
    MOVLW 51h
    MOVLW 33h
    GOTO main
    END
