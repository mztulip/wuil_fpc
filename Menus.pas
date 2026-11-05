unit Menus;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, SysUtils, Messages;

const
  TPM_LEFTBUTTON   = $0000;
  TPM_RIGHTBUTTON  = $0002;
  TPM_LEFTALIGN    = $0000;
  TPM_CENTERALIGN  = $0004;
  TPM_RIGHTALIGN   = $0008;

type
  TShortCut = Word;
  TMenuBreak = (mbNone, mbBreak, mbBarBreak);
  TPopupAlignment = (paLeft, paRight, paCenter);
  TTrackButton = (tbRightButton, tbLeftButton);

  TMenuItem = class;

  TMenuChangeEvent = procedure(Sender: TObject; Source: TMenuItem; Rebuild: Boolean) of object;

  TMenuItem = class(TComponent)
  private
    FCaption: string;
    FChecked: Boolean;
    FEnabled: Boolean;
    FDefault: Boolean;
    FRadioItem: Boolean;
    FVisible: Boolean;
    FGroupIndex: Byte;
    FShortCut: TShortCut;
    FHelpContext: LongInt;
    FBreak: TMenuBreak;
    FBitmap: HBITMAP;
    FCommand: Word;
    FOnClick: TNotifyEvent;
    FParent: TMenuItem;
    FItems: TList;
    FHandle: HMENU;
    procedure SetCaption(const Value: string);
    procedure SetChecked(Value: Boolean);
    procedure SetEnabled(Value: Boolean);
    procedure SetVisible(Value: Boolean);
    procedure SetShortCut(Value: TShortCut);
    function GetCount: Integer;
    function GetItem(Index: Integer): TMenuItem;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(Item: TMenuItem);
    procedure Insert(Index: Integer; Item: TMenuItem);
    procedure Delete(Index: Integer);
    procedure Remove(Item: TMenuItem);
    procedure Clear;
    function IndexOf(Item: TMenuItem): Integer;
    function IndexOfId(Id: Word): Integer;
    function Find(const ACaption: string): TMenuItem;
    procedure Click; virtual;
    function GetHandle: HMENU;
    procedure RebuildHandle;
    property Command: Word read FCommand write FCommand;
    property Handle: HMENU read GetHandle;
    property Count: Integer read GetCount;
    property Items[Index: Integer]: TMenuItem read GetItem; default;
    property Parent: TMenuItem read FParent;
  published
    property Caption: string read FCaption write SetCaption;
    property Checked: Boolean read FChecked write SetChecked;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Visible: Boolean read FVisible write SetVisible;
    property ShortCut: TShortCut read FShortCut write SetShortCut;
    property Break: TMenuBreak read FBreak write FBreak;
    property GroupIndex: Byte read FGroupIndex write FGroupIndex;
    property RadioItem: Boolean read FRadioItem write FRadioItem;
    property HelpContext: LongInt read FHelpContext write FHelpContext;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
  end;

  TFindItemKind = (fkCommand, fkHandle, fkShortCut);

  TMenu = class(TComponent)
  protected
    FItems: TMenuItem;
    FWindowHandle: HWND;
    function GetHandle: HMENU; virtual;
    procedure WndProc(var Message: TMessage); virtual;
    function DispatchCommand(ACommand: Word): Boolean;
    function DispatchPopup(AHandle: HMENU): Boolean;
    function FindItem(Value: Word; Kind: TFindItemKind): TMenuItem;
    function IsAccel(VK: Word; const Str: string): Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Items: TMenuItem read FItems;
    property Handle: HMENU read GetHandle;
    property WindowHandle: HWND read FWindowHandle write FWindowHandle;
  end;

  TMainMenu = class(TMenu)
  public
    constructor Create(AOwner: TComponent); override;
    function GetHandle: HMENU; override;
  end;

  TPopupMenu = class(TMenu)
  private
    FAlignment: TPopupAlignment;
    FAutoPopup: Boolean;
    FTrackButton: TTrackButton;
    FOnPopup: TNotifyEvent;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Popup(X, Y: Integer); virtual;
    property Alignment: TPopupAlignment read FAlignment write FAlignment;
    property AutoPopup: Boolean read FAutoPopup write FAutoPopup;
    property TrackButton: TTrackButton read FTrackButton write FTrackButton;
    property OnPopup: TNotifyEvent read FOnPopup write FOnPopup;
  end;

