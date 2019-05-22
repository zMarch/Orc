#!/usr/bin/env sh
#
# Tests with shunit2 test framework.
#
# The script is designed for a start via start_shunit2.sh
#
# Tests of the internal functions are collecte here.
#
# Name of the test functions are "test_FKT" where FKT is the name
# of the tested function.
#

# The shunit2 framework must be loaded in the ./shunit2 directory.
if [ ! -f ./shunit2/shunit2 ]; then
  echo 'Error: missing the shunit2 script' >&2
  return 1
fi
# The o.rc must be located in the cwd directory.
if [ ! -f ./o.rc ]; then
  echo 'missing the o.rc script in the cwd' >&2
  return 1
fi


test_orc_noop () {
  # Test the orc_noop function
  output=$(orc_noop)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  error=$(orc_noop 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
}


test_orc_colorNever () {
  # Test the orc_colorNever flag for the grep tool
  output=$(echo 'test' | grep $orc_colorNever 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  output=$(echo 'test' | grep $orc_colorNever 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertEquals 'returned not grep' 'test' "$output"
  output=$(echo 'test' | grep $orc_colorNeveri -q 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  output=$(echo 'test' | grep $orc_colorNever -q 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  output=$(echo 'test' | grep -q 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  output=$(echo 'test' | grep -q 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
}


test_orc_existsProg () {
  # Test the orc_existsProg function
  output=$(orc_existsProg orc_noop 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  output=$(orc_existsProg ' this is not a program ' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
}


test_orc_listArp () {
  # Test the orc_listArp function
  output=$(orc_listArp)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  # One address = one word per line
  assertEquals 'lines and words' "$(echo "$output"|wc -l)" "$(echo "$output"|wc -w)"
  error=$(orc_listArp 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
}


test_orc_listBroadcastAddress () {
  # Test the orc_listBroadcastAddress function
  output=$(orc_listBroadcastAddress)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  # One address = one word per line
  assertEquals 'lines and words' "$(echo "$output"|wc -l)" "$(echo "$output"|wc -w)"
  error=$(orc_listBroadcastAddress 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
}



test_orc_inetAddressAndMask () {
  # Test the orc_inetAddressAndMask function
  output=$(orc_inetAddressAndMask)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  # One address plus mask per line = two words per line
  assertEquals 'lines and words' "$(( $(echo "$output"|wc -l) *2))" "$(echo "$output"|wc -w)"
  error=$(orc_inetAddressAndMask 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
}


oneTimeSetUp() {
  # Loads the orc at test setup
  # shellcheck disable=SC1091
  . ./o.rc > /dev/null
}


# shellcheck disable=SC1091
. ./shunit2/shunit2

