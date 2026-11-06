unit Outline;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, Messages, SysUtils, Grids, StdCtrls;

type
  EOutlineError = class(Exception);

  TOutlineType = (otStandard, otOwnerDraw);
  TOutlineStyle = (osText, osPlusMinusText, osPictureText, osPlusMinusPictureText, osTreeText, osTreePictureText);
  TOutlineOption = (ooDrawTreeRoot, ooDrawFocusRect, ooStretchBitmaps);
  TOutlineOptions = set of TOutlineOption;
  TAttachMode = (oaAdd, oaAddChild, oaInsert);
  TOutlineBitmapStyle = (obPlus, obMinus, obOpen, obClosed, obLeaf);

  TOutlineNode = class;
  TCustomOutline = class;
  TOutline = class;

  TOutlineNodeEvent = procedure(Sender: TObject; Index: Longint) of object;

  TOutlineNode = class(TPersistent)
  private
    FOwner: TCustomOutline;
    FText: string;
    FData: Pointer;
    FParent: TOutlineNode;
    FExpanded: Boolean;
    FChildren: TList;
    function GetLevel: Integer;
    function GetIndex: Longint;
    function GetFullPath: string;
    function GetHasItems: Boolean;
    procedure SetExpanded(Value: Boolean);
    procedure SetText(const Value: string);
  public
    constructor Create(AOwner: TCustomOutline);
    destructor Destroy; override;

    procedure Expand;
    procedure Collapse;
    procedure FullExpand;
    procedure FullCollapse;
    procedure MoveTo(Destination: Longint; AttachMode: TAttachMode);

    function GetFirstChild: Longint;
    function GetLastChild: Longint;
    function GetNextChild(Value: Longint): Longint;
    function GetPrevChild(Value: Longint): Longint;

    property Text: string read FText write SetText;
    property Data: Pointer read FData write FData;
    property Parent: TOutlineNode read FParent;
    property Level: Integer read GetLevel;
    property Index: Longint read GetIndex;
    property HasItems: Boolean read GetHasItems;
    property Expanded: Boolean read FExpanded write SetExpanded;
    property FullPath: string read GetFullPath;
  end;

  TCustomOutline = class(TCustomGrid)
  private
    FRootNodes: TList;       // Top-level TOutlineNode instances
    FNodes: TList;           // All nodes in preorder
    FVisibleNodes: TList;    // Currently visible nodes
    FItemSeparator: Char;
    FStyle: TOutlineType;
    FOutlineStyle: TOutlineStyle;
    FOutlineOptions: TOutlineOptions;
    FSelectedItem: Longint;
    FPicturePlus: TBitmap;
    FPictureMinus: TBitmap;
    FPictureOpen: TBitmap;
    FPictureClosed: TBitmap;
    FPictureLeaf: TBitmap;
    FLinesAtRoot: Boolean;
    FUpdateCount: Integer;

    FOnExpand: TOutlineNodeEvent;
    FOnCollapse: TOutlineNodeEvent;
    FOnDrawItem: TDrawItemEvent;

    procedure RebuildTree;
    procedure RebuildVisible;
    function GetItemCount: Longint;
    function GetNode(Index: Longint): TOutlineNode;
    procedure SetSelectedItem(Value: Longint);
    procedure SetItemHeight(Value: Integer);
    function GetItemHeight: Integer;
  protected
    procedure DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState); override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;

    property OutlineType: TOutlineType read FStyle write FStyle default otStandard;
    property Style: TOutlineType read FStyle write FStyle default otStandard;
    property OutlineStyle: TOutlineStyle read FOutlineStyle write FOutlineStyle default osTreePictureText;
    property Options: TOutlineOptions read FOutlineOptions write FOutlineOptions;
    property ItemSeparator: Char read FItemSeparator write FItemSeparator default '\';
    property ItemHeight: Integer read GetItemHeight write SetItemHeight default 16;
    property LinesAtRoot: Boolean read FLinesAtRoot write FLinesAtRoot default False;
    property PicturePlus: TBitmap read FPicturePlus write FPicturePlus;
    property PictureMinus: TBitmap read FPictureMinus write FPictureMinus;
    property PictureOpen: TBitmap read FPictureOpen write FPictureOpen;
    property PictureClosed: TBitmap read FPictureClosed write FPictureClosed;
    property PictureLeaf: TBitmap read FPictureLeaf write FPictureLeaf;

    property OnExpand: TOutlineNodeEvent read FOnExpand write FOnExpand;
    property OnCollapse: TOutlineNodeEvent read FOnCollapse write FOnCollapse;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    function Add(Index: Longint; const Text: string): Longint;
    function AddObject(Index: Longint; const Text: string; const Data: Pointer): Longint;
    function AddChild(Index: Longint; const Text: string): Longint;
    function AddChildObject(Index: Longint; const Text: string; const Data: Pointer): Longint;
    function Insert(Index: Longint; const Text: string): Longint;
    function InsertObject(Index: Longint; const Text: string; const Data: Pointer): Longint;
    procedure Delete(Index: Longint);
    procedure Clear;
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure SetUpdateState(Updating: Boolean);
    procedure FullExpand;
    procedure FullCollapse;

    function GetItem(X, Y: Integer): Longint;
    function GetTextItem(const S: string): Longint;
    function GetDataItem(const Value: Pointer): Longint;

    property ItemCount: Longint read GetItemCount;
    property Items[Index: Longint]: TOutlineNode read GetNode; default;
    property SelectedItem: Longint read FSelectedItem write SetSelectedItem;
  end;

  TOutline = class(TCustomOutline)
  published
    property Align;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ItemHeight;
    property ItemSeparator;
    property LinesAtRoot;
    property Options;
    property OutlineStyle;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PictureClosed;
    property PictureLeaf;
    property PictureMinus;
    property PictureOpen;
    property PicturePlus;
    property PopupMenu;
    property ScrollBars;
    property ShowHint;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;

    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnExpand;
    property OnCollapse;
  end;

