unit Controls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, SysUtils, Menus;

type
  TModalResult = Integer;

const
  mrNone     = 0;
  mrOk       = 1;
  mrCancel   = 2;
  mrAbort    = 3;
  mrRetry    = 4;
  mrIgnore   = 5;
  mrYes      = 6;
  mrNo       = 7;
  mrAll      = 8;
  mrNoToAll  = 9;
  mrYesToAll = 10;

type
  TCaption = string;
  TCursor = Integer;
  TMouseButton = (mbLeft, mbRight, mbMiddle);
  TShiftStateEnum = (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble);
  TShiftState = set of TShiftStateEnum;

  TNotifyEvent = procedure(Sender: TObject) of object;
  TMouseEvent = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TMouseMoveEvent = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TKeyEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;
  TKeyPressEvent = procedure(Sender: TObject; var Key: Char) of object;
  TDragMode = (dmManual, dmAutomatic);
  TDragState = (dsDragEnter, dsDragLeave, dsDragMove);
  TDragOverEvent = procedure(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean) of object;
  TDragDropEvent = procedure(Sender, Source: TObject; X, Y: Integer) of object;
  TEndDragEvent = procedure(Sender, Target: TObject; X, Y: Integer) of object;
  TTabOrder = Integer;
  TAlign = (alNone, alTop, alBottom, alLeft, alRight, alClient);

  TMessage = record
    Msg: Word;
    WParam: Word;
    LParam: LongInt;
    Result: LongInt;
  end;

  TCreateParams = record
    Caption: PChar;
    Style: LongInt;
    ExStyle: LongInt;
    X, Y: Integer;
    Width, Height: Integer;
    WndParent: HWND;
    Param: Pointer;
    WindowClass: TWndClass;
    WinClassName: array[0..63] of Char;
  end;

  TWinControl = class;

  TControl = class(TComponent)
  protected
    FParent: TWinControl;
    FAlign: TAlign;
    FLeft, FTop, FWidth, FHeight: Integer;
    FVisible: Boolean;
    FEnabled: Boolean;
    FCaption: string;
    FColor: TColor;
    FFont: TFont;
    FCursor: TCursor;
    FPopupMenu: TPopupMenu;
    FOnClick: TNotifyEvent;
    FOnDblClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnKeyDown: TKeyEvent;
    FOnKeyUp: TKeyEvent;
    FOnKeyPress: TKeyPressEvent;
    FCtl3D: Boolean;
    FParentCtl3D: Boolean;
    FParentColor: Boolean;
    FParentFont: Boolean;
    FParentShowHint: Boolean;
    FShowHint: Boolean;
    FDragCursor: TCursor;
    FDragMode: TDragMode;
    FOnDragDrop: TDragDropEvent;
    FOnDragOver: TDragOverEvent;
    FOnEndDrag: TEndDragEvent;
    procedure SetAlign(Value: TAlign);
    procedure SetLeft(Value: Integer);
    procedure SetTop(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetParent(AParent: TWinControl); virtual;
    function GetBoundsRect: TRect;
    procedure SetBoundsRect(const Value: TRect);
    function GetClientRect: TRect; virtual;
    function GetClientOrigin: TPoint; virtual;
    procedure Click; virtual;
    procedure Paint; virtual;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); virtual;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); virtual;
    procedure KeyUp(var Key: Word; Shift: TShiftState); virtual;
    procedure KeyPress(var Key: Char); virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); virtual;
    procedure Invalidate; virtual;
    procedure Repaint; virtual;
    procedure Update; virtual;
    procedure Show;
    procedure Hide;
    procedure BringToFront;
    procedure SendToBack;
    property Align: TAlign read FAlign write SetAlign default alNone;
    property BoundsRect: TRect read GetBoundsRect write SetBoundsRect;
    property ClientRect: TRect read GetClientRect;
    property ClientOrigin: TPoint read GetClientOrigin;
    property Parent: TWinControl read FParent write SetParent;
    property Left: Integer read FLeft write SetLeft;
    property Top: Integer read FTop write SetTop;
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property Visible: Boolean read FVisible write SetVisible;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write FColor;
    property Font: TFont read FFont;
    property Cursor: TCursor read FCursor write FCursor;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnKeyDown: TKeyEvent read FOnKeyDown write FOnKeyDown;
    property OnKeyUp: TKeyEvent read FOnKeyUp write FOnKeyUp;
    property OnKeyPress: TKeyPressEvent read FOnKeyPress write FOnKeyPress;
    property Ctl3D: Boolean read FCtl3D write FCtl3D default True;
    property ParentCtl3D: Boolean read FParentCtl3D write FParentCtl3D default True;
    property ParentColor: Boolean read FParentColor write FParentColor default True;
    property ParentFont: Boolean read FParentFont write FParentFont default True;
    property ParentShowHint: Boolean read FParentShowHint write FParentShowHint default True;
    property ShowHint: Boolean read FShowHint write FShowHint default False;
    property DragCursor: TCursor read FDragCursor write FDragCursor default 0;
    property DragMode: TDragMode read FDragMode write FDragMode default dmManual;
    property OnDragDrop: TDragDropEvent read FOnDragDrop write FOnDragDrop;
    property OnDragOver: TDragOverEvent read FOnDragOver write FOnDragOver;
    property OnEndDrag: TEndDragEvent read FOnEndDrag write FOnEndDrag;
  end;

  TGraphicControl = class(TControl)
  private
    FCanvas: TCanvas;
  protected
    procedure Paint; override;
    property Canvas: TCanvas read FCanvas;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TWinControl = class(TControl)
  protected
    FHandle: HWND;
    FControls: TList;
    FDefWndProc: Pointer;
    FTabOrder: TTabOrder;
    FTabStop: Boolean;
    FOnEnter: TNotifyEvent;
    FOnExit: TNotifyEvent;
    function GetControl(Index: Integer): TControl;
    function GetControlCount: Integer;
    procedure CreateParams(var Params: TCreateParams); virtual;
    procedure CreateWindowHandle(const Params: TCreateParams); virtual;
    procedure DestroyWindowHandle; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateHandle; virtual;
    procedure DestroyHandle; virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetFocus; virtual;
    function HandleAllocated: Boolean;
    property TabOrder: TTabOrder read FTabOrder write FTabOrder default 0;
    property TabStop: Boolean read FTabStop write FTabStop default False;
    property OnEnter: TNotifyEvent read FOnEnter write FOnEnter;
    property OnExit: TNotifyEvent read FOnExit write FOnExit;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Invalidate; override;
    procedure Repaint; override;
    procedure Update; override;
    procedure PaintControls(DC: HDC; First: TControl);
    procedure Broadcast(var Message);
    procedure WndProc(var Message: TMessage); virtual;
    procedure DefaultHandler(var Message); override;
    property Handle: HWND read FHandle;
    property Controls[Index: Integer]: TControl read GetControl;
    property ControlCount: Integer read GetControlCount;
  end;

  TControlCanvas = class(TCanvas)
  private
    FControl: TControl;
    FDeviceContext: HDC;
    procedure SetControl(Value: TControl);
  public
    destructor Destroy; override;
    property Control: TControl read FControl write SetControl;
  end;

