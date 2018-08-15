{% set active_rules = "active" %}

{% extends "layout.tpl" %}

{% block title %}Rules{% endblock %}
{% block body %}

<div class="table-responsive">
  <table class="table table-striped table-sm">
    <thead>
      <tr>
        <th>Name</th>
        <th># of conditions</th>
        <th># of actions</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      {% for id, rule in result.items() %}
      <tr>
        <th>{{ rule['name'] }} </th>
        <th>{{ rule['conditions']|length }} </th>
        <th>{{ rule['actions']|length }} </th>
        <th>
          <a href="/rule/{{ id }}"><i class="fas fa-wrench"></i></a>
          <i class="fas fa-edit"></i>
          <i class="fas fa-trash"></i>
          </div>
        </th>
      </tr>
      {% endfor %}
    </tbody>
  </table>
</div>

{% endblock %}



