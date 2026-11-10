unit Forms;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Menus, SysUtils, Messages;

type
  TPoint = WinTypes.TPoint;
  TRect = WinTypes.TRect;
  TModalResult = Controls.TModalResult;

const
  mrNone     = Controls.mrNone;
  mrOk       = Controls.mrOk;
  mrCancel   = Controls.mrCancel;
  mrAbort    = Controls.mrAbort;
  mrRetry    = Controls.mrRetry;
  mrIgnore   = Controls.mrIgnore;
  mrYes      = Controls.mrYes;
  mrNo       = Controls.mrNo;
  mrAll      = Controls.mrAll;
  mrNoToAll  = Controls.mrNoToAll;
  mrYesToAll = Controls.mrYesToAll;

type
  TWindowState = (wsNormal, wsMinimized, wsMaximized);
  TFormBorderStyle = (bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin);
  TBorderStyle = bsNone..bsSingle;
  TFormPosition = (poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter);

  TWindowPlacement = record
    length: UINT;
    flags: UINT;
    showCmd: UINT;
    ptMinPosition: TPoint;
    ptMaxPosition: TPoint;
    rcNormalPosition: TRect;
  end;
  PWindowPlacement = ^TWindowPlacement;

const
  WPF_SETMINPOSITION = $0001;
  WPF_RESTORETOMAXIMIZED = $0002;

function GetWindowPlacement(hwnd: HWND; lpwndpl: PWindowPlacement): BOOL; far; external 'USER' index 370;
function SetWindowPlacement(hwnd: HWND; lpwndpl: PWindowPlacement): BOOL; far; external 'USER' index 371;