function FindControl(AHwnd: HWND): TWinControl;
function VclWindowProc(AHwnd: HWND; Msg: Word; AWParam: Word; ALParam: LongInt): LongInt; export;

implementation

const
  VclClassName = 'VCL_Window';

var
  ClassRegistered: Boolean = False;
  ControlList: TList = nil;

function VclWindowProc(AHwnd: HWND; Msg: Word; AWParam: Word; ALParam: LongInt): LongInt; export;
var
  Ctrl: TWinControl;
  Mesg: TMessage;
  PS: TPaintStruct;
  DC: HDC;
  Canvas: TCanvas;
begin
  Ctrl := FindControl(AHwnd);
  if Ctrl = nil then
  begin
    { Fallback na pobranie z cbWndExtra }
    Ctrl := TWinControl(Pointer(GetWindowLong(AHwnd, 0)));
  end;

  if Ctrl <> nil then
  begin
    Mesg.Msg := Msg;
    Mesg.WParam := AWParam;
    Mesg.LParam := ALParam;
    Mesg.Result := 0;

    case Msg of
      WM_COMMAND:
      begin
        { Sprawdzenie czy komunikat pochodzi od kontrolki potomnej }
        if ALParam <> 0 then
        begin
          Ctrl := FindControl(HWND(Loword(ALParam)));
          if (Ctrl <> nil) and (AWParam = BN_CLICKED) then
            Ctrl.Click;
        end
        else
        begin
          { Komunikat z menu (ID w AWParam) }
          DispatchMenuCommand(AWParam);
        end;
      end;
      WM_RBUTTONUP:
      begin
        if (Ctrl.PopupMenu <> nil) and Ctrl.PopupMenu.AutoPopup then
          Ctrl.PopupMenu.Popup(Loword(ALParam), Hiword(ALParam));
      end;
      WM_LBUTTONUP:
      begin
        Ctrl.Click;
      end;
    end;

    Ctrl.WndProc(Mesg);
    VclWindowProc := Mesg.Result;
    Exit;
  end;

  VclWindowProc := DefWindowProc(AHwnd, Msg, AWParam, ALParam);
