#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ben.h"

struct be_list *bdecode_list(const char *estr, size_t len, const char **ep)
{
	struct be_list *l = malloc(sizeof(*l));
	l->nodes = 0;
	l->len = 0;

	/* assert(*estr == 'l'); */
	for(estr += 1; *estr != 'e' ; len--, estr++) {
		if (len <= 0) {
			// die.
		}

		struct be_node *n = bdecode(estr, len, ep);
		if (n) {
			l->len ++;
			l->nodes = realloc(l->nodes, 
				sizeof(*(l->nodes)) * l->len);
			l->nodes[l->len - 1] = n;
			estr = *ep;
		} else {
			fprintf(stderr, "problem decoding at %p\n", estr);
		}
	}
}

/* parses a bencoded str from the encoded string buffer.
 * on error : returns 0, estr = ep.
 */
struct be_str *bdecode_str(const char *estr, size_t len, const char **ep)
{
	if (len == 0) {
		*ep = estr;
		return 0;
	}

	const char *ppos = estr;
	size_t slen = *ppos - '0';
	for(;;) {
		ppos++;
		len--;
		if(len <= 0) {
			*ep = estr;
			return 0;
		} else if (*ppos == ':') {
			break;
		}

		slen *= 10;
		slen += *ppos - '0';
		/* TODO: detect overflow. */
	}

	/* ppos points to the ':' */
	if (slen == 0 || slen > len) {
		/* not a valid string. */
		*ep = estr;
		return 0;
	}

	char *str = malloc(len);
	if (!str) {
		*ep = estr;
		return 0;
	}

	memcpy(str, ppos + 1, len);

	struct be_str *bstr = malloc(sizeof(*bstr));
	if (!bstr) {
		*ep = estr;
		free(str);
		return 0;
	}

	bstr->len = slen;
	bstr->str = str;
	*ep = ppos + 1 + slen;
	return bstr;
}

struct be_dict *bdecode_dict(const char *estr, size_t len, const char **ep)
{
	return 0;
}

long long bdecode_int(const char *estr, size_t len, const char **ep)
{
	return 0;
}

struct be_node *bdecode(const char *estr, size_t len, const char **ep)
{
	struct be_node *ret;
	switch(*estr) {
	case 'd':
		ret = malloc(sizeof(*ret));
		if (ret) {
			ret->u.d = bdecode_dict(estr, len, ep);
			ret->type = BE_DICT;
		}
		return ret;
	case 'i':
		ret = malloc(sizeof(*ret));
		if (ret) {
			ret->u.i = bdecode_int(estr, len, ep);
			ret->type = BE_INT;
		}
		return ret;
	case 'l':
		ret = malloc(sizeof(*ret));
		if (ret) {
			ret->u.l = bdecode_list(estr, len, ep);
			ret->type = BE_LIST;
		}
		return ret;
	case '0':
	case '1':
	case '2':
	case '3':
	case '4':
	case '5':
	case '6':
	case '7':
	case '8':
	case '9':
		ret = malloc(sizeof(*ret));
		if (ret) {
			ret->u.s = bdecode_str(estr, len, ep);
			ret->type = BE_STR;
		}
		return ret;
	default:
		return 0;
	}
}


