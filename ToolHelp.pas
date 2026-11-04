unit ToolHelp;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs;

const
  NO_UAE_BOX = 1;

type
  PTimerInfo = ^TTimerInfo;
  tagTIMERINFO = record
    dwSize: LongInt;
    dwmsSinceStart: LongInt;
    dwmsThisVM: LongInt;
  end;
  TTimerInfo = tagTIMERINFO;

  PTaskEntry = ^TTaskEntry;
  tagTASKENTRY = record
    dwSize: LongInt;
    hTask: HTASK;
    hTaskParent: HTASK;
    hInst: THandle;
    hModule: THandle;
    wSS: Word;
    wSP: Word;
    wStackTop: Word;
    wStackMinimum: Word;
    wStackBottom: Word;
    rcUsage: Word;
    hNext: HTASK;
    szExePath: array[0..259] of Char;
  end;
  TTaskEntry = tagTASKENTRY;

  PModuleEntry = ^TModuleEntry;
  tagMODULEENTRY = record
    dwSize: LongInt;
    szModule: array[0..9] of Char;
    hModule: THandle;
    wcUsage: Word;
    szExePath: array[0..255] of Char;
    wNext: Word;
  end;
  TModuleEntry = tagMODULEENTRY;

  PGlobalEntry = ^TGlobalEntry;
  tagGLOBALENTRY = record
    dwSize: LongInt;
    dwAddress: LongInt;
    dwBlockSize: LongInt;
    hBlock: THandle;
    wcLock: Word;
    wcPageLock: Word;
    wFlags: Word;
    wHeapPresent: Boolean;
    hOwner: THandle;
    wType: Word;
    wData: Word;
    dwNext: LongInt;
    dwNextAlt: LongInt;
  end;
  TGlobalEntry = tagGLOBALENTRY;

function TimerCount(lpTimerInfo: PTimerInfo): BOOL; far; external 'TOOLHELP' index 80;
function InterruptRegister(task: HTASK; proc: FARPROC): BOOL; far; external 'TOOLHELP' index 75;
function InterruptUnRegister(task: HTASK): BOOL; far; external 'TOOLHELP' index 76;
function NotifyRegister(task: HTASK; proc: FARPROC; fl: Word): BOOL; far; external 'TOOLHELP' index 73;
function NotifyUnregister(task: HTASK): BOOL; far; external 'TOOLHELP' index 74;
procedure TerminateApp(task: HTASK; fl: Word); far; external 'TOOLHELP' index 77;
function ModuleFindHandle(var me: TModuleEntry; hmod: THandle): Word; far; external 'TOOLHELP' index 62;
function ModuleFindName(var me: TModuleEntry; lpszName: LPCSTR): Word; far; external 'TOOLHELP' index 61;
function ModuleFirst(var me: TModuleEntry): BOOL; far; external 'TOOLHELP' index 59;
function ModuleNext(var me: TModuleEntry): BOOL; far; external 'TOOLHELP' index 60;
function TaskFirst(var te: TTaskEntry): BOOL; far; external 'TOOLHELP' index 63;
function TaskNext(var te: TTaskEntry): BOOL; far; external 'TOOLHELP' index 64;
function TaskFindHandle(var te: TTaskEntry; task: HTASK): BOOL; far; external 'TOOLHELP' index 65;
function GlobalFirst(var ge: TGlobalEntry; wFlags: Word): BOOL; far; external 'TOOLHELP' index 51;
function GlobalNext(var ge: TGlobalEntry; wFlags: Word): BOOL; far; external 'TOOLHELP' index 52;
function GlobalEntryHandle(var ge: TGlobalEntry; hBlock: THandle): BOOL; far; external 'TOOLHELP' index 54;
function GlobalEntryModule(var ge: TGlobalEntry; hModule: THandle; wSeg: Word): BOOL; far; external 'TOOLHELP' index 55;
function GlobalHandleToSel(hMem: THandle): Word; far; external 'TOOLHELP' index 50;

implementation

end.
