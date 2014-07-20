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
	const char* filename;
	uint32_t line;
	uint32_t column;
};

struct ubsan_type_descriptor {
	uint16_t type_kind;
	uint16_t type_info;
	char type_name[1]; /* TODO: VLA? */
};

typedef uintptr_t ubsan_value_handle_t;

static const struct ubsan_source_location unknown_location = {
	"<unknown file>",
	0,
	0,
};

__attribute__((noreturn))
static void usban_abort(const struct ubsan_source_location* location,
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
	struct ubsan_type_descriptor type; /* TODO: C++ const reference? */
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
	usban_abort(&data->location, "type mismatch");
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
	usban_abort(&data->location, "addition overflow");
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
	usban_abort(&data->location, "subtraction overflow");
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
	usban_abort(&data->location, "multiplication overflow");
}

EXTERN_C
void __ubsan_handle_negate_overflow(void* data_raw,
                                    void* old_value_raw)
{
	struct ubsan_overflow_data* data = (struct ubsan_overflow_data*) data_raw;
	ubsan_value_handle_t old_value = (ubsan_value_handle_t) old_value_raw;
	(void) old_value;
	usban_abort(&data->location, "negation overflow");
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
	usban_abort(&data->location, "division remainder overflow");
}

struct ubsan_shift_out_of_bounds_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor lhs_type; /* TODO: C++ const reference? */
	struct ubsan_type_descriptor rhs_type; /* TODO: C++ const reference? */
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
	usban_abort(&data->location, "shift out of bounds");
}

struct ubsan_out_of_bounds_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor array_type; /* TODO: C++ const reference? */
	struct ubsan_type_descriptor index_type; /* TODO: C++ const reference? */
};

EXTERN_C
void __ubsan_handle_out_of_bounds(void* data_raw,
                                  void* index_raw)
{
	struct ubsan_out_of_bounds_data* data = (struct ubsan_out_of_bounds_data*) data_raw;
	ubsan_value_handle_t index = (ubsan_value_handle_t) index_raw;
	(void) index;
	usban_abort(&data->location, "out of bounds");
}

struct ubsan_unreachable_data
{
	struct ubsan_source_location location;
};

EXTERN_C
void __ubsan_handle_builtin_unreachable(void* data_raw)
{
	struct ubsan_unreachable_data* data = (struct ubsan_unreachable_data*) data_raw;
	usban_abort(&data->location, "reached unreachable");
}

EXTERN_C
void __ubsan_handle_missing_return(void* data_raw)
{
	struct ubsan_unreachable_data* data = (struct ubsan_unreachable_data*) data_raw;
	usban_abort(&data->location, "missing return");
}

struct ubsan_vla_bound_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor type; /* TODO: C++ const reference? */
};

EXTERN_C
void __ubsan_handle_vla_bound_not_positive(void* data_raw,
                                           void* bound_raw)
{
	struct ubsan_vla_bound_data* data = (struct ubsan_vla_bound_data*) data_raw;
	ubsan_value_handle_t bound = (ubsan_value_handle_t) bound_raw;
	(void) bound;
	usban_abort(&data->location, "negative variable array length");
}

struct ubsan_float_cast_overflow_data
{
	//struct ubsan_source_location location; // TODO: `FIXME' according to GCC source.
	struct ubsan_type_descriptor from_type; /* TODO: C++ const reference? */
	struct ubsan_type_descriptor to_type; /* TODO: C++ const reference? */
};

EXTERN_C
void __ubsan_handle_float_cast_overflow(void* data_raw,
                                        void* from_raw)
{
	struct ubsan_float_cast_overflow_data* data = (struct ubsan_float_cast_overflow_data*) data_raw;
	ubsan_value_handle_t from = (ubsan_value_handle_t) from_raw;
	(void) from;
	usban_abort(((void) data, &unknown_location), "float cast overflow");
}

struct ubsan_invalid_value_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor type; /* TODO: C++ const reference? */
};

EXTERN_C
void __ubsan_handle_load_invalid_value(void* data_raw,
                                       void* value_raw)
{
	struct ubsan_invalid_value_data* data = (struct ubsan_invalid_value_data*) data_raw;
	ubsan_value_handle_t value = (ubsan_value_handle_t) value_raw;
	(void) value;
	usban_abort(&data->location, "invalid value load");
}

struct ubsan_function_type_mismatch_data
{
	struct ubsan_source_location location;
	struct ubsan_type_descriptor type; /* TODO: C++ const reference? */
};

EXTERN_C
void __ubsan_handle_function_type_mismatch(void* data_raw,
                                           void* value_raw)
{
	struct ubsan_function_type_mismatch_data* data = (struct ubsan_function_type_mismatch_data*) data_raw;
	ubsan_value_handle_t value = (ubsan_value_handle_t) value_raw;
	(void) value;
	usban_abort(&data->location, "function type mismatch");
}
