unit sevenrng;
interface

uses constants;

type 
    SevenBag = record
        data: array [1..7] of ShapeType;
        remain: integer;
    end;


procedure BAGInit(var bag: SevenBag);
procedure BAGTakeShape(var bag: SevenBag; var _type: ShapeType);

implementation

function IsEmpty(var bag: SevenBag) : boolean;
begin
    IsEmpty := (bag.remain = 0);
end;

procedure RenewBag(var bag: SevenBag);
var 
    i: integer;
    _type: ShapeType = Low(ShapeType);
begin
    for i := 1 to 7 do begin
       bag.data[i] := _type;
       _type := succ(_type); 
    end;
    bag.remain := 7;
end;

procedure BAGInit(var bag: SevenBag);
begin
    { populate bag }
    RenewBag(bag);
end;

procedure BAGTakeShape(var bag: SevenBag; var _type: ShapeType);
begin
    if IsEmpty(bag) then
        RenewBag(bag);
    _type := bag.data[bag.remain];
    bag.remain := bag.remain -1;
end;

end.
