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


# run investment solver
${P4R_ENV} investment_solver -s -l ${INSTANCE_IN_P4R}/results_simul/bellmanvalues.csv -o -S ${CONFIG_IN_P4R}BSPar-Investment.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_simul/ ${INSTANCE_IN_P4R}/nc4_simul/InvestmentBlock.nc4

${P4R_ENV} mv *_OUT.csv ${INSTANCE_IN_P4R}/
for (( scen=0; scen<$NBSCEN_SIM; scen++ ))
do 
	mv ${INSTANCE}Demand_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Demand/Demand${scen}.csv
	mv ${INSTANCE}Volume_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Volume/Volume${scen}.csv
	mv ${INSTANCE}MarginalCostActivePowerDemand_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostActivePowerDemand${scen}.csv
	mv ${INSTANCE}MarginalCostFlows_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostFlows${scen}.csv
	mv ${INSTANCE}MarginalCostInertia_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostInertia${scen}.csv
	mv ${INSTANCE}MarginalCostPrimary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostPrimary${scen}.csv
	mv ${INSTANCE}MarginalCostSecondary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostSecondary${scen}.csv
	mv ${INSTANCE}Flows_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Flows/Flows${scen}.csv
	mv ${INSTANCE}ActivePower_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/ActivePower/ActivePower${scen}.csv
	mv ${INSTANCE}MaxPower_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MaxPower/MaxPower${scen}.csv
	mv ${INSTANCE}Primary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Primary/Primary${scen}.csv
	mv ${INSTANCE}Secondary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Secondary/Secondary${scen}.csv
done
rm uc.lp
