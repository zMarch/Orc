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

# The script runs the tests
testRunner=$(readlink -e ./tests/run_shunit2.sh)

# Run the tests
for runner in $(readlink -e ./tests/run_shunit2_*.sh); do
  echo ">>> start script '$runner'"
  case $1 in
    bash)  bash -i "$runner" ;;
    dash)  dash "$runner" ;;
    ksh)   ksh  -i "$runner" ;;
    *)     echo 'ERROR: invalid argument, must be a shell name' >&2
           return 1 ;;
  esac
done

