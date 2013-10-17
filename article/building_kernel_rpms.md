
So you want to build rpms for the newest kernel with your custom patches on top?

fedora keeps a git repo which builds the latest testing release (-rcX)

    git clone git://pkgs.fedoraproject.org/kernel fedora-pkg-kernel

Now we need to modify it to build with your patches. Edit 'kernel.spec' and
look for the 'Patch....:' lines. Add a new one (numbered after all of the
existing ones so it will be applied last) with the name of your patch file

   ...
   # my patch
   Patch26000: my_patch_name_v1.patch
   ...

Also, copy your patch into fedora-pkg-kernel. If your patch is actually a series of git patches, generate it.

   cd kernel-src-git
   git diff FIRST_SHA1^..LAST_SHA1 > ../fedora-pkg-kernel/my_patch_name_v1.patch

== package build systems are inflexible ==

Now we need to build a src rpm. For this we need the fedora packaging tool
'fedpkg'. The easiest way to get it is to have an existing fedora system and
run everything on that. If you do not want to devote a system to fedora, it is
also possible to build a chroot that contains fedora.

I`ve create a chroot on Ubuntu 12.04 using (a variation on) these instructions (with lots of work arounds):

http://blog.parahard.com/2011/06/five-steps-to-create-fedora-chroot-jail.html

TODO: reproduce the actual instructions with tweaks I used

The 'schroot' tool can be used to manage the chroot, automatically mount needed
file systems, and allow non-root users to access it.

== Now that we have 'fedpkg'... ==

On the system with 'fedpkg', do

    cd fedora-pkg-kernel
    fedpkg srpm

Then install that source rpm

   rpm -i *.src.rpm

Then build that source rpm

   rpmbuild -ba ~/rpmbuild/SPECS/kernel.spec

The built rpms end up in ~/rpmbuild/RPMS

== All that works great if your destination system is fedora... =

What if I want to install the RPM on RHEL6?

Pain, lots of pain.
TODO: figure it out.
