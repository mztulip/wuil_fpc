unit ShellAPI;

{$MODE DELPHI}

interface

uses
  WinTypes, WinProcs, Classes;

type
  HDROP = Word;
  HKey = Longint;
  PHKey = ^HKey;

const
  HKEY_CLASSES_ROOT = 1;
  ERROR_SUCCESS = 0;
  REG_SZ = 1;

  { Errors }
  SE_ERR_FNF             = 2;
  SE_ERR_PNF             = 3;
  SE_ERR_ACCESSDENIED    = 5;
  SE_ERR_OOM             = 8;
  SE_ERR_DLLNOTFOUND     = 32;
  SE_ERR_SHARE           = 26;
  SE_ERR_ASSOCINCOMPLETE = 27;
  SE_ERR_DDETIMEOUT      = 28;
  SE_ERR_DDEFAIL         = 29;
  SE_ERR_DDEBUSY         = 30;
  SE_ERR_NOASSOC         = 31;

function RegOpenKey(hKey: HKey; lpSubKey: LPCSTR; var phkResult: HKey): Longint; far; external 'SHELL' index 1;
function RegCreateKey(hKey: HKey; lpSubKey: LPCSTR; var phkResult: HKey): Longint; far; external 'SHELL' index 2;
function RegCloseKey(hKey: HKey): Longint; far; external 'SHELL' index 3;
function RegDeleteKey(hKey: HKey; lpSubKey: LPCSTR): Longint; far; external 'SHELL' index 4;
function RegSetValue(hKey: HKey; lpSubKey: LPCSTR; dwType: Longint; lpData: LPCSTR; cbData: Longint): Longint; far; external 'SHELL' index 5;
function RegQueryValue(hKey: HKey; lpSubKey: LPCSTR; lpValue: LPSTR; var lpcbValue: Longint): Longint; far; external 'SHELL' index 6;
function RegEnumKey(hKey: HKey; iSubKey: Longint; lpName: LPSTR; cchName: Longint): Longint; far; external 'SHELL' index 7;

function DragAcceptFiles(hwnd: HWND; fAccept: BOOL): BOOL; far; external 'SHELL' index 9;
function DragQueryFile(hDrop: HDROP; iFile: UINT; lpszFile: LPSTR; cb: UINT): UINT; far; external 'SHELL' index 11;
procedure DragFinish(hDrop: HDROP); far; external 'SHELL' index 12;
function DragQueryPoint(hDrop: HDROP; var ppt: TPoint): BOOL; far; external 'SHELL' index 13; overload;
function DragQueryPoint(hDrop: HDROP; var ppt: POINT): BOOL; far; external 'SHELL' index 13; overload;
function ShellExecute(hwnd: HWND; lpszOp, lpszFile, lpszParams, lpszDir: LPCSTR; fsShowCmd: Integer): THandle; far; external 'SHELL' index 20;
function FindExecutable(lpFile, lpDirectory, lpResult: LPCSTR): THandle; far; external 'SHELL' index 21;
function ShellAbout(hwnd: HWND; szApp, szOtherStuff: LPCSTR; hIcon: HICON): Integer; far; external 'SHELL' index 22;
function ExtractIcon(hInst: THandle; lpszExeFileName: LPCSTR; nIconIndex: UINT): HICON; far; external 'SHELL' index 34;
function ExtractAssociatedIcon(hInst: THandle; lpIconPath: LPCSTR; var lpiIcon: Word): HICON; far; external 'SHELL' index 36;
function DoEnvironmentSubst(szString: LPSTR; cbWidth: UINT): UINT; far; external 'SHELL' index 37;
function RegisterShellHook(hwnd: HWND; fInstall: BOOL): BOOL; far; external 'SHELL' index 102;

implementation

end.
