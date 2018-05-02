{% set active_dash = "active" %} 

{% extends "layout.tpl" %}

{% block title %}Dashboard{% endblock %}

{% block css %}
.row .col {
   margin-left: 10px;
   margin-right: 10px;
}
{% endblock %}

{% block body %}

<div class="container">
  <div class="row summary">
    <div class="col border rounded">
      <h3 class="text-center"> Hue Bridge </h3>
      <table class="table table-sm">
        <tr><th> name </th><th> {{ conf['name'] }}</th></tr>
        <tr><th> ip address </th><th> {{ conf['ipaddress'] }}</th></tr>
        <tr><th> zigbee channel </th><th> {{ conf['zigbeechannel'] }}</th></tr>
        <tr><th> api version </th><th> {{ conf['apiversion'] }} </th></tr>
        <tr><th> portal service</th><th> {{ conf['portalservices'] }} </th></tr>
      </table>
    </div>
    <div class="col border rounded">
      <h3 class="text-center"> Lights summary </h3>
       <table class="table table-sm">
        <tr><th> Total </th><th> {{ lights|length }}</th></tr>
        <tr><th> Number on </th><th> 
          {{- lights.values()|selectattr("state.on")|list|length -}}
        </th></tr>
        <tr><th> Number reachable </th><th> 
          {{- lights.values()|selectattr("state.reachable")|list|length -}}
        </th></tr>
      </table>

    </div>
  </div>
   
</div>
{% endblock %}

