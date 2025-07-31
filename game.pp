unit game;
interface
uses shape, constants;

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

    NewShape(game.currentShape);
    NewShape(game.nextShape);

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

procedure UpdateShape(var game: TetrisGame);
var
    _shape: shape.TetrisShape;
    cemented: boolean;
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
    MoveShape(game.input.key, _shape, cemented);
    game.currentShape := _shape;
    if cemented then begin
        FillShapeWith(game, CEMENT);        
        game.currentShape := game.nextShape;
        NewShape(game.nextShape);
    end
    else begin
        FillShapeWith(game, ACTIVE);
    end;
end;

procedure PrintMap(var game: TetrisGame);
var
    i, j: integer;
begin
    for j := 1 to MAPHEIGHT do begin
        for i:= 1 to MAPWIDTH do begin
            write(game.map[j][i], '  ')
        end;
        writeln('');
    end;

    game.map[1][1] := 9;

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
    PrintMap(game);
    if game.isRunning = false then
        writeln('You entered Space and win');
end;


end.
