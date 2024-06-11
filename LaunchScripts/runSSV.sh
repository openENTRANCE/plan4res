#/bin/bash

# this scripts:
# 1 - creates plan4res dataset, 
# 2 - creates nc4 files 
# 3 - launches SSV alone

source include/utils.sh

if [ $# -ne 2 ]; then
    echo -n "$0 requires a second argument that can be either invest or simul."
    read phasecreate
else
	phasecreate="$2"
fi

if echo "$argumentsCREATE" | grep -qw "$phasecreate"; then
    :
else
	echo "${phasecreate} is not a valid argument: must be either ${argumentsCREATE}"
    read phasecreate
fi

phaseformat="optim"
echo $phaseformat

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
# comment if you are using handmade datasets
source include/create.sh 

# run script to create netcdf files for ssv
# comment if you are using aleady created nc4
source include/format.sh 

# run sddp solver
source include/ssv.sh

