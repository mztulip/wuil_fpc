unit Grids;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, Messages, SysUtils, StdCtrls;

type
  EGridError = class(Exception);

  TGridDrawingStyle = (gdsClassic, gdsThemed);
  TGridDrawState = set of (gdSelected, gdFocused, gdFixed);
  TGridOption = (goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine,
    goRangeSelect, goDrawFocusSelected, goRowSizing, goColSizing,
    goRowMoving, goColMoving, goEditing, goTabs, goRowSelect,
    goAlwaysShowEditor, goThumbTracking);
  TGridOptions = set of TGridOption;
  TGridState = (gsNormal, gsSelecting, gsRowSizing, gsColSizing, gsRowMoving, gsColMoving);
  TGridCoord = record
    X: Longint;
    Y: Longint;
  end;
  TGridRect = record
    Left, Top, Right, Bottom: Longint;
  end;
  TScrollStyle = (ssNone, ssHorizontal, ssVertical, ssBoth);

  TSelectCellEvent = procedure(Sender: TObject; ACol, ARow: Longint; var CanSelect: Boolean) of object;
  TDrawCellEvent = procedure(Sender: TObject; ACol, ARow: Longint; ARect: TRect; State: TGridDrawState) of object;

  TCustomGrid = class(TWinControl)
  private
    FColCount, FRowCount: Longint;
    FFixedCols, FFixedRows: Integer;
    FDefaultColWidth, FDefaultRowHeight: Integer;
    FGridLineWidth: Integer;
    FOptions: TGridOptions;
    FScrollBars: TScrollStyle;
    FCol, FRow: Longint;
    FLeftCol, FTopRow: Longint;
    FCanvas: TCanvas;
    FDefaultDrawing: Boolean;
    FOnSelectCell: TSelectCellEvent;
    FOnDrawCell: TDrawCellEvent;
    FOnTopLeftChanged: TNotifyEvent;
    function GetColWidth(Index: Longint): Integer;
    procedure SetColWidth(Index: Longint; Value: Integer);
    function GetRowHeight(Index: Longint): Integer;
    procedure SetRowHeight(Index: Longint; Value: Integer);
    function GetVisibleColCount: Integer;
    function GetVisibleRowCount: Integer;
    procedure SetCol(Value: Longint);
    procedure SetRow(Value: Longint);
    procedure SetColCount(Value: Longint);
    procedure SetRowCount(Value: Longint);
    procedure SetLeftCol(Value: Longint);
    procedure SetTopRow(Value: Longint);
    procedure SetFixedCols(Value: Integer);
    procedure SetFixedRows(Value: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SizeChanged(OldColCount, OldRowCount: Longint); virtual;
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); virtual;
    function SelectCell(ACol, ARow: Longint): Boolean; virtual;
    procedure TopLeftChanged; virtual;
    procedure Paint; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure InvalidateCell(ACol, ARow: Longint);
    procedure InvalidateCol(ACol: Longint);
    procedure InvalidateRow(ARow: Longint);
    property ColCount: Longint read FColCount write SetColCount default 5;
    property RowCount: Longint read FRowCount write SetRowCount default 5;
    property FixedCols: Integer read FFixedCols write SetFixedCols default 1;
    property FixedRows: Integer read FFixedRows write SetFixedRows default 1;
    property DefaultColWidth: Integer read FDefaultColWidth write FDefaultColWidth default 64;
    property DefaultRowHeight: Integer read FDefaultRowHeight write FDefaultRowHeight default 24;
    property GridLineWidth: Integer read FGridLineWidth write FGridLineWidth default 1;
    property LeftCol: Longint read FLeftCol write SetLeftCol;
    property TopRow: Longint read FTopRow write SetTopRow;
    property VisibleColCount: Integer read GetVisibleColCount;
    property VisibleRowCount: Integer read GetVisibleRowCount;
    property Options: TGridOptions read FOptions write FOptions;
    property ScrollBars: TScrollStyle read FScrollBars write FScrollBars default ssBoth;
    property DefaultDrawing: Boolean read FDefaultDrawing write FDefaultDrawing default True;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CellRect(ACol, ARow: Longint): TRect;
    procedure MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
    function MouseCoord(X, Y: Integer): TGridCoord;
    property Canvas: TCanvas read FCanvas;
    property Col: Longint read FCol write SetCol;
    property Row: Longint read FRow write SetRow;
    property ColWidths[Index: Longint]: Integer read GetColWidth write SetColWidth;
    property RowHeights[Index: Longint]: Integer read GetRowHeight write SetRowHeight;
  end;

  TDrawGrid = class(TCustomGrid)
  published
    property Align;
    property ColCount;
    property RowCount;
    property FixedCols;
    property FixedRows;
    property DefaultColWidth;
    property DefaultRowHeight;
    property GridLineWidth;
    property Options;
    property ScrollBars;
    property DefaultDrawing;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
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
    property OnDrawCell: TDrawCellEvent read FOnDrawCell write FOnDrawCell;
    property OnSelectCell: TSelectCellEvent read FOnSelectCell write FOnSelectCell;
    property OnTopLeftChanged: TNotifyEvent read FOnTopLeftChanged write FOnTopLeftChanged;
  end;

  TStringGrid = class(TDrawGrid)
  private
    FRows: TList;
    function GetCells(ACol, ARow: Integer): string;
    procedure SetCells(ACol, ARow: Integer; const Value: string);
    function GetObjects(ACol, ARow: Integer): TObject;
    procedure SetObjects(ACol, ARow: Integer; Value: TObject);
    function EnsureRow(ARow: Integer): TStrings;
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Cells[ACol, ARow: Integer]: string read GetCells write SetCells;
    property Objects[ACol, ARow: Integer]: TObject read GetObjects write SetObjects;
  end;

