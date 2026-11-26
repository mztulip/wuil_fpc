unit StdCtrls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Messages, Classes, Graphics, Controls, Forms, SysUtils;

const
  ES_READONLY    = $0800;
  EM_SETREADONLY = $00CF;
  EM_GETSEL      = $00B0;
  EM_SETSEL      = $00B1;
  EM_REPLACESEL  = $00C2;

type
  TCheckBoxState = (cbUnchecked, cbChecked, cbGrayed);
  TComboBoxStyle = (csDropDown, csSimple, csDropDownList, csOwnerDrawFixed, csOwnerDrawVariable);
  TScrollStyle = (ssNone, ssHorizontal, ssVertical, ssBoth);
  TAlignment = Classes.TAlignment;

  TLabel = class(TGraphicControl)
  private
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FWordWrap: Boolean;
    FShowAccelChar: Boolean;
    FFocusControl: TWinControl;
    procedure SetAlignment(Value: TAlignment);
    procedure SetWordWrap(Value: Boolean);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Alignment: TAlignment read FAlignment write SetAlignment default taLeftJustify;
    property AutoSize: Boolean read FAutoSize write FAutoSize default True;
    property WordWrap: Boolean read FWordWrap write SetWordWrap default False;
    property ShowAccelChar: Boolean read FShowAccelChar write FShowAccelChar default True;
    property FocusControl: TWinControl read FFocusControl write FFocusControl;
    property Caption;
    property Color;
    property Font;
    property Visible;
    property Enabled;
    property OnClick;
    property OnDblClick;
  end;

  TButton = class(TWinControl)
  private
    FDefault: Boolean;
    FCancel: Boolean;
    FModalResult: TModalResult;
    procedure SetDefault(Value: Boolean);
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property Caption;
    property Enabled;
    property Visible;
    property Font;
    property Default: Boolean read FDefault write SetDefault default False;
    property Cancel: Boolean read FCancel write FCancel default False;
    property ModalResult: TModalResult read FModalResult write FModalResult default mrNone;
    property OnClick;
  end;

  TCheckBox = class(TButton)
  private
    FChecked: Boolean;
    FState: TCheckBoxState;
    FAllowGrayed: Boolean;
    procedure SetChecked(Value: Boolean);
    procedure SetState(Value: TCheckBoxState);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property Checked: Boolean read FChecked write SetChecked default False;
    property State: TCheckBoxState read FState write SetState default cbUnchecked;
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Caption;
    property Enabled;
    property Visible;
    property Font;
    property OnClick;
  end;

  TRadioButton = class(TButton)
  private
    FChecked: Boolean;
    procedure SetChecked(Value: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Click; override;
  published
    property Checked: Boolean read FChecked write SetChecked default False;
    property Caption;
    property Enabled;
    property Visible;
    property Font;
    property OnClick;
  end;

  TGroupBox = class(TWinControl)
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Font;
    property Enabled;
    property Visible;
  end;

  TEditCharCase = (ecNormal, ecUpperCase, ecLowerCase);

  TCustomEdit = class(TWinControl)
  private
    FCharCase: TEditCharCase;
    FHideSelection: Boolean;
    FReadOnly: Boolean;
    FOEMConvert: Boolean;
    FMaxLength: Integer;
    FAutoSelect: Boolean;
    FPasswordChar: Char;
    FBorderStyle: TBorderStyle;
    FOnChange: TNotifyEvent;
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetReadOnly(Value: Boolean);
    procedure SetOEMConvert(Value: Boolean);
    procedure SetPasswordChar(Value: Char);
    function GetSelStart: Integer;
    procedure SetSelStart(Value: Integer);
    function GetSelLength: Integer;
    procedure SetSelLength(Value: Integer);
    function GetSelText: string;
    procedure SetSelText(const Value: string);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Change; virtual;
    property AutoSelect: Boolean read FAutoSelect write FAutoSelect default True;
    property CharCase: TEditCharCase read FCharCase write FCharCase default ecNormal;
    property HideSelection: Boolean read FHideSelection write FHideSelection default True;
    property BorderStyle: TBorderStyle read FBorderStyle write FBorderStyle default bsSingle;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
    property OEMConvert: Boolean read FOEMConvert write SetOEMConvert default False;
    property PasswordChar: Char read FPasswordChar write SetPasswordChar default #0;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear;
    procedure SelectAll;
    property Text: string read GetText write SetText;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelText: string read GetSelText write SetSelText;
  end;

  TEdit = class(TCustomEdit)
  published
    property AutoSelect;
    property CharCase;
    property HideSelection;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property OEMConvert;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
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

  TOwnerDrawState = set of (odSelected, odGrayed, odDisabled, odChecked,
    odFocused, odDefault);

  TDrawItemEvent = procedure(Control: TWinControl; Index: Integer;
    Rect: TRect; State: TOwnerDrawState) of object;
  TMeasureItemEvent = procedure(Control: TWinControl; Index: Integer;
    var Height: Integer) of object;

  TListBoxStyle = (lbStandard, lbOwnerDrawFixed, lbOwnerDrawVariable);

  TCustomListBox = class;

  TListBoxStrings = class(TStrings)
  private
    FListBox: TCustomListBox;
    FBuffer: TStringList;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
  public
    constructor Create(AListBox: TCustomListBox);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure SyncToHandle;
  end;

  TCustomListBox = class(TWinControl)
  private
    FItems: TStrings;
    FCanvas: TCanvas;
    FStyle: TListBoxStyle;
    FItemHeight: Integer;
    FBorderStyle: TBorderStyle;
    FMultiSelect: Boolean;
    FExtendedSelect: Boolean;
    FSorted: Boolean;
    FIntegralHeight: Boolean;
    FColumns: Integer;
    FSaveItemIndex: Integer;
    FSaveTopIndex: Integer;
    FOnDblClick: TNotifyEvent;
    FOnDrawItem: TDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetSelected(Index: Integer): Boolean;
    procedure SetSelected(Index: Integer; Value: Boolean);
    function GetTopIndex: Integer;
    procedure SetTopIndex(Value: Integer);
    function GetSelCount: Integer;
    procedure SetItems(Value: TStrings);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DblClick; virtual;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); virtual;
    procedure MeasureItem(Index: Integer; var Height: Integer); virtual;
    property BorderStyle: TBorderStyle read FBorderStyle write FBorderStyle default bsSingle;
    property Columns: Integer read FColumns write FColumns default 0;
    property ExtendedSelect: Boolean read FExtendedSelect write FExtendedSelect default True;
    property IntegralHeight: Boolean read FIntegralHeight write FIntegralHeight default True;
    property ItemHeight: Integer read FItemHeight write FItemHeight default 16;
    property MultiSelect: Boolean read FMultiSelect write FMultiSelect default False;
    property Sorted: Boolean read FSorted write FSorted default False;
    property Style: TListBoxStyle read FStyle write FStyle default lbStandard;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    function ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
    property Canvas: TCanvas read FCanvas;
    property Items: TStrings read FItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property SelCount: Integer read GetSelCount;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
  end;

  TListBox = class(TCustomListBox)
  published
    property Align;
    property BorderStyle;
    property Color;
    property Columns;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property Enabled;
    property ExtendedSelect;
    property Font;
    property IntegralHeight;
    property ItemHeight;
    property Items;
    property MultiSelect;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property Style;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
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
    property OnMeasureItem;
  end;

  TCustomComboBox = class;

  TComboBoxStrings = class(TStrings)
  private
    FComboBox: TCustomComboBox;
    FBuffer: TStringList;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
    function GetObject(Index: Integer): TObject; override;
    procedure PutObject(Index: Integer; AObject: TObject); override;
  public
    constructor Create(AComboBox: TCustomComboBox);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure SyncToHandle;
  end;

  TCustomComboBox = class(TWinControl)
  private
    FCanvas: TCanvas;
    FItems: TStrings;
    FStyle: TComboBoxStyle;
    FSorted: Boolean;
    FDropDownCount: Integer;
    FItemHeight: Integer;
    FMaxLength: Integer;
    FSaveItemIndex: Integer;
    FOnChange: TNotifyEvent;
    FOnDropDown: TNotifyEvent;
    FOnDrawItem: TDrawItemEvent;
    FOnMeasureItem: TMeasureItemEvent;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetDroppedDown: Boolean;
    procedure SetDroppedDown(Value: Boolean);
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetItems(Value: TStrings);
    procedure SetItemHeight(Value: Integer);
    procedure SetMaxLength(Value: Integer);
    procedure SetStyle(Value: TComboBoxStyle);
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Change; virtual;
    procedure MeasureItem(Index: Integer; var Height: Integer); virtual;
    procedure DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState); virtual;
    property Style: TComboBoxStyle read FStyle write SetStyle default csDropDown;
    property Sorted: Boolean read FSorted write FSorted default False;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property ItemHeight: Integer read FItemHeight write SetItemHeight;
    property MaxLength: Integer read FMaxLength write SetMaxLength default 0;
    property Items: TStrings read FItems write SetItems;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnDrawItem: TDrawItemEvent read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent read FOnMeasureItem write FOnMeasureItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    property Canvas: TCanvas read FCanvas;
    property DroppedDown: Boolean read GetDroppedDown write SetDroppedDown;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property Text: string read GetText write SetText;
  end;

  TComboBox = class(TCustomComboBox)
  published
    property Style;
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property DropDownCount;
    property Enabled;
    property Font;
    property ItemHeight;
    property Items;
    property ItemIndex;
    property MaxLength;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
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
    property OnMeasureItem;
  end;

  TMemo = class(TWinControl)
  private
    FLines: TStrings;
    FWordWrap: Boolean;
    FScrollBars: TScrollStyle;
    FReadOnly: Boolean;
    FModified: Boolean;
    FOnChange: TNotifyEvent;
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetLines(Value: TStrings);
    procedure SetReadOnly(Value: Boolean);
    function GetSelStart: Integer;
    procedure SetSelStart(Value: Integer);
    function GetSelLength: Integer;
    procedure SetSelLength(Value: Integer);
    function GetSelText: string;
    procedure SetSelText(const Value: string);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure Change; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    property Modified: Boolean read FModified write FModified;
    property SelStart: Integer read GetSelStart write SetSelStart;
    property SelLength: Integer read GetSelLength write SetSelLength;
    property SelText: string read GetSelText write SetSelText;
    property Text: string read GetText write SetText;
  published
    property Lines: TStrings read FLines write SetLines;
    property WordWrap: Boolean read FWordWrap write FWordWrap default True;
    property ScrollBars: TScrollStyle read FScrollBars write FScrollBars default ssNone;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property Enabled;
    property Font;
    property Visible;
    property OnClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TLabel }

