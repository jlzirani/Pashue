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
      <tr id="row-{{ id }}">
        <th>{{ group['lights']|length }}</th>
        <th> {%- if group['type'] == "Room" -%}
		{{ group.get("class", "Other type of room") }}
             {%- else -%}
                 {{ group['type'] }}
                {%- endif -%}
 </th>
        <th> {{ group['name'] }} </th>
        <th>
          <a href={{ url_for('group', id=id) }}><i class="fas fa-wrench"></i></a>
          <i class="fas fa-edit"></i>
          <a href="#deleteGroup" data-toggle="modal" data-id="{{ id }}" data-name="{{ group['name'] }}" class="deleteGroupBtn"><i class="fas fa-trash"></i></a>
          <div class="btn-group btn-group-toggle" data-toggle="buttons">
            <label data-id="{{ id }}" data-action="on" class="btn btn-secondary btn-sm active uSetBtn">
              <input type="radio" name="options" id="option1" autocomplete="off" checked> On 
            </label>
            <label data-id="{{ id }}" data-action="off" class="btn btn-secondary btn-sm uSetBtn">
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

<div class="modal fade" id="deleteGroup" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
        Delete the group "<span id="nameGroup">not defined yet</span>" ?
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="deleteBtn" data-dismiss="modal">Delete</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>


{% endblock %}
{% block js %}

<script>
$( document ).ready(function()
{
  $("#deleteGroup").on('show.bs.modal', function(e) {
    var rel = $(e.relatedTarget)
    var groupName = rel.data('name');
    var groupId = rel.data('id');
    $('#deleteBtn').data("id", groupId);
    $('#nameGroup').text(groupName);
  });

  $('#deleteBtn').on('click', function(e) {
    var groupId = $(this).data('id');
    $.ajax({
        type: "DELETE",
        url:"/redirect/groups/"+groupId, 
        success: function(reply) {
          $("#row-"+groupId).remove();
        }

      });
  });

  $('.uSetBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/groups/"+$(this).data('id')+"/action",
        contentType: "application/json",
        data: JSON.stringify({"on": $(this).data('action') == "on"})
      });
  });

});

</script>

{% endblock %}
