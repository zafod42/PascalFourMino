unit game;
interface
uses shape, constants, sevenrng;

const 

    CEMENT = 2;
    ACTIVE = 1;
    FREE = 0;

type 
    InputState = record
        key: integer;
    end;

    TetrisGame = record 
        isRunning: boolean;
        map: array [1..MAPHEIGHT, 1..MAPWIDTH] of integer;
        input: InputState;
        currentShape: shape.TetrisShape;
        nextShape: shape.TetrisShape;
        rng: SevenBag;
    end;

function IsGameRunning(game: TetrisGame) : boolean;
procedure TetrisInit(var game: TetrisGame);
procedure ProcessInput(var game: TetrisGame);
procedure Update(var game: TetrisGame);
procedure Render(var game: TetrisGame);

implementation
uses draw, userinput, crt;

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
    { Init map }
    for j := 1 to MAPHEIGHT do begin
        for i:=1 to MAPWIDTH do begin
            game.map[j][i] := 0;
        end
    end;

    BAGInit(game.rng);


    NewShape(game.currentShape, game.rng);
    NewShape(game.nextShape, game.rng);

    clrscr;
end;


procedure ProcessInput(var game: TetrisGame);
var 
    c: integer;
begin
    GetKey(c);
    game.input.key := c;
    {
    if KeyPressed then begin
        GetKey(c);
        game.input.key := c;
    end
    }
end;

procedure FillShapeWith(var game: TetrisGame; value: integer);
var 
    _shape: shape.TetrisShape;
    x, y: integer;
    cols, rows: integer;
    id: integer;
    rot: integer;
begin
    _shape := game.currentShape;
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

function HasCollision(game: TetrisGame) : boolean;
var
    i, j: integer;
    _shape: TetrisShape;
    _type: ShapeType;
    _rot: ShapeSubType;
    x, y: integer;
begin
    _shape := game.currentShape;
    _type := _shape.shapeType;
    _rot := _shape.subtype;
    x := _shape.posX;
    y := _shape.posY;
    for j := 1 to 4 do begin
        for i := 1 to 4 do begin
            if Shapes[ord(_type) + 1][ord(_rot) + 1][j][i] <> 0 then begin
                if game.map[y + j][x + i] > 1 then begin
                    Exit(True);
                end;
                if y + j > MAPHEIGHT then begin
                    Exit(True)
                end;
                if (x + i > MAPWIDTH) or (x + i < 1) then begin
                    Exit(True)
                end;
            end
        end
    end;
    HasCollision := False;
end;

procedure HandleBotCollision(var game: TetrisGame);
begin
    game.currentShape := game.nextShape;
    NewShape(game.nextShape, game.rng);
end;

procedure UpdateShape(var game: TetrisGame); 
const
    LEFT = -75;
    RIGHT = -77;
    UP = -72;
    DOWN = -80;
var
    _shape: shape.TetrisShape;
    cemented: boolean = false;
begin
    _shape := game.currentShape;
    {
        1. See if we already hit floor or cement (collision)
        1.1 If yes -- fix current shape position by placing cement here
        1.2 Assign current shape to next shape
        2. Move current shape (collision)
    }
    {1.}
    { make it MoveShape(shape, cemenuted, gametick }
    
    FillShapeWith(game, FREE);
    case game.input.key of
        LEFT : begin
            MoveShapeLeft(game.currentShape);
            { collision }
            if HasCollision(game) then begin
                MoveShapeRight(game.currentShape);
            end
        end;
        RIGHT : begin
            MoveShapeRight(game.currentShape);
            if HasCollision(game) then begin
                MoveShapeLeft(game.currentShape);
            end
        end; 
        UP : begin 
            RotateShape(game.currentShape);
            if HasCollision(game) then
                RotateShapeBack(game.currentShape);
        end;
        DOWN : begin end;
    end;
    MoveShapeDown(game.currentShape);
    if HasCollision(game) then begin
        MoveShapeUp(game.currentShape);
        FillShapeWith(game, CEMENT);
        HandleBotCollision(game);
    end 
    else begin
        FillShapeWith(game, ACTIVE);
    end
end;

procedure PrintMap(var game: TetrisGame);
var
    i, j: integer;
begin
    for j := 1 to MAPHEIGHT do
    begin
        for i := 1 to MAPWIDTH do
        begin
            if game.map[j][i] <> 0 then
            begin
                TextColor(RED);
                write('▣ ');
            end
            else 
            begin
                TextColor(WHITE);
                write('  ');
            end
        end;
        writeln;
    end
end;


procedure PrintDigitalMap(var game: TetrisGame);
var
    i, j: integer;
begin
    for j := 1 to MAPHEIGHT do
    begin
        for i := 1 to MAPWIDTH do
        begin
            if game.map[j][i] <> 0 then
            begin
                TextColor(RED);
                write(game.map[j][i], ' ');
            end
            else 
            begin
                TextColor(GREEN);
                write(game.map[j][i], ' ');
            end
        end;
        writeln;
    end
end;

procedure Update(var game: TetrisGame);
var
    key: integer;
begin
    UpdateShape(game);
    key := game.input.key;
    if key = ord(' ') then
        game.isRunning := false;
end;

procedure Render(var game: TetrisGame);
begin
    GotoXY(1, 1);
    TextBackground(WHITE);
    PrintMap(game);
    if game.isRunning = false then begin
        TextBackground(BLACK);
        TextColor(WHITE);
        writeln('You entered Space and win');
    end;
    TextBackground(BLACK);
end;


end.
