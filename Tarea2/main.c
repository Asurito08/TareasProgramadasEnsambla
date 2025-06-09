#include <stdio.h>

#define FILAS 20
#define COLUMNAS 20

// Declaración de la función ensamblador
extern void iterarMatriz(char matriz[FILAS * COLUMNAS], char matrizSiguiente[FILAS * COLUMNAS]);

void imprimirMatriz(char matriz[FILAS * COLUMNAS]) {
    for (int i = 0; i < FILAS; ++i) {
        for (int j = 0; j < COLUMNAS; ++j) {
            putchar(matriz[i * COLUMNAS + j]);
        }
        putchar('\n');
    }
}

void inicializar(char matriz[FILAS * COLUMNAS]) {
    for (int i = 0; i < FILAS * COLUMNAS; ++i)
        matriz[i] = '0';

    // Glider horizontal en la fila 10, columnas 8,9,10
    matriz[10 * COLUMNAS + 8] = '1';
    matriz[10 * COLUMNAS + 9] = '1';
    matriz[10 * COLUMNAS + 10] = '1';
}

int main() {
    char matriz[FILAS * COLUMNAS];
    char matrizSiguiente[FILAS * COLUMNAS];

    inicializar(matriz);

    printf("Estado inicial:\n");
    imprimirMatriz(matriz);

    iterarMatriz(matriz, matrizSiguiente);

    printf("\nEstado después de una iteración:\n");
    imprimirMatriz(matrizSiguiente);

    return 0;
}
