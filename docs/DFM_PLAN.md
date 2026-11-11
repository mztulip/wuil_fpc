# Plan: obsluga plikow DFM w WUIL

## Cel
Nasza Calmira II (kompilowana FPC) ma sie uruchomic na win16Loader. Blokuje ja brak
streamingu DFM: komponenty formularzy (TImage, TLabel...) sa nil, bo nikt nie czyta
plikow `.DFM` (35 w `calmira_src/SRC`, wiazane jako RT_RCDATA przez `bindres`).

## Co wiemy (zweryfikowane)
- DFM = binarny strumien `TPF0`: klasa, nazwa, pary (wlasciwosc, typ, wartosc), dzieci.
  Zdarzenia to nazwy metod.
- Calmira: ok. 100 klas komponentow, 186 nazw wlasciwosci (`wuil/examples/dfm_survey.py`).
- `TReader` + RTTI + `RegisterClass` z RTL FPC dzialaja na win16 HUGE pod loaderem
  (`wuil/examples/dfm_reader_test.pas`: ReadComponent czyta `Left`/`Caption` klasy `{$M+}`).
  Wlasny parser jest zbedny.
- Wlasne komponenty Calmiry (`calmira_src/VCL`) maja juz `published`.
- Wczesniejszy OOM z `InitInheritedComponent` wynikal z braku `published` w WUIL.

## Kroki
1. `published` dla wlasciwosci i zdarzen w klasach WUIL: TPersistent/TComponent, TControl,
   TWinControl, TForm, kontrolki StdCtrls/ExtCtrls/Buttons itd. Najpierw najczestsze:
   Left, Top, Width, Height, Caption, Color, Font, Visible, Enabled, OnClick.
2. `RegisterClass` dla wszystkich komponentow WUIL i Calmiry.
3. `TForm.Create` -> `InitInheritedComponent` (zasob RT_RCDATA). Wiazanie zdarzen po nazwie
   (obecne w `Forms.pas`) zostaje jako zapas.
4. Typy wartosci: TFont, TStrings (`Items.Strings`), bloby bitmap (`Glyph.Data`, `Picture.Data`).
5. Weryfikacja formularz po formularzu, zaczynajac od `TShort` (wywala start).

## Ryzyka
- Pamiec: GlobalAlloc 0x2000 padl przy poprzedniej probie; obserwowac zuzycie.
- Wlasciwosci, ktorych WUIL nie ma, przerywaja czytanie calego formularza (TReader: EReadError);
  trzeba dodawac je albo obslugiwac `OnError`.
- Kolejnosc inicjalizacji: FormCreate musi isc po wczytaniu komponentow.

## Do ustalenia
Podzial pracy na etapy (zaplanowany na pozniej).

## Stan na 2026-11-11 (zapis postepu)
Zrobione:
- `published` w TControl/TWinControl (Left/Top/Width/Height/ClientWidth/ClientHeight/Caption/Color/Font/...,
  zdarzenia), TForm (BorderIcons, FormStyle, KeyPreview, Scaled, PixelsPerInch, TextHeight, OnHide,
  OnCloseQuery, ActiveControl...), TFont/TPen/TBrush, TLabel, TEdit, TPopupMenu, THeader, TMenuItem.ShortCutText.
- `RegisterClasses` w initialization jednostek WUIL; `RegisterIntegerConsts` dla TColor i TCursor
  (TColor/TCursor to teraz osobne typy-podzakresy).
- GetChildren/SetParentComponent/GetParentComponent/HasParent dla TControl, TWinControl, TMenu, TMenuItem.
- `Forms.pas`: `LoadFormResources` (FindResource/LoadResource RT_RCDATA + TReader z OnError/OnPropertyNotFound),
  wolane z TForm.Create. W kodzie sa jeszcze logi `OutputDebugString('DFM ...')` do usuniecia po zakonczeniu.
- TBitmap/TIcon/TPicture.Assign(nil) czyszcza (Calmira robi `Glyph := nil`).
- Naprawy RTL (fpc-source, poza gitem): `typinfo.SetOrdProp` (setter 16-bit/8-bit dostaje parametr Word/Byte,
  wczesniej Self byl psuty), `i8086/setjump.inc` (fpc_setjmp = import KERNEL.Catch; poprzednio kazdy `raise`
  konczyl sie #GP). RTL przebudowany: `make OS_TARGET=win16 CPU_TARGET=i8086 PP=.../ppcross8086 OPT="-Cp80486 -Op80486 -Wh -WmHUGE"` w rtl/win16.
- Test: formularze TSplashForm, TComputer, TBin, TProgressBox czytaja sie z DFM.
- Wymagane: --mem 64 w qemu_headless (przy 16 MB brak selektorow/pamieci); po kompilacji uruchomic wuil/bindres.

Otwarte:
- Crash (deterministyczny, zalezny od ukladu pamieci) w TComputer.FormCreate: #GP w
  TBinaryObjectReader.ReadString (0620:2213, AX='st'); w poprzednim buildzie ten krok przechodzil, dalej padal
  TTaskbar/InsertComponent. Podejrzenie: nieinicjalizowane dane / uszkodzenie sterty; zbadac RefreshSys.Click, Icons.Get.
- THeader.Sections.Sections (DefineProperties) pomijane; Glyph.Data/Picture.Data (bitmapy) niezaimplementowane.
- Jednostka Classes przebudowana ze zrodel (classes.inc byl nowszy niz ppu).
