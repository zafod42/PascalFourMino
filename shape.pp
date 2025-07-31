unit shape;
interface

type
    ShapeType = (J, I, O, L, Z, T, S);
    ShapeSubType = (degree0, degree90, degree180, degree270);

    Point = record
        x, y: integer;
    end;

    TetrisShape = record
        shapeType: ShapeType;
        subtype: ShapeSubType;
        posX: integer;
        posY: integer;
        center: Point;
    end;
const 
    Shapes: array [1..7, 1..4, 1..4, 1..4] of integer = ((
        ( { J }
            (0, 0, 0, 0),
            (0, 0, 1, 0),
            (0, 0, 1, 0),
            (0, 1, 1, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 1, 1),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 0, 1, 1),
            (0, 0, 1, 0),
            (0, 0, 1, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 0, 0, 0),
            (0, 1, 1, 1),
            (0, 0, 0, 1)
        )
        { J end }
    ), ( { I }
        (
            (0, 0, 1, 0),
            (0, 0, 1, 0),
            (0, 0, 1, 0),
            (0, 0, 1, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 0, 0, 0),
            (1, 1, 1, 1),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (1, 1, 1, 1),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        )
        { I end }
    ),( { O }
        (
            (0, 0, 0, 0),
            (0, 1, 1, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 1, 1, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 1, 1, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 1, 1, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0)
        )
        { O end }
    ), ( { L }
        (
            (0, 0, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 1, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 0, 0, 0),
            (1, 1, 1, 0),
            (1, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (1, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (0, 0, 1, 0),
            (1, 1, 1, 0),
            (0, 0, 0, 0)
        )
        { L end }
    ), ( { Z }
        (
            (1, 1, 0, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 1, 0),
            (0, 1, 1, 0),
            (0, 1, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (1, 1, 0, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (1, 1, 0, 0),
            (1, 0, 0, 0),
            (0, 0, 0, 0)
        )
        { Z end }
    ), ( { T }
        (
            (0, 1, 0, 0),
            (1, 1, 1, 0),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (0, 1, 1, 0),
            (0, 1, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (1, 1, 1, 0),
            (0, 1, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (1, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 0, 0, 0)
        )
        { T end }
    ), ( { S }
        (
            (0, 1, 1, 0),
            (1, 1, 0, 0),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (0, 1, 1, 0),
            (0, 0, 1, 0),
            (0, 0, 0, 0)
        ),    
        (
            (0, 0, 0, 0),
            (0, 1, 1, 0),
            (1, 1, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (1, 0, 0, 0),
            (1, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 0, 0, 0)
        )
        { S end }
    ));

procedure MoveShape(key: integer; var shape: TetrisShape; var cemented: boolean);
procedure NewShape(var shape: TetrisShape);

implementation
uses constants;

procedure NewShape(var shape: TetrisShape);
const
    posYStart: array [1..SHAPESCOUNT] of integer = (2, 0, 1, 2, 1, 1, 1);
var
    _type: ShapeType;
begin
    shape.shapeType := I;
    shape.subtype := degree0;
    shape.posX := MAPWIDTH div 2 - 3;

    _type := shape.shapeType;
    shape.posY := posYStart[ord(_type) + 1];
end;

procedure CheckShapeCollision( 
    shape: TetrisShape;
    var canMoveLeft: boolean;
    var canMoveRight: boolean; 
    var canMoveDown: boolean);
begin

    canMoveDown := true;
    canMoveLeft := true;
    canMoveRight := true;

    if shape.posY = MAPHEIGHT then
        canMoveDown := false;
    if shape.posX = MAPWIDTH then
        canMoveRight := false;
    if shape.posX = 0 then
        canMoveLeft := false;
end;

procedure NextType4(var _type: ShapeSubType);
begin
    if _type = degree270 then begin
        _type := degree0;
    end
    else begin 
        _type := succ(_type);
    end;
end; 

procedure RotateShape(var shape: TetrisShape);
begin
    NextType4(shape.subtype);
end;

procedure MoveShape(key: integer; var shape: TetrisShape; var cemented: boolean);
const
    LEFT = -75;
    RIGHT = -77;
    UP = -72;
    DOWN = -80;
var
    _shape: TetrisShape;
    canMoveLeft: boolean;
    canMoveRight: boolean;
    canMoveDown: boolean;
begin
    _shape := shape;
    CheckShapeCollision(_shape, canMoveLeft, canMoveRight, canMoveDown);
    case key of
        LEFT :
        begin
            if canMoveLeft then 
                _shape.posX := _shape.posX - 1;
        end;
        RIGHT :
        begin
            if canMoveRight then
                _shape.posX := _shape.posX + 1;
        end;
        DOWN:
        begin
            { TODO: make figure go down faster }
        end;
        UP :
        begin
            RotateShape(_shape);
        end;
    end;
    { TODO: make it depend on gameTickCounter }
    if canMoveDown then begin
        _shape.posY := _shape.posY + 1; { hope its down }
        cemented := false;
    end
    else begin
        cemented := true;
    end;
    shape := _shape;
end;

end.
