# Notatki — kompilacja Calmira II przez FPC (`i8086-win16`) + WUIL

## Porównanie rozmiarów `CALMIRA.EXE` (Delphi 1.0 vs FPC + WUIL)

Pomiar dla w 100% oryginalnych, niemodyfikowanych źródeł Calmira II (`SRC/CALMIRA.DPR`, kompilacja `-Mdelphi -CX -XX -Cp80486 -Op80486 -Wh -WmHUGE -Sh-`, zasoby dołączone przez `wuil/bindres`):

| Składnik | Oryginał (Delphi 1.0) | Nasz (FPC + WUIL) | Stosunek |
|---|---:|---:|---:|
| **Rozmiar pliku na dysku** | **855 200 B** (835,2 KiB) | **3 232 026 B** (3 156,3 KiB) | 3,78× |
| Segmenty `CODE` | 626 556 B (34 seg.) | 891 688 B (16 seg.) | 1,42× |
| Segmenty `DATA` | 7 049 B (1 seg.) | 201 702 B (5 seg.) | 28,6× |
| Relokacje NE | 13 406 B | 373 808 B | 27,9× |
| Zasoby (`.RES` + `.DFM`) | 202 496 B (216 szt.) | 167 552 B (174 szt.) | 0,83× |
| **Faktyczny rozmiar NE (bez debug)** | **~855 KiB** | **~1 603 KiB** (`1 641 216 B`) | **1,92×** |
| Doklejone dane debugowe (ELF/DWARF) | 0 B | **1 590 810 B** (1 553,5 KiB) | — |

### Wnioski i przyczyny różnic

1. **Dane debugowe ELF/DWARF (~1,55 MiB)**: Prawie połowa pliku wynikowego to doklejony na końcu kontener `\x7fELF` z informacjami debugowymi DWARF (generowany domyślnie przez FPC/`wlink`). Usunięcie symboli (`-Xs` lub `wstrip`) zmniejsza plik z **3,16 MiB do ~1,60 MiB**.
2. **Segmenty `DATA` (201 KiB vs 7 KiB)**: FPC generuje pełne tablice RTTI/VMT/inicjalizacji klas (`RTL` + `Classes` + `WUIL`) oraz osobne segmenty danych dla unitów w modelu `HUGE`.
3. **Relokacje NE (374 KiB vs 13 KiB)**: W modelu `HUGE` niemal każde odwołanie do danych globalnych oraz wywołanie funkcji używa dalekich adresów (`seg:off`), co generuje osobny 8-bajtowy wpis relokacji NE. Delphi 1.0 trzymało dane w jednym `DGROUP` (`DS`), dzięki czemu relokacji było znacznie mniej.
4. **Kod maszynowy (`CODE`)**: Rozmiar kodu (`892 KiB` vs `627 KiB`, ok. **1,42×**) jest bardzo dobry jak na współczesny RTL FPC 3.3.1 i własną implementację WUIL.

## Uruchamianie pod `win16Loader`

W katalogu `win16Loader/`:

```bash
make run-calmira2
```

Kompiluje `../calmira_src/SRC/CALMIRA.exe`, podpina zasoby (`wuil/bindres`), buduje obraz `calmira2.img` (na bazie `calmira.img` z podmienionym `::CALMIRA/CALMIRA.EXE`) i uruchamia QEMU.
