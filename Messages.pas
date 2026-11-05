unit Messages;

{$MODE DELPHI}

interface

uses
  WinTypes;

const
  { Standard Windows Messages (wypisane dla wygody lub aliasowane z WinTypes) }
  WM_NULL             = $0000;
  WM_CREATE           = $0001;
  WM_DESTROY          = $0002;
  WM_MOVE             = $0003;
  WM_SIZE             = $0005;
  WM_ACTIVATE         = $0006;
  WM_SETFOCUS         = $0007;
  WM_KILLFOCUS        = $0008;
  WM_ENABLE           = $000A;
  WM_SETREDRAW        = $000B;
  WM_SETTEXT          = $000C;
  WM_GETTEXT          = $000D;
  WM_GETTEXTLENGTH    = $000E;
  WM_PAINT            = $000F;
  WM_CLOSE            = $0010;
  WM_QUERYENDSESSION  = $0011;
  WM_QUIT             = $0012;
  WM_QUERYOPEN        = $0013;
  WM_ERASEBKGND       = $0014;
  WM_SYSCOLORCHANGE   = $0015;
  WM_ENDSESSION       = $0016;
  WM_SHOWWINDOW       = $0018;
  WM_WININICHANGE     = $001A;
  WM_DEVMODECHANGE    = $001B;
  WM_ACTIVATEAPP      = $001C;
  WM_FONTCHANGE       = $001D;
  WM_TIMECHANGE       = $001E;
  WM_CANCELMODE       = $001F;
  WM_SETCURSOR        = $0020;
  WM_MOUSEACTIVATE    = $0021;
  WM_CHILDACTIVATE    = $0022;
  WM_QUEUESYNC        = $0023;
  WM_GETMINMAXINFO    = $0024;
  WM_PAINTICON        = $0026;
  WM_ICONERASEBKGND   = $0027;
  WM_NEXTDLGCTL       = $0028;
  WM_SPOOLERSTATUS    = $002A;
  WM_DRAWITEM         = $002B;
  WM_MEASUREITEM      = $002C;
  WM_DELETEITEM       = $002D;
  WM_VKEYTOITEM       = $002E;
  WM_CHARTOITEM       = $002F;
  WM_SETFONT          = $0030;
  WM_GETFONT          = $0031;
  WM_SETHOTKEY        = $0032;
  WM_GETHOTKEY        = $0033;
  WM_QUERYDRAGICON    = $0037;
  WM_COMPAREITEM      = $0039;
  WM_COMPACTING       = $0041;
  WM_COMMNOTIFY       = $0044;
  WM_WINDOWPOSCHANGING = $0046;
  WM_WINDOWPOSCHANGED = $0047;
  WM_POWER            = $0048;

  WM_NCCREATE         = $0081;
  WM_NCDESTROY        = $0082;
  WM_NCCALCSIZE       = $0083;
  WM_NCHITTEST        = $0084;
  WM_NCPAINT          = $0085;
  WM_NCACTIVATE       = $0086;
  WM_GETDLGCODE       = $0087;

  WM_KEYDOWN          = $0100;
  WM_KEYUP            = $0101;
  WM_CHAR             = $0102;
  WM_DEADCHAR         = $0103;
  WM_SYSKEYDOWN       = $0104;
  WM_SYSKEYUP         = $0105;
  WM_SYSCHAR          = $0106;
  WM_SYSDEADCHAR      = $0107;

  WM_INITDIALOG       = $0110;
  WM_COMMAND          = $0111;
  WM_SYSCOMMAND       = $0112;
  WM_TIMER            = $0113;
  WM_HSCROLL          = $0114;
  WM_VSCROLL          = $0115;
  WM_INITMENU         = $0116;
  WM_INITMENUPOPUP    = $0117;
  WM_MENUSELECT       = $011F;
  WM_MENUCHAR         = $0120;
  WM_ENTERIDLE        = $0121;

  WM_MOUSEMOVE        = $0200;
  WM_LBUTTONDOWN      = $0201;
  WM_LBUTTONUP        = $0202;
  WM_LBUTTONDBLCLK    = $0203;
  WM_RBUTTONDOWN      = $0204;
  WM_RBUTTONUP        = $0205;
  WM_RBUTTONDBLCLK    = $0206;
  WM_MBUTTONDOWN      = $0207;
  WM_MBUTTONUP        = $0208;
  WM_MBUTTONDBLCLK    = $0209;

  WM_PARENTNOTIFY     = $0210;
  WM_ENTERMENULOOP    = $0211;
  WM_EXITMENULOOP     = $0212;
  WM_MDICREATE        = $0220;
  WM_MDIDESTROY       = $0221;
  WM_MDIACTIVATE      = $0222;
  WM_MDIRESTORE       = $0223;
  WM_MDINEXT          = $0224;
  WM_MDIMAXIMIZE      = $0225;
  WM_MDITILE          = $0226;
  WM_MDICASCADE       = $0227;
  WM_MDIICONARRANGE   = $0228;
  WM_MDIGETACTIVE     = $0229;
  WM_MDISETMENU       = $0230;
  WM_DROPFILES        = $0233;

  WM_CUT              = $0300;
  WM_COPY             = $0301;
  WM_PASTE            = $0302;
  WM_CLEAR            = $0303;
  WM_UNDO             = $0304;

  WM_USER             = $0400;

  { Component Messages }
  CM_BASE                   = $B000;
  CM_ACTIVATE               = CM_BASE + 0;
  CM_DEACTIVATE             = CM_BASE + 1;
  CM_GOTFOCUS               = CM_BASE + 2;
  CM_LOSTFOCUS              = CM_BASE + 3;
  CM_CANCELMODE             = CM_BASE + 4;
  CM_DIALOGKEY              = CM_BASE + 5;
  CM_DIALOGCHAR             = CM_BASE + 6;
  CM_FOCUSCHANGED           = CM_BASE + 7;
  CM_PARENTFONTCHANGED      = CM_BASE + 8;
  CM_PARENTCOLORCHANGED     = CM_BASE + 9;
  CM_HITTEST                = CM_BASE + 10;
  CM_VISIBLECHANGED         = CM_BASE + 11;
  CM_ENABLEDCHANGED         = CM_BASE + 12;
  CM_COLORCHANGED           = CM_BASE + 13;
  CM_FONTCHANGED            = CM_BASE + 14;
  CM_CURSORCHANGED          = CM_BASE + 15;
  CM_CTL3DCHANGED           = CM_BASE + 16;
  CM_PARENTCTL3DCHANGED     = CM_BASE + 17;
  CM_TEXTCHANGED            = CM_BASE + 18;
  CM_MOUSEENTER             = CM_BASE + 19;
  CM_MOUSELEAVE             = CM_BASE + 20;
  CM_MENUCHANGED            = CM_BASE + 21;
  CM_APPKEYDOWN             = CM_BASE + 22;
  CM_APPSYSCOMMAND          = CM_BASE + 23;
  CM_BUTTONPRESSED          = CM_BASE + 24;
  CM_SHOWINGCHANGED         = CM_BASE + 25;
  CM_ENTER                  = CM_BASE + 26;
  CM_EXIT                   = CM_BASE + 27;
  CM_DESIGNHITTEST          = CM_BASE + 28;
  CM_ICONCHANGED            = CM_BASE + 29;
  CM_WANTSPECIALKEY         = CM_BASE + 30;
  CM_INVOKEHELP             = CM_BASE + 31;
  CM_WINDOWHOOK             = CM_BASE + 32;
  CM_RELEASE                = CM_BASE + 33;
  CM_SHOWHINTCHANGED        = CM_BASE + 34;
  CM_PARENTSHOWHINTCHANGED  = CM_BASE + 35;
  CM_SYSCOLORCHANGE         = CM_BASE + 36;
  CM_WININICHANGE           = CM_BASE + 37;
  CM_FONTCHANGE             = CM_BASE + 38;
  CM_TIMECHANGE             = CM_BASE + 39;
  CM_TABSTOPCHANGED         = CM_BASE + 40;
  CM_UIACTIVATE             = CM_BASE + 41;
  CM_UIDEACTIVATE           = CM_BASE + 42;
  CM_DOCWINDOWACTIVATE      = CM_BASE + 43;
  CM_CONTROLLISTCHANGE      = CM_BASE + 44;
  CM_GETDATALINK            = CM_BASE + 45;
  CM_CHILDKEY               = CM_BASE + 46;
  CM_DRAG                   = CM_BASE + 47;
  CM_HINTSHOW               = CM_BASE + 48;
  CM_DIALOGHANDLE           = CM_BASE + 49;
  CM_ISTOOLCONTROL          = CM_BASE + 50;
  CM_RECREATEWND            = CM_BASE + 51;
  CM_INVALIDATE             = CM_BASE + 52;

  { Notification Codes }
  CN_BASE                   = $BC00;
  CN_CHARTOITEM             = CN_BASE + WM_CHARTOITEM;
  CN_COMMAND                = CN_BASE + WM_COMMAND;
  CN_COMPACTING             = CN_BASE + WM_COMPACTING;
  CN_COMPAREITEM            = CN_BASE + WM_COMPAREITEM;
  CN_CTLCOLOR               = CN_BASE + WM_CTLCOLOR;
  CN_DELETEITEM             = CN_BASE + WM_DELETEITEM;
  CN_DRAWITEM               = CN_BASE + WM_DRAWITEM;
  CN_HSCROLL                = CN_BASE + WM_HSCROLL;
  CN_MEASUREITEM            = CN_BASE + WM_MEASUREITEM;
  CN_PARENTNOTIFY           = CN_BASE + WM_PARENTNOTIFY;
  CN_VKEYTOITEM             = CN_BASE + WM_VKEYTOITEM;
  CN_VSCROLL                = CN_BASE + WM_VSCROLL;

