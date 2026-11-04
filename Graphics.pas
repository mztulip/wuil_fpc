unit Graphics;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Win31, Classes, SysUtils;

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

  TGraphic = class;

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
    function GetPixel(X, Y: Integer): TColor;
    procedure SetPixel(X, Y: Integer; Value: TColor);
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
    procedure Draw(X, Y: Integer; Graphic: TGraphic);
    procedure CopyRect(const Dest: TRect; Source: TCanvas; const SourceRect: TRect);
    procedure PolyLine(const Points: array of TPoint);
    property Pixels[X, Y: Integer]: TColor read GetPixel write SetPixel;
    property Handle: HDC read FHandle write SetHandle;
    property Font: TFont read FFont;
    property Pen: TPen read FPen;
    property Brush: TBrush read FBrush;
  end;

  TGraphic = class(TPersistent)
  protected
    function GetEmpty: Boolean; virtual;
    function GetHeight: Integer; virtual;
    function GetWidth: Integer; virtual;
    procedure SetHeight(Value: Integer); virtual;
    procedure SetWidth(Value: Integer); virtual;
  public
    constructor Create; virtual;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); virtual; abstract;
    procedure LoadFromFile(const Filename: string); virtual;
    procedure SaveToFile(const Filename: string); virtual;
    property Empty: Boolean read GetEmpty;
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TIcon = class(TGraphic)
  private
    FHandle: HICON;
    function GetHandle: HICON;
    procedure SetHandle(Value: HICON);
  protected
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    property Handle: HICON read GetHandle write SetHandle;
  end;

  TBitmap = class(TGraphic)
  private
    FHandle: HBITMAP;
    FCanvas: TCanvas;
    FWidth, FHeight: Integer;
    function GetCanvas: TCanvas;
    procedure SetHandle(Value: HBITMAP);
  protected
    function GetEmpty: Boolean; override;
    function GetHeight: Integer; override;
    function GetWidth: Integer; override;
    procedure SetHeight(Value: Integer); override;
    procedure SetWidth(Value: Integer); override;
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure Draw(ACanvas: TCanvas; const Rect: TRect); override;
    procedure LoadFromResourceName(Instance: THandle; const ResName: string);
    property Canvas: TCanvas read GetCanvas;
    property Handle: HBITMAP read FHandle write SetHandle;
  end;

  TPicture = class(TPersistent)
  private
    FGraphic: TGraphic;
    FBitmap: TBitmap;
    FIcon: TIcon;
    function GetBitmap: TBitmap;
    function GetIcon: TIcon;
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetBitmap(Value: TBitmap);
    procedure SetIcon(Value: TIcon);
    procedure SetGraphic(Value: TGraphic);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure LoadFromFile(const Filename: string);
    property Bitmap: TBitmap read GetBitmap write SetBitmap;
    property Icon: TIcon read GetIcon write SetIcon;
    property Graphic: TGraphic read FGraphic write SetGraphic;
    property Height: Integer read GetHeight;
    property Width: Integer read GetWidth;
  end;

function RGB(R, G, B: Byte): LongInt;
function ColorToRGB(Color: TColor): LongInt;
function ColorToString(Color: TColor): string;
function StringToColor(const S: string): TColor;

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

function ColorToString(Color: TColor): string;
begin
  case Color of
    clBlack:       Result := 'clBlack';
    clMaroon:      Result := 'clMaroon';
    clGreen:       Result := 'clGreen';
    clOlive:       Result := 'clOlive';
    clNavy:        Result := 'clNavy';
    clPurple:      Result := 'clPurple';
    clTeal:        Result := 'clTeal';
    clGray:        Result := 'clGray';
    clSilver:      Result := 'clSilver';
    clRed:         Result := 'clRed';
    clLime:        Result := 'clLime';
    clYellow:      Result := 'clYellow';
    clBlue:        Result := 'clBlue';
    clFuchsia:     Result := 'clFuchsia';
    clAqua:        Result := 'clAqua';
    clWhite:       Result := 'clWhite';
    clScrollBar:   Result := 'clScrollBar';
    clBackground:  Result := 'clBackground';
    clActiveCaption: Result := 'clActiveCaption';
    clInactiveCaption: Result := 'clInactiveCaption';
    clMenu:        Result := 'clMenu';
    clWindow:      Result := 'clWindow';
    clWindowFrame: Result := 'clWindowFrame';
    clMenuText:    Result := 'clMenuText';
    clWindowText:  Result := 'clWindowText';
    clCaptionText: Result := 'clCaptionText';
    clActiveBorder: Result := 'clActiveBorder';
    clInactiveBorder: Result := 'clInactiveBorder';
    clAppWorkSpace: Result := 'clAppWorkSpace';
    clHighlight:   Result := 'clHighlight';
    clHighlightText: Result := 'clHighlightText';
    clBtnFace:     Result := 'clBtnFace';
    clBtnShadow:   Result := 'clBtnShadow';
    clGrayText:    Result := 'clGrayText';
    clBtnText:     Result := 'clBtnText';
    clInactiveCaptionText: Result := 'clInactiveCaptionText';
    clBtnHighlight: Result := 'clBtnHighlight';
    else Result := '$' + IntToHex(Color, 8);
  end;
