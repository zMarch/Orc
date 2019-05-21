#!/usr/bin/env sh
#
# Tests with shunit2 test framework.
#
# The script is designed for a start via start_shunit2.sh
#
# Tests of the user level functions are collecte here.
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


test_gethelp() {
  # Test the gethelp function
  output=$(gethelp 2> /dev/null)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertContains 'in output' "$output" 'Orc'
  assertTrue 'less than 5 lines' "[ $(echo "$output"|wc -l) -ge 5 ]"
  error=$(gethelp 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
}


test_getsfiles() {
  # Test the getsfiles function
  error=$(getsfiles background 2>&1 > /dev/null)
  assertNull 'error message in background mode' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  output=$(getsfiles 2> /dev/null)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertContains 'in output' "$output" 'root'
  assertTrue 'less than 5 lines' "[ $(echo "$output"|wc -l) -ge 5 ]"
  error=$(getsfiles 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  assertTrue 'missing sfiles' "[ -f sfiles ]"
  assertTrue 'less than 5 lines in sfiles' "[ $(wc -l < sfiles) -ge 5 ]"
  rm sfiles
}


test_dropsuid() {
  # Test the dropsuid function
  error=$(dropsuid 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


#test_getdbus() {
# Run with Travis CI raises the error:
# Failed to open connection to "session" message bus: Unable to autolaunch a dbus-daemon without a $DISPLAY for X11
#  # Test the getdbus function
#  error=$(getdbus 2>&1 > /dev/null)
#  assertEquals 'returned false' 0 $?
#  assertNull 'error message' "$error"
#  if [ -n "$error" ]; then echo "$error"; fi
#  # TODO: add more checks
#}


test_getdocker() {
  # Test the getdocker function
  error=$(getdocker 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getenum() {
  # Test the getenum function
  error=$(getenum 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getescape() {
  # Test the getescape function
  error=$(getescape 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getexploit() {
  # Test the getexploit function
  error=$(getexploit 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getidle() {
  # Test the getidle function
  error=$(getidle 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


#test_getinfo() {
#  # Test the getinfo function
#  error=$(getinfo 2>&1 > /dev/null)
#  assertEquals 'returned false' 0 $?
# TODO: suppress message "Removing leading '/' from member names
#  assertNull 'error message' "$error"
#  if [ -n "$error" ]; then echo "$error"; fi
#  # TODO: add more checks
#}


test_getip() {
  # Test the getip function
  error=$(getip 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getjail() {
  # Test the getjail function
  error=$(getjail 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getluks() {
  # Test the getluks function
  error=$(getluks 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


#test_getnet() {
#  # Test the getnet function
#  error=$(getnet 2>&1 > /dev/null)
#  assertEquals 'returned false' 0 $?
# TODO: suppress message "Removing leading '/' from member names
#  assertNull 'error message' "$error"
#  if [ -n "$error" ]; then echo "$error"; fi
#  # TODO: add more checks
#}


test_getrel() {
  # Test the getrel function
  error=$(getrel 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getsec() {
  # Test the getsec function
  error=$(getsec 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getspec() {
  # Test the getspec function
  error=$(getspec 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_gettmp() {
  # Test the gettmp function
  error=$(gettmp 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getusers() {
  # Test the getusers function
  error=$(getusers 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_getuservices() {
  # Test the getuservices function
  error=$(getuservices 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_portscan() {
  # Test the portscan function
  error=$(portscan localhost 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


test_prochide() {
  # Test the prochide function
  error=$(prochide 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


#test_srm() {
#  # Test the srm function
#  echo "test file for srm" > test_file_for_srm
#  error=$(srm test_file_for_srm 2>&1 > /dev/null)
#  assertEquals 'returned false' 0 $?
# TODO: no error output if srm works well.
#  assertNull 'error message' "$error"
#  if [ -n "$error" ]; then echo "$error"; fi
#  assertFalse 'test file not removed' "[ -e test_file_for_srm ]"
#}


test_tools() {
  # Test the tools function
  error=$(tools 2>&1 > /dev/null)
  assertEquals 'returned false' 0 $?
  # Some missing tools are normal. So $error could be contain messages
  # assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "$error"; fi
  # TODO: add more checks
}


oneTimeSetUp() {
  # Loads the orc at test setup
  # shellcheck disable=SC1091
  . ./o.rc > /dev/null
}


# shellcheck disable=SC1091
. ./shunit2/shunit2

