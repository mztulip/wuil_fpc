**English** | [Polski](README.pl.md)

# WUIL — Windows UI Library

**WUIL** (**W**indows **U**ser **I**nterface **L**ibrary / **Win**dows **UI** **L**ibrary) is an open-source visual component library for 16-bit Protected Mode Windows 3.1x (`i8086-win16`, optimized for **i486+** CPUs).

It was created to compile classic Borland Delphi 1.0 applications — most notably the full [**Calmira II (`calmira_fpc`)**](https://github.com/mztulip/calmira_fpc) desktop shell — using a 100% open-source toolchain built around a modified [**Free Pascal Compiler (FPC)**](https://github.com/mztulip/FPCSource), the **Open Watcom Linker (`wlink`)**, and the [**win16Loader**](https://github.com/mztulip/win16Loader) runtime, without requiring changes to application source code or `uses` clauses.

---

## What Is WUIL and Why Does It Exist?

Free Pascal supports the `i8086-win16` target (16-bit Protected Mode Windows 3.1) and provides a core RTL (`System`, `SysUtils`, `Classes`, `WinProcs`, `WinTypes`), but **had no GUI component library** (Lazarus / LCL does not support 16-bit Protected Mode).

Delphi 1.0 applications rely on the VCL object model:
```pascal
type
  TMainForm = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  end;
```

**WUIL fills this gap:**
1. **Drop-in unit naming:** Units use the exact Delphi 1.0 names (`Forms.pas`, `Controls.pas`, `Graphics.pas`, `Menus.pas`, `Dialogs.pas`, `StdCtrls.pas`, `ExtCtrls.pas`, etc.), so existing code compiles without modifying `uses` clauses.
2. **Object-oriented Win16 API wrapper:** WUIL classes wrap low-level Win16 C API calls (`CreateWindow`, `ShowWindow`, `BitBlt`, and the `GetMessage`/`DispatchMessage` message loop).
3. **HUGE memory model (`-WmHUGE`):** In 16-bit Protected Mode, the standard `LARGE` model imposes a 64 KB limit on `DGROUP` (all global variables combined). WUIL operates in the `HUGE` model, where each unit gets its own FAR data segment, enabling large multi-unit applications (such as Calmira II with 80+ units).
4. **i486 performance:** Uses 32-bit i486 instructions inside 16-bit Protected Mode segments (`-Cp80486 -Op80486`).

---

## Implemented Units

| Unit | Main Classes & Features |
|---|---|
| **`Forms.pas`** | `TApplication` (global `Application` object, `Run` loop), `TForm` (form windows, `Show`, `ShowModal`, `Close`, `OnCreate`, `OnPaint`, `OnClose`). |
| **`Controls.pas`** | `TControl`, `TWinControl` (`HWND` handles, `WndProc` dispatch), `TGraphicControl`, layout and bounds management. |
| **`Graphics.pas`** | `TCanvas`, `TPen`, `TBrush`, `TFont`, `TColor`, `TBitmap`, `TIcon`, `TPicture`, `HDC` device context handling. |
| **`StdCtrls.pas`** | Standard Windows controls: `TButton`, `TLabel`, `TEdit`, `TMemo`, `TListBox`, `TComboBox`, `TCheckBox`, `TRadioButton`, `TGroupBox`. |
| **`ExtCtrls.pas`** | Extended controls: `TPanel`, `TTimer` (Windows `SetTimer`), `TImage`, `TBevel`, `TRadioGroup`. |
| **`Menus.pas`** | `TMenu`, `TMainMenu`, `TPopupMenu`, `TMenuItem` (shortcuts, `OnClick` events). |
| **`Dialogs.pas`** | Dialog boxes: `ShowMessage`, `MessageDlg`, `TOpenDialog`, `TSaveDialog`, `TColorDialog`, `TFontDialog`. |
| **`Buttons.pas`** | Graphical buttons: `TSpeedButton`, `TBitBtn` (with glyph bitmaps). |
| **`IniFiles.pas`** | `TIniFile` (reading/writing Windows `.ini` files via Win16 API). |
| **`Grids.pas`** | `TDrawGrid`, `TStringGrid`. |
| **`Messages.pas`** | Windows message records and constants (`WM_COMMAND`, `WM_PAINT`, `WM_NOTIFY`, etc.). |
| **`Clipbrd.pas`** | `TClipboard` (Windows system clipboard). |
| **`Outline.pas`** | `TOutline` (tree view control). |
| **`ShellAPI.pas`** | Shell functions: `ShellExecute`, `ExtractIcon`. |
| **`Spin.pas`** | `TSpinEdit`, `TSpinButton`. |
| **`TabNotBk.pas`** & **`Tabs.pas`** | Tabs and multi-page notebooks (`TTabSet`, `TNotebook`). |
| **`ToolHelp.pas`** & **`Ver.pas`** | System inspection (`TOOLHELP.DLL`) and version info (`VER.DLL`). |
| **`DdeMan.pas`** | Dynamic Data Exchange (`DDEML.DLL`). |

---

## Screenshot

The example application (`examples/hello_gui.pas`) compiled with WUIL and running under [**win16Loader**](https://github.com/mztulip/win16Loader) (VESA 640x480 graphics mode):

![WUIL Example App running under win16Loader](docs/screenshot.png)

---

## Usage Example

### Basic Window with Controls (`examples/hello_gui.pas`)

```pascal
program hello_gui;

{$MODE DELPHI}

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, StdCtrls, Dialogs;

type
  TMainForm = class(TForm)
  private
    FLabel: TLabel;
    FEdit: TEdit;
    FButton: TButton;
    procedure ButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
  end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FormCreate(Self);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Caption := 'WUIL - Windows UI Library';
  Left := 50; Top := 50; Width := 320; Height := 180;

  FLabel := TLabel.Create(Self);
  FLabel.Parent := Self;
  FLabel.Left := 20; FLabel.Top := 20;
  FLabel.Caption := 'Welcome to WUIL for Win16!';

  FEdit := TEdit.Create(Self);
  FEdit.Parent := Self;
  FEdit.Left := 20; FEdit.Top := 50; FEdit.Width := 200;
  FEdit.Text := 'Text editor';

  FButton := TButton.Create(Self);
  FButton.Parent := Self;
  FButton.Left := 20; FButton.Top := 90; FButton.Width := 100;
  FButton.Caption := 'Click me';
  FButton.OnClick := ButtonClick;
end;

procedure TMainForm.ButtonClick(Sender: TObject);
begin
  ShowMessage('WUIL is running on 16-bit Windows 3.1x!');
  Close;
end;

var
  MainForm: TMainForm;

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
```

---

## Building

Compiling requires the modified Free Pascal cross-compiler (`ppcross8086`) targeting `i8086-win16` and the Open Watcom Linker (`wlink`).

> [!IMPORTANT]
> **Modified FPC Compiler Required:**
> Upstream (unmodified) Free Pascal **will not compile** WUIL or large Win16 applications. You must use our fork: [**FPCSource (`mztulip/FPCSource`)**](https://github.com/mztulip/FPCSource).
>
> **Key compiler and RTL modifications:**
> 1. **HUGE memory model (`-WmHUGE`) for Win16:** Upstream FPC for `win16` only supports the `LARGE` model with a single 64 KB `DGROUP` data segment. Our fork adds full `HUGE` model support (each unit has its own FAR data segment), allowing large applications like Calmira II (80+ units) to build.
> 2. **Per-procedure code sections (`-Wh`):** Emits each procedure into its own code section so `wlink` can group code into segments within the 64 KB limit (`<= 56 KB`), avoiding code segment overflow.
> 3. **32-bit i486 instructions in 16-bit Protected Mode (`-Cp80486 -Op80486`):** Code generator fixes enabling 32-bit registers (`EAX`, `EBX`, etc.) and instructions (`MOVZX`, `MOVSX`, `BSWAP`).
> 4. **Open Watcom (`wlink`/`wlib`) & Win16 RTL fixes:** Fixed `wlib` page size calculation, far-jump DLL import trampolines, `KERNEL.Catch` exception handling, ordinal API imports, and Delphi 1.0 compatibility.

The repository includes the helper script **`fpc16`**, which sets all required compiler flags:
* `-Twin16` — 16-bit Windows target,
* `-Cp80486 -Op80486` — i486 code generation and optimizations,
* `-WmHUGE` — HUGE memory model (separate FAR data segment per unit),
* `-Wh` — separate code section per routine for `wlink` segment grouping (≤ 56 KB),
* `-CX -XX` — smart linking (dead code and data elimination).

### Building the Example
```bash
./fpc16 -Mdelphi examples/hello_gui.pas
```
This produces a 16-bit **NE (New Executable)** binary **`hello_gui.exe`**, ready to run on Windows 3.1x, Windows 95/98/ME, or [**win16Loader**](https://github.com/mztulip/win16Loader).

### Building Calmira II
From the [`calmira_fpc`](https://github.com/mztulip/calmira_fpc) repository root:
```bash
./wuil/fpc16 -Mdelphi -CX -XX \
    -FuSRC -FuVCL -Fuwuil \
    -FiSRC -FiVCL \
    SRC/CALMIRA.DPR
```

---

## License

WUIL is released under the [MIT License](LICENSE), allowing free use in both open-source (including GPL projects like Calmira II) and commercial applications.