constructor TLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 65;
  FHeight := 17;
  FCaption := 'Label';
  FAlignment := taLeftJustify;
  FAutoSize := True;
  FShowAccelChar := True;
  FWordWrap := False;
end;

procedure TLabel.SetAlignment(Value: TAlignment);
begin
  if FAlignment <> Value then
  begin
    FAlignment := Value;
    Invalidate;
  end;
end;

procedure TLabel.SetWordWrap(Value: Boolean);
begin
  if FWordWrap <> Value then
  begin
    FWordWrap := Value;
    Invalidate;
  end;
end;

procedure TLabel.Paint;
var
  DC: HDC;
  OwnDC: Boolean;
  R: RECT;
  Flags: Word;
begin
  if Length(FCaption) = 0 then Exit;
  OwnDC := False;
  DC := Canvas.Handle;
  if DC <> 0 then
  begin
    R.left := 0;
    R.top := 0;
    R.right := FWidth;
    R.bottom := FHeight;
  end
  else
  begin
    if (FParent = nil) or not FParent.HandleAllocated then Exit;
    DC := GetDC(FParent.Handle);
    if DC = 0 then Exit;
    OwnDC := True;
    R.left := FLeft;
    R.top := FTop;
    R.right := FLeft + FWidth;
    R.bottom := FTop + FHeight;
  end;
  try
    SetBkMode(DC, TRANSPARENT);
    SetTextColor(DC, ColorToRGB(FFont.Color));
    if FFont.Handle <> 0 then
      SelectObject(DC, FFont.Handle);

    Flags := 0;
    if FWordWrap then
      Flags := Flags or DT_WORDBREAK;
    case FAlignment of
      taLeftJustify:  Flags := Flags or DT_LEFT;
      taRightJustify: Flags := Flags or DT_RIGHT;
      taCenter:       Flags := Flags or DT_CENTER;
    end;

    DrawText(DC, @FCaption[1], Length(FCaption), R, Flags);
  finally
    if OwnDC then
      ReleaseDC(FParent.Handle, DC);
  end;
