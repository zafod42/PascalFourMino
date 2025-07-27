program tetris;
uses crt, game;

procedure GetKey(var code: integer);
var
    c: char;
begin
    c := ReadKey;
    if c = #0 then begin
        c := ReadKey;
        code := -ord(c);
    end 
    else begin
        code := ord(c);
    end;
end;

begin
    repeat
        ProcessInput;
        Update;
        Render;
    until not IsGameRunning;
    writeln('Game Finished');
end.
