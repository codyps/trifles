
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/debugfs.h>
#include <linux/printk.h>
#include <linux/module.h> /* MODULE_* */
#include <linux/init.h> /* module_{init,exit} */

static struct dentry *root_dentry;
static u8 test;

static int debugfs_u8_set(void *data, u64 val)
{
	*(u8 *)data = val;
	return 0;
}
static int debugfs_u8_get(void *data, u64 *val)
{
	*val = *(u8 *)data;
	return 0;
}

#define DEFINE_WATCHED_U8(___var)				\
	static int ___var ## _watch_set(void *data, u64 val)	\
	{							\
		debugfs_u8_set(data, val);			\
		return ___var ## _watch(data);			\
	}							\
	DEFINE_SIMPLE_ATTRIBUTE(___var ## _fops, debugfs_u8_get, ___var ## _watch_set, "%llu");


static int test_watch(void *data)
{
	u8 val = *(u8*)data;
	pr_devel("test changed to %d.", val);
	return 0;
}
DEFINE_WATCHED_U8(test);

static int __init mod_init(void)
{
	if (!debugfs_initialized()) {
		pr_devel("debugfs not registered or disabled.");
		return 0;
	}

	root_dentry = debugfs_create_dir("debugfs-test", NULL);
	if (!root_dentry) {
		pr_devel("failed to create dir");
		return 0;
	}

	{
		struct dentry *d = debugfs_create_file("test-bool", 0777, root_dentry, &test, &test_fops);
		if (!d) {
			pr_devel("failed to create test-bool");
			return 0;
		}
	}

	return 0;
}

static void __exit mod_exit(void)
{
	debugfs_remove_recursive(root_dentry);
}

module_init(mod_init);
module_exit(mod_exit);

MODULE_AUTHOR("Cody P Schafer <cody@linux.vnet.ibm.com>");
MODULE_DESCRIPTION("Debugfs testing.");
MODULE_LICENSE("GPL");