function NewItem(const ACaption: string; AShortCut: TShortCut;
  AChecked, AEnabled: Boolean; AOnClick: TNotifyEvent;
  hCtx: Word; const AName: string): TMenuItem;
function NewLine: TMenuItem;
function NewSubMenu(const ACaption: string; hCtx: Word;
  const AName: string; const Items: array of TMenuItem): TMenuItem;

function ShortCut(Key: Word; Shift: TShiftState): TShortCut;
procedure ShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift: TShiftState);
function ShortCutToText(ShortCut: TShortCut): string;
function TextToShortCut(const Text: string): TShortCut;

function FindMenuItem(CommandId: Word): TMenuItem;
procedure DispatchMenuCommand(CommandId: Word);
function IsAccel(VK: Word; const Str: string): Boolean;

implementation

var
  NextCommandID: Word = 1000;
  MenuItemList: TList = nil;

function RegisterMenuItem(Item: TMenuItem): Word;
begin
  if MenuItemList = nil then
    MenuItemList := TList.Create;
  MenuItemList.Add(Item);
  Inc(NextCommandID);
  RegisterMenuItem := NextCommandID;
end;

procedure UnregisterMenuItem(Item: TMenuItem);
begin
  if MenuItemList <> nil then
    MenuItemList.Remove(Item);
end;

function FindMenuItem(CommandId: Word): TMenuItem;
var
  I: Integer;
  Item: TMenuItem;
begin
  Result := nil;
  if MenuItemList <> nil then
  begin
    for I := 0 to MenuItemList.Count - 1 do
    begin
      Item := TMenuItem(MenuItemList[I]);
      if (Item <> nil) and (Item.Command = CommandId) then
      begin
        Result := Item;
        Exit;
      end;
    end;
  end;
end;

procedure DispatchMenuCommand(CommandId: Word);
var
  Item: TMenuItem;
begin
  Item := FindMenuItem(CommandId);
  if Item <> nil then
    Item.Click;
end;

{ TMenuItem }

constructor TMenuItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TList.Create;
  FEnabled := True;
  FVisible := True;
  FChecked := False;
  FRadioItem := False;
  FBreak := mbNone;
  FGroupIndex := 0;
  FHelpContext := 0;
  FShortCut := 0;
  FCaption := '';
  FHandle := 0;
  FParent := nil;
  FCommand := RegisterMenuItem(Self);
end;

destructor TMenuItem.Destroy;
begin
  Clear;
  FItems.Free;
  UnregisterMenuItem(Self);
  if FHandle <> 0 then
  begin
    DestroyMenu(FHandle);
    FHandle := 0;
  end;
  inherited Destroy;
end;

function TMenuItem.GetCount: Integer;
begin
  Result := FItems.Count;
end;

function TMenuItem.GetItem(Index: Integer): TMenuItem;
begin
  Result := TMenuItem(FItems[Index]);
end;

procedure TMenuItem.Add(Item: TMenuItem);
begin
  Insert(GetCount, Item);
end;

procedure TMenuItem.Insert(Index: Integer; Item: TMenuItem);
begin
  if Item <> nil then
  begin
    if Item.FParent <> nil then
      Item.FParent.Remove(Item);
    Item.FParent := Self;
    FItems.Insert(Index, Item);
    RebuildHandle;
  end;
end;

procedure TMenuItem.Delete(Index: Integer);
var
  Item: TMenuItem;
begin
  if (Index >= 0) and (Index < FItems.Count) then
  begin
    Item := TMenuItem(FItems[Index]);
    FItems.Delete(Index);
    Item.FParent := nil;
    Item.Free;
    RebuildHandle;
  end;
