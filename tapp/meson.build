project('tapp', 'cpp',
  default_optons: [
    'werror=true',
    'b_sanitize=address,undefined',
    'optimization=g'
  ]
)

add_global_arguments(
  '-Wall', '-Wextra',
  '-ggdb3',
  language: 'cpp'
)

boost_dep = dependency('boost')
# NOTE: without thread_dep, boost attempts to use some pthreads
# functions and causes a link error.
thread_dep  = dependency('threads')

executable('tapp', 'tapp.cc',
  #cpp_pch: 'pch/tapp_pch.hh',
  dependencies: [
    boost_dep, thread_dep,
  ]
)
