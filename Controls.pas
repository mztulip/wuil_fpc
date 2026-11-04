unit Controls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Strings, Menus;

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

type
  TCursor = Integer;
  TMouseButton = (mbLeft, mbRight, mbMiddle);
  TShiftStateEnum = (ssShift, ssAlt, ssCtrl, ssLeft, ssRight, ssMiddle, ssDouble);
  TShiftState = set of TShiftStateEnum;

  TNotifyEvent = procedure(Sender: TObject) of object;
  TMouseEvent = procedure(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer) of object;
  TMouseMoveEvent = procedure(Sender: TObject; Shift: TShiftState; X, Y: Integer) of object;
  TKeyEvent = procedure(Sender: TObject; var Key: Word; Shift: TShiftState) of object;
  TKeyPressEvent = procedure(Sender: TObject; var Key: Char) of object;

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
    FLeft, FTop, FWidth, FHeight: Integer;
    FVisible: Boolean;
    FEnabled: Boolean;
    FCaption: string;
    FColor: TColor;
    FFont: TFont;
    FCursor: TCursor;
    FPopupMenu: TPopupMenu;
    FOnClick: TNotifyEvent;
    FOnMouseDown: TMouseEvent;
    FOnMouseUp: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    procedure SetLeft(Value: Integer);
    procedure SetTop(Value: Integer);
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
    procedure SetVisible(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetCaption(const Value: string);
    procedure SetParent(AParent: TWinControl); virtual;
    procedure Click; virtual;
    procedure Paint; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); virtual;
    procedure Invalidate; virtual;
    procedure Repaint; virtual;
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
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
  end;

  TWinControl = class(TControl)
  protected
    FHandle: HWND;
    FControls: TList;
    FDefWndProc: Pointer;
    function GetControl(Index: Integer): TControl;
    function GetControlCount: Integer;
    procedure CreateParams(var Params: TCreateParams); virtual;
    procedure CreateWindowHandle(const Params: TCreateParams); virtual;
    procedure DestroyWindowHandle; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure CreateHandle; virtual;
    procedure SetParent(AParent: TWinControl); override;
    procedure SetFocus; virtual;
    function HandleAllocated: Boolean;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure Invalidate; override;
    procedure WndProc(var Message: TMessage); virtual;
    procedure DefaultHandler(var Message); override;
    property Handle: HWND read FHandle;
    property Controls[Index: Integer]: TControl read GetControl;
    property ControlCount: Integer read GetControlCount;
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

initialization

finalization
  if ControlList <> nil then
  begin
    ControlList.Free;
    ControlList := nil;
  end;

end.
