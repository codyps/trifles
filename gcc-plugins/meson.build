project('gcc-plugin-test', ['cpp', 'c'],
  default_options: [
    'optimization=g',
    'werror=true',
  ]
)

cc = meson.get_compiler('c')
plugin_dev_path_result = run_command(cc.cmd_array(), '-print-file-name=plugin')
plugin_dev_path = plugin_dev_path_result.stdout().strip()
plugin_inc = include_directories([join_paths(plugin_dev_path, 'include')])

explicit_init = shared_module('explicit_init',
	'explicit-init.cc',
	include_directories: plugin_inc
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
