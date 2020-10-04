import flask
import json
import os

from flask import request, jsonify, abort, Response, url_for
from flask_cors import CORS, cross_origin
from flask_restplus import Api, Resource, fields
from werkzeug.contrib.fixers import ProxyFix
from execution import planner_exec

flask_app = flask.Flask(__name__)
app = Api(app = flask_app)
cors = CORS(flask_app)
flask_app.config["DEBUG"] = True

# Name space for the /RUN methods
run_namespace = app.namespace('run', description='Execution Methods for the different planners available')
# Fix to serve swagger on HTTPS
app.wsgi_app = ProxyFix(flask_app.wsgi_app)

# Model with the inputs of the Execution methods
execution_input_model = run_namespace.model('RunPlannerInput', {
    'timeout': fields.String,
    'domain': fields.String,
    'problem': fields.String
})

@flask_app.errorhandler(500)
def internal_error(err):
    print(err)
    return "There was an error executing your request. Review the parameters added to the domain and problem. ({})".format(str(err)), 500

# Method to RUN in SGPlan
@run_namespace.route('/sgplan', methods=['POST'])
@run_namespace.doc(
    body=execution_input_model,
    responses={
        200: 'Success - Returns the text to be added to the console',
        500: 'The planner exited with a non zero code or API failure'
    })
class RunSGPlan(Resource):
    def post(self):
        try:
            json_data = request.get_json(force=True)
            timeout = json_data['timeout']
            domain = json_data['domain']
            problem = json_data['problem']
            return planner_exec.execute_planner('sgplan', timeout, domain, problem), 200
        except Exception as err:
            abort(500, err)

# Method to RUN in Optic
@run_namespace.route('/optic', methods=['POST'])
@run_namespace.doc(
    body=execution_input_model,
    responses={
        200: 'Success - Returns the text to be added to the console',
        500: 'The planner exited with a non zero code or API failure'
    })
class RunOptic(Resource):
    def post(self):
        try:
            json_data = request.get_json(force=True)
            timeout = json_data['timeout']
            domain = json_data['domain']
            problem = json_data['problem']
            return planner_exec.execute_planner('optic', timeout, domain, problem), 200
        except Exception as err:
            abort(500, err)

# Start the API in any IP listening port 5000
# TODO: Move this values to constants or config file
flask_app.run(host='0.0.0.0', port = int(os.environ.get('PORT', 5000)))