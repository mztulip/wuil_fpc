unit Forms;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Strings;

type
  TWindowState = (wsNormal, wsMinimized, wsMaximized);
  TFormBorderStyle = (bsNone, bsSingle, bsSizeable, bsDialog, bsToolWindow, bsSizeToolWin);
  TFormPosition = (poDesigned, poDefault, poDefaultPosOnly, poDefaultSizeOnly, poScreenCenter);

  TCloseAction = (caNone, caHide, caFree, caMinimize);
  TCloseEvent = procedure(Sender: TObject; var Action: TCloseAction) of object;

  TForm = class;
  TFormClass = class of TForm;

  TForm = class(TWinControl)
  private
    FCanvas: TCanvas;
    FWindowState: TWindowState;
    FBorderStyle: TFormBorderStyle;
    FPosition: TFormPosition;
    FModalResult: TModalResult;
    FOnCreate: TNotifyEvent;
    FOnDestroy: TNotifyEvent;
    FOnShow: TNotifyEvent;
    FOnClose: TCloseEvent;
    FOnPaint: TNotifyEvent;
    procedure SetBorderStyle(Value: TFormBorderStyle);
    procedure SetWindowState(Value: TWindowState);
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
    procedure WndProc(var Message: TMessage); override;
    property Canvas: TCanvas read FCanvas;
    property BorderStyle: TFormBorderStyle read FBorderStyle write SetBorderStyle;
    property WindowState: TWindowState read FWindowState write SetWindowState;
    property Position: TFormPosition read FPosition write FPosition;
    property ModalResult: TModalResult read FModalResult write FModalResult;
    property OnCreate: TNotifyEvent read FOnCreate write FOnCreate;
    property OnDestroy: TNotifyEvent read FOnDestroy write FOnDestroy;
    property OnShow: TNotifyEvent read FOnShow write FOnShow;
    property OnClose: TCloseEvent read FOnClose write FOnClose;
    property OnPaint: TNotifyEvent read FOnPaint write FOnPaint;
  end;

  TApplication = class(TComponent)
  private
    FTitle: string;
    FMainForm: TForm;
    FTerminated: Boolean;
    procedure SetTitle(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Initialize;
    procedure CreateForm(FormClass: TFormClass; var Reference);
    procedure Run;
    procedure ProcessMessages;
    procedure Terminate;
    property Title: string read FTitle write SetTitle;
    property MainForm: TForm read FMainForm;
    property Terminated: Boolean read FTerminated;
  end;

var
  Application: TApplication;

implementation

const
  FormClassName = 'VCL_Form';

var
  FormClassRegistered: Boolean = False;

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
begin
  CreateNew(AOwner);
  DoCreate;
end;

constructor TForm.CreateNew(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FWindowState := wsNormal;
  FBorderStyle := bsSizeable;
  FPosition := poDesigned;
  FModalResult := mrNone;
  FWidth := 320;
  FHeight := 240;
  FCaption := 'Form';
end;

destructor TForm.Destroy;
begin
  DoDestroy;
  FCanvas.Free;
  inherited Destroy;
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
  FTitle := 'VCL Application';
  FMainForm := nil;
  FTerminated := False;
end;

destructor TApplication.Destroy;
begin
  inherited Destroy;
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
begin
  if FMainForm <> nil then
  begin
    FMainForm.Show;
    while not FTerminated do
    begin
      if GetMessage(Msg, 0, 0, 0) then
      begin
        TranslateMessage(Msg);
        DispatchMessage(Msg);
      end
      else
        Break;
    end;
  end;
end;

procedure TApplication.ProcessMessages;
var
  Msg: TMsg;
begin
  while PeekMessage(Msg, 0, 0, 0, PM_REMOVE) do
  begin
    if Msg.message = WM_QUIT then
    begin
      FTerminated := True;
      PostQuitMessage(Msg.wParam);
      Break;
    end;
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

procedure TApplication.Terminate;
begin
  FTerminated := True;
  PostQuitMessage(0);
end;

procedure TApplication.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

initialization
  Application := TApplication.Create(nil);

finalization
  Application.Free;

end.