end;

{ TButton }

constructor TButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 75;
  FHeight := 25;
  FCaption := 'Button';
  FDefault := False;
  FCancel := False;
  FModalResult := mrNone;
end;

procedure TButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'BUTTON');
  Params.Style := WS_CHILD or WS_TABSTOP;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
  if FDefault then
    Params.Style := Params.Style or BS_DEFPUSHBUTTON
  else
    Params.Style := Params.Style or BS_PUSHBUTTON;
end;

procedure TButton.SetDefault(Value: Boolean);
begin
  if FDefault <> Value then
  begin
    FDefault := Value;
    if HandleAllocated then
    begin
      if FDefault then
        SendMessage(FHandle, BM_SETSTYLE, BS_DEFPUSHBUTTON, 1)
      else
        SendMessage(FHandle, BM_SETSTYLE, BS_PUSHBUTTON, 1);
    end;
  end;
end;

procedure TButton.Click;
begin
  inherited Click;
  if FModalResult <> mrNone then
  begin
    if (FParent <> nil) and (FParent is TForm) then
      TForm(FParent).ModalResult := FModalResult;
  end;
end;

procedure TButton.CNCommand(var Message: TWMCommand);
begin
  if Message.NotifyCode = BN_CLICKED then
    Click;
end;

{ TCheckBox }

constructor TCheckBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 97;
  FHeight := 17;
  FCaption := 'CheckBox';
  FChecked := False;
  FState := cbUnchecked;
  FAllowGrayed := False;
end;

procedure TCheckBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'BUTTON');
  Params.Style := WS_CHILD or WS_TABSTOP or BS_AUTOCHECKBOX;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
end;

procedure TCheckBox.CreateWnd;
var
  CheckFlag: Word;
begin
  inherited CreateWnd;
  case FState of
    cbChecked:   CheckFlag := 1;
    cbGrayed:    CheckFlag := 2;
    else         CheckFlag := 0;
  end;
  if FHandle <> 0 then
    SendMessage(FHandle, BM_SETCHECK, CheckFlag, 0);
end;

procedure TCheckBox.DestroyWnd;
begin
  if HandleAllocated then
  begin
    case SendMessage(FHandle, BM_GETCHECK, 0, 0) of
      1: FState := cbChecked;
      2: FState := cbGrayed;
      else FState := cbUnchecked;
    end;
    FChecked := (FState = cbChecked);
  end;
  inherited DestroyWnd;
end;

procedure TCheckBox.SetChecked(Value: Boolean);
begin
  if Value then
    SetState(cbChecked)
  else
    SetState(cbUnchecked);
end;

procedure TCheckBox.SetState(Value: TCheckBoxState);
var
  CheckFlag: Word;
begin
  if FState <> Value then
  begin
    FState := Value;
    FChecked := (FState = cbChecked);
    if HandleAllocated then
    begin
      case FState of
        cbChecked:   CheckFlag := 1;
        cbGrayed:    CheckFlag := 2;
        else         CheckFlag := 0;
      end;
      SendMessage(FHandle, BM_SETCHECK, CheckFlag, 0);
    end;
  end;
