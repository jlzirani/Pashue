{% set active_sensors = "active" %}

{% extends "layout.tpl" %}

{% block css %}


{% endblock %}

{% block title %}Sensors{% endblock %}
{% block body %}

<div class="table-responsive">
  <table class="table table-striped table-sm">
    <thead>
      <tr>
        <th>Type</th>
	<th>Name</th>
        <th>Battery</th>
        <th>Actions</th>
      </tr>
    </thead>
      {% for id, sensor in sensors.items() %}
      <tr>
	<th>{{ sensor['type'] }} </th>
        <th>{{ sensor['name'] }} </th>
        <th><span {% if sensor['config']['battery'] -%}
               class=
            {%- if sensor['config']['battery'] >= 50 -%}
               "textgreen"
            {%- elif sensor['config']['battery'] > 25 -%}
               "textorange"
            {%- else -%}
               "textred"
            {%- endif -%}{% endif %}>{{ sensor['config'].get('battery', "None") }}</span> 
        </th>
        <th>
          {% if id == "1" %}
          <i class="fas fa-wrench" style="color: lightgrey"></i>
          <i class="fas fa-edit" style="color: lightgrey"></i>
          <i class="fas fa-trash" style="color: lightgrey"></i>
          {%- else -%}
          <i class="fas fa-wrench"></i>
          <i class="fas fa-edit"></i>
          <i class="fas fa-trash"></i>
          {% endif %}
        </th>
      </tr>
      {% endfor %}

    <tbody>
    </tbody>
  </table>
</div>

{% endblock %}

