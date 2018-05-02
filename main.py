#!/usr/bin/env python
import json, backapi
from flask import Flask, request, abort, render_template

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

@app.route("/light/<id>")
def light(id):
  light = restApi.get("lights/"+id)
  return render_template('light.tpl', light=light, id=id)

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
    obj = backapi.ProxyApiObject(config, user, url)
    return json.dumps( obj.get() if request.method == 'GET' else obj.delete() )
    
@app.route("/api", methods=['POST'])
@app.route("/api/", methods=['POST'])
@app.route("/api/<user>", methods=['POST', 'PUT'])
@app.route("/api/<user>/", methods=['POST', 'PUT'])
@app.route("/api/<user>/<path:url>", methods=['POST', 'PUT'])
def ApiProxyPostPut(user="", url=""):
    if not config.get("proxy", False):
       abort(404)
    body =  request.get_json(force=True) 
    obj = backapi.ProxyApiObject(config, user,  url)
    return json.dumps( obj.post(body) if request.method == 'POST' else obj.put(body) )

if __name__ == '__main__':
  config = json.load(open('config.json'))
  restApi = backapi.restApi(config['hue-ip'], config['user'])

  app.run(host=config.get("ip", "0.0.0.0"), port=config.get("port", 8080))


