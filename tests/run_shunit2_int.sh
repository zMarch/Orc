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
  # The orc_colorNever variable is defined in the o.rc.
  # So the shellcheck 2154 must be disabled.
  # The varaible must not used with quotes because the
  # empty string must not used as argument.
  # So the shellcheck 2086 must be disabled.
  # shellcheck disable=SC2154,SC2086
  output=$(echo 'test' | grep $orc_colorNever 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  # shellcheck disable=SC2154,SC2086
  output=$(echo 'test' | grep $orc_colorNever 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertEquals 'returned not grep' 'test' "$output"
  # shellcheck disable=SC2154,SC2086
  output=$(echo 'test' | grep $orc_colorNeveri -q 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  # shellcheck disable=SC2154,SC2086
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


test_orc_exportProxySettings () {
  # Test the orc_exportProxySettings function
  output=$(orc_exportProxySettings 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  http_proxy='http-test'
  https_proxy='https-test'
  output=$(orc_exportProxySettings 2>&1)
  orc_exportProxySettings
  assertEquals 'returned false' 0 $?
  assertEquals 'http_proxy 1' 'http-test' "$(sh -c 'echo $http_proxy')"
  assertEquals 'http_proxy 2' 'http-test' "$(sh -c 'echo $HTTP_PROXY')"
  assertEquals 'https_proxy 1' 'https-test' "$(sh -c 'echo $https_proxy')"
  assertEquals 'https_proxy 2' 'https-test' "$(sh -c 'echo $HTTPS_PROXY')"
  http_proxy=''
  HTTP_PROXY='http2-test'
  https_proxy=''
  HTTPS_PROXY='https2-test'
  orc_exportProxySettings
  assertEquals 'returned false' 0 $?
  assertEquals 'http_proxy 3' 'http2-test' "$(sh -c 'echo $http_proxy')"
  assertEquals 'http_proxy 4' 'http2-test' "$(sh -c 'echo $HTTP_PROXY')"
  assertEquals 'https_proxy 3' 'https2-test' "$(sh -c 'echo $https_proxy')"
  assertEquals 'https_proxy 4' 'https2-test' "$(sh -c 'echo $HTTPS_PROXY')"
  assertEquals 'http_proxy 5' 'http2-test' "$http_proxy"
  assertEquals 'http_proxy 6' 'http2-test' "$HTTP_PROXY"
  assertEquals 'https_proxy 5' 'https2-test' "$https_proxy"
  assertEquals 'https_proxy 6' 'https2-test' "$HTTPS_PROXY"
  # clear http proxy settings for follwing tests
  http_proxy=''
  HTTP_PROXY=''
  https_proxy=''
  HTTPS_PROXY=''
}


test_orc_loadURL () {
  # Test the orc_loadURL function
  output=$(orc_loadURL https://raw.githubusercontent.com/zMarch/Orc/master/resources/echo_arguments.sh)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertTrue 'less than 10 lines' "[ $(echo "$output"|wc -l) -ge 10 ]"
  assertTrue 'less than 50 words' "[ $(echo "$output"|wc -w) -ge 50 ]"
  assertContains 'in download' "$output" '#!'
  assertContains 'in download' "$output" 'echo'
  error=$(orc_loadURL https://raw.githubusercontent.com/zMarch/Orc/master/resources/echo_arguments.sh 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
}


test_orc_tryTcpConnection () {
  # Test the orc_tryTcpConnection function
  output=$(orc_tryTcpConnection 'raw.githubusercontent.com' 80 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
  output=$(orc_tryTcpConnection 'raw.githubusercontent.com' 43 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "$output"; fi
}


test_orc_listtmp () {
  # Test the orc_listtmp function
  output=$(orc_listtmp)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertTrue 'less than 3 lines' "[ $(echo "$output"|wc -l) -ge 3 ]"
  echo "$output" |
  while read -r t; do
    assertTrue 'not directory' "[ -d "$t" ]"
  done
  error=$(orc_listtmp 2>&1 > /dev/null)
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

