{% set active_schedules = "active" %}

{% extends "layout.tpl" %}

{% block title %}Schedules{% endblock %}

{% block body %}

<div class="table-responsive">
  <table class="table table-striped table-sm">
    <thead>
      <tr>
        <th>Type</th>
        <th>Name</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      {% for id, schedule in result.items() %}
      <tr>
	<th>{{ schedule['type'] }} </th>
        <th>{{ schedule['name'] }} </th>
        <th>
          <i class="fas fa-wrench"></i>
          <i class="fas fa-edit"></i>
          <i class="fas fa-trash"></i>
        </th>
      </tr>
      {% endfor %}
    </tbody>
  </table>
</div>

{% endblock %}


