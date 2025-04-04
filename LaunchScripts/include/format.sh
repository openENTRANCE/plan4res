#/bin/bash

echo -e "${print_blue}\nEntering LaunchFORMAT${no_color}"

# run formatting script to create netcdf input files for running the cem
echo -e "\n${print_orange}Create netcdf input files: ${no_color}${P4R_ENV} python -W ignore${PYTHONSCRIPTS_IN_P4R}/format.py ${CONFIG_IN_P4R}/settings_format_${phaseformat}.yml ${CONFIG_IN_P4R}/settingsCreateInputPlan4res_${phasecreate}.yml ${DATASET}"
${P4R_ENV} python -W ignore ${PYTHONSCRIPTS_IN_P4R}/format.py ${CONFIG_IN_P4R}/settings_format_${phaseformat}.yml ${CONFIG_IN_P4R}/settingsCreateInputPlan4res_${phasecreate}.yml ${DATASET}
python_script_return_status=$(read_python_status ${INSTANCE}python_return_status)
if [[ $python_script_return_status -ne 0 ]]; then
    echo -e "${print_red}Script exited with error code ${python_script_return_status}. See above error messages.${no_color}"
    exit $python_script_return_status
fi
echo -e "${print_green}$(date +'%m/%d/%Y %H:%M:%S') - netcdf input files created successfully.${no_color}\n"

