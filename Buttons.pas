unit Buttons;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, StdCtrls, Messages, SysUtils;

type
  TButtonLayout = (blGlyphLeft, blGlyphRight, blGlyphTop, blGlyphBottom);
  TButtonState = (bsUp, bsDisabled, bsDown, bsExclusive);
  TButtonStyle = (bsAutoDetect, bsWin31, bsNew);
  TBitBtnKind = (bkCustom, bkOK, bkCancel, bkHelp, bkYes, bkNo, bkClose, bkAbort, bkRetry, bkIgnore, bkAll);

  TSpeedButton = class(TGraphicControl)
  protected
    FGroupIndex: Integer;
    FGlyph: TBitmap;
    FDown: Boolean;
    FDragging: Boolean;
    FAllowAllUp: Boolean;
    FLayout: TButtonLayout;
    FSpacing: Integer;
    FMargin: Integer;
    FNumGlyphs: Integer;
    FState: TButtonState;
    FStyle: TButtonStyle;
    procedure SetDown(Value: Boolean);
    procedure SetGroupIndex(Value: Integer);
    procedure SetAllowAllUp(Value: Boolean);
    procedure SetGlyph(Value: TBitmap);
    procedure SetNumGlyphs(Value: Integer);
    procedure SetLayout(Value: TButtonLayout);
    procedure SetSpacing(Value: Integer);
    procedure SetMargin(Value: Integer);
    procedure UpdateExclusive;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
    property Canvas;
  published
    property AllowAllUp: Boolean read FAllowAllUp write SetAllowAllUp default False;
    property GroupIndex: Integer read FGroupIndex write SetGroupIndex default 0;
    property Down: Boolean read FDown write SetDown default False;
    property Style: TButtonStyle read FStyle write FStyle default bsAutoDetect;
    property Caption;
    property Enabled;
    property Font;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property Layout: TButtonLayout read FLayout write SetLayout default blGlyphLeft;
    property Margin: Integer read FMargin write SetMargin default -1;
    property NumGlyphs: Integer read FNumGlyphs write SetNumGlyphs default 1;
    property Spacing: Integer read FSpacing write SetSpacing default 4;
    property Visible;
    property OnClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
  end;

  TBitBtn = class(TButton)
  private
    FKind: TBitBtnKind;
    FGlyph: TBitmap;
    FNumGlyphs: Integer;
    FLayout: TButtonLayout;
    FMargin: Integer;
    FSpacing: Integer;
    FStyle: TButtonStyle;
    FModalResult: TModalResult;
    FDefault: Boolean;
    FCancel: Boolean;
    procedure SetKind(Value: TBitBtnKind);
    procedure SetGlyph(Value: TBitmap);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Click; override;
  published
    property Style: TButtonStyle read FStyle write FStyle default bsAutoDetect;
    property Kind: TBitBtnKind read FKind write SetKind default bkCustom;
    property Glyph: TBitmap read FGlyph write SetGlyph;
    property NumGlyphs: Integer read FNumGlyphs write FNumGlyphs default 1;
    property Layout: TButtonLayout read FLayout write FLayout default blGlyphLeft;
    property Margin: Integer read FMargin write FMargin default -1;
    property Spacing: Integer read FSpacing write FSpacing default 4;
    property ModalResult: TModalResult read FModalResult write FModalResult default mrNone;
    property Default: Boolean read FDefault write FDefault default False;
    property Cancel: Boolean read FCancel write FCancel default False;
  end;

implementation

{ TSpeedButton }

constructor TSpeedButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGlyph := TBitmap.Create;
  FWidth := 25;
  FHeight := 25;
  FGroupIndex := 0;
  FDown := False;
  FAllowAllUp := False;
  FLayout := blGlyphLeft;
  FMargin := -1;
  FSpacing := 4;
  FNumGlyphs := 1;
  FState := bsUp;
end;