end;

procedure TCheckBox.Click;
begin
  if HandleAllocated then
  begin
    if SendMessage(FHandle, BM_GETCHECK, 0, 0) <> 0 then
      FState := cbChecked
    else
      FState := cbUnchecked;
    FChecked := (FState = cbChecked);
  end
  else
    SetChecked(not FChecked);
  inherited Click;
end;

{ TRadioButton }

constructor TRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 113;
  FHeight := 17;
  FCaption := 'RadioButton';
  FChecked := False;
end;

procedure TRadioButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'BUTTON');
  Params.Style := WS_CHILD or WS_TABSTOP or BS_AUTORADIOBUTTON;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
end;

procedure TRadioButton.CreateWnd;
var
  CheckFlag: Word;
begin
  inherited CreateWnd;
  if FChecked then CheckFlag := 1 else CheckFlag := 0;
  if FHandle <> 0 then
    SendMessage(FHandle, BM_SETCHECK, CheckFlag, 0);
end;

procedure TRadioButton.DestroyWnd;
begin
  if HandleAllocated then
    FChecked := SendMessage(FHandle, BM_GETCHECK, 0, 0) <> 0;
  inherited DestroyWnd;
end;

procedure TRadioButton.SetChecked(Value: Boolean);
var
  CheckFlag: Word;
  I: Integer;
  Sibling: TControl;
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if HandleAllocated then
    begin
      if FChecked then CheckFlag := 1 else CheckFlag := 0;
      SendMessage(FHandle, BM_SETCHECK, CheckFlag, 0);
    end;
    if FChecked and (FParent <> nil) then
      for I := 0 to FParent.ControlCount - 1 do
      begin
        Sibling := FParent.Controls[I];
        if (Sibling <> Self) and (Sibling is TRadioButton) then
          TRadioButton(Sibling).SetChecked(False);
      end;
  end;
end;

procedure TRadioButton.Click;
begin
  FChecked := True;
  inherited Click;
end;

{ TGroupBox }

constructor TGroupBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 185;
  FHeight := 105;
  FCaption := 'GroupBox';
end;

procedure TGroupBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'BUTTON');
  Params.Style := WS_CHILD or WS_CLIPCHILDREN or BS_GROUPBOX;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
end;

procedure TGroupBox.Paint;
begin
  { Malowane przez Windows API BS_GROUPBOX }
end;

{ TCustomEdit }

constructor TCustomEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 121;
  FHeight := 21;
  FCaption := '';
  FReadOnly := False;
  FMaxLength := 0;
  FAutoSelect := True;
  FHideSelection := True;
  FBorderStyle := bsSingle;
  FPasswordChar := #0;
  FOEMConvert := False;
end;

procedure TCustomEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'EDIT');
  Params.Style := WS_CHILD or WS_BORDER or WS_TABSTOP or ES_AUTOHSCROLL;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
  if FReadOnly then
    Params.Style := Params.Style or ES_READONLY;
  if FOEMConvert then
    Params.Style := Params.Style or ES_OEMCONVERT;
end;

procedure TCustomEdit.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
  begin
    if FPasswordChar <> #0 then
      SendMessage(FHandle, EM_SETPASSWORDCHAR, Ord(FPasswordChar), 0);
    if FMaxLength > 0 then
      SendMessage(FHandle, EM_LIMITTEXT, FMaxLength, 0);
  end;
end;

procedure TCustomEdit.DestroyWnd;
begin
  if HandleAllocated then
    FCaption := GetText;
  inherited DestroyWnd;
end;

function TCustomEdit.GetText: string;
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

procedure TCustomEdit.SetText(const Value: string);
begin
  FCaption := Value;
  if HandleAllocated then
    SetWindowText(FHandle, PChar(Value));
end;

procedure TCustomEdit.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    if HandleAllocated then
      SendMessage(FHandle, EM_SETREADONLY, Ord(Value), 0);
  end;
end;

procedure TCustomEdit.SetOEMConvert(Value: Boolean);
begin
  if FOEMConvert <> Value then
  begin
    FOEMConvert := Value;
    if HandleAllocated then
      RecreateWnd;
  end;
end;

procedure TCustomEdit.SetPasswordChar(Value: Char);
begin
  if FPasswordChar <> Value then
  begin
    FPasswordChar := Value;
    if HandleAllocated then
      SendMessage(FHandle, EM_SETPASSWORDCHAR, Ord(Value), 0);
  end;
end;

procedure TCustomEdit.Clear;
begin
  SetText('');
end;

procedure TCustomEdit.SelectAll;
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_SETSEL, 0, MakeLong(0, $FFFF));
end;

procedure TCustomEdit.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

function TCustomEdit.GetSelStart: Integer;
var
  L: LongInt;
begin
  if HandleAllocated then
  begin
    L := SendMessage(FHandle, EM_GETSEL, 0, 0);
    Result := LoWord(L);
  end
  else
    Result := 0;
end;

procedure TCustomEdit.SetSelStart(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_SETSEL, 0, MakeLong(Value, Value));
end;

function TCustomEdit.GetSelLength: Integer;
var
  L: LongInt;
begin
  if HandleAllocated then
  begin
    L := SendMessage(FHandle, EM_GETSEL, 0, 0);
    Result := HiWord(L) - LoWord(L);
  end
  else
    Result := 0;
