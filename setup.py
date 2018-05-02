#!/usr/bin/env python
import json, backapi, socket

if __name__ == '__main__':
  config = {'hue-ip': "", "redirect": True}
  device = {"devicetype": "Pashue#"+ socket.gethostname()}
  print("Setup of Pashue")
  print("This setup will overide config.json")
  config['hue-ip'] = raw_input("Please enter the hue bridge : ") 

  raw_input("Please, tap on the sync boutton of the hue bridge.")

  answer = backapi.ApiObject( config, "" ).post(device) 
  if 'error' in answer[0]:
    "Error, please restart the setup"
  elif 'success' in answer[0]:
    config['user'] = answer[0]['success']['username']
    json.dump(config, open("config.json", 'w')) 
    
