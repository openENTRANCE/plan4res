#/bin/bash

# update sddp_solver configuration file to account for number of scenarios
echo -e "\n${print_blue} - Update sddp_solver configuration file to account for number of scenarios${no_color}"
newNbScen=$NBSCEN
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
	echo -e "\n${print_blue} - Run Hotstart SSV with sddp_solver to compute Bellman values for storages: ${no_color}${P4R_ENV} sddp_solver -S ${CONFIG}sddp_solver.txt -c ${CONFIG} -p ${INSTANCE}nc4_optim/ ${INSTANCE}nc4_optim/SDDPBlock.nc4"
	${P4R_ENV} sddp_solver -l ${INSTANCE}cuts.txt -S ${CONFIG}sddp_solver.txt -c ${CONFIG} -p ${INSTANCE}nc4_optim/ ${INSTANCE}nc4_optim/SDDPBlock.nc4
else
	echo -e "\n${print_blue} - Run SSV with sddp_solver to compute Bellman values for storages: ${no_color}${P4R_ENV} sddp_solver -S ${CONFIG}sddp_solver.txt -c ${CONFIG} -p ${INSTANCE}nc4_optim/ ${INSTANCE}nc4_optim/SDDPBlock.nc4"
	${P4R_ENV} sddp_solver -S ${CONFIG}sddp_solver.txt -c ${CONFIG} -p ${INSTANCE}nc4_optim/ ${INSTANCE}nc4_optim/SDDPBlock.nc4
fi
sddp_status ./

mv Bellman* ${INSTANCE}
mv cuts.txt ${INSTANCE}
rm regressors.sddp.* visited_states.sddp.* cuts.sddp* uc.lp