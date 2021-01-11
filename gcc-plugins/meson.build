project('gcc-plugin-test', ['cpp', 'c'],
  meson_version: '>= 0.55',
  default_options: [
    'optimization=g',
    'werror=true',
  ]
)

cc = meson.get_compiler('c')
plugin_dev_path_result = run_command(cc.cmd_array(), '-print-file-name=plugin')
plugin_dev_path = plugin_dev_path_result.stdout().strip()
plugin_inc = include_directories([join_paths(plugin_dev_path, 'include')], is_system: true)

# required for gcc10 plugin headers
gmp = dependency('gmp')

gcc_plugin = declare_dependency(
  include_directories: plugin_inc,
  dependencies: [gmp]
  )

explicit_init = shared_module('explicit_init',
	'explicit-init.cc',
	dependencies: [gcc_plugin]
)

explicit_init_fdep = custom_target('explicit_init',
	input: explicit_init,
	output: 'explicit_init_fdep.h',
	command: ['echo'],
	capture: true
)

test_1 = executable('test-1', 'test-1.c', explicit_init_fdep,
	c_args: [ '-fplugin=' + explicit_init.full_path() ],
	native: true,
)
test('test_1', test_1)
