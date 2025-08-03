unit draw;
interface

const 
    MinTerminalHeight = 40;
    MinTerminalWidth = 50;
    
    CellSizeX = 3;
    CellSizeY = 2;

type
    DrawContext = record
        Height, Width: integer;
        CenterX : integer;
        CenterY : integer;
        TxtColor: integer;
        PrevContext: integer;
    end;

procedure InitTerminal(var context: DrawContext);
procedure DrawCell(context: DrawContext; cell: integer; x, y : integer);
procedure DrawShadedCell(context: DrawContext; cell: integer; x, y : integer);
procedure DrawText(context: DrawContext; txt: string; x, y: integer);
procedure DrawInt64(context: DrawContext; value: int64; x, y: integer);
procedure SetTextColor(var context: DrawContext; color: integer);
procedure RestoreTerminal(var context: DrawContext);

function isSceenEnough : boolean;
function ConsoleHeight: integer;
function ConsoleWidth : integer;

implementation
{$IFDEF WINDOWS}
    uses Windows, crt;
{$ELSE}
    uses crt;
{$ENDIF}

function ConsoleWidth : integer;
{$IFDEF WINDOWS}
var
    ConsoleInfo: CONSOLE_SCREEN_BUFFER_INFO;
{$ENDIF}
begin
    {$IFDEF WINDOWS}
    if GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), @ConsoleInfo) then begin
        ConsoleWidth := ConsoleInfo.srWindow.Right - ConsoleInfo.srWindow.Left + 1;
    end
    else begin
        ConsoleWidth := 0; { Cannot identify }
    end;
    {$ELSE}
        ConsoleWidth := ScreenWidth;
    {$ENDIF}
end;

function ConsoleHeight: integer;
{$IFDEF WINDOWS}
var
    ConsoleInfo: CONSOLE_SCREEN_BUFFER_INFO;
{$ENDIF}
begin
    {$IFDEF WINDOWS}
    if GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), @ConsoleInfo) then begin
        ConsoleHeight := ConsoleInfo.srWindow.Bottom - ConsoleInfo.srWindow.Top + 1;
    end
    else begin
        ConsoleHeight := 0; { Cannot identify }
    end;
    {$ELSE}
        ConsoleHeight := ScreenHeight;
    {$ENDIF}
end;

function isSceenEnough : boolean;
begin
    if ConsoleWidth < MinTerminalWidth then
        exit(False);
    if ConsoleHeight < MinTerminalHeight then
        exit(False);

    isSceenEnough := True;
end;

procedure InitTerminal(var context: DrawContext);
begin
    
    context.PrevContext := TextAttr;

    clrscr;

    context.Height := ConsoleHeight;
    context.Width := ConsoleWidth;

    context.CenterX := context.Width div 2;
    context.CenterY := context.Height div 2;
end;


procedure RestoreTerminal(var context: DrawContext);
begin
    TextAttr := context.PrevContext;
    clrscr;
end;

procedure DrawCell(context: DrawContext; cell: integer; x, y : integer);
var
    _x, _y: integer;
begin
    _x := x;
    _y := y;

    TextBackground(cell);
    GotoXY(_x - CellSizeX + 1, _y);
    write('   ');
    GotoXY(_x - CellSizeX + 1, _y - 1);
    write('   ');
    GotoXY(1, 1);
end;

procedure DrawShadedCell(context: DrawContext; cell: integer; x, y : integer);
const 
{$IFDEF WINDOWS}
    shadeSym = ':';
{$ELSE}
    shadeSym = '░';
{$ENDIF}
var
    _x, _y: integer;
begin
    _x := x;
    _y := y;

    TextBackground(cell);
    TextColor(BLACK);
    GotoXY(_x - CellSizeX + 1, _y);
    write(shadeSym);
    write(shadeSym);
    write(shadeSym);
    GotoXY(_x - CellSizeX + 1, _y - 1);
    write(shadeSym);
    write(shadeSym);
    write(shadeSym);
    GotoXY(1, 1);
end;

procedure SetTextColor(var context: DrawContext; color: integer);
begin
    context.TxtColor := color;
end;

procedure DrawText(context: DrawContext; txt: string; x, y: integer);
begin
    TextColor(context.TxtColor);
    GotoXY(x, y);
    write(txt);
    GotoXY(1, 1);
end;

procedure DrawInt64(context: DrawContext; value: int64; x, y: integer);
begin
    TextColor(context.TxtColor);
    GotoXY(x, y);
    write(value);
    GotoXY(1, 1);
end;

end.
