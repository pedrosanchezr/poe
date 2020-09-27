import uuid
import os
from flask import request

TEMP_FOLDER = './temp'

# Return a tuple with the domain and problem file names
def get_file_names():
    uuid_str = str(uuid.uuid4())
    domain_file_name = "domain_{}.pddl".format(uuid_str)
    problem_file_name = "problem_{}.pddl".format(uuid_str)
    return (domain_file_name, problem_file_name)

# Write temp files with the domain and problem received
def write_temp_files(file_names, domain_param, problem_param):
    domain_file_name = os.path.join(TEMP_FOLDER, file_names[0])
    problem_file_name = os.path.join(TEMP_FOLDER, file_names[1])

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

# Prepare the temporary files getting generating the names and saving the content
def prepare_temp_files():
    domain_param = request.get_json()['domain']
    problem_param = request.get_json()['problem']
    
    # Saves the domain and problem in temp
    if domain_param and problem_param:
        file_names = get_file_names()
        write_temp_files(file_names, domain_param, problem_param)
        return file_names
    else:
        return "Domain or Problem was not received"