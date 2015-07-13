#include <glib.h>
#include <stdio.h>

int main(void)
{
    GVariantDict actual_b, target_b;
    g_variant_dict_init(&actual_b, NULL);
    g_variant_dict_init(&target_b, NULL);

    g_variant_dict_insert(&actual_b, "speed", "d", 4);
    g_variant_dict_insert(&actual_b, "incline", "d", 2.0);

    g_variant_dict_insert(&target_b, "speed", "d", 5);
    g_variant_dict_insert(&target_b, "incline", "d", 1.9);

    GVariant *actual = g_variant_dict_end(&actual_b);
    GVariant *target = g_variant_dict_end(&target_b);

    GVariant *v = g_variant_new("({sv}{sv})", "actual", actual, "target", target);

    gchar *out = g_variant_print(v, TRUE);

    printf("v: %s\n", out);

    g_free(out);
    g_variant_unref(v);
    return 0;
}
