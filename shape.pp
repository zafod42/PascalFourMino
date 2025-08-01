unit shape;
interface
uses constants, sevenrng;

type
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
            (1, 0, 0, 0),
            (1, 1, 1, 0),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 1, 0),
            (0, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (1, 1, 1, 0),
            (0, 0, 1, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (0, 1, 0, 0),
            (1, 1, 0, 0),
            (0, 0, 0, 0)
        )
        { J end }
    ), ( { I }
        (
            (0, 0, 0, 0),
            (1, 1, 1, 1),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        ),
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
            (0, 0, 1, 0),
            (1, 1, 1, 0),
            (0, 0, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 1, 0),
            (0, 0, 0, 0)
        ),
        (
            (0, 0, 0, 0),
            (1, 1, 1, 0),
            (1, 0, 0, 0),
            (0, 0, 0, 0)
        ),
        (
            (1, 1, 0, 0),
            (0, 1, 0, 0),
            (0, 1, 0, 0),
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

procedure NewShape(var shape: TetrisShape; var bag: SevenBag);

procedure MoveShapeLeft(var shape: TetrisShape);
procedure MoveShapeRight(var shape: TetrisShape);
procedure MoveShapeDown(var shape: TetrisShape);
procedure MoveShapeUp(var shape: TetrisShape);
procedure RotateShape(var shape: TetrisShape);
procedure RotateShapeBack(var shape: TetrisShape);

implementation

procedure NewShape(var shape: TetrisShape; var bag: SevenBag);
const
    posYStart: array [1..SHAPESCOUNT] of integer = (0, 0, 0, 0, 0, 0, 0);
var
    _type: ShapeType;
begin
    BAGTakeShape(bag, shape.shapeType);
    shape.subtype := degree0;
    shape.posX := MAPWIDTH div 2-2;

    _type := shape.shapeType;
    shape.posY := posYStart[ord(_type) + 1];
end;

procedure NextType(var _type: ShapeSubType);
begin
    if _type = degree270 then begin
        _type := degree0;
    end
    else begin 
        _type := succ(_type);
    end;
end; 

procedure PrevType(var _type: ShapeSubType);
begin
    if _type = degree0 then begin
        _type := degree270;
    end
    else begin 
        _type := pred(_type);
    end;
end; 

procedure RotateShape(var shape: TetrisShape);
begin
    NextType(shape.subtype);
end;

procedure RotateShapeBack(var shape: TetrisShape);
begin
    PrevType(shape.subtype);
end;

procedure MoveShapeBy(var shape: TetrisShape; x, y: integer);
begin
    shape.posX := shape.posX + x;
    shape.posY := shape.posY + y;
end;

procedure MoveShapeUp(var shape: TetrisShape);
begin 
    MoveShapeBy(shape, 0, -1);
end;

procedure MoveShapeLeft(var shape: TetrisShape);
begin 
    MoveShapeBy(shape, -1, 0);
end;

procedure MoveShapeRight(var shape: TetrisShape);
begin 
    MoveShapeBy(shape, 1, 0);
end;

procedure MoveShapeDown(var shape: TetrisShape);
begin 
    MoveShapeBy(shape, 0, 1);
end;

end.
