#/bin/bash

# run script to create plan4res input dataset (ZV_ZoneValues.csv ...)
${P4R_ENV} python -W ignore ${PYTHONSCRIPTS}CreateInputPlan4res.py /${CONFIG}settingsCreateInputPlan4res_invest.yml ${DATASET}
python_script_return_status=$(read_python_status ${INSTANCE}python_return_status)
if [[ $python_script_return_status -ne 0 ]]; then
    echo -e "${print_red}Script exited with error code ${python_script_return_status}. See above error messages.${no_color}"
    exit $python_script_return_status
fi
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - plan4res input files created successfully.${no_color}"
