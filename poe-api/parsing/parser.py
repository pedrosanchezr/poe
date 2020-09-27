from flask import request

from filesmgr import files_manager

# Class to simplify the parsing options
class Parser:
  def __init__(self):
    domainpath, problempath = files_manager.prepare_temp_files()
    
  

