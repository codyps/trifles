#include <gcc-plugin.h>

#if 0
static struct plugin_info explicit_init_info = {
	.version = "0",
	.help = "detect implicit initializations",
};

static struct plugin_gcc_version explicit_init_ver = {
	.basever = "8",
};

static struct gimple_opt_pass explicit_init_pass = {
	.pass.type = GIMPLE_PASS,
	.pass.name = "explicit-init",

	.pass.gate = explicit_init_gate,
	.pass.execute = explicit_init_exec,
};

static
const_tree
is_str_cst(const_tree node)
{
	const_tree str = node;
	if (TREE_CODE(str) == VAR_DECL) {
		
	}
}


static
unsigned
explicit_init_exec(void)
{
	unsigned i;
	const_tree str, op;
	basic_block bb;
	gimple stmt;
	gimple_stmt_iterator gsi;

	FOR_EACH_BB(bb)
		for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi)) {
			stmt = gsi_stmt(gsi);
			for (i = 0; i < gimple_num_opts(stmt); ++i)
				if ((op = gimple_op(stmt, i)) && (str = is_str_cst(op)))
					spell_check(stmt, str);
		}

	return 0;
}
#endif

int
plugin_init(struct plugin_name_args *plugin_info,
		struct plugin_gcc_version *version)
{
	//struct register_pass_info pass;


	fprintf(stderr, "plugin_info: %s %s %d\n",
			plugin_info->base_name,
			plugin_info->full_name,
			plugin_info->argc);

	for (int i = 0; i < plugin_info->argc; i++) {
		fprintf(stderr, "arg: %s=%s\n",
				plugin_info->argv[i].key,
				plugin_info->argv[i].value);
	}

	if (plugin_info->version)
		fprintf(stderr, "version: %s\n", plugin_info->version);

	if (plugin_info->help)
		fprintf(stderr, "help: %s\n", plugin_info->help);



#if 0
	if (plugin_default_version_check(version, explicit_init_ver))
		return -1;

	register_callback("explicit-init", PLUGIN_INFO, NULL, &explicit_init_info);

	pass.pass = &explicit_init_pass.pass;

	pass.register_pass_name = "cfg";
	pass.ref_pass_instance_number = 1;
	pass.pos_op = PASS_POS_INSERT_AFTER;

	register_callback("explicit-init", PLUGIN_PASS_MANAGER_SETUP, NULL, &pass);

	register_callback(plugin_info->base_name, PLUGIN_FINISH, finish_gcc, NULL);
#endif

	return 0;
}

int
plugin_is_GPL_compatible;
