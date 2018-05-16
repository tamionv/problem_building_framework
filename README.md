Hello.
This is a bundle of scripts used to prepare competitive programming problems

File descriptions:

README.md | This readme
--------- | -----------
problemname | A file that should contain exactly the problem name
timelimit | A file that should contain the time limit, in seconds
lib.sh | A bash library, used for the scripts in this bundle
build\_test.sh | ./build\_test.sh *xxx* will build *problemname*-*xxx*.in with ingen/ingen.bin with configuration incf/*xxx*
run.sh | ./run.sh *xxx* will run src/*xxx* on all the tests
ingen | Contains files related to input generation
ingen/makefile | A file that needs to make the input generator, ingen/ingen.bin
ingen/ingen.bin | The input generator. When run, a configuration file *problemname*.cf might be made available to it (depending on whether an appropriate file exists in incf). The input should be written to a file *problemname*.in.
incf | Holds various configuration files
okgen | Contains files related to ok generation
okgen/makefile | A file that needs to make the ok generator, okgen/okgen.bin
okgen/okgen.bin | A file that needs to make ok's. It will read the input from *problemname*.in and write the ok to *problemname*.ok
eval | Contains files related to evaluation
eval/makefile | A file that needs to make the evaluator, eval/eval.bin
eval/eval.bin | A file that evaluates. It will read the input file from *problemname*.in, the output file from *problemname*.out, the ok file from *problemname*.ok. It will write the score to *stdout* and the evaluation message to *stderr*.
tests | Holds tests
stage | Where evaluation happens
