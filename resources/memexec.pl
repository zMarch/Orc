#!/usr/bin/env perl
#
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
 
use warnings;
use strict;
# Import user agent ($ua) and get to file function.
use LWP::Simple qw($ua get getstore);
use Config;

# use the old if-elsif-else structure to be compatible to
#  old perl interpreters.
my $syscallnr = -1;
if($Config{archname} =~ /x86_64-linux/) {
  $syscallnr = 319 }
elsif($Config{archname} =~ /i386-linux/) {
  $syscallnr = 356 }
elsif($Config{archname} =~ /ia64-linux/) {
  $syscallnr = 1340 }
elsif($Config{archname} =~ /(arm|armeb|aarch64)-linux/) {
  $syscallnr = 385 }
elsif($Config{archname} =~ /power(pc|pc64|pc64le)-linux/) {
  $syscallnr = 360 }
elsif($Config{archname} =~ /(sparc|sparc64)-linux/) {
  $syscallnr = 348 }
else {
  die "This architecture is not supported, arch='$Config{archname}'" }

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
my $fd = syscall($syscallnr, $name, 1);
if($fd == -1) {
  die "can't create anon file, $!" }
my $anon = "/proc/$$/fd/$fd";

# Copy URL content to the anonymous file
my $code = getstore( $url, $anon );
if($code != 200) {
  die "can't load file from server, status code=$code" }

# Figure out: Is it a binary file or script file?
# A script file must start with "#!"
open my $fh, '<:raw', $anon;
my $nrbytes = read $fh, my $bytes, 2;
if($nrbytes != 2) {
  die "can not read file signature bytes" }
close $fh;
if('#!' eq unpack 'a2', $bytes) {
  # Execute a script.
  # Use env to start the script interpreter defined in the shebang
  system {"env"} '--', $anon, @ARGV }
else {
  # Execute the binary program
  exec {$anon} $prog, @ARGV
}

