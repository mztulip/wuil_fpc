unit TabNotBk;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, Graphics, Controls, Forms, ExtCtrls;

type
  TPage = ExtCtrls.TPage;
  TNotebook = ExtCtrls.TNotebook;

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