destructor TSpeedButton.Destroy;
begin
  FGlyph.Free;
  inherited Destroy;
end;

procedure TSpeedButton.SetDown(Value: Boolean);
begin
  if FGroupIndex = 0 then
    Value := False;
  if FDown <> Value then
  begin
    FDown := Value;
    if Value then
    begin
      if FState = bsUp then
        FState := bsExclusive;
      UpdateExclusive;
    end
    else
    begin
      FState := bsUp;
    end;
    Invalidate;
  end;
end;

procedure TSpeedButton.SetGroupIndex(Value: Integer);
begin
  if FGroupIndex <> Value then
  begin
    FGroupIndex := Value;
    if (FGroupIndex = 0) and FDown then
      SetDown(False);
  end;
end;

procedure TSpeedButton.SetAllowAllUp(Value: Boolean);
begin
  if FAllowAllUp <> Value then
    FAllowAllUp := Value;
end;

procedure TSpeedButton.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TSpeedButton.SetNumGlyphs(Value: Integer);
begin
  if Value < 1 then Value := 1;
  if Value > 4 then Value := 4;
  if FNumGlyphs <> Value then
  begin
    FNumGlyphs := Value;
    Invalidate;
  end;
end;

procedure TSpeedButton.SetLayout(Value: TButtonLayout);
begin
  if FLayout <> Value then
  begin
    FLayout := Value;
    Invalidate;
  end;
end;

procedure TSpeedButton.SetSpacing(Value: Integer);
begin
  if FSpacing <> Value then
  begin
    FSpacing := Value;
    Invalidate;
  end;
end;

procedure TSpeedButton.SetMargin(Value: Integer);
begin
  if FMargin <> Value then
  begin
    FMargin := Value;
    Invalidate;
  end;
end;

procedure TSpeedButton.UpdateExclusive;
var
  I: Integer;
  Sibling: TControl;
begin
  if (FGroupIndex <> 0) and (FParent <> nil) then
  begin
    for I := 0 to FParent.ControlCount - 1 do
    begin
      Sibling := FParent.Controls[I];
      if (Sibling <> Self) and (Sibling is TSpeedButton) then
      begin
        if TSpeedButton(Sibling).FGroupIndex = FGroupIndex then
        begin
          TSpeedButton(Sibling).SetDown(False);
        end;
      end;
    end;
  end;
end;

procedure TSpeedButton.Click;
begin
  if FGroupIndex <> 0 then
  begin
    if not FDown then
      SetDown(True)
    else if FAllowAllUp then
      SetDown(False);
  end;
  inherited Click;
end;

procedure TSpeedButton.Paint;
var
  DC: HDC;
  R: RECT;
  TopColor, BottomColor: TColor;
  IsPressed: Boolean;
  TextX, TextY: Integer;
  GlyphX, GlyphY: Integer;
  Offset: Integer;
  TextSize: LongInt;
  TextW, TextH: Integer;