implementation

{ TOutlineNode }

constructor TOutlineNode.Create(AOwner: TCustomOutline);
begin
  inherited Create;
  FOwner := AOwner;
  FText := '';
  FData := nil;
  FParent := nil;
  FExpanded := False;
  FChildren := TList.Create;
end;

destructor TOutlineNode.Destroy;
var
  i: Integer;
begin
  if FChildren <> nil then
  begin
    for i := FChildren.Count - 1 downto 0 do
      TOutlineNode(FChildren[i]).Free;
    FChildren.Free;
    FChildren := nil;
  end;
  inherited Destroy;
end;

function TOutlineNode.GetLevel: Integer;
var
  p: TOutlineNode;
begin
  Result := 1;
  p := FParent;
  while p <> nil do
  begin
    Inc(Result);
    p := p.FParent;
  end;
end;

function TOutlineNode.GetIndex: Longint;
begin
  if FOwner <> nil then
    Result := FOwner.FNodes.IndexOf(Self) + 1
  else
    Result := 0;
end;

function TOutlineNode.GetFullPath: string;
begin
  if FParent = nil then
    Result := FText
  else
    Result := FParent.GetFullPath + FOwner.FItemSeparator + FText;
end;

function TOutlineNode.GetHasItems: Boolean;
begin
  Result := (FChildren <> nil) and (FChildren.Count > 0);
end;

procedure TOutlineNode.SetExpanded(Value: Boolean);
begin
  if FExpanded <> Value then
  begin
    if Value then
      Expand
    else
      Collapse;
  end;
end;

procedure TOutlineNode.SetText(const Value: string);
begin
  if FText <> Value then
  begin
    FText := Value;
    if FOwner <> nil then
      FOwner.Invalidate;
  end;
end;

