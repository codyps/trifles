#include "../../list.h"

int main(void)
{
	struct list_head h;
	list_init_(&h);

	struct list_node n1;
	struct list_node n2;
	struct list_node n3;

	list_append_(&h, &n1);
	list_append_(&h, &n2);
	list_append_(&h, &n3);

	return 0;
}
