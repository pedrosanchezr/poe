import flask
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


@app.route('/', methods=['GET'])
def home():
    return "<h1>Hello world!</h1>"

@app.route('/run/sgplan', methods=['GET'])
def run_sgplan():
    # Uses the timeout especified unless it's not present or higher than MAX_TIMEOUT
    if 'timeout' in request.args and int(request.args['timeout']) <= MAX_TIMEOUT:
        timeout = int(request.args['timeout'])
    else:
        timeout = DEFAULT_TIMEOUT_SECS
    
    # Execute the command with the given timeout
    try:
        output = check_output([SGPLAN_BIN, "-o", TEST_DOMAIN, "-f", TEST_PROBLEM], stderr=STDOUT, timeout=timeout)
    except:
        print("Timeout of {} seconds reached".format(timeout))

    return output.decode("utf-8").replace("\n", "<br>")

@app.route('/run/optic', methods=['GET'])
def run_optic():
    # Uses the timeout especified unless it's not present or higher than MAX_TIMEOUT
    if 'timeout' in request.args and int(request.args['timeout']) <= MAX_TIMEOUT:
        timeout = int(request.args['timeout'])
    else:
        timeout = DEFAULT_TIMEOUT_SECS
    
    # Execute the command with the given timeout
    try:
        output = check_output([ "timeout", "{}s".format(timeout), OPTIC_BIN, TEST_DOMAIN, TEST_PROBLEM], stderr=STDOUT, timeout=timeout+0.1)
    except Exception as err:
        output = err.output

    return output.decode("utf-8").replace("\n", "<br>")

app.run()