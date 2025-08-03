
TARGET=tetris
SRC=main.pas
MODULES=$(wildcard %.pp)
PASCALC=fpc

.PHONY: all 
all: $(TARGET)

.PHONY: windows
windows: $(MODULES)
	$(PASCALC) $(SRC) -Twin64 -o$(TARGET).exe

.PHONY: windows
windows_debug: $(MODULES)
	$(PASCALC) $(SRC) -g -dDEBUG -Twin64 -o$(TARGET).exe

$(TARGET): $(MODULES)
	$(PASCALC) $(SRC) -o$(TARGET)

.PHONY: debug
debug: $(MODULES)
	$(PASCALC) -g $(SRC) -o$(TARGET)

.PHONY: clean 
clean:
	rm *.ppu *.o $(TARGET) $(TARGET).exe
