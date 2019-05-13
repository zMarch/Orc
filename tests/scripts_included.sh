#!/usr/bin/env sh
#
# Tests
#
# The current scripts in the resources sub-directory must be
# included into the o.rc script.
#

# Path to the resources files
readonly res=resources

echo 'Test - memexec.pl is included'
if ! $res/encode_perl_script.sh $res/memexec.pl; then
  echo 'ERROR: encode_perl_script memexec failed' >&2
  return 1
fi
encoded=$(cat resources/memexec.pl.base64)
if grep --quiet "$encoded" -- o.rc; then
  echo 'ok, current memexec.pl is included'
else
  echo 'ERROR: memexec.pl is not included' >&2
  return 1
fi

echo 'Test - memexec.py is included'
if ! $res/encode_python_script.sh $res/memexec.py; then
  echo 'ERROR: encode_python_script memexec failed' >&2
  return 1
fi
encoded=$(cat resources/memexec.py.base64)
if grep --quiet "$encoded" -- o.rc; then
  echo 'ok, current memexec.py is included'
else
  echo 'ERROR: memexec.py is not included' >&2
  return 1
fi

