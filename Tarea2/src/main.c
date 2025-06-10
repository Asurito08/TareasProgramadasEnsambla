#include <gtk/gtk.h>
#include "lifegame.h"

static void activate(GtkApplication *app, gpointer user_data) {
    // Estilo CSS
    GtkCssProvider *provider = gtk_css_provider_new();
    gtk_css_provider_load_from_path(provider, "estilo.css");
    gtk_style_context_add_provider_for_display(
        gdk_display_get_default(),
        GTK_STYLE_PROVIDER(provider),
        GTK_STYLE_PROVIDER_PRIORITY_USER
    );

    // Crear e iniciar la ventana del juego
    GtkWidget *ventana = crearPantallalifegame(app);
    gtk_window_present(GTK_WINDOW(ventana));
}

int main( int argc, char **argv) {

    GtkApplication *app = gtk_application_new("com.life.game", G_APPLICATION_DEFAULT_FLAGS);
    app_global = app;
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    int estado = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);
    return estado;
}
