target: prueba

prueba: lifeGameFunct.o main.c
	gcc -g -no-pie main.c lifeGameFunct.o -o prueba

lifeGameFunct.o: lifeGameFunct.asm
	nasm -f elf64 -g -F dwarf lifeGameFunct.asm -o lifeGameFunct.o

run: prueba
	./prueba

clean:
	rm -f lifeGameFunct.o prueba
