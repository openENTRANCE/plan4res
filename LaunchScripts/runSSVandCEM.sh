#/bin/bash

#/bin/bash

# this scripts:
# 1 - creates plan4res dataset, 
# 2 - creates nc4 files for SSV
# 3 - launches SSV 
# 4 - creates nc4 files for CEM
# 5 - launches CEM 
# 6 - launches post treatments

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

rm -r ${INSTANCE}results_invest
mkdir ${INSTANCE}results_invest

# in case sddp has not converged, use cuts instead of bellmanvaluesout
cp ${INSTANCE}cuts.txt ${INSTANCE}results_invest/
cp ${INSTANCE}BellmanValuesOUT.csv ${INSTANCE}results_invest/

# run formatting script to create netcdf input files for the investment model
echo -e "\n${print_orange}Step 4 - Create netcdf input files to run the CEM: ${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}format.py /${CONFIG}settings_format_invest.yml /${CONFIG}settingsCreateInputPlan4res_invest.yml ${DATASET}"
rm -r ${INSTANCE}nc4_invest
source scripts/include/formatCEM.sh

# run investment solver
echo -e "\n${print_orange}Step 5 - run CEM using investment_solver:${no_color}${P4R_ENV} investment_solver -l ${INSTANCE}results_invest/bellmanvalues.csv -o -e -S ${CONFIG}BSPar-Investment.txt -c ${CONFIG} -p ${INSTANCE}nc4_invest/ ${INSTANCE}nc4_invest/InvestmentBlock.nc4"
source scripts/include/cem.sh

# run post treatment script
echo -e "\n${print_orange}Step 6 - launch post treat:${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}PostTreatPlan4res.py /${CONFIG}settingsPostTreatPlan4res_invest.yml /${CONFIG}settings_format_invest.yml /${CONFIG}settingsCreateInputPlan4res_invest.yml ${DATASET}"
source scripts/include/postreatCEM.sh