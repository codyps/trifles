Programming Assignment: OPENMP and MPI
======================================

Notes on timing
---------------
In order to have the X11 window display the rendering properly, a delay of 1
second was added following the first XFlush (which follows the creation of the
window by preceeds the actual value calculations). For this reason, the
seconds count is inflated by 1 in the printouts.

openmp implimentation
---------------------
Contained within mandelbrot_omp.c, built to `brot_omp`.
Parallelized over the columns.


