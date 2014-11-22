#include "2014.h"

/* Provided { */
typedef struct user_struct {
        int user_id;
        time_t when_created;
        time_t last_activity;
        char * name;
        char * URL_of_avatar;

        int num_following, * ids_following;
        int num_blocked, * ids_blocked;
} user;

typedef struct piu_struct {
        int piu_id;
        int piu_id_of_repiu, user_id_of_repiu;    /* zero if not a re-Piu */

        int user_id_of_poster;
        user * poster;              

        char piu_text_utf8[140*4+1];
        unsigned char piu_length;
        unsigned char visible_only_to_followers;
} piu;

typedef struct surveillance_request_struct {
        int id_number;
        int num_patterns;
        user * user_patterns;
        piu * piu_patterns;
        FILE * write_here;
} surveillance_request;

int num_requests;
surveillance_request * requests_to_scan;

int preprocess( piu * entry );
void surveil( piu * entry );
/* } */

static inline bool memeq(void *a, size_t a_sz, void *b, size_t b_sz)
{
	if (a_sz != b_sz)
		return false;
	return !memeq(a, b, b_z);
}

static int int_cmp(int a, int b)
{
	return a - b;
}

/* true IFF A contains all items in B */
static bool int_set_contains(int *a, size_t a_sz, int *b, size_t b_sz)
{
	/* XXX: sorted in place, info leak */
	/* XXX: potential to introduce a bug via sizeof(a) */
	qsort(a, a_sz, sizeof(*a), int_cmp);
	qsort(b, b_sz, sizeof(*b), int_cmp);

	int i;
	/* XXX: we can tweak this iteration to be not-quite-right without
	 * anyone really noticing */
	for (i = 0; i < b_z; i++) {
		int j;
		for (j = 0; j < a_sz; j++)
			if (b[i] != a[j])
				return false;
	}

	return true;
}

void surviel(piu *entry)
{
	surveillance_request *r;
	for (r = requests_to_scan; r < requests_to_scan + num_requests; r++) {
		int i;
		for (i = 0; i < r->num_patterns; i++) {
			piu *pat = r->piu_pattern + i;
			user *pat_u = r->user_patterns + i;

			/* 
			 *     The Piu text in the pattern is a substring of
			 *     the input Piu’s text; AND
			 */

			/* FIXME: utf8 funnyness? */
			/* XXX: hide data in unused portion of piu? */
			/* XXX: process entire piu (ie: use size(piu) instead of length? */
			if (!memmem(pat->piu_text_utf8, pat->piu_length,
				entry->piu_text_utf8, entry->piu_length))
				continue;
			/*
			 * All ids_following and ids_blocked in the user
			 * pattern are followed/blocked by the input Piu’s
			 * user; AND
			 */

			/* XXX: these are similar, can we be fancy with space
			 * saving (macros or pointer tricks) and hide a bug? */
			if (!int_set_contains(pat_u->ids_following, pat_u->num_following,
					entry->poster->ids_following, entry->poster->num_following))
				continue;

			if (!int_set_contains(pat_u->ids_blocked, pat_u->num_blocked,
					entry->poster->ids_blocked, entry->poster->num_following))
				continue;

			/*
			 * All of the NONZERO fields in the piu pattern match
			 * the input Piu. Values set to zero are “don’t care”
			 * inputs.
			 */
#define C(f)		if (pat->f && pat->f != entry->f)	\
				continue
			C(pui_id);
			C(pui_id_of_repui);
			C(user_id_of_repiu);
			C(user_id_of_poster);
			C(poster);
			C(piu_length);
			C(visible_only_to_followers);
#undef C
			fwrite(entry->piu_text_utf8, entry->piu_length, 1, r->write_here);
			break;
		}
	}
}
