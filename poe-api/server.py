import os
import flask
import uuid
import json
from flask import request, jsonify, abort, Response
from flask_cors import CORS, cross_origin
from subprocess import STDOUT, PIPE, check_output

app = flask.Flask(__name__)
cors = CORS(app)
app.config["DEBUG"] = True

TEST_DOMAIN = "./test/cooperation.pddl"
TEST_PROBLEM = "./test/coop-problem.pddl"
SGPLAN_BIN = "./bin/sgplan522"
OPTIC_BIN = "./bin/optic-clp"

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
    domain_file_name = "./temp/{}".format(file_names[0])
    problem_file_name = "./temp/{}".format(file_names[1])
    domain_param = request.get_json()['domain']
    problem_param = request.get_json()['problem']

    # Write the domain
    with open(domain_file_name, 'w') as domain:
        domain.write(domain_param)
    # Write the problem
    with open(problem_file_name, 'w') as problem:
        problem.write(problem_param)

# Delete the temporary files
def delete_temp_files(file_names):
    os.remove("./temp/{}".format(file_names[0]))
    os.remove("./temp/{}".format(file_names[1]))

# Execute sgPlan
def execute_sgplan(file_names, timeout):
    domain_file_name = "./temp/{}".format(file_names[0])
    problem_file_name = "./temp/{}".format(file_names[1])
    
    try:
        output = check_output([SGPLAN_BIN, "-o", domain_file_name, "-f", problem_file_name],  stderr=STDOUT, timeout=timeout)
    except Exception as err:
        output = err.output

    return output

# Execute optic
def execute_optic(file_names, timeout):
    domain_file_name = "./temp/{}".format(file_names[0])
    problem_file_name = "./temp/{}".format(file_names[1])
    
    try:
        output = check_output([ "timeout", "{}s".format(timeout), OPTIC_BIN, domain_file_name, problem_file_name], stderr=STDOUT, timeout=timeout+0.1)
    except Exception as err:
        output = err.output
    
    return output

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
            output = execute_sgplan(file_names, timeout)
        elif planner == "optic":
            output = execute_optic(file_names, timeout)
        else:
            print("Planner {} is not supported".format(planner))
    except Exception as err:
        raise err
    finally:
        # Clear temp files
        delete_temp_files(file_names)
        
    return output.decode("utf-8").replace("\n", "<br>")
        

@app.errorhandler(500)
def internal_error(err):
    print(err)
    return "There was an error executing your request. Review the parameters added to the domain and problem. ({})".format(str(err)), 500

@app.route('/run/sgplan', methods=['POST'])
def run_sgplan():
    try:
        return execute_planner('sgplan'), 200
    except Exception as err:
        abort(500, err)

@app.route('/run/optic', methods=['POST'])
def run_optic():
    try:
        return execute_planner('optic'), 200
    except Exception as err:
        abort(500, err)

app.run(host='0.0.0.0', port = int(os.environ.get('PORT', 5000)))