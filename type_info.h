#ifndef PENNY_TYPE_INFO_H_
#define PENNY_TYPE_INFO_H_


#define umaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
		                    (0xFULL << ((sizeof(t) * 8ULL) - 4ULL)))

#define smaxof(t) (((0x1ULL << ((sizeof(t) * 8ULL) - 1ULL)) - 1ULL) | \
		                    (0x7ULL << ((sizeof(t) * 8ULL) - 4ULL)))

#endif
