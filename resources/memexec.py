#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Load binary program or script file from web server.
# Uses http or https protocol.
# Execute the program or the script without touching the
# file to a storage drive.
# Stores the file in the process memory /proc/id.
# A binary program must be compiled for the architecture of
# the executing system.
# A script file must start with the two characters "#!".
#
# Script arguments:
# 1) URL to load the binary program or script file..
# 2) Name of program to use for execution,
#    The name is only used to start the program.
#    But the name must be given in each case to use the same
#    command line format.
# 3) optional: arguments passed thru to the program.
#
# Typical this script with "PYTHONHTTPSVERIFY=0 python" to switch of
# the https certificate check.
#
# Needs Linux kernel >= 3.17
#
# In-Memory-Only ELF Execution (Without tmpfs)
# https://magisterquis.github.io/2018/03/31/in-memory-only-elf-execution.html
#
# System call table
# https://www.lurklurk.org/syscalls.html
#
# Multiarch Architecture Specifiers
# https://wiki.debian.org/Multiarch/Tuples
#

import ctypes
import os
import platform
import sys

try:
    # python 3 version
    from urllib.request import urlopen
except ImportError:
    # python 2 version
    from urllib2 import urlopen

# System call number of memfd_create depends on the machine
sys_call_numbers = {
    'x86_64': 319,
    'i386': 356,
    'ia64': 1340,
    'arm': 385,
    'armeb': 385,
    'aarch64': 385,
    'powerpc': 360,
    'powerpc64': 360,
    'powerpc64le': 360,
    'sparc': 348,
    'sparc64': 348
}

try:

    # Find the system call number of memfd_create on the current machine
    if platform.system() != 'Linux':
        raise RuntimeError('supports only Linux, but found ' + platform.system())
    if platform.machine() not in sys_call_numbers.keys():
        raise RuntimeError('does not support architecture ' + platform.machine())
    sys_call_nr = sys_call_numbers[platform.machine()]

    if len(sys.argv) < 3:
        raise RuntimeError('missing arguments: url and program name must be given')
    # URL to load the binary program or the script file
    url = sys.argv[1]
    # Name of the program to used, because there is no filename
    name = sys.argv[2]
    # optional arguments to pass thru the loaded program
    arguments = sys.argv[3:]

    # Create an anonymous file with name '' and close-on-exec (=1) flag
    fd = ctypes.CDLL(None).syscall(sys_call_nr, '', 1)
    if fd == 1:
        raise RuntimeError('can not create anonymous file')
    # The name of the anonymous file in the process memory
    anon = '/proc/' + str(os.getpid()) + '/fd/' + str(fd)

    # Copy data from server to anonymous file
    signature = None
    with open(anon, 'wb') as out:
        request = urlopen(url)
        while True:
            buffer = request.read(1048576)
            if not buffer:
                break
            if not signature and len(buffer) > 1:
                # File signature is the first two bytes:w
                signature = buffer[0:2]
            out.write(buffer)

    # Figure out: Is it a binary file or script file?
    # A script file must start with "#!"
    # "(ord('#'),'#')" is used to support python3 and python2.
    if signature and signature[0] in (ord('#'), '#') and signature[1] in (ord('!'), '!'):
        # Execute a script
        os.system(anon + ' "' + '" "'.join(arguments) + '"')
    else:
        # Execute a binary program
        os.execv(anon, [name, ] + arguments)

except Exception as error:
    print(error)
    sys.exit(1)
