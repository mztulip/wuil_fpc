unit Graphics;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Win31, Classes, SysUtils;

type
  TColor = -$7FFFFFFF-1..$7FFFFFFF;
  TRect = WinTypes.RECT;
  TPoint = WinTypes.POINT;

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
  cl3DDkShadow          = TColor($80000015);
  cl3DLight             = TColor($80000016);
  clInfoText            = TColor($80000017);
  clInfoBk              = TColor($80000018);

type
  TFontStyle = (fsBold, fsItalic, fsUnderline, fsStrikeOut);
  TFontStyles = set of TFontStyle;

  TPenStyle = (psSolid, psDash, psDot, psDashDot, psDashDotDot, psClear, psInsideFrame);
  TBrushStyle = (bsSolid, bsClear, bsHorizontal, bsVertical, bsFDiagonal, bsBDiagonal, bsCross, bsDiagCross);
  TFillStyle = (fsSurface, fsBorder);

  TGraphic = class;
  TBitmap = class;

  TFont = class(TPersistent)
  private
    FName: string;
    FSize: Integer;
    FHeight: Integer;
    FColor: TColor;
    FStyle: TFontStyles;
    FHandle: HFONT;
    procedure SetName(const Value: string);
    procedure SetSize(Value: Integer);
    function GetHeight: Integer;
    procedure SetHeight(Value: Integer);
    procedure SetColor(Value: TColor);
    procedure SetStyle(Value: TFontStyles);
    function GetHandle: HFONT;
    procedure UpdateFont;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Handle: HFONT read GetHandle;
  published
    property Name: string read FName write SetName;
    property Size: Integer read FSize write SetSize;
    property Height: Integer read GetHeight write SetHeight;
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
    function GetHandle: HPEN;
    procedure UpdatePen;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Handle: HPEN read GetHandle;
  published
    property Color: TColor read FColor write SetColor;
    property Width: Integer read FWidth write SetWidth;
    property Style: TPenStyle read FStyle write SetStyle;
  end;

  TBrush = class(TPersistent)
  private
    FColor: TColor;
    FStyle: TBrushStyle;
    FHandle: HBRUSH;
    FBitmap: TBitmap;
    procedure SetColor(Value: TColor);
    procedure SetStyle(Value: TBrushStyle);
    procedure SetBitmap(Value: TBitmap);
    function GetHandle: HBRUSH;
    procedure UpdateBrush;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    property Handle: HBRUSH read GetHandle;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
  published
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
    FPenPos: TPoint;
    procedure SetHandle(Value: HDC);
    function GetPixel(X, Y: Integer): TColor;
    procedure SetPixel(X, Y: Integer; Value: TColor);
    function GetPenPos: TPoint;
    procedure SetPenPos(const Value: TPoint);
    procedure SetFont(Value: TFont);
    procedure SetPen(Value: TPen);
    procedure SetBrush(Value: TBrush);
  public
    constructor Create;
    destructor Destroy; override;
    procedure MoveTo(X, Y: Integer);
    procedure LineTo(X, Y: Integer);
    procedure Rectangle(X1, Y1, X2, Y2: Integer);
    procedure RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);
    procedure Ellipse(X1, Y1, X2, Y2: Integer);
    procedure Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
    procedure Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
    procedure Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
    procedure FloodFill(X, Y: Integer; Color: TColor; FillStyle: TFillStyle);
    procedure FillRect(const Rect: TRect);
    procedure DrawFocusRect(const Rect: TRect);
    procedure TextOut(X, Y: Integer; const Text: string);
    procedure TextRect(Rect: TRect; X, Y: Integer; const Text: string);
    function TextWidth(const Text: string): Integer;
    function TextHeight(const Text: string): Integer;
    procedure Draw(X, Y: Integer; Graphic: TGraphic);
    procedure CopyRect(const Dest: TRect; Source: TCanvas; const SourceRect: TRect);
    procedure PolyLine(const Points: array of TPoint);
    property Pixels[X, Y: Integer]: TColor read GetPixel write SetPixel;
    property Handle: HDC read FHandle write SetHandle;
    property Font: TFont read FFont write SetFont;
    property Pen: TPen read FPen write SetPen;
    property Brush: TBrush read FBrush write SetBrush;
    property PenPos: TPoint read GetPenPos write SetPenPos;
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
    procedure LoadFromStream(Stream: TStream); virtual;
    procedure SaveToStream(Stream: TStream); virtual;
    property Empty: Boolean read GetEmpty;
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
  end;

  TIcon = class(TGraphic)
  private
    FHandle: HICON;
    FMemoryImage: TMemoryStream;
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
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    property Handle: HICON read GetHandle write SetHandle;
  end;

  TBitmap = class(TGraphic)
  private
    FHandle: HBITMAP;
    FCanvas: TCanvas;
    FWidth, FHeight: Integer;
    function GetCanvas: TCanvas;
    procedure SetHandle(Value: HBITMAP);
    procedure ReadData(Stream: TStream);
    procedure WriteData(Stream: TStream);
  protected
    procedure DefineProperties(Filer: TFiler); override;
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
    procedure FreeImage;
    procedure LoadFromResourceName(Instance: THandle; const ResName: string);
    procedure LoadFromStream(Stream: TStream); override;
    procedure SaveToStream(Stream: TStream); override;
    property Canvas: TCanvas read GetCanvas;
    property Handle: HBITMAP read FHandle write SetHandle;
    property Height: Integer read GetHeight write SetHeight;
    property Width: Integer read GetWidth write SetWidth;
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

