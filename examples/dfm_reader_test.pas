program rt;
{$MODE DELPHI}
{$M+}
uses WinTypes, WinProcs, Classes, SysUtils;
type
  TTestObj = class(TComponent)
  private
    FLeft: Integer;
    FCaption: string;
    FOnHit: TNotifyEvent;
  published
    property Left: Integer read FLeft write FLeft;
    property Caption: string read FCaption write FCaption;
    property OnHit: TNotifyEvent read FOnHit write FOnHit;
  end;
const
  Blob: array[0..39] of Byte = (
    $54,$50,$46,$30, 8,Ord('T'),Ord('T'),Ord('e'),Ord('s'),Ord('t'),Ord('O'),Ord('b'),Ord('j'),
    4,Ord('O'),Ord('b'),Ord('j'),Ord('1'),
    4,Ord('L'),Ord('e'),Ord('f'),Ord('t'), 2, 5,
    7,Ord('C'),Ord('a'),Ord('p'),Ord('t'),Ord('i'),Ord('o'),Ord('n'), 6, 2,Ord('h'),Ord('i'),
    0,0,0);
var
  M: TMemoryStream;
  R: TReader;
  C: TComponent;
  s: string;
begin
  OutputDebugString('RT start');
  RegisterClass(TTestObj);
  M := TMemoryStream.Create;
  M.Write(Blob, SizeOf(Blob));
  M.Position := 0;
  C := M.ReadComponent(nil);
  Str(TTestObj(C).Left, s);
  OutputDebugString(PChar('RT left=' + s + ' caption=' + TTestObj(C).Caption));
end.
