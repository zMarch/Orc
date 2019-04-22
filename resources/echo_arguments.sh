#!/usr/bin/env sh
#
# Shell script to test the memexec script.
# The script writes the command line arguments to stdout.
# One text line will be written to stderr.
# The exit code of the script is number of arguments.
# so the call "echo_argument a" will return 1.
#
# The scrpt echo_arguments can be stored on a web server
# to load it with the memexec script.
#

echo 'The echo_arguments test script'
echo 'This is a output line to stderr' >&2
for arg; do
  echo "argument '$arg'"
done
printf "exit code of the test script is %d\n", $#
exit $#


