import os

from subprocess import STDOUT, PIPE, check_output, CalledProcessError
from  execution import planner_exec

# CONSTANTS
OPTIC_BIN = "./bin/optic-clp"

# Execute optic
def execute(file_names, timeout):
    domain_file_name = os.path.join(planner_exec.TEMP_FOLDER, file_names[0])
    problem_file_name = os.path.join(planner_exec.TEMP_FOLDER, file_names[1])

    try:
        output = check_output([ "timeout", "{}s".format(timeout), OPTIC_BIN, domain_file_name, problem_file_name], stderr=STDOUT, timeout=timeout+0.1)
    except CalledProcessError as err:
        output = err.output
    
    return output