type

  TCloseAction = (caNone, caHide, caFree, caMinimize);
  TCloseEvent = procedure(Sender: TObject; var Action: TCloseAction) of object;

  TDesigner = class(TObject)
  public
    procedure Modified; virtual;
  end;

  TForm = class;
  TFormClass = class of TForm;

  TForm = class(TWinControl)
  private
    FCanvas: TCanvas;
    FIcon: TIcon;
    FDesigner: TDesigner;
    FWindowState: TWindowState;
    FBorderStyle: TFormBorderStyle;
    FPosition: TFormPosition;
    FModalResult: TModalResult;
    FMenu: TMainMenu;
    FActiveControl: TWinControl;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnClose: TCloseEvent;
    FOnPaint: TNotifyEvent;
    procedure SetBorderStyle(Value: TFormBorderStyle);
    procedure SetWindowState(Value: TWindowState);
    procedure SetIcon(Value: TIcon);
    procedure SetMenu(Value: TMainMenu);
    procedure SetActiveControl(Value: TWinControl);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
    procedure DoCreate; virtual;
    procedure DoDestroy; virtual;
    procedure DoShow; virtual;
    procedure DoClose(var Action: TCloseAction); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    constructor CreateNew(AOwner: TComponent); virtual;
    destructor Destroy; override;
    procedure Show;
    procedure Hide;
    function ShowModal: Integer;
    procedure Close;
    procedure Release;
    procedure WndProc(var Message: TMessage); override;
    property ActiveControl: TWinControl read FActiveControl write SetActiveControl;
    property Canvas: TCanvas read FCanvas;
    property Icon: TIcon read FIcon write SetIcon;
    property Menu: TMainMenu read FMenu write SetMenu;
    property BorderStyle: TFormBorderStyle read FBorderStyle write SetBorderStyle;
    property Designer: TDesigner read FDesigner write FDesigner;
    property WindowState: TWindowState read FWindowState write SetWindowState;
    property Position: TFormPosition read FPosition write FPosition;
    property ModalResult: TModalResult read FModalResult write FModalResult;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnClose: TCloseEvent read FOnClose write FOnClose;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TMessageEvent = procedure(var Msg: TMsg; var Handled: Boolean) of object;

  TScreen = class(TObject)
  private
    FCursor: TCursor;
    FCursors: array[-32..32] of HCURSOR;
    FForms: TList;
    FOnActiveControlChange: TNotifyEvent;
    FOnActiveFormChange: TNotifyEvent;
    function GetWidth: Integer;
    function GetHeight: Integer;
    function GetPixelsPerInch: Integer;
    function GetCursor(Index: Integer): HCURSOR;
    procedure SetCursor(Index: Integer; Value: HCURSOR);
    procedure SetCurrentCursor(Value: TCursor);
    function GetActiveForm: TForm;
    function GetFormCount: Integer;
    function GetForm(Index: Integer): TForm;
  public
    constructor Create;
    destructor Destroy; override;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;
    property PixelsPerInch: Integer read GetPixelsPerInch;
    property Cursor: TCursor read FCursor write SetCurrentCursor;
    property Cursors[Index: Integer]: HCURSOR read GetCursor write SetCursor; default;
    property ActiveForm: TForm read GetActiveForm;
    property FormCount: Integer read GetFormCount;
    property Forms[Index: Integer]: TForm read GetForm;
    property OnActiveControlChange: TNotifyEvent read FOnActiveControlChange write FOnActiveControlChange;
    property OnActiveFormChange: TNotifyEvent read FOnActiveFormChange write FOnActiveFormChange;
  end;

  THintInfo = record
    HintControl: TControl;
    HintWindowClass: TClass;
    HintPos: TPoint;
    HintMaxWidth: Integer;
    HintColor: TColor;
    CursorRect: TRect;
    CursorPos: TPoint;
    ReshowTimeout: Integer;
    HideTimeout: Integer;
    HintStr: string;
    HintData: Pointer;
  end;
  PHintInfo = ^THintInfo;

  TExceptionEvent = procedure(Sender: TObject; E: Exception) of object;
  TIdleEvent = procedure(Sender: TObject; var Done: Boolean) of object;
  THelpEvent = function(Command: Word; Data: Longint; var CallHelp: Boolean): Boolean of object;
  TShowHintEvent = procedure(var HintStr: string; var CanShow: Boolean; var HintInfo: THintInfo) of object;
  TWindowHook = function(var Message: TMessage): Boolean of object;

  TApplication = class(TComponent)
  private
    FTitle: string;
    FIcon: TIcon;
    FMainForm: TForm;
    FTerminated: Boolean;
    FHandle: HWND;
    FExeName: string;
    FActive: Boolean;
    FHintPause: Integer;
    FHintColor: TColor;
    FHelpFile: string;
    FHint: string;
    FOnActivate: TNotifyEvent;
    FOnDeactivate: TNotifyEvent;
    FOnException: TExceptionEvent;
    FOnHelp: THelpEvent;
    FOnHint: TNotifyEvent;
    FOnIdle: TIdleEvent;
    FOnMessage: TMessageEvent;
    FOnMinimize: TNotifyEvent;
    FOnRestore: TNotifyEvent;
    FOnShowHint: TShowHintEvent;
    procedure SetTitle(const Value: string);
    procedure SetIcon(Value: TIcon);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure CreateForm(FormClass: TFormClass; var Reference);
    procedure Run;
    procedure ProcessMessages;
    procedure Terminate;
    procedure HandleException(Sender: TObject);
    procedure Minimize;
    procedure Restore;
    function MessageBox(Text, Caption: PChar; Flags: Word): Integer;
    procedure HelpContext(Context: Longint);
    procedure HelpCommand(Command: Word; Data: Longint);
    procedure HelpJump(const Topic: string);
    procedure HookMainWindow(Hook: TWindowHook);
    procedure UnhookMainWindow(Hook: TWindowHook);

    property Title: string read FTitle write SetTitle;
    property Icon: TIcon read FIcon write SetIcon;
    property MainForm: TForm read FMainForm;
    property Terminated: Boolean read FTerminated;
    property Handle: HWND read FHandle;
    property ExeName: string read FExeName;
    property Active: Boolean read FActive write FActive;
    property HintPause: Integer read FHintPause write FHintPause;
    property HintColor: TColor read FHintColor write FHintColor;
    property HelpFile: string read FHelpFile write FHelpFile;
    property Hint: string read FHint write FHint;

    property OnActivate: TNotifyEvent read FOnActivate write FOnActivate;
    property OnDeactivate: TNotifyEvent read FOnDeactivate write FOnDeactivate;
    property OnException: TExceptionEvent read FOnException write FOnException;
    property OnHelp: THelpEvent read FOnHelp write FOnHelp;
    property OnHint: TNotifyEvent read FOnHint write FOnHint;
    property OnIdle: TIdleEvent read FOnIdle write FOnIdle;
    property OnMessage: TMessageEvent read FOnMessage write FOnMessage;
    property OnMinimize: TNotifyEvent read FOnMinimize write FOnMinimize;
    property OnRestore: TNotifyEvent read FOnRestore write FOnRestore;
    property OnShowHint: TShowHintEvent read FOnShowHint write FOnShowHint;
  end;

