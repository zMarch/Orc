#!/usr/bin/env sh
#
# Shell script to test the sourceurl function.
# The file defines one function.
#


echo_function() {
  echo 'The echo_function'
  for arg; do
    echo "argument '$arg'"
  done
  return 0
}

