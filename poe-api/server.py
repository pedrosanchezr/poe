import flask
import json
import os

from flask import request, jsonify, abort, Response
from flask_cors import CORS, cross_origin
from execution import planner_exec

app = flask.Flask(__name__)
cors = CORS(app)
app.config["DEBUG"] = True


@app.errorhandler(500)
def internal_error(err):
    print(err)
    return "There was an error executing your request. Review the parameters added to the domain and problem. ({})".format(str(err)), 500

@app.route('/run/sgplan', methods=['POST'])
def run_sgplan():
    try:
        return planner_exec.execute_planner('sgplan'), 200
    except Exception as err:
        abort(500, err)

@app.route('/run/optic', methods=['POST'])
def run_optic():
    try:
        return planner_exec.execute_planner('optic'), 200
    except Exception as err:
        abort(500, err)

app.run(host='0.0.0.0', port = int(os.environ.get('PORT', 5000)))