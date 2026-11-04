unit Graphics;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes;

type
  TColor = LongInt;

const
  clBlack       = TColor($00000000);
  clMaroon      = TColor($00000080);
  clGreen       = TColor($00008000);
  clOlive       = TColor($00008080);
  clNavy        = TColor($00800000);
  clPurple      = TColor($00800080);
  clTeal        = TColor($00808000);
  clGray        = TColor($00808080);
  clSilver      = TColor($00C0C0C0);
  clRed         = TColor($000000FF);
  clLime        = TColor($0000FF00);
  clYellow      = TColor($0000FFFF);
  clBlue        = TColor($00FF0000);
  clFuchsia     = TColor($00FF00FF);
  clAqua        = TColor($00FFFF00);
  clWhite       = TColor($00FFFFFF);

  clScrollBar           = TColor($80000000);
  clBackground          = TColor($80000001);
  clActiveCaption       = TColor($80000002);
  clInactiveCaption     = TColor($80000003);
  clMenu                = TColor($80000004);
  clWindow              = TColor($80000005);
  clWindowFrame         = TColor($80000006);
  clMenuText            = TColor($80000007);
  clWindowText          = TColor($80000008);
  clCaptionText         = TColor($80000009);
  clActiveBorder        = TColor($8000000A);
  clInactiveBorder      = TColor($8000000B);
  clAppWorkSpace        = TColor($8000000C);
  clHighlight           = TColor($8000000D);
  clHighlightText       = TColor($8000000E);
  clBtnFace             = TColor($8000000F);
  clBtnShadow           = TColor($80000010);
  clGrayText            = TColor($80000011);
  clBtnText             = TColor($80000012);
  clInactiveCaptionText = TColor($80000013);
  clBtnHighlight        = TColor($80000014);

type
  TFontStyle = (fsBold, fsItalic, fsUnderline, fsStrikeOut);
  TFontStyles = set of TFontStyle;

  TPenStyle = (psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame);
  TBrushStyle = (bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross);

  TFont = class(TPersistent)
  private
    FName: string;
    FSize: Integer;
    FColor: TColor;
    FStyle: TFontStyles;
    FHandle: HFONT;
    procedure SetName(const Value: string);
    procedure SetSize(Value: Integer);
    procedure SetColor(Value: TColor);
    procedure SetStyle(Value: TFontStyles);
    procedure UpdateFont;
  public
    constructor Create;
    destructor Destroy; override;
    property Handle: HFONT read FHandle;
    property Name: string read FName write SetName;
    property Size: Integer read FSize write SetSize;
    property Color: TColor read FColor write SetColor;
    property Style: TFontStyles read FStyle write SetStyle;
  end;

  TPen = class(TPersistent)
  private
    FColor: TColor;
    FWidth: Integer;
    FStyle: TPenStyle;
    FHandle: HPEN;
    procedure SetColor(Value: TColor);
    procedure SetWidth(Value: Integer);
    procedure SetStyle(Value: TPenStyle);
    procedure UpdatePen;
  public
    constructor Create;
    destructor Destroy; override;
    property Handle: HPEN read FHandle;
    property Color: TColor read FColor write SetColor;
    property Width: Integer read FWidth write SetWidth;
    property Style: TPenStyle read FStyle write SetStyle;
  end;

  TBrush = class(TPersistent)
  private
    FColor: TColor;
    FStyle: TBrushStyle;
    FHandle: HBRUSH;
    procedure SetColor(Value: TColor);
    procedure SetStyle(Value: TBrushStyle);
    procedure UpdateBrush;
  public
    constructor Create;
    destructor Destroy; override;
    property Handle: HBRUSH read FHandle;
    property Color: TColor read FColor write SetColor;
    property Style: TBrushStyle read FStyle write SetStyle;
  end;

  TCanvas = class(TPersistent)
  private
    FHandle: HDC;
    FFont: TFont;
    FPen: TPen;
    FBrush: TBrush;
    FAutoFreeDC: Boolean;
    procedure SetHandle(Value: HDC);
  public
    constructor Create;
    destructor Destroy; override;
    procedure MoveTo(X, Y: Integer);
    procedure LineTo(X, Y: Integer);
    procedure Rectangle(X1, Y1, X2, Y2: Integer);
    procedure FillRect(const Rect: TRect);
    procedure TextOut(X, Y: Integer; const Text: string);
    function TextWidth(const Text: string): Integer;
    function TextHeight(const Text: string): Integer;
    property Handle: HDC read FHandle write SetHandle;
    property Font: TFont read FFont;
    property Pen: TPen read FPen;
    property Brush: TBrush read FBrush;
  end;

function RGB(R, G, B: Byte): LongInt;
function ColorToRGB(Color: TColor): LongInt;

implementation

function RGB(R, G, B: Byte): LongInt;
begin
  RGB := LongInt(R) or (LongInt(G) shl 8) or (LongInt(B) shl 16);
end;

function ColorToRGB(Color: TColor): LongInt;
begin
  if (Color and $80000000) <> 0 then
    ColorToRGB := GetSysColor(Integer(Color and $000000FF))
  else
    ColorToRGB := Color;
end;

{ TFont }

constructor TFont.Create;
begin
  inherited Create;
  FName := 'System';
  FSize := 10;
  FColor := clWindowText;
  FStyle := [];
  FHandle := 0;
end;

