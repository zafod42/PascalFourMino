
TARGET=tetris
SRC=main.pas
PASCALC=fpc

.PHONY: all 
all: $(TARGET)

$(TARGET):
	$(PASCALC) $(SRC) -o$(TARGET)

.PHONY: debug
debug:
	$(PASCALC) -g $(SRC) -o$(TARGET)

.PHONY: clean 
clean:
	rm *.ppu *.o $(TARGET)
