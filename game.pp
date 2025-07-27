unit game;
interface

const 
    Width = 10;
    Height = 20;
type 
    TetrisGame = record 
        isRunning: boolean;
        map: array [1..Height, 1..Width] of integer;
    end;

function IsGameRunning : boolean;
procedure ProcessInput;
procedure Update;
procedure Render;

implementation
uses draw;

function IsGameRunning : boolean;
begin
    IsGameRunning := False;
end;

procedure ProcessInput;
begin
    writeln('Process input');
end;

procedure Update;
begin
    writeln('Update');
end;
procedure Render;
begin
    writeln('Render');
end;


end.
