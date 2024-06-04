#/bin/bash

# this scripts:
# 1 - creates plan4res dataset, 
# 2 - creates nc4 files 
# 3 - launches SSV alone

source include/include.sh

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
# comment if you are using handmade datasets
echo -e "\n${print_orange}Step 1 - Create plan4res input files: ${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}CreateInputPlan4res.py /${CONFIG}settingsCreateInputPlan4res_simul.yml ${DATASET}"
source scripts/include/createSIM.sh 

# run script to create netcdf files for ssv
# comment if you are using aleady created nc4
echo -e "\n${print_orange}Step 2 - Create netcdf input files to run the SSV: ${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}format.py /${CONFIG}settings_format_optim.yml /${CONFIG}settingsCreateInputPlan4res_invest.yml ${DATASET}"
source scripts/include/formatSSV.sh 

# run sddp solver
echo -e "\n${print_orange}Step 3 - run SSV with sddp_solver to compute Bellman values for storages:${no_color}${P4R_ENV} sddp_solver -S ${CONFIG}sddp_solver.txt -c ${CONFIG} -p ${INSTANCE}nc4_optim/ ${INSTANCE}nc4_optim/SDDPBlock.nc4"
source scripts/include/ssv.sh

# alternative: run sddp_solver with hotstart
# comment the 2 lignes above and uncomment the 2 lignes below
#echo -e "\n${print_orange}Step 3 - run (hotstart) SSV with sddp_solver to compute Bellman values for storages:${no_color}${P4R_ENV} sddp_solver -S ${CONFIG}sddp_solver.txt -c ${CONFIG} -p ${INSTANCE}nc4_optim/ ${INSTANCE}nc4_optim/SDDPBlock.nc4"
#source ssvHOTSTART.sh