procedure TOutlineNode.Expand;
begin
  if not FExpanded then
  begin
    FExpanded := True;
    if FOwner <> nil then
    begin
      FOwner.RebuildVisible;
      if Assigned(FOwner.FOnExpand) then
        FOwner.FOnExpand(FOwner, Index);
    end;
  end;
end;

procedure TOutlineNode.Collapse;
begin
  if FExpanded then
  begin
    FExpanded := False;
    if FOwner <> nil then
    begin
      FOwner.RebuildVisible;
      if Assigned(FOwner.FOnCollapse) then
        FOwner.FOnCollapse(FOwner, Index);
    end;
  end;
end;

procedure TOutlineNode.FullExpand;
var
  i: Integer;
begin
  Expand;
  if FChildren <> nil then
    for i := 0 to FChildren.Count - 1 do
      TOutlineNode(FChildren[i]).FullExpand;
end;

procedure TOutlineNode.FullCollapse;
var
  i: Integer;
begin
  if FChildren <> nil then
    for i := 0 to FChildren.Count - 1 do
      TOutlineNode(FChildren[i]).FullCollapse;
  Collapse;
end;

procedure TOutlineNode.MoveTo(Destination: Longint; AttachMode: TAttachMode);
var
  DestNode: TOutlineNode;
  TargetList: TList;
  InsertIdx: Integer;
begin
  if FOwner = nil then Exit;

  // Detach from current parent
  if FParent <> nil then
    FParent.FChildren.Remove(Self)
  else
    FOwner.FRootNodes.Remove(Self);

  DestNode := nil;
  if (Destination > 0) and (Destination <= FOwner.FNodes.Count) then
    DestNode := FOwner.Items[Destination];

  case AttachMode of
    oaAddChild:
      begin
        if DestNode <> nil then
        begin
          FParent := DestNode;
          DestNode.FChildren.Add(Self);
        end
        else
        begin
          FParent := nil;
          FOwner.FRootNodes.Add(Self);
        end;
      end;
    oaAdd:
      begin
        if DestNode <> nil then
        begin
          FParent := DestNode.FParent;
          if FParent <> nil then
            TargetList := FParent.FChildren
          else
            TargetList := FOwner.FRootNodes;
          InsertIdx := TargetList.IndexOf(DestNode);
          if InsertIdx >= 0 then
            TargetList.Insert(InsertIdx + 1, Self)
          else
            TargetList.Add(Self);
        end
        else
        begin
          FParent := nil;
          FOwner.FRootNodes.Add(Self);
        end;
      end;
    oaInsert:
      begin
        if DestNode <> nil then
        begin
          FParent := DestNode.FParent;
          if FParent <> nil then
            TargetList := FParent.FChildren
          else
            TargetList := FOwner.FRootNodes;
          InsertIdx := TargetList.IndexOf(DestNode);
          if InsertIdx >= 0 then
            TargetList.Insert(InsertIdx, Self)
          else
            TargetList.Add(Self);
        end
        else
        begin
          FParent := nil;
          FOwner.FRootNodes.Insert(0, Self);
        end;
      end;
  end;

  FOwner.RebuildTree;
end;

function TOutlineNode.GetFirstChild: Longint;
begin
  if HasItems then
    Result := TOutlineNode(FChildren[0]).Index
  else
    Result := 0;
end;

function TOutlineNode.GetLastChild: Longint;
begin
  if HasItems then
    Result := TOutlineNode(FChildren[FChildren.Count - 1]).Index
  else
    Result := 0;
end;

function TOutlineNode.GetNextChild(Value: Longint): Longint;
var
  idx: Integer;
  node: TOutlineNode;
begin
  Result := 0;
  if (FOwner <> nil) and (Value > 0) and (Value <= FOwner.FNodes.Count) then
  begin
    node := FOwner.Items[Value];
    idx := FChildren.IndexOf(node);
    if (idx >= 0) and (idx < FChildren.Count - 1) then
      Result := TOutlineNode(FChildren[idx + 1]).Index;
  end;
end;

