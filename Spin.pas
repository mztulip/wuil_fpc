unit Spin;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, Messages, SysUtils, StdCtrls;

type
  TSpinButton = class(TWinControl)
  private
    FUpClick: TNotifyEvent;
    FDownClick: TNotifyEvent;
  protected
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property Ctl3D;
    property Enabled;
    property ParentCtl3D;
    property Visible;
    property OnUpClick: TNotifyEvent read FUpClick write FUpClick;
    property OnDownClick: TNotifyEvent read FDownClick write FDownClick;
  end;

  TSpinEdit = class(TCustomEdit)
  private
    FMinValue: Longint;
    FMaxValue: Longint;
    FIncrement: Longint;
    FButton: TSpinButton;
    function GetValue: Longint;
    procedure SetValue(NewValue: Longint);
    function CheckValue(NewValue: Longint): Longint;
    procedure UpClick(Sender: TObject);
    procedure DownClick(Sender: TObject);
    procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
  protected
    function IsValidChar(Key: Char): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Button: TSpinButton read FButton;
  published
    property Align;
    property AutoSelect;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property Increment: Longint read FIncrement write FIncrement default 1;
    property MaxLength;
    property MaxValue: Longint read FMaxValue write FMaxValue default 0;
    property MinValue: Longint read FMinValue write FMinValue default 0;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Value: Longint read GetValue write SetValue default 0;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

implementation

{ TSpinButton }

constructor TSpinButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Width := 16;
  Height := 20;
end;

procedure TSpinButton.Paint;
begin
end;

procedure TSpinButton.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  inherited MouseDown(Button, Shift, X, Y);
  if Y < Height div 2 then
  begin
    if Assigned(FUpClick) then FUpClick(Self);
  end
  else
  begin
    if Assigned(FDownClick) then FDownClick(Self);
  end;
end;

{ TSpinEdit }

constructor TSpinEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIncrement := 1;
  FMinValue := 0;
  FMaxValue := 0;
  Value := 0;
  FButton := TSpinButton.Create(Self);
  FButton.Parent := Self;
  FButton.OnUpClick := UpClick;
  FButton.OnDownClick := DownClick;
  Width := 121;
  Height := 22;
end;

destructor TSpinEdit.Destroy;
begin
  FButton.Free;
  inherited Destroy;
end;

procedure TSpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TSpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TSpinEdit.SetEditRect;
var
  Loc: TRect;
begin
  if HandleAllocated then
  begin
    SendMessage(FHandle, EM_GETRECT, 0, LongInt(@Loc));
    Loc.Bottom := ClientHeight + 1;
    Loc.Right := ClientWidth - FButton.Width - 2;
    Loc.Top := 0;
    Loc.Left := 0;
    SendMessage(FHandle, EM_SETRECTNP, 0, LongInt(@Loc));
  end;
end;

procedure TSpinEdit.WMSize(var Message: TWMSize);
var
  MinBWidth: Integer;
begin
  inherited;
  MinBWidth := GetSystemMetrics(SM_CXVSCROLL);
  if MinBWidth < 9 then MinBWidth := 9;
  if FButton <> nil then
  begin
    FButton.SetBounds(Width - MinBWidth - 4, 0, MinBWidth, Height - 4);
    SetEditRect;
  end;
end;

function TSpinEdit.CheckValue(NewValue: Longint): Longint;
begin
  Result := NewValue;
  if (FMaxValue <> FMinValue) then
  begin
    if Result < FMinValue then
      Result := FMinValue
    else if Result > FMaxValue then
      Result := FMaxValue;
  end;
end;

function TSpinEdit.GetValue: Longint;
var
  Val: Longint;
begin
  Val := StrToIntDef(Text, FMinValue);
  Result := CheckValue(Val);
end;

procedure TSpinEdit.SetValue(NewValue: Longint);
begin
  Text := IntToStr(CheckValue(NewValue));
end;

procedure TSpinEdit.UpClick(Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value := Value + FIncrement;
end;

procedure TSpinEdit.DownClick(Sender: TObject);
begin
  if ReadOnly then MessageBeep(0)
  else Value := Value - FIncrement;
end;

function TSpinEdit.IsValidChar(Key: Char): Boolean;
begin
  Result := (Key in ['0'..'9', '+', '-']) or (Key < ' ');
end;

procedure TSpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_UP then UpClick(Self)
  else if Key = VK_DOWN then DownClick(Self);
  inherited KeyDown(Key, Shift);
end;

procedure TSpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0);
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

end.
