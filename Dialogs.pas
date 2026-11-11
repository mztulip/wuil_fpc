unit Dialogs;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, SysUtils, Buttons;

const
  { Stałe flag dla OpenFileName }
  OFN_READONLY             = $00000001;
  OFN_OVERWRITEPROMPT      = $00000002;
  OFN_HIDEREADONLY         = $00000004;
  OFN_NOCHANGEDIR          = $00000008;
  OFN_SHOWHELP             = $00000010;
  OFN_NOVALIDATE           = $00000100;
  OFN_ALLOWMULTISELECT     = $00000200;
  OFN_EXTENSIONDIFFERENT   = $00000400;
  OFN_PATHMUSTEXIST        = $00000800;
  OFN_FILEMUSTEXIST        = $00001000;
  OFN_CREATEPROMPT         = $00002000;
  OFN_SHAREAWARE           = $00004000;
  OFN_NOREADONLYRETURN     = $00008000;
  OFN_NOTESTFILECREATE     = $00010000;

type
  TFileExt = SysUtils.TFileExt;
  TMsgDlgType = (mtWarning, mtError, mtInformation, mtConfirmation, mtCustom);
  TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp);
  TMsgDlgButtons = set of TMsgDlgBtn;

const
  mbYesNoCancel = [mbYes, mbNo, mbCancel];
  mbOKCancel = [mbOK, mbCancel];
  mbAbortRetryIgnore = [mbAbort, mbRetry, mbIgnore];

