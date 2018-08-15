<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="/static/bs/css/bootstrap.min.css">
    <link rel="stylesheet" href="/static/fa/css/fontawesome-all.css">

    {% block stylesheetlink %}
    {% endblock %}

    <style>

.sidebar {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  z-index: 100; /* Behind the navbar */
  padding: 48px 0 0; /* Height of navbar */
  box-shadow: inset -1px 0 0 rgba(0, 0, 0, .1);
}

.sidebar .nav-link .fas {
  margin-right: 4px;
  color: #999;
}

.sidebar .nav-link {
  font-weight: 500;
  color: #333;
}

.sidebar .nav-link.active {
  font-size: 115%;
  color: #007bff;
}

.sidebar .nav-link.active .fas{
  color: #007bff;
}

.sidebar .nav-link .text{
  left: 40px;
  position: fixed;
}

[role="main"] {
  padding-top: 48px; /* Space for fixed navbar */
}

body {
  font-size: .875rem;
}

table tbody tr th {
  font-weight: normal;
}

.textgreen {
  color: green;
}
.textorange{
  color: orange;
}
.textred {
  color: red;
  font-weight: bold;
}

.bold {
   font-weight: bold;
}

{% block css %}
{% endblock %}

</style>


    <title>Pashue - {% block title %}Template{% endblock %}</title>
  </head>
  <body>

    <nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
      <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="{{ url_for('dashboard') }}">Pashue</a>
      <ul class="navbar-nav px-3">
      </ul>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <nav class="col-md-2 d-none d-md-block bg-light sidebar">
          <div class="sidebar-sticky">
            <ul class="nav flex-column">
              <li class="nav-item">
                <a class="nav-link {{ active_dash }}" href="{{ url_for('dashboard') }}">
                  <i class="fas fa-home"></i>
                  <span class="text">dashboard</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link {{ active_lights }}" href="{{ url_for("generic", page='lights') }}">
		  <i class="fas fa-lightbulb"></i>
                  <span class="text">lights</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link {{ active_sensors }}" href="{{ url_for("generic", page='sensors') }}">
                  <i class="fas fa-question"></i>
                  <span class="text">sensors</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link {{ active_groups }}" href="{{ url_for('generic', page="groups") }}">
                  <i class="fas fa-object-group"></i>
                  <span class="text">groups</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link {{ active_rules }}" href="{{ url_for('generic', page="rules") }}">
                  <i class="fas fa-list-ol"></i>
                  <span class="text">rules</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link {{ active_schedules }}" href="{{ url_for('generic', page="schedules") }}">
                  <i class="fas fa-clock"></i>
                  <span class="text">schedules</span>
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link {{ active_scenes }}" href="{{ url_for('generic', page="scenes") }}">
                <i class="fas fa-bullhorn"></i>
                <span class="text">scenes</span>
                </a>
              </li>
             </ul>
          </div>
        </nav>
      </div>
    </div>

    <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
    {% block body %}
    {% endblock %}
    </main>

    <script src="/static/js/jquery.js"></script>
    <script src="/static/js/popper.min.js"></script>
    <script src="/static/bs/js/bootstrap.min.js"></script>

    {% block js %}
    {% endblock %}

  </body>
</html>
