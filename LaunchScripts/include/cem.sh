#/bin/bash


# in case sddp has not converged, use cuts instead of bellmanvaluesout
cp ${INSTANCE}/results_invest/cuts.txt ${INSTANCE}/results_invest/bellmanvalues.csv
cp ${INSTANCE}/results_invest/BellmanValuesOUT.csv ${INSTANCE}/results_invest/bellmanvalues.csv

# bellman values may have been computed for more ssv timestpeps than required => remove them
LASTSTEP=$(ls -l ${INSTANCE}/nc4_invest/Block*.nc4 | wc -l)
awk -v laststep=$LASTSTEP -F ',' '$1 < laststep' ${INSTANCE}/results_invest/bellmanvalues.csv > temp.csv
echo -e "${print_blue} - remove Bellman values after $LASTSTEP steps since they will not be used by the CEM${no_color}\n"
mv temp.csv ${INSTANCE}/results_invest/bellmanvalues.csv
 
mkdir ${INSTANCE}/results_invest/Demand
mkdir ${INSTANCE}/results_invest/Volume
mkdir ${INSTANCE}/results_invest/MarginalCosts
mkdir ${INSTANCE}/results_invest/Flows
mkdir ${INSTANCE}/results_invest/ActivePower
mkdir ${INSTANCE}/results_invest/Primary
mkdir ${INSTANCE}/results_invest/Secondary
mkdir ${INSTANCE}/results_invest/MaxPower


# run investment solver
echo -e "\n${print_orange} - run CEM using investment_solver:${no_color}${P4R_ENV} investment_solver -l ${INSTANCE_IN_P4R}/results_invest/bellmanvalues.csv -o -e -S ${CONFIG_IN_P4R}/BSPar-Investment.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_invest/ ${INSTANCE_IN_P4R}/nc4_invest/InvestmentBlock.nc4"
${P4R_ENV} investment_solver -l ${INSTANCE_IN_P4R}/results_invest/bellmanvalues.csv -o -e -S ${CONFIG_IN_P4R}/BSPar-Investment.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_invest/ ${INSTANCE_IN_P4R}/nc4_invest/InvestmentBlock.nc4
invest_status ./
mv Solution_OUT.csv ${INSTANCE}/results_invest/

for (( scen=0; scen<$NBSCEN_CEM; scen++ ))
do 
	mv Demand_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/Demand/Demand${scen}.csv
	mv Volume_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/Volume/Volume${scen}.csv
	mv MarginalCostActivePowerDemand_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/MarginalCosts/MarginalCostActivePowerDemand${scen}.csv
	mv MarginalCostFlows_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/MarginalCosts/MarginalCostFlows${scen}.csv
	mv MarginalCostInertia_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/MarginalCosts/MarginalCostInertia${scen}.csv
	mv MarginalCostPrimary_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/MarginalCosts/MarginalCostPrimary${scen}.csv
	mv MarginalCostSecondary_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/MarginalCosts/MarginalCostSecondary${scen}.csv
	mv Flows_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/Flows/Flows${scen}.csv
	mv ActivePower_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/ActivePower/ActivePower${scen}.csv
	mv MaxPower_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/MaxPower/MaxPower${scen}.csv
	mv Primary_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/Primary/Primary${scen}.csv
	mv Secondary_Scen${scen}_OUT.csv ${INSTANCE}/results_invest/Secondary/Secondary${scen}.csv
done
rm uc.lp
