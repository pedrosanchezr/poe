import os
import flask
import uuid
from flask import request, jsonify
from subprocess import STDOUT, check_output

app = flask.Flask(__name__)
app.config["DEBUG"] = True

TEST_DOMAIN = "./test/cooperation.pddl"
TEST_PROBLEM = "./test/coop-problem.pddl"
SGPLAN_BIN = "./bin/sgplan522"
OPTIC_BIN = "./bin/optic-clp"

DEFAULT_TIMEOUT_SECS = 2
MAX_TIMEOUT = 20

# Return a tuple with the domain and problem file names
def get_file_names():
    uuid = str(uuid.uuid4())
    domain_file_name = "domain_{}.pddl".format(uuid)
    problem_file_name = "problem_{}.pddl".format(uuid)
    return (domain_file_name, problem_file_name)

# Write temp files with the domain and problem received
def write_temp_files(file_names):
    domain_file_name = "./temp/{}".format(file_names[0])
    problem_file_name = "./temp/{}".format(file_names[1])

    # Write the domain
    with open(domain_file_name, 'w') as domain:
        domain.write(request.form['domain'])
    # Write the problem
    with open(problem_file_name, 'w') as problem:
        problem.write(request.form['problem'])

# Delete the temporary files
def delete_temp_files(file_names):
    os.remove("./temp/{}".format(file_names[0]))
    os.remove("./temp/{}".format(file_names[1]))

# Execute sgPlan
def execute_sgplan(file_names, timeout):
    domain_file_name = "./temp/{}".format(file_names[0])
    problem_file_name = "./temp/{}".format(file_names[1])
    
    try:
        output = check_output([SGPLAN_BIN, "-o", domain_file_name, "-f", problem_file_name], stderr=STDOUT, timeout=timeout)
    except:
        print("Timeout of {} seconds reached".format(timeout))

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
    # Uses the timeout especified unless it's not present or higher than MAX_TIMEOUT
    if 'timeout' in request.form and int(request.form['timeout']) <= MAX_TIMEOUT:
        timeout = int(request.form['timeout'])
    else:
        timeout = DEFAULT_TIMEOUT_SECS
    
    # Saves the domain and problem in temp
    if 'domain' in request.form and 'problem' in request.form:
        file_names = get_file_names()
        write_temp_files(file_names)
    else:
        return "Domain or Problem was not received"

    # Execute the planner
    if planner == "sgplan":
        output = execute_sgplan(file_names, timeout)
    elif planner == "optic":
        output = execute_optic(file_names, timeout)
    else:
        print("Planner {} is not supported".format(planner))
    
    # Clear temp files
    delete_temp_files(file_names)
        
    return output.decode("utf-8").replace("\n", "<br>")
        

@app.route('/', methods=['GET'])
def home():
    return "<h1>Hello world!</h1>"

@app.route('/run/sgplan', methods=['POST'])
def run_sgplan():
    execute_planner('sgplan')

@app.route('/run/optic', methods=['POST'])
def run_optic():
    execute_planner('optic')

app.run(host='0.0.0.0', port = int(os.environ.get('PORT', 5000)))