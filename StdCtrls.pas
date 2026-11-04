unit StdCtrls;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, SysUtils;

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
  TAlignment = (taLeftJustify, taRightJustify, taCenter);

  TLabel = class(TControl)
  private
    FAlignment: TAlignment;
    FAutoSize: Boolean;
    FWordWrap: Boolean;
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

  TEdit = class(TWinControl)
  private
    FReadOnly: Boolean;
    FMaxLength: Integer;
    FAutoSelect: Boolean;
    FOnChange: TNotifyEvent;
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetReadOnly(Value: Boolean);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure Change; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Clear;
    procedure SelectAll;
    property Text: string read GetText write SetText;
  published
    property AutoSelect: Boolean read FAutoSelect write FAutoSelect default True;
    property MaxLength: Integer read FMaxLength write FMaxLength default 0;
    property ReadOnly: Boolean read FReadOnly write SetReadOnly default False;
    property Enabled;
    property Visible;
    property Font;
    property OnClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

  TListBox = class;

  TListBoxStrings = class(TStrings)
  private
    FListBox: TListBox;
    FBuffer: TStringList;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
  public
    constructor Create(AListBox: TListBox);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure SyncToHandle;
  end;

  TListBox = class(TWinControl)
  private
    FItems: TStrings;
    FMultiSelect: Boolean;
    FExtendedSelect: Boolean;
    FSorted: Boolean;
    FIntegralHeight: Boolean;
    FColumns: Integer;
    FOnDblClick: TNotifyEvent;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetSelected(Index: Integer): Boolean;
    procedure SetSelected(Index: Integer; Value: Boolean);
    function GetTopIndex: Integer;
    procedure SetTopIndex(Value: Integer);
    procedure SetItems(Value: TStrings);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure DblClick; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    property Selected[Index: Integer]: Boolean read GetSelected write SetSelected;
  published
    property Items: TStrings read FItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property MultiSelect: Boolean read FMultiSelect write FMultiSelect default False;
    property ExtendedSelect: Boolean read FExtendedSelect write FExtendedSelect default True;
    property Sorted: Boolean read FSorted write FSorted default False;
    property TopIndex: Integer read GetTopIndex write SetTopIndex;
    property Columns: Integer read FColumns write FColumns default 0;
    property IntegralHeight: Boolean read FIntegralHeight write FIntegralHeight default True;
    property Enabled;
    property Font;
    property Visible;
    property OnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
  end;

  TComboBox = class;

  TComboBoxStrings = class(TStrings)
  private
    FComboBox: TComboBox;
    FBuffer: TStringList;
  protected
    function Get(Index: Integer): string; override;
    function GetCount: Integer; override;
  public
    constructor Create(AComboBox: TComboBox);
    destructor Destroy; override;
    procedure Clear; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure SyncToHandle;
  end;

  TComboBox = class(TWinControl)
  private
    FItems: TStrings;
    FStyle: TComboBoxStyle;
    FSorted: Boolean;
    FDropDownCount: Integer;
    FOnChange: TNotifyEvent;
    function GetItemIndex: Integer;
    procedure SetItemIndex(Value: Integer);
    function GetText: string;
    procedure SetText(const Value: string);
    procedure SetItems(Value: TStrings);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Change; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Clear;
    property Text: string read GetText write SetText;
  published
    property Items: TStrings read FItems write SetItems;
    property ItemIndex: Integer read GetItemIndex write SetItemIndex default -1;
    property Style: TComboBoxStyle read FStyle write FStyle default csDropDown;
    property Sorted: Boolean read FSorted write FSorted default False;
    property DropDownCount: Integer read FDropDownCount write FDropDownCount default 8;
    property Enabled;
    property Font;
    property Visible;
    property OnClick;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
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
  R: RECT;
  Flags: Word;
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

      Flags := DT_NOPREFIX;
      if FWordWrap then
        Flags := Flags or DT_WORDBREAK;
      case FAlignment of
        taLeftJustify:  Flags := Flags or DT_LEFT;
        taRightJustify: Flags := Flags or DT_RIGHT;
        taCenter:       Flags := Flags or DT_CENTER;
      end;

      DrawText(DC, @FCaption[1], Length(FCaption), R, Flags);
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
  FDefault := False;
  FCancel := False;
  FModalResult := mrNone;
