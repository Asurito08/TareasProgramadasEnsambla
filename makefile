# Makefile para compilar y ejecutar lifeGame.asm desde src/
# y generar todo en la carpeta build/

# Carpetas
SRC_DIR = src
BUILD_DIR = build

# Nombre del ejecutable
TARGET = lifeGame
EXEC = $(BUILD_DIR)/$(TARGET)

# Archivos fuente y objeto
SRC = $(SRC_DIR)/lifeGame.asm
OBJ = $(BUILD_DIR)/lifeGame.o

# Comandos
NASM = nasm
LD = ld

# Flags
NASMFLAGS = -f elf64
LDFLAGS =

# Reglas
all: $(EXEC)

# Crear el ejecutable
$(EXEC): $(OBJ)
	$(LD) $(OBJ) -o $(EXEC)

# Compilar el ASM a .o (asegura que la carpeta build exista)
$(OBJ): $(SRC)
	@mkdir -p $(BUILD_DIR)
	$(NASM) $(NASMFLAGS) $(SRC) -o $(OBJ)

# Ejecutar el ejecutable
run: $(EXEC)
	./$(EXEC)

# Limpiar archivos generados
clean:
	rm -rf $(BUILD_DIR)
