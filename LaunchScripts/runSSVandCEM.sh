#/bin/bash

#/bin/bash

# this scripts:
# 1 - creates plan4res dataset, 
# 2 - creates nc4 files for SSV
# 3 - launches SSV 
# 4 - creates nc4 files for CEM
# 5 - launches CEM 
# 6 - launches post treatments

source include/utils.sh

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
# comment if you are using handmade datasets
phasecreate="invest"
echo -e "\n${print_orange}Step 1 - Create plan4res input files ${no_color}"
source include/create.sh 

# run script to create netcdf files for ssv
# comment if you are using aleady created nc4
echo -e "\n${print_orange}Step 2 - Create netcdf input files to run the SSV "
phaseformat="optim"
source include/format.sh 


# run sddp solver
echo -e "\n${print_orange}Step 3 - run SSV with sddp_solver to compute Bellman values for storages${no_color}"
source include/ssv.sh

rm -r ${INSTANCE}/results_invest
mkdir ${INSTANCE}/results_invest

# in case sddp has not converged, use cuts instead of bellmanvaluesout
cp ${INSTANCE}/cuts.txt ${INSTANCE}/results_invest/
cp ${INSTANCE}/BellmanValuesOUT.csv ${INSTANCE}/results_invest/

# run formatting script to create netcdf input files for the investment model
echo -e "\n${print_orange}Step 4 - Create netcdf input files to run the CEM ${no_color}"
rm -r ${INSTANCE}/nc4_invest
phaseformat="invest"
source include/format.sh

# run investment solver
echo -e "\n${print_orange}Step 5 - run CEM using investment_solver${no_color}"
source include/cem.sh

# run post treatment script
phasepostreat="invest"
echo -e "\n${print_orange}Step 6 - launch post treat${no_color}"
source include/postreat.sh