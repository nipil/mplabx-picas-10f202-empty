# Empty pic-as project for 10f202

See [this page](https://developerhelp.microchip.com/xwiki/bin/view/software-tools/ides/x/version-control/working-with-version-control/) for `.gitignore` files for MPLAB projects

See [the manual](https://ww1.microchip.com/downloads/en/DeviceDoc/MPLAB%20XC8%20PIC%20Assembler%20User%27s%20Guide%2050002974A.pdf) for instruction for the assembler shipped with XC8.

See [the migration guide](https://onlinedocs.microchip.com/oxy/GUID-6EF91A11-1A5C-4C0A-8A18-67AD6D50B17B-en-US-2/GUID-34FE7635-E398-49D5-B986-393EA335B217.html) for convention change about file extensions

## IMPORTANT

### hex bytes vs word size

From the manual, section "4.9.40.4 Delta Flag"

    The delta psect flag defines the size of the addressable unit.
    In other words, the number of data bytes that are associated with each address.
    With PIC Mid-range and Baseline devices, the program memory space is word addressable
    So, psects in this space must use a delta of 2. That is to say, each address in
    program memory requires 2 bytes of data in the HEX file to define their contents.
    So, addresses in the HEX file will not match addresses in the program memory.

As a consequence for `CODE` sections :

- Each `CODE` "psect" in the assembly source mus have a `delta=2`option
- Addresses in the HEX file are twice the MEMORY address of the target word

If this rule is not respected, the assembled HEX file will contain incomplete instructions !

## Note about MPLAB X "post-install"

I noticed i had to restart MPLAB a few times after installation (so that everything settles ?)

Because at first, compilation failed with `(2043) target device was not recognized` :

    make -f nbproject/Makefile-default.mk SUBPROJECTS= .build-conf
    make  -f nbproject/Makefile-default.mk dist/default/production/empty.X.production.null
    (2043) target device was not recognized
    make[2]: ***[nbproject/Makefile-default.mk:104: build/default/production/main.o] Error 1
    make[1]:*** [nbproject/Makefile-default.mk:85: .build-conf] Error 2
    make: *** [nbproject/Makefile-impl.mk:39: .build-impl] Error 2
    make[2]: Entering directory 'C:/Users/nicol/MPLABXProjects/empty.X'
    "C:\Program Files\Microchip\xc8\v3.10\pic-as\bin\pic-as.exe" -mcpu= -c \
    -o build/default/production/main.o \
    main.asm \
    -misa=std -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
    make[2]: Leaving directory 'C:/Users/nicol/MPLABXProjects/empty.X'

    BUILD FAILED (exit value 2, total time: 108ms)

After an exit/restart of MPLAB X, it just compiled.

According to the `Makefile-*` files, it seems that the "Device Family Pack" package was not loaded at first ?

## Interesting stuff

### Debugging

Go to `Tools/Options/Embedded`

- debug reset `reset vector`
- debug startup `halt at reset vector`

### Chip fuses

Go to `Window/Target Memory View/Configuration bits`

- you can browse the flags
- you can modify and generate code to include in your source

### Registers

Go to `Window/Target Memory View/File registers` for user addressable registers

Go to `Window/Target Memory View/SFR` for chip registers

Go to `Window/Debugging/Watched` and add a watch to `WREG`

## Project Configuration

IMPORTANT: use the "refresh button" or close/reopen the project.

### Compilation output

Go to project properties

- Select `pic-as Global Options`
- Select `Summary output` in "option categories"
- Check `psect`, `class`, `hex`

### Assembler

Go to project properties

- Select `pic-as Assembler`
- Select `Custom options` in "option categories"
- Add options in "custom assembler options" (one per line)
  - `-a` to generate assembly file

### Linker

Go to project properties

- Select `pic-as Linker`
- Select `General` in "option categories"
- Add options in "custom linker options" (one per line)
  - `-pmain=000h` to place the main code at the start of program Memory
  - `-presetVector=1FFh` to place the OSCCAL instruction at reset vector

IMPORTANT: the `-DCODE=2` override does not seem to be taken into account.

## Updating Device Family Pack

Go to `Tools / Packs` menu

- Click `Check for updates`
- Enter your chip number in the text box on the right
- On the left, maybe you have "new" and can `Update`
- if so, please proceed

Then update your project to use the newer DFP

- in the project dashboard, click the "Properties" button
- go to `Conf` section
- select the newer version in the "Packs" section on the right
- re-select "pic-as" as compiler toolchain
- click OK

Note : the DFP installed in system (at software install ?) cannot be uninstalled.

## Preliminary verification

Verification of supported device

    & 'C:\Program Files\Microchip\xc8\v3.10\pic-as\bin\pic-as.exe' -mprint-devices
    ...
    pic10f200
    pic10f202
    pic10f204
    pic10f206
    pic10f220
    pic10f222
    ...

## Project setup in MPLAB X

- install MPLAB X 6.25
  - do not install IPE
  - accept installation of XC8 only
  - use free version

- new project
  - application project
  - baseline 8-bit (PIC10/12/16)
  - device PIC10F202
  - tool: no tool
  - supported debug header: none
  - compiler: pic-as (v3.10)
  - name: empty
  - encoding: UTF-8

- window / projects
  - right-click source files
  - new / assemblyFile.s
  - main.s (at project root)

- see [main.s](main.s) for content

## Compilation

Shift+F11 to clean beforehand

    CLEAN SUCCESSFUL (total time: 4ms)
    make -f nbproject/Makefile-default.mk SUBPROJECTS= .build-conf
    make  -f nbproject/Makefile-default.mk dist/default/production/empty.X.production.hex
    make[2]: Entering directory 'C:/Users/nicol/MPLABXProjects/empty.X'
    "C:\Program Files\Microchip\xc8\v3.10\pic-as\bin\pic-as.exe" -mcpu=PIC10F202 -c \
    -o build/default/production/main.o \
    main.asm \
    -mdfp="C:/Program Files/Microchip/MPLABX/v6.25/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8"  -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -fmax-errors=20 -mwarn=0 -xassembler-with-cpp
    make[2]: Leaving directory 'C:/Users/nicol/MPLABXProjects/empty.X'
    make[2]: Entering directory 'C:/Users/nicol/MPLABXProjects/empty.X'
    "C:\Program Files\Microchip\xc8\v3.10\pic-as\bin\pic-as.exe" -mcpu=PIC10F202 build/default/production/main.o \
    -o dist/default/production/empty.X.production.hex \
    -mdfp="C:/Program Files/Microchip/MPLABX/v6.25/packs/Microchip/PIC10-12Fxxx_DFP/1.7.178/xc8"  -msummary=+mem,-psect,-class,-hex,-file,-sha1,-sha256,-xml,-xmlfull -mcallgraph=std -Wl,-Map=dist/default/production/empty.X.production.map -mno-download-hex
    ::: warning: (528) no start record; entry point defaults to zero

    10F202 Memory Summary:
        Program space        used     1h (     1) of   200h words   (  0.2%)
        Data space           used     0h (     0) of    18h bytes   (  0.0%)
        EEPROM space         None available
        Configuration bits   used     1h (     1) of     1h word    (100.0%)
        ID Location space    used     0h (     0) of     4h bytes   (  0.0%)

    make[2]: Leaving directory 'C:/Users/nicol/MPLABXProjects/empty.X'

    BUILD SUCCESSFUL (total time: 461ms)
    Loading code from C:/Users/nicol/MPLABXProjects/empty.X/dist/default/production/empty.X.production.hex...
    Program loaded with pack,PIC10-12Fxxx_DFP,1.7.178,Microchip
    Loading completed

## Analysis

After compiling, we look at the compilation log, and we see two messages

1. `Non line specific message::: advisory: (2091) fixup overflow messages have been recorded in the list file "build/default/production\main.lst"`

2. `build/default/production/main.o:0:: warning: (528) no start record; entry point defaults to zero`

### analysis for number 1

Go to `build/default/production` and you will find an `*.lst` file for disassembly.

    159                            psect resetVector
    160      3FA                     resetVector:
    161      3FA  C69                 movlw 105 ; if you need to reset/override OSCCAL
    162
    163                            psect main
    164      3FC                     main:
    165      3FC  C51                 movlw 81
    166      3FD  C33                 movlw 51
    167      3FE
                  warning: (2090) fixup overflow storing 0x3FC in 2 bytes
                  BFC                 goto main
    168
    169                            psect config
    170
    171                           ;Config register CONFIG @ 0xFFF
    172                           ; Oscillator
    173                           ; OSC = 0x1, unprogrammed default
    174                           ; Watchdog Timer
    175                           ; WDTE = OFF, WDT disabled
    176                           ; Code Protect
    177                           ; CP = OFF, Code protection off
    178                           ; Master Clear Enable
    179                           ; MCLRE = OFF, GP3/MCLR pin fuction is digital I/O, MCLR internally tied to VDD
    180      FFF                      org 4095
    181      FFF  0FEB                dw 4075

But the HEX in `dist/default/production/*.hex` and it contains, _with misconfigured options_ :

    :0103FA006999
    :0403FC005133FC0B72
    :021FFE00EB0FE7
    :00000001FF

So it would contain

- 1 byte for adress `03FAh` --> but the instruction is 12 bits, and 12 bits does not fit in a byte !
- 2 bytes for `03FCh` --> same, two MOVLW instructions do not fit in 2 bytes, yet the GOTO is "fully" there !
- 2 bytes for `1FFEh` --> ok it can hold the 12-bit config word, but the address is weird (not `3FF`)

The warning in the `.lst` file is clear : the linker does not have enough room to fit the encoded instruction.

What is wrong in our configuration ?

- the `delta` (number of HEX byte per instruction word) of the `psect` was not set properly
- the relocation of the different section has not been done

See `Linker options` to fix both of these.

After correcting the settings according to the above sections, we finally get :

    :06000000510C330C000A54
    :0203FE00690C88
    :021FFE00EB0FE7
    :00000001FF

What do we read from it :

- each instruction is now "complete" with 2 bytes per word (no `0xC..` missing)
- the `delta`setting makes every HEX addresses actually double mcu mem address : hex `03FE` = mem `01FF * 2`
- the config section (_which cannot be relocated !_) and the configuration word is at hex `1FFE` = mem `FFF`

And the `*.lst` files tells us the "correct" story :

    159                            psect resetVector
    160      1FF                     resetVector:
    161      1FF  0C69                movlw 105 ; if you need to reset/override OSCCAL
    162
    163                            psect main
    164      000                     main:
    165      000  0C51                movlw 81
    166      001  0C33                movlw 51
    167      002  0A00                goto main
    168
    169                            psect config
    170
    171                           ;Config register CONFIG @ 0xFFF
    172                           ; Oscillator
    173                           ; OSC = 0x1, unprogrammed default
    174                           ; Watchdog Timer
    175                           ; WDTE = OFF, WDT disabled
    176                           ; Code Protect
    177                           ; CP = OFF, Code protection off
    178                           ; Master Clear Enable
    179                           ; MCLRE = OFF, GP3/MCLR pin fuction is digital I/O, MCLR internally tied to VDD
    180      FFF                      org 4095
    181      FFF  0FEB                dw 4075

### analysis for number 2

To be done...