end;

procedure TButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'BUTTON');
  Params.Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP;
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
  Params.Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_AUTOCHECKBOX;
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
  Params.Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or BS_AUTORADIOBUTTON;
end;

procedure TRadioButton.SetChecked(Value: Boolean);
var
  CheckFlag: Word;
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if HandleAllocated then
    begin
      if FChecked then CheckFlag := 1 else CheckFlag := 0;
      SendMessage(FHandle, BM_SETCHECK, CheckFlag, 0);
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
  Params.Style := WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or BS_GROUPBOX;
end;

procedure TGroupBox.Paint;
begin
  { Malowane przez Windows API BS_GROUPBOX }
end;

{ TEdit }

constructor TEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FWidth := 121;
  FHeight := 21;
  FCaption := '';
  FReadOnly := False;
  FMaxLength := 0;
  FAutoSelect := True;
end;

procedure TEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'EDIT');
  Params.Style := WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP or ES_AUTOHSCROLL;
  if FReadOnly then
    Params.Style := Params.Style or ES_READONLY;
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

procedure TEdit.SetReadOnly(Value: Boolean);
begin
  if FReadOnly <> Value then
  begin
    FReadOnly := Value;
    if HandleAllocated then
      SendMessage(FHandle, EM_SETREADONLY, Ord(Value), 0);
  end;
end;

procedure TEdit.Clear;
begin
  SetText('');
end;

procedure TEdit.SelectAll;
begin
  if HandleAllocated then
    SendMessage(FHandle, EM_SETSEL, 0, MakeLong(0, $FFFF));
end;

procedure TEdit.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{ TListBoxStrings }

constructor TListBoxStrings.Create(AListBox: TListBox);
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
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
    SendMessage(FListBox.Handle, LB_INSERTSTRING, Index, LongInt(PChar(S)));
  FBuffer.Insert(Index, S);
end;

procedure TListBoxStrings.SyncToHandle;
var
  I: Integer;
begin
  if (FListBox <> nil) and FListBox.HandleAllocated then
  begin
    SendMessage(FListBox.Handle, LB_RESETCONTENT, 0, 0);
    for I := 0 to FBuffer.Count - 1 do
      SendMessage(FListBox.Handle, LB_ADDSTRING, 0, LongInt(PChar(FBuffer[I])));
  end;
end;

{ TListBox }

constructor TListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TListBoxStrings.Create(Self);
  FWidth := 121;
  FHeight := 97;
  FMultiSelect := False;
  FExtendedSelect := True;
  FSorted := False;
  FIntegralHeight := True;
  FColumns := 0;
end;

destructor TListBox.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TListBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'LISTBOX');
  Params.Style := WS_CHILD or WS_VISIBLE or WS_BORDER or WS_VSCROLL or WS_TABSTOP or LBS_NOTIFY;
  if FSorted then
    Params.Style := Params.Style or LBS_SORT;
  if FMultiSelect then
  begin
    if FExtendedSelect then
      Params.Style := Params.Style or LBS_EXTENDEDSEL
    else
      Params.Style := Params.Style or LBS_MULTIPLESEL;
  end;
end;

procedure TListBox.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  if FItems is TListBoxStrings then
    TListBoxStrings(FItems).SyncToHandle;
end;

procedure TListBox.Clear;
begin
  FItems.Clear;
end;

function TListBox.GetItemIndex: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, LB_GETCURSEL, 0, 0)
  else
    Result := -1;
end;

procedure TListBox.SetItemIndex(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, LB_SETCURSEL, Value, 0);
end;

function TListBox.GetSelected(Index: Integer): Boolean;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, LB_GETSEL, Index, 0) > 0
  else
    Result := False;
end;

procedure TListBox.SetSelected(Index: Integer; Value: Boolean);
var
  Flag: Word;
begin
  if HandleAllocated then
  begin
    if Value then Flag := 1 else Flag := 0;
    SendMessage(FHandle, LB_SETSEL, Flag, Index);
  end;
end;

