
/*
 * - on breakpoint, watchpoint, or debug request, we get an "abort exception"
 *   if in monitor mode.
 *
 * - "BREAKPT" signal
 *
 * - "Debug Communications Channel" : DDC
 *
 * - It appears that the arm7tdmi reqires external hardware for debugging to
 *   be functional.
 * - ARM7TDMI TRM is lacking in info, perhaps a more generic manual has more?
 * 
 * - ARM trm says ARMv6 was the first to introduce standardized debug hw,
 *   ARM7TDMI is ARMv4
 */