const
  WPF_SETMINPOSITION      = $0001;
  WPF_RESTORETOMAXIMIZED  = $0002;

type
  PWindowPlacement = ^TWindowPlacement;
  tagWINDOWPLACEMENT = record
    length: UINT;
    flags: UINT;
    showCmd: UINT;
    ptMinPosition: TPoint;
    ptMaxPosition: TPoint;
    rcNormalPosition: TRect;
  end;
  TWindowPlacement = tagWINDOWPLACEMENT;

function LockWindowUpdate(hwndLock: HWND): BOOL; far; external 'USER' index 294;
function GetWindowPlacement(hwnd: HWND; lpwndpl: PWindowPlacement): BOOL; far; external 'USER' index 370;
function SetWindowPlacement(hwnd: HWND; lpwndpl: PWindowPlacement): BOOL; far; external 'USER' index 371;

function RGB(R, G, B: Byte): LongInt;
function LoadStr(Ident: Word): string;
function FmtLoadStr(Ident: Word; const Args: array of const): string;
function ColorToRGB(Color: TColor): LongInt;
function ColorToString(Color: TColor): string;
function StringToColor(const S: string): TColor;
function ColorToIdent(Color: Longint; var Ident: OpenString): Boolean;
function IdentToColor(const Ident: string; var Color: Longint): Boolean;
procedure GetColorValues(Proc: TGetStrProc);
function Point(AX, AY: Integer): TPoint;
function Rect(ALeft, ATop, ARight, ABottom: Integer): TRect;
function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;
function IntersectRect(var Dest: TRect; const Source1, Source2: TRect): SmallInt;

implementation

function LoadStr(Ident: Word): string;
var
  Buf: array[0..255] of Char;
begin
  if LoadString(HInstance, Ident, Buf, SizeOf(Buf)) > 0 then
    Result := StrPas(Buf)
  else
    Result := '';
end;

function FmtLoadStr(Ident: Word; const Args: array of const): string;
begin
  Result := Format(LoadStr(Ident), Args);
end;

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

function ColorToIdent(Color: Longint; var Ident: OpenString): Boolean;
var
  S: string;
begin
  S := ColorToString(TColor(Color));
  if (Length(S) > 0) and (S[1] <> '$') then
  begin
    Ident := S;
    Result := True;
  end
  else
    Result := False;
end;

function IdentToColor(const Ident: string; var Color: Longint): Boolean;
var
  S: string;
