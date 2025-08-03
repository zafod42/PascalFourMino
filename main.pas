program tetris;
uses game, crt, sysutils, draw;
const 
    FrameRate = 30;
    FrameMS = 1000 div FrameRate;
var
    tetrisGame: game.TetrisGame;
    _start, _end: int64;
begin
    Randomize;
    if not isSceenEnough then begin
        writeln('Too small screen size.');
        writeln('Current size is: cols = ', ScreenHeight, '; rows = ', ScreenWidth);
        writeln('You need at least: cols = ', MinTerminalHeight, '; rows = ', MinTerminalWidth);
        exit;
    end;

    TetrisInit(tetrisGame);
    repeat
        _start := GetTickCount64;
        ProcessInput(tetrisGame);
        Update(tetrisGame);
        Render(tetrisGame);
        _end := GetTickCount64;
        delay(FrameMS - (_end - _start));
    until not IsGameRunning(tetrisGame);
    TetrisClean(tetrisGame);
end.
