#/bin/bash

# update sddp_solver configuration file to account for number of scenarios
echo -e "\n${print_blue} - Update sddp_solver configuration file to account for number of scenarios${no_color}"
newNbScen=$NBSCEN_OPT
rowconfig=$(grep "intNbSimulCheckForConv" ${CONFIG}sddp_solver.txt)
intNbSimulCheckForConv=$(echo "$rowconfig" | cut -d ' ' -f 2-)
let "oldNbScen=$intNbSimulCheckForConv"
toreplace="$oldNbScen"
replacement="$newNbScen"
newrowconfig=${rowconfig/"$toreplace"/"$replacement"}
sed -i "s/$rowconfig/$newrowconfig/g" "${CONFIG}sddp_solver.txt"
echo -e "${print_blue} - successfully updated sddp_solver.txt configuration file to account for number of scenarios: $oldNbScen, replaced by $newNbScen.${no_color}"

# run sddp solver
if [[ "$@" == *"HOTSTART"* ]]; then
	# run in hotstart
	echo -e "\n${print_blue} - Run SSV with sddp_solver to compute Bellman values for storages: ${no_color}"
	echo -e "\n$${P4R_ENV}sddp_solver -l ${INSTANCE_IN_P4R}/cuts.txt -S ${CONFIG_IN_P4R}/sddp_solver.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_optim/ ${INSTANCE_IN_P4R}/nc4_optim/SDDPBlock.nc4"
	${P4R_ENV} sddp_solver -l ${INSTANCE_IN_P4R}/cuts.txt -S ${CONFIG_IN_P4R}/sddp_solver.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_optim/ ${INSTANCE_IN_P4R}/nc4_optim/SDDPBlock.nc4
else
	echo -e "\n${print_blue} - Run SSV with sddp_solver to compute Bellman values for storages: ${no_color}"
	echo -e "\n$${P4R_ENV}sddp_solver -S ${CONFIG_IN_P4R}/sddp_solver.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_optim/ ${INSTANCE_IN_P4R}/nc4_optim/SDDPBlock.nc4"
	${P4R_ENV} sddp_solver -S ${CONFIG_IN_P4R}/sddp_solver.txt -c ${CONFIG_IN_P4R} -p ${INSTANCE_IN_P4R}/nc4_optim/ ${INSTANCE_IN_P4R}/nc4_optim/SDDPBlock.nc4
fi
sddp_status ./

mv Bellman* ${INSTANCE}
mv cuts.txt ${INSTANCE}
rm regressors.sddp.* visited_states.sddp.* cuts.sddp* uc.lp
