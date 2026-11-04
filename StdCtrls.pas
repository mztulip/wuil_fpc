unit StdCtrls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Strings;

type
  TLabel = class(TControl)
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Color;
    property Font;
    property Visible;
    property Enabled;
    property OnClick;
  end;

  TButton = class(TWinControl)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Enabled;
    property Visible;
    property Font;
    property OnClick;
  end;

  TEdit = class(TWinControl)
  private
    function GetText: string;
    procedure SetText(const Value: string);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    property Text: string read GetText write SetText;
  published
    property Enabled;
    property Visible;
    property Font;
    property OnClick;
  end;

implementation

{ TLabel }

constructor TLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 65;
  FHeight := 17;
  FCaption := 'Label';
end;

procedure TLabel.Paint;
var
  DC: HDC;
  R: RECT;
begin
  if (FParent <> nil) and FParent.HandleAllocated then
  begin
    DC := GetDC(FParent.Handle);
    if DC <> 0 then
    begin
      SetBkMode(DC, TRANSPARENT);
      SetTextColor(DC, ColorToRGB(FFont.Color));
      if FFont.Handle <> 0 then
        SelectObject(DC, FFont.Handle);
      R.left := FLeft;
      R.top := FTop;
      R.right := FLeft + FWidth;
      R.bottom := FTop + FHeight;
      DrawText(DC, @FCaption[1], Length(FCaption), R, DT_LEFT or DT_NOPREFIX);
      ReleaseDC(FParent.Handle, DC);
    end;
  end;
end;

{ TButton }

constructor TButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 75;
  FHeight := 25;
  FCaption := 'Button';
end;

procedure TButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'BUTTON');
  Params.Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_PUSHBUTTON;
end;

{ TEdit }

constructor TEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 121;
  FHeight := 21;
  FCaption := '';
end;

procedure TEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'EDIT');
  Params.Style := WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP or ES_AUTOHSCROLL;
end;

function TEdit.GetText: string;
var
  Len: Integer;
  Buf: array[0..255] of Char;
begin
  Result := '';
  if HandleAllocated then
  begin
    Len := GetWindowText(FHandle, Buf, SizeOf(Buf));
    if Len > 0 then
      Result := StrPas(Buf);
  end
  else
    Result := FCaption;
end;

procedure TEdit.SetText(const Value: string);
begin
  FCaption := Value;
  if HandleAllocated then
    SetWindowText(FHandle, PChar(Value));
end;

end.
