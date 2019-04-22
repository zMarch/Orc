#!/usr/bin/env sh
#
# Simple Perl script obfuscation.
# - Removes all comment lines (including #!)
#   and empty lines.
# - Compress the striped file with gzip
# - base64 encode the compressed file with uuencode
#
# gzip and uuencode/uudecode are choosed because they
# are widley used linux tools.
#
# The perl script could be executed by
#      $ uudecode FILE | gzip -d | perl - ARGUMENTS
# where FILE is the file generated by this script and
# ARGUMENTS are the arguments used by the Perl script.
#

if [ $# -ne 1 ]; then
  echo "missing argument: perl script name" >&2
  return 1
fi

# strip comment lines
grep -v '^ *#' $1 |
# strip empty lines
grep -v '^$' |
# compress
gzip --stdout - |
# base64 uuencode
uuencode --base64 - > $1.uu

echo "The compressed and encoded file is $1.uu"

