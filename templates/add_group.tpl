{% extends "layout.tpl" %}

{% block title %} Add group {% endblock %}

{% block body %}


<div class="container">
  <form action="/test" method="post">
    <div class="form-group">
      <label for="name">Name group</label>
      <input type="text" class="form-control" name="name" id="name" aria-describedby="emailHelp" placeholder="Enter a name group">
  </div>

  <div class="form-group">
    <label for="type">group type</label>
    <select class="form-control" id="type" name="type">
      <option>LightGroup</option>
      <option>Living room</option>
      <option>Kitchen</option>
      <option>Dining</option>
      <option>Bedroom</option>
      <option>Kids bedroom</option>
      <option>Bathroom</option>
      <option>Nursery</option>
      <option>Recreation</option>
      <option>Office</option>
      <option>Gym</option>
      <option>Hallway</option>
      <option>Toilet</option>
      <option>Front door</option>
      <option>Garage</option>
      <option>Terrace</option>
      <option>Garden</option>
      <option>Driveway</option>
      <option>Carport</option>
      <option>Other</option>
    </select>
  </div>

  <div class="form-group">
    <label for="luminaires">Lights</label>
    {% for id,light in lights.items() %}
    <div class="checkbox">
      <label><input type="checkbox" name="lights" value="{{ id }}"> {{ light['name'] }}</label>
    </div>
    {% endfor %}
  </div>
  <button type="submit" class="btn btn-default">Create</button>
  <!-- <button type="submit" class="btn btn-default" name="create" value="new">Create and add an other new group</button> -->

</form>
</div>

{% endblock %}


