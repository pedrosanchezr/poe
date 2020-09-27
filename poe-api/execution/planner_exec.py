import uuid
import os
from flask import request

# Executors for each planner implemented
from execution import sgplan, optic

# CONSTANTS
TEMP_FOLDER = './temp'
TEST_DOMAIN = "./test/cooperation.pddl"
TEST_PROBLEM = "./test/coop-problem.pddl"

DEFAULT_TIMEOUT_SECS = 2
MAX_TIMEOUT = 20


# Return a tuple with the domain and problem file names
def get_file_names():
    uuid_str = str(uuid.uuid4())
    domain_file_name = "domain_{}.pddl".format(uuid_str)
    problem_file_name = "problem_{}.pddl".format(uuid_str)
    return (domain_file_name, problem_file_name)

# Write temp files with the domain and problem received
def write_temp_files(file_names):
    domain_file_name = os.path.join(TEMP_FOLDER, file_names[0])
    problem_file_name = os.path.join(TEMP_FOLDER, file_names[1])
    domain_param = request.get_json()['domain']
    problem_param = request.get_json()['problem']

    # Write the domain
    with open(domain_file_name, 'w+') as domain:
        domain.write(domain_param)
    # Write the problem
    with open(problem_file_name, 'w+') as problem:
        problem.write(problem_param)

# Delete the temporary files
def delete_temp_files(file_names):
    os.remove(os.path.join(TEMP_FOLDER, file_names[0]))
    os.remove(os.path.join(TEMP_FOLDER, file_names[1]))

# Execute by planner
def execute_planner(planner):
    domain_param = request.get_json()['domain']
    problem_param = request.get_json()['problem']
    timeout_param = request.get_json()['timeout']

    # Uses the timeout especified unless it's not present or higher than MAX_TIMEOUT
    if timeout_param and int(timeout_param) <= MAX_TIMEOUT:
        timeout = int(timeout_param)
    else:
        timeout = DEFAULT_TIMEOUT_SECS
    
    # Saves the domain and problem in temp
    if domain_param and problem_param:
        file_names = get_file_names()
        write_temp_files(file_names)
    else:
        return "Domain or Problem was not received"

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
        delete_temp_files(file_names)
        
    return output.decode("utf-8").replace("\n", "<br>")
        