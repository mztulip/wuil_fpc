unit DdeMan;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, SysUtils, Forms, Messages;

type
  EDdeError = class(Exception);

  TDdeConnectMode = (ddeAutomatic, ddeManual);

  TDdeMacroEvent = procedure(Sender: TObject; Msg: TStrings) of object;

  TDdeClientConv = class(TComponent)
  private
    FConnectMode: TDdeConnectMode;
    FServiceApplication: string;
    FDdeService: string;
    FDdeTopic: string;
    FLinkInfo: string;
    FConnected: Boolean;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure SetLink(const Service, Topic: string);
    function OpenLink: Boolean; virtual;
    procedure CloseLink; virtual;
    function RequestData(const Item: string): PChar; virtual;
    function ExecuteMacro(Command: PChar; WaitFlg: Boolean): Boolean; virtual;
    function ExecuteMacroLines(Commands: TStrings; WaitFlg: Boolean): Boolean; virtual;
    function PokeData(const Item: string; Data: PChar): Boolean; virtual;
    function PokeDataLines(const Item: string; Lines: TStrings): Boolean; virtual;

    property Connected: Boolean read FConnected;
  published
    property ServiceApplication: string read FServiceApplication write FServiceApplication;
    property ConnectMode: TDdeConnectMode read FConnectMode write FConnectMode default ddeManual;
    property DdeService: string read FDdeService write FDdeService;
    property DdeTopic: string read FDdeTopic write FDdeTopic;
    property LinkInfo: string read FLinkInfo write FLinkInfo;
  end;

  TDdeServerConv = class(TComponent)
  private
    FTopic: string;
    FFormatChars: Boolean;
    FOnOpen: TNotifyEvent;
    FOnClose: TNotifyEvent;
    FOnExecuteMacro: TDdeMacroEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Topic: string read FTopic write FTopic;
    property FormatChars: Boolean read FFormatChars write FFormatChars default False;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    property OnExecuteMacro: TDdeMacroEvent read FOnExecuteMacro write FOnExecuteMacro;
  end;

  TDdeServerItem = class(TComponent)
  private
    FServerConv: TDdeServerConv;
    FText: string;
    FLines: TStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property ServerConv: TDdeServerConv read FServerConv write FServerConv;
    property Text: string read FText write FText;
    property Lines: TStrings read FLines write FLines;
  end;

  TDdeClientItem = class(TComponent)
  private
    FDdeConv: TDdeClientConv;
    FDdeItem: string;
    FText: string;
    FLines: TStrings;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property DdeConv: TDdeClientConv read FDdeConv write FDdeConv;
    property DdeItem: string read FDdeItem write FDdeItem;
    property Text: string read FText write FText;
    property Lines: TStrings read FLines write FLines;
  end;

  TDdeMgr = class(TComponent)
  private
    FAppName: string;
    procedure SetAppName(const Value: string);
  public
    constructor Create(AOwner: TComponent); override;
    property AppName: string read FAppName write SetAppName;
  end;

var
  DdeMgr: TDdeMgr;

implementation

{ TDdeClientConv }

constructor TDdeClientConv.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnectMode := ddeManual;
  FConnected := False;
end;

destructor TDdeClientConv.Destroy;
begin
  if FConnected then
    CloseLink;
  inherited Destroy;
end;

procedure TDdeClientConv.SetLink(const Service, Topic: string);
begin
  FDdeService := Service;
  FDdeTopic := Topic;
  FLinkInfo := 'Service ' + Service + #13#10 + 'Topic ' + Topic;
end;

function TDdeClientConv.OpenLink: Boolean;
begin
  // Basic link opening state
  FConnected := True;
  Result := True;
end;

procedure TDdeClientConv.CloseLink;
begin
  FConnected := False;
end;

function TDdeClientConv.RequestData(const Item: string): PChar;
var
  p: PChar;
begin
  // Return empty string allocated via StrAlloc so caller can safely StrDispose it
  p := StrAlloc(1);
  p[0] := #0;
  Result := p;
end;

function TDdeClientConv.ExecuteMacro(Command: PChar; WaitFlg: Boolean): Boolean;
begin
  Result := True;
end;

function TDdeClientConv.ExecuteMacroLines(Commands: TStrings; WaitFlg: Boolean): Boolean;
begin
  Result := True;
end;

function TDdeClientConv.PokeData(const Item: string; Data: PChar): Boolean;
begin
  Result := True;
end;

function TDdeClientConv.PokeDataLines(const Item: string; Lines: TStrings): Boolean;
begin
  Result := True;
end;

{ TDdeServerConv }

constructor TDdeServerConv.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FFormatChars := False;
end;

destructor TDdeServerConv.Destroy;
begin
  inherited Destroy;
end;

{ TDdeServerItem }

constructor TDdeServerItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TStringList.Create;
end;

destructor TDdeServerItem.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

{ TDdeClientItem }

constructor TDdeClientItem.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLines := TStringList.Create;
end;

destructor TDdeClientItem.Destroy;
begin
  FLines.Free;
  inherited Destroy;
end;

{ TDdeMgr }

constructor TDdeMgr.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAppName := 'CALMIRA';
end;

procedure TDdeMgr.SetAppName(const Value: string);
begin
  FAppName := Value;
end;

initialization
  DdeMgr := TDdeMgr.Create(nil);

finalization
  DdeMgr.Free;
  DdeMgr := nil;

end.