function TOutlineNode.GetPrevChild(Value: Longint): Longint;
var
  idx: Integer;
  node: TOutlineNode;
begin
  Result := 0;
  if (FOwner <> nil) and (Value > 0) and (Value <= FOwner.FNodes.Count) then
  begin
    node := FOwner.Items[Value];
    idx := FChildren.IndexOf(node);
    if idx > 0 then
      Result := TOutlineNode(FChildren[idx - 1]).Index;
  end;
end;

{ TCustomOutline }

constructor TCustomOutline.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FRootNodes := TList.Create;
  FNodes := TList.Create;
  FVisibleNodes := TList.Create;

  ColCount := 1;
  RowCount := 0;
  FixedCols := 0;
  FixedRows := 0;
  DefaultColWidth := 200;
  DefaultRowHeight := 18;
  GridLineWidth := 0;
  DefaultDrawing := False;

  FItemSeparator := '\';
  FStyle := otStandard;
  FOutlineStyle := osTreePictureText;
  FOutlineOptions := [ooDrawTreeRoot, ooDrawFocusRect];
  FSelectedItem := 0;
  FLinesAtRoot := False;

  FPicturePlus := TBitmap.Create;
  FPictureMinus := TBitmap.Create;
  FPictureOpen := TBitmap.Create;
  FPictureClosed := TBitmap.Create;
  FPictureLeaf := TBitmap.Create;
end;

destructor TCustomOutline.Destroy;
begin
  Clear;
  FRootNodes.Free;
  FNodes.Free;
  FVisibleNodes.Free;

  FPicturePlus.Free;
  FPictureMinus.Free;
  FPictureOpen.Free;
  FPictureClosed.Free;
  FPictureLeaf.Free;

  inherited Destroy;
end;

procedure TCustomOutline.RebuildTree;

  procedure AddBranch(node: TOutlineNode);
  var
    i: Integer;
  begin
    FNodes.Add(node);
    if node.FChildren <> nil then
      for i := 0 to node.FChildren.Count - 1 do
        AddBranch(TOutlineNode(node.FChildren[i]));
  end;

var
  i: Integer;
begin
  if FUpdateCount > 0 then Exit;
  FNodes.Clear;
  for i := 0 to FRootNodes.Count - 1 do
    AddBranch(TOutlineNode(FRootNodes[i]));
  RebuildVisible;
end;

procedure TCustomOutline.RebuildVisible;

  procedure AddVisibleBranch(node: TOutlineNode);
  var
    i: Integer;
  begin
    FVisibleNodes.Add(node);
    if node.FExpanded and (node.FChildren <> nil) then
      for i := 0 to node.FChildren.Count - 1 do
        AddVisibleBranch(TOutlineNode(node.FChildren[i]));
  end;

var
  i: Integer;
begin
  FVisibleNodes.Clear;
  for i := 0 to FRootNodes.Count - 1 do
    AddVisibleBranch(TOutlineNode(FRootNodes[i]));
  RowCount := FVisibleNodes.Count;
  Invalidate;
end;

function TCustomOutline.GetItemCount: Longint;
begin
  Result := FNodes.Count;
end;

function TCustomOutline.GetNode(Index: Longint): TOutlineNode;
begin
  if (Index >= 1) and (Index <= FNodes.Count) then
    Result := TOutlineNode(FNodes[Index - 1])
  else
    Result := nil;
end;

procedure TCustomOutline.SetSelectedItem(Value: Longint);
var
  node: TOutlineNode;
  visIdx: Integer;
begin
  if FSelectedItem <> Value then
  begin
    FSelectedItem := Value;
    if (Value > 0) and (Value <= FNodes.Count) then
    begin
      node := Items[Value];
      visIdx := FVisibleNodes.IndexOf(node);
      if visIdx >= 0 then
        Row := visIdx;
    end;
    Invalidate;
  end;
end;

function TCustomOutline.GetItemHeight: Integer;
begin
  Result := DefaultRowHeight;