end;

procedure TCustomEdit.SetSelLength(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_SETSEL, 0, MakeLong(GetSelStart, GetSelStart + Value));
end;

function TCustomEdit.GetSelText: string;
var
  StartPos, EndPos: Integer;
  Res: LongInt;
  S: string;
begin
  Result := '';
  if HandleAllocated then
  begin
    Res := SendMessage(FHandle, EM_GETSEL, 0, 0);
    StartPos := LoWord(Res);
    EndPos := HiWord(Res);
    if EndPos > StartPos then
    begin
      S := GetText;
      Result := Copy(S, StartPos + 1, EndPos - StartPos);
    end;
  end;
end;

procedure TCustomEdit.SetSelText(const Value: string);
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_REPLACESEL, 0, LongInt(PChar(Value)));
end;

{ TListBoxStrings }

constructor TListBoxStrings.Create(AListBox: TCustomListBox);
begin
  inherited Create;
  FListBox := AListBox;
  FBuffer := TStringList.Create;
end;

destructor TListBoxStrings.Destroy;
begin
  FBuffer.Free;
  inherited Destroy;
end;

function TListBoxStrings.GetCount: Integer;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
    Result := SendMessage(FListBox.Handle, LB_GETCOUNT, 0, 0)
  else
    Result := FBuffer.Count;
end;

function TListBoxStrings.Get(Index: Integer): string;
var
  Buf: array[0..255] of Char;
  Len: Integer;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
  begin
    Len := SendMessage(FListBox.Handle, LB_GETTEXT, Index, LongInt(@Buf));
    if Len >= 0 then
      Result := StrPas(Buf)
    else
      Result := '';
  end
  else
    Result := FBuffer[Index];
end;

function TListBoxStrings.GetObject(Index: Integer): TObject;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
    Result := TObject(SendMessage(FListBox.Handle, LB_GETITEMDATA, Index, 0))
  else if (Index >= 0) and (Index < FBuffer.Count) then
    Result := FBuffer.Objects[Index]
  else
    Result := nil;
end;

procedure TListBoxStrings.PutObject(Index: Integer; AObject: TObject);
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
    SendMessage(FListBox.Handle, LB_SETITEMDATA, Index, LongInt(AObject));
  if (Index >= 0) and (Index < FBuffer.Count) then
    FBuffer.Objects[Index] := AObject;
end;

procedure TListBoxStrings.Clear;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
    SendMessage(FListBox.Handle, LB_RESETCONTENT, 0, 0);
  FBuffer.Clear;
end;

procedure TListBoxStrings.Delete(Index: Integer);
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
    SendMessage(FListBox.Handle, LB_DELETESTRING, Index, 0);
  if (Index >= 0) and (Index < FBuffer.Count) then
    FBuffer.Delete(Index);
end;

procedure TListBoxStrings.Insert(Index: Integer; const S: string);
var
  Buf: array[0..255] of Char;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
  begin
    StrPLCopy(Buf, S, 255);
    SendMessage(FListBox.Handle, LB_INSERTSTRING, Index, LongInt(@Buf));
  end;
  FBuffer.Insert(Index, S);
end;

procedure TListBoxStrings.SyncToHandle;
var
  I, Idx: Integer;
  Buf: array[0..255] of Char;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
  begin
    SendMessage(FListBox.Handle, LB_RESETCONTENT, 0, 0);
    for I := 0 to FBuffer.Count - 1 do
    begin
      StrPLCopy(Buf, FBuffer[I], 255);
      Idx := SendMessage(FListBox.Handle, LB_ADDSTRING, 0, LongInt(@Buf));
      if Idx >= 0 then
        SendMessage(FListBox.Handle, LB_SETITEMDATA, Idx, LongInt(FBuffer.Objects[I]));
    end;
  end;
end;

{ TCustomListBox }

constructor TCustomListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TListBoxStrings.Create(Self);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FWidth := 121;
  FHeight := 97;
  FStyle := lbStandard;
  FItemHeight := 16;
  FBorderStyle := bsSingle;
  FMultiSelect := False;
  FExtendedSelect := True;
  FSorted := False;
  FIntegralHeight := True;
  FColumns := 0;
  FSaveItemIndex := -1;
  FSaveTopIndex := 0;
end;

destructor TCustomListBox.Destroy;
begin
  FItems.Free;
  FCanvas.Free;
  inherited Destroy;
end;

procedure TCustomListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'LISTBOX');
  Params.Style := WS_CHILD or WS_BORDER or WS_VSCROLL or WS_TABSTOP or LBS_NOTIFY;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
  if FSorted then
    Params.Style := Params.Style or LBS_SORT;
  if FMultiSelect then
  begin
    if FExtendedSelect then
      Params.Style := Params.Style or LBS_EXTENDEDSEL
    else
      Params.Style := Params.Style or LBS_MULTIPLESEL;
  end;
  if not FIntegralHeight then
    Params.Style := Params.Style or LBS_NOINTEGRALHEIGHT;
  if FColumns > 0 then
    Params.Style := Params.Style or LBS_MULTICOLUMN;
  case FStyle of
    lbOwnerDrawFixed:
      Params.Style := Params.Style or LBS_OWNERDRAWFIXED or LBS_HASSTRINGS;
    lbOwnerDrawVariable:
      Params.Style := Params.Style or LBS_OWNERDRAWVARIABLE or LBS_HASSTRINGS;
  end;
