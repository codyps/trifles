#include <stdlib.h>
#include "generated/api.h"

static void
on_bus_acquired(GDBusConnection *conn, const gchar *name, gpointer user_data)
{
	(void)conn;
	g_print("on bus as %s\n", name);

	Api *a = user_data;

	GError *error = NULL;
	if (!g_dbus_interface_skeleton_export(G_DBUS_INTERFACE_SKELETON(a),
			conn,
			"/com/codyps/api",
			&error)) {
		if (error) {
			g_print("error: %s\n", error->message);
		} else {
			g_print("dbus export skel failed but no error\n");
		}
		exit(EXIT_FAILURE);
	}
}

static void
on_name_acquired(GDBusConnection *conn, const gchar *name, gpointer user_data)
{
	(void)conn;
	(void)user_data;
	g_print("got name %s\n", name);
}

static void
on_name_lost(GDBusConnection *conn, const gchar *name, gpointer user_data)
{
	(void)conn;
	(void)user_data;
	g_print("lost name %s\n", name);
	exit(1);
}

static void
on_junk (GObject *gobject, GParamSpec *pspec, gpointer user_data)
{
	(void)gobject;
	(void)user_data;
	g_print("junk happened!: %s\n", pspec->name);
}

int
main(void)
{
	Api *a = api_skeleton_new();
	if (!a) {
		g_print("could not create skeleton\n");
		exit(EXIT_FAILURE);
	}

	api_set_junk(a, "hi");

	guint own = g_bus_own_name(G_BUS_TYPE_SESSION,
				   "com.codyps.api",
				   G_DBUS_PROXY_FLAGS_NONE,
				   on_bus_acquired,
				   on_name_acquired,
				   on_name_lost,
				   a,
				   NULL);

	g_signal_connect(a, "notify::junk", G_CALLBACK(on_junk), NULL);

	GMainLoop *loop = g_main_loop_new(NULL, FALSE);
	g_main_loop_run(loop);
	g_object_unref(a);
	g_bus_unown_name(own);
	return 0;
}
