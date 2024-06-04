#/bin/bash

# this script launches creation of nc4 files for running investment_solver 
source include/include.sh
echo -e "\n${print_green}Launching netcdf dataset creation for $DATASET - [$start_time]${no_color}"

echo -e "\n${print_orange}Step 1 - Create netcdf input files to run the CEM: ${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}format.py /${CONFIG}settings_format_invest.yml /${CONFIG}settingsCreateInputPlan4res_invest.yml ${DATASET}"
# run formatting script to create netcdf input files
source scripts/include/formatCEM.sh