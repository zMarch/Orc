#!/usr/bin/env sh
#
# Tests
#
# - The current scripts in the resources sub-directory must be
#   included into the o.rc script.
# - The used quoated http and https addresses must be accessable.
#

# The error flag will be set to 1 if an test fail
errorFlag=0

# Path to the resources files
readonly res=resources

# The memexec.pl must be included as base64 blob in the Orc script.
echo 'check - memexec.pl is included'
if ! $res/encode_perl_script.sh $res/memexec.pl; then
  echo 'ERROR: encode_perl_script memexec failed' >&2
  errorFlag=1
else
  encoded=$(cat resources/memexec.pl.base64)
  if ! grep --quiet "$encoded" -- o.rc; then
    echo 'ERROR: memexec.pl is not included' >&2
    errorFlag=1
  fi
fi

# The memexec.py must be included as bas64 blob in the Orc script.
echo 'Check - memexec.py is included'
if ! $res/encode_python_script.sh $res/memexec.py; then
  echo 'ERROR: encode_python_script memexec failed' >&2
  errorFlag=1
else
  encoded=$(cat resources/memexec.py.base64)
  if ! grep --quiet "$encoded" -- o.rc; then
    echo 'ERROR: memexec.py is not included' >&2
    errorFlag=1
  fi
fi

# Check the included http and https expressions.
# Checks only the single-quated expression. Other strings could
# contain shell variables.
urls=$(grep --ignore-case --only-matching --extended-regexp "'https?://[^']+'" o.rc)
if [ -z "$urls" ]; then
  echo 'ERROR: no http/https addresses found' >&2
  errorFlag=1
fi
for address in $urls; do
  address=${address%\'}
  address=${address#\'}
  if ! head=$(curl --head --silent --insecure --location "$address"); then
    echo "ERROR: can not download '$address'" >&2
    errorFlag=1
  fi
  if [ -z "$head" ]; then
    echo "ERROR: can not download head of '$address'" >&2
    errorFlag=1
  fi
done

exit $errorFlag
