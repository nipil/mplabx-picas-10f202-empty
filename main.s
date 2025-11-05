    radix   dec

    processor 10F202

    CONFIG  WDTE = OFF
    CONFIG  CP = OFF
    CONFIG  MCLRE = OFF

    #include "xc.inc"

    PSECT resetVector, class=CODE
resetVector:
    MOVLW 00h

    PSECT main, class=CODE
main:
    MOVLW 1
    GOTO main
    END