begin
  Result := False;
  if Length(Ident) < 3 then Exit;
  if (Ident[1] = '$') or (Ident[1] in ['0'..'9', '+', '-']) then Exit;
  Color := StringToColor(Ident);
  S := ColorToString(TColor(Color));
  if CompareText(S, Ident) = 0 then
    Result := True;
end;

function ColorToIdentStream(Int: Longint; var Ident: string): Boolean;
var
  S: string;
begin
  S := ColorToString(TColor(Int));
  Result := (Length(S) > 0) and (S[1] <> '$');
  if Result then Ident := S;
end;

function IdentToColorStream(const Ident: string; var Int: Longint): Boolean;
begin
  Result := IdentToColor(Ident, Int);
end;

function Point(AX, AY: Integer): TPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

function Rect(ALeft, ATop, ARight, ABottom: Integer): TRect;
begin
  Result.Left := ALeft;
  Result.Top := ATop;
  Result.Right := ARight;
  Result.Bottom := ABottom;
end;

function Bounds(ALeft, ATop, AWidth, AHeight: Integer): TRect;
begin
  Result.Left := ALeft;
  Result.Top := ATop;
  Result.Right := ALeft + AWidth;
  Result.Bottom := ATop + AHeight;
end;

function IntersectRect(var Dest: TRect; const Source1, Source2: TRect): SmallInt;
begin
  Result := WinProcs.IntersectRect(@Dest, @Source1, @Source2);
end;

procedure GetColorValues(Proc: TGetStrProc);
const
  ColorNames: array[0..36] of string[25] = (
    'clBlack', 'clMaroon', 'clGreen', 'clOlive', 'clNavy', 'clPurple',
    'clTeal', 'clGray', 'clSilver', 'clRed', 'clLime', 'clYellow',
    'clBlue', 'clFuchsia', 'clAqua', 'clWhite',
    'clScrollBar', 'clBackground', 'clActiveCaption', 'clInactiveCaption',
    'clMenu', 'clWindow', 'clWindowFrame', 'clMenuText', 'clWindowText',
    'clCaptionText', 'clActiveBorder', 'clInactiveBorder', 'clAppWorkSpace',
    'clHighlight', 'clHighlightText', 'clBtnFace', 'clBtnShadow',
    'clGrayText', 'clBtnText', 'clInactiveCaptionText', 'clBtnHighlight'
  );
var
  I: Integer;
begin
  for I := Low(ColorNames) to High(ColorNames) do
    Proc(ColorNames[I]);
end;

{ TFont }

constructor TFont.Create;
begin
  inherited Create;
  FName := 'System';
  FSize := 10;
  FHeight := -13;
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

procedure TFont.Assign(Source: TPersistent);
begin
  if Source is TFont then
  begin
    FName := TFont(Source).FName;
    FSize := TFont(Source).FSize;
    FHeight := TFont(Source).FHeight;
    FColor := TFont(Source).FColor;
    FStyle := TFont(Source).FStyle;
    UpdateFont;
  end
  else
    inherited Assign(Source);
end;

function TFont.GetHandle: HFONT;
var
  Weight: Integer;
  FaceBuf: array[0..32] of Char;
begin
  if FHandle = 0 then
  begin
    if fsBold in FStyle then
      Weight := 700
    else
      Weight := 400;
    StrPLCopy(FaceBuf, FName, 32);
    FHandle := CreateFont(
      GetHeight, 0, 0, 0, Weight,
      Byte(fsItalic in FStyle),
      Byte(fsUnderline in FStyle),
      Byte(fsStrikeOut in FStyle),
      ANSI_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS,
      DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
      FaceBuf
    );
  end;
  Result := FHandle;
end;

procedure TFont.UpdateFont;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
end;

procedure TFont.SetName(const Value: string);
begin
  if FName <> Value then
  begin
    FName := Value;
    UpdateFont;
  end;
end;

function TFont.GetHeight: Integer;
begin
  if FHeight <> 0 then
    Result := FHeight
  else
    Result := -MulDiv(FSize, 96, 72);
end;

