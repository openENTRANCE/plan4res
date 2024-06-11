#/bin/bash

source include/utils.sh

if [ $# -ne 2 ]; then
    echo -n "$0 requires a second argument that can be either invest, optim or simul."
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


echo -e "\n${print_green}Launching plan4res dataset creation for $DATASET - [$start_time]${no_color}"

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
source include/create.sh 
