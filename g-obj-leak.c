/* ex: set noet sts=8 ts=8 sw=8: */

#include <error.h>
#include <glib-object.h>

int main(void)
{

	gpointer object = g_object_new(G_TYPE_OBJECT, "bar", "value-of-bar");
	if (!object) {
		error(1, 0, "object creation failure");
	}

	size_t i;
	for (i = 0; i < 1000000; i++) {
		gchar *value = NULL;
		g_object_get(G_OBJECT(object), "bar", &value, NULL);
	}

#if 0
	g_object_unref(obj);
#endif
	return 0;
}
