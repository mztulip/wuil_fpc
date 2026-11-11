# Projekt: Kompilacja Calmiry w Open Source (FPC + Biblioteka Komponentów dla i486 Win16)

## Cel projektu
Umożliwienie kompilacji powłoki **Calmira** (oryginalnie napisanej w Borland Delphi 1.0) przy użyciu w pełni otwartoźródłowego łańcucha narzędzi opartego na **Free Pascal Compiler (FPC)** dla 16-bitowego trybu chronionego Windows 3.1x (`win16`), zoptymalizowanego pod kątem procesora **i486** i uruchamianego w środowisku `win16Loader`.

---

## Stan prac (Zrealizowane)

1. **Cross-kompilator FPC (`ppcross8086` v3.3.1):**
   * Zbudowany z gałęzi głównej (`main`) FPC.
   * Host: Linux x86_64, Cel: `i8086-win16`.
2. **Optymalizacja pod procesor i486:**
   * Cała biblioteka uruchomieniowa RTL (`fpc-source/rtl/units/win16`: `System`, `ObjPas`, `Classes`, `SysUtils`, `Math`, itp.) została przebudowana z flagami:
     ```bash
     -Cp80486 -Op80486
     ```
   * Używa natywnych instrukcji 32-bitowych procesora i486 (rejestry `EAX`/`EBX`, instrukcje `MOVZX`, `MOVSX`, `BSWAP`, itp.) w 16-bitowym segmencie chronionym.
3. **Linker i format wyjściowy:**
   * Użycie Open Watcom Linkera (`wlink`).
   * Generowanie w 100% poprawnych 16-bitowych plików **NE (New Executable)**.
4. **Narzędzie kompilacji (`tools/fpc16`):**
   * Gotowy skrypt automatyzujący ścieżki i flagi kompilacji dla i486 Win16:
     ```bash
     tools/fpc16 sciezka/do/programu.pas
     ```
5. **Testy jednostkowe w `win16Loader` (QEMU):**
   * **Test 01 (`test01_hello.pas`):** Proceduralny Win16 z `MessageBox` i logowaniem przez `OutputDebugString`. Zakończony pełnym sukcesem (`DONE`).
   * **Test 02 (`test02_oop.pas`):** Pełny model obiektowy Delphi: klasy (`class`), konstruktory (`Create`), destruktory (`Destroy`), tablica metod wirtualnych (**VMT**), polimorfizm (`virtual`/`override`), słowo `inherited` oraz właściwości (`property`). Zakończony pełnym sukcesem (`DONE`).

---

## Nazwa biblioteki: WUIL (Windows UI Library)

* Projekt biblioteki nosi nazwę **WUIL** (**Windows UI Library** / **Win UI Library**).
* Kod źródłowy znajduje się w katalogu `wuil/` (z symlinkiem `vcl/` dla kompatybilności wstecznej).
* **Złota zasada integracji:** Chociaż cała biblioteka nazywa się **WUIL**, poszczególne pliki modułów zachowują standardowe nazwy Borlanda (`Forms.pas`, `Controls.pas`, `Classes.pas`, `Graphics.pas`, `Menus.pas`, `Dialogs.pas`, `ExtCtrls.pas`, `Buttons.pas`, `StdCtrls.pas`).
* Dzięki temu kod Calmiry i dowolnych programów Delphi 1.0 kompiluje się **bez zmian w sekcjach `uses`**, korzystając bezpośrednio z implementacji WUIL!

---

## Język implementacji biblioteki (Object Pascal vs C)

### Dlaczego bibliotekę piszemy w Object Pascalu, a nie w C?
W kodzie Calmiry każde okno i kontrolka bezpośrednio **dziedziczy** z klas biblioteki:
```pascal
type
  TAboutDialog = class(TForm)
    OKButton: TButton;
    procedure OKButtonClick(Sender: TObject);
    procedure Paint; override;
  end;
```
* Język C nie posiada klas, metod wirtualnych ani zdarzeń (`TNotifyEvent`).
* Kompilator Pascala (FPC) nie potrafi dziedziczyć z kodu napisanego w C/C++ z powodu innego układu pamięci i innych tabel metod wirtualnych (**VMT**).
* Aby Calmira mogła zdefiniować `class(TForm)` i nadpisać metody (`override`), klasa `TForm` musi być fizycznie zadeklarowana w Object Pascalu.

### Jak biblioteka łączy się z Win16 API napisanym w C?
Biblioteka pełni rolę **obiektowego wrappera na Win16 API**:
* Jest napisana w Object Pascalu,
* Ale wewnątrz swoich metod wywołuje bezpośrednio 16-bitowe funkcje C API (`CreateWindow`, `ShowWindow`, `BitBlt`, `GetMessage`), zadeklarowane w modułach `WinProcs` i `WinTypes`.

### Podział ról w architekturze:
1. **`win16Loader` (w C):**
   * Pliki `kernel.c`, `user.c`, `gdi.c` realizują całą warstwę niskopoziomową – obsługę pamięci, sterownik VESA, kolejkę komunikatów i pętle okien.
2. **Nasza biblioteka komponentów (w Object Pascalu):**
   * Opakowuje te funkcje C w klasy obiektowe (`TForm`, `TButton`, `TPanel`).
3. **Calmira (w Object Pascalu):**
   * Tworzy powłokę pulpitu, pasek zadań i menu Start, dziedzicząc z klas naszej biblioteki.