end;

procedure TCustomOutline.SetItemHeight(Value: Integer);
begin
  DefaultRowHeight := Value;
end;

function TCustomOutline.AddChildObject(Index: Longint; const Text: string; const Data: Pointer): Longint;
var
  ParentNode, NewNode: TOutlineNode;
begin
  NewNode := TOutlineNode.Create(Self);
  NewNode.FText := Text;
  NewNode.FData := Data;

  if (Index > 0) and (Index <= FNodes.Count) then
  begin
    ParentNode := Items[Index];
    NewNode.FParent := ParentNode;
    ParentNode.FChildren.Add(NewNode);
  end
  else
  begin
    NewNode.FParent := nil;
    FRootNodes.Add(NewNode);
  end;

  if FUpdateCount = 0 then
    RebuildTree
  else
    FNodes.Add(NewNode);
  Result := NewNode.Index;
end;

function TCustomOutline.AddChild(Index: Longint; const Text: string): Longint;
begin
  Result := AddChildObject(Index, Text, nil);
end;

function TCustomOutline.AddObject(Index: Longint; const Text: string; const Data: Pointer): Longint;
var
  DestNode, NewNode: TOutlineNode;
  TargetList: TList;
  InsertIdx: Integer;
begin
  if (Index > 0) and (Index <= FNodes.Count) then
  begin
    DestNode := Items[Index];
    NewNode := TOutlineNode.Create(Self);
    NewNode.FText := Text;
    NewNode.FData := Data;
    NewNode.FParent := DestNode.FParent;
    if DestNode.FParent <> nil then
      TargetList := DestNode.FParent.FChildren
    else
      TargetList := FRootNodes;
    InsertIdx := TargetList.IndexOf(DestNode);
    if InsertIdx >= 0 then
      TargetList.Insert(InsertIdx + 1, NewNode)
    else
      TargetList.Add(NewNode);
    if FUpdateCount = 0 then
      RebuildTree
    else
      FNodes.Add(NewNode);
    Result := NewNode.Index;
  end
  else
    Result := AddChildObject(0, Text, Data);
end;

function TCustomOutline.Add(Index: Longint; const Text: string): Longint;
begin
  Result := AddObject(Index, Text, nil);
end;

function TCustomOutline.InsertObject(Index: Longint; const Text: string; const Data: Pointer): Longint;
var
  DestNode, NewNode: TOutlineNode;
  TargetList: TList;
  InsertIdx: Integer;
begin
  if (Index > 0) and (Index <= FNodes.Count) then
  begin
    DestNode := Items[Index];
    NewNode := TOutlineNode.Create(Self);
    NewNode.FText := Text;
    NewNode.FData := Data;
    NewNode.FParent := DestNode.FParent;
    if DestNode.FParent <> nil then
      TargetList := DestNode.FParent.FChildren
    else
      TargetList := FRootNodes;
    InsertIdx := TargetList.IndexOf(DestNode);
    if InsertIdx >= 0 then
      TargetList.Insert(InsertIdx, NewNode)
    else
      TargetList.Add(NewNode);
    if FUpdateCount = 0 then
      RebuildTree
    else
      FNodes.Add(NewNode);
    Result := NewNode.Index;
  end
  else
    Result := AddChildObject(0, Text, Data);
end;

function TCustomOutline.Insert(Index: Longint; const Text: string): Longint;
begin
  Result := InsertObject(Index, Text, nil);
end;

procedure TCustomOutline.Delete(Index: Longint);
var
  Node: TOutlineNode;
begin
  if (Index > 0) and (Index <= FNodes.Count) then
  begin
    Node := Items[Index];
    if Node.FParent <> nil then
      Node.FParent.FChildren.Remove(Node)
    else
      FRootNodes.Remove(Node);
    Node.Free;
    RebuildTree;
    if FSelectedItem = Index then
      FSelectedItem := 0;
  end;
end;

procedure TCustomOutline.Clear;
var
  i: Integer;