function TListBox.GetTopIndex: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, LB_GETTOPINDEX, 0, 0)
  else
    Result := 0;
end;

procedure TListBox.SetTopIndex(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, LB_SETTOPINDEX, Value, 0);
end;

procedure TListBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TListBox.DblClick;
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;

{ TComboBoxStrings }

constructor TComboBoxStrings.Create(AComboBox: TComboBox);
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
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
    Result := SendMessage(FComboBox.Handle, CB_GETCOUNT, 0, 0)
  else
    Result := FBuffer.Count;
end;

function TComboBoxStrings.Get(Index: Integer): string;
var
  Buf: array[0..255] of Char;
  Len: Integer;
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
  begin
    Len := SendMessage(FComboBox.Handle, CB_GETLBTEXT, Index, LongInt(@Buf));
    if Len >= 0 then
      Result := StrPas(Buf)
    else
      Result := '';
  end
  else
    Result := FBuffer[Index];
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
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
    SendMessage(FComboBox.Handle, CB_INSERTSTRING, Index, LongInt(PChar(S)));
  FBuffer.Insert(Index, S);
end;

procedure TComboBoxStrings.SyncToHandle;
var
  I: Integer;
begin
  if (FComboBox <> nil) and FComboBox.HandleAllocated then
  begin
    SendMessage(FComboBox.Handle, CB_RESETCONTENT, 0, 0);
    for I := 0 to FBuffer.Count - 1 do
      SendMessage(FComboBox.Handle, CB_ADDSTRING, 0, LongInt(PChar(FBuffer[I])));
  end;
end;

{ TComboBox }

constructor TComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TComboBoxStrings.Create(Self);
  FWidth := 145;
  FHeight := 21;
  FStyle := csDropDown;
  FSorted := False;
  FDropDownCount := 8;
end;

destructor TComboBox.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TComboBox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  FillChar(Params.WinClassName, SizeOf(Params.WinClassName), 0);
  StrCopy(Params.WinClassName, 'COMBOBOX');
  Params.Style := WS_CHILD or WS_VISIBLE or WS_VSCROLL or WS_TABSTOP or CBS_AUTOHSCROLL;
  case FStyle of
    csSimple:       Params.Style := Params.Style or CBS_SIMPLE;
    csDropDownList: Params.Style := Params.Style or CBS_DROPDOWNLIST;
    else            Params.Style := Params.Style or CBS_DROPDOWN;
  end;
  if FSorted then
    Params.Style := Params.Style or CBS_SORT;
end;

procedure TComboBox.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
  if FItems is TComboBoxStrings then
    TComboBoxStrings(FItems).SyncToHandle;
end;

procedure TComboBox.Clear;
begin
  FItems.Clear;
  SetText('');
end;

function TComboBox.GetItemIndex: Integer;
begin
  if HandleAllocated then
    Result := SendMessage(FHandle, CB_GETCURSEL, 0, 0)
  else
    Result := -1;
end;

procedure TComboBox.SetItemIndex(Value: Integer);
begin
  if HandleAllocated then
    SendMessage(FHandle, CB_SETCURSEL, Value, 0);
end;

function TComboBox.GetText: string;
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

procedure TComboBox.SetText(const Value: string);
begin
  FCaption := Value;
  if HandleAllocated then
    SetWindowText(FHandle, PChar(Value));
end;

procedure TComboBox.SetItems(Value: TStrings);
begin
  FItems.Assign(Value);
end;

procedure TComboBox.Change;
begin
  if Assigned(FOnChange) then
    FOnChange(Self);
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
  Params.Style := WS_CHILD or WS_VISIBLE or WS_BORDER or WS_TABSTOP or
                  ES_MULTILINE or ES_AUTOVSCROLL;
  if not FWordWrap then
    Params.Style := Params.Style or ES_AUTOHSCROLL;
  if (FScrollBars = ssHorizontal) or (FScrollBars = ssBoth) then
    Params.Style := Params.Style or WS_HSCROLL;
  if (FScrollBars = ssVertical) or (FScrollBars = ssBoth) then
    Params.Style := Params.Style or WS_VSCROLL;
  if FReadOnly then
    Params.Style := Params.Style or ES_READONLY;
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

end.
