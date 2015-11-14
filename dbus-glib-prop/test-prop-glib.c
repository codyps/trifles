/* ex: set noet sts=8 sw=8 ts=8 : */
#include "login1.h"

static void
on_idle_action (GObject    *gobject,
               GParamSpec *pspec,
               gpointer    user_data)
{
	g_print("Got it!\n");
}

int main(int argc, char *argv[])
{
	if (argc != 2) {
		return -1;
	}

	GError *error = NULL;
	login1Manager *l = login1_manager_proxy_new_for_bus_sync(
			G_BUS_TYPE_SYSTEM,
			G_DBUS_CONNECTION_FLAGS_NONE,
			"org.freedesktop.login1",
			argv[1],
			NULL,
			&error);

	if (!l) {
		g_printerr("no proxy: %s\n", error->message);
		return -1;
	}

	int id = g_signal_connect(l, "notify::idle-action", 
			G_CALLBACK(on_idle_action), NULL);
	if (id < 0) {
		g_printerr("no signal: %d\n", id);
		return -1;
	}

	GMainLoop *loop = g_main_loop_new(NULL, FALSE);
	g_main_loop_run (loop);
	return 0;
}