implementation

{ TCustomGrid }

constructor TCustomGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FColCount := 5;
  FRowCount := 5;
  FFixedCols := 1;
  FFixedRows := 1;
  FDefaultColWidth := 64;
  FDefaultRowHeight := 24;
  FGridLineWidth := 1;
  FCol := 0;
  FRow := 0;
  FLeftCol := 0;
  FTopRow := 0;
  FDefaultDrawing := True;
  FOptions := [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];
  FScrollBars := ssBoth;
  FCanvas := TCanvas.Create;
  Color := clWindow;
  Width := 300;
  Height := 150;
end;

destructor TCustomGrid.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TCustomGrid.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CHILD or WS_VISIBLE or WS_TABSTOP or WS_BORDER;
  if FScrollBars in [ssHorizontal, ssBoth] then
    Params.Style := Params.Style or WS_HSCROLL;
  if FScrollBars in [ssVertical, ssBoth] then
    Params.Style := Params.Style or WS_VSCROLL;
end;

function TCustomGrid.GetColWidth(Index: Longint): Integer;
begin
  Result := FDefaultColWidth;
end;

procedure TCustomGrid.SetColWidth(Index: Longint; Value: Integer);
begin
  Invalidate;
end;

function TCustomGrid.GetRowHeight(Index: Longint): Integer;
begin
  Result := FDefaultRowHeight;
end;

procedure TCustomGrid.SetRowHeight(Index: Longint; Value: Integer);
begin
  Invalidate;
end;

function TCustomGrid.GetVisibleColCount: Integer;
begin
  if FDefaultColWidth + FGridLineWidth > 0 then
    Result := Width div (FDefaultColWidth + FGridLineWidth)
  else
    Result := 1;
  if Result > FColCount then
    Result := FColCount;
end;

function TCustomGrid.GetVisibleRowCount: Integer;
begin
  if FDefaultRowHeight + FGridLineWidth > 0 then
    Result := Height div (FDefaultRowHeight + FGridLineWidth)
  else
    Result := 1;
  if Result > FRowCount then
    Result := FRowCount;
end;

procedure TCustomGrid.SetCol(Value: Longint);
begin
  if (Value >= 0) and (Value < FColCount) and (FCol <> Value) then
  begin
    FCol := Value;
    Invalidate;
  end;
end;

procedure TCustomGrid.SetRow(Value: Longint);
begin
  if (Value >= 0) and (Value < FRowCount) and (FRow <> Value) then
  begin
    FRow := Value;
    Invalidate;
  end;
end;

procedure TCustomGrid.SetColCount(Value: Longint);
var
  Old: Longint;
begin
  if Value < 1 then Value := 1;
  if FColCount <> Value then
  begin
    Old := FColCount;
    FColCount := Value;
    SizeChanged(Old, FRowCount);
    Invalidate;
  end;
end;

procedure TCustomGrid.SetRowCount(Value: Longint);
var
  Old: Longint;
