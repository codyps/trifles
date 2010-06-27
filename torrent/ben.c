#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "ben.h"

#define DIE(...) do {\
	fprintf(stderr, "%s:%d:%s : ", __FILE__, __LINE__,__func__);\
	fprintf(stderr, __VA_ARGS__);\
	fputc('\n', stderr);\
	exit(1);\
} while(0)

#define INFO(...) do {\
	fprintf(stderr, "%s:%d:%s : ", __FILE__, __LINE__,__func__);\
	fprintf(stderr, __VA_ARGS__);\
	fputc('\n', stderr);\
} while(0)

void be_print_indent(struct be_node *be, FILE *out, size_t indent);
void spaces(size_t num, FILE *out)
{
	for(; num != 0; num--) {
		fputc(' ', out);
	}
}

void be_print_str(struct be_str *str, FILE *out)
{
	fprintf(out, "str : ");
	fwrite(str->str, str->len, 1, out);
}

void be_print_int(long long num, FILE *out)
{
	fprintf(out, "int: %lld\n", num);
}

void be_print_dict(struct be_dict *dict, FILE *out, size_t indent)
{
	fputs("dict:", out);
	size_t i;
	for(i = 0; i < dict->len; i++) {
		fputc('\n', out);
		fputc(' ', out);
		be_print_str(dict->key[i], out);
		fputc(':', out);
		be_print_indent(dict->val[i], out, indent + 1);
	}
}

void be_print_list(struct be_list *list, FILE *out, size_t indent)
{
	size_t i;
	fputs("list:", out);
	for(i = 0; i < list->len; i++) {
		fputc('\n', out);
		be_print_indent(list->nodes[i], out, indent + 1);
	}
}

void be_print_indent(struct be_node *be, FILE *out, size_t indent)
{
	size_t i;
	spaces(indent, out);

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

void be_print(struct be_node *be, FILE *out)
{
	be_print_indent(be, out, 0);
}

struct be_list *bdecode_list(const char *estr, size_t len, const char **ep)
{
	INFO("decode list");
	struct be_list *l = malloc(sizeof(*l));
	l->nodes = 0;
	l->len = 0;

	/* assert(*estr == 'l'); */
	const char *ppos;
	for(ppos = estr + 1; ; len--, ppos++) {
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
			ppos = *ep;
		} else {
			DIE("malloc");
		}
	}

	*ep = estr + 1;
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
	INFO("%c => strlen dig. curr slen = %d",
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

		INFO("%c => strlen dig. curr slen = %d",
				*ppos, slen);
		slen *= 10;
		slen += *ppos - '0';
		/* TODO: detect overflow. */
	}

	/* ppos points to the ':' */
	if (slen == 0 || slen > len) {
		printf("slen : %d; len : %d\n", slen, len);
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
	bstr->str = malloc(bstr->len);
	if (!bstr->str) {
		*ep = estr;
		free(bstr);
		DIE("");
		return 0;
	}

	memcpy(bstr->str, ppos + 1, bstr->len);

	*ep = ppos + 1 + slen;

	INFO("str parsed:");
	be_print_str(bstr, 0);
	return bstr;
}

struct be_dict *bdecode_dict(const char *estr, size_t len, const char **ep)
{
	INFO("decode dict.");
	/* *estr = 'd' */
	const char *ppos = estr + 1;
	len --;

	struct be_dict *dict = malloc(sizeof(*dict));
	dict->key = 0;
	dict->val = 0;
	dict->len = 0;

	for(;;) {
		if (len <= 0) {
			free(dict->key);
			free(dict->val);
			free(dict);
			DIE("dict ran out.");
			*ep = ppos;
			return 0;
		} else if(*ppos == 'e') {
			/* dict done */
			*ep = ppos;
			return dict;
		}

		dict->len++;
		dict->key = realloc(dict->key, sizeof(dict->key) * dict->len);
		dict->val = realloc(dict->val, sizeof(dict->val) * dict->len);

		/* now decode string */
		dict->key[dict->len - 1] = bdecode_str(ppos, len, ep);

		len -= *ep - ppos;
		ppos = *ep;

		/* decode node */
		dict->val[dict->len - 1] = bdecode(ppos, len, ep);

		len -= *ep - ppos;
		ppos = *ep;
	}


	DIE("attempt dict decode.");
	return 0;
}

long long bdecode_int(const char *estr, size_t len, const char **ep)
{
	INFO("decode int");
	const char *ppos = estr;
	if (len < 3) {
		/* at least 3 characters for a valid  int */
		*ep = estr;
		DIE("not enough chars for int");
		return 0;
	}

	if (*ppos != 'i') {
		/* first must be a 'i' */
		DIE("");
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
			DIE("");
			*ep = estr;
			return 0;
		}
	
		if (*ppos == 'e') {
			*ep = ppos;
			INFO(" int: %lld", sign * num);
			return sign * num;
		} else if (!isdigit(*ppos)) {
			*ep = estr;
			DIE("");
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


