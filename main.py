#!/usr/bin/env python
import json, backapi
from flask import Flask, request, abort, render_template

app = Flask(__name__, static_url_path="/static")
config = {}

@app.route("/favicon.ico")
def favicon():
  return app.send_static_file('favicon.ico')

@app.route("/")
def dashboard():
  return app.send_static_file('index.html')

#  conf = backapi.ApiObject(config, "config").get()
#  lights = backapi.ApiObject(config, "lights").get()
#  sensors = backapi.ApiObject(config, "sensors")
#  rules = backapi.ApiObject(config, "rules")

#  return render_template('dashboard.tpl', conf=conf, 
#                         lights=lights)

@app.route("/groups")
def groups():
  groups = backapi.ApiObject(config, "groups")
  return render_template('groups.tpl', groups=groups.get())

@app.route("/schedules")
def schedules():
  schedules = backapi.ApiObject(config, "schedules")
  return render_template('schedules.tpl', schedules=schedules.get())

@app.route("/scenes")
def scenes():
  scenes = backapi.ApiObject(config, "scenes")
  return render_template('scenes.tpl', scenes=scenes.get())

@app.route("/lights")
def lights():
  lights = backapi.ApiObject(config, "lights")
  return render_template('lights.tpl', lights = lights.get())

@app.route("/light/<id>")
def light(id):
  light = backapi.ApiObject(config, "lights/"+id)
  return render_template('light.tpl', light=light.get(), id=id)

@app.route("/sensors")
def sensors():
  sensors = backapi.ApiObject(config, "sensors")
  return render_template('sensors.tpl', sensors = sensors.get())

@app.route("/rules")
def rules():
  rules = backapi.ApiObject(config, "rules")
  return render_template('rules.tpl', rules=rules.get())

@app.route("/rule/<id>")
def rule(id):
  rule = backapi.ApiObject(config, "rules/"+id)
  return render_template('rule.tpl', id=id, rule=rule.get())

@app.route("/redirect/", methods=['GET'])
@app.route("/redirect/<path:url>", methods=['GET', 'DELETE'])
def proxy(url=""):
    if not config.get("redirect", False):
       abort(404)
    obj = backapi.ApiObject(config, url)
    return json.dumps( obj.get() if request.method == 'GET' else obj.delete() )
    
@app.route("/redirect/<path:url>", methods=['POST', 'PUT'])
def proxyPostPut(url=""):
    if not config.get("redirect", False):
       abort(404)
    body =  request.get_json(force=True) 
    obj = backapi.ApiObject(config, url)
    return json.dumps( obj.post(body) if request.method == 'POST' else obj.put(body) )

@app.route("/api/", methods=['GET'])
@app.route("/api/<user>", methods=['GET'])
@app.route("/api/<user>/", methods=['GET'])
@app.route("/api/<user>/<path:url>", methods=['GET', 'DELETE'])
def Apiproxy(user="", url=""):
    if not config.get("redirect", False):
       abort(404)
    obj = backapi.ProxyApiObject(config, user, url)
    return json.dumps( obj.get() if request.method == 'GET' else obj.delete() )
    
@app.route("/api", methods=['POST'])
@app.route("/api/", methods=['POST'])
@app.route("/api/<user>", methods=['POST', 'PUT'])
@app.route("/api/<user>/", methods=['POST', 'PUT'])
@app.route("/api/<user>/<path:url>", methods=['POST', 'PUT'])
def ApiProxyPostPut(user="", url=""):
    if not config.get("redirect", False):
       abort(404)
    body =  request.get_json(force=True) 
    obj = backapi.ProxyApiObject(config, user,  url)
    return json.dumps( obj.post(body) if request.method == 'POST' else obj.put(body) )

if __name__ == '__main__':
  config = json.load(open('config.json'))
  app.run(host=config.get("ip", "0.0.0.0"), port=config.get("port", 8080))


