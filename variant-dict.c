#include <glib.h>
#include <stdio.h>

int main(void)
{
    GVariantDict actual_b;
    GVariantBuilder target_b;
    g_variant_dict_init(&actual_b, NULL);
    GVariantType *t = g_variant_type_new("a{sd}");
    g_variant_builder_init(&target_b, t);

    g_variant_dict_insert(&actual_b, "speed", "d", 4);
    g_variant_dict_insert(&actual_b, "incline", "d", 2.0);

    g_variant_builder_add(&target_b, "{sd}", "speed", 5);
    g_variant_builder_add(&target_b, "{sd}", "incline", 1.9);

    GVariant *actual = g_variant_dict_end(&actual_b);
    GVariant *target = g_variant_builder_end(&target_b);

    GVariant *v = g_variant_new("({s@a{sv}}{s@a{sd}})", "actual", actual, "target", target);

    gchar *out = g_variant_print(v, TRUE);
    const gchar *type = g_variant_get_type_string(v);

    printf("v: %s\n", out);
    printf("t: %s\n", type);

    g_free(out);
    g_variant_type_free(t);
    g_variant_unref(v);
    return 0;
}
