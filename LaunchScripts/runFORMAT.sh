#/bin/bash

# this script launches creation of nc4 files for running investment_solver 
source include/utils.sh
echo -e "\n${print_green}Launching netcdf dataset creation for $DATASET - [$start_time]${no_color}"

if [ $# -ne 2 ]; then
    echo -n "$0 requires a second argument that can be either invest, optim or simul."
    read phaseformat
else
	phaseformat="$2"
fi

if echo "$argumentsFORMAT" | grep -qw "$phaseformat"; then
    :
else
	echo "${phaseformat} is not a valid argument: must be either ${argumentsFORMAT}"
    read phaseformat
fi

if [ "$phaseformat" = "simul" ]; then
    phasecreate = "simul"
elif [ "$phaseformat" = "invest" ]; then
    phasecreate = "invest"
else
	if [ $# -ne 3 ]; then
		echo -n "$0 requires a third argument that can be either invest, optim or simul."
		read phasecreate
	else
		phasecreate="$3"
	fi
	if echo "$argumentsCREATE" | grep -qw "$phasecreate"; then
		:
	else
		echo "${phasecreate} is not a valid argument: must be either ${argumentsCREATE}"
		read phasecreate
	fi
fi
# run formatting script to create netcdf input files
source include/format.sh