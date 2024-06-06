#/bin/bash

# this script runs the posttreatment script on investment results
source include/utils.sh
echo -e "\n${print_green}Launching post-treatment for $DATASET - [$start_time]${no_color}"

if [ $# -ne 2 ]; then
    echo -n "$0 requires a second argument that can be either invest or simul."
    read phasepostreat
else
	phasepostreat="$2"
fi

if echo "$argumentsPOSTREAT" | grep -qw "$phasepostreat"; then
    :
else
	echo "${phasepostreat} is not a valid argument: must be either ${argumentsPOSTREAT}"
    read phasepostreat
fi

phasecreate=$phasepostreat
phaseformat=$phasepostreat

source scripts/include/postreat.sh