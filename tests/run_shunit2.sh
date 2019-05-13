#!/usr/bin/env sh
#
# Tests
#
# Runs the tests with the shunit2 test framework.
# The script is designed for a start via the start_shunit2.sh script.
#


test_Gethelp () {
  output=$(gethelp)
  assertNotNull 'output is null' "$output"
  assertNotNull 'Orc not found' "$(echo $output|grep 'Orc')"
}


oneTimeSetUp() {
  # Loads the orc at test setup
  # shellcheck disable=SC1091
  . ./o.rc
}


# shellcheck disable=SC1091
. ./shunit2/shunit2

