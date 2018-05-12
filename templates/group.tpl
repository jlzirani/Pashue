{% extends "layout.tpl" %}

{% block stylesheetlink %}
{% if "xy" in group['action'] %}
<link href="/static/bs-colorpicker/css/bootstrap-colorpicker.css" rel="stylesheet">
{% endif %}
{% endblock %}

{% block title %} Group - {{ group['name'] }}{% endblock %}

{% block body %}


<div class="media">
  <span class="media-left">
    {% if group['state']['all_on'] -%}
    <i id="bulb-icon" class="far fa-lightbulb fa-8x" ></i>
    {%- else -%}
    <i id="bulb-icon" class="fas fa-lightbulb fa-8x" ></i>
    {%- endif %}
  </span>
  <div class="media-body">
    <ul style="list-style-type: none">
      <li>{{ group['name'] }}</li>
      <li>{{ group['type'] }}</li>
      <li>{{ group['modelid'] }}</li>
      <li>{{ group['swconfigid'] }}</li>
      <li>{{ group['manufacturername'] }} </li>
      <li>{% if group['state']['reachable'] -%}
         Reachable
	{%- else -%}
	 Unreachable
	{%- endif -%}
      </li>
  </div>
</div>

  <div class="btn-group btn-group-toggle" data-toggle="buttons">
    <label id="uSetOnBtn" class="btn btn-secondary btn-sm 
	{%- if group['state']['all_on'] %} active{% endif -%}">
      <input type="radio" name="option1" autocomplete="off"  
	{%- if group['state']['all_on'] %} checked {% endif -%}> On 
    </label>
    <label class="btn btn-secondary btn-sm btn-disabled 
	{%- if group['state']['any_on'] and not group['state']['all_on'] %} active{% endif -%}">
      <input type="radio" autocomplete="off"  
	{%- if group['state']['any_on'] and not group['state']['all_on'] %} checked {% endif -%}> Some
    </label>
    <label id="uSetOffBtn" class="btn btn-secondary btn-sm
	{%- if not group['state']['any_on'] %} active{% endif -%}">
      <input type="radio" name="option2" autocomplete="off"
	{%- if not group['state']['any_on'] %} checked {% endif -%}> Off
    </label>
  </div>

{% if 'bri' in group['action'] %}
<div class="slidecontainer">
  <input type="range" min="1" max="254" value="{{ group['action']['bri'] }}" class="slider" id="briSlider">
  bri: <span id="briVal">{{ group['action']['bri'] }}</span> 
</div>
{% endif %}

{% if 'sat' in group['action'] %}
<div class="slidecontainer">
  <input type="range" min="1" max="254" value="{{ group['action']['sat'] }}" class="slider" id="satSlider">
  sat: <span id="satVal">{{ group['action']['sat'] }}</span> 
</div>
{% endif %}


{% if "xy" in group['action'] %}
<div class="media">
  <div id="colorPicker" class="media-left inl-bl" style="display: inline-block"></div>
  <div class="media-body">
    <ul style="list-style-type: none">
      <li> x: <span id="xy-xval">{{ group['action']['xy'][0] }}</span> </li>
      <li> y: <span id="xy-yval">{{ group['action']['xy'][1] }}</span> </li>
    </ul>
  </div>
</div>
{% endif %}


{% endblock %}

{% block js %}

{% if "xy" in group['action'] %}
<script src="/static/bs-colorpicker/js/bootstrap-colorpicker.js"></script>
<script src="/static/js/colorConversion.js"></script>
{% endif %}

<script>
$( document ).ready(function()
{
  {% if 'bri' in group['action'] %}
  $('#briSlider').on('input', function(e) {
    $('#briVal').text( $(this).val() );
    $.ajax({
      type: "PUT",
      url: "/redirect/groups/{{ id }}/action",
      contentType: "application/json",
      data: JSON.stringify({"bri": parseInt($(this).val())})
    });
  });
  {% endif %}
  {% if 'sat' in group['action'] %}
  $('#satSlider').on('input', function(e) {
    $('#satVal').text( $(this).val() );
    $.ajax({
      type: "PUT",
      url: "/redirect/groups/{{ id }}/action",
      contentType: "application/json",
      data: JSON.stringify({"sat": parseInt($(this).val())})
    });
  });
  {% endif %}
  {% if 'xy' in group['action'] %}
  $(function() {
        var XY = {"x": {{ group['action']['xy'][0] }},
                  "y": {{ group['action']['xy'][1] }} };
        var color = getRGBFromXYB(XY, {{ group['action']['bri'] }});
        var colorText = "rgb("+color['r']+","+color['g']+","+color['b']+")";
        $('#colorPicker').colorpicker({
            color: colorText,
            container: true,
            inline: true,
            useAlpha: false
        });
    });

  $('#colorPicker').on('changeColor', function(e) {
    var XY = getXYFromRGB(e.color.toRGB());
    $.ajax({
        type: "PUT",
        url:"/redirect/groups/{{ id }}/action",
        contentType: "application/json",
        data: JSON.stringify( {"xy": [parseFloat(XY["x"]), 
                                      parseFloat(XY['y'])],
                               "bri": Math.round(XY['bri']*255),
                               "transistiontime": 20 
                               }),
        success: function(data) {
          $.ajax({
            type: "GET",
            url: "/redirect/groups/{{ id }}",
            success: function(stateLight) {
              var parsedState = JSON.parse(stateLight);
              {% if 'sat' in group['action'] -%}
              $('#satSlider').val(parsedState['action']['sat']);
              $('#satVal').text(parsedState['action']['sat']);
              {%- endif %}
              {% if 'bri' in group['action'] -%}
              $('#briSlider').val(parsedState['action']['bri']);
              $('#briVal').text(parsedState['action']['bri']);
              {%- endif %}
              $('#xy-xval').text(parsedState['action']['xy'][0]);
              $('#xy-yval').text(parsedState['action']['xy'][1]);
            }
          });
        }
    });     
  }); 
  {% endif %}
  
  $('#uSetOffBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/groups/{{ id }}/action",
        contentType: "application/json",
        data: JSON.stringify({"on": false}),
        success: function (data) {
           var parsed_data = JSON.parse(data);
           if( "success" in parsed_data[0] )
             $('#bulb-icon').removeClass().addClass("fas fa-lightbulb fa-8x");
           else
           {
             $('#uSetOffBtn').removeClass('active')
             $('#uSetOnBtn').addClass('active')
           }
        }
      });
  });
  $('#uSetOnBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/groups/{{ id }}/action",
        contentType: "application/json",
        data: JSON.stringify({"on": true}),
        success: function (data) {
           var parsed_data = JSON.parse(data);
           if( "success" in parsed_data[0] )
             $('#bulb-icon').removeClass().addClass("far fa-lightbulb fa-8x");
           else
           {
             $('#uSetOnBtn').removeClass('active')
             $('#uSetOffBtn').addClass('active')
           }
        }
      });
  });
});

</script>
{% endblock %}