begin
  if (FParent <> nil) and FParent.HandleAllocated then
  begin
    DC := GetDC(FParent.Handle);
    if DC <> 0 then
    begin
      Canvas.Handle := DC;
      try
        R.left := FLeft;
        R.top := FTop;
        R.right := FLeft + FWidth;
        R.bottom := FTop + FHeight;

        IsPressed := (FState in [bsDown, bsExclusive]);

        Canvas.Brush.Color := clBtnFace;
        WinProcs.FillRect(DC, R, Canvas.Brush.Handle);

        if IsPressed then
        begin
          TopColor := clBtnShadow;
          BottomColor := clBtnHighlight;
          Offset := 1;
        end
        else
        begin
          TopColor := clBtnHighlight;
          BottomColor := clBtnShadow;
          Offset := 0;
        end;

        { Ramka wypukła / wklęsła }
        SelectObject(DC, CreatePen(PS_SOLID, 1, ColorToRGB(TopColor)));
        WinProcs.MoveTo(DC, R.left, R.bottom - 1);
        WinProcs.LineTo(DC, R.left, R.top);
        WinProcs.LineTo(DC, R.right - 1, R.top);
        DeleteObject(SelectObject(DC, CreatePen(PS_SOLID, 1, ColorToRGB(BottomColor))));
        WinProcs.LineTo(DC, R.right - 1, R.bottom - 1);
        WinProcs.LineTo(DC, R.left, R.bottom - 1);
        DeleteObject(SelectObject(DC, GetStockObject(BLACK_PEN)));

        { Rysowanie glifu }
        if (FGlyph <> nil) and not FGlyph.Empty then
        begin
          GlyphX := R.left + (FWidth - FGlyph.Width div FNumGlyphs) div 2 + Offset;
          GlyphY := R.top + (FHeight - FGlyph.Height) div 2 + Offset;
          FGlyph.Draw(Canvas, Rect(GlyphX, GlyphY, GlyphX + FGlyph.Width, GlyphY + FGlyph.Height));
        end;

        { Rysowanie podpisu }
        if Length(FCaption) > 0 then
        begin
          SetBkMode(DC, TRANSPARENT);
          SetTextColor(DC, ColorToRGB(FFont.Color));
          if FFont.Handle <> 0 then
            SelectObject(DC, FFont.Handle);
          TextSize := GetTextExtent(DC, @FCaption[1], Length(FCaption));
          TextW := Loword(TextSize);
          TextH := Hiword(TextSize);
          TextX := R.left + (FWidth - TextW) div 2 + Offset;
          TextY := R.top + (FHeight - TextH) div 2 + Offset;
          WinProcs.TextOut(DC, TextX, TextY, @FCaption[1], Length(FCaption));
        end;

      finally
        Canvas.Handle := 0;
        ReleaseDC(FParent.Handle, DC);
      end;
    end;
  end;
end;

{ TBitBtn }

constructor TBitBtn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FGlyph := TBitmap.Create;
  FNumGlyphs := 1;
  FLayout := blGlyphLeft;
  FMargin := -1;
  FSpacing := 4;
  FModalResult := mrNone;
  FDefault := False;
  FCancel := False;
  FKind := bkCustom;
end;

destructor TBitBtn.Destroy;
begin
  FGlyph.Free;
  inherited Destroy;
end;

procedure TBitBtn.SetKind(Value: TBitBtnKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    case Value of
      bkOK:
      begin
        Caption := 'OK';
        ModalResult := mrOk;
        Default := True;
      end;
      bkCancel:
      begin
        Caption := 'Cancel';
        ModalResult := mrCancel;
        Cancel := True;
      end;
      bkHelp:
      begin
        Caption := '&Help';
      end;
      bkYes:
      begin
        Caption := '&Yes';
        ModalResult := mrYes;
      end;
      bkNo:
      begin
        Caption := '&No';
        ModalResult := mrNo;
      end;
      bkClose:
      begin
        Caption := '&Close';
        ModalResult := mrCancel;
      end;
      bkAbort:
      begin
        Caption := '&Abort';
        ModalResult := mrAbort;
      end;
      bkRetry:
      begin
        Caption := '&Retry';
        ModalResult := mrRetry;
      end;
      bkIgnore:
      begin
        Caption := '&Ignore';
        ModalResult := mrIgnore;
      end;
      bkAll:
      begin
        Caption := '&All';
        ModalResult := mrAll;
      end;
    end;
  end;
end;

procedure TBitBtn.SetGlyph(Value: TBitmap);
begin
  FGlyph.Assign(Value);
  Invalidate;
end;

procedure TBitBtn.Click;
begin
  inherited Click;
  if FModalResult <> mrNone then
  begin
    if (FParent <> nil) and (FParent is TForm) then
      TForm(FParent).ModalResult := FModalResult;
  end;
end;

initialization
  RegisterClasses([TSpeedButton, TBitBtn]);

end.
