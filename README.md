# Orc is a simple post-exploitation written in bash.

Authors: Darren Martyn, March, Ulrich Berntien

## The Project

IRC Channel: #orc on irc.hackint.eu

I initially wrote this because I myself needed a more featureful post-exploitation toolkit for Linux. It's part of a larger bundle of scripts and tools, but I'll add those as I write and re-write them.

## Script Start

It takes the form of an ENV script, so load orc into a shell by running ENV=o.rc sh -i (it does need an interactive shell, I'm afraid)
You can also source it.

It creates a directory (.q) typical in /dev/shm, and all output of commands etc tend to go in there.
It will also auto-delete this directory on exit.
If /dev/shm does not exist or is mounted with noexec option, then the script can choose another directory.
The used directory is stored in the HOME variable. The user account home directory is stored in the NHOME variable.

HISTFILE is unset, and we use ulimit -c 0 to try and prevent any corefiles showing up.

## Functions

It also contains a relatively decent selection of useful functions: some are currently not super featureful, and there's likely to be a large number of bugs, but you can find the vast majority of them by running the command 'gethelp'.
HOWEVER. An overview:

- getenum takes the versions from the kernel, glibc, and dbus. For privilege escalation exploits, they're usually the ones you want. It also prints the init system, because it's good to know that. ([Wiki](https://github.com/zMarch/Orc/wiki/getenum))

- getexploit pulls down the linux exploit suggester ([Wiki](https://github.com/zMarch/Orc/wiki/getexploit))

- getinfo pulls basically everything useful and generic i could think of and sticks it in a tar.xz file for you. ([Wiki](https://github.com/zMarch/Orc/wiki/getinfo))

- getrel prints the OS name from the release file. ([Wiki](https://github.com/zMarch/Orc/wiki/getrel))

- getip uses HTTP and DNS to get your external IP. It aims to use curl and dig, but will fall back to wget and host if it needs to. It grabs these from Akami and Google respectively to try and avoid using smaller sites that might flag in a SOC's logs or alerts. ([Wiki](https://github.com/zMarch/Orc/wiki/getip))

- getjail does a check to see if we're in a chroot, and then does some very basic checks for hypervisors/virtualisation. If there are any better checks, let me know. ([Wiki](https://github.com/zMarch/Orc/wiki/getjail))

- getsuspect pulls down my suspect script and runs it, looking for malware or signs of compromise. ([Wiki](https://github.com/zMarch/Orc/wiki/getsuspect))

- getsec checks for the presence of SELinux, AppArmor, and GrSec. I thought about adding stuff for rkhunter/chkrootkit, but in my experience they're not much of a threat unless you're using rootkits from 2003. ([Wiki](https://github.com/zMarch/Orc/wiki/getsec))

- getusers gets all users with a shell. ([Wiki](https://github.com/zMarch/Orc/wiki/getusers))

- getspec prints some basic hardware information. ([Wiki](https://github.com/zMarch/Orc/wiki/getspec))

- gettmp lists typical directories for tmp files. ([Wiki](https://github.com/zMarch/Orc/wiki/gettmp))

- getpty pops a pty using script. This pty should have Orc already loaded. ([Wiki](https://github.com/zMarch/Orc/wiki/getpty))

- getidle gives you an accurate idle time for ptys, letting you see how recently other users have been active. ([Wiki](https://github.com/zMarch/Orc/wiki/getidle))

- getnet is a monstrous attempt to auto-enumerate living hosts on the network. It's probably broken, probably lacks anything good or right, and does use ping, so yeah. ([Wiki](https://github.com/zMarch/Orc/wiki/getnet))

- getuservices gets all processes running by users who don't have a shell. Useful. ([Wiki](https://github.com/zMarch/Orc/wiki/getuservices))

- portscan should be fairly self-evident. It checks for the following open ports on one host: 21, 22, 23, 80, 443, 8080, 8443, 129, 445, 3389, 3306. ([Wiki](https://github.com/zMarch/Orc/wiki/portscan))

- prochide grabs the longest process name from ps (because we can't hide arguments, but we can choose something that makes them relatively invisible in the noise) and uses that as the $0 of whatever you execute. ([Wiki](https://github.com/zMarch/Orc/wiki/prochide))

- srm is just a wrapper around shred, basically. ([Wiki](https://github.com/zMarch/Orc/wiki/srm))

- qsu uses an ASKPASS script to launch sudo without requiring a tty. Apply arguments as usual to sudo. ([Wiki](https://github.com/zMarch/Orc/wiki/qsu))

- qssh uses an ASKPASS script to launch ssh without requiring a tty. Apply arguments as usual. ([Wiki](https://github.com/zMarch/Orc/wiki/qssh))

- wiper uses utmpdump to dump wtmp into plaintext and then greps out the string given as an argument. It then repacks the modified file into /var/log/wtmp, and ensures that the file is nicely timestomped. ([Wiki](https://github.com/zMarch/Orc/wiki/wiper))

- fpssh is just a wrapper around ssh-keyscan. ([Wiki](https://github.com/zMarch/Orc/wiki/fpssh))

- stomp is just an alias for "touch -r". ([Wiki](https://github.com/zMarch/Orc/wiki/stomp))

- tools checks for common tools. ([Wiki](https://github.com/zMarch/Orc/wiki/tools))

- dropsuid basically drops a tiny SUID shell written in ASM wherever. You'll need to chmod a+sx it. ([Wiki](https://github.com/zMarch/Orc/wiki/dropsuid))

- memexec uses some janky perl (see https://magisterquis.github.io/2018/03/31/in-memory-only-elf-execution.html who I stole much of the basis of it for) to execute a binary in-memory. No arguments or anything yet, and only x64 supported. ([Wiki](https://github.com/zMarch/Orc/wiki/memexec))

- getdbus lists all dbus services for delicious priv-esc. ([Wiki](https://github.com/zMarch/Orc/wiki/getdbus))

- getescape attempts to find a way to escape a chroot by traversing a poorly configured /proc/. ([Wiki](https://github.com/zMarch/Orc/wiki/getescape))

## Compatibility Status

Current the compatibility of Orc to bash, POXIS shell (e.g. dash) and other shells is a work item.

The [ShellCheck](https://www.shellcheck.net/) in the [Travis CI](https://travis-ci.org/) gives hints to optimize the compatibility. Current the checks failed but despite that O.rc is runable on most POSIX conform shells.

[![Build Status](https://api.travis-ci.org/zMarch/Orc.svg?branch=master)](https://travis-ci.org/zMarch/Orc)
