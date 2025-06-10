target: prueba

GTK_FLAGS := `pkg-config --cflags --libs gtk4`

bin/prueba: build/lifegame.o build/lifeGameFunct.o src/main.c
	mkdir -p bin
	gcc -g -no-pie src/main.c build/lifegame.o build/lifeGameFunct.o $(GTK_FLAGS) -o bin/prueba

build/lifegame.o: src/lifegame.c
	mkdir -p build
	gcc -g -c src/lifegame.c $(GTK_FLAGS) -o build/lifegame.o

build/lifeGameFunct.o: src/lifeGameFunct.asm
	mkdir -p build
	nasm -f elf64 -g -F dwarf src/lifeGameFunct.asm -o build/lifeGameFunct.o

run: bin/prueba
	./bin/prueba

clean:
	rm -rf bin build
