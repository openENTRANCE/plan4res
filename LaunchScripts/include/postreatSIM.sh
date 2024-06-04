#/bin/bash

# run post treatment script
${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}PostTreatPlan4res.py /${CONFIG}settingsPostTreatPlan4res_simul.yml /${CONFIG}settings_format_simul.yml /${CONFIG}settingsCreateInputPlan4res_simul.yml ${DATASET}
python_script_return_status=$(read_python_status ${INSTANCE}python_return_status)
if [[ $python_script_return_status -ne 0 ]]; then
    echo -e "${print_red}Script exited with error code ${python_return_status}. See above error messages.${no_color}"
    exit $python_script_return_status
fi
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - post treat successful.${no_color}\n"

