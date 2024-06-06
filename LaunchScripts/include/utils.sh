#/bin/bash

no_color='\033[0m' # No Color
print_red='\033[0;31m'
print_green='\033[0;32m'
print_orange='\033[0;33m'
print_blue='\033[0;34m'

export P4R_ENV="bin/p4r"
export PYTHONSCRIPTS="scripts/python/plan4res-scripts/"
export DATA="data/local/"

export argumentsCREATE="invest simul"
export argumentsFORMAT="invest optim simul"
export argumentsPOSTREAT="invest simul"
export argumentsHOTSTART="hotstart"

# DATASET is the name of the directory within data/local
if [ "$1" == "" ] ; then
    echo "Please enter the name of the directory in data/local/ corresponding to your case study: "
    read DATASET
else
	DATASET=$1
fi

export INSTANCE="${DATA}${DATASET}/"
export CONFIG="${DATA}${DATASET}/settings/"
cd ..

function read_python_status {
	if [[ -f "$1" ]]; then	
		echo $(head -n 1 $1) 
	fi
}

function sddp_status {
    if [[ -f "$1BellmanValuesOUT.csv" ]]; then
        echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - successfully ran SSV with SDDP solver (convergence OK).${no_color}"
    else
        if [[ -f "$1cuts.txt" ]]; then
            echo -e "${print_orange}$(date +'%m/%d/%Y %H:%M:%S') - partially ran SSV with SDDP solver${no_color}${print_red} (no convergence).${no_color}"
        else
            echo -e "${print_red}$(date +'%m/%d/%Y %H:%M:%S') - error while running sddp_solver.${no_color}"
            exit 3
        fi
    fi
}

function invest_status {
    if [[ -f "$1Solution_OUT.csv" ]]; then
        echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - successfully ran CEM with investment_solver.${no_color}"
    else
        echo -e "${print_red}$(date +'%m/%d/%Y %H:%M:%S') - error while running CEM with investment_solver.${no_color}"
        exit 4
    fi
}

start_time=$(date +'%m/%d/%Y %H:%M:%S')

rowsettings=$(awk -F ':' '$1=="    Scenarios"' ${CONFIG}settings_format_optim.yml)
StrNbCommas=$(echo $rowsettings | grep -o ',' | wc -l)
let "NbCommas=$StrNbCommas"
NBSCEN=`expr $NbCommas + 1`
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - There are $NBSCEN scenarios in this dataset ${no_color}"

