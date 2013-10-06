#include <stdio.h>
#include <string.h>

int main(int argc, char **argv)
{
	if (argc != 2)
		return 1;

	printf("digraph g {\n");

	char *s = strtok(argv[1], " ");
	int i = 0;
	while (s) {
		printf("\tn%d -> n%s;\n", i, s);
		s = strtok(NULL, " ");
		i++;
	}

	printf("}\n");
	return 0;
}
