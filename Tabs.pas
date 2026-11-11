unit Tabs;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Forms, Controls;

type
  TTabStyle = (tsTabs, tsButtons);
  TTabPosition = (tpTop, tpBottom);
  TTabChangeEvent = procedure(Sender: TObject; NewTab: Integer; var AllowChange: Boolean) of object;

  TTabSet = class(TWinControl)
  private
    FTabs: TStrings;
    FTabIndex: Integer;
    FOnChange: TTabChangeEvent;
    procedure SetTabs(Value: TStrings);
    procedure SetTabIndex(Value: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Tabs: TStrings read FTabs write SetTabs;
    property TabIndex: Integer read FTabIndex write SetTabIndex default -1;
    property OnChange: TTabChangeEvent read FOnChange write FOnChange;
  end;

implementation

constructor TTabSet.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FTabs := TStringList.Create;
  FTabIndex := -1;
end;

destructor TTabSet.Destroy;
begin
  FTabs.Free;
  inherited Destroy;
end;

procedure TTabSet.SetTabs(Value: TStrings);
begin
  FTabs.Assign(Value);
end;

procedure TTabSet.SetTabIndex(Value: Integer);
var
  Allow: Boolean;
begin
  if FTabIndex <> Value then
  begin
    Allow := True;
    if Assigned(FOnChange) then
      FOnChange(Self, Value, Allow);
    if Allow then
    begin
      FTabIndex := Value;
      Invalidate;
    end;
  end;
end;

initialization
  RegisterClasses([TTabSet]);

end.
