import uuid
import os
from flask import request

from filesmgr import files_manager

# Executors for each planner implemented
from execution import sgplan, optic

# CONSTANTS
DEFAULT_TIMEOUT_SECS = 2
MAX_TIMEOUT = 20

def execute_planner(planner, timeout_param, domain, problem):
    """Execute the problem on the planner requested"""

    # Uses the timeout especified unless it's not present or higher than MAX_TIMEOUT
    if timeout_param and int(timeout_param) <= MAX_TIMEOUT:
        timeout = int(timeout_param)
    else:
        timeout = DEFAULT_TIMEOUT_SECS
    
    # Saves the domain and problem in temp
    file_names = files_manager.prepare_temp_files(domain, problem)

    try:
        # Execute the planner
        if planner == "sgplan":
            output = sgplan.execute(file_names, timeout)
        elif planner == "optic":
            output = optic.execute(file_names, timeout)
        else:
            print("Planner {} is not supported".format(planner))
    except Exception as err:
        raise err
    finally:
        # Clear temp files
        files_manager.delete_temp_files(file_names)

    if output:
        return output.decode("utf-8").replace("\n", "<br>")
    else:
        return output
        