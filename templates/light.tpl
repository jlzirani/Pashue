{% extends "layout.tpl" %}

{% block stylesheetlink %}
{% if "xy" in light['state'] %}
<link href="/static/bs-colorpicker/css/bootstrap-colorpicker.css" rel="stylesheet">
{% endif %}
{% endblock %}


{% block title %}Light - {{ light['name'] }}{% endblock %}

{% block body %}

<div class="media">
  <span class="media-left">
    {% if light['state']['on'] -%}
    <i id="bulb-icon" class="far fa-lightbulb fa-8x" ></i>
    {%- else -%}
    <i id="bulb-icon" class="fas fa-lightbulb fa-8x" ></i>
    {%- endif %}
  </span>
  <div class="media-body">
    <ul style="list-style-type: none">
      <li>{{ light['name'] }}</li>
      <li>{{ light['type'] }}</li>
      <li>{{ light['modelid'] }}</li>
      <li>{{ light['swconfigid'] }}</li>
      <li>{{ light['manufacturername'] }} </li>
      <li>{% if light['state']['reachable'] -%}
         Reachable
	{%- else -%}
	 Unreachable
	{%- endif -%}
      </li>
  </div>
</div>

  <div class="btn-group btn-group-toggle" data-toggle="buttons">
    <label id="uSetOnBtn" class="btn btn-secondary btn-sm 
	{%- if light['state']['on'] %} active{% endif -%}">
      <input type="radio" name="option1" autocomplete="off"  
	{%- if light['state']['on'] %} checked {% endif -%}> On 
    </label>
    <label id="uSetOffBtn" class="btn btn-secondary btn-sm
	{%- if not light['state']['on'] %} active{% endif -%}">
      <input type="radio" name="option2" autocomplete="off"
	{%- if not light['state']['on'] %} checked {% endif -%}> Off
    </label>
  </div>

{% if 'bri' in light['state'] %}
<div class="slidecontainer">
  <input type="range" min="1" max="254" value="{{ light['state']['bri'] }}" class="slider" id="briSlider">
  bri: <span id="briVal">{{ light['state']['bri'] }}</span> 
</div>
{% endif %}

{% if 'sat' in light['state'] %}
<div class="slidecontainer">
  <input type="range" min="1" max="254" value="{{ light['state']['sat'] }}" class="slider" id="satSlider">
  sat: <span id="satVal">{{ light['state']['sat'] }}</span> 
</div>
{% endif %}


{% if "xy" in light['state'] %}
<div class="media">
  <div id="colorPicker" class="media-left inl-bl" style="display: inline-block"></div>
  <div class="media-body">
    <ul style="list-style-type: none">
      <li> x: <span id="xy-xval">{{ light['state']['xy'][0] }}</span> </li>
      <li> y: <span id="xy-yval">{{ light['state']['xy'][1] }}</span> </li>
    </ul>
  </div>
</div>
{% endif %}


{% endblock %}

{% block js %}

{% if "xy" in light['state'] %}
<script src="/static/bs-colorpicker/js/bootstrap-colorpicker.js"></script>
<script src="/static/js/colorConversion.js"></script>
{% endif %}

<script>
$( document ).ready(function()
{
  {% if 'bri' in light['state'] %}
  $('#briSlider').on('input', function(e) {
    $('#briVal').text( $(this).val() );
    $.ajax({
      type: "PUT",
      url: "/redirect/lights/{{ id }}/state",
      contentType: "application/json",
      data: JSON.stringify({"bri": parseInt($(this).val())})
    });
  });
  {% endif %}
  {% if 'sat' in light['state'] %}
  $('#satSlider').on('input', function(e) {
    $('#satVal').text( $(this).val() );
    $.ajax({
      type: "PUT",
      url: "/redirect/lights/{{ id }}/state",
      contentType: "application/json",
      data: JSON.stringify({"sat": parseInt($(this).val())})
    });
  });
  {% endif %}
  {% if 'xy' in light['state'] %}
  $(function() {
        var XY = {"x": {{ light['state']['xy'][0] }},
                  "y": {{ light['state']['xy'][1] }} };
        var color = getRGBFromXYB(XY, {{ light['state']['bri'] }});
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
        url:"/redirect/lights/{{ id }}/state",
        contentType: "application/json",
        data: JSON.stringify( {"xy": [parseFloat(XY["x"]), 
                                      parseFloat(XY['y'])],
                               "bri": Math.round(XY['bri']*255),
                               "transistiontime": 20 
                               }),
        success: function(data) {
          $.ajax({
            type: "GET",
            url: "/redirect/lights/{{ id }}",
            success: function(stateLight) {
              var parsedState = JSON.parse(stateLight);
              {% if 'sat' in light['state'] -%}
              $('#satSlider').val(parsedState['state']['sat']);
              $('#satVal').text(parsedState['state']['sat']);
              {%- endif %}
              {% if 'bri' in light['state'] -%}
              $('#briSlider').val(parsedState['state']['bri']);
              $('#briVal').text(parsedState['state']['bri']);
              {%- endif %}
              $('#xy-xval').text(parsedState['state']['xy'][0]);
              $('#xy-yval').text(parsedState['state']['xy'][1]);
            }
          });
        }
    });     
  }); 
  {% endif %}
  
  $('#uSetOffBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/lights/{{ id }}/state",
        contentType: "application/json",
        data: JSON.stringify({"on": false}),
        success: function (data) {
           var parsed_data = JSON.parse(data);
           if( "success" in parsed_data[0] )
             $('#bulb-icon').removeClass().addClass("fas fa-lightbulb fa-8x");
           else
           {
             $('$uSetOffBtn').removeClass('active')
             $('$uSetOnBtn').addClass('active')
           }
        }
      });
  });
  $('#uSetOnBtn').on('click', function(e) {
     $.ajax({
        type: "PUT",
        url:"/redirect/lights/{{ id }}/state",
        contentType: "application/json",
        data: JSON.stringify({"on": true}),
        success: function (data) {
           var parsed_data = JSON.parse(data);
           if( "success" in parsed_data[0] )
             $('#bulb-icon').removeClass().addClass("far fa-lightbulb fa-8x");
           else
           {
             $('$uSetOnBtn').removeClass('active')
             $('$uSetOffBtn').addClass('active')
           }
        }
      });
  });
});

</script>
{% endblock %}