end;

procedure RegisterVclClass;
var
  WC: TWndClass;
begin
  if not ClassRegistered then
  begin
    WC.style := CS_HREDRAW or CS_VREDRAW or CS_DBLCLKS;
    WC.lpfnWndProc := @VclWindowProc;
    WC.cbClsExtra := 0;
    WC.cbWndExtra := 4; { Miejsce na wskaźnik Self }
    WC.hInstance := HInstance;
    WC.hIcon := LoadIcon(0, IDI_APPLICATION);
    WC.hCursor := LoadCursor(0, IDC_ARROW);
    WC.hbrBackground := COLOR_BTNFACE + 1;
    WC.lpszMenuName := nil;
    WC.lpszClassName := VclClassName;
    WinProcs.RegisterClass(WC);
    ClassRegistered := True;
  end;
end;

function FindControl(AHwnd: HWND): TWinControl;
var
  I: Integer;
  C: TWinControl;
begin
  Result := nil;
  if (ControlList <> nil) and (AHwnd <> 0) then
  begin
    for I := 0 to ControlList.Count - 1 do
    begin
      C := TWinControl(ControlList[I]);
      if (C <> nil) and (C.Handle = AHwnd) then
      begin
        Result := C;
        Exit;
      end;
    end;
  end;
end;

{ TControl }

constructor TControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLeft := 0;
  FTop := 0;
  FWidth := 50;
  FHeight := 25;
  FVisible := True;
  FEnabled := True;
  FCaption := '';
  FColor := clBtnFace;
  FFont := TFont.Create;
  FCursor := 0;
  FAlign := alNone;
  FCtl3D := True;
  FParentCtl3D := True;
  FParentColor := True;
  FParentFont := True;
  FParentShowHint := True;
  FShowHint := False;
end;

destructor TControl.Destroy;
begin
  if FParent <> nil then
  begin
    FParent.FControls.Remove(Self);
    FParent := nil;
  end;
  FFont.Free;
  inherited Destroy;
end;

procedure TControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FWidth := AWidth;
  FHeight := AHeight;
  Invalidate;
end;

function TControl.GetBoundsRect: TRect;
begin
  Result.Left := FLeft;
  Result.Top := FTop;
  Result.Right := FLeft + FWidth;
  Result.Bottom := FTop + FHeight;
end;

procedure TControl.SetBoundsRect(const Value: TRect);
begin
  SetBounds(Value.Left, Value.Top, Value.Right - Value.Left, Value.Bottom - Value.Top);
end;

function TControl.GetClientRect: TRect;
begin
  Result.Left := 0;
  Result.Top := 0;
  Result.Right := FWidth;
  Result.Bottom := FHeight;
end;

function TControl.GetClientOrigin: TPoint;
var
  P: TPoint;
begin
  P.X := 0;
  P.Y := 0;
  if FParent <> nil then
  begin
    P := FParent.ClientOrigin;
    Inc(P.X, FLeft);
    Inc(P.Y, FTop);
  end;
  Result := P;
end;

procedure TControl.SetLeft(Value: Integer);
begin
  SetBounds(Value, FTop, FWidth, FHeight);
end;

procedure TControl.SetTop(Value: Integer);
begin
  SetBounds(FLeft, Value, FWidth, FHeight);
end;

procedure TControl.SetWidth(Value: Integer);
begin
  SetBounds(FLeft, FTop, Value, FHeight);
end;

procedure TControl.SetHeight(Value: Integer);
begin
  SetBounds(FLeft, FTop, FWidth, Value);
end;

procedure TControl.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    Invalidate;
  end;
end;

procedure TControl.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    Invalidate;
  end;
end;

procedure TControl.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    Invalidate;
  end;
end;

