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
      <tr id="row-{{ id }}">
	<th>{{ light['type'] }} </th>
        <th class="nameLight">{{ light['name'] }} </th>
        <th>{{ light['state']['reachable'] }} </th>
        <th>
          <a href="{{ url_for('light', id= id) }}"><i class="fas fa-wrench"></i></a>
          <a href="#renameLight" data-toggle="modal" data-id="{{ id }}" data-name="{{ light['name'] }}"><i class="fas fa-edit"></i></a>
          <a href="#deleteLight" data-toggle="modal" data-id="{{ id }}" data-name="{{ light['name'] }}" ><i class="fas fa-trash"></i></a>
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

<div class="modal fade" id="deleteLight" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
        Delete the light "<span class="nameLight">not defined yet</span>" ?
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="deleteBtn" data-dismiss="modal">Delete</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="renameLight" role="dialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
        Rename the light "<span class="nameLight">not defined yet</span>" ?
        <input type="text" class="form-control" id="renameLightInput"></span>
      </div>

      <div class="modal-footer">
        <button type="button" class="btn btn-default" id="renameBtn" data-dismiss="modal">Rename</button>
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

  $('#deleteLight').on('show.bs.modal', function(e) {
    var rel = $(e.relatedTarget);
    var name = rel.data('name');
    var id = rel.data('id');
    $('#deleteLight .deleteBtn').data("id", id);
    $('#deleteLight .nameLight').text(name);
  });

  $('#renameLight').on('show.bs.modal', function(e) {
    var rel = $(e.relatedTarget);
    var name = rel.data('name');
    var id = rel.data('id');
    $('#renameLight #renameBtn').data("id", id);
    $('#renameLight #renameLightInput').attr("placeholder", name);
    $('#renameLight .nameLight').text(name);
  });

  $('#deleteBtn').on('click', function(e) {
    var groupId = $(this).data('id');
    $.ajax({
        type: "DELETE",
        url:"/redirect/lights/"+groupId, 
        success: function(reply) {
          var parsedReply = JSON.parse(reply);
          if( "success" in parsedReply[0] )
            $("#row-"+groupId).remove();
        }
      });
  });

  $('#renameBtn').on('click', function(e) {
     var newName = $('#renameLight #renameLightInput').val() ;
     if( newName.length != 0 )
     {
        var id = $(this).data('id');
        $.ajax({
          type: "PUT",
          url:"/redirect/lights/"+$(this).data('id'),
          contentType: "application/json",
          data: JSON.stringify({"name": newName}),
          success: function(reply) {
            var parsedReply = JSON.parse(reply);
            if( "success" in parsedReply[0] )
              $("#row-"+id+" .nameLight").text(newName);
            else
              console.log(parsedReply);
          }
        });
     }
  });



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



