## Orc Tests

The directory "tests" contains files to support the Orc development.

The directory "tests" and the files in this directory are **not** needed
to run o.rc. To run o.rc only the o.rc file is needed.

The files in the directory "tests" are only needed during development
the o.rc code.

### start_shunit2.sh script

The script is called by the Travis CI system. The calls are in the 
.travis.yaml file in the root directory.

The scripts gets the shell interpreter to use as argument.

The scripts loads the [shunit2](https://github.com/kward/shunit2)
test framework.

The script starts the test run files. All files "run_shunit2_*.sh" will
be started by the script.

### run_shunit2_*.sh scripts

These scripts tests the Orc code. The Orc files is sourced by the tests scripts.

The tests are shunit2 based.

### scripts_included.sh script

The script checks the included scripts from the resources subdirectory.
The script compares the base64 encoded ode blocks in the Orc source file
with the current script files.

