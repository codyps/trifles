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

executable('accum',
  'main.c'
)
