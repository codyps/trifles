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

Some times obtained for various schedulings are shown below.
(Note that these all contain the 1 second addition mentioned above).

Dynamic Scheduling
~~~~~~~~~~~~~~~~~~

~~~~
1.106686
1.114315
1.117982
1.120328
1.113071
1.120215
1.116418
~~~~

Average = 1.1155735714

Guided Scheduling
~~~~~~~~~~~~~~~~~

~~~~
1.151770
1.141926
1.139374
1.172475
1.134437
1.095787
1.141593
~~~~

Average = 1.1396231428

Static Scheduling
~~~~~~~~~~~~~~~~~

~~~~
1.163276
1.160127
1.144849
1.126164
1.161700
1.166065
1.167602
~~~~

Average = 1.1556832857


MPI with static scheduling
--------------------------
Slave threads preform a small computation to determine the X indexes they are
responsible for. Following the completion of a column, the slave sends it to 
the Master thread. Master waits for incomming columns and waits for X11 input
once all have rendered.


MPI with dynamic scheduling
---------------------------
Master handles X11 communication of slave coordination.
Slave threads are given a column (and X value) to compute all the data along,
and then send this back to the master for another column to process.


MPI + openmp
------------
Either the static or dynamic mpi code could have been altered to support mpi
(with the addition of just 2 paragmas), but given the success of the dynamic
allocation code, the dynamic mpi was chosen to fullfil this role

Parallelization over X (columns) is done via MPI and parallelization over Y
(rows) is done via openmp.

