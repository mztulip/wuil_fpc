# Poprawki RTL FPC (i8086-win16) wymagane przez WUIL / DFM

`fpc-source/` nie jest w gicie (570 MB), dlatego zmienione pliki sa tu.
Skopiuj je do `fpc-source/` (zachowujac sciezki) i przebuduj RTL:

    cp -r wuil/fpc-patches/rtl/* fpc-source/rtl/
    cd fpc-source/rtl/win16
    make OS_TARGET=win16 CPU_TARGET=i8086 PP=$PWD/../../compiler/ppcross8086 \
         OPT="-Cp80486 -Op80486 -Wh -WmHUGE"

Zmiany:
1. `rtl/objpas/typinfo.pp` - `SetOrdProp`: setter z parametrem 8/16-bitowym wolany jako
   `procedure(Byte/Word)`, nie `procedure(LongInt)` (na i8086 psulo `Self`). Diff: `typinfo-setordprop.diff`.
2. `rtl/i8086/setjump.inc` - WIN16: `fpc_SetJmp` jest importem `KERNEL.Catch` zamiast wrappera
   wolajacego Catch z wlasnej (martwej po powrocie) ramki; poprzednio kazdy `raise` konczyl sie #GP.

Uwaga: `rtl/objpas/classes/classes.inc` w drzewie byl nowszy niz classes.ppu - po przebudowie RTL Classes jest odswiezone.
Kompilator: `ppcross8086` z poprawka pstatmnt.pas (patrz pamiec projektu).
