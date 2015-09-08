/* both clang & gcc (if new enough) define this when gnu89-inlines are enabled,
 * so use it immediately if possible*/
#ifdef __GNUC_GNU_INLINE__
# define HAVE_GNU_INLINE 1
# define HAVE_STD_INLINE 0
#elif defined(__GNUC_STD_INLINE__)
# define HAVE_STD_INLINE 1
# define HAVE_GNU_INLINE 0
#else
/* If we don't have a direct indication, we'll need to guess based on some standard defines */
# ifndef __STDC_VERSION__
  /*
   * we're a pre-c99 version of c, our only options (as far as we know) are
   * gnu89-inline or no inlines at all.
   */
#  if defined(__GNUC__) && (__GNUC__ > 2) || (__GNUC__ == 2 && __GNUC_MINOR__ > 6)
    /*
     * We should only hit this case with an old gcc version (pre-4.3.0 or 4.1.3)
     *
     * The GNUC version mess is an attempt at handling the approximate version
     * of gcc that introduced 'extern inline' (gnu89-inline style) support.
     * It's possible it's slightly incorrect, but in all likelyhood doesn't
     * even matter. gcc-2.7.0 was released June 16, 1995. I'm comfortable with
     * these excluding more versions of gcc than we have to as hardely anyone
     * will be using those versions.
     *
     * The version was found by grepping for 'extern inline' in gcc git logs
     * and using the first occurance (which was in some changes after the gcc-2.6.0
     * release). It is possible that support was introduced earlier.
     */
#   define HAVE_GNU_INLINE 1
#   define HAVE_STD_INLINE 0
#  else
   /* 
    * we aren't GNUC (or we're an ancient version), and we aren't at least c99,
    * and we don't have a magic define telling us we have gnu89-inline, no
    * inlines for anyone
    */
#   define HAVE_GNU_INLINE 0
#   define HAVE_STD_INLINE 0
#  endif
# else /* if defined(__STDC_VERSION__) */
 /* I'd like to just say "yay, we have c99, everything works".
  * Unfortunately, tcc exists, which just ignores the 'inline' keyword,
  * leading to multiple definition errors if we try to use 'extern inline'.
  */
#  ifdef __TINYC__
#   define HAVE_STD_INLINE 0
#   define HAVE_GNU_INLINE 0
#  else
  /*
   * With __STDC_VERSION__ defined we know we're c99 or later, so we must have standard inline.
   * This is the path taken by conforming compilers without magic defines.
   */
#   define HAVE_STD_INLINE 1
#   define HAVE_GNU_INLINE 0
#  endif /* defined(__TINYC__) */
# endif
#endif

#if HAVE_GNU_INLINE
have_gnu_inline
#endif

#if HAVE_STD_INLINE
have_std_inline
#endif
