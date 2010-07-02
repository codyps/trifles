#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <search.h>
#include "ben.h"

int debug = 0;

#define DIE(...) do {\
	fflush(stdout);\
	fprintf(stderr, "%s:%d:%s : ", __FILE__, __LINE__,__func__);\
	fprintf(stderr, __VA_ARGS__);\
	fputc('\n', stderr);\
	fflush(stderr);\
	exit(1);\
} while(0)

#define INFO(...) do {\
	if (debug) {\
		fflush(stdout);\
		fprintf(stderr, "%s:%d:%s : ", __FILE__, __LINE__,__func__);\
		fprintf(stderr, __VA_ARGS__);\
		fputc('\n', stderr);\
		fflush(stderr);\
	}\
} while(0)

void be_print_node(struct be_node *be, FILE *out, size_t indent);
void be_print_indent(struct be_node *be, FILE *out, size_t indent);
void spaces(size_t num, FILE *out)
{
	for(; num != 0; num--) {
		fputc(' ', out);
	}
}

void be_print_str(struct be_str *str, FILE *out)
{
	fprintf(out, "%zu:", str->len);
	fwrite(str->data, str->len, 1, out);
	fputc('\n', out);
}

void be_print_int(long long num, FILE *out)
{
	fprintf(out, " i %lld\n", num);
}

void be_print_dict(struct be_dict *dict, FILE *out, size_t indent)
{
	fputs("d\n", out);
	size_t i;
	for(i = 0; i < dict->len; i++) {
		spaces(indent + 1, out);
		struct be_str *bstr = dict->keys[i];
		fprintf(out, "%zu:", bstr->len);
		fwrite(bstr->data, bstr->len, 1, out);
		fputc(':', out);
		be_print_node(dict->vals[i], out, indent + 1);
	}
}

void be_print_list(struct be_list *list, FILE *out, size_t indent)
{
	size_t i;
	fputs("l", out);
	for(i = 0; i < list->len; i++) {
		fputc('\n', out);
		be_print_indent(list->nodes[i], out, indent + 1);
	}
}

void be_print_node(struct be_node *be, FILE *out, size_t indent)
{
	switch(be->type) {
	case BE_INT:
		be_print_int(be->u.i, out);
		break;
	case BE_STR:
		be_print_str(be->u.s, out);
		break;
	case BE_DICT:
		be_print_dict(be->u.d, out, indent);
		break;
	case BE_LIST:
		be_print_list(be->u.l, out, indent);
		break;
	default:
		DIE("unknown BE type %d\n", be->type);
	}
}

void be_print_indent(struct be_node *be, FILE *out, size_t indent)
{
	spaces(indent, out);
	be_print_node(be, out, indent);
}

int be_str_cmp(const void *a1, const void *a2)
{
	/* a1 < a2 = -num
	 * a1 = a2 = 0
	 * a1 > a2 = +num
	 */

	const struct be_str *b1 = a1, *b2 = a2;
	ssize_t ldiff = b1->len - b2->len;

	if (ldiff) {
		return ldiff;
	} else {
		return memcmp(b1->data, b2->data, b1->len);
	}
}

/* Returns the first value with a matching key */
struct be_node *be_dict_lookup(const struct be_dict *dict,
		const struct be_str *key)
{
	size_t i;
	for(i = 0; i < dict->len; i++) {
		const struct be_str *lkey = dict->keys[i];
		ssize_t diff = lkey->len - key->len;
		if(diff) {
			int x = memcmp(lkey->data, key->data, key->len);
			if (!x)
				return dict->vals[i];
		}
	}
	
	return 0;
}

void be_print(struct be_node *be, FILE *out)
{
	be_print_indent(be, out, 0);
}

struct be_node *be_dict_insert(const struct be_dict *dict,
		const struct be_node *data)
{
	return 0;
}

struct be_node *be_dict_remove(const struct be_dict *dict,
		const struct be_str *key) 
{
	return 0;
}

struct be_list *bdecode_list(const char *estr, size_t len, const char **ep)
{
	INFO("decode list");
	struct be_list *l = malloc(sizeof(*l));
	l->nodes = 0;
	l->len = 0;

