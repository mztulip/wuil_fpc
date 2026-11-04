unit Clipbrd;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, SysUtils;

type
  TClipboard = class(TObject)
  public
    procedure Clear;
    procedure Open;
    procedure Close;
    function HasFormat(Format: Word): Boolean;
    function GetAsHandle(Format: Word): THandle;
    procedure SetAsHandle(Format: Word; Value: THandle);
    function AsText: string;
    procedure SetTextBuf(Buffer: PChar);
    function GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;
  end;

function Clipboard: TClipboard;

implementation

var
  FClipboard: TClipboard = nil;

function Clipboard: TClipboard;
begin
  if FClipboard = nil then
    FClipboard := TClipboard.Create;
  Result := FClipboard;
end;

procedure TClipboard.Clear;
begin
  Open;
  try
    EmptyClipboard;
  finally
    Close;
  end;
end;

procedure TClipboard.Open;
begin
  OpenClipboard(GetActiveWindow);
end;

procedure TClipboard.Close;
begin
  CloseClipboard;
end;

function TClipboard.HasFormat(Format: Word): Boolean;
begin
  Result := IsClipboardFormatAvailable(Format);
end;

function TClipboard.GetAsHandle(Format: Word): THandle;
begin
  Open;
  try
    Result := GetClipboardData(Format);
  finally
    Close;
  end;
end;

procedure TClipboard.SetAsHandle(Format: Word; Value: THandle);
begin
  Open;
  try
    EmptyClipboard;
    SetClipboardData(Format, Value);
  finally
    Close;
  end;
end;

function TClipboard.AsText: string;
var
  Data: THandle;
  P: PChar;
begin
  Result := '';
  Open;
  try
    Data := GetClipboardData(CF_TEXT);
    if Data <> 0 then
    begin
      P := GlobalLock(Data);
      if P <> nil then
      begin
        Result := StrPas(P);
        GlobalUnlock(Data);
      end;
    end;
  finally
    Close;
  end;
end;

procedure TClipboard.SetTextBuf(Buffer: PChar);
var
  Data: THandle;
  P: PChar;
  Len: Integer;
begin
  if Buffer <> nil then
  begin
    Len := StrLen(Buffer) + 1;
    Data := GlobalAlloc(GMEM_MOVEABLE or GMEM_DDESHARE, Len);
    if Data <> 0 then
    begin
      P := GlobalLock(Data);
      if P <> nil then
      begin
        StrCopy(P, Buffer);
        GlobalUnlock(Data);
        SetAsHandle(CF_TEXT, Data);
      end;
    end;
  end;
end;

function TClipboard.GetTextBuf(Buffer: PChar; BufSize: Integer): Integer;
var
  S: string;
begin
  S := AsText;
  StrLCopy(Buffer, PChar(S), BufSize - 1);
  Result := StrLen(Buffer);
end;

initialization

finalization
  if FClipboard <> nil then
  begin
    FClipboard.Free;
    FClipboard := nil;
  end;

end.
