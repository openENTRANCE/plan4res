#/bin/bash

# this script launches creation of nc4 files for running sddp_solver or investment_solver in simulation mode
source include/include.sh
echo -e "\n${print_green}Launching netcdf dataset creation for $DATASET - [$start_time]${no_color}"

echo -e "\n${print_orange}Step 1 - Create netcdf input files to run the SIM: ${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}format.py /${CONFIG}settings_format_simul.yml /${CONFIG}settingsCreateInputPlan4res_simul.yml ${DATASET}"
# run formatting script to create netcdf input files
source scripts/include/formatSIM.sh