end;

procedure TCustomListBox.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  if FItems is TListBoxStrings then
    TListBoxStrings(FItems).SyncToHandle;
end;

procedure TCustomListBox.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
  begin
    if FSaveItemIndex >= 0 then
      SendMessage(FHandle, LB_SETCURSEL, FSaveItemIndex, 0);
    if FSaveTopIndex > 0 then
      SendMessage(FHandle, LB_SETTOPINDEX, FSaveTopIndex, 0);
  end;
end;

procedure TCustomListBox.DestroyWnd;
begin
  if HandleAllocated then
  begin
    FSaveItemIndex := GetItemIndex;
    FSaveTopIndex := GetTopIndex;
  end;
  inherited DestroyWnd;
end;

procedure TCustomListBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Assigned(FOnDrawItem) then
    FOnDrawItem(Self, Index, Rect, State);
end;

procedure TCustomListBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  if Message.DrawItemStruct = nil then Exit;
  with Message.DrawItemStruct^ do
  begin
    State := [];
    if (itemState and $0001) <> 0 then Include(State, odSelected);
    if (itemState and $0002) <> 0 then Include(State, odGrayed);
    if (itemState and $0004) <> 0 then Include(State, odDisabled);
    if (itemState and $0008) <> 0 then Include(State, odChecked);
    if (itemState and $0010) <> 0 then Include(State, odFocused);
    FCanvas.Handle := hDC;
    try
      FCanvas.Font := Font;
      FCanvas.Brush.Color := Color;
      if Integer(itemID) >= 0 then
        DrawItem(Integer(itemID), rcItem, State)
      else
        FCanvas.FillRect(rcItem);
    finally
      FCanvas.Handle := 0;
    end;
  end;
end;

procedure TCustomListBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  if Assigned(FOnMeasureItem) then
    FOnMeasureItem(Self, Index, Height);
end;

procedure TCustomListBox.Clear;
begin
  FItems.Clear;
  FSaveItemIndex := -1;
  FSaveTopIndex := 0;
end;

function TCustomListBox.GetItemIndex: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, LB_GETCURSEL, 0, 0)
  else
    Result := FSaveItemIndex;
end;

procedure TCustomListBox.SetItemIndex(Value: Integer);
begin
  FSaveItemIndex := Value;
  if HandleAllocated then
    SendMessage(FHandle, LB_SETCURSEL, Value, 0);
end;

function TCustomListBox.GetSelected(Index: Integer): Boolean;
begin
  Result := SendMessage(Handle, LB_GETSEL, Index, 0) > 0;
end;

procedure TCustomListBox.SetSelected(Index: Integer; Value: Boolean);
var
  Flag: Word;
begin
  if Value then Flag := 1 else Flag := 0;
  SendMessage(Handle, LB_SETSEL, Flag, Index);
end;

function TCustomListBox.GetTopIndex: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, LB_GETTOPINDEX, 0, 0)
  else
    Result := FSaveTopIndex;
end;

procedure TCustomListBox.SetTopIndex(Value: Integer);
begin
  FSaveTopIndex := Value;
  if HandleAllocated then
    SendMessage(FHandle, LB_SETTOPINDEX, Value, 0);
end;

function TCustomListBox.GetSelCount: Integer;
begin
  if MultiSelect then
  begin
    if HandleAllocated then
      Result := SendMessage(FHandle, LB_GETSELCOUNT, 0, 0)
    else
      Result := 0;
  end
  else
  begin
    if ItemIndex <> -1 then
      Result := 1
    else
      Result := 0;
  end;
end;

function TCustomListBox.ItemAtPos(Pos: TPoint; Existing: Boolean): Integer;
var
  I, TopIdx, Cnt: Integer;
  R: TRect;
begin
  Result := -1;
  if not HandleAllocated then Exit;
  Cnt := Items.Count;
  TopIdx := SendMessage(FHandle, LB_GETTOPINDEX, 0, 0);
  for I := TopIdx to Cnt - 1 do
  begin
    if SendMessage(FHandle, LB_GETITEMRECT, I, Longint(@R)) = LB_ERR then Break;
    if PtInRect(R, Pos) then
    begin
      Result := I;
      Exit;
    end;
    if Pos.Y < R.Top then Exit;
  end;
  if (not Existing) and (Cnt > 0) then
  begin
    R := ClientRect;
    if PtInRect(R, Pos) then
      Result := Cnt;
  end;
end;

procedure TCustomListBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TCustomListBox.DblClick;
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

{ TComboBoxStrings }

constructor TComboBoxStrings.Create(AComboBox: TCustomComboBox);
begin
  inherited Create;
  FComboBox := AComboBox;
  FBuffer := TStringList.Create;
end;

destructor TComboBoxStrings.Destroy;
begin
  FBuffer.Free;
  inherited Destroy;
end;

function TComboBoxStrings.GetCount: Integer;
begin
  Result := FBuffer.Count;
end;

function TComboBoxStrings.Get(Index: Integer): string;
begin
  Result := FBuffer[Index];
end;

function TComboBoxStrings.GetObject(Index: Integer): TObject;
begin
  Result := FBuffer.Objects[Index];
end;

procedure TComboBoxStrings.PutObject(Index: Integer; AObject: TObject);
begin
  FBuffer.Objects[Index] := AObject;
