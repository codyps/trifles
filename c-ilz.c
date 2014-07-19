#include "c-ilz.h"
#include "c-struct-ilz.h"

static struct c_ilz_elem *create_uint(const char *id_, size_t id_len_, uintmax_t v_)
{
	struct c_ilz_elem *e = malloc(sizeof(*e));
	if (!e)
		return NULL;

	*e = (typeof(e)) {
		.type = C_IZL_UINT,
		.member = id_,
		.member_len = id_len_,
		.uint = v,
	};

	return e;
}

static struct c_ilz_elem *create_str(const char *id_, size_t id_len_, char *str, size_t str_len)
{
	struct c_ilz_elem *e = malloc(offsetof(struct c_ilz_elem, array[str_len]));
	if (!e)
		return NULL;

	*e = (typeof(e)) {
		.type = C_IZL_ARRAY,
		.member = id_,
		.member_len = id_len_,
		.array.len = str_len,
	};

	memcpy(e->array.data, str, str_len);
	return e;
}

static uint32_t hash_elem_by_id(struct c_ilz_elem *e)
{
	return tommy_hash_u32(0, e->member, e->member_len);
}

static void c_ilz_insert_under(struct c_ilz_elem *parent, struct c_ilz_elem *child)
{
	assert(parent->type == C_IZL_STRUCT);
	tommy_hashlin_insert(&parent->struct_.children, &child->node, child, hash_elem_by_id(child));
}

struct c_ilz_elem *c_ilz_find(struct c_ilz_elem *root, char *path)
{
	return NULL;
}

struct c_ilz_ctx_plus {
	struct c_ilz_ctx ctx;
	struct c_ilz_elem *root;
	struct c_ilz_elem *parent;
};

struct c_ilz_ctx_plus *ctx_to_plus(struct c_ilz_ctx *ctx)
{
	return container_of(ctx, struct c_ilz_ctx_plus, ctx);
}

static int cb_uint(struct c_ilz_ctx *i, const char *id_, size_t id_len_, uintmax_t v_)
{
	struct c_ilz_ctx_plus *ctx = ctx_to_plus(i);
	struct c_ilz_elem *e = create_uint(id_, id_len_, v_);
	if (!e)
		return -1;

	c_ilz_insert_under(ctx->root, e);
	return 0;
}

static int cb_str(struct c_ilz_ctx *i, const char *id_, size_t id_len_, const char *str_, size_t str_len_)
{
	struct c_ilz_ctx_plus *ctx = ctx_to_plus(i);
	struct c_ilz_elem *e = create_str(id_, id_len_, str_, str_len_);
	if (!e)
		return -1;

	c_ilz_insert_under(ctx->root, e);
	return 0;
}

int c_ilz_read(struct c_ilz_elem *ilz, const char *data, size_t data_len)
{
	/* assume we have a top level {} */
	*ilz = (struct c_ilz_elem){
		.type = C_IZL_STRUCT,
		.member = NULL,
		.member_len = 0,
	};
	tommy_hashlin_init(&ilz->struct_.children);

	struct c_ilz_ctx_plus ctx = {
		.ctx = {
			.parse_uint = cb_uint,
			.parse_string = cb_str
		},
		.root = ilz,
	};

	return parse_c_ilz(&ctx.ctx, data, data_len);
}
