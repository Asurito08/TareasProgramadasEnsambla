#ifndef LIFEGAME_H
#define LIFEGAME_H

#include <gtk/gtk.h>

#define FILAS 20
#define COLUMNAS 20
#define RUTA_MATRIZ "data/datos.txt"

extern GtkApplication *app_global;
extern void iterarMatriz(char matriz[FILAS * COLUMNAS], char matrizSiguiente[FILAS * COLUMNAS]);
GtkWidget* crearPantallalifegame(GtkApplication *app);

#endif
