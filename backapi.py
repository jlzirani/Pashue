import requests, json

class restApi:
  def __init__(self, ip, user):
    self.ip = ip
    self.user = user

  def buildBaseUrl(self, path):
    url = "http://" + self.ip + "/api"
    if self.user and self.user != "":
      url += "/" + self.user
    if path and path != "":
      url += "/" + path
    return url

  def get(self, path):
    r = requests.get( self.buildBaseUrl(path) )
    return r.json()

  def put(self, path, data):
    r = requests.put( self.buildBaseUrl(path), json.dumps(data))
    return r.json()

  def post(self, path, data):
    r = requests.post( self.buildBaseUrl(path), json.dumps(data))
    return r.json()

  def delete(self, path):
    r = requests.delete( self.buildBaseUrl(path) )
    return r.json()
 
