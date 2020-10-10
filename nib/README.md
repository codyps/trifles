# nib

Nibble (nyble, nybble, half-byte, semi-octet, quadbit, quartet, hex digit)
slices and references

## Survey of existing packages

 - [nibble](https://crates.io/crates/nibble)
   - latest release: 0.1.0, 2017-10-30 (as of 2020-10-09) (also the only release)
   - license: CC0-1.0
   - doesn't build on stable (https://github.com/clarfonthey/nibble/issues/2) as of 2018-02-09
   - fairly complicated implimentation
   - supports slices, "arrays", vectors, nibble pairs (extensive)
   - provides formatting, num-traits (math on nibbles)
   - provides distinct types to cover cases where the nibbles are start and/or end aligned
 - [nibbler](https://crates.io/crates/nibbler)
   - latest release: 0.2.3, 2020-08-16 (as of 2020-10-09)
   - license: GPL-3.0-or-later
   - does funny things with 4 bools to represent a nibble
   - generates strings and uses them in switch statements
   - lacks a slice type that can work on real memory
   - it's vec-like (Nibbles) is always used
   - never packs nibbles
 - [nibble_vec](https://crates.io/crates/nibble_vec)
   - latest release: 0.1.0, 2020-06-27 (as of 2020-10-09)
   - license:
   - provides only a vector (uses `smallvec` as it's backing store)
   - operations like split cause allocation of a new vector
   - no support for real-memory nibbles (ie: without copying)
   - only limited indexing (via get and split), no range support
 
## License

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later
version.

In addition to the permissions in the GNU General Public License, the authors
give you unlimited permission to link the compiled version of this library into
combinations with other programs, and to distribute those programs without any
restriction coming from the use of this library. (The General Public License
restrictions do apply in other respects; for example, they cover modification
of the library, and distribution when not linked into another program.)

This library is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more
details.
