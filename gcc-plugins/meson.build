project('gcc-plugin-test', 'c',
  default_options: [
    'optimization=g',
    'werror=true',
  ]
)

cc = meson.get_compiler('c')
plugin_dev_path = run_command(cc, '-print-file-name=plugin').stdout().strip()
plugin_inc = include_directories(plugin_dev_path / 'include')