var
  Application: TApplication;
  Screen: TScreen;

function Point(AX, AY: Integer): TPoint;
function GetParentForm(Control: TControl): TForm;
type
  TWndMethod = procedure(var Message: TMessage) of object;
function AllocateHWnd(Method: TWndMethod): HWND;
procedure DeallocateHWnd(Wnd: HWND);

implementation

const
  FormClassName = 'VCL_Form';

var
  FormClassRegistered: Boolean = False;

type
  PAllocateRec = ^TAllocateRec;
  TAllocateRec = record
    Method: TWndMethod;
  end;

function AllocateWndProc(AHwnd: HWND; Msg: UINT; WParam: WPARAM; LParam: LPARAM): LRESULT; export;
var
  Rec: PAllocateRec;
  M: TMessage;
begin
  Rec := PAllocateRec(GetProp(AHwnd, 'WUIL_AllocWnd'));
  if (Rec <> nil) and Assigned(Rec^.Method) then
  begin
    M.Msg := Msg;
    M.WParam := WParam;
    M.LParam := LParam;
    M.Result := 0;
    Rec^.Method(M);
    Result := M.Result;
  end
  else
    Result := DefWindowProc(AHwnd, Msg, WParam, LParam);
end;

function AllocateHWnd(Method: TWndMethod): HWND;
var
  WndClass: TWndClass;
  Rec: PAllocateRec;
  H: HWND;
begin
  if not WinProcs.GetClassInfo(HInstance, 'WUIL_AllocateHWnd', WndClass) then
  begin
    FillChar(WndClass, SizeOf(WndClass), 0);
    WndClass.lpfnWndProc := @AllocateWndProc;
    WndClass.hInstance := HInstance;
    WndClass.lpszClassName := 'WUIL_AllocateHWnd';
    WinProcs.RegisterClass(WndClass);
  end;
  H := CreateWindow('WUIL_AllocateHWnd', '', WS_POPUP, 0, 0, 0, 0, 0, 0, HInstance, nil);
  if H <> 0 then
  begin
    New(Rec);
    Rec^.Method := Method;
    SetProp(H, 'WUIL_AllocWnd', THandle(Rec));
  end;
  Result := H;
end;

procedure DeallocateHWnd(Wnd: HWND);
var
  Rec: PAllocateRec;
begin
  if (Wnd <> 0) and IsWindow(Wnd) then
  begin
    Rec := PAllocateRec(GetProp(Wnd, 'WUIL_AllocWnd'));
    if Rec <> nil then
    begin
      RemoveProp(Wnd, 'WUIL_AllocWnd');
      Dispose(Rec);
    end;
    DestroyWindow(Wnd);
  end;
end;

procedure RegisterFormClass;
var
  WC: TWndClass;
begin
  if not FormClassRegistered then
  begin
    WC.style := CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS;
    WC.lpfnWndProc := @VclWindowProc;
    WC.cbClsExtra := 0;
    WC.cbWndExtra := 4;
    WC.hInstance := HInstance;
    WC.hIcon := LoadIcon(HInstance, MAKEINTRESOURCE(1));
    if WC.hIcon = 0 then
      WC.hIcon := LoadIcon(0, IDI_APPLICATION);
    WC.hCursor := LoadCursor(0, IDC_ARROW);
    WC.hbrBackground := COLOR_BTNFACE + 1;
    WC.lpszMenuName := nil;
    WC.lpszClassName := FormClassName;
    WinProcs.RegisterClass(WC);
    FormClassRegistered := True;
  end;
end;

{ TForm }

constructor TForm.Create(AOwner: TComponent);
var
  M: TMethod;
begin
  CreateNew(AOwner);
  { Brak strumieniowania DFM: zdarzenia formularza wiazemy po nazwach metod
    publikowanych (konwencja Delphi: FormCreate, FormDestroy, ...). }
  M.Data := Self;
  if not Assigned(FOnCreate) then
  begin
    M.Code := MethodAddress('FormCreate');
    if M.Code <> nil then FOnCreate := TNotifyEvent(M);
  end;
  if not Assigned(FOnDestroy) then
  begin
    M.Code := MethodAddress('FormDestroy');
    if M.Code <> nil then FOnDestroy := TNotifyEvent(M);
  end;
  if not Assigned(FOnShow) then
  begin
    M.Code := MethodAddress('FormShow');
    if M.Code <> nil then FOnShow := TNotifyEvent(M);
  end;
  if not Assigned(FOnClose) then
  begin
    M.Code := MethodAddress('FormClose');
    if M.Code <> nil then FOnClose := TCloseEvent(M);
  end;
  if not Assigned(FOnPaint) then
  begin
    M.Code := MethodAddress('FormPaint');
    if M.Code <> nil then FOnPaint := TNotifyEvent(M);
  end;
  DoCreate;
