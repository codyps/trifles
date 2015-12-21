#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#ifdef __cplusplus
#define EXTERN_C extern "C"
#else
#define EXTERN_C
#endif

struct ubsan_source_location {
	const char *filename;
	uint32_t line;
	uint32_t column;
};

enum ubsan_type_kind {
	/*
	 * struct utk_int_type_info {
	 *	u16 base_two_size: 15;
	 *	u16 is_signed: 1;
	 * }
	 *
	 * if (sizeof(value) =< sizeof(value_handle))
	 *  value_handle = value;
	 * else
	 *  value_handle = &value;
	 */
	utk_int = 0,

	/*
	 * struct utk_float_type_info {
	 *	u16 bit_width;
	 * }
	 *
	 * value_handle is set the same way as integer type, after casting the
	 * float to an int.
	 */
	utk_float = 1,
	utk_unknown = 0xffff
};

struct ubsan_type_descriptor {
	/* one of enum ubsan_type_kind */
	uint16_t type_kind;

	/* interp varies based on type_kind, see individual decoding notes above */
	uint16_t type_info;

	/*
	 * used as a vla, with a minimum size of 1
	 * null terminated string
	 */
	char type_name[1];
};

typedef uintptr_t ubsan_value_handle_t;

static const struct ubsan_source_location unknown_location = {
	"<unknown file>",
	0,
	0,
};

__attribute__((noreturn))
static void ubsan_abort(const struct ubsan_source_location* location,
                        const char* violation)
{
	if ( !location || !location->filename )
		location = &unknown_location;
	fprintf(stderr, "Undefined behavior: %s at %s:%u:%u: Aborting.\n",
		violation,
		location->filename,
		location->line,
		location->column);
	abort();
}

struct ubsan_type_mismatch_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
	uintptr_t alignment;
	unsigned char type_check_kind;
};

EXTERN_C
void __ubsan_handle_type_mismatch(void* data_raw,
                                  void* pointer_raw)
{
	struct ubsan_type_mismatch_data* data = (struct ubsan_type_mismatch_data*) data_raw;
	ubsan_value_handle_t pointer = (ubsan_value_handle_t) pointer_raw;
	(void) pointer;
	ubsan_abort(&data->location, "type mismatch");
}

struct ubsan_overflow_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor type; /* TODO: C++ const reference? */
};

EXTERN_C
void __ubsan_handle_add_overflow(void* data_raw,
                                 void* lhs_raw,
                                 void* rhs_raw)
{
	struct ubsan_overflow_data* data = (struct ubsan_overflow_data*) data_raw;
	ubsan_value_handle_t lhs = (ubsan_value_handle_t) lhs_raw;
	ubsan_value_handle_t rhs = (ubsan_value_handle_t) rhs_raw;
	(void) lhs;
	(void) rhs;
	ubsan_abort(&data->location, "addition overflow");
}

EXTERN_C
void __ubsan_handle_sub_overflow(void* data_raw,
                                 void* lhs_raw,
                                 void* rhs_raw)
{
	struct ubsan_overflow_data* data = (struct ubsan_overflow_data*) data_raw;
	ubsan_value_handle_t lhs = (ubsan_value_handle_t) lhs_raw;
	ubsan_value_handle_t rhs = (ubsan_value_handle_t) rhs_raw;
	(void) lhs;
	(void) rhs;
	ubsan_abort(&data->location, "subtraction overflow");
}

EXTERN_C
void __ubsan_handle_mul_overflow(void* data_raw,
                                 void* lhs_raw,
                                 void* rhs_raw)
{
	struct ubsan_overflow_data* data = (struct ubsan_overflow_data*) data_raw;
	ubsan_value_handle_t lhs = (ubsan_value_handle_t) lhs_raw;
	ubsan_value_handle_t rhs = (ubsan_value_handle_t) rhs_raw;
	(void) lhs;
	(void) rhs;
	ubsan_abort(&data->location, "multiplication overflow");
}

EXTERN_C
void __ubsan_handle_negate_overflow(void* data_raw,
                                    void* old_value_raw)
{
	struct ubsan_overflow_data* data = (struct ubsan_overflow_data*) data_raw;
	ubsan_value_handle_t old_value = (ubsan_value_handle_t) old_value_raw;
	(void) old_value;
	ubsan_abort(&data->location, "negation overflow");
}

EXTERN_C
void __ubsan_handle_divrem_overflow(void* data_raw,
                                    void* lhs_raw,
                                    void* rhs_raw)
{
	struct ubsan_overflow_data* data = (struct ubsan_overflow_data*) data_raw;
	ubsan_value_handle_t lhs = (ubsan_value_handle_t) lhs_raw;
	ubsan_value_handle_t rhs = (ubsan_value_handle_t) rhs_raw;
	(void) lhs;
	(void) rhs;
	ubsan_abort(&data->location, "division remainder overflow");
}

