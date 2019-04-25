## Orc Resources

The directory resources contains files to support the Orc development.

The directory resources and the files in this directory are **not** needed
to run o.rc. To run o.rc only the o.rc file is needed.

The files in the directory resources are only needed during development
the o.rc code.

### memexec

The orc function memexec is based on a Perl or a Python function.
Inside o.rc a shell function calls the Perl or Python interpreter
with the code developed here.

* **memexec.pl**
  The Perl version of the memexec function.
* **memexec.py**
  The Python version of the memexec function.
  Python 2 and Python 3 interpreters can run this code.
* **echo_arguments.sh**
  Test shell script for the memexec function.
  The memexec function should be able to start this script.
  The script runs with bash, dash, ksh.
* **echo_arguments.c**
  C test program for the memexec funtion.
  The memexec function should be able to start the compiled program.
  The program must be compiled for the desired target system before
  memexec can start the binary file.
    
## encoder

The scripts are stored gziped and base64 encoded in the o.rc file.
Also the comments inside the script files are not stored in the o.rc.

The encoder shell scripts strips the comments, gzips the file and
base64 encode the binary gzip output.

* **encode_perl_script.sh**
  Shell script to encode a Perl script.
* **encode_python_script.sh**
  Shell script to encode a Python script.