end;

constructor TForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FIcon := TIcon.Create;
  FDesigner := TDesigner.Create;
  FWindowState := wsNormal;
  FBorderStyle := bsSizeable;
  FPosition := poDesigned;
  FModalResult := mrNone;
  FWidth := 320;
  FHeight := 240;
  FCaption := 'Form';
  if Screen <> nil then
    Screen.FForms.Add(Self);
end;

destructor TForm.Destroy;
begin
  if Screen <> nil then
    Screen.FForms.Remove(Self);
  DoDestroy;
  FDesigner.Free;
  FIcon.Free;
  FCanvas.Free;
  inherited Destroy;
end;

procedure TForm.SetIcon(Value: TIcon);
begin
  FIcon.Assign(Value);
  if HandleAllocated and (FIcon.Handle <> 0) then
    SetClassWord(Handle, GCW_HICON, FIcon.Handle);
end;

procedure TForm.CreateParams(var Params: TCreateParams);
var
  WStyle: LongInt;
begin
  RegisterFormClass;
  inherited CreateParams(Params);

  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, FormClassName);

  WStyle := WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
  case FBorderStyle of
    bsNone:     WStyle := WStyle or WS_POPUP;
    bsSingle:   WStyle := WStyle or (WS_OVERLAPPED or WS_CAPTION or WS_SYSMENU or WS_MINIMIZEBOX);
    bsDialog:   WStyle := WStyle or (WS_POPUP or WS_CAPTION or WS_SYSMENU or DS_MODALFRAME);
    else        WStyle := WStyle or WS_OVERLAPPEDWINDOW;
  end;

  Params.Style := WStyle;
  Params.WndParent := 0;

  if FPosition = poScreenCenter then
  begin
    Params.X := (GetSystemMetrics(SM_CXSCREEN) - FWidth) div 2;
    Params.Y := (GetSystemMetrics(SM_CYSCREEN) - FHeight) div 2;
  end;
end;

procedure TForm.Show;
var
  I: Integer;
begin
  if not HandleAllocated then
    CreateHandle;
  if (FMenu <> nil) and HandleAllocated then
  begin
    WinProcs.SetMenu(FHandle, FMenu.Handle);
    DrawMenuBar(FHandle);
  end;
  for I := 0 to FControls.Count - 1 do
  begin
    if TObject(FControls[I]) is TWinControl then
      TWinControl(FControls[I]).CreateHandle;
  end;
  DoShow;
  ShowWindow(FHandle, SW_SHOWNORMAL);
  UpdateWindow(FHandle);
end;

procedure TForm.Hide;
begin
  if HandleAllocated then
    ShowWindow(FHandle, SW_HIDE);
end;

function TForm.ShowModal: Integer;
var
  Msg: TMsg;
begin
  FModalResult := mrNone;
  Show;
  while (FModalResult = mrNone) and HandleAllocated and not Application.Terminated do
  begin
    if GetMessage(Msg, 0, 0, 0) then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end
    else
    begin
      Application.Terminate;
      Break;
    end;
  end;
  Hide;
  Result := FModalResult;
end;

procedure TForm.Close;
var
  Action: TCloseAction;
begin
  Action := caHide;
  DoClose(Action);
  case Action of
    caHide: Hide;
    caFree: Destroy;
  end;
end;

procedure TForm.Release;
begin
  Free;
end;

procedure TForm.SetActiveControl(Value: TWinControl);
begin
  if FActiveControl <> Value then
  begin
    FActiveControl := Value;
    if (Value <> nil) and Value.CanFocus then
      Value.SetFocus;
  end;
end;

procedure TForm.Paint;
begin
  inherited Paint;
  if Assigned(FOnPaint) then
    FOnPaint(Self);
end;

procedure TForm.WndProc(var Message: TMessage);
var
  DC: HDC;
  PS: TPaintStruct;
