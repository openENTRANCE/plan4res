#/bin/bash

source scripts/include/utils.sh

if [ $# -ne 2 ]; then
    echo " requires a second argument that can be either invest or simul "
    echo " depending if you intend to create a plan4res dataset: " 
	echo "     - without investment optimisation -simul-, "
	echo "     - with investment optimisation -invest- ."
    echo -n "$0 please choose: "    
	read phasecreate
else
	phasecreate="$2"
fi

if echo "$argumentsCREATE" | grep -qw "$phasecreate"; then
    :
else
	echo "${phasecreate} is not a valid argument: must be either invest or simul "
	echo -n "$0 please choose invest or simul: " 
    read phasecreate
fi


echo -e "\n${print_green}Launching plan4res dataset creation for $DATASET - [$start_time]${no_color}"

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
source scripts/include/create.sh 