destructor TFont.Destroy;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  inherited Destroy;
end;

procedure TFont.UpdateFont;
var
  Weight: Integer;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
  if fsBold in FStyle then
    Weight := 700
  else
    Weight := 400;
  { CreateFont in Win16 }
  FHandle := CreateFont(
    -FSize, 0, 0, 0, Weight,
    Byte(fsItalic in FStyle),
    Byte(fsUnderline in FStyle),
    Byte(fsStrikeOut in FStyle),
    ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
    DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
    @FName[1]
  );
end;

procedure TFont.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    UpdateFont;
  end;
end;

procedure TFont.SetSize(Value: Integer);
begin
  if FSize <> Value then
  begin
    FSize := Value;
    UpdateFont;
  end;
end;

procedure TFont.SetColor(Value: TColor);
begin
  FColor := Value;
end;

procedure TFont.SetStyle(Value: TFontStyles);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    UpdateFont;
  end;
end;

{ TPen }

constructor TPen.Create;
begin
  inherited Create;
  FColor := clBlack;
  FWidth := 1;
  FStyle := psSolid;
  UpdatePen;
end;

destructor TPen.Destroy;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  inherited Destroy;
end;

procedure TPen.UpdatePen;
var
  PenStyleCode: Integer;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  case FStyle of
    psDash: PenStyleCode := PS_DASH;
    psDot:  PenStyleCode := PS_DOT;
    psClear: PenStyleCode := PS_NULL;
    else PenStyleCode := PS_SOLID;
  end;
  FHandle := CreatePen(PenStyleCode, FWidth, ColorToRGB(FColor));
end;

procedure TPen.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    UpdatePen;
  end;
end;

procedure TPen.SetWidth(Value: Integer);
begin
  if FWidth <> Value then
  begin
    FWidth := Value;
    UpdatePen;
  end;
end;

procedure TPen.SetStyle(Value: TPenStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    UpdatePen;
  end;
end;

{ TBrush }

constructor TBrush.Create;
begin
  inherited Create;
  FColor := clWhite;
  FStyle := bsSolid;
  UpdateBrush;
end;

destructor TBrush.Destroy;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  inherited Destroy;
end;

procedure TBrush.UpdateBrush;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  if FStyle = bsClear then
    FHandle := GetStockObject(NULL_BRUSH)
  else
    FHandle := CreateSolidBrush(ColorToRGB(FColor));
end;

procedure TBrush.SetColor(Value: TColor);
begin
  if FColor <> Value then
  begin
    FColor := Value;
    UpdateBrush;
  end;
end;

procedure TBrush.SetStyle(Value: TBrushStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
    UpdateBrush;
  end;
end;

{ TCanvas }

constructor TCanvas.Create;
begin
  inherited Create;
  FHandle := 0;
  FFont := TFont.Create;
  FPen := TPen.Create;
  FBrush := TBrush.Create;
  FAutoFreeDC := False;
end;

destructor TCanvas.Destroy;
begin
  FFont.Free;
  FPen.Free;
  FBrush.Free;
  inherited Destroy;
end;

procedure TCanvas.SetHandle(Value: HDC);
begin
  FHandle := Value;
  if FHandle <> 0 then
  begin
    if FPen.Handle <> 0 then
      SelectObject(FHandle, FPen.Handle);
    if FBrush.Handle <> 0 then
      SelectObject(FHandle, FBrush.Handle);
    if FFont.Handle <> 0 then
      SelectObject(FHandle, FFont.Handle);
  end;
end;

procedure TCanvas.MoveTo(X, Y: Integer);
begin
  if FHandle <> 0 then
    WinProcs.MoveTo(FHandle, X, Y);
end;

procedure TCanvas.LineTo(X, Y: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    WinProcs.LineTo(FHandle, X, Y);
  end;
end;

procedure TCanvas.Rectangle(X1, Y1, X2, Y2: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.Rectangle(FHandle, X1, Y1, X2, Y2);
  end;
end;

procedure TCanvas.FillRect(const Rect: TRect);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.FillRect(FHandle, @Rect, FBrush.Handle);
  end;
end;

procedure TCanvas.TextOut(X, Y: Integer; const Text: string);
begin
  if (FHandle <> 0) and (Length(Text) > 0) then
  begin
    SetTextColor(FHandle, ColorToRGB(FFont.Color));
    SetBkMode(FHandle, TRANSPARENT);
    if FFont.Handle <> 0 then
      SelectObject(FHandle, FFont.Handle);
    WinProcs.TextOut(FHandle, X, Y, @Text[1], Length(Text));
  end;
end;

function TCanvas.TextWidth(const Text: string): Integer;
var
  Extent: LongInt;
begin
  Result := 0;
  if (FHandle <> 0) and (Length(Text) > 0) then
  begin
    if FFont.Handle <> 0 then
      SelectObject(FHandle, FFont.Handle);
    Extent := GetTextExtent(FHandle, @Text[1], Length(Text));
    Result := Loword(Extent);
  end;
end;

function TCanvas.TextHeight(const Text: string): Integer;
var
  Extent: LongInt;
begin
  Result := 0;
  if (FHandle <> 0) and (Length(Text) > 0) then
  begin
    if FFont.Handle <> 0 then
      SelectObject(FHandle, FFont.Handle);
    Extent := GetTextExtent(FHandle, @Text[1], Length(Text));
    Result := Hiword(Extent);
  end;
end;

end.