end;

procedure TMenuItem.Remove(Item: TMenuItem);
var
  Idx: Integer;
begin
  Idx := IndexOf(Item);
  if Idx >= 0 then
  begin
    FItems.Delete(Idx);
    Item.FParent := nil;
    RebuildHandle;
  end;
end;

procedure TMenuItem.Clear;
var
  Item: TMenuItem;
begin
  while FItems.Count > 0 do
  begin
    Item := TMenuItem(FItems[FItems.Count - 1]);
    FItems.Delete(FItems.Count - 1);
    Item.FParent := nil;
    Item.Free;
  end;
  RebuildHandle;
end;

function TMenuItem.IndexOf(Item: TMenuItem): Integer;
begin
  Result := FItems.IndexOf(Item);
end;

function TMenuItem.IndexOfId(Id: Word): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FItems.Count - 1 do
  begin
    if TMenuItem(FItems[I]).Command = Id then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

function TMenuItem.Find(const ACaption: string): TMenuItem;
var
  I: Integer;
  M: TMenuItem;
begin
  Result := nil;
  for I := 0 to FItems.Count - 1 do
  begin
    M := TMenuItem(FItems[I]);
    if M.Caption = ACaption then
    begin
      Result := M;
      Exit;
    end;
  end;
end;

procedure TMenuItem.Click;
begin
  if FEnabled and Assigned(FOnClick) then
    FOnClick(Self);
end;

procedure TMenuItem.RebuildHandle;
begin
  if FHandle <> 0 then
  begin
    DestroyMenu(FHandle);
    FHandle := 0;
  end;
  if FParent <> nil then
    FParent.RebuildHandle;
end;

function TMenuItem.GetHandle: HMENU;
var
  I: Integer;
  Child: TMenuItem;
  Flags: UINT;
  ItemId: UINT;
  CapStr: string;
begin
  if FHandle = 0 then
  begin
    FHandle := CreatePopupMenu;
    for I := 0 to FItems.Count - 1 do
    begin
      Child := TMenuItem(FItems[I]);
      if Child.Visible then
      begin
        Flags := 0;
        if Child.Caption = '-' then
          Flags := Flags or MF_SEPARATOR
        else
          Flags := Flags or MF_STRING;

        if Child.Count > 0 then
        begin
          Flags := Flags or MF_POPUP;
          ItemId := UINT(Child.Handle);
        end
        else
          ItemId := Child.Command;

        if Child.Checked then
          Flags := Flags or MF_CHECKED;
        if not Child.Enabled then
          Flags := Flags or MF_GRAYED;
        if Child.Break = mbBreak then
          Flags := Flags or MF_MENUBREAK
        else if Child.Break = mbBarBreak then
          Flags := Flags or MF_MENUBARBREAK;

        CapStr := Child.Caption;
        if Child.ShortCut <> 0 then
          CapStr := CapStr + #9 + ShortCutToText(Child.ShortCut);

        AppendMenu(FHandle, Flags, ItemId, PChar(CapStr));
      end;
    end;
  end;
  Result := FHandle;
end;

procedure TMenuItem.SetCaption(const Value: string);
begin
  if FCaption <> Value then
  begin
    FCaption := Value;
    RebuildHandle;
  end;
end;

procedure TMenuItem.SetChecked(Value: Boolean);
begin
  if FChecked <> Value then
  begin
    FChecked := Value;
    if FHandle <> 0 then
    begin
      if FChecked then
        CheckMenuItem(FHandle, FCommand, MF_BYCOMMAND or MF_CHECKED)
      else
        CheckMenuItem(FHandle, FCommand, MF_BYCOMMAND or MF_UNCHECKED);
    end;
  end;
end;

