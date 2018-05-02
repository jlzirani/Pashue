# Pashue

## Installation, dependencies and launching the application

### Installations :

Pashue use flask and requests as a python dependencies. You can use virtualenv and pip to install them.

```
virtualenv --no-site-packages ve
source ve/bin/activate
pip install -r requirements.txt
```

After that, you can generate _config.json_ using setup.py (in the ve if necessary).

### Dependencies :

As said previously, there is two python dependencies: _flask_ and _requests_.
Although, the html/css fronted use _bootstrap_, _jquery_, _fontawesome_ and _bootstrap-colorpicker_.
Those dependencies are statically present under the static directory:
* static/bs: bootstrap
* static/js/jquery.js: jquery
* static/bs-colorpicjer: bootstrap-colorpicker
* static/fa: font awesome

### Launch application :

Launch the application by _main.py_ (in the ve if necessary) :

```
source ve/bin/activate
./main.py
```

### config.json:

The file _config.json_ is the configuration file and contains:
* hue-ip: the ip of the bridge
* user: the username
* redirect: allowing the /redirect/ and /api/ route. Currently, redirect is necessary for manipulating the lights by ajax.

## License:
This project is under the GPL license.

Bootstrap, bootstrap-colorpicker and jquery: MIT license.
Font awesome (free): Icons: CC BY 4.0, Fonts: SIL OFL 1.1, Code: MIT License.

