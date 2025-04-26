import os
import random

# Variables configurables
rows = 50
cols = 100

# Crear la carpeta "data" si no existe
os.makedirs("data", exist_ok=True)

# Generar la matriz con valores aleatorios 0 o 1
matriz = [[random.randint(0, 1) for _ in range(cols)] for _ in range(rows)]

# Ruta del archivo
ruta_archivo = os.path.join("data", "datos.txt")

# Guardar la matriz en el archivo
with open(ruta_archivo, "w") as archivo:
    for fila in matriz:
        archivo.write("".join(map(str, fila)) + "\n")

print(f"Matriz {rows}x{cols} con valores 0 o 1 guardada en '{ruta_archivo}'")
