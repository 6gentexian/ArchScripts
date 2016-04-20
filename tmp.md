1413143198

To circumvent a conflicting files issue, manual intervention is required
**only if package `java-common` is installed**. This can be checked with the
following command:

    
    
    $ pacman -Q java-common 
    java-common ... 
    

If so, please run the following **prior** to upgrading:

    
    
    # archlinux-java unset 
    # pacman -Sydd --asdeps java-runtime-common 
    :: java-runtime-common and java-common are in conflict. Remove java-common? [y/N] y 
    # archlinux-java fix 
    

You can then go ahead and upgrade:

    
    
    # pacman -Su 
    

Please note that new package [`java-runtime-
common`](https://www.archlinux.org/packages/extra/any/java-common/) does
**not** use nor support forcing `JAVA_HOME` as former package `java-common`
did. See the [Java wiki page](https://wiki.archlinux.org/index.php/Java) for
more info.

1414013350

Microcode on Intel CPUs is no longer loaded automatically, as it needs to be
loaded very early in the boot process. This requires adjustments in the
bootloader. If you have an Intel CPU, please follow [the instructions in the w
iki](https://wiki.archlinux.org/index.php/Microcode#Enabling_Intel_Microcode_U
pdates).

1418004794

The upgrade to gnupg-2.1 ported the pacman keyring to a new upstream format
but in the process rendered the local master key unable to sign other keys.
This is only an issue if you ever intend to customize your pacman keyring. We
nevertheless recommend all users fix this by generating a fresh keyring.

In addition, we recommend installing haveged, a daemon that generates system
entropy; this speeds up critical operations in cryptographic programs such as
gnupg (including the generation of new keyrings).

To do all the above, run as root:

    
    
    pacman -Syu haveged 
    systemctl start haveged 
    systemctl enable haveged 
     
    rm -fr /etc/pacman.d/gnupg 
    pacman-key --init 
    pacman-key --populate archlinux 
    

1418299508

The way local CA certificates are handled has changed. If you have added any
locally trusted certificates:

  1. Move /usr/local/share/ca-certificates/*.crt to /etc/ca-certificates/trust-source/anchors/
  2. Do the same with all manually-added /etc/ssl/certs/*.pem files and rename them to *.crt
  3. Instead of `update-ca-certificates`, run `trust extract-compat`

Also see `man 8 update-ca-trust` and `trust --help`.

1421775410

For consistency with upstream naming, the lirc-utils package was renamed to
lirc. The wpc8769l kernel drivers were dropped and can be obtained by
installing [lirc-wpc8769l from the
AUR](https://aur.archlinux.org/packages/lirc-wpc8769l/).

Note that 0.9.2 is a major release and comes along with several upstream and
packaging changes. In particular, the `irexec.service` systemd unit was
removed. Please edit and copy the template
`/usr/share/lirc/contrib/irexec.service` if you want to keep using that
service.

1422267613

The KDE Software Collection has been updated to KDE Applications 14.12.

The KDE developers have started porting their software to KDE Frameworks and
Qt 5. For a list of the software that has been ported see [the
announcement](https://www.kde.org/announcements/announce-
applications-14.12.0.php).

When a KDE Frameworks port of a KDE application is considered stable, it is
released with KDE Applications and development and bug fixes are no longer
applied to the Qt4/KDE4 version. This means that as ported versions of
applications are released, we will switch to the newer version. At the same
time, we are getting rid of KDE module prefixes (e.g. _kdebase-konsole -&gt;
konsole_).

The result of this transition is that some packages will be using Qt5 and some
will be using Qt4. We are working hard to make the transition smooth for KDE4
users, but things might look different depending on your configuration. Please
adjust themes and colors as necessary for the two toolkits. See [the
wiki](https://wiki.archlinux.org/index.php/KDE#Personalization) for help. We
also recommend switching to Plasma 5.2 which will be released this week.

Please report upstream bugs to the KDE bugzilla. Feel free to CC me.

1424005606

The new version comes with the following changes:

  * following ustream, xf86-video-modesetting is now provided with xorg-server package.

  * These packages are deprecated and moved to AUR, some are replaced by modesetting driver: xf86-video-ast, xf86-video-cirrus, xf86-video-geode, xf86-video-mga, xf86-video-sisimedia, xf86-video-v4l

1431761988

Some modules have been split from the `pulseaudio` package to avoid having
modules with missing dynamic libraries. Please check which modules you need
and reinstall them.

The split out modules are:

  * `pulseaudio-bluetooth`: Bluetooth (Bluez) support
  * `pulseaudio-equalizer`: Equalizer sink (qpaeq)
  * `pulseaudio-gconf`: GConf support (paprefs)
  * `pulseaudio-jack`: JACK sink, source and jackdbus detection
  * `pulseaudio-lirc`: Infrared (LIRC) volume control
  * `pulseaudio-xen`: Xen paravirtual sink
  * `pulseaudio-zeroconf`: Zeroconf (Avahi/DNS-SD) support
1431880040

Puppet 4 has been released and breaks compatibility with version 3. Therefore
users will need to upgrade a server to Puppet 4 before updating their clients.
Note that if only a Puppet 4 server is available, Puppet 3 clients will not
work. Also a number of locations for things have changed including the config,
manifest and module files. You will need to follow upgrade instructions for
your servers and clients:

  * <https://docs.puppetlabs.com/puppet/4.0/reference/upgrade_server.html>
  * <https://docs.puppetlabs.com/puppet/4.0/reference/upgrade_agent.html>
1432326745

Recent Linux kernels (4.0.2+, LTS 3.14.41+), pushed to the [core] repository
in the past couple of weeks, suffered from a bug that can cause data
corruption on file systems mounted with the `discard` option and residing on
software RAID 0 arrays. Even if `discard` is not specified, the `fstrim`
command can also trigger this bug. (**If you do not use software RAID 0 or the
`discard` option, then this issue does not affect you.**)

The issue has been addressed in the `linux 4.0.4-2` and `linux-lts 3.14.43-2`
updates. Due to the nature of the bug, however, it is likely that data
corruption has already occurred on systems running the aforementioned kernels.
It is strongly advised to verify the integrity of affected file systems using
`fsck` and/or restore their data from known good backups.

For further information please read the [LKML
post](https://lkml.org/lkml/2015/5/21/167) by Holger Kiehl, the [related artic
le](http://www.phoronix.com/scan.php?page=news_item&amp;px=Linux-4-EXT4-RAID-
Issue-Found) on Phoronix, as well as the [proposed fix](http://git.neil.brown.
name/?p=md.git;a=commitdiff;h=a81157768a00e8cf8a7b43b5ea5cac931262374f) that
was backported to the Arch kernels.

1439529002

In light of recently discovered vulnerabilities, the new `openssh-7.0p1`
release deprecates keys of `ssh-dss` type, also known as DSA keys. See the
[upstream announcement](http://lists.mindrot.org/pipermail/openssh-unix-
announce/2015-August/000122.html) for details.

Before updating and restarting `sshd` on a remote host, make sure you do not
rely on such keys for connecting to it. To enumerate DSA keys granting access
to a given account, use:

    
    
     grep ssh-dss ~/.ssh/authorized_keys 
    

If you have any, ensure you have alternative means of logging in, such as key
pairs of a different type, or password authentication.

Finally, host keys of `ssh-dss` type being deprecated too, you might have to
confirm a new fingerprint (for a host key of a different type) when connecting
to a freshly updated server.

1442781067

The packages `systemd` 226-1 plus `dbus` 1.10.0-3 now launch _dbus-daemon_
once per user; all sessions of a user will share the same D-Bus "session" bus.
The _pam_systemd_ module ensures that the right `DBUS_SESSION_BUS_ADDRESS` is
set at login.

This also permits dbus-daemon to defer to systemd for activation instead of
spawning server processes itself. However, currently this is not commonly used
for session services (as opposed to system services).

_kdbus_ will only support this model, so this is also an opportunity to iron
out some bugs and make a future transition to kernel buses easier. Please let
us know of any issues.

1444291848

Update: All fixed now.

I just installed a kernel update on our rsync and mail server and it seems we
have broken hardware so it is unable to reboot right now. Mailing lists are
running on a different system however you need to use the
`lists.archlinux.org` domain rather than `archlinux.org`. So for arch-general
you'd use `arch-general@lists.archlinux.org`. Mails sent to the normal domain
will go through once the server is up again.

The rsync master will stay unavailable for now.

I've asked the hoster to look into the issue, but I can't currently estimate
when I'll get a reply/fix.

Sorry for the inconvenience, Florian

1447418572

Xorg 1.18.0 is entering [testing] with the following changes:

  * You can now choose between `xf86-input-evdev` and `xf86-input-libinput`.

  * `xf86-input-aiptek` will not be updated and will be removed when xorg-1.18.0 is moved to [extra]

Update: Nvidia drivers are now compatible with xorg-1.18.0 (ABI 20)

1449730114

GCC 5.x contains libstdc++ with [dual
ABI](https://gcc.gnu.org/onlinedocs/libstdc++/manual/using_dual_abi.html)
support and we have now switched to the new ABI.

While the old C++ ABI is still available, it is recommended that you build all
non-repo packages to have the new ABI. This is particularly important if they
link to another library built against the new ABI. You can get a list of
packages to rebuild using the following shell script:

    
    
    #!/bin/bash 
     
    while read pkg; do 
     mapfile -t files &lt; &lt;(pacman -Qlq $pkg | grep -v /$) 
     grep -Fq libstdc++.so.6 "${files[@]}" &lt;&amp;- 2&gt;/dev/null &amp;&amp; echo $pkg 
    done &lt; &lt;(pacman -Qmq) 
    

(Original announcement text by Allan McRae
[[link](https://lists.archlinux.org/pipermail/arch-dev-
public/2015-December/027597.html)])

1449914655

Since the KDE 4 desktop has been unmaintained for several months and it's
becoming increasingly difficult to support two versions of Plasma, we are
removing it from our repositories. Plasma 5.5 has just been released and
should be stable enough to replace it.

KDE 4 installations will not be automatically upgraded to Plasma 5. However,
we recommend all users to upgrade or switch to a maintained alternative as
soon as possible, since any future update may break the KDE 4 desktop without
prior notice. See [the
wiki](https://wiki.archlinux.org/index.php/KDE#Upgrading_from_Plasma_4_to_5)
for instructions on how to upgrade to Plasma 5.

1451747621

Packages of the new major version of PHP have been released into the stable
repositories. Besides the new [PHP 7
features](http://php.net/archive/2015.php#id2015-12-03-1) there are the
following packaging changes. In general the package configuration is now
closer to what was intended by the PHP project. Also refer to the **[PHP 7
migration guide](http://php.net/manual/en/migration70.php)** for upstream
improvements.

#### Removed packages

  * **php-pear**
  * **php-mssql**
  * **php-ldap** The module is now included in the [php](https://www.archlinux.org/packages/extra/x86_64/php/) package
  * **php-mongo** The new **[php-mongodb](https://www.archlinux.org/packages/community/x86_64/php-mongodb/)** might provide an alternative even though it is not a compatible drop-in replacement
  * **php-xcache** Consider using the included [OPcache](http://php.net/opcache) and optionally [APCu](https://www.archlinux.org/packages/extra/x86_64/php-apcu/) for user data cache
  * **[graphviz](https://www.archlinux.org/packages/extra/x86_64/graphviz/)** The PHP bindings had to be removed

#### New packages

  * **[php-apcu-bc](https://www.archlinux.org/packages/extra/x86_64/php-apcu-bc/)** Install and enable this module if the **apc_*** functions are needed
  * **[php-mongodb](https://www.archlinux.org/packages/community/x86_64/php-mongodb/)**

#### Configuration changes

  * **open_basedir** is no longer set by default
  * **openssl**, **phar** and **posix** extensions are now built in
  * [php-fpm](https://www.archlinux.org/packages/extra/x86_64/php-fpm/) does no longer provide a **logrotate** configuration. Instead syslog/journald is used by default
  * [php-fpm](https://www.archlinux.org/packages/extra/x86_64/php-fpm/)'s service file does no longer set **PrivateTmp=true**
  * The configuration and module of [php-apache](https://www.archlinux.org/packages/extra/x86_64/php-apache/) have been renamed to **php7_module.conf** and **libphp7.so**

