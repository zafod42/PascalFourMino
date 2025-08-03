program tetris;
{$IFDEF WINDOWS}
    uses game, crt, sysutils, draw, Windows;
{$ELSE}
    uses game, crt, sysutils, draw;
{$ENDIF}
const 
    FrameRate = 30;
    FrameMS = 1000 div FrameRate;
var
    tetrisGame: game.TetrisGame;
    _start, _end: int64;
    delayMs: integer;
begin
    RandSeed := GetTickCount64;
    if not isSceenEnough then begin
        writeln('Too small screen size.');
        writeln('Current size is: cols = ', ConsoleWidth, '; rows = ', ConsoleHeight);
        writeln('You need at least: cols = ', MinTerminalWidth, '; rows = ', MinTerminalHeight);
        exit;
    end;

    TetrisInit(tetrisGame);
    repeat
        _start := GetTickCount64;
        ProcessInput(tetrisGame);
        Update(tetrisGame);
        Render(tetrisGame);
        _end := GetTickCount64;
        delayMs := FrameMS - (_end - _start);
        if delayMs > 0 then begin
            Sleep(FrameMS - (_end - _start));
        end
        else begin
            Sleep(0);
        end;
    until not IsGameRunning(tetrisGame);
    TetrisClean(tetrisGame);
end.
