import os

from subprocess import STDOUT, PIPE, check_output, CalledProcessError
from  execution import planner_exec

# CONSTANTS
SGPLAN_BIN = "./bin/sgplan522"

# Execute sgPlan
def execute(file_names, timeout):
    domain_file_name = os.path.join(planner_exec.TEMP_FOLDER, file_names[0])
    problem_file_name = os.path.join(planner_exec.TEMP_FOLDER, file_names[1])
    
    try:
        output = check_output([SGPLAN_BIN, "-o", domain_file_name, "-f", problem_file_name],  stderr=STDOUT, timeout=timeout)
    except CalledProcessError as err:
        output = err.output

    return output