procedure TControl.SetParent(AParent: TWinControl);
begin
  if FParent <> AParent then
  begin
    if FParent <> nil then
      FParent.FControls.Remove(Self);
    FParent := AParent;
    if FParent <> nil then
      FParent.FControls.Add(Self);
  end;
end;

procedure TControl.Click;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TControl.Paint;
begin
  { Domyślnie brak rysowania bazowego }
end;

procedure TControl.Invalidate;
begin
  if (FParent <> nil) and (FParent.HandleAllocated) then
    FParent.Invalidate;
end;

procedure TControl.Repaint;
begin
  Invalidate;
end;

procedure TControl.SetAlign(Value: TAlign);
begin
  if FAlign <> Value then
  begin
    FAlign := Value;
  end;
end;

procedure TControl.Show;
begin
  Visible := True;
end;

procedure TControl.Hide;
begin
  Visible := False;
end;

procedure TControl.BringToFront;
begin
  if (FParent <> nil) and (FParent.HandleAllocated) then
  begin
    if (Self is TWinControl) and TWinControl(Self).HandleAllocated then
      BringWindowToTop(TWinControl(Self).Handle);
  end;
end;

procedure TControl.SendToBack;
begin
  if (FParent <> nil) and (FParent.HandleAllocated) then
  begin
    if (Self is TWinControl) and TWinControl(Self).HandleAllocated then
      SetWindowPos(TWinControl(Self).Handle, 1, 0, 0, 0, 0, SWP_NOMOVE or SWP_NOSIZE);
  end;
end;

procedure TControl.Update;
begin
  if (FParent <> nil) and (FParent.HandleAllocated) then
    UpdateWindow(FParent.Handle);
end;

procedure TControl.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
end;

procedure TControl.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self, Shift, X, Y);
end;

procedure TControl.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);
end;

procedure TControl.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyDown) then
    FOnKeyDown(Self, Key, Shift);
end;

procedure TControl.KeyUp(var Key: Word; Shift: TShiftState);
begin
  if Assigned(FOnKeyUp) then
    FOnKeyUp(Self, Key, Shift);
end;

procedure TControl.KeyPress(var Key: Char);
begin
  if Assigned(FOnKeyPress) then
    FOnKeyPress(Self, Key);
end;

{ TGraphicControl }

constructor TGraphicControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
end;

destructor TGraphicControl.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TGraphicControl.Paint;
begin
end;

{ TWinControl }

constructor TWinControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FControls := TList.Create;
  FHandle := 0;
  if ControlList = nil then
    ControlList := TList.Create;
  ControlList.Add(Self);
end;

destructor TWinControl.Destroy;
begin
  if ControlList <> nil then
    ControlList.Remove(Self);
  DestroyWindowHandle;
  FControls.Free;
  inherited Destroy;
end;

procedure TWinControl.SetParent(AParent: TWinControl);
begin
  inherited SetParent(AParent);
  if (FParent <> nil) and FParent.HandleAllocated and not HandleAllocated then
    CreateHandle;
end;

function TWinControl.GetControl(Index: Integer): TControl;
begin
  Result := TControl(FControls[Index]);
end;

function TWinControl.GetControlCount: Integer;
begin
  Result := FControls.Count;
end;

function TWinControl.HandleAllocated: Boolean;
begin
  Result := FHandle <> 0;
end;

procedure TWinControl.CreateParams(var Params: TCreateParams);
begin
  RegisterVclClass;
  Params.Caption := PChar(FCaption);
  Params.Style := WS_CHILD or WS_VISIBLE or WS_CLIPSIBLINGS;
  Params.ExStyle := 0;
  Params.X := FLeft;
  Params.Y := FTop;
  Params.Width := FWidth;
  Params.Height := FHeight;
  if FParent <> nil then
    Params.WndParent := FParent.Handle
  else
    Params.WndParent := 0;
  Params.Param := nil;
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, VclClassName);
end;

procedure TWinControl.CreateWindowHandle(const Params: TCreateParams);
begin
  FHandle := CreateWindowEx(
    Params.ExStyle,
    Params.WinClassName,
    Params.Caption,
    Params.Style,
    Params.X, Params.Y,
    Params.Width, Params.Height,
    Params.WndParent,
    0,
    HInstance,
    Params.Param
  );
  if FHandle <> 0 then
    SetWindowLong(FHandle, 0, LongInt(Pointer(Self)));
end;

procedure TWinControl.CreateHandle;
var
  Params: TCreateParams;
