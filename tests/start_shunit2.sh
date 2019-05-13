#!/usr/bin/env sh
#
# Tests
#
# Starts a test with the shunit2 test framework.
# - Downloads the shunit2 test framework
# - Starts the test script with o.rc
# Argument: the shell to use.
#

if [ $# -ne 1 ]; then
  echo 'ERROR: script needs shell (bash, dash, ksh) as argument' >&2
  return 1;
fi

# Download the shunit2 test framework
if [ -d 'shunit2' ]; then
  echo 'Use existing shunit2 framework'
else
  echo 'Get current shunit2 framework from github'
  git clone --quiet --no-tags --single-branch --depth 1 https://github.com/kward/shunit2.git
fi

if ! [ -d 'shunit2' ]; then
  echo 'Can not download shunit2 testframework' >&2
  return 1;
fi

# Activate colored output
export SHUNIT_COLOR
SHUNIT_COLOR='always'

# use absoulte paths because o.rc changes the CWD
testRunner=$(realpath tests/run_shunit2.sh)

# Run the tests
case $1 in
  bash)  bash -i "$testRunner" ;;
  dash)  dash "$testRunner" ;;
  ksh)   ksh  -i "$testRunner" ;;
  *)     echo 'ERROR: invalid argument, must be a shell name' >&2
	 return 1 ;;
esac

