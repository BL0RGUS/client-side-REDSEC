#!/bin/bash
# This line is required to inform the Linux
#command line to parse the script using
#the bash shell

# Instructing SLURM to locate and assign
#X number of nodes with Y number of
#cores in each node.
# X,Y are integers. Refer to table for
#various combinations
#SBATCH -N 3
#SBATCH -c 32
# Governs the run time limit and
# resource limit for the job. Please pick values
# from the partition and QOS tables below
#for various combinations
#SBATCH --partition=cpu
#SBATCH --qos="short"
#SBATCH --output="decryption_log.o"
export LD_LIBRARY_PATH=:/usr/local/lib:/usr/local/lib:$(pwd)/lib
export format=MNIST

START=$(date +%s.%N)
make decrypt-image
TIME=$(echo "$(date +%s.%N) - $START" | bc)
TOTALTIME=$(echo "$TOTALTIME+$TIME" | bc)
echo "Classification Decryption: $TIME seconds"

echo "Total Time: $TOTALTIME seconds"