import os
import random

# Configuración
rows = 20
cols = 20

# Crear carpeta si no existe
os.makedirs("data", exist_ok=True)

# Generar matriz lineal
matriz_lineal = [str(random.randint(0, 1)) for _ in range(rows * cols)]

# Guardar en una sola línea
with open("data/datos.txt", "w") as f:
    f.write("".join(matriz_lineal))

print("Archivo 'data/datos.txt' generado con todos los datos en una sola línea.")
