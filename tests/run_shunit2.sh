#!/usr/bin/env sh
#
# Tests
#
# Runs the tests with the shunit2 test framework.
# The script is designed for a start via the start_shunit2.sh script.
# The shunit2 framework must be loaded in the ./shunit2 directory.
# The o.rc must be located in the cwd directory.
#

if [ ! -f ./shunit2/shunit2 ]; then
  echo 'Error: missing the shunit2 script' >&2
  return 1
fi
if [ ! -f ./o.rc ]; then
  echo 'missing the o.rc script in the cwd' >&2
  return 1
fi


test_gethelp () {
  # Test the gethelp function
  output=$(gethelp)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertContains 'Orc not found' "$output" 'Orc'
  assertTrue 'Less than 5 lines' "[ $(echo "$output"|wc -l) -ge 5 ]"
  error=$(gethelp 2>&1 > /dev/null)
  assertNull 'error message' "$error"
}


oneTimeSetUp() {
  # Loads the orc at test setup
  # shellcheck disable=SC1091
  . ./o.rc
}


# shellcheck disable=SC1091
. ./shunit2/shunit2