begin
  for i := FRootNodes.Count - 1 downto 0 do
    TOutlineNode(FRootNodes[i]).Free;
  FRootNodes.Clear;
  FNodes.Clear;
  FVisibleNodes.Clear;
  RowCount := 0;
  FSelectedItem := 0;
end;

procedure TCustomOutline.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

procedure TCustomOutline.EndUpdate;
begin
  if FUpdateCount > 0 then
  begin
    Dec(FUpdateCount);
    if FUpdateCount = 0 then
      RebuildTree;
  end;
end;

procedure TCustomOutline.SetUpdateState(Updating: Boolean);
begin
  if Updating then
    BeginUpdate
  else
    EndUpdate;
end;

procedure TCustomOutline.FullExpand;
var
  i: Integer;
begin
  for i := 0 to FRootNodes.Count - 1 do
    TOutlineNode(FRootNodes[i]).FullExpand;
end;

procedure TCustomOutline.FullCollapse;
var
  i: Integer;
begin
  for i := 0 to FRootNodes.Count - 1 do
    TOutlineNode(FRootNodes[i]).FullCollapse;
end;

function TCustomOutline.GetItem(X, Y: Integer): Longint;
var
  Coord: TGridCoord;
begin
  Coord := MouseCoord(X, Y);
  if (Coord.Y >= 0) and (Coord.Y < FVisibleNodes.Count) then
    Result := TOutlineNode(FVisibleNodes[Coord.Y]).Index
  else
    Result := 0;
end;

function TCustomOutline.GetTextItem(const S: string): Longint;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FNodes.Count - 1 do
    if CompareText(TOutlineNode(FNodes[i]).FText, S) = 0 then
    begin
      Result := i + 1;
      Exit;
    end;
end;

function TCustomOutline.GetDataItem(const Value: Pointer): Longint;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to FNodes.Count - 1 do
    if TOutlineNode(FNodes[i]).FData = Value then
    begin
      Result := i + 1;
      Exit;
    end;
end;

procedure TCustomOutline.DrawCell(ACol, ARow: Longint; ARect: TRect; AState: TGridDrawState);
var
  Node: TOutlineNode;
  ODState: TOwnerDrawState;
  X, Y: Integer;
  S: string;
begin
  if (ARow < 0) or (ARow >= FVisibleNodes.Count) then Exit;
  Node := TOutlineNode(FVisibleNodes[ARow]);

  if (FStyle = otOwnerDraw) and Assigned(FOnDrawItem) then
  begin
    ODState := [];
    if gdSelected in AState then Include(ODState, odSelected);
    if gdFocused in AState then Include(ODState, odFocused);
    FOnDrawItem(Self, ARow, ARect, ODState);
  end
  else
  begin
    with Canvas do
    begin
      if gdSelected in AState then
      begin
        Brush.Color := clHighlight;
        Font.Color := clHighlightText;
      end
      else
      begin
        Brush.Color := Self.Color;
        Font.Color := Self.Font.Color;
      end;
      FillRect(ARect);

      X := ARect.Left + Node.Level * 16 + 2;
      Y := ARect.Top + 2;
      S := Node.FText;
      TextOut(X, Y, S);
    end;
  end;
end;

procedure TCustomOutline.MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  ItemIdx: Longint;
begin
  inherited MouseDown(Button, Shift, X, Y);
  ItemIdx := GetItem(X, Y);
  if ItemIdx > 0 then
    SelectedItem := ItemIdx;
end;

procedure TCustomOutline.KeyDown(var Key: Word; Shift: TShiftState);
var
  Node: TOutlineNode;
begin
  inherited KeyDown(Key, Shift);
  if FSelectedItem > 0 then
  begin
    Node := Items[FSelectedItem];
    case Key of
      VK_LEFT:
        if Node.Expanded then
          Node.Collapse;
      VK_RIGHT:
        if not Node.Expanded then
          Node.Expand;
    end;
  end;
end;

end.
