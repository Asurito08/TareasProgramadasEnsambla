#include "lifegame.h"
#include <string.h>
#include <unistd.h>

GtkWidget *grid_global = NULL;
GtkWidget *contenedor_global = NULL;
GtkWidget *ventana_global = NULL;
GtkWidget *botones[FILAS][COLUMNAS];
char matriz[FILAS * COLUMNAS];
char matrizSiguiente[FILAS * COLUMNAS];
volatile gboolean simulacion_activa = FALSE;
guint id_simulacion = 0;
GtkApplication *app_global = NULL;

// Cargar matriz desde archivo
void cargar_matriz(const char *filename, char *matriz) {
    memset(matriz, 0, FILAS * COLUMNAS);
    FILE *archivo = fopen(filename, "r");
    if (!archivo) {
        perror("Error al abrir el archivo");
        return;
    }
    fread(matriz, 1, FILAS * COLUMNAS, archivo);
    fclose(archivo);
}

// Actualizar colores en el grid
void actualizarGrid() {
    for (int i = 0; i < FILAS; i++) {
        for (int j = 0; j < COLUMNAS; j++) {
            GtkWidget *boton = botones[i][j];
            if (!GTK_IS_WIDGET(boton)) continue;
            gtk_widget_remove_css_class(boton, "casilla-blanca");
            gtk_widget_remove_css_class(boton, "casilla-negra");

            if (matriz[i * COLUMNAS + j] == '1') {
                gtk_widget_add_css_class(boton, "casilla-blanca");
            } else {
                gtk_widget_add_css_class(boton, "casilla-negra");
            }
        }
    }
}

// Alternar celda con clic
void celdaPresionada(GtkButton *boton, gpointer user_data) {
    int posicion = GPOINTER_TO_INT(user_data);
    int fila = posicion / COLUMNAS;
    int col = posicion % COLUMNAS;
    char *celda = &matriz[fila * COLUMNAS + col];
    *celda = (*celda == '1') ? '0' : '1';

    actualizarGrid();
}

// Crear botones del grid
void crearGrid() {
    for (int i = 0; i < FILAS; i++) {
        for (int j = 0; j < COLUMNAS; j++) {
            GtkWidget *boton = gtk_button_new_with_label("");
            gtk_widget_set_size_request(boton, 30, 30);

            if (matriz[i * COLUMNAS + j] == '1') {
                gtk_widget_add_css_class(boton, "casilla-blanca");
            } else {
                gtk_widget_add_css_class(boton, "casilla-negra");
            }

            g_signal_connect(boton, "clicked", G_CALLBACK(celdaPresionada), GINT_TO_POINTER(i * COLUMNAS + j));
            gtk_grid_attach(GTK_GRID(grid_global), boton, j, i, 1, 1);
            botones[i][j] = boton;
        }
    }
}

// Simulación paso a paso
gboolean ciclo_simulacion(gpointer user_data) {
    if (!simulacion_activa) return G_SOURCE_REMOVE;

    iterarMatriz(matriz, matrizSiguiente);
    memcpy(matriz, matrizSiguiente, FILAS * COLUMNAS);
    actualizarGrid();

    return G_SOURCE_CONTINUE;
}

// Iniciar simulación
void iniciarSimulacion(GtkButton *boton, gpointer user_data) {
    if (!simulacion_activa) {
        simulacion_activa = TRUE;
        if (id_simulacion == 0) {
            id_simulacion = g_timeout_add(200, ciclo_simulacion, NULL);
        }
    }
}

// Pausar simulación
void pausarSimulacion(GtkButton *boton, gpointer user_data) {
    simulacion_activa = FALSE;
    if (id_simulacion != 0) {
        g_source_remove(id_simulacion);
        id_simulacion = 0;
    }
}

// Recargar desde archivo original
void recargarMatriz(GtkButton *boton, gpointer user_data) {
    cargar_matriz(RUTA_MATRIZ, matriz);
    actualizarGrid();
}

GtkWidget* crear_boton(GtkWidget *caja, const char *texto, const char *css_class, GCallback funcion, gpointer data) {
    GtkWidget *boton = gtk_button_new_with_label(texto);
    gtk_widget_add_css_class(boton, css_class);
    if (funcion) {
        g_signal_connect(boton, "clicked", funcion, data);
    }
    gtk_box_append(GTK_BOX(caja), boton);  // aquí sí, ya conoce la caja
    return boton;
}

// Crear ventana y todos los widgets
GtkWidget* crearPantallalifegame(GtkApplication *app) {
    app_global = app;
    cargar_matriz(RUTA_MATRIZ, matriz);

    ventana_global = gtk_application_window_new(app);
    gtk_widget_add_css_class(ventana_global, "fondo-principal");
    gtk_window_set_title(GTK_WINDOW(ventana_global), "Juego de la Vida");
    gtk_window_set_default_size(GTK_WINDOW(ventana_global), 1100, 800);
    gtk_window_set_resizable(GTK_WINDOW(ventana_global), FALSE);

    contenedor_global = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    gtk_widget_set_margin_top(contenedor_global, 20);
    gtk_widget_set_margin_bottom(contenedor_global, 20);
    gtk_widget_set_margin_start(contenedor_global, 20);
    gtk_widget_set_margin_end(contenedor_global, 20);
    gtk_window_set_child(GTK_WINDOW(ventana_global), contenedor_global);

    GtkWidget *titulo = gtk_label_new("Juego de la Vida");
    gtk_widget_set_halign(titulo, GTK_ALIGN_CENTER);
    gtk_widget_add_css_class(titulo, "titulo-principal");
    gtk_box_append(GTK_BOX(contenedor_global), titulo);

    grid_global = gtk_grid_new();
    gtk_widget_set_halign(grid_global, GTK_ALIGN_CENTER);
    gtk_widget_set_valign(grid_global, GTK_ALIGN_CENTER);
    gtk_widget_set_margin_top(grid_global, 20);
    gtk_widget_set_margin_bottom(grid_global, 20);
    crearGrid();
    gtk_box_append(GTK_BOX(contenedor_global), grid_global);
    gtk_widget_set_visible(grid_global, TRUE);

    // Caja de botones alineados en una fila
    GtkWidget *caja_botones = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 20);
    gtk_widget_set_halign(caja_botones, GTK_ALIGN_CENTER);
    gtk_widget_set_margin_top(caja_botones, 30);
    gtk_widget_set_margin_bottom(caja_botones, 20);
    gtk_widget_set_margin_start(caja_botones, 20);
    gtk_widget_set_margin_end(caja_botones, 20);

    GtkWidget *boton1 = crear_boton(caja_botones, "PAUSA", "boton-juego", G_CALLBACK(pausarSimulacion), NULL);
    GtkWidget *boton2 = crear_boton(caja_botones,"INICIAR", "boton-juego", G_CALLBACK(iniciarSimulacion), NULL);
    GtkWidget *boton3 = crear_boton(caja_botones, "CARGAR", "boton-juego", G_CALLBACK(recargarMatriz), NULL);
    GtkWidget *boton4 = crear_boton(caja_botones, "SALIR", "boton-juego", NULL, NULL);
    g_signal_connect_swapped(boton4, "clicked", G_CALLBACK(g_application_quit), app_global);

    gtk_box_append(GTK_BOX(contenedor_global), caja_botones);

    return ventana_global;
}