begin
  if Value < 1 then Value := 1;
  if FRowCount <> Value then
  begin
    Old := FRowCount;
    FRowCount := Value;
    SizeChanged(FColCount, Old);
    Invalidate;
  end;
end;

procedure TCustomGrid.SetLeftCol(Value: Longint);
begin
  if FLeftCol <> Value then
  begin
    FLeftCol := Value;
    TopLeftChanged;
    Invalidate;
  end;
end;

procedure TCustomGrid.SetTopRow(Value: Longint);
begin
  if FTopRow <> Value then
  begin
    FTopRow := Value;
    TopLeftChanged;
    Invalidate;
  end;
end;

procedure TCustomGrid.SetFixedCols(Value: Integer);
begin
  if FFixedCols <> Value then
  begin
    FFixedCols := Value;
    Invalidate;
  end;
end;

procedure TCustomGrid.SetFixedRows(Value: Integer);
begin
  if FFixedRows <> Value then
  begin
    FFixedRows := Value;
    Invalidate;
  end;
end;

procedure TCustomGrid.SizeChanged(OldColCount, OldRowCount: Longint);
begin
end;

procedure TCustomGrid.TopLeftChanged;
begin
  if Assigned(FOnTopLeftChanged) then
    FOnTopLeftChanged(Self);
end;

function TCustomGrid.SelectCell(ACol, ARow: Longint): Boolean;
begin
  Result := True;
  if Assigned(FOnSelectCell) then
    FOnSelectCell(Self, ACol, ARow, Result);
end;

function TCustomGrid.CellRect(ACol, ARow: Longint): TRect;
var
  X, Y: Integer;
  StepX, StepY: Integer;
begin
  StepX := FDefaultColWidth + FGridLineWidth;
  StepY := FDefaultRowHeight + FGridLineWidth;

  if ACol < FFixedCols then
    X := ACol * StepX
  else
    X := FFixedCols * StepX + (ACol - FLeftCol) * StepX;

  if ARow < FFixedRows then
    Y := ARow * StepY
  else
    Y := FFixedRows * StepY + (ARow - FTopRow) * StepY;

  Result.Left := X;
  Result.Top := Y;
  Result.Right := X + FDefaultColWidth;
  Result.Bottom := Y + FDefaultRowHeight;
end;

procedure TCustomGrid.MouseToCell(X, Y: Integer; var ACol, ARow: Longint);
var
  StepX, StepY: Integer;
begin
  StepX := FDefaultColWidth + FGridLineWidth;
  StepY := FDefaultRowHeight + FGridLineWidth;
  if StepX > 0 then
    ACol := FLeftCol + (X div StepX)
  else
    ACol := 0;
  if StepY > 0 then
    ARow := FTopRow + (Y div StepY)
  else
    ARow := 0;
  if ACol >= FColCount then ACol := -1;
  if ARow >= FRowCount then ARow := -1;
end;

function TCustomGrid.MouseCoord(X, Y: Integer): TGridCoord;
var
  ACol, ARow: Longint;
begin
  MouseToCell(X, Y, ACol, ARow);
  Result.X := ACol;
  Result.Y := ARow;
end;

procedure TCustomGrid.InvalidateCell(ACol, ARow: Longint);
var
  R: TRect;
begin
  if HandleAllocated then
  begin
    R := CellRect(ACol, ARow);
    InvalidateRect(FHandle, @R, False);
  end;
end;

procedure TCustomGrid.InvalidateCol(ACol: Longint);
begin
  Invalidate;
end;

procedure TCustomGrid.InvalidateRow(ARow: Longint);
begin
  Invalidate;
end;

procedure TCustomGrid.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  C, R: Longint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  MouseToCell(X, Y, C, R);
  if (C >= 0) and (R >= 0) then
  begin
    if SelectCell(C, R) then
    begin
      FCol := C;
      FRow := R;
      Invalidate;
    end;
  end;
end;

procedure TCustomGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
begin
  if Assigned(FOnDrawCell) then
    FOnDrawCell(Self, ACol, ARow, ARect, AState);
end;

procedure TCustomGrid.Paint;
var
  DC: HDC;
  PS: PAINTSTRUCT;
  C, R: Longint;
  CRect: TRect;
  State: TGridDrawState;
  VisCols, VisRows: Integer;
