program tetris;
uses game, crt, sysutils;
const 
    FrameRate = 30;
    FrameMS = 1000 div FrameRate;
var
    tetrisGame: game.TetrisGame;
    _start, _end: int64;
begin
    TetrisInit(tetrisGame);
    repeat
        _start := GetTickCount64;
        ProcessInput(tetrisGame);
        Update(tetrisGame);
        Render(tetrisGame);
        _end := GetTickCount64;
        delay(FrameMS - (_end - _start));
    until not IsGameRunning(tetrisGame);
    writeln('Game Finished');
end.
