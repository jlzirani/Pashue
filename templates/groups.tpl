{% set active_groups = "active" %}

{% extends "layout.tpl" %}

{% block title %}Groups{% endblock %}


{% block css %}
tr th:first-child {
  width: 90px;
}

tr th:last-child {
  width: 150px;
  text-align: center;
}

tr th:nth-child(2){
  width: 150px;
}
{% endblock %}

{% block body %}

<div class="table-responsive">
  <table class="table table-striped table-sm">
    <thead>
      <tr>
        <th># of lights</th>
        <th>Type</th>
        <th>Name</th>
        <th>Actions</th>
      </tr>
    </thead>
    <tbody>
    {% for id, group in result.items() %}
      <tr>
        <th>{{ group['lights']|length }}</th>
        <th> {%- if group['type'] == "Room" -%}
		{{ group.get("class", "Other type of room") }}
             {%- else -%}
                 {{ group['type'] }}
                {%- endif -%}
 </th>
        <th> {{ group['name'] }} </th>
        <th>
          <i class="fas fa-wrench"></i>
          <i class="fas fa-edit"></i>
          <i class="fas fa-trash"></i>
          <div class="btn-group btn-group-toggle" data-toggle="buttons">
            <label id="uSetOnBtn-{{ id }}" class="btn btn-secondary btn-sm active">
              <input type="radio" name="options" id="option1" autocomplete="off" checked> On 
            </label>
            <label id="uSetOffBtn-{{ id }}" class="btn btn-secondary btn-sm">
              <input type="radio" name="options" id="option3" autocomplete="off"> Off
            </label>
          </div>
        </th>
      </tr>
    {% endfor %}
    </tbody>
  </table>
</div>

<div>
  <ul style="list-style-type: none">
    <li><a href="{{ url_for("addGroup") }}"><i class="fas fa-plus"></i>Add a new group</a></li>
  </ul>
</div>


{% endblock %}
{% block js %}

<script>
$( document ).ready(function()
{
  {% for id in result %}
  $('#uSetOffBtn-{{ id }}').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/groups/{{ id }}/action",
        contentType: "application/json",
        data: JSON.stringify({"on": false})
      });
  });
  $('#uSetOnBtn-{{ id }}').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/groups/{{ id }}/action",
        contentType: "application/json",
        data: JSON.stringify({"on": true})
      });
  });
  {% endfor %}
});

</script>

{% endblock %}