end;

function StringToColor(const S: string): TColor;
var
  LS: string;
begin
  LS := Lowercase(S);
  if LS = 'clblack' then Result := clBlack
  else if LS = 'clmaroon' then Result := clMaroon
  else if LS = 'clgreen' then Result := clGreen
  else if LS = 'clolive' then Result := clOlive
  else if LS = 'clnavy' then Result := clNavy
  else if LS = 'clpurple' then Result := clPurple
  else if LS = 'clteal' then Result := clTeal
  else if LS = 'clgray' then Result := clGray
  else if LS = 'clsilver' then Result := clSilver
  else if LS = 'clred' then Result := clRed
  else if LS = 'cllime' then Result := clLime
  else if LS = 'clyellow' then Result := clYellow
  else if LS = 'clblue' then Result := clBlue
  else if LS = 'clfuchsia' then Result := clFuchsia
  else if LS = 'claqua' then Result := clAqua
  else if LS = 'clwhite' then Result := clWhite
  else if LS = 'clbtnface' then Result := clBtnFace
  else if LS = 'clbtnshadow' then Result := clBtnShadow
  else if LS = 'clbtnhighlight' then Result := clBtnHighlight
  else if LS = 'clwindow' then Result := clWindow
  else if LS = 'clwindowtext' then Result := clWindowText
  else if LS = 'clhighlight' then Result := clHighlight
  else if LS = 'clhighlighttext' then Result := clHighlightText
  else if LS = 'clmenu' then Result := clMenu
  else if LS = 'clmenutext' then Result := clMenuText
  else
    Result := StrToIntDef(S, clBlack);
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

function TCanvas.GetPixel(X, Y: Integer): TColor;
begin
  if FHandle <> 0 then
    Result := WinProcs.GetPixel(FHandle, X, Y)
  else
    Result := clBlack;
end;

procedure TCanvas.SetPixel(X, Y: Integer; Value: TColor);
begin
  if FHandle <> 0 then
    WinProcs.SetPixel(FHandle, X, Y, ColorToRGB(Value));
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

procedure TCanvas.Draw(X, Y: Integer; Graphic: TGraphic);
var
  R: TRect;
begin
  if (FHandle <> 0) and (Graphic <> nil) and not Graphic.Empty then
  begin
    R.Left := X;
    R.Top := Y;
    R.Right := X + Graphic.Width;
    R.Bottom := Y + Graphic.Height;
    Graphic.Draw(Self, R);
  end;
end;

procedure TCanvas.CopyRect(const Dest: TRect; Source: TCanvas; const SourceRect: TRect);
begin
  if (FHandle <> 0) and (Source <> nil) and (Source.Handle <> 0) then
  begin
    BitBlt(FHandle, Dest.Left, Dest.Top,
      Dest.Right - Dest.Left, Dest.Bottom - Dest.Top,
      Source.Handle, SourceRect.Left, SourceRect.Top, SRCCOPY);
  end;
end;

procedure TCanvas.PolyLine(const Points: array of TPoint);
var
  I: Integer;
begin
  if (FHandle <> 0) and (High(Points) >= 1) then
  begin
    SelectObject(FHandle, FPen.Handle);
    WinProcs.MoveTo(FHandle, Points[0].X, Points[0].Y);
    for I := 1 to High(Points) do
      WinProcs.LineTo(FHandle, Points[I].X, Points[I].Y);
  end;
end;

{ TGraphic }

constructor TGraphic.Create;
begin
  inherited Create;
end;

function TGraphic.GetEmpty: Boolean;
begin
  Result := True;
end;

function TGraphic.GetHeight: Integer;
begin
  Result := 0;
end;

function TGraphic.GetWidth: Integer;
begin
  Result := 0;
end;

procedure TGraphic.SetHeight(Value: Integer);
begin
end;

procedure TGraphic.SetWidth(Value: Integer);
begin
end;

procedure TGraphic.LoadFromFile(const Filename: string);
begin
end;

procedure TGraphic.SaveToFile(const Filename: string);
begin
end;

{ TIcon }

constructor TIcon.Create;
begin
  inherited Create;
  FHandle := 0;
end;

destructor TIcon.Destroy;
begin
  if FHandle <> 0 then
    DestroyIcon(FHandle);
  inherited Destroy;
end;

function TIcon.GetEmpty: Boolean;
begin
  Result := FHandle = 0;
end;

function TIcon.GetHeight: Integer;
begin
  Result := 32;
end;

function TIcon.GetWidth: Integer;
begin
  Result := 32;
end;

function TIcon.GetHandle: HICON;
begin
  Result := FHandle;
end;

procedure TIcon.SetHandle(Value: HICON);
begin
  if FHandle <> Value then
  begin
    if FHandle <> 0 then
      DestroyIcon(FHandle);
    FHandle := Value;
  end;
end;

