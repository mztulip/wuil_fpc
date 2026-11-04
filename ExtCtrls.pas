unit ExtCtrls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, Strings;

type
  TBevelStyle = (bsLowered, bsRaised);
  TBevelShape = (bsBox, bsFrame, bsTopLine, bsBottomLine, bsLeftLine, bsRightLine, bsSpacer);
  TPanelBevel = (bvNone, bvLowered, bvRaised, bvSpace);
  TAlignment = (taLeftJustify, taRightJustify, taCenter);
  TBorderStyle = (bsNone, bsSingle);

  TTimer = class(TComponent)
  private
    FInterval: Word;
    FEnabled: Boolean;
    FOnTimer: TNotifyEvent;
    FTimerID: Word;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Word);
    procedure UpdateTimer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Timer; virtual;
  published
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Interval: Word read FInterval write SetInterval;
    property OnTimer: TNotifyEvent read FOnTimer write FOnTimer;
  end;

  TBevel = class(TControl)
  private
    FShape: TBevelShape;
    FStyle: TBevelStyle;
    procedure SetShape(Value: TBevelShape);
    procedure SetStyle(Value: TBevelStyle);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Shape: TBevelShape read FShape write SetShape;
    property Style: TBevelStyle read FStyle write SetStyle;
    property Visible;
    property Enabled;
  end;

  TPanel = class(TWinControl)
  private
    FAlignment: TAlignment;
    FBevelInner: TPanelBevel;
    FBevelOuter: TPanelBevel;
    FBevelWidth: Integer;
    FBorderWidth: Integer;
    FBorderStyle: TBorderStyle;
    FCanvas: TCanvas;
    procedure SetAlignment(Value: TAlignment);
    procedure SetBevelInner(Value: TPanelBevel);
    procedure SetBevelOuter(Value: TPanelBevel);
    procedure SetBevelWidth(Value: Integer);
    procedure SetBorderWidth(Value: Integer);
    procedure SetBorderStyle(Value: TBorderStyle);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure WndProc(var Message: TMessage); override;
    property Canvas: TCanvas read FCanvas;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property BevelInner: TPanelBevel read FBevelInner write SetBevelInner;
    property BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter;
    property BevelWidth: Integer read FBevelWidth write SetBevelWidth;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
    property Caption;
    property Color;
    property Font;
    property Visible;
    property Enabled;
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
  end;

  TImage = class(TControl)
  private
    FPicture: TPicture;
    FStretch: Boolean;
    FAutoSize: Boolean;
    FCenter: Boolean;
    procedure SetPicture(Value: TPicture);
    procedure SetStretch(Value: Boolean);
    procedure SetAutoSize(Value: Boolean);
    procedure SetCenter(Value: Boolean);
    function GetCanvas: TCanvas;
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Canvas: TCanvas read GetCanvas;
  published
    property Picture: TPicture read FPicture write SetPicture;
    property Stretch: Boolean read FStretch write SetStretch;
    property AutoSize: Boolean read FAutoSize write SetAutoSize;
    property Center: Boolean read FCenter write SetCenter;
    property Visible;
    property Enabled;
    property OnClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnMouseMove;
  end;

  THeader = class(TControl)
  private
    FSections: TStrings;
    FSectionWidths: TList;
    function GetSectionWidth(Index: Integer): Integer;
    procedure SetSectionWidth(Index: Integer; Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Sections: TStrings read FSections;
    property SectionWidth[Index: Integer]: Integer read GetSectionWidth write SetSectionWidth;
  published
    property Visible;
    property Enabled;
  end;

implementation

var
  TimerList: TList = nil;
  NextTimerID: Word = 1;

function TimerProc(AHwnd: HWND; Msg: UINT; IdEvent: UINT; dwTime: LongInt): LongInt; export;
var
  I: Integer;
  T: TTimer;
begin
  if TimerList <> nil then
  begin
    for I := 0 to TimerList.Count - 1 do
    begin
      T := TTimer(TimerList[I]);
      if (T <> nil) and (T.FTimerID = IdEvent) then
      begin
        T.Timer;
        Break;
      end;
    end;
  end;
  TimerProc := 0;
end;

{ TTimer }

constructor TTimer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FInterval := 1000;
  FEnabled := True;
  FTimerID := 0;
  if TimerList = nil then
    TimerList := TList.Create;
  TimerList.Add(Self);
  UpdateTimer;
end;

destructor TTimer.Destroy;
begin
  FEnabled := False;
  UpdateTimer;
  if TimerList <> nil then
    TimerList.Remove(Self);
  inherited Destroy;
end;

procedure TTimer.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    UpdateTimer;
  end;
end;

procedure TTimer.SetInterval(Value: Word);
begin
  if FInterval <> Value then
  begin
    FInterval := Value;
    UpdateTimer;
  end;
end;

procedure TTimer.UpdateTimer;
begin
  if FTimerID <> 0 then
  begin
    KillTimer(0, FTimerID);
    FTimerID := 0;
  end;
  if FEnabled and (FInterval > 0) then
  begin
    Inc(NextTimerID);
    FTimerID := SetTimer(0, NextTimerID, FInterval, @TimerProc);
  end;
end;

procedure TTimer.Timer;
begin
  if FEnabled and Assigned(FOnTimer) then
    FOnTimer(Self);
end;

{ TBevel }

constructor TBevel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 50;
  FHeight := 50;
  FShape := bsBox;
  FStyle := bsLowered;
end;

procedure TBevel.SetShape(Value: TBevelShape);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

procedure TBevel.SetStyle(Value: TBevelStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    Invalidate;
  end;
end;

procedure TBevel.Paint;
var
  DC: HDC;
  TopColor, BottomColor: TColor;
  X1, Y1, X2, Y2: Integer;
begin
  if (FParent <> nil) and FParent.HandleAllocated then
  begin
    DC := GetDC(FParent.Handle);
    if DC <> 0 then
    begin
      if FStyle = bsLowered then
      begin
        TopColor := clBtnShadow;
        BottomColor := clBtnHighlight;
      end
      else
      begin
        TopColor := clBtnHighlight;
        BottomColor := clBtnShadow;
      end;

      X1 := FLeft;
      Y1 := FTop;
      X2 := FLeft + FWidth - 1;
      Y2 := FTop + FHeight - 1;

      case FShape of
        bsBox:
        begin
          { Górna i lewa krawędź }
          SelectObject(DC, CreatePen(PS_SOLID, 1, ColorToRGB(TopColor)));
          WinProcs.MoveTo(DC, X1, Y2);
          WinProcs.LineTo(DC, X1, Y1);
          WinProcs.LineTo(DC, X2, Y1);
          DeleteObject(SelectObject(DC, GetStockObject(BLACK_PEN)));

          { Dolna i prawa krawędź }
          SelectObject(DC, CreatePen(PS_SOLID, 1, ColorToRGB(BottomColor)));
          WinProcs.LineTo(DC, X2, Y2);
          WinProcs.LineTo(DC, X1, Y2);
          DeleteObject(SelectObject(DC, GetStockObject(BLACK_PEN)));
        end;
        bsTopLine:
        begin
          SelectObject(DC, CreatePen(PS_SOLID, 1, ColorToRGB(TopColor)));
          WinProcs.MoveTo(DC, X1, Y1);
          WinProcs.LineTo(DC, X2, Y1);
          DeleteObject(SelectObject(DC, CreatePen(PS_SOLID, 1, ColorToRGB(BottomColor))));
          WinProcs.MoveTo(DC, X1, Y1 + 1);
          WinProcs.LineTo(DC, X2, Y1 + 1);
          DeleteObject(SelectObject(DC, GetStockObject(BLACK_PEN)));
        end;
        else ;
      end;

      ReleaseDC(FParent.Handle, DC);
    end;
  end;
end;

{ TPanel }

constructor TPanel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FWidth := 185;
  FHeight := 41;
  FColor := clBtnFace;
  FAlignment := taCenter;
  FBevelInner := bvNone;
  FBevelOuter := bvRaised;
  FBevelWidth := 1;
  FBorderWidth := 0;
  FBorderStyle := bsNone;
end;

destructor TPanel.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TPanel.SetBevelInner(Value: TPanelBevel);
begin
  if FBevelInner <> Value then
  begin
    FBevelInner := Value;
    Invalidate;
  end;
end;

procedure TPanel.SetBevelOuter(Value: TPanelBevel);
begin
  if FBevelOuter <> Value then
  begin
    FBevelOuter := Value;
    Invalidate;
  end;
end;

procedure TPanel.SetBevelWidth(Value: Integer);
begin
  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
    Invalidate;
  end;
end;

procedure TPanel.SetBorderWidth(Value: Integer);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TPanel.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    Invalidate;
  end;
end;

procedure TPanel.Paint;
var
  R: RECT;
  TopColor, BottomColor: TColor;
  Flags: Word;
begin
  R.Left := 0;
  R.Top := 0;
  R.Right := FWidth;
  R.Bottom := FHeight;

  FCanvas.Brush.Color := FColor;
  WinProcs.FillRect(FCanvas.Handle, R, FCanvas.Brush.Handle);

  if FBevelOuter <> bvNone then
  begin
    if FBevelOuter = bvLowered then
    begin
      TopColor := clBtnShadow;
      BottomColor := clBtnHighlight;
    end
    else
    begin
      TopColor := clBtnHighlight;
      BottomColor := clBtnShadow;
    end;

    FCanvas.Pen.Color := TopColor;
    FCanvas.MoveTo(R.Left, R.Bottom - 1);
    FCanvas.LineTo(R.Left, R.Top);
    FCanvas.LineTo(R.Right - 1, R.Top);

    FCanvas.Pen.Color := BottomColor;
    FCanvas.LineTo(R.Right - 1, R.Bottom - 1);
    FCanvas.LineTo(R.Left, R.Bottom - 1);
  end;

  if Length(FCaption) > 0 then
  begin
    FCanvas.Font.Assign(FFont);
    Flags := DT_SINGLELINE or DT_VCENTER;
    case FAlignment of
      taLeftJustify:  Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter:       Flags := Flags or DT_CENTER;
    end;
    SetBkMode(FCanvas.Handle, TRANSPARENT);
    SetTextColor(FCanvas.Handle, ColorToRGB(FFont.Color));
    DrawText(FCanvas.Handle, @FCaption[1], Length(FCaption), R, Flags);
  end;
end;

procedure TPanel.WndProc(var Message: TMessage);
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

{ TImage }

constructor TImage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  FWidth := 105;
  FHeight := 105;
  FStretch := False;
  FAutoSize := False;
  FCenter := False;
end;

destructor TImage.Destroy;
begin
  FPicture.Free;
  inherited Destroy;
end;

function TImage.GetCanvas: TCanvas;
begin
  Result := FPicture.Bitmap.Canvas;
end;

procedure TImage.SetPicture(Value: TPicture);
begin
  FPicture.Assign(Value);
  Invalidate;
end;

procedure TImage.SetStretch(Value: Boolean);
begin
  if FStretch <> Value then
  begin
    FStretch := Value;
    Invalidate;
  end;
end;

procedure TImage.SetAutoSize(Value: Boolean);
begin
  if FAutoSize <> Value then
  begin
    FAutoSize := Value;
    if FAutoSize and (FPicture.Width > 0) and (FPicture.Height > 0) then
      SetBounds(FLeft, FTop, FPicture.Width, FPicture.Height);
  end;
end;

procedure TImage.SetCenter(Value: Boolean);
begin
  if FCenter <> Value then
  begin
    FCenter := Value;
    Invalidate;
  end;
end;

procedure TImage.Paint;
var
  DC: HDC;
  R: TRect;
  ImgCanvas: TCanvas;
begin
  if (FParent <> nil) and FParent.HandleAllocated and (FPicture <> nil) then
  begin
    DC := GetDC(FParent.Handle);
    if DC <> 0 then
    begin
      ImgCanvas := TCanvas.Create;
      ImgCanvas.Handle := DC;
      try
        R.Left := FLeft;
        R.Top := FTop;
        R.Right := FLeft + FWidth;
        R.Bottom := FTop + FHeight;

        if FPicture.Graphic <> nil then
          FPicture.Graphic.Draw(ImgCanvas, R)
        else if not FPicture.Icon.Empty then
          FPicture.Icon.Draw(ImgCanvas, R)
        else if not FPicture.Bitmap.Empty then
          FPicture.Bitmap.Draw(ImgCanvas, R);
      finally
        ImgCanvas.Free;
        ReleaseDC(FParent.Handle, DC);
      end;
    end;
  end;
end;

{ THeader }

constructor THeader.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FSections := TStringList.Create;
  FSectionWidths := TList.Create;
  FWidth := 100;
  FHeight := 20;
end;

destructor THeader.Destroy;
begin
  FSections.Free;
  FSectionWidths.Free;
  inherited Destroy;
end;

function THeader.GetSectionWidth(Index: Integer): Integer;
begin
  if (Index >= 0) and (Index < FSectionWidths.Count) then
    Result := Integer(FSectionWidths[Index])
  else
    Result := 50;
end;

procedure THeader.SetSectionWidth(Index: Integer; Value: Integer);
begin
  while FSectionWidths.Count <= Index do
    FSectionWidths.Add(Pointer(50));
  FSectionWidths[Index] := Pointer(Value);
  Invalidate;
end;

finalization
  if TimerList <> nil then
  begin
    TimerList.Free;
    TimerList := nil;
  end;

end.
