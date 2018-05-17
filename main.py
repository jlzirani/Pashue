#!/usr/bin/env python
import json, backapi
from flask import Flask, request, abort, render_template, redirect, url_for

app = Flask(__name__, static_url_path="/static")
config = {}
restApi = None

@app.route("/favicon.ico")
def favicon():
  return app.send_static_file('favicon.ico')

@app.route("/dashboard")
@app.route("/")
def dashboard():
  conf = restApi.get("config")
  lights = restApi.get("lights")
  #sensors = backapi.ApiObject(config, "sensors")
  #rules = backapi.ApiObject(config, "rules")

  return render_template('dashboard.tpl', conf=conf, 
                         lights=lights)

@app.route("/<any(groups, schedules, scenes, lights, sensors, rules):page>")
def generic(page):
  result = restApi.get(page) 
  return render_template( page+".tpl", result=result)

@app.route("/add/group", methods=['GET'])
def addGroup():
  lights = restApi.get("lights")
  return render_template( "add_group.tpl", lights=lights )

@app.route("/add/group", methods=['POST'])
def addGroupPost():
   data = request.form

   query = { "lights": data.getlist('lights'),
             "name": data['name'],
             "type": data['type']}

   if query['type'] in [ 'Living room', 'Kitchen', 'Dining', 'Bedroom', 'Kids bedroom', 
                         'Bathroom', 'Nursery', 'Recreation', 'Office', 'Gym', 'Hallway', 
                         'Toilet', 'Front door', 'Garage', 'Terrace', 'Garden', 
                         'Driveway', 'Carport', 'Other']:
     query['class'] = query['type']
     query['type'] = "Room"

   result = restApi.post("groups", query)

   if "success" in result[0]:
     if data['return'] == "groupPage":
       return redirect( url_for("group", id = result[0]["success"]["id"]) )
     if data['return'] == "newGroup":
       return redirect( url_for("addGroup") )

   return json.dumps(query)

@app.route("/light/<id>")
def light(id):
  light = restApi.get("lights/"+id)
  return render_template('light.tpl', light=light, id=id)

@app.route("/group/<id>")
def group(id):
  group = restApi.get("groups/"+id)
  return render_template('group.tpl', group=group, id=id)

@app.route("/rule/<id>")
def rule(id):
  rule = restApi.get("rules/"+id)
  return render_template('rule.tpl', id=id, rule=rule)

@app.route("/redirect/", methods=['GET'])
@app.route("/redirect/<path:url>", methods=['GET', 'DELETE'])
def proxy(url=""):
    if not config.get("redirect", False):
       abort(404)
    return json.dumps(restApi.get(url) if request.method == 'GET' else restApi.delete(url))
    
@app.route("/redirect/<path:url>", methods=['POST', 'PUT'])
def proxyPostPut(url=""):
    if not config.get("redirect", False):
       abort(404)
    body =  request.get_json(force=True) 
    return json.dumps( restApi.post(url,body) if request.method == 'POST' else restApi.put(url,body))

@app.route("/api/", methods=['GET'])
@app.route("/api/<user>", methods=['GET'])
@app.route("/api/<user>/", methods=['GET'])
@app.route("/api/<user>/<path:url>", methods=['GET', 'DELETE'])
def Apiproxy(user="", url=""):
    if not config.get("proxy", False):
       abort(404)
    proxyApi = backapi.restApi(config['hue-ip'], user)
    result = {}
    
    if request.method == 'GET' :
      result = proxyApi.get( url )
      if type(result) is dict:
        if url == "/" or url == "":
          result['config']['name'] = "Proxy " + result['config']['name']
          result['config']['ipaddress'] = config.get("ip", "192.168.0.235")
        if url == "config" or url == "config/":
          result['name'] = "Proxy " + result['name']
          result['ipaddress'] = config.get("ip", "192.168.0.235")
    else:
      result = proxyApi.delete( url )

    return json.dumps( result )
    
@app.route("/api", methods=['POST'])
@app.route("/api/", methods=['POST'])
@app.route("/api/<user>", methods=['POST', 'PUT'])
@app.route("/api/<user>/", methods=['POST', 'PUT'])
@app.route("/api/<user>/<path:url>", methods=['POST', 'PUT'])
def ApiProxyPostPut(user="", url=""):
    if not config.get("proxy", False):
       abort(404)
    proxyApi = backapi.restApi(config['hue-ip'], user)
    body =  request.get_json(force=True) 
    return json.dumps( proxyApi.post(url,body) if request.method == 'POST' else proxyApi.put(url, body) )

if __name__ == '__main__':
  config = json.load(open('config.json'))
  restApi = backapi.restApi(config['hue-ip'], config['user'])

  app.run(host=config.get("ip", "0.0.0.0"), port=config.get("port", 8080))


