unit ExtCtrls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, SysUtils, StdCtrls, Messages;

type
  TBevelStyle = (bsLowered, bsRaised);
  TBevelShape = (bsBox, bsFrame, bsTopLine, bsBottomLine, bsLeftLine, bsRightLine, bsSpacer);
  TPanelBevel = (bvNone, bvLowered, bvRaised, bvSpace);
  TAlignment = Classes.TAlignment;

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

  TShapeType = (stRectangle, stSquare, stRoundRect, stRoundSquare, stEllipse, stCircle);

  TShape = class(TGraphicControl)
  private
    FPen: TPen;
    FBrush: TBrush;
    FShape: TShapeType;
    procedure SetBrush(Value: TBrush);
    procedure SetPen(Value: TPen);
    procedure SetShape(Value: TShapeType);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Brush: TBrush read FBrush write SetBrush;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ParentShowHint;
    property Pen: TPen read FPen write SetPen;
    property Shape: TShapeType read FShape write SetShape default stRectangle;
    property ShowHint;
    property Visible;
  end;

  TCustomPanel = class(TWinControl)
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
    property Alignment: TAlignment read FAlignment write SetAlignment;
    property BevelInner: TPanelBevel read FBevelInner write SetBevelInner;
    property BevelOuter: TPanelBevel read FBevelOuter write SetBevelOuter;
    property BevelWidth: Integer read FBevelWidth write SetBevelWidth;
    property BorderWidth: Integer read FBorderWidth write SetBorderWidth;
    property BorderStyle: TBorderStyle read FBorderStyle write SetBorderStyle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure WndProc(var Message: TMessage); override;
    property Canvas: TCanvas read FCanvas;
  end;

  TPanel = class(TCustomPanel)
  published
    property Alignment;
    property BevelInner;
    property BevelOuter;
    property BevelWidth;
    property BorderWidth;
    property BorderStyle;
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

  TPage = class(TWinControl)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNotebook = class(TWinControl)
  private
    FPages: TStrings;
    FPageIndex: Integer;
    FOnPageChanged: TNotifyEvent;
    function GetActivePage: string;
    procedure SetActivePage(const Value: string);
    procedure SetPageIndex(Value: Integer);
    procedure SetPages(Value: TStrings);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ShowCurrentPage; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ActivePage: string read GetActivePage write SetActivePage;
  published
    property Pages: TStrings read FPages write SetPages;
    property PageIndex: Integer read FPageIndex write SetPageIndex default 0;
    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
    property Enabled;
    property Visible;
    property Font;
    property Color;
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

  TSectionEvent = procedure(Sender: TObject; ASection, AWidth: Integer) of object;

  THeader = class(TControl)
  private
    FSections: TStrings;
    FTabOrder: Integer;
    FOnSized: TSectionEvent;
    FOnSizing: TSectionEvent;
    FSectionWidths: TList;
    function GetSectionWidth(Index: Integer): Integer;
    procedure SetSectionWidth(Index: Integer; Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Sections: TStrings read FSections;
    property SectionWidth[Index: Integer]: Integer read GetSectionWidth write SetSectionWidth;
  published
    property TabOrder: Integer read FTabOrder write FTabOrder default 0;
    property OnSized: TSectionEvent read FOnSized write FOnSized;
    property OnSizing: TSectionEvent read FOnSizing write FOnSizing;
  end;

  TRadioGroup = class(TGroupBox)
  private
    FItems: TStrings;
    FItemIndex: Integer;
    FColumns: Integer;
    FButtons: TList;
    FReading: Boolean;
    procedure SetItems(Value: TStrings);
    procedure SetItemIndex(Value: Integer);
    procedure SetColumns(Value: Integer);
    procedure ItemsChange(Sender: TObject);
    procedure ButtonClick(Sender: TObject);
    procedure ArrangeButtons;
  protected
    procedure Loaded; override;
    procedure ReadState(Reader: TReader); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property Caption;
    property Color;
    property Columns: Integer read FColumns write SetColumns default 1;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ItemIndex: Integer read FItemIndex write SetItemIndex default -1;
    property Items: TStrings read FItems write SetItems;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
  end;

procedure Frame3D(Canvas: TCanvas; var Rect: TRect; TopColor, BottomColor: TColor; Width: Integer);

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

{ TShape }

constructor TShape.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPen := TPen.Create;
  FBrush := TBrush.Create;
  FShape := stRectangle;
  FWidth := 65;
  FHeight := 65;
end;

destructor TShape.Destroy;
begin
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

procedure TShape.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
  Invalidate;
end;

procedure TShape.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
  Invalidate;
end;

procedure TShape.SetShape(Value: TShapeType);
begin
  if FShape <> Value then
  begin
    FShape := Value;
    Invalidate;
  end;
end;

procedure TShape.Paint;
var
  X, Y, W, H, S: Integer;
begin
  Canvas.Pen := FPen;
  Canvas.Brush := FBrush;
  X := Pen.Width div 2;
  Y := Pen.Width div 2;
  W := Width - Pen.Width + 1;
  H := Height - Pen.Width + 1;
  if (FShape = stSquare) or (FShape = stRoundSquare) or (FShape = stCircle) then
  begin
    if W < H then S := W else S := H;
    X := X + (W - S) div 2;
    Y := Y + (H - S) div 2;
    W := S;
    H := S;
  end;
  case FShape of
    stRectangle, stSquare:
      Canvas.Rectangle(X, Y, X + W, Y + H);
    stRoundRect, stRoundSquare:
      Canvas.RoundRect(X, Y, X + W, Y + H, (W + H) div 8, (W + H) div 8);
    stEllipse, stCircle:
      Canvas.Ellipse(X, Y, X + W, Y + H);
  end;
end;

{ TCustomPanel }

constructor TCustomPanel.Create(AOwner: TComponent);
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

destructor TCustomPanel.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TCustomPanel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TCustomPanel.SetBevelInner(Value: TPanelBevel);
begin
  if FBevelInner <> Value then
  begin
    FBevelInner := Value;
    Invalidate;
  end;
end;

procedure TCustomPanel.SetBevelOuter(Value: TPanelBevel);
begin
  if FBevelOuter <> Value then
  begin
    FBevelOuter := Value;
    Invalidate;
  end;
end;

procedure TCustomPanel.SetBevelWidth(Value: Integer);
begin
  if FBevelWidth <> Value then
  begin
    FBevelWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomPanel.SetBorderWidth(Value: Integer);
begin
  if FBorderWidth <> Value then
  begin
    FBorderWidth := Value;
    Invalidate;
  end;
end;

procedure TCustomPanel.SetBorderStyle(Value: TBorderStyle);
begin
  if FBorderStyle <> Value then
  begin
    FBorderStyle := Value;
    Invalidate;
  end;
end;

procedure TCustomPanel.Paint;
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

procedure TCustomPanel.WndProc(var Message: TMessage);
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
      PaintControls(DC, nil);
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

{ TPage }

constructor TPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := True;
end;

{ TNotebook }

constructor TNotebook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TStringList.Create;
  FPageIndex := 0;
  FWidth := 150;
  FHeight := 150;
end;

destructor TNotebook.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
  begin
    if FPages.Objects[I] <> nil then
      TObject(FPages.Objects[I]).Free;
  end;
  FPages.Free;
  inherited Destroy;
end;

procedure TNotebook.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

function TNotebook.GetActivePage: string;
begin
  if (FPageIndex >= 0) and (FPageIndex < FPages.Count) then
    Result := FPages[FPageIndex]
  else
    Result := '';
end;

procedure TNotebook.SetActivePage(const Value: string);
var
  Idx: Integer;
begin
  Idx := FPages.IndexOf(Value);
  if Idx >= 0 then
    SetPageIndex(Idx);
end;

procedure TNotebook.SetPageIndex(Value: Integer);
begin
  if FPageIndex <> Value then
  begin
    FPageIndex := Value;
    ShowCurrentPage;
    if Assigned(FOnPageChanged) then
      FOnPageChanged(Self);
  end;
end;

procedure TNotebook.SetPages(Value: TStrings);
begin
  FPages.Assign(Value);
  if FPageIndex >= FPages.Count then
    FPageIndex := FPages.Count - 1;
  ShowCurrentPage;
end;

procedure TNotebook.ShowCurrentPage;
var
  I: Integer;
  P: TControl;
begin
  for I := 0 to FPages.Count - 1 do
  begin
    if FPages.Objects[I] is TControl then
    begin
      P := TControl(FPages.Objects[I]);
      P.Visible := (I = FPageIndex);
    end;
  end;
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

{ TRadioGroup }

constructor TRadioGroup.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TStringList.Create;
  TStringList(FItems).OnChange := ItemsChange;
  FButtons := TList.Create;
  FItemIndex := -1;
  FColumns := 1;
end;

destructor TRadioGroup.Destroy;
begin
  SetItemIndex(-1);
  FItems.Free;
  FButtons.Free;
  inherited Destroy;
end;

procedure TRadioGroup.ItemsChange(Sender: TObject);
begin
  if not FReading then
    ArrangeButtons;
end;

procedure TRadioGroup.SetColumns(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if FColumns <> Value then
  begin
    FColumns := Value;
    ArrangeButtons;
  end;
end;

procedure TRadioGroup.SetItemIndex(Value: Integer);
begin
  if FReading then
    FItemIndex := Value
  else
  begin
    if Value < -1 then Value := -1;
    if Value >= FButtons.Count then Value := FButtons.Count - 1;
    if FItemIndex <> Value then
    begin
      if (FItemIndex >= 0) and (FItemIndex < FButtons.Count) then
        TRadioButton(FButtons[FItemIndex]).Checked := False;
      FItemIndex := Value;
      if (FItemIndex >= 0) and (FItemIndex < FButtons.Count) then
        TRadioButton(FButtons[FItemIndex]).Checked := True;
      Click;
    end;
  end;
end;

procedure TRadioGroup.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TRadioGroup.ButtonClick(Sender: TObject);
begin
  if not FReading then
  begin
    SetItemIndex(FButtons.IndexOf(Sender));
  end;
end;

procedure TRadioGroup.ArrangeButtons;
var
  I, Col, Row, ColCount, RowCount: Integer;
  BtnWidth, BtnHeight, StartX, StartY: Integer;
  Btn: TRadioButton;
begin
  while FButtons.Count > 0 do
  begin
    TObject(FButtons.Last).Free;
    FButtons.Delete(FButtons.Count - 1);
  end;
  if FItems.Count = 0 then Exit;

  ColCount := FColumns;
  if ColCount < 1 then ColCount := 1;
  RowCount := (FItems.Count + ColCount - 1) div ColCount;
  if RowCount < 1 then RowCount := 1;

  StartX := 10;
  StartY := 20;
  BtnWidth := (Width - StartX * 2) div ColCount;
  BtnHeight := (Height - StartY - 10) div RowCount;
  if BtnHeight < 18 then BtnHeight := 18;

  for I := 0 to FItems.Count - 1 do
  begin
    Col := I div RowCount;
    Row := I mod RowCount;
    Btn := TRadioButton.Create(Self);
    Btn.Parent := Self;
    Btn.Caption := FItems[I];
    Btn.Left := StartX + Col * BtnWidth;
    Btn.Top := StartY + Row * BtnHeight;
    Btn.Width := BtnWidth;
    Btn.Height := BtnHeight;
    Btn.OnClick := ButtonClick;
    if I = FItemIndex then
      Btn.Checked := True;
    FButtons.Add(Btn);
  end;
end;

procedure TRadioGroup.Loaded;
begin
  inherited Loaded;
  ArrangeButtons;
  if (FItemIndex >= 0) and (FItemIndex < FButtons.Count) then
    TRadioButton(FButtons[FItemIndex]).Checked := True;
end;

procedure TRadioGroup.ReadState(Reader: TReader);
begin
  FReading := True;
  try
    inherited ReadState(Reader);
  finally
    FReading := False;
  end;
end;

procedure Frame3D(Canvas: TCanvas; var Rect: TRect; TopColor, BottomColor: TColor; Width: Integer);
var
  I: Integer;
begin
  for I := 1 to Width do
  begin
    Canvas.Pen.Color := TopColor;
    Canvas.MoveTo(Rect.Left, Rect.Bottom - 1);
    Canvas.LineTo(Rect.Left, Rect.Top);
    Canvas.LineTo(Rect.Right - 1, Rect.Top);
    Canvas.Pen.Color := BottomColor;
    Canvas.LineTo(Rect.Right - 1, Rect.Bottom - 1);
    Canvas.LineTo(Rect.Left, Rect.Bottom - 1);
    Inc(Rect.Left);
    Inc(Rect.Top);
    Dec(Rect.Right);
    Dec(Rect.Bottom);
  end;
end;

initialization
  RegisterClasses([TTimer, TBevel, TShape, TPanel, TPage, TNotebook, TImage, THeader, TRadioGroup]);

finalization
  if TimerList <> nil then
  begin
    TimerList.Free;
    TimerList := nil;
  end;

end.
