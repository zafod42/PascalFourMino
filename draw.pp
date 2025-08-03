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

implementation
uses crt;

function isSceenEnough : boolean;
begin
    if ScreenWidth < MinTerminalWidth then
        exit(False);
    if ScreenHeight < MinTerminalHeight then
        exit(False);
    isSceenEnough := True;
end;

procedure InitTerminal(var context: DrawContext);
begin
    
    context.PrevContext := TextAttr;

    clrscr;

    context.Height := ScreenHeight;
    context.Width := ScreenWidth;

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
var
    _x, _y: integer;
begin
    _x := x;
    _y := y;

    TextBackground(White);
    TextColor(BLACK);
    GotoXY(_x - CellSizeX + 1, _y);
    write('░░░');
    GotoXY(_x - CellSizeX + 1, _y - 1);
    write('░░░');
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
