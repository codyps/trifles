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

explict_init = shared_library('explicit_init',
	'explicit-init.cc',
	include_directories: plugin_inc
)
