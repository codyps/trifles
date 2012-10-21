
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

#include <linux/debugfs.h>
#include <linux/printk.h>
#include <linux/module.h> /* MODULE_* */
#include <linux/init.h> /* module_{init,exit} */
#include <linux/timer.h> /* DEFINE_TIMER, mod_timer */
#include <linux/fsnotify.h> /* fsnotify, FS_MODIFY, fsnotify_parent, FSNOTIFY_EVENT_INODE */

static struct dentry *root_dentry, *do_it_dentry, *delay_dentry;
static u8 do_it;
static u32 delay = 1000;

/*
 * fsnotify_modify_dentry - dentry/inode was modified.
 *
 * Should only be called due to changes originating in the kernel (such as in
 * one of it's virtual filesystems, ie: proc, sysfs, debugfs)
 */
static inline void fsnotify_modify_dentry(struct dentry *dentry)
{
	struct inode *inode = dentry->d_inode;
	__u32 mask = FS_MODIFY;

	if (S_ISDIR(inode->i_mode))
		mask |= FS_ISDIR;

	fsnotify_parent(NULL, dentry, mask);
	fsnotify(inode, mask, inode, FSNOTIFY_EVENT_INODE, NULL, 0);
}

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
		u8 old_val = *(u8 *)data;			\
		debugfs_u8_set(data, val);			\
		return ___var ## _watch(old_val, val);		\
	}							\
	DEFINE_SIMPLE_ATTRIBUTE(___var ## _fops, debugfs_u8_get, ___var ## _watch_set, "%llu");

void change_back(unsigned long arg)
{
	pr_devel("resetting 'do-it'");
	do_it = 0;
	fsnotify_modify_dentry(do_it_dentry);
}

#if 0
DEFINE_TIMER(change_back_tl, change_back, 0, 0);
#else
struct timer_list change_back_tl = TIMER_DEFERRED_INITIALIZER(change_back, 0, 0);
#endif

static int do_it_watch(u8 old_val, u8 new_val)
{
	pr_devel("do-it: %d => %d.", old_val, new_val);
	if (old_val == 0 && new_val == 1) {
		pr_devel("setting timer for %d ms.", delay);
		if (!timer_pending(&change_back_tl)) {
			mod_timer(&change_back_tl,  jiffies + msecs_to_jiffies(delay));
		} else {
			pr_devel("timer pending, should never happen.");
		}
		return 0;
	}
	return -EACCES;
}
DEFINE_WATCHED_U8(do_it);

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

	do_it_dentry = debugfs_create_file("do-it", 0700, root_dentry, &do_it, &do_it_fops);
	if (!do_it_dentry) {
		pr_devel("failed to create do-it");
		return 0;
	}

	delay_dentry = debugfs_create_u32("delay", 0700, root_dentry, &delay);
	if (!delay_dentry) {
		pr_devel("failed to create delay");
		return 0;
	}

	pr_devel("initialized: do-it: %d, delay: %d", do_it, delay);

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