struct ubsan_shift_out_of_bounds_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *lhs_type;
	const struct ubsan_type_descriptor *rhs_type;
};

EXTERN_C
void __ubsan_handle_shift_out_of_bounds(void* data_raw,
                                        void* lhs_raw,
                                        void* rhs_raw)
{
	struct ubsan_shift_out_of_bounds_data* data = (struct ubsan_shift_out_of_bounds_data*) data_raw;
	ubsan_value_handle_t lhs = (ubsan_value_handle_t) lhs_raw;
	ubsan_value_handle_t rhs = (ubsan_value_handle_t) rhs_raw;
	(void) lhs;
	(void) rhs;
	ubsan_abort(&data->location, "shift out of bounds");
}

struct ubsan_out_of_bounds_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *array_type;
	const struct ubsan_type_descriptor *index_type;
};

EXTERN_C
void __ubsan_handle_out_of_bounds(void* data_raw,
                                  void* index_raw)
{
	struct ubsan_out_of_bounds_data* data = (struct ubsan_out_of_bounds_data*) data_raw;
	ubsan_value_handle_t index = (ubsan_value_handle_t) index_raw;
	(void) index;
	ubsan_abort(&data->location, "out of bounds");
}

struct ubsan_unreachable_data
{
	struct ubsan_source_location location;
};

EXTERN_C
void __ubsan_handle_builtin_unreachable(void *data_raw)
{
	struct ubsan_unreachable_data* data = (struct ubsan_unreachable_data*) data_raw;
	ubsan_abort(&data->location, "reached unreachable");
}

EXTERN_C
void __ubsan_handle_missing_return(void* data_raw)
{
	struct ubsan_unreachable_data* data = (struct ubsan_unreachable_data*) data_raw;
	ubsan_abort(&data->location, "missing return");
}

struct ubsan_vla_bound_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
};

EXTERN_C
void __ubsan_handle_vla_bound_not_positive(void* data_raw,
                                           void* bound_raw)
{
	struct ubsan_vla_bound_data* data = (struct ubsan_vla_bound_data*) data_raw;
	ubsan_value_handle_t bound = (ubsan_value_handle_t) bound_raw;
	(void) bound;
	ubsan_abort(&data->location, "negative variable array length");
}

struct ubsan_float_cast_overflow_data {
	//struct ubsan_source_location location; // TODO: `FIXME' according to GCC source.
	const struct ubsan_type_descriptor *from_type;
	const struct ubsan_type_descriptor *to_type;
};

struct ubsan_float_cast_overflow_data_v2 {
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *from_type;
	const struct ubsan_type_descriptor *to_type;
};

EXTERN_C
void __ubsan_handle_float_cast_overflow(void* data_raw,
                                        void* from_raw)
{
	struct ubsan_float_cast_overflow_data* data = (struct ubsan_float_cast_overflow_data*) data_raw;
	ubsan_value_handle_t from = (ubsan_value_handle_t) from_raw;
	(void) from;
	ubsan_abort(((void) data, &unknown_location), "float cast overflow");
}

struct ubsan_invalid_value_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor *type;
};

EXTERN_C
void __ubsan_handle_load_invalid_value(void* data_raw,
                                       void* value_raw)
{
	struct ubsan_invalid_value_data* data = (struct ubsan_invalid_value_data*) data_raw;
	ubsan_value_handle_t value = (ubsan_value_handle_t) value_raw;
	(void) value;
	ubsan_abort(&data->location, "invalid value load");
}

struct ubsan_function_type_mismatch_data
{
	struct ubsan_source_location location;
	const struct ubsan_type_descriptor *type;
};

EXTERN_C
void __ubsan_handle_function_type_mismatch(void* data_raw,
                                           void* value_raw)
{
	struct ubsan_function_type_mismatch_data* data = (struct ubsan_function_type_mismatch_data*) data_raw;
	ubsan_value_handle_t value = (ubsan_value_handle_t) value_raw;
	(void) value;
	ubsan_abort(&data->location, "function type mismatch");
}

struct ubsan_nonnull_return_data {
	struct ubsan_source_location loc;
	struct ubsan_source_location attr_loc;
};

void __ubsan_handle_nonnull_return(struct ubsan_nonnull_return_data *data)
{
	ubsan_abort(&data->loc, "nonnull return");
}

struct ubsan_cfi_bad_icall_data {
	struct ubsan_source_location loc;
	const struct ubsan_type_descriptor *type;
};

void __ubsan_handle_cfi_bad_icall(struct ubsan_cfi_bad_icall_data *data, ubsan_value_handle_t function)
{
	(void)function;
	ubsan_abort(&data->loc, "cfi bad icall");
}