type
  TMessage = record
    Msg: Word;
    WParam: Word;
    LParam: LongInt;
    Result: LongInt;
  end;

  TWMCommand = record
    Msg: Word;
    ItemID: Word;
    Ctl: HWND;
    NotifyCode: Word;
    Result: LongInt;
  end;

  TWMMouse = record
    Msg: Word;
    Keys: Word;
    XPos: SmallInt;
    YPos: SmallInt;
    Result: LongInt;
  end;

  TWMKey = record
    Msg: Word;
    CharCode: Word;
    KeyData: LongInt;
    Result: LongInt;
  end;

  TWMNoParams = record
    Msg: Word;
    Unused: Word;
    Unused2: Longint;
    Result: Longint;
  end;

  TWMGetDlgCode = TWMNoParams;
  TWMQueryOpen = TWMNoParams;
  TWMSysColorChange = TWMNoParams;

  TWMEnable = record
    Msg: Word;
    Enabled: WordBool;
    Unused: Longint;
    Result: Longint;
  end;

  TWMSize = record
    Msg: Word;
    SizeType: Word;
    Width: Word;
    Height: Word;
    Result: Longint;
  end;

  TWMMove = record
    Msg: Word;
    Unused: Word;
    XPos: Integer;
    YPos: Integer;
    Result: Longint;
  end;

  TWMPaint = record
    Msg: Word;
    DC: HDC;
    Unused: Longint;
    Result: Longint;
  end;

  TWMGetMinMaxInfo = record
    Msg: Word;
    Unused: Word;
    MinMaxInfo: PMINMAXINFO;
    Result: Longint;
  end;

  TWMSysCommand = record
    Msg: Word;
    CmdType: Word;
    XPos: SmallInt;
    YPos: SmallInt;
    Result: Longint;
  end;

  TWMMouseActivate = record
    Msg: Word;
    TopLevel: HWND;
    HitTestCode: Word;
    MouseMsg: Word;
    Result: Longint;
  end;

  TWMNCMouse = record
    Msg: Word;
    HitTest: Word;
    XCursor: SmallInt;
    YCursor: SmallInt;
    Result: Longint;
  end;
  TWMNCRButtonDown = TWMNCMouse;
  TWMNCLButtonDown = TWMNCMouse;

  TWMLButtonDown = TWMMouse;
  TWMLButtonUp = TWMMouse;
  TWMLButtonDblClk = TWMMouse;
  TWMRButtonDown = TWMMouse;
  TWMRButtonUp = TWMMouse;
  TWMRButtonDblClk = TWMMouse;
  TWMMouseMove = TWMMouse;

  TWMActivate = record
    Msg: Word;
    Active: Word;
    Minimized: WordBool;
    ActiveWindow: HWND;
    Result: Longint;
  end;

  TWMDropFiles = record
    Msg: Word;
    Drop: Word;
    Unused: Longint;
    Result: Longint;
  end;

  TWMDrawItem = record
    Msg: Word;
    Ctl: HWND;
    DrawItemStruct: PDRAWITEMSTRUCT;
    Result: Longint;
  end;

  TWMMeasureItem = record
    Msg: Word;
    Ctl: HWND;
    MeasureItemStruct: PMEASUREITEMSTRUCT;
    Result: Longint;
  end;

  TWMScroll = record
    Msg: Word;
    ScrollCode: SmallInt;
    Pos: SmallInt;
    ScrollBar: HWND;
    Result: Longint;
  end;
  TWMVScroll = TWMScroll;
  TWMHScroll = TWMScroll;

  TCMFocusChanged = record
    Msg: Word;
    Unused: Word;
    Sender: TObject;
    Result: Longint;
  end;

function Point(AX, AY: Integer): TPoint;

implementation

function Point(AX, AY: Integer): TPoint;
begin
  Result.X := AX;
  Result.Y := AY;
end;

end.
