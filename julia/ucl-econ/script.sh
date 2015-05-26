#!/bin/bash

echo "starting qsub script file"
source ~/.bash_profile
date

module load sge/2011.11

# here's the SGE directives
# ------------------------------------------
#$ -q batch.q   # <- the name of the Q you want to submit to
#$ -pe mpich 14  #  <- load the openmpi parallel env w/ $(arg1) slots
#$ -S /bin/bash   # <- run the job under bash
#$ -N mpi-testing # <- name of the job in the qstat output
#$ -o test.out # direct output stream to here
#$ -e test.err # <- name of the stderr file.
#$ -wd /data/uctpfos/git/parallelTest/julia/ucl-econ

echo "checking environment:"
echo "====================="

echo "your LD_LIBRARY"
echo $LD_LIBRARY_PATH

echo "your hostfile:"
cat $PE_HOSTFILE

awk '{ for (i=0; i < $2; ++i) { print $1} }' $PE_HOSTFILE > hosts

echo "calling julia now:"

# you need to execute this line by hand.
# julia --machinefile hosts.txt -L ../incl.jl sge.jl