---

## Architektura biblioteki (Moduły krok po kroku)

1. **`Classes.pas`:**
   * `TPersistent` – obsługa przypisywania obiektów (`Assign`).
   * `TComponent` – mechanizm `Owner` i lista komponentów potomnych (`Components[]`, `ComponentCount`).
   * Kolekcje pomocnicze: `TList`, `TStrings`, `TStringList`.
2. **`Controls.pas`:**
   * `TControl` – bazowe właściwości wizualne (`Left`, `Top`, `Width`, `Height`, `Visible`, `Enabled`, `Parent`).
   * `TWinControl` – klasa posiadająca uchwyt okna Windows (`Handle: HWND`) oraz mechanizm przekierowania komunikatów Windows (`WndProc`) do metod obiektowych.
3. **`Forms.pas`:**
   * `TApplication` – globalny obiekt aplikacji (`Application`) zarządzający pętlą komunikatów (`Run`, `ProcessMessage`).
   * `TForm` – bazowa klasa okna formularza.
4. **`Graphics.pas` / `StdCtrls.pas`:**
   * Opakowanie `HDC`, pędzli i piór (`TCanvas`, `TFont`, `TColor`, `TPen`, `TBrush`, `TBitmap`, `TIcon`).
   * Podstawowe kontrolki: `TButton`, `TLabel`, `TPanel`, `TListBox`, `TComboBox`, `TMemo`, `TCheckBox`, `TRadioButton`.
5. **Moduły zaawansowane WUIL:**
   * `Menus.pas` (`TMainMenu`, `TPopupMenu`, `TMenuItem`),
   * `Dialogs.pas` (`ShowMessage`, `MessageDlg`, `TOpenDialog`, `TSaveDialog`),
   * `ExtCtrls.pas` (`TPanel`, `TTimer`, `TImage`, `TBevel`, `TRadioGroup`),
   * `Buttons.pas` (`TSpeedButton`, `TBitBtn`),
   * `IniFiles.pas` (`TIniFile`),
   * `Grids.pas` (`TDrawGrid`, `TStringGrid`),
   * `ShellAPI.pas`, `Ver.pas`, `Outline.pas`, `Tabs.pas`, `TabNotBk.pas`, `Spin.pas`, `DdeMan.pas`.

---

## Postęp kompilacji Calmiry (Stan na 2026-11-05)

Praktycznie wszystkie 80+ modułów Calmiry kompiluje się już w 100% czysto pod FPC i486-win16 bez żadnych modyfikacji źródeł Calmiry!
W module `ALIAS.PAS` kompilator zatrzymuje się na metodach `TStreamer`/`TIcon` (`LoadFromStream`/`SaveToStream`), co stanowi kolejny krok do zakończenia etapu kompilacji i przejścia do linkowania binarki `CALMIRA.EXE`.


---

## Stan na 2026-11-06: CALMIRA.exe skompilowana i zlinkowana

Pełna kompilacja i linkowanie `CALMIRA.DPR` → `CALMIRA.exe` (16-bitowy NE, 21 segmentów, 0 zmian w `calmira_src/`) działa. Poprzedni wpis o `ALIAS.PAS` jest nieaktualny.

### Polecenie budowania (z katalogu głównego projektu)
```bash
./wuil/fpc16 -Mdelphi -CX -XX -Fucalmira_src/SRC -Fucalmira_src/VCL -Fuwuil -Ficalmira_src/SRC -Ficalmira_src/VCL calmira_src/SRC/CALMIRA.DPR
```
Uruchomienie z `calmira_src/SRC` bez tych `-Fu` kończy się błędem `Can't find unit MiscUtil`.

### Kluczowe ustalenia
* **`-WmHUGE` jest wymagane** (dodane do `wuil/fpc16`): w modelu LARGE dane 80+ modułów przekraczają 64 KB DGROUP. W HUGE każdy moduł ma własny segment danych FAR.
* **`-Wh`**: każda procedura w osobnej sekcji; wlink pakuje kod do segmentów ≤56 KB.
* RTL Win16 musi być przebudowany z: `-Cp80486 -Op80486 -Wh -WmHUGE -CX -XX`.
* Poprawki kompilatora (`fpc-source`):
  * `compiler/i8086/n8086ld.pas`: jawne ładowanie segmentu tabel `resourcestring` (`RESSTR_*`) w modelu pamięci HUGE (`-WmHUGE`), gdzie segment danych danego modułu różni się od `DS`.
  * `compiler/link.pas`: `get_wlib_record_size` zwraca `page_size` (a nie `nb_pages`), co naprawia wlib dla dużych bibliotek.
  * `compiler/x86/hlcgx86.pas`: trampolina importu DLL używa far jump (`S_FAR`) dla win16.
  * `rtl/win16/system.pp`: dodane `_FPC_ParamStrA` z 16-bitowym indeksem `ParamStrA(l: Integer): AnsiString`, plus rozszerzenia typów i stałych Win16.

### Następne kroki
1. Uruchomić `CALMIRA.exe` w `win16Loader` (Bochs/QEMU) i sprawdzić start, okno, pętlę komunikatów.
2. Dołączyć zasoby (`.res`, np. `wrc`) do exe.
3. Poprawiać błędy czasu wykonania w WUIL.
