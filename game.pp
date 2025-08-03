unit game;
interface
uses shape, constants, sevenrng, draw;

const 

    CEMENT = 2;
    ACTIVE = 1;
    FREE = 0;

type 
    InputState = record
        prev: integer;
        key: integer;
    end;

    TetrisGame = record 
        isRunning: boolean;
        map: array [-MAPHEIGHT..MAPHEIGHT, 1..MAPWIDTH] of integer;
        input: InputState;
        currentShape: shape.TetrisShape;
        nextShape: shape.TetrisShape;
        rng: SevenBag;
        gameTick: integer;
        gravity: integer;
        score: int64;
        context: DrawContext;
        lose: boolean;
    end;

function IsGameRunning(game: TetrisGame) : boolean;
procedure TetrisInit(var game: TetrisGame);
procedure ProcessInput(var game: TetrisGame);
procedure Update(var game: TetrisGame);
procedure Render(var game: TetrisGame);
procedure TetrisClean(var game: TetrisGame);

implementation
uses userinput, crt, keys;

function IsGameRunning(game: TetrisGame) : boolean;
begin
    IsGameRunning := game.isRunning;
end;
procedure TetrisInit(var game: TetrisGame);
var
    j, i: integer;
begin
    { Game State is running }
    game.isRunning := True;
    game.lose := False;
    { Init map }
    for j := 1 to MAPHEIGHT do begin
        for i:=1 to MAPWIDTH do begin
            game.map[j][i] := 0;
        end
    end;

    game.gravity := 1;
    game.gameTick := 0;

    BAGInit(game.rng);


    NewShape(game.currentShape, game.rng);
    NewShape(game.nextShape, game.rng);

    InitTerminal(game.context);

end;

procedure ClearInput(var game: TetrisGame);
begin
    game.input.prev := game.input.key;
    game.input.key := 0;
end;

procedure ProcessInput(var game: TetrisGame);
var 
    c: integer;
begin
    ClearInput(game);
    if KeyPressed then begin
        GetKey(c);
        game.input.key := c;
    end
end;

procedure FillShapeWith(var game: TetrisGame; mode: integer);
var 
    _shape: shape.TetrisShape;
    x, y: integer;
    cols, rows: integer;
    id: integer;
    rot: integer;
    value: integer;
begin
    _shape := game.currentShape;
    
    case mode of 
        FREE : value := 0;
        CEMENT, ACTIVE : value := GetShapeColor(_shape); 
    end;

    x := _shape.posX;
    y := _shape.posY;
    id := ord(_shape.shapeType) + 1;
    rot := ord(_shape.subtype) + 1;

    for cols := 1 to 4 do
    begin
        for rows := 1 to 4 do
        begin
            if Shapes[id][rot][cols][rows] = 1 then begin
                game.map[y + cols][x + rows] := value;
            end;
        end;
    end;
    
end;

function HasCollision(game: TetrisGame; shape: TetrisShape) : boolean;
var
    i, j: integer;
    _shape: TetrisShape;
    _type: ShapeType;
    _rot: ShapeSubType;
    x, y: integer;
begin
    _shape := shape;
    _type := _shape.shapeType;
    _rot := _shape.subtype;
    x := _shape.posX;
    y := _shape.posY;
    for j := 1 to 4 do begin
        for i := 1 to 4 do begin
            if (y + j < 1) then
                continue;

            if Shapes[ord(_type) + 1][ord(_rot) + 1][j][i] <> 0 then begin
                if y + j > MAPHEIGHT then begin
                    Exit(True)
                end;
                if (x + i > MAPWIDTH) or (x + i < 1) then begin
                    Exit(True)
                end;
                if game.map[y + j][x + i] > 0 then begin
                    Exit(True);
                end;
            end
        end
    end;
    HasCollision := False;
end;

procedure WipeLine(var game: TetrisGame; n: integer);
var
    j, i: integer;
begin
    game.score := game.score + 10;
    for j := n downto 2 do begin
        for i := 1 to MAPWIDTH do begin
            game.map[j][i] := game.map[j - 1][i]
        end
    end
end;

procedure HandleBotCollision(var game: TetrisGame);
var 
    fullLines: array [1..MAPHEIGHT] of boolean; { TODO: for future use }
    j, i: integer;
    isFull: boolean;
