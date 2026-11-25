unit IniFiles;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes, SysUtils;

type
  TPoint = WinTypes.TPoint;
  TRect = WinTypes.TRect;

  TIniFile = class(TObject)
  private
    FFileName: string;
  public
    constructor Create(const AFileName: string);
    destructor Destroy; override;
    function ReadString(const Section, Ident, Default: string): string; virtual;
    procedure WriteString(const Section, Ident, Value: string); virtual;
    function ReadInteger(const Section, Ident: string; Default: LongInt): LongInt; virtual;
    procedure WriteInteger(const Section, Ident: string; Value: LongInt); virtual;
    function ReadBool(const Section, Ident: string; Default: Boolean): Boolean; virtual;
    procedure WriteBool(const Section, Ident: string; Value: Boolean); virtual;
    procedure ReadSection(const Section: string; Strings: TStrings); virtual;
    procedure ReadSections(Strings: TStrings); virtual;
    procedure ReadSectionValues(const Section: string; Strings: TStrings); virtual;
    procedure EraseSection(const Section: string); virtual;
    procedure DeleteKey(const Section, Ident: string); virtual;
    procedure UpdateFile; virtual;
    property FileName: string read FFileName;
  end;

function Point(AX, AY: Integer): TPoint;

implementation

function Point(AX, AY: Integer): TPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

constructor TIniFile.Create(const AFileName: string);
begin
  inherited Create;
  FFileName := AFileName;
end;

destructor TIniFile.Destroy;
begin
  UpdateFile;
  inherited Destroy;
end;

function TIniFile.ReadString(const Section, Ident, Default: string): string;
var
  Buf: array[0..255] of Char;
  Len: Integer;
begin
  Len := GetPrivateProfileString(
    PChar(Section),
    PChar(Ident),
    PChar(Default),
    Buf,
    SizeOf(Buf),
    PChar(FFileName)
  );
  if Len > 0 then
    Result := StrPas(Buf)
  else
    Result := Default;
end;

procedure TIniFile.WriteString(const Section, Ident, Value: string);
begin
  WritePrivateProfileString(
    PChar(Section),
    PChar(Ident),
    PChar(Value),
    PChar(FFileName)
  );
end;

function TIniFile.ReadInteger(const Section, Ident: string; Default: LongInt): LongInt;
var
  S: string;
begin
  S := ReadString(Section, Ident, '');
  if Length(S) = 0 then
    Result := Default
  else
    Result := StrToIntDef(Trim(S), Default);
end;

procedure TIniFile.WriteInteger(const Section, Ident: string; Value: LongInt);
begin
  WriteString(Section, Ident, IntToStr(Value));
end;

function TIniFile.ReadBool(const Section, Ident: string; Default: Boolean): Boolean;
begin
  Result := ReadInteger(Section, Ident, Ord(Default)) <> 0;
end;

procedure TIniFile.WriteBool(const Section, Ident: string; Value: Boolean);
begin
  WriteInteger(Section, Ident, Ord(Value));
end;

procedure TIniFile.ReadSection(const Section: string; Strings: TStrings);
var
  Buf: PChar;
  P: PChar;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    GetMem(Buf, 2048);
    try
      GetPrivateProfileString(PChar(Section), nil, '', Buf, 2048, PChar(FFileName));
      P := Buf;
      while P^ <> #0 do
      begin
        Strings.Add(StrPas(P));
        P := P + StrLen(P) + 1;
      end;
    finally
      FreeMem(Buf, 2048);
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.ReadSections(Strings: TStrings);
var
  Buf: PChar;
  P: PChar;
  F: TextFile;
  Line: string;
begin
  Strings.BeginUpdate;
  try
    Strings.Clear;
    GetMem(Buf, 2048);
    try
      { Najpierw próba przez API }
      if GetPrivateProfileString(nil, nil, '', Buf, 2048, PChar(FFileName)) > 0 then
      begin
        P := Buf;
        while P^ <> #0 do
        begin
          Strings.Add(StrPas(P));
          P := P + StrLen(P) + 1;
        end;
      end
      else
      begin
        { Fallback na skanowanie pliku tekstowego }
        if FileExists(FFileName) then
        begin
          AssignFile(F, FFileName);
          Reset(F);
          try
            while not Eof(F) do
            begin
              Readln(F, Line);
              Line := Trim(Line);
              if (Length(Line) > 2) and (Line[1] = '[') and (Line[Length(Line)] = ']') then
                Strings.Add(Copy(Line, 2, Length(Line) - 2));
            end;
          finally
            CloseFile(F);
          end;
        end;
      end;
    finally
      FreeMem(Buf, 2048);
    end;
  finally
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.ReadSectionValues(const Section: string; Strings: TStrings);
var
  KeyList: TStringList;
  I: Integer;
begin
  Strings.BeginUpdate;
  KeyList := TStringList.Create;
  try
    Strings.Clear;
    ReadSection(Section, KeyList);
    for I := 0 to KeyList.Count - 1 do
      Strings.Add(KeyList[I] + '=' + ReadString(Section, KeyList[I], ''));
  finally
    KeyList.Free;
    Strings.EndUpdate;
  end;
end;

procedure TIniFile.EraseSection(const Section: string);
begin
  WritePrivateProfileString(PChar(Section), nil, nil, PChar(FFileName));
end;

procedure TIniFile.DeleteKey(const Section, Ident: string);
begin
  WritePrivateProfileString(PChar(Section), PChar(Ident), nil, PChar(FFileName));
end;

procedure TIniFile.UpdateFile;
begin
  WritePrivateProfileString(nil, nil, nil, PChar(FFileName));
end;

end.