	/* assert(*estr == 'l'); */
	const char *ppos;
	for(ppos = estr + 1; ;) {
		if (len <= 0) {
			*ep = estr;
			DIE("list decode barf.");
			return 0;
		} else if (*ppos == 'e') {
			break;
		}

		struct be_node *n = bdecode(ppos, len, ep);
		if (n) {
			l->len ++;
			l->nodes = realloc(l->nodes, 
				sizeof(*(l->nodes)) * l->len);
			l->nodes[l->len - 1] = n;
			len -= *ep - ppos;
			ppos = *ep;
		} else {
			DIE("malloc");
		}
	}

	*ep = ppos + 1;
	INFO("got list, len = %zd", l->len);
	return l;
}

/* parses a bencoded str from the encoded string buffer.
 * on error : returns 0, estr = ep.
 */
struct be_str *bdecode_str(const char *estr, size_t len, const char **ep)
{
	INFO("decode str");
	if (len == 0) {
		*ep = estr;
		DIE("no length");
		return 0;
	}

	const char *ppos = estr;
	size_t slen = *ppos - '0';
	INFO("%c => strlen dig. curr slen = %zd",
				*ppos, slen);
	for(;;) {
		ppos++;
		len--;
		if(len <= 0) {
			*ep = estr;
			DIE("no length");
			return 0;
		} else if (*ppos == ':') {
			INFO("got to ':'");
			break;
		}

		INFO("%c => strlen dig. curr slen = %zd",
				*ppos, slen);
		slen *= 10;
		slen += *ppos - '0';
		/* TODO: detect overflow. */
	}

	/* ppos points to the ':' */
	if (slen == 0 || slen > len) {
		printf("slen : %zd; len : %zd\n", slen, len);
		/* not a valid string. */
		DIE("i don't know .");
		*ep = estr;
		return 0;
	}

	struct be_str *bstr = malloc(sizeof(*bstr));
	if (!bstr) {
		*ep = estr;
		DIE("alloc fail.");
		return 0;
	}

	bstr->len = slen;
	bstr->data = malloc(bstr->len);
	if (!bstr->data) {
		*ep = estr;
		free(bstr);
		DIE("malloc");
		return 0;
	}

	memcpy(bstr->data, ppos + 1, bstr->len);

	*ep = ppos + 1 + slen;

	INFO("str parsed");
	return bstr;
}

struct be_dict *bdecode_dict(const char *estr, size_t len, const char **ep)
{
	INFO("decode dict.");
	/* *estr = 'd' */
	const char *ppos = estr + 1;
	len --;

	struct be_dict *dict = malloc(sizeof(*dict));
	dict->keys = 0;
	dict->vals = 0;
	dict->len = 0;

	for(;;) {
		if (len <= 0) {
			free(dict->keys);
			free(dict->vals);
			free(dict);
			DIE("dict ran out.");
			*ep = ppos;
			return 0;
		} else if(*ppos == 'e') {
			/* dict done */
			INFO("dict parsed");
			*ep = ppos + 1;
			return dict;
		}

		dict->len++;
		dict->keys = realloc(dict->keys, 
				sizeof(dict->keys) * dict->len);
		dict->vals = realloc(dict->vals, 
				sizeof(dict->vals) * dict->len);

		/* now decode string */
		dict->keys[dict->len - 1] = bdecode_str(ppos, len, ep);

		len -= *ep - ppos;
		ppos = *ep;

		/* decode node */
		dict->vals[dict->len - 1] = bdecode(ppos, len, ep);

		len -= *ep - ppos;
		ppos = *ep;
	}

	DIE("attempt dict decode.");
	return 0;
}

long long bdecode_int(const char *estr, size_t len, const char **ep)
{
	INFO("decode int");
	/* *estr == 'i' */

	const char *ppos = estr + 1;
	len --;
	if (len < 3) {
		/* at least 3 characters for a valid  int */
		*ep = estr;
		DIE("not enough chars for int");
		return 0;
	}

	/* handle the sign */
	int sign;
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
			DIE("ran out of len");
			*ep = estr;
			return 0;
		}
	
		if (*ppos == 'e') {
			*ep = ppos + 1;
			INFO(" int: %lld", sign * num);
			return sign * num;
		} else if (!isdigit(*ppos)) {
			*ep = estr;
			DIE("got non-digit in int.");
			return 0;
		}

		num *= 10;
		num += *ppos - '0';
	}

}

struct be_node *bdecode(const char *estr, size_t len, const char **ep)
{
	INFO("decode node");
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
		DIE("invalid type.");
		return 0;
	}
}