end;

procedure TComboBoxStrings.Clear;
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
    SendMessage(FComboBox.Handle, CB_RESETCONTENT, 0, 0);
  FBuffer.Clear;
end;

procedure TComboBoxStrings.Delete(Index: Integer);
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
    SendMessage(FComboBox.Handle, CB_DELETESTRING, Index, 0);
  if (Index >= 0) and (Index < FBuffer.Count) then
    FBuffer.Delete(Index);
end;

procedure TComboBoxStrings.Insert(Index: Integer; const S: string);
var
  Buf: array[0..255] of Char;
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
  begin
    StrPLCopy(Buf, S, 255);
    SendMessage(FComboBox.Handle, CB_INSERTSTRING, Index, LongInt(@Buf));
  end;
  FBuffer.Insert(Index, S);
end;

procedure TComboBoxStrings.SyncToHandle;
var
  I: Integer;
  Buf: array[0..255] of Char;
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
  begin
    SendMessage(FComboBox.Handle, CB_RESETCONTENT, 0, 0);
    for I := 0 to FBuffer.Count - 1 do
    begin
      StrPLCopy(Buf, FBuffer[I], 255);
      SendMessage(FComboBox.Handle, CB_ADDSTRING, 0, LongInt(@Buf));
    end;
  end;
end;

{ TCustomComboBox }

constructor TCustomComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TComboBoxStrings.Create(Self);
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;
  FWidth := 145;
  FHeight := 21;
  FStyle := csDropDown;
  FSorted := False;
  FDropDownCount := 8;
  FItemHeight := 16;
  FMaxLength := 0;
  FSaveItemIndex := -1;
end;

destructor TCustomComboBox.Destroy;
begin
  FCanvas.Free;
  FItems.Free;
  inherited Destroy;
end;

function TCustomComboBox.GetDroppedDown: Boolean;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, $0157, 0, 0) <> 0
  else
    Result := False;
end;

procedure TCustomComboBox.SetDroppedDown(Value: Boolean);
begin
  if HandleAllocated then
    SendMessage(FHandle, $014F, Word(Value), 0);
end;

procedure TCustomComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'COMBOBOX');
  Params.Style := WS_CHILD or WS_VSCROLL or WS_TABSTOP or CBS_AUTOHSCROLL;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
  case FStyle of
    csSimple:           Params.Style := Params.Style or CBS_SIMPLE;
    csDropDownList:     Params.Style := Params.Style or CBS_DROPDOWNLIST;
    csOwnerDrawFixed:   Params.Style := Params.Style or CBS_DROPDOWNLIST or CBS_OWNERDRAWFIXED or CBS_HASSTRINGS;
    csOwnerDrawVariable:Params.Style := Params.Style or CBS_DROPDOWNLIST or CBS_OWNERDRAWVARIABLE or CBS_HASSTRINGS;
    else                Params.Style := Params.Style or CBS_DROPDOWN;
  end;
  if FSorted then
    Params.Style := Params.Style or CBS_SORT;
end;

procedure TCustomComboBox.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  if FItems is TComboBoxStrings then
    TComboBoxStrings(FItems).SyncToHandle;
end;

procedure TCustomComboBox.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then
  begin
    if FMaxLength > 0 then
      SendMessage(FHandle, $0141 {CB_LIMITTEXT}, FMaxLength, 0);
    if FSaveItemIndex >= 0 then
      SendMessage(FHandle, CB_SETCURSEL, FSaveItemIndex, 0)
    else if FCaption <> '' then
      SetWindowText(FHandle, PChar(FCaption));
  end;
end;

procedure TCustomComboBox.DestroyWnd;
begin
  if HandleAllocated then
  begin
    FSaveItemIndex := GetItemIndex;
    FCaption := GetText;
  end;
  inherited DestroyWnd;
end;

procedure TCustomComboBox.Clear;
begin
  FItems.Clear;
  FSaveItemIndex := -1;
  SetText('');
end;

function TCustomComboBox.GetItemIndex: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, CB_GETCURSEL, 0, 0)
  else
    Result := FSaveItemIndex;
end;

procedure TCustomComboBox.SetItemIndex(Value: Integer);
begin
  FSaveItemIndex := Value;
  if HandleAllocated then
    SendMessage(FHandle, CB_SETCURSEL, Value, 0);
end;

function TCustomComboBox.GetText: string;
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

procedure TCustomComboBox.SetText(const Value: string);
begin
  FCaption := Value;
  if HandleAllocated then
    SetWindowText(FHandle, PChar(Value));
end;

procedure TCustomComboBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TCustomComboBox.SetItemHeight(Value: Integer);
begin
  if FItemHeight <> Value then
  begin
    FItemHeight := Value;
    if HandleAllocated then
      SendMessage(FHandle, $0153 {CB_SETITEMHEIGHT}, 0, Value);
  end;
end;

procedure TCustomComboBox.SetMaxLength(Value: Integer);
begin
  if FMaxLength <> Value then
  begin
    FMaxLength := Value;
    if HandleAllocated then
      SendMessage(FHandle, $0141 {CB_LIMITTEXT}, Value, 0);
  end;
end;

procedure TCustomComboBox.SetStyle(Value: TComboBoxStyle);
begin
  if FStyle <> Value then
  begin
    FStyle := Value;
  end;
