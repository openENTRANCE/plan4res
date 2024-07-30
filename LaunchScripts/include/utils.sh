#/bin/bash

echo "Loading utils."

P4R_ENV="bin/p4r"
PYTHONSCRIPTS="scripts/python/plan4res-scripts/"
DATA="data/local/"

outputs="Demand Volume Flows ActivePower MaxPower Primary Secondary"
MarginalCosts="MarginalCostActivePowerDemand MarginalCostFlows MarginalCostInertia MarginalCostPrimary MarginalCostSecondary"

# Do not modify below
no_symlinks='on'
function get_realpath() { # taken and adapted from bin/p4r, 
    if [ ! -f "$1" ] && [ ! -d "$1" ]; then
        return 1 # failure : file or directory does not exist.
    fi
    [[ -n "$no_symlinks" ]] && local pwdp='pwd -P' || local pwdp='pwd' # do symlinks.
    echo "$( cd "$( echo "${1%/*}" )" 2>/dev/null; $pwdp )"/"${1##*/}" # echo result.
    return 0 # success
}

P4R_ENV=$(get_realpath ${P4R_ENV})
PYTHONSCRIPTS=$(get_realpath ${PYTHONSCRIPTS})
DATA=$(get_realpath ${DATA})
export P4R_ENV
export PYTHONSCRIPTS
export DATA

# DATASET is the name of the directory within data/local
if [ "$1" == "" ] ; then
    echo "Please enter the name of the directory in data/local/ corresponding to your case study: "
    read DATASET
else
	DATASET=$1
fi

echo "Path used:"
echo -e "\tP4R_ENV       = ${P4R_ENV}"
echo -e "\tPYTHONSCRIPTS = ${PYTHONSCRIPTS}"
echo -e "\tDATA          = ${DATA}"
export INSTANCE="${DATA}/${DATASET}/"
export CONFIG="${DATA}/${DATASET}/settings/"
echo -e "\tINSTANCE      = ${INSTANCE}"
echo -e "\tCONFIG        = ${CONFIG}"

#if [[ "$USER" = "vagrant" ]]; then
vagrant_cwd_file=.vagrant/machines/default/virtualbox/vagrant_cwd
if [ -f ${vagrant_cwd_file} ]; then
    echo "Using a vagrant environment"
    vagrant_cwd=$(head -n 1 ${vagrant_cwd_file})
    vagrant_cwd=$(get_realpath $vagrant_cwd)
    p4r_vagrant_home="/vagrant"
    echo "Vagrant CWD is ${vagrant_cwd}"
    export PYTHONSCRIPTS_IN_P4R=$(echo "$PYTHONSCRIPTS" | sed "s|$vagrant_cwd|$p4r_vagrant_home|")
    export DATA_IN_P4R=$(echo "$DATA" | sed "s|$vagrant_cwd|$p4r_vagrant_home|")
    export INSTANCE_IN_P4R=$(echo "$INSTANCE" | sed "s|$vagrant_cwd|$p4r_vagrant_home|")
    export CONFIG_IN_P4R=$(echo "$CONFIG" | sed "s|$vagrant_cwd|$p4r_vagrant_home|")
    echo "Path used in the Vagrant container:"
    echo -e "\tPYTHONSCRIPTS = ${PYTHONSCRIPTS_IN_P4R}"
    echo -e "\tDATA          = ${DATA_IN_P4R}"
    echo -e "\tINSTANCE      = ${INSTANCE_IN_P4R}"
    echo -e "\tCONFIG        = ${CONFIG_IN_P4R}"
else
    export PYTHONSCRIPTS_IN_P4R=${PYTHONSCRIPTS}
    export DATA_IN_P4R=${DATA}
    export INSTANCE_IN_P4R=${INSTANCE}
    export CONFIG_IN_P4R=${CONFIG}
fi

no_color='\033[0m' # No Color
print_red='\033[0;31m'
print_green='\033[0;32m'
print_orange='\033[0;33m'
print_blue='\033[0;34m'

export argumentsCREATE="invest simul"
export argumentsFORMAT="invest optim simul postinvest"
export argumentsPOSTREAT="invest simul"
export argumentsHOTSTART="hotstart"

function read_python_status {
	if [[ -f "$1" ]]; then	
		echo $(head -n 1 $1) 
	fi
}

function sddp_status {
    if [[ -f "${INSTANCE}BellmanValuesOUT.csv" ]]; then
        echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - successfully ran SSV with SDDP solver (convergence OK).${no_color}"
    else
        if [[ -f "${INSTANCE}cuts.txt" ]]; then
            echo -e "${print_orange}$(date +'%m/%d/%Y %H:%M:%S') - partially ran SSV with SDDP solver${no_color}${print_red} (no convergence).${no_color}"
        else
            echo -e "${print_red}$(date +'%m/%d/%Y %H:%M:%S') - error while running sddp_solver.${no_color}"
            exit 3
        fi
    fi
}

function invest_status {
    if [[ -f "${INSTANCE}/results_invest/Solution_OUT.csv" ]]; then
        echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - successfully ran CEM with investment_solver.${no_color}"
    else
        echo -e "${print_red}$(date +'%m/%d/%Y %H:%M:%S') - error while running CEM with investment_solver.${no_color}"
        exit 4
    fi
}

start_time=$(date +'%m/%d/%Y %H:%M:%S')

rowsettings=$(awk -F ':' '$1=="    Scenarios"' ${CONFIG}/settings_format_optim.yml)
StrNbCommas=$(echo $rowsettings | grep -o ',' | wc -l)
let "NbCommas=$StrNbCommas"
NBSCEN_OPT=`expr $NbCommas + 1`
rowsettings=$(awk -F ':' '$1=="    Scenarios"' ${CONFIG}/settings_format_simul.yml)
StrNbCommas=$(echo $rowsettings | grep -o ',' | wc -l)
let "NbCommas=$StrNbCommas"
NBSCEN_SIM=`expr $NbCommas + 1`
rowsettings=$(awk -F ':' '$1=="    Scenarios"' ${CONFIG}/settings_format_invest.yml)
StrNbCommas=$(echo $rowsettings | grep -o ',' | wc -l)
let "NbCommas=$StrNbCommas"
NBSCEN_CEM=`expr $NbCommas + 1`
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - There are $NBSCEN_OPT scenarios for optimisation (bellman values computation) in this dataset ${no_color}"
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - There are $NBSCEN_SIM scenarios for simulation in this dataset ${no_color}"
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - There are $NBSCEN_CEM scenarios for investments optimisation in this dataset ${no_color}"
