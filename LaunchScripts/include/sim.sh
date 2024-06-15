#/bin/bash

# in case sddp has not converged, use cuts instead of bellmanvaluesout
cp ${INSTANCE}/results_simul/cuts.txt ${INSTANCE}/results_simul/bellmanvalues.csv
cp ${INSTANCE}/results_simul/BellmanValuesOUT.csv ${INSTANCE}/results_simul/bellmanvalues.csv

# bellman values may have been computed for more ssv timestpeps than required => remove them
LASTSTEP=$(ls -l ${INSTANCE}/nc4_simul/Block*.nc4 | wc -l)
awk -v laststep=$LASTSTEP -F ',' '$1 < laststep' ${INSTANCE}/results_simul/bellmanvalues.csv > ${INSTANCE}/results_simul/temp.csv
echo -e "${print_blue} - remove Bellman values after $LASTSTEP steps since they will not be used by the CEM${no_color}\n"
mv ${INSTANCE}/results_simul/temp.csv ${INSTANCE}/results_simul/bellmanvalues.csv
 
mkdir ${INSTANCE}/results_simul/Demand
mkdir ${INSTANCE}/results_simul/Volume
mkdir ${INSTANCE}/results_simul/MarginalCosts
mkdir ${INSTANCE}/results_simul/Flows
mkdir ${INSTANCE}/results_simul/ActivePower
mkdir ${INSTANCE}/results_simul/Primary
mkdir ${INSTANCE}/results_simul/Secondary
mkdir ${INSTANCE}/results_simul/MaxPower


# run simulation
for (( scen=0; scen<$NBSCEN_SIM; scen++ ))
do
	echo -e "\n${print_blue} - run simulation for scenario $scen ${no_color}"
	${P4R_ENV} sddp_solver -l ${INSTANCE_IN_P4R}/results_simul/bellmanvalues.csv -s -i ${scen} -S ${CONFIG_IN_P4R}/sddp_greedy.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_simul/ ${INSTANCE_IN_P4R}/nc4_simul/SDDPBlock.nc4
	${P4R_ENV} mv *OUT.csv ${INSTANCE}/
	mv ${INSTANCE}/DemandOUT.csv ${INSTANCE}/results_simul/Demand/Demand${scen}.csv
	mv ${INSTANCE}/VolumeOUT.csv ${INSTANCE}/results_simul/Volume/Volume${scen}.csv
	mv ${INSTANCE}/MarginalCostActivePowerDemandOUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostActivePowerDemand${scen}.csv
	mv ${INSTANCE}/MarginalCostFlowsOUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostFlows${scen}.csv
	mv ${INSTANCE}/FlowsOUT.csv ${INSTANCE}/results_simul/Flows/Flows${scen}.csv
	mv ${INSTANCE}/ActivePowerOUT.csv ${INSTANCE}/results_simul/ActivePower/ActivePower${scen}.csv
	mv ${INSTANCE}/MarginalCostInertiaOUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostInertia${scen}.csv
	mv ${INSTANCE}/MarginalCostPrimaryOUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostPrimary${scen}.csv
	mv ${INSTANCE}/MarginalCostSecondaryOUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostSecondary${scen}.csv
	mv ${INSTANCE}/MaxPowerOUT.csv ${INSTANCE}/results_simul/MaxPower/MaxPower${scen}.csv
	mv ${INSTANCE}/PrimaryOUT.csv ${INSTANCE}/results_simul/Primary/Primary${scen}.csv
	mv ${INSTANCE}/SecondaryOUT.csv ${INSTANCE}/results_simul/Secondary/Secondary${scen}.csv
	rm uc.lp
done 
echo -e "\n${print_blue}- simulations completed"
