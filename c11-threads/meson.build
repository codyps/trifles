project('c11-thread-on-pthreads', 'c',
  default_options: [
    'c_std=gnu11',
    'werror=true',
    'b_sanitize=thread',
    'optimization=g',
  ]
)

add_project_arguments(
  '-Wall', '-Wextra',
  '-Wold-style-definition', '-Wundef', '-Wmissing-prototypes', '-Wstrict-prototypes',
  '-D_GNU_SOURCE=1',
  language: 'c'
)

add_global_arguments(
  '-ggdb3', '-fvar-tracking-assignments',
  '-fstack-usage',
  language: 'c',
)

ccan_inc = include_directories(['ccan'])
ccan_sta = static_library('ccan',
  'ccan'/'ccan'/'tap'/'tap.c',
  include_directories: ccan_inc,
)
ccan = declare_dependency(
  link_with: ccan_sta,
  include_directories: ccan_inc
)

libc11thr = library('c11_thread_on_pthreads',
  'threads.c',
)

thread_dep = dependency('threads')

t1_c11_via_pthreads = executable('t1_c11_via_pthreads', 'test.c',
  dependencies: [ccan],
  link_with: [libc11thr],
)
test('t1-c11-via-pthreads', t1_c11_via_pthreads)

t1_c11_direct = executable('t1_c11_direct', 'test.c',
  dependencies: [ccan, thread_dep],
)
test('t1-c11-direct', t1_c11_direct)