end;

procedure TCustomComboBox.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

procedure TCustomComboBox.MeasureItem(Index: Integer; var Height: Integer);
begin
  if Assigned(FOnMeasureItem) then
    FOnMeasureItem(Self, Index, Height);
end;

procedure TCustomComboBox.DrawItem(Index: Integer; Rect: TRect; State: TOwnerDrawState);
begin
  if Assigned(FOnDrawItem) then
    FOnDrawItem(Self, Index, Rect, State);
end;

procedure TCustomComboBox.CNDrawItem(var Message: TWMDrawItem);
var
  State: TOwnerDrawState;
begin
  if Message.DrawItemStruct = nil then Exit;
  with Message.DrawItemStruct^ do
  begin
    State := [];
    if (itemState and $0001) <> 0 then Include(State, odSelected);
    if (itemState and $0002) <> 0 then Include(State, odGrayed);
    if (itemState and $0004) <> 0 then Include(State, odDisabled);
    if (itemState and $0008) <> 0 then Include(State, odChecked);
    if (itemState and $0010) <> 0 then Include(State, odFocused);
    FCanvas.Handle := hDC;
    try
      FCanvas.Font := Font;
      FCanvas.Brush.Color := Color;
      if Integer(itemID) >= 0 then
        DrawItem(Integer(itemID), rcItem, State)
      else
        FCanvas.FillRect(rcItem);
    finally
      FCanvas.Handle := 0;
    end;
  end;
end;

procedure TCustomComboBox.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    1 {CBN_SELCHANGE}: Change;
    7 {CBN_DROPDOWN}:
      if Assigned(FOnDropDown) then FOnDropDown(Self);
  end;
end;

{ TMemo }

constructor TMemo.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TStringList.Create;
  FWidth := 185;
  FHeight := 89;
  FWordWrap := True;
  FScrollBars := ssNone;
  FReadOnly := False;
  FModified := False;
end;

destructor TMemo.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

procedure TMemo.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'EDIT');
  Params.Style := WS_CHILD or WS_BORDER or WS_TABSTOP or
                  ES_MULTILINE or ES_AUTOVSCROLL;
  if FVisible then
    Params.Style := Params.Style or WS_VISIBLE;
  if not FWordWrap then
    Params.Style := Params.Style or ES_AUTOHSCROLL;
  if (FScrollBars = ssHorizontal) or (FScrollBars = ssBoth) then
    Params.Style := Params.Style or WS_HSCROLL;
  if (FScrollBars = ssVertical) or (FScrollBars = ssBoth) then
    Params.Style := Params.Style or WS_VSCROLL;
  if FReadOnly then
    Params.Style := Params.Style or ES_READONLY;
end;

procedure TMemo.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated and (FLines.Count > 0) then
    SetWindowText(FHandle, PChar(FLines.Text));
end;

procedure TMemo.DestroyWnd;
begin
  if HandleAllocated then
    FLines.Text := GetText;
  inherited DestroyWnd;
end;

function TMemo.GetText: string;
var
  Len: Integer;
  Buf: PChar;
begin
  Result := '';
  if HandleAllocated then
  begin
    Len := GetWindowTextLength(FHandle);
    if Len > 0 then
    begin
      GetMem(Buf, Len + 1);
      GetWindowText(FHandle, Buf, Len + 1);
      Result := StrPas(Buf);
      FreeMem(Buf, Len + 1);
    end;
  end
  else
    Result := FLines.Text;
end;

procedure TMemo.SetText(const Value: string);
begin
  FLines.Text := Value;
  if HandleAllocated then
    SetWindowText(FHandle, PChar(Value));
end;

procedure TMemo.SetLines(Value: TStrings);
begin
  FLines.Assign(Value);
  if HandleAllocated then
    SetWindowText(FHandle, PChar(FLines.Text));
end;

procedure TMemo.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    if HandleAllocated then
      SendMessage(FHandle, EM_SETREADONLY, Ord(Value), 0);
  end;
end;

procedure TMemo.Clear;
begin
  SetText('');
end;

function TMemo.GetSelStart: Integer;
var
  L: LongInt;
begin
  if HandleAllocated then
  begin
    L := SendMessage(FHandle, EM_GETSEL, 0, 0);
    Result := Loword(L);
  end
  else
    Result := 0;
end;

procedure TMemo.SetSelStart(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_SETSEL, 0, MakeLong(Value, Value));
end;

function TMemo.GetSelLength: Integer;
var
  L: LongInt;
begin
  if HandleAllocated then
  begin
    L := SendMessage(FHandle, EM_GETSEL, 0, 0);
    Result := Hiword(L) - Loword(L);
  end
  else
    Result := 0;
end;

procedure TMemo.SetSelLength(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_SETSEL, 0, MakeLong(GetSelStart, GetSelStart + Value));
end;

function TMemo.GetSelText: string;
begin
  { Podstawowa implementacja pobrania zaznaczonego tekstu }
  Result := '';
end;

procedure TMemo.SetSelText(const Value: string);
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_REPLACESEL, 0, LongInt(PChar(Value)));
end;

procedure TMemo.Change;
begin
  FModified := True;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

initialization
  RegisterClasses([TLabel, TButton, TCheckBox, TRadioButton, TGroupBox, TEdit, TListBox, TComboBox, TMemo]);

end.
