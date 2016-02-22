#include <stdlib.h>
#include "generated/api.h"

static void
on_junk (GObject *gobject, GParamSpec *pspec, gpointer user_data)
{
	(void)user_data;
	g_print("junk happened!: %s: %s\n", pspec->name, api_get_junk(API(gobject)));
}

static void
on_ready(GObject *source_object, GAsyncResult *res, gpointer user_data)
{

	g_print("ready!\n");
	GError *error = NULL;
	Api *a = api_proxy_new_for_bus_finish(res, &error);
	if (!a) {
		g_print("error getting api proxy: %s\n", error->message);
		exit(EXIT_FAILURE);
	}

	g_signal_connect(a, "notify::junk", G_CALLBACK(on_junk), NULL);
}

int main(void)
{
	api_proxy_new_for_bus(G_BUS_TYPE_SESSION,
			G_DBUS_PROXY_FLAGS_NONE,
			"com.codyps.api",
			"/com/codyps/api",
			NULL,
			on_ready,
			NULL);

	GMainLoop *loop = g_main_loop_new(NULL, FALSE);
	g_main_loop_run(loop);
	return 0;
}
