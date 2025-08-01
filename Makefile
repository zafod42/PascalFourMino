
TARGET=tetris
SRC=main.pas
MODULES=$(wildcard %.pp)
PASCALC=fpc

.PHONY: all 
all: $(TARGET)

$(TARGET): $(MODULES)
	$(PASCALC) $(SRC) -o$(TARGET)

.PHONY: debug
debug: $(MODULES)
	$(PASCALC) -g $(SRC) -o$(TARGET)

.PHONY: clean 
clean:
	rm *.ppu *.o $(TARGET)
