unit TabNotBk;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms;

type
  TPage = class(TWinControl)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  TNotebook = class(TWinControl)
  private
    FPages: TStrings;
    FPageIndex: Integer;
    FOnPageChanged: TNotifyEvent;
    function GetActivePage: string;
    procedure SetActivePage(const Value: string);
    procedure SetPageIndex(Value: Integer);
    procedure SetPages(Value: TStrings);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure ShowCurrentPage; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ActivePage: string read GetActivePage write SetActivePage;
  published
    property Pages: TStrings read FPages write SetPages;
    property PageIndex: Integer read FPageIndex write SetPageIndex default 0;
    property OnPageChanged: TNotifyEvent read FOnPageChanged write FOnPageChanged;
    property Enabled;
    property Visible;
    property Font;
    property Color;
  end;

  TTabbedNotebook = class(TWinControl)
  private
    FPages: TStrings;
    FPageIndex: Integer;
    FOnChange: TNotifyEvent;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Pages: TStrings read FPages write FPages;
    property PageIndex: Integer read FPageIndex write FPageIndex default 0;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
  end;

implementation

{ TPage }

constructor TPage.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FVisible := True;
end;

{ TNotebook }

constructor TNotebook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TStringList.Create;
  FPageIndex := 0;
  FWidth := 150;
  FHeight := 150;
end;

destructor TNotebook.Destroy;
var
  I: Integer;
begin
  for I := 0 to FPages.Count - 1 do
  begin
    if FPages.Objects[I] <> nil then
      TObject(FPages.Objects[I]).Free;
  end;
  FPages.Free;
  inherited Destroy;
end;

procedure TNotebook.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

function TNotebook.GetActivePage: string;
begin
  if (FPageIndex >= 0) and (FPageIndex < FPages.Count) then
    Result := FPages[FPageIndex]
  else
    Result := '';
end;

procedure TNotebook.SetActivePage(const Value: string);
var
  Idx: Integer;
begin
  Idx := FPages.IndexOf(Value);
  if Idx >= 0 then
    SetPageIndex(Idx);
end;

procedure TNotebook.SetPageIndex(Value: Integer);
begin
  if FPageIndex <> Value then
  begin
    FPageIndex := Value;
    ShowCurrentPage;
    if Assigned(FOnPageChanged) then
      FOnPageChanged(Self);
  end;
end;

procedure TNotebook.SetPages(Value: TStrings);
begin
  FPages.Assign(Value);
  if FPageIndex >= FPages.Count then
    FPageIndex := FPages.Count - 1;
  ShowCurrentPage;
end;

procedure TNotebook.ShowCurrentPage;
var
  I: Integer;
  P: TControl;
begin
  for I := 0 to FPages.Count - 1 do
  begin
    if FPages.Objects[I] is TControl then
    begin
      P := TControl(FPages.Objects[I]);
      P.Visible := (I = FPageIndex);
    end;
  end;
end;

{ TTabbedNotebook }

constructor TTabbedNotebook.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPages := TStringList.Create;
  FPageIndex := 0;
  FWidth := 200;
  FHeight := 150;
end;

destructor TTabbedNotebook.Destroy;
begin
  FPages.Free;
  inherited Destroy;
end;

end.
