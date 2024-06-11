#/bin/bash


# in case sddp has not converged, use cuts instead of bellmanvaluesout
cp ${INSTANCE}/results_simul/cuts.txt ${INSTANCE}/results_simul/bellmanvalues.csv
cp ${INSTANCE}/results_simul/BellmanValuesOUT.csv ${INSTANCE}/results_simul/bellmanvalues.csv

# bellman values may have been computed for more ssv timestpeps than required => remove them
LASTSTEP=$(ls -l ${INSTANCE}/nc4_simul/Block*.nc4 | wc -l)
awk -v laststep=$LASTSTEP -F ',' '$1 < laststep' ${INSTANCE}/results_simul/bellmanvalues.csv > temp.csv
echo -e "${print_blue} - remove Bellman values after $LASTSTEP steps since they will not be used by the CEM${no_color}\n"
mv temp.csv ${INSTANCE}/results_simul/bellmanvalues.csv
 
mkdir ${INSTANCE}/results_simul/Demand
mkdir ${INSTANCE}/results_simul/Volume
mkdir ${INSTANCE}/results_simul/MarginalCosts
mkdir ${INSTANCE}/results_simul/Flows
mkdir ${INSTANCE}/results_simul/ActivePower
mkdir ${INSTANCE}/results_simul/Primary
mkdir ${INSTANCE}/results_simul/Secondary
mkdir ${INSTANCE}/results_simul/MaxPower


# run investment solver
${P4R_ENV} investment_solver -s -l ${INSTANCE}/results_simul/bellmanvalues.csv -o -S ${CONFIG}BSPar-Investment.txt -c ${CONFIG} -p ${INSTANCE}/nc4_simul/ ${INSTANCE}/nc4_simul/InvestmentBlock.nc4

for (( scen=0; scen<$NBSCEN_SIM; scen++ ))
do 
	mv Demand_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Demand/Demand${scen}.csv
	mv Volume_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Volume/Volume${scen}.csv
	mv MarginalCostActivePowerDemand_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostActivePowerDemand${scen}.csv
	mv MarginalCostFlows_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostFlows${scen}.csv
	mv MarginalCostInertia_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostInertia${scen}.csv
	mv MarginalCostPrimary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostPrimary${scen}.csv
	mv MarginalCostSecondary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MarginalCosts/MarginalCostSecondary${scen}.csv
	mv Flows_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Flows/Flows${scen}.csv
	mv ActivePower_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/ActivePower/ActivePower${scen}.csv
	mv MaxPower_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/MaxPower/MaxPower${scen}.csv
	mv Primary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Primary/Primary${scen}.csv
	mv Secondary_Scen${scen}_OUT.csv ${INSTANCE}/results_simul/Secondary/Secondary${scen}.csv
done
rm uc.lp
