#define FOO BAR
#define BIZ BAZ

#define STR_(x) #x
#define STR(x) STR_(x)

#if STR(BIZ) != STR(FOO)
# warning "BIZ != FOO"
#else
# warning "BIZ == FOO"
#endif
