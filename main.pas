program tetris;
uses game;
var
    tetrisGame: game.TetrisGame;
begin
    TetrisInit(tetrisGame);
    repeat
        ProcessInput(tetrisGame);
        Update(tetrisGame);
        Render(tetrisGame);
    until not IsGameRunning(tetrisGame);
    writeln('Game Finished');
end.