begin
  if not HandleAllocated then
  begin
    CreateParams(Params);
    CreateWindowHandle(Params);
  end;
end;

procedure TWinControl.DestroyHandle;
begin
  DestroyWindowHandle;
end;

procedure TWinControl.DestroyWindowHandle;
begin
  if HandleAllocated then
  begin
    DestroyWindow(FHandle);
    FHandle := 0;
  end;
end;

procedure TWinControl.SetFocus;
begin
  if HandleAllocated then
    WinProcs.SetFocus(FHandle);
end;

procedure TWinControl.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  if HandleAllocated then
    MoveWindow(FHandle, ALeft, ATop, AWidth, AHeight, True);
end;

procedure TWinControl.Invalidate;
begin
  if HandleAllocated then
    InvalidateRect(FHandle, nil, True);
end;

procedure TWinControl.Repaint;
begin
  Invalidate;
  Update;
end;

procedure TWinControl.Update;
begin
  if HandleAllocated then
    UpdateWindow(FHandle);
end;

procedure TWinControl.PaintControls(DC: HDC; First: TControl);
var
  I, StartIdx: Integer;
  Ctrl: TControl;
  SaveIndex: Integer;
begin
  StartIdx := 0;
  if First <> nil then
    StartIdx := FControls.IndexOf(First);
  if StartIdx < 0 then StartIdx := 0;

  for I := StartIdx to FControls.Count - 1 do
  begin
    Ctrl := TControl(FControls[I]);
    if (Ctrl is TGraphicControl) and Ctrl.Visible then
    begin
      SaveIndex := SaveDC(DC);
      OffsetWindowOrg(DC, -Ctrl.Left, -Ctrl.Top);
      IntersectClipRect(DC, 0, 0, Ctrl.Width, Ctrl.Height);
      TGraphicControl(Ctrl).Paint;
      RestoreDC(DC, SaveIndex);
    end;
  end;
end;

procedure TWinControl.Broadcast(var Message);
var
  I: Integer;
  Ctrl: TControl;
begin
  for I := 0 to FControls.Count - 1 do
  begin
    Ctrl := TControl(FControls[I]);
    if Ctrl is TWinControl then
      TWinControl(Ctrl).WndProc(TMessage(Message));
  end;
end;

procedure TWinControl.WndProc(var Message: TMessage);
begin
  DefaultHandler(Message);
end;

procedure TWinControl.DefaultHandler(var Message);
var
  M: TMessage;
begin
  M := TMessage(Message);
  if HandleAllocated then
    M.Result := DefWindowProc(FHandle, M.Msg, M.WParam, M.LParam)
  else
    M.Result := 0;
  TMessage(Message).Result := M.Result;
end;

{ TControlCanvas }

destructor TControlCanvas.Destroy;
begin
  if (FDeviceContext <> 0) and (FControl <> nil) then
  begin
    if (FControl is TWinControl) and TWinControl(FControl).HandleAllocated then
      ReleaseDC(TWinControl(FControl).Handle, FDeviceContext)
    else if (FControl.Parent <> nil) and FControl.Parent.HandleAllocated then
      ReleaseDC(FControl.Parent.Handle, FDeviceContext);
  end;
  inherited Destroy;
end;

procedure TControlCanvas.SetControl(Value: TControl);
begin
  if FControl <> Value then
  begin
    if (FDeviceContext <> 0) and (FControl <> nil) then
    begin
      if (FControl is TWinControl) and TWinControl(FControl).HandleAllocated then
        ReleaseDC(TWinControl(FControl).Handle, FDeviceContext)
      else if (FControl.Parent <> nil) and FControl.Parent.HandleAllocated then
        ReleaseDC(FControl.Parent.Handle, FDeviceContext);
      FDeviceContext := 0;
      Handle := 0;
    end;
    FControl := Value;
    if (FControl <> nil) then
    begin
      if (FControl is TWinControl) and TWinControl(FControl).HandleAllocated then
      begin
        FDeviceContext := GetDC(TWinControl(FControl).Handle);
        Handle := FDeviceContext;
      end
      else if (FControl.Parent <> nil) and FControl.Parent.HandleAllocated then
      begin
        FDeviceContext := GetDC(FControl.Parent.Handle);
        Handle := FDeviceContext;
      end;
    end;
  end;
end;

initialization

finalization
  if ControlList <> nil then
  begin
    ControlList.Free;
    ControlList := nil;
  end;

end.
