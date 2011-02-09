#include <stdio.h>
#include <readline/readline.h>
#include <readline/history.h>

int main(int argc, char **argv)
{
	for (;;) {
		char *l = readline("->| ");
		if (!l)
			continue;
		rl_save_prompt();
		rl_message("<-| %s\n", "hello");
		rl_restore_prompt();
	}
	return 0;
}
