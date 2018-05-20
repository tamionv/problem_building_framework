Hello.
This is a bundle of scripts used to prepare competitive programming problems

File descriptions:

README.md | This readme
--------- | -----------
problemconfig.sh | A script that sets problem configuration variables (i.e. $problemname, $timelimit)
lib.sh | A bash library, used for the scripts in this bundle
run.sh | ./run.sh -s "s1.cpp s2.cpp" -t "00 01" will run s1.cpp, s2.cpp on 00, 01 -- ommiting -s or -t respectively leads to running all sources / all tests
buildtests.sh | ./buildtests.sh will build all tests following testmanifest
testmanifest | describes the structure of the tests
ingen | Contains files related to input generation
ingen/makefile | A file that needs to make the input generator, ingen/ingen.bin
ingen/ingen.bin | The input generator. When run, a configuration file *problemname*.cf will be made available to it. Output the input to *problemname*.in
incf | Holds various input configuration files
okgen | Contains files related to ok generation
okgen/makefile | A file that needs to make the ok generator, okgen/okgen.bin
okgen/okgen.bin | A file that needs to make ok's. It will read the input from *problemname*.in and write the ok to *problemname*.ok. The number of points for this test will be found in *problemname*.points
eval | Contains files related to evaluation
eval/makefile | A file that needs to make the evaluator, eval/eval.bin
eval/eval.bin | A file that evaluates. It will read the input file from *problemname*.in, the output file from *problemname*.out, the ok file from *problemname*.ok. It will write the score to *stdout* and the evaluation message to *stderr*.
tests | Holds tests
stage | Where evaluation happens

testmanifest format:

Groups of tests will appear, each described on a column ; first the number of tests "like this", second the number of points for the group, third the name of the incf.