begin
  DC := BeginPaint(FHandle, PS);
  try
    FCanvas.Handle := DC;

    FCanvas.Brush.Color := Color;
    FCanvas.FillRect(ClientRect);

    VisCols := GetVisibleColCount;
    VisRows := GetVisibleRowCount;

    for R := 0 to VisRows - 1 do
    begin
      for C := 0 to VisCols - 1 do
      begin
        if (C < FColCount) and (R < FRowCount) then
        begin
          CRect := CellRect(C, R);
          State := [];
          if (C < FFixedCols) or (R < FFixedRows) then
            Include(State, gdFixed);
          if (C = FCol) and (R = FRow) then
          begin
            Include(State, gdSelected);
            Include(State, gdFocused);
          end;

          if FDefaultDrawing then
          begin
            if gdFixed in State then
              FCanvas.Brush.Color := clBtnFace
            else if gdSelected in State then
              FCanvas.Brush.Color := clHighlight
            else
              FCanvas.Brush.Color := Color;
            FCanvas.FillRect(CRect);
          end;

          DrawCell(C, R, CRect, State);

          if (goVertLine in FOptions) or (goHorzLine in FOptions) then
          begin
            FCanvas.Pen.Color := clBtnShadow;
            if goVertLine in FOptions then
            begin
              FCanvas.MoveTo(CRect.Right, CRect.Top);
              FCanvas.LineTo(CRect.Right, CRect.Bottom);
            end;
            if goHorzLine in FOptions then
            begin
              FCanvas.MoveTo(CRect.Left, CRect.Bottom);
              FCanvas.LineTo(CRect.Right, CRect.Bottom);
            end;
          end;
        end;
      end;
    end;
  finally
    FCanvas.Handle := 0;
    EndPaint(FHandle, PS);
  end;
end;

{ TStringGrid }

constructor TStringGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRows := TList.Create;
end;

destructor TStringGrid.Destroy;
var
  I: Integer;
begin
  for I := 0 to FRows.Count - 1 do
    TObject(FRows[I]).Free;
  FRows.Free;
  inherited Destroy;
end;

function TStringGrid.EnsureRow(ARow: Integer): TStrings;
var
  SL: TStringList;
begin
  while FRows.Count <= ARow do
  begin
    SL := TStringList.Create;
    FRows.Add(SL);
  end;
  Result := TStrings(FRows[ARow]);
end;

function TStringGrid.GetCells(ACol, ARow: Integer): string;
var
  RowStrings: TStrings;
begin
  Result := '';
  if (ARow >= 0) and (ARow < FRows.Count) then
  begin
    RowStrings := TStrings(FRows[ARow]);
    if (RowStrings <> nil) and (ACol >= 0) and (ACol < RowStrings.Count) then
      Result := RowStrings[ACol];
  end;
end;

procedure TStringGrid.SetCells(ACol, ARow: Integer; const Value: string);
var
  RowStrings: TStrings;
begin
  if (ARow >= 0) and (ACol >= 0) then
  begin
    RowStrings := EnsureRow(ARow);
    while RowStrings.Count <= ACol do
      RowStrings.Add('');
    RowStrings[ACol] := Value;
    Invalidate;
  end;
end;

function TStringGrid.GetObjects(ACol, ARow: Integer): TObject;
var
  RowStrings: TStrings;
begin
  Result := nil;
  if (ARow >= 0) and (ARow < FRows.Count) then
  begin
    RowStrings := TStrings(FRows[ARow]);
    if (RowStrings <> nil) and (ACol >= 0) and (ACol < RowStrings.Count) then
      Result := RowStrings.Objects[ACol];
  end;
end;

procedure TStringGrid.SetObjects(ACol, ARow: Integer; Value: TObject);
var
  RowStrings: TStrings;
begin
  if (ARow >= 0) and (ACol >= 0) then
  begin
    RowStrings := EnsureRow(ARow);
    while RowStrings.Count <= ACol do
      RowStrings.Add('');
    RowStrings.Objects[ACol] := Value;
  end;
end;

procedure TStringGrid.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  S: string;
begin
  inherited DrawCell(ACol, ARow, ARect, AState);
  if FDefaultDrawing then
  begin
    S := GetCells(ACol, ARow);
    if S <> '' then
      FCanvas.TextOut(ARect.Left + 2, ARect.Top + 2, S);
  end;
end;

initialization
  RegisterClasses([TDrawGrid, TStringGrid]);

end.
