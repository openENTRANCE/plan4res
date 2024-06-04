#/bin/bash

# this script runs the posttreatment script on investment results
source include/include.sh
echo -e "\n${print_green}Launching post-treatment for $DATASET - [$start_time]${no_color}"

echo -e "\n${print_orange}Step 1 - launch post treat:${no_color}${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}PostTreatPlan4res.py /${CONFIG}settingsPostTreatPlan4res_invest.yml /${CONFIG}settings_format_invest.yml /${CONFIG}settingsCreateInputPlan4res_invest.yml ${DATASET}"
source scripts/include/postreatCEM.sh