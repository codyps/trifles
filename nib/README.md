


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
 

