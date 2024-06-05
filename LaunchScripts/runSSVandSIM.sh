#/bin/bash

# this scripts:
# 1 - creates plan4res dataset, 
# 2 - creates nc4 files for SSV
# 3 - launches SSV 
# 4 - creates nc4 files for SIM
# 5 - launches SIM 
# 6 - launches post treatments

source include/utils.sh

# run script to create plan4res input dataset (ZV_ZineValues.csv ...)
# comment if you are using handmade datasets
phasecreate="simul"
echo -e "\n${print_orange}Step 1 - Create plan4res input files"
source scripts/include/create.sh 

# run script to create netcdf files for ssv
# comment if you are using aleady created nc4
phaseformat="optim"
echo -e "\n${print_orange}Step 2 - Create netcdf input files to run the SSV"
source scripts/include/format.sh 

# run sddp solver
echo -e "\n${print_orange}Step 3 - run SSV "
source scripts/include/ssv.sh

rm -r ${INSTANCE}results_simul
mkdir ${INSTANCE}results_simul

# in case sddp has not converged, use cuts instead of bellmanvaluesout
cp ${INSTANCE}cuts.txt ${INSTANCE}results_simul/
cp ${INSTANCE}BellmanValuesOUT.csv ${INSTANCE}results_simul/

# run formatting script to create netcdf input files for the SIM
phaseformat="simul"
echo -e "\n${print_orange}Step 4 - Create netcdf input files to run the SIM"
rm -r ${INSTANCE}nc4_simul
source scripts/include/format.sh

# run simulations using sddp_solver
echo -e "\n${print_orange}Step 5 - run SIM using sddp_solver"
source scripts/include/sim.sh
# alternative: run simulations using investment_solver
#echo -e "\n${print_orange}Step 5 - run SIM using investment_solver"
#source scripts/include/simCEM.sh

# run post treatment script
phasepostreat="simul"
echo -e "\n${print_orange}Step 6 - launch post treat"
source scripts/include/postreat.sh