procedure TFont.SetHeight(Value: Integer);
begin
  if FHeight <> Value then
  begin
    FHeight := Value;
    if Value < 0 then
      FSize := -MulDiv(Value, 72, 96)
    else
      FSize := MulDiv(Value, 72, 96);
    UpdateFont;
  end;
end;

procedure TFont.SetSize(Value: Integer);
begin
  if FSize <> Value then
  begin
    FSize := Value;
    FHeight := -MulDiv(Value, 96, 72);
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
  FHandle := 0;
end;

destructor TPen.Destroy;
begin
  if FHandle <> 0 then
    DeleteObject(FHandle);
  inherited Destroy;
end;

procedure TPen.Assign(Source: TPersistent);
begin
  if Source is TPen then
  begin
    FColor := TPen(Source).FColor;
    FWidth := TPen(Source).FWidth;
    FStyle := TPen(Source).FStyle;
    UpdatePen;
  end
  else
    inherited Assign(Source);
end;

function TPen.GetHandle: HPEN;
var
  PenStyleCode: Integer;
  RGBCol: LongInt;
begin
  if FHandle = 0 then
  begin
    if FStyle = psClear then
      FHandle := GetStockObject(NULL_PEN)
    else
    begin
      RGBCol := ColorToRGB(FColor);
      if (FStyle = psSolid) and (FWidth <= 1) and (RGBCol = 0) then
        FHandle := GetStockObject(BLACK_PEN)
      else if (FStyle = psSolid) and (FWidth <= 1) and (RGBCol = $FFFFFF) then
        FHandle := GetStockObject(WHITE_PEN)
      else
      begin
        case FStyle of
          psDash: PenStyleCode := PS_DASH;
          psDot:  PenStyleCode := PS_DOT;
          else    PenStyleCode := PS_SOLID;
        end;
        FHandle := CreatePen(PenStyleCode, FWidth, RGBCol);
      end;
    end;
  end;
  Result := FHandle;
end;

procedure TPen.UpdatePen;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
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
  FBitmap := nil;
  FHandle := 0;
end;

destructor TBrush.Destroy;
begin
  FBitmap.Free;
  if FHandle <> 0 then
    DeleteObject(FHandle);
  inherited Destroy;
end;

procedure TBrush.Assign(Source: TPersistent);
begin
  if Source is TBrush then
  begin
    FColor := TBrush(Source).FColor;
    FStyle := TBrush(Source).FStyle;
    UpdateBrush;
  end
  else
    inherited Assign(Source);
end;

procedure TBrush.SetBitmap(Value: TBitmap);
begin
  if FBitmap = nil then
    FBitmap := TBitmap.Create;
  FBitmap.Assign(Value);
  UpdateBrush;
end;

function TBrush.GetHandle: HBRUSH;
var
  RGBCol: LongInt;
begin
  if FHandle = 0 then
  begin
    if (FBitmap <> nil) and (FBitmap.Handle <> 0) then
      FHandle := CreatePatternBrush(FBitmap.Handle)
    else if FStyle = bsClear then
      FHandle := GetStockObject(NULL_BRUSH)
    else
    begin
      RGBCol := ColorToRGB(FColor);
      if RGBCol = $FFFFFF then
        FHandle := GetStockObject(WHITE_BRUSH)
      else if RGBCol = 0 then
        FHandle := GetStockObject(BLACK_BRUSH)
      else
        FHandle := CreateSolidBrush(RGBCol);
    end;
  end;
  Result := FHandle;
end;

procedure TBrush.UpdateBrush;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
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
  if (FHandle <> 0) and (FHandle <> Value) then
  begin
    SelectObject(FHandle, GetStockObject(BLACK_PEN));
    SelectObject(FHandle, GetStockObject(WHITE_BRUSH));
    SelectObject(FHandle, GetStockObject(SYSTEM_FONT));
  end;
  FHandle := Value;
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

function TCanvas.GetPenPos: TPoint;
var
  Pt: WinTypes.POINT;
begin
  if FHandle <> 0 then
  begin
    GetCurrentPositionEx(FHandle, @Pt);
    Result.X := Pt.x;
    Result.Y := Pt.y;
    FPenPos := Result;
  end
  else
    Result := FPenPos;
