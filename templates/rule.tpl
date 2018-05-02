
{% extends "layout.tpl" %}

{% block title %} Rule {{ rule['name'] }} {% endblock %}

{% block body %}
<ul style="list-style-type: none">
  <li>name: {{ rule['name'] }}</li>
  <li>number of condtions: {{ rule['conditions']|length }}</li>
  <li>number of actions: {{ rule['actions']|length }}</li>
  <li>status: {{ rule['status'] }}</li>
</ul>


{% endblock %}