begin
    game.currentShape := game.nextShape;
    NewShape(game.nextShape, game.rng);
    if HasCollision(game, game.currentShape) then
        game.lose := true;

    for j := 1 to MAPHEIGHT do begin
        fullLines[j] := true;
        isFull := true;
        for i:=1 to MAPWIDTH do begin
            if game.map[j][i] = 0 then begin
                fullLines[j] := false;
                isFull := false;
                break
            end
        end;
        if isFull then
            WipeLine(game, j);
    end;

    { TODO: add combo logic and 4-lines clear bonus }

    

end;

procedure UpdateShape(var game: TetrisGame); 
var 
    _key: integer;
begin
    {
        1. See if we already hit floor or cement (collision)
        1.1 If yes -- fix current shape position by placing cement here
        1.2 Assign current shape to next shape
        2. Move current shape (collision)
    }
    {1.}
    { make it MoveShape(shape, cemenuted, gametick }
    
    FillShapeWith(game, FREE);

    _key := game.input.key;

    case _key of
        LEFT : begin
            MoveShapeLeft(game.currentShape);
            { collision }
            if HasCollision(game, game.currentShape) then begin
                MoveShapeRight(game.currentShape);
            end
        end;
        RIGHT : begin
            MoveShapeRight(game.currentShape);
            if HasCollision(game, game.currentShape) then begin
                MoveShapeLeft(game.currentShape);
            end
        end; 
        UP : begin 
            RotateShape(game.currentShape);
            if HasCollision(game, game.currentShape) then
                RotateShapeBack(game.currentShape);
        end;
        DOWN : begin 
            MoveShapeDown(game.currentShape);
            if HasCollision(game, game.currentShape) then begin
                MoveShapeUp(game.currentShape);
                FillShapeWith(game, CEMENT);
                HandleBotCollision(game);
            end;
        end;
        SPACE : begin { hard drop }
            while not HasCollision(game, game.currentShape) do 
                MoveShapeDown(game.currentShape);
            MoveShapeUp(game.currentShape);
            FillShapeWith(game, CEMENT);
            HandleBotCollision(game);
        end;
    end;
    if game.gameTick mod 30 = 15 then
        MoveShapeDown(game.currentShape);
    if HasCollision(game, game.currentShape) then begin
        MoveShapeUp(game.currentShape);
        FillShapeWith(game, CEMENT);
        HandleBotCollision(game);
    end 
    else begin
        FillShapeWith(game, ACTIVE);
    end
end;

procedure LoseHandle(var game: TetrisGame);
const
    MESSAGE = 'Game Over';
    SCORE_MSG = 'Score is ';
    HELP_MSG = 'R to restart, ESC to exit';
var
    offsetX: integer;
    offsetY: integer;
begin
    
    TextBackground(WHITE);
    SetTextColor(game.context, BLACK);

    offsetY := game.context.centerY;
    offsetX := game.context.centerX - (length(MESSAGE) div 2);
    
    DrawText(game.context, MESSAGE, offsetX, offsetY);

    offsetY := offsetY + 1;
    offsetX := game.context.centerX - (length(SCORE_MSG) div 2);

    DrawText(game.context, SCORE_MSG, offsetX, offsetY);

    offsetX := offsetX + length(SCORE_MSG) + 1;

    DrawInt64(game.context, game.score, offsetX, offsetY);

    offsetY := offsetY + 1;
    offsetX := game.context.centerX - (length(HELP_MSG) div 2);
    DrawText(game.context, HELP_MSG, offsetX, offsetY);
end;


procedure PrintMap(var game: TetrisGame);
var
    offsetX: integer;
    offsetY: integer;
    i, j: integer;
    _x, _y: integer;
begin
    offsetX := (ConsoleWidth - CellSizeX * MAPWIDTH) div 2;
    offsetY := (ConsoleHeight - CellSizeY * MAPHEIGHT) div 2;
    if offsetY < 0 then
        offsetY := 0;
    for j := 1 to MAPHEIGHT do
    begin
        for i := 1 to MAPWIDTH do
        begin
            _x := i * CellSizeX + offsetX;
            _y := j * CellSizeY + offsetY;
            if game.map[j][i] <> 0 then begin
                DrawCell(game.context, game.map[j][i], _x, _y);
            end
            else begin
                DrawCell(game.context, LIGHTGRAY, _x, _y);
            end;
        end;
    end
end;

procedure PrintNext(var game: TetrisGame);
var
    offsetX: integer;
    offsetY: integer;
    _type: ShapeType;
    j, i: integer;
    color: integer;
    _x, _y: integer;
begin 
    offsetX := (ConsoleWidth + CellSizeX * MAPWIDTH) div 2;
    offsetY := (ConsoleHeight - CellSizeY * MAPHEIGHT) div 2;
    if offsetY < 1 then
        offsetY := 1;
    
    TextBackground(WHITE);
    SetTextColor(game.context, BLACK);
    DrawText(game.context, 'NEXT', offsetX + 1, offsetY);
    
    _type := game.nextShape.shapeType;
    color := GetShapeColor(game.nextShape);

    {offsetY := offsetY + 1;    }
    for j := 1 to 4 do begin
        for i := 1 to 4 do begin
            _x := offsetX + i * CellSizeX;
            _y := offsetY + j * CellSizeY;
            if Shapes[ord(_type) + 1][ord(degree0) + 1][j][i] <> 0 then
            begin
                DrawCell(game.context, color, _x, _y);
            end
            else
            begin
                DrawCell(game.context, WHITE, _x, _y);
            end
        end
    end
end;

procedure PrintScore(var game: TetrisGame);
var
    offsetX: integer;
    offsetY: integer;
begin 
    offsetX := (ConsoleWidth + CellSizeX * MAPWIDTH) div 2;
    offsetY := (ConsoleHeight - CellSizeY * MAPHEIGHT) div 2 + 8;
    if offsetY < 0 then
        offsetY := 8;

    TextBackground(WHITE);
    SetTextColor(game.context, BLACK);
    DrawText(game.context, 'Score: ', offsetX + 1 , offsetY);
    DrawInt64(game.context, game.score, offsetX + 7, offsetY);

end;

procedure TetrisRestart(var game: TetrisGame);
var
    j, i: integer;
begin
    for j := 1 to MAPHEIGHT do begin
        for i:=1 to MAPWIDTH do begin
            game.map[j][i] := 0;
        end
    end;

    game.gravity := 1;
    game.gameTick := 0;

    BAGInit(game.rng);

    NewShape(game.currentShape, game.rng);
    NewShape(game.nextShape, game.rng);

    game.lose := False;
end;

procedure Update(var game: TetrisGame);
var
    key: integer;
begin
    game.gameTick := game.gameTick + 1;
    if not game.lose then
        UpdateShape(game);

    key := game.input.key;
    case key of
        R, SHIFT_R : TetrisRestart(game);
        ESC : game.isRunning := false;
    end;
end;

procedure PrintShade(var game: TetrisGame);
var
    _x, _y: integer;
    offsetX, offsetY: integer;
    i, j: integer;
    _type: ShapeType;
    _subtype: ShapeSubType;
    color: integer;
    _shape: TetrisShape;
begin
    _shape := game.currentShape;
    FillShapeWith(game, FREE);
    while not HasCollision(game, _shape) do begin
        MoveShapeDown(_shape);
    end;
    FillShapeWith(game, ACTIVE);
    MoveShapeUp(_shape);


    offsetX := (ConsoleWidth - CellSizeX * MAPWIDTH) div 2;
    offsetY := (ConsoleHeight - CellSizeY * MAPHEIGHT) div 2;
    if offsetY < 0 then
        offsetY := 0;

    _type := _shape.shapeType;
    _subtype := _shape.subtype;

    color := GetShapeColor(_shape);

    for j := 1 to 4 do begin
        for i := 1 to 4 do begin
            _x := offsetX + (i + _shape.posX) * CellSizeX;
            _y := offsetY + (j + _shape.posY) * CellSizeY;
            if Shapes[ord(_type) + 1][ord(_subtype) + 1][j][i] <> 0 then
                DrawShadedCell(game.context, color, _x, _y);
        end
    end
end;

procedure Render(var game: TetrisGame);
begin
    GotoXY(1, 1);
    TextBackground(WHITE);
    PrintMap(game);
    TextBackground(WHITE);
    PrintNext(game);
    TextBackground(WHITE);
    PrintScore(game);
    TextColor(WHITE);

    PrintShade(game);
    TextBackground(WHITE);
    TextColor(WHITE);

{$IFDEF DEBUG}
    GotoXY(10, 10);
    TextColor(RED);
    write('Render', random(10));
    TextColor(WHITE);
{$ENDIF}

    if game.lose then 
        LoseHandle(game);

    if game.isRunning = false then begin
        TextBackground(BLACK);
        TextColor(WHITE);
        writeln('Your score is ', game.score);
    end;
    TextBackground(BLACK);
end;

procedure TetrisClean(var game: TetrisGame);
begin
    RestoreTerminal(game.context);
end;

end.