end;

procedure TCanvas.SetPenPos(const Value: TPoint);
begin
  MoveTo(Value.X, Value.Y);
end;

procedure TCanvas.SetFont(Value: TFont);
begin
  FFont.Assign(Value);
end;

procedure TCanvas.SetPen(Value: TPen);
begin
  FPen.Assign(Value);
end;

procedure TCanvas.SetBrush(Value: TBrush);
begin
  FBrush.Assign(Value);
end;

procedure TCanvas.MoveTo(X, Y: Integer);
begin
  FPenPos.X := X;
  FPenPos.Y := Y;
  if FHandle <> 0 then
    WinProcs.MoveTo(FHandle, X, Y);
end;

procedure TCanvas.LineTo(X, Y: Integer);
begin
  FPenPos.X := X;
  FPenPos.Y := Y;
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

procedure TCanvas.RoundRect(X1, Y1, X2, Y2, X3, Y3: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.RoundRect(FHandle, X1, Y1, X2, Y2, X3, Y3);
  end;
end;

procedure TCanvas.Ellipse(X1, Y1, X2, Y2: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.Ellipse(FHandle, X1, Y1, X2, Y2);
  end;
end;

procedure TCanvas.Arc(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    WinProcs.Arc(FHandle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  end;
end;

procedure TCanvas.Chord(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.Chord(FHandle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  end;
end;

procedure TCanvas.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4: Integer);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FPen.Handle);
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.Pie(FHandle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
  end;
end;

procedure TCanvas.FloodFill(X, Y: Integer; Color: TColor; FillStyle: TFillStyle);
const
  FillStyles: array[TFillStyle] of Word = (FLOODFILLSURFACE, FLOODFILLBORDER);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FBrush.Handle);
    ExtFloodFill(FHandle, X, Y, ColorToRGB(Color), FillStyles[FillStyle]);
  end;
end;

procedure TCanvas.FillRect(const Rect: TRect);
begin
  if FHandle <> 0 then
  begin
    SelectObject(FHandle, FBrush.Handle);
    WinProcs.FillRect(FHandle, Rect, FBrush.Handle);
  end;
end;

procedure TCanvas.DrawFocusRect(const Rect: TRect);
begin
  if FHandle <> 0 then
    WinProcs.DrawFocusRect(FHandle, Rect);
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

procedure TCanvas.TextRect(Rect: TRect; X, Y: Integer; const Text: string);
begin
  if (FHandle <> 0) and (Length(Text) > 0) then
  begin
    SetTextColor(FHandle, ColorToRGB(FFont.Color));
    SetBkMode(FHandle, TRANSPARENT);
    if FFont.Handle <> 0 then
      SelectObject(FHandle, FFont.Handle);
    ExtTextOut(FHandle, X, Y, ETO_CLIPPED, @Rect, @Text[1], Length(Text), nil);
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
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmOpenRead);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TGraphic.SaveToFile(const Filename: string);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(Filename, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TGraphic.LoadFromStream(Stream: TStream);
begin
end;

procedure TGraphic.SaveToStream(Stream: TStream);
begin
end;

{ TIcon }

constructor TIcon.Create;
begin
  inherited Create;
  FHandle := 0;
  FMemoryImage := TMemoryStream.Create;
end;

destructor TIcon.Destroy;
begin
  FMemoryImage.Free;
  if FHandle <> 0 then
    DestroyIcon(FHandle);
  inherited Destroy;
end;

function TIcon.GetEmpty: Boolean;
begin
  Result := (FHandle = 0) and (FMemoryImage.Size = 0);
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
  if Source = nil then
  begin
    SetHandle(0);
    FMemoryImage.Clear;
  end
  else if Source is TIcon then
  begin
    SetHandle(CopyIcon(HInstance, TIcon(Source).Handle));
    FMemoryImage.Clear;
    if TIcon(Source).FMemoryImage.Size > 0 then
    begin
      TIcon(Source).FMemoryImage.Position := 0;
      FMemoryImage.CopyFrom(TIcon(Source).FMemoryImage, TIcon(Source).FMemoryImage.Size);
      FMemoryImage.Position := 0;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TIcon.Draw(ACanvas: TCanvas; const Rect: TRect);
begin
  if (ACanvas <> nil) and (ACanvas.Handle <> 0) and (FHandle <> 0) then
    DrawIcon(ACanvas.Handle, Rect.Left, Rect.Top, FHandle);
end;

procedure TIcon.LoadFromStream(Stream: TStream);
var
  Hdr: record
    idReserved: Word;
    idType: Word;
    idCount: Word;
  end;
  Entry: record
    bWidth, bHeight, bColorCount, bReserved: Byte;
    wPlanes, wBitCount: Word;
    dwBytesInRes, dwImageOffset: Longint;
  end;
  StartPos: Longint;
  TotalSize, I: Longint;
begin
  StartPos := Stream.Position;
  if Stream.Read(Hdr, SizeOf(Hdr)) = SizeOf(Hdr) then
  begin
    if (Hdr.idType = 1) and (Hdr.idCount > 0) then
    begin
      TotalSize := SizeOf(Hdr) + Hdr.idCount * SizeOf(Entry);
      for I := 1 to Hdr.idCount do
      begin
        if Stream.Read(Entry, SizeOf(Entry)) = SizeOf(Entry) then
        begin
          if Entry.dwImageOffset + Entry.dwBytesInRes > TotalSize then
            TotalSize := Entry.dwImageOffset + Entry.dwBytesInRes;
        end;
      end;
      Stream.Position := StartPos;
      FMemoryImage.Clear;
      FMemoryImage.CopyFrom(Stream, TotalSize);
      FMemoryImage.Position := 0;
    end
    else
      FMemoryImage.Clear;
  end;
end;

procedure TIcon.SaveToStream(Stream: TStream);
var
  Hdr: record
    idReserved: Word;
    idType: Word;
    idCount: Word;
  end;
begin
  if FMemoryImage.Size > 0 then
  begin
    FMemoryImage.Position := 0;
    Stream.CopyFrom(FMemoryImage, FMemoryImage.Size);
  end
  else
  begin
    Hdr.idReserved := 0;
    Hdr.idType := 1;
    Hdr.idCount := 0;
    Stream.Write(Hdr, SizeOf(Hdr));
  end;
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

procedure TBitmap.FreeImage;
begin
  if FHandle <> 0 then
  begin
    DeleteObject(FHandle);
    FHandle := 0;
  end;
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
var
  DC, SrcDC, DstDC: HDC;
  NewBmp, OldSrc, OldDst: HBITMAP;
begin
  if Source = nil then
  begin
    SetHandle(0);
    FWidth := 0;
    FHeight := 0;
  end
  else if Source is TBitmap then
  begin
    if (TBitmap(Source).FHandle <> 0) and (TBitmap(Source).Width > 0) and (TBitmap(Source).Height > 0) then
    begin
      DC := GetDC(0);
      SrcDC := CreateCompatibleDC(DC);
      DstDC := CreateCompatibleDC(DC);
      NewBmp := CreateCompatibleBitmap(DC, TBitmap(Source).Width, TBitmap(Source).Height);
      OldSrc := SelectObject(SrcDC, TBitmap(Source).FHandle);
      OldDst := SelectObject(DstDC, NewBmp);
      BitBlt(DstDC, 0, 0, TBitmap(Source).Width, TBitmap(Source).Height, SrcDC, 0, 0, SRCCOPY);
      SelectObject(SrcDC, OldSrc);
      SelectObject(DstDC, OldDst);
      DeleteDC(SrcDC);
      DeleteDC(DstDC);
      ReleaseDC(0, DC);
      SetHandle(NewBmp);
    end
    else
    begin
      SetHandle(0);
      FWidth := 0;
      FHeight := 0;
    end;
  end
  else
    inherited Assign(Source);
end;

procedure TBitmap.Draw(ACanvas: TCanvas; const Rect: TRect);
var
  MemDC: HDC;
  OldBmp: HBITMAP;
  W, H: Integer;
begin
  if (ACanvas <> nil) and (ACanvas.Handle <> 0) and (FHandle <> 0) then
  begin
    W := Rect.Right - Rect.Left;
    H := Rect.Bottom - Rect.Top;
    if (W <= 0) or (W > FWidth) then W := FWidth;
    if (H <= 0) or (H > FHeight) then H := FHeight;
    MemDC := CreateCompatibleDC(ACanvas.Handle);
    OldBmp := SelectObject(MemDC, FHandle);
    BitBlt(ACanvas.Handle, Rect.Left, Rect.Top, W, H, MemDC, 0, 0, SRCCOPY);
    SelectObject(MemDC, OldBmp);
    DeleteDC(MemDC);
  end;
end;

procedure TBitmap.LoadFromResourceName(Instance: THandle; const ResName: string);
var
  Buf: array[0..63] of Char;
begin
  StrPLCopy(Buf, ResName, 63);
  SetHandle(LoadBitmap(Instance, Buf));
end;

procedure TBitmap.DefineProperties(Filer: TFiler);
begin
  inherited DefineProperties(Filer);
  Filer.DefineBinaryProperty('Data', ReadData, WriteData, not Empty);
end;

procedure TBitmap.ReadData(Stream: TStream);
var
  StartPos, DataSize: LongInt;
  Sig: array[0..1] of Char;
begin
  StartPos := Stream.Position;
  if Stream.Size - StartPos < 14 then Exit;
  Stream.Read(Sig, 2);
  if (Sig[0] = 'B') and (Sig[1] = 'M') then
  begin
    Stream.Position := StartPos;
    LoadFromStream(Stream);
  end
  else
  begin
    { Delphi 1.0 DFM TBitmap.Data zaczyna sie 4-bajtowym rozmiarem przed 'BM' }
    Stream.Position := StartPos;
    Stream.Read(DataSize, SizeOf(DataSize));
    if (DataSize > 14) and (Stream.Size - Stream.Position >= 14) then
      LoadFromStream(Stream);
  end;
end;

procedure TBitmap.WriteData(Stream: TStream);
begin
  SaveToStream(Stream);
end;

procedure TBitmap.LoadFromStream(Stream: TStream);
var
  FileHdr: TBitmapFileHeader;
  DataLen: LongInt;
  Buf: PChar;
  DC: HDC;
  H: HBITMAP;
  BitsOffset: LongInt;
begin
  if Stream.Read(FileHdr, SizeOf(FileHdr)) <> SizeOf(FileHdr) then Exit;
  if FileHdr.bfType <> $4D42 then Exit; { 'BM' }
  DataLen := Stream.Size - Stream.Position;
  if (DataLen < SizeOf(TBitmapInfoHeader)) or (DataLen > 65000) then Exit;
  GetMem(Buf, DataLen);
  try
    if Stream.Read(Buf^, DataLen) = DataLen then
    begin
      BitsOffset := FileHdr.bfOffBits - SizeOf(FileHdr);
      if (BitsOffset >= SizeOf(TBitmapInfoHeader)) and (BitsOffset < DataLen) then
      begin
        DC := GetDC(0);
        try
          H := CreateDIBitmap(DC, PBitmapInfoHeader(Buf)^, CBM_INIT,
            Buf + BitsOffset, PBitmapInfo(Buf)^, DIB_RGB_COLORS);
          if H <> 0 then
            SetHandle(H);
        finally
          ReleaseDC(0, DC);
        end;
      end;
    end;
  finally
    FreeMem(Buf, DataLen);
  end;
end;

procedure TBitmap.SaveToStream(Stream: TStream);
begin
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
  if Source = nil then
  begin
    Bitmap.Assign(nil);
    Icon.Assign(nil);
  end
  else if Source is TPicture then
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

initialization
  RegisterIntegerConsts(TypeInfo(TColor), @IdentToColorStream, @ColorToIdentStream);

end.