procedure TMenuItem.SetEnabled(Value: Boolean);
begin
  if FEnabled <> Value then
  begin
    FEnabled := Value;
    if FHandle <> 0 then
    begin
      if FEnabled then
        EnableMenuItem(FHandle, FCommand, MF_BYCOMMAND or MF_ENABLED)
      else
        EnableMenuItem(FHandle, FCommand, MF_BYCOMMAND or MF_GRAYED);
    end;
  end;
end;

procedure TMenuItem.SetVisible(Value: Boolean);
begin
  if FVisible <> Value then
  begin
    FVisible := Value;
    RebuildHandle;
  end;
end;

procedure TMenuItem.SetShortCut(Value: TShortCut);
begin
  if FShortCut <> Value then
  begin
    FShortCut := Value;
    RebuildHandle;
  end;
end;

{ TMenu }

constructor TMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FItems := TMenuItem.Create(Self);
  FWindowHandle := 0;
end;

destructor TMenu.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

function TMenu.GetHandle: HMENU;
begin
  Result := FItems.Handle;
end;

function FindInItem(Item: TMenuItem; Value: Word; Kind: TFindItemKind): TMenuItem;
var
  I: Integer;
  Res: TMenuItem;
begin
  Result := nil;
  if Item = nil then Exit;
  case Kind of
    fkCommand: if Item.Command = Value then begin Result := Item; Exit; end;
    fkHandle: if Item.Handle = HMENU(Value) then begin Result := Item; Exit; end;
    fkShortCut: if Item.ShortCut = Value then begin Result := Item; Exit; end;
  end;
  for I := 0 to Item.Count - 1 do
  begin
    Res := FindInItem(Item[I], Value, Kind);
    if Res <> nil then begin Result := Res; Exit; end;
  end;
end;

function TMenu.FindItem(Value: Word; Kind: TFindItemKind): TMenuItem;
begin
  Result := FindInItem(FItems, Value, Kind);
end;

function TMenu.DispatchCommand(ACommand: Word): Boolean;
var
  Item: TMenuItem;
begin
  Item := FindItem(ACommand, fkCommand);
  if Item <> nil then
  begin
    Item.Click;
    Result := True;
  end
  else
    Result := False;
end;

function TMenu.DispatchPopup(AHandle: HMENU): Boolean;
begin
  Result := False;
end;

procedure TMenu.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_COMMAND:
      DispatchCommand(Message.WParam);
    WM_INITMENUPOPUP:
      DispatchPopup(Message.WParam);
  end;
end;

function IsAccel(VK: Word; const Str: string): Boolean;
var
  P: Integer;
  Ch: Char;
begin
  Result := False;
  P := Pos('&', Str);
  if (P > 0) and (P < Length(Str)) then
    Ch := UpCase(Str[P + 1])
  else if Length(Str) > 0 then
    Ch := UpCase(Str[1])
  else
    Exit;
  Result := (Word(Ch) = VK) or (Word(UpCase(Ch)) = VK);
end;

function TMenu.IsAccel(VK: Word; const Str: string): Boolean;
begin
  Result := Menus.IsAccel(VK, Str);
end;

{ TMainMenu }

constructor TMainMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

function TMainMenu.GetHandle: HMENU;
var
  I: Integer;
  Child: TMenuItem;
  Flags: UINT;
  ItemId: UINT;
begin
  if FItems.FHandle = 0 then
  begin
    FItems.FHandle := CreateMenu;
    for I := 0 to FItems.Count - 1 do
    begin
      Child := FItems[I];
      if Child.Visible then
      begin
        Flags := 0;
        if Child.Count > 0 then
        begin
          Flags := Flags or MF_POPUP;
          ItemId := UINT(Child.Handle);
        end
        else
        begin
          Flags := Flags or MF_STRING;
          ItemId := Child.Command;
        end;
        if not Child.Enabled then
          Flags := Flags or MF_GRAYED;
        AppendMenu(FItems.FHandle, Flags, ItemId, PChar(Child.Caption));
      end;
    end;
  end;
  Result := FItems.FHandle;
end;

{ TPopupMenu }

