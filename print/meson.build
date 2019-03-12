project('accum', 'c',
  default_options: [
    'optimization=g',
    'werror=true',
  ]
)

common_flags = [
  '-Wall', '-Wextra',
  '-Wold-style-definition', '-Wundef', '-Wmissing-prototypes', '-Wstrict-prototypes',
  '-D_GNU_SOURCE=1',
]

add_project_arguments(
  common_flags,
  language: 'c'
)

test_print = executable('test_print',
  'test-print.c'
)
test('print', test_print)