procedure TIcon.Assign(Source: TPersistent);
begin
  if Source is TIcon then
    SetHandle(CopyIcon(HInstance, TIcon(Source).Handle))
  else
    inherited Assign(Source);
end;

procedure TIcon.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  if (ACanvas <> nil) and (ACanvas.Handle <> 0) and (FHandle <> 0) then
    DrawIcon(ACanvas.Handle, Rect.Left, Rect.Top, FHandle);
end;

{ TBitmap }

constructor TBitmap.Create;
begin
  inherited Create;
  FHandle := 0;
  FWidth := 0;
  FHeight := 0;
  FCanvas := nil;
end;

destructor TBitmap.Destroy;
begin
  FCanvas.Free;
  if FHandle <> 0 then
    DeleteObject(FHandle);
  inherited Destroy;
end;

function TBitmap.GetEmpty: Boolean;
begin
  Result := FHandle = 0;
end;

function TBitmap.GetHeight: Integer;
begin
  Result := FHeight;
end;

function TBitmap.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TBitmap.SetHeight(Value: Integer);
begin
  FHeight := Value;
end;

procedure TBitmap.SetWidth(Value: Integer);
begin
  FWidth := Value;
end;

procedure TBitmap.SetHandle(Value: HBITMAP);
var
  BM: BITMAP;
begin
  if FHandle <> Value then
  begin
    if FHandle <> 0 then
      DeleteObject(FHandle);
    FHandle := Value;
    if FHandle <> 0 then
    begin
      GetObject(FHandle, SizeOf(BITMAP), @BM);
      FWidth := BM.bmWidth;
      FHeight := BM.bmHeight;
    end
    else
    begin
      FWidth := 0;
      FHeight := 0;
    end;
  end;
end;

function TBitmap.GetCanvas: TCanvas;
var
  DC: HDC;
begin
  if FCanvas = nil then
  begin
    FCanvas := TCanvas.Create;
    DC := CreateCompatibleDC(0);
    FCanvas.Handle := DC;
    if FHandle <> 0 then
      SelectObject(DC, FHandle);
  end;
  Result := FCanvas;
end;

procedure TBitmap.Assign(Source: TPersistent);
begin
  if Source is TBitmap then
  begin
    SetWidth(TBitmap(Source).Width);
    SetHeight(TBitmap(Source).Height);
    { Kopiowanie uchwytu lub danych }
  end
  else
    inherited Assign(Source);
end;

procedure TBitmap.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  MemDC: HDC;
  OldBmp: HBITMAP;
begin
  if (ACanvas <> nil) and (ACanvas.Handle <> 0) and (FHandle <> 0) then
  begin
    MemDC := CreateCompatibleDC(ACanvas.Handle);
    OldBmp := SelectObject(MemDC, FHandle);
    BitBlt(ACanvas.Handle, Rect.Left, Rect.Top, FWidth, FHeight, MemDC, 0, 0, SRCCOPY);
    SelectObject(MemDC, OldBmp);
    DeleteDC(MemDC);
  end;
end;

procedure TBitmap.LoadFromResourceName(Instance: THandle; const ResName: string);
begin
  SetHandle(LoadBitmap(Instance, PChar(ResName)));
end;

{ TPicture }

constructor TPicture.Create;
begin
  inherited Create;
  FBitmap := TBitmap.Create;
  FIcon := TIcon.Create;
  FGraphic := nil;
end;

destructor TPicture.Destroy;
begin
  FBitmap.Free;
  FIcon.Free;
  inherited Destroy;
end;

function TPicture.GetBitmap: TBitmap;
begin
  FGraphic := FBitmap;
  Result := FBitmap;
end;

function TPicture.GetIcon: TIcon;
begin
  FGraphic := FIcon;
  Result := FIcon;
end;

procedure TPicture.SetBitmap(Value: TBitmap);
begin
  FBitmap.Assign(Value);
  FGraphic := FBitmap;
end;

procedure TPicture.SetIcon(Value: TIcon);
begin
  FIcon.Assign(Value);
  FGraphic := FIcon;
end;

procedure TPicture.SetGraphic(Value: TGraphic);
begin
  FGraphic := Value;
end;

function TPicture.GetWidth: Integer;
begin
  if FGraphic <> nil then
    Result := FGraphic.Width
  else
    Result := 0;
end;

function TPicture.GetHeight: Integer;
begin
  if FGraphic <> nil then
    Result := FGraphic.Height
  else
    Result := 0;
end;

procedure TPicture.Assign(Source: TPersistent);
begin
  if Source is TPicture then
  begin
    if TPicture(Source).Graphic is TIcon then
      Icon.Assign(TPicture(Source).Icon)
    else if TPicture(Source).Graphic is TBitmap then
      Bitmap.Assign(TPicture(Source).Bitmap);
  end
  else if Source is TIcon then
    Icon.Assign(Source)
  else if Source is TBitmap then
    Bitmap.Assign(Source)
  else
    inherited Assign(Source);
end;

procedure TPicture.LoadFromFile(const Filename: string);
begin
  { Opcjonalne ładowanie z pliku }
end;

end.
