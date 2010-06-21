#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ben.h"

void spaces(size_t num, FILE *out)
{
	for(; num != 0; num--) {
		fputc(' ', out);
	}
}

void be_print_indent(struct be_node *be, FILE *out, size_t indent)
{
	size_t i;
	spaces(indent, out);

	switch(be->type) {
	case BE_INT:
		fprintf(out, "%d\n", be->u.i);
		break;
	case BE_STR:
		fwrite(be->u.s->str, be->u.s->len, 1, out);
		fputc('\n', out);
		break;
	case BE_DICT:
		fputs("dict:", out);
		for(i = 0; i < be->u.d->len; i++) {
			fputc('\n', out);
			fputc(' ', out);
			fwrite(be->u.d->key[i]->str, 
				be->u.d->key[i]->len, 1, out);
			fputc(':', out);
			be_print_indent(be->u.d->val[i], out, indent + 1);
		}
		break;
	case BE_LIST:
		fputs("list:", out);
		for(i = 0; i < be->u.l->len; i++) {
			fputc('\n', out);
			be_print_indent(be->u.l->nodes[i], out, indent + 1);
		}
		break;
	default:
		fprintf(stderr, "unknown BE type %d\n", be->type);
	}
}

void be_print(struct be_node *be, FILE *out)
{
	be_print_indent(be, out, 0);
}

struct be_list *bdecode_list(const char *estr, size_t len, const char **ep)
{
	struct be_list *l = malloc(sizeof(*l));
	l->nodes = 0;
	l->len = 0;

	/* assert(*estr == 'l'); */
	const char *ppos;
	for(ppos = estr + 1; *ppos != 'e' ; len--, ppos++) {
		if (len <= 0) {
			*ep = estr;
			return 0;
		}

		struct be_node *n = bdecode(ppos, len, ep);
		if (n) {
			l->len ++;
			l->nodes = realloc(l->nodes, 
				sizeof(*(l->nodes)) * l->len);
			l->nodes[l->len - 1] = n;
			ppos = *ep;
		} else {
			fprintf(stderr, "problem decoding at %p\n", ppos);
		}
	}

	*ep = estr;
	return l;
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
	const char *ppos = estr;
	if (len < 3) {
		/* at least 3 characters for a valid  int */
		*ep = estr;
		return 0;
	}

	if (*ppos != 'i') {
		/* first must be a 'i' */
		*ep = estr;
		return 0;
	}
	ppos++;
	len--;

	/* handle the sign */
	uint8_t sign;
	long long num = 0;
	if (*ppos == '-') {
		ppos++;
		len--;
		sign = -1;
	} else {
		sign = 1;
	}

	for(;;ppos++, len--) {
		if (len <= 0) {
			*ep = estr;
			return 0;
		}
	
		if (*ppos == 'e') {
			*ep = ppos;
			return sign * num;
		} else if (!isdigit(*ppos)) {
			*ep = estr;
			return 0;
		}

		num *= 10;
		num += *ppos - '0';
	}

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