type
  TOpenOption = (ofReadOnly, ofOverwritePrompt, ofHideReadOnly, ofNoChangeDir,
    ofShowHelp, ofNoValidate, ofAllowMultiSelect, ofExtensionDifferent,
    ofPathMustExist, ofFileMustExist, ofCreatePrompt, ofShareAware,
    ofNoReadOnlyReturn, ofNoTestFileCreate);
  TOpenOptions = set of TOpenOption;

  POpenFileName = ^TOpenFileName;
  tagOFN = record
    lStructSize: LongInt;
    hWndOwner: HWND;
    hInstance: THandle;
    lpstrFilter: PChar;
    lpstrCustomFilter: PChar;
    nMaxCustFilter: LongInt;
    nFilterIndex: LongInt;
    lpstrFile: PChar;
    nMaxFile: LongInt;
    lpstrFileTitle: PChar;
    nMaxFileTitle: LongInt;
    lpstrInitialDir: PChar;
    lpstrTitle: PChar;
    Flags: LongInt;
    nFileOffset: Word;
    nFileExtension: Word;
    lpstrDefExt: PChar;
    lCustData: LongInt;
    lpfnHook: Pointer;
    lpTemplateName: PChar;
  end;
  TOpenFileName = tagOFN;

  TCommonDialog = class(TComponent)
  public
    constructor Create(AOwner: TComponent); override;
    function Execute: Boolean; virtual; abstract;
  end;

  TOpenDialog = class(TCommonDialog)
  protected
    FHistoryList: TStrings;
    FFiles: TStrings;
    FFileName: string;
    FFilter: string;
    FInitialDir: string;
    FTitle: string;
    FDefaultExt: string;
    FFilterIndex: Integer;
    FOptions: TOpenOptions;
    procedure SetHistoryList(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
    property Files: TStrings read FFiles;
    property HistoryList: TStrings read FHistoryList write SetHistoryList;
  published
    property FileName: string read FFileName write FFileName;
    property Filter: string read FFilter write FFilter;
    property FilterIndex: Integer read FFilterIndex write FFilterIndex;
    property InitialDir: string read FInitialDir write FInitialDir;
    property Title: string read FTitle write FTitle;
    property DefaultExt: string read FDefaultExt write FDefaultExt;
    property Options: TOpenOptions read FOptions write FOptions;
  end;

  TSaveDialog = class(TOpenDialog)
  public
    function Execute: Boolean; override;
  end;

  tagCHOOSECOLOR = record
    lStructSize: LongInt;
    hWndOwner: HWND;
    hInstance: THandle;
    rgbResult: TColorRef;
    lpCustColors: Pointer;
    Flags: LongInt;
    lCustData: LongInt;
    lpfnHook: Pointer;
    lpTemplateName: PChar;
  end;
  TChooseColor = tagCHOOSECOLOR;

  TColorDialogOption = (cdFullOpen, cdPreventFullOpen, cdShowHelp);
  TColorDialogOptions = set of TColorDialogOption;

  TColorDialog = class(TCommonDialog)
  private
    FColor: TColor;
    FCustomColors: TStrings;
    FOptions: TColorDialogOptions;
    FCustColorsArray: array[0..15] of LongInt;
    procedure SetCustomColors(Value: TStrings);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  published
    property Color: TColor read FColor write FColor default clBlack;
    property CustomColors: TStrings read FCustomColors write SetCustomColors;
    property Options: TColorDialogOptions read FOptions write FOptions default [];
  end;

  tagCHOOSEFONT = record
    lStructSize: LongInt;
    hWndOwner: HWND;
    hDC: HDC;
    lpLogFont: Pointer;
    iPointSize: SmallInt;
    Flags: LongInt;
    rgbColors: TColorRef;
    lCustData: LongInt;
    lpfnHook: Pointer;
    lpTemplateName: PChar;
    hInstance: THandle;
    lpszStyle: PChar;
    nFontType: Word;
    wReserved: Word;
    nSizeMin: SmallInt;
    nSizeMax: SmallInt;
  end;
  TChooseFont = tagCHOOSEFONT;

  TFontDialogOption = (fdAnsiOnly, fdTrueTypeOnly, fdEffects, fdFixedPitchOnly,
    fdForceFontExist, fdNoFaceSel, fdNoOEMFonts, fdNoSimulations,
    fdNoSizeSel, fdNoStyleSel, fdScalableOnly, fdShowHelp, fdWysiwyg,
    fdLimitSize);
  TFontDialogOptions = set of TFontDialogOption;
  TFontDialogDevice = (fdScreen, fdPrinter, fdBoth);

  TFontDialog = class(TCommonDialog)
  private
    FFont: TFont;
    FDevice: TFontDialogDevice;
    FOptions: TFontDialogOptions;
    FMinFontSize: Integer;
    FMaxFontSize: Integer;
    procedure SetFont(Value: TFont);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Execute: Boolean; override;
  published
    property Font: TFont read FFont write SetFont;
    property Device: TFontDialogDevice read FDevice write FDevice default fdScreen;
    property MinFontSize: Integer read FMinFontSize write FMinFontSize default 0;
    property MaxFontSize: Integer read FMaxFontSize write FMaxFontSize default 0;
    property Options: TFontDialogOptions read FOptions write FOptions default [fdEffects];
  end;

const
  CC_RGBINIT = $00000001;
  CC_FULLOPEN = $00000002;
  CC_PREVENTFULLOPEN = $00000004;
  CC_SHOWHELP = $00000008;

  CF_SCREENFONTS = $00000001;
  CF_PRINTERFONTS = $00000002;
  CF_BOTH = $00000003;
  CF_SHOWHELP = $00000004;
  CF_ENABLEHOOK = $00000008;
  CF_ENABLETEMPLATE = $00000010;
  CF_ENABLETEMPLATEHANDLE = $00000020;
  CF_INITTOLOGFONTSTRUCT = $00000040;
  CF_USESTYLE = $00000080;
  CF_EFFECTS = $00000100;
  CF_APPLY = $00000200;
  CF_ANSIONLY = $00000400;
  CF_NOVECTORFONTS = $00000800;
  CF_NOOEMFONTS = $00000800;
  CF_NOSIMULATIONS = $00001000;
  CF_LIMITSIZE = $00002000;
  CF_FIXEDPITCHONLY = $00004000;
  CF_WYSIWYG = $00008000;
  CF_FORCEFONTEXIST = $00010000;
  CF_SCALABLEONLY = $00020000;
  CF_TTONLY = $00040000;
  CF_NOFACESEL = $00080000;
  CF_NOSTYLESEL = $00100000;
  CF_NOSIZESEL = $00200000;

var
  MsgDlgMinWidth: Integer = 0;
  MsgDlgMinHeight: Integer = 0;
  MsgDlgButtonStyle: TButtonStyle = bsAutoDetect;
  MsgDlgGlyphs: Boolean = False;
  MsgDlgBtnSize: TPoint = (X: 75; Y: 23);

function GetOpenFileName(var OpenFile: TOpenFileName): Bool; far; external 'COMMDLG' index 1;
function GetSaveFileName(var OpenFile: TOpenFileName): Bool; far; external 'COMMDLG' index 2;
function ChooseColor(var CC: TChooseColor): Bool; far; external 'COMMDLG' index 5;
function ChooseFont(var CF: TChooseFont): Bool; far; external 'COMMDLG' index 6;

procedure ShowMessage(const Msg: string);
procedure ShowMessageFmt(const Msg: string; const Params: array of const);
function MessageDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
function MessageDlgPos(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Word;
function InputBox(const ACaption, APrompt, ADefault: string): string;
function InputQuery(const ACaption, APrompt: string; var Value: OpenString): Boolean;

implementation

uses
  StdCtrls;

procedure ShowMessage(const Msg: string);
var
  AppTitle: string;
begin
  if Application <> nil then
    AppTitle := Application.Title
  else
    AppTitle := 'Information';
  MessageBox(GetActiveWindow, PChar(Msg), PChar(AppTitle), MB_OK or MB_ICONINFORMATION);
end;

procedure ShowMessageFmt(const Msg: string; const Params: array of const);
begin
  ShowMessage(Format(Msg, Params));
end;

function MessageDlg(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint): Word;
begin
  Result := MessageDlgPos(Msg, DlgType, Buttons, HelpCtx, -1, -1);
end;

function MessageDlgPos(const Msg: string; DlgType: TMsgDlgType;
  Buttons: TMsgDlgButtons; HelpCtx: Longint; X, Y: Integer): Word;
var
  Flags: Word;
  AppTitle: string;
  Res: Integer;
begin
  Flags := 0;
  case DlgType of
    mtWarning:      Flags := Flags or MB_ICONEXCLAMATION;
    mtError:        Flags := Flags or MB_ICONSTOP;
    mtInformation:  Flags := Flags or MB_ICONINFORMATION;
    mtConfirmation: Flags := Flags or MB_ICONQUESTION;
  end;

  if mbAbortRetryIgnore <= Buttons then
    Flags := Flags or MB_ABORTRETRYIGNORE
  else if mbYesNoCancel <= Buttons then
    Flags := Flags or MB_YESNOCANCEL
  else if [mbYes, mbNo] <= Buttons then
    Flags := Flags or MB_YESNO
  else if mbOKCancel <= Buttons then
    Flags := Flags or MB_OKCANCEL
  else if [mbRetry, mbCancel] <= Buttons then
    Flags := Flags or MB_RETRYCANCEL
  else
    Flags := Flags or MB_OK;

  if Application <> nil then
    AppTitle := Application.Title
  else
    AppTitle := '';

  Res := MessageBox(GetActiveWindow, PChar(Msg), PChar(AppTitle), Flags);
  case Res of
    IDOK:     Result := mrOk;
    IDCANCEL: Result := mrCancel;
    IDABORT:  Result := mrAbort;
    IDRETRY:  Result := mrRetry;
    IDIGNORE: Result := mrIgnore;
    IDYES:    Result := mrYes;
    IDNO:     Result := mrNo;
    else      Result := mrNone;
  end;
end;

{ TCommonDialog }

constructor TCommonDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

{ TOpenDialog }

constructor TOpenDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FHistoryList := TStringList.Create;
  FFiles := TStringList.Create;
  FFileName := '';
  FFilter := 'All Files (*.*)|*.*';
  FInitialDir := '';
  FTitle := '';
  FDefaultExt := '';
  FFilterIndex := 1;
  FOptions := [ofHideReadOnly, ofFileMustExist];
end;

destructor TOpenDialog.Destroy;
begin
  FHistoryList.Free;
  FFiles.Free;
  inherited Destroy;
end;

procedure TOpenDialog.SetHistoryList(Value: TStrings);
begin
  FHistoryList.Assign(Value);
end;

function MakeFilterString(const S: string): string;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(Result) do
  begin
    if Result[I] = '|' then
      Result[I] := #0;
  end;
  Result := Result + #0#0;
end;

function TOpenDialog.Execute: Boolean;
var
  OFN: TOpenFileName;
  FileBuf: array[0..255] of Char;
  FilterBuf: string;
  OwnerWnd: HWND;
  FlagsWord: LongInt;
begin
  FillChar(OFN, SizeOf(OFN), 0);
  OFN.lStructSize := SizeOf(OFN);

  OwnerWnd := 0;
  if Owner is TWinControl then
    OwnerWnd := TWinControl(Owner).Handle
  else
    OwnerWnd := GetActiveWindow;

  OFN.hWndOwner := OwnerWnd;
  OFN.hInstance := HInstance;

  FilterBuf := MakeFilterString(FFilter);
  OFN.lpstrFilter := @FilterBuf[1];
  OFN.nFilterIndex := FFilterIndex;

  FillChar(FileBuf, SizeOf(FileBuf), 0);
  if Length(FFileName) > 0 then
    StrLCopy(FileBuf, PChar(FFileName), SizeOf(FileBuf) - 1);
  OFN.lpstrFile := FileBuf;
  OFN.nMaxFile := SizeOf(FileBuf);

  if Length(FInitialDir) > 0 then
    OFN.lpstrInitialDir := PChar(FInitialDir);
  if Length(FTitle) > 0 then
    OFN.lpstrTitle := PChar(FTitle);
  if Length(FDefaultExt) > 0 then
    OFN.lpstrDefExt := PChar(FDefaultExt);

  FlagsWord := 0;
  if ofReadOnly in FOptions then FlagsWord := FlagsWord or OFN_READONLY;
  if ofOverwritePrompt in FOptions then FlagsWord := FlagsWord or OFN_OVERWRITEPROMPT;
  if ofHideReadOnly in FOptions then FlagsWord := FlagsWord or OFN_HIDEREADONLY;
  if ofNoChangeDir in FOptions then FlagsWord := FlagsWord or OFN_NOCHANGEDIR;
  if ofShowHelp in FOptions then FlagsWord := FlagsWord or OFN_SHOWHELP;
  if ofNoValidate in FOptions then FlagsWord := FlagsWord or OFN_NOVALIDATE;
  if ofAllowMultiSelect in FOptions then FlagsWord := FlagsWord or OFN_ALLOWMULTISELECT;
  if ofExtensionDifferent in FOptions then FlagsWord := FlagsWord or OFN_EXTENSIONDIFFERENT;
  if ofPathMustExist in FOptions then FlagsWord := FlagsWord or OFN_PATHMUSTEXIST;
  if ofFileMustExist in FOptions then FlagsWord := FlagsWord or OFN_FILEMUSTEXIST;
  if ofCreatePrompt in FOptions then FlagsWord := FlagsWord or OFN_CREATEPROMPT;
  if ofShareAware in FOptions then FlagsWord := FlagsWord or OFN_SHAREAWARE;
  if ofNoReadOnlyReturn in FOptions then FlagsWord := FlagsWord or OFN_NOREADONLYRETURN;
  if ofNoTestFileCreate in FOptions then FlagsWord := FlagsWord or OFN_NOTESTFILECREATE;
  OFN.Flags := FlagsWord;

  Result := GetOpenFileName(OFN);
  if Result then
  begin
    FFileName := StrPas(FileBuf);
    FFiles.Clear;
    FFiles.Add(FFileName);
    FFilterIndex := OFN.nFilterIndex;
  end;
end;

{ TSaveDialog }

function TSaveDialog.Execute: Boolean;
var
  OFN: TOpenFileName;
  FileBuf: array[0..255] of Char;
  FilterBuf: string;
  OwnerWnd: HWND;
  FlagsWord: LongInt;
begin
  FillChar(OFN, SizeOf(OFN), 0);
  OFN.lStructSize := SizeOf(OFN);

  OwnerWnd := 0;
  if Owner is TWinControl then
    OwnerWnd := TWinControl(Owner).Handle
  else
    OwnerWnd := GetActiveWindow;

  OFN.hWndOwner := OwnerWnd;
  OFN.hInstance := HInstance;

  FilterBuf := MakeFilterString(FFilter);
  OFN.lpstrFilter := @FilterBuf[1];
  OFN.nFilterIndex := FFilterIndex;

  FillChar(FileBuf, SizeOf(FileBuf), 0);
  if Length(FFileName) > 0 then
    StrLCopy(FileBuf, PChar(FFileName), SizeOf(FileBuf) - 1);
  OFN.lpstrFile := FileBuf;
  OFN.nMaxFile := SizeOf(FileBuf);

  if Length(FInitialDir) > 0 then
    OFN.lpstrInitialDir := PChar(FInitialDir);
  if Length(FTitle) > 0 then
    OFN.lpstrTitle := PChar(FTitle);
  if Length(FDefaultExt) > 0 then
    OFN.lpstrDefExt := PChar(FDefaultExt);

  FlagsWord := 0;
  if ofReadOnly in FOptions then FlagsWord := FlagsWord or OFN_READONLY;
  if ofOverwritePrompt in FOptions then FlagsWord := FlagsWord or OFN_OVERWRITEPROMPT;
  if ofHideReadOnly in FOptions then FlagsWord := FlagsWord or OFN_HIDEREADONLY;
  if ofNoChangeDir in FOptions then FlagsWord := FlagsWord or OFN_NOCHANGEDIR;
  if ofShowHelp in FOptions then FlagsWord := FlagsWord or OFN_SHOWHELP;
  if ofNoValidate in FOptions then FlagsWord := FlagsWord or OFN_NOVALIDATE;
  if ofAllowMultiSelect in FOptions then FlagsWord := FlagsWord or OFN_ALLOWMULTISELECT;
  if ofExtensionDifferent in FOptions then FlagsWord := FlagsWord or OFN_EXTENSIONDIFFERENT;
  if ofPathMustExist in FOptions then FlagsWord := FlagsWord or OFN_PATHMUSTEXIST;
  if ofFileMustExist in FOptions then FlagsWord := FlagsWord or OFN_FILEMUSTEXIST;
  if ofCreatePrompt in FOptions then FlagsWord := FlagsWord or OFN_CREATEPROMPT;
  if ofShareAware in FOptions then FlagsWord := FlagsWord or OFN_SHAREAWARE;
  if ofNoReadOnlyReturn in FOptions then FlagsWord := FlagsWord or OFN_NOREADONLYRETURN;
  if ofNoTestFileCreate in FOptions then FlagsWord := FlagsWord or OFN_NOTESTFILECREATE;
  OFN.Flags := FlagsWord;

  Result := GetSaveFileName(OFN);
  if Result then
  begin
    FFileName := StrPas(FileBuf);
    FFiles.Clear;
    FFiles.Add(FFileName);
    FFilterIndex := OFN.nFilterIndex;
  end;
end;

{ TColorDialog }

constructor TColorDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColor := clBlack;
  FCustomColors := TStringList.Create;
  FOptions := [];
  FillChar(FCustColorsArray, SizeOf(FCustColorsArray), $FF);
end;

destructor TColorDialog.Destroy;
begin
  FCustomColors.Free;
  inherited Destroy;
end;

procedure TColorDialog.SetCustomColors(Value: TStrings);
begin
  FCustomColors.Assign(Value);
end;

function TColorDialog.Execute: Boolean;
var
  CC: TChooseColor;
begin
  FillChar(CC, SizeOf(CC), 0);
  CC.lStructSize := SizeOf(CC);
  if Owner is TWinControl then
    CC.hWndOwner := TWinControl(Owner).Handle
  else
    CC.hWndOwner := GetActiveWindow;
  CC.hInstance := HInstance;
  CC.rgbResult := ColorToRGB(FColor);
  CC.lpCustColors := @FCustColorsArray[0];
  CC.Flags := CC_RGBINIT;
  if cdFullOpen in FOptions then CC.Flags := CC.Flags or CC_FULLOPEN;
  if cdPreventFullOpen in FOptions then CC.Flags := CC.Flags or CC_PREVENTFULLOPEN;
  if cdShowHelp in FOptions then CC.Flags := CC.Flags or CC_SHOWHELP;
  Result := ChooseColor(CC);
  if Result then
    FColor := CC.rgbResult;
end;

{ TFontDialog }

constructor TFontDialog.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFont := TFont.Create;
  FDevice := fdScreen;
  FOptions := [fdEffects];
  FMinFontSize := 0;
  FMaxFontSize := 0;
end;

destructor TFontDialog.Destroy;
begin
  FFont.Free;
  inherited Destroy;
end;

procedure TFontDialog.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

function TFontDialog.Execute: Boolean;
var
  CF: TChooseFont;
  LF: TLogFont;
begin
  FillChar(CF, SizeOf(CF), 0);
  CF.lStructSize := SizeOf(CF);
  if Owner is TWinControl then
    CF.hWndOwner := TWinControl(Owner).Handle
  else
    CF.hWndOwner := GetActiveWindow;
  CF.hInstance := HInstance;
  FillChar(LF, SizeOf(LF), 0);
  if FFont.Handle <> 0 then
    GetObject(FFont.Handle, SizeOf(LF), @LF);
  CF.lpLogFont := @LF;
  CF.Flags := CF_INITTOLOGFONTSTRUCT;
  case FDevice of
    fdScreen: CF.Flags := CF.Flags or CF_SCREENFONTS;
    fdPrinter: CF.Flags := CF.Flags or CF_PRINTERFONTS;
    fdBoth: CF.Flags := CF.Flags or CF_BOTH;
  end;
  if fdEffects in FOptions then CF.Flags := CF.Flags or CF_EFFECTS;
  if fdAnsiOnly in FOptions then CF.Flags := CF.Flags or CF_ANSIONLY;
  if fdTrueTypeOnly in FOptions then CF.Flags := CF.Flags or CF_TTONLY;
  if fdFixedPitchOnly in FOptions then CF.Flags := CF.Flags or CF_FIXEDPITCHONLY;
  if fdForceFontExist in FOptions then CF.Flags := CF.Flags or CF_FORCEFONTEXIST;
  if fdNoFaceSel in FOptions then CF.Flags := CF.Flags or CF_NOFACESEL;
  if fdNoOEMFonts in FOptions then CF.Flags := CF.Flags or CF_NOOEMFONTS;
  if fdNoSimulations in FOptions then CF.Flags := CF.Flags or CF_NOSIMULATIONS;
  if fdNoSizeSel in FOptions then CF.Flags := CF.Flags or CF_NOSIZESEL;
  if fdNoStyleSel in FOptions then CF.Flags := CF.Flags or CF_NOSTYLESEL;
  if fdScalableOnly in FOptions then CF.Flags := CF.Flags or CF_SCALABLEONLY;
  if fdShowHelp in FOptions then CF.Flags := CF.Flags or CF_SHOWHELP;
  if fdWysiwyg in FOptions then CF.Flags := CF.Flags or CF_WYSIWYG;
  if fdLimitSize in FOptions then
  begin
    CF.Flags := CF.Flags or CF_LIMITSIZE;
    CF.nSizeMin := FMinFontSize;
    CF.nSizeMax := FMaxFontSize;
  end;
  Result := ChooseFont(CF);
  if Result then
  begin
    FFont.Name := StrPas(LF.lfFaceName);
    FFont.Height := LF.lfHeight;
    FFont.Color := CF.rgbColors;
  end;
end;

function InputQuery(const ACaption, APrompt: string; var Value: OpenString): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  BtnOK, BtnCancel: TButton;
begin
  Form := TForm.CreateNew(Application);
  try
    Form.Caption := ACaption;
    Form.ClientWidth := 300;
    Form.ClientHeight := 105;
    Form.Position := poScreenCenter;
    Form.BorderStyle := bsDialog;

    Prompt := TLabel.Create(Form);
    Prompt.Parent := Form;
    Prompt.Caption := APrompt;
    Prompt.SetBounds(10, 10, 280, 16);

    Edit := TEdit.Create(Form);
    Edit.Parent := Form;
    Edit.Text := Value;
    Edit.SetBounds(10, 30, 280, 22);

    BtnOK := TButton.Create(Form);
    BtnOK.Parent := Form;
    BtnOK.Caption := 'OK';
    BtnOK.ModalResult := mrOk;
    BtnOK.Default := True;
    BtnOK.SetBounds(130, 65, 75, 23);

    BtnCancel := TButton.Create(Form);
    BtnCancel.Parent := Form;
    BtnCancel.Caption := 'Cancel';
    BtnCancel.ModalResult := mrCancel;
    BtnCancel.Cancel := True;
    BtnCancel.SetBounds(215, 65, 75, 23);

    Result := Form.ShowModal = mrOk;
    if Result then
      Value := Edit.Text;
  finally
    Form.Free;
  end;
end;

function InputBox(const ACaption, APrompt, ADefault: string): string;
var
  S: ShortString;
begin
  S := ADefault;
  InputQuery(ACaption, APrompt, S);
  Result := S;
end;

initialization
  RegisterClasses([TOpenDialog, TSaveDialog, TColorDialog, TFontDialog]);

end.
