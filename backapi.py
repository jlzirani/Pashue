import requests
import json

class ApiObject:
  def __init__(self, config, path):
    self.path = path
    self.config = config
    self.ip = config.get("hue-ip")
    self.user = config.get("user")
    self.result = {}

  def buildBaseUrl(self):
    url = "http://" + self.ip + "/api"

    if self.user and self.user != "":
      url += "/" + self.user
    if self.path and self.path != "":
      url += "/" + self.path

    return url

  def get(self):
    r = requests.get( self.buildBaseUrl() )
    return r.json()

  def put(self, data):
    r = requests.put( self.buildBaseUrl(), json.dumps(data))
    return r.json()

  def post(self, data):
    r = requests.post( self.buildBaseUrl(), json.dumps(data))
    return r.json()

  def delete(self):
    r = requests.delete( self.buildBaseUrl() )
    return r.json()

class ProxyApiObject(ApiObject):
  def __init__(self, config, user, path):
    ApiObject.__init__(self, config, path)
    self.user = user

  def get(self):
    result = ApiObject.get(self)
    if "error" not in result[0] and ( self.path == "/" or self.path == "" ):
      result['config']['name'] = "Proxy " + result['config']['name']
      result['config']['ipaddress'] = self.config.get("ip", "192.168.0.235")
    if "error" not in result[0] and (self.path == "config" or self.path == "config/"):
      result['name'] = "Proxy " + result['name']
      result['ipaddress'] = self.config.get("ip", "192.168.0.235")
    return result

