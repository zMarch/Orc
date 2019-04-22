/*
 * C program to test the memexec script.
 * The C program writes the command line arguments to stdout.
 * One text line will be written to stderr.
 * The exit code of the program is number of arguments - 2,
 * so the call "echo_argument a" will return 0. (The program
 * name is the first command line argument.)
 *
 * The C program can be compiled to a binary program
 * with the command:
 * gcc echo_arguments.c -o echo_arguments
 *
 * Then the binary program echo_arguments can be stored
 * on a web server to load it with the memexec script.
 */

#include <stdio.h>

int main ( int argc, char** argv )
{
  int i;
  puts( "The echo_arguments test program" );
  fputs( "This is a output line to stderr\n", stderr );
  for( i = 0; i < argc; ++i)
    printf( "argument %2d is '%s'\n", i, argv[i] );
  printf( "exit code of the test program is %d\n", argc-2 );
  return argc-2;
}