constructor TPopupMenu.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAlignment := paLeft;
  FAutoPopup := True;
  FTrackButton := tbRightButton;
end;

procedure TPopupMenu.Popup(X, Y: Integer);
var
  AlignFlags: UINT;
  TargetWnd: HWND;
begin
  if Assigned(FOnPopup) then
    FOnPopup(Self);
  AlignFlags := TPM_LEFTALIGN;
  case FAlignment of
    paRight:  AlignFlags := TPM_RIGHTALIGN;
    paCenter: AlignFlags := TPM_CENTERALIGN;
  end;
  if FTrackButton = tbLeftButton then
    AlignFlags := AlignFlags or TPM_LEFTBUTTON
  else
    AlignFlags := AlignFlags or TPM_RIGHTBUTTON;

  TargetWnd := FWindowHandle;
  if TargetWnd = 0 then
    TargetWnd := GetActiveWindow;

  TrackPopupMenu(Items.Handle, AlignFlags, X, Y, 0, TargetWnd, nil);
end;

{ Helper functions }

function NewItem(const ACaption: string; AShortCut: TShortCut;
  AChecked, AEnabled: Boolean; AOnClick: TNotifyEvent;
  hCtx: Word; const AName: string): TMenuItem;
begin
  Result := TMenuItem.Create(nil);
  Result.Caption := ACaption;
  Result.ShortCut := AShortCut;
  Result.Checked := AChecked;
  Result.Enabled := AEnabled;
  Result.OnClick := AOnClick;
  Result.HelpContext := hCtx;
  Result.Name := AName;
end;

function NewLine: TMenuItem;
begin
  Result := NewItem('-', 0, False, True, nil, 0, '');
end;

function NewSubMenu(const ACaption: string; hCtx: Word;
  const AName: string; const Items: array of TMenuItem): TMenuItem;
var
  I: Integer;
begin
  Result := NewItem(ACaption, 0, False, True, nil, hCtx, AName);
  for I := Low(Items) to High(Items) do
    Result.Add(Items[I]);
end;

function ShortCut(Key: Word; Shift: TShiftState): TShortCut;
var
  S: Word;
begin
  S := 0;
  if ssShift in Shift then S := S or $2000;
  if ssCtrl in Shift then S := S or $4000;
  if ssAlt in Shift then S := S or $8000;
  Result := (Key and $FF) or S;
end;

procedure ShortCutToKey(ShortCut: TShortCut; var Key: Word; var Shift: TShiftState);
begin
  Key := ShortCut and $FF;
  Shift := [];
  if (ShortCut and $2000) <> 0 then Include(Shift, ssShift);
  if (ShortCut and $4000) <> 0 then Include(Shift, ssCtrl);
  if (ShortCut and $8000) <> 0 then Include(Shift, ssAlt);
end;

function ShortCutToText(ShortCut: TShortCut): string;
var
  Key: Word;
  Shift: TShiftState;
  S: string;
begin
  if ShortCut = 0 then
  begin
    Result := '';
    Exit;
  end;
  ShortCutToKey(ShortCut, Key, Shift);
  S := '';
  if ssCtrl in Shift then S := S + 'Ctrl+';
  if ssAlt in Shift then S := S + 'Alt+';
  if ssShift in Shift then S := S + 'Shift+';
  if (Key >= Ord('A')) and (Key <= Ord('Z')) then
    S := S + Chr(Key)
  else if (Key >= Ord('0')) and (Key <= Ord('9')) then
    S := S + Chr(Key)
  else if (Key >= VK_F1) and (Key <= VK_F12) then
    S := S + 'F' + Chr(Ord('1') + (Key - VK_F1))
  else
    S := S + Chr(Key);
  Result := S;
end;

function TextToShortCut(const Text: string): TShortCut;
begin
  { Podstawowa konwersja }
  Result := 0;
end;

initialization

finalization
  if MenuItemList <> nil then
  begin
    MenuItemList.Free;
    MenuItemList := nil;
  end;

end.
