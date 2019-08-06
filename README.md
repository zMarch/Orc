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

HISTFILE is unset, and we use ulimit -c 0 to try and prevent any corefiles showing up. If ulimit isn't present, we'll try and use the limit coredumpsize command.

## Functions

It also contains a relatively decent selection of useful functions: some are currently not super featureful, and there's likely to be a large number of bugs, but you can find the vast majority of them by running the command 'gethelp'.
HOWEVER. An overview:

- dropsuid basically drops a tiny SUID shell written in ASM wherever. You'll need to chmod a+sx it. ([Wiki](https://github.com/zMarch/Orc/wiki/dropsuid))

- fpssh is just a wrapper around ssh-keyscan. ([Wiki](https://github.com/zMarch/Orc/wiki/fpssh))

- getdbus lists all dbus services for delicious priv-esc. ([Wiki](https://github.com/zMarch/Orc/wiki/getdbus))

- getdocker checks if the docker socket in /var/run/docker.sock exists, if we have write access, and then if we do, runs docker ps. ([Wiki](https://github.com/zMarch/Orc/wiki/getdocker))

- getenum takes the versions from the kernel, glibc, and dbus. For privilege escalation exploits, they're usually the ones you want. It also prints the init system, because it's good to know that. ([Wiki](https://github.com/zMarch/Orc/wiki/getenum))

- getescape attempts to find a way to escape a chroot by traversing a poorly configured /proc/. ([Wiki](https://github.com/zMarch/Orc/wiki/getescape))

- getexploit pulls down the linux exploit suggester ([Wiki](https://github.com/zMarch/Orc/wiki/getexploit))

- getsctp checks if SCTP support is enabled. ([Wiki](https://github.com/zMarch/Orc/wiki/getsctp))

- getidle gives you an accurate idle time for ptys, letting you see how recently other users have been active. ([Wiki](https://github.com/zMarch/Orc/wiki/getidle))

- getinfo pulls basically everything useful and generic i could think of and sticks it in a tar.xz file for you. ([Wiki](https://github.com/zMarch/Orc/wiki/getinfo))

- getip uses HTTP and DNS to get your external IP. It aims to use curl and dig, but will fall back to wget and host if it needs to. It grabs these from Akami and Google respectively to try and avoid using smaller sites that might flag in a SOC's logs or alerts. ([Wiki](https://github.com/zMarch/Orc/wiki/getip))

- getjail does a check to see if we're in a chroot, and then does some very basic checks for hypervisors/virtualisation. If there are any better checks, let me know. ([Wiki](https://github.com/zMarch/Orc/wiki/getjail))

- getluks uses lsblk to look for partitions of type crypt, indicating disk crypto. ([Wiki](https://github.com/zMarch/Orc/wiki/getluks))

- getnet does some basic network enumeration with arp and known_hosts. ([Wiki](https://github.com/zMarch/Orc/wiki/getnet))

- getpty pops a pty using script. This pty should have Orc already loaded. ([Wiki](https://github.com/zMarch/Orc/wiki/getpty))

- getrel prints the OS name from the release file. ([Wiki](https://github.com/zMarch/Orc/wiki/getrel))

- getsec checks for the presence of SELinux, AppArmor, and GrSec. I thought about adding stuff for rkhunter/chkrootkit, but in my experience they're not much of a threat unless you're using rootkits from 2003. ([Wiki](https://github.com/zMarch/Orc/wiki/getsec))

- getsfiles lists setuid flagged files and setcap files. ([Wiki](https://github.com/zMarch/Orc/wiki/getsfiles))

- getspec prints some basic hardware information. ([Wiki](https://github.com/zMarch/Orc/wiki/getspec))

- getsuspect pulls down my suspect script and runs it, looking for malware or signs of compromise. ([Wiki](https://github.com/zMarch/Orc/wiki/getsuspect))

- gettmp lists typical directories for tmp files. ([Wiki](https://github.com/zMarch/Orc/wiki/gettmp))

- getusers gets all users with a shell. ([Wiki](https://github.com/zMarch/Orc/wiki/getusers))

- getuservices gets all processes running by users who don't have a shell. Useful. ([Wiki](https://github.com/zMarch/Orc/wiki/getuservices))

- getgtfobins pulls down the list of current gtfobins and checks to see which are installed in your $PATH

- memexec uses some janky perl (see https://magisterquis.github.io/2018/03/31/in-memory-only-elf-execution.html who I stole much of the basis of it for) to execute a binary in-memory. No arguments or anything yet, and only x64 supported. ([Wiki](https://github.com/zMarch/Orc/wiki/memexec))

- portscan should be fairly self-evident. It checks for the following open ports on one host: 21, 22, 23, 80, 443, 8080, 8443, 129, 445, 3389, 3306. ([Wiki](https://github.com/zMarch/Orc/wiki/portscan))

- prochide grabs the longest process name from ps (because we can't hide arguments, but we can choose something that makes them relatively invisible in the noise) and uses that as the $0 of whatever you execute. ([Wiki](https://github.com/zMarch/Orc/wiki/prochide))

- qssh uses an ASKPASS script to launch ssh without requiring a tty. Apply arguments as usual. ([Wiki](https://github.com/zMarch/Orc/wiki/qssh))

- qsu uses an ASKPASS script to launch sudo without requiring a tty. Apply arguments as usual to sudo. ([Wiki](https://github.com/zMarch/Orc/wiki/qsu))

- sourceurl sources a file via http or https download. ([Wiki](https://github.com/zMarch/Orc/wiki/sourceurl))

- srm is just a wrapper around shred, basically. ([Wiki](https://github.com/zMarch/Orc/wiki/srm))

- stomp is just an alias for "touch -r". ([Wiki](https://github.com/zMarch/Orc/wiki/stomp))

- tools checks for common tools. ([Wiki](https://github.com/zMarch/Orc/wiki/tools))

- wiper uses utmpdump to dump wtmp into plain text and then greps out the string given as an argument. It then repacks the modified file into /var/log/wtmp, and ensures that the file is nicely time stomped. ([Wiki](https://github.com/zMarch/Orc/wiki/wiper))

## Build Status

Tests of the Orc script file are executed automatically with the [Travis CI](https://travis-ci.org/) service.

[ShellCheck](https://www.shellcheck.net/) is used to ensure wide compatibility of the Orc script.
The Bourne shell dialects: bash, dash, sh and ksh are checked.

Scripts in the tests sub-directory automatically tests Orc functions. Current the tests are in construction.
The tests will be widened over the time.

For details see the Travis CI job log.

[![Build Status](https://api.travis-ci.org/zMarch/Orc.svg?branch=master)](https://travis-ci.org/zMarch/Orc)

