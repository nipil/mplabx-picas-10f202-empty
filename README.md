# Empty pic-as project for 10f202

See [this page](https://developerhelp.microchip.com/xwiki/bin/view/software-tools/ides/x/version-control/working-with-version-control/) for `.gitignore` files for MPLAB projects

See [the manual](https://ww1.microchip.com/downloads/en/DeviceDoc/MPLAB%20XC8%20PIC%20Assembler%20User%27s%20Guide%2050002974A.pdf) for instruction for the assembler shipped with XC8.

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
  - new / assemblyFile.asm
  - main.asm (at project root)

- see [main.asm](main.asm) for content

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

After compiling, the hex file is in `dist/default/production/*.hex` and it contains :

    :0203FE00FF0BF3
    :021FFE00EB0FE7
    :00000001FF

So it would contain 2 bytes for adress `03FEh` and 2 bytes for `1FFEh`, but no "goto" code for `0000`, so there is something wrong in our source code.
