#ifndef PENNY_DBUS_H_
#define PENNY_DBUS_H_

/* Version 0.23 (2014-01-06 */

enum dbus_type_codes {
	/* basic types */
	DBUS_BYTE = 'y',
	DBUS_BOOLEAN = 'b',
	DBUS_INT16 = 'n',
	DBUS_UINT16 = 'q',
	DBUS_INT32 = 'i',
	DBUS_UINT32 = 'u',
	DBUS_INT64 = 'x',
	DBUS_UINT64 = 't',
	DBUS_DOUBLE = 'd',
	DBUS_UNIX_FD = 'h', /* uint32_t */

	/* string-like types
	 *  - 0 or more Unicode codepoints encoded in UTF-8, none of which may
	 *    be U+0000
	 *  - must validate strictly, overlong sequences or codepoints above
	 *    U+10FFFF are prohibited.
	 *  - marshalled with a '\0' byte, but this byte is not considered part
	 *    of the text.
	 */
	DBUS_STRING = 's',
	DBUS_OBJECT_PATH = 'o',
	DBUS_SIGNATURE = 'g',


	/* container types */
	DBUS_STRUCT_BEGIN = '(',
	DBUS_STRUCT_END = ')',
	DBUS_ARRAY = 'a',
	DBUS_VARIANT = 'v',
	DBUS_DICT_ENTRY_BEGIN = '{',
	DBUS_DICT_ENTRY_END = '}',
};

#endif
