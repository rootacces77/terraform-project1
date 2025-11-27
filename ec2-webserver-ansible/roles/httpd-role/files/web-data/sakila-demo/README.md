# Sakila Demo

Flask web app demonstrating database programming using the MySQL sakila example database

## Requirements

1. Python 3, which I recommend getting through [Miniconda](http://conda.pydata.org/miniconda.html) -- remember to get the Python 3.5 version! Then at your command line do:

   ```sh
   $ conda install python pip flask pymysql
   ```

2. This app uses `flask_bootstrap` and `flask_wtf`, the latest versions of which are not available from conda, so you'll need to get them with `pip`:

   ```sh
   $ pip install flask-bootstrap
   $ pip install flask-wtf
   ```

3. And, of course, [MySQL](http://dev.mysql.com/downloads/mysql/).

## Running

1. Start your MySQL server (if necessary, mainly on OS X).
2. Clone this repository.
3. `cd` to the `sakila-demo` directory
4. Run `python sakila_demo.py`.

## Learning

Of course you need to know [Python](https://docs.python.org/3/tutorial/) and [MySQL](http://dev.mysql.com/doc/refman/5.7/en/). The new stuff for most students will be:

1. The [Python DB-API](https://www.python.org/dev/peps/pep-0249/) and [PyMySQL](http://pymysql.readthedocs.io/en/latest/)'s implementation of it.
2. The [Flask](http://flask.pocoo.org/) web application framework.
3. The [Bootstrap](http://getbootstrap.com/) web front end framework.
4. You'll need at least a firm grasp of HTML. Knowledge of CSS and JavaScript are also helpful but not essential. You can learn these at [Mozilla Developer Network](https://developer.mozilla.org/).