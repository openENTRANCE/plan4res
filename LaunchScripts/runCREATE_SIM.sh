#/bin/bash

# this script launches creation of plan4res dataset for a run without investment (set of csv files) 
source include/include.sh
echo -e "\n${print_green}Launching plan4res dataset creation for $DATASET - [$start_time]${no_color}"

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
echo -e "\n${print_orange}Step 1 - Create plan4res input files: ${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}CreateInputPlan4res.py /${CONFIG}settingsCreateInputPlan4res_simul.yml ${DATASET}"
source scripts/include/createSIM.sh 