begin
  if Message.Msg = WM_PAINT then
  begin
    DC := BeginPaint(FHandle, PS);
    if FCanvas <> nil then
      FCanvas.Handle := DC;
    try
      Paint;
    finally
      if FCanvas <> nil then
        FCanvas.Handle := 0;
      EndPaint(FHandle, PS);
    end;
    Message.Result := 0;
    Exit;
  end;
  inherited WndProc(Message);
end;

procedure TForm.DoCreate;
begin
  if Assigned(FOnCreate) then
    FOnCreate(Self);
end;

procedure TForm.DoDestroy;
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(Self);
end;

procedure TForm.DoShow;
begin
  if Assigned(FOnShow) then
    FOnShow(Self);
end;

procedure TForm.DoClose(var Action: TCloseAction);
begin
  if Assigned(FOnClose) then
    FOnClose(Self, Action);
end;

procedure TForm.SetMenu(Value: TMainMenu);
begin
  if FMenu <> Value then
  begin
    FMenu := Value;
    if HandleAllocated then
    begin
      if FMenu <> nil then
        WinProcs.SetMenu(FHandle, FMenu.Handle)
      else
        WinProcs.SetMenu(FHandle, 0);
      DrawMenuBar(FHandle);
    end;
  end;
end;

procedure TForm.SetBorderStyle(Value: TFormBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    if HandleAllocated then
    begin
      DestroyWindowHandle;
      CreateHandle;
    end;
  end;
end;

procedure TForm.SetWindowState(Value: TWindowState);
begin
  if FWindowState <> Value then
  begin
    FWindowState := Value;
    if HandleAllocated then
    begin
      case FWindowState of
        wsNormal:    ShowWindow(FHandle, SW_RESTORE);
        wsMinimized: ShowWindow(FHandle, SW_MINIMIZE);
        wsMaximized: ShowWindow(FHandle, SW_MAXIMIZE);
      end;
    end;
  end;
end;

{ TApplication }

constructor TApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIcon := TIcon.Create;
  FTitle := 'VCL Application';
  FMainForm := nil;
  FTerminated := False;
  FExeName := ParamStr(0);
  FActive := True;
  FHintPause := 500;
  FHintColor := $80FFFF;
end;

destructor TApplication.Destroy;
begin
  FIcon.Free;
  inherited Destroy;
end;

procedure TApplication.SetIcon(Value: TIcon);
begin
  FIcon.Assign(Value);
  if (FHandle <> 0) and (FIcon.Handle <> 0) then
    SetClassWord(FHandle, GCW_HICON, FIcon.Handle);
end;

procedure TApplication.Initialize;
begin
  { Inicjalizacja zasobów aplikacji }
end;

procedure TApplication.CreateForm(FormClass: TFormClass; var Reference);
var
  Instance: TForm;
begin
  Instance := FormClass.Create(Self);
  TForm(Reference) := Instance;
  if FMainForm = nil then
    FMainForm := Instance;
end;

procedure TApplication.Run;
var
  Msg: TMsg;
  Handled: Boolean;
begin
  if FMainForm <> nil then
  begin
    FMainForm.Show;
    while not FTerminated do
    begin
      if GetMessage(Msg, 0, 0, 0) then
      begin
        Handled := False;
        if Assigned(FOnMessage) then
          FOnMessage(Msg, Handled);
        if not Handled then
        begin
          TranslateMessage(Msg);
          DispatchMessage(Msg);
        end;
      end
      else
        Break;
    end;
  end;
end;

procedure TApplication.ProcessMessages;
var
  Msg: TMsg;
  Handled: Boolean;
begin
  while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
  begin
    if Msg.message = WM_QUIT then
    begin
      FTerminated := True;
      PostQuitMessage(Msg.wParam);
      Break;
    end;
    Handled := False;
    if Assigned(FOnMessage) then
      FOnMessage(Msg, Handled);
    if not Handled then
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
end;

procedure TApplication.Terminate;
begin
  FTerminated := True;
  PostQuitMessage(0);
end;

procedure TApplication.HandleException(Sender: TObject);
begin
  if (Sender <> nil) and (Sender is Exception) then
    ShowException(Exception(Sender), ExceptAddr)
  else
    WinProcs.MessageBox(0, 'Unhandled Exception', 'Error', MB_OK or MB_ICONSTOP);
end;

procedure TApplication.Minimize;
begin
  if FMainForm <> nil then
    ShowWindow(FMainForm.Handle, SW_MINIMIZE);
end;

procedure TApplication.Restore;
begin
  if FMainForm <> nil then
    ShowWindow(FMainForm.Handle, SW_RESTORE);
end;

function TApplication.MessageBox(Text, Caption: PChar; Flags: Word): Integer;
var
  HW: HWND;
begin
  HW := 0;
  if FMainForm <> nil then HW := FMainForm.Handle;
  Result := WinProcs.MessageBox(HW, Text, Caption, Flags);
end;

procedure TApplication.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

procedure TApplication.HelpContext(Context: Longint);
begin
  WinHelp(FHandle, nil, HELP_CONTEXT, Context);
end;

procedure TApplication.HelpCommand(Command: Word; Data: Longint);
begin
  WinHelp(FHandle, nil, Command, Data);
end;

procedure TApplication.HelpJump(const Topic: string);
var
  S: array[0..255] of Char;
begin
  WinHelp(FHandle, nil, HELP_KEY, Longint(StrPCopy(S, Topic)));
end;

procedure TApplication.HookMainWindow(Hook: TWindowHook);
begin
end;

procedure TApplication.UnhookMainWindow(Hook: TWindowHook);
begin
end;

{ TScreen }

constructor TScreen.Create;
begin
  inherited Create;
  FForms := TList.Create;
  FCursor := crDefault;
  FillChar(FCursors, SizeOf(FCursors), 0);
  FCursors[crDefault] := LoadCursor(0, IDC_ARROW);
  FCursors[crArrow] := LoadCursor(0, IDC_ARROW);
  FCursors[crCross] := LoadCursor(0, IDC_CROSS);
  FCursors[crIBeam] := LoadCursor(0, IDC_IBEAM);
  FCursors[crSizeNESW] := LoadCursor(0, IDC_SIZENESW);
  FCursors[crSizeNS] := LoadCursor(0, IDC_SIZENS);
  FCursors[crSizeNWSE] := LoadCursor(0, IDC_SIZENWSE);
  FCursors[crSizeWE] := LoadCursor(0, IDC_SIZEWE);
  FCursors[crUpArrow] := LoadCursor(0, IDC_UPARROW);
  FCursors[crHourGlass] := LoadCursor(0, IDC_WAIT);
end;

destructor TScreen.Destroy;
begin
  FForms.Free;
  inherited Destroy;
end;

function TScreen.GetWidth: Integer;
begin
  Result := GetSystemMetrics(SM_CXSCREEN);
end;

function TScreen.GetHeight: Integer;
begin
  Result := GetSystemMetrics(SM_CYSCREEN);
end;

function TScreen.GetPixelsPerInch: Integer;
var
  DC: HDC;
begin
  DC := GetDC(0);
  Result := GetDeviceCaps(DC, LOGPIXELSY);
  ReleaseDC(0, DC);
  if Result <= 0 then Result := 96;
end;

function TScreen.GetCursor(Index: Integer): HCURSOR;
begin
  if (Index >= -32) and (Index <= 32) then
    Result := FCursors[Index]
  else
    Result := 0;
end;

procedure TScreen.SetCursor(Index: Integer; Value: HCURSOR);
begin
  if (Index >= -32) and (Index <= 32) then
    FCursors[Index] := Value;
end;

procedure TScreen.SetCurrentCursor(Value: TCursor);
begin
  FCursor := Value;
  if (Value >= -32) and (Value <= 32) and (FCursors[Value] <> 0) then
    WinProcs.SetCursor(FCursors[Value]);
end;

function TScreen.GetActiveForm: TForm;
begin
  if FForms.Count > 0 then
    Result := TForm(FForms[0])
  else
    Result := Application.MainForm;
end;

function TScreen.GetFormCount: Integer;
begin
  Result := FForms.Count;
end;

function TScreen.GetForm(Index: Integer): TForm;
begin
  Result := TForm(FForms[Index]);
end;

procedure TDesigner.Modified;
begin
end;

function Point(AX, AY: Integer): TPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

function GetParentForm(Control: TControl): TForm;
begin
  while (Control <> nil) and not (Control is TForm) do
    Control := Control.Parent;
  Result := TForm(Control);
end;

initialization
  Screen := TScreen.Create;
  Application := TApplication.Create(nil);

finalization
  Application.Free;
  Screen.Free;

end.
