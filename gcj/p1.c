#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <limits.h>

#include "list.h"

#define L_TRACK_INIT(name) { .acts = LIST_HEAD_INIT(name.acts), .pos = {1, 1} }
#define L_TRACK(name) struct l_track name = L_TRACK_INIT(name)

struct act {
	bool blue;
	unsigned goal_pos;
	struct list_head list;
};

struct l_track {
	struct list_head acts;
#define P_ORANGE 0
#define P_BLUE 1
	unsigned pos[2];
	unsigned time_total;
};


struct act *find_next_other(struct act *cur, struct list_head *head)
{
	struct act *cur2;
	bool blue = cur->blue;
	list_for_each_entry(cur2, head, list) {
		if (blue != cur2->blue)
			return cur2;
	}

	/* XXX: oh god this will blow up in my face */
	return NULL;
}

unsigned abs_diff(unsigned goal, unsigned cur)
{
	//printf("goal: %u cur: %u\n", goal, cur);
	if (goal > cur)
		return goal - cur;
	else
		return cur - goal;
}

unsigned move_closer_by(unsigned cur_pos, unsigned goal_pos, unsigned time_passed)
{
	if (cur_pos > goal_pos) {
		return cur_pos - time_passed;
	} else {
		return cur_pos + time_passed;
	}
}

int eval_line(struct l_track *lt)
{
	struct act *cur;
	struct act *n;
	struct act *oth = list_entry(lt->acts.next, typeof(*oth), list);
	list_for_each_entry_safe(cur, n, &lt->acts, list) {
		if (cur == oth) {
			oth = find_next_other(cur, &lt->acts);
		}

		unsigned cur_tt = abs_diff(cur->goal_pos, lt->pos[cur->blue]) + 1;
		if (oth) {
			unsigned oth_tt =
				abs_diff(oth->goal_pos, lt->pos[oth->blue]) + 1;

			/* XXX: the edge case is hard due to button presses being a
			 * separate move from moving */
			if (oth_tt <= cur_tt) {
				lt->pos[oth->blue] = oth->goal_pos;
			} else {
				/* adj other pos closer to goal by cur_tt */
				lt->pos[oth->blue] = move_closer_by(
						lt->pos[oth->blue],
						oth->goal_pos,
						cur_tt);
			}
		}

		lt->pos[cur->blue] = cur->goal_pos;
		lt->time_total += cur_tt;
		//printf("\ttt: %u (+%u)\n", lt->time_total, cur_tt);

		list_del(&cur->list);
		free(cur);
	}

	return 0;
}

int parse_line(FILE *in, struct l_track *lt)
{
	unsigned acts;
	int ret = fscanf(in, "%u ", &acts);
	if (ret != 1) {
		perror("bleh");
		return -2;
	}

	unsigned i;
	for (i = 0; i < acts; i ++) {
		char color_char;
		unsigned goal_pos;
		ret = fscanf(in, "%c %u ", &color_char, &goal_pos);
		if (ret != 2) {
			perror("Belh");
			printf("matched %u %d\n", i, ret);
			return -4;
		}

		struct act *nact = malloc(sizeof(*nact));

		nact->blue = color_char == 'B';
		nact->goal_pos = goal_pos;

		list_add_tail(&nact->list, &lt->acts);
	}

	return 0;
}

int main(int argc, char **argv)
{
	unsigned cases;
	int ret = scanf("%u\n", &cases);
	if (ret != 1)
		return -1;

	unsigned i;
	for (i = 0; i < cases; i ++) {
		L_TRACK(lt);

		ret = parse_line(stdin, &lt);
		if (ret < 0)
			return ret;

		ret = eval_line(&lt);
		if (ret < 0)
			return ret;

		printf("Case #%u: %u\n", i + 1, lt.time_total);
	}

	return 0;
}
