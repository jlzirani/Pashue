{% set active_lights = "active" %}

{% extends "layout.tpl" %}

{% block title %}Lights{% endblock %}
{% block body %}

<div class="media" style="padding-top: 20px; padding-bottom: 20px">
  <span class="media-left">
    <i id="bulb-icon" class="fas fa-lightbulb fa-8x" ></i>
  </span>
  <div class="media-body">
    <ul style="list-style-type: none">
      <li> {{ result|length }} ligth(s) known by the bridge. </li>
      <li> {{ result.values()|selectattr("state.on")|list|length }} light(s) turned on.</li>
      <li> 
        {{ result.values()|selectattr("state.reachable")|list|length }} light(s) are reachable.
      </li>
      <li> 
        <div class="btn-group btn-group-toggle" data-toggle="buttons">
          <label data-action="on" class="btn btn-secondary btn-sm uSetAllBtn">
            <input type="radio" name="options" id="option1" autocomplete="off" > On 
          </label>
          <label data-action="off" class="btn btn-secondary btn-sm uSetAllBtn">
            <input type="radio" name="options" id="option3" autocomplete="off"> Off
          </label>
       </li>
    <ul>
  </div>
</div>


<div class="table-responsive">
  <table class="table table-striped table-sm">
    <thead>
      <tr>
        <th>Type</th>
        <th>Name</th>
        <th>Reachable</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
      {% for id, light in result.items() %}
      <tr>
	<th>{{ light['type'] }} </th>
        <th>{{ light['name'] }} </th>
        <th>{{ light['state']['reachable'] }} </th>
        <th>
          <a href="{{ url_for('light', id= id) }}"><i class="fas fa-wrench"></i></a>
          <i class="fas fa-edit"></i>
          <i class="fas fa-trash"></i>
          <div class="btn-group btn-group-toggle" data-toggle="buttons">
            <label data-id="{{id}}" data-action="on" class="btn btn-secondary btn-sm  
		{%- if light['state']['on'] %} active{% endif %} uSetBtn">
              <input type="radio" name="options" id="option1" autocomplete="off"  
		{%- if light['state']['on'] %} checked {% endif -%}> On 
            </label>
            <label data-id="{{id}}" data-action="off" class="btn btn-secondary btn-sm
		{%- if not light['state']['on'] %} active {% endif %} uSetBtn">
              <input type="radio" name="options" id="option3" autocomplete="off"
		{%- if not light['state']['on'] %} checked {% endif -%}> Off
            </label>
          </div>
        </th>
      </tr>
      {% endfor %}
    </tbody>
  </table>
</div>
{% endblock %}

{% block js %}
<script>
$( document ).ready(function()
{
  $('.uSetAllBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/groups/0/action",
        contentType: "application/json",
        data: JSON.stringify({"on": $(this).data('action') == "on"})
      });
  });


  $('.uSetBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/lights/"+$(this).data('id')+"/state",
        contentType: "application/json",
        data: JSON.stringify({"on": $(this).data('action') == "on"})
      });
  });

});

</script>

{% endblock %}



