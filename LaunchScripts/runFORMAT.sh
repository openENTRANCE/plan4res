#/bin/bash

# this script launches creation of nc4 files for running investment_solver 
source scripts/include/utils.sh
echo -e "\n${print_green}Launching netcdf dataset creation for $DATASET - [$start_time]${no_color}"
if [ "$2" == "" ]; then
    echo " requires a second argument that can be either invest, optim or simul "
    echo " depending if you intend to create a plan4res dataset for: " 
    echo "     - launching computation of bellman values -optim-, "
	echo "     - launching simulation -simul-, "
	echo "     - launching investments with investment_solver -invest- ."
    echo -n "$0 please choose: "
	read phaseformat
else
	phaseformat="$2"
	echo "creating blocks for $phaseformat"										
fi

if echo "$argumentsFORMAT" | grep -qw "$phaseformat"; then
    :
else
	echo "${phaseformat} is not a valid argument: must be either ${argumentsFORMAT}"
	echo -n "$0 please choose between invest, optim, simul: "
    read phaseformat
fi

if [ "$phaseformat" == "simul" ]; then
    phasecreate="simul"
elif [ "$phaseformat" == "invest" ]; then
    phasecreate="invest"
else
	if [ "$#" -lt 3 ]; then
		echo " requires a third argument that can be either invest or simul "
		echo " depending if your dataset will be used in a case study : " 
		echo "     - with investment optimisation -invest-, "
		echo "     - without investment optimisation -simul- ."
		echo "Usage: $0 $1 $2 arg2"
		exit 1
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
source scripts/include/format.sh
