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
  if [ -n "$output" ]; then echo "--> $output"; fi
  error=$(orc_noop 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "--> $error"; fi
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
  if [ -n "$output" ]; then echo "--> $output"; fi
  # shellcheck disable=SC2154,SC2086
  output=$(echo 'test' | grep $orc_colorNever 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertEquals 'returned not grep' 'test' "$output"
  # shellcheck disable=SC2154,SC2086
  output=$(echo 'test' | grep $orc_colorNeveri -q 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  # shellcheck disable=SC2154,SC2086
  output=$(echo 'test' | grep $orc_colorNever -q 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  output=$(echo 'test' | grep -q 'no' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  output=$(echo 'test' | grep -q 'test' 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
}


test_orc_existsProg () {
  # Test the orc_existsProg function
  output=$(orc_existsProg orc_noop 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  output=$(orc_existsProg ' this is not a program ' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
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
  if [ -n "$error" ]; then echo "--> $error"; fi
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
  if [ -n "$error" ]; then echo "--> $error"; fi
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
  if [ -n "$error" ]; then echo "--> $error"; fi
}


test_orc_exportProxySettings () {
  # Test the orc_exportProxySettings function
  output=$(orc_exportProxySettings 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
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
  if [ -n "$error" ]; then echo "--> $error"; fi
}


test_orc_tryTcpConnection () {
  # Test the orc_tryTcpConnection function
  output=$(orc_tryTcpConnection 'raw.githubusercontent.com' 80 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  output=$(orc_tryTcpConnection 'raw.githubusercontent.com' 43 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
}


test_orc_listTmp () {
  # Test the orc_listTmp function
  output=$(orc_listTmp)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertTrue 'less than 3 lines' "[ $(echo "$output"|wc -l) -ge 3 ]"
  echo "$output" |
  while read -r t; do
    assertTrue 'not directory' "[ -d $t ]"
  done
  error=$(orc_listTmp 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "--> $error"; fi
}


test_orc_makeHome () {
  # Test the orc_makeHome function
  output=$(orc_makeHome 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  assertNotNull 'HOME' "$HOME"
  assertTrue 'not directory' "[ -d $HOME ]"
}


test_orc_createEchoFile () {
  # Test the orc_createEchoFile function
  output=$(orc_createEchoFile argument_A argument_BB 2>&1)
  assertEquals 'returned false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  orc_createEchoFile argument_A argument_BB
  assertEquals 'returned false' 0 $?
  assertNotNull 'ORC_ECHO_FILE' "$ORC_ECHO_FILE"
  assertTrue 'not file' "[ -f $ORC_ECHO_FILE ]"
  output=$("$ORC_ECHO_FILE")
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertContains 'in return' "$output" 'argument_A'
  assertContains 'in return' "$output" 'argument_BB'
}


test_orc_log2outp () {
  # Test the orc_log2outp function
  OUTP="$HOME"
  assertNotNull 'outp' "$OUTP"
  output=$(orc_log2outp testA ' this is not a program name ' 2>&1)
  assertNotEquals 'returned not false' 0 $?
  assertNull 'output is not null' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  assertTrue 'output file' "[ -f 'testA.txt' ]"
  assertTrue 'error file' "[ -f 'testA.err' ]"
  output=$(cat 'testA.txt')
  error=$(cat 'testA.err')
  assertNull 'output file (T1)' "$output"
  assertNotNull 'error file (T2)' "$error"
  orc_log2outp testA pwd
  output=$(cat 'testA.txt')
  error=$(cat 'testA.err')
  assertNotNull 'output file (T2)' "$output"
  assertNotNull 'error file (T2)' "$error"
  rm 'testA.err'
  orc_createEchoFile argument_A argument_BB
  orc_log2outp testA "$ORC_ECHO_FILE"
  output=$(cat 'testA.txt')
  error=$(cat 'testA.err')
  assertNotNull 'output file (T3)' "$output"
  assertNull 'error file (T3)' "$error"
  assertContains 'in return' "$output" 'argument_A'
  assertContains 'in return' "$output" 'argument_BB'
}


test_orc_listUsers () {
  # Test the orc_listUsers function
  output=$(orc_listUsers)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertTrue 'less than 1 line' "[ $(echo "$output"|wc -l) -ge 1 ]"
  # One user per line = one word per line
  assertEquals 'lines and words' "$(echo "$output"|wc -l)" "$(echo "$output"|wc -w)"
  error=$(orc_listUsers 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "--> $error"; fi
}


test_orc_homeOfUserID () {
  # Test the orc_homeOfUserID function
  for userid in 0 1 $(id -u)
  do
    output=$(orc_homeOfUserID "$userid")
    assertEquals 'returned false' 0 $?
    assertNotNull 'output is null' "$output"
    error=$(orc_homeOfUserID "$userid" 2>&1 > /dev/null)
    assertNull 'error message' "$error"
    if [ -n "$error" ]; then echo "--> $error"; fi
  done
}


test_orc_homeOfCurrentUser () {
  # Test the orc_homeOfCurrentUser function
  output=$(orc_homeOfCurrentUser)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertTrue 'home must be a dir' "[ -d $output ]"
  error=$(orc_homeOfCurrentUser 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "--> $error"; fi
}


test_orc_ourPts () {
  # Test the orc_ourPts function
  output=$(orc_ourPts)
  assertEquals 'returned false' 0 $?
  if [ -n "$output" ]; then
    assertTrue 'must be 1 line' "[ $(echo "$output"|wc -l) -eq 1 ]"
    assertTrue 'must not negative number' "[ $output -ge 0 ]"
  fi
  error=$(orc_ourPts 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "--> $error"; fi
}


test_orc_isMinimalOsVersion () {
  # Test the orc_isMinimalOsVersion function
  output=$(orc_isMinimalOsVersion Linux 1 0 2>&1)
  assertEquals 'returned false (1)' 0 $?
  assertNull 'message (1)' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  output=$(orc_isMinimalOsVersion Linux 1 120 2>&1)
  assertEquals 'returned false (2)' 0 $?
  assertNull 'message (2)' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  output=$(orc_isMinimalOsVersion ThisIsNotAnOsName 1 0 2>&1)
  assertNotEquals 'returned not false (3)' 0 $?
  assertNull 'message (3)' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
  output=$(orc_isMinimalOsVersion Linux 123 0 2>&1)
  assertNotEquals 'returned not false (4)' 0 $?
  assertNull 'message (4)' "$output"
  if [ -n "$output" ]; then echo "--> $output"; fi
}


test_orc_filterIpAddress () {
  # Test the orc_filterIpAddress function
  testinput='
	ether 50:46:5d:dd:05:20  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
   	lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        TX packets 784  bytes 63597 (63.5 KB)
        wlp3s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.2.7  netmask 255.255.255.0  broadcast 172.17.2.255
        inet6 fe80::8836:5635:53b7:5706  prefixlen 64  scopeid 0x20<link>
        ether 68:5d:43:b0:31:82  txqueuelen 1000  (Ethernet)
        TX packets 3205  bytes 595218 (595.2 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
	0.0.0.0
	1.2.3
	1.2.3.4
	255.255.255.255
	500.500.500.500
  '
  correctoutput='127.0.0.1
172.17.2.7
fe80::8836:5635:53b7:5706
0.0.0.0
1.2.3.4
255.255.255.255
500.500.500.500'
  output=$(echo "$testinput" | orc_filterIpAddress 2>&1)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertEquals 'output invalid' "$correctoutput" "$output"
  if [ ! "$correctoutput" = "$output" ]; then echo "--> $output"; fi
}


test_orc_listHomes () {
  # Test the orc_listHomes function
  output=$(orc_listHomes)
  assertEquals 'returned false' 0 $?
  assertNotNull 'output is null' "$output"
  assertTrue 'less than 3 lines' "[ $(echo "$output"|wc -l) -ge 3 ]"
  echo "$output" |
  while read -r t; do
    assertTrue 'not directory' "[ -d $t ]"
  done
  error=$(orc_listHomes 2>&1 > /dev/null)
  assertNull 'error message' "$error"
  if [ -n "$error" ]; then echo "--> $error"; fi
}


oneTimeSetUp() {
  # Loads the orc at test setup
  # shellcheck disable=SC1091
  . ./o.rc > /dev/null
}


# shellcheck disable=SC1091
. ./shunit2/shunit2

